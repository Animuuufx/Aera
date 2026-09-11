-- Aera Rifts. Import once before restarting the emulator. MySQL 5.7+.
CREATE TABLE IF NOT EXISTS rift_definitions (
 `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 `Name` VARCHAR(100) NOT NULL,
 `Map` VARCHAR(64) NOT NULL,
 `Enabled` TINYINT NOT NULL DEFAULT 0,
 `InvaderID` INT NOT NULL,
 `EliteID` INT NOT NULL,
 `CrystalID` INT NOT NULL,
 `CommanderID` INT NOT NULL,
 `KillGoal` INT NOT NULL DEFAULT 40,
 `CrystalGoal` INT NOT NULL DEFAULT 8,
 `MaterialGoal` INT NOT NULL DEFAULT 20,
 `DefenseSeconds` INT NOT NULL DEFAULT 60,
 `DurationSeconds` INT NOT NULL DEFAULT 1800,
 `BaseShards` INT NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS rift_events (
 `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 `Server` VARCHAR(64) NOT NULL,
 `DefinitionID` INT NOT NULL,
 `Map` VARCHAR(64) NOT NULL,
 `Tier` VARCHAR(20) NOT NULL,
 `Modifier` VARCHAR(20) NOT NULL,
 `Status` VARCHAR(20) NOT NULL DEFAULT 'active',
 `State` MEDIUMTEXT NOT NULL,
 `StartedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `EndedAt` DATETIME NULL,
 KEY server_status (Server,Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS rift_rewards (
 `EventID` BIGINT UNSIGNED NOT NULL,
 `UserID` INT NOT NULL,
 `Score` BIGINT NOT NULL,
 `Medal` VARCHAR(20) NOT NULL,
 `Shards` INT NOT NULL,
 `Damage` BIGINT NOT NULL,
 `Kills` INT NOT NULL,
 `Objectives` INT NOT NULL,
 PRIMARY KEY (EventID,UserID), KEY user_history (UserID,EventID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS users_rifts (
 `UserID` INT PRIMARY KEY,
 `Shards` BIGINT NOT NULL DEFAULT 0,
 `RiftsClosed` INT NOT NULL DEFAULT 0,
 `LegendaryClosed` INT NOT NULL DEFAULT 0,
 `BossesDefeated` INT NOT NULL DEFAULT 0,
 `HighestContribution` BIGINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS rift_shop (
 `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 `ItemID` INT NOT NULL,
 `Cost` INT NOT NULL,
 `Quantity` INT NOT NULL DEFAULT 1,
 `Enabled` TINYINT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Definitions deliberately require real map/monster IDs from your content database.
CREATE TABLE IF NOT EXISTS rift_purchases (
 `Token` CHAR(64) PRIMARY KEY,
 `UserID` INT NOT NULL,
 `ShopID` INT NOT NULL,
 `Cost` INT NOT NULL,
 `CreatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Configure them through /admin/rifts; no asset filenames or production IDs are assumed.
