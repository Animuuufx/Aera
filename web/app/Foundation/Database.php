<?php
declare(strict_types=1);
namespace Aera\Foundation;

use PDO;
use Throwable;

final class Database
{
    private static ?PDO $pdo = null;
    private static ?string $lastError = null;

    public static function reset(): void
    {
        self::$pdo = null;
        self::$lastError = null;
    }

    public static function connection(): PDO
    {
        if (self::$pdo) return self::$pdo;
        if (!extension_loaded('pdo_mysql')) {
            self::$lastError = 'PDO MySQL is not enabled in PHP.';
            throw new \RuntimeException(self::$lastError);
        }

        $host = (string)Config::get('db.host', 'localhost');
        $port = (int)Config::get('db.port', 9519);
        $database = 'aera';
        $dsn = 'mysql:host=' . $host . ';port=' . $port . ';dbname=' . $database . ';charset=utf8mb4';

        try {
            self::$pdo = new PDO($dsn, (string)Config::get('db.username'), (string)Config::get('db.password'), [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_TIMEOUT => 5,
                PDO::ATTR_PERSISTENT => false,
            ]);
            self::$lastError = null;
            return self::$pdo;
        } catch (Throwable $e) {
            self::$lastError = self::friendlyMessage($e);
            throw $e;
        }
    }

    public static function ping(): bool
    {
        try {
            self::connection()->query('SELECT 1')->fetchColumn();
            return true;
        } catch (Throwable) {
            return false;
        }
    }

    public static function diagnostic(): array
    {
        $ok = self::ping();
        return [
            'ok' => $ok,
            'host' => (string)Config::get('db.host', 'localhost'),
            'port' => (int)Config::get('db.port', 9519),
            'database' => 'aera',
            'username' => (string)Config::get('db.username', ''),
            'pdo_mysql' => extension_loaded('pdo_mysql'),
            'error' => $ok ? null : (self::$lastError ?: 'Connection failed.'),
        ];
    }

    private static function friendlyMessage(Throwable $e): string
    {
        $message = $e->getMessage();
        if (stripos($message, 'Connection refused') !== false || stripos($message, 'actively refused') !== false) {
            return 'MySQL refused the connection. Check that MySQL is running and the configured port is correct.';
        }
        if (stripos($message, 'Access denied') !== false) {
            return 'MySQL rejected the username/password.';
        }
        if (stripos($message, 'Unknown database') !== false) {
            return 'The aera database does not exist yet.';
        }
        return preg_replace('/password=[^;\s]+/i', 'password=***', $message) ?: 'Database connection failed.';
    }

    public static function one(string $sql, array $params = []): ?array
    {
        $s = self::connection()->prepare($sql); $s->execute($params); $r = $s->fetch();
        return $r === false ? null : $r;
    }
    public static function all(string $sql, array $params = []): array
    {
        $s = self::connection()->prepare($sql); $s->execute($params); return $s->fetchAll();
    }
    public static function run(string $sql, array $params = []): int
    {
        $s = self::connection()->prepare($sql); $s->execute($params); return $s->rowCount();
    }
    public static function scalar(string $sql, array $params = [], mixed $default = 0): mixed
    {
        $s = self::connection()->prepare($sql); $s->execute($params); $v = $s->fetchColumn();
        return $v === false ? $default : $v;
    }
}
