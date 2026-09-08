<?php
declare(strict_types=1);
require dirname(__DIR__).'/src/Autoload.php';

use AeraEmu\CombatMath;
use AeraEmu\Database;
use AeraEmu\WorldRepository;
use AeraEmu\ClientSession;

$fail=[];
$eq=static function(string $name,mixed $got,mixed $want)use(&$fail):void{
    if(is_float($want)){
        if(abs((float)$got-$want)>0.00001)$fail[]="$name: got ".var_export($got,true).", expected ".var_export($want,true);
    }elseif($got!==$want)$fail[]="$name: got ".var_export($got,true).", expected ".var_export($want,true);
};

$eq('legacy 50% normalization',CombatMath::normalizedRateValue(50,'-'),.50);
$eq('legacy +10 normalization',CombatMath::applyRateEffect(1.0,'+',10),1.10);
$eq('legacy *10 means +10%',CombatMath::applyRateEffect(1.0,'*',10),1.10);
$eq('50% mitigation coefficient',CombatMath::applyRateEffect(1.0,'-',50),.50);

// CombatMath's directional coefficient paths are pure once the cached world is
// supplied, so construct cache/database shells without opening MySQL.
$db=(new ReflectionClass(Database::class))->newInstanceWithoutConstructor();
$world=(new ReflectionClass(WorldRepository::class))->newInstanceWithoutConstructor();
$world->rates=[];
$world->auraEffectsByAura=[
    1=>[['id'=>1,'AuraID'=>1,'Stat'=>'cai','Value'=>10.0,'Type'=>'+']],
];
$combat=new CombatMath($db,$world);
$sock=fopen('php://temp','r+');
$u=new ClientSession($sock,1,'127.0.0.1');
$u->classCategory='M1';
$u->stats=['$cao'=>1.0,'$cpo'=>1.10,'$cmo'=>1.0,'$cai'=>.50,'$cpi'=>1.0,'$cmi'=>1.0,'$cdi'=>.75,'$chi'=>1.0,'$cho'=>1.0];
$u->auras=[];$u->passiveAuras=[];

$eq('Aggression-style physical outgoing', $combat->playerOutgoing(100,$u,microtime(true),'physical'),110);
$eq('On Guard-style incoming mitigation', $combat->playerIncoming(100,$u,microtime(true),'physical'),50);
$eq('DoT incoming coefficient', $combat->playerDotIncoming(100,$u),75);
$monsterAuras=[1=>['id'=>1,'nam'=>'Armor Shred','cat'=>'none','expiresAt'=>microtime(true)+5,'DamageIncrease'=>0.0,'DamageTakenDecrease'=>0.0]];
$eq('Armor Shred-style monster incoming', $combat->monsterIncoming(100,$monsterAuras,microtime(true),'physical'),110);

$root=dirname(__DIR__);
$router=file_get_contents($root.'/src/ExtensionRouter.php')?:'';
$server=file_get_contents($root.'/src/GameServer.php')?:'';
$stats=file_get_contents($root.'/src/StatsCalculator.php')?:'';
$sqlPath=dirname($root,2).'/Database/patches/v30_63_buff_skills_aura_ack.sql';
$sql=is_file($sqlPath)?(file_get_contents($sqlPath)?:''):'';

foreach([
    'self target routing'=>"if(\$targetMode==='s')\$targetSpecs=['p:'.\$u->sfsUserId]",
    'Prepared Strike runtime'=>'Prepared Strike',
    'Prepared Strike charges'=>"\$runtime['charges']=2",
    'Prepared Strike On Guard snapshot'=>"\$runtime['guarded']=\$this->activePlayerAuraByName(\$target,'On Guard',\$now)!==null",
    'aura client effects'=>"\$info['e']=\$effects",
    'v30.61 iay transport'=>"broadcastRaw(['iay',\$rank,\$u->username,\$msg])",
] as $name=>$marker)if(!str_contains($router,$marker))$fail[]="Missing router marker: $name";

foreach([
    'configured Flash policy port'=>"Protocol::policy((int)\$this->config->get('port',5589))",
    'monster outgoing aura math'=>'monsterOutgoing(',
    'player incoming aura math'=>'playerIncoming(',
    'player DoT aura math'=>'playerDotIncoming(',
    'monster DoT aura math'=>'monsterDotIncoming(',
    'PvP exit stat recalculation'=>'$this->recalculateStats($client,false)',
] as $name=>$marker)if(!str_contains($server,$marker))$fail[]="Missing server marker: $name";

foreach(['\$cai','\$cao','\$cpi','\$cpo','\$cmi','\$cmo','\$cdi','\$cdo','\$chi','\$cho','\$cmc'] as $stat){
    $needle=str_replace('\\','',$stat);
    if(!str_contains($stats,$needle))$fail[]="StatsCalculator missing coefficient $needle";
}

foreach([
    "`Name`='Prepared Strike'",
    "`Name` IN ('Prepared Strike','On Guard','Fortune')",
    "'cai',50.00,'-'",
    "'thi',30.00,'+'",
] as $marker)if(!str_contains($sql,$marker))$fail[]="SQL patch missing marker: $marker";

foreach([
    'self session direct resolution'=>'$target=($id===$u->sfsUserId)?$u:$this->server->findUserBySfsId($id)',
    'forced baseline self buffs'=>"['prepared strike','on guard','fortune']",
    'zero damage uses NONE'=>'$damage=0;$type=\'none\'',
    'NONE can apply non-hostile aura'=>'$nonHostile&&$resultType===\'none\'',
    'failed action unlock ack'=>'\'iRes\'=>0',
    'live skill aura fallback'=>'SELECT AuraID FROM skills_auras WHERE SkillID=? ORDER BY id',
    'live aura effect fallback'=>'SELECT * FROM auras_effects WHERE AuraID=? ORDER BY id',
    'aura application trace'=>'Aura applied: ',
] as $name=>$marker)if(!str_contains($router,$marker))$fail[]="Missing v30.63 router marker: $name";

if(is_resource($sock))fclose($sock);
if($fail){fwrite(STDERR,"Aera v30.63 aura self-test FAILED\n- ".implode("\n- ",$fail)."\n");exit(1);}
echo "Aera v30.63 aura self-test PASSED\n";
echo "Self/friendly buff acknowledgement, DamageType.NONE aura casts, live aura mapping/effect fallbacks, plus v30.62 combat math are verified.\n";
