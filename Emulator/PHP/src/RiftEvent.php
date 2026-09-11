<?php
declare(strict_types=1);
namespace AeraEmu;

/** Pure, server-authoritative event state. No client-provided contribution values. */
final class RiftEvent
{
    public const MODIFIERS=['Blood','Arcane','Titan','Swift','Golden','Corrupted'];
    public string $phase='invasion';
    public int $kills=0, $crystals=0, $materials=0, $defense=0;
    public int $bossHp=0, $bossMax=0;
    public int $wardHp=100;
    public array $players=[];
    public float $nextMechanic=0, $strikeAt=0;
    public string $strikeFrame='';
    public string $commanderFrame='';
    public string $defenseCell='';
    public array $areas=[];
    public function __construct(public array $definition, public string $tier, public string $modifier, public float $multiplier, public float $startedAt) {}

    public function damage(int $userId,int $amount): void
    {
        if($amount<=0||$userId<=0||!in_array($this->phase,['invasion','objectives','commander'],true))return;
        $this->participant($userId);
        $this->players[$userId]['damage']+=$amount;
    }
    public function participant(int $id): void
    {
        $this->players[$id]??=['damage'=>0,'kills'=>0,'objectives'=>0,'materials'=>0];
    }
    public function kill(array $ids,string $role): void
    {
        if($this->phase==='invasion')$this->kills++;
        if($this->phase==='objectives'&&$role==='crystal')$this->crystals++;
        foreach(array_unique($ids) as $id){
            if(!isset($this->players[$id]))continue;
            $this->players[$id]['kills']++;
            if($this->phase==='objectives'){
                if($role==='crystal')$this->players[$id]['objectives']++;
                else $this->players[$id]['materials']=min(10,$this->players[$id]['materials']+1);
            }
        }
    }
    public function deposit(int $id): int
    {
        if($this->phase!=='objectives')return 0;
        $n=min((int)($this->players[$id]['materials']??0),max(0,(int)$this->definition['MaterialGoal']-$this->materials));
        if($n>0){$this->materials+=$n;$this->players[$id]['materials']-=$n;$this->players[$id]['objectives']+=$n;}
        return $n;
    }
    public function defend(array $ids): void
    {
        if($this->phase!=='objectives'||!$ids||$this->defense>=(int)$this->definition['DefenseSeconds'])return;
        $this->defense++;
        foreach(array_unique($ids) as $id){$this->participant($id);$this->players[$id]['objectives']++;}
    }
    public function ready(): bool
    {
        return $this->phase==='invasion' ? $this->kills>=(int)$this->definition['KillGoal'] :
            ($this->phase==='objectives'&&$this->crystals>=(int)$this->definition['CrystalGoal']&&$this->materials>=(int)$this->definition['MaterialGoal']&&$this->defense>=(int)$this->definition['DefenseSeconds']);
    }
    public function progress(): int
    {
        if($this->phase==='invasion')return min(100,(int)floor(100*$this->kills/max(1,(int)$this->definition['KillGoal'])));
        if($this->phase==='commander')return min(100,(int)floor(100*(1-$this->bossHp/max(1,$this->bossMax))));
        $sum=0;foreach(['CrystalGoal'=>$this->crystals,'MaterialGoal'=>$this->materials,'DefenseSeconds'=>$this->defense] as $key=>$value)$sum+=min(1,$value/max(1,(int)$this->definition[$key]));
        return (int)floor(100*$sum/3);
    }
    public static function reward(array $p,int $base,float $multiplier): array
    {
        // Damage is deliberately capped so objective play remains competitive at low levels.
        $score=min(10000,intdiv((int)$p['damage'],100))+(int)$p['kills']*100+(int)$p['objectives']*150;
        $medal=$score>=15000?'Legendary':($score>=5000?'Gold':($score>=1500?'Silver':'Bronze'));
        $factor=['Bronze'=>1,'Silver'=>2,'Gold'=>3,'Legendary'=>5][$medal];
        return ['score'=>$score,'medal'=>$medal,'shards'=>$score>0?(int)max(1,floor($base*$factor*$multiplier)):0];
    }
}
