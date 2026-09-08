<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Response
{
    public static function redirect(string $to, int $status = 302): never
    {
        header('Location: ' . $to, true, $status); exit;
    }
    public static function json(mixed $data, int $status = 200): never
    {
        http_response_code($status); header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store');
        echo json_encode($data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE); exit;
    }
    public static function text(string $text, int $status = 200): never
    {
        http_response_code($status); header('Content-Type: text/plain; charset=utf-8'); echo $text; exit;
    }
    public static function abort(int $status, string $message = ''): never { throw new HttpException($status, $message); }
}
