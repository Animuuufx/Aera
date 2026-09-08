-- Aera v30.79 - Complete Enhancement System Fixes
-- MySQL 5.7 compatible and idempotent.
-- Fixes: pattern-id mismatch (Lucky=9 for the client), exact client pattern stats,
-- persistent enhancement item identity, level 1-100 resolution, slot normalization,
-- trade persistence, and legacy data migration.

USE `aera`;
SET FOREIGN_KEY_CHECKS=0;

-- Persist the actual enhancement ITEM selected by the player separately from the
-- enhancement definition FK. This is required because users_items.EnhID is an FK
-- to enhancements, while the newer client expects EnhID in packets to be an item id.
SET @sql := IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='users_items' AND COLUMN_NAME='EnhItemID')=0, 'ALTER TABLE `users_items` ADD COLUMN `EnhItemID` int(11) UNSIGNED NULL AFTER `EnhID`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='users_markets')>0 AND (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='users_markets' AND COLUMN_NAME='EnhItemID')=0, 'ALTER TABLE `users_markets` ADD COLUMN `EnhItemID` int(11) UNSIGNED NULL AFTER `EnhID`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql := IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='users_trades_items')>0 AND (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='users_trades_items' AND COLUMN_NAME='EnhItemID')=0, 'ALTER TABLE `users_trades_items` ADD COLUMN `EnhItemID` int(11) UNSIGNED NULL AFTER `EnhID`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Client patterns include negative stat weights (for example Vim/Examen/Hearty).
-- The original schema used UNSIGNED tinyints, so widen these columns to signed
-- tinyints before importing the native client pattern table.
ALTER TABLE `enhancements_patterns`
  MODIFY `Wisdom` tinyint NOT NULL,
  MODIFY `Strength` tinyint NOT NULL,
  MODIFY `Luck` tinyint NOT NULL,
  MODIFY `Dexterity` tinyint NOT NULL,
  MODIFY `Endurance` tinyint NOT NULL,
  MODIFY `Intelligence` tinyint NOT NULL;

-- Exact enhancement pattern ids/stat weights from the current client source.
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (1,'Adventurer','none',16,16,0,16,18,16) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (2,'Fighter','M1',0,44,0,13,43,0) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (3,'Thief','M2',0,30,0,45,25,0) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (4,'Armsman','M4',0,38,0,36,26,0) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (5,'Hybrid','M3',0,28,0,20,25,27) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (6,'Wizard','C1',20,0,20,0,10,50) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (7,'Healer','C2',15,0,0,0,40,45) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (8,'Spellbreaker','C3',30,0,10,0,20,40) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (9,'Lucky','S1',10,10,50,10,10,10) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (10,'Forge','Blacksmith',0,25,50,0,0,25) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (11,'Absolution','Smith',0,25,50,0,0,25) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (12,'Avarice','Smith',0,25,50,0,0,25) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (23,'Depths','S1',0,0,50,0,0,50) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (24,'Vainglory','Smith',0,25,50,0,0,25) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (25,'Vim','SmithP2',0,10,50,130,-90,0) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (26,'Examen','SmithP2',130,0,50,0,-90,10) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (27,'Pneuma','SmithP2',24,24,0,24,-90,118) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (28,'Anima','SmithP2',16,134,0,24,-90,16) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (29,'Penitence','SmithP2',0,25,50,0,0,25) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (30,'Lament','SmithP2',0,25,50,0,0,25) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);
INSERT INTO `enhancements_patterns` (`id`,`Name`,`Desc`,`Wisdom`,`Strength`,`Luck`,`Dexterity`,`Endurance`,`Intelligence`) VALUES (32,'Hearty','Grimskull Troll Enhancement',-20,-20,-20,-20,150,-20) ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`),`Desc`=VALUES(`Desc`),`Wisdom`=VALUES(`Wisdom`),`Strength`=VALUES(`Strength`),`Luck`=VALUES(`Luck`),`Dexterity`=VALUES(`Dexterity`),`Endurance`=VALUES(`Endurance`),`Intelligence`=VALUES(`Intelligence`);

-- Correct the three current enhancement families and all generated definition rows.
UPDATE `enhancements` SET `PatternID`=1 WHERE LOWER(`Name`) LIKE 'adventurer enhancement%';
UPDATE `enhancements` SET `PatternID`=2 WHERE LOWER(`Name`) LIKE 'fighter enhancement%';
UPDATE `enhancements` SET `PatternID`=9 WHERE LOWER(`Name`) LIKE 'lucky enhancement%';
UPDATE `enhancements` SET `PatternID`=9 WHERE LOWER(`Name`)='lucky enhacement';

-- Ensure generated Lucky definitions from the v30.76 catalog use client PatternID 9.
UPDATE `enhancements` SET `PatternID`=9 WHERE `id` BETWEEN 100201 AND 100300;

-- Migrate any legacy rows where EnhID was incorrectly populated with the enhancement item id.
UPDATE `users_items` ui INNER JOIN `items` ei ON ei.`id`=ui.`EnhID` AND LOWER(ei.`Type`)='enhancement' SET ui.`EnhItemID`=ei.`id`, ui.`EnhID`=ei.`EnhID` WHERE ui.`EnhID` IS NOT NULL;

-- If EnhItemID is present but EnhID is empty, restore the definition FK from the item.
UPDATE `users_items` ui INNER JOIN `items` ei ON ei.`id`=ui.`EnhItemID` AND LOWER(ei.`Type`)='enhancement' SET ui.`EnhID`=ei.`EnhID` WHERE (ui.`EnhID` IS NULL OR ui.`EnhID`=0) AND ui.`EnhItemID` IS NOT NULL;

-- Backfill a canonical enhancement item for old definition-only records where there
-- is an unambiguous matching catalog row. This does not change the definition FK.
UPDATE `users_items` ui INNER JOIN `items` target ON target.`id`=ui.`ItemID` INNER JOIN `items` ei ON LOWER(ei.`Type`)='enhancement' AND ei.`EnhID`=ui.`EnhID` AND ei.`Equipment`=target.`Equipment` SET ui.`EnhItemID`=ei.`id` WHERE (ui.`EnhItemID` IS NULL OR ui.`EnhItemID`=0) AND ui.`EnhID`>0;

-- Upgrade existing generated enhancement ITEM rows to the correct family definition
-- for their own level. Covers 900xxx-style legacy catalogs too when the item name
-- identifies Lucky/Fighter; generic Weapon/Helm/Cape/Class rows default to Adventurer.
UPDATE `items` i INNER JOIN `enhancements` e ON e.`Level`=i.`Level` AND e.`PatternID`=CASE WHEN LOWER(i.`Name`) LIKE '%lucky%' THEN 9 WHEN LOWER(i.`Name`) LIKE '%fighter%' THEN 2 ELSE 1 END SET i.`EnhID`=e.`id` WHERE LOWER(i.`Type`)='enhancement' AND i.`Level` BETWEEN 1 AND 100;

-- Persist exact enhancement item id in auction records when the schema supports it.
UPDATE `users_markets` um INNER JOIN `items` ei ON ei.`id`=um.`EnhID` AND LOWER(ei.`Type`)='enhancement' SET um.`EnhItemID`=ei.`id`, um.`EnhID`=ei.`EnhID` WHERE um.`EnhID` IS NOT NULL;
SET FOREIGN_KEY_CHECKS=1;
