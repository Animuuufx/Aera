<?php
declare(strict_types=1);

namespace Aera\Foundation;

use RuntimeException;

final class Config
{
    private static array $data = [];

    public static function boot(string $webRoot, string $projectRoot): void
    {
        $defaults = require $webRoot . '/config/app.php';
        $storage = $webRoot . '/storage'; if (!is_dir($storage)) @mkdir($storage, 0775, true);
        $runtime = []; $runtimeFile = $storage . '/config.php';
        if (is_file($runtimeFile)) { $loaded = require $runtimeFile; if (is_array($loaded)) $runtime = $loaded; }
        self::$data = self::merge($defaults, $runtime);
        self::$data['paths']['web'] = $webRoot; self::$data['paths']['project'] = $projectRoot; self::$data['paths']['public'] = $webRoot . '/public'; self::$data['paths']['views'] = $webRoot . '/views'; self::$data['paths']['storage'] = $storage;
        $projectSql = $projectRoot . '/Database/aera.sql'; $localSql = $webRoot . '/resources/database/aera.sql'; self::$data['paths']['database_sql'] = is_file($projectSql) ? $projectSql : $localSql; self::$data['paths']['emulator'] = $projectRoot . '/Emulator/PHP';
        $envMap = [
            'AERA_APP_URL'=>'app.url','AERA_DEBUG'=>'app.debug','AERA_DB_HOST'=>'db.host','AERA_DB_PORT'=>'db.port','AERA_DB_USER'=>'db.username','AERA_DB_PASSWORD'=>'db.password',
            'AERA_PAYPAL_MODE'=>'paypal.mode','AERA_PAYPAL_CLIENT_ID'=>'paypal.client_id','AERA_PAYPAL_CLIENT_SECRET'=>'paypal.client_secret','AERA_PAYPAL_MERCHANT_EMAIL'=>'paypal.merchant_email','AERA_PAYPAL_BRAND_NAME'=>'paypal.brand_name'
        ];
        foreach ($envMap as $env=>$key) { $value=getenv($env); if($value!==false&&$value!=='') self::set($key,self::normalize($value)); }
        self::set('db.database','aera');
    }
    private static function merge(array $a,array $b): array { foreach($b as $k=>$v){$a[$k]=is_array($v)&&isset($a[$k])&&is_array($a[$k])?self::merge($a[$k],$v):$v;}return $a; }
    private static function normalize(mixed $v): mixed { if(!is_string($v))return $v; return match(strtolower($v)){ 'true'=>true,'false'=>false,'null'=>null,default=>$v }; }
    public static function get(string $key,mixed $default=null): mixed { $value=self::$data;foreach(explode('.',$key) as $segment){if(!is_array($value)||!array_key_exists($segment,$value))return $default;$value=$value[$segment];}return $value; }
    public static function set(string $key,mixed $value): void { $parts=explode('.',$key);$ref=&self::$data;foreach($parts as $i=>$part){if($i===count($parts)-1){$ref[$part]=$value;break;}if(!isset($ref[$part])||!is_array($ref[$part]))$ref[$part]=[];$ref=&$ref[$part];} }

    public static function setRuntime(string $key, mixed $value): void
    {
        $runtimeFile = rtrim((string)self::get('paths.storage', ''), DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . 'config.php';
        if ($runtimeFile === DIRECTORY_SEPARATOR . 'config.php' || $runtimeFile === 'config.php') throw new RuntimeException('Config storage path is not configured.');
        $runtime = [];
        if (is_file($runtimeFile)) {
            $loaded = require $runtimeFile;
            if (is_array($loaded)) $runtime = $loaded;
        }
        self::setNested($runtime, $key, $value);
        $contents = "<?php\nreturn " . var_export($runtime, true) . ";\n";
        if (@file_put_contents($runtimeFile, $contents, LOCK_EX) === false) throw new RuntimeException('Unable to save runtime configuration.');
        self::set($key, $value);
    }

    private static function setNested(array &$data, string $key, mixed $value): void
    {
        $parts = explode('.', $key); $ref =& $data;
        foreach ($parts as $i => $part) {
            if ($i === count($parts) - 1) { $ref[$part] = $value; break; }
            if (!isset($ref[$part]) || !is_array($ref[$part])) $ref[$part] = [];
            $ref =& $ref[$part];
        }
    }
}
