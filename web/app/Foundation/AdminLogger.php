<?php
declare(strict_types=1);
namespace Aera\Foundation;

use Throwable;

/**
 * Central audit trail for every authenticated admin-panel request.
 *
 * This is intentionally independent from the older admin_audit table.  The
 * latter records selected high-level mutations; admin_logs records the whole
 * panel request stream so there is one chronological source of truth for
 * navigation, emulator controls, player actions, database CRUD and uploads.
 */
final class AdminLogger
{
    private static bool $tableReady = false;
    private static ?int $activeId = null;
    private static float $startedAt = 0.0;
    private static bool $shutdownRegistered = false;

    public static function begin(Request $request): void
    {
        $path = $request->path();
        $isPanel = str_starts_with($path, '/admin');

        // The panel logout button posts to the shared /logout endpoint. Record
        // it only when the currently authenticated user is staff and the
        // browser came from /admin.
        if (!$isPanel && $path === '/logout') {
            $referer = (string)$request->header('Referer', '');
            $isPanel = str_contains($referer, '/admin');
        }
        if (!$isPanel) return;

        try {
            $admin = Auth::user();
            if (!$admin || (int)($admin['Access'] ?? 0) < (int)Config::get('security.admin_min_access', 40)) return;
            self::ensureTable();

            [$action, $entity, $entityId, $background] = self::classify($request);
            $requestData = self::safeJson(self::sanitize($request->all(), $request));
            $fileData = self::safeJson(self::files());
            $userAgent = substr((string)$request->header('User-Agent', ''), 0, 255);

            $pdo = Database::connection();
            $s = $pdo->prepare(
                'INSERT INTO admin_logs '
                .'(AdminUserID,AdminName,Method,Path,Action,Entity,EntityID,RequestData,FileData,IPAddress,UserAgent,IsBackground,CreatedAt) '
                .'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,NOW())'
            );
            $s->execute([
                (int)$admin['id'],
                substr((string)($admin['Name'] ?? ''), 0, 60),
                substr($request->method(), 0, 10),
                substr($path, 0, 255),
                substr($action, 0, 96),
                $entity !== null ? substr($entity, 0, 96) : null,
                $entityId !== null ? substr($entityId, 0, 128) : null,
                $requestData,
                $fileData,
                substr($request->ip(), 0, 45),
                $userAgent,
                $background ? 1 : 0,
            ]);
            self::$activeId = (int)$pdo->lastInsertId();
            self::$startedAt = microtime(true);

            if (!self::$shutdownRegistered) {
                self::$shutdownRegistered = true;
                register_shutdown_function([self::class, 'finish']);
            }
        } catch (Throwable) {
            // An audit failure must never break the control panel itself.
        }
    }

    public static function finish(): void
    {
        if (!self::$activeId) return;
        $id = self::$activeId;
        self::$activeId = null;

        try {
            $status = http_response_code();
            if ($status < 100) $status = 200;
            $duration = max(0, (int)round((microtime(true) - self::$startedAt) * 1000));
            $error = error_get_last();
            $fatalTypes = [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR, E_USER_ERROR];
            $errorMessage = null;
            if (is_array($error) && in_array((int)($error['type'] ?? 0), $fatalTypes, true)) {
                $errorMessage = substr((string)($error['message'] ?? 'Fatal PHP error'), 0, 500);
                if ($status < 400) $status = 500;
            }
            Database::run(
                'UPDATE admin_logs SET ResponseStatus=?,DurationMs=?,ErrorMessage=?,CompletedAt=NOW() WHERE id=?',
                [$status, $duration, $errorMessage, $id]
            );
        } catch (Throwable) {
        }
    }

    public static function ensureTable(): void
    {
        if (self::$tableReady) return;
        Database::connection()->exec(self::createSql());
        self::$tableReady = true;
    }

    public static function createSql(): string
    {
        return "CREATE TABLE IF NOT EXISTS `admin_logs` ("
            ."`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,"
            ."`AdminUserID` int(11) UNSIGNED DEFAULT NULL,"
            ."`AdminName` varchar(60) NOT NULL DEFAULT '',"
            ."`Method` varchar(10) NOT NULL,"
            ."`Path` varchar(255) NOT NULL,"
            ."`Action` varchar(96) NOT NULL DEFAULT '',"
            ."`Entity` varchar(96) DEFAULT NULL,"
            ."`EntityID` varchar(128) DEFAULT NULL,"
            ."`RequestData` mediumtext,"
            ."`FileData` text,"
            ."`IPAddress` varchar(45) DEFAULT NULL,"
            ."`UserAgent` varchar(255) DEFAULT NULL,"
            ."`IsBackground` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,"
            ."`ResponseStatus` smallint(5) UNSIGNED DEFAULT NULL,"
            ."`DurationMs` int(10) UNSIGNED DEFAULT NULL,"
            ."`ErrorMessage` varchar(500) DEFAULT NULL,"
            ."`CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,"
            ."`CompletedAt` datetime DEFAULT NULL,"
            ."PRIMARY KEY (`id`),"
            ."KEY `idx_admin_logs_admin_created` (`AdminUserID`,`CreatedAt`),"
            ."KEY `idx_admin_logs_action_created` (`Action`,`CreatedAt`),"
            ."KEY `idx_admin_logs_path_created` (`Path`,`CreatedAt`),"
            ."KEY `idx_admin_logs_background_created` (`IsBackground`,`CreatedAt`),"
            ."CONSTRAINT `fk_admin_logs_user` FOREIGN KEY (`AdminUserID`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE"
            .") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
    }

