<?php
declare(strict_types=1);
require dirname(__DIR__).'/src/Autoload.php';

use AeraEmu\Protocol;
use AeraEmu\ClientSession;
use AeraEmu\RoomState;

$fail=[];
$requiredRuntimeClasses=[
    AeraEmu\Config::class,AeraEmu\Database::class,AeraEmu\Logger::class,AeraEmu\WorldRepository::class,
    AeraEmu\WorldMath::class,AeraEmu\StatsCalculator::class,AeraEmu\CombatMath::class,AeraEmu\RequestTrace::class,
    AeraEmu\SettingsCodec::class,AeraEmu\AchievementBits::class,AeraEmu\ExtensionRouter::class,AeraEmu\GameServer::class,
];
foreach($requiredRuntimeClasses as $requiredClass)if(!class_exists($requiredClass))$fail[]='Missing runtime class/file: '.$requiredClass;

$raw=Protocol::raw(['loginResponse','true','42','Animu','MOTD','2026-09-02T12:00:00','news']);
$wire=rtrim($raw,"\0");
$expected='%xt%loginResponse%-1%true%42%Animu%MOTD%2026-09-02T12:00:00%news%';
if($wire!==$expected)$fail[]="raw login framing mismatch:\n{$wire}";

// Emulate SmartFoxClient.strReceived(): strip first/last %, split, then remove xt.
$parts=explode('%',substr($wire,1,-1));
array_shift($parts);
if(($parts[0]??null)!=='loginResponse')$fail[]='client index 0 must be loginResponse';
if(($parts[1]??null)!=='-1')$fail[]='client index 1 must be SmartFox room -1';
if(($parts[2]??null)!=='true')$fail[]='client index 2 must be login success';
if(($parts[3]??null)!=='42')$fail[]='client index 3 must be SFS user id';
if(($parts[4]??null)!=='Animu')$fail[]='client index 4 must be username';

$incoming=Protocol::parse('%xt%zm%firstJoin%1%');
if(($incoming['type']??'')!=='ext'||($incoming['cmd']??'')!=='firstJoin'||($incoming['room']??0)!==1)$fail[]='incoming STR XT parse failed';

$gar=Protocol::parse('%xt%zm%gar%1%11%aa>m:1%wvz%');
if(($gar['type']??'')!=='ext'||($gar['ext']??'')!=='zm'||($gar['cmd']??'')!=='gar'||($gar['room']??0)!==1||($gar['params']??[])!==['11','aa>m:1','wvz'])$fail[]='gar STR combat packet parse failed';

$respawnWire=rtrim(Protocol::raw(['respawnMon','7']),"\0");
if($respawnWire!=='%xt%respawnMon%-1%7%')$fail[]='respawnMon STR framing mismatch: '.$respawnWire;

$chatWire=rtrim(Protocol::raw(['chatm','zone~OOF','Animu','42','107','1']),"\0");
$chatParts=explode('%',substr($chatWire,1,-1));
array_shift($chatParts);
if(($chatParts[0]??null)!=='chatm'||($chatParts[2]??null)!=='zone~OOF'||($chatParts[3]??null)!=='Animu'||($chatParts[4]??null)!=='42'||($chatParts[5]??null)!=='107'||($chatParts[6]??null)!=='1')$fail[]='chatm packet does not match aClient-04 Game.as indices';

$json=Protocol::parse('{"t":"xt","b":{"x":"zm","c":"hi","r":1,"p":[]}}');
if(($json['type']??'')!=='ext'||($json['cmd']??'')!=='hi')$fail[]='incoming JSON XT parse failed';

