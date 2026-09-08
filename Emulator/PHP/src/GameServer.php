<?php
declare(strict_types=1);
namespace AeraEmu;

use Throwable;

final class GameServer
{
    private $server;
    /** @var array<int,ClientSession> */ private array $clients=[];
    /** @var array<int,RoomState> */ private array $rooms=[];
    private int $nextUserId=1;
    private int $nextRoomId=100;
    private bool $running=true;
    private float $lastCommandPoll=0.0;
    private ?float $shutdownAt=null;
    private ?float $restartAt=null;
    private ExtensionRouter $router;
    private ?ConsoleBridge $console = null;
    private float $startedAt = 0.0;
    private float $lastServerMessageAt=0.0;
    private float $lastWarzoneTick=0.0;
    private int $lastShutdownWarning=-1;
    private RequestTrace $requestTrace;
    private WorldMath $math;
    private StatsCalculator $statsCalculator;
    private CombatMath $combat;

    public function __construct(private Config $config, private Database $db, private Logger $log, private WorldRepository $world)
    {
        $this->world->setServerName((string)$config->get('server_name','Aera'));
        $this->world->reload();
        $this->math=new WorldMath($world);
        $this->statsCalculator=new StatsCalculator($db,$world);
        $this->combat=new CombatMath($db,$world);
        $this->requestTrace=new RequestTrace($db,$world);
        $this->router=new ExtensionRouter($this,$db,$log,$world,$config);
    }

    public function run(): void
    {
        $host=(string)$this->config->get('host','0.0.0.0');$port=(int)$this->config->get('port',5589);
        $errno=0;$errstr='';
        $this->server=@stream_socket_server("tcp://{$host}:{$port}",$errno,$errstr,STREAM_SERVER_BIND|STREAM_SERVER_LISTEN);
        if(!is_resource($this->server)) throw new \RuntimeException("Could not bind {$host}:{$port}: {$errstr} ({$errno})");
        stream_set_blocking($this->server,false);

        // Local admin-console bridge. The public browser never sees this port;
        // IIS proxies it to authenticated administrators using Server-Sent Events.
        try {
            $this->console = new ConsoleBridge();
            $consoleHost=(string)$this->config->get('console_host','127.0.0.1');
            $consolePort=(int)$this->config->get('console_port',5591);
            $this->console->start($consoleHost,$consolePort);
            $this->log->setSink(fn(string $line) => $this->console?->broadcastLine($line));
        } catch (Throwable $e) {
            $this->console = null;
            $this->log->warn('Live console disabled: '.$e->getMessage());
        }

        $this->startedAt=microtime(true);
        // Java schedules these tasks with an initial delay equal to their interval.
        $this->lastCommandPoll=$this->startedAt;
        $this->lastServerMessageAt=$this->startedAt;
        $this->lastWarzoneTick=$this->startedAt;
        $this->writePid();
        $this->repairStalePresence();
        $this->markServer(true);
        $this->log->info("Aera PHP Emulator listening on {$host}:{$port}");
        if($this->console!==null)$this->log->info('Live admin console listening on 127.0.0.1:'.(int)$this->config->get('console_port',5591));
        $this->log->info('Protocol: SmartFoxServer 1.x compatible socket + Aera xt requests');
        $this->console?->broadcastState('running',['pid'=>getmypid()]);
        while($this->running){
            $read=[$this->server]; foreach($this->clients as $c)$read[]=$c->socket;
            $this->console?->appendReadSockets($read);
            $write=$except=[];
            @stream_select($read,$write,$except,0,(int)$this->config->get('tick_ms',50)*1000);
            foreach($read as $sock){
                if($this->console!==null && $this->console->handles($sock)){
                    $this->console->handleReadable(
                        $sock,
                        fn(string $command):array=>$this->handleConsoleCommand($command),
                        fn(string $action,array $params):array=>$this->handleConsoleRpc($action,$params)
                    );
                    continue;
                }
                if($sock===$this->server){$this->accept();continue;}
                $id=(int)$sock;$client=$this->clients[$id]??null;if(!$client)continue;
                $data=@fread($sock,65536);
                if($data===''||$data===false){if(feof($sock))$this->disconnect($client,'socket closed');continue;}
                $client->buffer.=$data;
                while(($pos=strpos($client->buffer,"\0"))!==false){$msg=substr($client->buffer,0,$pos);$client->buffer=substr($client->buffer,$pos+1);if($msg!=='')$this->handle($client,$msg);}
            }
            $this->tick();
            $this->console?->tick();
        }
        $this->shutdownNow();
    }

