<?php
declare(strict_types=1);
namespace AeraEmu;

use RuntimeException;
use Throwable;

/** Server authority for admission, combat rooms, choices and exactly-once settlement. */
final class ExpeditionManager
{
    private bool $available;
    /** @var array<int,ExpeditionRun> */ private array $runs=[];
    private array $byUser=[], $pools=[];
    private string $serverName;
    public function __construct(private GameServer $server,private Database $db,private WorldRepository $world,Config $config,private Logger $log)
    {
        $this->serverName=(string)$config->get('server_name','Aera');
        $this->available=true;
        foreach(['expedition_maps','expedition_runs','expedition_rewards','users_expeditions','expedition_weekly','expedition_weeks','expedition_shop'] as $table)
            if(!$db->tableExists($table))$this->available=false;
    }
    public function recoverStartup(): void
    {
        if($this->available)$this->db->run("UPDATE expedition_runs SET Status='interrupted',EndedAt=UTC_TIMESTAMP() WHERE Server=? AND Status='active'",[$this->serverName]);
    }
    public function runFor(ClientSession $u): ?ExpeditionRun { return $this->runs[$this->byUser[$u->dbId]??0]??null; }
    public function inRoom(ClientSession $u): ?ExpeditionRun
    { $r=$this->runFor($u);return $r&&$r->roomId>0&&$r->roomId===$u->roomId?$r:null; }
    private function content(): array
    {
        $pool=[];
        foreach($this->db->all('SELECT Map FROM expedition_maps WHERE Enabled=1 ORDER BY Map') as $row){
            $map=$this->world->map((string)$row['Map']);
            if(!$map||(int)$map['PvP']||(int)$map['Staff']||(int)$map['Upgrade']||(int)$map['ReqLevel']>1||(int)$map['ReqParty'])continue;
            $placements=$this->world->mapMonsters((int)$map['id']);
            foreach($placements as $m)if($m['HPMax']>0&&$m['File']!=='')$pool[]=['map'=>$map,'monster'=>$m];
        }
        if(!$pool)throw new RuntimeException('No expedition maps are configured. Import v30_82_expeditions.sql and enable a public level-1 map with monster placements.');
        usort($pool,fn($a,$b)=>strcmp($a['map']['Name'],$b['map']['Name'])?:($a['monster']['MonMapID']<=>$b['monster']['MonMapID']));
        return $pool;
    }
    public function command(ClientSession $u,array $args): void
    {
        try{
            if(!$this->available)throw new RuntimeException('Expeditions require v30_82_expeditions.sql and an emulator restart.');
            $this->tick(microtime(true));
            $action=strtolower((string)($args[0]??'panel'));$r=$this->runFor($u);
            if($action==='start'){
                if($r)throw new RuntimeException('You already have an expedition.');
                $this->start($u,strtolower((string)($args[1]??'solo')));return;
            }
            if($action==='join'){$this->joinLobby($u);return;}
            if(in_array($action,['panel','status','leaderboard'],true)){$this->publishOne($u,$r);return;}
            if(!$r)throw new RuntimeException('Start an expedition first.');
            if($r->settlement!==null)throw new RuntimeException('Your reward settlement is pending. Please wait.');
            // Every mutation is tied to the displayed run AND room, so delayed clicks cannot affect a new room/run.
            if((int)($args[1]??0)!==$r->id||(int)($args[2]??-1)!==$r->depth)throw new RuntimeException('Expedition state changed. Refresh and try again.');
            if($action==='leave'){$this->finish($r,'abandoned');return;}
            if($action==='launch'){
                if($r->phase!=='lobby'||$r->leader!==$u->dbId)throw new RuntimeException('Only the expedition leader can launch the lobby.');
                $this->advance($r);return;
            }
            if($action==='choose'){$r->choose($u->dbId,(string)($args[3]??''));$this->publish($r);return;}
            if($action==='cashout'){
                if(!in_array($r->phase,['blessing','decision'],true))throw new RuntimeException('Clear the room before cashing out.');
                // Any member can protect the party bank. Continuing requires unanimity.
                $this->finish($r,'cashed_out');return;
            }
            if($action==='continue'){$r->vote($u->dbId);if(count($r->votes)===count($r->members))$this->advance($r);else$this->publish($r);return;}
            throw new RuntimeException('Unknown expedition command.');
        }catch(Throwable $e){
            $this->log->warn('Expedition command: '.$e->getMessage());
            $this->server->sendJson($u,['cmd'=>'expeditionError','message'=>$e instanceof RuntimeException?$e->getMessage():'Expedition request failed. Please retry.']);
        }
    }
    private function ready(ClientSession $u): void
    {
        if(!$u->authenticated||$u->hp<=0||$u->state!==1||$u->pvpQueued!==null||$u->pvpRoomId!==null||$u->tradeTarget!==null)
            throw new RuntimeException('Finish combat, PvP or trading before entering.');
    }
    private function weeklyContent(string $week): array
    {
        $snapshot=$this->db->scalar('SELECT Content FROM expedition_weeks WHERE WeekKey=? AND RulesVersion=?',[$week,ExpeditionRun::VERSION]);
        if($snapshot===null){
            $this->db->run('INSERT IGNORE INTO expedition_weeks (WeekKey,RulesVersion,Content) VALUES (?,?,?)',[$week,ExpeditionRun::VERSION,json_encode($this->content(),JSON_THROW_ON_ERROR)]);
            $snapshot=$this->db->scalar('SELECT Content FROM expedition_weeks WHERE WeekKey=? AND RulesVersion=?',[$week,ExpeditionRun::VERSION]);
        }
        $pool=json_decode((string)$snapshot,true,512,JSON_THROW_ON_ERROR);
        if(!$pool)throw new RuntimeException('Weekly content snapshot is empty.');
        return $pool;
    }
    private function start(ClientSession $u,string $mode): void
    {
        $this->ready($u);
        if($mode==='party'&&$u->partyId<=0)throw new RuntimeException('Create a game party first.');
        if($mode==='party')foreach($this->runs as $other)if($other->partyId===$u->partyId)throw new RuntimeException('Your party already has an expedition. Use Join party lobby.');
        $week=ExpeditionRun::week();
        $pool=$mode==='weekly'?$this->weeklyContent($week):$this->content();
        $seed=$mode==='weekly'?'weekly:'.ExpeditionRun::VERSION.':'.$week:bin2hex(random_bytes(16));
        $r=new ExpeditionRun(0,$mode,$seed,$week,$u->dbId,$mode==='party'?$u->partyId:0);
        $this->db->run('INSERT INTO expedition_runs (Server,Mode,Seed,WeekKey,RulesVersion) VALUES (?,?,?,?,?)',[$this->serverName,$mode,$seed,$week,ExpeditionRun::VERSION]);
        $r->id=(int)$this->db->lastInsertId();$r->members[$u->dbId]=$u->username;
        $this->runs[$r->id]=$r;$this->pools[$r->id]=$pool;$this->byUser[$u->dbId]=$r->id;
        if($mode==='party')$this->publish($r);else$this->advance($r);
    }
    private function joinLobby(ClientSession $u): void
    {
        $this->ready($u);
        if($this->runFor($u))throw new RuntimeException('You already have an expedition.');
        foreach($this->runs as $r)if($u->partyId>0&&$r->partyId===$u->partyId&&$r->phase==='lobby'){
            if(count($r->members)>=4)throw new RuntimeException('Expedition parties support at most four players.');
            $r->members[$u->dbId]=$u->username;$this->byUser[$u->dbId]=$r->id;$this->publish($r);return;
        }
        throw new RuntimeException('Your party has no open expedition lobby.');
    }
    private function advance(ExpeditionRun $r): void
    {
        foreach($r->members as $uid=>$name){$u=$this->server->findUserByDbId($uid);if(!$u)throw new RuntimeException('A member disconnected.');$this->ready($u);}
        $r->next();
        $pool=$this->pools[$r->id];$entry=$pool[$r->roll('room:'.$r->depth,count($pool))];$base=$entry['monster'];
        $r->frame=(string)$base['Frame'];
        $count=$r->kind==='Boss'?1:($r->modifier==='Swarm'?4:2);$monsters=[];
        $scale=(1+.18*($r->depth-1))*(1+.65*(count($r->members)-1))*($r->kind==='Boss'?3:($r->kind==='Elite'?1.6:1));
        for($i=1;$i<=$count;$i++){
            $m=$base;$m['MonMapID']=$i;$m['expeditionId']=$r->id;$m['Aggresive']=0;
            $m['HP']=$m['HPMax']=max(1,(int)min(2000000000,round($base['HPMax']*$scale*($r->modifier==='Titan'?2:1))));
            $m['DPS']=max(1,(int)min(100000000,round($base['DPS']*(1+.12*($r->depth-1))*($r->modifier==='Blood Moon'?1.3:($r->modifier==='Glass Cannon'?1.5:1)))));
            // Template skills can contain world-specific scripts; v1 encounters use normal attacks.
            $m['skills']=[];$m['Name']='Expedition '.$r->kind.': '.$base['Name'];
            // Database positioning permits multiple enemies even when the map has one timeline slot.
            $m['DBPosition']=true;$m['X']=max(40,min(900,(float)($m['X']??500)+($i-1)*65));$m['Y']=(float)($m['Y']??350);
            $monsters[$i]=$m;
        }
        $old=$r->roomId;$room=$this->server->createExpeditionRoom($entry['map'],$monsters,$r->id,array_keys($r->members));$r->roomId=$room->id;$r->moving=true;
        try{foreach($r->members as $uid=>$name){
            $u=$this->server->findUserByDbId($uid);if(!$u)continue;
            // A room boundary is a clean combat boundary; temporary blessings live only in the run.
            $this->server->resetExpeditionCombat($u);
            if(!$this->server->joinExpeditionRoom($u,$room,$r->frame))throw new RuntimeException('Expedition room admission failed.');
        }}finally{$r->moving=false;if($old)$this->server->releasePreparedRoomIfUnused($old);}
        $this->publish($r);
    }
    public function damage(?ClientSession $u,array $m,int $amount): int
    {
        if(!$u||$amount<=0)return $amount;$r=$this->inRoom($u);
        if(!$r||$r->phase!=='combat'||($m['expeditionId']??0)!==$r->id)return $amount;
        $amount=$r->outgoing($u->dbId,$amount,(int)$m['HP'],(int)$m['HPMax']);
        $heal=(int)floor(min($amount,max(0,(int)$m['HP']))*min(.1,.02*($r->blessings[$u->dbId]['vampiric']??0)));
        if($heal>0&&$u->hp>0){$u->hp=min($u->hpMax,$u->hp+$heal);$this->vitals($u);}
        return $amount;
    }
    public function incoming(ClientSession $u,int $amount): int { return $this->inRoom($u)?->incoming($u->dbId,$amount)??$amount; }
    private function vitals(ClientSession $u): void
    { $room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson(['cmd'=>'uotls','unm'=>$u->username,'o'=>['intHP'=>$u->hp,'intMP'=>$u->mp,'intState'=>$u->state]],$room); }
    public function tick(float $now): void
    {
        foreach($this->runs as $r){
            if($r->moving)continue;
            try{
                if($r->settlement!==null){$this->finish($r,$r->settlement);continue;}
                $alive=0;$missing=false;
                foreach($r->members as $uid=>$name){$u=$this->server->findUserByDbId($uid);if(!$u||($r->roomId&&$u->roomId!==$r->roomId)){$missing=true;continue;}if($u->hp>0)$alive++;}
                if($missing||!$alive||$now-$r->lastProgress>600||$now-$r->startedAt>14400){$this->finish($r,$missing?'abandoned':(!$alive?'defeated':'expired'));continue;}
                if($r->phase!=='combat')continue;
                $room=$this->server->roomById($r->roomId);if(!$room)continue;
                $living=array_filter($room->monsters,fn($m)=>$m['HP']>0);
                if(!$living){
                    $r->clear();
                    // Surviving a party room revives fallen teammates before the next choice.
                    foreach($room->clients as $u){$u->hp=max(1,$u->hp);$u->state=1;$u->respawnAt=0;$u->targetMonster=null;$u->dots=[];$this->vitals($u);}
                    if($r->finiteComplete()||$r->depth>=1000)$this->finish($r,'completed');else$this->publish($r);
                    continue;
                }
                if($now-$r->lastRegen>=1){
                    $r->lastRegen=$now;
                    foreach($room->clients as $u)if($u->hp>0){
                        $b=$r->blessings[$u->dbId]??[];$hp=$u->hp;$mp=$u->mp;
                        $u->hp=min($u->hpMax,$u->hp+(int)floor($u->hpMax*.01*min(5,$b['renewal']??0)));
                        $u->mp=min($u->mpMax,$u->mp+(int)floor($u->mpMax*.01*min(5,$b['reserve']??0)));
                        if($r->modifier==='Mana Drought')$u->mp=max(0,$u->mp-max(1,(int)ceil($u->mpMax*.02)));
                        if($hp!==$u->hp||$mp!==$u->mp)$this->vitals($u);
                    }
                }
            }catch(Throwable $e){$this->log->warn('Expedition tick: '.$e->getMessage());}
        }
    }
    private function finish(ExpeditionRun $r,string $status): void
    {
        // Freeze the outcome before touching the DB. An uncertain commit is retried with the same outcome.
        $r->settlement??=$status;$status=$r->settlement;
        $marks=$r->payout($status);$elapsed=min(2147483647,(int)round((microtime(true)-$r->startedAt)*1000));
        $this->db->tx(function(Database $db)use($r,$status,$marks,$elapsed){
            $row=$db->one('SELECT Status FROM expedition_runs WHERE id=? FOR UPDATE',[$r->id]);
            if(!$row)throw new RuntimeException('Expedition ledger is missing.');
            if($row['Status']!=='active')return;
            foreach($r->members as $uid=>$name){
                $db->run('INSERT INTO expedition_rewards (RunID,UserID,Marks) VALUES (?,?,?)',[$r->id,$uid,$marks]);
                $db->run('INSERT INTO users_expeditions (UserID,Marks,TotalEarned) VALUES (?,?,?) ON DUPLICATE KEY UPDATE Marks=Marks+VALUES(Marks),TotalEarned=TotalEarned+VALUES(TotalEarned)',[$uid,$marks,$marks]);
                if($r->mode==='weekly'&&$r->cleared>0){
                    $old=$db->one('SELECT Depth,ElapsedMs FROM expedition_weekly WHERE WeekKey=? AND RulesVersion=? AND UserID=? FOR UPDATE',[$r->week,ExpeditionRun::VERSION,$uid]);
                    if(!$old||$r->cleared>(int)$old['Depth']||($r->cleared===(int)$old['Depth']&&$elapsed<(int)$old['ElapsedMs']))
                        $db->run('INSERT INTO expedition_weekly (WeekKey,RulesVersion,UserID,Depth,ElapsedMs,RunID) VALUES (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE Depth=VALUES(Depth),ElapsedMs=VALUES(ElapsedMs),RunID=VALUES(RunID)',[$r->week,ExpeditionRun::VERSION,$uid,$r->cleared,$elapsed,$r->id]);
                }
            }
            $db->run('UPDATE expedition_runs SET Status=?,Depth=?,EndedAt=UTC_TIMESTAMP() WHERE id=?',[$status,$r->cleared,$r->id]);
        });
        unset($this->runs[$r->id],$this->pools[$r->id]);
        foreach($r->members as $uid=>$name){
            unset($this->byUser[$uid]);$u=$this->server->findUserByDbId($uid);if(!$u)continue;
            if($u->roomId===$r->roomId){$this->server->resetExpeditionCombat($u);$this->server->joinGameRoom($u,'faroff');}
            $this->publishOne($u,null,'Expedition '.$status.'. Earned '.$marks.' Marks.');
        }
        if($r->roomId)$this->server->releasePreparedRoomIfUnused($r->roomId);
    }
    private function publish(ExpeditionRun $r): void
    { foreach($r->members as $uid=>$name){$u=$this->server->findUserByDbId($uid);if($u)$this->publishOne($u,$r);} }
    public function shutdown(): void
    { foreach($this->runs as $r)try{$this->finish($r,'interrupted');}catch(Throwable $e){$this->log->warn('Expedition shutdown: '.$e->getMessage());} }
    private function publishOne(ClientSession $u,?ExpeditionRun $r,string $message=''): void
    {
        $wallet=$this->db->scalar('SELECT Marks FROM users_expeditions WHERE UserID=?',[$u->dbId],0);
        $leaders=$this->db->all('SELECT u.Name,w.Depth,w.ElapsedMs FROM expedition_weekly w INNER JOIN users u ON u.id=w.UserID WHERE w.WeekKey=? AND w.RulesVersion=? ORDER BY w.Depth DESC,w.ElapsedMs ASC,w.UserID ASC LIMIT 10',[ExpeditionRun::week(),ExpeditionRun::VERSION]);
        $offers=[];foreach($r?->offers[$u->dbId]??[] as $key)$offers[]=['key'=>$key,'text'=>ExpeditionRun::BLESSINGS[$key]];
        $this->server->sendJson($u,['cmd'=>'expeditionState','message'=>$message,'marks'=>$wallet,'week'=>ExpeditionRun::week(),'leaders'=>$leaders,
            'run'=>$r?['id'=>$r->id,'depth'=>$r->depth,'cleared'=>$r->cleared,'phase'=>$r->phase,'mode'=>$r->mode,'kind'=>$r->kind,'modifier'=>$r->modifier,
            'bank'=>$r->bank,'failureMarks'=>intdiv($r->bank,2),'leader'=>$r->leader===$u->dbId,'members'=>array_values($r->members),'votes'=>count($r->votes),
            'offers'=>$offers,'blessings'=>(object)($r->blessings[$u->dbId]??[])]:null]);
    }
}
