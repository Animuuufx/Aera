-- Aera Heartfall progression/content polish
-- Follow-up for v30_82_aera_heartfall.sql. Safe for databases that already installed the base Heartfall pack.
-- MySQL 5.7.9 compatible.

CREATE TABLE IF NOT EXISTS `aera_content_packs` (
  `Name` varchar(64) NOT NULL PRIMARY KEY,
  `InstalledAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TEMPORARY TABLE IF EXISTS `hf_polish`;
CREATE TEMPORARY TABLE `hf_polish` (
  `seq` int NOT NULL PRIMARY KEY,
  `title` varchar(64) NOT NULL,
  `mobname` varchar(64) NOT NULL,
  `bossname` varchar(64) NOT NULL
);

-- Names are deliberately matched to the six monster SWF/linkage archetypes used by v30_82.
-- Normal cycle: WolfDire / Shade1 / StoneGolem1.
-- Boss cycle: Treeant / FrostQueenBhtNoth / UndeadLich1.
INSERT INTO `hf_polish` (`seq`,`title`,`mobname`,`bossname`) VALUES
(1,'Aera Wake','Wake Direwolf','Wake Rootguard'),
(2,'Auralis','Auralis Rift Shade','Riftbound Matriarch'),
(3,'Greenward','Greenward Stone Golem','Greenward Blight Lich'),
(4,'Runed Woods','Runebound Direwolf','Runewood Ancient'),
(5,'Blackbriar','Blackbriar Shade','Blackbriar Thorn Queen'),
(6,'Mirewatch','Mirestone Golem','Mire Lich'),
(7,'Underpath','Underpath Direwolf','Buried Root Sentinel'),
(8,'Deep Cavern','Cavern Revenant','Crystal Queen'),
(9,'Dredd Docks','Dredd Dock Golem','Dredd Dock Lich'),
(10,'Crystal Cove','Cove Direwolf','Cove Root Guardian'),
(11,'Frostgale','Frostgale Wraith','Gale Matriarch'),
(12,'Frozen Fang','Frozen Stone Sentry','Frozen Lich Castellan'),
(13,'Lost Ruins','Ruin Hound','Ruinroot Ancient'),
(14,'Dethertombs','Tomb Shade','Ossuary Queen'),
(15,'Doomwood','Doomwood Rot Golem','Doomwood Rot Lich'),
(16,'Dragonfire Citadel','Ember Hound','Emberwood Ancient'),
(17,'Infernal Gate','Infernal Shade','Infernal Rift Queen'),
(18,'Shadowmoor','Ritual Stone Sentinel','Ritual Lich'),
(19,'Starfall','Starfall Hound','Starroot Ancient'),
(20,'Celestial Depths','Null Echo','Null Queen Avatar');

DELIMITER $$
DROP PROCEDURE IF EXISTS `install_aera_heartfall_polish`$$
CREATE PROCEDURE `install_aera_heartfall_polish`()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

  IF NOT EXISTS (SELECT 1 FROM `aera_content_packs` WHERE `Name`='aera-heartfall-starter-v1') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall polish failed: install v30_82_aera_heartfall.sql first';
  END IF;

  START TRANSACTION;

  IF NOT EXISTS (SELECT 1 FROM `aera_content_packs` WHERE `Name`='aera-heartfall-polish-v1') THEN
    -- Make the 20-map route a real level 1-20 progression instead of allowing every zone at level 1.
    UPDATE `maps` m
    JOIN `hf_polish` z ON m.`id`=820000+z.`seq`
    SET m.`ReqLevel`=z.`seq`;

    -- Quest level requirements follow their zone. Existing gear already uses the zone level in v30_82.
    UPDATE `quests` q
    JOIN `hf_polish` z ON q.`id` IN (824000+(z.`seq`-1)*2,824001+(z.`seq`-1)*2)
    SET q.`Level`=z.`seq`;

    -- v30_82 intentionally reuses known-good monster files. Rename the encounters so the displayed
    -- creature names agree with the actual SWF/linkage being loaded instead of presenting a wisp as a wolf, etc.
    UPDATE `monsters` m
    JOIN `hf_polish` z ON m.`id`=823000+(z.`seq`-1)*2
    SET m.`Name`=z.`mobname`;

    UPDATE `monsters` m
    JOIN `hf_polish` z ON m.`id`=823001+(z.`seq`-1)*2
    SET m.`Name`=z.`bossname`;

    -- Keep quest/drop text synchronized with those corrected encounter names.
    UPDATE `items` i
    JOIN `hf_polish` z ON i.`id`=821000+(z.`seq`-1)*2
    SET i.`Description`=CONCAT('Heartfall quest item from ',z.`mobname`,' in ',z.`title`,'.');

    UPDATE `items` i
    JOIN `hf_polish` z ON i.`id`=821001+(z.`seq`-1)*2
    SET i.`Description`=CONCAT('Heartfall quest item from ',z.`bossname`,' in ',z.`title`,'.');

    UPDATE `quests` q
    JOIN `hf_polish` z ON q.`id`=824000+(z.`seq`-1)*2
    JOIN `items` i ON i.`id`=821000+(z.`seq`-1)*2
    SET q.`Description`=CONCAT('Defeat ',z.`mobname`,' in ',z.`title`,' and recover 4 ',i.`Name`,'. The evidence will reveal what is holding this part of the Heartfall trail.');

    UPDATE `quests` q
    JOIN `hf_polish` z ON q.`id`=824001+(z.`seq`-1)*2
    JOIN `items` i ON i.`id`=821001+(z.`seq`-1)*2
    SET q.`Description`=CONCAT('Defeat ',z.`bossname`,' in ',z.`title`,' and recover ',i.`Name`,'.');

    -- Every zone now awards its matching armor and weapon through the story quests, not only through its shop.
    -- Milestone class rewards from v30_82 remain on quests 824009, 824019 and 824039 as additional rewards.
    INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`)
      SELECT 829000+(z.`seq`-1)*2,824000+(z.`seq`-1)*2,822000+(z.`seq`-1)*2,1,1,'S'
      FROM `hf_polish` z
      UNION ALL
      SELECT 829001+(z.`seq`-1)*2,824001+(z.`seq`-1)*2,822001+(z.`seq`-1)*2,1,1,'S'
      FROM `hf_polish` z;

    INSERT INTO `aera_content_packs` (`Name`) VALUES ('aera-heartfall-polish-v1');
  END IF;

  COMMIT;
END$$
CALL `install_aera_heartfall_polish`()$$
DROP PROCEDURE `install_aera_heartfall_polish`$$
DELIMITER ;

DROP TEMPORARY TABLE IF EXISTS `hf_polish`;