$router=file_get_contents(dirname(__DIR__).'/src/ExtensionRouter.php') ?: '';
$worldRepo=file_get_contents(dirname(__DIR__).'/src/WorldRepository.php') ?: '';
$stats=file_get_contents(dirname(__DIR__).'/src/StatsCalculator.php') ?: '';
$trace=file_get_contents(dirname(__DIR__).'/src/RequestTrace.php') ?: '';
$routeSwitch=strstr($router,'    private function firstJoin',true) ?: $router;
preg_match_all("/case\\s+'([^']+)'/",$routeSwitch,$m);
$cases=array_values(array_unique($m[1]??[]));
$java=[
'getAchievement','setAchievement','buyAuctionItem','loadAuction','loadRetrieve','retrieveAuctionItem','retrieveAuctionItems','searchAuction','sellAuctionItem',
'bankFromInv','bankSwapInv','bankToInv','loadBank','cc','em','message','whisper','da','dd','duel','enhanceItemLocal','enhanceItemShop',
'addFriend','declineFriend','deleteFriend','getfriendlist','requestFriend','guild','house','housesave','trap door','buyItem','equipItem','removeItem','sellItem','serverUseItem','unequipItem',
'addLoadout','equipLoadout','removeLoadout','getMapItem','moveToCell','aggroMon','denyDrop','getDrop','gp','gar','afk','changeArmorColor','changeColor','emotea','firstJoin','genderSwapa','hi','ia','isModerator','mv','restRequest','resPlayerTimed','retrieveInventory','retrieveUserData','retrieveUserDatas','cmd','geia','PVPQr','PVPIr','acceptQuest','getQuests','tryQuestComplete','redeemCode','loadHairShop','loadShop','reloadShop','buyBagSlots','buyBankSlots','buyHouseSlots','buyLoadoutSlots','loadTitles','updateTitle','loadOffer','tia','tradeCancel','tradeDeal','tid','tradeFromInv','tradeLock','ti','tradeSwapInventory','tradeToInv','tradeUnlock','loadWarVars','wearItem','unwearItem','wearLoadout'
];
$missing=array_values(array_diff($java,$cases));
if($missing)$fail[]='Java request cases missing: '.implode(', ',$missing);

// Every request advertised by the router must have a real switch branch. This
// catches regressions in both the 94 Java routes and the newer stock-client aliases.
$supported=[];
foreach([
    '/\\$this->supported=array_fill_keys\\(\\[(.*?)\\],true\\);/s',
    '/foreach\\s*\\(\\[(.*?)\\]\\s*as\\s*\\$alias\\)/s'
] as $pattern){
    if(preg_match($pattern,$router,$block)){
        preg_match_all("/'([^']+)'/",$block[1],$names);
        $supported=array_merge($supported,$names[1]??[]);
    }
}
$supported=array_values(array_unique($supported));
$unrouted=array_values(array_diff($supported,$cases));
if($unrouted)$fail[]='Advertised PHP request routes missing a switch branch: '.implode(', ',$unrouted);

// Combat/class-skill compatibility markers taken from the Java Action/loadSkills path.
foreach([
    'class skill assignments'=>'skills_assign',
    'class action bootstrap'=>"'cmd'=>'sAct'",
    'Java damage result hp field'=>'\'hp\'=>$damage',
    'Java damage result type field'=>'\'type\'=>$type',
    'class action bootstrap call'=>'sendClassActions($u,true)',
] as $feature=>$marker)if(!str_contains($router,$marker))$fail[]='Missing combat compatibility marker: '.$feature;
if(str_contains($router,'intDmg'))$fail[]='Legacy intDmg combat field remains in ExtensionRouter';
if(!str_contains($router,"(int)\$r['Equipped']===1)\$o['bEquip']='1'"))$fail[]='Inventory bEquip must only be emitted for equipped rows';
if(str_contains($router,"\$o['bEquip']=(string)(int)\$r['Equipped']"))$fail[]='Unequipped inventory rows still serialize truthy string bEquip=0';
if(!str_contains($stats,"'\$cmc'=>")||!str_contains($stats,"'\$tha'=>"))$fail[]='Action-bar stat packet is missing Java $cmc/$tha stats';
if(!str_contains($router,"unset(\$m['targets'][\$u->socketId])"))$fail[]='moveToCell must clear stale monster targets';
$invStart=strpos($router,'private function inventory');
$invEnd=$invStart===false?false:strpos($router,'private function itemJson',$invStart);
if($invStart===false||$invEnd===false)$fail[]='Could not locate inventory bootstrap for combat ordering check';
else{
    $inv=substr($router,$invStart,$invEnd-$invStart);
    $classPos=strpos($inv,'sendClassActions($u,true)');
    $loadPos=strpos($inv,"'cmd'=>'loadInventoryBig'");
    if($classPos===false||$loadPos===false||$classPos>$loadPos)$fail[]='sAct/updateClass bootstrap must precede loadInventoryBig';
}

$server=file_get_contents(dirname(__DIR__).'/src/GameServer.php') ?: '';

