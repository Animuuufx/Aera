<?php
declare(strict_types=1);
namespace AeraEmu;

use Throwable;

final class Logger
{
    private string $path;
    /** @var null|callable(string):void */
    private $sink = null;

    public function __construct(string $path)
    {
        $this->path = $path;
        @mkdir(dirname($path), 0775, true);
    }

    /** @param null|callable(string):void $sink */
    public function setSink(?callable $sink): void { $this->sink = $sink; }

    public function log(string $level, string $message): void
    {
        $line = sprintf("[%s] %-7s %s", date('Y-m-d H:i:s'), strtoupper($level), $message);
        @file_put_contents($this->path, $line . "\n", FILE_APPEND | LOCK_EX);
        @fwrite(STDOUT, $line . "\n");
        if (is_callable($this->sink)) {
            try { ($this->sink)($line); } catch (Throwable) { /* console viewers must never break the emulator */ }
        }
    }

    public function info(string $m): void { $this->log('info', $m); }
    public function warn(string $m): void { $this->log('warning', $m); }
    public function error(string $m): void { $this->log('error', $m); }
}
