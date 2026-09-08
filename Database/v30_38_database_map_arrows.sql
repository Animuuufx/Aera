-- --------------------------------------------------------
--
-- Table structure for table `maps_arrows`
-- Database-driven room/map transition arrows.
--

CREATE TABLE IF NOT EXISTS `maps_arrows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `MapID` int(11) NOT NULL DEFAULT 0,
  `Frame` varchar(50) NOT NULL DEFAULT 'Enter',
  `X` double NOT NULL DEFAULT 0,
  `Y` double NOT NULL DEFAULT 0,
  `Direction` enum('Left','Right','Up','Down') NOT NULL DEFAULT 'Right',
  `TargetType` enum('Room','Map') NOT NULL DEFAULT 'Room',
  `TargetMapID` int(11) DEFAULT NULL,
  `TargetFrame` varchar(50) NOT NULL DEFAULT 'Enter',
  `TargetPad` varchar(50) NOT NULL DEFAULT 'Spawn',
  `Enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_maps_arrows_source` (`MapID`,`Frame`,`Enabled`),
  KEY `idx_maps_arrows_target_map` (`TargetMapID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
