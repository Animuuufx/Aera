-- Aera Heartfall v2 - clean 10-map storyline rebuild
-- Replaces the old 20-map Heartfall content.
-- Map selection is based only on physical SWFs in web/public/gamefiles/maps.
-- Selected map SWFs were checked as AS3 and verified to contain an Enter frame.
-- MySQL 5.7.9 / phpMyAdmin compatible: no TEMPORARY-table reuse and no UNION text coercion.

CREATE TABLE IF NOT EXISTS `aera_content_packs` (
  `Name` varchar(64) NOT NULL PRIMARY KEY,
  `InstalledAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Clear stale procedures/staging from the retired Heartfall installers.
DROP PROCEDURE IF EXISTS `install_aera_heartfall`;
DROP PROCEDURE IF EXISTS `install_aera_heartfall_polish`;
DROP PROCEDURE IF EXISTS `install_aera_heartfall_10map`;
DROP TABLE IF EXISTS `hf_zone`;
DROP TABLE IF EXISTS `hf_skill`;
DROP TABLE IF EXISTS `hf_polish`;
DROP TABLE IF EXISTS `hf10_zone`;
DROP TABLE IF EXISTS `hf10_skill`;

-- Normal InnoDB staging tables are intentional for MySQL 5.7 compatibility.
CREATE TABLE `hf10_zone` (
  `seq` int NOT NULL PRIMARY KEY,
  `mapkey` varchar(32) NOT NULL,
  `title` varchar(64) NOT NULL,
  `swf` varchar(128) NOT NULL,
  `npc` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `slogan` text NOT NULL,
  `mob` varchar(64) NOT NULL,
  `mobfile` varchar(128) NOT NULL,
  `moblink` varchar(64) NOT NULL,
  `boss` varchar(64) NOT NULL,
  `bossfile` varchar(128) NOT NULL,
  `bosslink` varchar(64) NOT NULL,
  `mobtoken` varchar(64) NOT NULL,
  `bosstoken` varchar(64) NOT NULL,
  `armorname` varchar(64) NOT NULL,
  `armorfile` varchar(128) NOT NULL,
  `armorlink` varchar(64) NOT NULL,
  `swordname` varchar(64) NOT NULL,
  `swordfile` varchar(128) NOT NULL,
  `swordlink` varchar(64) NOT NULL,
  `prevkey` varchar(32) NOT NULL,
  `prevtitle` varchar(64) NOT NULL,
  `nextkey` varchar(32) NOT NULL,
  `nexttitle` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `hf10_zone` VALUES
(1,'dawnglen','Dawnglen','fawnforest.swf','Ranger Elowen','Dawnglen Ranger','Silver light is bleeding through the western roots. Hunt the warped pack and find who carried the first Heart shard east.','Dawnglen Direwolf','WolfDire.swf','WolfDire','Rootscar Ancient','Treeant.swf','Treeant','Silver-Torn Fang','Rootscar Heartwood','Dawnglen Ranger Garb','ForestKin2.swf','ForestKinBase','Dawnthorn Blade','items/swords/BasicRuneSwordDage.swf','BasicRuneSwordDage','newbie','Newbie','runeweald','Runeweald'),
(2,'runeweald','Runeweald','FoM-RunedWoodsV4.swf','Rune-Seer Taren','Rune-Seer','The old wardstones are answering the stolen shard. Recover the broken glyphs before the cult rewrites the road east.','Runeweald Shade','Shade1.swf','Shade1','Runebound Lich','Undeadlich.swf','UndeadLich1','Broken Ward Glyph','Lich Rune','Runeweald Seer Mantle','ForestKin2.swf','ForestKinBase','Runebound Edge','items/swords/BasicRuneSwordDage.swf','BasicRuneSwordDage','dawnglen','Dawnglen','blackbriar','Blackbriar'),
(3,'blackbriar','Blackbriar','Darkforest.swf','Captain Nyra','Thornwatch Captain','The cult crossed Blackbriar and woke the stone beneath the roots. Break their sentries and recover the thorn seal.','Blackbriar Stoneguard','StoneGolem1.swf','StoneGolem1','Thornheart Ancient','Treeant.swf','Treeant','Briar Stone','Thornheart Seal','Blackbriar Warden Armor','ForestKin2.swf','ForestKinBase','Briarcleaver','items/swords/BasicRuneSwordDage.swf','BasicRuneSwordDage','runeweald','Runeweald','mirewatch','Mirewatch'),
(4,'mirewatch','Mirewatch','marsh.swf','Mirekeeper Oss','Mirekeeper','The shard trail vanished beneath black water. The mire remembers every step; make its hunters reveal the drowned seal.','Mirefang Hound','WolfDire.swf','WolfDire','Mirewood Ancient','Treeant.swf','Treeant','Mirefang','Drowned Heartwood','Mirewatch Keeper Coat','ForestKin2.swf','ForestKinBase','Mirefang Blade','items/swords/BasicRuneSwordDage.swf','BasicRuneSwordDage','blackbriar','Blackbriar','hollowdeep','Hollowdeep'),
(5,'hollowdeep','Hollowdeep','CAVE3.swf','Archivist Kessa','Heart Archivist','The cavern walls record why the Aera Heart was divided: its fragments are locks, not trophies. Save the crystal record before the cult destroys it.','Hollowdeep Revenant','Shade1.swf','Shade1','Crystal Matriarch','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Memory Shard','Crystal Seal','Hollowdeep Delver Plate','AsgardianKnight.swf','AsgardianKnight','Crystalbreaker','items/swords/AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1','mirewatch','Mirewatch','dreadharbor','Dreadharbor'),
(6,'dreadharbor','Dreadharbor','DreddDocks.swf','Dockmaster Vale','Harbor Warden','The cult is shipping Heart fragments across the eastern sea. Smash their dock guard and seize the manifest before the last vessel leaves.','Harbor Iron Golem','StoneGolem1.swf','StoneGolem1','Dreadharbor Lich','Undeadlich.swf','UndeadLich1','Iron Dock Sigil','Black Manifest','Dreadharbor Corsair Coat','AsgardianKnight.swf','AsgardianKnight','Tidebreaker','items/swords/AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1','hollowdeep','Hollowdeep','frostgale','Frostgale'),
(7,'frostgale','Frostgale','frostgale.swf','Frostwarden Rook','Frostwarden','The manifest points north. A stolen fragment is freezing the pass solid and feeding a queen of the storm. Reclaim it before the road dies.','Frostfang Wolf','WolfDire.swf','WolfDire','Frostgale Matriarch','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Frozen Fang','Gale Crown','Frostgale Warden Mail','ArcticRanger.swf','ArcticRanger','Frostveil Reaver','items/swords/CCFrostReaver.swf','CCFrostReaver','dreadharbor','Dreadharbor','faroffheights','Faroff Heights'),
(8,'faroffheights','Faroff Heights','Aegle-FaroffV3.swf','Skywatcher Asha','Skywatcher','From the heights we can finally see the cult route: every stolen lock is converging on Akiba. Clear the sky-path and recover the star chart.','Skyveil Wraith','Shade1.swf','Shade1','Skyroot Ancient','Treeant.swf','Treeant','Skyveil Ash','Star Chart','Faroff Skyguard Raiment','ArcticRanger.swf','ArcticRanger','Skyglass Blade','items/swords/AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1','frostgale','Frostgale','akiba','Akiba'),
(9,'akiba','Akiba','Akiba.swf','Blade-Sage Ren','Blade-Sage','Akiba holds the last intact ward. The cult is already inside the city; restore the wardstones before their army reaches the inner gate.','Akiba Ward Golem','StoneGolem1.swf','StoneGolem1','Fallen Ward-Sage','Undeadlich.swf','UndeadLich1','Wardstone Chip','Sage Seal','Akiba Spiritguard','AsgardianKnight.swf','AsgardianKnight','Eastern Rune Blade','items/swords/AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1','faroffheights','Faroff Heights','akibawar','Siege of Akiba'),
(10,'akibawar','Siege of Akiba','AkibaWar.swf','Warden Kaori','Heart Warden','The cult has joined the stolen fragments into a false Heart. Break their war line, defeat the Heartfall Queen, and turn the fragments back into locks.','Heartfall War Hound','WolfDire.swf','WolfDire','Heartfall Queen','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Warbound Fang','False Heart Core','Akiba Heartguard Warplate','AsgardianKnight.swf','AsgardianKnight','Heartseal Blade','items/swords/AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1','akiba','Akiba','newbie','Newbie');

CREATE TABLE `hf10_skill` (
  `sid` int NOT NULL PRIMARY KEY,
  `classid` int NOT NULL,
  `name` varchar(64) NOT NULL,
  `damage` decimal(6,2) NOT NULL,
  `mana` int NOT NULL,
  `rangev` int NOT NULL,
  `refv` varchar(8) NOT NULL,
  `cooldown` int NOT NULL,
  `hits` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `hf10_skill` VALUES
(826001,825001,'Wild Strike',0.50,0,303,'aa',1500,1),
(826002,825001,'Briar Cut',1.05,10,303,'a1',3200,1),
(826003,825001,'Root Rush',1.35,18,303,'a2',5800,1),
(826004,825001,'Verdant Sweep',0.85,24,303,'a3',8500,2),
(826005,825001,'Thorn Verdict',2.25,30,303,'a4',14000,1),
(826006,825002,'Quick Shot',0.50,0,808,'aa',1500,1),
(826007,825002,'Frostline',1.05,10,808,'a1',3200,1),
(826008,825002,'Icebreak Arrow',1.35,18,808,'a2',5800,1),
(826009,825002,'Split Volley',0.85,24,808,'a3',8500,2),
(826010,825002,'Whiteout',2.25,30,808,'a4',14000,1),
(826011,825003,'Heart Strike',0.50,0,303,'aa',1500,1),
(826012,825003,'Seal Cut',1.05,10,303,'a1',3200,1),
(826013,825003,'Wardbreaker',1.35,18,303,'a2',5800,1),
(826014,825003,'Resonant Sweep',0.85,24,303,'a3',8500,2),
(826015,825003,'Aera Verdict',2.25,30,303,'a4',14000,1);

DELIMITER $$
CREATE PROCEDURE `install_aera_heartfall_10map`()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  SET @entryMap=(SELECT `id` FROM `maps` WHERE `Name`='newbie' LIMIT 1);
  IF @entryMap IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall v2 install failed: missing newbie entry map';
  END IF;

  START TRANSACTION;

  -- Remove every old Heartfall row first. 820000-829999 is reserved for this content pack.
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

  DELETE FROM `skills` WHERE `id` BETWEEN 820000 AND 829999;
  DELETE FROM `classes` WHERE `id` BETWEEN 820000 AND 829999 OR `ItemID` BETWEEN 820000 AND 829999;
  DELETE FROM `quests` WHERE `id` BETWEEN 820000 AND 829999;
  DELETE FROM `monsters` WHERE `id` BETWEEN 820000 AND 829999;
  DELETE FROM `npcs` WHERE `id` BETWEEN 820000 AND 829999;
  DELETE FROM `shops` WHERE `id` BETWEEN 820000 AND 829999;
  DELETE FROM `items` WHERE `id` BETWEEN 820000 AND 829999;
  DELETE FROM `maps` WHERE `id` BETWEEN 820000 AND 829999;

  DELETE FROM `aera_content_packs`
    WHERE `Name` IN ('aera-heartfall-starter-v1','aera-heartfall-polish-v1','aera-heartfall-10map-v2');

  -- 10 verified physical map SWFs from web/public/gamefiles/maps.
  INSERT INTO `maps` (`id`,`Name`,`File`,`MaxPlayers`,`ReqLevel`,`ReqParty`,`Upgrade`,`Staff`,`PvP`)
    SELECT 820000+seq,mapkey,swf,12,seq,0,0,0,0 FROM `hf10_zone`;

  -- Area quest drops.
  INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    SELECT 821000+(seq-1)*2,mobtoken,CONCAT('Story item recovered from ',mob,' in ',title,'.'),'Item','','','iibag','None',seq,100,50,10,1,20,0,0,0,1,0,0,1,0,0 FROM `hf10_zone`;
  INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    SELECT 821001+(seq-1)*2,bosstoken,CONCAT('Story item recovered from ',boss,' in ',title,'.'),'Item','','','iibag','None',seq,100,50,10,1,5,0,0,0,1,0,0,1,0,0 FROM `hf10_zone`;

  -- One armor and one weapon matched to every zone.
  INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    SELECT 822000+(seq-1)*2,armorname,CONCAT('Armor earned while defending ',title,' during Heartfall.'),'Armor',armorfile,armorlink,'iwarmor','co',seq,100,50,10,1,1,400+(seq-1)*300,0,1,0,0,0,1,1,1 FROM `hf10_zone`;
  INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    SELECT 822001+(seq-1)*2,swordname,CONCAT('A weapon reforged for the fighting in ',title,'.'),'Sword',swordfile,swordlink,'iwsword','Weapon',seq,100,50,10,1,1,350+(seq-1)*275,0,1,0,0,0,1,1,1 FROM `hf10_zone`;

  -- Three milestone classes using verified class/armor assets already in gamefiles/classes/M.
  INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`) VALUES
    (825001,'Thornwarden','Heartfall class earned after securing Blackbriar.','Class','ForestKin2.swf','ForestKinBase','iiclass','ar',3,100,50,10,1,1,0,0,1,0,0,0,1,1,1),
    (825002,'Frostveil Ranger','Heartfall class earned after reclaiming Frostgale.','Class','ArcticRanger.swf','ArcticRanger','iiclass','ar',7,100,50,10,1,1,0,0,1,0,0,0,1,1,1),
    (825003,'Heartblade','Final Heartfall class earned after the Siege of Akiba.','Class','AsgardianKnight.swf','AsgardianKnight','iiclass','ar',10,100,50,10,1,1,0,0,1,0,0,0,1,1,1);

  INSERT INTO `shops` (`id`,`Name`,`House`,`Upgrade`,`Staff`,`Limited`,`Field`)
    SELECT 820000+seq,CONCAT(title,' Armory'),0,0,0,0,'' FROM `hf10_zone`;

  INSERT INTO `npcs` (`id`,`Name`,`Gender`,`Job`,`Slogan`,`Level`,`Health`,`Mana`,`DPS`,`ColorHair`,`ColorSkin`,`ColorEye`,`ColorBase`,`ColorTrim`,`ColorAccessory`,`WeaponID`,`ArmorID`)
    SELECT 820000+seq,npc,IF(MOD(seq,2)=1,'F','M'),job,slogan,seq,1200+seq*180,100,0,'0x3A2D2A','0xD6AD8D','0x87CFFF','0x33475E','0xC5A96A','0x6B8CA8',822001+(seq-1)*2,822000+(seq-1)*2 FROM `hf10_zone`;
  INSERT INTO `npcs` (`id`,`Name`,`Gender`,`Job`,`Slogan`,`Level`,`Health`,`Mana`,`DPS`,`ColorHair`,`ColorSkin`,`ColorEye`,`ColorBase`,`ColorTrim`,`ColorAccessory`,`WeaponID`,`ArmorID`) VALUES
    (820000,'Heartfall Guide','F','Aera Courier','Heartfall has begun again. Start in Dawnglen and follow the stolen seals all the way to Akiba.',1,1200,100,0,'0x3A2D2A','0xD6AD8D','0x87CFFF','0x33475E','0xC5A96A','0x6B8CA8',822001,822000);

  -- Each zone gets its own named normal encounter and boss while using verified monster SWF/linkage pairs.
  INSERT INTO `monsters` (`id`,`Name`,`File`,`Linkage`,`Level`,`Health`,`Mana`,`Gold`,`Coin`,`Experience`,`ClassPoint`,`Reputation`,`DamageReduction`,`DPS`,`Respawn`,`Speed`,`Immune`)
    SELECT 823000+(seq-1)*2,mob,mobfile,moblink,seq,450+seq*220,100,20+seq*10,0,80+seq*35,6,3,0,10+seq*3,7,2200,0 FROM `hf10_zone`;
  INSERT INTO `monsters` (`id`,`Name`,`File`,`Linkage`,`Level`,`Health`,`Mana`,`Gold`,`Coin`,`Experience`,`ClassPoint`,`Reputation`,`DamageReduction`,`DPS`,`Respawn`,`Speed`,`Immune`)
    SELECT 823001+(seq-1)*2,boss,bossfile,bosslink,seq+1,1200+seq*600,100,75+seq*25,0,240+seq*95,15,8,0,18+seq*5,12,2200,0 FROM `hf10_zone`;

  -- Two story quests per zone: clear the local threat, then defeat the zone boss.
  INSERT INTO `quests` (`id`,`FactionID`,`Name`,`Description`,`EndText`,`Experience`,`Gold`,`Coins`,`ClassPoints`,`RewardType`,`Level`,`Upgrade`,`Once`,`Slot`,`Value`,`Field`,`Index`)
    SELECT 824000+(seq-1)*2,1,CONCAT(title,': Trace the Shard'),CONCAT('Defeat ',mob,' in ',title,' and recover 4 ',mobtoken,'. ',npc,' needs them to follow the Heart shard trail.'),CONCAT('The trail is clear. ',boss,' is holding the seal that opens the next road.'),300+seq*190,220+seq*140,0,80+seq*12,'S',seq,0,1,92,(seq-1)*2+1,'',-1 FROM `hf10_zone`;
  INSERT INTO `quests` (`id`,`FactionID`,`Name`,`Description`,`EndText`,`Experience`,`Gold`,`Coins`,`ClassPoints`,`RewardType`,`Level`,`Upgrade`,`Once`,`Slot`,`Value`,`Field`,`Index`)
    SELECT 824001+(seq-1)*2,1,CONCAT(title,': Break the Seal'),CONCAT('Defeat ',boss,' and recover ',bosstoken,'.'),IF(seq<10,CONCAT('The seal is ours. Continue to ',nexttitle,' before the cult can regroup.'),'The false Heart is broken. Its fragments are locks again, Akiba stands, and the Aera Heart is sealed against the darkness.'),550+seq*280,360+seq*210,0,140+seq*18,'S',seq,0,1,92,(seq-1)*2+2,'',-1 FROM `hf10_zone`;

  INSERT INTO `classes` (`id`,`ItemID`,`Category`,`Description`,`ManaRegenerationMethods`,`StatsDescription`) VALUES
    (825001,825001,'M1','Thornwarden guards living wards and turns the strength of the wild against Heartfall corruption.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival; Luck improves critical performance.'),
    (825002,825002,'M1','Frostveil Ranger hunts shard-bearers across frozen roads and broken ley-lines.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival; Luck improves critical performance.'),
    (825003,825003,'M1','Heartblade is the discipline of warriors who restored the Aera Heart locks at Akiba.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival; Luck improves critical performance.');

  INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`)
    SELECT sid,name,IF(refv='aa','Attack1,Attack2','Attack3'),IF(hits=2,'Strike up to two enemies.',IF(refv='aa','A basic weapon attack.','Deal physical weapon damage to one enemy.')),damage,mana,'iwsword',rangev,'',refv,'h','m','p','',cooldown,hits FROM `hf10_skill`;

  -- Put one story NPC in the Enter room of every verified map plus a guide in newbie.
  INSERT INTO `maps_npc` (`id`,`MapID`,`NpcID`,`NpcMapID`,`Frame`,`X`,`Y`,`Turn`)
    SELECT 827500+seq,820000+seq,820000+seq,1,'Enter',220,390,'Right' FROM `hf10_zone`;
  INSERT INTO `maps_npc` (`id`,`MapID`,`NpcID`,`NpcMapID`,`Frame`,`X`,`Y`,`Turn`) VALUES
    (827500,@entryMap,820000,820000,'Enter',235,395,'Right');

  -- Two normal placements and one boss placement per area, all on the verified Enter frame.
  INSERT INTO `maps_monsters` (`id`,`MapID`,`MonsterID`,`MonMapID`,`Frame`,`X`,`Y`,`Aggresive`,`Enabled`)
    SELECT 827600+(seq-1)*3+1,820000+seq,823000+(seq-1)*2,827600+(seq-1)*3+1,'Enter',470,405,0,1 FROM `hf10_zone`;
  INSERT INTO `maps_monsters` (`id`,`MapID`,`MonsterID`,`MonMapID`,`Frame`,`X`,`Y`,`Aggresive`,`Enabled`)
    SELECT 827600+(seq-1)*3+2,820000+seq,823000+(seq-1)*2,827600+(seq-1)*3+2,'Enter',650,405,0,1 FROM `hf10_zone`;
  INSERT INTO `maps_monsters` (`id`,`MapID`,`MonsterID`,`MonMapID`,`Frame`,`X`,`Y`,`Aggresive`,`Enabled`)
    SELECT 827600+(seq-1)*3+3,820000+seq,823001+(seq-1)*2,827600+(seq-1)*3+3,'Enter',800,405,0,1 FROM `hf10_zone`;

  -- Story/shop/navigation buttons for every area.
  INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 827000+(seq-1)*5+1,820000+seq,'quests','Story Quests',CONCAT(824000+(seq-1)*2,',',824001+(seq-1)*2),'' FROM `hf10_zone`;
  INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 827000+(seq-1)*5+2,820000+seq,'shop',CONCAT(title,' Armory'),CAST(820000+seq AS CHAR),'' FROM `hf10_zone`;
  INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 827000+(seq-1)*5+3,820000+seq,'join',IF(seq=1,'Return to Newbie',CONCAT('Previous: ',prevtitle)),CONCAT(prevkey,'|Enter|Spawn'),'' FROM `hf10_zone`;
  INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 827000+(seq-1)*5+4,820000+seq,'join',IF(seq=10,'Return to Newbie',CONCAT('Continue: ',nexttitle)),CONCAT(nextkey,'|Enter|Spawn'),'' FROM `hf10_zone`;
  INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 827000+(seq-1)*5+5,820000+seq,'join','Restart Heartfall','dawnglen|Enter|Spawn','' FROM `hf10_zone`;
  INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`) VALUES
    (827099,820000,'join','Begin Heartfall','dawnglen|Enter|Spawn','');

  -- Every area armory sells its matching armor and weapon.
  INSERT INTO `shops_items` (`id`,`ShopID`,`ItemID`,`QuantityRemain`)
    SELECT 827800+(seq-1)*2+1,820000+seq,822000+(seq-1)*2,0 FROM `hf10_zone`;
  INSERT INTO `shops_items` (`id`,`ShopID`,`ItemID`,`QuantityRemain`)
    SELECT 827800+(seq-1)*2+2,820000+seq,822001+(seq-1)*2,0 FROM `hf10_zone`;

  INSERT INTO `monsters_drops` (`id`,`MonsterID`,`ItemID`,`Chance`,`Quantity`)
    SELECT 827900+(seq-1)*2+1,823000+(seq-1)*2,821000+(seq-1)*2,1,1 FROM `hf10_zone`;
  INSERT INTO `monsters_drops` (`id`,`MonsterID`,`ItemID`,`Chance`,`Quantity`)
    SELECT 827900+(seq-1)*2+2,823001+(seq-1)*2,821001+(seq-1)*2,1,1 FROM `hf10_zone`;

  INSERT INTO `quests_requirements` (`id`,`QuestID`,`ItemID`,`Quantity`)
    SELECT 828000+(seq-1)*2+1,824000+(seq-1)*2,821000+(seq-1)*2,4 FROM `hf10_zone`;
  INSERT INTO `quests_requirements` (`id`,`QuestID`,`ItemID`,`Quantity`)
    SELECT 828000+(seq-1)*2+2,824001+(seq-1)*2,821001+(seq-1)*2,1 FROM `hf10_zone`;

  INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`)
    SELECT 828100+(sid-826000),sid,classid FROM `hf10_skill`;

  -- Main quest rewards: armor for the first quest, weapon for the boss quest.
  INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`)
    SELECT 829000+(seq-1)*2,824000+(seq-1)*2,822000+(seq-1)*2,1,1,'S' FROM `hf10_zone`;
  INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`)
    SELECT 829001+(seq-1)*2,824001+(seq-1)*2,822001+(seq-1)*2,1,1,'S' FROM `hf10_zone`;

  -- Milestone class rewards: Blackbriar, Frostgale, and the final Siege of Akiba.
  INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`) VALUES
    (829101,824005,825001,1,1,'S'),
    (829102,824013,825002,1,1,'S'),
    (829103,824019,825003,1,1,'S');

  INSERT INTO `aera_content_packs` (`Name`) VALUES ('aera-heartfall-10map-v2');

  COMMIT;
END$$
CALL `install_aera_heartfall_10map`()$$
DROP PROCEDURE `install_aera_heartfall_10map`$$
DELIMITER ;

DROP TABLE IF EXISTS `hf10_skill`;
DROP TABLE IF EXISTS `hf10_zone`;
