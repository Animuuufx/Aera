<?php
declare(strict_types=1);
require dirname(__DIR__).'/src/Autoload.php';
use AeraEmu\{GameServer,ClientSession,Config,Logger};

$server=(new ReflectionClass(GameServer::class))->newInstanceWithoutConstructor();
$config=new Config(dirname(__DIR__));
(new ReflectionProperty($server,'config'))->setValue($server,$config);
(new ReflectionProperty($server,'log'))->setValue($server,new Logger(sys_get_temp_dir().'/aera-rift-poll-test.log'));
$guard=new ReflectionMethod($server,'isRequestFlood');
$u=new ClientSession(null,1,'test');$checks=0;
function check(bool $ok,string $message):void { global $checks;$checks++;if(!$ok)throw new RuntimeException($message); }

// Simulate an hour of five-second refreshes without sleeping or contacting a DB.
for($i=0;$i<720;$i++){
    $u->lastRiftPanelRequestMs=microtime(true)*1000-5000;
    check(!$guard->invoke($server,$u,'cmd',['rift','panel',0,0]),'Normal polling must remain accepted');
}
check($u->requestWarnings===0&&$u->repeatedRequestCounter===0,'Polling never accumulates generic flood penalties');
$last=$u->lastRiftPanelRequestMs;
for($i=0;$i<30;$i++)check($guard->invoke($server,$u,'cmd',['rift','panel',0,0]),'Rapid panel requests are throttled');
check($u->requestWarnings===0&&$u->lastRiftPanelRequestMs===$last,'Throttled reads neither kick nor prolong the cooldown');
$u->lastRiftPanelRequestMs=microtime(true)*1000-501;
check(!$guard->invoke($server,$u,'cmd',[' RIFT ',' PANEL ',1,1]),'Normalization matches the command router');

// A poll must neither count as nor erase suspicious write traffic.
$u->lastRequest='cmd';$u->repeatedRequestCounter=1;$u->requestCounter=2;$u->requestWarnings=0;$u->lastRequestMs=1234;
$u->lastRiftPanelRequestMs=0;
$guard->invoke($server,$u,'cmd',['rift','panel']);
check($u->lastRequest==='cmd'&&$u->repeatedRequestCounter===1&&$u->requestCounter===2&&$u->lastRequestMs===1234.0,'Read polling leaves generic flood state intact');
foreach([['rift','buy',1,'token'],['rift','join'],['rift','deposit'],['rift','status'],['other','panel']] as $args){
    $u->lastRequestMs=0;$u->lastRequest='cmd';$u->repeatedRequestCounter=0;
    $guard->invoke($server,$u,'cmd',$args);
    check($u->repeatedRequestCounter===1,'Write and unrelated commands retain repeat protection');
}
echo "Rift polling: {$checks} checks passed.\n";
