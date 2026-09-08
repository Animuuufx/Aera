<?php
declare(strict_types=1);
namespace Aera\Foundation;

use PDO;
use Throwable;

final class Installer
{
    public static function isConfigured(): bool
    {
        return is_file((string)Config::get('paths.storage') . '/config.php');
    }

    public static function requirements(): array
    {
        $storage = (string)Config::get('paths.storage');
        if (!is_dir($storage)) @mkdir($storage, 0775, true);
        $sql = (string)Config::get('paths.database_sql');
        return [
            'php' => ['ok' => version_compare(PHP_VERSION, '8.2.0', '>='), 'label' => 'PHP 8.2+', 'value' => PHP_VERSION],
            'pdo' => ['ok' => extension_loaded('pdo'), 'label' => 'PDO extension', 'value' => extension_loaded('pdo') ? 'Enabled' : 'Missing'],
            'mysql' => ['ok' => extension_loaded('pdo_mysql'), 'label' => 'PDO MySQL extension', 'value' => extension_loaded('pdo_mysql') ? 'Enabled' : 'Missing'],
            'storage' => ['ok' => is_dir($storage) && is_writable($storage), 'label' => 'web/storage writable', 'value' => (is_dir($storage) && is_writable($storage)) ? 'Writable' : 'Not writable'],
            'sql' => ['ok' => is_file($sql), 'label' => 'aera.sql installer source', 'value' => is_file($sql) ? 'Found' : 'Missing'],
        ];
    }

    /**
     * Repair packages created before 3.2 could contain a saved 3306/blank
     * connection even though the user's supplied legacy website used another
     * MySQL endpoint. If that original endpoint is still live, migrate the
     * runtime config automatically. Passwords are never returned to the UI.
     */
    public static function tryCompatibilityRepair(): bool
    {
        if (!self::isConfigured() || Database::ping()) return false;

        $candidates = [
            ['host' => 'localhost', 'port' => 9519, 'username' => 'root', 'password' => '123'],
            ['host' => '127.0.0.1', 'port' => 9519, 'username' => 'root', 'password' => '123'],
        ];

        foreach ($candidates as $candidate) {
            try {
                $pdo = self::connectServer($candidate['host'], $candidate['port'], $candidate['username'], $candidate['password'], false);
                if (!self::databaseExists($pdo, 'aera')) continue;
                $pdo->exec('USE `aera`');
                if (!self::tableExists($pdo, 'users')) continue;
                self::ensureWebTables($pdo);
                self::writeConfig(['db' => $candidate + ['database' => 'aera']]);
                self::applyRuntimeConfig($candidate['host'], $candidate['port'], $candidate['username'], $candidate['password']);
                return Database::ping();
            } catch (Throwable) {
                // Try the next compatibility endpoint.
            }
        }
        return false;
    }

