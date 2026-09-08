-- Aera v30.62 - Buffs / Auras / Combat correction
-- MySQL 5.7 compatible. Safe to run again: the core mappings/effects below are rebuilt deterministically.

START TRANSACTION;

-- These three abilities are true self buffs. They must not route through player/monster damage.
UPDATE `skills` SET `Damage`=0.00, `Target`='s' WHERE `Name`='Prepared Strike';
UPDATE `skills` SET `Damage`=0.00, `Target`='s' WHERE `Name`='On Guard';
UPDATE `skills` SET `Damage`=0.00, `Target`='s' WHERE `Name`='Fortune';

-- Core aura rows use auras_effects as the authoritative modifier source.
UPDATE `auras`
SET `DamageIncrease`=0.00, `DamageTakenDecrease`=0.00
WHERE `Name` IN ('Armor Shred','Precise Blow','Aggression','Resolute','On Guard','Fortune');

-- Prepared Strike was described by the skill but was never mapped to an aura in the shipped DB.
INSERT INTO `auras` (`Name`,`Duration`,`Category`,`Chance`,`DamageIncrease`,`DamageTakenDecrease`)
SELECT 'Prepared Strike',30,'none',1.00,0.00,0.00
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `auras` WHERE `Name`='Prepared Strike');

UPDATE `auras`
SET `Duration`=30, `Category`='none', `Chance`=1.00, `DamageIncrease`=0.00, `DamageTakenDecrease`=0.00
WHERE `Name`='Prepared Strike';

-- Rebuild the authoritative effects for the baseline class auras.
DELETE ae
FROM `auras_effects` ae
INNER JOIN `auras` a ON a.`id`=ae.`AuraID`
WHERE a.`Name` IN ('Armor Shred','Aggression','Resolute','On Guard','Fortune','Prepared Strike');

-- Armor Shred: target takes 10% more incoming damage.
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'cai',10.00,'+' FROM `auras` WHERE `Name`='Armor Shred' ORDER BY `id` LIMIT 1;

-- Aggression: +10% hit chance and +10% outgoing physical damage.
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'thi',10.00,'+' FROM `auras` WHERE `Name`='Aggression' ORDER BY `id` LIMIT 1;
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'cpo',10.00,'+' FROM `auras` WHERE `Name`='Aggression' ORDER BY `id` LIMIT 1;

-- Resolute: 10% all-damage resistance.
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'cai',10.00,'-' FROM `auras` WHERE `Name`='Resolute' ORDER BY `id` LIMIT 1;

-- On Guard: 50% all-damage resistance for five seconds.
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'cai',50.00,'-' FROM `auras` WHERE `Name`='On Guard' ORDER BY `id` LIMIT 1;

-- Fortune: +30% hit chance for ten seconds.
INSERT INTO `auras_effects` (`AuraID`,`Stat`,`Value`,`Type`)
SELECT `id`,'thi',30.00,'+' FROM `auras` WHERE `Name`='Fortune' ORDER BY `id` LIMIT 1;

-- Rebuild the baseline skill -> aura links, including Prepared Strike.
DELETE sa
FROM `skills_auras` sa
INNER JOIN `skills` s ON s.`id`=sa.`SkillID`
WHERE s.`Name` IN ('Decisive Strike','Imbalancing Strike','Prepared Strike','Aggression','Resolute','On Guard','Fortune');

INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='Decisive Strike' AND a.`Name`='Armor Shred' ORDER BY s.`id`,a.`id` LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='Imbalancing Strike' AND a.`Name`='Precise Blow' ORDER BY s.`id`,a.`id` LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='Prepared Strike' AND a.`Name`='Prepared Strike' ORDER BY s.`id`,a.`id` LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='Aggression' AND a.`Name`='Aggression' ORDER BY s.`id`,a.`id` LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='Resolute' AND a.`Name`='Resolute' ORDER BY s.`id`,a.`id` LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='On Guard' AND a.`Name`='On Guard' ORDER BY s.`id`,a.`id` LIMIT 1;
INSERT INTO `skills_auras` (`SkillID`,`AuraID`)
SELECT s.`id`,a.`id` FROM `skills` s CROSS JOIN `auras` a WHERE s.`Name`='Fortune' AND a.`Name`='Fortune' ORDER BY s.`id`,a.`id` LIMIT 1;

COMMIT;
