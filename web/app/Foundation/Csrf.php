<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Csrf
{
    public static function token(): string
    {
        $token = Session::get('_csrf');
        if (!is_string($token) || strlen($token) < 32) { $token = bin2hex(random_bytes(32)); Session::put('_csrf', $token); }
        return $token;
    }
    public static function verify(Request $request): void
    {
        $given = (string)$request->input('_token', ''); $known = (string)Session::get('_csrf', '');
        if ($given === '' || $known === '' || !hash_equals($known, $given)) Response::abort(419, 'Your form session expired. Refresh the page and try again.');
    }
}