    private function accept(): void
    {
        $peer='';$sock=@stream_socket_accept($this->server,0,$peer);if(!is_resource($sock))return;
        stream_set_blocking($sock,false);$ip=preg_replace('/:\d+$/','',$peer)?:$peer;$id=(int)$sock;
        $count=0;foreach($this->clients as $c)if($c->ip===$ip)$count++;
        if($count>=(int)$this->config->get('max_connections_per_ip',5)){@fclose($sock);$this->log->warn("Rejected connection limit from {$ip}");return;}
        $this->clients[$id]=new ClientSession($sock,$id,$ip);$this->log->info("Socket connected {$peer}");
    }

    private function handle(ClientSession $c,string $message): void
    {
        $p=Protocol::parse($message);
        if($p['type']==='policy'){$this->write($c,Protocol::policy((int)$this->config->get('port',5589)));return;}
        if($p['type']==='sys'){$this->handleSystem($c,$p);return;}
        if($p['type']==='ext'){
            if(!$c->authenticated){
                $this->log->warn('Ignored XT request before login: '.(string)($p['cmd']??''));
                return;
            }
            $cmd=(string)($p['cmd']??'');$params=$p['params']??[];$fromRoom=(int)($p['room']??-1);
            if($c->access<1){$this->log->warn('Blocked request from disabled account '.$c->username.': '.$cmd);return;}
            // Java Suck_MElator validates non-system room ids before dispatch.
            if($fromRoom>0&&!in_array($fromRoom,[1,32123],true)&&$this->roomById($fromRoom)===null){$this->log->warn('Invalid request room '.$fromRoom.' from '.$c->username.'; disconnecting.');$this->disconnect($c,'invalid request room');return;}
            if($this->isRequestFlood($c,$cmd))return;
            if((bool)$this->config->get('trace_requests',true))$this->log->info($this->requestTrace->format($c,$cmd,$params,$fromRoom));
            try{$this->router->handle($c,$cmd,$params,$fromRoom);}
            catch(Throwable $e){$this->log->error("Request {$cmd} from {$c->username}: {$e->getMessage()} @ {$e->getFile()}:{$e->getLine()}");$this->sendRaw($c,['warning','An unknown error occurred.']);}
        }
    }

    private function handleSystem(ClientSession $c,array $p): void
    {
        $action=(string)($p['action']??'');$xml=(string)($p['xml']??'');
        switch($action){
            case 'verChk': $c->apiOk=true;$this->write($c,Protocol::sys('apiOK',0)); break;
            case 'login': $this->login($c,$xml); break;
            case 'getRmList': $this->roomList($c); break;
            case 'joinRoom': $rid=(int)(Protocol::attr($xml,'room','id')??1);$this->joinSystemRoom($c,$rid); break;
            case 'roundTrip': $this->write($c,Protocol::sys('roundTripRes',$c->roomId)); break;
            case 'logout': $this->gracefulLogout($c,'logout'); break;
            case 'pubMsg': $txt=Protocol::tag($xml,'txt')??'';$this->broadcastSystemPublic($c,$txt);break;
            default: break;
        }
    }

