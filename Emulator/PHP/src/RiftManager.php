<?php
declare(strict_types=1);
namespace AeraEmu;

use RuntimeException;
use Throwable;

/** One shared Rift per emulator. Room copies use the same commander HP pool. */
final class RiftManager
{
    private ?RiftEvent $event=null;
    private int $id=0;
    private bool $available=false;
    private float $nextStart=0, $lastTick=0, $lastSave=0;
    private string $serverName;

    public function __construct(private GameServer $server,private Database $db,private WorldRepository $world,private Config $config,private Logger $log)
    {
        $this->serverName=(string)$config->get('server_name','Aera');
        $this->available=$db->tableExists('rift_events');
        $this->schedule();
    }
    public function recoverStartup(): void
    {
        if($this->available){
            // A crashed encounter is interrupted, never replayed or rewarded from stale combat state.
            $this->db->run("UPDATE rift_events SET Status='interrupted',EndedAt=NOW() WHERE Server=? AND Status='active'",[$this->serverName]);
        }
    }
    private function schedule(): void
    {
        $min=max(60,(int)$this->config->get('rift_min_interval',1800));
        $this->nextStart=microtime(true)+random_int($min,max($min,(int)$this->config->get('rift_max_interval',5400)));
    }
    public function status(): array
    {
        $e=$this->event;
        return ['cmd'=>'riftState','active'=>$e!==null,'available'=>$this->available,'id'=>$this->id,
            'map'=>$e?->definition['Map']??'','phase'=>$e?->phase??'idle','tier'=>$e?->tier??'',
            'modifier'=>$e?->modifier??'','progress'=>$e?->progress()??0,'players'=>count($e?->players??[]),
            'bossHp'=>$e?->bossHp??0,'bossMax'=>$e?->bossMax??0,
            'crystals'=>$e?->crystals??0,'crystalGoal'=>$e?->definition['CrystalGoal']??0,
            'materials'=>$e?->materials??0,'materialGoal'=>$e?->definition['MaterialGoal']??0,
            'defense'=>$e?->defense??0,'defenseGoal'=>$e?->definition['DefenseSeconds']??0,
            'wardHp'=>$e?->wardHp??100,'defenseFrame'=>$e?$this->defenseFrame():'' ];
    }
    private function defenseFrame(): string
    {
        $map=$this->world->map((string)$this->event->definition['Map']);
        $placements=$this->world->mapMonsters((int)$map['id']);$first=reset($placements);
        return (string)$first['Frame'];
    }
    public function control(string $action,array $p): array
    {
        try{
            if(!$this->available)throw new RuntimeException('Import v30_80_aera_rifts.sql and restart the emulator first.');
            if($action==='rift-start')$this->start((int)($p['definition']??0),(string)($p['tier']??'Normal'),(string)($p['modifier']??'Random'),(float)($p['multiplier']??1));
            elseif($action==='rift-stop'){$this->requireEvent();$this->finish('cancelled');}
            elseif($action==='rift-boss'){$this->requireEvent();if($this->event->phase!=='commander')$this->commander();}
            elseif($action==='rift-multiplier'){$this->requireEvent();$this->event->multiplier=$this->validMultiplier((float)($p['multiplier']??1));$this->save();}
            elseif($action!=='rift-status')throw new RuntimeException('Unknown Rift control.');
            return ['ok'=>true,'message'=>'Rift control applied.','data'=>$this->status()];
        }catch(Throwable $e){return ['ok'=>false,'message'=>$e->getMessage()];}
    }
    private function requireEvent(): void { if(!$this->event)throw new RuntimeException('No Rift is active.'); }
    private function validMultiplier(float $v): float
    { if(!is_finite($v)||$v<0.1||$v>10)throw new RuntimeException('Reward multiplier must be between 0.1 and 10.');return $v; }
    private function start(int $definition,string $tier,string $modifier,float $multiplier): void
    {
        if($this->event)throw new RuntimeException('A Rift is already active.');
        $d=$this->db->one('SELECT * FROM rift_definitions WHERE id=? AND Enabled=1',[$definition]);
        if(!$d)throw new RuntimeException('Choose an enabled Rift definition.');
        $map=$this->world->map((string)$d['Map']);
        if(!$map||(int)($map['PvP']??0)!==0||(int)($map['Staff']??0)!==0||!$this->world->mapMonsters((int)$map['id']))throw new RuntimeException('Rifts require a public non-PvP map with database monster placements.');
        foreach(['InvaderID','EliteID','CrystalID','CommanderID'] as $k)if(!isset($this->world->monsters[(int)$d[$k]]))throw new RuntimeException('Missing monster template: '.$k);
        foreach(['KillGoal','CrystalGoal','MaterialGoal','DefenseSeconds','DurationSeconds','BaseShards'] as $k)if((int)$d[$k]<1||(int)$d[$k]>100000)throw new RuntimeException('Invalid definition value: '.$k);
        if(!in_array($tier,['Normal','Heroic','Legendary'],true))throw new RuntimeException('Invalid Rift tier.');
        if($modifier==='Random'){$roll=random_int(1,1000);$modifier=$roll<=10?'Golden':RiftEvent::MODIFIERS[[0,1,2,3,5][random_int(0,4)]];}
        if(!in_array($modifier,RiftEvent::MODIFIERS,true))throw new RuntimeException('Invalid Rift modifier.');
        $e=new RiftEvent($d,$tier,$modifier,$this->validMultiplier($multiplier),microtime(true));
        $this->db->run('INSERT INTO rift_events (Server,DefinitionID,Map,Tier,Modifier,State) VALUES (?,?,?,?,?,?)',[$this->serverName,$definition,$d['Map'],$tier,$modifier,json_encode($e,JSON_THROW_ON_ERROR)]);
        $this->id=(int)$this->db->lastInsertId();$this->event=$e;
        foreach($this->server->rooms() as $room)$this->attach($room,true);
        $this->announce(($tier==='Legendary'?'LEGENDARY RIFT DETECTED! ':'').'A '.$modifier.' Rift has opened in '.$d['Map'].'! The city is under attack. Use /rift join.');
        $this->publish();
    }
    private function eligible(RoomState $room): bool
    {
        if(!$this->event||isset($room->meta['house'])||isset($room->meta['expedition'])||(int)($room->map['PvP']??0)!==0)return false;
        $parts=explode('-',$room->name,2);
        return strcasecmp($parts[0],(string)$this->event->definition['Map'])===0&&(int)($parts[1]??1)<=999;
    }
    public function attach(RoomState $room,bool $refresh=false): void
    {
        if(!$this->eligible($room)||isset($room->meta['rift']))return;
        $room->meta['rift']=['id'=>$this->id];
        $this->populate($room);
        if($refresh)$this->server->refreshRiftRoom($room);
    }
    private function populate(RoomState $room): void
    {
        $e=$this->event;if(!$e)return;
        $placements=$this->world->mapMonsters((int)$room->map['id']);$out=[];$i=0;
        foreach($placements as $id=>$placement){
            $role=$e->phase==='commander'&&$i===0?'commander':($e->phase==='objectives'&&$i%2===0?'crystal':'invader');
            $out[$id]=$this->enemy($placement,$role);$i++;
        }
        // Single-placement maps need material invaders and Commander adds too.
        if($e->phase!=='invasion'&&count($out)===1){
            $id=max(array_keys($out))+1;$placement=reset($placements);$placement['MonMapID']=$id;
            $out[$id]=$this->enemy($placement,'invader');
        }
        $room->monsters=$out;
    }
    private function enemy(array $placement,string $role): array
    {
            $e=$this->event;
            $key=$role==='commander'?'CommanderID':($role==='crystal'?'CrystalID':($e->progress()>=50?'EliteID':'InvaderID'));
            $t=$this->world->monsters[(int)$e->definition[$key]];
            $scale=($e->tier==='Legendary'?3:($e->tier==='Heroic'?1.7:1))*($e->modifier==='Titan'?2.5:1);
            $hp=max(1,(int)round((int)$t['Health']*$scale));
            if($role==='commander')$hp=$e->bossMax;
            return array_replace($placement,[
                'MonID'=>(int)$t['id'],'Name'=>'Rift '.($role==='commander'?'Commander: ':'').$t['Name'],
                'File'=>$t['File'],'Linkage'=>$t['Linkage'],'Level'=>(int)$t['Level'],
                'HP'=>$role==='commander'?$e->bossHp:$hp,'HPMax'=>$hp,'MP'=>(int)$t['Mana'],'MPMax'=>(int)$t['Mana'],
                'DPS'=>max(1,(int)round((int)$t['DPS']*($e->modifier==='Blood'?1.3:1))),
                'Speed'=>max(1000,(int)round((int)$t['Speed']*($e->modifier==='Swift'?.65:1))),
                'DamageReduction'=>(float)$t['DamageReduction'],'Immune'=>(int)$t['Immune'],
                'Respawn'=>5,'skills'=>$this->world->monsterSkills[(int)$t['id']]??[],
                'riftId'=>$this->id,'riftRole'=>$role,'riftHitters'=>[],
            ]);
    }
    private function rebuild(): void
    { foreach($this->server->rooms() as $r)if(isset($r->meta['rift'])){$this->populate($r);$this->server->refreshRiftRoom($r);} $this->save();$this->publish(); }

