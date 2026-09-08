<?php
declare(strict_types=1);
namespace Aera\Foundation;

final class Router
{
    private array $routes = [];
    public function get(string $path, array|callable $handler): void { $this->add('GET', $path, $handler); }
    public function post(string $path, array|callable $handler): void { $this->add('POST', $path, $handler); }
    public function add(string $method, string $path, array|callable $handler): void
    {
        $normalized = '/' . trim($path, '/'); if ($normalized === '//') $normalized = '/';
        $regex = preg_replace_callback('#\{([A-Za-z_][A-Za-z0-9_]*)\}#', static fn($m) => '(?P<' . $m[1] . '>[^/]+)', $normalized);
        $this->routes[] = [$method, '#^' . $regex . '$#', $handler];
    }
    public function dispatch(Request $request): void
    {
        foreach ($this->routes as [$method, $regex, $handler]) {
            if ($method !== $request->method()) continue;
            if (!preg_match($regex, $request->path(), $matches)) continue;
            $params = [];
            foreach ($matches as $k => $v) if (is_string($k)) $params[] = rawurldecode((string)$v);
            if (is_callable($handler)) { $handler($request, ...$params); return; }
            [$class, $action] = $handler;
            (new $class())->{$action}($request, ...$params); return;
        }
        Response::abort(404, 'Page not found.');
    }
}
