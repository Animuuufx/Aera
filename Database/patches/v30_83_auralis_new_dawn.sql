-- Auralis: New Dawn - fresh starter/progression storyline.
-- Requires the current AERA schema through v30_82.
-- Repo content only: every map File below already exists under web/public/gamefiles/maps.
-- Quest progress slot 93 and IDs 830000-831999 are reserved for this pack.
-- This intentionally does not restore or depend on the retired Heartfall/Broken Oath content.

CREATE TABLE IF NOT EXISTS `aera_content_packs` (
  `Name` varchar(64) NOT NULL,
  `InstalledAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELIMITER $$
DROP PROCEDURE IF EXISTS `install_auralis_new_dawn`$$
CREATE PROCEDURE `install_auralis_new_dawn`()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    DROP TEMPORARY TABLE IF EXISTS `tmp_auralis_stage`;
    RESIGNAL;
  END;

  SET @entryMap=(SELECT `id` FROM `maps` WHERE `Name`='newbie' LIMIT 1);
  IF @entryMap IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis New Dawn requires the newbie entry map';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM `aera_content_packs` WHERE `Name`='auralis-new-dawn') THEN
    IF EXISTS (SELECT 1 FROM `maps` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in maps'; END IF;
    IF EXISTS (SELECT 1 FROM `items` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in items'; END IF;
    IF EXISTS (SELECT 1 FROM `monsters` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in monsters'; END IF;
    IF EXISTS (SELECT 1 FROM `shops` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in shops'; END IF;
    IF EXISTS (SELECT 1 FROM `npcs` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in npcs'; END IF;
    IF EXISTS (SELECT 1 FROM `quests` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in quests'; END IF;
    IF EXISTS (SELECT 1 FROM `classes` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in classes'; END IF;
    IF EXISTS (SELECT 1 FROM `skills` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in skills'; END IF;
    IF EXISTS (SELECT 1 FROM `maps_npc` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in maps_npc'; END IF;
    IF EXISTS (SELECT 1 FROM `maps_monsters` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in maps_monsters'; END IF;
    IF EXISTS (SELECT 1 FROM `npcs_buttons` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in npcs_buttons'; END IF;
    IF EXISTS (SELECT 1 FROM `shops_items` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in shops_items'; END IF;
    IF EXISTS (SELECT 1 FROM `monsters_drops` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in monsters_drops'; END IF;
    IF EXISTS (SELECT 1 FROM `quests_requirements` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in quest requirements'; END IF;
    IF EXISTS (SELECT 1 FROM `quests_rewards` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in quest rewards'; END IF;
    IF EXISTS (SELECT 1 FROM `skills_assign` WHERE `id` BETWEEN 830000 AND 831999) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Auralis reserved IDs occupied in skill assignments'; END IF;
    IF EXISTS (SELECT 1 FROM `quests` WHERE `Slot`=93) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quest slot 93 is already in use'; END IF;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM `aera_content_packs` WHERE `Name`='auralis-new-dawn') THEN
    START TRANSACTION;

    DROP TEMPORARY TABLE IF EXISTS `tmp_auralis_stage`;
    CREATE TEMPORARY TABLE `tmp_auralis_stage` (
      `Seq` int NOT NULL PRIMARY KEY,
      `MapName` varchar(64) NOT NULL,
      `MapFile` varchar(128) NOT NULL,
      `ZoneTitle` varchar(96) NOT NULL,
      `NPCName` varchar(96) NOT NULL,
      `NPCGender` char(1) NOT NULL,
      `NPCJob` varchar(96) NOT NULL,
      `NPCSlogan` varchar(512) NOT NULL,
      `MonsterName` varchar(96) NOT NULL,
      `MonsterFile` varchar(128) NOT NULL,
      `MonsterLinkage` varchar(128) NOT NULL,
      `TokenName` varchar(96) NOT NULL,
      `GearName` varchar(96) NOT NULL,
      `GearFile` varchar(128) NOT NULL,
      `GearLink` varchar(128) NOT NULL,
      `QuestName` varchar(128) NOT NULL,
      `QuestDesc` varchar(768) NOT NULL,
      `QuestEnd` varchar(768) NOT NULL,
      `ReqQty` int NOT NULL,
      `NextMapName` varchar(64) NOT NULL,
      `NextZoneTitle` varchar(96) NOT NULL
    ) ENGINE=MEMORY;

    INSERT INTO `tmp_auralis_stage`
      (`Seq`,`MapName`,`MapFile`,`ZoneTitle`,`NPCName`,`NPCGender`,`NPCJob`,`NPCSlogan`,`MonsterName`,`MonsterFile`,`MonsterLinkage`,`TokenName`,`GearName`,`GearFile`,`GearLink`,`QuestName`,`QuestDesc`,`QuestEnd`,`ReqQty`,`NextMapName`,`NextZoneTitle`)
    VALUES
(1,'auralislanding','town-newbie-6jan12.swf','Auralis Landing','Captain Elian','M','Landing Captain','The harbor lamps are dying. Help me secure the landing before the darkness reaches the city.','Dockside Prowler','WolfDire.swf','WolfDire','Prowler Fang','Landing Scout Garb','ForestKin2.swf','ForestKinBase','Light the First Lantern','Collect 3 Prowler Fangs from the creatures stalking the landing.','The landing is secure. Take the road into Auralis Heart and report to Steward Mira.',3,'auralisheart','Auralis Heart'),
(2,'auralisheart','Auralis-town.swf','Auralis Heart','Steward Mira','F','City Steward','Auralis still stands, but every district has gone silent. We will wake the city one ward at a time.','Mana-Sick Falcon','Shade1.swf','Shade1','Faded Aether','Heartwatch Armor','AsgardianKnight.swf','AsgardianKnight','A City Still Breathing','Collect 3 Faded Aether samples from the creatures circling the central ward.','The pulse is returning. Lantern Ward is the next district on the old watch route.',3,'auralislanternward','Lantern Ward'),
(3,'auralislanternward','Auralis-town-01.swf','Lantern Ward','Lanternkeeper Sol','M','Lanternkeeper','The ward lights are being smothered from below. Bring me proof of what is feeding on them.','Hollow Scarecrow','Treeant.swf','Treeant','Lantern Root','Lantern Ward Garb','ArcticRanger.swf','ArcticRanger','Fuel for the Ward','Collect 3 Lantern Roots from the hollow guardians in this ward.','The lanterns burn again. Market Steps can see our signal.',3,'auralismarketsteps','Market Steps'),
(4,'auralismarketsteps','Auralis-town-02.swf','Market Steps','Quartermaster Veya','F','Quartermaster','The market was our supply line. Clear the warped brutes and we can arm the districts ahead.','Flood Brute','StoneGolem1.swf','StoneGolem1','Supply Seal','Market Guard Plate','AsgardianKnight.swf','AsgardianKnight','Reopen the Supply Line','Recover 3 Supply Seals from the brutes occupying Market Steps.','The stores are open again. Artisan Row has the tools we need to repair the gates.',3,'auralisartisanrow','Artisan Row'),
(5,'auralisartisanrow','Auralis-town-03.swf','Artisan Row','Smith Corin','M','Master Smith','Something heavy is hammering at the old forge doors. Break it before the ward machinery is ruined.','Forgebound Sentinel','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Forge Core','Artisan Bulwark','AsgardianKnight.swf','AsgardianKnight','The Silent Forge','Defeat the Forgebound Sentinel and recover its Forge Core.','The forges are ours. Sister Avel is waiting in Chapel Quarter with news about the corruption.',1,'auralischapelquarter','Chapel Quarter'),
(6,'auralischapelquarter','Auralis-town-04.swf','Chapel Quarter','Sister Avel','F','Dawn Cleric','The shadow is not random. It is following an old oath carved beneath the city.','Crypt Shade','Undeadlich.swf','UndeadLich1','Broken Prayer','Chapel Vanguard Armor','AsgardianKnight.swf','AsgardianKnight','Prayers Under Stone','Collect 3 Broken Prayers from the undead haunting the chapel.','These fragments name the first gate. Take the Vanguard discipline and reach the Lower Ramparts.',3,'auralislowerramparts','Lower Ramparts'),
(7,'auralislowerramparts','Auralis-town-05.swf','Lower Ramparts','Sergeant Nox','M','Rampart Sergeant','The lower wall is our last safe road to the watchtowers. Clear it before the enemy closes the city in.','Rampart Direwolf','WolfDire.swf','WolfDire','Rampart Claw','Lower Rampart Mail','ForestKin2.swf','ForestKinBase','Hold the Lower Wall','Collect 3 Rampart Claws from the beasts overrunning the wall.','The ramparts are holding. Scout Teren has sighted movement at East Watch.',3,'auraliseastwatch','East Watch'),
(8,'auraliseastwatch','Auralis-town-06.swf','East Watch','Scout Teren','M','Watch Scout','The enemy is testing our signal towers. We need their focus crystals before they can blind the watch.','Aether Watcher','Shade1.swf','Shade1','Watcher Crystal','East Watch Leathers','ArcticRanger.swf','ArcticRanger','Eyes on the Horizon','Collect 3 Watcher Crystals from the aether creatures around the tower.','The tower can see the outer road again. Archivist Lis is opening Crown Walk.',3,'auraliscrownwalk','Crown Walk'),
(9,'auraliscrownwalk','Auralis-town-07.swf','Crown Walk','Archivist Lis','F','Royal Archivist','The old records say every city gate was bound to a single altar beyond the walls. Find the missing seal pieces.','Crown Golem','StoneGolem1.swf','StoneGolem1','Crown Seal','Crown Walk Guard','AsgardianKnight.swf','AsgardianKnight','Pieces of the Crown','Collect 3 Crown Seals from the constructs guarding the royal walk.','The records are complete. The Sunspire key will open the road to the First Gate.',3,'auralissunspire','Sunspire'),
(10,'auralissunspire','Auralis-town-08.swf','Sunspire','Warden Hale','M','Sunspire Warden','The Sunspire keeper has been twisted into a weapon. Free the tower and the outer gates can open.','Twisted Sunkeeper','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Sunspire Key','Sunspire Warden Plate','AsgardianKnight.swf','AsgardianKnight','Wake the Sunspire','Defeat the Twisted Sunkeeper and recover the Sunspire Key.','The outer road is open. Beyond it, the real siege begins at the First Gate.',1,'auralisfirstgate','First Gate'),
(11,'auralisfirstgate','Auralis-gate-01.swf','First Gate','Gatewarden Rhea','F','Gatewarden','The gate chain is trapped beneath the rubble. Clear the creatures carrying its broken links.','Gate Prowler','WolfDire.swf','WolfDire','Gate Chain Link','First Gate Scout Garb','ForestKin2.swf','ForestKinBase','Raise the First Gate','Collect 3 Gate Chain Links from the prowlers around the mechanism.','The gate is raised. The Guardpost ahead can finally receive reinforcements.',3,'auralisguardpost','Guardpost'),
(12,'auralisguardpost','Auralis-gate-02.swf','Guardpost','Lieutenant Oren','M','Guard Lieutenant','We lost half the post when the sky turned black. Recover our signal shards so the wall knows we still stand.','Signal Wraith','Shade1.swf','Shade1','Signal Shard','Guardpost Ranger Gear','ArcticRanger.swf','ArcticRanger','Signal the Wall','Collect 3 Signal Shards from the wraiths surrounding the guardpost.','The wall answered. Pathfinder Ily has found a route across the Broken Causeway.',3,'auralisbrokencauseway','Broken Causeway'),
(13,'auralisbrokencauseway','Auralis-gate-03.swf','Broken Causeway','Pathfinder Ily','F','Pathfinder','The causeway is guarded by an oathless knight. Defeat it and I can show you the path the invaders used.','Oathless Knight','Undeadlich.swf','UndeadLich1','Oathless Crest','Causeway Ranger Armor','ArcticRanger.swf','ArcticRanger','Cross the Broken Causeway','Defeat the Oathless Knight and recover its Oathless Crest.','The crest bears the altar mark. Take the Lantern Ranger discipline and push to the Outer Wall.',1,'auralisouterwall','Outer Wall'),
(14,'auralisouterwall','Auralis-gate-04.swf','Outer Wall','Commander Sera','F','Wall Commander','The siege force is pinning us against the outer wall. Break their stone anchors and we can move again.','Siege Golem','StoneGolem1.swf','StoneGolem1','Siege Anchor','Outer Wall Plate','AsgardianKnight.swf','AsgardianKnight','Break the Siege Anchors','Collect 3 Siege Anchors from the constructs battering the wall.','The line is moving. Medic Rowan is holding the Ashen Barricade ahead.',3,'auralisashenbarricade','Ashen Barricade'),
(15,'auralisashenbarricade','Auralis-gate-05.swf','Ashen Barricade','Medic Rowan','M','Field Medic','A corrupted guardian is burning everything that crosses the barricade. Put it down before the wounded are trapped.','Ashen Guardian','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Ashen Heart','Ashen Guard Mail','AsgardianKnight.swf','AsgardianKnight','Quench the Barricade','Defeat the Ashen Guardian and recover its Ashen Heart.','The road is clear. Marshal Cael is gathering every survivor at Storm Gate.',1,'auralisstormgate','Storm Gate'),
(16,'auralisstormgate','Auralis-gate-06.swf','Storm Gate','Marshal Cael','M','Auralis Marshal','This is the last city gate. Recover the storm sigils and we can follow the enemy to its source.','Storm Talon','Shade1.swf','Shade1','Storm Sigil','Stormgate Leathers','ArcticRanger.swf','ArcticRanger','Open the Storm Gate','Collect 3 Storm Sigils from the creatures feeding on the gate wards.','The gate is open. Oracle Sen has reached the Shattered Altar beyond the walls.',3,'auralisshatteredaltar','Shattered Altar'),
(17,'auralisshatteredaltar','auralisalter-07.swf','Shattered Altar','Oracle Sen','F','Dawn Oracle','The altar was built to protect Auralis. Someone inverted its oath and turned every ward against us.','Blighted Idol','Treeant.swf','Treeant','Inverted Rune','Altar Keeper Garb','ForestKin2.swf','ForestKinBase','Read the Inverted Oath','Collect 3 Inverted Runes from the blighted guardians around the altar.','The runes point into Duskpath. Whoever broke the oath fled carrying its final verse.',3,'auralisduskpath','Duskpath'),
(18,'auralisduskpath','duskpath-07.swf','Duskpath','Ranger Nyra','F','Dusk Ranger','Tracks lead through the dark road toward a refugee camp. Clear the hunters before they reach our people.','Dusk Hound','WolfDire.swf','WolfDire','Dusk Fang','Duskpath Ranger Gear','ArcticRanger.swf','ArcticRanger','Hunt the Dusk Hounds','Collect 3 Dusk Fangs from the hunters on the road.','The road is safe. Dawn Refuge holds the witnesses we need.',3,'auralisdawnrefuge','Dawn Refuge'),
(19,'auralisdawnrefuge','town-battleon-21Nov14.swf','Dawn Refuge','Elder Tor','M','Refuge Elder','We saw the oathbreaker pass toward the old arena. His champion stayed behind to silence us.','Veilbound Reaver','Undeadlich.swf','UndeadLich1','Veil Crest','Dawn Refuge Armor','ForestKin2.swf','ForestKinBase','The Last Witnesses','Collect 3 Veil Crests from the reavers surrounding Dawn Refuge.','Now we know the truth. The oathbreaker waits in the arena, protected by the Veilbound Champion.',3,'auralisoatharena','Oath Arena'),
(20,'auralisoatharena','1VS1-duel-01.11.14-HP.A.swf','Oath Arena','Champion Vale','M','Last Champion','The city has carried you this far. End the broken oath here and give Auralis a new dawn.','Veilbound Champion','FrostQueenBhtNoth.swf','FrostQueenBhtNoth','Veilbound Sigil','New Dawn Champion Plate','AsgardianKnight.swf','AsgardianKnight','A New Dawn for Auralis','Defeat the Veilbound Champion and recover the Veilbound Sigil.','The inverted oath is broken. Auralis is free to write a new one, and you are now a Dusk Warden.',1,'auralisheart','Auralis Heart');

    -- Twenty progression maps: city districts -> six gates -> altar -> Duskpath -> refuge -> arena.
    INSERT INTO `maps` (`id`,`Name`,`File`,`MaxPlayers`,`ReqLevel`,`ReqParty`,`Upgrade`,`Staff`,`PvP`)
    SELECT 830000+`Seq`,`MapName`,`MapFile`,20,`Seq`,0,0,0,0
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    -- One quest token and one permanent armor reward/shop item per zone.
    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    SELECT 830100+`Seq`,`TokenName`,CONCAT('Story item from ',`ZoneTitle`,'.'),'Item','','','iibag','None',1,100,50,10,1,20,0,0,1,1,0,0,1,0,0
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    SELECT 830200+`Seq`,`GearName`,CONCAT('Auralis New Dawn reward from ',`ZoneTitle`,'.'),'Armor',`GearFile`,`GearLink`,'iwarmor','co',`Seq`,100,50,10,1,1,300+(`Seq`*200),0,1,0,0,0,1,0,0
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`)
    VALUES (830250,'Auralis Dawnblade','Standard blade carried by the restored Auralis watch.','Sword','items/swords/AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1','iwsword','Weapon',1,100,50,10,1,1,500,0,1,0,0,0,1,0,0);

    -- Three storyline classes unlocked at the chapter milestones.
    INSERT INTO `items` (`id`,`Name`,`Description`,`Type`,`File`,`Link`,`Icon`,`Equipment`,`Level`,`DPS`,`Range`,`Rarity`,`Quantity`,`Stack`,`Cost`,`Coins`,`Sell`,`Temporary`,`Upgrade`,`Staff`,`EnhID`,`Trade`,`Market`) VALUES
      (831051,'Auralis Vanguard','Front-line discipline of the restored city watch.','Class','AsgardianKnight.swf','AsgardianKnight','iiclass','ar',1,100,50,10,1,1,0,0,1,0,0,0,1,0,0),
      (831052,'Lantern Ranger','Mobile ranger discipline trained to protect the outer roads.','Class','ArcticRanger.swf','ArcticRanger','iiclass','ar',1,100,50,10,1,1,0,0,1,0,0,0,1,0,0),
      (831053,'Dusk Warden','Veteran discipline earned by completing the New Dawn story.','Class','ForestKin2.swf','ForestKinBase','iiclass','ar',1,100,50,10,1,1,0,0,1,0,0,0,1,0,0);

    INSERT INTO `monsters` (`id`,`Name`,`File`,`Linkage`,`Level`,`Health`,`Mana`,`Gold`,`Coin`,`Experience`,`ClassPoint`,`Reputation`,`DamageReduction`,`DPS`,`Respawn`,`Speed`,`Immune`)
    SELECT 830300+`Seq`,`MonsterName`,`MonsterFile`,`MonsterLinkage`,`Seq`+1,
           500+(`Seq`*250)+(CASE WHEN `ReqQty`=1 THEN 1200 ELSE 0 END),
           100,20+(`Seq`*15),0,50+(`Seq`*40),5,5,0,12+(`Seq`*3),8,2200,0
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `shops` (`id`,`Name`,`House`,`Upgrade`,`Staff`,`Limited`,`Field`)
    SELECT 830400+`Seq`,CONCAT(`ZoneTitle`,' Supplies'),0,0,0,0,''
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `npcs` (`id`,`Name`,`Gender`,`Job`,`Slogan`,`Level`,`Health`,`Mana`,`DPS`,`ColorHair`,`ColorSkin`,`ColorEye`,`ColorBase`,`ColorTrim`,`ColorAccessory`,`WeaponID`,`ArmorID`)
    SELECT 830500+`Seq`,`NPCName`,`NPCGender`,`NPCJob`,`NPCSlogan`,`Seq`,1000+(`Seq`*50),100,0,
           '0x483329','0xD6AD8D','0x68B6C7','0x374F46','0xB6A276','0x688C99',830250,830200+`Seq`
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    -- Separate intro herald on newbie so this fresh story has a clean starting point.
    INSERT INTO `npcs` (`id`,`Name`,`Gender`,`Job`,`Slogan`,`Level`,`Health`,`Mana`,`DPS`,`ColorHair`,`ColorSkin`,`ColorEye`,`ColorBase`,`ColorTrim`,`ColorAccessory`,`WeaponID`,`ArmorID`)
    VALUES (830599,'Auralis Herald','F','New Dawn Herald','Auralis is calling for new defenders. Begin at the landing and follow the ward lights into the city.',1,1000,100,0,
            '0x483329','0xD6AD8D','0x68B6C7','0x374F46','0xB6A276','0x688C99',830250,830201);

    INSERT INTO `quests` (`id`,`FactionID`,`Name`,`Description`,`EndText`,`Experience`,`Gold`,`Coins`,`ClassPoints`,`RewardType`,`Level`,`Upgrade`,`Once`,`Slot`,`Value`,`Field`,`Index`)
    SELECT 830600+`Seq`,1,`QuestName`,`QuestDesc`,`QuestEnd`,300+(`Seq`*150),200+(`Seq`*100),0,100,'S',`Seq`,0,1,93,`Seq`,'',-1
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `maps_npc` (`id`,`MapID`,`NpcID`,`NpcMapID`,`Frame`,`X`,`Y`,`Turn`)
    SELECT 830700+`Seq`,830000+`Seq`,830500+`Seq`,1,'Enter',180,385,'Right'
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `maps_npc` (`id`,`MapID`,`NpcID`,`NpcMapID`,`Frame`,`X`,`Y`,`Turn`)
    VALUES (830799,@entryMap,830599,1,'Enter',240,400,'Right');

    INSERT INTO `maps_monsters` (`id`,`MapID`,`MonsterID`,`MonMapID`,`Frame`,`X`,`Y`,`Aggresive`,`Enabled`)
    SELECT 830720+`Seq`,830000+`Seq`,830300+`Seq`,1,'Enter',650,405,0,1
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 830800+((`Seq`-1)*3)+1,830500+`Seq`,'quests',`QuestName`,CAST(830600+`Seq` AS CHAR),''
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 830800+((`Seq`-1)*3)+2,830500+`Seq`,'shop',CONCAT(`ZoneTitle`,' Supplies'),CAST(830400+`Seq` AS CHAR),''
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    SELECT 830800+((`Seq`-1)*3)+3,830500+`Seq`,'join',
           CASE WHEN `Seq`=20 THEN 'Return to Auralis Heart' ELSE CONCAT('Continue: ',`NextZoneTitle`) END,
           CONCAT(`NextMapName`,'|Enter|Spawn'),''
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `npcs_buttons` (`id`,`NPCID`,`Action`,`Text`,`Value`,`Icon`)
    VALUES (830899,830599,'join','Begin Auralis: New Dawn','auralislanding|Enter|Spawn','');

    INSERT INTO `shops_items` (`id`,`ShopID`,`ItemID`,`QuantityRemain`)
    SELECT 830900+`Seq`,830400+`Seq`,830200+`Seq`,0
    FROM `tmp_auralis_stage` ORDER BY `Seq`;
    INSERT INTO `shops_items` (`id`,`ShopID`,`ItemID`,`QuantityRemain`) VALUES (830950,830401,830250,0);

    INSERT INTO `monsters_drops` (`id`,`MonsterID`,`ItemID`,`Chance`,`Quantity`)
    SELECT 831000+`Seq`,830300+`Seq`,830100+`Seq`,1,1
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `quests_requirements` (`id`,`QuestID`,`ItemID`,`Quantity`)
    SELECT 831100+`Seq`,830600+`Seq`,830100+`Seq`,`ReqQty`
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`)
    SELECT 831200+`Seq`,830600+`Seq`,830200+`Seq`,1,1,'S'
    FROM `tmp_auralis_stage` ORDER BY `Seq`;

    INSERT INTO `classes` (`id`,`ItemID`,`Category`,`Description`,`ManaRegenerationMethods`,`StatsDescription`) VALUES
      (831051,831051,'M1','Auralis Vanguard uses physical attacks and heavy pressure to hold the line.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance improves survival.'),
      (831052,831052,'M1','Lantern Ranger uses quick physical attacks to control the road ahead.','Gain mana by striking enemies and taking hits.','Dexterity and Strength improve offense; Endurance improves survival.'),
      (831053,831053,'M1','Dusk Warden is the veteran discipline earned at the end of Auralis New Dawn.','Gain mana by striking enemies and taking hits.','Strength improves damage; Endurance and Luck support survival.');

    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831051,'Vanguard Strike','Attack1,Attack2','A steady weapon attack.',0.5,0,'iwsword',808,'','aa','h','m','p','',1500,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831061,'Solar Cut','Attack3','Cut one enemy with a charged blade.',1.0,10,'iwsword',808,'','a1','h','m','p','',3000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831071,'Bulwark Breaker','Attack3','A heavy strike against one enemy.',1.35,18,'iwsword',808,'','a2','h','m','p','',6000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831081,'Rampart Sweep','Attack3','Sweep through up to two enemies.',0.85,24,'iwsword',808,'','a3','h','m','p','',9000,2);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831091,'Dawn Verdict','Attack3','Deliver a powerful finishing blow.',2.25,30,'iwsword',808,'','a4','h','m','p','',14000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831052,'Lantern Shot','Attack1,Attack2','A quick ranged weapon attack.',0.5,0,'iwsword',808,'','aa','h','m','p','',1500,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831062,'Quickflare','Attack3','Strike one enemy with a fast flare shot.',1.0,10,'iwsword',808,'','a1','h','m','p','',3000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831072,'Marked Volley','Attack3','Drive a focused volley into one enemy.',1.3,18,'iwsword',808,'','a2','h','m','p','',6000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831082,'Beacon Rain','Attack3','Hit up to two enemies with lantern fire.',0.8,24,'iwsword',808,'','a3','h','m','p','',9000,2);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831092,'Sunline Arrow','Attack3','Fire a high damage finishing shot.',2.2,30,'iwsword',808,'','a4','h','m','p','',14000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831053,'Dusk Strike','Attack1,Attack2','A measured weapon attack.',0.5,0,'iwsword',808,'','aa','h','m','p','',1500,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831063,'Veil Cut','Attack3','Strike one enemy through the veil.',1.0,10,'iwsword',808,'','a1','h','m','p','',3000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831073,'Twilight Brand','Attack3','Brand one enemy with a stronger attack.',1.35,18,'iwsword',808,'','a2','h','m','p','',6000,1);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831083,'Oath Sweep','Attack3','Sweep through up to two enemies.',0.85,24,'iwsword',808,'','a3','h','m','p','',9000,2);
    INSERT INTO `skills` (`id`,`Name`,`Animation`,`Description`,`Damage`,`Mana`,`Icon`,`Range`,`Dsrc`,`Reference`,`Target`,`Effects`,`Type`,`Strl`,`Cooldown`,`HitTargets`) VALUES (831093,'New Dawn Eclipse','Attack3','End the oath with a decisive blow.',2.3,30,'iwsword',808,'','a4','h','m','p','',14000,1);

    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831051,831051,831051);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831061,831061,831051);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831071,831071,831051);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831081,831081,831051);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831091,831091,831051);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831052,831052,831052);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831062,831062,831052);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831072,831072,831052);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831082,831082,831052);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831092,831092,831052);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831053,831053,831053);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831063,831063,831053);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831073,831073,831053);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831083,831083,831053);
    INSERT INTO `skills_assign` (`id`,`SkillID`,`ItemID`) VALUES (831093,831093,831053);

    -- Class unlocks: Chapel Quarter, Broken Causeway, and the final Oath Arena quest.
    INSERT INTO `quests_rewards` (`id`,`QuestID`,`ItemID`,`Quantity`,`Rate`,`RewardType`) VALUES
      (831251,830606,831051,1,1,'S'),
      (831252,830613,831052,1,1,'S'),
      (831253,830620,831053,1,1,'S');

    INSERT IGNORE INTO `aera_content_packs` (`Name`) VALUES ('auralis-new-dawn');

    DROP TEMPORARY TABLE IF EXISTS `tmp_auralis_stage`;
    COMMIT;
  END IF;
END$$
CALL `install_auralis_new_dawn`()$$
DROP PROCEDURE `install_auralis_new_dawn`$$
DELIMITER ;
