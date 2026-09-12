-- Aera Expeditions v1. MySQL 5.7.9: InnoDB, no JSON defaults, CTEs or window functions.
-- Import after the normal base schema. Existing map assets and placements are reused.
CREATE TABLE IF NOT EXISTS expedition_maps (
 `Map` VARCHAR(64) PRIMARY KEY,
 `Enabled` TINYINT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT IGNORE INTO expedition_maps (Map)
 SELECT DISTINCT m.Name FROM maps m INNER JOIN maps_monsters mm ON mm.MapID=m.id
 WHERE m.PvP=0 AND m.Staff=0 AND m.Upgrade=0 AND m.ReqLevel<=1 AND m.ReqParty=0
 ORDER BY m.Name LIMIT 8;
CREATE TABLE IF NOT EXISTS expedition_runs (
 `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 `Server` VARCHAR(64) NOT NULL,
 `Mode` VARCHAR(16) NOT NULL,
 `Seed` VARCHAR(80) NOT NULL,
 `WeekKey` VARCHAR(8) NOT NULL,
 `RulesVersion` INT NOT NULL DEFAULT 1,
 `Status` VARCHAR(20) NOT NULL DEFAULT 'active',
 `Depth` INT NOT NULL DEFAULT 0,
 `StartedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `EndedAt` DATETIME NULL,
 KEY active_server (Server,Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Freeze content for the entire ISO week, even across restarts or world-cache reloads.
CREATE TABLE IF NOT EXISTS expedition_weeks (
 `WeekKey` VARCHAR(8) NOT NULL,
 `RulesVersion` INT NOT NULL,
 `Content` MEDIUMTEXT NOT NULL,
 PRIMARY KEY (WeekKey,RulesVersion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS expedition_rewards (
 `RunID` BIGINT UNSIGNED NOT NULL,
 `UserID` INT NOT NULL,
 `Marks` INT NOT NULL,
 PRIMARY KEY (RunID,UserID), KEY user_history (UserID,RunID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS users_expeditions (
 `UserID` INT PRIMARY KEY,
 `Marks` BIGINT NOT NULL DEFAULT 0,
 `TotalEarned` BIGINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS expedition_weekly (
 `WeekKey` VARCHAR(8) NOT NULL,
 `RulesVersion` INT NOT NULL,
 `UserID` INT NOT NULL,
 `Depth` INT NOT NULL,
 `ElapsedMs` INT NOT NULL,
 `RunID` BIGINT UNSIGNED NOT NULL,
 PRIMARY KEY (WeekKey,RulesVersion,UserID), KEY ranking (WeekKey,RulesVersion,Depth,ElapsedMs)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Reward catalogue scaffolding. Fulfillment is intentionally not enabled in v1.
CREATE TABLE IF NOT EXISTS expedition_shop (
 `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 `ItemID` INT NOT NULL,
 `Cost` INT NOT NULL,
 `Quantity` INT NOT NULL DEFAULT 1,
 `Enabled` TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
