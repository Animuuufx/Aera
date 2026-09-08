<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Session
{
    public static function start(): void
    {
        if (session_status() === PHP_SESSION_ACTIVE) return;
        session_name((string)Config::get('session.name', 'aera_session'));
        session_set_cookie_params(['lifetime'=>0,'path'=>'/','secure'=>false,'httponly'=>true,'samesite'=>'Lax']);
        if (!is_dir((string)Config::get('paths.storage') . '/sessions')) @mkdir((string)Config::get('paths.storage') . '/sessions', 0775, true);
        session_start();
    }
    public static function flash(string $key, mixed $value): void { $_SESSION['_flash'][$key] = $value; }
    public static function pull(string $key, mixed $default = null): mixed { $v = $_SESSION['_flash'][$key] ?? $default; unset($_SESSION['_flash'][$key]); return $v; }
    public static function put(string $key, mixed $value): void { $_SESSION[$key] = $value; }
    public static function get(string $key, mixed $default = null): mixed { return $_SESSION[$key] ?? $default; }
    public static function forget(string $key): void { unset($_SESSION[$key]); }
    public static function regenerate(): void { session_regenerate_id(true); }
}
