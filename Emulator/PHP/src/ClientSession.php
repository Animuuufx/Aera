<?php
declare(strict_types=1);
namespace AeraEmu;

final class ClientSession
{
    /** @param resource $socket */
    public function __construct(public $socket, public int $socketId, public string $ip) {}
    public string $buffer='';
    public bool $apiOk=false;
    public bool $authenticated=false;
    /** Presence/login notices must only be emitted once per connected session. */
    public bool $presenceAnnounced=false;
    public int $sfsUserId=0;
    public int $dbId=0;
    public string $username='';
    public int $access=0;
    public int $level=1;
    public int $roomId=1;
    public string $roomName='limbo-1';
    public string $frame='Enter';
    public string $pad='Spawn';
    public int $x=0;
    public int $y=0;
    public int $hp=400;
    public int $hpMax=400;
    public int $mp=100;
    public int $mpMax=100;
    public int $state=1;
    public ?int $targetMonster=null;
    public array $user=[];
    public array $cooldowns=[];
    /** @var array<string,int> Runtime skill references injected by geia/potions (Java Users.SKILLS). */
    public array $dynamicSkills=[];
    /** @var array<int,array> active Java RemoveAura-equivalent records keyed by AuraID */
    public array $auras=[];
    /** @var array<int,array> periodic DamageOverTime state keyed by AuraID */
    public array $dots=[];
    /** @var array<int,array> class passive auras applied directly to Stats (Java applyPassiveAuras). */
    public array $passiveAuras=[];
    public float $lastRequestAt=0.0;

    // Java Suck_MElator / Users anti-flood runtime state.
    public int $requestCounter=0;
    public int $requestWarnings=0;
    public int $repeatedRequestCounter=0;
    public string $lastRequest='';
    public float $lastRequestMs=0.0;
    public int $messageFloodCounter=0;
    public int $messageFloodWarnings=0;
    public int $repeatedMessageCounter=0;
    public string $lastMessage='';
    public float $lastMessageMs=0.0;
    public float $muteUntil=0.0;
    // Calculated Java Stats values used by combat and the AS3 action bar.
    public array $stats=[];
    public int $wDPS=1;
    public int $mDPS=1;
    public int $minDmg=1;
    public int $maxDmg=2;
    public string $classCategory='M1';
    public int $stamina=100;
    public int $staminaMax=100;
    public bool $afk=false;
    /** @var array<int,bool> Java REQUESTED_GUILD equivalent; multiple guild invitations may coexist. */
    public array $guildInvites=[];
    /** Last/legacy invite id retained for compatibility with existing PHP state. */
    public int $guildInviteId=0;
    public int $partyId=0;
    public array $partyInvites=[];
    public ?int $duelInviteFrom=null;
    public ?int $tradeTarget=null;
    public string $riftShopToken='';
    /** @var array<int,bool> SmartFox user IDs that requested a trade with this player. */
    public array $tradeRequests=[];
    public array $tradeItems=[];
    public int $tradeGold=0;
    public int $tradeCoins=0;
    public bool $tradeLocked=false;
    public bool $tradeAccepted=false;
    /** @var array<int,bool> DB user IDs that requested friendship */
    public array $friendRequests=[];
    /** @var array<int,int> ItemID => pending drop quantity */
    public array $pendingDrops=[];
    /** @var array<int,int> temporary ItemID => quantity */
    public array $temporaryItems=[];
    /** @var array<int,bool> accepted quest IDs for this session */
    public array $acceptedQuests=[];
    public float $respawnAt=0.0;
    public bool $resting=false;
    public float $lastRegenAt=0.0;
    public ?string $pvpQueued=null;
    public ?int $pvpRoomId=null;
    public ?string $pvpRoomName=null;
    public int $pvpTeam=0;
    public float $pvpJoinAt=0.0;
    public float $pvpExitAt=0.0;
    /** Java ServerUseItem toggle state keyed by boost command (xpboost, gboost, ...). */
    public array $boostFlags=[];
    /** Java KickUser equivalent: delayed staff disconnect/logout state. */
    public float $kickAt=0.0;
    public bool $kickGraceful=false;
    public string $kickReason='';
    /** /position toggle: continuously refreshes the player's live X/Y HUD. */
    public bool $positionDisplay=false;
    public float $lastPositionDisplayAt=0.0;
}
