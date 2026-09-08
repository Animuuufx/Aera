<?php
declare(strict_types=1);
namespace AeraEmu;

/** Port of aqworlds.utils.Settings. A set bit means the preference is disabled. */
final class SettingsCodec
{
    private const BITS=[
        'bCloak'=>0,'bHelm'=>1,'bPet'=>2,'bWAnim'=>3,'bGoto'=>4,'bSoundOn'=>5,
        'bMusicOn'=>6,'bFriend'=>7,'bParty'=>8,'bGuild'=>9,'bWhisper'=>10,'bTT'=>11,
        'bFBShare'=>12,'bDuel'=>13,'bWorldBoss'=>19,'bTrade'=>20,
    ];
    public static function enabled(int $settings,string $pref): bool
    { return isset(self::BITS[$pref]) && AchievementBits::get($settings,self::BITS[$pref])===0; }
    public static function set(int $settings,string $pref,bool $enabled): int
    { return isset(self::BITS[$pref]) ? AchievementBits::update($settings,self::BITS[$pref],$enabled?0:1) : $settings; }
    public static function all(int $settings): array
    { $out=[];foreach(self::BITS as $name=>$bit)$out[$name]=AchievementBits::get($settings,$bit)===0;return $out; }
    public static function allowed(string $pref,ClientSession $requester,ClientSession $target): bool
    { return self::enabled((int)($target->user['Settings']??0),$pref) || $requester->access>=40; }
}
