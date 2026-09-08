<?php
declare(strict_types=1);
namespace AeraEmu;

/** Java World.java numeric formulas shared by login, stats, XP and item budgets. */
final class WorldMath
{
    public function __construct(private WorldRepository $world) {}

    public function rate(string $name, float $default=0.0): float
    { return (float)($this->world->rates[$name] ?? $default); }

    public function baseValueByLevel(float $base,float $delta,float $curve,int $level): float
    {
        $cap=max(2,(int)$this->rate('intLevelCap',100));
        $level=max(1,min($cap,$level));
        $x=($level-1)/($cap-1);
        return $base+pow($x,$curve)*$delta;
    }

    public function roundTens(int $value): int
    { while($value%10!==0)$value++; return $value; }

    public function expToLevel(int $level): int
    {
        $max=(int)$this->rate('intLevelMax',100);
        if($level>=$max)return 200000000;
        return $this->roundTens((int)$this->baseValueByLevel(1000,850000,1.66,$level));
    }

    public function manaByLevel(int $level): int
    {
        $base=(int)$this->rate('PCmpBase1',100);
        $delta=(int)$this->rate('PCmpBase100',2000);
        $curve=$this->rate('curveExponent',0.66)+($delta!==0?$base/$delta:0.0);
        return (int)$this->baseValueByLevel($base,$delta,$curve,$level);
    }

    public function healthByLevel(int $level): int
    {
        $base=(int)$this->rate('PChpGoal1',400);
        $delta=(int)$this->rate('PChpGoal100',4000);
        $curve=1.5+($delta!==0?$base/$delta:0.0);
        return (int)$this->baseValueByLevel($base,$delta,$curve,$level);
    }

    public function baseHpByLevel(int $level): int
    {
        return (int)$this->baseValueByLevel(
            $this->rate('PChpBase1',360),
            $this->rate('PChpDelta',1640),
            $this->rate('curveExponent',0.66),
            $level
        );
    }

    public function itemBudget(int $level,int $rarity): int
    {
        $base=$this->rate('GstBase',10);$goal=$this->rate('GstGoal',1000);
        $cap=max(2,(int)$this->rate('intLevelCap',100));$curve=$this->rate('statsExponent',1.5);
        // Java World.getIBudget() deliberately does not clamp the effective
        // item level to intLevelCap; rarity can push x above 1.0.
        $rarity=max(1,$rarity);$effective=$level+$rarity-1;
        $x=($effective-1)/($cap-1);
        return (int)round($base+pow($x,$curve)*($goal-$base));
    }

    public function innateBudget(int $level): int
    {
        $base=$this->rate('PCstBase',20);$goal=$this->rate('PCstGoal',200);
        return (int)$this->baseValueByLevel($base,$goal-$base,$this->rate('statsExponent',1.5),$level);
    }
}
