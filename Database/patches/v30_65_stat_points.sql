-- Aera v30.65 - persistent stat point allocation system
-- 3 points are earned for every level above level 1.
-- Existing players are backfilled from their current level.

CREATE TABLE IF NOT EXISTS `users_stats` (
  `UserID` int(11) UNSIGNED NOT NULL,
  `Points` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Strength` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Intellect` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Dexterity` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Endurance` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Wisdom` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Luck` int(11) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`UserID`),
  CONSTRAINT `FK_users_stats_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO `users_stats` (`UserID`,`Points`,`Strength`,`Intellect`,`Dexterity`,`Endurance`,`Wisdom`,`Luck`)
SELECT `id`, GREATEST((CAST(`Level` AS SIGNED) - 1) * 3, 0), 0, 0, 0, 0, 0, 0
FROM `users`
ON DUPLICATE KEY UPDATE `UserID`=VALUES(`UserID`);
