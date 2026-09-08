<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Logger
{
    public static function error(\Throwable $e): void
    {
        $dir = (string)Config::get('paths.storage') . '/logs'; if (!is_dir($dir)) @mkdir($dir, 0775, true);
        $line = '[' . date('Y-m-d H:i:s') . '] ' . get_class($e) . ': ' . $e->getMessage() . "\n" . $e->getTraceAsString() . "\n\n";
        @file_put_contents($dir . '/aera.log', $line, FILE_APPEND | LOCK_EX);
    }
}