if(str_contains($server,'intDmg'))$fail[]='Legacy intDmg combat field remains in GameServer';
if(!str_contains($server,'\'hp\'=>$damage')||!str_contains($server,'\'type\'=>$type'))$fail[]='Monster attack result is missing Java hp/type fields';
if(!str_contains($server,"\$ct['sara']")||!str_contains($server,"'actionResult'=>\$action"))$fail[]='Basic monster attack must use Java sara/actionResult response';
if(!preg_match('/->frame\s*!==\s*\(string\)\$m\[\'Frame\'\]/',$server))$fail[]='Monster attack tick must reject targets in a different map frame';
if(!str_contains($router,"\$m['state']=2"))$fail[]='Player attacks must put monsters into combat state 2';
if(!str_contains($router,"\$r->monsters[\$id]['state']=2"))$fail[]='aggroMon must put monsters into combat state 2';
if(!str_contains($server,"\$this->broadcastRaw(['respawnMon',(string)\$id],\$room)"))$fail[]='Monster respawn must send the client respawnMon command';
if(!str_contains($server,"['cmd'=>'mtls','id'=>\$id,'o'=>['intState'=>1,'intHP'=>\$m['HP'],'intMP'=>\$m['MP'],'intSP'=>100]]"))$fail[]='Monster respawn must restore Java-style mtls state before respawnMon';
if(!str_contains($server,"'intState'=>\$m['state']"))$fail[]='Disengaged monster regen must preserve runtime monster state';
if(!str_contains($router,"'expiresAt'=>\$expiresAt")||!str_contains($router,"if(\$cat==='stun')\$info['s']='s'"))$fail[]='Monster skill auras must be stored as timed server-side statuses';
if(!str_contains($server,'function monsterIsDisabled')||!str_contains($server,"['stun','freeze','stone','disabled']"))$fail[]='Monster AI must pause while Java-disabled aura categories are active';
if(!str_contains($server,'function expireMonsterAuras')||!str_contains($server,"'cmd'=>'aura-'")||!str_contains($server,"'aura'=>\$info"))$fail[]='Timed monster auras must emit Java aura- removal packets';
if(!str_contains($worldRepo,"'auras'=>[]")||!str_contains($worldRepo,"'Immune'=>(int)\$r['Immune']"))$fail[]='Monster runtime must retain aura timers and immunity';
if(!str_contains($router,"\$m['auras']=[]"))$fail[]='Monster death must clear server-side timed auras';
foreach([
    'private house rooms'=>'function joinHouse',
    'prepared PvP rooms'=>'function createPreparedPvpRoom',
    'unused PvP cleanup'=>'function releasePreparedRoomIfUnused',
    'gradual rest regeneration'=>'lastRegenAt',
    'timed death restoration'=>'respawnAt',
] as $feature=>$marker)if(!str_contains($router.$server,$marker))$fail[]='Missing runtime feature marker: '.$feature;


// v30 full-stack parity markers: semantic tracing, Java command tasks, and cache/schema corrections.
foreach([
    'semantic chat trace'=>'Player {$player} -> message:',
    'semantic command trace'=>'Player {$player} -> command: /',
    'room/cell trace'=>'| Room: {$room} | Cell: {$cell}',
    'unknown parameter fallback'=>"Param '.(\$i+1)",
] as $feature=>$marker)if(!str_contains($trace,$marker))$fail[]='Missing request trace marker: '.$feature;
foreach([
    'Java shutdown scheduler'=>'function scheduleShutdown',
    'Java restart scheduler'=>'function scheduleRestart',
    'shutdown cancellation'=>'function cancelShutdown',
    'restart cancellation'=>'function cancelRestart',
    'restart supervisor intent'=>'function markRestartIntent',
] as $feature=>$marker)if(!str_contains($server,$marker))$fail[]='Missing task lifecycle marker: '.$feature;
foreach([
    'staff pull'=>'function staffPull',
    'admin ban toggle'=>'function adminToggleBan',
    'shutdown command'=>"\$cmd==='shutdown'",
    'restart command'=>"\$cmd==='restart'",
    'moderator mute'=>"\$cmd==='mute'",
    'class point admin reward'=>"\$cmd==='addcp'",
] as $feature=>$marker)if(!str_contains($router,$marker))$fail[]='Missing Java UserCommand marker: '.$feature;
if(!str_contains($worldRepo,'SELECT * FROM hairs_shops_items ORDER BY ShopID')||!str_contains($worldRepo,"\$r['ShopID']"))$fail[]='Hair-shop child cache must use schema column ShopID';
if(!str_contains($server,"function gracefulLogout")||!str_contains($server,"Protocol::sys('logout',-1)"))$fail[]='Intentional logout must send SmartFox sys/logout before socket close';
if(!str_contains($router,"gracefulLogout(\$u,'client logout')"))$fail[]='XT logout command must use graceful SmartFox logout path';

