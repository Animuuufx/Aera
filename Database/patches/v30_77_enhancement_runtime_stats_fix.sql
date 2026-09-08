-- Aera v30.77 Enhancement Runtime + Stat Binding Fix
-- MySQL 5.7 compatible. Safe to run repeatedly.
-- Fixes custom/legacy enhancement items that were created without the proper
-- target Equipment code or definition EnhID, including catalogs such as
-- "Weapon Enhancement 100" / item id 900100.

USE `aera`;
START TRANSACTION;

-- 1) Normalize enhancement target slots from the item name when Equipment is
-- blank/None. These are the client slot values used by the enhancement UI.
UPDATE `items`
SET `Equipment` = CASE
    WHEN LOWER(`Name`) LIKE '%weapon%' THEN 'Weapon'
    WHEN LOWER(`Name`) LIKE '%helm%' OR LOWER(`Name`) LIKE '%helmet%' THEN 'he'
    WHEN LOWER(`Name`) LIKE '%cape%' THEN 'ba'
    WHEN LOWER(`Name`) LIKE '%class%' THEN 'ar'
    WHEN LOWER(`Name`) LIKE '%armor%' OR LOWER(`Name`) LIKE '%armour%' THEN 'co'
    WHEN LOWER(`Name`) LIKE '%pet%' THEN 'pe'
    ELSE `Equipment`
END
WHERE LOWER(`Type`)='enhancement'
  AND (`Equipment` IS NULL OR TRIM(`Equipment`)='' OR LOWER(TRIM(`Equipment`))='none');

-- 2) Repair the link from enhancement item -> enhancement definition when the
-- item has no valid EnhID. Pattern family is inferred from its name; unnamed
-- families default to Adventurer (pattern 1).
UPDATE `items` i
JOIN `enhancements` e
  ON e.`Level`=i.`Level`
 AND e.`PatternID` = CASE
      WHEN LOWER(i.`Name`) LIKE '%lucky%' THEN 3
      WHEN LOWER(i.`Name`) LIKE '%fighter%' THEN 2
      ELSE 1
    END
SET i.`EnhID`=e.`id`
WHERE LOWER(i.`Type`)='enhancement'
  AND (
      i.`EnhID` IS NULL
      OR i.`EnhID`=0
      OR NOT EXISTS (SELECT 1 FROM `enhancements` ve WHERE ve.`id`=i.`EnhID`)
  );

-- 3) Repair legacy users_items rows that stored the enhancement definition id
-- instead of the enhancement item id. Keep already-canonical item ids intact.
UPDATE `users_items` ui
JOIN `items` target ON target.`id`=ui.`ItemID`
JOIN `enhancements` e ON e.`id`=ui.`EnhID`
JOIN `items` enh ON LOWER(enh.`Type`)='enhancement'
                 AND enh.`EnhID`=e.`id`
                 AND enh.`Equipment`=target.`Equipment`
SET ui.`EnhID`=enh.`id`
WHERE ui.`EnhID`>0
  AND LOWER(target.`Type`)<>'enhancement'
  AND target.`Equipment` IN ('Weapon','he','ba','ar','co','pe');

COMMIT;
