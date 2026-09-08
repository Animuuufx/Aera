-- Aera v30.63 - self/friendly buff routing + aura acknowledgement hardening
-- MySQL 5.7 compatible. Safe to re-run.

START TRANSACTION;

-- These baseline abilities are buffs, never attacks.
UPDATE `skills` SET `Damage`=0.00, `Target`='s' WHERE `Name` IN ('Prepared Strike','On Guard','Fortune');

-- Prepared Strike needs a real aura row in older Aera databases.
INSERT INTO `auras` (`Name`,`Duration`,`Category`,`Chance`,`DamageIncrease`,`DamageTakenDecrease`)
SELECT 'Prepared Strike',30,'none',1.00,0.00,0.00
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `auras` WHERE `Name`='Prepared Strike');
UPDATE `auras` SET `Duration`=30,`Category`='none',`Chance`=1.00 WHERE `Name`='Prepared Strike';

-- Guarantee the core skill->aura mappings without creating duplicates.
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s JOIN `auras` a ON a.`Name`='Prepared Strike'
WHERE s.`Name`='Prepared Strike'
  AND NOT EXISTS (SELECT 1 FROM `skills_auras` x WHERE x.`SkillID`=s.`id` AND x.`AuraID`=a.`id`)
LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s JOIN `auras` a ON a.`Name`='On Guard'
WHERE s.`Name`='On Guard'
  AND NOT EXISTS (SELECT 1 FROM `skills_auras` x WHERE x.`SkillID`=s.`id` AND x.`AuraID`=a.`id`)
LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s JOIN `auras` a ON a.`Name`='Fortune'
WHERE s.`Name`='Fortune'
  AND NOT EXISTS (SELECT 1 FROM `skills_auras` x WHERE x.`SkillID`=s.`id` AND x.`AuraID`=a.`id`)
LIMIT 1;

-- Reassert the intended baseline effects. This is deliberately deterministic so
-- an older broken Aera row cannot leave the skill visually active but inert.
DELETE ae FROM `auras_effects` ae JOIN `auras` a ON a.`id`=ae.`AuraID`
WHERE a.`Name` IN ('On Guard','Fortune');
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'cai',50.00,'-' FROM `auras` WHERE `Name`='On Guard' ORDER BY `id` LIMIT 1;
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'thi',30.00,'+' FROM `auras` WHERE `Name`='Fortune' ORDER BY `id` LIMIT 1;

COMMIT;