if(!str_contains($router,'private function chatPacket(?ClientSession $u,string $channel,string $message,?RoomState $room=null)'))$fail[]='Central chatm packet builder is missing';
if(!str_contains($router,'private function staffChatNamePrefix(ClientSession $u): string'))$fail[]='Staff display-name prefix helper is missing';
if(!str_contains($router,'$displayName=$this->staffChatNamePrefix($u).ucfirst($displayName)'))$fail[]='Normal map chat must encode staff rank in the display-name field with a readable player name';
if(substr_count($router,"['chatm'")!==1)$fail[]='All chatm output must go through chatPacket() to preserve client field order';

// v30.5 live-command, staff-prefix, /iay and request-flood regressions.
if(!str_contains($router,'private function refreshLiveCommandState(ClientSession $u): void'))$fail[]='Live command state refresh helper is missing';
if(substr_count($router,'refreshLiveCommandState($u)')<6)$fail[]='Mutating staff commands are not wired to live state refresh';
if(!str_contains($router,"\$cmd==='iay'||\$cmd==='adminyell'"))$fail[]='/iay and /adminyell aliases must be routed';
if(!str_contains($router,"broadcastRaw(['iay'"))$fail[]='/iay must use dedicated iay transport';
if(!str_contains($router,"\$rank=\$u->access>=90?'GameMaster':(\$u->access>=60?'Administrator':'Moderator')"))$fail[]='/iay must preserve visible Moderator/Administrator/Game Master rank';
if(!str_contains($router,'Admin /item is an immediate grant'))$fail[]='/item must grant immediately instead of requiring relog/drop acceptance';
if(!str_contains($sessionSource??'','public bool $presenceAnnounced=false')&&!str_contains(file_get_contents(dirname(__DIR__).'/src/ClientSession.php') ?: '','public bool $presenceAnnounced=false'))$fail[]='Per-session presence announcement guard is missing';
if(!str_contains($router,'if(!$u->presenceAnnounced)'))$fail[]='Inventory refresh must not resend login presence notices';
$configSource=file_get_contents(dirname(__DIR__).'/config/emulator.php') ?: '';
if(!str_contains($configSource,"'antiflood_request_tolerance'=>10")||!str_contains($configSource,"'antiflood_request_max_repeated'=>10")||!str_contains($configSource,"'antiflood_request_warnings'=>1"))$fail[]='Request flood disconnect threshold must be 10 requests';

// v30.7 player-management and cross-player item grant regressions.
if(!str_contains($router,"\$cmd==='giveitem'"))$fail[]='/giveitem command is missing';
if(!str_contains($router,'public function grantItemToPlayer(int $userId,int $itemId,int $qty=1'))$fail[]='Shared live item grant helper is missing';
if(!str_contains($server,"\$action === 'message-player'"))$fail[]='Panel direct-message RPC is missing';
if(!str_contains($server,"\$action === 'ban-player'"))$fail[]='Panel live-ban RPC is missing';
if(!str_contains($server,"\$action === 'give-item'"))$fail[]='Panel give-item RPC is missing';
if(!str_contains($server,"Reason: '.\$reason"))$fail[]='Kick/ban reason delivery is missing';

