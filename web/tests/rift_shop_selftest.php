<?php
declare(strict_types=1);
// Isolated controller test: real SQL/transactions, fake authentication/redirect boundary.
namespace Aera\Foundation {
    class Auth { public static function requireUser(): array { return ['id'=>1]; } }
    class Csrf { public static bool $valid=true;public static function verify($r): void { if(!self::$valid)throw new \RuntimeException('CSRF rejected'); } }
    class Session { public static array $messages=[];public static function flash($key,$message): void { self::$messages[$key]=$message; } }
    class Redirect extends \RuntimeException {}
    class Response { public static function redirect($url): never { throw new Redirect($url); } }
}
namespace {
    require dirname(__DIR__).'/app/Foundation/Database.php';
    require dirname(__DIR__).'/app/Foundation/Request.php';
    require dirname(__DIR__).'/app/Controllers/RiftController.php';
    use Aera\Foundation\{Database,Request,Csrf,Redirect,Session};
    use Aera\Controllers\RiftController;
    class ShopTestPDO extends PDO {
        public function prepare(string $query,array $options=[]): PDOStatement|false { return parent::prepare(str_replace(' FOR UPDATE','',$query),$options); }
    }
    $pdo=new ShopTestPDO('sqlite::memory:');$pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE,PDO::FETCH_ASSOC);$pdo->sqliteCreateFunction('NOW',fn()=>date('Y-m-d H:i:s'));
    (new ReflectionProperty(Database::class,'pdo'))->setValue(null,$pdo);
    $pdo->exec('CREATE TABLE users(id INTEGER PRIMARY KEY,SlotsBag INTEGER,CurrentServer TEXT,Access INTEGER);
        CREATE TABLE items(id INTEGER PRIMARY KEY,Stack INTEGER,EnhID INTEGER,Equipment TEXT);
        CREATE TABLE users_items(id INTEGER PRIMARY KEY AUTOINCREMENT,UserID INTEGER,ItemID INTEGER,EnhID INTEGER,Equipped INTEGER,Quantity INTEGER,Bank INTEGER,Wear INTEGER,DatePurchased TEXT);
        CREATE TABLE users_rifts(UserID INTEGER PRIMARY KEY,Shards INTEGER);
        CREATE TABLE rift_shop(id INTEGER PRIMARY KEY,ItemID INTEGER,Cost INTEGER,Quantity INTEGER,Enabled INTEGER);
        CREATE TABLE rift_purchases(Token TEXT PRIMARY KEY,UserID INTEGER,ShopID INTEGER,Cost INTEGER);
        INSERT INTO users VALUES(1,2,"Offline",1);
        INSERT INTO items VALUES(1,2,7,"ar"),(2,1,1,"Weapon");
        INSERT INTO users_rifts VALUES(1,100);
        INSERT INTO rift_shop VALUES(1,1,20,1,1),(2,2,10,1,1);');
    $checks=0;
    function check(bool $ok,string $name): void { global $checks;$checks++;if(!$ok)throw new RuntimeException($name); }
    function buy(string $token,int $shop=1): void {
        $_POST=['token'=>$token,'shop'=>$shop];Session::$messages=[];
        try{(new RiftController())->buy(Request::capture());}catch(Redirect){}
    }
    $balance=fn()=>(int)$pdo->query('SELECT Shards FROM users_rifts')->fetchColumn();
    $quantity=fn()=>(int)$pdo->query('SELECT COALESCE(SUM(Quantity),0) FROM users_items')->fetchColumn();
    $token=str_repeat('a',64);buy($token);
    check($balance()===80&&$quantity()===1,'Purchase debits shards and grants inventory');
    check((int)$pdo->query('SELECT EnhID FROM users_items')->fetchColumn()===7,'Reward retains item enhancement');
    buy($token);check($balance()===80&&$quantity()===1,'Replayed purchase token cannot debit again');
    buy(str_repeat('b',64));check($balance()===60&&$quantity()===2,'Stackable reward stacks');
    buy(str_repeat('c',64));check($balance()===60&&$quantity()===2,'Stack overflow rejected without debit');
    $pdo->exec('UPDATE users_rifts SET Shards=0');buy(str_repeat('d',64),2);check($quantity()===2&&$balance()===0,'Insufficient funds cannot grant inventory');
    $pdo->exec('UPDATE users_rifts SET Shards=100; UPDATE users SET SlotsBag=1');buy(str_repeat('e',64),2);check($balance()===100&&$quantity()===2,'Full inventory rejected');
    $pdo->exec('UPDATE users SET SlotsBag=2,CurrentServer="Aera"');buy(str_repeat('f',64),2);check($balance()===100,'Online account purchase rejected');
    $pdo->exec('UPDATE users SET CurrentServer="Offline",Access=0');buy(str_repeat('1',64),2);check($balance()===100,'Disabled account purchase rejected');
    $pdo->exec('UPDATE users SET Access=1; UPDATE rift_shop SET Cost=-1 WHERE id=2');buy(str_repeat('2',64),2);check($balance()===100,'Invalid shop cost rejected');
    $pdo->exec('UPDATE rift_shop SET Cost=10 WHERE id=2');
    $pdo->exec("CREATE TRIGGER reject_purchase BEFORE INSERT ON rift_purchases BEGIN SELECT RAISE(ABORT,'storage failure'); END");
    buy(str_repeat('3',64),2);check($balance()===100&&$quantity()===2,'Ledger failure rolls back inventory and wallet');
    $pdo->exec('DROP TRIGGER reject_purchase');buy(str_repeat('3',64),2);check($balance()===90&&$quantity()===3,'Failed transaction is safely retryable');
    Csrf::$valid=false;
    try{buy(str_repeat('4',64),2);check(false,'CSRF must reject');}catch(RuntimeException $e){check($e->getMessage()==='CSRF rejected'&&$balance()===90,'CSRF protects purchase before database writes');}
    echo "Rift shop: {$checks} checks passed.\n";
}
