<?php
declare(strict_types=1);
require __DIR__.'/swf_info.php';
$root=dirname(__DIR__,2);$assets=$root.'/web/public/gamefiles/';$rows=[];$checks=0;
function add(string $table,array $row):void {global $rows;$rows[$table][]=$row;}
function asset(string $file,string $link='',array $frames=[]):void {global $assets,$checks;$info=swfInfo($assets.$file);foreach($frames as $frame)if(!in_array($frame,$info['labels'],true))throw new RuntimeException("Missing frame $frame in $file");if($link!==''&&!in_array($link,$info['symbols'],true))throw new RuntimeException("Missing linkage $link in $file");$checks++;}
$areas=[
 ['briarwatch','fawnforest.swf',['Enter','Area2','Area3','Area4'],'Briarwatch','Scout Elowen','Briar Scout','The forest roots are freezing from within. Recover tainted sap, then break the rootwarden holding the northern road.','ForestKin2.swf','ForestKinBase'],
 ['winterpass','frostgale.swf',['Enter','Area2','Area3','Boss'],'Winterpass','Ranger Soren','Pass Keeper','The cold is being drawn toward the old ruins. Free the pass from its hollow sentries and defeat the queen bound to the signal.','ArcticRanger.swf','ArcticRanger'],
 ['oathruins','~Lostruinsbenzaj.swf',['Enter','Field1','Field2','End'],'Oath Ruins','Warden Ilyra','Oath Archivist','A lich has inverted the old ward. Silence its stone sentinels, reclaim the keystone, and restore the oath that protected these lands.','AsgardianKnight.swf','AsgardianKnight']
];
$weapons=[['Briarbound Runeblade','BasicRuneSwordDage.swf','BasicRuneSwordDage'],['Winterpass Reaver','CCFrostReaver.swf','CCFrostReaver'],['Oathkeeper Blade','AngelicRunedBroadsword1.swf','AngelicRunedBroadsword1']];
$pets=[['Briar Wolf Companion','DireWolf.swf','DireWolf'],['Snowtrail Companion','DireWolfwht.swf','Direwolfwht'],['Runeward Familiar','Arcanewolf.swf','Arcanewolf']];
$enemies=[['Blighted Dire Wolf','WolfDire.swf','WolfDire',3,550,14],['Frozen Rootwarden','Treeant.swf','Treeant',5,1900,23],['Hollow Frost Wisp','Shade1.swf','Shade1',6,950,24],['Bound Winter Queen','FrostQueenBhtNoth.swf','FrostQueenBhtNoth',8,3300,36],['Oathstone Sentinel','StoneGolem1.swf','StoneGolem1',9,1450,35],['Lich of the Broken Oath','Undeadlich.swf','UndeadLich1',11,5200,48]];
$quests=[
 ['Sap Beneath the Frost','Defeat 4 Blighted Dire Wolves on the Briarwatch trails and collect their tainted sap. The wolves have been feeding on frozen roots.','This sap carries the old ward mark. The rootwarden has been turned into a conduit.','Tainted Sap',4],
 ['Break the Rootbound Seal','Defeat the Frozen Rootwarden at the end of Briarwatch and bring back its frostbound heart.','The road is open. My travel button leads to Winterpass; Ranger Soren will follow the ward signal with you.','Frostbound Heart',1],
 ['Voices in the Snow','Collect 4 Hollow Echoes from Hollow Frost Wisps in Winterpass. Each carries part of the signal controlling the queen.','These are stolen memories, not winter spirits. The queen is another prisoner of the ward.','Hollow Echo',4],
 ['Release the Winter Queen','Defeat the Bound Winter Queen at the summit and recover the northern ward fragment.','The queen is free. Take the road to Oath Ruins and find Warden Ilyra. She knows who broke the ward.','Northern Ward Fragment',1],
 ['The Oath Remembers','Recover 4 Oathstone Fragments from Oathstone Sentinels in the ruins. We must rebuild the seal before confronting the lich.','The inscription names the thief: a lich feeding on the forest and the pass. Its stolen keystone is the final piece.','Oathstone Fragment',4],
 ['A Promise Restored','Defeat the Lich of the Broken Oath in the final chamber and recover the stolen keystone.','The keystone is restored. Spring can return to Briarwatch, and the pass is safe. You have earned the Oath Warden discipline. Return to Briarwatch through my travel button.','Stolen Keystone',1]
];
function item(int $id,string $name,string $type,string $file,string $link,int $cost,int $level=1):array {
 return ['id'=>$id,'Name'=>$name,'Description'=>'Relic of the Broken Oath beta chapter. '.$name.'.','Type'=>$type,'File'=>$file,'Link'=>$link,'Icon'=>match($type){'Sword'=>'iwsword','Pet'=>'iipet','Class'=>'iiclass','Armor'=>'iwarmor',default=>'iibag'},'Equipment'=>match($type){'Sword'=>'Weapon','Pet'=>'pe','Class'=>'ar','Armor'=>'co',default=>'None'},'Level'=>$level,'DPS'=>100,'Range'=>50,'Rarity'=>10,'Quantity'=>1,'Stack'=>1,'Cost'=>$cost,'Coins'=>0,'Sell'=>1,'Temporary'=>0,'Upgrade'=>0,'Staff'=>0,'EnhID'=>1,'Trade'=>0,'Market'=>0];
}
$placement=810000;$button=810000;
foreach($areas as $i=>$a){
 [$name,$file,$frames,$title,$npcName,$job,$dialog,$armorFile,$armorLink]=$a;$mapId=810001+$i;$npcId=810001+$i;$base=810001+$i*10;
 asset('maps/'.$file,'',$frames);
 foreach(['M','F'] as $gender)asset('classes/'.$gender.'/'.$armorFile,$armorLink.$gender.'Chest');
 add('maps',['id'=>$mapId,'Name'=>$name,'File'=>$file,'MaxPlayers'=>12,'ReqLevel'=>1,'ReqParty'=>0,'Upgrade'=>0,'Staff'=>0,'PvP'=>0]);
 add('items',item($base,$title.' Garb','Armor',$armorFile,$armorLink,700+$i*700));
 [$wn,$wf,$wl]=$weapons[$i];asset('items/swords/'.$wf,$wl);add('items',item($base+1,$wn,'Sword','items/swords/'.$wf,$wl,400+$i*500));
 [$pn,$pf,$pl]=$pets[$i];asset('items/pets/'.$pf,$pl);add('items',item($base+2,$pn,'Pet','items/pets/'.$pf,$pl,900+$i*800));
 add('shops',['id'=>$mapId,'Name'=>$title.' Supplies','House'=>0,'Upgrade'=>0,'Staff'=>0,'Limited'=>0,'Field'=>'']);
 foreach([$base,$base+1,$base+2] as $iid)add('shops_items',['id'=>$iid,'ShopID'=>$mapId,'ItemID'=>$iid,'QuantityRemain'=>0]);
 add('npcs',['id'=>$npcId,'Name'=>$npcName,'Gender'=>$i===1?'M':'F','Job'=>$job,'Slogan'=>$dialog,'Level'=>10,'Health'=>1000,'Mana'=>100,'DPS'=>0,'ColorHair'=>'0x483329','ColorSkin'=>'0xD6AD8D','ColorEye'=>'0x68B6C7','ColorBase'=>'0x374F46','ColorTrim'=>'0xB6A276','ColorAccessory'=>'0x688C99','WeaponID'=>$base+1,'ArmorID'=>$base]);
 foreach($frames as $j=>$frame){
  add('maps_npc',['id'=>++$placement,'MapID'=>$mapId,'NpcID'=>$npcId,'NpcMapID'=>1,'Frame'=>$frame,'X'=>180,'Y'=>385,'Turn'=>'Right']);
  // Unique NPC instance IDs across the map are required by the payload cache.
  $rows['maps_npc'][count($rows['maps_npc'])-1]['NpcMapID']=$j+1;
  if($j===0)continue;
  $boss=$j===count($frames)-1;$monsterId=810001+$i*2+($boss?1:0);
  foreach($boss?[620]:[470,710] as $x)add('maps_monsters',['id'=>++$placement,'MapID'=>$mapId,'MonsterID'=>$monsterId,'MonMapID'=>$placement,'Frame'=>$frame,'X'=>$x,'Y'=>405,'Aggresive'=>0,'Enabled'=>1]);
 }
 $buttons=[['quests','The Broken Oath',(string)(810001+$i*2).','.(810002+$i*2)],['shop',$title.' Supplies',(string)$mapId]];
 foreach(array_slice($frames,1) as $j=>$frame)$buttons[]=['join',$j===2?'Confront the area boss':'Explore trail '.($j+1),$name.'|'.$frame.'|Spawn'];
 $buttons[]=['join','Return to camp',$name.'|Enter|Spawn'];
 $buttons[]=['join',$i<2?'Continue to '.$areas[$i+1][3]:'Return to Briarwatch',$areas[($i+1)%3][0].'|Enter|Spawn'];
 if($i>0)$buttons[]=['join','Return to '.$areas[$i-1][3],$areas[$i-1][0].'|Enter|Spawn'];
 $buttons[]=['join','Return to Newbie','newbie|Enter|Spawn'];
 foreach($buttons as [$action,$label,$value])add('npcs_buttons',['id'=>++$button,'NPCID'=>$npcId,'Action'=>$action,'Text'=>$label,'Value'=>$value,'Icon'=>'']);
}
foreach($enemies as $i=>[$name,$file,$link,$level,$hp,$dps]){
 asset('mon/'.$file,$link);$id=810001+$i;
 add('monsters',['id'=>$id,'Name'=>$name,'File'=>$file,'Linkage'=>$link,'Level'=>$level,'Health'=>$hp,'Mana'=>100,'Gold'=>30+$i*15,'Coin'=>0,'Experience'=>80+$i*35,'ClassPoint'=>5,'Reputation'=>5,'DamageReduction'=>0,'DPS'=>$dps,'Respawn'=>8,'Speed'=>2200,'Immune'=>0]);
 [$qn,$desc,$end,$token,$qty]=$quests[$i];$iid=810101+$i;
 $it=item($iid,$token,'Item','','',0);$it['Temporary']=1;$it['Stack']=10;$it['Sell']=0;add('items',$it);
 add('monsters_drops',['id'=>$id,'MonsterID'=>$id,'ItemID'=>$iid,'Chance'=>1,'Quantity'=>1]);
 add('quests',['id'=>$id,'FactionID'=>1,'Name'=>$qn,'Description'=>$desc,'EndText'=>$end,'Experience'=>500+$i*300,'Gold'=>400+$i*250,'Coins'=>0,'ClassPoints'=>100,'RewardType'=>'S','Level'=>1,'Upgrade'=>0,'Once'=>1,'Slot'=>90,'Value'=>$i+1,'Field'=>'','Index'=>-1]);
 add('quests_requirements',['id'=>$id,'QuestID'=>$id,'ItemID'=>$iid,'Quantity'=>$qty]);
}
// Two starter-friendly physical disciplines with separate active skill sets.
foreach([[810051,'Winterpass Ranger','ArcticRanger.swf','ArcticRanger',808,['Trail Shot','Piercing Frost','Twin Volley','Winter Salvo','Summit Shot']],[810052,'Oath Warden','AsgardianKnight.swf','AsgardianKnight',303,['Oath Strike','Runeblade Cut','Sealbreaker','Warden Sweep','Keystone Verdict']]] as $c){
 [$id,$name,$file,$link,$range,$names]=$c;add('items',item($id,$name,'Class',$file,$link,0));
 add('classes',['id'=>$id,'ItemID'=>$id,'Category'=>'M1','Description'=>$name.' uses physical attacks to reclaim the Broken Oath lands.','ManaRegenerationMethods'=>'Gain mana by striking enemies and taking hits.','StatsDescription'=>'Strength improves damage; Endurance improves survival.']);
 foreach($names as $j=>$skillName){$sid=$id+($j*10);add('skills',['id'=>$sid,'Name'=>$skillName,'Animation'=>$j===0?'Attack1,Attack2':'Attack3','Description'=>$j===0?'A basic weapon attack.':($j===3?'Strike up to two enemies.':'Deal physical weapon damage to one enemy.'),'Damage'=>[0.5,1.0,1.3,0.8,2.2][$j],'Mana'=>[0,10,18,24,30][$j],'Icon'=>'iwsword','Range'=>$range,'Dsrc'=>'','Reference'=>$j===0?'aa':'a'.$j,'Target'=>'h','Effects'=>'m','Type'=>'p','Strl'=>'','Cooldown'=>[1500,3000,6000,9000,14000][$j],'HitTargets'=>$j===3?2:1]);add('skills_assign',['id'=>$sid,'SkillID'=>$sid,'ItemID'=>$id]);}
 add('quests_rewards',['id'=>$id,'QuestID'=>$id===810051?810004:810006,'ItemID'=>$id,'Quantity'=>1,'Rate'=>1,'RewardType'=>'S']);
}
// A guide at the existing beginner map makes the chapter discoverable.
// Resolve its MapID by name at import time; never overwrite existing NPCs.
$rows['maps_npc'][]=['id'=>810099,'MapID'=>'@entryMap','NpcID'=>810001,'NpcMapID'=>810099,'Frame'=>'Enter','X'=>240,'Y'=>400,'Turn'=>'Right'];
add('npcs_buttons',['id'=>810099,'NPCID'=>810001,'Action'=>'join','Text'=>'Begin: Briarwatch','Value'=>'briarwatch|Enter|Spawn','Icon'=>'']);
function val(mixed $v):string {if($v==='@entryMap')return $v;if(is_int($v)||is_float($v))return (string)$v;return "'".str_replace("'","''",(string)$v)."'";}
// Parent records must precede their foreign-key dependants on a live MySQL schema.
$ordered=[];
foreach(['maps','items','monsters','shops','npcs','quests','classes','skills','maps_npc','maps_monsters','npcs_buttons','shops_items','monsters_drops','quests_requirements','skills_assign','quests_rewards'] as $table)$ordered[$table]=$rows[$table];
$rows=$ordered;
$sql="-- The Broken Oath: compact beta chapter. Generated by tools/content/build_beta.php.\n-- Requires current schema through v30_80. Back up the VPS database before import.\n-- Uses existing SWFs only. Quest progress slot 90 is reserved for this pack.\nCREATE TABLE IF NOT EXISTS aera_content_packs (Name varchar(64) PRIMARY KEY, InstalledAt timestamp DEFAULT CURRENT_TIMESTAMP);\nDELIMITER $$\nDROP PROCEDURE IF EXISTS install_broken_oath$$\nCREATE PROCEDURE install_broken_oath()\nBEGIN\n DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;\n SET @entryMap=(SELECT id FROM maps WHERE Name='newbie' LIMIT 1);\n IF @entryMap IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Missing newbie entry map'; END IF;\n IF NOT EXISTS (SELECT 1 FROM aera_content_packs WHERE Name='broken-oath-beta') THEN\n";
foreach(array_keys($rows) as $table)$sql.=" IF EXISTS (SELECT 1 FROM `$table` WHERE id BETWEEN 810000 AND 810199) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Reserved content IDs occupied in $table'; END IF;\n";
$sql.=" IF EXISTS (SELECT 1 FROM quests WHERE Slot=90) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quest slot 90 already used'; END IF;\n END IF;\n START TRANSACTION;\n";
foreach($rows as $table=>$entries)foreach($entries as $r){$cols=array_keys($r);$sql.=' INSERT INTO `'.$table.'` (`'.implode('`,`',$cols).'`) VALUES ('.implode(',',array_map('val',array_values($r))).') ON DUPLICATE KEY UPDATE '.implode(',',array_map(fn($k)=>"`$k`=VALUES(`$k`)",array_filter($cols,fn($k)=>$k!=='id'))).";\n";}
$sql.=" INSERT IGNORE INTO aera_content_packs(Name) VALUES ('broken-oath-beta');\n COMMIT;\nEND$$\nCALL install_broken_oath()$$\nDROP PROCEDURE install_broken_oath$$\nDELIMITER ;\n";
file_put_contents($root.'/Database/patches/v30_81_broken_oath_beta.sql',$sql);
file_put_contents(__DIR__.'/broken_oath_manifest.json',json_encode($rows,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES)."\n");
echo "Validated $checks SWF assets/variants. Generated ".array_sum(array_map('count',$rows))." content rows.\n";
