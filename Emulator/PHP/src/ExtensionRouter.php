<?php
declare(strict_types=1);
namespace AeraEmu;

use Throwable;

final class ExtensionRouter
{
    private array $supported;
    private array $parties=[];
    private int $nextPartyId=1;
    /** @var array<string,array<int,ClientSession>> */
    private array $pvpQueues=[];
    private WorldMath $math;
    private StatsCalculator $statsCalculator;
    private CombatMath $combat;
    public function __construct(private GameServer $server,private Database $db,private Logger $log,private WorldRepository $world,private Config $config)
    {
        $this->math=new WorldMath($world);$this->statsCalculator=new StatsCalculator($db,$world);$this->combat=new CombatMath($db,$world);
        $this->supported=array_fill_keys([
            'getAchievement','setAchievement','buyAuctionItem','loadAuction','loadRetrieve','retrieveAuctionItem','retrieveAuctionItems','searchAuction','sellAuctionItem',
            'bankFromInv','bankSwapInv','bankToInv','loadBank','cc','em','message','whisper','da','dd','duel','enhanceItemLocal','enhanceItemShop',
            'addFriend','declineFriend','deleteFriend','getfriendlist','requestFriend','guild','house','housesave','trap door','buyItem','equipItem','removeItem','sellItem','serverUseItem','unequipItem',
            'addLoadout','equipLoadout','removeLoadout','getMapItem','moveToCell','aggroMon','denyDrop','getDrop','gp','gar','afk','changeArmorColor','changeColor','emotea','firstJoin','genderSwapa','hi','ia','isModerator','mv','restRequest','resPlayerTimed','retrieveInventory','retrieveUserData','retrieveUserDatas','cmd','geia','PVPQr','PVPIr','acceptQuest','getQuests','tryQuestComplete','redeemCode','loadHairShop','loadShop','reloadShop','buyBagSlots','buyBankSlots','buyHouseSlots','buyLoadoutSlots','loadTitles','updateTitle','loadOffer','tia','tradeCancel','tradeDeal','tid','tradeFromInv','tradeLock','ti','tradeSwapInventory','tradeToInv','tradeUnlock','loadWarVars','wearItem','unwearItem','wearLoadout'
        ],true);
        // Newer stock-client aliases that were not present in the legacy Java RequestManage.
        // They are kept here so the existing SWF can use either protocol generation.
        foreach ([
            'tradeSwapInv','loadFriendsList','loadFactions','loadHouseInventory','getQuests2','spendStatPoints','saveStatPoints','resetStatPoints',
            'loadQuestStringData','updateQuest','enhanceItem','forceEquipItem','removeTempItem',
            'retrieveMonData','changeClass','setHomeTown','summonPet','getApop','mtcid',
            'dungeonQueue','dungeonRejoin','castt','dynamic','fbCmd','getAdData','getAdReward','rewardReferral'
        ] as $alias) $this->supported[$alias]=true;
    }

    public function handle(ClientSession $u,string $cmd,array $p,int $fromRoom): void
    {
        if(!isset($this->supported[$cmd])){$this->server->sendRaw($u,['server','Unknown request: '.$cmd]);return;}
        switch($cmd){
            case 'hi':$this->server->sendRaw($u,['hi']);break;
            case 'firstJoin':$this->firstJoin($u);break;
            case 'mv':$this->move($u,$p);break;
            case 'moveToCell':$this->moveToCell($u,$p);break;
            case 'message':$this->message($u,$p);break;
            case 'whisper':$this->whisper($u,$p);break;
            case 'cmd':$this->command($u,$p);break;
            case 'gar':$this->action($u,$p);break;
            case 'aggroMon':$this->aggro($u,$p);break;
            case 'retrieveInventory':$this->inventory($u);break;
            case 'loadShop':case 'reloadShop':$this->shop($u,$p);break;
            case 'buyItem':$this->buyItem($u,$p);break;
            case 'sellItem':$this->sellItem($u,$p);break;
            case 'equipItem':$this->equip($u,$p,true);break;
            case 'unequipItem':$this->equip($u,$p,false);break;
            case 'wearItem':$this->wearItem($u,$p);break;
            case 'unwearItem':$this->unwearItem($u,$p);break;
            case 'getQuests':$this->getQuests($u,$p);break;
            case 'acceptQuest':$this->acceptQuest($u,$p);break;
            case 'tryQuestComplete':$this->completeQuest($u,$p);break;
            case 'loadBank':$this->loadBank($u);break;
            case 'bankFromInv':$this->bankMove($u,$p,true);break;
            case 'bankToInv':$this->bankMove($u,$p,false);break;
            case 'getfriendlist':case 'loadFriendsList':$this->friends($u,$cmd==='loadFriendsList');break;
            case 'requestFriend':$this->requestFriend($u,$p);break;
            case 'addFriend':$this->addFriend($u,$p);break;
            case 'declineFriend':$this->declineFriend($u,$p);break;
            case 'deleteFriend':$this->deleteFriend($u,$p);break;
            case 'isModerator':$this->isModerator($u,$p);break;
            case 'restRequest':$this->startRest($u);break;
            case 'loadTitles':$this->titles($u);break;
            case 'updateTitle':$this->updateTitle($u,$p);break;
            case 'redeemCode':$this->redeem($u,$p);break;
            case 'getDrop':$this->getDrop($u,$p);break;
            case 'denyDrop':$this->denyDrop($u,$p);break;
            case 'getMapItem':$this->mapItem($u,$p);break;
            case 'getAchievement':$this->getAchievement($u,$p);break;
            case 'setAchievement':$this->setAchievement($u,$p);break;
            case 'loadAuction':$this->loadAuction($u,$p,false);break;
            case 'searchAuction':$this->searchAuction($u,$p);break;
            case 'loadRetrieve':$this->loadAuction($u,$p,true);break;
            case 'sellAuctionItem':$this->sellAuction($u,$p);break;
            case 'buyAuctionItem':$this->buyAuction($u,$p);break;
            case 'retrieveAuctionItem':case 'retrieveAuctionItems':$this->retrieveAuction($u,$p,$cmd);break;
            case 'bankSwapInv':$this->bankSwap($u,$p);break;
            case 'cc':$this->cannedChat($u,$p);break;
            case 'em':case 'emotea':$this->emote($u,$p,$cmd);break;
            case 'duel':$this->duelInvite($u,$p);break;
            case 'da':$this->duelReply($u,$p,true);break;
            case 'dd':$this->duelReply($u,$p,false);break;
            case 'enhanceItemLocal':case 'enhanceItemShop':$this->enhanceItem($u,$p,$cmd);break;
            case 'guild':$this->guild($u,$p);break;
            case 'house':$this->house($u,$p);break;
            case 'housesave':$this->houseSave($u,$p);break;
            case 'trap door':$this->trapDoor($u,$p);break;
            case 'removeItem':$this->removeItem($u,$p);break;
            case 'serverUseItem':$this->useItem($u,$p);break;
            case 'addLoadout':$this->addLoadout($u,$p);break;
            case 'equipLoadout':case 'wearLoadout':$this->equipLoadout($u,$p,$cmd);break;
            case 'removeLoadout':$this->removeLoadout($u,$p);break;
            case 'gp':$this->party($u,$p);break;
            case 'afk':$this->afk($u,$p);break;
            case 'changeArmorColor':$this->changeArmorColor($u,$p);break;
            case 'changeColor':$this->changeColor($u,$p);break;
            case 'genderSwapa':$this->genderSwap($u);break;
            case 'ia':$this->interaction($u,$p);break;
            case 'resPlayerTimed':$this->restorePlayer($u,$p);break;
            case 'retrieveUserData':$this->retrieveUserData($u,$p,false);break;
            case 'retrieveUserDatas':$this->retrieveUserData($u,$p,true);break;
            case 'geia':$this->potionEffect($u,$p);break;
            case 'PVPQr':$this->pvpQueue($u,$p);break;
            case 'PVPIr':$this->pvpReply($u,$p);break;
            case 'loadHairShop':$this->hairShop($u,$p);break;
            case 'buyBagSlots':$this->buySlots($u,$p,'SlotsBag','intBagSpacePrice','intBagSpaceCap','buyBagSlots');break;
            case 'buyBankSlots':$this->buySlots($u,$p,'SlotsBank','intBankSpacePrice','intBankSpaceCap','buyBankSlots');break;
            case 'buyHouseSlots':$this->buySlots($u,$p,'SlotsHouse','intHouseSpacePrice','intHouseSpaceCap','buyHouseSlots');break;
            case 'buyLoadoutSlots':$this->buySlots($u,$p,'SlotsLoadout','intLoadoutSpacePrice',null,'buyLoadoutSlots');break;
            case 'ti':$this->tradeRequest($u,$p);break;
            case 'tia':$this->tradeAccept($u,$p);break;
            case 'tid':$this->tradeDecline($u,$p);break;
            case 'tradeCancel':$this->tradeCancel($u,$p,$cmd);break;
            case 'loadOffer':$this->tradeLoadOffer($u,$p);break;
            case 'tradeToInv':case 'tradeFromInv':case 'tradeSwapInventory':case 'tradeSwapInv':$this->tradeItems($u,$p,$cmd);break;
            case 'tradeLock':case 'tradeUnlock':$this->tradeLock($u,$p,$cmd==='tradeLock');break;
            case 'tradeDeal':$this->tradeDeal($u,$p);break;
            case 'loadWarVars':$this->loadWar($u,$p);break;
            case 'loadFactions':$this->sendFactions($u,'loadFactions');break;
            case 'spendStatPoints':$this->spendStatPoints($u,$p);break;
            case 'saveStatPoints':$this->saveStatPoints($u,$p);break;
            case 'resetStatPoints':$this->resetStatPoints($u);break;
            case 'loadHouseInventory':$this->sendHouseInventory($u);break;
            case 'getQuests2':$this->getQuests($u,$p,'getQuests2');break;
            case 'loadQuestStringData':$this->questStringData($u);break;
            case 'updateQuest':$this->updateQuestValue($u,$p);break;
            case 'enhanceItem':$this->enhanceItem($u,$p,'enhanceItem');break;
            case 'forceEquipItem':$this->equip($u,$p,true);break;
            case 'removeTempItem':$this->removeTempItem($u,$p);break;
            case 'retrieveMonData':$this->retrieveMonsterData($u,$p);break;
            case 'changeClass':$this->changeClass($u,$p);break;
            case 'setHomeTown':$this->setHomeTown($u,$p);break;
            case 'summonPet':$this->summonPet($u,$p);break;
            case 'getApop':$this->server->sendJson($u,['cmd'=>'getapop','apopData'=>null,'bQuests'=>false]);break;
            case 'mtcid':$this->server->sendJson($u,['cmd'=>'mtcid','bitSuccess'=>1]);break;
            case 'dungeonQueue':case 'dungeonRejoin':$this->server->sendJson($u,['cmd'=>$cmd,'bitSuccess'=>0,'msg'=>'Dungeon matchmaking is not enabled on this server.']);break;
            case 'castt':$this->server->sendJson($u,['cmd'=>'castt','bitSuccess'=>1]);break;
            case 'dynamic':$this->dynamicChat($u,$p);break;
            case 'getAdData':$this->server->sendJson($u,['cmd'=>'getAdData','bSuccess'=>0,'bitSuccess'=>0,'bh'=>null]);break;
            case 'getAdReward':$this->server->sendJson($u,['cmd'=>'getAdReward','bSuccess'=>0,'bitSuccess'=>0,'iGold'=>0,'iCoins'=>0]);break;
            case 'fbCmd':case 'rewardReferral':$this->server->sendJson($u,['cmd'=>$cmd,'bSuccess'=>0,'bitSuccess'=>0]);break;
            default:$this->compatibilityAck($u,$cmd);break;
        }
    }

    /** DragonBuff.java parity helper. The legacy Java RequestManage never registered
     *  this class as an XT route, but keeping the response behavior here prevents
     *  the dormant source class from being lost during the PHP port. */
    private function dragonBuff(ClientSession $u): void { $this->server->sendRaw($u,['Dragon Buff']); }

    private function firstJoin(ClientSession $u): void
    {
        $this->server->sendJson($u,['cmd'=>'cvu','o'=>$this->world->coreValues()]);
        $room=$u->level<=1&&$u->access<=30?'newbie':($u->access>=40?'limbo':'faroff');
        $this->server->joinGameRoom($u,$room,'Enter','Spawn');
    }
    private function move(ClientSession $u,array $p): void
    {
        $u->x=(int)($p[0]??0);$u->y=(int)($p[1]??0);if($u->positionDisplay)$u->lastPositionDisplayAt=0.0;
        $speed=(int)($p[2]??8);$dashFlag=((int)($p[3]??0)===1);
        // Aera v30.74: use BOTH the explicit fourth mv parameter and the actual
        // 3x dash speed as detection. Some client/protocol combinations were not
        // preserving the fourth parameter, which left server stamina at 100 while
        // the client spent it locally. That is why SP only appeared to recover when
        // an unrelated HP/MP regen packet happened.
        $dashBySpeed=$speed>=20;
        $dash=$dashFlag||$dashBySpeed;$dashCost=50;
        if($dash){
            $beforeSp=$u->stamina;
            if($u->stamina>=$dashCost){
                $u->stamina=max(0,$u->stamina-$dashCost);
                $this->log->info('Dash stamina: player='.$u->username.' before='.$beforeSp.' cost='.$dashCost.' after='.$u->stamina);
            }else{
                // Not enough server-side stamina: reject the sprint speed.
                $dash=false;$speed=min($speed,9);
                $this->log->info('Dash rejected: player='.$u->username.' stamina='.$beforeSp.' required='.$dashCost);
            }
        }
        // Any movement exits the server-side resting state.
        $u->resting=false;
        $r=$this->server->currentRoom($u);
        if($r){
            $this->server->broadcastRaw(['uotls',$u->username,"tx:{$u->x},ty:{$u->y},sp:{$speed},strFrame:{$u->frame}"],$r,$u);
        }
        if($dashFlag||$dashBySpeed){
            // Send the stamina authority directly to the moving player. Do not rely
            // on a room broadcast to repair the local HUD after the dash.
            $this->server->sendJson($u,['cmd'=>'ct','p'=>[$u->username=>['intSP'=>$u->stamina,'intState'=>$u->state]]]);
        }
    }
    private function moveToCell(ClientSession $u,array $p): void
    {
        $r=$this->server->currentRoom($u);
        // Java's MonsterAttack task drops a target as soon as its map frame no
        // longer matches the player's frame. Remove it immediately here too so
        // a monster cannot land one more scheduled hit after a cell transition.
        if($r){
            foreach($r->monsters as &$m)unset($m['targets'][$u->socketId]);
            unset($m);
        }
        $wasCombat=$u->state!==1;
        $u->frame=(string)($p[0]??'Enter');$u->pad=(string)($p[1]??'Spawn');$u->x=$u->y=0;if($u->positionDisplay)$u->lastPositionDisplayAt=0.0;$u->state=1;$u->targetMonster=null;$u->resting=false;
        if($r&&$wasCombat)$this->server->broadcastJson(['cmd'=>'ct','p'=>[$u->username=>['intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intState'=>1]]],$r);
        if($r)$this->server->broadcastRaw(['uotls',$u->username,"strPad:{$u->pad},tx:0,strFrame:{$u->frame},ty:0"],$r,$u);
        try{$this->db->run('UPDATE users SET LastArea=? WHERE id=?',[(preg_replace('/-\d+$/','',$u->roomName)?:$u->roomName).'|'.$u->frame.'|'.$u->pad,$u->dbId]);}catch(Throwable){}
    }
    /** Build the stock AQW chatm payload expected by Game.as:
     *  chatm, channel~message, username, SmartFox user id, room id, staff flag.
     *
     * aClient-04 Chat2 does not support administrator/gm as channel names, so
     * map chat always remains on `zone`. Staff rank belongs in the DISPLAY NAME
     * field instead of the message body. The patched Chat/Chat2 popBubble()
     * strips this display-only prefix for avatar lookup, which gives us:
     *   [Admin] Animu: hello   (text chat)
     *   hello                  (speech bubble)
     */
    private function chatPacket(?ClientSession $u,string $channel,string $message,?RoomState $room=null): array
    {
        if($room===null&&$u!==null)$room=$this->server->currentRoom($u);
        $displayName=$u?->username??'';
        // Staff display names are sent separately from the message body.
        // Capitalize the first username character so the text log renders
        // `[Admin] Animu: message` while the avatar lookup still resolves
        // against the canonical username after the client strips the prefix.
        if($u!==null&&$channel==='zone'&&$u->access>=40)$displayName=$this->staffChatNamePrefix($u).ucfirst($displayName);
        return ['chatm',$channel.'~'.$message,$displayName,(string)($u?->sfsUserId??0),(string)($room?->id??1),($u!==null&&$u->access>=40)?'1':'0'];
    }
    private function staffChatNamePrefix(ClientSession $u): string
    {
        if($u->access>=90)return '[GM] ';
        if($u->access>=60)return '[Admin] ';
        if($u->access>=40)return '[Mod] ';
        return '';
    }

    private function message(ClientSession $u,array $p): void
    {
        $message=trim((string)($p[0]??''));$channel=strtolower(trim((string)($p[1]??'zone')));if($message==='')return;
        if(!$this->chatAllowed($u))return;
        if(strlen(strip_tags($message))>150){$this->server->sendRaw($u,['warning','Unable to send. Your message is too long.']);return;}
        foreach($this->world->filters as $word=>$seconds)if($word!==''&&str_contains(strtolower($message),strtolower($word))){$this->server->muteSeconds($u,max(1,(int)$seconds));$this->server->sendRaw($u,['warning',$this->server->muteMessage($u)]);return;}
        if($u->access<40&&$this->containsUrl($message)){$this->server->mute($u,5);$this->server->sendRaw($u,['warning',$this->server->muteMessage($u)]);$this->server->sendRaw($u,['warning','Please refrain from posting this kind of message.']);return;}
        if($channel==='world'){
            if($u->access<=0){$this->server->sendRaw($u,['warning','Your account is currently disabled. Actions in-game are limited.']);return;}
            $this->server->broadcastRaw($this->chatPacket($u,'world',$message));
        }elseif($channel==='guild'){
            $gid=(int)($u->user['GuildID']??0);if($gid<=0){$this->server->sendRaw($u,['server','You are not in a guild.']);return;}foreach($this->server->clients() as $c)if((int)($c->user['GuildID']??0)===$gid)$this->server->sendRaw($c,$this->chatPacket($u,'guild',$message));
        }elseif($channel==='party'){
            $pid=$u->partyId;if($pid<=0||!isset($this->parties[$pid])){$this->server->sendRaw($u,['server','You are not in a party.']);return;}foreach($this->parties[$pid]['members'] as $c)$this->server->sendRaw($c,$this->chatPacket($u,'party',$message));
        }else{
            // aClient-04 Chat2 silently drops unknown administrator/gm channels.
            // Zone is understood by both chat implementations, so all normal
            // Map chat stays on the Chat2-compatible zone channel. Rank is
            // encoded in the display-name field by chatPacket(), never in text.
            $r=$this->server->currentRoom($u);if($r)$this->server->broadcastRaw($this->chatPacket($u,'zone',$message,$r),$r);
        }
        $this->server->applyMessageFlood($u,$message);
    }
    private function whisper(ClientSession $u,array $p): void
    {
        $message=trim((string)($p[0]??''));$to=trim((string)($p[1]??''));if($message===''||$to==='')return;if(!$this->chatAllowed($u))return;
        $t=$this->server->findUser($to);if(!$t){$this->server->sendRaw($u,['server','Player "'.strtolower($to).'" could not be found.']);return;}
        if(!SettingsCodec::allowed('bWhisper',$u,$t)){$this->server->sendRaw($u,['server','Player '.$t->username.' is not accepting PMs at this time.']);return;}
        if($t===$u){$this->server->sendRaw($u,['server','You cannot whisper yourself.']);return;}
        $escaped=str_replace(['#038:','&','"','<','>'],['&','&amp;','&quot;','&lt;','&gt;'],$message);$msg=['whisper',$escaped,$u->username,$t->username,'0',$u->access>=40?'1':'0'];$this->server->sendRaw($u,$msg);$this->server->sendRaw($t,$msg);$this->server->applyMessageFlood($u,$message);
    }
    private function chatAllowed(ClientSession $u): bool
    {
        if((int)($u->user['PermamuteFlag']??0)>0){$this->server->sendRaw($u,['warning','You are muted! Chat privileges have been permanently revoked.']);return false;}
        if($this->server->isMuted($u)){$this->server->sendRaw($u,['warning',$this->server->muteMessage($u)]);return false;}return true;
    }
    private function containsUrl(string $message): bool
    { return (bool)preg_match('~(?:https?://|ftp://|www\.)[^\s]+|\b[a-z0-9.-]+\.(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum|travel|[a-z]{2})(?:/[^\s]*)?~i',$message); }
    private function command(ClientSession $u,array $p): void
    {
        $cmd=strtolower(trim((string)($p[0]??'')));
        if($cmd==='')return;

        // Player commands from Java UserCommand.
        if($cmd==='tfer'){
            $room=strtolower(str_replace('battleon','faroff',(string)($p[2]??$p[1]??'faroff')));
            if(isset($p[1])&&strcasecmp((string)$p[1],$u->username)===0)$this->server->joinGameRoom($u,$room);
            return;
        }
        if($cmd==='goto'){
            if($u->access<=0){$this->server->sendRaw($u,['warning','Your account is currently disabled. Actions in-game are limited.']);return;}
            $name=(string)($p[1]??'');$t=$this->server->findUser($name);
            if(!$t){$this->server->sendRaw($u,['server','Player "'.$name.'" could not be found.']);return;}
            if($u->access<40&&!SettingsCodec::allowed('bGoto',$u,$t)){$this->server->sendRaw($u,['server',$t->username.' is ignoring goto requests.']);return;}
            $this->server->joinGameRoom($u,$t->roomName,$t->frame,$t->pad);return;
        }
        if($cmd==='who'){
            $r=$this->server->currentRoom($u);$users=[];
            if($r)foreach($r->clients as $c)$users[(string)$c->sfsUserId]=['iLvl'=>$c->level,'ID'=>$c->dbId,'sName'=>$c->username,'sClass'=>$this->className($c)];
            $this->server->sendJson($u,['cmd'=>'who','users'=>$users]);return;
        }
        if($cmd==='queuecount'){
            if(!$this->pvpQueues){$this->server->sendRaw($u,['server','There are no active Warzone queues.']);return;}
            foreach($this->pvpQueues as $warzone=>$queue){$map=$this->world->map($warzone);if(!$map)continue;$this->server->sendRaw($u,['server',$warzone.' queue: '.count($queue).'/'.(int)$map['MaxPlayers']]);}
            return;
        }
        if($cmd==='ignorelist')return; // Java keeps this as an intentionally empty compatibility command.
        if($cmd==='uopref'){
            $pref=(string)($p[1]??'');$value=filter_var($p[2]??true,FILTER_VALIDATE_BOOLEAN,FILTER_NULL_ON_FAILURE);if($value===null)$value=(string)($p[2]??'1')!=='0';
            $settings=SettingsCodec::set((int)($u->user['Settings']??0),$pref,$value);$this->db->run('UPDATE users SET Settings=? WHERE id=?',[$settings,$u->dbId]);$u->user['Settings']=$settings;
            $this->server->sendJson($u,['cmd'=>'loadPrefs','success'=>true,'result'=>['prefs'=>SettingsCodec::all($settings)]]);
            if(in_array($pref,['bHelm','bCloak'],true)){$room=$this->server->currentRoom($u);if($room){$key=$pref==='bHelm'?'showHelm':'showCloak';$this->server->broadcastJson(['cmd'=>'uotls','unm'=>$u->username,'o'=>[$key=>$value]],$room,$u);}}
            $messages=['bCloak'=>['Cloak Visibility On.','Cloak Visibility Off.'],'bHelm'=>['Helm Visibility On.','Helm Visibility Off.'],'bPet'=>['Pet Visibility On.','Pet Visibility Off.'],'bParty'=>['Accepting party invites.','Ignoring party invites.'],'bGoto'=>['Accepting goto requests.','Blocking goto requests.'],'bFriend'=>['Accepting Friend requests.','Ignoring Friend requests.'],'bWhisper'=>['Accepting PMs.','Ignoring PMs.'],'bTT'=>['Ability ToolTips will always show on mouseover.','Ability ToolTips will not show on mouseover during combat.'],'bDuel'=>['Accepting duel invites.','Ignoring duel invites.'],'bGuild'=>['Accepting guild invites.','Ignoring guild invites.'],'bTrade'=>['Accepting trade invites.','Ignoring trade invites.']];
            if(isset($messages[$pref]))$this->server->sendRaw($u,[$value?'server':'warning',$messages[$pref][$value?0:1]]);return;
        }
        if($cmd==='logout'){$this->server->gracefulLogout($u,'client logout');return;}
        if($cmd==='position'){
            $u->positionDisplay=!$u->positionDisplay;$u->lastPositionDisplayAt=0.0;
            if($u->positionDisplay)$this->server->sendRaw($u,['popup','blackbanner','Position  X: '.$u->x.'  Y: '.$u->y]);
            else $this->server->sendRaw($u,['popup','blackbanner','Position display OFF']);
            return;
        }

        // Java lets a normal player invoke /mute <minutes> on themselves.
        if($cmd==='mute'&&$u->access<40){if(!$this->server->isMuted($u)){$minutes=max(1,(int)($p[1]??1));$this->server->mute($u,$minutes);$this->server->sendRaw($u,['mute',$minutes*60000]);$this->server->sendRaw($u,['warning',$this->server->muteMessage($u)]);}return;}

        if($cmd==='count'){$this->server->sendRaw($u,['server',count(array_filter($this->server->clients(),fn($c)=>$c->authenticated)).' currently online right now.']);return;}
        if($cmd==='srates'){
            foreach(['exp'=>'Experience','rep'=>'Reputation','gold'=>'Gold','coins'=>'Coins','cp'=>'Class Points','drop'=>'Drop'] as $key=>$label)$this->server->sendRaw($u,['server',$label.': '.($this->world->rewardRates[$key]??1)]);return;
        }

        // Administrator commands (Java user.isAdmin()).
        if($u->access>=60){
            if($cmd==='shutdown'){
                if(!$this->server->scheduleShutdown(300,'/shutdown by '.$u->username))$this->server->sendRaw($u,['warning','There is already a shutdown or restart task going-on!']);
                return;
            }
            if($cmd==='shutdowncancel'){
                if($this->server->cancelShutdown())$this->server->broadcastRaw(['server','Server shutdown cancelled. You may continue playing.']);else$this->server->sendRaw($u,['warning','There is no shutdown task going-on!']);return;
            }
            if($cmd==='shutdownnow'){$this->server->broadcastRaw(['logoutWarning','','60']);$this->server->stopFromCommand();return;}
            if($cmd==='restart'){
                if(!$this->server->scheduleRestart(300,'/restart by '.$u->username))$this->server->sendRaw($u,['warning','There is already a shutdown or restart task going-on!']);return;
            }
            if($cmd==='restartcancel'){
                if($this->server->cancelRestart())$this->server->broadcastRaw(['server','Server restart cancelled. You may continue playing.']);else$this->server->sendRaw($u,['warning','There is no restart task going-on!']);return;
            }
            if($cmd==='restartnow'){$this->server->broadcastRaw(['logoutWarning','','60']);$this->server->requestRestart();return;}
            if($cmd==='rates'){
                $type=strtolower((string)($p[1]??''));$value=(int)($p[2]??0);if($value>20||$value<-20){$this->server->sendRaw($u,['warning','Rates cannot be higher than 20% or less than -20%.']);return;}
                $keys=$type==='all'?['gold','coins','drop','exp','rep','cp']:[$type];
                foreach($keys as $key){if(!array_key_exists($key,$this->world->rewardRates))continue;$this->world->rewardRates[$key]=$value;$label=['gold'=>'Gold','coins'=>'Coins','drop'=>'Drop','exp'=>'Experience','rep'=>'Reputation','cp'=>'Class Point'][$key];$msg=$value===1?($label.' rate has been set to normal.'):($label.' rate has been '.($value>0?'increased':'reduced').' by '.$value.'%.');$this->server->broadcastRaw(['server',$msg]);}
                return;
            }
            if($cmd==='promote'||$cmd==='demote'){
                $name=trim((string)($p[1]??''));$rankToken=trim((string)($p[2]??($cmd==='demote'?'player':'')));
                if($name===''||$rankToken===''){$this->server->sendRaw($u,['warning','Usage: /'.$cmd.' playername rank']);return;}
                $target=$this->db->one('SELECT id,Name,Access FROM users WHERE LOWER(Name)=LOWER(?) LIMIT 1',[$name]);
                if(!$target){$this->server->sendRaw($u,['warning','Player "'.strtolower($name).'" could not be found.']);return;}
                if((int)$target['id']===$u->dbId){$this->server->sendRaw($u,['warning','You cannot change your own staff rank.']);return;}
                $newAccess=$this->staffRankAccess($rankToken);if($newAccess===null){$this->server->sendRaw($u,['warning','Ranks: player, support, moderator, administrator, gm, owner.']);return;}
                $current=(int)$target['Access'];
                if($current>=$u->access){$this->server->sendRaw($u,['warning','You cannot change a player with an equal or higher rank.']);return;}
                if($newAccess>$u->access){$this->server->sendRaw($u,['warning','You cannot assign a rank higher than your own.']);return;}
                if($cmd==='promote'&&$newAccess<=$current){$this->server->sendRaw($u,['warning','/promote requires a higher rank than the player currently has.']);return;}
                if($cmd==='demote'&&$newAccess>=$current){$this->server->sendRaw($u,['warning','/demote requires a lower rank than the player currently has.']);return;}
                $result=$this->setPlayerAccess((int)$target['id'],$newAccess,'/'.$cmd.' by '.$u->username);
                $this->server->sendRaw($u,[!empty($result['ok'])?'server':'warning',(string)($result['message']??'Rank change failed.')]);return;
            }
            if($cmd==='ban'){$this->adminToggleBan($u,(string)($p[1]??''));return;}
            if($cmd==='addachievement'){$this->getAchievement($u,[(int)($p[1]??0)]);return;}
            if($cmd==='help'){
                foreach(['/shutdown /shutdowncancel','/restart /restartcancel','/rates (exp, drop, rep, cp, gold, coins, all) (multiplier)','/srates','/ban (username)','/promote (username) (support|moderator|administrator|gm|owner)','/demote (username) [player|support|moderator|administrator|gm]','/addachievement (id)'] as $line)$this->server->sendRaw($u,['server',$line]);
                // Java intentionally continues into moderatorCommand so admins also receive moderator help.
            }
        }

        // Moderator commands (also available to administrators).
        if($u->access>=40){
            if($cmd==='mute'){
                $a1=trim((string)($p[1]??''));$a2=trim((string)($p[2]??''));
                if($a1!==''&&ctype_digit($a1)){$minutes=max(1,(int)$a1);$name=$a2;}else{$name=$a1;$minutes=max(1,ctype_digit($a2)?(int)$a2:5);}
                $t=$this->server->findUser($name);if(!$t){$this->server->sendRaw($u,['warning','Player "'.strtolower($name).'" is not online.']);return;}
                if($t===$u){$this->server->sendRaw($u,['warning','Use /mute <minutes> without a username to mute yourself.']);return;}
                if($t->access>=40&&$t->access>=$u->access){$this->server->sendRaw($u,['warning','You cannot mute staff of an equal or higher rank.']);return;}
                if($u->dbId!==1&&$minutes>1440){$this->server->sendRaw($u,['warning','Cannot mute more than 24 hours.']);return;}
                if($this->server->isMuted($t)){$this->server->sendRaw($u,['warning','Player "'.strtolower($name).'" is already muted.']);return;}
                $this->server->mute($t,$minutes);$this->server->sendRaw($t,['mute',$minutes*60000]);$this->server->sendRaw($t,['warning',$this->server->muteMessage($t)]);$this->server->sendRaw($u,['server',$t->username.' muted for '.$minutes.' minute(s).']);$this->log->warn($u->username.' initiated mute: '.$t->username.' for '.$minutes.' minute(s)');return;
            }
            if($cmd==='unmute'){
                $name=(string)($p[1]??'');$t=$this->server->findUser($name);if(!$t){$this->server->sendRaw($u,['warning','Player "'.strtolower($name).'" is not online.']);return;}
                if($t->access>=40&&$t->access>=$u->access){$this->server->sendRaw($u,['warning','You cannot unmute staff of an equal or higher rank.']);return;}
                if($this->server->isMuted($t)){$this->server->sendRaw($t,['unmute']);$this->server->unmute($t);$this->server->sendRaw($u,['server',$t->username.' has been unmuted.']);}else $this->server->sendRaw($u,['server',$t->username.' is not muted.']);return;
            }
            if($cmd==='kick'){
                $t=$this->server->findUser((string)($p[1]??''));if(!$t)return;if($u->access<60&&$t->access>=40){$this->server->sendRaw($u,['warning','You cannot kick this user.']);return;}
                $reason=trim(implode(' ',array_slice($p,2)));if($reason==='')$reason='Kicked by '.$u->username.'.';$reason=substr($reason,0,250);$kickMessage='You were kicked by staff. Reason: '.$reason;
                $this->server->sendRaw($t,['warning',$kickMessage]);$this->server->sendRaw($t,['popup','messagebox',$kickMessage]);$this->server->sendRaw($t,['logoutWarning',$kickMessage,'5']);$t->kickReason=$reason;$t->kickGraceful=true;$t->kickAt=microtime(true)+5.5;return;
            }
            if($cmd==='clear'){
                $type=strtolower((string)($p[1]??''));$valid=['all','item','title','map','quest','shop','enhshop','setting'];if(!in_array($type,$valid,true)){$this->server->sendRaw($u,['server',"Unknown object type '{$type}', please type /help for more info."]);return;}
                $this->server->sendRaw($u,['server','Retrieving database objects..']);$this->world->reload();$this->server->sendRaw($u,['server','Server data cleared.']);return;
            }
            if($cmd==='reload'||$cmd==='reloadext'){
                $this->server->broadcastRaw(['server','Server refresh command has been initiated by the administrators. This process might interrupt your actions.']);
                if($cmd==='reloadext'){
                    // Java rebuilds monster-bearing rooms before reloading the extension.
                    $move=[];foreach($this->server->clients() as $client){$room=$this->server->currentRoom($client);if($room&&$room->monsters)$move[$client->socketId]=$client;}
                    foreach($move as $client){$this->server->sendRaw($client,['server','The map "'.$client->roomName.'" is being rebuilt. You may join again in a few moments.']);$this->server->joinGameRoom($client,'faroff');}
                    $this->server->sendRaw($u,['server','Reloading extension requests..']);
                }
                $this->world->reload();$this->server->sendRaw($u,['server','All extension requests successfully reloaded.']);return;
            }
            if($cmd==='emoteall'){
                $emote=(string)($p[1]??'');$room=$this->server->currentRoom($u);if($room)foreach($room->clients as $client)$this->server->sendRaw($client,['emotea',$emote,(string)$client->sfsUserId]);return;
            }
            if($cmd==='pull'){$this->staffPull($u,(string)($p[1]??''));return;}
            if($cmd==='iay'||$cmd==='adminyell'){
                $msg=trim(implode(' ',array_slice($p,1)));if($msg==='')return;
                if(str_starts_with($msg,'@')){$this->server->broadcastRaw(['server',ltrim(substr($msg,1))]);return;}
                // Aera v30.61: /iay has its own raw transport instead of piggybacking
                // on `moderator`.  This prevents the client from ever confusing an
                // Administrator/GameMaster announcement with normal Moderator chat.
                // Wire shape: %xt%iay%-1%Rank%Username%Message%
                $rank=$u->access>=90?'GameMaster':($u->access>=60?'Administrator':'Moderator');
                $this->server->broadcastRaw(['iay',$rank,$u->username,$msg]);
                return;
            }
            if($cmd==='changegender'){$this->genderSwap($u);$this->refreshLiveCommandState($u);return;}
            if($cmd==='addgold'){$amount=max(0,(int)($p[1]??0));$cap=(int)($this->world->rates['intGoldCap']??1000000);if($amount>$cap){$this->server->sendRaw($u,['warning','Cannot go more beyond '.number_format($cap).' currency.']);return;}$this->giveRewards($u,0,$amount,0,0,0,-1,$u->sfsUserId,'p');$this->refreshLiveCommandState($u);return;}
            if($cmd==='addcoins'){$amount=max(0,(int)($p[1]??0));$cap=(int)($this->world->rates['intCoinsCap']??1000000);if($amount>$cap){$this->server->sendRaw($u,['warning','Cannot go more beyond '.number_format($cap).' currency.']);return;}$this->giveRewards($u,0,0,$amount,0,0,-1,$u->sfsUserId,'p');$this->refreshLiveCommandState($u);return;}
            if($cmd==='addcp'){$amount=max(0,(int)($p[1]??0));if($amount>302500){$this->server->sendRaw($u,['warning','Cannot go more beyond 302,500 class points.']);return;}$this->giveRewards($u,0,0,0,$amount,0,-1,$u->sfsUserId,'p');$this->refreshLiveCommandState($u);return;}
            if($cmd==='addxp'){$this->giveRewards($u,max(0,(int)($p[1]??0)),0,0,0,0,-1,$u->sfsUserId,'p');$this->refreshLiveCommandState($u);return;}
            if($cmd==='addreps'||$cmd==='addrep'){$this->giveRewards($u,0,0,0,0,max(0,(int)($p[2]??0)),(int)($p[1]??-1),$u->sfsUserId,'p');$this->refreshLiveCommandState($u);return;}
if($cmd==='level'){
    $max=max(1,(int)($this->world->rates['intLevelMax']??100));$lvl=max(1,min($max,(int)($p[1]??1)));$oldLevel=$u->level;$award=max(0,$lvl-$oldLevel)*3;$pointsAfter=0;
    $this->db->tx(function(Database $db)use($u,$lvl,$award,&$pointsAfter){
        $this->ensureUserStats($u,$db);$db->run('UPDATE users SET Level=?,Exp=0 WHERE id=?',[$lvl,$u->dbId]);
        if($award>0)$db->run('UPDATE users_stats SET Points=Points+? WHERE UserID=?',[$award,$u->dbId]);
        $pointsAfter=(int)$db->scalar('SELECT Points FROM users_stats WHERE UserID=?',[$u->dbId],0);
    });
    $u->level=$lvl;$u->user['Level']=$lvl;$u->user['Exp']=0;$this->sendStats($u,true);$this->server->sendJson($u,['cmd'=>'levelUp','intLevel'=>$lvl,'intExpToLevel'=>$this->math->expToLevel($lvl),'xp'=>0,'StatPointsAwarded'=>$award,'StatPoints'=>$pointsAfter]);$this->refreshLiveCommandState($u);return;
}
            if($cmd==='item'){$this->adminGiveItem($u,(int)($p[1]??0),max(1,(int)($p[2]??1)));return;}
            if($cmd==='giveitem'){
                $itemId=(int)($p[1]??0);$name=trim((string)($p[2]??''));$qty=max(1,(int)($p[3]??1));
                if($itemId<=0||$name===''){$this->server->sendRaw($u,['warning','Usage: /giveitem itemid playername [quantity]']);return;}
                $target=$this->db->one('SELECT id,Name FROM users WHERE LOWER(Name)=LOWER(?) LIMIT 1',[$name]);
                if(!$target){$this->server->sendRaw($u,['warning','Player "'.strtolower($name).'" could not be found.']);return;}
                $result=$this->grantItemToPlayer((int)$target['id'],$itemId,$qty,'/giveitem by '.$u->username);
                if(empty($result['ok'])){$this->server->sendRaw($u,['warning',(string)($result['message']??'Could not give item.')]);return;}
                $this->server->sendRaw($u,['server','Gave '.(int)$result['quantity'].' x '.$result['item'].' to '.$result['player'].(!empty($result['online'])?' (live).':' (saved for next login).')]);return;
            }
            if($cmd==='help'){
                foreach(['/position (toggle live X/Y display)','/kick (username) [reason]','/mute (username) [minutes] or /mute (minutes) (username)','/unmute (username)','/promote (username) (rank)','/demote (username) [rank]','/clear (map, shop, quest, item, enhshop, setting, all)','/pull (username)','/iay (message)','/emoteall (emote)','/count','/item (item id) (quantity)','/giveitem (item id) (player name) [quantity]','/addgold, /addcp, /addxp, /addcoins (amount)','/addreps (faction id) (amount)','/level (level)','/changegender'] as $line)$this->server->sendRaw($u,['server',$line]);return;
            }
        }
    }

