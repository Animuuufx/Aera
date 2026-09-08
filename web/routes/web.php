<?php
declare(strict_types=1);

use Aera\Controllers\AccountController;
use Aera\Controllers\AdminController;
use Aera\Controllers\AdminDataController;
use Aera\Controllers\AdminDiscordController;
use Aera\Controllers\AdminEmulatorController;
use Aera\Controllers\AdminFilesController;
use Aera\Controllers\AdminNewsController;
use Aera\Controllers\GameApiController;
use Aera\Controllers\HomeController;
use Aera\Controllers\SetupController;
use Aera\Controllers\WikiController;
use Aera\Foundation\Router;

return static function (Router $r): void {
    $r->get('/setup', [SetupController::class, 'form']); $r->post('/setup', [SetupController::class, 'install']); $r->get('/health', [SetupController::class, 'health']);
    $r->get('/', [HomeController::class, 'index']); $r->get('/character', [HomeController::class, 'character']); $r->get('/rankings', [HomeController::class, 'rankings']); $r->get('/play', [HomeController::class, 'play']); $r->get('/news/{slug}', [HomeController::class, 'news']); $r->get('/wiki', [WikiController::class, 'index']); $r->get('/gamefiles/{file}', [WikiController::class, 'gamefile']);
    $r->get('/register', [AccountController::class, 'registerForm']); $r->post('/register', [AccountController::class, 'register']); $r->get('/login', [AccountController::class, 'loginForm']); $r->post('/login', [AccountController::class, 'login']); $r->post('/logout', [AccountController::class, 'logout']); $r->get('/account', [AccountController::class, 'account']); $r->post('/account/email', [AccountController::class, 'email']); $r->post('/account/password', [AccountController::class, 'password']);
    $r->get('/api/game/version', [GameApiController::class, 'version']); $r->get('/api/game/clientvars', [GameApiController::class, 'clientvars']); $r->post('/api/game/login', [GameApiController::class, 'login']); $r->post('/api/game/register', [GameApiController::class, 'register']); $r->post('/api/char/bank', [GameApiController::class, 'bank']); $r->post('/api/char/HouseSaveRoom', [GameApiController::class, 'houseSaveRoom']); $r->post('/api/char/HouseSaveRoom', [GameApiController::class, 'houseSaveRoom']); $r->get('/api/data/booklore', [GameApiController::class, 'bookLore']); $r->get('/api/data/servers', [GameApiController::class, 'servers']); $r->post('/api/data/serversext', [GameApiController::class, 'serversExtended']); $r->get('/api/charpage/fvars', [GameApiController::class, 'charPage']);
    $r->get('/admin', [AdminController::class, 'dashboard']); $r->get('/admin/logs', [AdminController::class, 'logs']); $r->get('/admin/players', [AdminEmulatorController::class, 'players']); $r->post('/admin/players/action', [AdminEmulatorController::class, 'playerAction']); $r->get('/admin/data', [AdminDataController::class, 'index']); $r->get('/admin/data/{table}/new', [AdminDataController::class, 'createForm']); $r->post('/admin/data/{table}/new', [AdminDataController::class, 'create']); $r->get('/admin/data/{table}/edit', [AdminDataController::class, 'editForm']); $r->post('/admin/data/{table}/edit', [AdminDataController::class, 'edit']); $r->get('/admin/data/{table}', [AdminDataController::class, 'table']);
    $r->get('/admin/news', [AdminNewsController::class, 'index']); $r->get('/admin/news/new', [AdminNewsController::class, 'createForm']); $r->post('/admin/news/new', [AdminNewsController::class, 'create']); $r->get('/admin/news/{id}/edit', [AdminNewsController::class, 'editForm']); $r->post('/admin/news/{id}/edit', [AdminNewsController::class, 'edit']); $r->post('/admin/news/{id}/delete', [AdminNewsController::class, 'delete']); $r->get('/admin/files', [AdminFilesController::class, 'index']); $r->post('/admin/files/image', [AdminFilesController::class, 'image']); $r->post('/admin/files/swf', [AdminFilesController::class, 'swf']);
    $r->get('/admin/emulator', [AdminEmulatorController::class, 'index']); $r->get('/admin/emulator/events', [AdminEmulatorController::class, 'events']); $r->get('/admin/emulator/state', [AdminEmulatorController::class, 'state']); $r->get('/admin/emulator/editor', [AdminEmulatorController::class, 'editorRead']); $r->post('/admin/emulator/editor/save', [AdminEmulatorController::class, 'editorSave']); $r->post('/admin/emulator/rpc', [AdminEmulatorController::class, 'rpc']); $r->post('/admin/emulator/player-action', [AdminEmulatorController::class, 'livePlayerAction']); $r->post('/admin/emulator/control/{action}', [AdminEmulatorController::class, 'control']); $r->post('/admin/emulator/console-command', [AdminEmulatorController::class, 'consoleCommand']); $r->post('/admin/emulator/port', [AdminEmulatorController::class, 'port']); $r->post('/admin/emulator/{action}', [AdminEmulatorController::class, 'action']);
    $r->get('/admin/discord', [AdminDiscordController::class, 'index']); $r->post('/admin/discord/save', [AdminDiscordController::class, 'save']); $r->post('/admin/discord/control', [AdminDiscordController::class, 'control']); $r->get('/admin/discord/status', [AdminDiscordController::class, 'status']);
};
