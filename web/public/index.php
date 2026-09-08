<?php
declare(strict_types=1);

define('AERA_WEB_ROOT', dirname(__DIR__));
define('AERA_PROJECT_ROOT', dirname(AERA_WEB_ROOT));

spl_autoload_register(static function (string $class): void {
    $prefix = 'Aera\\';
    if (strncmp($class, $prefix, strlen($prefix)) !== 0) return;
    $relative = substr($class, strlen($prefix));
    $file = AERA_WEB_ROOT . '/app/' . str_replace('\\', '/', $relative) . '.php';
    if (is_file($file)) require $file;
});

require AERA_WEB_ROOT . '/app/Support/helpers.php';

use Aera\Foundation\AdminLogger;
use Aera\Foundation\Config;
use Aera\Foundation\Database;
use Aera\Foundation\HttpException;
use Aera\Foundation\Installer;
use Aera\Foundation\Logger;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Router;
use Aera\Foundation\Session;
use Aera\Foundation\View;

Config::boot(AERA_WEB_ROOT, AERA_PROJECT_ROOT);
date_default_timezone_set((string) Config::get('app.timezone', 'America/Chicago'));
Session::start();

$request = Request::capture();

try {
    if (!Installer::isConfigured() && !in_array($request->path(), ['/setup', '/health'], true)) {
        Response::redirect('/setup');
    }

    // Centralized control-panel audit trail. The shutdown hook registered here
    // also records response status/duration when controller helpers exit after
    // redirects or JSON responses.
    if (Installer::isConfigured()) AdminLogger::begin($request);

    $router = new Router();
    (require AERA_WEB_ROOT . '/routes/web.php')($router);
    $router->dispatch($request);
} catch (HttpException $e) {
    http_response_code($e->status());
    View::render('error', ['status' => $e->status(), 'message' => $e->getMessage()]);
} catch (Throwable $e) {
    Logger::error($e);
    $errorRef = strtoupper(substr(hash('sha256', get_class($e).'|'.$e->getMessage().'|'.date('Y-m-d-H')), 0, 10));
    $dbProblem = $e instanceof PDOException || stripos($e->getMessage(), 'database') !== false || stripos($e->getMessage(), 'SQLSTATE') !== false || stripos($e->getMessage(), 'MySQL') !== false;

    // A SQL/query error is not the same thing as a dead database connection.
    // Older builds redirected every PDO exception from /admin to setup, which
    // made individual table problems (for example /admin/data/items) look like
    // the whole installation had lost its configuration. Only redirect when a
    // fresh ping proves MySQL itself is actually unreachable.
    $dbUnavailable = false;
    if ($dbProblem) {
        try { $dbUnavailable = !Database::ping(); } catch (Throwable) { $dbUnavailable = true; }
    }
    if ($dbUnavailable && str_starts_with($request->path(), '/admin')) {
        Response::redirect('/setup?repair=1');
    }

    http_response_code(500);
    View::render('error', [
        'status' => 500,
        'message' => Config::get('app.debug', false) ? $e->getMessage() : ($dbUnavailable ? 'The website is running, but it cannot reach the Aera database.' : 'Aera encountered an internal error.'),
        'details' => Config::get('app.debug', false) ? $e->getTraceAsString() : null,
        'showSetup' => $dbUnavailable,
        'errorRef' => $errorRef,
    ]);
}
