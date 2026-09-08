-- Aera v30.20 - Database-driven NPCs
-- Safe to run against an existing Aera database.

CREATE TABLE IF NOT EXISTS `npcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `Gender` varchar(50) DEFAULT 'M',
  `Job` varchar(255) DEFAULT NULL,
  `Slogan` varchar(1000) DEFAULT NULL,
  `Level` int(11) DEFAULT 1,
  `Health` int(11) DEFAULT 0,
  `Mana` int(11) DEFAULT 0,
  `DPS` int(11) DEFAULT 0,
  `ColorHair` varchar(50) DEFAULT NULL,
  `ColorSkin` varchar(50) DEFAULT NULL,
  `ColorEye` varchar(50) DEFAULT NULL,
  `ColorBase` varchar(50) DEFAULT NULL,
  `ColorTrim` varchar(50) DEFAULT NULL,
  `ColorAccessory` varchar(50) DEFAULT NULL,
  `WeaponID` int(11) DEFAULT NULL,
  `ArmorID` int(11) DEFAULT NULL,
  `HelmID` int(11) DEFAULT NULL,
  `CapeID` int(11) DEFAULT NULL,
  `GroundID` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `npcs_buttons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NPCID` int(11) DEFAULT 0,
  `Action` varchar(255) DEFAULT NULL,
  `Text` varchar(255) DEFAULT NULL,
  `Value` varchar(255) DEFAULT NULL,
  `Icon` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_npcs_buttons_npcid` (`NPCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `maps_npc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `MapID` int(11) DEFAULT 0,
  `NpcID` int(11) DEFAULT 0,
  `NpcMapID` int(11) DEFAULT 0,
  `Frame` varchar(50) DEFAULT NULL,
  `X` double DEFAULT NULL,
  `Y` double DEFAULT NULL,
  `Turn` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_maps_npc_map_instance` (`MapID`,`NpcMapID`),
  KEY `idx_maps_npc_npcid` (`NpcID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
