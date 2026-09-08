-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 02, 2026 at 05:38 PM
-- Server version: 5.7.9-log
-- PHP Version: 8.2.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aera`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievements`
--

CREATE TABLE `achievements` (
  `id` int(14) UNSIGNED NOT NULL,
  `Name` varchar(55) NOT NULL,
  `File` varchar(255) NOT NULL DEFAULT 'default.swf',
  `Image` varchar(255) NOT NULL DEFAULT 'Achievement.png',
  `Linkage` varchar(60) DEFAULT 'Achievement',
  `Description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `achievements`
--

INSERT INTO `achievements` (`id`, `Name`, `File`, `Image`, `Linkage`, `Description`) VALUES
(1, 'Beta Tester', 'default.swf', 'Achievement.png', 'Achievement', 'PUTANG INA MO!');

-- --------------------------------------------------------

--
-- Table structure for table `admin_audit`
--

CREATE TABLE `admin_audit` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `AdminUserID` int(11) UNSIGNED DEFAULT NULL,
  `Action` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Entity` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `EntityID` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Details` text COLLATE utf8mb4_unicode_ci,
  `IPAddress` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_audit`
--

INSERT INTO `admin_audit` (`id`, `AdminUserID`, `Action`, `Entity`, `EntityID`, `Details`, `IPAddress`, `CreatedAt`) VALUES
(1, 1, 'update', 'monsters', '{\"id\":1}', '{\"Name\":\"Slime Green\",\"File\":\"Slimegreen.swf\",\"Linkage\":\"Slimegreen\",\"Level\":\"1\",\"Health\":\"800\",\"Mana\":\"100\",\"Gold\":\"100\",\"Coin\":\"0\",\"Experience\":\"200\",\"ClassPoint\":\"0\",\"Reputation\":\"100\",\"DamageReduction\":\"0.00\",\"DPS\":\"15\",\"Respawn\":\"6\",\"Speed\":\"2000\",\"Immune\":\"0\"}', '172.70.176.44', '2026-08-31 22:43:20'),
(2, 1, 'update', 'monsters', '{\"id\":1}', '{\"Name\":\"Slime Green\",\"File\":\"Slimegreen.swf\",\"Linkage\":\"Slimegreen\",\"Level\":\"1\",\"Health\":\"300\",\"Mana\":\"100\",\"Gold\":\"100\",\"Coin\":\"0\",\"Experience\":\"200\",\"ClassPoint\":\"0\",\"Reputation\":\"100\",\"DamageReduction\":\"0.00\",\"DPS\":\"15\",\"Respawn\":\"6\",\"Speed\":\"2000\",\"Immune\":\"0\"}', '172.70.176.44', '2026-09-02 13:12:44'),
(3, 1, 'create', 'servers', '4', '{\"Name\":\"Test\",\"IP\":\"217.61.240.144\",\"Online\":\"0\",\"Status\":\"1\",\"Upgrade\":\"0\",\"Chat\":\"2\",\"Count\":\"0\",\"Level\":\"1\",\"Max\":\"500\",\"MOTD\":\"\",\"Port\":\"5588\"}', '172.68.150.210', '2026-09-02 16:04:40'),
(4, 1, 'update', 'servers', '{\"id\":2}', '{\"Name\":\"Test\",\"IP\":\"217.61.240.142\",\"Online\":\"0\",\"Status\":\"1\",\"Upgrade\":\"0\",\"Chat\":\"2\",\"Count\":\"0\",\"Level\":\"1\",\"Max\":\"1000\",\"MOTD\":\"Offline\",\"Port\":\"5588\"}', '172.68.150.210', '2026-09-02 16:06:25'),
(5, 1, 'delete', 'servers', '{\"id\":4}', NULL, '172.68.150.210', '2026-09-02 16:06:33'),
(6, 1, 'update', 'servers', '{\"id\":2}', '{\"Name\":\"Test\",\"IP\":\"217.61.240.142\",\"Online\":\"0\",\"Status\":\"2\",\"Upgrade\":\"0\",\"Chat\":\"2\",\"Count\":\"0\",\"Level\":\"1\",\"Max\":\"1000\",\"MOTD\":\"Offline\",\"Port\":\"5588\"}', '172.68.150.210', '2026-09-02 16:06:45'),
(7, 1, 'update', 'servers', '{\"id\":2}', '{\"Name\":\"Test\",\"IP\":\"217.61.240.144\",\"Online\":\"0\",\"Status\":\"2\",\"Upgrade\":\"0\",\"Chat\":\"2\",\"Count\":\"0\",\"Level\":\"1\",\"Max\":\"1000\",\"MOTD\":\"Offline\",\"Port\":\"5588\"}', '172.68.150.210', '2026-09-02 16:07:00');

-- --------------------------------------------------------

--
-- Table structure for table `admin_commands`
--

CREATE TABLE `admin_commands` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Command` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Payload` text COLLATE utf8mb4_unicode_ci,
  `RequestedBy` int(11) UNSIGNED DEFAULT NULL,
  `Status` enum('pending','processing','complete','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `RequestedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ProcessedAt` datetime DEFAULT NULL,
  `Result` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_commands`
--

INSERT INTO `admin_commands` (`id`, `Command`, `Payload`, `RequestedBy`, `Status`, `RequestedAt`, `ProcessedAt`, `Result`) VALUES
(1, 'reload_data', NULL, 1, 'complete', '2026-08-31 22:36:02', '2026-08-31 22:36:04', 'Database-backed game cache reloaded.'),
(2, 'safe_shutdown', NULL, 1, 'complete', '2026-08-31 22:47:31', '2026-08-31 22:47:32', 'Five-minute in-game shutdown countdown started.'),
(3, 'reload_data', NULL, 1, 'complete', '2026-09-02 09:05:13', '2026-09-02 09:05:14', 'Database-backed game cache reloaded.');

-- --------------------------------------------------------

--
-- Table structure for table `auras`
--

CREATE TABLE `auras` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `Duration` smallint(3) NOT NULL DEFAULT '6',
  `Category` varchar(8) NOT NULL,
  `Chance` decimal(7,2) NOT NULL DEFAULT '1.00',
  `DamageIncrease` decimal(7,2) NOT NULL DEFAULT '0.00',
  `DamageTakenDecrease` decimal(7,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `auras`
--

INSERT INTO `auras` (`id`, `Name`, `Duration`, `Category`, `Chance`, `DamageIncrease`, `DamageTakenDecrease`) VALUES
(1, 'Armor Shred', 5, 'none', 1.00, 0.00, 0.00),
(2, 'Precise Blow', 3, 'stun', 1.00, 0.00, 0.00),
(3, 'Aggression', 6, 'passive', 1.00, 0.00, 0.00),
(4, 'Resolute', 6, 'passive', 1.00, 0.00, 0.00),
(5, 'On Guard', 5, 'none', 1.00, 0.00, 0.00),
(6, 'Fortune', 10, 'none', 1.00, 0.00, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `auras_effects`
--

CREATE TABLE `auras_effects` (
  `id` int(11) UNSIGNED NOT NULL,
  `AuraID` int(11) UNSIGNED NOT NULL,
  `Stat` char(3) NOT NULL,
  `Value` decimal(7,2) NOT NULL DEFAULT '0.00',
  `Type` char(1) NOT NULL DEFAULT '+'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `auras_effects`
--

INSERT INTO `auras_effects` (`id`, `AuraID`, `Stat`, `Value`, `Type`) VALUES
(1, 1, 'cai', 15.00, '-'),
(2, 3, 'thi', 10.00, '*'),
(3, 4, 'cao', 10.00, '+'),
(4, 5, 'cai', 50.00, '+'),
(5, 6, 'thi', 30.00, '+');

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `id` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Category` char(2) NOT NULL,
  `Description` text NOT NULL,
  `ManaRegenerationMethods` text NOT NULL,
  `StatsDescription` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`id`, `ItemID`, `Category`, `Description`, `ManaRegenerationMethods`, `StatsDescription`) VALUES
(1, 2, 'M1', 'Warlord are quintessential melee fighters. Simple, direct, and effective, they are masters of armed combat, and quite durable.', 'Warlords gain mana when they:,-Strike an enemy in combat (more effective on crits),-Are struck by an enemy in combat', 'Warlords are quintessential melee fighters. Simple, direct, and effective, they are masters of armed');

-- --------------------------------------------------------

--
-- Table structure for table `enhancements`
--

CREATE TABLE `enhancements` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `PatternID` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `Rarity` tinyint(3) UNSIGNED NOT NULL,
  `DPS` smallint(4) UNSIGNED NOT NULL,
  `Level` tinyint(3) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `enhancements`
--

INSERT INTO `enhancements` (`id`, `Name`, `PatternID`, `Rarity`, `DPS`, `Level`) VALUES
(1, 'Adventurer Enhancement', 1, 1, 50, 1),
(2, 'Fighter Enhancement', 2, 1, 50, 1),
(3, 'Lucky Enhacement', 3, 0, 60, 1);

-- --------------------------------------------------------

--
-- Table structure for table `enhancements_patterns`
--

CREATE TABLE `enhancements_patterns` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `Desc` varchar(4) NOT NULL,
  `Wisdom` tinyint(2) UNSIGNED NOT NULL,
  `Strength` tinyint(2) UNSIGNED NOT NULL,
  `Luck` tinyint(2) UNSIGNED NOT NULL,
  `Dexterity` tinyint(2) UNSIGNED NOT NULL,
  `Endurance` tinyint(2) UNSIGNED NOT NULL,
  `Intelligence` tinyint(2) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `enhancements_patterns`
--

INSERT INTO `enhancements_patterns` (`id`, `Name`, `Desc`, `Wisdom`, `Strength`, `Luck`, `Dexterity`, `Endurance`, `Intelligence`) VALUES
(1, 'Adventurer', 'M1', 11, 20, 5, 3, 2, 10),
(2, 'Fighter', 'M2', 11, 20, 5, 3, 2, 10),
(3, 'Lucky', 'M1', 15, 15, 100, 15, 15, 15);

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `factions`
--

INSERT INTO `factions` (`id`, `Name`) VALUES
(1, 'None');

-- --------------------------------------------------------

--
-- Table structure for table `game_sessions`
--

CREATE TABLE `game_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `TokenHash` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ExpiresAt` datetime NOT NULL,
  `LastUsedAt` datetime DEFAULT NULL,
  `IPAddress` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `game_sessions`
--

INSERT INTO `game_sessions` (`id`, `UserID`, `TokenHash`, `CreatedAt`, `ExpiresAt`, `LastUsedAt`, `IPAddress`) VALUES
(77, 4, 'dcb88c0de23b80da7e743bb075c66826cbd7ef116bc17b06d3a7ba93fe402978', '2026-09-02 16:05:00', '2026-09-03 06:05:00', NULL, '172.70.176.44'),
(90, 5, '7f68395e1b44147e3e095699af926df718184182a3014e930daabfa7dcf57172', '2026-09-02 16:19:16', '2026-09-03 06:19:16', '2026-09-02 16:19:18', '104.23.237.91'),
(91, 1, '4dcee6e62ab8dc2076cdd0cbc46cfa0d0cf256ba5e1683e4a7e016520cd31db6', '2026-09-02 17:34:18', '2026-09-03 07:34:18', '2026-09-02 17:34:21', '172.68.150.210');

-- --------------------------------------------------------

--
-- Table structure for table `global_drops`
--

CREATE TABLE `global_drops` (
  `id` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Chance` decimal(7,2) UNSIGNED NOT NULL DEFAULT '1.00',
  `Quantity` int(11) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Color` varchar(64) NOT NULL DEFAULT '0xFFFFFF',
  `MessageOfTheDay` varchar(512) NOT NULL,
  `MaxMembers` tinyint(3) UNSIGNED NOT NULL DEFAULT '15',
  `Wins` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Loses` int(11) NOT NULL DEFAULT '0',
  `TotalKills` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Level` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `Exp` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `hairs`
--

CREATE TABLE `hairs` (
  `id` int(11) UNSIGNED NOT NULL,
  `Gender` char(1) NOT NULL,
  `Name` varchar(16) NOT NULL,
  `File` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hairs`
--

INSERT INTO `hairs` (`id`, `Gender`, `Name`, `File`) VALUES
(1, 'M', 'MQElegant', 'hairs/M/MQElegant.swf'),
(2, 'F', 'Pig Bangs', 'hairs/F/Pig1Bangs1.swf');

-- --------------------------------------------------------

--
-- Table structure for table `hairs_shops`
--

CREATE TABLE `hairs_shops` (
  `id` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hairs_shops`
--

INSERT INTO `hairs_shops` (`id`, `Name`) VALUES
(1, 'Yulgar');

-- --------------------------------------------------------

--
-- Table structure for table `hairs_shops_items`
--

CREATE TABLE `hairs_shops_items` (
  `id` int(11) UNSIGNED NOT NULL,
  `Gender` enum('M','F') NOT NULL DEFAULT 'M',
  `ShopID` int(11) UNSIGNED NOT NULL,
  `HairID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hairs_shops_items`
--

INSERT INTO `hairs_shops_items` (`id`, `Gender`, `ShopID`, `HairID`) VALUES
(1, 'M', 1, 1),
(2, 'F', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(60) NOT NULL,
  `Description` text NOT NULL,
  `Type` varchar(16) NOT NULL,
  `Element` varchar(16) NOT NULL DEFAULT 'None',
  `File` varchar(120) DEFAULT NULL,
  `Link` varchar(64) DEFAULT NULL,
  `Icon` varchar(16) NOT NULL,
  `Equipment` varchar(10) NOT NULL,
  `Level` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `DPS` smallint(6) UNSIGNED NOT NULL DEFAULT '100',
  `Range` smallint(6) UNSIGNED NOT NULL DEFAULT '50',
  `Rarity` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `Quantity` smallint(4) UNSIGNED NOT NULL DEFAULT '1',
  `Stack` smallint(4) UNSIGNED NOT NULL DEFAULT '1',
  `Cost` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Coins` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Sell` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `Temporary` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Upgrade` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Staff` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `EnhID` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `FactionID` int(11) UNSIGNED DEFAULT NULL,
  `ReqReputation` mediumint(6) UNSIGNED NOT NULL DEFAULT '0',
  `ReqClassID` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `ReqClassPoints` mediumint(6) UNSIGNED NOT NULL DEFAULT '0',
  `QuestStringIndex` tinyint(3) NOT NULL DEFAULT '-1',
  `QuestStringValue` tinyint(3) NOT NULL DEFAULT '0',
  `ReqQuests` varchar(32) DEFAULT NULL,
  `Trade` tinyint(1) DEFAULT '1',
  `Market` tinyint(1) DEFAULT '1',
  `Meta` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `Name`, `Description`, `Type`, `Element`, `File`, `Link`, `Icon`, `Equipment`, `Level`, `DPS`, `Range`, `Rarity`, `Quantity`, `Stack`, `Cost`, `Coins`, `Sell`, `Temporary`, `Upgrade`, `Staff`, `EnhID`, `FactionID`, `ReqReputation`, `ReqClassID`, `ReqClassPoints`, `QuestStringIndex`, `QuestStringValue`, `ReqQuests`, `Trade`, `Market`, `Meta`) VALUES
(1, 'Default Sword', 'Default sword for every adventurers', 'Sword', 'None', 'items/swords/sword01.swf', 'sword01', 'iwsword', 'Weapon', 1, 100, 50, 10, 1, 1, 0, 0, 0, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(2, 'Warrior', 'The heart of a warrior is filled with courage and ...', 'Class', 'None', 'NewWarriorB2.swf', 'NewWarriorB2', 'iiclass', 'ar', 1, 100, 50, 1, 1, 1, 15000, 0, 0, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(3, 'Xp Boost (1 hrs)', 'Using this item will DOUBLE all experience gained from killing monsters or completing quests for 1 hour.', 'ServerUse', 'None', 'icbxp', 'xpboost::60::false', 'icbxp', 'None', 1, 100, 50, 1, 1, 20, 5000, 1, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(4, 'Gold Boost (1 hrs)', 'Using this item will DOUBLE all Gold gained from killing monsters or completing quests for 1 hour of in-game play time.', 'ServerUse', 'None', 'icbgold', 'gboost::60::false', 'icbgold', 'None', 1, 100, 50, 1, 1, 20, 5000, 1, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(5, 'Coins Boost (1 hrs)', 'Using this item will DOUBLE all Coins gained from killing monsters or completing quests for 1 hour of in-game play time.', 'ServerUse', 'None', 'iicrystal', 'coinsboost::60::false', 'iicrystal', 'None', 1, 100, 50, 1, 1, 20, 5000, 1, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(6, 'Class Point Boost (1 hrs)', 'Using this item will DOUBLE all Class Point gained from completing quests and all other sources for 1 HOUR of in-game play time. Does not expire while logged out.', 'ServerUse', 'None', 'icbcp', 'cpboost::60::false', 'icbcp', 'None', 1, 100, 50, 1, 1, 20, 5000, 1, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(7, 'Reputation Boost (1 hrs)', 'Using this item will DOUBLE all Reputation gained from killing monsters or completing quests for 1 hour of in-game play time.', 'ServerUse', 'None', 'icbrep', 'repboost::60::false', 'icbrep', 'None', 1, 100, 50, 1, 1, 20, 5000, 1, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(8, 'Creepy Cottage', 'Creepy Cottage', 'House', 'None', 'houses/house-CreepyCottage_r1.swf', '', 'ihhouse', 'ho', 1, 100, 50, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(9, 'Dragon Trophy', 'Dragon Trophy', 'Floor Item', 'None', '', 'GLTrophy', 'ihfloor', 'hi', 1, 100, 50, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(10, 'Treasure Hunt', 'Treasure Hunt', 'Item', 'None', '', '', 'iibag', 'None', 1, 100, 50, 1, 1, 999, 100, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(11, 'Fortune Potion', 'Spin the Wheel, become stronger! HIT CHANCE for a short time.', 'Item', 'None', 'ich1', 'ich1', 'ich1', 'None', 1, 100, 50, 1, 1, 999, 0, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, '8'),
(12, 'Standard Wheel Ticket', 'A single stack of ticket, this ticket is used to unlock awesome items in a wheel.', 'Item', 'None', '', 'iidesign', 'iidesign', 'None', 1, 100, 50, 1, 1, 500, 0, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(13, 'Stack of Wheel Ticket', 'A multiple stack of ticket, this ticket is used to unlock awesome items in a wheel.', 'Item', 'None', '', 'iidesign', 'iidesign', 'None', 1, 100, 50, 1, 10, 100, 0, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL),
(14, 'Purple Vamp', '..', 'Armor', 'None', 'DPurpleVamp.swf', 'DPurpleVamp', 'iwarmor', 'co', 1, 100, 50, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, NULL, 0, 0, 0, -1, 0, '', 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `items_requirements`
--

CREATE TABLE `items_requirements` (
  `id` int(11) NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `ReqItemID` int(11) UNSIGNED NOT NULL,
  `Quantity` smallint(6) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `items_requirements`
--

INSERT INTO `items_requirements` (`id`, `ItemID`, `ReqItemID`, `Quantity`) VALUES
(1, 8, 11, 50),
(2, 9, 11, 25);

-- --------------------------------------------------------

--
-- Table structure for table `items_skills`
--

CREATE TABLE `items_skills` (
  `ItemID` int(11) UNSIGNED NOT NULL,
  `SkillID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `maps`
--

CREATE TABLE `maps` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `File` varchar(128) NOT NULL,
  `MaxPlayers` tinyint(3) UNSIGNED NOT NULL DEFAULT '6',
  `ReqLevel` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `ReqParty` int(11) UNSIGNED NOT NULL,
  `Upgrade` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Staff` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `PvP` tinyint(1) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `maps`
--

INSERT INTO `maps` (`id`, `Name`, `File`, `MaxPlayers`, `ReqLevel`, `ReqParty`, `Upgrade`, `Staff`, `PvP`) VALUES
(1, 'faroff', 'town-battleon-21Nov14.swf', 10, 1, 0, 0, 0, 0),
(2, 'newbie', 'town-newbie-6jan12.swf', 10, 1, 0, 0, 0, 0),
(3, 'limbo', 'town-limbo.swf', 15, 1, 0, 0, 1, 0),
(4, 'deadlock', '1VS1-duel-01.11.14-HP.A.swf', 2, 1, 0, 0, 0, 1),
(5, 'test', 'testv1.swf', 6, 1, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `maps_items`
--

CREATE TABLE `maps_items` (
  `MapID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `maps_monsters`
--

CREATE TABLE `maps_monsters` (
  `id` int(11) NOT NULL,
  `MapID` int(11) UNSIGNED NOT NULL,
  `MonsterID` int(11) UNSIGNED NOT NULL,
  `MonMapID` int(11) UNSIGNED NOT NULL,
  `Frame` varchar(16) NOT NULL,
  `Aggresive` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `maps_monsters`
--

INSERT INTO `maps_monsters` (`id`, `MapID`, `MonsterID`, `MonMapID`, `Frame`, `Aggresive`) VALUES
(1, 2, 1, 1, 'r2', 0),
(2, 2, 1, 8, 'r2', 0),
(3, 5, 1, 1, 'Enter', 0),
(4, 5, 1, 2, 'Enter', 0),
(5, 5, 1, 3, 'Enter', 0);

-- --------------------------------------------------------

--
-- Table structure for table `monsters`
--

CREATE TABLE `monsters` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(30) NOT NULL,
  `File` varchar(128) NOT NULL,
  `Linkage` varchar(32) NOT NULL,
  `Level` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `Health` int(11) UNSIGNED NOT NULL DEFAULT '1000',
  `Mana` int(11) UNSIGNED NOT NULL DEFAULT '100',
  `Gold` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Coin` int(11) NOT NULL DEFAULT '0',
  `Experience` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `ClassPoint` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Reputation` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `DamageReduction` decimal(7,2) NOT NULL DEFAULT '0.00',
  `DPS` int(11) UNSIGNED NOT NULL DEFAULT '100',
  `Respawn` int(11) NOT NULL DEFAULT '6',
  `Speed` int(11) NOT NULL DEFAULT '1500',
  `Immune` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `monsters`
--

INSERT INTO `monsters` (`id`, `Name`, `File`, `Linkage`, `Level`, `Health`, `Mana`, `Gold`, `Coin`, `Experience`, `ClassPoint`, `Reputation`, `DamageReduction`, `DPS`, `Respawn`, `Speed`, `Immune`) VALUES
(1, 'Slime Green', 'Slimegreen.swf', 'Slimegreen', 1, 300, 100, 100, 0, 200, 0, 100, 0.00, 15, 6, 2000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `monsters_drops`
--

CREATE TABLE `monsters_drops` (
  `id` int(11) NOT NULL,
  `MonsterID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Chance` decimal(7,2) UNSIGNED NOT NULL DEFAULT '1.00',
  `Quantity` int(11) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `monsters_skills`
--

CREATE TABLE `monsters_skills` (
  `MonsterID` int(11) UNSIGNED NOT NULL,
  `SkillID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `news_posts`
--

CREATE TABLE `news_posts` (
  `id` int(11) UNSIGNED NOT NULL,
  `Title` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Slug` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Excerpt` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `Body` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `Image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Published` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `Pinned` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `AuthorID` int(11) UNSIGNED DEFAULT NULL,
  `PublishedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `news_posts`
--

INSERT INTO `news_posts` (`id`, `Title`, `Slug`, `Excerpt`, `Body`, `Image`, `Published`, `Pinned`, `AuthorID`, `PublishedAt`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'This is a test post 01', 'post-1788242001', 'TEST', 'This is a test post 01This is a test post 01This is a test post 01This is a test post 01', NULL, 1, 0, 1, '2026-08-31 22:53:21', '2026-08-31 22:53:21', '2026-08-31 22:53:21'),
(2, 'This is a test post 02', 'post-1788242014', 'TEST', 'This is a test post 02This is a test post 02This is a test post 02This is a test post 02This is a test post 02This is a test post 02', NULL, 1, 0, 1, '2026-08-31 22:53:34', '2026-08-31 22:53:34', '2026-08-31 22:53:34'),
(3, 'This is a test post 03', 'post-1788242022', 'TEST', 'This is a test post 03This is a test post 03This is a test post 03This is a test post 03This is a test post 03This is a test post 03This is a test post 03', NULL, 1, 0, 1, '2026-08-31 22:53:42', '2026-08-31 22:53:42', '2026-08-31 22:53:42'),
(4, 'This is a test post 04', 'post-1788242031', 'TEST', 'This is a test post 04This is a test post 04This is a test post 04This is a test post 04This is a test post 04This is a test post 04', NULL, 1, 0, 1, '2026-08-31 22:53:51', '2026-08-31 22:53:51', '2026-08-31 22:53:51'),
(5, 'This is a test post 05', 'post-1788242043', 'TEST', 'This is a test post 05This is a test post 05This is a test post 05This is a test post 05This is a test post 05This is a test post 05', NULL, 1, 0, 1, '2026-08-31 22:54:03', '2026-08-31 22:54:03', '2026-08-31 22:54:03'),
(6, 'This is a test post 06', 'post-1788242053', 'TEST', 'This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06This is a test post 06', NULL, 1, 0, 1, '2026-08-31 22:54:13', '2026-08-31 22:54:13', '2026-08-31 22:54:13');

-- --------------------------------------------------------

--
-- Table structure for table `quests`
--

CREATE TABLE `quests` (
  `id` int(11) UNSIGNED NOT NULL,
  `WarID` int(11) UNSIGNED DEFAULT NULL,
  `AchievementID` int(11) UNSIGNED DEFAULT NULL,
  `TitleID` int(11) DEFAULT NULL,
  `FactionID` int(11) UNSIGNED DEFAULT '1',
  `WarMega` tinyint(1) DEFAULT '0',
  `ReqReputation` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `ReqClassID` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `ReqClassPoints` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Name` varchar(64) NOT NULL,
  `Description` text NOT NULL,
  `EndText` text NOT NULL,
  `Experience` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Gold` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Coins` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Reputation` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `ClassPoints` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `RewardType` char(1) NOT NULL DEFAULT 'S',
  `Level` tinyint(3) NOT NULL DEFAULT '1',
  `Upgrade` tinyint(1) NOT NULL DEFAULT '0',
  `Once` tinyint(1) NOT NULL DEFAULT '0',
  `Slot` int(11) NOT NULL DEFAULT '-1',
  `Value` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Field` char(3) NOT NULL DEFAULT '',
  `Index` int(11) NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `quests`
--

INSERT INTO `quests` (`id`, `WarID`, `AchievementID`, `TitleID`, `FactionID`, `WarMega`, `ReqReputation`, `ReqClassID`, `ReqClassPoints`, `Name`, `Description`, `EndText`, `Experience`, `Gold`, `Coins`, `Reputation`, `ClassPoints`, `RewardType`, `Level`, `Upgrade`, `Once`, `Slot`, `Value`, `Field`, `Index`) VALUES
(1, NULL, NULL, NULL, 1, 0, 0, 0, 0, 'Wheel Standard', 'None', 'None', 0, 100, 0, 0, 0, 'S', 1, 0, 0, -1, 0, '', -1),
(2, NULL, NULL, NULL, 1, 0, 0, 0, 0, 'Wheel Stacked', 'None', 'None', 0, 100, 0, 0, 0, 'S', 1, 0, 0, -1, 0, '', -1),
(172, NULL, NULL, NULL, 1, 0, 0, 0, 0, 'Test 172', 'Test', 'Test', 5, 5, 5, 0, 5, 'S', 1, 0, 0, -1, 0, '', -1);

-- --------------------------------------------------------

--
-- Table structure for table `quests_required_items`
--

CREATE TABLE `quests_required_items` (
  `id` int(11) NOT NULL,
  `QuestID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `quests_requirements`
--

CREATE TABLE `quests_requirements` (
  `id` int(11) NOT NULL,
  `QuestID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Quantity` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `quests_requirements`
--

INSERT INTO `quests_requirements` (`id`, `QuestID`, `ItemID`, `Quantity`) VALUES
(1, 172, 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `quests_rewards`
--

CREATE TABLE `quests_rewards` (
  `id` int(11) NOT NULL,
  `QuestID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Quantity` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `Rate` decimal(7,2) UNSIGNED NOT NULL DEFAULT '1.00',
  `RewardType` varchar(60) NOT NULL DEFAULT 'S'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `redeems`
--

CREATE TABLE `redeems` (
  `id` int(11) UNSIGNED NOT NULL,
  `Code` varchar(60) NOT NULL,
  `Coins` int(11) UNSIGNED NOT NULL,
  `Gold` int(11) UNSIGNED NOT NULL,
  `Exp` int(11) UNSIGNED NOT NULL,
  `ClassPoints` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED DEFAULT NULL,
  `Quantity` int(11) NOT NULL DEFAULT '1',
  `QuantityLeft` int(11) NOT NULL DEFAULT '1',
  `Limited` tinyint(4) NOT NULL DEFAULT '1',
  `Expires` tinyint(4) NOT NULL DEFAULT '1',
  `DateExpiry` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `servers`
--

CREATE TABLE `servers` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(64) NOT NULL DEFAULT 'Server',
  `IP` char(18) NOT NULL DEFAULT '0.0.0.0',
  `Online` tinyint(1) NOT NULL DEFAULT '0',
  `Status` int(11) NOT NULL DEFAULT '1',
  `Upgrade` tinyint(1) NOT NULL DEFAULT '0',
  `Chat` tinyint(1) NOT NULL DEFAULT '2',
  `Count` mediumint(4) NOT NULL DEFAULT '0',
  `Level` mediumint(4) NOT NULL DEFAULT '1',
  `Max` mediumint(4) NOT NULL DEFAULT '500',
  `MOTD` text NOT NULL,
  `Port` int(11) NOT NULL DEFAULT '5588'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `servers`
--

INSERT INTO `servers` (`id`, `Name`, `IP`, `Online`, `Status`, `Upgrade`, `Chat`, `Count`, `Level`, `Max`, `MOTD`, `Port`) VALUES
(1, 'Aera', '217.61.240.142', 1, 2, 0, 2, 1, 1, 1000, 'Welcome to Aera. Staff will never ask for your password.', 5588),
(2, 'Test', '217.61.240.144', 1, 2, 0, 2, 0, 1, 1000, 'Offline', 5588);

-- --------------------------------------------------------

--
-- Table structure for table `settings_filters`
--

CREATE TABLE `settings_filters` (
  `id` int(11) NOT NULL,
  `Word` varchar(60) NOT NULL,
  `Mutetime` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings_filters`
--

INSERT INTO `settings_filters` (`id`, `Word`, `Mutetime`) VALUES
(1, 'dick', 360),
(2, 'dickhead', 360),
(3, 'kingina', 1000),
(4, 'tite', 360),
(5, 'titi', 360);

-- --------------------------------------------------------

--
-- Table structure for table `settings_login`
--

CREATE TABLE `settings_login` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `value` varchar(50) NOT NULL DEFAULT '',
  `location` enum('loader','game','wiki') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings_login`
--

INSERT INTO `settings_login` (`id`, `name`, `value`, `location`) VALUES
(1, 'gMenu', '', 'game'),
(2, 'sAssets', 'Assets_20241211.swf', 'game'),
(3, 'sBG', 'LegionBG.swf', 'loader'),
(4, 'sBook', 'interface/secure__FoM.Scroll4.swf', 'game'),
(6, 'sFile', 'aClient-04.swf', 'loader'),
(9, 'sLoader', 'Loader.swf', 'loader'),
(14, 'sTitle', 'Aera', 'loader'),
(15, 'sVersion', '1.0.0', 'loader'),
(16, 'sWTSandbox', 'false', 'game'),
(17, 'iMaxBagSlots', '480', 'game'),
(18, 'iMaxBankSlots', '800', 'game'),
(19, 'iMaxFriends', '275', 'game'),
(20, 'iMaxGuildMembers', '800', 'game'),
(21, 'iMaxHouseSlots', '275', 'game'),
(22, 'iMaxLoadoutSlots', '20', 'game'),
(23, 'sCharSelect', 'interface/CharSelect/charselect.swf', 'loader'),
(24, 'sLoadout', 'Outfit/outfitsetsr2.swf', 'loader');

-- --------------------------------------------------------

--
-- Table structure for table `settings_messages`
--

CREATE TABLE `settings_messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '',
  `Interval` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings_messages`
--

INSERT INTO `settings_messages` (`id`, `message`, `Interval`) VALUES
(1, 'Welcome to Aera! Follow the website news for server updates.', 5000);

-- --------------------------------------------------------

--
-- Table structure for table `settings_rates`
--

CREATE TABLE `settings_rates` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  `value` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings_rates`
--

INSERT INTO `settings_rates` (`id`, `name`, `value`) VALUES
(1, 'baseBlock', '0.7'),
(2, 'baseBlockValue', '0.7'),
(3, 'baseCrit', '0.05'),
(4, 'baseCritValue', '1.5'),
(5, 'baseDodge', '0.04'),
(6, 'baseEventValue', '0.05'),
(7, 'baseHaste', '0'),
(8, 'baseHit', '0'),
(9, 'baseMiss', '0.1'),
(10, 'baseParry', '0.03'),
(11, 'baseResistValue', '0.7'),
(12, 'bigNumberBase', '8'),
(13, 'curveExponent', '0.66'),
(14, 'GstBase', '12'),
(15, 'GstGoal', '572'),
(16, 'GstRatio', '5.6'),
(17, 'intAPtoDPS', '10'),
(18, 'intBagSpaceCap', '500'),
(19, 'intBagSpacePrice', '200'),
(20, 'intBankSpaceCap', '550'),
(21, 'intBankSpacePrice', '200'),
(22, 'intCoinsCap', '1000000'),
(23, 'intCoinsReward', '5000'),
(24, 'intGoldCap', '1000000'),
(25, 'intHouseSpaceCap', '155'),
(26, 'intHouseSpacePrice', '200'),
(27, 'intHPperEND', '5'),
(28, 'intLevelCap', '100'),
(29, 'intLevelMax', '100'),
(30, 'intMPperWIS', '5'),
(31, 'intSPtoDPS', '10'),
(32, 'intStackCap', '1500'),
(33, 'intStatPointPerLevel', '3'),
(34, 'modRating', '3'),
(35, 'PCDPSMod', '0.85'),
(36, 'PChpBase1', '360'),
(37, 'PChpBase100', '4000'),
(38, 'PChpDelta', '1640'),
(39, 'PChpGoal1', '400'),
(40, 'PChpGoal100', '4000'),
(41, 'PCmpBase1', '100'),
(42, 'PCmpBase100', '2000'),
(43, 'PCmpDelta', '900'),
(44, 'PCstBase', '15'),
(45, 'PCstGoal', '762'),
(46, 'PCstRatio', '7.47'),
(47, 'resistRating', '17'),
(48, 'statsExponent', '1'),
(50, 'intLoadoutSpacePrice', '200');

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `House` tinyint(1) NOT NULL DEFAULT '0',
  `Upgrade` tinyint(1) NOT NULL DEFAULT '0',
  `Staff` tinyint(1) NOT NULL DEFAULT '0',
  `Limited` tinyint(1) NOT NULL DEFAULT '0',
  `Field` varchar(8) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `Name`, `House`, `Upgrade`, `Staff`, `Limited`, `Field`) VALUES
(1, 'Wheel Shop', 0, 0, 0, 0, ''),
(2, 'Wheel Tickets', 0, 0, 0, 0, ''),
(39, 'Test Shop', 0, 0, 0, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `shops_items`
--

CREATE TABLE `shops_items` (
  `id` int(11) UNSIGNED NOT NULL,
  `ShopID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `QuantityRemain` int(11) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `shops_items`
--

INSERT INTO `shops_items` (`id`, `ShopID`, `ItemID`, `QuantityRemain`) VALUES
(1, 39, 10, 1),
(2, 2, 12, 0),
(3, 2, 13, 0);

-- --------------------------------------------------------

--
-- Table structure for table `shops_seasonal`
--

CREATE TABLE `shops_seasonal` (
  `ShopID` int(11) UNSIGNED NOT NULL,
  `EndDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shops_seasonal`
--

INSERT INTO `shops_seasonal` (`ShopID`, `EndDate`) VALUES
(39, '2025-03-14 19:56:30');

-- --------------------------------------------------------

--
-- Table structure for table `site_settings`
--

CREATE TABLE `site_settings` (
  `SettingKey` varchar(96) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SettingValue` text COLLATE utf8mb4_unicode_ci,
  `UpdatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `site_settings`
--

INSERT INTO `site_settings` (`SettingKey`, `SettingValue`, `UpdatedAt`) VALUES
('foundation.version', '3.2.0', '2026-09-01 03:59:32'),
('game.base_url', 'https://nightvaults.com/', '2026-09-01 03:59:32'),
('gamefiles.base_url', 'https://nightvaults.com/gamefiles/', '2026-09-01 03:59:32'),
('registration.enabled', '1', '2026-09-01 03:59:32'),
('site.name', 'Aera', '2026-09-01 03:59:32'),
('site.tagline', 'A new beginning awaits.', '2026-09-01 03:59:32'),
('site.url', 'https://nightvaults.com/', '2026-09-01 03:59:32');

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `Animation` varchar(64) NOT NULL,
  `Description` text NOT NULL,
  `Damage` decimal(7,2) NOT NULL DEFAULT '1.00',
  `Mana` smallint(3) NOT NULL DEFAULT '0',
  `Icon` varchar(32) NOT NULL,
  `Range` smallint(3) UNSIGNED NOT NULL DEFAULT '808',
  `Dsrc` varchar(70) NOT NULL,
  `Reference` char(2) NOT NULL,
  `Target` char(1) NOT NULL DEFAULT 'h',
  `Effects` char(1) NOT NULL,
  `Type` varchar(7) NOT NULL,
  `Strl` varchar(32) NOT NULL,
  `Cooldown` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `HitTargets` tinyint(2) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`id`, `Name`, `Animation`, `Description`, `Damage`, `Mana`, `Icon`, `Range`, `Dsrc`, `Reference`, `Target`, `Effects`, `Type`, `Strl`, `Cooldown`, `HitTargets`) VALUES
(1, 'Attack', 'Attack1,Attack2', 'A basic attack, taught to all adventurers. Damage dealt is based on your weapon damage.', 0.50, 0, 'iwd1', 303, '', 'aa', 'h', 'm', 'p', '', 1500, 1),
(2, 'Decisive Strike', 'Attack3', 'A powerful strike. Applies Armor Shred to your target, reducing their Damage Resistance by 10% for 5 seconds.', 0.87, 13, 'ims2,iwaxe', 808, '', 'a1', 'h', 'm', 'p', '', 2000, 1),
(3, 'Imbalancing Strike', 'Thrash', 'A powerful and precise blow which stuns your target for 3 seconds.', 0.73, 15, 'iss1', 303, '', 'a2', 'h', 'm', 'p', '', 10000, 1),
(4, 'Prepared Strike', 'Unsheath', 'Empower your weapon, causing your next two Auto Attacks to be unavoidable critical hits. If On Guard was active at the time of application, the Auto Attacks will deal double damage.', 0.00, 25, 'ims3,iwsword', 303, '', 'a3', 'f', 'e', 'm', '', 12000, 1),
(5, 'Aggression', '', 'Hit Chance and outgoing physical damage increased by 10%.', 0.00, 0, 'iwdagger,iwsword', 808, '', 'p1', 's', 'm', 'passive', '', 0, 1),
(6, 'Resolute', '', 'Damage Resistance increased by 10%.', 0.00, 0, 'iwarmor', 808, '', 'p2', 's', 'm', 'passive', '', 0, 1),
(7, 'On Guard', 'ShieldBlock', 'Take a defensive stance. Applies On Guard, increasing your Damage Resistance by 50% for 5 seconds.', 0.50, 30, 'iwshield', 303, '', 'a4', 'f', 'm', 'p', '', 10000, 1),
(8, 'Fortune', 'Hit', 'IncreaseHit Chance by 30% for 10 seconds.', -3.00, 0, 'ich1', 808, '', 'i1', 'f', 'e', 'm', '', 3000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `skills_assign`
--

CREATE TABLE `skills_assign` (
  `id` int(11) UNSIGNED NOT NULL,
  `SkillID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `skills_assign`
--

INSERT INTO `skills_assign` (`id`, `SkillID`, `ItemID`) VALUES
(1, 1, 2),
(2, 2, 2),
(3, 3, 2),
(4, 4, 2),
(5, 5, 2),
(6, 6, 2),
(7, 7, 2);

-- --------------------------------------------------------

--
-- Table structure for table `skills_auras`
--

CREATE TABLE `skills_auras` (
  `id` int(11) NOT NULL,
  `SkillID` int(11) UNSIGNED NOT NULL,
  `AuraID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `skills_auras`
--

INSERT INTO `skills_auras` (`id`, `SkillID`, `AuraID`) VALUES
(1, 2, 1),
(2, 3, 2),
(3, 5, 3),
(4, 6, 4),
(5, 7, 5),
(6, 8, 6);

-- --------------------------------------------------------

--
-- Table structure for table `titles`
--

CREATE TABLE `titles` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(55) NOT NULL,
  `Description` text NOT NULL,
  `Strength` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Intellect` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Endurance` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Dexterity` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Wisdom` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Luck` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Color` varchar(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `titles`
--

INSERT INTO `titles` (`id`, `Name`, `Description`, `Strength`, `Intellect`, `Endurance`, `Dexterity`, `Wisdom`, `Luck`, `Color`) VALUES
(1, 'Game Dev', 'Game Dev', 10, 9, 8, 7, 6, 5, '0xFF0000'),
(2, 'Admin', 'Admin', 0, 0, 0, 0, 0, 0, '0xFF0000'),
(3, 'Test 1', 'Test 1', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(4, 'Test 2', 'Test 2', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(5, 'Test 3', 'Test 3', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(6, 'Test 4', 'Test 4', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(7, 'Test 5', 'Test 5', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(8, 'Test 6', 'Test 6', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(9, 'Test 7', 'Test 7', 0, 0, 0, 0, 0, 0, '0xFFFFFF'),
(10, 'Test 8', 'Test 8', 0, 0, 0, 0, 0, 0, '0xFFFFFF');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(32) NOT NULL,
  `Hash` char(70) NOT NULL,
  `HairID` int(11) UNSIGNED NOT NULL DEFAULT '1',
  `TitleID` int(11) UNSIGNED DEFAULT NULL,
  `Access` tinyint(2) UNSIGNED NOT NULL DEFAULT '1',
  `ActivationFlag` tinyint(1) UNSIGNED NOT NULL DEFAULT '5',
  `PermamuteFlag` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Country` char(2) NOT NULL DEFAULT 'xx',
  `Age` tinyint(2) UNSIGNED NOT NULL DEFAULT '18',
  `Gender` char(1) NOT NULL DEFAULT 'M',
  `Email` varchar(64) NOT NULL,
  `Level` tinyint(2) UNSIGNED NOT NULL DEFAULT '1',
  `Gold` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Coins` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Exp` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `ColorHair` char(6) NOT NULL DEFAULT '000000',
  `ColorSkin` char(6) NOT NULL DEFAULT '000000',
  `ColorEye` char(6) NOT NULL DEFAULT '000000',
  `ColorBase` char(6) NOT NULL DEFAULT '000000',
  `ColorTrim` char(6) NOT NULL DEFAULT '000000',
  `ColorAccessory` char(6) NOT NULL DEFAULT '000000',
  `SlotsAuction` smallint(5) NOT NULL DEFAULT '10',
  `SlotsBag` smallint(5) UNSIGNED NOT NULL DEFAULT '40',
  `SlotsBank` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `SlotsHouse` smallint(5) UNSIGNED NOT NULL DEFAULT '20',
  `SlotsLoadout` smallint(5) UNSIGNED NOT NULL DEFAULT '2',
  `DateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastLogin` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CpBoostExpire` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `RepBoostExpire` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `GoldBoostExpire` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `CoinsBoostExpire` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ExpBoostExpire` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `UpgradeExpire` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpgradeDays` smallint(3) NOT NULL DEFAULT '0',
  `Upgraded` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Achievement` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Settings` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Quests` char(100) NOT NULL DEFAULT '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  `Quests2` char(100) NOT NULL DEFAULT '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  `DailyQuests0` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `DailyQuests1` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `DailyQuests2` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `MonthlyQuests0` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `LastArea` varchar(64) NOT NULL DEFAULT 'faroff-1|Enter|Spawn',
  `CurrentServer` varchar(16) NOT NULL DEFAULT 'Offline',
  `HouseInfo` text,
  `KillCount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `DeathCount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `Address` varchar(255) NOT NULL DEFAULT '0.0.0.0',
  `GameAddress` varchar(255) NOT NULL DEFAULT '0.0.0.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `Name`, `Hash`, `HairID`, `TitleID`, `Access`, `ActivationFlag`, `PermamuteFlag`, `Country`, `Age`, `Gender`, `Email`, `Level`, `Gold`, `Coins`, `Exp`, `ColorHair`, `ColorSkin`, `ColorEye`, `ColorBase`, `ColorTrim`, `ColorAccessory`, `SlotsAuction`, `SlotsBag`, `SlotsBank`, `SlotsHouse`, `SlotsLoadout`, `DateCreated`, `LastLogin`, `CpBoostExpire`, `RepBoostExpire`, `GoldBoostExpire`, `CoinsBoostExpire`, `ExpBoostExpire`, `UpgradeExpire`, `UpgradeDays`, `Upgraded`, `Achievement`, `Settings`, `Quests`, `Quests2`, `DailyQuests0`, `DailyQuests1`, `DailyQuests2`, `MonthlyQuests0`, `LastArea`, `CurrentServer`, `HouseInfo`, `KillCount`, `DeathCount`, `Address`, `GameAddress`) VALUES
(1, 'animu', '$2y$10$fdFBlG8NydHlAEh9NL8TveNWxuM/YdRcB2fJzJKTkcahagGEUoccW', 1, NULL, 60, 5, 0, 'xx', 18, 'M', 'asd@aol.com', 3, 3705, 99005, 800, 'FF00FF', 'EACD8A', '01649E', '000000', '000000', '000000', 10, 40, 0, 20, 2, '2026-08-31 21:29:35', '2026-09-02 17:34:21', '2026-09-02 13:24:13', '2026-09-02 13:24:10', '2026-09-02 13:24:12', '2000-01-01 00:00:00', '2026-09-02 13:24:09', '2026-08-31 21:29:35', 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 0, 0, 0, 0, 'newbie|r2|Left', 'Aera', '', 5, 2, '0.0.0.0', '162.247.130.167'),
(2, 'valfor', '$2y$10$VcrcMohok9X9mfHhocwNcOSrOWNg9Qtx3v2m8SmLXWvpVmWo8mlJG', 1, NULL, 60, 5, 0, 'xx', 18, 'M', 'dibsworlds@gmail.com', 1, 0, 0, 0, '5e4f37', 'eacd8a', '1649e', '000000', '000000', '000000', 10, 40, 0, 20, 2, '2026-09-01 11:15:39', '2026-09-01 11:15:39', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2026-09-01 11:15:39', 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 0, 0, 0, 0, 'limbo|Enter|Spawn', 'Offline', NULL, 0, 0, '0.0.0.0', '0.0.0.0'),
(3, 'animutest', '$2y$10$Wwg/IQHHx6l0tzf9jJU6WOVqUPAARpCoiGzJbJZEGmaz5.PB7SY0K', 1, NULL, 60, 5, 0, 'xx', 18, 'M', 'adaw@aol.com', 1, 0, 0, 0, '5e4f37', 'eacd8a', '1649e', '000000', '000000', '000000', 10, 40, 0, 20, 2, '2026-09-01 15:29:47', '2026-09-01 16:08:08', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2026-09-01 15:29:47', 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 0, 0, 0, 0, 'limbo|Enter|Spawn', 'Offline', NULL, 0, 0, '0.0.0.0', '0.0.0.0'),
(4, 'valfortest', '$2y$10$AhTCLEiYzz79ll41ahwLFuhPYOsceVjct3IZG/vGYGzYpXee.0W/O', 1, NULL, 1, 5, 0, 'xx', 18, 'M', 'dibsworlds2@gmail.com', 1, 0, 0, 0, '5e4f37', 'eacd8a', '1649e', '000000', '000000', '000000', 10, 40, 0, 20, 2, '2026-09-02 15:54:04', '2026-09-02 16:05:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2026-09-02 15:54:04', 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 0, 0, 0, 0, 'newbie|Enter|Spawn', 'Offline', '', 0, 0, '0.0.0.0', '162.247.130.167'),
(5, 'cadette', '$2y$10$9fksgiWDRPb41dDcd4Zs0OaHdjz6fp6gGktkvlACJFkaShjecoLJK', 1, NULL, 1, 5, 0, 'xx', 18, 'M', 'ggliferson@gmail.com', 1, 300, 0, 600, '5e4f37', 'eacd8a', '1649e', '000000', '000000', '000000', 10, 40, 0, 20, 2, '2026-09-02 16:16:34', '2026-09-02 16:19:18', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2000-01-01 00:00:00', '2026-09-02 16:16:34', 0, 0, 0, 0, '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 0, 0, 0, 0, 'faroff|Enter|Spawn', 'Offline', '', 3, 0, '0.0.0.0', '179.1.101.12');

-- --------------------------------------------------------

--
-- Table structure for table `users_achievements`
--

CREATE TABLE `users_achievements` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `AchievementID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_factions`
--

CREATE TABLE `users_factions` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `FactionID` int(11) UNSIGNED NOT NULL,
  `Reputation` mediumint(6) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_friends`
--

CREATE TABLE `users_friends` (
  `UserID` int(11) UNSIGNED NOT NULL,
  `FriendID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_guilds`
--

CREATE TABLE `users_guilds` (
  `id` int(11) UNSIGNED NOT NULL,
  `GuildID` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `Rank` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_houses`
--

CREATE TABLE `users_houses` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) NOT NULL,
  `Frame` varchar(50) NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `X` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Y` int(11) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_items`
--

CREATE TABLE `users_items` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `EnhID` int(11) UNSIGNED DEFAULT NULL,
  `Equipped` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Quantity` mediumint(6) UNSIGNED NOT NULL DEFAULT '1',
  `Bank` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `Wear` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `DatePurchased` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_items`
--

INSERT INTO `users_items` (`id`, `UserID`, `ItemID`, `EnhID`, `Equipped`, `Quantity`, `Bank`, `Wear`, `DatePurchased`) VALUES
(1, 1, 1, 1, 1, 1, 0, 0, '2026-08-31 21:29:35'),
(2, 1, 2, 1, 1, 202601, 0, 0, '2026-08-31 21:29:35'),
(3, 1, 13, 1, 0, 6, 0, 0, '2026-08-31 22:18:40'),
(5, 1, 11, 1, 0, 4, 0, 0, '2026-08-31 22:18:44'),
(6, 1, 9, 1, 0, 1, 0, 0, '2026-08-31 22:18:48'),
(7, 2, 1, 1, 1, 1, 0, 0, '2026-09-01 11:15:39'),
(8, 2, 2, 1, 1, 1, 0, 0, '2026-09-01 11:15:39'),
(9, 3, 1, 1, 1, 1, 0, 0, '2026-09-01 15:29:47'),
(10, 3, 2, 1, 1, 1, 0, 0, '2026-09-01 15:29:47'),
(14, 1, 8, 1, 0, 1, 0, 0, '2026-09-02 12:23:30'),
(15, 1, 10, 1, 0, 1, 0, 0, '2026-09-02 12:23:36'),
(16, 1, 14, 1, 0, 1, 0, 0, '2026-09-02 12:23:41'),
(17, 1, 3, 1, 0, 20, 0, 0, '2026-09-02 12:28:13'),
(18, 4, 1, 1, 1, 1, 0, 0, '2026-09-02 15:54:04'),
(19, 4, 2, 1, 1, 1, 0, 0, '2026-09-02 15:54:04'),
(20, 5, 1, 1, 1, 1, 0, 0, '2026-09-02 16:16:34'),
(21, 5, 2, 1, 1, 1, 0, 0, '2026-09-02 16:16:34');

-- --------------------------------------------------------

--
-- Table structure for table `users_logs`
--

CREATE TABLE `users_logs` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED DEFAULT NULL,
  `Violation` varchar(64) NOT NULL,
  `Details` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_logs`
--

INSERT INTO `users_logs` (`id`, `UserID`, `Violation`, `Details`) VALUES
(1, 1, 'Suspicous TurnIn', 'Item to turn in not found in database.'),
(2, 1, 'Suspicous TurnIn', 'Item to turn in not found in database.'),
(3, 1, 'Suspicous TurnIn', 'Item to turn in not found in database.');

-- --------------------------------------------------------

--
-- Table structure for table `users_markets`
--

CREATE TABLE `users_markets` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED DEFAULT NULL,
  `ItemID` int(11) UNSIGNED DEFAULT NULL,
  `EnhID` int(11) UNSIGNED DEFAULT NULL,
  `Datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `BuyerID` int(11) UNSIGNED DEFAULT NULL,
  `Gold` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Coins` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Quantity` int(11) UNSIGNED NOT NULL,
  `Type` enum('Auction') NOT NULL DEFAULT 'Auction',
  `Status` tinyint(1) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_markets`
--

INSERT INTO `users_markets` (`id`, `UserID`, `ItemID`, `EnhID`, `Datetime`, `BuyerID`, `Gold`, `Coins`, `Quantity`, `Type`, `Status`) VALUES
(1, 1, 11, 1, '2026-09-02 05:20:23', NULL, 0, 1, 1, 'Auction', 1),
(2, 1, 11, 1, '2026-09-02 19:21:14', NULL, 0, 1, 1, 'Auction', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_markets_logs`
--

CREATE TABLE `users_markets_logs` (
  `OwnerID` int(11) UNSIGNED NOT NULL,
  `BuyerID` int(11) UNSIGNED DEFAULT NULL,
  `Gold` int(11) UNSIGNED NOT NULL,
  `Coins` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED DEFAULT NULL,
  `EnhID` int(11) UNSIGNED DEFAULT NULL,
  `Quantity` int(11) UNSIGNED NOT NULL,
  `Type` enum('Buy','Sell','Retrieve') NOT NULL,
  `Market` enum('Auction') NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_markets_logs`
--

INSERT INTO `users_markets_logs` (`OwnerID`, `BuyerID`, `Gold`, `Coins`, `ItemID`, `EnhID`, `Quantity`, `Type`, `Market`, `Date`) VALUES
(1, NULL, 0, 1, 11, 1, 1, 'Sell', 'Auction', '2026-09-01 05:20:23'),
(1, NULL, 0, 1, 11, 1, 1, 'Retrieve', 'Auction', '2026-09-01 05:20:32');

-- --------------------------------------------------------

--
-- Table structure for table `users_outfits`
--

CREATE TABLE `users_outfits` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Equipments` text CHARACTER SET utf8 NOT NULL,
  `ColorAccessory` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `ColorBase` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `ColorTrim` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `ColorHair` varchar(15) NOT NULL DEFAULT '0',
  `ColorSkin` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `ColorEye` varchar(15) CHARACTER SET utf8 NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_redeems`
--

CREATE TABLE `users_redeems` (
  `id` int(11) UNSIGNED NOT NULL,
  `RedeemID` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `UserID` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `Date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_reports`
--

CREATE TABLE `users_reports` (
  `id` int(11) NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `TargetName` varchar(60) NOT NULL,
  `Category` varchar(60) NOT NULL,
  `Description` text NOT NULL,
  `DateSubmitted` datetime NOT NULL DEFAULT '1974-01-01 00:00:00'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_titles`
--

CREATE TABLE `users_titles` (
  `id` int(11) UNSIGNED NOT NULL,
  `UserID` int(11) UNSIGNED NOT NULL,
  `TitleID` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_trades`
--

CREATE TABLE `users_trades` (
  `id` int(11) NOT NULL,
  `FromUserID` int(11) UNSIGNED NOT NULL,
  `ToUserID` int(11) UNSIGNED NOT NULL,
  `Coins` int(11) UNSIGNED NOT NULL,
  `Gold` int(11) UNSIGNED NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_trades_items`
--

CREATE TABLE `users_trades_items` (
  `FromUserID` int(11) UNSIGNED DEFAULT NULL,
  `ToUserID` int(11) UNSIGNED DEFAULT NULL,
  `ItemID` int(11) UNSIGNED DEFAULT NULL,
  `EnhID` int(11) UNSIGNED DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `wars`
--

CREATE TABLE `wars` (
  `id` int(11) UNSIGNED NOT NULL,
  `Name` varchar(60) DEFAULT NULL,
  `Points` int(11) DEFAULT '0',
  `MaxPoints` int(11) DEFAULT '10000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `wheels`
--

CREATE TABLE `wheels` (
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Chance` decimal(7,2) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `wheels`
--

INSERT INTO `wheels` (`ItemID`, `Chance`, `Quantity`) VALUES
(8, 0.70, 1),
(9, 0.60, 1),
(10, 0.70, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_audit`
--
ALTER TABLE `admin_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_admin_audit_admin` (`AdminUserID`),
  ADD KEY `idx_admin_audit_created` (`CreatedAt`);

--
-- Indexes for table `admin_commands`
--
ALTER TABLE `admin_commands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_admin_commands_status` (`Status`,`RequestedAt`),
  ADD KEY `fk_admin_commands_user` (`RequestedBy`);

--
-- Indexes for table `auras`
--
ALTER TABLE `auras`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `auras_effects`
--
ALTER TABLE `auras_effects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_auras_effects_auras` (`AuraID`);

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`,`ItemID`) USING BTREE,
  ADD KEY `FK_classes_items` (`ItemID`);

--
-- Indexes for table `enhancements`
--
ALTER TABLE `enhancements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_enhancements_patternid` (`PatternID`);

--
-- Indexes for table `enhancements_patterns`
--
ALTER TABLE `enhancements_patterns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `game_sessions`
--
ALTER TABLE `game_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_game_sessions_token` (`TokenHash`),
  ADD KEY `idx_game_sessions_user` (`UserID`),
  ADD KEY `idx_game_sessions_expiry` (`ExpiresAt`);

--
-- Indexes for table `global_drops`
--
ALTER TABLE `global_drops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_global_drops_items` (`ItemID`);

--
-- Indexes for table `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hairs`
--
ALTER TABLE `hairs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hairs_shops`
--
ALTER TABLE `hairs_shops`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `hairs_shops_items`
--
ALTER TABLE `hairs_shops_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_items_enhid` (`EnhID`),
  ADD KEY `fk_items_factionid` (`FactionID`),
  ADD KEY `fk_items_reqclassid` (`ReqClassID`),
  ADD KEY `FK_items_items_rarities` (`Rarity`);

--
-- Indexes for table `items_requirements`
--
ALTER TABLE `items_requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_items_requirements_items` (`ItemID`),
  ADD KEY `FK_items_requirements_items_2` (`ReqItemID`);

--
-- Indexes for table `items_skills`
--
ALTER TABLE `items_skills`
  ADD PRIMARY KEY (`ItemID`),
  ADD KEY `FK_items_skills_skills` (`SkillID`);

--
-- Indexes for table `maps`
--
ALTER TABLE `maps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maps_items`
--
ALTER TABLE `maps_items`
  ADD PRIMARY KEY (`MapID`,`ItemID`),
  ADD KEY `fk_mapitem_itemid` (`ItemID`);

--
-- Indexes for table `maps_monsters`
--
ALTER TABLE `maps_monsters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_maps_monsters_maps` (`MapID`),
  ADD KEY `FK_maps_monsters_monsters` (`MonsterID`);

--
-- Indexes for table `monsters`
--
ALTER TABLE `monsters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `monsters_drops`
--
ALTER TABLE `monsters_drops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_monsters_drops_monsters` (`MonsterID`),
  ADD KEY `FK_monsters_drops_items` (`ItemID`);

--
-- Indexes for table `monsters_skills`
--
ALTER TABLE `monsters_skills`
  ADD PRIMARY KEY (`MonsterID`),
  ADD KEY `FK_monsters_skills_monsters` (`MonsterID`),
  ADD KEY `FK_monsters_skills_skills` (`SkillID`);

--
-- Indexes for table `news_posts`
--
ALTER TABLE `news_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_news_slug` (`Slug`),
  ADD KEY `idx_news_published` (`Published`,`Pinned`,`PublishedAt`),
  ADD KEY `fk_news_author` (`AuthorID`);

--
-- Indexes for table `quests`
--
ALTER TABLE `quests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_quests_factionid` (`FactionID`),
  ADD KEY `fk_quests_classid` (`ReqClassID`),
  ADD KEY `FK_quests_achievements` (`AchievementID`),
  ADD KEY `FK_quests_wars` (`WarID`);

--
-- Indexes for table `quests_required_items`
--
ALTER TABLE `quests_required_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_quests_reqditems_quests` (`QuestID`),
  ADD KEY `FK_quests_reqditems_items` (`ItemID`);

--
-- Indexes for table `quests_requirements`
--
ALTER TABLE `quests_requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKmuw6ian13i0bgbncnisalmofo` (`ItemID`),
  ADD KEY `FK7ja2i1gayntqyx8acr1fh80tf` (`QuestID`);

--
-- Indexes for table `quests_rewards`
--
ALTER TABLE `quests_rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKkxgsbchs88dj96al5gg18roi6` (`ItemID`),
  ADD KEY `FKp12rmebsmpa9a5hx6qa2yfv04` (`QuestID`);

--
-- Indexes for table `redeems`
--
ALTER TABLE `redeems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_redeems_items` (`ItemID`);

--
-- Indexes for table `servers`
--
ALTER TABLE `servers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings_filters`
--
ALTER TABLE `settings_filters`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `settings_login`
--
ALTER TABLE `settings_login`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `settings_messages`
--
ALTER TABLE `settings_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings_rates`
--
ALTER TABLE `settings_rates`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shops_items`
--
ALTER TABLE `shops_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_shopitems_shopid` (`ShopID`),
  ADD KEY `fk_shopitems_itemid` (`ItemID`);

--
-- Indexes for table `shops_seasonal`
--
ALTER TABLE `shops_seasonal`
  ADD KEY `FK_shops_seasonal_shops` (`ShopID`);

--
-- Indexes for table `site_settings`
--
ALTER TABLE `site_settings`
  ADD PRIMARY KEY (`SettingKey`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `skills_assign`
--
ALTER TABLE `skills_assign`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK__skills` (`SkillID`),
  ADD KEY `FK__items` (`ItemID`);

--
-- Indexes for table `skills_auras`
--
ALTER TABLE `skills_auras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_skills_auras_skills` (`SkillID`),
  ADD KEY `FK_skills_auras_auras` (`AuraID`);

--
-- Indexes for table `titles`
--
ALTER TABLE `titles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`,`Name`,`Hash`) USING BTREE,
  ADD UNIQUE KEY `Username` (`Name`),
  ADD KEY `fk_users_hairid` (`HairID`),
  ADD KEY `Hash` (`Hash`) USING BTREE;

--
-- Indexes for table `users_achievements`
--
ALTER TABLE `users_achievements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_users_achievements_users` (`UserID`),
  ADD KEY `FK_users_achievements_achievements` (`AchievementID`);

--
-- Indexes for table `users_factions`
--
ALTER TABLE `users_factions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UserID` (`UserID`,`FactionID`),
  ADD KEY `fk_userfactions_factionid` (`FactionID`);

--
-- Indexes for table `users_friends`
--
ALTER TABLE `users_friends`
  ADD PRIMARY KEY (`UserID`,`FriendID`),
  ADD KEY `fk_friends_friendid` (`FriendID`);

--
-- Indexes for table `users_guilds`
--
ALTER TABLE `users_guilds`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `FK_users_guilds_guilds` (`GuildID`),
  ADD KEY `FK_users_guilds_users` (`UserID`);

--
-- Indexes for table `users_houses`
--
ALTER TABLE `users_houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_items`
--
ALTER TABLE `users_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uid_itemid` (`ItemID`,`UserID`),
  ADD KEY `fk_useritems_enhid` (`EnhID`),
  ADD KEY `fk_useritems_userid` (`UserID`);

--
-- Indexes for table `users_logs`
--
ALTER TABLE `users_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_userlogs_userid` (`UserID`);

--
-- Indexes for table `users_markets`
--
ALTER TABLE `users_markets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_users_markets_users` (`UserID`),
  ADD KEY `FK_users_markets_items` (`ItemID`),
  ADD KEY `FK_users_markets_enhancements` (`EnhID`),
  ADD KEY `FK_users_markets_users_2` (`BuyerID`);

--
-- Indexes for table `users_markets_logs`
--
ALTER TABLE `users_markets_logs`
  ADD KEY `FK_users_markets_logs_users` (`OwnerID`),
  ADD KEY `FK_users_markets_logs_users_2` (`BuyerID`),
  ADD KEY `FK_users_markets_logs_items` (`ItemID`),
  ADD KEY `FK_users_markets_logs_enhancements` (`EnhID`);

--
-- Indexes for table `users_outfits`
--
ALTER TABLE `users_outfits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_users_loadouts_users` (`UserID`);

--
-- Indexes for table `users_redeems`
--
ALTER TABLE `users_redeems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_users_redeems_redeems` (`RedeemID`),
  ADD KEY `FK_users_redeems_users` (`UserID`);

--
-- Indexes for table `users_reports`
--
ALTER TABLE `users_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_users_reports_users` (`UserID`);

--
-- Indexes for table `users_titles`
--
ALTER TABLE `users_titles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_trades`
--
ALTER TABLE `users_trades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_users_trades_users` (`FromUserID`),
  ADD KEY `FK_users_trades_users_2` (`ToUserID`);

--
-- Indexes for table `users_trades_items`
--
ALTER TABLE `users_trades_items`
  ADD KEY `FK__users` (`FromUserID`),
  ADD KEY `FK__users_2` (`ToUserID`),
  ADD KEY `FK__items` (`ItemID`),
  ADD KEY `FK__enhancements` (`EnhID`);

--
-- Indexes for table `wars`
--
ALTER TABLE `wars`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wheels`
--
ALTER TABLE `wheels`
  ADD PRIMARY KEY (`ItemID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` int(14) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `admin_audit`
--
ALTER TABLE `admin_audit`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `admin_commands`
--
ALTER TABLE `admin_commands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `auras`
--
ALTER TABLE `auras`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `auras_effects`
--
ALTER TABLE `auras_effects`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `enhancements`
--
ALTER TABLE `enhancements`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `enhancements_patterns`
--
ALTER TABLE `enhancements_patterns`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `game_sessions`
--
ALTER TABLE `game_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `global_drops`
--
ALTER TABLE `global_drops`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hairs`
--
ALTER TABLE `hairs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=958;

--
-- AUTO_INCREMENT for table `hairs_shops`
--
ALTER TABLE `hairs_shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `hairs_shops_items`
--
ALTER TABLE `hairs_shops_items`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `items_requirements`
--
ALTER TABLE `items_requirements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `maps`
--
ALTER TABLE `maps`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `maps_monsters`
--
ALTER TABLE `maps_monsters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `monsters`
--
ALTER TABLE `monsters`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `monsters_drops`
--
ALTER TABLE `monsters_drops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `news_posts`
--
ALTER TABLE `news_posts`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `quests`
--
ALTER TABLE `quests`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `quests_required_items`
--
ALTER TABLE `quests_required_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quests_requirements`
--
ALTER TABLE `quests_requirements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `quests_rewards`
--
ALTER TABLE `quests_rewards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `servers`
--
ALTER TABLE `servers`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `settings_filters`
--
ALTER TABLE `settings_filters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `settings_login`
--
ALTER TABLE `settings_login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `settings_messages`
--
ALTER TABLE `settings_messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `settings_rates`
--
ALTER TABLE `settings_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `shops_items`
--
ALTER TABLE `shops_items`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `skills_assign`
--
ALTER TABLE `skills_assign`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `skills_auras`
--
ALTER TABLE `skills_auras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `titles`
--
ALTER TABLE `titles`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users_achievements`
--
ALTER TABLE `users_achievements`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_factions`
--
ALTER TABLE `users_factions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_guilds`
--
ALTER TABLE `users_guilds`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_houses`
--
ALTER TABLE `users_houses`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_items`
--
ALTER TABLE `users_items`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users_logs`
--
ALTER TABLE `users_logs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users_markets`
--
ALTER TABLE `users_markets`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users_outfits`
--
ALTER TABLE `users_outfits`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_redeems`
--
ALTER TABLE `users_redeems`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_reports`
--
ALTER TABLE `users_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_titles`
--
ALTER TABLE `users_titles`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_trades`
--
ALTER TABLE `users_trades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wars`
--
ALTER TABLE `wars`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_audit`
--
ALTER TABLE `admin_audit`
  ADD CONSTRAINT `fk_admin_audit_user` FOREIGN KEY (`AdminUserID`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `admin_commands`
--
ALTER TABLE `admin_commands`
  ADD CONSTRAINT `fk_admin_commands_user` FOREIGN KEY (`RequestedBy`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `auras_effects`
--
ALTER TABLE `auras_effects`
  ADD CONSTRAINT `FK_auras_effects_auras` FOREIGN KEY (`AuraID`) REFERENCES `auras` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `classes`
--
ALTER TABLE `classes`
  ADD CONSTRAINT `FK_classes_items` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `enhancements`
--
ALTER TABLE `enhancements`
  ADD CONSTRAINT `FK_enhancements_enhancements_patterns` FOREIGN KEY (`PatternID`) REFERENCES `enhancements_patterns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `game_sessions`
--
ALTER TABLE `game_sessions`
  ADD CONSTRAINT `fk_game_sessions_user` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `global_drops`
--
ALTER TABLE `global_drops`
  ADD CONSTRAINT `FK_global_drops_items` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `FK_items_enhancements` FOREIGN KEY (`EnhID`) REFERENCES `enhancements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_items_factions` FOREIGN KEY (`FactionID`) REFERENCES `factions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `items_requirements`
--
ALTER TABLE `items_requirements`
  ADD CONSTRAINT `FK_items_requirements_items` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_items_requirements_items_2` FOREIGN KEY (`ReqItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `items_skills`
--
ALTER TABLE `items_skills`
  ADD CONSTRAINT `FKpp1cdddrcqxq1qxx9rjnvpp3r` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `FKqyt8g25xcsjrbt21de7clmkf8` FOREIGN KEY (`SkillID`) REFERENCES `skills` (`id`);

--
-- Constraints for table `maps_items`
--
ALTER TABLE `maps_items`
  ADD CONSTRAINT `FKg9692euy8ff48y6mmxntemklc` FOREIGN KEY (`MapID`) REFERENCES `maps` (`id`),
  ADD CONSTRAINT `FKqm8afl1ljard4s2nib32g69ts` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`);

--
-- Constraints for table `maps_monsters`
--
ALTER TABLE `maps_monsters`
  ADD CONSTRAINT `FKj4bx7ums3hogq184e3m3pnfb8` FOREIGN KEY (`MonsterID`) REFERENCES `monsters` (`id`),
  ADD CONSTRAINT `FKois5ak4sxfhdlx37p7xeh83sg` FOREIGN KEY (`MapID`) REFERENCES `maps` (`id`);

--
-- Constraints for table `monsters_drops`
--
ALTER TABLE `monsters_drops`
  ADD CONSTRAINT `FK6gxmy23qojgc6th3dclji6onq` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `FKn7mqwuhn9copfd5ychsisjvqc` FOREIGN KEY (`MonsterID`) REFERENCES `monsters` (`id`);

--
-- Constraints for table `monsters_skills`
--
ALTER TABLE `monsters_skills`
  ADD CONSTRAINT `FK8wpgjnoctef64danl01ia3swn` FOREIGN KEY (`MonsterID`) REFERENCES `monsters` (`id`),
  ADD CONSTRAINT `FKoe3xgdrji49tugb4307tsoa3h` FOREIGN KEY (`SkillID`) REFERENCES `skills` (`id`);

--
-- Constraints for table `news_posts`
--
ALTER TABLE `news_posts`
  ADD CONSTRAINT `fk_news_author` FOREIGN KEY (`AuthorID`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `quests`
--
ALTER TABLE `quests`
  ADD CONSTRAINT `FK1kaook9lujr6s2cwqr8rknegv` FOREIGN KEY (`AchievementID`) REFERENCES `achievements` (`id`),
  ADD CONSTRAINT `FK8nw5gp0m01yv7u00kmgpdam55` FOREIGN KEY (`FactionID`) REFERENCES `factions` (`id`),
  ADD CONSTRAINT `FKnb8ktwlipo9t6el68robjv2p1` FOREIGN KEY (`WarID`) REFERENCES `wars` (`id`);

--
-- Constraints for table `quests_required_items`
--
ALTER TABLE `quests_required_items`
  ADD CONSTRAINT `FKaenplea63pwgmx8cdq7a4smpc` FOREIGN KEY (`QuestID`) REFERENCES `quests` (`id`),
  ADD CONSTRAINT `FKmqhhvsl7v6n7dcqveyyib0j1d` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`);

--
-- Constraints for table `quests_requirements`
--
ALTER TABLE `quests_requirements`
  ADD CONSTRAINT `FK7ja2i1gayntqyx8acr1fh80tf` FOREIGN KEY (`QuestID`) REFERENCES `quests` (`id`),
  ADD CONSTRAINT `FKmuw6ian13i0bgbncnisalmofo` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`);

--
-- Constraints for table `quests_rewards`
--
ALTER TABLE `quests_rewards`
  ADD CONSTRAINT `FKkxgsbchs88dj96al5gg18roi6` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `FKp12rmebsmpa9a5hx6qa2yfv04` FOREIGN KEY (`QuestID`) REFERENCES `quests` (`id`);

--
-- Constraints for table `shops_items`
--
ALTER TABLE `shops_items`
  ADD CONSTRAINT `FKhy5g6k69qtdxbv0lpwl08jxc4` FOREIGN KEY (`ShopID`) REFERENCES `shops` (`id`),
  ADD CONSTRAINT `FKqikn091kioqm0dbkf1t0w0phm` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`);

--
-- Constraints for table `shops_seasonal`
--
ALTER TABLE `shops_seasonal`
  ADD CONSTRAINT `FK_shops_seasonal_shops` FOREIGN KEY (`ShopID`) REFERENCES `shops` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `skills_assign`
--
ALTER TABLE `skills_assign`
  ADD CONSTRAINT `FK__items` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK__skills` FOREIGN KEY (`SkillID`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `skills_auras`
--
ALTER TABLE `skills_auras`
  ADD CONSTRAINT `FK_skills_auras_auras` FOREIGN KEY (`AuraID`) REFERENCES `auras` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_skills_auras_skills` FOREIGN KEY (`SkillID`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FKk5xtmfxv33m8frrumlh13lje0` FOREIGN KEY (`HairID`) REFERENCES `hairs` (`id`);

--
-- Constraints for table `users_factions`
--
ALTER TABLE `users_factions`
  ADD CONSTRAINT `FK_users_factions_factions` FOREIGN KEY (`FactionID`) REFERENCES `factions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_factions_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_friends`
--
ALTER TABLE `users_friends`
  ADD CONSTRAINT `FK_users_friends_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_guilds`
--
ALTER TABLE `users_guilds`
  ADD CONSTRAINT `FK_users_guilds_guilds` FOREIGN KEY (`GuildID`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_guilds_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_items`
--
ALTER TABLE `users_items`
  ADD CONSTRAINT `FK74w0y27rldrrr5bxv7qilfjl4` FOREIGN KEY (`EnhID`) REFERENCES `enhancements` (`id`),
  ADD CONSTRAINT `FKskp2d25pul0ttf34s8qwg3hkl` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKss555n17dhk5gpfbbr5y67541` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`);

--
-- Constraints for table `users_outfits`
--
ALTER TABLE `users_outfits`
  ADD CONSTRAINT `FK_users_loadouts_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_redeems`
--
ALTER TABLE `users_redeems`
  ADD CONSTRAINT `FK_users_redeems_redeems` FOREIGN KEY (`RedeemID`) REFERENCES `redeems` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_redeems_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_trades`
--
ALTER TABLE `users_trades`
  ADD CONSTRAINT `FK_users_trades_users` FOREIGN KEY (`FromUserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_trades_users_2` FOREIGN KEY (`ToUserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_trades_items`
--
ALTER TABLE `users_trades_items`
  ADD CONSTRAINT `FK_users_trades_items_enhancements` FOREIGN KEY (`EnhID`) REFERENCES `enhancements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_trades_items_items` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_trades_items_users` FOREIGN KEY (`FromUserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_users_trades_items_users_2` FOREIGN KEY (`ToUserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wheels`
--
ALTER TABLE `wheels`
  ADD CONSTRAINT `FK_wheels_items` FOREIGN KEY (`ItemID`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `[Quest] Monthly Reset` ON SCHEDULE EVERY 1 MONTH STARTS '2026-09-02 03:59:32' ON COMPLETION PRESERVE ENABLE DO UPDATE users SET MonthlyQuests0 = 0$$

CREATE DEFINER=`root`@`localhost` EVENT `[Quest] Daily Quest Reset` ON SCHEDULE EVERY 1 DAY STARTS '2026-09-02 03:59:32' ON COMPLETION PRESERVE ENABLE DO UPDATE users SET DailyQuests0 = 0, DailyQuests1 = 0, DailyQuests2 = 0, UpgradeDays=GREATEST(UpgradeDays-1,0)$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
