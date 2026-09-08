<?php
declare(strict_types=1);
namespace AeraEmu;

/**
 * Combat math shared by player actions and monster AI.
 *
 * v30.62 makes aura coefficients directional and server-authoritative.  The
 * earlier PHP port applied the same aura list as both outgoing and incoming
 * modifiers, which made defensive buffs increase damage in some paths and left
 * the client's $cai/$cao/$cpi/$cpo/... values mostly cosmetic.
 */
final class CombatMath
{
    private WorldMath $math;

    public function __construct(private Database $db, private WorldRepository $world)
    { $this->math=new WorldMath($world); }

    public function damageType(float $hitChance,float $dodgeChance,float $critChance): string
    {
        $hit=max(.05,min(.98,$hitChance));
        $dodge=max(0.0,min(.75,$dodgeChance));
        $crit=max(0.0,min(.60,$critChance));
        if($this->rand()>$hit)return 'miss';
        if($this->rand()<$dodge)return 'dodge';
        if($this->rand()<$crit)return 'crit';
        return 'hit';
    }

    /** Exact Java Damage.getRandomDamage behavior. */
    public function randomDamage(string $type,int $maxDmg,int $minDmg,int $weaponDmg=0): int
    {
        $low=max(0,min($minDmg,$maxDmg));$high=max($low,max($minDmg,$maxDmg));
        $damage=$low===$high?$low:random_int($low,$high);
        if($weaponDmg>0)$damage+=intdiv($weaponDmg,2);
        if($type==='crit')$damage=(int)round($damage*1.5);
        if(in_array($type,['dodge','miss','none'],true))$damage=0;
        return max(0,$damage);
    }

    public function playerHitChance(ClientSession $u): float
    { return (1.0-$this->math->rate('baseMiss',.1))+(float)($u->stats['$thi']??0.0); }

    public function playerDamageSchool(ClientSession $u,string $requested=''): string
    {
        $requested=strtolower(trim($requested));
        if(in_array($requested,['magic','m'],true))return 'magic';
        if(in_array($requested,['physical','p'],true))return 'physical';
        return str_starts_with(strtoupper((string)$u->classCategory),'C')?'magic':'physical';
    }

    /** Apply caster-side all/physical/magic outgoing coefficients and passive legacy fields. */
    public function playerOutgoing(int $damage,ClientSession $u,float $now=0.0,string $school=''): int
    {
        if($damage<=0)return $damage;
        $school=$this->playerDamageSchool($u,$school);
        $damage=$this->scale($damage,(float)($u->stats['$cao']??1.0));
        $damage=$this->scale($damage,(float)($u->stats[$school==='magic'?'$cmo':'$cpo']??1.0));
        return $this->legacyOutgoing($damage,$this->playerAuraSet($u),$now);
    }

    /** Apply target-side all/physical/magic incoming coefficients and passive legacy fields. */
    public function playerIncoming(int $damage,ClientSession $u,float $now=0.0,string $school='physical'): int
    {
        if($damage<=0)return $damage;
        $school=$this->playerDamageSchool($u,$school);
        $damage=$this->scale($damage,(float)($u->stats['$cai']??1.0));
        $damage=$this->scale($damage,(float)($u->stats[$school==='magic'?'$cmi':'$cpi']??1.0));
        return $this->legacyIncoming($damage,$this->playerAuraSet($u),$now);
    }

    /** Player healing coefficients used by negative-damage/heal skills. */
    public function playerHealingOutgoing(int $heal,ClientSession $u): int
    { return $this->scale($heal,(float)($u->stats['$cho']??1.0)); }
    public function playerHealingIncoming(int $heal,ClientSession $u): int
    { return $this->scale($heal,(float)($u->stats['$chi']??1.0)); }

    /** DoT coefficients.  The stored DoT magnitude already contains the cast's base damage. */
    public function playerDotIncoming(int $damage,ClientSession $u): int
    { return $this->scale($damage,(float)($u->stats['$cdi']??1.0)); }

    /** Monster outgoing coefficients are read directly from active aura effects. */
    public function monsterOutgoing(int $damage,array $auras,float $now=0.0,string $school='physical'): int
    {
        if($damage<=0)return $damage;$school=strtolower($school)==='magic'?'magic':'physical';
        $damage=$this->scale($damage,$this->monsterCoefficient($auras,'cao',$now));
        $damage=$this->scale($damage,$this->monsterCoefficient($auras,$school==='magic'?'cmo':'cpo',$now));
        return $this->legacyOutgoing($damage,$auras,$now);
    }

    /** Monster incoming coefficients are read directly from active aura effects. */
    public function monsterIncoming(int $damage,array $auras,float $now=0.0,string $school='physical'): int
    {
        if($damage<=0)return $damage;$school=strtolower($school)==='magic'?'magic':'physical';
        $damage=$this->scale($damage,$this->monsterCoefficient($auras,'cai',$now));
        $damage=$this->scale($damage,$this->monsterCoefficient($auras,$school==='magic'?'cmi':'cpi',$now));
        return $this->legacyIncoming($damage,$auras,$now);
    }

    public function monsterDotIncoming(int $damage,array $auras,float $now=0.0): int
    {
        if($damage<=0)return $damage;
        return $this->scale($damage,$this->monsterCoefficient($auras,'cdi',$now));
    }