// v30.8 logout/message/player-tab regressions.
$projectRoot=dirname(__DIR__,3);
$clientSource=file_get_contents($projectRoot.'/Sources/Client/src/Game.as') ?: '';
$worldClientSource=file_get_contents($projectRoot.'/Sources/Client/src/World.as') ?: '';
$avatarClientSource=file_get_contents($projectRoot.'/Sources/Client/src/AvatarMC.as') ?: '';
$databaseNpcPanelSource=file_get_contents($projectRoot.'/Sources/Client/src/DatabaseNPCPanel.as') ?: '';
$emuPanelView=file_get_contents($projectRoot.'/web/views/admin/emulator/index.php') ?: '';
$emuPanelJs=file_get_contents($projectRoot.'/web/public/assets/js/app.js') ?: '';
$emuController=file_get_contents($projectRoot.'/web/app/Controllers/AdminEmulatorController.php') ?: '';
$webRoutes=file_get_contents($projectRoot.'/web/routes/web.php') ?: '';
if(str_contains($server,"'[Staff Message] '"))$fail[]='Panel staff messages still use square brackets that Chat2 converts to question marks';
if(!str_contains($server,"'Staff Message: '.\$message"))$fail[]='Panel staff-message prefix must be legacy-chat-safe ASCII';
if(str_contains($router,"'['.\$rank.'] '"))$fail[]='/iay still uses square brackets that Chat2 cleanChars converts to question marks';
if(!str_contains($router,"broadcastRaw(['iay',\$rank,\$u->username,\$msg])"))$fail[]='/iay rank/username wire format is missing';
if(!str_contains($clientSource,"public function logout():void")||!preg_match('/public function logout\(\):void\s*\{\s*userLogoutPending = true;\s*showServers = false;/s',$clientSource))$fail[]='Client logout must clear showServers so it cannot auto-login into Server Select';
if(substr_count($clientSource,'gotoAndPlay("Login");')<4)$fail[]='Client disconnect/logout handlers must return directly to Login';
foreach(['Message'=>'data-emu-player-action="message"','Kick'=>'data-emu-player-action="kick"','Ban'=>'data-emu-player-action="ban"','Give Item'=>'data-emu-player-action="give-item"','Manage'=>'/admin/players?q='] as $feature=>$needle)if(!str_contains($emuPanelView,$needle))$fail[]='Emulator Players tab missing visible '.$feature.' action';
if(!str_contains($emuPanelJs,"/admin/emulator/player-action"))$fail[]='Emulator Players tab live action AJAX route is missing';
if(!str_contains($emuController,'public function livePlayerAction(Request $request): void'))$fail[]='Emulator Players tab controller action is missing';
if(!str_contains($webRoutes,"/admin/emulator/player-action"))$fail[]='Emulator Players tab route is missing';

// v30.10 Chat2 map-chat compatibility regression.
if(str_contains($router,'staffChatChannel('))$fail[]='Map chat must not emit administrator/gm channels because aClient-04 Chat2 drops them';
if(!str_contains($router,"chatPacket(\$u,'zone',\$message,\$r)"))$fail[]='Normal map chat must use the Chat + Chat2 compatible zone channel with an unmodified message body';
foreach(['[Mod] ','[Admin] ','[GM] '] as $prefix)if(!str_contains($router,$prefix))$fail[]='Missing staff display-name prefix '.$prefix;
if(str_contains($router,'$display=$this->staffChatPrefix($u).$message'))$fail[]='Staff rank must not be embedded in map-chat message text';
if(!str_contains($router,'$displayName=$this->staffChatNamePrefix($u).ucfirst($displayName)'))$fail[]='Staff rank must be encoded in the chatm display-name field';

// v30.13 staff prefix formatting regression.
$chat2Source=file_get_contents($projectRoot.'/Sources/Client/src/Chat2.as') ?: '';
$chatLegacySource=file_get_contents($projectRoot.'/Sources/Client/src/Chat.as') ?: '';
foreach(['u:[Admin] ','u:[Mod] ','u:[GM] ','u:[admin] ','u:[mod] ','u:[gm] '] as $prefix){
    if(!str_contains($chat2Source,$prefix))$fail[]='Chat2 speech-bubble lookup does not strip staff display prefix '.$prefix;
    if(!str_contains($chatLegacySource,$prefix))$fail[]='Legacy Chat speech-bubble lookup does not strip staff display prefix '.$prefix;
}
if(!str_contains($router,"return '[Admin] ';"))$fail[]='Administrator chat prefix must be [Admin]';
if(!str_contains($router,"return '[Mod] ';"))$fail[]='Moderator chat prefix must be [Mod]';
if(!str_contains($router,"return '[GM] ';"))$fail[]='Game Master chat prefix must be [GM]';
if(!str_contains($chat2Source,'u:[admin] ')||!str_contains($chatLegacySource,'u:[admin] '))$fail[]='Speech bubble fix must account for strToProperCase lowercasing the staff prefix before avatar lookup';

