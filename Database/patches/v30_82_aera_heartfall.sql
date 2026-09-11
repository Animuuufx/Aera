-- Aera Heartfall starter storyline
-- Fresh 20-map progression. Uses map/item/monster SWFs already present in gamefiles.
-- MySQL 5.7.9 compatible. Reserved IDs 820000-829999; quest slot 91.

CREATE TABLE IF NOT EXISTS `aera_content_packs` (`Name` varchar(64) NOT NULL PRIMARY KEY, `InstalledAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- MySQL 5.7 cannot reopen the same TEMPORARY TABLE more than once in one statement.
-- Heartfall intentionally reuses this staging data in UNION ALLs/subqueries, so use throwaway normal tables.
DROP TABLE IF EXISTS `hf_zone`;
CREATE TABLE `hf_zone` (
  `seq` int NOT NULL PRIMARY KEY, `mapkey` varchar(32) NOT NULL, `title` varchar(64) NOT NULL, `swf` varchar(128) NOT NULL,
  `npc` varchar(64) NOT NULL, `job` varchar(64) NOT NULL, `slogan` text NOT NULL,
  `mob` varchar(64) NOT NULL, `boss` varchar(64) NOT NULL, `mobtoken` varchar(64) NOT NULL, `bosstoken` varchar(64) NOT NULL,
  `armorname` varchar(64) NOT NULL, `swordname` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `hf_zone` VALUES
(1,'aerawake','Aera Wake','tutorial-ani.swf','Echo Scribe Mira','Echo Scribe','You woke beneath a sky split by silver fire. Follow the echoes, learn to fight, and carry this message to Auralis.','Fracture Wisp','Fallen Wakeguard','Echo Dust','Broken Wake Sigil','Wakebound Garb','Echoedge'),
(2,'auralis','Auralis','Auralis_BattleonReplacement_FINAL.swf','Warden Lyra','Auralis Warden','The Aera Heart shattered last night. Every road is changing. We need someone untouched by the old oaths to trace the first shard.','Heartfall Marauder','Riftbound Captain','Rift Mark','Captain''s Seal','Auralis Recruit Garb','Auralis Watchblade'),
(3,'greenward','Greenward','fawnforest.swf','Ranger Tovin','Greenward Ranger','Black resin is moving through the roots toward the city. Hunt the blighted pack and find what is poisoning the wardstones.','Blightfang','Rootbound Alpha','Tainted Resin','Alpha Thorn','Greenward Leathers','Thorncutter'),
(4,'runedwoods','Runed Woods','FoM-RunedWoodsV4.swf','Rune-Seer Elian','Rune-Seer','These runes once carried the Heart''s pulse. Now a foreign rhythm is answering from beneath them. Gather the glyphs before they burn out.','Rune Wisp','Glyph Warden','Loose Glyph','Warden Rune','Runeseer Mantle','Glyphblade'),
(5,'blackbriar','Blackbriar','Darkforest.swf','Thornwatch Nyra','Thornwatch Captain','The corruption has a direction. Something dragged a Heart fragment through Blackbriar and left the forest fighting itself.','Blackbriar Wolf','Thornheart','Briar Fang','Thornheart Core','Blackbriar Guard','Briarbrand'),
(6,'mirewatch','Mirewatch','marsh.swf','Mirekeeper Oss','Mirekeeper','The trail vanished into the mire, but the water remembers. Pull the shadow-moss from its servants and the swamp will show us the way.','Mire Shade','Bog Colossus','Shadow Moss','Bog Heart','Mirewatch Coat','Bogsplitter'),
(7,'underpath','Underpath','TUNNEL.swf','Delver Bran','Delver','Smugglers used these tunnels long before Heartfall. Now something below is paying them in star-metal. Clear the route and recover their cache seal.','Tunnel Stalker','Buried Sentinel','Star-Metal Scrap','Cache Seal','Underpath Delver','Deepcut Blade'),
(8,'deepcavern','Deep Cavern','CAVE3.swf','Archivist Kessa','Field Archivist','This cavern predates Auralis. The walls describe a sealed sovereign beneath the stars. We need the crystal record before the cult destroys it.','Cave Revenant','Crystal Maw','Memory Crystal','Prismatic Core','Cavern Scholar Garb','Crystal Fang'),
(9,'dredddocks','Dredd Docks','DreddDocks.swf','Dockmaster Vale','Dockmaster','The cult moved a shard by sea. Their ship sailed under a dead flag and left armed crews behind. Break their hold on the docks.','Dread Corsair','Dock Reaver','Corsair Insignia','Reaver Compass','Dredd Dockcoat','Harbor Reaver'),
(10,'crystalcove','Crystal Cove','Crystalcove-SmoothPathArrows.swf','Tidebinder Sena','Tidebinder','The stolen shard sank here and woke the cove''s old guardian. Recover the tideglass and force the guardian to release the Heart fragment.','Tide Shade','Cove Guardian','Tideglass','Cove Heartshard','Tidebinder Garb','Tideglass Saber'),
(11,'frostgale','Frostgale','frostgale.swf','Frostwarden Rook','Frostwarden','The recovered shard points north. Frostgale is pulling heat out of the world as if something is breathing through the ice.','Frost Wisp','Gale Matriarch','Frozen Echo','Matriarch Crest','Frostgale Wrap','Gale Reaver'),
(12,'frozenfang','Frozen Fang','FrozenfangStronghold.swf','Captain Hald','Stronghold Captain','Frozen Fang has fallen silent. The gate sentries answer to a voice from the ruins. Retake the halls and seize the command sigil.','Frozen Sentry','Frostfang Castellan','Sentry Shard','Command Sigil','Frozen Fang Plate','Fangbreaker'),
(13,'lostruins','Lost Ruins','~Lostruinsbenzaj.swf','Relickeeper Asha','Relickeeper','These ruins name the truth: Warden Cael shattered the Heart on purpose. He was sealing a thing called the Null Sovereign, not destroying the realm.','Ruin Sentinel','Exiled Curator','Relic Fragment','Curator Tablet','Relickeeper Garb','Ruins Edge'),
(14,'dethertombs','Dethertombs','FoM-DethertombsFX.swf','Grave-Sage Orin','Grave-Sage','Cael''s last testimony was buried with his order. The dead are awake because the cult wants the same record. Reach it first.','Tomb Shade','Ossuary Lich','Grave Wax','Ossuary Key','Dethertomb Vestment','Graveward Blade'),
(15,'doomwood','Doomwood','DoomwoodExpanse.swf','Scout Linn','Doomwood Scout','The testimony confirms it: five major Heart fragments are locks. Reuniting them carelessly opens the prison. The cult already has three.','Doomwood Beast','Rotwarden','Rotwood Bark','Rotwarden Heart','Doomwood Scout Garb','Rotcleaver'),
(16,'dragonfire','Dragonfire Citadel','DragonfireCitadel.swf','Embermarshal Kael','Embermarshal','The fourth fragment is inside Dragonfire. The cult is melting the ward around it. Take ember seals from their constructs and defeat their champion.','Ember Golem','Dragonfire Champion','Ember Seal','Champion Brand','Dragonfire Mail','Emberbrand'),
(17,'infernalgate','Infernal Gate','Infernal-SmoothPathArrows.swf','Gatewalker Veya','Gatewalker','The cult fled through the Infernal Gate with four fragments. Every opened seal makes the Null Sovereign stronger. Shut down the gate anchors.','Infernal Shade','Gatebreaker','Gate Ash','Gatebreaker Horn','Gatewalker Raiment','Infernal Edge'),
(18,'shadowmoor','Shadowmoor','ShadowmoorRitual.swf','Shadecaller Neris','Shadecaller','This is where they will bind the fragments together. Break the ritual circles and take the shadow-key before the final road opens.','Shadow Wraith','Ritual Keeper','Ritual Ash','Shadow Key','Shadowmoor Mantle','Shadepiercer'),
(19,'starfall','Starfall','Starfall-SmoothPathArrows.swf','Starwatcher Sol','Starwatcher','The false Heart is rising into the sky. Starfall is the last stable path to the prison. Collect the star seals and defeat the fallen astronomer.','Starborn Sentry','Fallen Astronomer','Star Seal','Astral Lens','Starwatch Garb','Starfall Blade'),
(20,'celestialdepths','Celestial Depths','CelestialDepths.swf','Heartkeeper Aerin','Heartkeeper','The prison is open, but not lost. The fragments can still become locks again. Defeat the Sovereign''s avatar and restore the Aera Heart.','Null Echo','Sovereign Avatar','Null Fragment','Sovereign Core','Heartkeeper Plate','Heartward');

DROP TABLE IF EXISTS `hf_skill`;
CREATE TABLE `hf_skill` (`sid` int NOT NULL PRIMARY KEY,`classid` int NOT NULL,`name` varchar(64) NOT NULL,`damage` decimal(6,2) NOT NULL,`mana` int NOT NULL,`rangev` int NOT NULL,`refv` varchar(8) NOT NULL,`cooldown` int NOT NULL,`hits` int NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `hf_skill` VALUES
(826001,825001,'Wild Strike',0.5,0,303,'aa',1500,1),(826002,825001,'Briar Cut',1.05,10,303,'a1',3200,1),(826003,825001,'Thorn Rush',1.35,18,303,'a2',5800,1),(826004,825001,'Greenward Sweep',0.85,24,303,'a3',8500,2),(826005,825001,'Verdant Verdict',2.25,30,303,'a4',14000,1),
(826006,825002,'Quick Shot',0.5,0,808,'aa',1500,1),(826007,825002,'Rift Arrow',1.05,10,808,'a1',3200,1),(826008,825002,'Frostline',1.35,18,808,'a2',5800,1),(826009,825002,'Split Volley',0.85,24,808,'a3',8500,2),(826010,825002,'Shardpiercer',2.25,30,808,'a4',14000,1),
(826011,825003,'Heart Strike',0.5,0,303,'aa',1500,1),(826012,825003,'Resonant Cut',1.05,10,303,'a1',3200,1),(826013,825003,'Wardbreaker',1.35,18,303,'a2',5800,1),(826014,825003,'Heartward Sweep',0.85,24,303,'a3',8500,2),(826015,825003,'Aera Verdict',2.25,30,303,'a4',14000,1);

DELIMITER $$
DROP PROCEDURE IF EXISTS `install_aera_heartfall`$$
CREATE PROCEDURE `install_aera_heartfall`()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
  SET @entryMap=(SELECT `id` FROM `maps` WHERE `Name`='newbie' LIMIT 1);
  IF @entryMap IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall install failed: missing newbie map'; END IF;
  START TRANSACTION;
  IF NOT EXISTS (SELECT 1 FROM `aera_content_packs` WHERE `Name`='aera-heartfall-starter-v1') THEN
    IF EXISTS (SELECT 1 FROM `maps` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in maps'; END IF;
    IF EXISTS (SELECT 1 FROM `items` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in items'; END IF;
    IF EXISTS (SELECT 1 FROM `monsters` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in monsters'; END IF;
    IF EXISTS (SELECT 1 FROM `shops` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in shops'; END IF;
    IF EXISTS (SELECT 1 FROM `npcs` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in npcs'; END IF;
    IF EXISTS (SELECT 1 FROM `quests` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in quests'; END IF;
    IF EXISTS (SELECT 1 FROM `classes` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in classes'; END IF;
    IF EXISTS (SELECT 1 FROM `skills` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in skills'; END IF;
    IF EXISTS (SELECT 1 FROM `maps_npc` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in maps_npc'; END IF;
    IF EXISTS (SELECT 1 FROM `maps_monsters` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in maps_monsters'; END IF;
    IF EXISTS (SELECT 1 FROM `npcs_buttons` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in npcs_buttons'; END IF;
    IF EXISTS (SELECT 1 FROM `shops_items` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in shops_items'; END IF;
    IF EXISTS (SELECT 1 FROM `monsters_drops` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in monsters_drops'; END IF;
    IF EXISTS (SELECT 1 FROM `quests_requirements` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in quests_requirements'; END IF;
    IF EXISTS (SELECT 1 FROM `skills_assign` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in skills_assign'; END IF;
    IF EXISTS (SELECT 1 FROM `quests_rewards` WHERE `id` BETWEEN 820000 AND 829999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall reserved IDs occupied in quests_rewards'; END IF;
    IF EXISTS (SELECT 1 FROM `quests` WHERE `Slot`=91) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Heartfall quest slot 91 already used'; END IF;

    DELETE FROM `npcs_buttons` WHERE `id`=810099;
    DELETE FROM `maps_npc` WHERE `id`=810099;

    INSERT INTO `maps` (`id`,`Name`,`File`,`MaxPlayers`,`ReqLevel`,`ReqParty`,`Upgrade`,`Staff`,`PvP`) SELECT 820000+seq,mapkey,swf,12,1,0,0,0,0 FROM `hf_zone`;

    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
      SELECT 821000+(seq-1)*2,mobtoken,CONCAT('Heartfall quest item from ',mob,' in ',title,'.'),'Item','','','iibag','None',1,100,50,10,1,20,0,0,0,1,0,0,1,0,0 FROM `hf_zone`
      UNION ALL
      SELECT 821001+(seq-1)*2,bosstoken,CONCAT('Heartfall quest item from ',boss,' in ',title,'.'),'Item','','','iibag','None',1,100,50,10,1,5,0,0,0,1,0,0,1,0,0 FROM `hf_zone`;

    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
      SELECT 822000+(seq-1)*2,armorname,CONCAT(title,' field armor from the Heartfall campaign.'),'Armor',
        CASE MOD(seq-1,3) WHEN 0 THEN 'ForestKin2.swf' WHEN 1 THEN 'ArcticRanger.swf' ELSE 'AsgardianKnight.swf' END,
        CASE MOD(seq-1,3) WHEN 0 THEN 'ForestKinBase' WHEN 1 THEN 'ArcticRanger' ELSE 'AsgardianKnight' END,
        'iwarmor','co',LEAST(seq,20),100,50,10,1,1,400+(seq-1)*225,0,1,0,0,0,1,1,1 FROM `hf_zone`
      UNION ALL
      SELECT 822001+(seq-1)*2,swordname,CONCAT('A weapon reforged during the Heartfall campaign in ',title,'.'),'Sword',
        CASE MOD(seq-1,3) WHEN 0 THEN 'items/swords/BasicRuneSwordDage.swf' WHEN 1 THEN 'items/swords/CCFrostReaver.swf' ELSE 'items/swords/AngelicRunedBroadsword1.swf' END,
        CASE MOD(seq-1,3) WHEN 0 THEN 'BasicRuneSwordDage' WHEN 1 THEN 'CCFrostReaver' ELSE 'AngelicRunedBroadsword1' END,
        'iwsword','Weapon',LEAST(seq,20),100,50,10,1,1,300+(seq-1)*200,0,1,0,0,0,1,1,1 FROM `hf_zone`;

    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`) VALUES
      (825001,'Wildwarden','Heartfall milestone class earned after Blackbriar.','Class','ForestKin2.swf','ForestKinBase','iiclass','ar',1,100,50,10,1,1,0,0,1,0,0,0,1,1,1),
      (825002,'Rift Ranger','Heartfall milestone class earned after Crystal Cove.','Class','ArcticRanger.swf','ArcticRanger','iiclass','ar',1,100,50,10,1,1,0,0,1,0,0,0,1,1,1),
      (825003,'Heartwarden','Final Heartfall class earned after restoring the Aera Heart.','Class','AsgardianKnight.swf','AsgardianKnight','iiclass','ar',1,100,50,10,1,1,0,0,1,0,0,0,1,1,1);

    INSERT INTO `shops` (`id`,`Name`,`House`,`Upgrade`,`Staff`,`Limited`,`Field`) SELECT 820000+seq,CONCAT(title,' Supplies'),0,0,0,0,'' FROM `hf_zone`;

    INSERT INTO `npcs` (`id`,`Name`,`Gender`,`Job`,`Slogan`,`Level`,`Health`,`Mana`,`DPS`,`ColorHair`,`ColorSkin`,`ColorEye`,`ColorBase`,`ColorTrim`,`ColorAccessory`,`WeaponID`,`ArmorID`)
      SELECT 820000+seq,npc,IF(MOD(seq,2)=1,'F','M'),job,slogan,seq,1000+seq*100,100,0,'0x3A2D2A','0xD6AD8D','0x87CFFF','0x33475E','0xC5A96A','0x6B8CA8',822001+(seq-1)*2,822000+(seq-1)*2 FROM `hf_zone`;
    INSERT INTO `npcs` (`id`,`Name`,`Gender`,`Job`,`Slogan`,`Level`,`Health`,`Mana`,`DPS`,`ColorHair`,`ColorSkin`,`ColorEye`,`ColorBase`,`ColorTrim`,`ColorAccessory`,`WeaponID`,`ArmorID`) VALUES
      (820000,'Heartfall Guide','F','Auralis Courier','The old starter story is retired. Follow the silver trail to Aera Wake and begin Heartfall.',1,1000,100,0,'0x3A2D2A','0xD6AD8D','0x87CFFF','0x33475E','0xC5A96A','0x6B8CA8',822001,822000);

    INSERT INTO `monsters` (`id`,`Name`,`File`,`Linkage`,`Level`,`Health`,`Mana`,`Gold`,`Coin`,`Experience`,`ClassPoint`,`Reputation`,`DamageReduction`,`DPS`,`Respawn`,`Speed`,`Immune`)
      SELECT 823000+(seq-1)*2,mob,CASE MOD(seq-1,3) WHEN 0 THEN 'WolfDire.swf' WHEN 1 THEN 'Shade1.swf' ELSE 'StoneGolem1.swf' END,CASE MOD(seq-1,3) WHEN 0 THEN 'WolfDire' WHEN 1 THEN 'Shade1' ELSE 'StoneGolem1' END,seq,350+seq*180,100,15+seq*8,0,50+seq*30,5,3,0,8+seq*3,7,2200,0 FROM `hf_zone`
      UNION ALL
      SELECT 823001+(seq-1)*2,boss,CASE MOD(seq-1,3) WHEN 0 THEN 'Treeant.swf' WHEN 1 THEN 'FrostQueenBhtNoth.swf' ELSE 'Undeadlich.swf' END,CASE MOD(seq-1,3) WHEN 0 THEN 'Treeant' WHEN 1 THEN 'FrostQueenBhtNoth' ELSE 'UndeadLich1' END,seq+1,900+seq*450,100,50+seq*18,0,180+seq*70,12,8,0,15+seq*4,12,2200,0 FROM `hf_zone`;

    INSERT INTO `quests` (`id`,`FactionID`,`Name`,`Description`,`EndText`,`Experience`,`Gold`,`Coins`,`ClassPoints`,`RewardType`,`Level`,`Upgrade`,`Once`,`Slot`,`Value`,`Field`,`Index`)
      SELECT 824000+(seq-1)*2,1,CONCAT(title,': Clear the Trail'),CONCAT('Defeat ',mob,' in ',title,' and recover 4 ',mobtoken,'. ',npc,' needs them to trace the Heartfall corruption.'),CONCAT('The evidence points deeper into ',title,'. Now confront ',boss,'.'),250+seq*160,180+seq*120,0,70+seq*10,'S',1,0,1,91,(seq-1)*2+1,'',-1 FROM `hf_zone`
      UNION ALL
      SELECT 824001+(seq-1)*2,1,CONCAT(title,': Break the Hold'),CONCAT('Defeat ',boss,' in ',title,' and recover ',bosstoken,'.'),CASE WHEN seq<20 THEN CONCAT('The Heartfall trail continues. Travel onward from ',title,' and keep the fragment path moving.') ELSE 'The Sovereign avatar is defeated. The Aera Heart is sealed again, and you are the first Heartwarden of the new age.' END,450+seq*240,300+seq*180,0,120+seq*15,'S',1,0,1,91,(seq-1)*2+2,'',-1 FROM `hf_zone`;

    INSERT INTO `classes` (`id`,`ItemID`,`Category`,`Description`,`ManaRegenerationMethods`,`StatsDescription`) VALUES
      (825001,825001,'M1','Wildwarden protects the living roads opened during Heartfall.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival; Luck improves critical performance.'),
      (825002,825002,'M1','Rift Ranger hunts Heart fragments across broken ley-lines.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival; Luck improves critical performance.'),
      (825003,825003,'M1','Heartwarden is the final discipline of the restored Aera Heart.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival; Luck improves critical performance.');

    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`)
      SELECT sid,name,IF(refv='aa','Attack1,Attack2','Attack3'),IF(hits=2,'Strike up to two enemies.',IF(refv='aa','A basic weapon attack.','Deal physical weapon damage to one enemy.')),damage,mana,'iwsword',rangev,'',refv,'h','m','p','',cooldown,hits FROM `hf_skill`;

    INSERT INTO `maps_npc` (`id`,`MapID`,`NpcID`,`NpcMapID`,`Frame`,`X`,`Y`,`Turn`) SELECT 827500+seq,820000+seq,820000+seq,1,'Enter',210,390,'Right' FROM `hf_zone`;
    INSERT INTO `maps_npc` (`id`,`MapID`,`NpcID`,`NpcMapID`,`Frame`,`X`,`Y`,`Turn`) VALUES (827500,@entryMap,820000,820000,'Enter',235,395,'Right');

    INSERT INTO `maps_monsters` (`id`,`MapID`,`MonsterID`,`MonMapID`,`Frame`,`X`,`Y`,`Aggresive`,`Enabled`)
      SELECT 827600+(seq-1)*3+1,820000+seq,823000+(seq-1)*2,827600+(seq-1)*3+1,'Enter',470,405,0,1 FROM `hf_zone`
      UNION ALL SELECT 827600+(seq-1)*3+2,820000+seq,823000+(seq-1)*2,827600+(seq-1)*3+2,'Enter',660,405,0,1 FROM `hf_zone`
      UNION ALL SELECT 827600+(seq-1)*3+3,820000+seq,823001+(seq-1)*2,827600+(seq-1)*3+3,'Enter',790,405,0,1 FROM `hf_zone`;

    INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
      SELECT 827000+(seq-1)*5+1,820000+seq,'quests','Story Quests',CONCAT(824000+(seq-1)*2,',',824001+(seq-1)*2),'' FROM `hf_zone`
      UNION ALL SELECT 827000+(seq-1)*5+2,820000+seq,'shop',CONCAT(title,' Supplies'),CAST(820000+seq AS CHAR),'' FROM `hf_zone`
      UNION ALL SELECT 827000+(seq-1)*5+3,820000+seq,'join',IF(seq=1,'Return to Newbie',CONCAT('Previous: ',(SELECT z2.title FROM hf_zone z2 WHERE z2.seq=hf_zone.seq-1))),IF(seq=1,'newbie|Enter|Spawn',CONCAT((SELECT z2.mapkey FROM hf_zone z2 WHERE z2.seq=hf_zone.seq-1),'|Enter|Spawn')),'' FROM `hf_zone`
      UNION ALL SELECT 827000+(seq-1)*5+4,820000+seq,'join',IF(seq=20,'Return to Auralis',CONCAT('Continue: ',(SELECT z2.title FROM hf_zone z2 WHERE z2.seq=hf_zone.seq+1))),IF(seq=20,'auralis|Enter|Spawn',CONCAT((SELECT z2.mapkey FROM hf_zone z2 WHERE z2.seq=hf_zone.seq+1),'|Enter|Spawn')),'' FROM `hf_zone`
      UNION ALL SELECT 827000+(seq-1)*5+5,820000+seq,'join','Restart Heartfall','aerawake|Enter|Spawn','' FROM `hf_zone`;
    INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`) VALUES (827101,820000,'join','Begin Heartfall','aerawake|Enter|Spawn','');

    INSERT INTO `shops_items` (`id`,`ShopID`,`ItemID`,`QuantityRemain`) SELECT 827800+(seq-1)*2+1,820000+seq,822000+(seq-1)*2,0 FROM `hf_zone` UNION ALL SELECT 827800+(seq-1)*2+2,820000+seq,822001+(seq-1)*2,0 FROM `hf_zone`;
    INSERT INTO `monsters_drops` (`id`,`MonsterID`,`ItemID`,`Chance`,`Quantity`) SELECT 827900+(seq-1)*2+1,823000+(seq-1)*2,821000+(seq-1)*2,1,1 FROM `hf_zone` UNION ALL SELECT 827900+(seq-1)*2+2,823001+(seq-1)*2,821001+(seq-1)*2,1,1 FROM `hf_zone`;
    INSERT INTO `quests_requirements` (`id`,`QuestID`,`ItemID`,`Quantity`) SELECT 828000+(seq-1)*2+1,824000+(seq-1)*2,821000+(seq-1)*2,4 FROM `hf_zone` UNION ALL SELECT 828000+(seq-1)*2+2,824001+(seq-1)*2,821001+(seq-1)*2,1 FROM `hf_zone`;
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) SELECT 828100+(sid-826000),sid,classid FROM `hf_skill`;
    INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`) VALUES (828201,824009,825001,1,1,'S'),(828202,824019,825002,1,1,'S'),(828203,824039,825003,1,1,'S');

    INSERT INTO `aera_content_packs` (`Name`) VALUES ('aera-heartfall-starter-v1');
  END IF;
  COMMIT;
END$$
CALL `install_aera_heartfall`()$$
DROP PROCEDURE `install_aera_heartfall`$$
DELIMITER ;

DROP TABLE IF EXISTS `hf_skill`;
DROP TABLE IF EXISTS `hf_zone`;
