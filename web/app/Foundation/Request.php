<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Request
{
    private function __construct(private string $method, private string $path) {}
    public static function capture(): self
    {
        $method = strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET');

        // Physical fallback endpoints (setup.php/health.php) can force a route without
        // requiring IIS URL Rewrite. This is intentionally namespaced so normal query
        // parameters can never change framework routing.
        $forcedRoute = $_GET['_aera_route'] ?? null;
        if (is_string($forcedRoute) && $forcedRoute !== '') {
            unset($_GET['_aera_route']);
            $uri = $forcedRoute;
        } else {
            $uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';

            // Support /index.php/setup as a second troubleshooting fallback. IIS/FastCGI
            // exposes the original REQUEST_URI even when pretty URLs are unavailable.
            $script = str_replace('\\', '/', (string)($_SERVER['SCRIPT_NAME'] ?? ''));
            if ($script !== '' && $script !== '/' && str_starts_with($uri, $script)) {
                $uri = substr($uri, strlen($script)) ?: '/';
            }
        }

        $path = '/' . trim(rawurldecode($uri), '/');
        if ($path === '//') $path = '/';
        return new self($method, $path);
    }
    public function method(): string { return $this->method; }
    public function path(): string { return $this->path; }
    public function input(string $key, mixed $default = null): mixed { return $_POST[$key] ?? $_GET[$key] ?? $default; }
    public function all(): array { return array_merge($_GET, $_POST); }
    public function has(string $key): bool { return array_key_exists($key, $_POST) || array_key_exists($key, $_GET); }
    public function file(string $key): ?array { return isset($_FILES[$key]) && is_array($_FILES[$key]) ? $_FILES[$key] : null; }
    public function header(string $name, mixed $default = null): mixed
    {
        $key = 'HTTP_' . strtoupper(str_replace('-', '_', $name));
        if (isset($_SERVER[$key])) return $_SERVER[$key];
        if (strcasecmp($name, 'Content-Type') === 0) return $_SERVER['CONTENT_TYPE'] ?? $default;
        return $default;
    }
    public function ip(): string { return (string)($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0'); }
}
