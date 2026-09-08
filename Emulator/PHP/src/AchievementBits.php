<?php
declare(strict_types=1);
namespace AeraEmu;

/** Port of aqworlds.utils.Achievement bit helpers. */
final class AchievementBits
{
    public static function get(int $value,int $index): int { return ($value >> $index) & 1; }
    public static function update(int $value,int $index,int $bit): int
    {
        $mask=1<<$index;
        return $bit ? ($value|$mask) : ($value&~$mask);
    }
}