    private function staffPull(ClientSession $staff,string $name): void
    {
        $target=$this->server->findUser($name);if(!$target){$this->server->sendRaw($staff,['warning','Player "'.strtolower($name).'" could not be found.']);return;}
        if($target->access>=60&&$staff->access<60){$this->server->sendRaw($staff,['warning','Invalid /pull request.']);return;}
        if($target->roomId!==$staff->roomId){$this->server->joinGameRoom($target,$staff->roomName,$staff->frame,$staff->pad);return;}
        $room=$this->server->currentRoom($staff);if(!$room)return;
        foreach($room->monsters as &$m)unset($m['targets'][$target->socketId]);unset($m);
        if($target->frame!==$staff->frame){
            $target->frame=$staff->frame;$target->pad=$staff->pad;$target->x=$target->y=0;$target->state=1;$target->targetMonster=null;
            $this->server->sendJson($target,['cmd'=>'MoveToCellTrack','bitSuccess'=>1,'Frame'=>$staff->frame,'Cell'=>$staff->pad]);
            $this->server->broadcastRaw(['uotls',$target->username,"strPad:{$target->pad},tx:0,strFrame:{$target->frame},ty:0"],$room,$target);return;
        }
        $target->x=$staff->x+($target->x>$staff->x?-80:80);$target->y=$staff->y;
        $this->server->broadcastRaw(['uotls',$target->username,"tx:{$target->x},ty:{$target->y},sp:32,strFrame:{$target->frame}"],$room);
    }

