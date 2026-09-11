<?php
declare(strict_types=1);
require dirname(__DIR__).'/src/Autoload.php';
use AeraEmu\{RiftEvent,RiftManager,GameServer,Database,Config,Logger,WorldRepository,RoomState,ClientSession};

$checks=0;
function check(bool $condition,string $name): void { global $checks;$checks++;if(!$condition)throw new RuntimeException($name); }
$d=['id'=>1,'Name'=>'Test','Map'=>'test','Enabled'=>1,'InvaderID'=>1,'EliteID'=>2,'CrystalID'=>3,'CommanderID'=>4,'KillGoal'=>2,'CrystalGoal'=>1,'MaterialGoal'=>1,'DefenseSeconds'=>1,'DurationSeconds'=>300,'BaseShards'=>10];
$e=new RiftEvent($d,'Normal','Blood',1,100);
$e->damage(1,100);$e->damage(2,0);check(count($e->players)===1,'Zero damage does not earn participation');
$e->kill([1,1],'invader');check($e->kills===1&&$e->players[1]['kills']===1,'Kills count once per participant');
check($e->progress()===50&&!$e->ready(),'Invasion progress');$e->kill([1],'invader');check($e->ready(),'Invasion threshold');
$e->phase='objectives';$e->kill([1],'invader');check($e->deposit(1)===1&&$e->deposit(1)===0,'Materials cannot be deposited twice');
$e->kill([1],'crystal');check(!$e->ready(),'Defense gates commander');$e->defend([]);check($e->defense===0,'Empty defense does not progress');$e->defend([2]);check($e->ready(),'Objectives jointly gate commander');
check(RiftEvent::reward($e->players[2],10,1)['shards']>0,'Low level objective-only participation earns rewards');
check(RiftEvent::reward(['damage'=>0,'kills'=>0,'objectives'=>0],10,1)['shards']===0,'No idle reward');
check(RiftEvent::reward(['damage'=>PHP_INT_MAX,'kills'=>0,'objectives'=>0],10,1)['score']===10000,'Damage score is capped');
foreach([[100,0,'Bronze'],[1500,0,'Silver'],[5000,0,'Gold'],[15000,0,'Legendary']] as [$score,$unused,$medal])check(RiftEvent::reward(['damage'=>0,'kills'=>$score/100,'objectives'=>0],10,1)['medal']===$medal,'Contribution tier '.$medal);