    private function login(ClientSession $c,string $xml): void
    {
        if(!$c->apiOk){
            $this->log->warn('Login packet received before SmartFox API version check.');
            return;
        }

        $zone=(string)(Protocol::attr($xml,'login','z')??'');
        $nick=Protocol::tag($xml,'nick')??'';
        $token=Protocol::tag($xml,'pword')??'';
        $parts=explode('~',$nick);
        $username=trim((string)($parts[1]??$parts[0]??''));
        $clientVersion=trim((string)($parts[2]??''));

        $this->log->info('SmartFox login request user='.(($username!=='')?$username:'<empty>').' zone='.(($zone!=='')?$zone:'<empty>').($clientVersion!==''?' client='.$clientVersion:''));

        if($username===''){
            $this->loginFailure($c,'','Invalid username.');
            return;
        }
        if($zone!=='' && strcasecmp($zone,(string)$this->config->get('zone','zone_master'))!==0){
            $this->loginFailure($c,$username,'Invalid game zone.');
            return;
        }
        if($token===''){
            $this->loginFailure($c,$username,'Invalid or expired game session.');
            return;
        }

        foreach($this->clients as $other){
            if($other!==$c && $other->authenticated && strcasecmp($other->username,$username)===0){
                // Java Users.multiLogin(): warn the new connection, kick the
                // existing session, then close the new socket as well.  Leaving
                // the new unauthenticated socket open caused stale login state.
                $this->sendRaw($c,['multiLoginWarning']);
                $this->disconnect($other,'duplicate login');
                $this->log->warn('Duplicate login rejected for '.$username);
                $this->disconnect($c,'duplicate login');
                return;
            }
        }

        // The website stores SHA-256 token hashes. Compute the hash in PHP so
        // authentication does not depend on SQL SHA2() behavior/configuration.
        $tokenHash=hash('sha256',$token);
        try{
            $row=$this->db->one(
                'SELECT u.*,ug.GuildID,ug.Rank FROM users u '
                .'LEFT JOIN users_guilds ug ON ug.UserID=u.id '
                .'INNER JOIN game_sessions s ON s.UserID=u.id '
                .'WHERE LOWER(u.Name)=LOWER(?) AND s.TokenHash=? AND s.ExpiresAt>NOW() '
                .'ORDER BY s.id DESC LIMIT 1',
                [$username,$tokenHash]
            );
        }catch(Throwable $e){
            $this->log->error('Login database error for '.$username.': '.$e->getMessage());
            $this->loginFailure($c,$username,'Could not retrieve your game session.');
            return;
        }

        if(!$row){
            $this->log->warn('Login rejected for '.$username.' (session missing/expired/hash mismatch).');
            $this->loginFailure($c,$username,'Invalid or expired game session. Please log in again.');
            return;
        }
        if((int)$row['Access']<1){
            $reason='';try{$reason=trim((string)$this->db->scalar("SELECT Details FROM users_logs WHERE UserID=? AND Violation='Panel Ban' ORDER BY id DESC LIMIT 1",[(int)$row['id']],'') );}catch(Throwable){}
            $this->loginFailure($c,$username,'This account is banned.'.($reason!==''?' Reason: '.$reason:''));return;
        }
        if((bool)$this->config->get('staff_only',false)&&(int)$row['Access']<40){$this->loginFailure($c,$username,'Server is currently restricted to staff.');return;}

        // Java Users.isIpConnectionMaxExceeded() counts every channel from the
        // IP, including the channel currently logging in, then rejects when the
        // count is >= connection.max_connection.  The runtime aqworld.conf uses
        // 5, so reproduce that behavior instead of only enforcing at accept().
        $ipConnections=0;
        foreach($this->clients as $client)if($client->ip===$c->ip)$ipConnections++;
        if($ipConnections>=(int)$this->config->get('max_connections_per_ip',5)){
            $this->loginFailure($c,$username,'Connection failed: Maximum number of connections from your IP address has been exceeded. Please try again later');
            $this->log->warn('Login rejected for '.$username.' due to per-IP connection limit from '.$c->ip);
            return;
        }

        $c->authenticated=true;
        $c->sfsUserId=$this->nextUserId++;
        $c->dbId=(int)$row['id'];
        $c->username=(string)$row['Name'];
        $c->access=(int)$row['Access'];
        $c->level=max(1,(int)$row['Level']);
        $c->user=$row;
        $calc=$this->statsCalculator->calculate($c);$c->stats=$calc['sta'];$c->wDPS=$calc['wDPS'];$c->mDPS=$calc['mDPS'];$c->minDmg=$calc['minDmg'];$c->maxDmg=$calc['maxDmg'];$c->classCategory=$calc['classCat'];
        $c->hpMax=$calc['hpMax'];$c->hp=$c->hpMax;$c->mpMax=$calc['mpMax'];$c->mp=$c->mpMax;$c->stamina=$c->staminaMax=100;

        $mod=$c->access>=40?1:0;
        $this->write($c,Protocol::sys('logOK',0,"<login id='{$c->sfsUserId}' mod='{$mod}' n='".Protocol::x($c->username)."' />"));

        $motd=(string)($this->world->server['MOTD']??'Welcome to Aera.');
        $news=$this->world->newsString;

        // IMPORTANT: Protocol::raw() inserts SmartFox room -1 after the command.
        // The stock client expects loginResponse[2] to be the success value.
        $this->sendRaw($c,[
            'loginResponse','true',(string)$c->sfsUserId,$c->username,$motd,
            date("Y-m-d\TH:i:s"),$news
        ]);

        try{
            $this->db->run('UPDATE game_sessions SET LastUsedAt=NOW() WHERE UserID=? AND TokenHash=?',[$c->dbId,$tokenHash]);
            $this->db->run('UPDATE users SET CurrentServer=?,GameAddress=?,LastLogin=NOW() WHERE id=?',[(string)$this->config->get('server_name',$this->world->server['Name']??'Aera'),$c->ip,$c->dbId]);
        }catch(Throwable $e){
            $this->log->warn('Post-login database update failed for '.$c->username.': '.$e->getMessage());
        }

        $this->updateCount();
        $this->log->info('Login OK '.$c->username.' access='.$c->access.' sfsId='.$c->sfsUserId.'; loginResponse sent.');
    }

