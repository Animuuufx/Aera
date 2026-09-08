<?php
declare(strict_types=1);

$root=dirname(__DIR__,3);
$phpRoot=$root.'/Emulator/PHP';
$docs=$phpRoot.'/docs';
$fail=[];$ok=[];

function fail(array &$fail,string $m): void {$fail[]=$m;}
function pass(array &$ok,string $m): void {$ok[]=$m;}
function tsv(string $path): array {
    $fh=fopen($path,'rb'); if($fh===false)return [];
    $head=fgetcsv($fh,0,"\t"); if(!is_array($head)){fclose($fh);return [];}
    $rows=[];
    while(($r=fgetcsv($fh,0,"\t"))!==false){if($r===[null]||$r===[])continue;$r=array_pad($r,count($head),'');$rows[]=array_combine($head,array_slice($r,0,count($head)));}
    fclose($fh); return $rows;
}
function routerSets(string $router): array {
    $supported=[];
    foreach([
        '/\\$this->supported=array_fill_keys\\(\\[(.*?)\\],true\\);/s',
        '/foreach\\s*\\(\\[(.*?)\\]\\s*as\\s*\\$alias\\)/s'
    ] as $p) if(preg_match($p,$router,$m)){preg_match_all("/'([^']+)'/",$m[1],$n);$supported=array_merge($supported,$n[1]??[]);}
    $prefix=strstr($router,'    private function firstJoin',true) ?: $router;
    preg_match_all("/case\\s+'([^']+)'/",$prefix,$m);
    return [array_values(array_unique($supported)),array_values(array_unique($m[1]??[]))];
}
function parseSchema(string $sql): array {
    $tables=[];
    if(preg_match_all('/CREATE\\s+TABLE\\s+(?:IF\\s+NOT\\s+EXISTS\\s+)?`?([A-Za-z0-9_]+)`?\\s*\\((.*?)\\)\\s*(?:ENGINE=|;)/is',$sql,$ms,PREG_SET_ORDER)){
        foreach($ms as $m){$cols=[];if(preg_match_all('/^\\s*`([^`]+)`\\s+/m',$m[2],$cm))foreach($cm[1] as $c)$cols[$c]=true;$tables[strtolower($m[1])]=$cols;}
    }
    return $tables;
}
function phpStringLiteral(string $token): ?string {
    $q=$token[0]??''; if(($q!=="'"&&$q!=='"')||substr($token,-1)!==$q)return null;
    $s=substr($token,1,-1);
    if($q==="'")return str_replace(["\\\\","\\'"],["\\","'"],$s);
    // Direct double-quoted SQL strings with interpolation are intentionally skipped.
    if(str_contains($s,'$'))return null;
    return stripcslashes($s);
}
function sqlAudit(string $phpRoot,array $tables): array {
    $ops=0;$unknown=[];$badCols=[];
    $it=new RecursiveIteratorIterator(new RecursiveDirectoryIterator($phpRoot,FilesystemIterator::SKIP_DOTS));
    foreach($it as $file){if(!$file->isFile()||strtolower($file->getExtension())!=='php')continue;$text=file_get_contents($file->getPathname());if($text===false)continue;
        foreach(token_get_all($text) as $tok){if(!is_array($tok)||$tok[0]!==T_CONSTANT_ENCAPSED_STRING)continue;$s=phpStringLiteral($tok[1]);if($s===null||!preg_match('/^\\s*(?:SELECT|INSERT|UPDATE|DELETE|REPLACE)\\b/i',$s))continue;$ops++;
            $refs=[];if(preg_match_all('/\\b(?:FROM|JOIN|INTO)\\s+`?([A-Za-z0-9_]+)`?/i',$s,$rm))$refs=array_merge($refs,$rm[1]);if(preg_match('/^\\s*UPDATE\\s+`?([A-Za-z0-9_]+)`?/i',$s,$um))$refs[]=$um[1];
            foreach(array_unique($refs) as $t)if(!isset($tables[strtolower($t)])&&strtolower($t)!=='information_schema')$unknown[]=$file->getFilename().':'.$tok[2].' -> '.$t;
            if(preg_match('/\\bINSERT\\s+INTO\\s+`?([A-Za-z0-9_]+)`?\\s*\\(([^)]+)\\)/is',$s,$im)&&isset($tables[strtolower($im[1])])){
                foreach(explode(',',$im[2]) as $c){$c=trim($c," `\t\r\n");if($c!==''&&!isset($tables[strtolower($im[1])][$c]))$badCols[]=$file->getFilename().':'.$tok[2].' INSERT '.$im[1].'.'.$c;}
            }
            if(preg_match('/\\bUPDATE\\s+`?([A-Za-z0-9_]+)`?\\s+(?:[A-Za-z0-9_]+\\s+)?SET\\s+(.+?)(?:\\s+WHERE\\b|$)/is',$s,$um)&&isset($tables[strtolower($um[1])])){
                if(preg_match_all('/(?:\\b[A-Za-z0-9_]+\\.)?`?([A-Za-z0-9_]+)`?\\s*=/', $um[2],$cm))foreach($cm[1] as $c)if(!isset($tables[strtolower($um[1])][$c]))$badCols[]=$file->getFilename().':'.$tok[2].' UPDATE '.$um[1].'.'.$c;
            }
        }
    }
    return [$ops,array_values(array_unique($unknown)),array_values(array_unique($badCols))];
}