    /**
     * Compatibility wrapper retained for old callers.  New action paths should
     * prefer playerOutgoing/playerIncoming or monsterOutgoing/monsterIncoming.
     */
    public function evaluateAuras(int $damage,array $auras,float $now=0.0): int
    {
        if($damage<=0)return $damage;
        return $this->legacyIncoming($this->legacyOutgoing($damage,$auras,$now),$auras,$now);
    }

    /** Java Damage.getReducedDamage() compatibility wrapper. */
    public function reduceByAuras(int $damage,array $auras,float $now=0.0): int
    { return $this->legacyIncoming($damage,$auras,$now); }

    /** Java Action.getEquipmentMetaTotal(). */
    public function equipmentMeta(ClientSession $u,string $wanted,float $min=-1.0,float $max=5.0): float
    {
        $total=0.0;
        try{
            $rows=$this->db->all('SELECT i.Meta FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ui.Equipped=1',[$u->dbId]);
            foreach($rows as $row)$total+=$this->metaValue((string)($row['Meta']??''),$wanted);
        }catch(\Throwable){}
        return max($min,min($max,$total));
    }

    public function weaponDps(ClientSession $u): int
    {
        try{return max(0,(int)$this->db->scalar("SELECT i.DPS FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ui.Equipped=1 AND i.Equipment='Weapon' ORDER BY ui.id DESC LIMIT 1",[$u->dbId],0));}catch(\Throwable){return 0;}
    }

    public function metaValue(string $meta,string $wanted): float
    {
        if($meta===''||!str_contains($meta,':'))return 0.0;$total=0.0;
        foreach(explode(',',$meta) as $part){$kv=array_map('trim',explode(':',$part,2));if(count($kv)!==2||strcasecmp($kv[0],$wanted)!==0||!is_numeric($kv[1]))continue;$v=(float)$kv[1];if(is_finite($v))$total+=$v;}
        return $total;
    }

    /** Normalize legacy admin data such as 50 => .50 while preserving decimal data. */
    public static function normalizedRateValue(float $value,string $type='+'): float
    {
        if(!is_finite($value))return $type==='*'?1.0:0.0;
        if($type==='*'){
            // Legacy rows such as "thi * 10" were intended as +10%, not x10.
            if(abs($value)>2.0)return 1.0+($value/100.0);
            return $value;
        }
        if(abs($value)>2.0)$value/=100.0;
        return $value;
    }

    /** Apply one aura effect to a decimal/rate value. */
    public static function applyRateEffect(float $current,string $type,float $value): float
    {
        $value=self::normalizedRateValue($value,$type);
        return match($type){
            '+'=>$current+$value,
            '-'=>$current-$value,
            '*'=>$current*$value,
            default=>$current,
        };
    }

    private function playerAuraSet(ClientSession $u): array
    {
        // Active timed auras and class passives both participate in the legacy
        // DamageIncrease/DamageTakenDecrease fields.  Array merge is intentional:
        // keys are irrelevant to legacy fields and duplicate aura IDs must stack
        // only when the runtime actually contains two distinct records.
        return array_merge(array_values($u->passiveAuras),array_values($u->auras));
    }

    private function monsterCoefficient(array $auras,string $wanted,float $now): float
    {
        $now=$now>0?$now:microtime(true);$value=1.0;
        foreach($auras as $auraId=>$a){
            if(!$this->activeAura($a,$now))continue;
            $id=(int)($a['id']??$auraId);
            foreach($this->world->auraEffectsByAura[$id]??[] as $effect){
                if(strtolower((string)($effect['Stat']??''))!==$wanted)continue;
                $value=self::applyRateEffect($value,(string)($effect['Type']??'+'),(float)($effect['Value']??0));
            }
        }
        return max(0.0,min(10.0,$value));
    }

    private function legacyOutgoing(int $damage,array $auras,float $now): int
    {
        if($damage<=0)return $damage;$now=$now>0?$now:microtime(true);
        foreach($auras as $a){
            if(!$this->activeAura($a,$now))continue;
            $inc=$this->legacyFraction((float)($a['DamageIncrease']??0.0));
            if($inc!=0.0)$damage=$this->scale($damage,max(0.0,1.0+$inc));
        }
        return max(0,$damage);
    }

    private function legacyIncoming(int $damage,array $auras,float $now): int
    {
        if($damage<=0)return $damage;$now=$now>0?$now:microtime(true);
        foreach($auras as $a){
            if(!$this->activeAura($a,$now))continue;
            $dec=$this->legacyFraction((float)($a['DamageTakenDecrease']??0.0));
            if($dec!=0.0)$damage=$this->scale($damage,max(0.0,1.0-$dec));
        }
        return max(0,$damage);
    }

    private function activeAura(mixed $a,float $now): bool
    {
        if(!is_array($a))return false;
        $expires=(float)($a['expiresAt']??0.0);
        return $expires<=0.0||$expires>$now;
    }

    private function legacyFraction(float $value): float
    { if(abs($value)>1.0)$value/=100.0;return max(-5.0,min(5.0,$value)); }

    private function scale(int $amount,float $coefficient): int
    {
        if($amount<=0)return $amount;
        if(!is_finite($coefficient))$coefficient=1.0;
        return max(0,(int)round($amount*max(0.0,$coefficient)));
    }

    private function rand(): float { return mt_rand()/mt_getrandmax(); }
}
