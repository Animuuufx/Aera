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
    public ?ExpeditionManager $expeditions=null;
    public ?RiftManager $rifts=null;

    public function __construct(private Config $config, private Database $db, private Logger $log, private WorldRepository $world)
    {
        $this->world->setServerName((string)$config->get('server_name','Aera'));
        $this->world->reload();
        $this->math=new WorldMath($world);
        $this->statsCalculator=new StatsCalculator($db,$world);
        $this->combat=new CombatMath($db,$world);
        $this->requestTrace=new RequestTrace($db,$world);
        $this->router=new ExtensionRouter($this,$db,$log,$world,$config);
        $this->rifts=new RiftManager($this,$db,$world,$config,$log);
        $this->expeditions=new ExpeditionManager($this,$db,$world,$config,$log);
    }

    public function run(): void
    {
        $host=(string)$this->config->get('host','0.0.0.0');$port=(int)$this->config->get('port',5589);
        $errno=0;$errstr='';
        $this->server=@stream_socket_server("tcp://{$host}:{$port}",$errno,$errstr,STREAM_SERVER_BIND|STREAM_SERVER_LISTEN);
        if(!is_resource($this->server)) throw new \RuntimeException("Could not bind {$host}:{$port}: {$errstr} ({$errno})");
        stream_set_blocking($this->server,false);
        // Recover Rift state only after owning the game port; a duplicate launch
        // that fails to bind must not interrupt the running server's encounter.
        $this->rifts?->recoverStartup();
        $this->expeditions?->recoverStartup();

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
            if($this->isRequestFlood($c,$cmd,$params))return;
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
        // uses to show login errors. logKO alone is not enough because the game's
        // onLogin callback is intentionally empty.
        $this->sendRaw($c,['loginResponse','false','-1',$username,$message]);
        $this->write($c,Protocol::sys('logKO',0,"<login e='".Protocol::x($message)."' />"));
    }

    private function roomList(ClientSession $c): void
    {
        $xml="<rmList><rm id='1' maxu='1000' maxs='0' temp='0' game='0' priv='0' lmb='1' ucnt='".count($this->clients)."' scnt='0'><n>Limbo</n></rm></rmList>";
        $this->write($c,Protocol::sys('rmList',-1,$xml));
    }

    private function joinSystemRoom(ClientSession $c,int $roomId): void
    {
        if($roomId!==1)$roomId=1;$c->roomId=$roomId;
        $body="<pid id='1'/><uLs><u i='{$c->sfsUserId}' m='".($c->access>=40?1:0)."' s='0' p='1'><n>".Protocol::x($c->username)."</n></u></uLs>";
        $this->write($c,Protocol::sys('joinOK',$roomId,$body));
    }

    private function broadcastSystemPublic(ClientSession $from,string $message): void
    {
        $body="<user id='{$from->sfsUserId}'/><txt><![CDATA[{$message}]]></txt>";
        foreach($this->clients as $c)if($c->authenticated&&$c->roomId===$from->roomId)$this->write($c,Protocol::sys('pubMsg',$from->roomId,$body));
    }

    public function joinGameRoom(ClientSession $c,string $requested,string $frame='Enter',string $pad='Spawn'): bool
    {
        $base=strtolower(explode('-',$requested)[0]);$map=$this->world->map($base);if(!$map){$this->sendRaw($c,['warning','"'.$base.'" is not a recognized map name.']);return false;}
        if((int)$map['ReqLevel']>$c->level){$this->sendRaw($c,['warning','"'.$base.'" requires level '.$map['ReqLevel'].' and above to enter.']);return false;}
        if((int)($map['PvP']??0)===1){$this->sendRaw($c,['warning','"'.$base.'" is a locked zone. Join it through the PvP queue.']);return false;}
        if((int)$map['Staff']===1&&$c->access<40){$this->sendRaw($c,['warning','"'.$base.'" is not a recognized map name.']);return false;}
        if((int)$map['Upgrade']===1&&(int)($c->user['UpgradeDays']??0)<=0){$this->sendRaw($c,['warning','"'.$base.'" is vip only.']);return false;}
        $room=$this->findOrCreateRoom($base,$requested,$map);
        return $this->joinRoomState($c,$room,$frame,$pad,$base);
    }

    /** @param array<string,mixed> $owner @param array<string,mixed> $houseItem @param array<int,array<string,mixed>> $items @param array<string,mixed> $layout */
    public function joinHouse(ClientSession $c,array $owner,array $houseItem,array $items,array $layout): bool
    {
        $ownerId=(int)$owner['id'];$name='house-'.$ownerId;$room=null;
        foreach($this->rooms as $candidate)if(strcasecmp($candidate->name,$name)===0){$room=$candidate;break;}
        $map=['id'=>0,'Name'=>$name,'File'=>(string)$houseItem['File'],'MaxPlayers'=>100000,'ReqLevel'=>0,'ReqParty'=>0,'Upgrade'=>0,'Staff'=>0,'PvP'=>0];
        $meta=['house'=>['strMapFileName'=>(string)$houseItem['File'],'strMapName'=>'house','sHouseInfo'=>(string)($owner['HouseInfo']??''),'items'=>$items,'roomName'=>$name,'unm'=>(string)$owner['Name'],'CharID'=>$ownerId,'sData'=>$layout]];
        if(!$room){$room=new RoomState($this->nextRoomId++,$name,$map,[],$meta);$this->rooms[$room->id]=$room;}else{$room->map=$map;$room->meta=$meta;}
        return $this->joinRoomState($c,$room,'Enter','Spawn','house');
    }

    public function updateHouseInfo(int $ownerId,string $houseInfo): void
    { foreach($this->rooms as $room)if((int)($room->meta['house']['CharID']??0)===$ownerId)$room->meta['house']['sHouseInfo']=$houseInfo; }

    public function createExpeditionRoom(array $map,array $monsters,int $runId,array $members): RoomState
    {
        $map['MaxPlayers']=4;
        $id=$this->nextRoomId++;
        $room=new RoomState($id,$map['Name'].'-exp'.$runId.'r'.$id,$map,$monsters,['expedition'=>$runId,'expeditionMembers'=>array_fill_keys($members,true)]);
        $this->rooms[$id]=$room;return $room;
    }
    public function joinExpeditionRoom(ClientSession $c,RoomState $room,string $frame): bool
    {
        if(!isset($room->meta['expeditionMembers'][$c->dbId]))return false;
        return $this->joinRoomState($c,$room,$frame,'Spawn',(string)$room->map['Name']);
    }
    public function resetExpeditionCombat(ClientSession $c): void
    {
        $c->auras=[];$c->dots=[];$c->cooldowns=[];$c->state=1;$c->respawnAt=0;$c->targetMonster=null;$c->resting=false;
        $this->recalculateStats($c,false);$c->hp=$c->hpMax;$c->mp=$c->mpMax;
        $this->sendJson($c,['cmd'=>'clearAuras']);
    }

    public function createPreparedPvpRoom(string $base): ?RoomState
    {
        $map=$this->world->map($base);if(!$map||(int)($map['PvP']??0)!==1)return null;
        do{$name=$base.'-'.random_int(0,9998);$exists=false;foreach($this->rooms as $candidate)if(strcasecmp($candidate->name,$name)===0){$exists=true;break;}}while($exists);
        $meta=['pvp'=>['scores'=>[0,0],'done'=>false,'factions'=>[['id'=>8,'sName'=>'Team B'],['id'=>7,'sName'=>'Team A']]]];
        $room=new RoomState($this->nextRoomId++,$name,$map,$this->world->mapMonsters((int)$map['id']),$meta);$this->rooms[$room->id]=$room;return $room;
    }

    public function joinPreparedRoom(ClientSession $c,int $roomId,string $frame='Enter',string $pad='Spawn'): bool
    {
        $room=$this->rooms[$roomId]??null;
        if(!$room||$c->pvpRoomId!==$roomId||(int)($room->map['PvP']??0)!==1||($room->meta['pvp']['done']??false)){
            $c->pvpRoomId=null;$c->pvpRoomName=null;$c->pvpJoinAt=0.0;
            return false;
        }
        $c->pvpJoinAt=0.0;return $this->joinRoomState($c,$room,$frame,$pad,strtolower(explode('-',$room->name)[0]));
    }

    public function releasePreparedRoomIfUnused(int $roomId): void
    {
        $room=$this->rooms[$roomId]??null;if(!$room||$room->clients)return;
        foreach($this->clients as $client)if($client->pvpRoomId===$roomId)return;
        unset($this->rooms[$roomId]);
    }

    private function joinRoomState(ClientSession $c,RoomState $room,string $frame,string $pad,string $base): bool
    {
        if(isset($room->meta['expedition'])&&(!isset($room->meta['expeditionMembers'][$c->dbId])||$this->expeditions?->runFor($c)?->roomId!==$room->id)){
            $this->sendRaw($c,['warning','This expedition is private.']);return false;
        }
        if(!isset($room->meta['expedition']))$this->rifts?->attach($room);
        $map=$room->map;
        $oldRoom=$this->currentRoom($c);
        // Java Rooms.checkLimits rejects explicit attempts to join the room the
        // player is already in.  Re-sending moveToArea here caused duplicated
        // client initialization and could reset live combat state.
        if($oldRoom&&$oldRoom->id===$room->id){
            $this->sendRaw($c,['warning','Cannot join a room you are currently in!']);
            return false;
        }
        if(count($room->clients)>=(int)$map['MaxPlayers']){$this->sendRaw($c,['warning','Room join failed, destination room is full.']);return false;}
        if($oldRoom){
            $this->exitRoomState($c,$oldRoom,true);
        }
        $c->roomId=$room->id;$c->roomName=$room->name;$c->frame=$frame;$c->pad=$pad;$c->x=0;$c->y=0;if($c->positionDisplay)$c->lastPositionDisplayAt=0.0;$c->state=1;$c->targetMonster=null;$c->respawnAt=0.0;$c->resting=false;
        if((int)($map['PvP']??0)!==1){$c->pvpRoomId=null;$c->pvpRoomName=null;$c->pvpJoinAt=0.0;$c->pvpExitAt=0.0;}
        foreach($room->clients as $other){
            $body="<u i='{$c->sfsUserId}' m='".($c->access>=40?1:0)."' s='0' p='{$c->sfsUserId}'><n>".Protocol::x($c->username)."</n></u>";
            $this->write($other,Protocol::sys('uER',$room->id,$body));
        }
        $room->clients[$c->socketId]=$c;
        $ul='';
        foreach($room->clients as $member){
            $ul .= "<u i='{$member->sfsUserId}' m='".($member->access>=40?1:0)."' s='0' p='{$member->sfsUserId}'><n>".Protocol::x($member->username)."</n></u>";
        }
        $this->write($c,Protocol::sys('joinOK',$room->id,"<pid id='{$c->sfsUserId}'/><uLs>{$ul}</uLs>"));
        $this->sendMoveToArea($c,$room);$this->sendRaw($c,['server','You joined "'.$room->name.'"!']);
        if($this->rifts)$this->sendJson($c,$this->rifts->status());
        try{$this->db->run('UPDATE users SET LastArea=? WHERE id=?',[$base.'|'.$frame.'|'.$pad,$c->dbId]);}catch(Throwable){}
        foreach($room->clients as $other){if($other!==$c)$this->sendJson($other,['cmd'=>'uotls','o'=>$this->userProps($c),'unm'=>$c->username]);}
        return true;
    }

    private function findOrCreateRoom(string $base,string $requested,array $map): RoomState
    {
        // Exact room first, just like Java Rooms.lookForRoom().
        foreach($this->rooms as $r)if(strcasecmp($r->name,$requested)===0)return $r;

        $requestedKey=null;
        if(str_contains($requested,'-')){
            $tail=explode('-',$requested,2)[1]??'';
            if($tail!==''&&ctype_digit($tail))$requestedKey=(int)$tail;
        }

        // Private keys above 999 never fall through into the public room pool.
        // Keys > 9999 are deliberately randomized by the Java emulator.
        if($requestedKey!==null&&$requestedKey>999){
            if($requestedKey>9999){
                do{$key=random_int(0,9998);$name=$base.'-'.$key;$exists=false;foreach($this->rooms as $r)if(strcasecmp($r->name,$name)===0){$exists=true;break;}}while($exists);
            }else{$name=$base.'-'.$requestedKey;}
            $r=new RoomState($this->nextRoomId++,$name,$map,$this->world->mapMonsters((int)$map['id']));$this->rooms[$r->id]=$r;return $r;
        }

        // Java only searches public keys 1..999.  Do not merge a public join
        // into somebody else's private room.
        for($n=1;$n<1000;$n++){
            $name=$base.'-'.$n;
            foreach($this->rooms as $r)if(!isset($r->meta['expedition'])&&strcasecmp($r->name,$name)===0&&count($r->clients)<(int)$map['MaxPlayers'])return $r;
        }

        // Generate the first unused public key (including an explicitly asked
        // for key 999, matching Rooms.generateRoom()).
        for($n=1;$n<1000;$n++){
            $name=$base.'-'.$n;$exists=false;foreach($this->rooms as $r)if(strcasecmp($r->name,$name)===0){$exists=true;break;}
            if(!$exists){$r=new RoomState($this->nextRoomId++,$name,$map,$this->world->mapMonsters((int)$map['id']));$this->rooms[$r->id]=$r;return $r;}
        }
        throw new \RuntimeException('No public room key is available for '.$base);
    }

    public function currentRoom(ClientSession $c): ?RoomState { return $this->rooms[$c->roomId]??null; }
    public function roomById(int $id): ?RoomState { return $this->rooms[$id]??null; }
    public function clients(): array { return $this->clients; }
    public function rooms(): array { return $this->rooms; }
    public function refreshRiftRoom(RoomState $room): void
    {
        foreach($room->clients as $c){$c->targetMonster=null;if($c->hp>0)$c->state=1;$this->sendMoveToArea($c,$room);}
    }
    public function findUser(string $name): ?ClientSession { foreach($this->clients as $c)if($c->authenticated&&strcasecmp($c->username,$name)===0)return $c;return null; }
    public function findUserBySfsId(int $id): ?ClientSession { foreach($this->clients as $c)if($c->authenticated&&$c->sfsUserId===$id)return $c;return null; }
    public function findUserByDbId(int $id): ?ClientSession { foreach($this->clients as $c)if($c->authenticated&&$c->dbId===$id)return $c;return null; }

    public function leaveGameRoom(ClientSession $c,bool $notify=true): void
    {
        $r=$this->rooms[$c->roomId]??null;if(!$r)return;
        $this->exitRoomState($c,$r,$notify);
    }

    private function exitRoomState(ClientSession $c,RoomState $r,bool $notify): void
    {
        foreach($r->monsters as &$monster)unset($monster['targets'][$c->socketId]);unset($monster);
        unset($r->clients[$c->socketId]);$c->targetMonster=null;$c->resting=false;
        if($notify){
            foreach($r->clients as $other){
                // Java Rooms.exit broadcasts exitArea, while SmartFox itself
                // emits userGone.  Keep both contracts for the stock client.
                $this->sendRaw($other,['exitArea',(string)$c->sfsUserId,$c->username]);
                $this->sendJson($other,['cmd'=>'uotls','unm'=>$c->username,'o'=>['intState'=>0]]);
                $this->write($other,Protocol::sys('userGone',$r->id,"<user id='{$c->sfsUserId}'/>"));
            }
        }
        if((int)($r->map['PvP']??0)===1)$this->handlePvpDeparture($r,$c,$notify);
        if(!$r->clients)unset($this->rooms[$r->id]);
    }

    private function handlePvpDeparture(RoomState $r,ClientSession $c,bool $notify): void
    {
        if($notify)$this->broadcastRaw(['server',$c->username.' has left the match.'],$r);
        if(($r->meta['pvp']['done']??false)!==true){
            $blue=0;$red=0;
            foreach($r->clients as $member){if($member->pvpTeam===0)$blue++;elseif($member->pvpTeam===1)$red++;}
            if($blue<=0)$r->meta['pvp']['scores'][1]=1000;
            elseif($red<=0)$r->meta['pvp']['scores'][0]=1000;
            if(($r->meta['pvp']['scores'][0]??0)>=1000||($r->meta['pvp']['scores'][1]??0)>=1000){
                $r->meta['pvp']['done']=true;$this->schedulePvpExit($r,microtime(true));
            }
        }
        $this->broadcastJson(['cmd'=>'ct','pvp'=>$this->pvpResultPacket($r)],$r);
    }

    /** @return array<string,mixed> */
    public function pvpResultPacket(RoomState $r): array
    {
        $scores=$r->meta['pvp']['scores']??[0,0];$done=(bool)($r->meta['pvp']['done']??false);
        $o=['cmd'=>$done?'PVPC':'PVPS','pvpScore'=>[['v'=>(int)($scores[0]??0)],['v'=>(int)($scores[1]??0)]]];
        if($done)$o['team']=(int)($scores[1]??0)>=(int)($scores[0]??0)?1:0;
        return $o;
    }

    public function schedulePvpExit(RoomState $r,float $now): void
    {
        foreach($r->clients as $member){$member->pvpExitAt=$now+6.0;$member->pvpRoomId=$r->id;}
    }

    private function sendMoveToArea(ClientSession $c,RoomState $r): void
    {
        $uo=[];foreach($r->clients as $u)$uo[]=$this->userProps($u);
        $monBranch=[];$monDef=[];$monMap=[];
        foreach($r->monsters as $m){
            $monBranch[]=['MonID'=>$m['MonID'],'MonMapID'=>$m['MonMapID'],'bRed'=>$m['Aggresive'],'iLvl'=>$m['Level'],'intHP'=>$m['HP'],'intHPMax'=>$m['HPMax'],'intMP'=>$m['MP'],'intMPMax'=>$m['MPMax'],'intState'=>$m['state'],'wDPS'=>$m['DPS']];
            $monDef[]=['MonID'=>$m['MonID'],'intHP'=>$m['HPMax'],'intHPMax'=>$m['HPMax'],'intLevel'=>$m['Level'],'intMP'=>$m['MPMax'],'intMPMax'=>$m['MPMax'],'strBehave'=>'walk','strLinkage'=>$m['Linkage'],'strMonFileName'=>$m['File'],'strMonName'=>$m['Name']];
            $monPlacement=['MonID'=>$m['MonID'],'MonMapID'=>$m['MonMapID'],'bRed'=>$m['Aggresive'],'intRSS'=>'-1','strFrame'=>$m['Frame'],'dbSpawn'=>!empty($m['DBPosition'])?1:0];
            if(!empty($m['DBPosition'])){$monPlacement['X']=(float)$m['X'];$monPlacement['Y']=(float)$m['Y'];}
            $monMap[]=$monPlacement;
        }
        $o=['cmd'=>'moveToArea','areaId'=>$r->id,'areaName'=>$r->name,'sExtra'=>'','strMapFileName'=>$r->map['File'],'strMapName'=>explode('-',$r->name)[0],'uoBranch'=>$uo,'monBranch'=>$monBranch,'intType'=>2];
        $npc=$this->world->mapNpcPayload((int)$r->map['id']);
        if($npc['npcmap']){$o['npcBranch']=$npc['npcBranch'];$o['npcdef']=$npc['npcdef'];$o['npcmap']=$npc['npcmap'];}
        else{$o['npcBranch']=[];$o['npcdef']=[];$o['npcmap']=[];}
        $o['mapArrows']=isset($r->meta['expedition'])?[]:$this->world->mapArrowPayload((int)$r->map['id']);
        if(isset($r->meta['expedition'])){$o['npcBranch']=[];$o['npcdef']=[];$o['npcmap']=[];}
        if(isset($r->meta['house']))$o['houseData']=$r->meta['house'];
        if((int)($r->map['PvP']??0)===1){$pvp=$r->meta['pvp']??['scores'=>[0,0],'factions'=>[]];$scores=$pvp['scores']??[0,0];$o['pvpTeam']=$c->pvpTeam;$o['PVPFactions']=$pvp['factions']??[];$o['pvpScore']=[['v'=>(int)($scores[0]??0)],['v'=>(int)($scores[1]??0)]];}
        if($monDef){$o['mondef']=$monDef;$o['monmap']=$monMap;}
        $this->sendJson($c,$o);
    }

    public function userProps(ClientSession $u): array
    { return ['afk'=>$u->afk,'entID'=>$u->sfsUserId,'entType'=>'p','intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intLevel'=>$u->level,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intState'=>$u->state,'showCloak'=>SettingsCodec::enabled((int)($u->user['Settings']??0),'bCloak'),'showHelm'=>SettingsCodec::enabled((int)($u->user['Settings']??0),'bHelm'),'strFrame'=>$u->frame,'strPad'=>$u->pad,'strUsername'=>$u->username,'tx'=>$u->x,'ty'=>$u->y,'uoName'=>$u->username]; }

    /**
     * Complete an intentional SmartFox logout without racing onConnectionLost.
     * The stock AQW client expects the sys/logout packet first; its onLogout
     * handler then closes the socket and returns to the login UI.  Keep a
     * short timeout as a fallback for clients that do not close themselves.
     */
    public function gracefulLogout(ClientSession $c,string $reason='logout'): void
    {
        $this->write($c,Protocol::sys('logout',-1));
        $c->kickAt=microtime(true)+1.0;
        $this->log->info('Logout acknowledged for '.($c->username!==''?$c->username:'<unauthenticated>').': '.$reason);
    }

    public function sendRaw(ClientSession $c,array $parts): void { $this->write($c,Protocol::raw($parts)); }
    public function sendJson(ClientSession $c,array $obj): void { $this->write($c,Protocol::json($obj)); }
    public function broadcastRaw(array $parts,?RoomState $room=null,?ClientSession $except=null): void { $targets=$room?$room->clients:$this->clients;foreach($targets as $c)if($c->authenticated&&$c!==$except)$this->sendRaw($c,$parts); }
    public function broadcastJson(array $obj,?RoomState $room=null,?ClientSession $except=null): void { $targets=$room?$room->clients:$this->clients;foreach($targets as $c)if($c->authenticated&&$c!==$except)$this->sendJson($c,$obj); }

    private function write(ClientSession $c,string $data): void { if(is_resource($c->socket))@fwrite($c->socket,$data); }
    public function disconnect(ClientSession $c,string $reason=''): void
    {
        $this->router->onDisconnect($c);$this->leaveGameRoom($c);unset($this->clients[$c->socketId]);if(is_resource($c->socket))@fclose($c->socket);
        if($c->authenticated){try{$this->db->run("UPDATE users SET CurrentServer='Offline' WHERE id=?",[$c->dbId]);}catch(Throwable){};$this->log->info("Disconnected {$c->username}: {$reason}");$this->updateCount();}
    }

    private function tick(): void
    {
        $now=microtime(true);
        foreach(array_values($this->clients) as $client){
            if(!$client->authenticated)continue;
            if($client->kickAt>0.0&&$now>=$client->kickAt){if($client->kickGraceful){$client->kickGraceful=false;$client->kickAt=$now+1.0;$this->write($client,Protocol::sys('logout',-1));$this->log->info('Staff kick logout acknowledged for '.$client->username.' | Reason: '.$client->kickReason);continue;}$client->kickAt=0.0;$reason=$client->kickReason!==''?'staff kick: '.$client->kickReason:'scheduled kick';$client->kickReason='';$this->disconnect($client,$reason);continue;}
            $this->processPlayerAurasAndDots($client,$now);
            if($client->pvpExitAt>0.0&&$now>=$client->pvpExitAt){$roomId=$client->pvpRoomId;$client->pvpExitAt=0.0;$client->hp=$client->hpMax;$client->mp=$client->mpMax;$client->state=1;$client->respawnAt=0.0;$client->auras=[];$client->dots=[];$this->recalculateStats($client,false);$this->joinGameRoom($client,'faroff');if($roomId!==null)$this->releasePreparedRoomIfUnused($roomId);continue;}
            if($client->pvpRoomId!==null&&$client->pvpJoinAt>0.0&&$now>=$client->pvpJoinAt)$this->joinPreparedRoom($client,$client->pvpRoomId,'Enter'.$client->pvpTeam,'Spawn');
            // /position is a persistent in-game coordinate HUD. The stock client
            // already has a reusable black-banner notification MovieClip, so
            // refreshing it before frame 60 keeps one banner visible without
            // filling chat history or creating stacked popups.
            if($client->positionDisplay&&($client->lastPositionDisplayAt<=0.0||$now-$client->lastPositionDisplayAt>=0.75)){
                $client->lastPositionDisplayAt=$now;
                $this->sendRaw($client,['popup','blackbanner','Position  X: '.$client->x.'  Y: '.$client->y]);
            }
            if(!$client->resting||$client->state!==1||$client->hp<=0)continue;
            $needHp=$client->hp<$client->hpMax;
            $needMp=$client->mp<$client->mpMax;
            $needSp=$client->stamina<$client->staminaMax;
            if(!$needHp&&!$needMp&&!$needSp){$client->resting=false;continue;}
            if($client->lastRegenAt>0.0&&$now-$client->lastRegenAt<1.0)continue;$client->lastRegenAt=$now;
            // Aera v30.74: each resource regenerates independently. In particular,
            // stamina no longer depends on HP or MP being below maximum.
            if($needHp)$client->hp=min($client->hpMax,$client->hp+max(1,(int)round($client->hpMax*0.125)));
            if($needMp)$client->mp=min($client->mpMax,$client->mp+max(1,(int)round($client->mpMax*0.10)));
            $beforeSp=$client->stamina;
            if($needSp)$client->stamina=min($client->staminaMax,$client->stamina+max(1,(int)round($client->staminaMax*0.25)));
            if($needSp&&$client->stamina!==$beforeSp)$this->log->info('Stamina regen: player='.$client->username.' before='.$beforeSp.' after='.$client->stamina);
            $regen=['cmd'=>'ct','p'=>[$client->username=>['intHP'=>$client->hp,'intHPMax'=>$client->hpMax,'intMP'=>$client->mp,'intMPMax'=>$client->mpMax,'intSP'=>$client->stamina,'intState'=>1]]];
            // Always push the authoritative values directly to the resting player.
            $this->sendJson($client,$regen);
            $room=$this->currentRoom($client);if($room)$this->broadcastJson($regen,$room,$client);
            if($client->hp>=$client->hpMax&&$client->mp>=$client->mpMax&&$client->stamina>=$client->staminaMax)$client->resting=false;
        }
        foreach($this->rooms as $room){
            if(($room->meta['pvp']['done']??false)===true)continue;
            foreach($room->monsters as $id=>&$m){
                if(!isset($m['expeditionId']) && ($m['riftRole']??'')!=='commander' && $m['state']===0 && $m['respawnAt']>0 && $now>=$m['respawnAt']){
                    $m['HP']=$m['HPMax'];$m['MP']=$m['MPMax'];$m['state']=1;$m['targets']=[];$m['auras']=[];$m['dots']=[];$m['skillCooldowns']=[];$m['respawnAt']=0.0;$m['lastAttack']=0.0;$m['lastCombat']=0.0;$m['lastRegen']=$now;
                    $this->broadcastJson(['cmd'=>'mtls','id'=>$id,'o'=>['intState'=>1,'intHP'=>$m['HP'],'intMP'=>$m['MP'],'intSP'=>100]],$room);
                    $this->broadcastRaw(['respawnMon',(string)$id],$room);
                }
                if($m['state']!==0)$this->processMonsterDots($room,$m,$id,$now);
                $this->expireMonsterAuras($room,$m,$id,$now);
                if(($m['riftRole']??'')!=='commander' && $m['state']!==0 && !$m['targets'] && $m['HP']<$m['HPMax'] && ($now-$m['lastCombat'])>=(float)$this->config->get('monster_regen_interval',3.0) && ($now-$m['lastRegen'])>=(float)$this->config->get('monster_regen_interval',3.0)){$heal=max(1,(int)round($m['HPMax']*(float)$this->config->get('monster_regen_percent',0.05)));$m['HP']=min($m['HPMax'],$m['HP']+$heal);$m['lastRegen']=$now;$this->broadcastJson(['cmd'=>'mtls','id'=>$id,'o'=>['intHP'=>$m['HP'],'intHPMax'=>$m['HPMax'],'intMP'=>$m['MP'],'intMPMax'=>$m['MPMax'],'intState'=>$m['state']]],$room);}
                if($m['state']!==0 && $m['targets'])$this->monsterAttackTick($room,$m,$now);
            }unset($m);
        }
        $this->rifts?->tick($now);
        $this->expeditions?->tick($now);
        if($now-$this->lastCommandPoll>=(float)$this->config->get('admin_command_poll_seconds',2.0)){$this->lastCommandPoll=$now;$this->pollAdminCommands();}
        if($now-$this->lastServerMessageAt>=(float)$this->config->get('server_message_interval_seconds',1800)){$this->lastServerMessageAt=$now;$this->sendScheduledServerMessage();}
        if($now-$this->lastWarzoneTick>=(float)$this->config->get('warzone_queue_interval_seconds',5.0)){$this->lastWarzoneTick=$now;$this->router->processPvpQueues();}
        if($this->shutdownAt!==null){
            $remain=(int)ceil($this->shutdownAt-$now);
            if($remain<=0){$this->broadcastRaw(['logoutWarning','','60']);$this->intentionalStop('safe shutdown complete');$this->running=false;}
            elseif($remain!==$this->lastShutdownWarning&&in_array($remain,[300,240,180,120,60,30,10,5,4,3,2,1],true)){
                $this->lastShutdownWarning=$remain;
                $text=$remain>=60&&$remain%60===0?((int)($remain/60).' minute'.($remain===60?'':'s')):($remain.' seconds');
                $this->broadcastRaw([$remain===300?'server':'warning','Server shutting down in '.$text.'. Please logout to prevent data loss.']);
            }
        }
        if($this->restartAt!==null){
            $remain=(int)ceil($this->restartAt-$now);
            if($remain<=0){$this->broadcastRaw(['logoutWarning','','60']);$this->markRestartIntent('restart countdown completed');$this->running=false;}
            elseif($remain!==$this->lastShutdownWarning&&in_array($remain,[300,240,180,120,60,30,10,5,4,3,2,1],true)){
                $this->lastShutdownWarning=$remain;
                $text=$remain>=60&&$remain%60===0?((int)($remain/60).' minute'.($remain===60?'':'s')):($remain.' seconds');
                $this->broadcastRaw([$remain===300?'server':'warning','Server restarting in '.$text.'. Please logout to prevent data loss.']);
            }
        }
    }

    /** Port of RemoveAura + DamageOverTime for player targets. */
    private function processPlayerAurasAndDots(ClientSession $client,float $now): void
    {
        $room=$this->currentRoom($client);$statsChanged=false;
        foreach(array_keys($client->dots) as $auraId){
            $dot=$client->dots[$auraId]??null;if(!is_array($dot))continue;
            if((float)($dot['expiresAt']??0)>0&&(float)$dot['expiresAt']<=$now){unset($client->dots[$auraId]);continue;}
            if((float)($dot['nextTick']??PHP_FLOAT_MAX)>$now||$client->hp<=0)continue;
            $raw=(int)($dot['damage']??0);if($raw===0){unset($client->dots[$auraId]);continue;}$mag=max(1,abs($raw));$amount=random_int(1,$mag);if($raw<0)$amount*=-1;
            if($amount>0){$amount=$this->combat->playerDotIncoming($amount,$client);$meta=$this->combat->equipmentMeta($client,'dmgtaken',-1.0,.90);if($meta!=0.0)$amount=(int)round($amount*max(0.0,1.0-$meta));}
            $amount=$this->expeditions?->incoming($client,$amount)??$amount;
            if($amount>=0)$client->hp=max(0,$client->hp-$amount);else$client->hp=min($client->hpMax,$client->hp-$amount);
            if($client->hp<=0){$client->state=0;$client->resting=false;$client->targetMonster=null;$client->respawnAt=$now+8.0;unset($client->dots[$auraId]);try{$this->db->run('UPDATE users SET DeathCount=DeathCount+1 WHERE id=?',[$client->dbId]);}catch(Throwable){}}
            elseif($amount>0){$client->state=2;$client->resting=false;}
            if($room){$from=(string)($dot['from']??'');$action=['hp'=>$amount,'cInf'=>$from,'tInf'=>'p:'.$client->sfsUserId,'typ'=>'dot'];$this->broadcastJson(['cmd'=>'ct','p'=>[$client->username=>['intHP'=>$client->hp,'intHPMax'=>$client->hpMax,'intMP'=>$client->mp,'intMPMax'=>$client->mpMax,'intState'=>$client->state]],'sara'=>[['actionResult'=>$action,'iRes'=>1]]],$room);}
            if(isset($client->dots[$auraId]))$client->dots[$auraId]['nextTick']=$now+2.0;
        }
        foreach(array_keys($client->auras) as $auraId){$a=$client->auras[$auraId]??null;if(!is_array($a)||(float)($a['expiresAt']??0)>$now)continue;unset($client->auras[$auraId],$client->dots[$auraId]);if(!empty($this->world->auraEffectsByAura[(int)$auraId]))$statsChanged=true;if($room){$info=['nam'=>(string)($a['nam']??'')];$cat=strtolower((string)($a['cat']??''));if($cat!==''&&$cat!=='d'){$info['cat']=$cat;if($cat==='stun')$info['s']='s';}$this->broadcastJson(['cmd'=>'ct','a'=>[['cmd'=>'aura-','aura'=>$info,'tInf'=>'p:'.$this->sfsUserId]]],$room);}}
        if($statsChanged)$this->recalculateStats($client,false);
    }

    private function recalculateStats(ClientSession $client,bool $restoreNeutral=false): void
    {
        try{$calc=$this->statsCalculator->calculate($client);$wasNeutral=$client->state===1;$client->stats=$calc['sta'];$client->wDPS=$calc['wDPS'];$client->mDPS=$calc['mDPS'];$client->minDmg=$calc['minDmg'];$client->maxDmg=$calc['maxDmg'];$client->classCategory=$calc['classCat'];$client->hpMax=$calc['hpMax'];$client->mpMax=$calc['mpMax'];if($restoreNeutral&&$wasNeutral){$client->hp=$client->hpMax;$client->mp=$client->mpMax;}else{$client->hp=min($client->hp,$client->hpMax);$client->mp=min($client->mp,$client->mpMax);}$this->sendJson($client,['cmd'=>'stu','tempSta'=>$calc['tempSta'],'sta'=>$calc['sta'],'wDPS'=>$calc['wDPS'],'mDPS'=>$calc['mDPS']]);}catch(Throwable $e){$this->log->warn('Scheduled stat recalculation failed for '.$client->username.': '.$e->getMessage());}
    }

    private function processMonsterDots(RoomState $room,array &$m,int $monMapId,float $now): void
    {
        foreach(array_keys((array)($m['dots']??[])) as $auraId){$dot=$m['dots'][$auraId]??null;if(!is_array($dot))continue;if((float)($dot['expiresAt']??0)>0&&(float)$dot['expiresAt']<=$now){unset($m['dots'][$auraId]);continue;}if((float)($dot['nextTick']??PHP_FLOAT_MAX)>$now)continue;$raw=(int)($dot['damage']??0);if($raw===0){unset($m['dots'][$auraId]);continue;}$mag=max(1,abs($raw));$amount=random_int(1,$mag);if($raw<0)$amount*=-1;if($amount>0)$amount=$this->combat->monsterDotIncoming($amount,(array)($m['auras']??[]),$now);if($amount>0){$from=(string)($dot['from']??'');$owner=preg_match('/^p:(\d+)$/D',$from,$match)?$this->findUserBySfsId((int)$match[1]):null;$amount=$this->expeditions?->damage($owner,$m,$amount)??$amount;$this->rifts?->hit($owner,$m,$amount,(int)($dot['riftUserId']??0));}if($amount>=0)$m['HP']=max(0,(int)$m['HP']-$amount);else$m['HP']=min((int)$m['HPMax'],(int)$m['HP']-$amount);$action=['hp'=>$amount,'cInf'=>(string)($dot['from']??''),'tInf'=>'m:'.$monMapId,'typ'=>'dot'];$packet=['cmd'=>'ct','m'=>[(string)$monMapId=>['intHP'=>$m['HP'],'intHPMax'=>$m['HPMax'],'intMP'=>$m['MP'],'intMPMax'=>$m['MPMax'],'intState'=>$m['HP']<=0?0:$m['state'],'targets'=>array_map('intval',array_keys((array)$m['targets']))]],'sara'=>[['actionResult'=>$action,'iRes'=>1]]];if($m['HP']<=0){$m['state']=0;$m['respawnAt']=$now+max(1,(int)$m['Respawn']);$m['auras']=[];$m['dots']=[];$p=[];foreach(array_keys((array)$m['targets']) as $sid){$member=$room->clients[(int)$sid]??null;if($member&&$member->hp>0)$p[$member->username]=['intState'=>1];}if($p)$packet['p']=$p;$this->router->rewardMonsterParticipants($room,$m);$this->broadcastJson($packet,$room);return;}$this->broadcastJson($packet,$room);if(isset($m['dots'][$auraId]))$m['dots'][$auraId]['nextTick']=$now+2.0;}
    }

    private function expireMonsterAuras(RoomState $room,array &$m,int $monMapId,float $now): void
    {
        if(empty($m['auras'])||!is_array($m['auras']))return;
        foreach(array_keys($m['auras']) as $auraId){
            $aura=$m['auras'][$auraId]??null;
            if(!is_array($aura)||(float)($aura['expiresAt']??0)>$now)continue;
            unset($m['auras'][$auraId],$m['dots'][$auraId]);

            // RemoveAura.run() parity. aura- with s=s causes the stock client to
            // play Getup after a stun instead of leaving the monster in Fall.
            $info=['nam'=>(string)($aura['nam']??'')];
            $cat=(string)($aura['cat']??'');
            if($cat!==''&&$cat!=='d'){
                $info['cat']=$cat;
                if($cat==='stun')$info['s']='s';
            }
            $this->broadcastJson([
                'cmd'=>'ct',
                'a'=>[[
                    'cmd'=>'aura-',
                    'aura'=>$info,
                    'tInf'=>'m:'.$monMapId,
                ]],
            ],$room);
        }
    }

    private function monsterIsDisabled(array $m,float $now): bool
    {
        if(empty($m['auras'])||!is_array($m['auras']))return false;
        foreach($m['auras'] as $aura){
            if(!is_array($aura)||(float)($aura['expiresAt']??0)<=$now)continue;
            if(in_array(strtolower((string)($aura['cat']??'')),['stun','freeze','stone','disabled'],true))return true;
        }
        return false;
    }

    private function monsterAttackTick(RoomState $room,array &$m,float $now): void
    {
        // Java MonsterAttack.run()/attack() parity, with the same-cell guard
        // intentionally applied to monster skills as well so a stale target can
        // never be damaged after walking to another map frame.
        if($this->monsterIsDisabled($m,$now))return;
        $speed=max(1.0,((int)($m['Speed']??1000))/1000.0);
        $last=(float)($m['lastAttack']??0.0);
        if($now-$last<$speed)return;

        $eligible=[];
        foreach(array_keys((array)($m['targets']??[])) as $socketId){
            $candidate=$room->clients[(int)$socketId]??null;
            if(!$candidate||!$candidate->authenticated||$candidate->hp<=0||$candidate->state===0||$candidate->roomId!==$room->id||$candidate->frame!==(string)$m['Frame']){
                unset($m['targets'][(int)$socketId]);
                continue;
            }
            $eligible[(int)$socketId]=$candidate;
        }
        if(!$eligible){$m['state']=1;return;}

        $keys=array_keys($eligible);$targetId=$keys[array_rand($keys)];$target=$eligible[$targetId];
        $m['lastAttack']=$now;$m['lastCombat']=$now;$m['state']=2;

        $diff=(int)$m['Level']-$target->level;
        $hitChance=(float)$this->config->get('monster_accuracy_equal_level',0.90)+($diff*0.01);
        $hitChance=max((float)$this->config->get('monster_accuracy_min',0.82),min((float)$this->config->get('monster_accuracy_max',0.96),$hitChance));
        $dodge=max(0.0,min((float)$this->config->get('pve_dodge_cap',0.35),(float)($target->stats['$tdo']??0.0)));
        $type=$this->combat->damageType($hitChance,$dodge,0.05);
        $dps=max(0,(int)($m['DPS']??0));$min=(int)floor($dps-($dps*.10));$max=(int)ceil($dps+($dps*.10));
        $damage=$this->combat->randomDamage($type,$max,$min,0);
        $damage=$this->combat->monsterOutgoing($damage,(array)($m['auras']??[]),$now,'physical');
        $damage=$this->combat->playerIncoming($damage,$target,$now,'physical');
        $reduction=$this->combat->equipmentMeta($target,'dmgtaken',-1.0,.90);
        if($reduction!=0.0)$damage=(int)round($damage*max(0.0,1.0-$reduction));

        $m['MP']=min((int)$m['MPMax'],(int)$m['MP']+max(1,(int)round((int)$m['MPMax']*.02)));
        if($damage>0){
            $damage=$this->expeditions?->incoming($target,$damage)??$damage;
            $target->resting=false;$target->hp=max(0,$target->hp-$damage);$target->state=$target->hp<=0?0:2;
            if($target->hp<=0){
                unset($m['targets'][$targetId]);$target->targetMonster=null;$target->respawnAt=$now+8.0;
                try{$this->db->run('UPDATE users SET DeathCount=DeathCount+1 WHERE id=?',[$target->dbId]);}catch(Throwable){}
            }
        }

        $from='m:'.(int)$m['MonMapID'];$to='p:'.$target->sfsUserId;
        $action=['hp'=>$damage,'cInf'=>$from,'tInf'=>$to,'type'=>$type];
        $ct=['cmd'=>'ct','p'=>[$target->username=>['intHP'=>$target->hp,'intHPMax'=>$target->hpMax,'intMP'=>$target->mp,'intMPMax'=>$target->mpMax,'intState'=>$target->state]],'m'=>[(string)$m['MonMapID']=>['intMP'=>$m['MP']]],'anims'=>[['strFrame'=>$m['Frame'],'cInf'=>$from,'fx'=>'m','tInf'=>$to,'animStr'=>'Attack1,Attack2']]];
        $this->broadcastJson($ct,$room,$target);$ct['sara']=[['actionResult'=>$action,'iRes'=>1]];$this->sendJson($target,$ct);

        $this->monsterSkillCast($room,$m,$now);
    }

    /** Port of MonsterAttack.cast()/MonsterSkills. */
    private function monsterSkillCast(RoomState $room,array &$m,float $now): void
    {
        if($this->monsterIsDisabled($m,$now)||empty($m['skills'])||!is_array($m['skills']))return;

        // MonsterSkills.java stores "now" and subtracts the current time, so its
        // first available skill is returned on every basic attack. Preserve that
        // observable behavior while making target/cell validation stricter.
        $skill=null;
        foreach($m['skills'] as $skillId){$candidate=$this->world->skills[(int)$skillId]??null;if($candidate){$skill=$candidate;break;}}
        if(!$skill)return;
        $mana=max(0,(int)($skill['Mana']??0));if($mana>(int)$m['MP'])return;

        $eligible=[];
        foreach(array_keys((array)$m['targets']) as $socketId){
            $candidate=$room->clients[(int)$socketId]??null;
            if(!$candidate||!$candidate->authenticated||$candidate->hp<=0||$candidate->state===0||$candidate->roomId!==$room->id||$candidate->frame!==(string)$m['Frame']){unset($m['targets'][(int)$socketId]);continue;}
            $eligible[(int)$socketId]=$candidate;
        }
        if(!$eligible)return;
        $ids=array_keys($eligible);shuffle($ids);$ids=array_slice($ids,0,max(1,(int)($skill['HitTargets']??1)));
        if(!$ids)return;

        $from='m:'.(int)$m['MonMapID'];$results=[];$p=[];$sara=[];$targetInfos=[];
        foreach($ids as $socketId){
            $target=$eligible[$socketId];$targetInfo='p:'.$target->sfsUserId;$targetInfos[]=$targetInfo;
            $diff=(int)$m['Level']-$target->level;$hitChance=(float)$this->config->get('monster_accuracy_equal_level',0.90)+($diff*.01);$hitChance=max((float)$this->config->get('monster_accuracy_min',.82),min((float)$this->config->get('monster_accuracy_max',.96),$hitChance));
            $dodge=max(0.0,min((float)$this->config->get('pve_dodge_cap',.35),(float)($target->stats['$tdo']??0.0)));$type=$this->combat->damageType($hitChance,$dodge,.05);
            $dps=max(0,(int)($m['DPS']??0));$min=(int)floor($dps-($dps*.10));$max=(int)ceil($dps+($dps*.10));
            $mult=(float)($skill['Damage']??1.0);$school=strtolower((string)($skill['Type']??''))==='m'?'magic':'physical';
            $damage=(int)round($this->combat->randomDamage($type,$max,$min,0)*$mult);
            if($damage>0){$damage=$this->combat->monsterOutgoing($damage,(array)($m['auras']??[]),$now,$school);$damage=$this->combat->playerIncoming($damage,$target,$now,$school);$reduction=$this->combat->equipmentMeta($target,'dmgtaken',-1.0,.90);if($reduction!=0.0)$damage=(int)round($damage*max(0.0,1.0-$reduction));}
            $m['MP']=min((int)$m['MPMax'],(int)$m['MP']+max(1,(int)round((int)$m['MPMax']*.02)));
            $damage=$this->expeditions?->incoming($target,$damage)??$damage;
            if($damage>=0)$target->hp=max(0,$target->hp-$damage);else$target->hp=min($target->hpMax,$target->hp-$damage);
            if($target->hp<=0){$target->state=0;$target->resting=false;$target->targetMonster=null;$target->respawnAt=$now+8.0;unset($m['targets'][$socketId]);try{$this->db->run('UPDATE users SET DeathCount=DeathCount+1 WHERE id=?',[$target->dbId]);}catch(Throwable){}}
            elseif($damage>0){$target->state=2;$target->resting=false;}
            $result=['hp'=>$damage,'cInf'=>$from,'tInf'=>$targetInfo,'type'=>$type];$results[]=$result;
            $p[$target->username]=['intHP'=>$target->hp,'intHPMax'=>$target->hpMax,'intMP'=>$target->mp,'intMPMax'=>$target->mpMax,'intState'=>$target->state];
            $sara[]=['actionResult'=>['hp'=>$damage,'cInf'=>$from,'tInf'=>$targetInfo,'type'=>$type],'iRes'=>1];
        }
        if(!$results)return;

        $m['MP']=max(0,(int)$m['MP']-$mana);
        $targetInfo=implode(',',$targetInfos);$auras=$this->router->applySkillAurasFromServer((int)$skill['id'],$from,$results,$room,$now);
        $anim=['strFrame'=>(string)$m['Frame'],'cInf'=>$from,'fx'=>(string)($skill['Effects']??''),'tInf'=>$targetInfo,'animStr'=>(string)($skill['Animation']??'Attack1')];
        if((string)($skill['Strl']??'')!=='')$anim['strl']=(string)$skill['Strl'];
        $ct=['cmd'=>'ct','p'=>$p,'m'=>[(string)$m['MonMapID']=>['intMP'=>$m['MP']]],'sarsa'=>[['cInf'=>$from,'a'=>$results,'iRes'=>1]],'anims'=>[$anim],'sara'=>$sara];
        if($auras)$ct['a']=$auras;
        $this->broadcastJson($ct,$room);
    }

    private function pollAdminCommands(): void
    {
        if(!$this->db->tableExists('admin_commands'))return;
        $stale=max(30,(int)$this->config->get('admin_command_stale_seconds',120));
        try{
            $this->db->run("UPDATE admin_commands SET Status='failed',ProcessedAt=NOW(),Result='Expired: command was not processed within two minutes.' WHERE Status IN ('pending','processing') AND RequestedAt<DATE_SUB(NOW(),INTERVAL {$stale} SECOND)");
            $row=$this->db->one("SELECT * FROM admin_commands WHERE Status='pending' AND RequestedAt>=DATE_SUB(NOW(),INTERVAL {$stale} SECOND) ORDER BY id ASC LIMIT 1");if(!$row)return;
            $id=(int)$row['id'];$cmd=strtolower((string)$row['Command']);$changed=$this->db->run("UPDATE admin_commands SET Status='processing',ProcessedAt=NOW() WHERE id=? AND Status='pending'",[$id]);if($changed<1)return;
            if($cmd==='reload_data'){$this->world->reload();$result='Database-backed game cache reloaded.';}
            elseif($cmd==='safe_shutdown'){$seconds=(int)$this->config->get('safe_shutdown_seconds',300);$result=$this->scheduleShutdown($seconds,'admin command queue')?'Five-minute in-game shutdown countdown started.':'Shutdown or restart already scheduled.';}
            else{throw new \RuntimeException('Unknown admin command: '.$cmd);}
            $this->db->run("UPDATE admin_commands SET Status='complete',ProcessedAt=NOW(),Result=? WHERE id=?",[$result,$id]);$this->log->info("Admin command {$cmd}: {$result}");
        }catch(Throwable $e){if(isset($id))try{$this->db->run("UPDATE admin_commands SET Status='failed',ProcessedAt=NOW(),Result=? WHERE id=?",[substr($e->getMessage(),0,250),$id]);}catch(Throwable){}$this->log->warn('Admin command queue: '.$e->getMessage());}
    }

    public function scheduleShutdown(int $seconds=300,string $reason='in-game command'): bool
    {
        if($this->shutdownAt!==null||$this->restartAt!==null)return false;
        $this->shutdownAt=microtime(true)+max(1,$seconds);$this->lastShutdownWarning=-1;
        $this->log->warn('Safe shutdown scheduled: '.$seconds.' seconds | '.$reason);
        return true;
    }
    public function cancelShutdown(): bool
    {
        if($this->shutdownAt===null)return false;$this->shutdownAt=null;$this->lastShutdownWarning=-1;return true;
    }
    public function scheduleRestart(int $seconds=300,string $reason='in-game command'): bool
    {
        if($this->shutdownAt!==null||$this->restartAt!==null)return false;
        $this->restartAt=microtime(true)+max(1,$seconds);$this->lastShutdownWarning=-1;
        $this->log->warn('Restart scheduled: '.$seconds.' seconds | '.$reason);
        return true;
    }
    public function cancelRestart(): bool
    {
        if($this->restartAt===null)return false;$this->restartAt=null;$this->lastShutdownWarning=-1;return true;
    }
    public function stopFromCommand(): void { $this->intentionalStop('in-game command');$this->running=false; }
    public function requestRestart(): void
    {
        $this->markRestartIntent('immediate restart command');
        $this->log->warn('Emulator restart requested; supervisor/watchdog will relaunch PHP runtime.');
        $this->running=false;
    }
    private function markRestartIntent(string $reason): void
    {
        @mkdir($this->config->root().'/runtime/control',0775,true);
        @unlink($this->config->root().'/runtime/intentional.stop');
        @file_put_contents($this->config->root().'/runtime/control/desired.txt','running');
        @file_put_contents($this->config->root().'/runtime/control/restart.intent',$reason.' '.date(DATE_ATOM));
    }
    private function intentionalStop(string $reason): void
    {
        @file_put_contents($this->config->root().'/runtime/intentional.stop',$reason.' '.date(DATE_ATOM));
        // Tell the SYSTEM supervisor that this is an intentional stop so it
        // does not bring the emulator back after a safe shutdown.
        @mkdir($this->config->root().'/runtime/control',0775,true);
        @file_put_contents($this->config->root().'/runtime/control/desired.txt','stopped');
    }
    private function shutdownNow(): void
    {
        $this->expeditions?->shutdown();
        try{$this->rifts?->finish('interrupted');}catch(Throwable $e){$this->log->warn('Rift shutdown checkpoint: '.$e->getMessage());}
        foreach(array_values($this->clients) as $c)$this->disconnect($c,'server stopping');
        try{$this->db->run("UPDATE users SET CurrentServer='Offline' WHERE CurrentServer=?",[(string)$this->config->get('server_name','Aera')]);}catch(Throwable){}
        $this->markServer(false);
        @unlink($this->config->root().'/runtime/emulator.pid');
        if(is_resource($this->server))@fclose($this->server);
        $this->log->info('Aera PHP Emulator stopped.');
        $this->console?->broadcastState('stopped',['pid'=>getmypid()]);
        $this->log->setSink(null);
        $this->console?->close();
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
    /** @param array<string,mixed> $params @return array<string,mixed> */
    private function handleConsoleRpc(string $action, array $params): array
    {
        $action = strtolower(trim($action));

        if(str_starts_with($action,'rift-'))return $this->rifts?->control($action,$params)??['ok'=>false,'message'=>'Rifts unavailable.'];
        if ($action === 'snapshot') {
            $players = [];
            foreach ($this->clients as $client) {
                if (!$client->authenticated) continue;
                $players[] = [
                    'id' => $client->dbId,
                    'sfsId' => $client->sfsUserId,
                    'name' => $client->username,
                    'access' => $client->access,
                    'level' => $client->level,
                    'roomId' => $client->roomId,
                    'room' => $client->roomName,
                    'frame' => $client->frame,
                    'hp' => $client->hp,
                    'hpMax' => $client->hpMax,
                    'mp' => $client->mp,
                    'mpMax' => $client->mpMax,
                    'afk' => $client->afk,
                    'muted' => $this->isMuted($client),
                    'muteSeconds' => max(0,(int)ceil($client->muteUntil-microtime(true))),
                    'ip' => $client->ip,
                ];
            }
            usort($players, static fn(array $a,array $b):int => strcasecmp((string)$a['name'], (string)$b['name']));

            $rooms = [];
            foreach ($this->rooms as $room) {
                $alive = 0;
                foreach ($room->monsters as $monster) if ((int)($monster['state'] ?? 0) !== 0) $alive++;
                $rooms[] = [
                    'id' => $room->id,
                    'name' => $room->name,
                    'players' => count($room->clients),
                    'monsters' => count($room->monsters),
                    'monstersAlive' => $alive,
                ];
            }
            usort($rooms, static fn(array $a,array $b):int => strcasecmp((string)$a['name'], (string)$b['name']));

            return [
                'ok' => true,
                'data' => [
                    'pid' => getmypid(),
                    'running' => $this->running,
                    'uptime' => max(0, (int)(microtime(true) - $this->startedAt)),
                    'startedAt' => date(DATE_ATOM, (int)$this->startedAt),
                    'gamePort' => (int)$this->config->get('port', 5589),
                    'consolePort' => (int)$this->config->get('console_port', 5591),
                    'playersOnline' => count($players),
                    'activeRooms' => count($rooms),
                    'players' => $players,
                    'rooms' => $rooms,
                    'eventCursor' => $this->console?->cursor() ?? 0,
                    'shutdownRemaining' => $this->shutdownAt === null ? null : max(0, (int)ceil($this->shutdownAt - microtime(true))),
                    'restartRemaining' => $this->restartAt === null ? null : max(0, (int)ceil($this->restartAt - microtime(true))),
                ],
            ];
        }

        if ($action === 'broadcast') {
            $message = trim((string)($params['message'] ?? ''));
            if ($message === '') return ['ok'=>false,'message'=>'Broadcast message is empty.'];
            if (strlen($message) > 500) $message = substr($message, 0, 500);
            $this->broadcastRaw(['server', $message]);
            $this->log->info('Panel broadcast: '.$message);
            return ['ok'=>true,'message'=>'Broadcast sent to all online players.'];
        }

        if ($action === 'message-player') {
            $userId=(int)($params['userId']??0);$name=trim((string)($params['name']??''));$message=trim((string)($params['message']??''));
            if($message==='')return ['ok'=>false,'message'=>'Message is empty.'];
            $target=$userId>0?$this->findUserByDbId($userId):$this->findUser($name);
            if(!$target)return ['ok'=>false,'message'=>'Player is not online.'];
            $message=substr($message,0,500);
            $this->sendRaw($target,['server','Staff Message: '.$message]);
            $this->log->info('Panel message -> '.$target->username.': '.$message);
            return ['ok'=>true,'message'=>'Message sent to '.$target->username.'.'];
        }

        if ($action === 'kick') {
            $userId=(int)($params['userId']??0);$name=trim((string)($params['name']??''));$reason=trim((string)($params['reason']??''));
            $target=$userId>0?$this->findUserByDbId($userId):$this->findUser($name);
            if(!$target)return ['ok'=>false,'message'=>'Player is not online.'];
            $reason=substr($reason!==''?$reason:'No reason provided.',0,250);
            $kickMessage='You were kicked by staff. Reason: '.$reason;
            $this->sendRaw($target,['warning',$kickMessage]);
            $this->sendRaw($target,['popup','messagebox',$kickMessage]);
            $this->sendRaw($target,['logoutWarning',$kickMessage,'5']);
            $target->kickReason=$reason;$target->kickGraceful=true;$target->kickAt=microtime(true)+5.5;
            $this->log->warn('Panel kicked player '.$target->username.' | Reason: '.$reason);
            return ['ok'=>true,'message'=>$target->username.' was kicked.'];
        }

        if ($action === 'ban-player') {
            $userId=(int)($params['userId']??0);$name=trim((string)($params['name']??''));$reason=trim((string)($params['reason']??''));
            if($userId<=0&&$name==='')return ['ok'=>false,'message'=>'Player is required.'];
            $row=$userId>0?$this->db->one('SELECT id,Name,Access FROM users WHERE id=? LIMIT 1',[$userId]):$this->db->one('SELECT id,Name,Access FROM users WHERE LOWER(Name)=LOWER(?) LIMIT 1',[$name]);
            if(!$row)return ['ok'=>false,'message'=>'Player could not be found.'];
            $reason=substr($reason!==''?$reason:'No reason provided.',0,500);
            $this->db->run('UPDATE users SET Access=0,CurrentServer=\'Offline\' WHERE id=?',[(int)$row['id']]);
            try{$this->db->run('DELETE FROM game_sessions WHERE UserID=?',[(int)$row['id']]);}catch(Throwable){}
            $target=$this->findUserByDbId((int)$row['id']);
            if($target){$target->access=0;$target->user['Access']=0;$banMessage='Your account has been banned. Reason: '.$reason;$this->sendRaw($target,['warning',$banMessage]);$this->sendRaw($target,['popup','messagebox',$banMessage]);$this->sendRaw($target,['logoutWarning',$banMessage,'5']);$target->kickReason='ban: '.$reason;$target->kickGraceful=true;$target->kickAt=microtime(true)+5.5;}
            $this->log->warn('Panel ban enforced for '.$row['Name'].' | Reason: '.$reason);
            return ['ok'=>true,'message'=>$row['Name'].' was banned'.($target?' and disconnected.':'.')];
        }

        if ($action === 'mute-player') {
            $userId=(int)($params['userId']??0);$minutes=max(1,min(1440,(int)($params['minutes']??5)));$reason=trim((string)($params['reason']??''));
            $target=$userId>0?$this->findUserByDbId($userId):null;if(!$target)return ['ok'=>false,'message'=>'Player is not online.'];
            $this->mute($target,$minutes);$this->sendRaw($target,['mute',$minutes*60000]);$msg='You were muted by staff for '.$minutes.' minute(s).'.($reason!==''?' Reason: '.substr($reason,0,250):'');$this->sendRaw($target,['warning',$msg]);
            $this->log->warn('Panel muted '.$target->username.' for '.$minutes.' minute(s)'.($reason!==''?' | Reason: '.$reason:''));return ['ok'=>true,'message'=>$target->username.' muted for '.$minutes.' minute(s).'];
        }
        if ($action === 'unmute-player') {
            $userId=(int)($params['userId']??0);$target=$userId>0?$this->findUserByDbId($userId):null;if(!$target)return ['ok'=>false,'message'=>'Player is not online.'];
            $this->unmute($target);$this->sendRaw($target,['unmute']);$this->sendRaw($target,['server','You have been unmuted by staff.']);$this->log->info('Panel unmuted '.$target->username);return ['ok'=>true,'message'=>$target->username.' was unmuted.'];
        }
        if ($action === 'set-access') {
            $userId=(int)($params['userId']??0);$access=(int)($params['access']??-1);$source=trim((string)($params['source']??'web player panel'));
            return $this->router->setPlayerAccess($userId,$access,$source!==''?$source:'web player panel');
        }
        if ($action === 'give-item') {
            $userId=(int)($params['userId']??0);$itemId=(int)($params['itemId']??0);$quantity=max(1,(int)($params['quantity']??1));
            return $this->router->grantItemToPlayer($userId,$itemId,$quantity,'web player panel');
        }

        if ($action === 'reload-data') {
            $this->world->reload();
            $this->log->info('Panel reloaded emulator database cache.');
            return ['ok'=>true,'message'=>'Database-backed emulator data reloaded.'];
        }

        if ($action === 'safe-shutdown') {
            $seconds = max(10, min(3600, (int)($params['seconds'] ?? $this->config->get('safe_shutdown_seconds', 300))));
            if(!$this->scheduleShutdown($seconds,'web control panel'))return ['ok'=>false,'message'=>'A shutdown or restart countdown is already active.'];
            return ['ok'=>true,'message'=>'Safe shutdown countdown started for '.$seconds.' seconds.'];
        }

        if ($action === 'cancel-shutdown') {
            if(!$this->cancelShutdown())return ['ok'=>false,'message'=>'There is no shutdown countdown to cancel.'];
            $this->log->info('Safe shutdown cancelled from web control panel.');
            return ['ok'=>true,'message'=>'Safe shutdown cancelled.'];
        }

        if ($action === 'restart') {
            $this->requestRestart();
            return ['ok'=>true,'message'=>'Emulator restart requested.'];
        }

        if ($action === 'stop') {
            $this->intentionalStop('web control panel RPC');
            $this->running = false;
            return ['ok'=>true,'message'=>'Emulator stop requested.'];
        }

        return ['ok'=>false,'message'=>'Unknown emulator RPC action: '.$action];
    }

    private function repairStalePresence(): void
    { try{$this->db->run("UPDATE users SET CurrentServer='Offline' WHERE CurrentServer=?",[(string)$this->config->get('server_name','Aera')]);}catch(Throwable $e){$this->log->warn('Could not repair stale player presence: '.$e->getMessage());} }

    private function sendScheduledServerMessage(): void
    { $message=$this->world->randomServerMessage();if($message!==null){$this->broadcastRaw(['moderator',$message]);$this->log->info('Scheduled server message: '.$message);} }

    private function isRequestFlood(ClientSession $u,string $request,array $params=[]): bool
    {
        // Expedition state transitions require repeated cmd requests. Apply a dedicated rate limit.
        if($request==='cmd'&&in_array(strtolower(trim((string)($params[0]??''))),['expedition','gauntlet'],true)){
            $now=microtime(true)*1000;if($now-$u->lastExpeditionRequestMs<300)return true;
            $u->lastExpeditionRequestMs=$now;return false;
        }
        // The Rift panel polls while idle. Only this read-only subcommand gets
        // a separate throttle; exempting all "cmd" requests would permit abuse.
        if($request==='cmd'&&strtolower(trim((string)($params[0]??'')))==='rift'&&strtolower(trim((string)($params[1]??'')))==='panel'){
            $panelNow=microtime(true)*1000;
            if($panelNow-$u->lastRiftPanelRequestMs<500)return true;
            $u->lastRiftPanelRequestMs=$panelNow;
            return false;
        }
        $now=microtime(true)*1000;$exceptions=(array)$this->config->get('antiflood_request_exceptions',[]);$except=in_array($request,['spendStatPoints','saveStatPoints','resetStatPoints'],true)||in_array($request,$exceptions,true);$filtered=false;
        if(!$except&&$u->lastRequestMs+(float)$this->config->get('antiflood_request_minimum_ms',500)>$now){$u->requestCounter++;if($u->requestCounter>=(int)$this->config->get('antiflood_request_tolerance',3)){$u->requestWarnings++;$u->requestCounter=0;$filtered=true;}}
        else $u->requestCounter=0;
        if(!$except&&(bool)$this->config->get('antiflood_request_repeat_enabled',true)){
            if($request===$u->lastRequest){$u->repeatedRequestCounter++;if($u->repeatedRequestCounter>=(int)$this->config->get('antiflood_request_max_repeated',2)){$u->requestWarnings++;$u->repeatedRequestCounter=0;$filtered=true;}}
            else{$u->repeatedRequestCounter=0;$u->lastRequest=$request;}
        }
        $u->lastRequestMs=$now;
        if($u->requestWarnings>=(int)$this->config->get('antiflood_request_warnings',3)){$this->log->warn('Request flood disconnect: '.$u->username.' request='.$request);$this->disconnect($u,'request flood');return true;}
        if($filtered)$this->log->warn('Request flood filtered: '.$u->username.' request='.$request.' warnings='.$u->requestWarnings);
        return $filtered;
    }

    public function applyMessageFlood(ClientSession $u,string $message): void
    {
        $now=microtime(true)*1000;
        if($u->lastMessageMs+(float)$this->config->get('antiflood_message_minimum_ms',1000)>=$now){$u->messageFloodCounter++;if($u->messageFloodCounter>=(int)$this->config->get('antiflood_message_tolerance',3)){$u->messageFloodWarnings++;$u->messageFloodCounter=0;$this->sendRaw($u,['warning','Please do not flood the server with messages.']);}}else$u->messageFloodCounter=0;
        if($message===$u->lastMessage){$u->repeatedMessageCounter++;if($u->repeatedMessageCounter>=(int)$this->config->get('antiflood_message_max_repeated',3)){$u->messageFloodWarnings++;$u->repeatedMessageCounter=0;$this->sendRaw($u,['warning','Please do not flood the server with messages.']);}}else{$u->repeatedMessageCounter=0;$u->lastMessage=$message;}
        if($u->messageFloodWarnings>=(int)$this->config->get('antiflood_message_warnings',3)){$u->muteUntil=microtime(true)+120;$u->messageFloodWarnings=0;$this->sendRaw($u,['warning','You have been muted for 2 minutes for flooding.']);}
        $u->lastMessageMs=$now;
    }

    public function mute(ClientSession $u,int $minutes): void { $this->muteSeconds($u,max(1,$minutes)*60); }
    public function muteSeconds(ClientSession $u,int $seconds): void { $u->muteUntil=max($u->muteUntil,microtime(true)+max(1,$seconds)); }
    public function unmute(ClientSession $u): void { $u->muteUntil=0.0; }
    public function muteMessage(ClientSession $u): string { $s=max(0,(int)ceil($u->muteUntil-microtime(true)));return 'You are muted for another '.$s.' second'.($s===1?'':'s').'.'; }
    public function isMuted(ClientSession $u): bool { return $u->muteUntil>microtime(true); }

    private function markServer(bool $online): void { try{$this->db->run('UPDATE servers SET Online=?,Count=0,Port=? WHERE Name=?',[$online?1:0,(int)$this->config->get('port',5589),(string)$this->config->get('server_name','Aera')]);}catch(Throwable $e){$this->log->warn('Could not update server state: '.$e->getMessage());} }
    private function updateCount(): void { try{$count=0;foreach($this->clients as $c)if($c->authenticated)$count++;$this->db->run('UPDATE servers SET Count=?,Online=1 WHERE Name=?',[$count,(string)$this->config->get('server_name','Aera')]);}catch(Throwable){} }
    private function writePid(): void { @mkdir($this->config->root().'/runtime',0775,true);@file_put_contents($this->config->root().'/runtime/emulator.pid',(string)getmypid());@file_put_contents($this->config->root().'/runtime/status.json',json_encode(['pid'=>getmypid(),'started'=>date(DATE_ATOM),'port'=>(int)$this->config->get('port',5589)])); }
    private function healthByLevel(int $level): int { return $this->math->healthByLevel($level); }
    private function manaByLevel(int $level): int { return $this->math->manaByLevel($level); }
}