// Actual manager integration, with an isolated SQLite database and only MySQL dialect translation.
// Production queries still run through the real Database transaction wrapper.
class RiftTestPDO extends PDO
{
    public function prepare(string $query,array $options=[]): PDOStatement|false
    {
        $query=str_replace(' FOR UPDATE','',$query);
        if(str_contains($query,'ON DUPLICATE KEY UPDATE')){
            $query=str_replace('ON DUPLICATE KEY UPDATE','ON CONFLICT(UserID) DO UPDATE SET',$query);
            $query=preg_replace('/VALUES\((\w+)\)/','excluded.$1',$query);
            $query=str_replace('GREATEST(','MAX(',$query);
        }
        return parent::prepare($query,$options);
    }
}
$pdo=new RiftTestPDO('sqlite::memory:');$pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE,PDO::FETCH_ASSOC);$pdo->sqliteCreateFunction('NOW',fn()=>date('Y-m-d H:i:s'));
$pdo->exec('CREATE TABLE rift_definitions (id INTEGER PRIMARY KEY,Name TEXT,Map TEXT,Enabled INTEGER,InvaderID INTEGER,EliteID INTEGER,CrystalID INTEGER,CommanderID INTEGER,KillGoal INTEGER,CrystalGoal INTEGER,MaterialGoal INTEGER,DefenseSeconds INTEGER,DurationSeconds INTEGER,BaseShards INTEGER);
CREATE TABLE rift_events (id INTEGER PRIMARY KEY AUTOINCREMENT,Server TEXT,DefinitionID INTEGER,Map TEXT,Tier TEXT,Modifier TEXT,Status TEXT DEFAULT "active",State TEXT,EndedAt TEXT);
CREATE TABLE rift_rewards (EventID INTEGER,UserID INTEGER,Score INTEGER,Medal TEXT,Shards INTEGER,Damage INTEGER,Kills INTEGER,Objectives INTEGER,PRIMARY KEY(EventID,UserID));
CREATE TABLE users_rifts (UserID INTEGER PRIMARY KEY,Shards INTEGER,RiftsClosed INTEGER,LegendaryClosed INTEGER,BossesDefeated INTEGER,HighestContribution INTEGER);');
$pdo->prepare('INSERT INTO rift_definitions VALUES ('.implode(',',array_fill(0,count($d),'?')).')')->execute(array_values($d));
function setProperty(object $o,string $p,mixed $v): void { (new ReflectionProperty($o,$p))->setValue($o,$v); }
function shellOf(string $class): object { return (new ReflectionClass($class))->newInstanceWithoutConstructor(); }
$db=shellOf(Database::class);setProperty($db,'pdo',$pdo);
$world=shellOf(WorldRepository::class);
$world->maps=['test'=>['id'=>1,'Name'=>'test','PvP'=>0,'File'=>'test.swf']];
foreach([1,2,3,4] as $id)$world->monsters[$id]=['id'=>$id,'Name'=>'Monster '.$id,'File'=>'monster.swf','Linkage'=>'Monster','Level'=>1,'Health'=>100,'Mana'=>10,'DPS'=>10,'Respawn'=>5,'Speed'=>2000,'DamageReduction'=>0,'Immune'=>0];
$world->mapMonsterRows=[1=>[1=>['MonsterID'=>1,'MonMapID'=>1,'Frame'=>'Enter','Aggresive'=>1]]];
$server=shellOf(GameServer::class);setProperty($server,'world',$world);
$room=new RoomState(1,'test-1',$world->maps['test'],$world->mapMonsters(1));
$room2=new RoomState(2,'test-2',$world->maps['test'],$world->mapMonsters(1));
$private=new RoomState(3,'test-1001',$world->maps['test'],$world->mapMonsters(1));
setProperty($server,'rooms',[1=>$room,2=>$room2,3=>$private]);
$config=new Config(dirname(__DIR__));$log=new Logger(sys_get_temp_dir().'/aera-rift-selftest.log');
$manager=shellOf(RiftManager::class);
foreach(['server'=>$server,'db'=>$db,'world'=>$world,'config'=>$config,'log'=>$log,'available'=>true,'serverName'=>'Test'] as $key=>$v)setProperty($manager,$key,$v);
$visitor=new ClientSession(null,2,'test');$visitor->authenticated=true;$visitor->frame='Enter';
function riftId(RoomState $room): int { foreach($room->monsters as $id=>$m)if(isset($m['riftId']))return $id;throw new RuntimeException('No Rift monster'); }
$start=function($modifier='Blood')use($manager,$visitor){
    $result=$manager->control('rift-start',['definition'=>1,'tier'=>'Normal','modifier'=>$modifier,'multiplier'=>1]);
    if($result['ok'])foreach([1,2] as $id){$visitor->roomId=$id;$visitor->frame='Enter';$manager->enterArea($visitor,'Enter');}
    return $result;
};
check(!$manager->control('rift-start',['definition'=>999])['ok'],'Unknown definitions rejected');
check(!$manager->control('rift-start',['definition'=>1,'multiplier'=>-1])['ok'],'Invalid multiplier rejected');
check($start()['ok'],'Configured event starts');check(!$start()['ok'],'Overlapping event rejected');
check(isset($room->meta['rift'])&&isset($room2->meta['rift'])&&!isset($private->meta['rift']),'Public rooms participate; private rooms untouched');
check(!isset($room->monsters[1])&&count($room->monsters)===2,'Native monsters removed while Rift is active');
check($room->monsters[riftId($room)]['riftSpawnSeed']>0,'Dynamic spawn includes shared random seed');
check($room->monsters[riftId($room)]['DPS']===13,'Blood damage multiplier');
$u=new ClientSession(null,1,'test');$u->dbId=42;$u->sfsUserId=7;
$m=&$room->monsters[riftId($room)];$manager->hit($u,$m,10000);$m['HP']=0;$manager->killed($m);
$saved=(new ReflectionProperty($manager,'event'))->getValue($manager);check($saved->players[42]['damage']===100,'Overkill contribution is clamped');
check($manager->control('rift-boss',[])['ok'],'Admin commander transition');
$m=&$room->monsters[riftId($room)];$manager->hit($u,$m,20);$m['HP']-=20;
check($room2->monsters[riftId($room2)]['HP']===$m['HP'],'Commander damage shared across rooms');
$manager->hit(null,$m,10,42);$m['HP']-=10;check($room2->monsters[riftId($room2)]['HP']===$m['HP'],'Disconnected DoT owner retains contribution and shared damage');
$manager->hit($u,$m,10000);$m['HP']=0;$manager->killed($m);
$manager->tick(microtime(true)+2);
check(!$manager->status()['active'],'Commander death completes event');
check((int)$pdo->query('SELECT COUNT(*) FROM rift_rewards')->fetchColumn()===1,'One persistent reward per user/event');
$balance=(int)$pdo->query('SELECT Shards FROM users_rifts')->fetchColumn();check($balance>0,'Offline participant wallet credited');
$manager->finish('closed');check((int)$pdo->query('SELECT Shards FROM users_rifts')->fetchColumn()===$balance,'Repeated completion never double credits');
check(!isset($room->meta['rift'])&&$room->monsters[1]['Name']==='Monster 1','Normal monsters restored');
check($start('Titan')['ok']&&$room->monsters[riftId($room)]['HPMax']===250,'Titan scales HP');
$manager->control('rift-stop',[]);check((int)$pdo->query('SELECT COUNT(*) FROM rift_rewards')->fetchColumn()===1,'Cancelled events pay no rewards');
check($start('Swift')['ok']&&$room->monsters[riftId($room)]['Speed']===1300,'Swift reduces attack interval');
$manager->tick(microtime(true)+1000);check(!$manager->status()['active'],'Expired event is cleaned up');
setProperty($manager,'lastTick',0);
check($start('Arcane')['ok'],'Arcane event starts');
$e=(new ReflectionProperty($manager,'event'))->getValue($manager);
$e->damage(42,20);$e->kill([42],'invader');$e->kill([42],'invader');
$manager->tick(microtime(true)+2);check($e->phase==='objectives','Combat kill goal advances to objectives');
check(count($room->monsters)===2,'Single-placement map receives crystal and material invader');
$u->authenticated=true;$u->roomId=$room->id;$u->frame='WrongCell';$room->clients=[1=>$u];
$e->kill([42],'invader');$manager->playerCommand($u,['deposit']);check($e->materials===0,'Remote material deposit rejected');
$u->frame='Enter';$manager->playerCommand($u,['deposit']);check($e->materials===1,'Material deposit in defense cell succeeds');
$e->kill([42],'crystal');$manager->tick(microtime(true)+4);check($e->phase==='commander','Completed crystals/materials/defense spawns commander');
$e->nextMechanic=0;$manager->tick(microtime(true)+6);check($e->strikeAt>0&&$u->hp===$u->hpMax,'Commander telegraphs before damage');
$u->frame='SafeCell';$manager->tick(microtime(true)+12);check($u->hp===$u->hpMax,'Leaving telegraphed cell avoids shockwave');
$u->frame='Enter';$e->nextMechanic=0;$manager->tick(microtime(true)+14);$manager->tick(microtime(true)+20);check($u->hp<$u->hpMax,'Remaining in telegraphed cell takes damage');
$room->clients=[];
// Inject a database failure mid-payout: the event and wallet must remain retryable.
$pdo->exec("CREATE TRIGGER reject_rift_reward BEFORE INSERT ON rift_rewards BEGIN SELECT RAISE(ABORT,'simulated storage outage'); END");
$before=(int)$pdo->query('SELECT Shards FROM users_rifts')->fetchColumn();
try{$manager->finish('closed');check(false,'Payout failure must throw');}catch(PDOException){}
check($manager->status()['active']&&(int)$pdo->query('SELECT Shards FROM users_rifts')->fetchColumn()===$before,'Failed payout rolls back wallet and retains active event');
$pdo->exec('DROP TRIGGER reject_rift_reward');$manager->finish('closed');check(!$manager->status()['active'],'Payout succeeds on retry');
setProperty($manager,'lastTick',0);$start();$e=(new ReflectionProperty($manager,'event'))->getValue($manager);$e->phase='objectives';$e->wardHp=1;
$manager->tick(microtime(true)+1);check(!$manager->status()['active'],'Undefended ward failure ends event');
$start();$activeId=$manager->status()['id'];$manager->recoverStartup();
check($pdo->query('SELECT Status FROM rift_events WHERE id='.(int)$activeId)->fetchColumn()==='interrupted','Startup recovery marks abandoned event interrupted');
$manager->finish('cancelled');
$world->mapMonsterRows=[];
check($start()['ok'],'Map without database monster placements supports Rifts');
$visitor->roomId=1;$visitor->frame='UnconfiguredForest';$manager->enterArea($visitor,$visitor->frame);
check(count($room->monsters)===4,'Runtime screen spawns enemies without premade cells');
$manager->enterArea($visitor,$visitor->frame);check(count($room->monsters)===4,'Repeated screen report is idempotent');
$manager->enterArea($visitor,'SpoofedCell');check(count($room->monsters)===4,'Remote screen report rejected');
$manager->finish('cancelled');check($room->monsters===[],'Empty native map restored on cancellation');
echo "Aera Rifts: {$checks} checks passed.\n";