    private function adminToggleBan(ClientSession $staff,string $name): void
    {
        $name=trim($name);if($name==='')return;
        $row=$this->db->one('SELECT id,Name,Access FROM users WHERE LOWER(Name)=LOWER(?) LIMIT 1',[$name]);
        if(!$row){$this->server->sendRaw($staff,['warning','Player "'.strtolower($name).'" could not be found.']);return;}
        $id=(int)$row['id'];$access=(int)$row['Access'];
        if($access<=0){$this->db->run('UPDATE users SET Access=1 WHERE id=?',[$id]);if($live=$this->server->findUserByDbId($id)){$live->access=1;$live->user['Access']=1;}$detail='User '.strtolower((string)$row['Name']).' unbanned by '.$staff->username.'.';$this->server->sendRaw($staff,['server','User '.strtolower((string)$row['Name']).' has been unbanned.']);}
        else{
            if($access>=40){$this->server->sendRaw($staff,['warning','Invalid /modban request.']);return;}
            $this->db->run('UPDATE users SET Access=0 WHERE id=?',[$id]);if($live=$this->server->findUserByDbId($id))$this->server->disconnect($live,'banned by '.$staff->username);$detail='User '.strtolower((string)$row['Name']).' banned by '.$staff->username.'.';$this->server->sendRaw($staff,['server','User '.strtolower((string)$row['Name']).' has been banned.']);
        }
        try{$this->db->run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$staff->dbId,'Modban initiated',$detail]);}catch(Throwable){}
    }
    private function aggro(ClientSession $u,array $p): void
    {
        $r=$this->server->currentRoom($u);if(!$r)return;
        $now=microtime(true);$last=null;
        // Java AggroMonster walks every MonMapID in params, not only the first.
        foreach($p as $raw){$id=(int)$raw;if($id<=0||!isset($r->monsters[$id]))continue;if((string)$r->monsters[$id]['Frame']!==$u->frame)continue;$u->resting=false;$r->monsters[$id]['targets'][$u->socketId]=true;$r->monsters[$id]['lastCombat']=$now;if((int)$r->monsters[$id]['state']!==0)$r->monsters[$id]['state']=2;$last=$id;}
        if($last!==null){$u->targetMonster=$last;$u->state=2;}
    }
    private function action(ClientSession $u,array $p): void
    {
        $actId=(int)($p[0]??1);
        $rawTargetInfo=trim((string)($p[1]??''));
        $r=$this->server->currentRoom($u);
        if(!$r||$u->state===0||$u->hp<=0||($r->meta['pvp']['done']??false)||$rawTargetInfo==='')return;
        $u->resting=false;

        // Stock packet format: aa>m:1,a1>m:2.  Self-target skills may legally
        // arrive as "a3>"; resolve the skill before deciding whether a target is
        // missing so buffs are not discarded by the server.
        $segments=array_values(array_filter(array_map('trim',explode(',',$rawTargetInfo)),fn($v)=>$v!==''));
        if(!$segments)return;
        $first=explode('>',$segments[0],2);
        $skillRef=strtolower(trim((string)($first[0]??'')));
        if($skillRef==='')return;

        $skill=$this->skillForUser($u,$skillRef);
        if(!$skill)return;
        // Compatibility guard for live databases that have not yet imported the
        // v30.62/v30.63 SQL. These baseline abilities are intrinsically self
        // buffs and must never inherit their old hostile/friendly damage route.
        $forcedSelfBuff=in_array(strtolower(trim((string)($skill['Name']??''))),['prepared strike','on guard','fortune'],true);
        $targetMode=$forcedSelfBuff?'s':strtolower(trim((string)($skill['Target']??'h')));
        if(!in_array($targetMode,['h','f','s'],true))$targetMode='h';

        $targetSpecs=[];
        foreach($segments as $seg){$parts=explode('>',$seg,2);if(isset($parts[1])&&trim($parts[1])!=='')$targetSpecs[]=trim($parts[1]);}
        if($targetMode==='s')$targetSpecs=['p:'.$u->sfsUserId];
        elseif(!$targetSpecs&&$targetMode==='f')$targetSpecs=['p:'.$u->sfsUserId];
        elseif(!$targetSpecs&&$u->targetMonster!==null)$targetSpecs[]='m:'.$u->targetMonster;
        if(!$targetSpecs)return;

        // Java Action.hasDuplicates(): duplicate targets are a packet-edit exploit.
        if(count(array_unique($targetSpecs,SORT_STRING))!==count($targetSpecs)){
            try{$this->db->run('UPDATE users SET Access=0,PermamuteFlag=1 WHERE id=?',[$u->dbId]);}catch(Throwable){}
            $this->log->warn('Packet Edit [gar] player='.$u->username.' duplicate targets='.implode(',',$targetSpecs));
            $this->server->sendRaw($u,['logoutWarning','','65']);$this->server->disconnect($u,'duplicate gar targets');return;
        }
        $targetInfo=implode(',',$targetSpecs);

        // Respect active stun/stone/disabled auras server-side too.  The stock
        // client already blocks these, but the server must not trust a forged gar.
        $now=microtime(true);
        if($this->playerActionLocked($u,$now))return;

        // Action.getSkill() consumes the inventory item whose Meta points to an
        // i1 potion/scroll skill. The earlier PHP port registered geia skills but
        // never turned the item in, allowing unlimited potion use.
        if(strtolower((string)($skill['Reference']??''))==='i1'){
            $consumeId=(int)$this->db->scalar('SELECT id FROM items WHERE Meta=? ORDER BY id LIMIT 1',[(string)(int)$skill['id']],0);
            if($consumeId<=0||!$this->turnInQuestItems($u,[['ItemID'=>$consumeId,'Quantity'=>1]],1)){
                $this->recordViolation($u,'Suspicious TurnIn [Action]','Potion/scroll skill '.(int)$skill['id'].' was used without its required inventory item.');
                return;
            }
        }
        $rank=$this->rankFromClassPoints($this->classPoints($u));
        if(($skillRef==='a2'&&$rank<2)||($skillRef==='a3'&&$rank<3)||($skillRef==='a4'&&$rank<5))return;

        // The AS3 client applies $cmc to the visible mana cost and $tha to the
        // cooldown.  Honor both so aura-driven mana/haste changes are real.
        $manaBase=max(0,(int)$skill['Mana']);
        $mana=(int)round($manaBase*max(.10,(float)($u->stats['$cmc']??1.0)));
        if($u->mp<$mana){$this->server->sendRaw($u,['warning','You do not have enough mana to use that skill.']);return;}
        $haste=max(-1.0,min(.50,(float)($u->stats['$tha']??0.0)));
        $cd=(max(0,(int)$skill['Cooldown'])/1000.0)*(1.0-$haste);
        // Java accepts the request after cooldown - cooldown/2 - 500ms.
        $minGap=max(0.0,$cd/2.0-0.5);
        if(isset($u->cooldowns[$skillRef])&&$now-$u->cooldowns[$skillRef]<$minGap){$this->server->sendRaw($u,['warning','Action taken too quickly, try again in a moment.']);return;}
        $u->cooldowns[$skillRef]=$now;
        $u->mp-=$mana;

        $results=[];$mUpdate=[];$pUpdate=[];$granted=false;$pvpResult=null;
        $maxTargets=max(1,(int)$skill['HitTargets']);
        $isPvp=(int)($r->map['PvP']??0)===1;
        $processed=0;
        $from='p:'.$u->sfsUserId;
        $school=$this->skillDamageSchool($skill,$u);
        $skillDamage=$forcedSelfBuff?0.0:(float)$skill['Damage'];

        // Prepared Strike is a two-charge self aura.  Its cast records whether
        // On Guard was active.  Each subsequent valid Auto Attack is guaranteed
        // to crit; guarded casts also double those two Auto Attacks.
        $preparedAuraId=null;$preparedDouble=false;$preparedUsed=false;
        if($skillRef==='aa'){
            $prepared=$this->activePlayerAuraByName($u,'Prepared Strike',$now);
            if($prepared!==null&&(int)($prepared['aura']['charges']??0)>0){
                $preparedAuraId=$prepared['id'];
                $preparedDouble=(bool)($prepared['aura']['guarded']??false);
            }
        }

        foreach($targetSpecs as $spec){
            if($processed>=$maxTargets)break;
            if(!preg_match('/^(m|p):(\d+)$/i',$spec,$tm))continue;
            $kind=strtolower($tm[1]);$id=(int)$tm[2];
            if($kind==='m'){
                // Friendly/self skills can never be redirected to monsters.
                if($targetMode!=='h')continue;
                if(!isset($r->monsters[$id]))continue;
                $m=&$r->monsters[$id];if($m['state']===0){unset($m);continue;}
                $u->targetMonster=$id;$u->state=2;$m['targets'][$u->socketId]=true;$m['lastCombat']=$now;$m['state']=2;

                $type=$preparedAuraId!==null?'crit':$this->combat->damageType($this->combat->playerHitChance($u),0.20,(float)($u->stats['$tcr']??0.05));
                $damage=(int)($this->combat->randomDamage($type,$u->maxDmg,$u->minDmg,$this->combat->weaponDps($u))*$skillDamage);
                if($damage>0){
                    $damage=$this->combat->playerOutgoing($damage,$u,$now,$school);
                    $dmgAll=$this->combat->equipmentMeta($u,'dmgall',-1.0,5.0);if($dmgAll!=0.0)$damage=(int)round($damage*max(0.0,1.0+$dmgAll));
                    if($preparedAuraId!==null&&$preparedDouble)$damage*=2;
                    $damage=$this->combat->monsterIncoming($damage,(array)($m['auras']??[]),$now,$school);
                    if((float)$m['DamageReduction']>0)$damage=(int)round($damage*max(0.0,1.0-(float)$m['DamageReduction']));
                }
                if($damage>=0)$m['HP']=max(0,(int)$m['HP']-$damage);else$m['HP']=min((int)$m['HPMax'],(int)$m['HP']-$damage);
                if(!$granted&&$skillRef==='aa'&&$damage>0&&in_array($type,['hit','crit'],true)){$u->mp=min($u->mpMax,$u->mp+($type==='crit'?(int)$this->config->get('basic_crit_mana',6):(int)$this->config->get('basic_hit_mana',4)));$granted=true;}
                if($m['HP']<=0){
                    $rewardTargets=array_keys($m['targets']);$m['state']=0;$m['auras']=[];$m['dots']=[];$m['respawnAt']=$now+max(1,(int)$m['Respawn']);
                    foreach($rewardTargets as $sid){$member=$r->clients[$sid]??null;if($member){$member->state=1;$member->targetMonster=null;$this->rewardMonster($member,$m);}}
                    $m['targets']=[];if($u->targetMonster===$id)$u->targetMonster=null;$u->state=1;
                    if($isPvp){[$score,$event]=$this->pvpMonsterScore((string)$m['Name'],(int)$m['Level']);if($event!==null)$this->server->broadcastJson(['cmd'=>'PVPE','typ'=>'kill','team'=>$u->pvpTeam,'val'=>$event],$r);$pvpResult=$this->addPvpScore($r,$u->pvpTeam,$score,$now);}
                }
                $results[]=['hp'=>$damage,'cInf'=>$from,'tInf'=>'m:'.$id,'type'=>$type];
                $mUpdate[(string)$id]=['intHP'=>$m['HP'],'intHPMax'=>$m['HPMax'],'intMP'=>$m['MP'],'intMPMax'=>$m['MPMax'],'intState'=>$m['state'],'targets'=>array_keys($m['targets'])];
                $processed++;if($preparedAuraId!==null)$preparedUsed=true;unset($m);continue;
            }

                // A self-target packet carries the local SmartFox id (for example
            // a3>p:1). Resolve that directly to the executing session instead of
            // looking it back up through the global user list. This removes the
            // race that was consuming mana and leaving the action locked when a
            // self buff was used outside active monster combat.
            $target=($id===$u->sfsUserId)?$u:$this->server->findUserBySfsId($id);
            if(!$target||$target->roomId!==$r->id||$target->frame!==$u->frame||$target->state===0)continue;
            // Target mode validation must be one mutually-exclusive chain.
            // v30.63 accidentally used a second standalone `if`, so Target='s'
            // passed the self check and then fell into the hostile `else`, where
            // target===caster was rejected. That produced the exact live warning
            // `a3/a4 -> p:1: no valid target` even though self resolution worked.
            if($targetMode==='s'){
                if($target!==$u)continue;
            }elseif($targetMode==='f'){
                if($isPvp&&$target->pvpTeam!==$u->pvpTeam)continue;
            }else{ // hostile
                if($target===$u||!$isPvp||$target->pvpTeam===$u->pvpTeam)continue;
            }

            // A zero-damage friendly/self action is not a physical hit.  The
            // stock client uses DamageType.NONE for this case; using HIT made the
            // avatar play damage/wound behavior and also tied aura application to
            // attack-result semantics. The aura path below explicitly accepts
            // NONE for non-hostile skills.
            $damage=0;$type='none';
            if($skillDamage>0.0){
                $type=$preparedAuraId!==null?'crit':$this->combat->damageType($this->combat->playerHitChance($u),(float)($target->stats['$tdo']??0.04),(float)($u->stats['$tcr']??0.05));
                $damage=(int)($this->combat->randomDamage($type,$u->maxDmg,$u->minDmg,$this->combat->weaponDps($u))*$skillDamage);
                $damage=$this->combat->playerOutgoing($damage,$u,$now,$school);
                $dmgAll=$this->combat->equipmentMeta($u,'dmgall',-1.0,5.0);if($dmgAll!=0.0)$damage=(int)round($damage*max(0.0,1.0+$dmgAll));
                if($preparedAuraId!==null&&$preparedDouble)$damage*=2;
                $damage=$this->combat->playerIncoming($damage,$target,$now,$school);
                $reduction=$this->combat->equipmentMeta($target,'dmgtaken',-1.0,.90);if($reduction!=0.0)$damage=(int)round($damage*max(0.0,1.0-$reduction));
            }elseif($skillDamage<0.0){
                $heal=(int)round($this->combat->randomDamage('hit',$u->maxDmg,$u->minDmg,$this->combat->weaponDps($u))*abs($skillDamage));
                $heal=$this->combat->playerHealingOutgoing($heal,$u);
                $heal=$this->combat->playerHealingIncoming($heal,$target);
                $damage=-$heal;
            }

            if($damage>=0)$target->hp=max(0,$target->hp-$damage);else$target->hp=min($target->hpMax,$target->hp-$damage);
            $target->state=$target->hp<=0?0:($damage>0?2:$target->state);
            if($target!==$u&&$damage>0)$u->state=2;
            if(!$granted&&$skillRef==='aa'&&$damage>0){$u->mp=min($u->mpMax,$u->mp+($type==='crit'?(int)$this->config->get('basic_crit_mana',6):(int)$this->config->get('basic_hit_mana',4)));$granted=true;}
            if($target->hp<=0){$target->respawnAt=$now+8.0;$u->state=1;if($isPvp&&$target!==$u){$u->user['KillCount']=(int)($u->user['KillCount']??0)+1;$target->user['DeathCount']=(int)($target->user['DeathCount']??0)+1;try{$this->db->tx(function(Database $db)use($u,$target){$db->run('UPDATE users SET KillCount=KillCount+1 WHERE id=?',[$u->dbId]);$db->run('UPDATE users SET DeathCount=DeathCount+1 WHERE id=?',[$target->dbId]);});}catch(Throwable $e){$this->log->warn('PvP score persistence failed: '.$e->getMessage());}$pvpResult=$this->addPvpScore($r,$u->pvpTeam,1000,$now);}}
            $results[]=['hp'=>$damage,'cInf'=>$from,'tInf'=>'p:'.$target->sfsUserId,'type'=>$type];
            $pUpdate[$target->username]=['intHP'=>$target->hp,'intHPMax'=>$target->hpMax,'intMP'=>$target->mp,'intMPMax'=>$target->mpMax,'intState'=>$target->state];
            $processed++;if($preparedAuraId!==null)$preparedUsed=true;
        }
        if(!$results){
            // Never strand an action icon in its locked/black state. The client
            // locks as soon as it sends gar and only unlocks after an action
            // result. If target validation fails after mana/cooldown were taken,
            // refund the cast and send the stock iRes=0 acknowledgement.
            $u->mp=min($u->mpMax,$u->mp+$mana);
            unset($u->cooldowns[$skillRef]);
            $this->log->warn('Combat action produced no valid target: player='.$u->username.' skill='.$skillRef.' target='.$targetInfo.'; refunded and unlocked.');
            $this->server->sendJson($u,['cmd'=>'ct','p'=>[$u->username=>['intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intState'=>$u->state]],'sarsa'=>[['cInf'=>$from,'a'=>[],'actID'=>$actId,'iRes'=>0]]]);
            return;
        }

        if($isPvp&&$pvpResult===null)$pvpResult=$this->pvpScorePacket($r);
        $pUpdate[$u->username]=['intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intState'=>$u->state];
        $ct=['cmd'=>'ct','p'=>$pUpdate,'anims'=>[['strFrame'=>$u->frame,'cInf'=>$from,'fx'=>$skill['Effects'],'tInf'=>$targetInfo,'animStr'=>$skill['Animation']]]];
        if((string)($skill['Strl']??'')!=='')$ct['anims'][0]['strl']=$skill['Strl'];
        if($mUpdate)$ct['m']=$mUpdate;
        $auras=$this->skillAuraEvents((int)$skill['id'],$from,$results,$r,$now,$u);if($auras)$ct['a']=$auras;
        if($pvpResult)$ct['pvp']=$pvpResult;
        $sarsa=[['cInf'=>$from,'a'=>$results,'actID'=>$actId,'iRes'=>1]];
        if($isPvp){$ct['sarsa']=$sarsa;$this->server->broadcastJson($ct,$r);}
        else{$this->server->broadcastJson($ct,$r,$u);$ct['sarsa']=$sarsa;$this->server->sendJson($u,$ct);}
        // Consume after the action packet so the second guaranteed crit is shown
        // before the client receives the Prepared Strike fade event.
        if($preparedAuraId!==null&&$preparedUsed)$this->consumePreparedStrike($u,$preparedAuraId);
    }
    private function playerActionLocked(ClientSession $u,float $now): bool
    {
        foreach($u->auras as $a){
            if(!is_array($a))continue;
            $expires=(float)($a['expiresAt']??0.0);if($expires>0.0&&$expires<=$now)continue;
            if(in_array(strtolower((string)($a['cat']??'')),['stun','stone','disabled'],true))return true;
        }
        return false;
    }

    private function skillDamageSchool(array $skill,ClientSession $u): string
    {
        $typ=strtolower(trim((string)($skill['Type']??'')));
        if($typ==='m')return 'magic';
        if($typ==='p'||$typ==='aa')return 'physical';
        return $this->combat->playerDamageSchool($u);
    }

    /** @return array{id:int,aura:array}|null */
    private function activePlayerAuraByName(ClientSession $u,string $name,float $now): ?array
    {
        foreach($u->auras as $id=>$a){
            if(!is_array($a)||strcasecmp((string)($a['nam']??''),$name)!==0)continue;
            $expires=(float)($a['expiresAt']??0.0);if($expires>0.0&&$expires<=$now)continue;
            return ['id'=>(int)($a['id']??$id),'aura'=>$a];
        }
        return null;
    }

    private function consumePreparedStrike(ClientSession $u,int $auraId): void
    {
        $a=$u->auras[$auraId]??null;if(!is_array($a))return;
        $charges=max(0,(int)($a['charges']??0)-1);
        if($charges<=0){$this->removePlayerAura($u,$auraId,true);return;}
        $u->auras[$auraId]['charges']=$charges;
    }

    private function pvpMonsterScore(string $name,int $level): array
    { foreach(['Restorer'=>50,'Brawler'=>25,'Captain'=>1000,'General'=>100,'Knight'=>100] as $word=>$score)if(str_contains($name,$word))return[$score,$word];return[max(1,$level),null]; }
    private function addPvpScore(RoomState $room,int $team,int $score,float $now): array
    {
        if(!($room->meta['pvp']['done']??false)){
            $room->meta['pvp']['scores'][$team]=min(1000,(int)($room->meta['pvp']['scores'][$team]??0)+max(0,$score));
            if($room->meta['pvp']['scores'][$team]>=1000){
                $room->meta['pvp']['done']=true;
                $this->awardPvpMapDrops($room);
                $this->server->schedulePvpExit($room,$now);
            }
        }
        return $this->pvpScorePacket($room);
    }
    private function pvpScorePacket(RoomState $room): array { return $this->server->pvpResultPacket($room); }
    private function awardPvpMapDrops(RoomState $room): void
    {
        // Rooms.processScore() drops every map item to team 1 in the legacy
        // emulator. Preserve that observable behavior, including the drop UI.
        $mapId=(int)($room->map['id']??0);if($mapId<=0)return;
        $rows=$this->world->mapItems[$mapId]??[];
        foreach($room->clients as $member){if($member->pvpTeam!==1)continue;foreach($rows as $row){$item=$this->world->items[(int)$row['ItemID']]??null;if($item)$this->queueRewardItem($member,$item,1);}}
    }
    private function skillForUser(ClientSession $u,string $ref): ?array
    {
        // GetPotionEffect.java adds potion/scroll skills into the same runtime
        // ref -> SkillID map used by Action. Resolve those injected refs first.
        $dynId=(int)($u->dynamicSkills[strtolower($ref)]??0);
        if($dynId>0){$row=$this->db->one('SELECT * FROM skills WHERE id=?',[$dynId]);if($row)return $row;}
        // Java loadSkills() inserts class refs first, then the equipped weapon's
        // special skill into the same ref->SkillID map. Query weapon first here
        // so an identical reference has the same overwrite behavior.
        $weapon=$this->db->one("SELECT ui.ItemID FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0 AND i.Equipment='Weapon' LIMIT 1",[$u->dbId]);
        if($weapon){$row=$this->db->one('SELECT s.* FROM items_skills x INNER JOIN skills s ON s.id=x.SkillID WHERE x.ItemID=? AND LOWER(s.Reference)=LOWER(?) LIMIT 1',[(int)$weapon['ItemID'],$ref]);if($row)return $row;}
        $class=$this->equippedClass($u);
        if($class){$row=$this->db->one('SELECT s.* FROM skills_assign sa INNER JOIN skills s ON s.id=sa.SkillID WHERE sa.ItemID=? AND LOWER(s.Reference)=LOWER(?) LIMIT 1',[(int)$class['ItemID'],$ref]);if($row)return $row;}
        return null;
    }
    private function equippedClass(ClientSession $u): ?array
    {
        return $this->db->one("SELECT ui.ItemID,ui.Quantity AS iCP,i.Name AS sClassName,i.Element AS sElement,c.Category AS sClassCat,c.Description AS sClassDesc,c.ManaRegenerationMethods AS aMRM,c.StatsDescription AS sStats FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID INNER JOIN classes c ON c.ItemID=i.id WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0 AND i.Equipment='ar' ORDER BY ui.id DESC LIMIT 1",[$u->dbId]);
    }
    private function classPoints(ClientSession $u): int { $c=$this->equippedClass($u);return max(0,(int)($c['iCP']??0)); }
    private function rankFromClassPoints(int $cp): int
    {
        $ranks=array_fill(0,10,0);for($i=1;$i<count($ranks);$i++){$rankExp=(int)(pow($i+1,3)*100);$ranks[$i]=$i>1?$rankExp+$ranks[$i-1]:$rankExp+100;}
        for($i=1;$i<count($ranks);$i++)if($cp<$ranks[$i])return $i;return 10;
    }
    private function skillActionObject(array $skill,int $rank): array
    {
        $o=['anim'=>(string)$skill['Animation'],'cd'=>(string)(int)$skill['Cooldown'],'damage'=>(float)$skill['Damage'],'desc'=>(string)$skill['Description'],'fx'=>(string)$skill['Effects'],'icon'=>(string)$skill['Icon'],'id'=>(int)$skill['id'],'isOK'=>true,'mp'=>(string)(int)$skill['Mana'],'nam'=>(string)$skill['Name'],'range'=>(string)(int)$skill['Range'],'ref'=>(string)$skill['Reference'],'tgt'=>(string)$skill['Target'],'typ'=>(string)$skill['Type']];
        if((string)($skill['Dsrc']??'')!=='')$o['dsrc']=$skill['Dsrc'];if((string)($skill['Strl']??'')!=='')$o['strl']=$skill['Strl'];
        if(($o['ref']==='a2'&&$rank<2)||($o['ref']==='a3'&&$rank<3)||($o['ref']==='a4'&&$rank<5))$o['isOK']=false;
        if((int)$skill['HitTargets']>0){$o['tgtMax']=(string)(int)$skill['HitTargets'];$o['tgtMin']='1';}
        if($o['ref']==='aa'){$o['auto']=true;$o['typ']='aa';}
        return $o;
    }
    private function sendClassActions(ClientSession $u,bool $sendClassUpdate=true): void
    {
        $class=$this->equippedClass($u);if(!$class)return;$cp=max(0,(int)$class['iCP']);$rank=$this->rankFromClassPoints($cp);
        if($sendClassUpdate){
            $mrm=(string)$class['aMRM'];$mrmOut=str_contains($mrm,':')?array_map(fn($x)=>$x."\r",explode(',',$mrm)):$mrm;
            $this->server->sendJson($u,['cmd'=>'updateClass','iCP'=>$cp,'sClassCat'=>$class['sClassCat'],'sDesc'=>$class['sClassDesc'],'sStats'=>$class['sStats'],'uid'=>$u->sfsUserId,'aMRM'=>$mrmOut,'sClassName'=>$class['sClassName']]);
            $room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson(['cmd'=>'updateClass','iCP'=>$cp,'sClassCat'=>$class['sClassCat'],'sClassName'=>$class['sClassName'],'uid'=>$u->sfsUserId],$room,$u);
        }
        // Java loadSkills() clears the ref->SkillID map and every timed aura
        // before rebuilding class/passive/weapon actions.
        $u->dynamicSkills=[];$u->auras=[];$u->dots=[];$u->passiveAuras=[];
        $active=array_fill(0,6,null);$passive=[];
        $skills=$this->db->all('SELECT s.* FROM skills_assign sa INNER JOIN skills s ON s.id=sa.SkillID WHERE sa.ItemID=? ORDER BY sa.id',[(int)$class['ItemID']]);
        foreach($skills as $skill){$ref=(string)$skill['Reference'];if(strcasecmp((string)$skill['Type'],'passive')===0){$passive[]=['desc'=>$skill['Description'],'fx'=>$skill['Effects'],'icon'=>$skill['Icon'],'id'=>(int)$skill['id'],'nam'=>$skill['Name'],'range'=>(int)$skill['Range'],'ref'=>$ref,'tgt'=>$skill['Target'],'typ'=>$skill['Type'],'auras'=>[[]],'isOK'=>$rank>=4];continue;}$o=$this->skillActionObject($skill,$rank);$slot=['aa'=>0,'a1'=>1,'a2'=>2,'a3'=>3,'a4'=>4][$ref]??null;if($slot!==null)$active[$slot]=$o;}
        $weapon=$this->db->one("SELECT ui.ItemID FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0 AND i.Equipment='Weapon' LIMIT 1",[$u->dbId]);
        $special=$weapon?$this->db->one('SELECT s.* FROM items_skills x INNER JOIN skills s ON s.id=x.SkillID WHERE x.ItemID=? LIMIT 1',[(int)$weapon['ItemID']]):null;
        if($special){$o=$this->skillActionObject($special,$rank);$o['cd']=(int)$special['Cooldown'];$o['mp']=(int)$special['Mana'];$o['range']=(int)$special['Range'];if(isset($o['tgtMax']))$o['tgtMax']=(int)$special['HitTargets'];$active[5]=$o;$this->server->sendRaw($u,['server','Special skill activated: '.$special['Name']]);}
        else{$active[5]=['anim'=>'Cheer','cd'=>60000,'damage'=>0,'desc'=>'Equip a weapon with a special skill.','dsrc'=>'','fx'=>'','icon'=>'icu1','id'=>0,'isOK'=>true,'mp'=>0,'nam'=>'Weapon Skill','range'=>808,'ref'=>'i1','str'=>'','tgt'=>'f','typ'=>'i'];}
        $this->server->sendJson($u,['cmd'=>'clearAuras']);
        if($rank>=4){
            $pa=[];
            foreach($skills as $skill){
                if(strcasecmp((string)$skill['Type'],'passive')!==0)continue;
                foreach($this->world->skillsAuras[(int)$skill['id']]??[] as $auraId){
                    $a=$this->world->auras[$auraId]??null;if(!$a)continue;
                    $u->passiveAuras[$auraId]=$a;
                    $effects=[];foreach($this->world->auraEffectsByAura[$auraId]??[] as $e)$effects[]=['typ'=>$e['Type'],'sta'=>$e['Stat'],'id'=>(int)$e['id'],'val'=>(float)$e['Value']];
                    if($effects)$pa[]=['nam'=>$a['Name'],'e'=>$effects];
                }
            }
            if($pa)$this->server->sendJson($u,['cmd'=>'aura+p','auras'=>$pa,'tInf'=>'p:'.$u->sfsUserId]);
        }
        // Passive effects are server authoritative too; recalculate before exposing sAct.
        $this->sendStats($u,false);
        $this->server->sendJson($u,['cmd'=>'sAct','actions'=>['active'=>$active,'passive'=>$passive]]);
    }
    private function skillAuraEvents(int $skillId,string $from,array $results,?RoomState $room=null,?float $now=null,?ClientSession $caster=null): array
    {
        $events=[];$now=$now??microtime(true);
        $skill=$this->world->skills[$skillId]??null;
        if(!$skill){try{$skill=$this->db->one('SELECT * FROM skills WHERE id=? LIMIT 1',[$skillId]);if($skill)$this->world->skills[$skillId]=$skill;}catch(Throwable){$skill=null;}}
        $skillTarget=strtolower(trim((string)($skill['Target']??'h')));
        $nonHostile=in_array($skillTarget,['f','s'],true);
        foreach($this->skillAuraIds($skillId) as $auraId){
            $a=$this->world->auras[(int)$auraId]??null;
            if(!$a){try{$a=$this->db->one('SELECT * FROM auras WHERE id=? LIMIT 1',[(int)$auraId]);if($a)$this->world->auras[(int)$auraId]=$a;}catch(Throwable){$a=null;}}
            if(!$a)continue;
            $cat=strtolower((string)$a['Category']);$duration=max(0,(int)$a['Duration']);
            $isPrepared=strcasecmp((string)$a['Name'],'Prepared Strike')===0;

            foreach($results as $res){
                // Hostile on-hit auras require hit/crit. Friendly/self buffs are
                // valid DamageType.NONE actions and must still apply their aura.
                $resultType=(string)($res['type']??'none');
                if(!in_array($resultType,['hit','crit'],true)&&!($nonHostile&&$resultType==='none'))continue;
                $targetInfo=(string)($res['tInf']??'');if($targetInfo==='')continue;
                $damage=(int)($res['hp']??0);

                if($room!==null&&preg_match('/^m:(\d+)$/',$targetInfo,$tm)){
                    $monMapId=(int)$tm[1];if(!isset($room->monsters[$monMapId]))continue;$monster=&$room->monsters[$monMapId];
                    if((int)($monster['state']??0)===0){unset($monster);continue;}
                    if((int)($monster['Immune']??0)===1||$cat==='i'){$events[]=['cInf'=>$from,'cmd'=>'aura*','auras'=>$this->auraClientArray($a,true,$duration),'tInf'=>$targetInfo];unset($monster);continue;}
                    $existing=$monster['auras'][(int)$auraId]??null;$isNew=!is_array($existing)||(float)($existing['expiresAt']??0)<=$now;
                    $expiresAt=(!$isNew&&$duration>0)?(float)$existing['expiresAt']+$duration:$now+$duration;
                    $effective=max(0,(int)ceil($expiresAt-$now));
                    if($cat==='clean'){
                        $this->clearMonsterAuras($room,$monster,$monMapId);
                    }else{
                        $monster['auras'][(int)$auraId]=$this->auraRuntime($a,$expiresAt,$from,$damage);
                        if($cat==='d')$monster['dots'][(int)$auraId]=['auraId'=>(int)$auraId,'damage'=>$damage,'from'=>$from,'nextTick'=>$now+2.0,'expiresAt'=>$expiresAt];
                    }
                    $events[]=['cInf'=>$from,'cmd'=>'aura+','auras'=>$this->auraClientArray($a,$isNew,$effective),'tInf'=>$targetInfo];unset($monster);continue;
                }

                if(preg_match('/^p:(\d+)$/',$targetInfo,$tm)){
                    // Java only rolls Aura.Chance for player targets.
                    if((mt_rand()/mt_getrandmax())>(float)$a['Chance'])continue;
                    $playerId=(int)$tm[1];
                    // For a self aura, do not depend on a global SmartFox lookup.
                    // The executing ClientSession is authoritative and is already
                    // known to be in this room/frame from action validation.
                    $target=($caster!==null&&$playerId===$caster->sfsUserId)?$caster:$this->server->findUserBySfsId($playerId);if(!$target)continue;
                    $immune=false;foreach($target->auras as $ta)if(strtolower((string)($ta['cat']??''))==='i'){$immune=true;break;}
                    if($immune){$events[]=['cInf'=>$from,'cmd'=>'aura*','auras'=>$this->auraClientArray($a,true,$duration),'tInf'=>$targetInfo];continue;}

                    if(in_array($cat,['removedebuff','removebuff'],true)){
                        foreach(array_keys($target->auras) as $existingId){$ea=$target->auras[$existingId]??null;if(!is_array($ea))continue;$isDebuff=$this->auraIsDebuff($ea,(int)($target->dots[$existingId]['damage']??0));if(($cat==='removedebuff'&&$isDebuff)||($cat==='removebuff'&&!$isDebuff))$this->removePlayerAura($target,(int)$existingId,true);}
                    }

                    $existing=$target->auras[(int)$auraId]??null;$isNew=!is_array($existing)||(float)($existing['expiresAt']??0)<=$now;
                    // Normal AQW auras extend on a repeat application. Prepared
                    // Strike is charge-based instead: recasting resets to two
                    // charges and refreshes its timeout.
                    if($isPrepared)$expiresAt=$now+max(1,$duration);
                    elseif(!$isNew&&$duration>0)$expiresAt=(float)$existing['expiresAt']+$duration;
                    else$expiresAt=$now+$duration;
                    $effective=max(0,(int)ceil($expiresAt-$now));

                    $runtime=$this->auraRuntime($a,$expiresAt,$from,$damage);
                    if($isPrepared){
                        $runtime['charges']=2;
                        $runtime['guarded']=$this->activePlayerAuraByName($target,'On Guard',$now)!==null;
                    }
                    $target->auras[(int)$auraId]=$runtime;
                    if($cat==='d')$target->dots[(int)$auraId]=['auraId'=>(int)$auraId,'damage'=>$damage,'from'=>$from,'nextTick'=>$now+2.0,'expiresAt'=>$expiresAt];
                    if($cat==='clean'){
                        foreach(array_keys($target->auras) as $existingId)if((int)$existingId!==(int)$auraId)$this->removePlayerAura($target,(int)$existingId,true);
                    }
                    if($this->auraEffectsFor((int)$auraId))$this->sendStats($target,false);
                    $clientAuras=$this->auraClientArray($a,$isNew,$effective);
                    if($isPrepared)$clientAuras[0]['val']='2';
                    $events[]=['cInf'=>$from,'cmd'=>'aura+','auras'=>$clientAuras,'tInf'=>$targetInfo];
                    $this->log->info('Aura applied: '.(string)$a['Name'].' -> '.$target->username.' | SkillID: '.$skillId.' | Duration: '.$effective.'s');
                }
            }
        }
        return $events;
    }

    /** Resolve mappings live as a fallback so a stale WorldRepository cache can
     * never turn a valid buff cast into a mana-only no-op. */
    private function skillAuraIds(int $skillId): array
    {
        $ids=array_values(array_unique(array_map('intval',$this->world->skillsAuras[$skillId]??[])));
        if($ids)return $ids;
        try{
            foreach($this->db->all('SELECT AuraID FROM skills_auras WHERE SkillID=? ORDER BY id',[$skillId]) as $row){$id=(int)($row['AuraID']??0);if($id>0)$ids[]=$id;}
            $ids=array_values(array_unique($ids));if($ids)$this->world->skillsAuras[$skillId]=$ids;
        }catch(Throwable){}
        return $ids;
    }

    /** Resolve effects live as a fallback and populate the repository cache used
     * by StatsCalculator/CombatMath for the rest of the aura lifetime. */
    private function auraEffectsFor(int $auraId): array
    {
        $effects=$this->world->auraEffectsByAura[$auraId]??[];
        if($effects)return $effects;
        try{
            $effects=$this->db->all('SELECT * FROM auras_effects WHERE AuraID=? ORDER BY id',[$auraId]);
            if($effects)$this->world->auraEffectsByAura[$auraId]=$effects;
        }catch(Throwable){$effects=[];}
        return $effects;
    }

    /** GameServer monster-skill bridge to the same Java Action aura lifecycle. */
    public function applySkillAurasFromServer(int $skillId,string $from,array $results,RoomState $room,float $now): array
    { return $this->skillAuraEvents($skillId,$from,$results,$room,$now); }

    private function auraRuntime(array $a,float $expiresAt,string $from,int $damage): array
    { return ['id'=>(int)$a['id'],'nam'=>(string)$a['Name'],'cat'=>strtolower((string)$a['Category']),'expiresAt'=>$expiresAt,'DamageIncrease'=>(float)$a['DamageIncrease'],'DamageTakenDecrease'=>(float)$a['DamageTakenDecrease'],'from'=>$from,'damage'=>$damage]; }

    private function auraClientArray(array $a,bool $isNew,int $duration): array
    {
        $info=['nam'=>(string)$a['Name'],'t'=>'s','dur'=>(string)$duration,'isNew'=>$isNew];$cat=strtolower((string)$a['Category']);
        if($cat!==''&&$cat!=='d'&&$cat!=='none'){$info['cat']=$cat;if($cat==='stun')$info['s']='s';}
        $effects=[];
        foreach($this->auraEffectsFor((int)$a['id']) as $e)$effects[]=['typ'=>(string)$e['Type'],'sta'=>(string)$e['Stat'],'id'=>(int)$e['id'],'val'=>(float)$e['Value']];
        if($effects)$info['e']=$effects;
        return [$info];
    }

    private function auraIsDebuff(array $a,int $dotDamage=0): bool
    {
        $cat=strtolower((string)($a['cat']??''));
        if($cat==='d')return $dotDamage>0;
        return in_array($cat,['debuff','stun','silence','stone','freeze','disabled'],true);
    }

    private function removePlayerAura(ClientSession $target,int $auraId,bool $notify): void
    {
        $a=$target->auras[$auraId]??null;if(!is_array($a))return;unset($target->auras[$auraId],$target->dots[$auraId]);
        if($notify){$info=['nam'=>(string)($a['nam']??'')];$cat=(string)($a['cat']??'');if($cat!==''&&$cat!=='d'){$info['cat']=$cat;if($cat==='stun')$info['s']='s';}$r=$this->server->currentRoom($target);if($r)$this->server->broadcastJson(['cmd'=>'ct','a'=>[['cmd'=>'aura-','aura'=>$info,'tInf'=>'p:'.$target->sfsUserId]]],$r);}
        if(!empty($this->world->auraEffectsByAura[$auraId]))$this->sendStats($target,false);
    }

    private function clearMonsterAuras(RoomState $room,array &$monster,int $monMapId): void
    {
        foreach($monster['auras']??[] as $a){if(!is_array($a))continue;$info=['nam'=>(string)($a['nam']??'')];$cat=(string)($a['cat']??'');if($cat!==''&&$cat!=='d'){$info['cat']=$cat;if($cat==='stun')$info['s']='s';}$this->server->broadcastJson(['cmd'=>'ct','a'=>[['cmd'=>'aura-','aura'=>$info,'tInf'=>'m:'.$monMapId]]],$room);}
        $monster['auras']=[];$monster['dots']=[];
    }
    /** Java MonsterState.giveRewards() parity: every participant receives independently rolled drops and rewards. */
    private function rewardMonster(ClientSession $u,array $m): void
    {
        try{
            $mon=$this->world->monsters[(int)($m['MonID']??0)]??null;
            if(!$mon)return;
            $dropRate=(float)($this->world->rewardRates['drop']??0.0);
            foreach($this->world->monsterDrops[(int)$mon['id']]??[] as $drop){
                if($this->rollDrop((float)$drop['Chance']+$dropRate)){
                    $item=$this->world->items[(int)$drop['ItemID']]??null;
                    if($item)$this->queueRewardItem($u,$item,max(1,(int)$drop['Quantity']));
                }
            }
            foreach($this->world->globalDrops as $drop){
                if($this->rollDrop((float)$drop['Chance']+$dropRate)){
                    $item=$this->world->items[(int)$drop['ItemID']]??null;
                    if($item)$this->queueRewardItem($u,$item,max(1,(int)$drop['Quantity']));
                }
            }
            // The supplied Java Monster model maps the monster Reputation field to class points here.
            // Keep that behavior because the bundled DB uses Reputation=100 / ClassPoint=0 for Slime Green.
            $this->giveRewards(
                $u,(int)$mon['Experience'],(int)$mon['Gold'],(int)$mon['Coin'],
                (int)$mon['Reputation'],0,-1,(int)($m['MonMapID']??$m['MonID']??0),'m'
            );
        }catch(Throwable $e){$this->log->warn('Reward error: '.$e->getMessage());}
    }

    /** Public entry used by GameServer for DoT/monster-skill deaths. */
    public function rewardMonsterParticipants(RoomState $room,array &$monster): void
    {
        $targetIds=array_keys((array)($monster['targets']??[]));
        foreach($targetIds as $socketId){
            $member=$room->clients[(int)$socketId]??null;
            if(!$member)continue;
            $member->targetMonster=null;
            if($member->hp>0){$member->state=1;$member->resting=true;$member->lastRegenAt=0.0;}
            $this->rewardMonster($member,$monster);
        }
        $monster['targets']=[];
    }

    private function rollDrop(float $chance): bool
    {
        // Java stores drop chance as a 0..1 double; tolerate admin data entered as percent as well.
        if($chance>1.0)$chance/=100.0;
        $chance=max(0.0,min(1.0,$chance));
        return (mt_rand()/mt_getrandmax()) <= $chance;
    }

    /** Java Users.giveRewards() port, including boosts, equipment meta, CP/rank, faction rep and level-up. */
    private function giveRewards(ClientSession $u,int $exp,int $gold,int $coins,int $cp,int $rep,int $factionId,int $fromId,string $npcType): array
    {
        $rates=$this->world->rewardRates;
        $boostExp=$this->boostActive($u,'ExpBoostExpire');
        $boostGold=$this->boostActive($u,'GoldBoostExpire');
        $boostCoins=$this->boostActive($u,'CoinsBoostExpire');
        $boostRep=$this->boostActive($u,'RepBoostExpire');
        $boostCp=$this->boostActive($u,'CpBoostExpire');
        $calcExp=(int)round($exp*($boostExp?(1+(float)$rates['exp']):(float)$rates['exp']));
        $calcGold=(int)round($gold*($boostGold?(1+(float)$rates['gold']):(float)$rates['gold']));
        $calcCoins=(int)round($coins*($boostCoins?(1+(float)$rates['coins']):(float)$rates['coins']));
        $calcRep=(int)round($rep*($boostRep?(1+(float)$rates['rep']):(float)$rates['rep']));
        $calcCp=(int)round($cp*($boostCp?(1+(float)$rates['cp']):(float)$rates['cp']));

        foreach($this->equippedRewardMeta($u) as $type=>$total){
            $mult=max(0.0,1.0+$total);
            if($type==='exp')$calcExp=(int)($calcExp*$mult);
            elseif($type==='gold')$calcGold=(int)($calcGold*$mult);
            elseif($type==='coins')$calcCoins=(int)($calcCoins*$mult);
            elseif($type==='rep')$calcRep=(int)($calcRep*$mult);
            elseif($type==='cp')$calcCp=(int)($calcCp*$mult);
        }

        $maxLevel=max(1,(int)($this->world->rates['intLevelMax']??100));
        $goldCap=max(0,(int)($this->world->rates['intGoldCap']??1000000));
        $coinsCap=max(0,(int)($this->world->rates['intCoinsCap']??1000000));
        $expReward=$u->level<$maxLevel?max(0,$calcExp):0;
        $class=$this->equippedClass($u);$oldCp=max(0,(int)($class['iCP']??0));$oldRank=$this->rankFromClassPoints($oldCp);
        $newCp=min(302500,$oldCp+max(0,$calcCp));
        $newFactionId=0;$newFactionRep=0;$newFactionRowId=0;$newLevel=$u->level;$newExp=(int)($u->user['Exp']??0);$statPointsAwarded=0;$statPointsAfter=0;
        $walletGold=(int)($u->user['Gold']??0);$walletCoins=(int)($u->user['Coins']??0);

        $this->db->tx(function(Database $db)use($u,$expReward,$calcGold,$calcCoins,$calcRep,$calcCp,$factionId,$class,$newCp,$maxLevel,$goldCap,$coinsCap,&$walletGold,&$walletCoins,&$newExp,&$newLevel,&$newFactionId,&$newFactionRep,&$newFactionRowId,&$statPointsAwarded,&$statPointsAfter){
            $row=$db->one('SELECT Gold,Coins,Exp,Level FROM users WHERE id=? FOR UPDATE',[$u->dbId]);if(!$row)throw new \RuntimeException('Reward user row missing.');
            $this->ensureUserStats($u,$db);
            $walletGold=(int)$row['Gold'];$walletCoins=(int)$row['Coins'];$newExp=(int)$row['Exp']+$expReward;$newLevel=(int)$row['Level'];
            if($walletGold<$goldCap)$walletGold=min($goldCap,$walletGold+max(0,$calcGold));
            if($walletCoins<$coinsCap)$walletCoins=min($coinsCap,$walletCoins+max(0,$calcCoins));

            if($factionId>1&&$calcRep>0){
                $rewardRep=min($calcRep,302500);$fr=$db->one('SELECT id,Reputation FROM users_factions WHERE UserID=? AND FactionID=? FOR UPDATE',[$u->dbId,$factionId]);
                if($fr){$db->run('UPDATE users_factions SET Reputation=Reputation+? WHERE id=?',[$rewardRep,(int)$fr['id']]);}
                else{$db->run('INSERT INTO users_factions (UserID,FactionID,Reputation) VALUES (?,?,?)',[$u->dbId,$factionId,$rewardRep]);$newFactionRowId=(int)$db->lastInsertId();$newFactionId=$factionId;$newFactionRep=$rewardRep;}
            }
            if($class&&$calcCp>0&&$this->rankFromClassPoints((int)$class['iCP'])<10)$db->run('UPDATE users_items SET Quantity=? WHERE UserID=? AND ItemID=? AND Bank=0',[$newCp,$u->dbId,(int)$class['ItemID']]);

            while($newLevel<$maxLevel&&$newExp>=$this->math->expToLevel($newLevel)){$newExp-=$this->math->expToLevel($newLevel);$newLevel++;}
            // Java levelUp() intentionally resets Exp to zero when at least one level was gained.
            if($newLevel>(int)$row['Level']){
                $newExp=0;$statPointsAwarded=($newLevel-(int)$row['Level'])*3;
                $db->run('UPDATE users_stats SET Points=Points+? WHERE UserID=?',[$statPointsAwarded,$u->dbId]);
            }
            $statPointsAfter=(int)$db->scalar('SELECT Points FROM users_stats WHERE UserID=?',[$u->dbId],0);
            $db->run('UPDATE users SET Gold=?,Coins=?,Exp=?,Level=? WHERE id=?',[$walletGold,$walletCoins,$newExp,$newLevel,$u->dbId]);
        });

        $add=['cmd'=>'addGoldExp','id'=>$fromId,'typ'=>$npcType];
        if($u->level<$maxLevel){$add['intExp']=$expReward;if($boostExp)$add['bonusExp']=intdiv($expReward,2);}
        if($oldRank<10&&$calcCp>0){$add['iCP']=$calcCp;if($boostCp)$add['bonusCP']=intdiv($calcCp,2);}
        if((int)($u->user['Gold']??0)<$goldCap)$add['intGold']=max(0,$calcGold);
        if((int)($u->user['Coins']??0)<$coinsCap)$add['intCoins']=max(0,$calcCoins);
        if($factionId>1&&$calcRep>0){$add['FactionID']=$factionId;$add['iRep']=min($calcRep,302500);if($boostRep)$add['bonusRep']=intdiv(min($calcRep,302500),2);}
        if($newFactionId>0){$f=$this->world->factions[$newFactionId]??null;$this->server->sendJson($u,['cmd'=>'addFaction','faction'=>['FactionID'=>$newFactionId,'bitSuccess'=>1,'CharFactionID'=>$newFactionRowId,'sName'=>(string)($f['Name']??''),'iRep'=>$newFactionRep]]);}
        $this->server->sendJson($u,$add);

        $oldLevel=$u->level;$u->user['Gold']=$walletGold;$u->user['Coins']=$walletCoins;$u->user['Exp']=$newExp;$u->user['Level']=$newLevel;$u->level=$newLevel;
        if($newLevel!==$oldLevel){$this->sendStats($u,true);$this->server->sendJson($u,['cmd'=>'levelUp','intLevel'=>$newLevel,'intExpToLevel'=>$this->math->expToLevel($newLevel),'xp'=>0,'StatPointsAwarded'=>$statPointsAwarded,'StatPoints'=>$statPointsAfter]);}
        if($class&&$oldRank<10&&$calcCp>0&&$this->rankFromClassPoints($newCp)>$oldRank)$this->sendClassActions($u,true);
        return ['intExp'=>$expReward,'intGold'=>$calcGold,'intCoins'=>$calcCoins,'iCP'=>$calcCp,'iRep'=>$calcRep];
    }

    private function boostActive(ClientSession $u,string $field): bool
    {
        $flag=['ExpBoostExpire'=>'xpboost','GoldBoostExpire'=>'gboost','CoinsBoostExpire'=>'coinsboost','CpBoostExpire'=>'cpboost','RepBoostExpire'=>'repboost'][$field]??null;
        if($flag!==null&&array_key_exists($flag,$u->boostFlags))return (bool)$u->boostFlags[$flag];
        $v=$u->user[$field]??null;if(!$v)return false;$ts=strtotime((string)$v);return $ts!==false&&$ts>time();
    }

    /** @return array<string,float> */
    private function equippedRewardMeta(ClientSession $u): array
    {
        $sum=['exp'=>0.0,'gold'=>0.0,'coins'=>0.0,'rep'=>0.0,'cp'=>0.0];
        foreach($this->db->all('SELECT i.Meta FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0',[$u->dbId]) as $r){
            foreach(explode(',',(string)($r['Meta']??'')) as $raw){$parts=explode(':',trim($raw),2);if(count($parts)!==2)continue;$type=strtolower(trim($parts[0]));if(isset($sum[$type])&&is_numeric(trim($parts[1])))$sum[$type]+=(float)trim($parts[1]);}
        }
        return $sum;
    }
    private function inventory(ClientSession $u): void
    {
        $rows=$this->db->all(
            'SELECT ui.id UserItemID,ui.Quantity iQty,ui.Equipped,ui.Bank,ui.Wear,ui.EnhID,ui.EnhItemID,ui.DatePurchased,i.* '
            .'FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID '
            .'WHERE ui.UserID=? AND ui.Bank=0 ORDER BY ui.id',[$u->dbId]
        );
        $items=[];$hitems=[];
        foreach($rows as $r){
            $item=$this->itemJson($r,(int)$r['iQty'],(int)$r['UserItemID']);
            if(in_array((string)$r['Equipment'],['ho','hi'],true))$hitems[]=$item;else$items[]=$item;
            if((int)$r['Equipped']===1){
                $payload=['cmd'=>'equipItem','uid'=>$u->sfsUserId,'ItemID'=>(int)$r['id'],'strES'=>$r['Equipment'],'sFile'=>$r['File'],'sLink'=>$r['Link'],'sMeta'=>$r['Meta']??''];
                if((string)$r['Equipment']==='Weapon')$payload['sType']=$r['Type'];
                $room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($payload,$room);
            }
        }
        // RetrieveInventory.java calls updateClass()/loadSkills() while processing
        // equipped class data, before enhancement patterns and loadInventoryBig.
        $this->sendClassActions($u,true);
        $this->sendEnhancementPatterns($u);
        $bankCount=(int)$this->db->scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND Bank=1',[$u->dbId],0);
        $payload=['bankCount'=>$bankCount,'cmd'=>'loadInventoryBig','items'=>$items,'hitems'=>$hitems,'factions'=>$this->factionList($u)];
        $gid=(int)($u->user['GuildID']??0);if($gid>0){$g=$this->guildObject($gid);if($g)$payload['guild']=$g;}
        $this->server->sendJson($u,$payload);
        $this->sendLoadPrefs($u);
        $this->sendBoosts($u);
        $this->sendStats($u);
        // Match Java's friend/guild online update, but only once per socket.
        // Live command refreshes intentionally reload inventory and must not look
        // like repeated logins to friends or guild members.
        if(!$u->presenceAnnounced){
            foreach($this->friendRows($u) as $friend){$c=$this->server->findUserByDbId((int)$friend['ID']);if($c){$this->server->sendJson($c,['cmd'=>'updateFriend','friend'=>$this->friendObject($u)]);$this->server->sendRaw($c,['server',$u->username.' has logged in.']);}}
            if($gid>0){$rankName=$this->guildRankName((int)($u->user['Rank']??0));foreach($this->server->clients() as $c)if($c!==$u&&(int)($c->user['GuildID']??0)===$gid)$this->server->sendRaw($c,$this->chatPacket(null,'guild',$rankName.' '.$u->username.' has logged in.'));$this->sendGuildUpdate($gid);}
            $u->presenceAnnounced=true;
        }
    }
    private function enhancementPatternIdFromName(string $name): int
    {
        $map=['lucky'=>9,'pneuma'=>27,'anima'=>28,'penitence'=>29,'lament'=>30,'hearty'=>32,'vainglory'=>24,'vim'=>25,'examen'=>26,'forge'=>10,'absolution'=>11,'avarice'=>12,'depths'=>23,'spellbreaker'=>8,'healer'=>7,'wizard'=>6,'hybrid'=>5,'armsman'=>4,'thief'=>3,'fighter'=>2,'adventurer'=>1];
        foreach($map as $needle=>$id)if(str_contains($name,$needle))return $id;
        return 1;
    }

    private function normalizeEnhancementEquipment(string $equipment,string $name=''): string
    {
        $e=trim($equipment);
        if($e!=='' && strcasecmp($e,'None')!==0)return $e;
        $n=strtolower($name);
        if(str_contains($n,'weapon'))return 'Weapon';
        if(str_contains($n,'helm')||str_contains($n,'helmet'))return 'he';
        if(str_contains($n,'cape'))return 'ba';
        if(str_contains($n,'class'))return 'ar';
        if(str_contains($n,'armor')||str_contains($n,'armour'))return 'co';
        if(str_contains($n,'pet'))return 'pe';
        return $e;
    }

    /**
     * Resolve a stored enhancement item id or legacy enhancement definition id.
     * Older custom catalogs are also repaired when the enhancement item has no
     * valid EnhID: the pattern family is inferred from its name and the level.
     *
     * @return array{definition:?array,itemId:int,stats:array<string,int>}
     */
    private function resolveEnhancement(int $storedId,string $targetEquipment=''): array
    {
        $empty=['STR'=>0,'INT'=>0,'DEX'=>0,'END'=>0,'WIS'=>0,'LCK'=>0];
        if($storedId<=0)return ['definition'=>null,'itemId'=>0,'stats'=>$empty];

        $enhItem=$this->db->one("SELECT * FROM items WHERE id=? AND LOWER(Type)='enhancement' LIMIT 1",[$storedId]);
        $definition=null;
        $normalizedEquipment=$this->normalizeEnhancementEquipment((string)($enhItem['Equipment']??$targetEquipment),(string)($enhItem['Name']??''));

        if($enhItem){
            // The enhancement ITEM's Level is authoritative. This prevents a
            // stale legacy EnhID from turning a level-100 catalog item into the
            // level-1 definition while DPS still comes from the item row.
            $name=strtolower((string)($enhItem['Name']??''));
            $patternId=$this->enhancementPatternIdFromName($name);
            $level=max(1,min(100,(int)($enhItem['Level']??1)));
            $definition=$this->db->one('SELECT * FROM enhancements WHERE PatternID=? AND Level=? ORDER BY id LIMIT 1',[$patternId,$level]);

            if(!$definition){
                $candidateId=(int)($enhItem['EnhID']??0);
                if($candidateId>0){
                    $candidate=$this->world->enhancements[$candidateId]??$this->db->one('SELECT * FROM enhancements WHERE id=?',[$candidateId]);
                    if($candidate){
                        $patternId=(int)($candidate['PatternID']??$patternId);
                        $definition=$this->db->one('SELECT * FROM enhancements WHERE PatternID=? AND Level=? ORDER BY id LIMIT 1',[$patternId,$level]);
                    }
                }
            }

            if(!$definition){
                // Some generated/custom catalogs contain the enhancement item
                // but not a matching row in `enhancements`. Build a compatible
                // runtime definition from the item itself so Level 1..100 still
                // produces the correct stat budget and DPS.
                $definitionId=(int)($enhItem['EnhID']??0);
                if($definitionId>0){
                    $legacy=$this->world->enhancements[$definitionId]??$this->db->one('SELECT * FROM enhancements WHERE id=?',[$definitionId]);
                    if($legacy){
                        $definition=$legacy;
                    }else{
                        $definition=[
                            'id'=>$definitionId,
                            'Name'=>str_contains($name,'lucky')?'Lucky Enhancement':(str_contains($name,'fighter')?'Fighter Enhancement':'Adventurer Enhancement'),
                            'PatternID'=>$patternId,
                            'Rarity'=>max(1,(int)($enhItem['Rarity']??1)),
                            'DPS'=>max(0,(int)($enhItem['DPS']??100)),
                            'Level'=>$level,
                        ];
                    }
                }
            }
        }else{
            $definitionId=$storedId;
            $definition=$definitionId>0?($this->world->enhancements[$definitionId]??$this->db->one('SELECT * FROM enhancements WHERE id=?',[$definitionId])):null;
        }

        if(!$enhItem && $definition){
            $params=[(int)$definition['id']];
            $sql="SELECT * FROM items WHERE LOWER(Type)='enhancement' AND EnhID=?";
            if($normalizedEquipment!==''&&strcasecmp($normalizedEquipment,'None')!==0){$sql.=" ORDER BY (Equipment=? ) DESC, id ASC LIMIT 1";$params[]=$normalizedEquipment;}
            else{$sql.=' ORDER BY id ASC LIMIT 1';}
            $enhItem=$this->db->one($sql,$params);
        }

        if(!$definition)return ['definition'=>null,'itemId'=>$enhItem?(int)$enhItem['id']:0,'stats'=>$empty];
        $pattern=$this->db->one('SELECT * FROM enhancements_patterns WHERE id=? LIMIT 1',[(int)$definition['PatternID']]);
        if($pattern)$empty=['STR'=>(int)($pattern['Strength']??0),'INT'=>(int)($pattern['Intelligence']??0),'DEX'=>(int)($pattern['Dexterity']??0),'END'=>(int)($pattern['Endurance']??0),'WIS'=>(int)($pattern['Wisdom']??0),'LCK'=>(int)($pattern['Luck']??0)];
        return ['definition'=>$definition,'itemId'=>$enhItem?(int)$enhItem['id']:0,'stats'=>$empty];
    }

    private function itemJson(array $r,int $qty=1,?int $charItemId=null): array
    {
        $itemId=(int)($r['ItemID']??$r['id']??0);
        // When a joined query supplies UserItemID, `id` belongs to items.*.
        if(isset($r['UserItemID']) && isset($r['id']))$itemId=(int)$r['id'];
        $es=(string)($r['Equipment']??'');
        $o=[
            'ItemID'=>$itemId,'bCoins'=>(int)($r['Coins']??0),'bHouse'=>in_array($es,['ho','hi'],true)?1:0,'bPTR'=>0,
            'bStaff'=>(int)($r['Staff']??0),'bTrade'=>(int)($r['Trade']??0),'bSell'=>(int)($r['Sell']??0),'bMarket'=>(int)($r['Market']??0),
            'bTemp'=>(int)($r['Temporary']??0),'bUpg'=>(int)($r['Upgrade']??0),'iCost'=>(int)($r['Cost']??0),'iDPS'=>(int)($r['DPS']??0),
            'iLvl'=>(int)($r['Level']??0),'iQSindex'=>(int)($r['QuestStringIndex']??0),'iQSvalue'=>(int)($r['QuestStringValue']??0),
            'iRng'=>(int)($r['Range']??0),'iRty'=>(int)($r['Rarity']??0),'iStk'=>(int)($r['Stack']??1),'sDesc'=>(string)($r['Description']??''),
            'sES'=>$es,'sElmt'=>(string)($r['Element']??''),'sFile'=>(string)($r['File']??''),'sIcon'=>(string)($r['Icon']??''),'sLink'=>(string)($r['Link']??''),
            'sMeta'=>(string)($r['Meta']??''),'sName'=>(string)($r['Name']??''),'sReqQuests'=>(string)($r['ReqQuests']??''),'sType'=>(string)($r['Type']??''),
            'iReqCP'=>(int)($r['ReqClassPoints']??0),'iReqRep'=>(int)($r['ReqReputation']??0),'FactionID'=>(int)($r['FactionID']??0),
            'iQty'=>$qty
        ];
        $fid=(int)($r['FactionID']??0);if($fid>0)$o['sFaction']=(string)$this->db->scalar('SELECT Name FROM factions WHERE id=?',[$fid],'');
        $isEnhancementItem=(strcasecmp((string)($r['Type']??''),'Enhancement')===0);
        // For an equipped/owned item, EnhItemID is the authoritative enhancement
        // item id. EnhID remains the definition FK for backwards compatibility.
        // Enhancement catalog rows themselves are resolved by their own ItemID so
        // Level 1..100 is never lost to a stale definition id.
        $storedEnhItemId=(int)($r['EnhItemID']??0);
        $storedEnhId=(int)($r['EnhID']??0);
        $resolveId=$isEnhancementItem ? $itemId : ($storedEnhItemId>0?$storedEnhItemId:$storedEnhId);
        if($resolveId>0){
            $resolved=$this->resolveEnhancement($resolveId,$es);
            $enh=$resolved['definition'];
            if($enh){
                if(strcasecmp((string)($r['Type']??''),'Enhancement')===0){
                    $o['PatternID']=(int)$enh['PatternID'];
                    $o['iDPS']=(int)$enh['DPS'];
                    $o['iLvl']=(int)$enh['Level'];
                    $o['iRty']=(int)$enh['Rarity'];
                    $o['EnhName']=(string)$enh['Name'];
                    $o['EnhID']=0;
                    unset($o['sFile']);
                } else {
                    // The newer client treats EnhID as the enhancement ITEM id and
                    // EnhPatternID as the enhancement definition's pattern id.
                    // Older Aera rows sometimes stored the definition id instead.
                    // resolveEnhancement() accepts both layouts and canonicalizes
                    // the outgoing packet so the client can build its pattern tree.
                    $canonicalEnhItemId=(int)($resolved['itemId']??0);
                    $o['EnhID']=$canonicalEnhItemId>0?$canonicalEnhItemId:$storedEnhItemId;
                    $o['EnhItemID']=$canonicalEnhItemId>0?$canonicalEnhItemId:$storedEnhItemId;
                    $o['EnhDefinitionID']=(int)$enh['id'];
                    $o['EnhName']=(string)$enh['Name'];
                    $o['EnhLvl']=(int)$enh['Level'];
                    $o['EnhPatternID']=(int)$enh['PatternID'];
                    $o['EnhRty']=(int)$enh['Rarity'];
                    $o['EnhRng']=(int)($r['Range']??0);
                    $o['InvEnhPatternID']=(int)$enh['PatternID'];
                    $o['EnhDPS']=(int)$enh['DPS'];
                    $o['EnhPID']=(int)$enh['PatternID'];
                    $o['EnhSTR']=(int)($resolved['stats']['STR']??0);
                    $o['EnhINT']=(int)($resolved['stats']['INT']??0);
                    $o['EnhDEX']=(int)($resolved['stats']['DEX']??0);
                    $o['EnhEND']=(int)($resolved['stats']['END']??0);
                    $o['EnhWIS']=(int)($resolved['stats']['WIS']??0);
                    $o['EnhLCK']=(int)($resolved['stats']['LCK']??0);
                }
            }else {
                $o['EnhID']=0;
                $o['EnhItemID']=0;
                $o['EnhDefinitionID']=0;
                $o['EnhLvl']=0;
                $o['EnhPatternID']=0;
                $o['InvEnhPatternID']=0;
                $o['EnhDPS']=0;
            }
        } else $o['EnhID']=0;
        if($charItemId!==null)$o['CharItemID']=$charItemId;
        if(array_key_exists('Bank',$r))$o['bBank']=(string)(int)$r['Bank'];
        if(array_key_exists('Wear',$r))$o['bWear']=(int)$r['Wear'];
        // Java RetrieveInventory only includes bEquip when the row is actually
        // equipped. Sending the string "0" is truthy in AS3 and makes every
        // inventory item render as equipped/purple.
        if(array_key_exists('Equipped',$r) && (int)$r['Equipped']===1)$o['bEquip']='1';
        if((int)($r['Coins']??0)===1 && !empty($r['DatePurchased'])){$o['dPurchase']=str_replace(' ','T',(string)$r['DatePurchased']);try{$dt=new \DateTimeImmutable((string)$r['DatePurchased']);$o['iHrs']=max(0,(int)floor((time()-$dt->getTimestamp())/3600));}catch(Throwable){}}
        return $o;
    }
    private function shop(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0);
        $shop=$this->db->one('SELECT * FROM shops WHERE id=?',[$id]);
        if(!$shop){if($u->access>=40)$this->server->sendRaw($u,['server','ShopID: '.$id]);return;}
        try{
            $seasonal=$this->db->one('SELECT EndDate FROM shops_seasonal WHERE ShopID=? LIMIT 1',[$id]);
            if($seasonal&&!empty($seasonal['EndDate'])&&strtotime((string)$seasonal['EndDate'])<time()){
                $this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'Shop is not available.','strType'=>'red,medium']);
            }
        }catch(Throwable){}
        // LoadShop.java treats ShopID 1 as the Wheel preview and replaces
        // its ordinary listing with every configured wheel reward.
        $rows=$id===1
            ? $this->db->all('SELECT i.id ShopItemID,-1 QuantityRemain,i.* FROM wheels w INNER JOIN items i ON i.id=w.ItemID ORDER BY w.ItemID')
            : $this->db->all('SELECT si.id ShopItemID,si.QuantityRemain,i.* FROM shops_items si INNER JOIN items i ON i.id=si.ItemID WHERE si.ShopID=? ORDER BY si.id',[$id]);
        $items=[];
        foreach($rows as $r){
            $item=$this->itemJson($r,max(1,(int)($r['Quantity']??1)));
            $item['ShopItemID']=(int)$r['ShopItemID'];
            $item['iQtyRemain']=(int)$shop['Limited']===1?(int)$r['QuantityRemain']:-1;
            $item['iQty']=max(1,(int)($r['Quantity']??1));
            $item['iQSindex']=(int)($r['QuestStringIndex']??0);
            $item['iQSvalue']=(int)($r['QuestStringValue']??0);
            $item['iReqCP']=(int)($r['ReqClassPoints']??0);
            $item['iReqRep']=(int)($r['ReqReputation']??0);
            $item['FactionID']=(int)($r['FactionID']??0);
            $item['iCost']=(int)($r['Cost']??0)*max(1,(int)($r['Quantity']??1));
            $fid=(int)($r['FactionID']??0);if($fid>0)$item['sFaction']=(string)$this->db->scalar('SELECT Name FROM factions WHERE id=?',[$fid],'');
            $classId=(int)($r['ReqClassID']??0);if($classId>0){$item['iClass']=$classId;$item['sClass']=(string)$this->db->scalar('SELECT Name FROM items WHERE id=?',[$classId],'');}
            $turnin=[];try{foreach($this->db->all('SELECT ir.ReqItemID ItemID,ir.Quantity,i.Name,i.Stack FROM items_requirements ir INNER JOIN items i ON i.id=ir.ReqItemID WHERE ir.ItemID=?',[(int)$r['id']]) as $req)$turnin[]=['ItemID'=>(int)$req['ItemID'],'iQty'=>min((int)$req['Quantity'],max(1,(int)$req['Stack'])),'sName'=>$req['Name']];}catch(Throwable){}
            if($turnin)$item['turnin']=$turnin;
            $items[]=$item;
        }
        $shopinfo=['bHouse'=>(int)$shop['House'],'bStaff'=>(int)$shop['Staff'],'bUpgrd'=>(int)$shop['Upgrade'],'bLimited'=>(int)$shop['Limited'],'iIndex'=>'-1','items'=>$items,'ShopID'=>$id,'sField'=>(string)$shop['Field'],'sName'=>(string)$shop['Name']];
        $this->server->sendJson($u,['cmd'=>'loadShop','shopinfo'=>$shopinfo]);
    }
    private function buyItem(ClientSession $u,array $p): void
    {
        $itemId=(int)($p[0]??0);$shopId=(int)($p[1]??0);$shopItemId=(int)($p[2]??0);$qty=max(1,(int)($p[3]??1));
        $out=['cmd'=>'buyItem','bitSuccess'=>0,'CharItemID'=>-1,'iQty'=>0];
        $item=$this->db->one('SELECT * FROM items WHERE id=?',[$itemId]);
        $shop=$this->db->one('SELECT * FROM shops WHERE id=?',[$shopId]);
        $listing=$shopId===1
            ? $this->db->one('SELECT w.ItemID id,-1 QuantityRemain FROM wheels w WHERE w.ItemID=? LIMIT 1',[$itemId])
            : $this->db->one('SELECT * FROM shops_items WHERE ShopID=? AND ItemID=? AND (?=0 OR id=?) LIMIT 1',[$shopId,$itemId,$shopItemId,$shopItemId]);
        if(!$item||!$shop||!$listing){$out['strMessage']='This item is not available from this shop.';$this->server->sendJson($u,$out);return;}
        if((int)$shop['Staff']===1 && $u->access<40){$out['strMessage']='This shop is restricted to staff.';$this->server->sendJson($u,$out);return;}
        if((int)$item['Staff']===1 && $u->access<40){$out['strMessage']='Test Item: Cannot be purchased yet!';$this->server->sendJson($u,$out);return;}
        if((int)$item['Upgrade']===1 && (int)($u->user['UpgradeDays']??0)<=0){$out['strMessage']='This item is member only!';$this->server->sendJson($u,$out);return;}
        if((int)$item['Level']>$u->level){$out['strMessage']='Level requirement not met!';$this->server->sendJson($u,$out);return;}
        $fid=(int)($item['FactionID']??0);if($fid>1){$rep=(int)$this->db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$u->dbId,$fid],-1);if($rep<(int)$item['ReqReputation']){$out['strMessage']='Reputation requirement not met!';$this->server->sendJson($u,$out);return;}}
        try{$seasonal=$this->db->one('SELECT EndDate FROM shops_seasonal WHERE ShopID=? LIMIT 1',[$shopId]);if($seasonal&&!empty($seasonal['EndDate'])&&strtotime((string)$seasonal['EndDate'])<time()){$out['strMessage']='This shop is currently unavailable for purchases.';$this->server->sendJson($u,$out);return;}}catch(Throwable){}
        if((int)$shop['Limited']===1 && (int)$listing['QuantityRemain']<$qty){$out['strMessage']=$item['Name'];$out['bSoldOut']=1;$this->server->sendJson($u,$out);return;}
        $house=in_array((string)$item['Equipment'],['ho','hi'],true);$slotField=$house?'SlotsHouse':'SlotsBag';$count=(int)$this->db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ".($house?"i.Equipment IN ('ho','hi')":"i.Equipment NOT IN ('ho','hi')"),[$u->dbId],0);
        $owned=$this->db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1',[$u->dbId,$itemId]);
        if(!$owned && $count>=(int)($u->user[$slotField]??0)){$out['strMessage']=$house?'House Inventory Full!':'Inventory Full!';$this->server->sendJson($u,$out);return;}
        $stack=max(1,(int)$item['Stack']);$baseQty=max(1,(int)$item['Quantity']);$purchaseQty=$qty;
        if($owned && ($stack===1 || (int)$owned['Quantity']+$purchaseQty>$stack)){$out['strMessage']='You cannot have more than '.$stack.' of that item!';$this->server->sendJson($u,$out);return;}
        $cost=(int)$item['Cost']*($stack>1?($baseQty*$qty):1);$currency=(int)$item['Coins']===1?'Coins':'Gold';
        if((int)($u->user[$currency]??0)<$cost){$out['strMessage']='Insufficient funds!';$this->server->sendJson($u,$out);return;}
        $reqs=$this->db->all('SELECT ReqItemID,Quantity FROM items_requirements WHERE ItemID=?',[$itemId]);
        foreach($reqs as $req){$have=(int)$this->db->scalar('SELECT COALESCE(SUM(Quantity),0) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,(int)$req['ReqItemID']],0);if($have<(int)$req['Quantity']){$out['strMessage']='You do not meet the requirements to buy this item.';$this->server->sendJson($u,$out);return;}}
        $charId=-1;
        try{$this->db->tx(function(Database $db)use($u,$item,$itemId,$purchaseQty,$stack,$cost,$currency,$reqs,$shop,$listing,$qty,&$charId){
            foreach($reqs as $req){$left=(int)$req['Quantity'];$rows=$db->all('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 ORDER BY id FOR UPDATE',[$u->dbId,(int)$req['ReqItemID']]);foreach($rows as $row){$take=min($left,(int)$row['Quantity']);if($take>=(int)$row['Quantity'])$db->run('DELETE FROM users_items WHERE id=?',[(int)$row['id']]);else$db->run('UPDATE users_items SET Quantity=Quantity-? WHERE id=?',[$take,(int)$row['id']]);$left-=$take;if($left<=0)break;}}
            $cur=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$itemId]);
            if($cur){$new=(int)$cur['Quantity']+$purchaseQty;if($new>$stack)throw new \RuntimeException('Stack limit reached.');$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$new,(int)$cur['id']]);$charId=(int)$cur['id'];}
            else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,0,?,0,0,NOW())',[$u->dbId,$itemId,(int)$item['EnhID'],$purchaseQty]);$charId=(int)$db->lastInsertId();}
            $db->run("UPDATE users SET `{$currency}`=`{$currency}`-? WHERE id=?",[$cost,$u->dbId]);
            if((int)$shop['Limited']===1)$db->run('UPDATE shops_items SET QuantityRemain=GREATEST(0,QuantityRemain-?) WHERE id=? AND ShopID=? AND ItemID=?',[$qty,(int)$listing['id'],(int)$shop['id'],$itemId]);
        });}catch(Throwable $e){$out['strMessage']='An error occurred while purchasing the item.';$this->log->warn('buyItem failed: '.$e->getMessage());$this->server->sendJson($u,$out);return;}
        $u->user[$currency]=(int)$u->user[$currency]-$cost;
        // Java Users.turnInItems emits a turnIn packet so the AS3 inventory removes
        // requirement items immediately. Keep the DB mutation atomic, then mirror
        // the client-side removal only after the purchase committed successfully.
        if($reqs){$pairs=[];foreach($reqs as $req)$pairs[]=(int)$req['ReqItemID'].':'.(int)$req['Quantity'];if($pairs)$this->server->sendJson($u,['cmd'=>'turnIn','sItems'=>implode(',',$pairs)]);}
        $out['bitSuccess']=1;$out['CharItemID']=$charId;$out['iQty']=$purchaseQty;$out['bCoins']=(int)$item['Coins']===1?1:0;$out['iCost']=$cost;$out['bBank']=false;$out['virtual']=false;$this->server->sendJson($u,$out);
    }
    private function sellItem(ClientSession $u,array $p): void
    {
        $itemId=(int)($p[0]??0);$qty=max(1,(int)($p[1]??1));$charId=(int)($p[2]??0);
        $r=$this->db->one('SELECT ui.*,i.Cost,i.Coins,i.Sell,i.Stack,i.Name FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.ItemID=? AND ui.Bank=0 LIMIT 1',[$charId,$u->dbId,$itemId]);
        if(!$r){$this->server->sendRaw($u,['warning','Item not found in your inventory.']);return;}if((int)$r['Sell']!==1){$this->server->sendRaw($u,['warning','Item not sell-able.']);return;}
        $qty=min($qty,(int)$r['Quantity']);if($qty<=0)return;$ageHours=9999;if(!empty($r['DatePurchased'])){$ts=strtotime((string)$r['DatePurchased']);if($ts!==false)$ageHours=(int)floor((time()-$ts)/3600);}
        // SellItem.java uses the item's Coins flag (not the auction listing alias)
        // and performs integer division before applying the 90% member-currency refund.
        $coins=(int)$r['Coins']===1;
        $unit=$coins&&$ageHours<24?(intdiv((int)$r['Cost'],10)*9):intdiv((int)$r['Cost'],4);
        $amount=$unit*$qty;$currency=$coins?'Coins':'Gold';$left=(int)$r['Quantity']-$qty;
        try{$this->db->tx(function(Database $db)use($r,$qty,$left,$amount,$currency,$u){if($left>0 && (int)$r['Stack']>1)$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$left,(int)$r['id']]);else$db->run('DELETE FROM users_items WHERE id=?',[(int)$r['id']]);$db->run("UPDATE users SET `{$currency}`=`{$currency}`+? WHERE id=?",[$amount,$u->dbId]);});}catch(Throwable $e){$this->log->warn('sellItem failed: '.$e->getMessage());return;}
        $u->user[$currency]=(int)$u->user[$currency]+$amount;$this->server->sendJson($u,['cmd'=>'sellItem','intAmount'=>$amount,'iQty'=>$qty,'iQtyNow'=>$left,'CharItemID'=>$charId,'bCoins'=>$coins]);
    }
    private function equip(ClientSession $u,array $p,bool $equip): void
    {
        $itemId=(int)($p[0]??0);$item=$this->db->one('SELECT * FROM items WHERE id=?',[$itemId]);if(!$item)return;$es=(string)$item['Equipment'];
        if(!$equip && $es==='ar'){$this->server->sendRaw($u,['warning','Armors cannot be unequipped!']);return;}
        if($equip){
            if((int)$item['Staff']===1&&$u->access<40){$this->server->sendRaw($u,['warning','Unable to use restricted item!']);return;}
            if((int)$item['Upgrade']===1&&(int)($u->user['UpgradeDays']??0)<=0){$this->server->sendRaw($u,['warning','Upgrade is required!']);return;}
            if((int)$item['Level']>$u->level){$this->server->sendRaw($u,['warning','Level requirement not met!']);return;}
            $fid=(int)($item['FactionID']??0);if($fid>1){$rep=(int)$this->db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$u->dbId,$fid],-1);if($rep<(int)$item['ReqReputation']){$this->server->sendRaw($u,['warning','Reputation requirement not met!']);return;}}
            if((int)$item['Temporary']===1){if(!isset($u->temporaryItems[$itemId]))return;}else{$owned=$this->db->one('SELECT id,EnhID,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 AND Wear=0 LIMIT 1',[$u->dbId,$itemId]);if(!$owned)return;try{$this->db->tx(function(Database $db)use($u,$es,$itemId){$db->run('UPDATE users_items ui INNER JOIN items i ON i.id=ui.ItemID SET ui.Equipped=0 WHERE ui.UserID=? AND ui.Bank=0 AND ui.Wear=0 AND i.Equipment=?',[$u->dbId,$es]);$db->run('UPDATE users_items SET Equipped=1 WHERE UserID=? AND ItemID=? AND Bank=0 AND Wear=0',[$u->dbId,$itemId]);});}catch(Throwable $e){$this->log->warn('equipItem failed: '.$e->getMessage());return;}}
            $o=['uid'=>$u->sfsUserId,'cmd'=>'equipItem','ItemID'=>$itemId,'strES'=>$es,'sFile'=>$item['File'],'sLink'=>$item['Link'],'sMeta'=>$item['Meta']??''];if($es==='Weapon')$o['sType']=$item['Type'];$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($o,$room);else$this->server->sendJson($u,$o);$this->sendStats($u);if($es==='ar'||$es==='Weapon')$this->sendClassActions($u,$es==='ar');
            if($es==='ho'){
                // EquipItem.java clears/rebuilds an active house when its map item changes.
                $this->db->run("UPDATE users SET HouseInfo='' WHERE id=?",[$u->dbId]);$u->user['HouseInfo']='';$this->server->updateHouseInfo($u->dbId,'');
                $houseName='house-'.$u->dbId;$toMove=[];foreach($this->server->clients() as $client)if(strcasecmp($client->roomName,$houseName)===0)$toMove[]=$client;
                foreach($toMove as $client){$this->server->sendRaw($client,['server','The map "'.$houseName.'" is being rebuilt. You may join again in a few moments.']);$this->server->joinGameRoom($client,'faroff');}
            }
            return;
        }
        if((int)$item['Temporary']!==1)$this->db->run('UPDATE users_items SET Equipped=0 WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$itemId]);$o=['cmd'=>'unequipItem','ItemID'=>$itemId,'uid'=>$u->sfsUserId,'strES'=>$es,'bUnload'=>true];$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($o,$room);else$this->server->sendJson($u,$o);$this->sendStats($u);
    }
    private function wearItem(ClientSession $u,array $p): void
    {
        $itemId=(int)($p[0]??0);$item=$this->db->one('SELECT * FROM items WHERE id=?',[$itemId]);$o=['cmd'=>'wearItem','uid'=>$u->sfsUserId,'success'=>false];if(!$item){$o['msg']='Item does not exist!';$this->server->sendJson($u,$o);return;}
        $es=(string)$item['Equipment'];if(!in_array($es,['Weapon','co','he','ba'],true)){$o['msg']='Cannot wear this item!';$this->server->sendJson($u,$o);return;}$owned=$this->db->one('SELECT id FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1',[$u->dbId,$itemId]);if(!$owned){$o['msg']='Item is not in your inventory.';$this->server->sendJson($u,$o);return;}
        try{$this->db->tx(function(Database $db)use($u,$es,$itemId){$db->run('UPDATE users_items ui INNER JOIN items i ON i.id=ui.ItemID SET ui.Wear=0 WHERE ui.UserID=? AND i.Equipment=?',[$u->dbId,$es]);$db->run('UPDATE users_items SET Wear=1 WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$itemId]);});}catch(Throwable $e){$o['msg']='Unable to wear item.';$this->server->sendJson($u,$o);return;}
        $o+=['ItemID'=>$itemId,'sES'=>$es,'sFile'=>$item['File'],'sLink'=>$item['Link'],'sType'=>$item['Type'],'success'=>true];$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($o,$room);else$this->server->sendJson($u,$o);
    }
    private function unwearItem(ClientSession $u,array $p): void
    {
        $es=(string)($p[0]??'');$o=['cmd'=>'unwearItem','uid'=>$u->sfsUserId,'success'=>false];$w=$this->db->one('SELECT ui.ItemID,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Wear=1 AND i.Equipment=? LIMIT 1',[$u->dbId,$es]);if(!$w){$o['msg']='This item is not worn.';$this->server->sendJson($u,$o);return;}
        $fallback=$this->db->one('SELECT i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0 AND i.Equipment=? LIMIT 1',[$u->dbId,$es]);$display=$fallback?:$w;$this->db->run('UPDATE users_items SET Wear=0 WHERE UserID=? AND ItemID=?',[$u->dbId,(int)$w['ItemID']]);$o+=['ItemID'=>(int)$w['ItemID'],'sES'=>(string)$display['Equipment'],'sFile'=>$display['File'],'sLink'=>$display['Link'],'sType'=>$display['Type'],'success'=>true];if(!$fallback)$o['bRemove']=false;$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($o,$room);else$this->server->sendJson($u,$o);
    }
    private function getQuests(ClientSession $u,array $p,string $responseCmd='getQuests'): void
    {
        $ids=[];foreach($p as $v)foreach(preg_split('/[,~]/',(string)$v)?:[] as $x)if(ctype_digit(trim($x)))$ids[]=(int)$x;
        $quests=[];
        foreach(array_values(array_unique($ids)) as $qid){
            $q=$this->world->quests[$qid]??null;if(!$q)continue;
            $oReqd=[];$reqd=[];
            foreach($this->world->questRequiredItems[$qid]??[] as $rr){
                $iid=(int)$rr['ItemID'];$item=$this->world->items[$iid]??null;if(!$item)continue;$oReqd[(string)$iid]=$this->itemJson($item,1);
                // The legacy Java Quest.reqd model only retained quantity; preserve its packet fields for client compatibility.
                $qty=(int)$rr['Quantity'];$reqd[]=['ItemID'=>$iid,'QuestID'=>$qid,'iQty'=>$qty,'MapID'=>$qty,'Frame'=>(string)$qty,'Cell'=>(string)$qty];
            }
            $oItems=[];$turnin=[];
            foreach($this->world->questRequirements[$qid]??[] as $rr){$iid=(int)$rr['ItemID'];$item=$this->world->items[$iid]??null;if(!$item)continue;$oItems[(string)$iid]=$this->itemJson($item,1);$turnin[]=['ItemID'=>(string)$iid,'QuestID'=>$qid,'iQty'=>(int)$rr['Quantity']];}
            $oRewards=[];$reward=[];
            foreach($this->world->questRewards[$qid]??[] as $rr){$iid=(int)$rr['ItemID'];$item=$this->world->items[$iid]??null;if(!$item)continue;$type=(string)($rr['RewardType']??'S');$ij=$this->itemJson($item,(int)$rr['Quantity']);$bucket='items'.$type;if(!isset($oRewards[$bucket]))$oRewards[$bucket]=[];$oRewards[$bucket][(string)($rr['id']??$iid)]=$ij;$reward[]=['ItemID'=>$iid,'QuestID'=>$qid,'iRate'=>(int)round((float)$rr['Rate']*100),'iType'=>$type,'iQty'=>(int)$rr['Quantity']];}
            $quest=['FactionID'=>(int)$q['FactionID'],'QuestID'=>$qid,'bOnce'=>(int)$q['Once'],'bStaff'=>0,'bUpg'=>(int)$q['Upgrade'],'iExp'=>(int)$q['Experience'],'iGold'=>(int)$q['Gold'],'iCoins'=>(int)$q['Coins'],'iLvl'=>(int)$q['Level'],'iRep'=>(int)$q['Reputation'],'iReqCP'=>(int)$q['ReqClassPoints'],'iReqRep'=>(int)$q['ReqReputation'],'iSlot'=>(int)$q['Slot'],'iValue'=>(int)$q['Value'],'iWar'=>0,'oReqd'=>$oReqd,'oItems'=>$oItems,'oRewards'=>$oRewards,'reward'=>$reward,'sDesc'=>(string)$q['Description'],'sEndText'=>(string)$q['EndText'],'sName'=>(string)$q['Name'],'turnin'=>$turnin];
            if($reqd)$quest['reqd']=$reqd;
            if((int)$q['FactionID']>1)$quest['sFaction']=(string)(($this->world->factions[(int)$q['FactionID']]['Name']??''));
            if((int)$q['ReqClassID']>0){$quest['iClass']=(int)$q['ReqClassID'];$quest['sClass']=(string)(($this->world->items[(int)$q['ReqClassID']]['Name']??''));}
            if((string)$q['Field']!==''){$quest['sField']=$q['Field'];$quest['iIndex']=(int)$q['Index'];}
            $quests[(string)$qid]=$quest;
        }
        $this->server->sendJson($u,['cmd'=>$responseCmd,'quests'=>$quests]);
        if($u->access>=40&&$ids)$this->server->sendRaw($u,['server','QuestsID: '.implode(', ',$ids)]);
    }

    private function acceptQuest(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0);$q=$this->world->quests[$id]??null;$success=0;$msg='';
        if(!$q)$msg='Quest not found.';
        elseif((int)$q['Upgrade']===1&&(int)($u->user['UpgradeDays']??0)<=0)$msg='This quest requires membership.';
        elseif((int)$q['Level']>$u->level)$msg='You do not meet the level requirement.';
        else{$u->acceptedQuests[$id]=true;$success=1;}
        $o=['cmd'=>'acceptQuest','QuestID'=>$id,'bSuccess'=>$success];if($msg!=='')$o['msg']=$msg;$this->server->sendJson($u,$o);
    }

    private function completeQuest(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0);$choice=(int)($p[1]??0);$quantity=max(1,(int)($p[3]??1));$q=$this->world->quests[$id]??null;
        $fail=function(string $msg='',bool $log=false)use($u,$id){$o=['cmd'=>'ccqr','QuestID'=>$id,'bSuccess'=>0];if($msg!=='')$o['msg']=$msg;$this->server->sendJson($u,$o);if($log)$this->recordViolation($u,'Packet Edit [TryQuestComplete]',$msg);};
        if(!$q){$fail('Quest not found.');return;}
        if((int)$q['Upgrade']===1&&(int)($u->user['UpgradeDays']??0)<=0){$fail('Attempted to complete member-only quest.',true);return;}
        $factionId=(int)$q['FactionID'];if($factionId>1){$rep=(int)$this->db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$u->dbId,$factionId],0);if($rep<(int)$q['ReqReputation']){$fail('Attempted to complete a quest without required reputation.',true);return;}}
        $wheel=in_array($id,[1,2],true);if(!isset($u->acceptedQuests[$id])&&!$wheel&&(int)$q['WarID']<=0){$fail('Attempted to complete an unaccepted quest: '.$q['Name'],true);return;}
        if((string)$q['Field']!==''&&$this->achievementFieldValue($u,(string)$q['Field'],(int)$q['Index'])!==0){$fail('Quest daily/monthly limit has been reached. Please try again later.',true);$this->server->sendRaw($u,['server','Quest daily/monthly limit has been reached. Please try again later.']);return;}
        if($wheel&&$u->level<(int)$q['Level']){$this->server->sendRaw($u,['warning','You need to be at least level '.(int)$q['Level'].' to spin the wheel!']);return;}
        if(!$this->turnInQuestItems($u,$this->world->questRequirements[$id]??[],1)){$fail('Failed to pass turn in validation while attempting to complete quest: '.$q['Name'],true);return;}

        $exp=(int)$q['Experience']*$quantity;$gold=(int)$q['Gold']*$quantity;$coins=(int)$q['Coins']*$quantity;$cp=(int)$q['ClassPoints']*$quantity;$repReward=(int)$q['Reputation']*$quantity;
        if($wheel&&$quantity===1){if(!$this->doWheel($u)){$fail('Insufficient amount of tickets.');return;}}
        else{
            for($i=0;$i<$quantity;$i++){
                $random=[];$choiceExists=false;
                foreach($this->world->questRewards[$id]??[] as $rw){$type=strtolower((string)($rw['RewardType']??'S'));$iid=(int)$rw['ItemID'];$item=$this->world->items[$iid]??null;if(!$item)continue;
                    if($type==='c'){$choiceExists=true;if($choice===$iid)$this->queueRewardItem($u,$item,(int)$rw['Quantity']);continue;}
                    if(in_array($type,['r','rand'],true)){$random[]=$rw;continue;}$this->queueRewardItem($u,$item,(int)$rw['Quantity']);
                }
                if($choiceExists&&$choice<=0){$fail('A choice reward was required.',true);return;}
                if($choiceExists){$validChoice=false;foreach($this->world->questRewards[$id]??[] as $rw)if(strtolower((string)$rw['RewardType'])==='c'&&(int)$rw['ItemID']===$choice){$validChoice=true;break;}if(!$validChoice){$fail('Invalid quest choice reward.',true);return;}}
                if($random){$rw=$random[array_rand($random)];$item=$this->world->items[(int)$rw['ItemID']]??null;if($item)$this->queueRewardItem($u,$item,(int)$rw['Quantity']);}
            }
        }
        $this->giveRewards($u,$exp,$gold,$coins,$cp,$repReward,$factionId,$u->sfsUserId,'p');
        if((int)$q['WarID']>0){$points=(int)$q['WarMega']===1?2:1;try{$this->db->run('UPDATE wars SET Points=LEAST(MaxPoints,Points+?) WHERE id=?',[$points,(int)$q['WarID']]);}catch(Throwable){}}
        if((int)$q['Slot']>0&&$this->questValue($u,(int)$q['Slot'])<(int)$q['Value'])$this->updateQuestValue($u,[(int)$q['Slot'],(int)$q['Value']]);
        if((string)$q['Field']!=='')$this->setAchievementField($u,(string)$q['Field'],(int)$q['Index'],1);
        unset($u->acceptedQuests[$id]);
        $rewardObj=['intGold'=>$gold,'intCoins'=>$coins,'intExp'=>$exp,'iCP'=>$cp];if($factionId>0)$rewardObj['iRep']=$repReward;
        $this->server->sendJson($u,['cmd'=>'ccqr','QuestID'=>$id,'rewardObj'=>$rewardObj,'sName'=>$q['Name'],'bSuccess'=>1]);
        if((int)$q['AchievementID']>0)$this->getAchievement($u,[(int)$q['AchievementID']]);
    }

    private function turnInQuestItems(ClientSession $u,array $requirements,int $multiplier=1): bool
    {
        if(!$requirements||$multiplier<1)return true;$needed=[];foreach($requirements as $r){$iid=(int)$r['ItemID'];$needed[$iid]=($needed[$iid]??0)+(max(0,(int)$r['Quantity'])*$multiplier);}
        foreach($needed as $iid=>$qty){$item=$this->world->items[$iid]??null;if(!$item)return false;if((int)$item['Temporary']===1){if((int)($u->temporaryItems[$iid]??0)<$qty)return false;}else{$have=(int)$this->db->scalar('SELECT COALESCE(SUM(Quantity),0) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$iid],0);if($have<$qty)return false;}}
        try{$this->db->tx(function(Database $db)use($u,$needed){foreach($needed as $iid=>$qty){$item=$this->world->items[$iid]??null;if(!$item)continue;if((int)$item['Temporary']===1)continue;$left=$qty;$rows=$db->all('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 ORDER BY id FOR UPDATE',[$u->dbId,$iid]);foreach($rows as $r){$take=min($left,(int)$r['Quantity']);if($take===(int)$r['Quantity'])$db->run('DELETE FROM users_items WHERE id=?',[(int)$r['id']]);else$db->run('UPDATE users_items SET Quantity=Quantity-? WHERE id=?',[$take,(int)$r['id']]);$left-=$take;if($left<=0)break;}}});}catch(Throwable $e){$this->log->warn('Quest turn-in transaction failed: '.$e->getMessage());return false;}
        $pairs=[];foreach($needed as $iid=>$qty){$item=$this->world->items[$iid]??null;if($item&&(int)$item['Temporary']===1){$left=max(0,(int)($u->temporaryItems[$iid]??0)-$qty);if($left>0)$u->temporaryItems[$iid]=$left;else unset($u->temporaryItems[$iid]);}$pairs[]=$iid.':'.$qty;}
        if($pairs)$this->server->sendJson($u,['cmd'=>'turnIn','sItems'=>implode(',',$pairs)]);return true;
    }

    private function doWheel(ClientSession $u): bool
    {
        $ticket=null;foreach([12,13] as $iid){$item=$this->world->items[$iid]??null;if(!$item)continue;$have=(int)$item['Temporary']===1?(int)($u->temporaryItems[$iid]??0):(int)$this->db->scalar('SELECT COALESCE(SUM(Quantity),0) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$iid],0);if($have>0){$ticket=$iid;break;}}
        if($ticket===null)return false;if(!$this->turnInQuestItems($u,[['ItemID'=>$ticket,'Quantity'=>1]],1))return false;if(!$this->world->wheels)return true;
        $total=0.0;foreach($this->world->wheels as $w)$total+=max(0.0,(float)$w['Chance']);if($total<=0.0)return true;$pick=(mt_rand()/mt_getrandmax())*$total;$chosen=null;foreach($this->world->wheels as $w){$pick-=max(0.0,(float)$w['Chance']);if($pick<=0){$chosen=$w;break;}}$chosen=$chosen??end($this->world->wheels);$iid=(int)$chosen['ItemID'];$item=$this->world->items[$iid]??null;if(!$item)return true;
        $charItemId=(int)$this->db->scalar('SELECT id FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1',[$u->dbId,$iid],-1);$dropItems=[];$extra=[];
        foreach([[3,'charItem1','iQty1'],[11,'charItem2','iQty2']] as [$bonusId,$charKey,$qtyKey]){$bonus=$this->world->items[$bonusId]??null;if(!$bonus)continue;$char=0;$qty=0;$can=true;try{$this->db->tx(function(Database $db)use($u,$bonusId,$bonus,&$char,&$qty,&$can){$r=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$bonusId]);if($r){$char=(int)$r['id'];$qty=(int)$r['Quantity'];if($qty>=(int)$bonus['Stack']){$can=false;return;}$qty++;$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$qty,$char]);}else{$qty=1;$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,0,1,0,0,NOW())',[$u->dbId,$bonusId,(int)$bonus['EnhID']]);$char=(int)$db->lastInsertId();}});}catch(Throwable){$can=false;}if($can){$dropItems[(string)$bonusId]=$this->itemJson($bonus,1);$extra[$charKey]=$char;$extra[$qtyKey]=$qty;}}
        $packet=['cmd'=>'Wheel','Item'=>$this->itemJson($item,1),'dropQty'=>(int)$chosen['Quantity'],'CharItemID'=>$charItemId,'dropItems'=>$dropItems]+$extra;$this->server->sendJson($u,$packet);
        if($charItemId<1){$this->server->sendRaw($u,['wheel','You won '.$item['Name']]);$this->queueRewardItem($u,$item,max(1,(int)$chosen['Quantity']));}return true;
    }

    private function achievementFieldValue(ClientSession $u,string $field,int $index): int
    { $map=['ia0'=>'Achievement','id0'=>'DailyQuests0','id1'=>'DailyQuests1','id2'=>'DailyQuests2','im0'=>'MonthlyQuests0'];if(!isset($map[$field]))return -1;$index=max(0,min(30,$index));return (((int)($u->user[$map[$field]]??0) & (1<<$index))!==0)?1:0; }
    private function questValue(ClientSession $u,int $index): int
    { $field=$index>99?'Quests2':'Quests';$i=$index>99?$index-100:$index;$s=(string)($u->user[$field]??'');if($i<0||$i>=strlen($s))return 0;$c=$s[$i];return ctype_digit($c)?(int)$c:max(0,ord(strtoupper($c))-55); }
    private function recordViolation(ClientSession $u,string $violation,string $details): void
    { try{$this->db->run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$u->dbId,$violation,$details]);}catch(Throwable){}$this->server->sendRaw($u,['suspicious']);$this->log->warn($violation.' player='.$u->username.' '.$details); }
    private function loadBank(ClientSession $u,array $p=[]): void { $types=array_values(array_filter(array_map('strval',$p)));$rows=$this->db->all('SELECT ui.id UserItemID,ui.Quantity iQty,ui.Equipped,ui.Bank,ui.Wear,ui.EnhID,ui.EnhItemID,ui.DatePurchased,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=1 ORDER BY ui.id',[$u->dbId]);$items=[];foreach($rows as $r){if($types&&!in_array((string)$r['Type'],$types,true))continue;$items[]=$this->itemJson($r,(int)$r['iQty'],(int)$r['UserItemID']);}$this->server->sendJson($u,['cmd'=>'loadBank','items'=>$items,'bitSuccess'=>1]); }
    private function bankMove(ClientSession $u,array $p,bool $toBank): void
    {
        $itemId=(int)($p[0]??0);$charId=(int)($p[1]??0);$cmd=$toBank?'bankFromInv':'bankToInv';
        $out=['cmd'=>$cmd,'bitSuccess'=>0,'bSuccess'=>0,'ItemID'=>$itemId,'CharItemID'=>$charId];
        $fail=function(string $msg)use($u,$toBank,&$out): void {
            $out['msg']=$msg;$out['strMessage']=$msg;
            // The stock AS3 bankToInv handler does not inspect bSuccess and would
            // visually move the item on a failed response. Java surfaces these
            // validation failures as a modal exception, so use popupmsg instead.
            if(!$toBank){$this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>$msg,'strGlow'=>'red,medium','bitSuccess'=>0]);return;}
            $this->server->sendJson($u,$out);
        };
        $r=$this->db->one('SELECT ui.*,i.Temporary,i.Stack,i.Equipment,i.Coins FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.ItemID=? LIMIT 1',[$charId,$u->dbId,$itemId]);
        if(!$r){$fail($toBank?'You do not own this item!':'Item does not exist in your bank!');return;}
        if((int)$r['Temporary']===1){$fail('Item is temporary, unable to transfer to bank!');return;}
        $wantFrom=$toBank?0:1;if((int)$r['Bank']!==$wantFrom){$fail($toBank?'You do not own this item!':'Item does not exist in your bank!');return;}
        $destBank=$toBank?1:0;$other=$this->db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=? AND id<>? LIMIT 1',[$u->dbId,$itemId,$destBank,$charId]);
        if($toBank&&!$other&&(int)$r['Coins']!==1){$count=(int)$this->db->scalar('SELECT COUNT(*) FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=1 AND i.Coins=0',[$u->dbId],0);if($count>=(int)($u->user['SlotsBank']??0)){$fail('Bank Inventory Full!');return;}}
        if(!$toBank&&!$other){$house=in_array((string)$r['Equipment'],['ho','hi'],true);$slots=(int)($u->user[$house?'SlotsHouse':'SlotsBag']??0);$count=(int)$this->db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ".($house?"i.Equipment IN ('ho','hi')":"i.Equipment NOT IN ('ho','hi')"),[$u->dbId],0);if($count>=$slots){$fail($house?'House Inventory Full!':'Inventory Full!');return;}}
        try{$this->db->tx(function(Database $db)use($r,$other,$charId,$destBank){if($other){if((string)$r['Equipment']==='ar')throw new \RuntimeException('Cannot put same class in your bank!');$new=(int)$other['Quantity']+(int)$r['Quantity'];if($new>(int)$r['Stack'])throw new \RuntimeException('Item stack cannot be more than '.(int)$r['Stack'].'!');$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$new,(int)$other['id']]);$db->run('DELETE FROM users_items WHERE id=?',[$charId]);}else{$db->run('UPDATE users_items SET Bank=?,Equipped=0,Wear=0 WHERE id=?',[$destBank,$charId]);}});}catch(Throwable $e){$fail($e->getMessage());return;}
        $out['bitSuccess']=$out['bSuccess']=1;$out['bBank']=$destBank;$this->server->sendJson($u,$out);
    }
    private function friends(ClientSession $u,bool $showList=false): void
    { $this->server->sendJson($u,['cmd'=>$showList?'loadFriendsList':'friends','friends'=>$this->friendRows($u),'showList'=>$showList]); }
    private function addFriend(ClientSession $u,array $p): void
    {
        $name=trim((string)($p[0]??end($p)??''));$t=$this->server->findUser($name);if(!$t){$this->server->sendRaw($u,['server','Player "'.$name.'" could not be found.']);return;}
        // Legacy Java requires an outstanding request. Be tolerant of older clients
        // that omit the request tracking packet, but still create both directions atomically.
        try{$this->db->tx(function(Database $db)use($u,$t){foreach([[$u->dbId,$t->dbId],[$t->dbId,$u->dbId]] as [$a,$b])if((int)$db->scalar('SELECT COUNT(*) FROM users_friends WHERE UserID=? AND FriendID=?',[$a,$b],0)===0)$db->run('INSERT INTO users_friends (UserID,FriendID) VALUES (?,?)',[$a,$b]);});}catch(Throwable $e){$this->server->sendRaw($u,['warning','Error adding friend.']);return;}
        unset($u->friendRequests[$t->dbId]);unset($t->friendRequests[$u->dbId]);
        $this->server->sendJson($u,['cmd'=>'addFriend','friend'=>$this->friendObject($t)]);$this->server->sendRaw($u,['server',$t->username.' has been added to your friends list.']);
        $this->server->sendJson($t,['cmd'=>'addFriend','friend'=>$this->friendObject($u)]);$this->server->sendRaw($t,['server',$u->username.' has been added to your friends list.']);
    }
    private function deleteFriend(ClientSession $u,array $p): void
    {
        $name=trim((string)($p[1]??$p[0]??''));$t=$this->db->one('SELECT id,Name FROM users WHERE LOWER(Name)=LOWER(?)',[$name]);if(!$t)return;$id=(int)$t['id'];
        $this->db->run('DELETE FROM users_friends WHERE (UserID=? AND FriendID=?) OR (UserID=? AND FriendID=?)',[$u->dbId,$id,$id,$u->dbId]);
        $this->server->sendJson($u,['cmd'=>'deleteFriend','ID'=>$id]);$online=$this->server->findUserByDbId($id);if($online)$this->server->sendJson($online,['cmd'=>'deleteFriend','ID'=>$u->dbId]);
    }
    private function titles(ClientSession $u): void
    {
        // Exact LoadTitles.java/client contract: the client reads `success`
        // and `lists`, not `titles`.
        $rows=$this->db->all('SELECT t.id,t.Name,t.Description,t.Color,t.Strength,t.Intellect,t.Endurance,t.Dexterity,t.Wisdom,t.Luck FROM users_titles ut INNER JOIN titles t ON t.id=ut.TitleID WHERE ut.UserID=?',[$u->dbId]);
        $lists=[];foreach($rows as $r)$lists[]=['id'=>(int)$r['id'],'Name'=>(string)$r['Name'],'Description'=>(string)$r['Description'],'Color'=>(int)$r['Color'],'Strength'=>(int)$r['Strength'],'Intellect'=>(int)$r['Intellect'],'Endurance'=>(int)$r['Endurance'],'Dexterity'=>(int)$r['Dexterity'],'Wisdom'=>(int)$r['Wisdom'],'Luck'=>(int)$r['Luck']];
        $this->server->sendJson($u,['cmd'=>'loadTitles','lists'=>$lists,'success'=>true]);
    }
    private function updateTitle(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0);$type=strtolower(trim((string)($p[1]??'equip')));$title=$this->db->one('SELECT * FROM titles WHERE id=?',[$id]);if(!$title){$this->server->sendRaw($u,['warning','Invalid Title.']);return;}$has=(int)$this->db->scalar('SELECT COUNT(*) FROM users_titles WHERE UserID=? AND TitleID=?',[$u->dbId,$id],0);if($has<1){$this->server->sendRaw($u,['warning','Selected title is currently locked.']);return;}
        if($type==='equip'){$this->db->run('UPDATE users SET TitleID=? WHERE id=?',[$id,$u->dbId]);$u->user['TitleID']=$id;}elseif(in_array($type,['unequip','remove'],true)){$this->db->run('UPDATE users SET TitleID=NULL WHERE id=?',[$u->dbId]);$u->user['TitleID']=null;$type='unequip';}else{$this->server->sendRaw($u,['warning','Invalid title action.']);return;}
        $o=['cmd'=>'updateTitle','uid'=>$u->sfsUserId,'type'=>$type,'title'=>['id'=>(int)$title['id'],'Name'=>$title['Name'],'Description'=>$title['Description'],'Color'=>$title['Color'],'Strength'=>(int)$title['Strength'],'Intellect'=>(int)$title['Intellect'],'Endurance'=>(int)$title['Endurance'],'Dexterity'=>(int)$title['Dexterity'],'Wisdom'=>(int)$title['Wisdom'],'Luck'=>(int)$title['Luck']],'success'=>true];$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($o,$room);else$this->server->sendJson($u,$o);$this->sendStats($u);
    }
    private function redeem(ClientSession $u,array $p): void
    {
        $code=strtolower(trim((string)($p[0]??'')));if($code==='')return;
        $r=null;$rewards=null;
        try{$this->db->tx(function(Database $db)use($u,$code,&$r,&$rewards){
            $r=$db->one('SELECT * FROM redeems WHERE LOWER(Code)=? LIMIT 1 FOR UPDATE',[$code]);
            if(!$r)throw new \RuntimeException("The code you're trying to redeem is invalid!");$rid=(int)$r['id'];
            if((int)$db->scalar('SELECT COUNT(*) FROM users_redeems WHERE UserID=? AND RedeemID=?',[$u->dbId,$rid],0)>0)throw new \RuntimeException('You already redeemed this code!');
            if((int)$r['Expires']===1&&!empty($r['DateExpiry'])&&strtotime((string)$r['DateExpiry'])<=time())throw new \RuntimeException("The code you're trying to redeem is already expired.");
            if((int)$r['Limited']===1){$n=$db->run('UPDATE redeems SET QuantityLeft=QuantityLeft-1 WHERE id=? AND QuantityLeft>0',[$rid]);if($n<1)throw new \RuntimeException("The code you're trying to redeem is out of stock.");}
            // Mark the code inside the same transaction as Users.giveRewards(). Database::tx
            // supports nesting, so a reward failure rolls the redemption back as well.
            $db->run('INSERT INTO users_redeems (RedeemID,UserID) VALUES (?,?)',[$rid,$u->dbId]);
            $rewards=$this->giveRewards($u,(int)$r['Exp'],(int)$r['Gold'],(int)$r['Coins'],(int)$r['ClassPoints'],0,-1,$u->sfsUserId,'p');
        });}catch(Throwable $e){$this->server->sendRaw($u,['warning',$e->getMessage()]);return;}
        if($r&&(int)($r['ItemID']??0)>0){$item=$this->world->items[(int)$r['ItemID']]??$this->db->one('SELECT * FROM items WHERE id=?',[(int)$r['ItemID']]);if($item)$this->queueRewardItem($u,$item,max(1,(int)$r['Quantity']));}
        if($r)$this->server->sendRaw($u,['server','You successfully earned '.(int)$r['Coins'].' Coins, '.(int)$r['Gold'].' Gold, '.(int)$r['Exp'].' Experience, '.(int)$r['ClassPoints'].' Class Points!']);
    }
    private function getDrop(ClientSession $u,array $p): void
    {
        $itemId=(int)($p[0]??0);$qty=max(1,(int)($u->pendingDrops[$itemId]??$p[1]??1));$item=$this->db->one('SELECT * FROM items WHERE id=?',[$itemId]);if(!$item)return;
        $gd=['cmd'=>'getDrop','ItemID'=>$itemId,'bSuccess'=>'0'];
        // Keep the Java anti-packet-edit rule when we actually have pending-drop state.
        if($u->pendingDrops && !isset($u->pendingDrops[$itemId])){$this->server->sendJson($u,$gd);return;}
        if((int)$this->db->scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=1',[$u->dbId,$itemId],0)>0){$this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'This item is already in your bank!','strGlow'=>'red,medium','bitSuccess'=>0]);return;}
        $char=0;$finalQty=$qty;
        try{$this->db->tx(function(Database $db)use($u,$item,$itemId,$qty,&$char,&$finalQty){$cur=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$itemId]);if($cur){$char=(int)$cur['id'];$stack=max(1,(int)$item['Stack']);$new=(int)$cur['Quantity']+$qty;if($new>$stack)throw new \RuntimeException('stack full');$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$new,$char]);$finalQty=$qty;}else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,0,?,0,0,NOW())',[$u->dbId,$itemId,(int)$item['EnhID'],$qty]);$char=(int)$db->lastInsertId();}});}catch(Throwable){$this->server->sendJson($u,$gd);return;}
        $gd['CharItemID']=$char;$gd['bBank']=false;$gd['iQty']=$finalQty;$gd['bSuccess']='1';$enh=$this->db->one('SELECT * FROM enhancements WHERE id=?',[(int)$item['EnhID']]);if($enh){$gd['EnhID']=(int)$item['EnhID'];$gd['EnhLvl']=(int)$enh['Level'];$gd['EnhPatternID']=(int)$enh['PatternID'];$gd['EnhRty']=(int)$enh['Rarity'];}if((string)$item['ReqQuests']!=='')$gd['showDrop']='1';
        unset($u->pendingDrops[$itemId]);$this->server->sendJson($u,$gd);
    }
    private function mapItem(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0);if($id<=0)return;$mapName=explode('-',$u->roomName)[0];$mapId=(int)$this->db->scalar('SELECT id FROM maps WHERE LOWER(Name)=LOWER(?)',[$mapName],0);if($mapId<=0)return;$allowed=(int)$this->db->scalar('SELECT COUNT(*) FROM maps_items WHERE MapID=? AND ItemID=?',[$mapId,$id],0);if($allowed<1){$this->log->warn('Packet edit getMapItem user='.$u->username.' map='.$mapName.' item='.$id);return;}$item=$this->db->one('SELECT * FROM items WHERE id=?',[$id]);if($item)$this->queueRewardItem($u,$item,max(1,(int)$item['Quantity']));
    }
    private function getAchievement(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0); if($id<=0)return;
        $a=$this->db->one('SELECT * FROM achievements WHERE id=?',[$id]); if(!$a)return;
        $has=(int)$this->db->scalar('SELECT COUNT(*) FROM users_achievements WHERE UserID=? AND AchievementID=?',[$u->dbId,$id],0);
        if(!$has){$this->db->run('INSERT INTO users_achievements (UserID,AchievementID) VALUES (?,?)',[$u->dbId,$id]);$this->server->sendJson($u,['cmd'=>'getAchievement','bitSuccess'=>1,'id'=>$id,'name'=>$a['Name']]);}
    }
    private function setAchievement(ClientSession $u,array $p): void
    { $field=(string)($p[0]??'');$index=max(0,(int)($p[1]??0));$value=(int)($p[2]??0);$this->setAchievementField($u,$field,$index,$value); }
    private function auctionRows(array $types=[],?int $owner=null,?string $keyword=null): array
    {
        $sql="SELECT um.id AuctionID,um.UserID MarketUserID,um.ItemID MarketItemID,um.EnhID MarketEnhID,um.EnhItemID MarketEnhItemID,um.Datetime,um.BuyerID,um.Gold AuctionGold,um.Coins AuctionCoins,um.Quantity AuctionQty,um.Type MarketType,um.Status MarketStatus,u.Name Player,i.* FROM users_markets um INNER JOIN users u ON u.id=um.UserID INNER JOIN items i ON i.id=um.ItemID WHERE um.Type='Auction' AND um.Status=0";$params=[];
        if($owner!==null){$sql.=' AND um.UserID=?';$params[]=$owner;}else{$sql.=' AND um.BuyerID IS NULL AND um.Datetime>=NOW()';}
        if($keyword!==null&&$keyword!==''){$sql.=' AND i.Name LIKE ?';$params[]='%'.$keyword.'%';}
        if($types&&!in_array('All',$types,true)){$ph=implode(',',array_fill(0,count($types),'?'));$sql.=" AND i.Type IN ({$ph})";array_push($params,...$types);}
        return $this->db->all($sql.' ORDER BY um.id DESC LIMIT 250',$params);
    }
    private function auctionItem(array $r,bool $retrieve=false): array
    {
        $itemRow=$r;$itemRow['EnhID']=(int)($r['MarketEnhID']??$r['EnhID']??0);$itemRow['EnhItemID']=(int)($r['MarketEnhItemID']??0);
        $o=$this->itemJson($itemRow,(int)($r['AuctionQty']??1));$o['AuctionID']=(int)$r['AuctionID'];
        $buyer=(int)($r['BuyerID']??0);$expiry=strtotime((string)($r['Datetime']??''));$remaining=$expiry===false?0:max(0,$expiry-time());
        if($buyer>0){$o['Player']='<font color="#00FF00">Sold Out</font>';$remaining=0;}elseif($expiry!==false&&$expiry<=time()){$o['Player']="<font color='#FF0000'>Expired</font>";}elseif($retrieve){$o['Player']='On Listing';}else{$o['Player']=$r['Player']??'';}
        $h=intdiv($remaining,3600);$m=intdiv($remaining%3600,60);$sec=$remaining%60;$o['Duration']=sprintf('%02d:%02d:%02d',$h,$m,$sec);$o['Gold']=(int)($r['AuctionGold']??0);$o['Coins']=(int)($r['AuctionCoins']??0);return $o;
    }
    private function loadAuction(ClientSession $u,array $p,bool $retrieve): void
    {
        $types=array_values(array_filter(array_map('strval',$p)));$rows=$this->auctionRows($types,$retrieve?$u->dbId:null,null);$items=[];foreach($rows as $r)$items[]=$this->auctionItem($r,$retrieve);$this->server->sendJson($u,['cmd'=>$retrieve?'loadRetrieve':'loadAuction','items'=>$items,'bitSuccess'=>1]);
    }
    private function searchAuction(ClientSession $u,array $p): void
    {
        $rows=$this->auctionRows([],null,trim((string)($p[0]??'')));$items=[];foreach($rows as $r)$items[]=$this->auctionItem($r);$this->server->sendJson($u,['cmd'=>'loadAuction','items'=>$items,'bitSuccess'=>$items?1:0,'strMessage'=>$items?'':'Your search did not match any items.']);
    }
    private function sellAuction(ClientSession $u,array $p): void
    {
        $itemId=(int)($p[0]??0);$charId=(int)($p[1]??0);$qty=max(1,(int)($p[2]??1));$gold=(int)($p[3]??0);$coins=(int)($p[4]??0);$out=['cmd'=>'sellAuctionItem','bitSuccess'=>0,'CharItemID'=>-1];
        if($gold<0||$gold>10000000||$coins<0||$coins>10000000){$out['strMessage']='Auction prices must be between 0 and 10,000,000.';$this->server->sendJson($u,$out);return;}
        $r=$this->db->one('SELECT ui.*,i.Name,i.Stack,i.Trade,i.Market FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.ItemID=? AND ui.Bank=0 LIMIT 1',[$charId,$u->dbId,$itemId]);
        if(!$r||$qty>(int)$r['Quantity']){$out['strMessage']='Quantity requirement for turning in item is lacking.';$this->server->sendJson($u,$out);return;}
        if((int)$r['Market']!==1){$out['strMessage']=(string)$r['Name'].' is a non-marketable item!';$this->server->sendJson($u,$out);return;}
        if((int)$r['Equipped']===1||(int)$r['Wear']===1){$out['strMessage']='Unequip the item before auctioning it.';$this->server->sendJson($u,$out);return;}
        $slots=(int)$this->db->scalar("SELECT COUNT(*) FROM users_markets WHERE UserID=? AND Status=0 AND BuyerID IS NULL AND Type='Auction'",[$u->dbId],0);
        if($slots>=(int)($u->user['SlotsAuction']??0)){$out['strMessage']='You have reached the maximum amount of auctions limit!';$this->server->sendJson($u,$out);return;}
        if((int)($u->user['Coins']??0)<1000){$out['strMessage']='You need atleast 1000 Coins to list your items on Auction House for 24 hours!';$this->server->sendJson($u,$out);return;}
        try{$this->db->tx(function(Database $db)use($u,$r,$qty,$gold,$coins){
            if($qty===(int)$r['Quantity'])$db->run('DELETE FROM users_items WHERE id=?',[(int)$r['id']]);else$db->run('UPDATE users_items SET Quantity=Quantity-? WHERE id=?',[$qty,(int)$r['id']]);
            $db->run("INSERT INTO users_markets_logs (OwnerID,BuyerID,Coins,Gold,ItemID,EnhID,Quantity,Market,Type) VALUES (?,NULL,?,?,?,?,?,'Auction','Sell')",[$u->dbId,$coins,$gold,(int)$r['ItemID'],(int)$r['EnhID'],$qty]);
            // SellAuctionItem.java creates a 24-hour listing. Store the expiry explicitly;
            // relying on the schema CURRENT_TIMESTAMP made new PHP listings immediately expire.
            $db->run("INSERT INTO users_markets (UserID,ItemID,Datetime,BuyerID,Coins,Gold,Quantity,EnhID,EnhItemID,Type,Status) VALUES (?,?,DATE_ADD(NOW(),INTERVAL 24 HOUR),NULL,?,?,?,?,?, 'Auction',0)",[$u->dbId,(int)$r['ItemID'],$coins,$gold,$qty,(int)$r['EnhID'],(int)($r['EnhItemID']??0)]);
            $db->run('UPDATE users SET Coins=Coins-1000 WHERE id=?',[$u->dbId]);
        });}catch(Throwable $e){$out['strMessage']='Auction listing failed.';$this->log->warn('Auction sell failed: '.$e->getMessage());$this->server->sendJson($u,$out);return;}
        $u->user['Coins']=max(0,(int)$u->user['Coins']-1000);$out=['cmd'=>'sellAuctionItem','bitSuccess'=>1,'CharItemID'=>$charId,'Quantity'=>$qty];$this->server->sendJson($u,['cmd'=>'updateGoldCoins','coins'=>(int)$u->user['Coins']]);$this->server->sendJson($u,$out);
    }

    private function buyAuction(ClientSession $u,array $p): void
    {
        $id=(int)($p[0]??0);$result=['cmd'=>'buyAuctionItem','bitSuccess'=>0,'CharItemID'=>-1,'AuctionID'=>$id];
        try{$this->db->tx(function(Database $db)use($u,$id,&$result){
            $r=$db->one("SELECT um.id AuctionID,um.UserID MarketUserID,um.ItemID MarketItemID,um.EnhID MarketEnhID,um.EnhItemID MarketEnhItemID,um.BuyerID,um.Gold AuctionGold,um.Coins AuctionCoins,um.Quantity AuctionQty,um.Status MarketStatus,um.Datetime,i.*,seller.Access SellerAccess FROM users_markets um INNER JOIN items i ON i.id=um.ItemID INNER JOIN users seller ON seller.id=um.UserID WHERE um.id=? AND um.Type='Auction' AND um.Status=0 AND um.BuyerID IS NULL AND um.Datetime>=NOW() FOR UPDATE",[$id]);if(!$r)throw new \RuntimeException('Auction listing could not be found.');
            if((int)$r['MarketUserID']===$u->dbId)throw new \RuntimeException('You cannot buy your own item! If you want to reclaim it, use the Retrieve tab.');
            if((int)($r['Upgrade']??0)===1&&(int)($u->user['UpgradeDays']??0)<=0)throw new \RuntimeException('This item is member only!');
            if((int)($r['Level']??1)>$u->level)throw new \RuntimeException('Level requirement not met!');
            if(((int)($r['Staff']??0)===1||(int)($r['SellerAccess']??0)>=40)&&$u->access<40)throw new \RuntimeException('Test Item: Cannot be purchased yet!');
            if($u->access>=40&&(int)($r['SellerAccess']??0)<40)throw new \RuntimeException('Staff restriction: unable to buy player items!');
            $factionId=(int)($r['FactionID']??0);$reqRep=(int)($r['ReqReputation']??0);if($factionId>1){$rep=(int)$db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$u->dbId,$factionId],-1);if($rep<$reqRep)throw new \RuntimeException('Reputation requirement not met! ('.$factionId.'/'.$reqRep.')');}
            $itemId=(int)$r['MarketItemID'];$qty=max(1,(int)$r['AuctionQty']);
            $existing=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$itemId]);
            if(!$existing){$house=in_array((string)$r['Equipment'],['ho','hi'],true);$slots=(int)($u->user[$house?'SlotsHouse':'SlotsBag']??0);$bag=(int)$db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i2 ON i2.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ".($house?"i2.Equipment IN ('ho','hi')":"i2.Equipment NOT IN ('ho','hi')"),[$u->dbId],0);if($bag>=$slots)throw new \RuntimeException($house?'House Inventory Full!':'Inventory Full!');}
            $me=$db->one('SELECT Gold,Coins FROM users WHERE id=? FOR UPDATE',[$u->dbId]);$priceGold=(int)$r['AuctionGold'];$priceCoins=(int)$r['AuctionCoins'];if(!$me||(int)$me['Gold']<$priceGold||(int)$me['Coins']<$priceCoins)throw new \RuntimeException('Insufficient funds!');
            $char=0;if($existing){if((int)$r['Stack']<=1)throw new \RuntimeException('You cannot have more than 1 of that item!');$new=(int)$existing['Quantity']+$qty;if($new>(int)$r['Stack'])throw new \RuntimeException('You cannot have more than '.$r['Stack'].' of that item!');$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$new,(int)$existing['id']]);$char=(int)$existing['id'];}
            else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,EnhItemID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,?,0,?,0,0,NOW())',[$u->dbId,$itemId,(int)$r['MarketEnhID'],(int)($r['MarketEnhItemID']??0),$qty]);$char=(int)$db->lastInsertId();}
            $db->run("INSERT INTO users_markets_logs (OwnerID,BuyerID,Coins,Gold,ItemID,EnhID,Quantity,Market,Type) VALUES (?,?,?,?,?,?,?,'Auction','Buy')",[(int)$r['MarketUserID'],$u->dbId,$priceCoins,$priceGold,$itemId,(int)$r['MarketEnhID'],$qty]);
            $db->run('UPDATE users SET Gold=Gold-?,Coins=Coins-? WHERE id=?',[$priceGold,$priceCoins,$u->dbId]);$db->run("UPDATE users_markets SET BuyerID=?,Status=0 WHERE id=? AND Type='Auction'",[$u->dbId,$id]);
            $u->user['Gold']=(int)$me['Gold']-$priceGold;$u->user['Coins']=(int)$me['Coins']-$priceCoins;$itemRow=$r;$itemRow['EnhID']=(int)$r['MarketEnhID'];$itemRow['EnhItemID']=(int)($r['MarketEnhItemID']??0);$item=$this->itemJson($itemRow,$qty,$char);$item['AuctionID']=$id;$item['bBank']=0;$item['iReqCP']=(int)($r['ReqClassPoints']??0);$item['iReqRep']=$reqRep;$item['FactionID']=$factionId;$item['sFaction']=(string)($this->world->factions[$factionId]['Name']??'');$result=['cmd'=>'buyAuctionItem','bitSuccess'=>1,'CharItemID'=>$char,'AuctionID'=>$id,'item'=>$item];
        });}catch(Throwable $e){$result['strMessage']=$e->getMessage();}
        if(($result['bitSuccess']??0)==1)$this->server->sendJson($u,['cmd'=>'updateGoldCoins','gold'=>(int)$u->user['Gold'],'coins'=>(int)$u->user['Coins']]);$this->server->sendJson($u,$result);
    }

    private function retrieveAuction(ClientSession $u,array $p,string $cmd): void
    {
        if($cmd==='retrieveAuctionItem'){$this->retrieveAuctionOne($u,(int)($p[0]??0));return;}
        $this->retrieveAuctionAll($u);
    }

    private function retrieveAuctionOne(ClientSession $u,int $id): void
    {
        $out=['cmd'=>'retrieveAuctionItem','bitSuccess'=>0,'CharItemID'=>-1,'AuctionID'=>$id];
        if($id<=0){$out['strMessage']='Error[1]: Invalid Auction ID!';$this->server->sendJson($u,$out);return;}
        $goldCap=(int)($this->world->rates['intGoldCap']??1000000);$coinsCap=(int)($this->world->rates['intCoinsCap']??1000000);$walletChanged=false;
        try{$this->db->tx(function(Database $db)use($u,$id,$goldCap,$coinsCap,&$out,&$walletChanged){
            $r=$db->one("SELECT um.id AuctionID,um.UserID MarketUserID,um.ItemID MarketItemID,um.EnhID MarketEnhID,um.EnhItemID MarketEnhItemID,um.BuyerID,um.Gold AuctionGold,um.Coins AuctionCoins,um.Quantity AuctionQty,um.Status MarketStatus,i.* FROM users_markets um INNER JOIN items i ON i.id=um.ItemID WHERE um.id=? AND um.Type='Auction' FOR UPDATE",[$id]);
            if(!$r)throw new \RuntimeException('Error[1]: Invalid Auction ID!');if((int)$r['MarketUserID']!==$u->dbId)throw new \RuntimeException('Error[2]: Invalid Auction ID!');if((int)$r['MarketStatus']!==0)throw new \RuntimeException('You have already claimed this auction item or reward.');
            $out['AuctionID']=$id;
            if((int)($r['BuyerID']??0)>0){$w=$db->one('SELECT Gold,Coins FROM users WHERE id=? FOR UPDATE',[$u->dbId]);$gold=(int)$w['Gold']+(int)$r['AuctionGold'];$coins=(int)$w['Coins']+(int)$r['AuctionCoins'];if($gold>$goldCap)throw new \RuntimeException('You have already reached maximum amount of gold!');if($coins>$coinsCap)throw new \RuntimeException('You have already reached maximum amount of coins!');$db->run('UPDATE users SET Gold=?,Coins=? WHERE id=?',[$gold,$coins,$u->dbId]);$db->run("UPDATE users_markets SET Status=1 WHERE id=? AND Type='Auction'",[$id]);$u->user['Gold']=$gold;$u->user['Coins']=$coins;$walletChanged=true;$out['bitSuccess']=1;return;}
            $itemId=(int)$r['MarketItemID'];$existing=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$itemId]);
            if(!$existing){$house=in_array((string)$r['Equipment'],['ho','hi'],true);$count=(int)$db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i2 ON i2.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ".($house?"i2.Equipment IN ('ho','hi')":"i2.Equipment NOT IN ('ho','hi')"),[$u->dbId],0);$slots=(int)($u->user[$house?'SlotsHouse':'SlotsBag']??0);if($count>=$slots)throw new \RuntimeException($house?'House Inventory Full!':'Inventory Full!');}
            $char=0;if($existing){$char=(int)$existing['id'];if((int)$r['Stack']<=1)throw new \RuntimeException('You cannot have more than '.(int)$r['Stack'].' of that item!');$new=(int)$existing['Quantity']+(int)$r['AuctionQty'];if($new>(int)$r['Stack'])throw new \RuntimeException('You cannot have more than '.(int)$r['Stack'].' of that item!');$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$new,$char]);}
            else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,EnhItemID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,?,0,?,0,0,NOW())',[$u->dbId,$itemId,(int)$r['MarketEnhID'],(int)($r['MarketEnhItemID']??0),(int)$r['AuctionQty']]);$char=(int)$db->lastInsertId();}
            $db->run("INSERT INTO users_markets_logs (OwnerID,BuyerID,Coins,Gold,ItemID,EnhID,Quantity,Market,Type) VALUES (?,NULL,?,?,?,?,?,'Auction','Retrieve')",[$u->dbId,(int)$r['AuctionCoins'],(int)$r['AuctionGold'],$itemId,(int)$r['MarketEnhID'],(int)$r['AuctionQty']]);$db->run("UPDATE users_markets SET Status=1 WHERE id=? AND Type='Auction'",[$id]);
            $itemRow=$r;$itemRow['EnhID']=(int)$r['MarketEnhID'];$itemRow['EnhItemID']=(int)($r['MarketEnhItemID']??0);$item=$this->itemJson($itemRow,(int)$r['AuctionQty'],$char);$item['AuctionID']=$id;$item['bBank']=0;$item['bHouse']=in_array((string)$r['Equipment'],['ho','hi'],true)?1:0;$out['CharItemID']=$char;$out['item']=$item;$out['bitSuccess']=1;
        });}catch(Throwable $e){$out['strMessage']=$e->getMessage();}
        if($walletChanged)$this->server->sendJson($u,['cmd'=>'updateGoldCoins','gold'=>(int)$u->user['Gold'],'coins'=>(int)$u->user['Coins']]);$this->server->sendJson($u,$out);
    }

    private function retrieveAuctionAll(ClientSession $u): void
    {
        $out=['cmd'=>'retrieveAuctionItems','bitSuccess'=>0,'items'=>[]];$goldCap=(int)($this->world->rates['intGoldCap']??1000000);$coinsCap=(int)($this->world->rates['intCoinsCap']??1000000);$walletChanged=false;
        try{$this->db->tx(function(Database $db)use($u,$goldCap,$coinsCap,&$out,&$walletChanged){
            $rows=$db->all("SELECT um.id AuctionID,um.UserID MarketUserID,um.ItemID MarketItemID,um.EnhID MarketEnhID,um.EnhItemID MarketEnhItemID,um.BuyerID,um.Gold AuctionGold,um.Coins AuctionCoins,um.Quantity AuctionQty,um.Status MarketStatus,i.* FROM users_markets um INNER JOIN items i ON i.id=um.ItemID WHERE um.UserID=? AND um.Status=0 AND um.Type='Auction' ORDER BY um.id FOR UPDATE",[$u->dbId]);$w=$db->one('SELECT Gold,Coins FROM users WHERE id=? FOR UPDATE',[$u->dbId]);$gold=(int)$w['Gold'];$coins=(int)$w['Coins'];$items=[];
            // Validate the complete claim set before committing. The Java bulk
            // routine only compared the current bag count with the number of auction
            // rows, which could overflow slots or stacks when several listings of the
            // same/new item were claimed together. Track reserved slots/quantities so
            // the transaction is atomic and the client never receives impossible items.
            $bagUsed=(int)$db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i2 ON i2.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND i2.Equipment NOT IN ('ho','hi')",[$u->dbId],0);
            $houseUsed=(int)$db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i2 ON i2.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND i2.Equipment IN ('ho','hi')",[$u->dbId],0);
            $reserved=[];
            foreach($rows as $r){
                if((int)($r['BuyerID']??0)>0){if($gold+(int)$r['AuctionGold']>$goldCap)throw new \RuntimeException('Maximum amount of gold limit reached!');if($coins+(int)$r['AuctionCoins']>$coinsCap)throw new \RuntimeException('Maximum amount of coins limit reached!');$gold+=(int)$r['AuctionGold'];$coins+=(int)$r['AuctionCoins'];continue;}
                $iid=(int)$r['MarketItemID'];$qty=(int)$r['AuctionQty'];$stack=max(1,(int)$r['Stack']);
                if(!array_key_exists($iid,$reserved)){$existing=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$iid]);$reserved[$iid]=$existing?(int)$existing['Quantity']:0;if(!$existing){$house=in_array((string)$r['Equipment'],['ho','hi'],true);if($house){if($houseUsed>=(int)($u->user['SlotsHouse']??0))throw new \RuntimeException('House Inventory Full!');$houseUsed++;}else{if($bagUsed>=(int)($u->user['SlotsBag']??0))throw new \RuntimeException('Inventory Full!');$bagUsed++;}}}
                if($reserved[$iid]+$qty>$stack)throw new \RuntimeException('You cannot have more than '.$stack.' of '.(string)$r['Name'].'!');$reserved[$iid]+=$qty;
            }
            foreach($rows as $r){$itemId=(int)$r['MarketItemID'];$itemRow=$r;$itemRow['EnhID']=(int)$r['MarketEnhID'];$itemRow['EnhItemID']=(int)($r['MarketEnhItemID']??0);$obj=$this->itemJson($itemRow,(int)$r['AuctionQty']);$obj['AuctionID']=(int)$r['AuctionID'];$obj['bBank']=0;$obj['bHouse']=in_array((string)$r['Equipment'],['ho','hi'],true)?1:0;if((int)($r['BuyerID']??0)>0){$obj['bSold']=1;$walletChanged=true;}else{$existing=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$u->dbId,$itemId]);if($existing){$char=(int)$existing['id'];$db->run('UPDATE users_items SET Quantity=Quantity+? WHERE id=?',[(int)$r['AuctionQty'],$char]);}else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,EnhItemID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,?,0,?,0,0,NOW())',[$u->dbId,$itemId,(int)$r['MarketEnhID'],(int)($r['MarketEnhItemID']??0),(int)$r['AuctionQty']]);$char=(int)$db->lastInsertId();}$obj['CharItemID']=$char;$db->run("INSERT INTO users_markets_logs (OwnerID,BuyerID,Coins,Gold,ItemID,EnhID,Quantity,Market,Type) VALUES (?,NULL,?,?,?,?,?,'Auction','Retrieve')",[$u->dbId,(int)$r['AuctionCoins'],(int)$r['AuctionGold'],$itemId,(int)$r['MarketEnhID'],(int)$r['AuctionQty']]);}$db->run("UPDATE users_markets SET Status=1 WHERE id=? AND Type='Auction'",[(int)$r['AuctionID']]);$items[]=$obj;}
            if($walletChanged){$db->run('UPDATE users SET Gold=?,Coins=? WHERE id=?',[$gold,$coins,$u->dbId]);$u->user['Gold']=$gold;$u->user['Coins']=$coins;}$out['items']=$items;$out['bitSuccess']=1;
        });}catch(Throwable $e){$out['strMessage']=$e->getMessage();}
        if($walletChanged)$this->server->sendJson($u,['cmd'=>'updateGoldCoins','gold'=>(int)$u->user['Gold'],'coins'=>(int)$u->user['Coins']]);$this->server->sendJson($u,$out);
    }
    private function bankSwap(ClientSession $u,array $p): void
    {
        $itemId1=(int)($p[0]??0);$char1=(int)($p[1]??0);$itemId2=(int)($p[2]??0);$char2=(int)($p[3]??0);
        $out=['cmd'=>'bankSwapInv','bitSuccess'=>0,'bSuccess'=>0,'invItemID'=>$itemId1,'bankItemID'=>$itemId2,'CharItemID'=>$char1,'CharItemID2'=>$char2];
        $a=$this->db->one('SELECT ui.id,ui.ItemID,ui.Bank,i.Temporary,i.Coins FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=?',[$char1,$u->dbId]);
        $b=$this->db->one('SELECT ui.id,ui.ItemID,ui.Bank,i.Temporary FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=?',[$char2,$u->dbId]);
        if(!$a||!$b||(int)$a['ItemID']!==$itemId1||(int)$b['ItemID']!==$itemId2||(int)$a['Bank']!==0||(int)$b['Bank']!==1){$this->recordViolation($u,'Packet Edit [BankSwapInventory]','Attempting to swap items not in possession or in invalid bank state.');$this->server->sendJson($u,$out);return;}
        if((int)$a['Temporary']===1||(int)$b['Temporary']===1){$this->recordViolation($u,'Packet Edit [BankSwapInventory]','Attempting to transfer temporary items.');$this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'Cannot transfer temporary items','strGlow'=>'red,medium','bitSuccess'=>0]);return;}
        // Match Java: the inventory item is about to consume a bank slot. Coins do
        // not count toward the normal bank-slot cap.
        if((int)$a['Coins']!==1){$bankCount=(int)$this->db->scalar('SELECT COUNT(*) FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=1 AND i.Coins=0',[$u->dbId],0);if($bankCount>=(int)($u->user['SlotsBank']??0)){$this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'Bank Inventory Full!','strGlow'=>'red,medium','bitSuccess'=>0]);return;}}
        try{$this->db->tx(function(Database $db)use($char1,$char2){$db->run('UPDATE users_items SET Bank=1,Equipped=0,Wear=0 WHERE id=?',[$char1]);$db->run('UPDATE users_items SET Bank=0,Equipped=0,Wear=0 WHERE id=?',[$char2]);});$out['bitSuccess']=$out['bSuccess']=1;}catch(Throwable $e){$out['msg']=$out['strMessage']='Bank swap failed.';$this->log->warn('bankSwap failed: '.$e->getMessage());}
        $this->server->sendJson($u,$out);
    }
    private function cannedChat(ClientSession $u,array $p): void { $r=$this->server->currentRoom($u);if($r)$this->server->broadcastRaw(['cc',(string)($p[0]??''),$u->username],$r); }
    private function emote(ClientSession $u,array $p,string $cmd): void { $r=$this->server->currentRoom($u);if(!$r)return;if($cmd==='em')$this->server->broadcastRaw(['em',$u->username,(string)($p[0]??'')],$r);else$this->server->broadcastRaw(['emotea',(string)($p[0]??''),(string)$u->sfsUserId],$r,$u); }
    private function duelInvite(ClientSession $u,array $p): void
    {
        $name=trim((string)($p[0]??''));$t=$this->server->findUser($name);
        if(!$t){$this->server->sendRaw($u,['warning','Player "'.$name.'" could not be found.']);return;}
        if($t===$u){$this->server->sendRaw($u,['warning','You cannot challenge yourself to a duel!']);return;}
        if(!SettingsCodec::allowed('bDuel',$u,$t)){$this->server->sendRaw($u,['warning','Player "'.$t->username.'" is not accepting duel invites.']);return;}
        if($u->ip===$t->ip&&$u->access<40){$this->server->sendRaw($u,['warning','You cannot challenge someone on your network to a duel.']);return;}
        if($t->state===2){$this->server->sendRaw($u,['warning',$t->username.' is currently busy.']);return;}
        $t->duelInviteFrom=$u->sfsUserId;
        $this->server->sendJson($t,['owner'=>$u->username,'cmd'=>'di']);
        $this->server->sendRaw($u,['server','You have challenged '.$t->username.' to a duel.']);
    }
    private function duelReply(ClientSession $u,array $p,bool $accept): void
    {
        $name=trim((string)($p[0]??''));$from=$this->server->findUser($name);
        if(!$from)return;
        if($u->duelInviteFrom!==$from->sfsUserId){$this->log->warn('Rejected forced duel reply from '.$u->username.' for '.$name);return;}
        $u->duelInviteFrom=null;
        if(!$accept){$this->server->sendRaw($from,['server',$u->username.' declined your duel challenge.']);return;}
        if($u->state===2||$from->state===2){$this->server->sendRaw($u,['warning','Unable to start duel while a player is busy.']);return;}
        $uRoom=$this->server->currentRoom($u);$fromRoom=$this->server->currentRoom($from);
        if((int)($uRoom?->map['PvP']??0)===1||(int)($fromRoom?->map['PvP']??0)===1){$this->server->sendRaw($u,['warning','Unable to start a duel while either player is on a PvP battlefield.']);return;}
        $room=$this->server->createPreparedPvpRoom('deadlock');if(!$room){$this->server->sendRaw($u,['warning','Unable to create the duel room.']);return;}
        $room->meta['pvp']['factions']=[['id'=>$u->sfsUserId,'sName'=>$u->username],['id'=>$from->sfsUserId,'sName'=>$from->username]];
        $u->pvpRoomId=$room->id;$u->pvpRoomName=$room->name;$u->pvpTeam=0;$u->pvpJoinAt=0.0;
        $from->pvpRoomId=$room->id;$from->pvpRoomName=$room->name;$from->pvpTeam=1;$from->pvpJoinAt=0.0;
        if(!$this->server->joinPreparedRoom($u,$room->id,'Enter0','Spawn'))return;
        if(!$this->server->joinPreparedRoom($from,$room->id,'Enter1','Spawn'))return;
        $this->server->sendJson($u,['cmd'=>'DuelEX']);
        $this->server->sendJson($from,['cmd'=>'DuelEX']);
    }
    private function enhanceItem(ClientSession $u,array $p,string $cmd): void
    {
        // Newer stock clients can send a comma-separated list for shop enhancement;
        // legacy Java accepted one target. Supporting both preserves the Java packet
        // contract while matching this client's multi-select UI.
        $rawTargets=$p[0]??'';$targetIds=[];
        if(is_array($rawTargets))foreach($rawTargets as $x)if((int)$x>0)$targetIds[]=(int)$x;
        else foreach(preg_split('/\s*,\s*/',(string)$rawTargets,-1,PREG_SPLIT_NO_EMPTY)?:[] as $x)if(ctype_digit((string)$x)&&(int)$x>0)$targetIds[]=(int)$x;
        $targetIds=array_values(array_unique($targetIds));if(!$targetIds&&is_numeric($rawTargets)&&(int)$rawTargets>0)$targetIds=[(int)$rawTargets];
        $enhItemId=(int)($p[1]??0);$enhItem=$this->world->items[$enhItemId]??$this->db->one('SELECT * FROM items WHERE id=?',[$enhItemId]);
        if(!$targetIds||!$enhItem||strcasecmp((string)($enhItem['Type']??''),'Enhancement')!==0){$this->recordViolation($u,'Packet Edit ['.$cmd.']','Invalid target or enhancement item.');return;}
        $owned=[];foreach($targetIds as $targetId){$r=$this->db->one('SELECT ui.id,ui.ItemID,ui.Equipped,ui.Wear,ui.Bank,i.Equipment FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.ItemID=? AND ui.Bank=0 LIMIT 1',[$u->dbId,$targetId]);if(!$r){$this->recordViolation($u,'Packet Edit ['.$cmd.']','Attempting to enhance unowned ItemID '.$targetId.'.');return;}$owned[$targetId]=$r;}
        $enhResolution=$this->resolveEnhancement($enhItemId,(string)($enhItem['Equipment']??''));$enh=$enhResolution['definition'];if(!$enh){$this->recordViolation($u,'Packet Edit ['.$cmd.']','Enhancement definition not found.');return;}$enhId=(int)$enh['id'];$enhEquipment=$this->normalizeEnhancementEquipment((string)($enhItem['Equipment']??''),(string)($enhItem['Name']??''));if($enhEquipment!==''&&$enhEquipment!=='None'){foreach($targetIds as $targetId){$targetEquipment=(string)($owned[$targetId]['Equipment']??'');if($targetEquipment!==$enhEquipment){$this->recordViolation($u,'Packet Edit ['.$cmd.']','Enhancement slot mismatch: '.$enhEquipment.' cannot be applied to '.$targetEquipment.'.');return;}}}
        $shop=($cmd==='enhanceItemShop'||$cmd==='enhanceItem');$cost=max(0,(int)($enhItem['Cost']??0))*count($targetIds);$currency=(int)($enhItem['Coins']??0)===1?'Coins':'Gold';
        if($shop){$hasReq=(int)$this->db->scalar('SELECT COUNT(*) FROM items_requirements WHERE ItemID=?',[$enhItemId],0);if($hasReq>0){$this->recordViolation($u,'Packet Edit [EnhanceItemShop]','Trying to use an enhancement that can only be used locally.');return;}if((int)($u->user[$currency]??0)<$cost){$this->recordViolation($u,'Packet Edit [EnhanceItemShop]','Sent an enhancement request while lacking funds.');return;}}
        else {if(count($targetIds)!==1){$this->recordViolation($u,'Packet Edit [EnhanceItemLocal]','Local enhancement must contain one target.');return;}$have=(int)$this->db->scalar('SELECT COALESCE(SUM(Quantity),0) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$enhItemId],0);if($have<1){$this->recordViolation($u,'Packet Edit [EnhanceItemLocal]','Failed to pass turn in validation.');return;}}
        try{$this->db->tx(function(Database $db)use($u,$targetIds,$enhId,$shop,$currency,$cost,$enhItemId){
            if($shop){$wallet=$db->one('SELECT Gold,Coins FROM users WHERE id=? FOR UPDATE',[$u->dbId]);if(!$wallet||(int)$wallet[$currency]<$cost)throw new \RuntimeException('Insufficient funds.');$db->run("UPDATE users SET `{$currency}`=`{$currency}`-? WHERE id=?",[$cost,$u->dbId]);}
            else {$row=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 ORDER BY id LIMIT 1 FOR UPDATE',[$u->dbId,$enhItemId]);if(!$row||(int)$row['Quantity']<1)throw new \RuntimeException('Enhancement item is missing.');if((int)$row['Quantity']===1)$db->run('DELETE FROM users_items WHERE id=?',[(int)$row['id']]);else$db->run('UPDATE users_items SET Quantity=Quantity-1 WHERE id=?',[(int)$row['id']]);}
            foreach($targetIds as $targetId)$db->run('UPDATE users_items SET EnhID=?,EnhItemID=? WHERE ItemID=? AND UserID=? AND Bank=0',[$enhId,$enhItemId,$targetId,$u->dbId]);
        });}catch(Throwable $e){$this->log->warn($cmd.' failed: '.$e->getMessage());return;}
        if($shop)$u->user[$currency]=(int)$u->user[$currency]-$cost;else $this->server->sendJson($u,['cmd'=>'turnIn','sItems'=>$enhItemId.':1']);
        $packet=['cmd'=>$cmd,'bSuccess'=>1,'bitSuccess'=>1,'EnhName'=>(string)$enh['Name'],'EnhPID'=>(int)$enh['PatternID'],'EnhRng'=>(int)($enhItem['Range']??0),'EnhRty'=>(int)$enh['Rarity'],'EnhDPS'=>(int)$enh['DPS'],'EnhLvl'=>(int)$enh['Level'],'EnhID'=>$enhItemId,'ProcID'=>0,'iCost'=>$shop?$cost:(int)($enhItem['Cost']??0),'ItemID'=>$targetIds[0],'ItemIDs'=>$targetIds,
            // compatibility aliases used by a few custom client revisions
            'EnhPatternID'=>(int)$enh['PatternID'],'iLvl'=>(int)$enh['Level'],'iDPS'=>(int)$enh['DPS'],'EnhSTR'=>(int)($enhResolution['stats']['STR']??0),'EnhINT'=>(int)($enhResolution['stats']['INT']??0),'EnhDEX'=>(int)($enhResolution['stats']['DEX']??0),'EnhEND'=>(int)($enhResolution['stats']['END']??0),'EnhWIS'=>(int)($enhResolution['stats']['WIS']??0),'EnhLCK'=>(int)($enhResolution['stats']['LCK']??0)];
        $this->server->sendJson($u,$packet);
        // Any equipped enhanced target changes derived stats immediately.
        foreach($owned as $r)if((int)$r['Equipped']===1||(int)$r['Wear']===1){$this->sendStats($u);break;}
    }
    private function guildRankName(int $rank): string
    { return [0=>'duffer',1=>'member',2=>'officer',3=>'leader'][$rank]??''; }
    private function guildObject(int $guildId): ?array
    {
        $g=$this->db->one('SELECT * FROM guilds WHERE id=?',[$guildId]);if(!$g)return null;$members=[];
        foreach($this->db->all('SELECT u.id ID,u.Name userName,u.Level,u.CurrentServer Server,ug.Rank FROM users_guilds ug INNER JOIN users u ON u.id=ug.UserID WHERE ug.GuildID=? ORDER BY ug.Rank DESC,u.Name',[$guildId]) as $m)$members[]=['ID'=>(int)$m['ID'],'userName'=>$m['userName'],'Level'=>(string)$m['Level'],'Rank'=>(int)$m['Rank'],'Server'=>(string)$m['Server']];
        $motd=(string)$g['MessageOfTheDay'];if($motd==='')$motd='undefined';
        return ['id'=>(int)$g['id'],'Name'=>$g['Name'],'MOTD'=>$motd,'MessageOfTheDay'=>$motd,'MaxMembers'=>(int)$g['MaxMembers'],'Wins'=>(int)$g['Wins'],'Loses'=>(int)$g['Loses'],'Level'=>(int)$g['Level'],'Color'=>$g['Color'],'Exp'=>(int)$g['Exp'],'ExpToLevel'=>$this->expToLevel((int)$g['Level']),'ul'=>$members];
    }
    private function sendGuildUpdate(int $guildId,?string $msg=null): void
    {
        $g=$this->guildObject($guildId);if(!$g)return;$packet=['cmd'=>'updateGuild','guild'=>$g];if($msg!==null)$packet['msg']=$msg;foreach($this->server->clients() as $c)if((int)($c->user['GuildID']??0)===$guildId)$this->server->sendJson($c,$packet);
    }
    private function guild(ClientSession $u,array $p): void
    {
        $sub=(string)($p[0]??'');$gid=(int)($u->user['GuildID']??0);$rank=(int)($u->user['Rank']??0);
        if($sub==='gc'){
            $name=trim((string)($p[1]??''));if($gid>0){$this->server->sendRaw($u,['warning','You already have a guild!']);return;}if($name===''||strlen($name)>25){$this->server->sendRaw($u,['warning',$name===''?'Please specify a name for your guild.':'Guild names must be 25 characters or less.']);return;}if((int)($u->user['UpgradeDays']??0)<1){$this->server->sendRaw($u,['warning','Only members may create guilds.']);return;}if((int)$u->user['Gold']<=10){$this->server->sendRaw($u,['warning','You do not have enough Gold a guild creation will cost you 10 gold.']);return;}
            try{$this->db->tx(function(Database $db)use($u,$name,&$gid){if((int)$db->scalar('SELECT COUNT(*) FROM guilds WHERE LOWER(Name)=LOWER(?)',[$name],0)>0)throw new \RuntimeException('Guild name is already in use.');$db->run("INSERT INTO guilds (Name,MessageOfTheDay) VALUES (?,'Hello World!')",[$name]);$gid=(int)$db->lastInsertId();$db->run('INSERT INTO users_guilds (GuildID,UserID,Rank) VALUES (?,?,3)',[$gid,$u->dbId]);$db->run('UPDATE users SET Gold=Gold-10 WHERE id=?',[$u->dbId]);});}catch(Throwable $e){$this->server->sendRaw($u,['warning',$e->getMessage()]);return;}
            $u->user['GuildID']=$gid;$u->user['Rank']=3;$u->user['Gold']-=10;$packet=['cmd'=>'gc','uid'=>$u->sfsUserId,'guild'=>$this->guildObject($gid)];$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($packet,$room);else$this->server->sendJson($u,$packet);$this->server->sendRaw($u,['server','Guild '.$name.' successfuly created.']);return;
        }
        if(in_array($sub,['gi','gInv'],true)){
            $name=(string)($p[1]??'');$t=$this->server->findUser($name);if($rank<2||$gid<=0){$this->server->sendRaw($u,['warning','Invalid /gi request.']);return;}if(!$t){$this->server->sendRaw($u,['warning','Player "'.$name.'" could not be found.']);return;}if(!SettingsCodec::allowed('bGuild',$u,$t)){$this->server->sendRaw($u,['server','Player '.$t->username.' is not accepting guild invites.']);return;}if((int)($t->user['GuildID']??0)>0){$this->server->sendRaw($u,['warning',$t->username.' already belongs to a guild.']);return;}if($t->state===2){$this->server->sendRaw($u,['warning',$t->username.' is currently busy.']);return;}$g=$this->guildObject($gid);if(!$g||count($g['ul'])>=(int)$g['MaxMembers']){$this->server->sendRaw($u,['warning','Your guild has reached the maximum number of members.']);return;}$t->guildInvites[$gid]=true;$t->guildInviteId=$gid;$this->server->sendRaw($u,['server','You have invited '.$t->username.' to join your guild.']);$this->server->sendJson($t,['cmd'=>'gi','owner'=>$u->username,'gName'=>$g['Name'],'guildID'=>$gid]);return;
        }
        if($sub==='ga'){
            $invite=(int)($p[1]??0);$ownerName=(string)($p[2]??'');$owner=$this->server->findUser($ownerName);if($invite<=0||(!isset($u->guildInvites[$invite])&&$u->guildInviteId!==$invite)||!$owner||(int)($owner->user['GuildID']??0)!==$invite){$this->log->warn('Rejected forced guild accept from '.$u->username);return;}if((int)($u->user['GuildID']??0)>0)return;
            $this->db->run('INSERT INTO users_guilds (GuildID,UserID,Rank) VALUES (?,?,0) ON DUPLICATE KEY UPDATE GuildID=VALUES(GuildID),Rank=0',[$invite,$u->dbId]);$u->user['GuildID']=$invite;$u->user['Rank']=0;unset($u->guildInvites[$invite]);$u->guildInviteId=0;$g=$this->guildObject($invite);$packet=['cmd'=>'ga','unm'=>$u->username,'guild'=>$g];$room=$this->server->currentRoom($u);if($room)$this->server->broadcastJson($packet,$room);else$this->server->sendJson($u,$packet);$this->sendGuildUpdate($invite);return;
        }
        if($sub==='gdi'){
            $owner=$this->server->findUser((string)($p[2]??''));$declined=0;if($owner)$declined=(int)($owner->user['GuildID']??0);if($declined>0)unset($u->guildInvites[$declined]);if($u->guildInviteId===$declined||$declined===0)$u->guildInviteId=0;$this->server->sendRaw($u,['server','You declined the invitation.']);if($owner)$this->server->sendJson($owner,['cmd'=>'gd','unm'=>$u->username]);return;
        }
        if($gid<=0){$this->server->sendRaw($u,['warning','You do not have a guild!']);return;}
        if($sub==='motd'){
            if($rank<2)return;$motd=substr(trim((string)($p[1]??'')),0,512);$this->db->run('UPDATE guilds SET MessageOfTheDay=? WHERE id=?',[$motd,$gid]);foreach($this->server->clients() as $c)if((int)($c->user['GuildID']??0)===$gid){$this->server->sendJson($c,['cmd'=>'gMOTD','unm'=>$u->username,'msg'=>$motd,'MOTD'=>[$motd]]);$this->server->sendRaw($c,['server','Guild message has been changed.']);}$this->sendGuildUpdate($gid);return;
        }
        if($sub==='slots'){
            if($rank!==3)return;$slots=max(1,(int)($p[1]??1));$g=$this->db->one('SELECT MaxMembers FROM guilds WHERE id=?',[$gid]);$new=(int)$g['MaxMembers']+$slots;if($new>800){$this->server->sendRaw($u,['warning','You have already reached the maximum amount of guild member slots.']);return;}$cost=$slots*500;if((int)$u->user['Coins']<$cost){$this->server->sendRaw($u,['warning',"You don't have enough coins!"]);return;}$this->db->tx(function(Database $db)use($u,$gid,$new,$cost){$db->run('UPDATE users SET Coins=Coins-? WHERE id=?',[$cost,$u->dbId]);$db->run('UPDATE guilds SET MaxMembers=? WHERE id=?',[$new,$gid]);});$u->user['Coins']-=$cost;$this->sendGuildUpdate($gid);$this->server->sendRaw($u,['buyGSlots',(string)$slots]);return;
        }
        if($sub==='rename'){
            if($rank!==3)return;$name=trim((string)($p[1]??''));if($name===''||strlen($name)>25){$this->server->sendRaw($u,['warning','Invalid guild name.']);return;}if((int)$u->user['Coins']<1000){$this->server->sendRaw($u,['warning',"You don't have enough coins!"]);return;}if((int)$this->db->scalar('SELECT COUNT(*) FROM guilds WHERE LOWER(Name)=LOWER(?) AND id<>?',[$name,$gid],0)>0){$this->server->sendRaw($u,['warning','Guild name is already in use.']);return;}$this->db->run('UPDATE guilds SET Name=? WHERE id=?',[$name,$gid]);$this->db->run('UPDATE users SET Coins=Coins-1000 WHERE id=?',[$u->dbId]);$u->user['Coins']-=1000;$this->sendGuildUpdate($gid);$this->server->sendRaw($u,['gRename',$name]);return;
        }
        if($sub==='guildreset'){$this->sendGuildUpdate($gid);return;}
        $name=(string)($p[1]??'');$target=$this->server->findUser($name);$targetDb=$target?->dbId ?: (int)$this->db->scalar('SELECT id FROM users WHERE LOWER(Name)=LOWER(?)',[$name],0);if($targetDb<=0){$this->server->sendRaw($u,['warning','Player "'.$name.'" could not be found.']);return;}$m=$this->db->one('SELECT Rank FROM users_guilds WHERE GuildID=? AND UserID=?',[$gid,$targetDb]);if(!$m){$this->server->sendRaw($u,['warning',$name.' is not in your guild!']);return;}$targetRank=(int)$m['Rank'];
        if($sub==='gr'){
            if(($targetRank>$rank||$rank<2)&&$targetDb!==$u->dbId){$this->server->sendRaw($u,['warning','Invalid /gr request.']);return;}$members=(int)$this->db->scalar('SELECT COUNT(*) FROM users_guilds WHERE GuildID=?',[$gid],0);if($targetRank===3&&$members>1){$this->server->sendRaw($u,['warning','Invalid /gr request.']);return;}$this->db->run('DELETE FROM users_guilds WHERE GuildID=? AND UserID=?',[$gid,$targetDb]);if($targetRank===3&&$members===1)$this->db->run('DELETE FROM guilds WHERE id=?',[$gid]);if($target){$target->user['GuildID']=0;$target->user['Rank']=0;}$g=$this->guildObject($gid)??['Name'=>'','MOTD'=>'','MaxMembers'=>0,'ul'=>[]];$packet=['cmd'=>'gr','unm'=>$name,'guild'=>$g];$room=$target?$this->server->currentRoom($target):null;if($room)$this->server->broadcastJson($packet,$room);else$this->server->sendJson($u,$packet);if($members>1)$this->sendGuildUpdate($gid);return;
        }
        if($sub==='gp'){
            if($rank<2){$this->server->sendRaw($u,['warning','Invalid /gp request.']);return;}$nr=$targetRank+1;if($nr>=$rank){$this->server->sendRaw($u,['warning','Invalid /gp request.']);return;}$this->db->run('UPDATE users_guilds SET Rank=? WHERE GuildID=? AND UserID=?',[$nr,$gid,$targetDb]);if($target)$target->user['Rank']=$nr;$this->sendGuildUpdate($gid,$name."'s rank has been changed.");return;
        }
        if($sub==='gd'){
            if($rank<2||$targetRank>=$rank){$this->server->sendRaw($u,['warning','Invalid /gd request.']);return;}$nr=$targetRank-1;if($nr<0){$this->server->sendRaw($u,['warning','Invalid /gd request.']);return;}$this->db->run('UPDATE users_guilds SET Rank=? WHERE GuildID=? AND UserID=?',[$nr,$gid,$targetDb]);if($target)$target->user['Rank']=$nr;$this->sendGuildUpdate($gid,$name."'s rank has been changed.");return;
        }
    }
    private function house(ClientSession $u,array $p): void
    {
        $name=trim((string)($p[0]??$u->username));if($name==='')$name=$u->username;
        $owner=$this->db->one('SELECT id,Name,HouseInfo FROM users WHERE LOWER(Name)=LOWER(?)',[$name]);
        if(!$owner){$this->server->sendRaw($u,['warning','Player "'.$name.'" could not be found!']);return;}
        $house=$this->db->one("SELECT ui.id CharItemID,ui.Quantity,ui.DatePurchased,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 AND i.Equipment='ho' LIMIT 1",[(int)$owner['id']]);
        if(!$house){
            if((int)$owner['id']===$u->dbId){$this->server->sendRaw($u,['warning','Oops, maybe you forgot to equip the house.']);$this->server->joinGameRoom($u,'faroff');}
            else $this->server->sendRaw($u,['warning','This player does not own a house!']);
            return;
        }
        $items=[];
        foreach($this->db->all("SELECT ui.id UserItemID,ui.Quantity iQty,ui.Equipped,ui.Bank,ui.Wear,ui.EnhID,ui.EnhItemID,ui.DatePurchased,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND i.Equipment IN ('ho','hi') ORDER BY ui.id",[(int)$owner['id']]) as $row)$items[]=$this->itemJson($row,(int)$row['iQty'],(int)$row['UserItemID']);
        $layout=[];
        foreach($this->db->all('SELECT Frame,ItemID,X,Y FROM users_houses WHERE UserID=? ORDER BY id',[(int)$owner['id']]) as $placed){$frame=(string)$placed['Frame'];if(!isset($layout[$frame]))$layout[$frame]=['xi'=>[]];$layout[$frame]['xi'][]=['ID'=>(int)$placed['ItemID'],'x'=>(int)$placed['X'],'y'=>(int)$placed['Y']];}
        $this->server->joinHouse($u,$owner,$house,$items,$layout);
    }
    private function houseSave(ClientSession $u,array $p): void
    { $data=(string)($p[0]??'');if(strlen($data)>100000)return;$this->db->run('UPDATE users SET HouseInfo=? WHERE id=?',[$data,$u->dbId]);$u->user['HouseInfo']=$data;$this->server->updateHouseInfo($u->dbId,$data);$this->server->sendJson($u,['cmd'=>'housesave','bitSuccess'=>1]); }
    private function trapDoor(ClientSession $u,array $p): void
    { $r=$this->server->currentRoom($u);if($r)$this->server->broadcastRaw(['trap door',(string)($p[0]??'')],$r); }
    private function removeItem(ClientSession $u,array $p): void
    {
        $itemId=(int)($p[0]??0);$charId=(int)($p[1]??0);$qty=max(1,(int)($p[2]??1));$r=$this->db->one('SELECT ui.*,i.Stack FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.ItemID=? LIMIT 1',[$charId,$u->dbId,$itemId]);if(!$r)return;if((int)$r['Equipped']===1||(int)$r['Wear']===1){$this->server->sendRaw($u,['warning','Unequip the item before deleting it.']);return;}$qty=min($qty,(int)$r['Quantity']);$left=(int)$r['Quantity']-$qty;if($left>0&&(int)$r['Stack']>1)$this->db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$left,$charId]);else{$this->db->run('DELETE FROM users_items WHERE id=?',[$charId]);$left=0;}$this->server->sendJson($u,['cmd'=>'removeItem','ItemID'=>$itemId,'CharItemID'=>$charId,'iQty'=>$qty,'iQtyNow'=>$left,'bitSuccess'=>1]);
    }
    private function useItem(ClientSession $u,array $p): void
    {
        $option=(string)($p[0]??'');
        if($option==='-'){
            $type=strtolower((string)($p[1]??''));
            if(in_array($type,['xpboost','gboost','coinsboost','cpboost','repboost'],true)){$u->boostFlags[$type]=false;$this->server->sendJson($u,['cmd'=>$type,'op'=>'-']);}
            return;
        }
        if($option!=='+')return;
        $itemId=(int)($p[1]??0);$r=$this->db->one("SELECT ui.id CharItemID,ui.Quantity,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.ItemID=? AND ui.Bank=0 AND i.Type='ServerUse' LIMIT 1",[$u->dbId,$itemId]);
        if(!$r){$this->server->sendRaw($u,['warning','Usable item not found.']);return;}
        if((int)($r['Upgrade']??0)===1&&(int)($u->user['UpgradeDays']??0)<=0){$this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'This item is member only!','strGlow'=>'red,medium','bitSuccess'=>0]);return;}
        $parts=array_map('trim',explode('::',(string)$r['Link']));if(count($parts)<2){$this->server->sendRaw($u,['server','This feature is not yet available.']);return;}
        $type=strtolower((string)$parts[0]);$value=(int)$parts[1];$showShop=(string)($parts[2]??'undefined');
        if($type==='achievement'&&$value>0){
            if((int)$this->db->scalar('SELECT COUNT(*) FROM users_achievements WHERE UserID=? AND AchievementID=?',[$u->dbId,$value],0)>0){$this->server->sendRaw($u,['server','You already have unlocked this title!']);return;}
            $a=$this->world->achievements[$value]??null;if(!$a){$this->server->sendRaw($u,['warning','Invalid Achievement.']);return;}
            $this->db->run('INSERT INTO users_achievements (UserID,AchievementID) VALUES (?,?)',[$u->dbId,$value]);
            $this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'You successfully gained the achievement '.$a['Name'].'.','strGlow'=>'green,medium','bitSuccess'=>1]);
        }elseif($type==='title'&&$value>0){
            if((int)$this->db->scalar('SELECT COUNT(*) FROM users_titles WHERE UserID=? AND TitleID=?',[$u->dbId,$value],0)>0){$this->server->sendRaw($u,['server','You already have unlocked this title!']);return;}
            $title=$this->world->titles[$value]??$this->db->one('SELECT * FROM titles WHERE id=?',[$value]);if(!$title){$this->server->sendRaw($u,['warning','Invalid Title.']);return;}
            $this->db->run('INSERT INTO users_titles (UserID,TitleID) VALUES (?,?)',[$u->dbId,$value]);
            $this->server->sendJson($u,['cmd'=>'popupmsg','strMsg'=>'You successfully gained the title '.$title['Name'].'.','strGlow'=>'green,medium','bitSuccess'=>1]);
        }else{
            $map=['xpboost'=>'ExpBoostExpire','gboost'=>'GoldBoostExpire','coinsboost'=>'CoinsBoostExpire','cpboost'=>'CpBoostExpire','repboost'=>'RepBoostExpire'];if(!isset($map[$type])){$this->server->sendRaw($u,['warning','This consumable is not supported.']);return;}
            $minutes=max(1,$value);$field=$map[$type];$this->db->run("UPDATE users SET `{$field}`=DATE_ADD(GREATEST(NOW(),COALESCE(`{$field}`,NOW())),INTERVAL ? MINUTE) WHERE id=?",[$minutes,$u->dbId]);$expiry=$this->db->scalar("SELECT `{$field}` FROM users WHERE id=?",[$u->dbId],null);if($expiry!==null)$u->user[$field]=(string)$expiry;$seconds=(int)$this->db->scalar("SELECT GREATEST(0,TIMESTAMPDIFF(SECOND,NOW(),`{$field}`)) FROM users WHERE id=?",[$u->dbId],$minutes*60);$u->boostFlags[$type]=true;$this->server->sendJson($u,['cmd'=>$type,'op'=>'+','iSecsLeft'=>$seconds,'bShowShop'=>$showShop]);
        }
        $left=(int)$r['Quantity']-1;if($left>0)$this->db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$left,(int)$r['CharItemID']]);else$this->db->run('DELETE FROM users_items WHERE id=?',[(int)$r['CharItemID']]);
        // Users.turnInItem() updates the stock client's inventory through turnIn.
        $this->server->sendJson($u,['cmd'=>'turnIn','sItems'=>$itemId.':1']);
    }
    private function addLoadout(ClientSession $u,array $p): void
    {
        $name=substr(trim((string)($p[0]??'Loadout')),0,50);$raw=(string)($p[1]??'');$original=isset($p[2])?substr(trim((string)$p[2]),0,50):null;
        $out=['cmd'=>'addLoadout','success'=>true];
        $data=json_decode($raw,true);if(!is_array($data))$data=[];$colors=is_array($data['colors']??null)?$data['colors']:[];
        $ids=[];foreach(['ar','co','he','ba','Weapon'] as $slot){if(isset($data[$slot])&&is_numeric($data[$slot]))$ids[]=(int)$data[$slot];}
        if(!$ids){foreach($this->db->all('SELECT ui.ItemID FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND (ui.Equipped=1 OR ui.Wear=1) ORDER BY ui.id',[$u->dbId]) as $r)$ids[]=(int)$r['ItemID'];}
        $equipment=implode(',',array_values(array_unique(array_filter($ids))));
        $vals=[(string)($colors['accessory']??$u->user['ColorAccessory']??'0'),(string)($colors['base']??$u->user['ColorBase']??'0'),(string)($colors['trim']??$u->user['ColorTrim']??'0'),(string)($colors['hair']??$u->user['ColorHair']??'0'),(string)($colors['skin']??$u->user['ColorSkin']??'0'),(string)($colors['eye']??$u->user['ColorEye']??'0')];
        try{
            if($original!==null){$this->db->run('UPDATE users_outfits SET Name=?,Equipments=?,ColorAccessory=?,ColorBase=?,ColorTrim=?,ColorHair=?,ColorSkin=?,ColorEye=? WHERE Name=? AND UserID=?',[$name,$equipment,...$vals,$original,$u->dbId]);}
            else{
                $count=(int)$this->db->scalar('SELECT COUNT(*) FROM users_outfits WHERE UserID=?',[$u->dbId],0);if($count>=(int)($u->user['SlotsLoadout']??0))throw new \RuntimeException('No loadout slots available.');
                $this->db->run('INSERT INTO users_outfits (Name,UserID,Equipments,ColorAccessory,ColorBase,ColorTrim,ColorHair,ColorSkin,ColorEye) VALUES (?,?,?,?,?,?,?,?,?)',[$name,$u->dbId,$equipment,...$vals]);
            }
        }catch(Throwable $e){$out['success']=false;$out['msg']=$e->getMessage();}
        $this->server->sendJson($u,$out);
    }
    private function removeLoadout(ClientSession $u,array $p): void
    {
        $name=(string)($p[0]??'');$out=['cmd'=>'removeLoadout','success'=>true,'setName'=>$name];
        try{$this->db->run('DELETE FROM users_outfits WHERE UserID=? AND Name=?',[$u->dbId,$name]);}catch(Throwable){$out['success']=false;$out['msg']='error remove loadout!';}
        $this->server->sendJson($u,$out);
    }
    private function equipLoadout(ClientSession $u,array $p,string $cmd): void
    {
        $name=(string)($p[1]??$p[0]??'');$keepColor=(int)($p[2]??0);$o=$this->db->one('SELECT * FROM users_outfits WHERE UserID=? AND Name=?',[$u->dbId,$name]);
        if(!$o){$this->server->sendJson($u,['cmd'=>$cmd,'uid'=>$u->sfsUserId,'success'=>false,'msg'=>'Error '.$cmd.'!']);return;}
        $ids=array_values(array_filter(array_map('intval',explode(',',(string)$o['Equipments']))));
        if($cmd==='wearLoadout'){
            $costume=[];$this->db->run('UPDATE users_items SET Wear=0 WHERE UserID=?',[$u->dbId]);
            foreach($ids as $itemId){$i=$this->db->one('SELECT * FROM items WHERE id=?',[$itemId]);if(!$i||$i['Equipment']==='ar')continue;$owned=(int)$this->db->scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$itemId],0);if(!$owned)continue;$this->db->run('UPDATE users_items SET Wear=1 WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$itemId]);$costume[$i['Equipment']]=['ItemID'=>$itemId,'sFile'=>$i['File'],'sLink'=>$i['Link'],'iRty'=>(int)$i['Rarity'],'sType'=>$i['Type']];}
            $room=$this->server->currentRoom($u);$packet=['cmd'=>'wearLoadout','uid'=>$u->sfsUserId,'success'=>true,'costume'=>$costume];if($room)$this->server->broadcastJson($packet,$room);else$this->server->sendJson($u,$packet);
        }else{
            $keep=[];$missing=[];
            foreach($ids as $itemId){$owned=(int)$this->db->scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$itemId],0);if($owned){$this->equip($u,[$itemId],true);$keep[]=$itemId;}else$missing[]=$itemId;}
            foreach($this->db->all('SELECT ui.ItemID FROM users_items ui WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0',[$u->dbId]) as $r){$iid=(int)$r['ItemID'];if(!in_array($iid,$keep,true))$this->equip($u,[$iid],false);}
            if($missing){$this->db->run('UPDATE users_outfits SET Equipments=? WHERE UserID=? AND Name=?',[implode(',',$keep),$u->dbId,$name]);$this->server->sendRaw($u,['server','Missing item has been removed from equipment.']);}
            $this->sendStats($u);
        }
        if($keepColor===1){$this->changeColor($u,[$this->colorInt($o['ColorSkin']),$this->colorInt($o['ColorHair']),$this->colorInt($o['ColorEye']),(int)($u->user['HairID']??1)]);$this->changeArmorColor($u,[$this->colorInt($o['ColorBase']),$this->colorInt($o['ColorTrim']),$this->colorInt($o['ColorAccessory'])]);}
    }
    private function party(ClientSession $u,array $p): void
    {
        $sub=(string)($p[0]??'');$name=trim((string)($p[1]??''));
        if($sub==='pi'){
            $t=$this->server->findUser($name);if(!$t){$this->server->sendRaw($u,['warning','Player "'.$name.'" could not be found.']);return;}if($t===$u){$this->server->sendRaw($u,['warning','You cannot invite yourself.']);return;}if(!SettingsCodec::allowed('bParty',$u,$t)){$this->server->sendRaw($u,['warning',$t->username.' cannot recieve party invitations.']);return;}if($t->state===2){$this->server->sendRaw($u,['warning',$t->username.' is currently busy.']);return;}if($t->partyId>0){$this->server->sendRaw($u,['warning','User is already in a party!']);return;}
            $pid=$u->partyId;if($pid<=0){$pid=$this->nextPartyId++;$u->partyId=$pid;$this->parties[$pid]=['owner'=>$u->sfsUserId,'members'=>[$u->sfsUserId=>$u]];}
            $t->partyInvites[$pid]=$u->sfsUserId;$this->server->sendJson($t,['cmd'=>'pi','pid'=>$pid,'owner'=>$u->username]);$this->server->sendRaw($u,['server','You have invited '.$t->username.' to join your party.']);return;
        }
        if($sub==='pa'){
            if($u->partyId>0){$this->server->sendRaw($u,['warning','You are already in a party!']);return;}$pid=(int)($p[1]??0);if($pid<=0||!isset($u->partyInvites[$pid])||!isset($this->parties[$pid])){$this->log->warn('Rejected forced party accept from '.$u->username);return;}
            $party=&$this->parties[$pid];$u->partyId=$pid;$party['members'][$u->sfsUserId]=$u;unset($u->partyInvites[$pid]);$owner=$this->server->findUserBySfsId((int)$party['owner'])?->username??'';
            foreach($party['members'] as $m){if($m!==$u)$this->server->sendJson($m,['cmd'=>'pa','pid'=>$pid,'ul'=>[$u->username],'owner'=>$owner]);}
            $all=[];foreach($party['members'] as $m)$all[]=$m->username;$this->server->sendJson($u,['cmd'=>'pa','pid'=>$pid,'ul'=>$all,'owner'=>$owner]);return;
        }
        if($sub==='pd'){
            $pid=(int)($p[1]??0);$owner=$this->server->findUserBySfsId((int)($u->partyInvites[$pid]??($this->parties[$pid]['owner']??0)));unset($u->partyInvites[$pid]);if($owner)$this->server->sendJson($owner,['cmd'=>'pd','unm'=>$u->username]);$this->server->sendRaw($u,['server','You have declined the invitation.']);
            // Java PartyDecline removes a newly-created party when nobody has
            // accepted yet. In PHP the owner is stored in members, so <=1 means
            // the same owner-only state.
            if(isset($this->parties[$pid])&&count($this->parties[$pid]['members'])<=1){$ownerId=(int)$this->parties[$pid]['owner'];$ownerClient=$this->server->findUserBySfsId($ownerId);if($ownerClient)$ownerClient->partyId=0;unset($this->parties[$pid]);}
            return;
        }
        $pid=$u->partyId;if($pid<=0||!isset($this->parties[$pid])){$this->server->sendRaw($u,['warning','You are not in a party.']);return;}$party=&$this->parties[$pid];$ownerId=(int)$party['owner'];
        if($sub==='pl'){$this->partyRemove($u,$pid,'l');return;}
        $t=$this->server->findUser($name);
        if($sub==='pk'){
            if($u->sfsUserId!==$ownerId){$this->server->sendRaw($u,['warning','Only the party leader can remove members.']);return;}if(!$t||$t->partyId!==$pid){$this->server->sendRaw($u,['warning','That player is not in your party.']);return;}$this->partyRemove($t,$pid,'k');return;
        }
        if($sub==='pp'){
            if($u->sfsUserId!==$ownerId||!$t||$t->partyId!==$pid){$this->server->sendRaw($u,['warning','That player is not in your party.']);return;}$party['owner']=$t->sfsUserId;foreach($party['members'] as $m)$this->server->sendJson($m,['cmd'=>'pp','owner'=>$t->username]);return;
        }
        if($sub==='ps'){
            if(!$t||$t->partyId!==$pid){$this->server->sendRaw($u,['warning','The user you are trying to summon is not in your party.']);return;}$this->server->sendJson($t,['cmd'=>'ps','unm'=>$u->username]);$this->server->sendRaw($u,['server','You attempt to summon '.$t->username.' to you.']);return;
        }
        if($sub==='psa'){
            $owner=$this->server->findUserBySfsId($ownerId);if(!$owner)return;if(!SettingsCodec::allowed('bGoto',$owner,$u)){$this->server->sendRaw($owner,['warning',$u->username.' failed to be summoned.']);$this->server->sendRaw($u,['warning','Summon failed. Please do not block goto requests.']);return;}
            // Java PartyAcceptSummon only acknowledges the summon. The stock AS3 callback
            // immediately sends cmd/goto (or moveToCell) after psa; server-side joining here
            // caused a duplicate join and the Java same-room rejection on the second request.
            $this->server->sendRaw($owner,['server',$u->username.' accepted your summon.']);return;
        }
        if($sub==='psd'){
            $to=$t??$this->server->findUserBySfsId($ownerId);if($to)$this->server->sendRaw($to,['server',$u->username.' declined your summon.']);return;
        }
    }
    private function partyRemove(ClientSession $u,int $pid,string $typ): void
    {
        if(!isset($this->parties[$pid]))return;$party=&$this->parties[$pid];$oldOwner=(int)$party['owner'];unset($party['members'][$u->sfsUserId]);$u->partyId=0;
        if($oldOwner===$u->sfsUserId){$next=array_key_first($party['members']);if($next!==null)$party['owner']=(int)$next;}
        $owner=$this->server->findUserBySfsId((int)($party['owner']??0))?->username??'';$packet=['cmd'=>'pr','owner'=>$owner,'typ'=>$typ,'unm'=>$u->username];foreach($party['members'] as $m)$this->server->sendJson($m,$packet);$this->server->sendJson($u,$packet);
        if(!$party['members']){unset($this->parties[$pid]);return;}if(count($party['members'])===1){$only=reset($party['members']);if($only instanceof ClientSession){$only->partyId=0;$this->server->sendJson($only,['cmd'=>'pc']);}unset($this->parties[$pid]);}
    }
    private function afk(ClientSession $u,array $p): void { $u->afk=filter_var($p[0]??false,FILTER_VALIDATE_BOOLEAN);$r=$this->server->currentRoom($u);if($r)$this->server->broadcastRaw(['uotls',$u->username,'afk:'.($u->afk?'true':'false')],$r); }
    private function hexColor(mixed $v): string { return strtoupper(str_pad(dechex(((int)$v)&0xFFFFFF),6,'0',STR_PAD_LEFT)); }
    private function changeArmorColor(ClientSession $u,array $p): void
    { $base=(int)($p[0]??0);$trim=(int)($p[1]??0);$acc=(int)($p[2]??0);$this->db->run('UPDATE users SET ColorBase=?,ColorTrim=?,ColorAccessory=? WHERE id=?',[$this->hexColor($base),$this->hexColor($trim),$this->hexColor($acc),$u->dbId]);$u->user['ColorBase']=$this->hexColor($base);$u->user['ColorTrim']=$this->hexColor($trim);$u->user['ColorAccessory']=$this->hexColor($acc);$r=$this->server->currentRoom($u);if($r)$this->server->broadcastJson(['cmd'=>'changeArmorColor','uid'=>$u->sfsUserId,'intColorBase'=>$base,'intColorTrim'=>$trim,'intColorAccessory'=>$acc],$r,$u); }
    private function changeColor(ClientSession $u,array $p): void
    { $skin=(int)($p[0]??0);$hair=(int)($p[1]??0);$eye=(int)($p[2]??0);$hairId=(int)($p[3]??1);$h=$this->db->one('SELECT * FROM hairs WHERE id=?',[$hairId]);if(!$h)return;$this->db->run('UPDATE users SET ColorSkin=?,ColorHair=?,ColorEye=?,HairID=? WHERE id=?',[$this->hexColor($skin),$this->hexColor($hair),$this->hexColor($eye),$hairId,$u->dbId]);$u->user['HairID']=$hairId;$u->user['ColorSkin']=$this->hexColor($skin);$u->user['ColorHair']=$this->hexColor($hair);$u->user['ColorEye']=$this->hexColor($eye);$r=$this->server->currentRoom($u);if($r)$this->server->broadcastJson(['cmd'=>'changeColor','uid'=>$u->sfsUserId,'HairID'=>$hairId,'strHairName'=>$h['Name'],'strHairFilename'=>$h['File'],'intColorSkin'=>$skin,'intColorHair'=>$hair,'intColorEye'=>$eye],$r,$u); }
    private function genderSwap(ClientSession $u): void
    { if((int)$u->user['Coins']<1000){$this->server->sendRaw($u,['warning',"You don't have enough coins!"]);return;}$new=$u->user['Gender']==='M'?'F':'M';$h=$this->db->one('SELECT * FROM hairs WHERE Gender=? ORDER BY id LIMIT 1',[$new])??$this->db->one('SELECT * FROM hairs ORDER BY id LIMIT 1');$this->db->run('UPDATE users SET Gender=?,Coins=Coins-1000,HairID=? WHERE id=?',[$new,(int)$h['id'],$u->dbId]);$u->user['Gender']=$new;$u->user['Coins']-=1000;$u->user['HairID']=(int)$h['id'];$r=$this->server->currentRoom($u);if($r)$this->server->broadcastJson(['cmd'=>'genderSwap','uid'=>$u->sfsUserId,'bitSuccess'=>1,'gender'=>$new,'HairID'=>(int)$h['id'],'strHairName'=>$h['Name'],'strHairFilename'=>$h['File'],'intCoins'=>1000],$r); }
    private function interaction(ClientSession $u,array $p): void
    {
        $typ=(string)($p[0]??'');$o=['iAccessLevel'=>$u->access,'cmd'=>'ia','oName'=>(string)($p[1]??''),'typ'=>$typ,'iUpgDays'=>0,'unm'=>$u->username];
        if($typ==='rval')$o['val']=random_int(0,8999);
        elseif($typ==='str'){
            $value=(string)($p[2]??'');$o['val']=$value;
            // Legacy Java special interaction: aaaa warps the named player to
            // Battleon. This project's Battleon-equivalent map is named faroff.
            if($value==='aaaa'){
                $name=strtolower(trim((string)($p[3]??'')));$target=$this->server->findUser($name);
                if(!$target){$this->server->sendRaw($u,['warning','Player \"'.$name.'\" could not be found.']);return;}
                $this->server->joinGameRoom($target,$this->world->map('battleon')?'battleon':'faroff');
            }
        }
        $r=$this->server->currentRoom($u);if($r)$this->server->broadcastJson($o,$r);
    }
    private function startRest(ClientSession $u): void
    {
        if($u->state===0||$u->hp<=0)return;
        $u->targetMonster=null;$u->state=1;$u->resting=true;$u->lastRegenAt=0.0;
        // Aera v30.75: resting is server-owned and remains active even if HP/MP
        // are already full and stamina is the only resource below maximum.
        $this->server->sendJson($u,['cmd'=>'ct','p'=>[$u->username=>['intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intSP'=>$u->stamina,'intState'=>1]]]);
        $this->log->info('Rest started: player='.$u->username.' HP='.$u->hp.'/'.$u->hpMax.' MP='.$u->mp.'/'.$u->mpMax.' SP='.$u->stamina.'/'.$u->staminaMax);
        $r=$this->server->currentRoom($u);if($r)$this->server->broadcastJson(['cmd'=>'uotls','unm'=>$u->username,'o'=>['intState'=>1]],$r);
    }
    private function restorePlayer(ClientSession $u,array $p=[]): void
    {
        if($u->state!==0||$u->hp>0)return;
        $now=microtime(true);
        if($u->respawnAt<=0.0||$now<$u->respawnAt){$this->log->warn('Rejected early resPlayerTimed from '.$u->username);return;}
        $u->state=1;$u->respawnAt=0.0;$u->resting=false;$u->targetMonster=null;
        // Death removes timed combat auras, but class passives stay loaded.  The
        // old PHP port broadcast clearAuras to the whole room, making every nearby
        // player's client erase its own aura list.  Clear only the respawning player.
        $u->auras=[];$u->dots=[];
        $this->server->sendJson($u,['cmd'=>'clearAuras']);
        $this->sendStats($u,true);
        $this->server->sendRaw($u,['resTimed',$u->frame,$u->pad]);
        $r=$this->server->currentRoom($u);
        if($r)$this->server->broadcastJson(['cmd'=>'uotls','unm'=>$u->username,'o'=>['intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intState'=>1]],$r);
    }
    private function userData(ClientSession $c,bool $self=false): array
    {
        $eq=[];$className='';
        try{$rows=$this->db->all('SELECT ui.ItemID,ui.Equipped,ui.Wear,i.Equipment,i.File,i.Link,i.Name,i.Type,i.Rarity FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND (ui.Equipped=1 OR ui.Wear=1)',[$c->dbId]);foreach($rows as $r){$eq[$r['Equipment']]=['ItemID'=>(int)$r['ItemID'],'sFile'=>$r['File'],'sLink'=>$r['Link'],'sName'=>$r['Name'],'sType'=>$r['Type'],'iRty'=>(int)$r['Rarity']];if($r['Equipment']==='ar')$className=(string)$r['Name'];}}catch(Throwable){}
        $hair=$this->db->one('SELECT Name,File FROM hairs WHERE id=?',[(int)($c->user['HairID']??1)])??['Name'=>'','File'=>''];
        $d=['eqp'=>$eq,'iCP'=>$this->classPoints($c),'iUpgDays'=>max(0,(int)($c->user['UpgradeDays']??0)),'intAccessLevel'=>$c->access,'intColorAccessory'=>$this->colorInt($c->user['ColorAccessory']??0),'intColorBase'=>$this->colorInt($c->user['ColorBase']??0),'intColorEye'=>$this->colorInt($c->user['ColorEye']??0),'intColorHair'=>$this->colorInt($c->user['ColorHair']??0),'intColorSkin'=>$this->colorInt($c->user['ColorSkin']??0),'intColorTrim'=>$this->colorInt($c->user['ColorTrim']??0),'intLevel'=>$c->level,'intKillCount'=>(int)($c->user['KillCount']??0),'intDeathCount'=>(int)($c->user['DeathCount']??0),'strClassName'=>$className,'strGender'=>(string)($c->user['Gender']??'M'),'strHairFilename'=>$hair['File'],'strHairName'=>$hair['Name'],'strUsername'=>$c->username,'iFounder'=>0];
        $gid=(int)($c->user['GuildID']??0);if($gid>0){$g=$this->guildObject($gid);if($g){$d['guild']=['id'=>$gid,'Name'=>$g['Name'],'Color'=>$g['Color']??'','MOTD'=>$g['MOTD']??$g['MessageOfTheDay']??'','Status'=>''];$d['guildRank']=(int)($c->user['Rank']??0);}}
        $titleId=(int)($c->user['TitleID']??0);if($titleId>0){$t=$this->db->one('SELECT Name,Color FROM titles WHERE id=?',[$titleId]);if($t)$d['title']=['id'=>$titleId,'Name'=>$t['Name'],'Color'=>$t['Color']];}
        if($self){
            $d+=['CharID'=>$c->dbId,'HairID'=>(int)($c->user['HairID']??1),'UserID'=>$c->sfsUserId,'bPermaMute'=>(int)($c->user['PermamuteFlag']??0),'bitSuccess'=>'1','dCreated'=>$this->isoDate($c->user['DateCreated']??null),'dUpgExp'=>$this->isoDate($c->user['UpgradeExpire']??null),'iAge'=>(string)($c->user['Age']??'0'),'iAuctionSlots'=>(int)($c->user['SlotsAuction']??0),'iBagSlots'=>(int)($c->user['SlotsBag']??0),'iBankSlots'=>(int)($c->user['SlotsBank']??0),'iHouseSlots'=>(int)($c->user['SlotsHouse']??0),'iLoadoutSlots'=>(int)($c->user['SlotsLoadout']??0),'iBoostCP'=>0,'iBoostG'=>0,'iBoostC'=>0,'iBoostRep'=>0,'iBoostXP'=>0,'iDBCP'=>0,'iDailyAdCap'=>6,'iDailyAds'=>0,'iDEX'=>0,'iEND'=>0,'iINT'=>0,'iLCK'=>0,'iSTR'=>0,'iWIS'=>0,'iUpg'=>(int)($c->user['Upgraded']??0),'ia0'=>(int)($c->user['Achievement']??0),'ia1'=>(int)($c->user['Settings']??0),'id0'=>(int)($c->user['DailyQuests0']??0),'id1'=>(int)($c->user['DailyQuests1']??0),'id2'=>(int)($c->user['DailyQuests2']??0),'im0'=>(int)($c->user['MonthlyQuests0']??0),'intActivationFlag'=>(int)($c->user['ActivationFlag']??5),'intDBExp'=>(int)($c->user['Exp']??0),'intDBGold'=>(int)($c->user['Gold']??0),'intExp'=>(int)($c->user['Exp']??0),'intExpToLevel'=>$this->expToLevel($c->level),'intCoins'=>(int)($c->user['Coins']??0),'intGold'=>(int)($c->user['Gold']??0),'intHP'=>$c->hp,'intHPMax'=>$c->hpMax,'intHits'=>1267,'intMP'=>$c->mp,'intMPMax'=>$c->mpMax,'ip0'=>0,'ip1'=>0,'ip2'=>0,'iq0'=>0,'lastArea'=>(string)($c->user['LastArea']??''),'sCountry'=>(string)($c->user['Country']??''),'sHouseInfo'=>(string)($c->user['HouseInfo']??''),'strEmail'=>(string)($c->user['Email']??''),'strMapName'=>explode('-',$c->roomName)[0],'strQuests'=>(string)($c->user['Quests']??''),'strQuests2'=>(string)($c->user['Quests2']??'')];
        }
        return $d;
    }
    private function retrieveUserData(ClientSession $u,array $p,bool $many): void
    { if($many){$a=[];foreach($p as $id){$c=$this->server->findUserBySfsId((int)$id);if($c)$a[]=['uid'=>$c->sfsUserId,'strFrame'=>$c->frame,'strPad'=>$c->pad,'data'=>$this->userData($c,$c===$u)];}$this->server->sendJson($u,['cmd'=>'initUserDatas','a'=>$a]);}else{$c=$this->server->findUserBySfsId((int)($p[0]??0));if($c)$this->server->sendJson($u,['cmd'=>'initUserData','data'=>$this->userData($c,false),'strFrame'=>$c->frame,'strPad'=>$c->pad,'uid'=>$c->sfsUserId]);} }
    private function potionEffect(ClientSession $u,array $p): void
    {
        $ref=(string)($p[0]??'');$id=(int)($p[1]??0);$s=$this->db->one('SELECT * FROM skills WHERE id=?',[$id]);if(!$s){$this->server->sendRaw($u,['warning','Potion Info not found!']);return;}
        $o=['anim'=>$s['Animation'],'cd'=>(int)$s['Cooldown'],'damage'=>(float)$s['Damage'],'desc'=>$s['Description'],'dsrc'=>$s['Dsrc'],'fx'=>$s['Effects'],'icon'=>$s['Icon'],'id'=>(int)$s['id'],'isOK'=>true,'mp'=>(int)$s['Mana'],'nam'=>$s['Name'],'range'=>(int)$s['Range'],'ref'=>$ref,'strl'=>$s['Strl'],'tgt'=>$s['Target'],'typ'=>$s['Type']];
        try{
            $auras=[];foreach($this->db->all('SELECT a.* FROM skills_auras sa INNER JOIN auras a ON a.id=sa.AuraID WHERE sa.SkillID=? ORDER BY sa.id',[$id]) as $a){$effects=[];foreach($this->db->all('SELECT id,Type,Stat,Value FROM auras_effects WHERE AuraID=? ORDER BY id',[(int)$a['id']]) as $e)$effects[]=['typ'=>$e['Type'],'sta'=>$e['Stat'],'id'=>(int)$e['id'],'val'=>(float)$e['Value']];$ai=['nam'=>$a['Name']];if($effects)$ai['e']=$effects;if((int)$a['Duration']>0)$ai['t']='s';$auras[]=$ai;}if($auras)$o['auras']=$auras;
        }catch(Throwable){}
        $this->server->sendJson($u,['cmd'=>'seia','iRes'=>1,'o'=>$o]);
        // Java GetPotionEffect stores skill.getReference(), not merely the
        // presentation ref supplied by the client. Keep both aliases so the
        // stock i1 action slot and custom potion refs resolve identically.
        $u->dynamicSkills[strtolower((string)$s['Reference'])]=$id;
        if($ref!=='')$u->dynamicSkills[strtolower($ref)]=$id;
    }
    private function pvpQueue(ClientSession $u,array $p): void
    {
        $warzone=strtolower(trim((string)($p[0]??'none')));if($warzone==='')$warzone='none';
        if($u->level<5){$this->server->sendRaw($u,['warning','You need to be atleast level 5 to join a PvP Brawl!']);return;}
        $this->removeFromPvpQueue($u);
        $o=['cmd'=>'PVPQ','bitSuccess'=>0];
        if($warzone==='none'){$this->server->sendRaw($u,['server',"You have been removed from the Warzone's queue"]);$this->server->sendJson($u,$o);return;}
        $map=$this->world->map($warzone);if(!$map||(int)($map['PvP']??0)!==1){$this->server->sendRaw($u,['warning','Cannot queue on an invalid brawl.']);$this->server->sendJson($u,$o);return;}
        $u->pvpQueued=$warzone;$this->pvpQueues[$warzone][$u->socketId]=$u;
        $o+=['bitSuccess'=>1,'warzone'=>$warzone,'avgWait'=>-1];$this->server->sendRaw($u,['server','You joined the Warzone queue for '.$warzone.'!']);$this->server->sendJson($u,$o);$this->sendPvpQueueCount($warzone,(int)$map['MaxPlayers']);
        $this->startPvpMatches($warzone,$map);
    }
    private function pvpReply(ClientSession $u,array $p): void
    {
        $roomId=$u->pvpRoomId;
        if((string)($p[0]??'0')==='1'&&$roomId!==null)$this->server->joinPreparedRoom($u,$roomId,'Enter'.$u->pvpTeam,'Spawn');
        else{$u->pvpRoomId=null;$u->pvpRoomName=null;$u->pvpJoinAt=0.0;if($roomId!==null)$this->server->releasePreparedRoomIfUnused($roomId);}
        $this->server->sendJson($u,['cmd'=>'PVPQ','bitSuccess'=>0]);
    }
    private function removeFromPvpQueue(ClientSession $u): void
    {
        $warzone=$u->pvpQueued;if($warzone===null)return;unset($this->pvpQueues[$warzone][$u->socketId]);$u->pvpQueued=null;
        $map=$this->world->map($warzone);if($map)$this->sendPvpQueueCount($warzone,(int)$map['MaxPlayers']);if(empty($this->pvpQueues[$warzone]))unset($this->pvpQueues[$warzone]);
    }
    private function sendPvpQueueCount(string $warzone,int $slots): void
    { $packet=['cmd'=>'PVPQueueCntr','queues'=>count($this->pvpQueues[$warzone]??[]),'slots'=>$slots];foreach($this->pvpQueues[$warzone]??[] as $client)$this->server->sendJson($client,$packet); }
    private function startPvpMatches(string $warzone,array $map): void
    {
        $slots=max(2,(int)$map['MaxPlayers']);
        while(count($this->pvpQueues[$warzone]??[])>=$slots){$room=$this->server->createPreparedPvpRoom($warzone);if(!$room)return;$players=array_slice(array_values($this->pvpQueues[$warzone]),0,$slots);foreach($players as $i=>$client){unset($this->pvpQueues[$warzone][$client->socketId]);$client->pvpQueued=null;$client->pvpRoomId=$room->id;$client->pvpRoomName=$room->name;$client->pvpTeam=$i%2;$client->pvpJoinAt=microtime(true)+5+$i;$this->server->sendRaw($client,['server','A new Warzone battle has started!']);$this->server->sendJson($client,['cmd'=>'PVPI','warzone'=>$warzone]);}$this->sendPvpQueueCount($warzone,$slots);}
        if(empty($this->pvpQueues[$warzone]))unset($this->pvpQueues[$warzone]);
    }
    public function processPvpQueues(): void
    { foreach(array_keys($this->pvpQueues) as $warzone){$map=$this->world->map($warzone);if(!$map){unset($this->pvpQueues[$warzone]);continue;}$this->startPvpMatches($warzone,$map);} }
    private function hairShop(ClientSession $u,array $p): void
    { $id=(int)($p[0]??0);$shop=$this->db->one('SELECT * FROM hairs_shops WHERE id=?',[$id]);if(!$shop)return;$rows=$this->db->all('SELECT h.* FROM hairs_shops_items hsi INNER JOIN hairs h ON h.id=hsi.HairID WHERE hsi.ShopID=? AND hsi.Gender=? ORDER BY hsi.id',[$id,(string)$u->user['Gender']]);$hair=[];foreach($rows as $h)$hair[]=['sFile'=>$h['File'],'HairID'=>(int)$h['id'],'sName'=>$h['Name'],'sGen'=>$h['Gender']];$this->server->sendJson($u,['HairShopID'=>$id,'cmd'=>'loadHairShop','hair'=>$hair]); }
    private function buySlots(ClientSession $u,array $p,string $field,string $priceKey,?string $capKey,string $cmd): void
    { $n=max(1,(int)($p[0]??1));$price=(int)($this->world->rates[$priceKey]??200);$old=(int)$u->user[$field];$new=$old+$n;$cap=$capKey?(int)($this->world->rates[$capKey]??9999):9999;if($new>$cap){$this->server->sendRaw($u,['warning','You have already purchased the maximum amount!']);return;}$cost=$n*$price;if((int)$u->user['Coins']<$cost){$this->server->sendRaw($u,['warning',"You don't have enough coins!"]);return;}$this->db->run("UPDATE users SET `{$field}`=?,Coins=Coins-? WHERE id=?",[$new,$cost,$u->dbId]);$u->user[$field]=$new;$u->user['Coins']-=$cost;$this->server->sendJson($u,['cmd'=>$cmd,'iSlots'=>$n,'bitSuccess'=>'1']); }
    private function tradeRequest(ClientSession $u,array $p): void
    {
        $name=trim((string)($p[0]??''));if($name==='0'||$name==='1')return;
        $t=$this->server->findUser($name);if(!$t){$this->server->sendRaw($u,['warning','Player "'.$name.'" could not be found.']);return;}
        if($t===$u||$t->dbId===$u->dbId){$this->server->sendRaw($u,['warning','Cannot trade with yourself!']);return;}
        if(!SettingsCodec::allowed('bTrade',$u,$t)){$this->server->sendRaw($u,['warning','Player "'.$t->username.'" is not accepting trade invites.']);return;}
        if($u->level<5){$this->server->sendRaw($u,['warning','You need to be atleast level 5 to use this feature!']);return;}
        if($t->level<5){$this->server->sendRaw($u,['warning',$t->username.' does not meet level (5) requirement.']);return;}
        if($t->access>=40&&$u->access<40){$this->server->sendRaw($u,['warning','Cannot trade with staff member!']);return;}
        if($u->tradeTarget!==null||$t->tradeTarget!==null){$this->server->sendRaw($u,['warning',$t->username.' is currently trading with someone else.']);return;}
        if($u->state===2||$t->state===2){$this->server->sendRaw($u,['warning',$t->username.' is currently busy.']);return;}
        $r=$this->server->currentRoom($u);if((int)($r?->map['PvP']??0)===1){$this->server->sendRaw($u,['warning','You are not allowed to trade on PvP!']);return;}
        $t->tradeRequests[$u->sfsUserId]=true;
        $this->server->sendJson($t,['cmd'=>'ti','owner'=>$u->username]);$this->server->sendRaw($u,['server','You have requested '.$t->username.' to trade.']);
    }
    private function tradeDecline(ClientSession $u,array $p): void
    {
        $t=$this->server->findUser((string)($p[0]??''))??$this->server->findUserBySfsId((int)($p[0]??0));
        if(!$t)return;unset($u->tradeRequests[$t->sfsUserId]);$this->server->sendRaw($t,['server',$u->username.' declined your trade request.']);
    }
    private function tradeAccept(ClientSession $u,array $p): void
    {
        $t=$this->server->findUser((string)($p[0]??''))??$this->server->findUserBySfsId((int)($p[0]??0));
        if(!$t||$t===$u||$u->tradeTarget!==null||$t->tradeTarget!==null)return;
        if(!isset($u->tradeRequests[$t->sfsUserId])){$this->server->sendRaw($u,['warning','That trade request is no longer active.']);return;}
        unset($u->tradeRequests[$t->sfsUserId]);
        if($t->access>=40&&$u->access<40){$this->server->sendRaw($u,['warning','Cannot trade with staff member!']);return;}
        $u->tradeTarget=$t->sfsUserId;$t->tradeTarget=$u->sfsUserId;$u->tradeItems=[];$t->tradeItems=[];
        $u->tradeGold=$u->tradeCoins=$t->tradeGold=$t->tradeCoins=0;$u->tradeLocked=$t->tradeLocked=$u->tradeAccepted=$t->tradeAccepted=false;
        $this->server->sendJson($t,['cmd'=>'startTrade','userid'=>$u->sfsUserId]);$this->server->sendJson($u,['cmd'=>'startTrade','userid'=>$t->sfsUserId]);
    }
    private function tradePartner(ClientSession $u,array $p=[]): ?ClientSession
    { if($u->tradeTarget!==null)return $this->server->findUserBySfsId($u->tradeTarget);foreach(array_reverse($p) as $v)if(is_numeric($v)){if($c=$this->server->findUserBySfsId((int)$v))return $c;}return null; }
    private function tradeCancel(ClientSession $u,array $p,string $cmd='tradeCancel'): void
    {
        $t=$this->tradePartner($u,$p);foreach(array_filter([$u,$t]) as $c){$c->tradeTarget=null;$c->tradeItems=[];$c->tradeGold=$c->tradeCoins=0;$c->tradeLocked=$c->tradeAccepted=false;$this->server->sendJson($c,['cmd'=>'tradeCancel','bitSuccess'=>1]);}
        if($t)$this->server->sendRaw($t,['warning','Trade session has been canceled.']);
    }
    private function tradeLoadOffer(ClientSession $u,array $p): void
    { $types=array_values(array_filter(array_map('strval',$p)));$partner=$this->tradePartner($u,[]);$itemsB=$partner?$this->tradeItemObjects($partner,$types):[];$this->server->sendJson($u,['cmd'=>'loadOffer','itemsA'=>$this->tradeItemObjects($u,$types),'itemsB'=>$itemsB,'bitSuccess'=>1]); }
    private function tradeItemObjects(ClientSession $u,array $types=[]): array
    {
        $out=[];foreach($u->tradeItems as $char=>$qty){$r=$this->db->one('SELECT ui.id UserItemID,ui.EnhID,ui.EnhItemID,ui.Quantity,ui.Bank,ui.Wear,ui.Equipped,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=?',[(int)$char,$u->dbId]);if($r&&(!$types||in_array((string)$r['Type'],$types,true))){$o=$this->itemJson($r,$qty,(int)$char);$o['bBank']='1';$out[]=$o;}}return $out;
    }
    private function tradeItemObjectByChar(ClientSession $u,int $char,int $qty): ?array
    { $r=$this->db->one('SELECT ui.id UserItemID,ui.EnhID,ui.EnhItemID,ui.Quantity,ui.Bank,ui.Wear,ui.Equipped,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=?',[$char,$u->dbId]);if(!$r)return null;$o=$this->itemJson($r,$qty,$char);$o['bBank']='1';return $o; }
    private function tradeItems(ClientSession $u,array $p,string $cmd): void
    {
        $wire=$cmd==='tradeSwapInventory'?'tradeSwapInv':$cmd;
        if($wire==='tradeFromInv'){
            $itemId=(int)($p[0]??0);$char=(int)($p[1]??0);$targetId=(int)($p[2]??0);$qty=(int)($p[3]??1);$t=$this->tradePartner($u,[$targetId]);if(!$t)return;
            if($qty<=0){$this->recordViolation($u,'Packet Edit [TradeFromInventory]','Attempting to put non-positive item quantity amount');$this->server->sendJson($u,['cmd'=>'tradeFromInv','bitSuccess'=>0,'msg'=>'Invalid quantity amount!']);return;}
            $r=$this->db->one('SELECT ui.Quantity,ui.Bank,ui.Equipped,ui.Wear,ui.ItemID,ui.EnhID,i.Trade,i.Stack,i.Temporary,i.FactionID,i.ReqReputation,i.Name FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.ItemID=?',[$char,$u->dbId,$itemId]);
            if(!$r||(int)$r['Bank']!==0||(int)$r['Temporary']===1||(int)$r['Trade']!==1||(int)$r['Equipped']===1||(int)$r['Wear']===1||$qty>(int)$r['Quantity']){$this->server->sendJson($u,['cmd'=>'tradeFromInv','bitSuccess'=>0,'msg'=>(string)($r['Name']??'Item').' cannot be offered.']);return;}
            $fid=(int)($r['FactionID']??0);if($fid>1){$rep=(int)$this->db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$t->dbId,$fid],-1);if($rep<(int)$r['ReqReputation']){$this->server->sendJson($u,['cmd'=>'tradeFromInv','bitSuccess'=>0,'msg'=>'Reputation requirement not met for '.$t->username.'!']);return;}}
            $u->tradeItems[$char]=$qty;$this->server->sendJson($u,['cmd'=>'tradeFromInv','ItemID'=>$itemId,'bSuccess'=>1,'Type'=>1,'Quantity'=>$qty]);
            $obj=$this->tradeItemObjectByChar($u,$char,$qty);if($obj)$this->server->sendJson($t,['cmd'=>'loadOffer','itemsB'=>[$obj],'bitSuccess'=>1]);
        } elseif($wire==='tradeToInv'){
            $itemId=(int)($p[0]??0);$char=(int)($p[1]??0);$targetId=(int)($p[2]??0);$t=$this->tradePartner($u,[$targetId]);if(!$t)return;
            if(!isset($u->tradeItems[$char]))return;unset($u->tradeItems[$char]);
            $this->server->sendJson($u,['cmd'=>'tradeToInv','ItemID'=>$itemId,'Type'=>1]);$this->server->sendJson($t,['cmd'=>'tradeToInv','ItemID'=>$itemId,'Type'=>2]);
        } else {
            $itemId1=(int)($p[0]??0);$char1=(int)($p[1]??0);$itemId2=(int)($p[2]??0);$char2=(int)($p[3]??0);$targetId=(int)($p[4]??0);$t=$this->tradePartner($u,[$targetId]);if(!$t)return;
            if(!isset($u->tradeItems[$char2]))return;$oldQty=$u->tradeItems[$char2];
            $new=$this->db->one('SELECT ui.Quantity,ui.Bank,ui.Equipped,ui.Wear,i.Trade,i.Temporary FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.ItemID=?',[$char1,$u->dbId,$itemId1]);if(!$new||(int)$new['Bank']!==0||(int)$new['Temporary']===1||(int)$new['Trade']!==1||(int)$new['Equipped']===1||(int)$new['Wear']===1)return;
            unset($u->tradeItems[$char2]);$u->tradeItems[$char1]=min(max(1,$oldQty),(int)$new['Quantity']);
            $this->server->sendJson($u,['cmd'=>'tradeSwapInv','invItemID'=>$itemId1,'tradeItemID'=>$itemId2]);
            $this->server->sendJson($t,['cmd'=>'tradeToInv','ItemID'=>$itemId2,'Type'=>2]);$obj=$this->tradeItemObjectByChar($u,$char1,$u->tradeItems[$char1]);if($obj)$this->server->sendJson($t,['cmd'=>'loadOffer','itemsB'=>[$obj],'bitSuccess'=>1]);
        }
        $u->tradeLocked=$u->tradeAccepted=false;$t->tradeLocked=$t->tradeAccepted=false;$this->server->sendJson($u,['cmd'=>'tradeUnlock','bitSuccess'=>1]);$this->server->sendJson($t,['cmd'=>'tradeUnlock','bitSuccess'=>1]);
    }
    private function tradeLock(ClientSession $u,array $p,bool $lock): void
    {
        $targetId=(int)($p[0]??0);$t=$this->tradePartner($u,[$targetId]);if(!$t)return;
        if(!$lock){$u->tradeLocked=$u->tradeAccepted=false;$t->tradeLocked=$t->tradeAccepted=false;$this->server->sendJson($u,['cmd'=>'tradeUnlock','bitSuccess'=>1]);$this->server->sendJson($t,['cmd'=>'tradeUnlock','bitSuccess'=>1]);return;}
        $r=$this->server->currentRoom($u);if((int)($r?->map['PvP']??0)===1){$this->server->sendJson($u,['cmd'=>'tradeLock','bitSuccess'=>0,'msg'=>'You are not allowed to trade on PvP!']);return;}
        $gold=(int)($p[1]??0);$coins=(int)($p[2]??0);if($gold<0||$coins<0){$this->recordViolation($u,'Packet Edit [TradeLock]','Negative currency input');$this->server->sendJson($u,['cmd'=>'tradeLock','bitSuccess'=>0,'msg'=>'Invalid coins/gold input!']);return;}
        $wallet=$this->db->one('SELECT Gold,Coins FROM users WHERE id=?',[$u->dbId]);if(!$wallet||$gold>(int)$wallet['Gold']||$coins>(int)$wallet['Coins']){$this->server->sendJson($u,['cmd'=>'tradeLock','bitSuccess'=>0,'msg'=>'Insufficient funds!']);return;}
        if($u->tradeLocked||$u->tradeAccepted)return;$u->tradeGold=$gold;$u->tradeCoins=$coins;$u->tradeLocked=true;
        $o=['cmd'=>'tradeLock','bitSuccess'=>1,'coins'=>$coins,'gold'=>$gold];if($t->tradeLocked)$o['Deal']=1;$this->server->sendJson($t,$o);
        $mine=['cmd'=>'tradeLock','bitSuccess'=>1,'coins'=>$t->tradeCoins,'gold'=>$t->tradeGold,'Self'=>1];if($t->tradeLocked)$mine['Deal']=1;$this->server->sendJson($u,$mine);
    }
    private function tradeDeal(ClientSession $u,array $p): void
    {
        $t=$this->tradePartner($u,$p);if(!$t||!$u->tradeLocked||!$t->tradeLocked)return;$u->tradeAccepted=true;
        if(!$t->tradeAccepted){$this->server->sendJson($u,['cmd'=>'tradeDeal','bitSuccess'=>1,'onHold'=>1]);return;}
        try{$result=$this->executeTrade($u,$t);$this->applyTradeClientResult($result);$this->server->sendJson($u,['cmd'=>'tradeDeal','bitSuccess'=>1]);$this->server->sendJson($t,['cmd'=>'tradeDeal','bitSuccess'=>1]);$this->server->sendRaw($u,['server','Trade success with: '.$t->username]);$this->server->sendRaw($t,['server','Trade success with: '.$u->username]);}
        catch(Throwable $e){$msg=$e->getMessage()?:'Trade failed.';$this->server->sendJson($u,['cmd'=>'tradeDeal','bitSuccess'=>0,'msg'=>$msg]);$this->server->sendJson($t,['cmd'=>'tradeDeal','bitSuccess'=>0,'msg'=>$msg]);}
        finally{$this->tradeResetPair($u,$t);}
    }
    private function executeTrade(ClientSession $a,ClientSession $b): array
    {
        return $this->db->tx(function(Database $db)use($a,$b){
            $ua=$db->one('SELECT Gold,Coins FROM users WHERE id=? FOR UPDATE',[$a->dbId]);$ub=$db->one('SELECT Gold,Coins FROM users WHERE id=? FOR UPDATE',[$b->dbId]);if(!$ua||!$ub)throw new \RuntimeException('Trade player data could not be loaded.');
            if((int)$ua['Gold']<$a->tradeGold||(int)$ua['Coins']<$a->tradeCoins||(int)$ub['Gold']<$b->tradeGold||(int)$ub['Coins']<$b->tradeCoins)throw new \RuntimeException('A player no longer has the offered currency.');
            $plans=[];
            foreach([[$a,$b],[$b,$a]] as [$from,$to])foreach($from->tradeItems as $char=>$qty){
                $r=$db->one('SELECT ui.*,i.Stack,i.Trade,i.Temporary,i.Equipment,i.Name,i.FactionID,i.ReqReputation FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.id=? AND ui.UserID=? AND ui.Bank=0 FOR UPDATE',[(int)$char,$from->dbId]);
                if(!$r||$qty<=0||$qty>(int)$r['Quantity']||(int)$r['Trade']!==1||(int)$r['Temporary']===1||(int)$r['Equipped']===1||(int)$r['Wear']===1)throw new \RuntimeException('An offered item is no longer available.');
                $fid=(int)($r['FactionID']??0);if($fid>1){$rep=(int)$db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$to->dbId,$fid],-1);if($rep<(int)$r['ReqReputation'])throw new \RuntimeException($to->username.' no longer meets the reputation requirement for '.$r['Name'].'.');}
                $existing=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$to->dbId,(int)$r['ItemID']]);
                if($existing){if((int)$r['Stack']<=1||(int)$existing['Quantity']+$qty>(int)$r['Stack'])throw new \RuntimeException($to->username.' cannot have more than '.(int)$r['Stack'].' of '.$r['Name'].'!');}
                $plans[]=['from'=>$from,'to'=>$to,'char'=>(int)$char,'qty'=>(int)$qty,'row'=>$r,'existing'=>$existing];
            }
            // Slot check using the state after fully transferred outgoing rows are removed.
            foreach([$a,$b] as $to){foreach([false,true] as $house){$field=$house?'SlotsHouse':'SlotsBag';$where=$house?"i.Equipment IN ('ho','hi')":"i.Equipment NOT IN ('ho','hi')";$count=(int)$db->scalar("SELECT COUNT(*) FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND {$where}",[$to->dbId],0);$free=0;$incoming=0;foreach($plans as $pl){$isHouse=in_array((string)$pl['row']['Equipment'],['ho','hi'],true);if($isHouse!==$house)continue;if($pl['from']===$to&&$pl['qty']===(int)$pl['row']['Quantity'])$free++;if($pl['to']===$to&&!$pl['existing'])$incoming++;}if($count-$free+$incoming>(int)($to->user[$field]??0))throw new \RuntimeException($to->username.' inventory is full!');}}
            $transfers=[];
            foreach($plans as $pl){$from=$pl['from'];$to=$pl['to'];$r=$pl['row'];$qty=$pl['qty'];$existing=$pl['existing'];
                if($existing){$new=(int)$existing['Quantity']+$qty;$db->run('UPDATE users_items SET Quantity=? WHERE id=?',[$new,(int)$existing['id']]);$toChar=(int)$existing['id'];}
                else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,EnhItemID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,?,0,?,0,0,NOW())',[$to->dbId,(int)$r['ItemID'],(int)($r['EnhID']??0),(int)($r['EnhItemID']??0),$qty]);$toChar=(int)$db->lastInsertId();}
                if($qty===(int)$r['Quantity'])$db->run('DELETE FROM users_items WHERE id=?',[(int)$pl['char']]);else$db->run('UPDATE users_items SET Quantity=Quantity-? WHERE id=?',[$qty,(int)$pl['char']]);
                $db->run('INSERT INTO users_trades_items (FromUserID,ToUserID,ItemID,EnhID,Quantity) VALUES (?,?,?,?,?)',[$from->dbId,$to->dbId,(int)$r['ItemID'],(int)$r['EnhID'],$qty]);
                $transfers[]=['to'=>$to,'from'=>$from,'itemId'=>(int)$r['ItemID'],'enhId'=>(int)$r['EnhID'],'enhItemId'=>(int)($r['EnhItemID']??0),'qty'=>$qty,'charId'=>$toChar];
            }
            $aGold=(int)$ua['Gold']-$a->tradeGold+$b->tradeGold;$aCoins=(int)$ua['Coins']-$a->tradeCoins+$b->tradeCoins;$bGold=(int)$ub['Gold']-$b->tradeGold+$a->tradeGold;$bCoins=(int)$ub['Coins']-$b->tradeCoins+$a->tradeCoins;
            $db->run('UPDATE users SET Gold=?,Coins=? WHERE id=?',[$aGold,$aCoins,$a->dbId]);$db->run('UPDATE users SET Gold=?,Coins=? WHERE id=?',[$bGold,$bCoins,$b->dbId]);
            $db->run('INSERT INTO users_trades (FromUserID,ToUserID,Coins,Gold) VALUES (?,?,?,?)',[$a->dbId,$b->dbId,$a->tradeCoins,$a->tradeGold]);
            $db->run('INSERT INTO users_trades (FromUserID,ToUserID,Coins,Gold) VALUES (?,?,?,?)',[$b->dbId,$a->dbId,$b->tradeCoins,$b->tradeGold]);
            return ['transfers'=>$transfers,'wallets'=>[[$a,$aGold,$aCoins],[$b,$bGold,$bCoins]]];
        });
    }
    private function applyTradeClientResult(array $result): void
    {
        foreach($result['wallets']??[] as [$c,$gold,$coins]){$c->user['Gold']=$gold;$c->user['Coins']=$coins;$this->server->sendJson($c,['cmd'=>'updateGoldCoins','gold'=>$gold,'coins'=>$coins]);}
        foreach($result['transfers']??[] as $tr){$to=$tr['to'];$item=$this->world->items[$tr['itemId']]??$this->db->one('SELECT * FROM items WHERE id=?',[$tr['itemId']]);if(!$item)continue;$item['EnhID']=$tr['enhId'];$item['EnhItemID']=$tr['enhItemId']??0;$obj=$this->itemJson($item,$tr['qty']);$this->server->sendJson($to,['cmd'=>'dropItem','items'=>[(string)$tr['itemId']=>$obj],'addItem'=>1]);$gd=['cmd'=>'getDrop','ItemID'=>$tr['itemId'],'CharItemID'=>$tr['charId'],'bBank'=>false,'iQty'=>$tr['qty'],'bSuccess'=>'1'];foreach(['EnhID','EnhLvl','EnhPatternID','EnhRty','iRng','EnhRng','InvEnhPatternID','EnhDPS'] as $k)if(isset($obj[$k]))$gd[$k]=$obj[$k];$this->server->sendJson($to,$gd);}
    }
    private function tradeResetPair(ClientSession $a,ClientSession $b): void { foreach([$a,$b] as $c){$c->tradeTarget=null;$c->tradeItems=[];$c->tradeGold=$c->tradeCoins=0;$c->tradeLocked=$c->tradeAccepted=false;} }
    private function friendRows(ClientSession $u): array
    { $rows=$this->db->all('SELECT x.id ID,x.Level iLvl,x.Name sName,x.CurrentServer sServer FROM users_friends f INNER JOIN users x ON x.id=f.FriendID WHERE f.UserID=? ORDER BY x.Name',[$u->dbId]);foreach($rows as &$r){$r['ID']=(int)$r['ID'];$r['iLvl']=(int)$r['iLvl'];$r['sServer']=(string)($r['sServer']?:'Offline');}unset($r);return $rows; }
    private function friendObject(ClientSession $u): array { return ['iLvl'=>$u->level,'ID'=>$u->dbId,'sName'=>$u->username,'sServer'=>(string)($this->world->server['Name']??'Aera')]; }
    private function requestFriend(ClientSession $u,array $p): void
    { $name=trim((string)($p[0]??''));$t=$this->server->findUser($name);if(!$t){$this->server->sendRaw($u,['server','Player "'.$name.'" could not be found.']);return;}if(!SettingsCodec::allowed('bFriend',$u,$t)){$this->server->sendRaw($u,['server',$t->username.' is not accepting friend requests.']);return;}if($t->state===2){$this->server->sendRaw($u,['server',$t->username.' is currently busy.']);return;}if($t===$u){$this->server->sendRaw($u,['warning','You cannot add yourself as a friend.']);return;}if((int)$this->db->scalar('SELECT COUNT(*) FROM users_friends WHERE UserID=? AND FriendID=?',[$u->dbId,$t->dbId],0)>0){$this->server->sendRaw($u,['server',$t->username.' was already added to your friends list.']);return;}$t->friendRequests[$u->dbId]=true;$this->server->sendJson($t,['cmd'=>'requestFriend','unm'=>$u->username,'ID'=>$u->dbId]);$this->server->sendRaw($u,['server','You have requested '.$t->username.' to be friends.']); }
    private function declineFriend(ClientSession $u,array $p): void
    { $name=trim((string)($p[0]??''));$t=$this->server->findUser($name);if($t){unset($u->friendRequests[$t->dbId]);$this->server->sendRaw($t,['server',$u->username.' declined your friend request.']);}$this->server->sendRaw($u,['server','Friend request declined.']); }
    private function isModerator(ClientSession $u,array $p): void
    { $name=trim((string)($p[0]??$u->username));$t=$this->server->findUser($name);$row=$t?['Access'=>$t->access,'Name'=>$t->username]:$this->db->one('SELECT Access,Name FROM users WHERE LOWER(Name)=LOWER(?)',[$name]);$this->server->sendJson($u,['cmd'=>'isModerator','val'=>(bool)($row && (int)$row['Access']>=40),'unm'=>$row['Name']??$name]); }
    private function denyDrop(ClientSession $u,array $p): void
    { $id=(int)($p[0]??0);unset($u->pendingDrops[$id]);$this->server->sendJson($u,['cmd'=>'denyDrop','ItemID'=>$id,'bSuccess'=>'1']); }
    private function factionList(ClientSession $u): array
    { $rows=$this->db->all('SELECT uf.id CharFactionID,uf.FactionID,uf.Reputation iRep,f.Name sName FROM users_factions uf INNER JOIN factions f ON f.id=uf.FactionID WHERE uf.UserID=? ORDER BY uf.id',[$u->dbId]);foreach($rows as &$r){$r['FactionID']=(string)$r['FactionID'];$r['CharFactionID']=(string)$r['CharFactionID'];$r['iRep']=(int)$r['iRep'];}unset($r);return $rows; }
    private function sendFactions(ClientSession $u,string $cmd='loadFactions'): void { $this->server->sendJson($u,['cmd'=>$cmd,'factions'=>$this->factionList($u)]); }
    private function sendEnhancementPatterns(ClientSession $u): void
    { $o=[];foreach($this->db->all('SELECT * FROM enhancements_patterns ORDER BY id') as $ep){$wis=(int)$ep['Wisdom'];$end=(int)$ep['Endurance'];$lck=(int)$ep['Luck'];$str=(int)$ep['Strength'];$dex=(int)$ep['Dexterity'];$int=(int)$ep['Intelligence'];$o[(string)$ep['id']]=['ID'=>(string)$ep['id'],'id'=>(int)$ep['id'],'sName'=>(string)$ep['Name'],'sDesc'=>(string)$ep['Desc'],'iWIS'=>(string)$wis,'iEND'=>(string)$end,'iLCK'=>(string)$lck,'iSTR'=>(string)$str,'iDEX'=>(string)$dex,'iINT'=>(string)$int,'Wisdom'=>$wis,'Endurance'=>$end,'Luck'=>$lck,'Strength'=>$str,'Dexterity'=>$dex,'Intelligence'=>$int];}$this->server->sendJson($u,['cmd'=>'enhp','o'=>$o]); }
    private function sendLoadPrefs(ClientSession $u): void
    { $costumes=[];foreach($this->db->all('SELECT i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Wear=1 AND ui.Bank=0',[$u->dbId]) as $i)$costumes[$i['Equipment']]=['ItemID'=>(int)$i['id'],'sFile'=>$i['File'],'sLink'=>$i['Link'],'iRty'=>(int)$i['Rarity'],'sType'=>$i['Type']];$loadouts=[];foreach($this->db->all('SELECT * FROM users_outfits WHERE UserID=?',[$u->dbId]) as $lo){$d=[];foreach(array_filter(array_map('trim',explode(',',(string)$lo['Equipments']))) as $iid){$i=$this->db->one('SELECT id,Equipment FROM items WHERE id=?',[(int)$iid]);if($i)$d[$i['Equipment']]=(int)$i['id'];}$d['colors']=['accessory'=>$lo['ColorAccessory'],'base'=>$lo['ColorBase'],'trim'=>$lo['ColorTrim'],'hair'=>$lo['ColorHair'],'skin'=>$lo['ColorSkin'],'eye'=>$lo['ColorEye']];$loadouts[$lo['Name']]=$d;}$this->server->sendJson($u,['cmd'=>'loadPrefs','success'=>true,'result'=>['costumes'=>$costumes,'loadouts'=>$loadouts,'prefs'=>SettingsCodec::all((int)($u->user['Settings']??0))]]); }
    private function sendBoosts(ClientSession $u): void
    { foreach(['ExpBoostExpire'=>'xpboost','CpBoostExpire'=>'cpboost','RepBoostExpire'=>'repboost','GoldBoostExpire'=>'gboost','CoinsBoostExpire'=>'coinsboost'] as $field=>$cmd){try{$secs=(int)$this->db->scalar("SELECT GREATEST(0,TIMESTAMPDIFF(SECOND,NOW(),`{$field}`)) FROM users WHERE id=?",[$u->dbId],0);$u->boostFlags[$cmd]=$secs>0;if($secs>0)$this->server->sendJson($u,['cmd'=>$cmd,'bShowShop'=>'undefined','op'=>'+','iSecsLeft'=>$secs]);}catch(Throwable){$u->boostFlags[$cmd]=false;}} }