// v30.9 kick-reason delivery + centralized admin_logs regressions.
$adminLogger=file_get_contents($projectRoot.'/web/app/Foundation/AdminLogger.php') ?: '';
$adminController=file_get_contents($projectRoot.'/web/app/Controllers/AdminController.php') ?: '';
$publicIndex=file_get_contents($projectRoot.'/web/public/index.php') ?: '';
$installer=file_get_contents($projectRoot.'/web/app/Foundation/Installer.php') ?: '';
if(!str_contains($server,"['popup','messagebox',\$kickMessage]")||!str_contains($server,"['logoutWarning',\$kickMessage,'5']"))$fail[]='Panel kick must show and persist the actual kick reason before disconnect';
if(!str_contains($sessionSource??'','public bool $kickGraceful=false')&&!str_contains(file_get_contents(dirname(__DIR__).'/src/ClientSession.php') ?: '','public bool $kickGraceful=false'))$fail[]='Graceful staff-kick state is missing';
if(!str_contains($clientSource,'String(userPreference.data.logoutWarning) + "\nYou will be able to login after $s seconds."'))$fail[]='Client source does not render stored kick/ban reason on the login warning';
if(!str_contains($adminLogger,'CREATE TABLE IF NOT EXISTS `admin_logs`'))$fail[]='admin_logs centralized audit table definition is missing';
if(!str_contains($publicIndex,'AdminLogger::begin($request)'))$fail[]='Admin panel request logger is not wired globally';
if(!str_contains($adminLogger,"register_shutdown_function([self::class, 'finish'])"))$fail[]='Admin log response-status/duration shutdown hook is missing';
if(!str_contains($adminLogger,"'[REDACTED]'"))$fail[]='Admin log sensitive-field redaction is missing';
if(!str_contains($installer,'AdminLogger::createSql()'))$fail[]='Installer does not auto-create admin_logs';
if(!str_contains($webRoutes,"/admin/logs")||!str_contains($adminController,'public function logs(Request $request): void'))$fail[]='Admin Logs viewer route/controller is missing';

// v30.14-v30.16 Player Management modal/cache/edit-key regressions.
$playersView=file_get_contents($projectRoot.'/web/views/admin/players.php') ?: '';
$adminLayout=file_get_contents($projectRoot.'/web/views/layouts/admin.php') ?: '';
if(!str_contains($playersView,'/admin/data/users/edit?key='))$fail[]='Player Management visible Edit action is missing';
if(!str_contains($playersView,'class="player-manage-dialog"'))$fail[]='Player Management page-level Manage dialog is missing';
if(!str_contains($playersView,'max-height:calc(100vh - 32px)')||!str_contains($playersView,'overflow-y:auto'))$fail[]='Player Management dialog must remain viewport-safe and scrollable';
if(!str_contains($playersView,'class="player-row-actions"')||!str_contains($playersView,'>Edit</a>')||!str_contains($playersView,'>Manage</button>'))$fail[]='Player Management row must visibly render Edit and Manage actions';
if(str_contains($playersView,"['_edit_key']"))$fail[]='Player Management Edit links must not depend on controller-injected _edit_key';
if(!str_contains($playersView,'$playerEditKey((int)$p[\'id\'])'))$fail[]='Player Management Edit links must derive the users.id primary-key token directly from the row';
if(!str_contains($playersView,'<dialog id='))$fail[]='Manage UI must render outside the table row as a native dialog';
if(!str_contains($adminLayout,'filemtime(__DIR__')||!str_contains($adminLayout,'app.css?v='))$fail[]='Admin CSS/JS must use file-version cache busting';

// v30.19 persistent /position coordinate-display regression.
if(!str_contains($router,"\$cmd==='position'"))$fail[]='/position toggle command is missing';
if(!str_contains($sessionSource??'','public bool $positionDisplay=false')&&!str_contains(file_get_contents(dirname(__DIR__).'/src/ClientSession.php') ?: '','public bool $positionDisplay=false'))$fail[]='/position per-session toggle state is missing';
if(!str_contains($server,"['popup','blackbanner','Position  X: '.\$client->x.'  Y: '.\$client->y]"))$fail[]='/position persistent HUD refresh is missing';
if(!str_contains($server,'$now-$client->lastPositionDisplayAt>=0.75'))$fail[]='/position HUD refresh interval is missing';
if(!str_contains($router,'if($u->positionDisplay)$u->lastPositionDisplayAt=0.0'))$fail[]='/position must refresh immediately when movement changes X/Y';

