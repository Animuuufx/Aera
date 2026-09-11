<?php
declare(strict_types=1);
require dirname(__DIR__,2).'/Emulator/PHP/src/Autoload.php';
$root=dirname(__DIR__,2);$rows=json_decode(file_get_contents(__DIR__.'/broken_oath_manifest.json'),true,512,JSON_THROW_ON_ERROR);$n=0;
function ok(bool $v,string $msg):void {global $n;$n++;if(!$v)throw new RuntimeException($msg);}
$schema=file_get_contents($root.'/Database/aera.sql').file_get_contents($root.'/Database/v30_20_database_npcs.sql');
foreach($rows as $table=>$entries){
 preg_match('/CREATE TABLE (?:IF NOT EXISTS )?`'.preg_quote($table,'/').'` \((.*?)\) ENGINE/s',$schema,$m);ok(isset($m[1]),"Schema for $table");
 preg_match_all('/^\s*`([^`]+)`\s+(.+)$/m',$m[1],$cols,PREG_SET_ORDER);$defs=[];foreach($cols as $col)$defs[$col[1]]=$col[2];$ids=[];
 foreach($entries as $r){ok(!isset($ids[$r['id']]),"Duplicate $table id");$ids[$r['id']]=true;
 foreach($r as $col=>$v){ok(isset($defs[$col]),"Unknown $table.$col");if(preg_match('/(?:var)?char\((\d+)\)/',$defs[$col],$lim))ok(strlen((string)$v)<=(int)$lim[1],"Too long: $table.$col");}
 foreach($defs as $col=>$def)if(str_contains($def,'NOT NULL')&&!str_contains($def,'DEFAULT')&&!str_contains($def,'AUTO_INCREMENT'))ok(array_key_exists($col,$r),"Required $table.$col missing");
 }
}
$by=[];foreach($rows as $t=>$entries)foreach($entries as $r)$by[$t][$r['id']]=$r;
foreach(['maps_monsters'=>['MapID'=>'maps','MonsterID'=>'monsters'],'npcs_buttons'=>['NPCID'=>'npcs'],'shops_items'=>['ShopID'=>'shops','ItemID'=>'items'],'quests_requirements'=>['QuestID'=>'quests','ItemID'=>'items'],'quests_rewards'=>['QuestID'=>'quests','ItemID'=>'items'],'monsters_drops'=>['MonsterID'=>'monsters','ItemID'=>'items'],'skills_assign'=>['SkillID'=>'skills','ItemID'=>'items'],'classes'=>['ItemID'=>'items']] as $table=>$refs)foreach($rows[$table] as $r)foreach($refs as $col=>$target)ok(isset($by[$target][$r[$col]]),"Broken $table.$col reference");
foreach($rows['classes'] as $c){$refs=[];foreach($rows['skills_assign'] as $s)if($s['ItemID']===$c['ItemID'])$refs[]=$by['skills'][$s['SkillID']]['Reference'];sort($refs);ok($refs===['a1','a2','a3','a4','aa'],'Complete class hotbar');}
foreach($rows['quests'] as $i=>$q)ok($q['Slot']===90&&$q['Value']===$i+1&&$q['Once']===1,'Sequential one-time story');
$r=(new ReflectionClass(AeraEmu\ExtensionRouter::class))->newInstanceWithoutConstructor();$check=new ReflectionMethod($r,'betaStoryError');$update=new ReflectionMethod($r,'updateQuestValue');$u=new AeraEmu\ClientSession(null,1,'test');
for($step=1;$step<=6;$step++){$q=$by['quests'][810000+$step];$u->user['Quests']=str_repeat('0',90).($step-1);ok($check->invoke($r,$u,$q,1)==='','Expected story step accepted');ok($check->invoke($r,$u,$q,2)!=='','Bulk reward rejected');$u->user['Quests']=str_repeat('0',90).$step;ok($check->invoke($r,$u,$q,1)!=='','Replay rejected');if($step>1){$u->user['Quests']=str_repeat('0',91);ok($check->invoke($r,$u,$q,1)!=='','Skipping rejected');}}
$before=$u->user;$update->invoke($r,$u,[90,6]);ok($u->user===$before,'Client cannot write story slot');
echo "Broken Oath: $n content/schema/progression checks passed.\n";