/** Ensure every current/future user has a persistent stat row. */
private function ensureUserStats(ClientSession $u,?Database $db=null): array
{
    $db=$db??$this->db;
    $db->run('INSERT IGNORE INTO users_stats (UserID,Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck) VALUES (?,?,?,?,?,?,?,?)',[$u->dbId,max(0,$u->level-1)*3,0,0,0,0,0,0]);
    return $db->one('SELECT UserID,Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=?',[$u->dbId])??['UserID'=>$u->dbId,'Points'=>0,'Strength'=>0,'Intellect'=>0,'Dexterity'=>0,'Endurance'=>0,'Wisdom'=>0,'Luck'=>0];
}
private function statPayload(ClientSession $u): array
{
    $r=$this->ensureUserStats($u);
    return ['Points'=>(int)$r['Points'],'Strength'=>(int)$r['Strength'],'Intellect'=>(int)$r['Intellect'],'Dexterity'=>(int)$r['Dexterity'],'Endurance'=>(int)$r['Endurance'],'Wisdom'=>(int)$r['Wisdom'],'Luck'=>(int)$r['Luck']];
}
private function spendStatPoints(ClientSession $u,array $p): void
{
    $raw=strtolower(trim((string)($p[0]??'')));
    $map=['str'=>'Strength','strength'=>'Strength','int'=>'Intellect','intellect'=>'Intellect','dex'=>'Dexterity','dexterity'=>'Dexterity','end'=>'Endurance','endurance'=>'Endurance','wis'=>'Wisdom','wisdom'=>'Wisdom','lck'=>'Luck','luck'=>'Luck'];
    $stat=$map[$raw]??null;
    if($stat===null){$this->server->sendJson($u,['cmd'=>'spendStatPoints','bitSuccess'=>0,'msg'=>'Invalid stat.']);return;}
    $ok=false;$row=[];
    $this->db->tx(function(Database $db)use($u,$stat,&$ok,&$row){
        $this->ensureUserStats($u,$db);$locked=$db->one('SELECT Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=? FOR UPDATE',[$u->dbId]);
        if(!$locked||(int)$locked['Points']<1){$row=$locked??[];return;}
        $db->run("UPDATE users_stats SET `{$stat}`=`{$stat}`+1,Points=Points-1 WHERE UserID=? AND Points>0",[$u->dbId]);$ok=true;
        $row=$db->one('SELECT Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=?',[$u->dbId])??[];
    });
    if(!$ok){$this->server->sendJson($u,['cmd'=>'spendStatPoints','bitSuccess'=>0,'msg'=>'You do not have enough stat points.','Points'=>(int)($row['Points']??0)]);return;}
    $this->sendStats($u,false);
    $payload=['cmd'=>'spendStatPoints','bitSuccess'=>1,'msg'=>$stat.' increased by 1.','Points'=>(int)$row['Points'],'allocatedStats'=>['Strength'=>(int)$row['Strength'],'Intellect'=>(int)$row['Intellect'],'Dexterity'=>(int)$row['Dexterity'],'Endurance'=>(int)$row['Endurance'],'Wisdom'=>(int)$row['Wisdom'],'Luck'=>(int)$row['Luck']]];
    $this->server->sendJson($u,$payload);$this->log->info('Player '.strtolower($u->username).' spent 1 stat point on '.$stat.'; remaining='.(int)$row['Points']);
}