    /** Called before HP subtraction, for both direct hits and DoTs. */
    public function hit(?ClientSession $u,array &$m,int $amount,int $sourceUserId=0): void
    {
        $e=$this->event;
        if(!$e||($m['riftId']??0)!==$this->id||$amount<=0)return;
        $userId=$u?->dbId??$sourceUserId;
        $amount=min($amount,max(0,(int)$m['HP']));
        if(($m['riftRole']??'')==='commander'){
            $amount=min($amount,$e->bossHp);$e->bossHp=max(0,$e->bossHp-$amount);
            // The calling combat path subtracts its own hit after this hook.
            foreach($this->server->rooms() as $room)foreach($room->monsters as &$other)if(($other['riftId']??0)===$this->id&&($other['riftRole']??'')==='commander')$other['HP']=$e->bossHp;unset($other);
            $m['HP']=$e->bossHp+$amount;
        }
        $e->damage($userId,$amount);
        if($amount>0&&$userId>0)$m['riftHitters'][$userId]=true;
    }
    public function killed(array &$m): void
    {
        if(!$this->event||($m['riftId']??0)!==$this->id)return;
        $this->event->kill(array_keys($m['riftHitters']??[]),(string)$m['riftRole']);$m['riftHitters']=[];
        if($m['riftRole']==='commander')$m['respawnAt']=0;
    }
    public function tick(float $now): void
    {
        if(!$this->available||$now-$this->lastTick<1)return;
        $this->lastTick=$now;
        try{
            if(!$this->event){
                if($now>=$this->nextStart&&(bool)$this->config->get('rifts_enabled',true)){
                    $this->schedule();$online=array_filter($this->server->clients(),fn($c)=>$c->authenticated);
                    if($online){$defs=$this->db->all('SELECT id FROM rift_definitions WHERE Enabled=1');if($defs)$this->start((int)$defs[array_rand($defs)]['id'],random_int(1,100)<=2?'Legendary':'Normal','Random',1);}
                }return;
            }
            $e=$this->event;
            if($e->phase==='commander'&&$e->bossHp<=0){$this->finish('closed');return;}
            if($now>=$e->startedAt+(int)$e->definition['DurationSeconds']){$this->finish('expired');return;}
            $defenders=[];
            foreach($this->server->rooms() as $r){
                if(!isset($r->meta['rift']))continue;
                $first=reset($r->monsters);$frame=(string)($first['Frame']??'Enter');
                foreach($r->clients as $u)if($u->authenticated&&$u->hp>0&&$u->frame===$frame)$defenders[]=$u->dbId;
                foreach($r->monsters as $id=>&$m){
                    if(($m['riftRole']??'')==='commander')$m['HP']=$e->bossHp;
                    if($m['state']===0)continue;
                    if($e->phase==='objectives'&&$m['riftRole']==='invader'&&$m['Frame']===$frame){
                        foreach($r->clients as $u)if($u->authenticated&&$u->hp>0&&$u->frame===$frame)$m['targets'][$u->socketId]=true;
                    }
                    if($e->modifier==='Arcane'&&$now-(float)($m['riftRegen']??0)>=10&&($m['riftRole']??'')!=='commander'){$m['HP']=min($m['HPMax'],$m['HP']+max(1,(int)($m['HPMax']*.03)));$m['MP']=$m['MPMax'];$m['riftRegen']=$now;}
                    $this->server->broadcastJson(['cmd'=>'mtls','id'=>$id,'o'=>['intHP'=>$m['HP'],'intHPMax'=>$m['HPMax'],'intMP'=>$m['MP']]],$r);
                }unset($m);
            }
            $e->defend($defenders);
            if($e->phase==='objectives'&&!$defenders&&$e->defense<(int)$e->definition['DefenseSeconds']){
                $e->wardHp=max(0,$e->wardHp-1);
                if($e->wardHp===0){$this->finish('failed');return;}
            }
            if($e->ready()){
                if($e->phase==='invasion'){$e->phase='objectives';$this->announce('Rift objectives: destroy crystals, collect invader materials and use /rift deposit in the defense cell. Hold that cell to protect its ward!');$this->rebuild();}
                else $this->commander();
            }
            // Upgrade remaining invasion waves once the shared meter reaches 50%.
            if($e->phase==='invasion'&&$e->progress()>=50){foreach($this->server->rooms() as $r)if(isset($r->meta['rift'])&&empty($r->meta['rift']['elite'])){$r->meta['rift']['elite']=true;$this->populate($r);$this->server->refreshRiftRoom($r);}}
            if($e->phase==='commander')$this->mechanics($now);
            if($now-$this->lastSave>=5){$this->save();$this->lastSave=$now;}
            $this->publish();
        }catch(Throwable $ex){$this->log->error('Rift tick: '.$ex->getMessage());}
    }
    private function commander(): void
    {
        $e=$this->event;if(!$e)return;$e->phase='commander';
        $base=(int)$this->world->monsters[(int)$e->definition['CommanderID']]['Health'];
        $e->bossMax=max(1,(int)round($base*(1+.35*max(0,count($e->players)-1))*($e->tier==='Legendary'?3:($e->tier==='Heroic'?1.7:1))*($e->modifier==='Titan'?2.5:1)));
        $e->bossHp=$e->bossMax;$e->nextMechanic=microtime(true)+12;
        $this->announce('The Rift Commander has appeared! Its health is shared across all public rooms.');$this->rebuild();
    }
    private function mechanics(float $now): void
    {
        $e=$this->event;if(!$e)return;
        if($e->strikeAt>0&&$now>=$e->strikeAt){
            foreach($this->server->rooms() as $r)if(isset($r->meta['rift']))foreach($r->clients as $u)if($u->hp>0&&$u->frame===$e->strikeFrame){
                $damage=max(1,(int)round($u->hpMax*($e->bossHp<$e->bossMax*.3?.45:.25)));
                $u->hp=max(0,$u->hp-$damage);if($u->hp===0){$u->state=0;$u->respawnAt=$now+10;$u->resting=false;}
                $this->server->broadcastJson(['cmd'=>'ct','p'=>[$u->username=>['intHP'=>$u->hp,'intState'=>$u->state]]],$r);
            }
            $e->strikeAt=0;
        }
        if($now<$e->nextMechanic)return;
        $placements=$this->world->mapMonsters((int)$this->world->map((string)$e->definition['Map'])['id']);
        $first=reset($placements);$e->strikeFrame=(string)$first['Frame'];$e->strikeAt=$now+5;
        $e->nextMechanic=$now+($e->modifier==='Corrupted'?12:20);
        foreach($this->server->rooms() as $r)if(isset($r->meta['rift']))$this->server->broadcastRaw(['warning','Rift shockwave in '.$e->strikeFrame.' in 5 seconds! Leave this cell to evade'.($e->bossHp<$e->bossMax*.3?' — Commander enraged!':'!')],$r);
    }
    public function playerCommand(ClientSession $u,array $args): void
    {
        $action=strtolower((string)($args[0]??'status'));
        if($action==='panel'){$this->sendPanel($u,(int)($args[1]??0),(int)($args[2]??0));return;}
        if($action==='buy'){
            try{
                if(!$this->available)throw new RuntimeException('Rifts are not installed yet.');
                (new RiftShop($this->db))->buy($u,(int)($args[1]??0),(string)($args[2]??''));
                $this->server->sendJson($u,['cmd'=>'riftPurchase','ok'=>true,'message'=>'Purchased! Your reward is in your inventory.']);
            }catch(Throwable $e){$this->server->sendJson($u,['cmd'=>'riftPurchase','ok'=>false,'message'=>$e instanceof RuntimeException&&!($e instanceof \PDOException)?$e->getMessage():'Purchase failed. Refresh the shop and try again.']);}
            $this->sendPanel($u,(int)($args[3]??0),(int)($args[4]??0));return;
        }
        if($action==='join'&&$this->event){$this->server->joinGameRoom($u,(string)$this->event->definition['Map']);return;}
        if($action==='deposit'&&$this->event){
            $r=$this->server->currentRoom($u);$first=$r?reset($r->monsters):false;
            if($r&&isset($r->meta['rift'])&&$u->hp>0&&$u->frame===(string)($first['Frame']??'')){$n=$this->event->deposit($u->dbId);$this->server->sendRaw($u,['server','Deposited '.$n.' Rift materials.']);return;}
            $this->server->sendRaw($u,['warning','Travel to the Rift defense cell while alive to deposit materials.']);return;
        }
        $s=$this->status();$this->server->sendJson($u,$s);
        $wallet=$this->available?$this->db->one('SELECT * FROM users_rifts WHERE UserID=?',[$u->dbId]):null;
        $this->server->sendRaw($u,['server',($s['active']?$s['modifier'].' Rift: '.$s['map'].' | '.$s['phase'].' '.$s['progress'].'%. ':'No active Rift. ').'Rift Shards: '.(int)($wallet['Shards']??0).'. /rift join | /rift deposit | Shard shop: /rifts on the website.']);
    }
    public function sendPanel(ClientSession $u,int $historyPage=0,int $shopPage=0): void
    {
        if(!$this->available){$this->server->sendJson($u,['cmd'=>'riftPanel','available'=>false]);return;}
        $historyCount=(int)$this->db->scalar('SELECT COUNT(*) FROM rift_rewards WHERE UserID=?',[$u->dbId]);
        $shopCount=(int)$this->db->scalar('SELECT COUNT(*) FROM rift_shop s JOIN items i ON i.id=s.ItemID WHERE s.Enabled=1 AND s.Cost>0 AND s.Quantity>0');
        $historyPage=max(0,min($historyPage,max(0,(int)ceil($historyCount/6)-1)));
        $shopPage=max(0,min($shopPage,max(0,(int)ceil($shopCount/6)-1)));
        $wallet=$this->db->one('SELECT Shards,RiftsClosed,LegendaryClosed,BossesDefeated,HighestContribution FROM users_rifts WHERE UserID=?',[$u->dbId])??['Shards'=>0,'RiftsClosed'=>0,'LegendaryClosed'=>0,'BossesDefeated'=>0,'HighestContribution'=>0];
        $totals=$this->db->one('SELECT COALESCE(SUM(Damage),0) Damage,COALESCE(SUM(Kills),0) Kills,COALESCE(SUM(Objectives),0) Objectives,COALESCE(SUM(Shards),0) Earned FROM rift_rewards WHERE UserID=?',[$u->dbId]);
        $spent=(int)$this->db->scalar('SELECT COALESCE(SUM(Cost),0) FROM rift_purchases WHERE UserID=?',[$u->dbId]);
        $history=$this->db->all('SELECT r.Score,r.Medal,r.Shards,r.Damage,r.Kills,r.Objectives,e.Map,e.Tier,e.Modifier,e.EndedAt FROM rift_rewards r JOIN rift_events e ON e.id=r.EventID WHERE r.UserID=? ORDER BY r.EventID DESC LIMIT 6 OFFSET '.($historyPage*6),[$u->dbId]);
        $shop=$this->db->all('SELECT s.id,s.Cost,s.Quantity,i.Name,i.Type,i.Level FROM rift_shop s JOIN items i ON i.id=s.ItemID WHERE s.Enabled=1 AND s.Cost>0 AND s.Quantity>0 ORDER BY s.Cost,s.id LIMIT 6 OFFSET '.($shopPage*6));
        if($u->riftShopToken==='')$u->riftShopToken=bin2hex(random_bytes(32));
        $this->server->sendJson($u,['cmd'=>'riftPanel','available'=>true,'wallet'=>$wallet,'totals'=>$totals,'spent'=>$spent,
            'active'=>$this->status(),'contribution'=>$this->event?->players[$u->dbId]??['damage'=>0,'kills'=>0,'objectives'=>0,'materials'=>0],
            'history'=>$history,'historyPage'=>$historyPage,'historyPages'=>max(1,(int)ceil($historyCount/6)),
            'shop'=>$shop,'shopPage'=>$shopPage,'shopPages'=>max(1,(int)ceil($shopCount/6)),'token'=>$u->riftShopToken]);
    }
    private function save(): void
    { if($this->event)$this->db->run('UPDATE rift_events SET State=? WHERE id=? AND Status=\'active\'',[json_encode($this->event,JSON_THROW_ON_ERROR),$this->id]); }
    public function finish(string $status): void
    {
        $e=$this->event;if(!$e)return;
        $rewards=[];
        $this->db->tx(function(Database $db)use($e,$status,&$rewards){
            $row=$db->one('SELECT Status FROM rift_events WHERE id=? FOR UPDATE',[$this->id]);
            if(($row['Status']??'')!=='active')return;
            if($status==='closed')foreach($e->players as $userId=>$p){
                $mult=$e->multiplier*($e->modifier==='Golden'?5:($e->modifier==='Titan'?1.5:1))*($e->tier==='Legendary'?3:($e->tier==='Heroic'?1.5:1));
                $r=RiftEvent::reward($p,(int)$e->definition['BaseShards'],$mult);if(!$r['shards'])continue;
                $db->run('INSERT INTO rift_rewards (EventID,UserID,Score,Medal,Shards,Damage,Kills,Objectives) VALUES (?,?,?,?,?,?,?,?)',[$this->id,$userId,$r['score'],$r['medal'],$r['shards'],$p['damage'],$p['kills'],$p['objectives']]);
                $db->run('INSERT INTO users_rifts (UserID,Shards,RiftsClosed,LegendaryClosed,BossesDefeated,HighestContribution) VALUES (?,?,1,?,1,?) ON DUPLICATE KEY UPDATE Shards=Shards+VALUES(Shards),RiftsClosed=RiftsClosed+1,LegendaryClosed=LegendaryClosed+VALUES(LegendaryClosed),BossesDefeated=BossesDefeated+1,HighestContribution=GREATEST(HighestContribution,VALUES(HighestContribution))',[$userId,$r['shards'],$e->tier==='Legendary'?1:0,$r['score']]);$rewards[$userId]=$r;
            }
            $db->run('UPDATE rift_events SET Status=?,State=?,EndedAt=NOW() WHERE id=?',[$status,json_encode($e,JSON_THROW_ON_ERROR),$this->id]);
        });
        foreach($rewards as $id=>$r){$u=$this->server->findUserByDbId((int)$id);if($u)$this->server->sendRaw($u,['server',$r['medal'].' Contribution! Awarded '.$r['shards'].' Rift Shards.']);}
        $this->event=null;
        foreach($this->server->rooms() as $room)if(isset($room->meta['rift'])){
            $room->monsters=$this->world->mapMonsters((int)$room->map['id']);unset($room->meta['rift']);$this->server->refreshRiftRoom($room);
        }
        $this->announce('The Rift in '.$e->definition['Map'].' has ended: '.$status.'.');$this->publish();$this->schedule();
    }
    private function announce(string $message): void { $this->server->broadcastRaw(['server',$message]);$this->log->info($message); }
    private function publish(): void { $this->server->broadcastJson($this->status()); }
}
