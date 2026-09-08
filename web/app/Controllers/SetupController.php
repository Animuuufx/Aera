<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Config;
use Aera\Foundation\Csrf;
use Aera\Foundation\Database;
use Aera\Foundation\Installer;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\View;
use Throwable;

final class SetupController
{
    public function form(Request $r): void
    {
        $configured = Installer::isConfigured();
        $autoRepaired = false;
        if ($configured && !Database::ping()) {
            $autoRepaired = Installer::tryCompatibilityRepair();
        }
        $diagnostic = Database::diagnostic();
        View::render('setup', [
            'requirements' => Installer::requirements(),
            'configured' => $configured,
            'dbOk' => $diagnostic['ok'],
            'diagnostic' => $diagnostic,
            'autoRepaired' => $autoRepaired,
            'defaults' => [
                'host' => (string)Config::get('db.host', 'localhost'),
                'port' => (int)Config::get('db.port', 9519),
                'user' => (string)Config::get('db.username', 'root'),
            ],
        ]);
    }

    public function install(Request $r): void
    {
        Csrf::verify($r);
        try {
            $warnings = Installer::install($r->all());
            Session::flash('success', 'Database connection saved. The aera schema and admin support tables are ready.');
            if ($warnings) Session::flash('warning', implode(' ', $warnings));
            Response::redirect('/admin');
        } catch (Throwable $e) {
            Session::flash('error', $e->getMessage());
            Response::redirect('/setup');
        }
    }

    public function health(Request $r): void
    {
        $configured = Installer::isConfigured();
        $db = Database::diagnostic();
        Response::json([
            'ok' => $configured && $db['ok'],
            'framework' => 'Aera Foundation',
            'version' => Config::get('app.version'),
            'php' => PHP_VERSION,
            'configured' => $configured,
            'pdo_mysql' => extension_loaded('pdo_mysql'),
            'database' => 'aera',
            'database_ok' => $db['ok'],
            'database_host' => $db['host'],
            'database_port' => $db['port'],
            'database_user' => $db['username'],
            'database_error' => $db['error'],
        ]);
    }
}
