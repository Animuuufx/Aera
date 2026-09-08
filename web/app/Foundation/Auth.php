<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Auth
{
    private static ?array $cached = null;
    public static function attempt(string $username, string $password): bool
    {
        $username = strtolower(trim($username));
        $user = Database::one('SELECT * FROM users WHERE LOWER(Name)=? LIMIT 1', [$username]);
        if (!$user || !password_verify($password, (string)$user['Hash'])) return false;
        if ((int)$user['Access'] < 1) return false;
        Session::regenerate(); Session::put('user_id', (int)$user['id']); self::$cached = $user; return true;
    }
    public static function user(): ?array
    {
        if (self::$cached) return self::$cached;
        $id = (int)Session::get('user_id', 0); if ($id < 1) return null;
        self::$cached = Database::one('SELECT * FROM users WHERE id=? LIMIT 1', [$id]);
        if (!self::$cached) Session::forget('user_id');
        return self::$cached;
    }
    public static function refresh(): ?array { self::$cached = null; return self::user(); }
    public static function logout(): void { Session::forget('user_id'); self::$cached = null; Session::regenerate(); }
    public static function requireUser(): array { $u=self::user(); if(!$u) Response::redirect('/login'); return $u; }
    public static function requireAdmin(): array
    {
        $u=self::requireUser(); if ((int)$u['Access'] < (int)Config::get('security.admin_min_access',40)) Response::abort(403,'Administrator access required.'); return $u;
    }
}