// v30.20 database-driven NPC renderer/backend regressions.
if(!str_contains($clientSource,'world.npcBranch =')||!str_contains($clientSource,'world.npcdef =')||!str_contains($clientSource,'world.npcmap ='))$fail[]='Client moveToArea database NPC payload wiring is missing';
if(!str_contains($worldClientSource,'public function updateDatabaseNPCs():void')||!str_contains($worldClientSource,'public function openDatabaseNPC(avt:Avatar):void'))$fail[]='Client database NPC renderer/click handler is missing';
if(!str_contains($avatarClientSource,'_local_2.npcType == "npc"'))$fail[]='Database NPC clicks must bypass player/PvP targeting';
if(!preg_match('/class\s+DatabaseNPCPanel\s+extends\s+(?:Sprite|MovieClip)/',$databaseNpcPanelSource))$fail[]='Database NPC runtime interaction panel source is missing';
$databaseMapArrowSource=file_get_contents($projectRoot.'/Sources/Client/src/DatabaseMapArrow.as') ?: '';
if(!str_contains($databaseMapArrowSource,'class DatabaseMapArrow extends MovieClip'))$fail[]='Database map arrow runtime source is missing';
if(!str_contains($worldClientSource,'updateDatabaseMapArrows()'))$fail[]='World does not build database map arrows during cell setup';
if(!str_contains($clientSource,'world.mapArrows ='))$fail[]='moveToArea does not assign database map arrow payload';

if(!str_contains($worldRepo,'public function mapNpcPayload(int $mapId): array'))$fail[]='WorldRepository database NPC payload builder is missing';
if(!str_contains($server,"\$this->world->mapNpcPayload((int)\$r->map['id'])"))$fail[]='GameServer moveToArea database NPC payload is missing';

// v30 comprehensive-audit regressions discovered outside the original request-only pass.
$sessionSource=file_get_contents(dirname(__DIR__).'/src/ClientSession.php') ?: '';
foreach([
    'multi-guild invite state'=>'public array $guildInvites=[]',
    'potion/scroll inventory consumption'=>"SELECT id FROM items WHERE Meta=? ORDER BY id LIMIT 1",
    'wheel shop load'=>'FROM wheels w INNER JOIN items',
    'wheel shop purchase'=>'FROM wheels w WHERE w.ItemID=?',
    'trade client onHold state'=>"'onHold'=>1",
    'trap door room broadcast'=>"broadcastRaw(['trap door'",
    'quantity-aware temp item removal'=>"'iQtyNow'=>\$left",
] as $feature=>$needle)if(!str_contains($router.$sessionSource,$needle))$fail[]='Missing v30 comprehensive audit marker: '.$feature;
if(str_contains($trace,'strlen($s)>300')||str_contains($trace,'substr($s,0,297)'))$fail[]='Request tracing must not truncate request parameter values';
if(!str_contains($trace,'private function extra(array $params,int $start)'))$fail[]='Request tracing must preserve unmapped trailing parameters';

$stream=fopen('php://temp','r+');
if($stream===false)$fail[]='Could not create temporary session stream';
else{
    $session=new ClientSession($stream,7,'127.0.0.1');
    $session->resting=true;$session->pvpRoomId=123;$session->pvpTeam=1;
    if(!$session->resting||$session->pvpRoomId!==123||$session->pvpTeam!==1)$fail[]='Client runtime state fields failed';
    $room=new RoomState(123,'doomarena-123',['PvP'=>1],[],['pvp'=>['scores'=>[0,0],'done'=>false]]);
    if(($room->meta['pvp']['scores'][1]??null)!==0)$fail[]='Room runtime metadata failed';
    fclose($stream);
}


