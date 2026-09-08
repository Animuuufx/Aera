-- Aera v30.51 - More database map-arrow directions
-- MySQL 5.7 compatible.
--
-- Expands Direction from the old 4-value enum to varchar(32), allowing
-- the panel to store 16 named direction presets.
--
-- Also adds Rotation if v30.50 was not installed yet.

ALTER TABLE `maps_arrows`
    MODIFY COLUMN `Direction` varchar(32) NOT NULL DEFAULT 'Right';

SET @aera_db := DATABASE();

SET @aera_sql := IF(
    EXISTS(
        SELECT 1
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA=@aera_db
          AND TABLE_NAME='maps_arrows'
          AND COLUMN_NAME='Rotation'
    ),
    'SELECT 1',
    'ALTER TABLE `maps_arrows` ADD COLUMN `Rotation` double NULL AFTER `Direction`'
);

PREPARE aera_stmt FROM @aera_sql;
EXECUTE aera_stmt;
DEALLOCATE PREPARE aera_stmt;
