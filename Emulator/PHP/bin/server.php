<?php
declare(strict_types=1);
use AeraEmu\{Config,Database,GameServer,Logger,WorldRepository};
require dirname(__DIR__) . '/src/Autoload.php';
$root=dirname(__DIR__);$logger=new Logger($root.'/runtime/logs/panel-console.log');
set_exception_handler(static function(Throwable $e)use($logger){$logger->error(get_class($e).': '.$e->getMessage().' @ '.$e->getFile().':'.$e->getLine());exit(1);});
set_error_handler(static function(int $sev,string $msg,string $file,int $line)use($logger){$logger->error("PHP {$sev}: {$msg} @ {$file}:{$line}");return true;});

// Verify every v30 runtime dependency was actually deployed before constructing the server.
$requiredRuntimeClasses = [
    AeraEmu\Config::class, AeraEmu\Database::class, AeraEmu\Logger::class,
    AeraEmu\WorldRepository::class, AeraEmu\WorldMath::class, AeraEmu\StatsCalculator::class,
    AeraEmu\CombatMath::class, AeraEmu\RequestTrace::class, AeraEmu\SettingsCodec::class,
    AeraEmu\AchievementBits::class, AeraEmu\ExtensionRouter::class, AeraEmu\GameServer::class,
];
foreach ($requiredRuntimeClasses as $requiredClass) {
    if (!class_exists($requiredClass)) {
        throw new RuntimeException('Incomplete Aera PHP emulator deployment: missing runtime class ' . $requiredClass);
    }
}
$config=new Config($root);
$db=new Database($config);
$world=new WorldRepository($db,(string)$config->get('server_name','Aera'),$logger);
$server=new GameServer($config,$db,$logger,$world);
$server->run();
