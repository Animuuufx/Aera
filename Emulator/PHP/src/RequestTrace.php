<?php
declare(strict_types=1);
namespace AeraEmu;

/** Human-readable, parameter-complete request tracing for the live emulator console. */
final class RequestTrace
{
    private const LABELS=[
        // Core chat/movement/combat
        'message'=>['Message','Channel'],'whisper'=>['Message','Player'],'mv'=>['X','Y','Speed','Dash'],'moveToCell'=>['Cell','Pad'],
        'gar'=>['Action ID','Skill/Targets'],'aggroMon'=>[],'cc'=>['Canned Chat ID'],'em'=>['Emote'],'emotea'=>['Emote'],
        'getDrop'=>['Item ID'],'denyDrop'=>['Item ID'],'getMapItem'=>['Item ID'],'afk'=>['AFK'],
        // Inventory / shops / equipment. Indices follow the Java request classes exactly.
        'buyItem'=>['Item ID','Shop ID','Shop Item ID','Quantity'],'sellItem'=>['Item ID','Quantity','Character Item ID'],
        'equipItem'=>['Item ID'],'unequipItem'=>['Item ID'],'wearItem'=>['Item ID'],'unwearItem'=>['Equipment Slot'],
        'serverUseItem'=>['Option','Item ID/Type'],'removeItem'=>['Item ID','Character Item ID','Quantity'],
        'loadShop'=>['Shop ID'],'reloadShop'=>['Shop ID'],'loadHairShop'=>['Shop ID'],'enhanceItem'=>['Character Item ID','Enhancement Item ID'],
        'enhanceItemLocal'=>['Character Item ID','Enhancement Item ID'],'enhanceItemShop'=>['Character Item ID','Enhancement Item ID'],
        'forceEquipItem'=>['Item ID'],'removeTempItem'=>['Item ID','Quantity'],'changeClass'=>['Item ID'],'summonPet'=>['Item ID'],
        // Quests / achievements / titles / war
        'getQuests'=>['Quest IDs'],'getQuests2'=>['Quest IDs'],'acceptQuest'=>['Quest ID'],
        'tryQuestComplete'=>['Quest ID','Reward Item ID','Client Choice/Token','Quantity'],'updateQuest'=>['Index','Value'],
        'redeemCode'=>['Code'],'getAchievement'=>['Achievement ID'],'setAchievement'=>['Field','Index','Value'],
        'updateTitle'=>['Title ID','Action'],'loadWarVars'=>['War ID'],'setHomeTown'=>['Map'],
        // Bank
        'loadBank'=>[],'bankFromInv'=>['Item ID','Character Item ID'],'bankToInv'=>['Item ID','Character Item ID'],
        'bankSwapInv'=>['Item ID 1','Character Item ID 1','Item ID 2','Character Item ID 2'],
        // Friends / duel / social / guild / party
        'requestFriend'=>['Player'],'addFriend'=>['Player'],'declineFriend'=>['Player'],'deleteFriend'=>['Unused/Requester','Player'],
        'isModerator'=>['Player'],'duel'=>['Player'],'da'=>['Player'],'dd'=>['Player'],'gp'=>['Action','Arg 1','Arg 2','Arg 3'],
        'guild'=>['Action','Arg 1','Arg 2','Arg 3','Arg 4'],'house'=>['Player'],'housesave'=>['House Data'],
        // Trade. Target values are SmartFox user IDs in the Java protocol.
        'ti'=>['Player'],'tia'=>['Player'],'tid'=>['Player'],'tradeCancel'=>['Target User ID'],'tradeDeal'=>['Target User ID'],
        'tradeFromInv'=>['Item ID','Character Item ID','Target User ID','Quantity'],
        'tradeToInv'=>['Item ID','Character Item ID','Target User ID'],
        'tradeSwapInventory'=>['Item ID 1','Character Item ID 1','Item ID 2','Character Item ID 2','Target User ID'],
        'tradeSwapInv'=>['Item ID 1','Character Item ID 1','Item ID 2','Character Item ID 2','Target User ID'],
        'tradeLock'=>['Target User ID','Gold','Coins'],'tradeUnlock'=>['Target User ID'],'loadOffer'=>[],
        // Loadouts / appearance
        'addLoadout'=>['Name','Loadout JSON','Original Name'],'equipLoadout'=>['Unused/User ID','Name','Keep Color'],
        'wearLoadout'=>['Unused/User ID','Name','Keep Color'],'removeLoadout'=>['Name'],
        'changeColor'=>['Skin','Hair','Eye','Hair ID'],'changeArmorColor'=>['Base','Trim','Accessory'],'genderSwapa'=>[],
        // User/state lookup
        'retrieveUserData'=>['User ID'],'retrieveUserDatas'=>['User IDs'],'retrieveMonData'=>['Monster Map IDs'],'resPlayerTimed'=>[],
        'ia'=>['Action','Arg 1','Arg 2','Player'],'geia'=>['Reference','Skill ID'],'mtcid'=>['ID'],
        // PvP / queues / misc
        'PVPQr'=>['Warzone'],'PVPIr'=>['Reply/Target'],'dungeonQueue'=>['Queue'],'dungeonRejoin'=>['Queue'],
        'castt'=>['Target'],'dynamic'=>['Message'],'fbCmd'=>['Action','Arg 1'],'getAdData'=>['Ad ID'],'getAdReward'=>['Ad ID'],'rewardReferral'=>['Referral'],
        // Slots
        'buyBagSlots'=>['Count'],'buyBankSlots'=>['Count'],'buyHouseSlots'=>['Count'],'buyLoadoutSlots'=>['Count'],
        // Auction
        'loadAuction'=>['Filter/Type'],'searchAuction'=>['Keyword'],'loadRetrieve'=>['Filter/Type'],
        'sellAuctionItem'=>['Item ID','Character Item ID','Quantity','Price','Currency'],
        'buyAuctionItem'=>['Auction ID'],'retrieveAuctionItem'=>['Auction ID'],'retrieveAuctionItems'=>['Auction IDs'],
        // Command and protocol helpers
        'cmd'=>['Command','Arg 1','Arg 2','Arg 3','Arg 4','Arg 5'],'trap door'=>['Value'],
        'firstJoin'=>[],'retrieveInventory'=>[],'restRequest'=>[],'loadTitles'=>[],'loadFriendsList'=>[],'getfriendlist'=>[],
        'loadFactions'=>[],'loadHouseInventory'=>[],'loadQuestStringData'=>[],'spendStatPoints'=>['Stat'],'saveStatPoints'=>['Strength','Intellect','Dexterity','Endurance','Wisdom','Luck'],'resetStatPoints'=>[],'getApop'=>['Apop ID'],'hi'=>[],
    ];