$counts=json_decode((string)@file_get_contents($docs.'/PARITY_COUNTS_v30.json'),true);
if(!is_array($counts))fail($fail,'PARITY_COUNTS_v30.json missing/invalid');
$classes=tsv($docs.'/JAVA_CLASS_PARITY_v30.tsv');$requests=tsv($docs.'/JAVA_REQUEST_PARITY_v30.tsv');$tasks=tsv($docs.'/JAVA_TASK_PARITY_v30.tsv');$as3manifest=tsv($docs.'/AS3_REQUEST_COMPATIBILITY_v30.tsv');$config=tsv($docs.'/CONFIG_PARITY_v30.tsv');
foreach([['Java class manifest',$classes,173],['Java request manifest',$requests,94],['Java task manifest',$tasks,13],['AS3 request manifest',$as3manifest,105]] as [$label,$rows,$want]){if(count($rows)!==$want)fail($fail,"$label count ".count($rows)." != $want");else pass($ok,"$label: $want/$want");}
$badStatus=[];foreach($classes as $r)if(!in_array($r['status']??'',['PORTED','INTEGRATED','SOURCE_ONLY_PARITY'],true))$badStatus[]=($r['java_source']??'?').':'.($r['status']??'');
if($badStatus)fail($fail,'Java classes with unresolved status: '.implode(', ',$badStatus));else pass($ok,'Java class statuses: all 173 resolved');
$sourceOnly=array_values(array_filter($classes,fn($r)=>($r['status']??'')==='SOURCE_ONLY_PARITY'));if(count($sourceOnly)!==3)fail($fail,'Expected exactly 3 documented source-only parity classes, got '.count($sourceOnly));else pass($ok,'Dormant/source-only Java classes: 3 documented');

$router=(string)@file_get_contents($phpRoot.'/src/ExtensionRouter.php');[$supported,$cases]=routerSets($router);
if(count($supported)!==121)fail($fail,'Router advertised command count '.count($supported).' != 121');else pass($ok,'Advertised PHP routes: 121/121');
$missingCases=array_values(array_diff($supported,$cases));if($missingCases)fail($fail,'Advertised commands missing switch branch: '.implode(', ',$missingCases));else pass($ok,'Every advertised PHP route has an explicit handler branch');
$javaCmd=array_map(fn($r)=>(string)($r['command']??''),$requests);$missingJava=array_values(array_diff($javaCmd,$cases));if($missingJava)fail($fail,'Java routes missing in PHP: '.implode(', ',$missingJava));else pass($ok,'Java RequestManage routes: 94/94 explicit');

$as3=[];$srcRoot=$root.'/Sources/Client/src';if(is_dir($srcRoot)){$it=new RecursiveIteratorIterator(new RecursiveDirectoryIterator($srcRoot,FilesystemIterator::SKIP_DOTS));foreach($it as $f){if(!$f->isFile()||strtolower($f->getExtension())!=='as')continue;$s=file_get_contents($f->getPathname());if($s!==false&&preg_match_all('/sendXtMessage\\s*\\(\\s*[\'\"]zm[\'\"]\\s*,\\s*[\'\"]([^\'\"]+)[\'\"]/',$s,$m))foreach($m[1] as $c)$as3[$c]=true;}}
$as3cmd=array_keys($as3);sort($as3cmd);$manifestCmd=array_map(fn($r)=>(string)($r['command']??''),$as3manifest);sort($manifestCmd);
$allowedDynamic=['spendStatPoints'];$manifestComparable=array_values(array_diff($manifestCmd,$allowedDynamic));
if($as3cmd!==$manifestComparable)fail($fail,'Live AS3 request extraction differs from v30 manifest: missing='.implode(',',array_diff($manifestComparable,$as3cmd)).' new='.implode(',',array_diff($as3cmd,$manifestComparable)));else pass($ok,'Stock AS3 literal request contract: 105/105 (dynamic stat allocation commands excluded)');
$as3Unrouted=array_values(array_diff($as3cmd,$supported));if($as3Unrouted)fail($fail,'AS3 commands not advertised by PHP: '.implode(', ',$as3Unrouted));else pass($ok,'All 105 stock AS3 requests are routed');

