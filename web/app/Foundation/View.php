<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class View
{
    public static function render(string $name, array $data = []): void
    {
        $file = (string)Config::get('paths.views') . '/' . str_replace('.', '/', $name) . '.php';
        if (!is_file($file)) throw new \RuntimeException('View not found: ' . $name);
        extract($data, EXTR_SKIP); require $file;
    }
}
