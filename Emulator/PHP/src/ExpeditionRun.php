<?php
declare(strict_types=1);
namespace AeraEmu;

use RuntimeException;

/** Pure run rules. No player/account stats are persisted or modified here. */
final class ExpeditionRun
{
    public const VERSION = 1;
    public const BLESSINGS = [
        'bloodlust'=>'Bloodlust: +8% direct and periodic damage per stack (max +160%).',
        'ward'=>'Iron Ward: 6% less incoming damage per stack (max 60%).',
        'executioner'=>'Executioner: +15% damage below 30% enemy HP per stack (max +150%).',
        'vampiric'=>'Vampiric Edge: heal 2% of actual damage per stack (max 10%).',
        'renewal'=>'Renewal: heal 1% maximum HP each second per stack (max 5%).',
        'reserve'=>'Arcane Reserve: restore 1% maximum mana each second per stack (max 5%).',
    ];
    public const MODIFIERS = ['Calm','Blood Moon','Titan','Glass Cannon','Swarm','Mana Drought'];
    public string $phase='lobby';
    public int $depth=0, $cleared=0, $bank=0, $roomId=0;
    public string $modifier='Calm', $kind='Normal', $frame='Enter';
    public array $members=[], $offers=[], $blessings=[], $votes=[];
    public float $startedAt, $lastProgress, $lastRegen=0;
    public bool $moving=false;
    public ?string $settlement=null;
    public function __construct(public int $id, public string $mode, public string $seed, public string $week, public int $leader, public int $partyId=0)
    {
        if(!in_array($mode,['solo','party','endless','weekly'],true))throw new RuntimeException('Unknown expedition mode.');
        $this->startedAt=$this->lastProgress=microtime(true);
    }
    /** Hash-indexed randomness keeps room generation independent of choices and timing. */
    public function roll(string $key,int $count): int
    {
        if($count<1)throw new RuntimeException('Empty expedition content pool.');
        return (int)hexdec(substr(hash('sha256',$this->seed.'|'.$key),0,7))%$count;
    }
    public function next(): void
    {
        if(!in_array($this->phase,['lobby','decision'],true))throw new RuntimeException('Clear the room and choose a blessing first.');
        if($this->phase==='decision'&&count($this->votes)!==count($this->members))throw new RuntimeException('Waiting for everyone to continue.');
        $this->depth++;$this->phase='combat';$this->votes=[];$this->offers=[];
        $this->kind=$this->depth%5===0?'Boss':($this->depth%3===0?'Elite':'Normal');
        $this->modifier=self::MODIFIERS[$this->roll('modifier:'.$this->depth,count(self::MODIFIERS))];
        $this->lastProgress=microtime(true);
    }
    public function clear(): void
    {
        if($this->phase!=='combat')return;
        $this->cleared=$this->depth;
        $this->bank=min(1000000,$this->bank+5+2*$this->depth+($this->kind==='Boss'?10:0));
        $this->phase='blessing';$this->lastProgress=microtime(true);
        $pool=array_keys(self::BLESSINGS);$offer=[];
        for($i=0;$i<3;$i++){$pick=$this->roll('blessing:'.$this->depth.':'.$i,count($pool));$offer[]=array_splice($pool,$pick,1)[0];}
        foreach($this->members as $uid=>$name)$this->offers[$uid]=$offer;
    }
    public function choose(int $uid,string $key): void
    {
        if($this->phase!=='blessing'||!in_array($key,$this->offers[$uid]??[],true))throw new RuntimeException('That blessing is no longer available.');
        $this->blessings[$uid][$key]=min(20,1+($this->blessings[$uid][$key]??0));unset($this->offers[$uid]);
        if(!$this->offers)$this->phase='decision';
    }
    public function vote(int $uid): void
    {
        if($this->phase!=='decision'||!isset($this->members[$uid]))throw new RuntimeException('Choose blessings before continuing.');
        $this->votes[$uid]=true;
    }
    public function finiteComplete(): bool { return in_array($this->mode,['solo','party'],true)&&$this->cleared>=10; }
    public function payout(string $status): int { return in_array($status,['cashed_out','completed'],true)?$this->bank:intdiv($this->bank,2); }
    public static function week(?int $now=null): string { return gmdate('o-\WW',$now??time()); }
    public function outgoing(int $uid,int $damage,int $hp,int $max): int
    {
        if($damage<=0)return $damage;
        $b=$this->blessings[$uid]??[];
        $factor=1+.08*min(20,$b['bloodlust']??0);
        if($hp<.3*$max)$factor+=.15*min(10,$b['executioner']??0);
        if($this->modifier==='Glass Cannon')$factor*=1.5;
        return max(1,(int)min(2000000000,round($damage*$factor)));
    }
    public function incoming(int $uid,int $damage): int
    { return $damage<=0?$damage:max(1,(int)round($damage*(1-min(.6,.06*($this->blessings[$uid]['ward']??0))))); }
}
