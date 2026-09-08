<?php
declare(strict_types=1);
namespace AeraEmu;

use PDO;
use PDOException;
use PDOStatement;
use Throwable;

/** PDO database wrapper with Java-pool-like reconnect behavior for long-running CLI use. */
final class Database
{
    private PDO $pdo;
    private array $cfg;
    private int $txDepth=0;
    public function __construct(Config $config){$this->cfg=$config->db();if(!extension_loaded('pdo_mysql'))throw new \RuntimeException('pdo_mysql is required by the PHP emulator.');$this->connect();}
    private function connect(): void
    {
        $d=$this->cfg;$db=str_replace('`','',(string)($d['database']??'aera'));
        $dsn=sprintf('mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4',(string)($d['host']??'127.0.0.1'),(int)($d['port']??3306),$db);
        $this->pdo=new PDO($dsn,(string)($d['username']??''),(string)($d['password']??''),[
            PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false,
            PDO::ATTR_STRINGIFY_FETCHES=>false,PDO::ATTR_TIMEOUT=>max(2,(int)($d['timeout']??10)),
        ]);
        try{$this->pdo->exec("SET NAMES utf8mb4");}catch(Throwable){}
    }
    public function reconnect(): void { if($this->txDepth>0||$this->pdo->inTransaction())throw new \RuntimeException('Refusing to reconnect during a database transaction.');$this->connect(); }
    public function ping(): bool { try{$this->pdo->query('SELECT 1')->fetchColumn();return true;}catch(Throwable){try{$this->reconnect();return true;}catch(Throwable){return false;}} }
    public function pdo(): PDO { return $this->pdo; }
    public function lastInsertId(): string { return $this->pdo->lastInsertId(); }
    public function one(string $sql,array $params=[]): ?array { $s=$this->execute($sql,$params);$r=$s->fetch();return $r===false?null:$r; }
    public function all(string $sql,array $params=[]): array { return $this->execute($sql,$params)->fetchAll(); }
    public function scalar(string $sql,array $params=[],mixed $default=null): mixed { $v=$this->execute($sql,$params)->fetchColumn();return $v===false?$default:$v; }
    public function run(string $sql,array $params=[]): int { $s=$this->execute($sql,$params);return $s->rowCount(); }
    public function tx(callable $fn): mixed
    {
        if($this->txDepth>0)return $fn($this);
        $this->pdo->beginTransaction();$this->txDepth++;
        try{$r=$fn($this);$this->pdo->commit();$this->txDepth--;return $r;}catch(Throwable $e){if($this->pdo->inTransaction())$this->pdo->rollBack();$this->txDepth=max(0,$this->txDepth-1);throw $e;}
    }
    public function tableExists(string $table): bool
    { try{return (bool)$this->scalar('SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=?',[$table],0);}catch(Throwable){return false;} }
    public function columns(string $table): array
    { if(!preg_match('/^[A-Za-z0-9_]+$/',$table))return [];try{$rows=$this->all("SHOW COLUMNS FROM `{$table}`");return array_map(fn($r)=>(string)$r['Field'],$rows);}catch(Throwable){return [];} }
    private function execute(string $sql,array $params): PDOStatement
    {
        $attempt=0;
        while(true){
            try{$s=$this->pdo->prepare($sql);$s->execute($params);return $s;}
            catch(PDOException $e){if($attempt===0&&$this->txDepth===0&&$this->isDisconnect($e)){$attempt++;$this->connect();continue;}throw $e;}
        }
    }
    private function isDisconnect(PDOException $e): bool
    { $m=strtolower($e->getMessage());return str_contains($m,'server has gone away')||str_contains($m,'lost connection')||str_contains($m,'connection refused')||str_contains($m,'no connection to the server')||in_array((string)$e->getCode(),['HY000','2006','2013'],true); }
}