    /** @return array{0:string,1:?string,2:?string,3:bool} */
    private static function classify(Request $request): array
    {
        $path = $request->path();
        $method = $request->method();
        $action = $method === 'GET' ? 'view' : 'request';
        $entity = null;
        $entityId = null;
        $background = false;

        if ($path === '/admin') return ['view.dashboard', 'dashboard', null, false];
        if ($path === '/admin/players') return ['view.players', 'player', (string)$request->input('q', ''), false];
        if ($path === '/admin/players/action') {
            $a = strtolower(trim((string)$request->input('action', 'unknown')));
            return ['player.'.$a, 'player', (string)$request->input('user_id', ''), false];
        }
        if ($path === '/admin/emulator/player-action') {
            $a = strtolower(trim((string)$request->input('action', 'unknown')));
            return ['emulator.player.'.$a, 'player', (string)$request->input('user_id', ''), false];
        }
        if ($path === '/admin/emulator/events') return ['emulator.events', 'emulator', null, true];
        if ($path === '/admin/emulator/state') return ['emulator.state', 'emulator', null, true];
        if ($path === '/admin/emulator/editor') return ['emulator.editor.read', 'file', (string)$request->input('file', ''), false];
        if ($path === '/admin/emulator/editor/save') return ['emulator.editor.save', 'file', (string)$request->input('file', ''), false];
        if ($path === '/admin/emulator/rpc') return ['emulator.rpc.'.strtolower((string)$request->input('action', 'unknown')), 'emulator', null, false];
        if ($path === '/admin/emulator/console-command') return ['emulator.console.command', 'emulator', null, false];
        if (preg_match('#^/admin/emulator/control/([^/]+)$#', $path, $m)) return ['emulator.control.'.strtolower($m[1]), 'emulator', null, false];
        if (preg_match('#^/admin/emulator/([^/]+)$#', $path, $m) && $method === 'POST') return ['emulator.'.strtolower($m[1]), 'emulator', null, false];
        if ($path === '/admin/emulator') return ['view.emulator', 'emulator', null, false];

        if (preg_match('#^/admin/data/([^/]+)/(new|edit|delete)$#', $path, $m)) {
            $verb = $m[2] === 'new' ? ($method === 'POST' ? 'create' : 'create_form') : ($m[2] === 'edit' ? ($method === 'POST' ? 'edit' : 'edit_form') : 'delete');
            return ['data.'.$verb, $m[1], (string)$request->input('key', ''), false];
        }
        if (preg_match('#^/admin/data/([^/]+)$#', $path, $m)) return ['view.data_table', $m[1], null, false];
        if ($path === '/admin/data') return ['view.database', 'database', null, false];

        if ($path === '/admin/news/new') return [$method === 'POST' ? 'news.create' : 'news.create_form', 'news', null, false];
        if (preg_match('#^/admin/news/([^/]+)/(edit|delete)$#', $path, $m)) return ['news.'.$m[2], 'news', $m[1], false];
        if ($path === '/admin/news') return ['view.news', 'news', null, false];

        if ($path === '/admin/files/image') return ['files.upload.image', 'file', null, false];
        if ($path === '/admin/files/swf') return ['files.upload.swf', 'file', (string)$request->input('destination', ''), false];
        if ($path === '/admin/files') return ['view.files', 'file', null, false];
        if ($path === '/admin/logs') return ['view.admin_logs', 'admin_logs', null, false];
        if ($path === '/logout') return ['panel.logout', 'session', null, false];

        return [$action.'.'.trim(str_replace('/', '.', $path), '.'), $entity, $entityId, $background];
    }

    private static function sanitize(mixed $value, Request $request, string $key = ''): mixed
    {
        if (preg_match('/(?:pass(?:word)?|pwd|token|csrf|secret|hash|api[_-]?key|authorization|cookie)/i', $key)) return '[REDACTED]';

        if (is_array($value)) {
            $out = [];
            foreach ($value as $k => $v) $out[(string)$k] = self::sanitize($v, $request, (string)$k);
            return $out;
        }
        if (is_object($value)) return '[OBJECT '.get_class($value).']';
        if ($value === null || is_bool($value) || is_int($value) || is_float($value)) return $value;

        $text = (string)$value;
        // Source editor bodies can be megabytes. Log integrity information
        // rather than duplicating the entire source into MySQL.
        if (strtolower($key) === 'content' && $request->path() === '/admin/emulator/editor/save') {
            return ['bytes'=>strlen($text), 'sha256'=>hash('sha256', $text)];
        }
        if (strlen($text) > 2000) return substr($text, 0, 2000).'… [truncated '.strlen($text).' bytes]';
        return $text;
    }

    private static function files(): array
    {
        $out = [];
        foreach ($_FILES as $key => $file) {
            if (!is_array($file)) continue;
            $out[(string)$key] = [
                'name' => isset($file['name']) ? basename((string)$file['name']) : '',
                'type' => (string)($file['type'] ?? ''),
                'size' => (int)($file['size'] ?? 0),
                'error' => (int)($file['error'] ?? 0),
            ];
        }
        return $out;
    }

    private static function safeJson(mixed $value): ?string
    {
        if ($value === [] || $value === null) return null;
        $json = json_encode($value, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
        return is_string($json) ? $json : null;
    }
}
