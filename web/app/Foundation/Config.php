<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Config
{
    private static array $data = [];

    public static function boot(string $webRoot, string $projectRoot): void
    {
        $defaults = require $webRoot . '/config/app.php';

        // A fresh archive may not retain an empty storage directory. Create it
        // before setup runs so IIS/PHP can always persist runtime config/logs.
        $storage = $webRoot . '/storage';
        if (!is_dir($storage)) {
            @mkdir($storage, 0775, true);
        }

        $runtime = [];
        $runtimeFile = $storage . '/config.php';
        if (is_file($runtimeFile)) {
            $loaded = require $runtimeFile;
            if (is_array($loaded)) {
                $runtime = $loaded;
            }
        }

        self::$data = self::merge($defaults, $runtime);
        self::$data['paths']['web'] = $webRoot;
        self::$data['paths']['project'] = $projectRoot;
        self::$data['paths']['public'] = $webRoot . '/public';
        self::$data['paths']['views'] = $webRoot . '/views';
        self::$data['paths']['storage'] = $storage;

        // Full-server installs keep SQL in /Database. Web-only patches include
        // a local copy under /resources so setup is still self-contained.
        $projectSql = $projectRoot . '/Database/aera.sql';
        $localSql = $webRoot . '/resources/database/aera.sql';
        self::$data['paths']['database_sql'] = is_file($projectSql) ? $projectSql : $localSql;
        self::$data['paths']['emulator'] = $projectRoot . '/Emulator/PHP';

        $envMap = [
            'AERA_APP_URL' => 'app.url',
            'AERA_DEBUG' => 'app.debug',
            'AERA_DB_HOST' => 'db.host',
            'AERA_DB_PORT' => 'db.port',
            'AERA_DB_USER' => 'db.username',
            'AERA_DB_PASSWORD' => 'db.password',
        ];
        foreach ($envMap as $env => $key) {
            $value = getenv($env);
            if ($value !== false && $value !== '') {
                self::set($key, self::normalize($value));
            }
        }

        // The game schema name is intentionally fixed so the web site and
        // emulator cannot accidentally drift onto different databases.
        self::set('db.database', 'aera');
    }

    private static function merge(array $a, array $b): array
    {
        foreach ($b as $k => $v) {
            if (is_array($v) && isset($a[$k]) && is_array($a[$k])) {
                $a[$k] = self::merge($a[$k], $v);
            } else {
                $a[$k] = $v;
            }
        }
        return $a;
    }

    private static function normalize(mixed $v): mixed
    {
        if (!is_string($v)) return $v;
        return match (strtolower($v)) {
            'true' => true,
            'false' => false,
            'null' => null,
            default => $v,
        };
    }

    public static function get(string $key, mixed $default = null): mixed
    {
        $value = self::$data;
        foreach (explode('.', $key) as $segment) {
            if (!is_array($value) || !array_key_exists($segment, $value)) return $default;
            $value = $value[$segment];
        }
        return $value;
    }

    public static function set(string $key, mixed $value): void
    {
        $parts = explode('.', $key);
        $ref =& self::$data;
        foreach ($parts as $i => $part) {
            if ($i === count($parts) - 1) {
                $ref[$part] = $value;
                break;
            }
            if (!isset($ref[$part]) || !is_array($ref[$part])) $ref[$part] = [];
            $ref =& $ref[$part];
        }
    }
}
