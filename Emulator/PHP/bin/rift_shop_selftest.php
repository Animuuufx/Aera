<?php
declare(strict_types=1);
require dirname(__DIR__).'/src/Autoload.php';
use AeraEmu\{Database,ClientSession,RiftShop};
class InGameShopPDO extends PDO {
    public function prepare(string $query,array $options=[]): PDOStatement|false { return parent::prepare(str_replace(' FOR UPDATE','',$query),$options); }
}
$pdo=new InGameShopPDO('sqlite::memory:');$pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE,PDO::FETCH_ASSOC);$pdo->sqliteCreateFunction('NOW',fn()=>date('Y-m-d H:i:s'));
$pdo->exec('CREATE TABLE users(id INTEGER PRIMARY KEY,SlotsBag INTEGER,Access INTEGER);
CREATE TABLE items(id INTEGER PRIMARY KEY,Name TEXT,Stack INTEGER,EnhID INTEGER,Equipment TEXT,Staff INTEGER,Upgrade INTEGER,Level INTEGER,FactionID INTEGER,ReqReputation INTEGER);
CREATE TABLE users_items(id INTEGER PRIMARY KEY,UserID INTEGER,ItemID INTEGER,EnhID INTEGER,Equipped INTEGER,Quantity INTEGER,Bank INTEGER,Wear INTEGER,DatePurchased TEXT);
CREATE TABLE users_rifts(UserID INTEGER PRIMARY KEY,Shards INTEGER);
CREATE TABLE rift_shop(id INTEGER PRIMARY KEY,ItemID INTEGER,Cost INTEGER,Quantity INTEGER,Enabled INTEGER);
CREATE TABLE rift_purchases(Token TEXT PRIMARY KEY,UserID INTEGER,ShopID INTEGER,Cost INTEGER);
CREATE TABLE users_factions(UserID INTEGER,FactionID INTEGER,Reputation INTEGER);
INSERT INTO users VALUES(1,3,1);
INSERT INTO users_rifts VALUES(1,100);
INSERT INTO items VALUES(1,"Armor",3,7,"ar",0,0,1,0,0),(2,"Sword",1,1,"Weapon",0,0,1,0,0);
INSERT INTO rift_shop VALUES(1,1,20,1,1),(2,2,10,1,1);');
$db=(new ReflectionClass(Database::class))->newInstanceWithoutConstructor();(new ReflectionProperty(Database::class,'pdo'))->setValue($db,$pdo);
$shop=new RiftShop($db);$u=new ClientSession(null,1,'test');$u->dbId=1;$u->authenticated=true;$u->access=1;$u->riftShopToken=str_repeat('a',64);
$checks=0;
function check(bool $ok,string $message): void { global $checks;$checks++;if(!$ok)throw new RuntimeException($message); }
function rejected(callable $fn,string $message): void { try{$fn();}catch(RuntimeException){check(true,$message);return;}check(false,$message); }
$balance=fn()=>(int)$pdo->query('SELECT Shards FROM users_rifts WHERE UserID=1')->fetchColumn();
rejected(fn()=>$shop->buy($u,1,'forged'),'Reject unissued purchase token');
$shop->buy($u,1,str_repeat('a',64));check($balance()===80,'Debit wallet');check((int)$pdo->query('SELECT EnhID FROM users_items')->fetchColumn()===7,'Deliver configured item enhancement');check($u->riftShopToken==='','Consume successful token');
$u->riftShopToken=str_repeat('a',64);rejected(fn()=>$shop->buy($u,1,$u->riftShopToken),'Ledger blocks replays');check($balance()===80,'Replay does not debit');
$u->riftShopToken=str_repeat('b',64);$u->tradeTarget=2;rejected(fn()=>$shop->buy($u,1,$u->riftShopToken),'Reject purchases during trade');$u->tradeTarget=null;
$u->state=2;rejected(fn()=>$shop->buy($u,1,$u->riftShopToken),'Reject purchases during combat');$u->state=1;
$pdo->exec('UPDATE items SET Staff=1 WHERE id=2');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Enforce staff restriction');
$pdo->exec('UPDATE items SET Staff=0,Upgrade=1 WHERE id=2');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Enforce membership restriction');
$pdo->exec('UPDATE items SET Upgrade=0,Level=100 WHERE id=2');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Enforce level restriction');
$pdo->exec('UPDATE items SET Level=1,FactionID=2,ReqReputation=100 WHERE id=2');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Enforce reputation restriction');
$pdo->exec('UPDATE items SET FactionID=0 WHERE id=2; UPDATE rift_shop SET Cost=-1 WHERE id=2');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Reject negative cost');
$pdo->exec('UPDATE rift_shop SET Cost=1000 WHERE id=2');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Reject insufficient funds');
$pdo->exec('UPDATE rift_shop SET Cost=10 WHERE id=2; UPDATE users SET SlotsBag=1');rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Enforce bag capacity');
$pdo->exec('UPDATE users SET SlotsBag=3');
$pdo->exec("CREATE TRIGGER fail_purchase BEFORE INSERT ON rift_purchases BEGIN SELECT RAISE(ABORT,'test failure'); END");
rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Ledger failure rejects purchase');check($balance()===80&&(int)$pdo->query('SELECT COUNT(*) FROM users_items')->fetchColumn()===1,'Failed purchase rolls back wallet and inventory');
$pdo->exec('DROP TRIGGER fail_purchase');$shop->buy($u,2,$u->riftShopToken);check($balance()===70,'Retry after rollback succeeds');
$u->riftShopToken=str_repeat('c',64);rejected(fn()=>$shop->buy($u,2,$u->riftShopToken),'Enforce stack maximum');
$pdo->exec('ALTER TABLE items ADD COLUMN Type TEXT DEFAULT "Armor";
ALTER TABLE users_rifts ADD COLUMN RiftsClosed INTEGER DEFAULT 0;
ALTER TABLE users_rifts ADD COLUMN LegendaryClosed INTEGER DEFAULT 0;
ALTER TABLE users_rifts ADD COLUMN BossesDefeated INTEGER DEFAULT 0;
ALTER TABLE users_rifts ADD COLUMN HighestContribution INTEGER DEFAULT 0;
CREATE TABLE rift_rewards(EventID INTEGER,UserID INTEGER,Score INTEGER,Medal TEXT,Shards INTEGER,Damage INTEGER,Kills INTEGER,Objectives INTEGER);
CREATE TABLE rift_events(id INTEGER PRIMARY KEY,Map TEXT,Tier TEXT,Modifier TEXT,EndedAt TEXT);');
for($i=1;$i<=8;$i++){
    $pdo->exec("INSERT INTO rift_events VALUES($i,'test','Normal','Blood','2026-09-11')");
    $pdo->exec("INSERT INTO rift_rewards VALUES($i,".($i===8?2:1).",100,'Bronze',10,1000,1,2)");
}
$manager=(new ReflectionClass(AeraEmu\RiftManager::class))->newInstanceWithoutConstructor();
$server=(new ReflectionClass(AeraEmu\GameServer::class))->newInstanceWithoutConstructor();
foreach(['db'=>$db,'server'=>$server,'available'=>true] as $k=>$v)(new ReflectionProperty($manager,$k))->setValue($manager,$v);
$u->socket=fopen('php://temp','r+');
$readPanel=function(int $page)use($manager,$u):array {
    ftruncate($u->socket,0);rewind($u->socket);$manager->sendPanel($u,$page,0);rewind($u->socket);
    $packet=json_decode(trim(stream_get_contents($u->socket),"\0"),true,512,JSON_THROW_ON_ERROR);
    return $packet['b']['o'];
};
$packet=$readPanel(0);check(count($packet['history'])===6&&$packet['historyPages']===2,'History pagination');
check((int)$packet['totals']['Earned']===70&&(int)$packet['spent']===30,'Totals isolate the current user and include purchases');
check((int)$packet['wallet']['Shards']===70&&count($packet['shop'])===2,'Panel includes wallet and shop listings');
$token=$packet['token'];$packet=$readPanel(999);check(count($packet['history'])===1&&$packet['historyPage']===1,'Clamp history page to available records');check($packet['token']===$token,'Auto-refresh preserves pending purchase token');
$u->dbId=99;$packet=$readPanel(0);check($packet['wallet']['Shards']===0&&$packet['history']===[],'New players see zero balance and empty personal history');
fclose($u->socket);
echo "In-game Rift shop: {$checks} checks passed.\n";