private function saveStatPoints(ClientSession $u,array $p): void
{
    // The client stages all changes locally. Save commits one non-negative delta
    // for each stat in a single transaction, so partial/forged saves cannot occur.
    $deltas=[
        'Strength'=>max(0,(int)($p[0]??0)),
        'Intellect'=>max(0,(int)($p[1]??0)),
        'Dexterity'=>max(0,(int)($p[2]??0)),
        'Endurance'=>max(0,(int)($p[3]??0)),
        'Wisdom'=>max(0,(int)($p[4]??0)),
        'Luck'=>max(0,(int)($p[5]??0)),
    ];
    $total=array_sum($deltas);
    if($total<1){$row=$this->ensureUserStats($u);$this->server->sendJson($u,['cmd'=>'saveStatPoints','bitSuccess'=>1,'msg'=>'No pending stat points.','Points'=>(int)$row['Points'],'allocatedStats'=>['Strength'=>(int)$row['Strength'],'Intellect'=>(int)$row['Intellect'],'Dexterity'=>(int)$row['Dexterity'],'Endurance'=>(int)$row['Endurance'],'Wisdom'=>(int)$row['Wisdom'],'Luck'=>(int)$row['Luck']]]);return;}
    // Hard ceiling keeps intentionally malformed packets from carrying absurd integers.
    if($total>100000){$this->server->sendJson($u,['cmd'=>'saveStatPoints','bitSuccess'=>0,'msg'=>'Invalid stat allocation.']);return;}
    $ok=false;$row=[];
    $this->db->tx(function(Database $db)use($u,$deltas,$total,&$ok,&$row){
        $this->ensureUserStats($u,$db);
        $locked=$db->one('SELECT Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=? FOR UPDATE',[$u->dbId]);
        if(!$locked||(int)$locked['Points']<$total){$row=$locked??[];return;}
        $db->run('UPDATE users_stats SET Strength=Strength+?,Intellect=Intellect+?,Dexterity=Dexterity+?,Endurance=Endurance+?,Wisdom=Wisdom+?,Luck=Luck+?,Points=Points-? WHERE UserID=? AND Points>=?',[
            $deltas['Strength'],$deltas['Intellect'],$deltas['Dexterity'],$deltas['Endurance'],$deltas['Wisdom'],$deltas['Luck'],$total,$u->dbId,$total
        ]);
        $row=$db->one('SELECT Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=?',[$u->dbId])??[];
        $ok=true;
    });
    $alloc=['Strength'=>(int)($row['Strength']??0),'Intellect'=>(int)($row['Intellect']??0),'Dexterity'=>(int)($row['Dexterity']??0),'Endurance'=>(int)($row['Endurance']??0),'Wisdom'=>(int)($row['Wisdom']??0),'Luck'=>(int)($row['Luck']??0)];
    if(!$ok){$this->server->sendJson($u,['cmd'=>'saveStatPoints','bitSuccess'=>0,'msg'=>'You do not have enough unspent stat points.','Points'=>(int)($row['Points']??0),'allocatedStats'=>$alloc]);return;}
    // Send the commit acknowledgement first so the panel clears its pending values
    // before the live derived-stat packet refreshes the window.
    $this->server->sendJson($u,['cmd'=>'saveStatPoints','bitSuccess'=>1,'msg'=>'Stat allocation saved.','Points'=>(int)$row['Points'],'allocatedStats'=>$alloc]);
    $this->sendStats($u,false);
    $this->log->info('Player '.strtolower($u->username).' saved stat allocation: STR+'.$deltas['Strength'].' INT+'.$deltas['Intellect'].' DEX+'.$deltas['Dexterity'].' END+'.$deltas['Endurance'].' WIS+'.$deltas['Wisdom'].' LCK+'.$deltas['Luck'].' | spent='.$total.' | remaining='.(int)$row['Points']);
}

