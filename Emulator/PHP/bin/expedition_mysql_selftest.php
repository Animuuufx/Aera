<?php
declare(strict_types=1);
/** Run only against a NEW EMPTY disposable database named *_expedition_test. */
require dirname(__DIR__).'/src/Autoload.php';
use AeraEmu\{Database,GameServer,WorldRepository,ExpeditionManager,ExpeditionRun,ClientSession,RoomState,Logger};
$dsn=getenv('AERA_EXPEDITION_TEST_DSN')?:'';
if(!preg_match('/dbname=[A-Za-z0-9_]+_expedition_test(?:;|$)/',$dsn))throw new RuntimeException('Set AERA_EXPEDITION_TEST_DSN to a disposable empty *_expedition_test database.');
$pdo=new PDO($dsn,getenv('AERA_EXPEDITION_TEST_USER')?:'root',getenv('AERA_EXPEDITION_TEST_PASSWORD')?:'',[
    PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false,
]);
if($pdo->query('SHOW TABLES')->fetch())throw new RuntimeException('Test database must be empty; no existing data will be modified.');
$pdo->exec('CREATE TABLE users (id INT PRIMARY KEY,Name VARCHAR(64));
CREATE TABLE maps (id INT PRIMARY KEY,Name VARCHAR(64),PvP INT,Staff INT,Upgrade INT,ReqLevel INT,ReqParty INT);
CREATE TABLE maps_monsters (MapID INT);
INSERT INTO users VALUES(1,"Alpha"),(2,"Beta");
INSERT INTO maps VALUES(1,"arena",0,0,0,1,0),(2,"staff",0,1,0,1,0);
INSERT INTO maps_monsters VALUES(1),(2);');
$migration=file_get_contents(dirname(__DIR__,3).'/Database/patches/v30_82_expeditions.sql');
$pdo->exec($migration);$pdo->exec($migration);
$checks=0;
function check(bool $value,string $message): void { global $checks;$checks++;if(!$value)throw new RuntimeException($message); }
function set(object $object,string $key,mixed $value): void { (new ReflectionProperty($object,$key))->setValue($object,$value); }
function call(object $object,string $method,mixed ...$args): mixed { return (new ReflectionMethod($object,$method))->invoke($object,...$args); }
check($pdo->query('SELECT COUNT(*) FROM expedition_maps')->fetchColumn()===1,'Migration rerunnable and staff maps excluded');
$db=(new ReflectionClass(Database::class))->newInstanceWithoutConstructor();set($db,'pdo',$pdo);
$server=(new ReflectionClass(GameServer::class))->newInstanceWithoutConstructor();
$world=(new ReflectionClass(WorldRepository::class))->newInstanceWithoutConstructor();
$manager=(new ReflectionClass(ExpeditionManager::class))->newInstanceWithoutConstructor();
$log=new Logger(sys_get_temp_dir().'/aera-expedition-test.log');
foreach(['db'=>$db,'server'=>$server,'world'=>$world,'available'=>true,'serverName'=>'Test','log'=>$log] as $key=>$value)set($manager,$key,$value);
$server->expeditions=$manager;
$u=new ClientSession(fopen('php://temp','r+'),1,'test');$u->authenticated=true;$u->dbId=1;$u->username='Alpha';$u->sfsUserId=1;
set($server,'clients',[1=>$u]);
function makeRun(int $id,string $mode='solo'): ExpeditionRun
{
    global $pdo,$manager;
    $r=new ExpeditionRun($id,$mode,'seed',ExpeditionRun::week(),1);$r->members=[1=>'Alpha',2=>'Beta'];$r->bank=33;$r->cleared=3;
    $pdo->prepare('INSERT INTO expedition_runs (id,Server,Mode,Seed,WeekKey) VALUES (?,"Test",?,"seed",?)')->execute([$id,$mode,$r->week]);
    set($manager,'runs',[$id=>$r]);set($manager,'byUser',[1=>$id,2=>$id]);return $r;
}
$r=makeRun(1);call($manager,'finish',$r,'cashed_out');call($manager,'finish',$r,'cashed_out');
check((int)$pdo->query('SELECT SUM(Marks) FROM users_expeditions')->fetchColumn()===66,'Exactly one payout per member including offline member');
check((int)$pdo->query('SELECT COUNT(*) FROM expedition_rewards')->fetchColumn()===2,'Duplicate settlement does not duplicate ledger');
check($manager->runFor($u)===null,'Run membership cleared after settlement');
$r=makeRun(2);$pdo->exec("CREATE TRIGGER reject_reward BEFORE INSERT ON expedition_rewards FOR EACH ROW BEGIN IF NEW.UserID=2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Injected second-member ledger failure'; END IF; END");
try{call($manager,'finish',$r,'defeated');throw new LogicException('Expected rollback');}catch(PDOException){}
check((int)$pdo->query('SELECT SUM(Marks) FROM users_expeditions')->fetchColumn()===66,'Failed transaction leaves wallets unchanged');
check($pdo->query('SELECT Status FROM expedition_runs WHERE id=2')->fetchColumn()==='active','Failed transaction leaves run unsettled');
check($manager->runFor($u)===$r&&$r->settlement==='defeated','Failure retains frozen outcome for retry');
$pdo->exec('DROP TRIGGER reject_reward');call($manager,'finish',$r,'cashed_out');
check((int)$pdo->query('SELECT SUM(Marks) FROM users_expeditions')->fetchColumn()===98,'Retry keeps defeat payout rather than upgrading to cashout');
$r=makeRun(3,'weekly');$r->members=[1=>'Alpha'];$r->cleared=5;call($manager,'finish',$r,'cashed_out');
$r=makeRun(4,'weekly');$r->members=[1=>'Alpha'];$r->cleared=2;call($manager,'finish',$r,'defeated');
check((int)$pdo->query('SELECT Depth FROM expedition_weekly WHERE UserID=1')->fetchColumn()===5,'Weekly keeps best depth');
$r=makeRun(5,'weekly');$r->members=[1=>'Alpha'];$r->cleared=6;call($manager,'finish',$r,'defeated');
check((int)$pdo->query('SELECT RunID FROM expedition_weekly WHERE UserID=1')->fetchColumn()===5,'Weekly replaces best record');
$r=makeRun(6);$manager->recoverStartup();
check($pdo->query('SELECT Status FROM expedition_runs WHERE id=6')->fetchColumn()==='interrupted','Startup invalidates crashed run');
check((int)$pdo->query('SELECT COUNT(*) FROM expedition_rewards WHERE RunID=6')->fetchColumn()===0,'Crash recovery creates no phantom reward');
// Real manager combat hooks, temporary effects and outsider admission.
$r=makeRun(7);$r->members=[1=>'Alpha'];$r->roomId=321;$r->phase='combat';$r->blessings=[1=>['bloodlust'=>2,'ward'=>2,'vampiric'=>2]];
$u->roomId=321;$u->hp=100;
$room=new RoomState(321,'arena-exp7',['MaxPlayers'=>4],[],['expedition'=>7,'expeditionMembers'=>[1=>true]]);$room->clients=[1=>$u];set($server,'rooms',[321=>$room]);
$damage=$manager->damage($u,['expeditionId'=>7,'HP'=>50,'HPMax'=>100],100);
check($damage===116&&$u->hp===102,'Vampiric heals from actual HP removed, not overkill');
check($manager->incoming($u,100)===88,'Incoming reduction applied in run');
$u->roomId=999;check($manager->damage($u,['expeditionId'=>7,'HP'=>50,'HPMax'=>100],100)===100&&$manager->incoming($u,100)===100,'All effects stop outside assigned room');
$outsider=new ClientSession(fopen('php://temp','r+'),3,'test');$outsider->dbId=3;
check(!call($server,'joinRoomState',$outsider,$room,'Enter','Spawn','arena'),'Guessed room name cannot grant admission');
$rift=(new ReflectionClass(AeraEmu\RiftManager::class))->newInstanceWithoutConstructor();
set($rift,'event',new AeraEmu\RiftEvent(['Map'=>'arena'],'Normal','Blood',1,microtime(true)));
check(!call($rift,'eligible',$room),'World Rift cannot overwrite expedition monsters');
$snapshot=[['map'=>['Name'=>'arena'],'monster'=>['HPMax'=>100]]];
$pdo->prepare('INSERT INTO expedition_weeks VALUES (?,?,?)')->execute([ExpeditionRun::week(),ExpeditionRun::VERSION,json_encode($snapshot)]);
check(call($manager,'weeklyContent',ExpeditionRun::week())===$snapshot,'Weekly snapshot reused without reading changed world data');
$u->roomId=321;$r->modifier='Mana Drought';$r->lastRegen=0;$u->mp=100;
$room->monsters=[1=>['HP'=>100]];$manager->tick(microtime(true));check($u->mp===98,'Mana Drought applies on tick');
$room->monsters=[1=>['HP'=>0]];$r->depth=1;$manager->tick(microtime(true));check($r->phase==='blessing'&&count($r->offers[1])===3,'Combat clear publishes three choices');
$u->roomId=999;$manager->tick(microtime(true));check($manager->runFor($u)===null,'Leaving assigned room terminates run');
// Exercise real room creation, stat reset, SmartFox packets and UI command transitions.
$pdo->exec('ALTER TABLE users ADD LastArea VARCHAR(128);
CREATE TABLE classes (ItemID INT,Category VARCHAR(8));
CREATE TABLE items (id INT,Equipment VARCHAR(20));
CREATE TABLE users_items (id INT,UserID INT,ItemID INT,Bank INT,Equipped INT,EnhID INT,EnhItemID INT);
CREATE TABLE users_stats (UserID INT,Strength INT,Intellect INT,Dexterity INT,Endurance INT,Wisdom INT,Luck INT);');
$map=['id'=>1,'Name'=>'arena','File'=>'arena.swf','MaxPlayers'=>10,'ReqLevel'=>1,'ReqParty'=>0,'Upgrade'=>0,'Staff'=>0,'PvP'=>0];
$world->maps=['arena'=>$map,'faroff'=>array_replace($map,['id'=>2,'Name'=>'faroff'])];
$world->monsters=[1=>['id'=>1,'Name'=>'Slime','File'=>'slime.swf','Linkage'=>'Slime','Level'=>1,'Health'=>100,'Mana'=>0,'DPS'=>10,'Respawn'=>2,'Speed'=>2000,'DamageReduction'=>0,'Immune'=>0]];
$world->mapMonsterRows=[1=>[['MonsterID'=>1,'MonMapID'=>1,'Frame'=>'Enter','Aggresive'=>0,'X'=>500,'Y'=>350]]];
foreach(['db'=>$db,'world'=>$world,'log'=>$log,'statsCalculator'=>new AeraEmu\StatsCalculator($db,$world)] as $key=>$value)set($server,$key,$value);
$u->state=1;$u->hp=100;$manager->command($u,['start','solo']);$r=$manager->runFor($u);
check($r!==null&&$r->phase==='combat'&&$u->roomId===$r->roomId,'Start command creates and joins private combat room');
check($u->hp===$u->hpMax&&$u->mp===$u->mpMax,'Real stat reset restores neutral vitals');
$room=$server->currentRoom($u);check(count($room->monsters)>=2,'Encounter contains generated monsters');
$manager->command($u,['cashout',$r->id,$r->depth]);check($manager->runFor($u)===$r,'Cashout rejected during combat');
foreach($room->monsters as &$monster){$monster['HP']=0;$monster['state']=0;}unset($monster);
$manager->tick(microtime(true));$offer=$r->offers[1][0];
$manager->command($u,['choose',$r->id,999,$offer]);check(isset($r->offers[1]),'Stale room mutation rejected');
$manager->command($u,['choose',$r->id,$r->depth,$offer]);check($r->phase==='decision','Valid choice moves to decision');
$oldRoom=$r->roomId;$manager->command($u,['continue',$r->id,$r->depth]);
check($r->depth===2&&$r->roomId!==$oldRoom&&$server->roomById($oldRoom)===null,'Continue creates next room and releases old room');
$room=$server->currentRoom($u);foreach($room->monsters as &$monster){$monster['HP']=0;$monster['state']=0;}unset($monster);
$manager->tick(microtime(true));$manager->command($u,['cashout',$r->id,$r->depth]);
check($manager->runFor($u)===null&&$u->roomName==='faroff-1','Cashout exits cleanly to normal map');
check((int)$pdo->query('SELECT Marks FROM expedition_rewards WHERE RunID='.$r->id)->fetchColumn()===16,'Two-room real run pays earned bank');
$u2=new ClientSession(fopen('php://temp','r+'),2,'test');$u2->authenticated=true;$u2->dbId=2;$u2->username='Beta';$u2->sfsUserId=2;
$u->partyId=$u2->partyId=77;set($server,'clients',[1=>$u,2=>$u2]);
$manager->command($u,['start','party']);$r=$manager->runFor($u);check($r->phase==='lobby','Party starts in opt-in lobby');
$manager->command($u2,['join']);check(count($r->members)===2,'Party member opts into lobby');
$manager->command($u2,['launch',$r->id,0]);check($r->phase==='lobby','Nonleader cannot launch');
$manager->command($u,['launch',$r->id,0]);check($u->roomId===$u2->roomId&&$r->phase==='combat','Party launches together');
$u2->hp=0;$u2->state=0;$manager->tick(microtime(true));check($manager->runFor($u)===$r,'One fallen teammate is not a wipe');
$room=$server->currentRoom($u);foreach($room->monsters as &$monster){$monster['HP']=0;$monster['state']=0;}unset($monster);
$manager->tick(microtime(true));check($u2->hp>0&&$u2->state===1,'Surviving room clear revives fallen teammate');
$manager->command($u2,['cashout',$r->id,$r->depth]);check($manager->runFor($u)===null&&$manager->runFor($u2)===null,'Any member may cash out the party');
check((int)$pdo->query('SELECT SUM(Marks) FROM expedition_rewards WHERE RunID='.$r->id)->fetchColumn()===14,'Party receives equal full bank payout');
$manager->command($u,['start','endless']);$r=$manager->runFor($u);$u->hp=0;$u->state=0;$manager->tick(microtime(true));
check($manager->runFor($u)===null&&$pdo->query('SELECT Status FROM expedition_runs WHERE id='.$r->id)->fetchColumn()==='defeated','Solo wipe terminates endless run');
echo "Expedition MySQL integration: $checks checks passed on ".$pdo->getAttribute(PDO::ATTR_SERVER_VERSION).".\n";
