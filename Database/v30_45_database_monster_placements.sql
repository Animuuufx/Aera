-- Aera v30.45 - Database monster X/Y placements
-- MySQL 5.7 compatible and safe to run more than once.

SET @aera_db := DATABASE();

SET @aera_sql := IF(
    EXISTS(
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA=@aera_db AND TABLE_NAME='maps_monsters' AND COLUMN_NAME='X'
    ),
    'SELECT 1',
    'ALTER TABLE `maps_monsters` ADD COLUMN `X` double NULL AFTER `Frame`'
);
PREPARE aera_stmt FROM @aera_sql;
EXECUTE aera_stmt;
DEALLOCATE PREPARE aera_stmt;

SET @aera_sql := IF(
    EXISTS(
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA=@aera_db AND TABLE_NAME='maps_monsters' AND COLUMN_NAME='Y'
    ),
    'SELECT 1',
    'ALTER TABLE `maps_monsters` ADD COLUMN `Y` double NULL AFTER `X`'
);
PREPARE aera_stmt FROM @aera_sql;
EXECUTE aera_stmt;
DEALLOCATE PREPARE aera_stmt;

SET @aera_sql := IF(
    EXISTS(
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA=@aera_db AND TABLE_NAME='maps_monsters' AND COLUMN_NAME='Enabled'
    ),
    'SELECT 1',
    'ALTER TABLE `maps_monsters` ADD COLUMN `Enabled` tinyint(1) NOT NULL DEFAULT 1 AFTER `Aggresive`'
);
PREPARE aera_stmt FROM @aera_sql;
EXECUTE aera_stmt;
DEALLOCATE PREPARE aera_stmt;

-- Existing rows intentionally keep X/Y = NULL.
-- NULL means "use the old monster marker inside the map SWF".
-- Set X and Y in Admin > Data > Maps Monsters to switch that instance
-- to database-driven placement.
