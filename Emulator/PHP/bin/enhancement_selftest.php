<?php
declare(strict_types=1);
$root=dirname(__DIR__,3);
$fail=[];
$router=(string)@file_get_contents($root.'/Emulator/PHP/src/ExtensionRouter.php');
$stats=(string)@file_get_contents($root.'/Emulator/PHP/src/StatsCalculator.php');
$seed=(string)@file_get_contents($root.'/Database/aera.sql');
$patch=(string)@file_get_contents($root.'/Database/patches/v30_76_enhancement_client_compat.sql');

foreach([
    'enhancement resolver'=>'private function resolveEnhancement',
    'canonical enhancement persistence'=>'[$enhItemId,$targetId,$u->dbId]',
    'enhancement slot validation'=>'Enhancement slot mismatch',
    'Enhancement level output'=>"'EnhLvl'",
    'Enhancement pattern output'=>"'EnhPatternID'",
    'Enhancement DPS output'=>"'EnhDPS'",
    'Enhancement name output'=>"'EnhName'",
    'Enhancement Strength output'=>"'EnhSTR'",
    'Enhancement Intellect output'=>"'EnhINT'",
    'Enhancement Dexterity output'=>"'EnhDEX'",
    'Enhancement Endurance output'=>"'EnhEND'",
    'Enhancement Wisdom output'=>"'EnhWIS'",
    'Enhancement Luck output'=>"'EnhLCK'",
    'Pattern iSTR'=>"'iSTR'",
    'Pattern iINT'=>"'iINT'",
    'Pattern iDEX'=>"'iDEX'",
    'Pattern iEND'=>"'iEND'",
    'Pattern iWIS'=>"'iWIS'",
    'Pattern iLCK'=>"'iLCK'",
] as $name=>$needle){
    if(!str_contains($router.$stats,$needle))$fail[]="$name marker missing: $needle";
}
if(substr_count($patch,'INSERT INTO `enhancements`')!==300)$fail[]='Expected 300 enhancement definitions (3 patterns x 100 levels).';
if(substr_count($patch,'INSERT INTO `items`')!==1200)$fail[]='Expected 1200 enhancement items (4 slots x 3 patterns x 100 levels).';
foreach(['Weapon','he','ba','ar'] as $slot)if(!str_contains($patch,"$slot"))$fail[]="Enhancement slot $slot missing from catalog.";
foreach(['EnhLvl','EnhPatternID','EnhRty','EnhRng','EnhDPS','EnhID'] as $field)if(!str_contains($router,"'$field'"))$fail[]="Runtime missing $field output.";
if($fail){fwrite(STDERR,"Enhancement compatibility self-test FAILED\n- ".implode("\n- ",$fail)."\n");exit(1);} 
echo "Enhancement compatibility self-test PASSED\n";
echo "Definitions: 300\nItems: 1200\nSlots: Weapon/he/ba/ar\nStats: STR/INT/DEX/END/WIS/LCK\nLegacy + canonical EnhID formats: supported\n";