    private function loginFailure(ClientSession $c,string $username,string $message): void
    {
        // Java emulator behavior: extension-level loginResponse is what Game.as
        // uses to show login errors. logKO alone is not enough because the...
        // existing implementation continues here.
        $this->sendRaw($c,['loginResponse','false','0',$username,$message]);
        $this->log->warn('Login failed for '.($username!==''?$username:'<empty>').': '.$message);
        $this->disconnect($c,'login failed');
    }

    /** @return array<string,mixed> */
    private function handleConsoleCommand(string $command): array
    {
        $command=trim($command);
        [$name,$args]=array_pad(preg_split('/\s+/', $command, 2) ?: [],2,'');
        $name=strtolower((string)$name);
        $args=trim((string)$args);

        if($name==='help'){
            return ['ok'=>true,'message'=>'Commands: status, players, rooms, say <message>, reload, clear all, safe-shutdown [seconds], cancel-shutdown, restart, stop'];
        }
        if($name==='status'){
            $players=0;foreach($this->clients as $c)if($c->authenticated)$players++;
            return ['ok'=>true,'message'=>sprintf('running pid=%d players=%d rooms=%d uptime=%ds',getmypid(),$players,count($this->rooms),(int)(microtime(true)-$this->startedAt))];
        }
        if($name==='players'){
            $names=[];foreach($this->clients as $c)if($c->authenticated)$names[]=$c->username;
            return ['ok'=>true,'message'=>$names?('Online ('.count($names).'): '.implode(', ',$names)):'No players online.'];
        }
        if($name==='rooms'){
            $parts=[];foreach($this->rooms as $room)$parts[]=$room->name.'('.count($room->clients).')';
            return ['ok'=>true,'message'=>$parts?('Rooms: '.implode(', ',$parts)):'No active game rooms.'];
        }
        if($name==='say'){
            if($args==='')return ['ok'=>false,'message'=>'Usage: say <message>'];
            $this->broadcastRaw(['server',$args]);
            $this->log->info('Panel broadcast: '.$args);
            return ['ok'=>true,'message'=>'Broadcast sent.'];
        }
        if($name==='reload'){
            $this->world->reload();
            $this->log->info('Panel console reloaded database cache.');
            return ['ok'=>true,'message'=>'Database cache reloaded.'];
        }
        if($name==='clear'){
            if(strtolower($args)!=='all')return ['ok'=>false,'message'=>'Usage: clear all'];
            $cleared=0;
            foreach(array_values($this->clients) as $player){
                if(!$player->authenticated)continue;
                $name=$player->username;
                $this->sendRaw($player,['warning','The server is clearing all active sessions. Please reconnect.']);
                $this->disconnect($player,'console clear all');
                $cleared++;
                $this->log->warn('Console clear all disconnected '.$name.'.');
            }
            $this->updateCount();
            return ['ok'=>true,'message'=>'Cleared all active player sessions. Disconnected '.$cleared.' player(s).'];
        }
        if($name==='safe-shutdown'){
            $seconds=$args!==''?max(10,min(3600,(int)$args)):(int)$this->config->get('safe_shutdown_seconds',300);
            if(!$this->scheduleShutdown($seconds,'panel console'))return ['ok'=>false,'message'=>'A shutdown or restart countdown is already active.'];
            return ['ok'=>true,'message'=>'Safe shutdown countdown started for '.$seconds.' seconds.'];
        }
        if($name==='cancel-shutdown'){
            if(!$this->cancelShutdown())return ['ok'=>false,'message'=>'There is no shutdown countdown to cancel.'];
            $this->log->info('Safe shutdown countdown cancelled from panel console.');
            return ['ok'=>true,'message'=>'Safe shutdown cancelled.'];
        }
        if($name==='restart'){
            $this->requestRestart();
            return ['ok'=>true,'message'=>'Restart requested. Watchdog will relaunch the emulator.'];
        }
        if($name==='stop'){
            $this->intentionalStop('live panel console');
            $this->log->warn('Stop requested from live panel console.');
            $this->running=false;
            return ['ok'=>true,'message'=>'Stop requested.'];
        }
        return ['ok'=>false,'message'=>'Unknown command. Type help for available commands.'];
    }

    // ... remaining GameServer implementation unchanged ...
}
