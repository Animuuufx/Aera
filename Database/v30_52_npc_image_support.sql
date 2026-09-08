-- Aera v30.52 - image-backed database NPC support
-- MySQL 5.7 compatible and safe to run repeatedly.

SET @aera_schema := DATABASE();

SET @q := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@aera_schema AND TABLE_NAME='npcs' AND COLUMN_NAME='Image')=0,
  'ALTER TABLE `npcs` ADD COLUMN `Image` varchar(255) DEFAULT NULL AFTER `GroundID`',
  'SELECT 1'
);
PREPARE s FROM @q; EXECUTE s; DEALLOCATE PREPARE s;

SET @q := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@aera_schema AND TABLE_NAME='npcs' AND COLUMN_NAME='ImageScale')=0,
  'ALTER TABLE `npcs` ADD COLUMN `ImageScale` double NOT NULL DEFAULT 1 AFTER `Image`',
  'SELECT 1'
);
PREPARE s FROM @q; EXECUTE s; DEALLOCATE PREPARE s;

SET @q := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@aera_schema AND TABLE_NAME='npcs' AND COLUMN_NAME='ImageOffsetX')=0,
  'ALTER TABLE `npcs` ADD COLUMN `ImageOffsetX` double NOT NULL DEFAULT 0 AFTER `ImageScale`',
  'SELECT 1'
);
PREPARE s FROM @q; EXECUTE s; DEALLOCATE PREPARE s;

SET @q := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@aera_schema AND TABLE_NAME='npcs' AND COLUMN_NAME='ImageOffsetY')=0,
  'ALTER TABLE `npcs` ADD COLUMN `ImageOffsetY` double NOT NULL DEFAULT 0 AFTER `ImageOffsetX`',
  'SELECT 1'
);
PREPARE s FROM @q; EXECUTE s; DEALLOCATE PREPARE s;
