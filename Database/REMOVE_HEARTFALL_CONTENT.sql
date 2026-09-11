-- Remove all Heartfall content added by the retired v30_82/v30_83/v30_84 migrations.
-- MySQL 5.7.9 / phpMyAdmin compatible.
-- This intentionally clears the 820000-829999 ID range that was reserved for Heartfall.

DROP PROCEDURE IF EXISTS `install_aera_heartfall`;
DROP PROCEDURE IF EXISTS `install_aera_heartfall_polish`;
DROP PROCEDURE IF EXISTS `install_aera_heartfall_10map`;

DROP TABLE IF EXISTS `hf_zone`;
DROP TABLE IF EXISTS `hf_skill`;
DROP TABLE IF EXISTS `hf_polish`;
DROP TABLE IF EXISTS `hf10_zone`;
DROP TABLE IF EXISTS `hf10_skill`;

START TRANSACTION;

-- Remove dependent rows first.
DELETE FROM `quests_rewards`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `QuestID` BETWEEN 820000 AND 829999
    OR `ItemID` BETWEEN 820000 AND 829999;

DELETE FROM `quests_requirements`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `QuestID` BETWEEN 820000 AND 829999
    OR `ItemID` BETWEEN 820000 AND 829999;

DELETE FROM `monsters_drops`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `MonsterID` BETWEEN 820000 AND 829999
    OR `ItemID` BETWEEN 820000 AND 829999;

DELETE FROM `shops_items`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `ShopID` BETWEEN 820000 AND 829999
    OR `ItemID` BETWEEN 820000 AND 829999;

DELETE FROM `npcs_buttons`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `NPCID` BETWEEN 820000 AND 829999;

DELETE FROM `maps_monsters`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `MapID` BETWEEN 820000 AND 829999
    OR `MonsterID` BETWEEN 820000 AND 829999;

DELETE FROM `maps_npc`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `MapID` BETWEEN 820000 AND 829999
    OR `NpcID` BETWEEN 820000 AND 829999;

DELETE FROM `skills_assign`
 WHERE `id` BETWEEN 820000 AND 829999
    OR `SkillID` BETWEEN 820000 AND 829999
    OR `ItemID` BETWEEN 820000 AND 829999;

-- Remove the actual Heartfall records.
DELETE FROM `skills`   WHERE `id` BETWEEN 820000 AND 829999;
DELETE FROM `classes`  WHERE `id` BETWEEN 820000 AND 829999 OR `ItemID` BETWEEN 820000 AND 829999;
DELETE FROM `quests`   WHERE `id` BETWEEN 820000 AND 829999;
DELETE FROM `monsters` WHERE `id` BETWEEN 820000 AND 829999;
DELETE FROM `npcs`     WHERE `id` BETWEEN 820000 AND 829999;
DELETE FROM `shops`    WHERE `id` BETWEEN 820000 AND 829999;
DELETE FROM `items`    WHERE `id` BETWEEN 820000 AND 829999;
DELETE FROM `maps`     WHERE `id` BETWEEN 820000 AND 829999;

-- Remove Heartfall install markers if the bookkeeping table exists.
CREATE TABLE IF NOT EXISTS `aera_content_packs` (
  `Name` varchar(64) NOT NULL PRIMARY KEY,
  `InstalledAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM `aera_content_packs`
 WHERE `Name` IN (
   'aera-heartfall-starter-v1',
   'aera-heartfall-polish-v1',
   'aera-heartfall-10map-v2'
 );

COMMIT;

SELECT 'Heartfall content removed. You can now add your own maps/content.' AS `Result`;