private function resetStatPoints(ClientSession $u): void
{
    $row=[];$refund=0;
    $this->db->tx(function(Database $db)use($u,&$row,&$refund){
        $this->ensureUserStats($u,$db);
        $locked=$db->one('SELECT Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=? FOR UPDATE',[$u->dbId])??[];
        $refund=(int)($locked['Strength']??0)+(int)($locked['Intellect']??0)+(int)($locked['Dexterity']??0)+(int)($locked['Endurance']??0)+(int)($locked['Wisdom']??0)+(int)($locked['Luck']??0);
        $db->run('UPDATE users_stats SET Points=Points+?,Strength=0,Intellect=0,Dexterity=0,Endurance=0,Wisdom=0,Luck=0 WHERE UserID=?',[$refund,$u->dbId]);
        $row=$db->one('SELECT Points,Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=?',[$u->dbId])??[];
    });
    $alloc=['Strength'=>0,'Intellect'=>0,'Dexterity'=>0,'Endurance'=>0,'Wisdom'=>0,'Luck'=>0];
    $this->server->sendJson($u,['cmd'=>'resetStatPoints','bitSuccess'=>1,'msg'=>'All allocated stat points were refunded.','Refunded'=>$refund,'Points'=>(int)($row['Points']??0),'allocatedStats'=>$alloc]);
    $this->sendStats($u,false);
    $this->log->info('Player '.strtolower($u->username).' reset all allocated stats; refunded='.$refund.' | remaining='.(int)($row['Points']??0));
}

    private function sendStats(ClientSession $u,bool $restoreNeutral=true): void
    {
        $this->ensureUserStats($u);
        $oldHp=max(0,(int)$u->hp);$oldMp=max(0,(int)$u->mp);
        $oldHpMax=max(1,(int)$u->hpMax);$oldMpMax=max(1,(int)$u->mpMax);
        $wasNeutral=$u->state===1;
        $calc=$this->statsCalculator->calculate($u);
        $u->stats=$calc['sta'];$u->wDPS=$calc['wDPS'];$u->mDPS=$calc['mDPS'];$u->minDmg=$calc['minDmg'];$u->maxDmg=$calc['maxDmg'];$u->classCategory=$calc['classCat'];
        $u->hpMax=max(1,(int)$calc['hpMax']);$u->mpMax=max(1,(int)$calc['mpMax']);
        if($restoreNeutral&&$wasNeutral){
            $u->hp=$u->hpMax;$u->mp=$u->mpMax;
        }else{
            // Stat spending must be live without acting as a free heal/refill.
            // Preserve the player's current HP/MP percentage across max-value changes.
            $u->hp=$oldHp<=0?0:max(1,min($u->hpMax,(int)round(($oldHp/$oldHpMax)*$u->hpMax)));
            $u->mp=max(0,min($u->mpMax,(int)round(($oldMp/$oldMpMax)*$u->mpMax)));
        }
        $sp=$this->statPayload($u);
        $this->server->sendJson($u,[
            'cmd'=>'stu','tempSta'=>$calc['tempSta'],'sta'=>$calc['sta'],'wDPS'=>$calc['wDPS'],'mDPS'=>$calc['mDPS'],
            'statPoints'=>$sp['Points'],'allocatedStats'=>['Strength'=>$sp['Strength'],'Intellect'=>$sp['Intellect'],'Dexterity'=>$sp['Dexterity'],'Endurance'=>$sp['Endurance'],'Wisdom'=>$sp['Wisdom'],'Luck'=>$sp['Luck']],
            'intHP'=>$u->hp,'intHPMax'=>$u->hpMax,'intMP'=>$u->mp,'intMPMax'=>$u->mpMax,'intState'=>$u->state
        ]);
        // Push the live vitals to this player and everyone else in the room immediately.
        $r=$this->server->currentRoom($u);if($r)$this->server->broadcastRaw(['uotls',$u->username,'intHP:'.$u->hp.',intHPMax:'.$u->hpMax.',intMP:'.$u->mp.',intMPMax:'.$u->mpMax.',intState:'.$u->state],$r);
    }
    private function sendHouseInventory(ClientSession $u): void
    { $items=[];foreach($this->db->all("SELECT ui.id UserItemID,ui.Quantity iQty,ui.Equipped,ui.Bank,ui.Wear,ui.EnhID,ui.EnhItemID,ui.DatePurchased,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND i.Equipment IN ('ho','hi')",[$u->dbId]) as $r)$items[]=$this->itemJson($r,(int)$r['iQty'],(int)$r['UserItemID']);$this->server->sendJson($u,['cmd'=>'loadHouseInventory','sHouseInfo'=>(string)($u->user['HouseInfo']??''),'items'=>$items]); }
    private function colorInt(mixed $v): int { $s=ltrim((string)$v,'#');return ctype_xdigit($s)?(int)hexdec($s):(int)$v; }
    private function isoDate(mixed $v): string { if(!$v)return date("Y-m-d\\TH:i:s");return str_replace(' ','T',substr((string)$v,0,19)); }
    private function expToLevel(int $level): int { return $this->math->expToLevel($level); }
    private function questStringData(ClientSession $u): void { $this->server->sendJson($u,['cmd'=>'loadQuestStringData','obj'=>['strQuests'=>(string)($u->user['Quests']??''),'strQuests2'=>(string)($u->user['Quests2']??'')]]); }
    private function updateQuestValue(ClientSession $u,array $p): void
    { $idx=max(0,(int)($p[0]??0));$requested=(int)($p[1]??0);$val=($requested>=0&&$requested<36)?$requested:0;$field=$idx>99?'Quests2':'Quests';$i=$idx>99?$idx-100:$idx;$str=(string)($u->user[$field]??'');if(strlen($str)<=$i)$str=str_pad($str,$i+1,'0');$char=$val<10?(string)$val:chr(55+$val);$str=substr($str,0,$i).$char.substr($str,$i+1);$this->db->run("UPDATE users SET `{$field}`=? WHERE id=?",[$str,$u->dbId]);$u->user[$field]=$str;$this->server->sendJson($u,['cmd'=>'updateQuest','iIndex'=>$idx,'iValue'=>$val]); }
    private function removeTempItem(ClientSession $u,array $p): void { $id=(int)($p[0]??0);$qty=max(1,(int)($p[1]??1));$have=(int)($u->temporaryItems[$id]??0);if($have<=0)return;$left=max(0,$have-$qty);if($left>0)$u->temporaryItems[$id]=$left;else unset($u->temporaryItems[$id]);$this->server->sendJson($u,['cmd'=>'removeTempItem','ItemID'=>$id,'iQty'=>$qty,'iQtyNow'=>$left,'bitSuccess'=>1]); }
    private function retrieveMonsterData(ClientSession $u,array $p): void
    { $r=$this->server->currentRoom($u);$mon=[];if($r){foreach($r->monsters as $m)$mon[(string)$m['MonMapID']]=['MonID'=>$m['MonID'],'MonMapID'=>$m['MonMapID'],'intHP'=>$m['HP'],'intHPMax'=>$m['HPMax'],'intMP'=>$m['MP'],'intMPMax'=>$m['MPMax'],'intLevel'=>$m['Level'],'intState'=>$m['state'],'strMonName'=>$m['Name'],'strMonFileName'=>$m['File'],'strLinkage'=>$m['Linkage']];}$this->server->sendJson($u,['cmd'=>'initMonData','mon'=>$mon]); }
    private function changeClass(ClientSession $u,array $p): void
    { $itemId=(int)($p[0]??0);$r=$this->db->one("SELECT ui.id CharItemID,ui.ItemID,i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.ItemID=? AND ui.UserID=? AND ui.Bank=0 AND (i.Equipment='ar' OR i.Type='Class') LIMIT 1",[$itemId,$u->dbId]);if(!$r)return;$this->equip($u,[$itemId],true);$room=$this->server->currentRoom($u);$o=['cmd'=>'changeClass','uid'=>$u->sfsUserId,'ItemID'=>$itemId,'strClassName'=>$r['Name'],'sFile'=>$r['File'],'sLink'=>$r['Link'],'bitSuccess'=>1];if($room)$this->server->broadcastJson($o,$room);else$this->server->sendJson($u,$o); }
    private function setHomeTown(ClientSession $u,array $p): void { $home=trim((string)($p[0]??''));if($home==='')$home=explode('-',$u->roomName)[0];$this->server->sendJson($u,['cmd'=>'setHomeTown','bitSuccess'=>1,'sHomeTown'=>$home]); }
    private function summonPet(ClientSession $u,array $p): void { $this->server->sendJson($u,['cmd'=>'summonPet','bitSuccess'=>1,'uid'=>$u->sfsUserId,'ItemID'=>(int)($p[0]??0)]); }
    private function dynamicChat(ClientSession $u,array $p): void { $text=trim(implode(' ',array_map('strval',$p)));if($text!==''){$r=$this->server->currentRoom($u);if($r)$this->server->broadcastRaw($this->chatPacket($u,'zone',$text,$r),$r);} }

    private function loadWar(ClientSession $u,array $p): void
    { $id=(int)($p[0]??0);$w=$id>0?$this->db->one('SELECT * FROM wars WHERE id=?',[$id]):$this->db->one('SELECT * FROM wars ORDER BY id LIMIT 1');if($w)$this->server->sendJson($u,['cmd'=>'loadWarVars','id'=>(string)$w['id'],'Name'=>$w['Name'],'Points'=>(int)$w['Points'],'TotalPoints'=>(int)$w['MaxPoints']]);else$this->server->sendJson($u,['cmd'=>'loadWarVars','id'=>'0','Name'=>'','Points'=>0,'TotalPoints'=>0]); }
    private function setAchievementField(ClientSession $u,string $field,int $index,int $value): void
    {
        $map=['ia0'=>'Achievement','id0'=>'DailyQuests0','id1'=>'DailyQuests1','id2'=>'DailyQuests2','im0'=>'MonthlyQuests0'];
        if(!isset($map[$field])){$this->server->sendJson($u,['cmd'=>'setAchievement','field'=>$field,'index'=>$index,'value'=>$value]);return;}
        $column=$map[$field];$index=max(0,min(30,$index));$cur=(int)($u->user[$column]??0);$mask=1<<$index;$cur=$value?($cur|$mask):($cur&~$mask);$this->db->run("UPDATE users SET `{$column}`=? WHERE id=?",[$cur,$u->dbId]);$u->user[$column]=$cur;$this->server->sendJson($u,['cmd'=>'setAchievement','field'=>$field,'index'=>$index,'value'=>$value]);
    }
    private function queueRewardItem(ClientSession $u,array $item,int $qty): void
    {
        $itemId=(int)($item['ItemID']??$item['id']??0);if($itemId<=0||$qty<=0)return;$full=$this->world->items[$itemId]??$this->db->one('SELECT * FROM items WHERE id=?',[$itemId])??$item;$stack=max(1,(int)($full['Stack']??1));$qty=min($stack,$qty);
        // Java Users.dropItem(): quest-gated drops only appear while at least one ReqQuest is accepted.
        $reqQuests=trim((string)($full['ReqQuests']??''));
        if($reqQuests!==''){ $allowed=false;foreach(preg_split('/\s*,\s*/',$reqQuests)?:[] as $qid){if(ctype_digit($qid)&&isset($u->acceptedQuests[(int)$qid])){$allowed=true;break;}}if(!$allowed)return; }
        if((int)($full['Temporary']??0)===1){
            $have=(int)($u->temporaryItems[$itemId]??0);if($have>=$stack)return;$add=min($qty,$stack-$have);$u->temporaryItems[$itemId]=$have+$add;$this->server->sendJson($u,['cmd'=>'addItems','items'=>[(string)$itemId=>$this->itemJson($full,$add)]]);return;
        }
        $owned=(int)$this->db->scalar('SELECT COALESCE(MAX(Quantity),0) FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0',[$u->dbId,$itemId],0);if($owned>=$stack)return;
        $pending=(int)($u->pendingDrops[$itemId]??0);if($pending>0&&$stack===1)return;$add=min($qty,max(0,$stack-$pending));if($add<=0)return;$u->pendingDrops[$itemId]=$pending+$add;$o=$this->itemJson($full,$add);$o['showDrop']=1;$this->server->sendJson($u,['cmd'=>'dropItem','items'=>[(string)$itemId=>$o]]);
    }
    private function className(ClientSession $u): string
    {
        try{return (string)$this->db->scalar("SELECT i.Name FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 AND ui.Bank=0 AND (i.Equipment='ar' OR i.Type='Class') ORDER BY ui.id DESC LIMIT 1",[$u->dbId],'Adventurer');}catch(Throwable){return 'Adventurer';}
    }
    private function adminGiveItem(ClientSession $u,int $itemId,int $qty=1): void
    {
        if($u->access<40||$itemId<=0)return;
        $result=$this->grantItemToPlayer($u->dbId,$itemId,$qty,'/item by '.$u->username);
        $this->server->sendRaw($u,[!empty($result['ok'])?'server':'warning',(string)($result['message']??'Could not give item.')]);
    }

    /** Translate staff-rank names used by panel and in-game commands. */
    public function staffRankAccess(string $rank): ?int
    {
        $rank=strtolower(trim($rank));$rank=str_replace([' ','-','_'],'',$rank);
        return match($rank){
            '1','player','regular','user'=>1,
            '30','support','helper'=>30,
            '40','mod','moderator'=>40,
            '60','admin','administrator'=>60,
            '90','gm','gamemaster'=>90,
            '100','owner'=>100,
            default=>null,
        };
    }
    public function staffRankName(int $access): string
    {
        return $access>=100?'Owner':($access>=90?'Game Master':($access>=60?'Administrator':($access>=40?'Moderator':($access>=30?'Support':'Player'))));
    }
    /** Persist Access and immediately refresh an online recipient. */
    public function setPlayerAccess(int $userId,int $newAccess,string $source='staff rank change'): array
    {
        if(!in_array($newAccess,[1,30,40,60,90,100],true))return ['ok'=>false,'message'=>'Unsupported staff access level.'];
        $row=$this->db->one('SELECT id,Name,Access FROM users WHERE id=? LIMIT 1',[$userId]);if(!$row)return ['ok'=>false,'message'=>'Player could not be found.'];
        $old=(int)$row['Access'];if($old===$newAccess)return ['ok'=>true,'message'=>$row['Name'].' is already '.$this->staffRankName($newAccess).'.','online'=>$this->server->findUserByDbId($userId)!==null];
        $this->db->run('UPDATE users SET Access=? WHERE id=?',[$newAccess,$userId]);
        $live=$this->server->findUserByDbId($userId);
        if($live){
            $live->access=$newAccess;$live->user['Access']=$newAccess;$this->refreshLiveCommandState($live);
            $this->server->sendRaw($live,['server','Your rank is now '.$this->staffRankName($newAccess).' (Access '.$newAccess.').']);
        }
        $this->log->warn('Access change: player='.$row['Name'].' old='.$old.' new='.$newAccess.' source='.$source);
        return ['ok'=>true,'message'=>$row['Name'].' changed from '.$this->staffRankName($old).' to '.$this->staffRankName($newAccess).($live?' immediately.':'.'),'online'=>$live!==null,'oldAccess'=>$old,'newAccess'=>$newAccess];
    }

    /**
     * Grant an item directly to a user and refresh an online recipient immediately.
     * Used by /item, /giveitem and the web player-management panel.
     * @return array{ok:bool,message:string,player?:string,item?:string,quantity?:int,online?:bool}
     */
    // Admin /item is an immediate grant, and /giveitem/panel grants share the same live path.
    public function grantItemToPlayer(int $userId,int $itemId,int $qty=1,string $source='staff grant'): array
    {
        if($userId<=0||$itemId<=0)return ['ok'=>false,'message'=>'Invalid player or item ID.'];
        $target=$this->db->one('SELECT id,Name FROM users WHERE id=? LIMIT 1',[$userId]);
        if(!$target)return ['ok'=>false,'message'=>'Player could not be found.'];
        $item=$this->world->items[$itemId]??$this->db->one('SELECT * FROM items WHERE id=?',[$itemId]);
        if(!$item)return ['ok'=>false,'message'=>'Unknown item ID '.$itemId.'.'];
        $qty=max(1,$qty);$stack=max(1,(int)($item['Stack']??1));$live=$this->server->findUserByDbId($userId);

        // Temporary items only exist in the connected session by design.
        if((int)($item['Temporary']??0)===1){
            if(!$live)return ['ok'=>false,'message'=>'Temporary items can only be given while the player is online.'];
            $have=(int)($live->temporaryItems[$itemId]??0);$add=min($qty,max(0,$stack-$have));
            if($add<=0)return ['ok'=>false,'message'=>'Cannot go beyond '.$stack.' quantity for '.$item['Name'].'.'];
            $live->temporaryItems[$itemId]=$have+$add;
            $this->server->sendJson($live,['cmd'=>'addItems','items'=>[(string)$itemId=>$this->itemJson($item,$add)]]);
            $this->server->sendRaw($live,['server','You received '.$add.' x '.$item['Name'].'.']);
            $this->log->info('Item grant: player='.$target['Name'].' item='.$itemId.' qty='.$add.' source='.$source);
            return ['ok'=>true,'message'=>'Added '.$add.' x '.$item['Name'].'.','player'=>(string)$target['Name'],'item'=>(string)$item['Name'],'quantity'=>$add,'online'=>true];
        }

        $charId=0;$add=0;
        try{
            $this->db->tx(function(Database $db)use($userId,$itemId,$item,$qty,$stack,&$charId,&$add){
                $cur=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1 FOR UPDATE',[$userId,$itemId]);
                $owned=$cur?(int)$cur['Quantity']:0;$add=min($qty,max(0,$stack-$owned));
                if($add<=0)throw new \RuntimeException('stack full');
                if($cur){$charId=(int)$cur['id'];$db->run('UPDATE users_items SET Quantity=Quantity+? WHERE id=?',[$add,$charId]);}
                else{$db->run('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,0,?,0,0,NOW())',[$userId,$itemId,(int)($item['EnhID']??1),$add]);$charId=(int)$db->lastInsertId();}
            });
        }catch(Throwable $e){
            return ['ok'=>false,'message'=>$e->getMessage()==='stack full'?'Cannot go beyond '.$stack.' quantity for '.$item['Name'].'.':'Could not save the item grant.'];
        }

        if($live){
            $this->refreshLiveCommandState($live);
            $this->server->sendRaw($live,['server','You received '.$add.' x '.$item['Name'].'.']);
        }
        $this->log->info('Item grant: player='.$target['Name'].' item='.$itemId.' qty='.$add.' charItem='.$charId.' source='.$source);
        return ['ok'=>true,'message'=>'Added '.$add.' x '.$item['Name'].'.','player'=>(string)$target['Name'],'item'=>(string)$item['Name'],'quantity'=>$add,'online'=>$live!==null];
    }
    /** Reload mutable command-driven player state into the connected avatar. */
    private function refreshLiveCommandState(ClientSession $u): void
    {
        try{$row=$this->db->one('SELECT * FROM users WHERE id=?',[$u->dbId]);if($row){$u->user=array_replace($u->user,$row);$u->access=(int)($row['Access']??$u->access);$u->level=max(1,(int)($row['Level']??$u->level));}}catch(Throwable $e){$this->log->warn('Live command state reload failed for '.$u->username.': '.$e->getMessage());}
        $this->sendStats($u,false);
        $this->server->sendJson($u,['cmd'=>'updateGoldCoins','gold'=>(int)($u->user['Gold']??0),'coins'=>(int)($u->user['Coins']??0)]);
        // initUserData on the stock client immediately calls world.getInventory(),
        // giving us a complete inventory/class/faction refresh without relogging.
        $this->server->sendJson($u,['cmd'=>'initUserData','data'=>$this->userData($u,true),'strFrame'=>$u->frame,'strPad'=>$u->pad,'uid'=>$u->sfsUserId]);
        $room=$this->server->currentRoom($u);if($room)$this->server->broadcastRaw(['uotls',$u->username,'intLevel:'.$u->level.',intAccessLevel:'.$u->access],$room,$u);
        foreach($this->friendRows($u) as $friend){$c=$this->server->findUserByDbId((int)$friend['ID']);if($c)$this->server->sendJson($c,['cmd'=>'updateFriend','friend'=>$this->friendObject($u)]);}
    }
    private function adminCurrency(ClientSession $u,string $field,int $amount): void
    {
        if($u->access<40||!in_array($field,['Gold','Coins','Exp'],true))return;$amount=max(0,$amount);$cap=$field==='Exp'?2147483647:1000000;$this->db->run("UPDATE users SET `{$field}`=LEAST(?,`{$field}`+?) WHERE id=?",[$cap,$amount,$u->dbId]);$u->user[$field]=min($cap,(int)($u->user[$field]??0)+$amount);$this->server->sendRaw($u,['server',$amount.' '.$field.' added.']);$this->server->sendJson($u,['cmd'=>'updateGoldCoins','gold'=>(int)($u->user['Gold']??0),'coins'=>(int)($u->user['Coins']??0)]);
    }
    public function onDisconnect(ClientSession $u): void
    {
        $pvpRoomId=$u->pvpRoomId;
        $this->removeFromPvpQueue($u);
        if($u->partyId>0&&isset($this->parties[$u->partyId]))$this->partyRemove($u,$u->partyId,'l');
        $partner=$u->tradeTarget!==null?$this->server->findUserBySfsId($u->tradeTarget):null;
        if($partner){$this->server->sendJson($partner,['cmd'=>'tradeCancel','bitSuccess'=>1,'msg'=>$u->username.' left the trade.']);$this->tradeResetPair($u,$partner);}
        foreach($this->server->clients() as $client){unset($client->friendRequests[$u->dbId],$client->tradeRequests[$u->sfsUserId]);foreach($client->partyInvites as $pid=>$owner)if((int)$owner===$u->sfsUserId)unset($client->partyInvites[$pid]);if($client->duelInviteFrom===$u->sfsUserId)$client->duelInviteFrom=null;}
        // Users.lost() parity: online friends immediately receive Offline state.
        try{foreach($this->friendRows($u) as $friend){$client=$this->server->findUserByDbId((int)$friend['ID']);if(!$client)continue;$this->server->sendJson($client,['cmd'=>'updateFriend','friend'=>['iLvl'=>$u->level,'ID'=>$u->dbId,'sName'=>$u->username,'sServer'=>'Offline']]);$this->server->sendRaw($client,['server',$u->username.' has logged out.']);}}catch(Throwable $e){$this->log->warn('Friend offline update failed: '.$e->getMessage());}
        $gid=(int)($u->user['GuildID']??0);if($gid>0){try{$rankName=$this->guildRankName((int)($u->user['Rank']??0));foreach($this->server->clients() as $client)if($client!==$u&&(int)($client->user['GuildID']??0)===$gid)$this->server->sendRaw($client,$this->chatPacket(null,'guild',trim($rankName.' '.$u->username.' has logged out.')));$this->sendGuildUpdate($gid);}catch(Throwable $e){$this->log->warn('Guild offline update failed: '.$e->getMessage());}}
        $u->pvpRoomId=null;$u->pvpRoomName=null;$u->pvpJoinAt=0.0;$u->pvpExitAt=0.0;$u->resting=false;
        if($pvpRoomId!==null)$this->server->releasePreparedRoomIfUnused($pvpRoomId);
    }
    private function compatibilityAck(ClientSession $u,string $cmd): void { $this->log->warn("Compatibility handler used for {$cmd} by {$u->username}");$this->server->sendRaw($u,['server','The PHP emulator received '.$cmd.', but that legacy subsystem is still in compatibility mode.']); }
}