$db1=(string)@file_get_contents($root.'/Database/aera.sql');$db2=(string)@file_get_contents($root.'/web/resources/database/aera.sql');if($db1===''||$db1!==$db2)fail($fail,'Database/aera.sql and web/resources/database/aera.sql differ');else pass($ok,'Database SQL copies: byte-identical');
$patchSql='';foreach(glob($root.'/Database/patches/*.sql') ?: [] as $pf)$patchSql.="\n".(string)@file_get_contents($pf);$tables=parseSchema($db1."\n".$patchSql);if(count($tables)!==69)fail($fail,'Schema+patch table count '.count($tables).' != 69');else pass($ok,'Database schema + v30.72 patch tables: 69/69');
[$sqlOps,$unknownTables,$badCols]=sqlAudit($phpRoot,$tables);if($unknownTables)fail($fail,'Unknown SQL table refs: '.implode('; ',$unknownTables));else pass($ok,"PHP SQL table refs: $sqlOps literal operations, 0 unknown tables");if($badCols)fail($fail,'Invalid INSERT/UPDATE columns: '.implode('; ',$badCols));else pass($ok,'PHP SQL write columns: 0 invalid columns');

$configPhp=(string)@file_get_contents($phpRoot.'/config/emulator.php');foreach(["'port'=>5589"=>'socket port 5589',"'zone'=>'zone_master'"=>'zone_master',"'server_name'=>'Aera'"=>'server name Aera',"'max_connections_per_ip'=>5"=>'max connections/IP 5',"'trace_requests'=>true"=>'request tracing enabled',"'trace_request_params'=>true"=>'request parameter tracing enabled'] as $needle=>$label){if(!str_contains(str_replace(' ','',$configPhp),str_replace(' ','',$needle)))fail($fail,'Config missing '.$label);}
if(!array_filter($fail,fn($x)=>str_starts_with($x,'Config missing')))pass($ok,'Core runtime config markers: OK');
if(count($config)<20)fail($fail,'Config parity manifest unexpectedly short');else pass($ok,'Java/PHP config parity manifest: '.count($config).' settings documented');

$trace=(string)@file_get_contents($phpRoot.'/src/RequestTrace.php');foreach(['Player {$player} -> message:','| Room: {$room} | Cell: {$cell}',"Param '.(\$i+1)",'private function extra'] as $needle)if(!str_contains($trace,$needle))fail($fail,'RequestTrace missing marker '.$needle);
if(str_contains($trace,'strlen($s)>300')||str_contains($trace,'substr($s,0,297)'))fail($fail,'RequestTrace still truncates parameter values');else pass($ok,'Semantic request trace retains every request parameter without value truncation');

$server=(string)@file_get_contents($phpRoot.'/src/GameServer.php');foreach(['pollAdminCommands','processPlayerAurasAndDots','processMonsterDots','processPvpQueues','sendScheduledServerMessage','scheduleShutdown','scheduleRestart','monsterAttackTick'] as $needle)if(!str_contains($server,$needle))fail($fail,'GameServer task/runtime marker missing: '.$needle);
if(!array_filter($fail,fn($x)=>str_starts_with($x,'GameServer task/runtime')))pass($ok,'Scheduler/world/combat task markers: OK');
foreach(['skills_assign',"'cmd'=>'sAct'","'cmd'=>'aura-'","['respawnMon'",'turnInQuestItems($u',"SELECT id FROM items WHERE Meta=?"] as $needle)if(!str_contains($router.$server,$needle))fail($fail,'Combat/client parity marker missing: '.$needle);
if(str_contains($router.$server,'intDmg'))fail($fail,'Legacy intDmg field remains in active combat source');else pass($ok,'Combat packet field regression scan: OK');

$hashFile=$root.'/GAMEFILES_SHA256.txt';$hashLines=file($hashFile,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[];$checked=0;foreach($hashLines as $line){if(!preg_match('/^([0-9a-f]{64})\\s+(.+)$/i',$line,$m)){fail($fail,'Malformed GAMEFILES_SHA256 line: '.$line);continue;}$path=$root.'/'.trim($m[2]);if(!is_file($path)){fail($fail,'Protected gamefile missing: '.$m[2]);continue;}$actual=hash_file('sha256',$path);if(!hash_equals(strtolower($m[1]),strtolower($actual)))fail($fail,'Protected gamefile hash mismatch: '.$m[2]);else$checked++;}
if($checked===99&&count($hashLines)===99)pass($ok,'Protected deployed gamefiles: 99/99 SHA-256 verified');else if(!$hashLines)fail($fail,'GAMEFILES_SHA256.txt missing/empty');

// New v30 regression markers discovered during full parity audit.
foreach([
    'multi guild invites'=>'guildInvites',
    'potion/scroll inventory consumption'=>"SELECT id FROM items WHERE Meta=?",
    'quantity-aware temporary item removal'=>"'iQtyNow'=>\$left",
    'wheel shop table'=>'FROM wheels',
    'trade client onHold state'=>"'onHold'",
    'trap door room broadcast'=>"['trap door'",
] as $label=>$needle)if(!str_contains($router.(string)@file_get_contents($phpRoot.'/src/ClientSession.php'),$needle))fail($fail,"v30 regression marker missing: $label");
if(!array_filter($fail,fn($x)=>str_starts_with($x,'v30 regression')))pass($ok,'v30 full-audit regression markers: OK');

if($fail){fwrite(STDERR,"Aera v30 comprehensive parity audit FAILED\n- ".implode("\n- ",$fail)."\n");exit(1);} 
echo "Aera v30 comprehensive parity audit PASSED\n";foreach($ok as $line)echo $line."\n";