    public static function install(array $input): array
    {
        foreach (self::requirements() as $key => $r) {
            // SQL is only required when a fresh game schema must be imported.
            if ($key === 'sql') continue;
            if (!$r['ok']) throw new \RuntimeException('Setup requirement failed: ' . $r['label'] . ' (' . $r['value'] . ').');
        }

        $host = trim((string)($input['db_host'] ?? Config::get('db.host', 'localhost'))) ?: 'localhost';
        $port = (int)($input['db_port'] ?? Config::get('db.port', 9519));
        if ($port < 1 || $port > 65535) throw new \RuntimeException('Invalid MySQL port.');
        $user = trim((string)($input['db_user'] ?? Config::get('db.username', 'root')));
        if ($user === '') throw new \RuntimeException('MySQL username is required.');

        // Blank on a repair form means "keep current password" rather than
        // unexpectedly replacing it with an empty password.
        $postedPass = array_key_exists('db_password', $input) ? (string)$input['db_password'] : '';
        $pass = $postedPass !== '' ? $postedPass : (string)Config::get('db.password', '123');

        $pdo = self::connectServer($host, $port, $user, $pass, false);
        try {
            $pdo->exec("CREATE DATABASE IF NOT EXISTS `aera` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
        } catch (Throwable $e) {
            // Some production MySQL users can use an existing DB but cannot
            // CREATE DATABASE. Continue if aera already exists.
            if (!self::databaseExists($pdo, 'aera')) {
                throw new \RuntimeException('Connected to MySQL, but database aera could not be created: ' . $e->getMessage(), 0, $e);
            }
        }

        $pdo->exec('USE `aera`');
        $hasCore = self::tableExists($pdo, 'users');
        $warnings = [];

        if ($hasCore) {
            $warnings[] = 'Existing aera game schema detected; existing game data was preserved.';
            self::ensureWebTables($pdo);
        } else {
            $sql = (string)Config::get('paths.database_sql');
            if (!is_file($sql)) throw new \RuntimeException('Fresh setup needs aera.sql, but the installer SQL file is missing.');
            $warnings = array_merge($warnings, self::importSql($pdo, $sql));
            self::ensureWebTables($pdo);
        }

        $adminUser = strtolower(trim((string)($input['admin_username'] ?? '')));
        $adminEmail = trim((string)($input['admin_email'] ?? ''));
        $adminPass = (string)($input['admin_password'] ?? '');

        // On a repair of an existing schema, admin fields are optional. On a
        // fresh import they are required so the panel is never orphaned.
        $adminRequested = $adminUser !== '' || $adminEmail !== '' || $adminPass !== '';
        $needsAdmin = !self::hasAdministrator($pdo);
        if ($adminRequested || $needsAdmin) {
            self::validateAdmin($adminUser, $adminEmail, $adminPass);
            self::upsertAdmin($pdo, $adminUser, $adminEmail, $adminPass);
            $warnings[] = $needsAdmin ? 'Administrator account created.' : 'Administrator account updated.';
        }

        self::writeConfig(['db' => [
            'host' => $host,
            'port' => $port,
            'database' => 'aera',
            'username' => $user,
            'password' => $pass,
        ]]);
        self::applyRuntimeConfig($host, $port, $user, $pass);

        if (!Database::ping()) throw new \RuntimeException('The settings were saved, but Aera could not reconnect to MySQL.');
        return $warnings;
    }

    private static function connectServer(string $host, int $port, string $user, string $pass, bool $withDatabase): PDO
    {
        if (!extension_loaded('pdo_mysql')) throw new \RuntimeException('PDO MySQL is not enabled in PHP.');
        $dsn = 'mysql:host=' . $host . ';port=' . $port . ($withDatabase ? ';dbname=aera' : '') . ';charset=utf8mb4';
        try {
            return new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_TIMEOUT => 5,
                PDO::ATTR_PERSISTENT => false,
            ]);
        } catch (Throwable $e) {
            $message = $e->getMessage();
            if (stripos($message, 'Access denied') !== false) $message = 'MySQL rejected the username/password.';
            elseif (stripos($message, 'refused') !== false) $message = 'MySQL refused the connection. Check the MySQL service and port.';
            throw new \RuntimeException('Database connection failed: ' . $message, 0, $e);
        }
    }

    private static function databaseExists(PDO $pdo, string $name): bool
    {
        $s = $pdo->prepare('SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME=?');
        $s->execute([$name]);
        return (int)$s->fetchColumn() > 0;
    }

    private static function tableExists(PDO $pdo, string $name): bool
    {
        $s = $pdo->prepare('SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=?');
        $s->execute([$name]);
        return (int)$s->fetchColumn() > 0;
    }

    private static function hasAdministrator(PDO $pdo): bool
    {
        if (!self::tableExists($pdo, 'users')) return false;
        $s = $pdo->query('SELECT COUNT(*) FROM users WHERE Access >= 40');
        return (int)$s->fetchColumn() > 0;
    }

    private static function validateAdmin(string $name, string $email, string $password): void
    {
        if (!preg_match('/^[a-z0-9_]{3,20}$/', $name)) throw new \RuntimeException('Admin username must be 3-20 letters, numbers, or underscores.');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($email) > 64) throw new \RuntimeException('Enter a valid administrator email.');
        if (strlen($password) < 8 || strlen($password) > 72) throw new \RuntimeException('Administrator password must be 8-72 characters.');
    }

    private static function ensureMapArrowRotationColumn(PDO $pdo): void
    {
        if (!self::tableExists($pdo, 'maps_arrows')) return;

        // v30.51: Direction is no longer restricted to only four enum values.
        // varchar keeps legacy values while allowing diagonal presets.
        $pdo->exec(
            "ALTER TABLE `maps_arrows`
             MODIFY COLUMN `Direction` varchar(32) NOT NULL DEFAULT 'Right'"
        );

        $check = $pdo->prepare(
            "SELECT COUNT(*) FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA=DATABASE()
               AND TABLE_NAME='maps_arrows'
               AND COLUMN_NAME='Rotation'"
        );
        $check->execute();

        if ((int)$check->fetchColumn() === 0) {
            $pdo->exec(
                "ALTER TABLE `maps_arrows`
                 ADD COLUMN `Rotation` double NULL AFTER `Direction`"
            );
        }
    }

    private static function ensureNpcImageColumns(PDO $pdo): void
    {
        if (!self::tableExists($pdo, 'npcs')) return;

        $columns = [
            'Image' => "ALTER TABLE `npcs` ADD COLUMN `Image` varchar(255) DEFAULT NULL AFTER `GroundID`",
            'ImageScale' => "ALTER TABLE `npcs` ADD COLUMN `ImageScale` double NOT NULL DEFAULT 1 AFTER `Image`",
            'ImageOffsetX' => "ALTER TABLE `npcs` ADD COLUMN `ImageOffsetX` double NOT NULL DEFAULT 0 AFTER `ImageScale`",
            'ImageOffsetY' => "ALTER TABLE `npcs` ADD COLUMN `ImageOffsetY` double NOT NULL DEFAULT 0 AFTER `ImageOffsetX`",
        ];

        $check = $pdo->prepare(
            "SELECT COUNT(*) FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='npcs' AND COLUMN_NAME=?"
        );
        foreach ($columns as $column => $sql) {
            $check->execute([$column]);
            if ((int)$check->fetchColumn() === 0) $pdo->exec($sql);
        }
    }

    private static function ensureMonsterPlacementColumns(PDO $pdo): void
    {
        if (!self::tableExists($pdo, 'maps_monsters')) return;

        $columns = [
            'X' => "ALTER TABLE `maps_monsters` ADD COLUMN `X` double NULL AFTER `Frame`",
            'Y' => "ALTER TABLE `maps_monsters` ADD COLUMN `Y` double NULL AFTER `X`",
            'Enabled' => "ALTER TABLE `maps_monsters` ADD COLUMN `Enabled` tinyint(1) NOT NULL DEFAULT 1 AFTER `Aggresive`",
        ];

        $check = $pdo->prepare(
            "SELECT COUNT(*) FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='maps_monsters' AND COLUMN_NAME=?"
        );

        foreach ($columns as $column => $sql) {
            $check->execute([$column]);
            if ((int)$check->fetchColumn() === 0) $pdo->exec($sql);
        }
    }

    public static function ensureWebTables(PDO $pdo): void
    {
        $statements = [
            "CREATE TABLE IF NOT EXISTS `game_sessions` (`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,`UserID` int(11) UNSIGNED NOT NULL,`TokenHash` char(64) NOT NULL,`CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,`ExpiresAt` datetime NOT NULL,`LastUsedAt` datetime NULL,`IPAddress` varchar(45) DEFAULT NULL,PRIMARY KEY (`id`),UNIQUE KEY `uq_game_sessions_token` (`TokenHash`),KEY `idx_game_sessions_user` (`UserID`),KEY `idx_game_sessions_expiry` (`ExpiresAt`),CONSTRAINT `fk_game_sessions_user` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
            "CREATE TABLE IF NOT EXISTS `news_posts` (`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,`Title` varchar(160) NOT NULL,`Slug` varchar(180) NOT NULL,`Excerpt` varchar(255) NOT NULL DEFAULT '',`Body` mediumtext NOT NULL,`Image` varchar(255) DEFAULT NULL,`Published` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,`Pinned` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,`AuthorID` int(11) UNSIGNED DEFAULT NULL,`PublishedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,`CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,`UpdatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`id`),UNIQUE KEY `uq_news_slug` (`Slug`),KEY `idx_news_published` (`Published`,`Pinned`,`PublishedAt`),CONSTRAINT `fk_news_author` FOREIGN KEY (`AuthorID`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
            "CREATE TABLE IF NOT EXISTS `site_settings` (`SettingKey` varchar(96) NOT NULL,`SettingValue` text NULL,`UpdatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`SettingKey`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
            "CREATE TABLE IF NOT EXISTS `admin_audit` (`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,`AdminUserID` int(11) UNSIGNED DEFAULT NULL,`Action` varchar(64) NOT NULL,`Entity` varchar(64) NOT NULL,`EntityID` varchar(64) DEFAULT NULL,`Details` text NULL,`IPAddress` varchar(45) DEFAULT NULL,`CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (`id`),KEY `idx_admin_audit_admin` (`AdminUserID`),KEY `idx_admin_audit_created` (`CreatedAt`),CONSTRAINT `fk_admin_audit_user` FOREIGN KEY (`AdminUserID`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
            AdminLogger::createSql(),
            "CREATE TABLE IF NOT EXISTS `admin_commands` (`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,`Command` varchar(32) NOT NULL,`Payload` text NULL,`RequestedBy` int(11) UNSIGNED DEFAULT NULL,`Status` enum('pending','processing','complete','failed') NOT NULL DEFAULT 'pending',`RequestedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,`ProcessedAt` datetime NULL,`Result` varchar(255) DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_admin_commands_status` (`Status`,`RequestedAt`),CONSTRAINT `fk_admin_commands_user` FOREIGN KEY (`RequestedBy`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
            "CREATE TABLE IF NOT EXISTS `maps_arrows` (`id` int(11) NOT NULL AUTO_INCREMENT,`MapID` int(11) NOT NULL DEFAULT 0,`Frame` varchar(50) NOT NULL DEFAULT 'Enter',`X` double NOT NULL DEFAULT 0,`Y` double NOT NULL DEFAULT 0,`Direction` varchar(32) NOT NULL DEFAULT 'Right',`Rotation` double DEFAULT NULL,`TargetType` enum('Room','Map') NOT NULL DEFAULT 'Room',`TargetMapID` int(11) DEFAULT NULL,`TargetFrame` varchar(50) NOT NULL DEFAULT 'Enter',`TargetPad` varchar(50) NOT NULL DEFAULT 'Spawn',`Enabled` tinyint(1) NOT NULL DEFAULT 1,`created_at` timestamp NULL DEFAULT NULL,`updated_at` timestamp NULL DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_maps_arrows_source` (`MapID`,`Frame`,`Enabled`),KEY `idx_maps_arrows_target_map` (`TargetMapID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci",
        ];
        foreach ($statements as $sql) $pdo->exec($sql);
        self::ensureNpcImageColumns($pdo);
        self::ensureMonsterPlacementColumns($pdo);
        self::ensureMapArrowRotationColumn($pdo);

        $pdo->exec("INSERT INTO `site_settings` (`SettingKey`,`SettingValue`) VALUES ('site.name','Aera'),('site.url','https://nightvaults.com/'),('site.tagline','A new beginning awaits.'),('game.base_url','https://nightvaults.com/'),('gamefiles.base_url','https://nightvaults.com/gamefiles/'),('registration.enabled','1'),('foundation.version','3.2.0') ON DUPLICATE KEY UPDATE `SettingValue`=VALUES(`SettingValue`)");
        if (self::tableExists($pdo, 'servers')) $pdo->exec("UPDATE `servers` SET `IP`='nightvaults.com',`Online`=0,`Count`=0");
        if (self::tableExists($pdo, 'users')) {
            try { $pdo->exec("UPDATE `users` SET `CurrentServer`='Offline'"); } catch (Throwable) {}
        }
    }

    private static function writeConfig(array $config): void
    {
        $storage = (string)Config::get('paths.storage');
        if (!is_dir($storage) && !@mkdir($storage, 0775, true) && !is_dir($storage)) {
            throw new \RuntimeException('Could not create web/storage. Give IIS_IUSRS Modify permission to the web folder.');
        }
        $path = $storage . '/config.php';
        $tmp = $path . '.tmp';
        $body = "<?php\ndeclare(strict_types=1);\nreturn " . var_export($config, true) . ";\n";
        if (file_put_contents($tmp, $body, LOCK_EX) === false) throw new \RuntimeException('Could not write web/storage/config.php. Give IIS_IUSRS Modify permission to web/storage.');
        if (is_file($path) && !@unlink($path)) {
            @unlink($tmp);
            throw new \RuntimeException('Could not replace web/storage/config.php. Check IIS write permissions.');
        }
        if (!@rename($tmp, $path)) {
            @unlink($tmp);
            throw new \RuntimeException('Could not finalize web/storage/config.php. Check IIS write permissions.');
        }
    }

    private static function applyRuntimeConfig(string $host, int $port, string $user, string $pass): void
    {
        Config::set('db.host', $host);
        Config::set('db.port', $port);
        Config::set('db.database', 'aera');
        Config::set('db.username', $user);
        Config::set('db.password', $pass);
        Database::reset();
    }

    private static function importSql(PDO $pdo, string $file): array
    {
        $fh = fopen($file, 'rb');
        if (!$fh) throw new \RuntimeException('Could not open aera.sql.');
        $delimiter = ';'; $buffer = ''; $warnings = []; $count = 0;
        try {
            while (($line = fgets($fh)) !== false) {
                $trim = trim($line);
                if (preg_match('/^DELIMITER\s+(.+)$/i', $trim, $m)) { $delimiter = $m[1]; continue; }
                $buffer .= $line;
                $rtrim = rtrim($buffer);
                if ($rtrim === '' || !str_ends_with($rtrim, $delimiter)) continue;
                $statement = trim(substr($rtrim, 0, -strlen($delimiter))); $buffer = '';
                if ($statement === '') continue;
                try { $pdo->exec($statement); $count++; }
                catch (Throwable $e) {
                    if (stripos($statement, 'CREATE EVENT') !== false) { $warnings[] = 'A scheduled reset event could not be created: ' . $e->getMessage(); continue; }
                    throw new \RuntimeException('Database import failed near statement ' . ($count + 1) . ': ' . $e->getMessage(), 0, $e);
                }
            }
            if (trim($buffer) !== '') $pdo->exec($buffer);
        } finally { fclose($fh); }
        return $warnings;
    }

    private static function upsertAdmin(PDO $pdo, string $name, string $email, string $password): void
    {
        $hash = password_hash($password, PASSWORD_BCRYPT);
        $s = $pdo->prepare('SELECT id FROM users WHERE LOWER(Name)=? LIMIT 1'); $s->execute([$name]); $id = $s->fetchColumn();
        if ($id) {
            $pdo->prepare('UPDATE users SET Hash=?,Email=?,Access=60,ActivationFlag=5 WHERE id=?')->execute([$hash, $email, (int)$id]);
            return;
        }
        $s = $pdo->prepare('SELECT id FROM users WHERE LOWER(Email)=LOWER(?) LIMIT 1'); $s->execute([$email]); $emailId = $s->fetchColumn();
        if ($emailId) throw new \RuntimeException('That administrator email already belongs to another imported account. Use a different email or that account username.');
        $pdo->prepare("INSERT INTO users (Name,Hash,Access,ActivationFlag,Email,ColorHair,ColorSkin,ColorEye,ColorBase,ColorTrim,ColorAccessory,HouseInfo,CurrentServer) VALUES (?,?,60,5,?,'5e4f37','eacd8a','1649e','000000','000000','000000','','Offline')")->execute([$name, $hash, $email]);
        $id = (int)$pdo->lastInsertId();
        foreach ([1, 2] as $item) {
            $q = $pdo->prepare('SELECT id FROM items WHERE id=?'); $q->execute([$item]);
            if ($q->fetchColumn()) $pdo->prepare('INSERT IGNORE INTO users_items (UserID,ItemID,EnhID,Equipped) VALUES (?,?,1,1)')->execute([$id, $item]);
        }
    }
}
