-- phpMyAdmin SQL Dump
-- version 2.11.6
-- http://www.phpmyadmin.net
--
-- Host: hostingdb.limedomains.com
-- Generation Time: Aug 08, 2010 at 12:23 PM
-- Server version: 5.0.77
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `winquestworlds`
--

-- --------------------------------------------------------

--
-- Table structure for table `wqw_monsters`
--

CREATE TABLE IF NOT EXISTS `wqw_monsters` (
  `id` int(11) NOT NULL auto_increment,
  `sRace` varchar(32) NOT NULL default 'None',
  `MonID` int(11) NOT NULL,
  `intMPMax` int(5) NOT NULL,
  `intGold` int(5) NOT NULL,
  `intLevel` int(3) NOT NULL,
  `strDrops` varchar(128) NOT NULL,
  `intExp` int(5) NOT NULL,
  `iDPS` int(3) NOT NULL,
  `intHPMax` int(5) NOT NULL,
  `strElement` varchar(32) NOT NULL default 'None',
  `intRSC` int(3) NOT NULL,
  `strLinkage` varchar(32) NOT NULL,
  `strMonFileName` varchar(128) NOT NULL,
  `strMonName` varchar(64) NOT NULL,
  `intRep` int(3) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=953 ;

--
-- Dumping data for table `wqw_monsters`
--

INSERT INTO `wqw_monsters` (`id`, `sRace`, `MonID`, `intMPMax`, `intGold`, `intLevel`, `strDrops`, `intExp`, `iDPS`, `intHPMax`, `strElement`, `intRSC`, `strLinkage`, `strMonFileName`, `strMonName`, `intRep`) VALUES
(1, 'None', 23, 30, 33, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 11, 100, 550, 'None', 0, 'Slimegreen', 'Slimegreen.swf', 'Slime', 50),
(2, 'None', 25, 30, 36, 2, '102:1:1,37:1:0.1,808:1:.8', 22, 100, 600, 'None', 0, 'Sneevil1', 'Sneevil1.swf', 'Sneevil', 50),
(3, 'Orc', 165, 30, 33, 1, '810:1:.95', 11, 100, 1500, 'None', 0, 'OrcWarrior1a', 'OrcWarrior1a.swf', 'Dogear', 0),
(201, 'Sneevil', 201, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Sneevilvoltron1', 'Sneevilvoltron1.swf', 'Sneevilltron', 100),
(202, 'Sneevil', 202, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Sneevilboss', 'Sneevilboss.swf', 'Box Guardian', 1),
(203, 'Sneevil', 203, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Sneevilboss2', 'Sneevilboss2.swf', 'Grizzle Spit', 100),
(304, 'Dragon', 304, 100, 1500, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Princessmonster1', 'Princessmonster1.swf', 'Princess', 100),
(305, 'None', 305, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Frogzard1', 'frogzard1.swf', 'FrogZard', 100),
(306, 'None', 306, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Witch1', 'witch1.swf', 'Dark Witch', 100),
(307, 'None', 307, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'UndeadWar4', 'Undeadwar4.swf', 'Undead Berserker', 100),
(308, 'None', 308, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'UndeadBoss3', 'UndeadBoss3.swf', 'SoulSeeker', 100),
(309, 'None', 309, 150, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Darkelemental', 'DarkElemental.swf', 'Dark Elemental', 100),
(400, 'Dwakel', 400, 1500, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Dwakel3', 'Dwakel3.swf', 'Dwakel Blaster', 100),
(401, 'Dwakel', 401, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Dwakel4', 'Dwakel4.swf', 'Dwakel Warrior', 100),
(402, 'Dwakel', 402, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Dwakel3a', 'Dwakel3a.swf', 'Flamethrower Dwakel', 100),
(403, 'Dwakel', 403, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Dwakelboss2', 'dwakelboss2.swf', 'Protosartorium', 100),
(310, 'Custom', 310, 1, 1, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1, 1, 1, 'None', 1, 'Dragon2', '832cseyui_Dragon2.swf', 'Chaos Test Beast', 100),
(350, 'None', 350, 100, 2000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 5000, 100, 12000, 'None', 1, 'Grenwog', 'Grenwog.swf', 'Grenwog', 100),
(351, 'Chaos', 351, 100, 2147483647, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 800, 100, 1000, 'None', 1, 'Chaoswolf', 'chaoswolf.swf', 'Chaorrupted Wolf', 100),
(352, 'Chaos', 352, 150, 2000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 5000, 100, 2500, 'None', 1, 'ChaosBear', 'chaosbear.swf', 'Twisted Tooth', 100),
(450, 'Cellar', 450, 100, 2000, 4, '102:1:1,37:1:0.1,808:1:.8', 800, 100, 512, 'None', 1, 'Ratgreen', 'ratgreen.swf', 'GreenRat', 100),
(451, 'Cellar', 451, 100, 2000, 4, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 800, 100, 512, 'None', 1, 'Spider1', 'Spider1.swf', 'Spider', 100),
(452, 'Cellar', 452, 100, 2000, 5, '23:1:1,37:1:0.1,808:1:.8', 800, 100, 1005, 'None', 1, 'Slime2', 'Slime2.swf', 'Purple Slime', 100),
(453, 'GreenGuard', 453, 100, 2000, 12, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 2000, 'None', 1, 'Dragon3', 'Dragon3.swf', 'Greenguard Dragon', 100),
(454, 'GreenGuard', 454, 100, 2000, 12, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 2500, 'None', 1, 'Eyemonster2', 'Eyemonster2.swf', 'DeathGazer', 100),
(455, 'GreenGuard', 455, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 2500, 'None', 1, 'Basilisk1', 'Basilisk1.swf', 'Greenguard Basilisk', 100),
(456, 'GreenGuard', 456, 100, 2000, 12, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 2500, 'None', 1, 'SlimeJello1', 'SlimeJello1.swf', 'Gell Oh No', 100),
(457, 'GreenGuard', 457, 100, 2000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Wolfbrown', 'Wolfbrown.swf', 'Wolf', 100),
(600, 'Twilight', 600, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Dreadspider', 'Dreadspider.swf', 'Dread Spider', 100),
(601, 'Twilight', 601, 100, 2000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 3000, 'None', 1, 'Dreadspider2', 'Dreadspider2.swf', 'Abaddon', 100),
(602, 'Twilight', 602, 100, 2000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1500, 'None', 1, 'Spider3A', 'Spider3A.swf', 'Burning SoulEater', 100),
(603, 'Twilight', 603, 100, 2000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1500, 'None', 1, 'Spider3', 'Spider3.swf', 'Toxic SoulEater', 100),
(604, 'Twilight', 604, 100, 2000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 5000, 'None', 1, 'Dreadspider3', 'Dreadspider3.swf', 'Gressil', 100),
(605, 'Twilight', 605, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'CreeperBoss1', 'CreeperBoss1.swf', 'Cadaverous Creeper', 100),
(606, 'Twilight', 606, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Porkypine', 'Porkypine.swf', 'RattleBones', 100),
(460, 'Sewer', 460, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Frogdrake', 'Frogdrake.swf', 'FrogDrake', 100),
(461, 'Sewer', 461, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1750, 'None', 1, 'Worm1', 'Worm1.swf', 'Grumble', 100),
(660, 'Frost', 660, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Frogzard2', 'frogzard2.swf', 'FrostZard', 100),
(661, 'Frost', 661, 100, 2000, 1, '102:1:1,37:1:0.1,808:1:.8', 1500, 100, 2500, 'None', 1, 'FrostScythe', 'FrostScythe.swf', 'FrostScythe', 100),
(750, 'River', 750, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Fishman2', 'Fishman2.swf', 'River Fishman', 100),
(751, 'River', 751, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Zardman2', 'Zardman2.swf', 'ZardMan Fisher', 100),
(752, 'River', 752, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 3000, 'None', 1, 'Watermonster1', 'Watermonster1.swf', 'Kuro', 100),
(753, 'Vath', 753, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Rockelemental2', 'Rockelemental2.swf', 'Balboa', 100),
(754, 'Vath', 754, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 5000, 'None', 1, 'Dragon4', 'Dragon4.swf', 'Stalagbite', 100),
(755, 'Vath', 755, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 6500, 'None', 1, 'Vath', 'Vath.swf', 'Vath', 100),
(756, 'Sketch', 756, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 2000, 'None', 1, 'FrogzardSketch', 'FrogzardSketch.swf', 'Sketchy Frogzard', 100),
(757, 'Sketch', 757, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 6500, 'None', 1, 'DragonSketch', 'DragonSketch.swf', 'Sketchy Dragon', 100),
(758, 'Mythsong', 758, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Fishman3Tuna', 'Fishman3Tuna.swf', 'Tune-A-Fish', 100),
(759, 'Mythsong', 759, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1200, 'None', 1, 'Beetleman', 'Beetleman.swf', 'Beatles', 100),
(760, 'Mythsong', 760, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 7000, 'None', 1, 'Frogdrake2', 'Frogdrake2.swf', 'French Horned Toadra', 100),
(761, 'Shallow', 761, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 2500, 'None', 1, 'Waterelemental', 'Waterelemental.swf', 'Water Elemental', 100),
(762, 'Prison', 762, 100, 0, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1, 100, 600, 'None', 1, 'PrisonWall', 'PrisonWall.swf', 'Prison Wall', 100),
(770, 'Beta', 770, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'UndeadWar1', 'UndeadWar1.swf', 'Skeletal Warrior', 100),
(771, 'Beta', 771, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'UndeadMage1', 'UndeadMage1.swf', 'Skeletal Ice Mage', 100),
(850, 'J6', 850, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 600, 'None', 1, 'TrashCan', 'TrashCan.swf', 'Trash Can', 100),
(851, 'J6', 851, 100000, 100000, 99, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 100000, 1000, 1000000, 'None', 1, 'J6Strong', 'J6Strong.swf', 'J6', 100),
(950, 'Frostvale', 950, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 1000, 'None', 1, 'Snowgolem', 'snowgolem.swf', 'Snow Golem', 100),
(951, 'Frostvale', 951, 100, 2000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1500, 100, 6000, 'None', 1, 'Snowgolemboss', 'snowgolemboss.swf', 'Frosty', 100),
(859, 'chaos', 859, 100, 3000, 1, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 6000, 100, 1200, 'None', 1, 'NinjaNopper1', 'NinjaNopper1.swf', 'Ninja Nopperatu', 100),
(860, 'None', 860, 100, 40000, 4, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 50000, 100, 4000, 'None', 1, 'Shredder1', 'Shredder1.swf', 'Kitsune', 100),
(775, 'None', 775, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 2000, 'None', 1, 'Sentrybot1', 'Sentrybot1.swf', 'Lightning Specialist', 100),
(776, 'None', 776, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 2000, 'None', 1, 'Fireelemental', 'Fireelemental-mini.swf', 'Pyrotechnician', 100),
(26, 'None', 26, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 900, 'None', 1, 'Peasant1', 'Peasant1.swf', 'Kittarian Female', 100),
(27, 'None', 27, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 900, 'None', 1, 'Peasant2', 'Peasant2.swf', 'Kittarian Male', 100),
(28, 'None', 28, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 900, 'None', 1, 'OrcWarrior1', 'OrcWarrior1.swf', 'Horc Noob', 100),
(29, 'None', 29, 100, 10000, 5, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 3000, 'None', 1, 'OrcBoss1', 'OrcBoss1.swf', 'Horc Trainer', 100),
(30, 'None', 30, 100, 10000, 11, '810:1:.95', 1000, 100, 11111, 'None', 1, 'IcecreamFish', 'IcecreamFish.swf', 'Swetish Fish', 100),
(32, 'None', 32, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 2000, 'None', 1, 'Turtle', 'Turtle.swf', 'Red Shell Turtle', 100),
(31, 'None', 31, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 2000, 'None', 1, 'Leatherwing', 'Leatherwing.swf', 'Leatherwing', 100),
(33, 'None', 33, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 2000, 'None', 1, 'Troll3', 'Troll3.swf', 'Pine Troll', 100),
(34, 'None', 34, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 2000, 'None', 1, 'GrizzlyBear', 'GrizzlyBear.swf', 'Pine Grizzly', 100),
(35, 'None', 35, 100, 10000, 2, '98:1:1,285:1:0.15,330:1:.65,425:1:0.3,807:1:1', 1000, 100, 3000, 'None', 1, 'ChaosBear', 'ChaosBear.swf', 'Twisted Tooth', 100);