    public function __construct(private Database $db,private WorldRepository $world){}

    public function format(ClientSession $u,string $cmd,array $params,int $fromRoom): string
    {
        $player=strtolower($u->username?:'unknown');$room=$this->roomBase($u->roomName);$cell=$u->frame;
        if($cmd==='message')return "Player {$player} -> message: ".$this->safe($params[0]??'')." | Channel: ".$this->safe($params[1]??'zone')." | Room: {$room} | Cell: {$cell}".$this->extra($params,2);
        if($cmd==='whisper')return "Player {$player} -> whisper: ".$this->safe($params[0]??'')." | To: ".$this->safe($params[1]??'')." | Room: {$room} | Cell: {$cell}".$this->extra($params,2);
        if($cmd==='gar'){
            $target=$this->safe($params[1]??'');$resolved=$this->combatTargets($u,$target);
            return "Player {$player} -> combat: ".$this->safe($params[0]??'')." | Skill/Target: {$target}".($resolved!==''?" | {$resolved}":'')." | Room: {$room} | Cell: {$cell}".$this->extra($params,2);
        }
        if($cmd==='aggroMon')return "Player {$player} -> aggro monster: ".$this->monsterList($u,$params)." | Room: {$room} | Cell: {$cell}";
        if($cmd==='cmd'){
            $name=strtolower($this->safe($params[0]??''));$args=[];for($i=1;$i<count($params);$i++)$args[]=$this->safe($params[$i]);
            return "Player {$player} -> command: /{$name}".($args?' '.implode(' ',$args):'')." | Room: {$room} | Cell: {$cell}";
        }
        $parts=[];$labels=self::LABELS[$cmd]??[];
        foreach($params as $i=>$value){$label=$labels[$i]??('Param '.($i+1));$render=$this->safe($value);if(str_contains(strtolower($label),'item id')&&is_numeric($value)){$name=$this->itemName((int)$value);if($name)$render.=" ({$name})";}if(str_contains(strtolower($label),'quest id')&&is_numeric($value)){$name=$this->questName((int)$value);if($name)$render.=" ({$name})";}$parts[]="{$label}: {$render}";}
        $verb=$cmd;$detail=$parts?implode(' | ',$parts):'no params';
        return "Player {$player} -> {$verb}: {$detail} | Room: {$room} | Cell: {$cell} | FromRoomID: {$fromRoom}";
    }

    private function combatTargets(ClientSession $u,string $raw): string
    {
        $room=null; // resolution deliberately stays read-only
        if(!preg_match_all('/m:(\d+)/i',$raw,$m))return '';
        $names=[];foreach($m[1] as $id){$mon=$this->world->monsterByMapContext((int)$id,$this->roomBase($u->roomName));$names[]=$mon?((string)$mon['Name'].' #'.$id):('monster #'.$id);}return 'Targets: '.implode(', ',$names);
    }
    private function monsterList(ClientSession $u,array $ids): string
    { $out=[];foreach($ids as $id){$n=$this->world->monsterByMapContext((int)$id,$this->roomBase($u->roomName));$out[]=$n?((string)$n['Name'].' #'.(int)$id):('#'.(int)$id);}return $out?implode(', ',$out):'none'; }
    private function itemName(int $id): string { return (string)($this->world->items[$id]['Name']??''); }
    private function questName(int $id): string { return (string)($this->world->quests[$id]['Name']??''); }
    private function roomBase(string $room): string { return preg_replace('/-\d+$/','',$room)?:$room; }
    private function extra(array $params,int $start): string { $x=[];for($i=$start;$i<count($params);$i++)$x[]='Param '.($i+1).': '.$this->safe($params[$i]);return $x?' | '.implode(' | ',$x):''; }
    private function safe(mixed $v): string
    { if(is_bool($v))return $v?'true':'false';if(is_array($v)||is_object($v))$v=json_encode($v,JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);$s=preg_replace('/[\x00-\x1F\x7F]+/u',' ',(string)$v)??'';return $s===''?'<empty>':$s; }
}