// v30.18 live staff management + staff-link regressions.
if(!str_contains($router,'if($u->access<40&&$this->containsUrl($message))'))$fail[]='Moderator+ chat links must bypass the anti-link auto-mute';
if(!str_contains($router,'$u->access>=40?\'1\':\'0\''))$fail[]='Staff chat/whisper packets must carry the staff flag so client link filtering does not drop staff URLs';
if(!str_contains($router,'$cmd===\'promote\'||$cmd===\'demote\''))$fail[]='/promote and /demote commands are missing';
if(!str_contains($router,'public function setPlayerAccess(int $userId,int $newAccess'))$fail[]='Shared real-time player access update helper is missing';
foreach(['Support'=>"'30','support','helper'=>30",'Moderator'=>"'40','mod','moderator'=>40",'Administrator'=>"'60','admin','administrator'=>60",'Game Master'=>"'90','gm','gamemaster'=>90",'Owner'=>"'100','owner'=>100"] as $rank=>$needle)if(!str_contains($router,$needle))$fail[]='Staff rank mapping missing '.$rank;
foreach(['$action === \'mute-player\'','$action === \'unmute-player\'','$action === \'set-access\''] as $needle)if(!str_contains($server,$needle))$fail[]='Live player RPC missing '.$needle;
if(!str_contains($emuPanelView,"?'unmute':'mute'")&&!str_contains($emuPanelJs,"action === 'mute'"))$fail[]='Emulator Players tab missing Mute/Unmute control';
foreach(['Promote'=>'data-emu-player-action="promote"','Demote'=>'data-emu-player-action="demote"'] as $feature=>$needle)if(!str_contains($emuPanelView,$needle))$fail[]='Emulator Players tab missing '.$feature.' control';
if(!str_contains($playersView,'value="promote"')||!str_contains($playersView,'value="demote"')||!str_contains($playersView,'value="mute"'))$fail[]='Player Management modal missing mute/promote/demote controls';
if(!str_contains($chat2Source,'\\bhttps?://')||!str_contains($chatLegacySource,'\\bhttps?://'))$fail[]='Chat and Chat2 must render both HTTP and HTTPS links as clickable';

if($fail){
    fwrite(STDERR,"Aera PHP emulator self-test FAILED\n- ".implode("\n- ",$fail)."\n");
    exit(1);
}
echo "Aera PHP emulator self-test PASSED\n";
echo "SmartFox STR login response indices: OK\n";
echo "Incoming STR/JSON XT parsing: OK\n";
echo "GAR combat packet parsing: OK\n";
echo "Combat damage + class action protocol: OK\n";
echo "Inventory equip-state + action-bar stats: OK\n";
echo "Monster same-cell targeting: OK\n";
echo "Monster combat-state + respawnMon parity: OK\n";
echo "Timed monster stun/aura lifecycle: OK\n";
echo "respawnMon STR framing: OK\n";
echo "Java RequestManage route coverage: ".count($java)."/".count($java)."\n";
echo "Advertised PHP request route coverage: ".count($supported)."/".count($supported)."\n";
echo "House, PvP, rest, and respawn runtime state: OK\n";
echo "Semantic request parameter tracing: OK\n";
echo "Java UserCommand + shutdown/restart task parity: OK\n";
echo "v30 trade/potion/wheel/guild/temp-item regressions: OK\n";
echo "WorldRepository schema/cache markers: OK\n";
echo "Graceful SmartFox logout handshake: OK\n";

echo "aClient-04 chatm layout + Chat2-compatible map chat: OK\n";
echo "Staff prefix [Admin]/[Mod]/[GM] + restored speech bubble lookup: OK\n";
echo "Live command refresh + immediate /item: OK\n";
echo "/iay global staff announcement (Chat + Chat2): OK\n";
echo "Request flood disconnect threshold: 10 requests\n";
echo "Panel message/kick/ban reason controls: OK\n";
echo "/giveitem + panel live item grant: OK\n";
echo "Logout returns directly to Login: OK\n";
echo "/iay + panel message legacy-chat-safe text: OK\n";
echo "Emulator Players tab Message/Kick/Ban/Give Item/Manage: OK\n";
echo "Kick reason popup + graceful disconnect: OK\n";
echo "Central admin_logs audit trail + sensitive-field redaction: OK\n";
echo "Staff rank text-chat only; speech bubble raw message: OK\n";

echo "/position persistent live X/Y display toggle: OK\n";

echo "Chat2 staff map-chat channel regression: FIXED\n";
echo "Database NPC moveToArea + source renderer: OK\n";
