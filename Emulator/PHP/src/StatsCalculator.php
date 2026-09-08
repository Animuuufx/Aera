<?php
declare(strict_types=1);
namespace AeraEmu;

/**
 * Server-side port of aqworlds.world.users.Stats + Users.sendStats().
 * Obvious decompiler bug in the Java $END/$INT/$LCK/$STR/$WIS title getters is
 * intentionally corrected here: each getter uses its matching title stat.
 */
final class StatsCalculator
{
    private const CLASS_RATIOS=[
        'M1'=>[.27,.30,.22,.05,.10,.06],'M2'=>[.20,.22,.33,.05,.10,.10],
        'M3'=>[.24,.20,.20,.24,.07,.05],'M4'=>[.30,.18,.30,.02,.06,.14],
        'C1'=>[.06,.20,.11,.33,.15,.15],'C2'=>[.08,.27,.10,.30,.10,.15],
        'C3'=>[.06,.23,.05,.28,.28,.10],'S1'=>[.22,.18,.21,.08,.08,.23],
    ];
    private const KEYS=['STR','END','DEX','INT','WIS','LCK'];
    private const EQUIP_RATIO=['he'=>.25,'ar'=>.25,'ba'=>.20,'Weapon'=>.33];

    private WorldMath $math;
    public function __construct(private Database $db,private WorldRepository $world){$this->math=new WorldMath($world);}

    /** @return array{sta:array,tempSta:array,wDPS:int,mDPS:int,minDmg:int,maxDmg:int,hpMax:int,mpMax:int,classCat:string} */
    public function calculate(ClientSession $u): array
    {
        $class=$this->db->one("SELECT c.Category,ui.ItemID FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID INNER JOIN classes c ON c.ItemID=i.id WHERE ui.UserID=? AND ui.Bank=0 AND ui.Equipped=1 AND i.Equipment='ar' ORDER BY ui.id DESC LIMIT 1",[$u->dbId]);
        $cat=(string)($class['Category']??'M1');if(!isset(self::CLASS_RATIOS[$cat]))$cat='M1';
        $innateBudget=$this->math->innateBudget($u->level);$innate=[];
        foreach(self::KEYS as $i=>$key)$innate[$key]=(float)round(self::CLASS_RATIOS[$cat][$i]*$innateBudget);

        $gear=[];foreach(self::EQUIP_RATIO as $slot=>$ratio)$gear[$slot]=$this->emptyStats();
        $weaponItem=null;$weaponEnh=null;
        $rows=$this->db->all("SELECT i.*,ui.EnhID UserEnhID,ui.EnhItemID FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Bank=0 AND ui.Equipped=1 AND i.Equipment IN ('ar','he','ba','Weapon') ORDER BY ui.id",[$u->dbId]);
        foreach($rows as $row){$slot=(string)$row['Equipment'];if(!isset(self::EQUIP_RATIO[$slot]))continue;$storedEnhItemId=(int)($row['EnhItemID']??0);$storedEnhId=(int)($row['UserEnhID']??0);if($storedEnhId<=0)$storedEnhId=(int)($row['EnhID']??0);$enhResolution=$this->resolveEnhancement($storedEnhItemId>0?$storedEnhItemId:$storedEnhId,$slot);$enh=$enhResolution['definition'];$gear[$slot]=$this->itemStats($enh,$slot);if($slot==='Weapon'){$weaponItem=$row;$weaponEnh=$enh;}}

        $title=$this->emptyStats();$titleId=(int)($u->user['TitleID']??0);if($titleId>0){$t=$this->db->one('SELECT * FROM titles WHERE id=?',[$titleId]);if($t){$title=['STR'=>(float)$t['Strength'],'END'=>(float)$t['Endurance'],'DEX'=>(float)$t['Dexterity'],'INT'=>(float)$t['Intellect'],'WIS'=>(float)$t['Wisdom'],'LCK'=>(float)$t['Luck']];}}

        $allocated=$this->emptyStats();$us=$this->db->one('SELECT Strength,Intellect,Dexterity,Endurance,Wisdom,Luck FROM users_stats WHERE UserID=?',[$u->dbId]);if($us){$allocated=['STR'=>(float)$us['Strength'],'END'=>(float)$us['Endurance'],'DEX'=>(float)$us['Dexterity'],'INT'=>(float)$us['Intellect'],'WIS'=>(float)$us['Wisdom'],'LCK'=>(float)$us['Luck']];}

        $baseBlock=$this->math->rate('baseBlock',.7);$baseParry=$this->math->rate('baseParry',.03);$baseDodge=$this->math->rate('baseDodge',.04);$baseCrit=$this->math->rate('baseCrit',.05);$baseHit=$this->math->rate('baseHit',0);$baseHaste=$this->math->rate('baseHaste',0);
        $attackPower=0.0;$magicPower=0.0;$block=$baseBlock;$parry=$baseParry;$evasion=$baseDodge;$crit=$baseCrit;$hit=$baseHit;$haste=$baseHaste;$resist=0.0;
        $cai=1.0;$cao=1.0;$cpi=1.0;$cpo=1.0;$cmi=1.0;$cmo=1.0;$cdi=1.0;$cdo=1.0;$chi=1.0;$cho=1.0;$cmc=1.0;$sem=$this->math->rate('baseEventValue',.05);$sbm=$this->math->rate('baseBlockValue',.7);$scm=$this->math->rate('baseCritValue',1.5);$srm=$this->math->rate('baseResistValue',.7);
        $intAPtoDPS=max(1,$this->math->rate('intAPtoDPS',10));$intSPtoDPS=max(1,$this->math->rate('intSPtoDPS',10));$pcDpsMod=$this->math->rate('PCDPSMod',.85);
        $hpTgt=max(1,$this->math->baseHpByLevel($u->level));$tDps=($hpTgt/20)*.7;$bias=max(.000001,(2.25*$tDps)/(100/$intAPtoDPS)/2);
        foreach(self::KEYS as $key){$val=$innate[$key]+$gear['ar'][$key]+$gear['Weapon'][$key]+$gear['he'][$key]+$gear['ba'][$key]+$title[$key]+$allocated[$key];$ratio=($val/$bias)/100;
            switch($key){
                case 'STR': if($cat==='M1')$sbm-=($ratio*.3);$attackPower+=($cat==='S1'?round($val*1.4):$val*2);if(in_array($cat,['M1','M2','M3','M4','S1'],true))$crit+=($ratio*($cat==='M4'?.7:.4));break;
                case 'INT': $cmi-=$ratio;if(str_starts_with($cat,'C')||$cat==='M3')$cmo+=$ratio;$magicPower+=($cat==='S1'?round($val*1.4):$val*2);if(in_array($cat,['C1','C2','C3','M3','S1'],true))$haste+=($ratio*($cat==='C2'?.5:.3));break;
                case 'END': $hit+=($ratio*.1);break;
                case 'DEX': if(in_array($cat,['M1','M2','M3','M4','S1'],true)){if(!str_starts_with($cat,'C'))$hit+=($ratio*.2);$haste+=($ratio*(in_array($cat,['M2','M4'],true)?.5:.3));} $evasion+=($ratio*(in_array($cat,['M2','M3'],true)?.5:.3));break;
                case 'WIS': if(in_array($cat,['C1','C2','C3','S1'],true)){$crit+=($ratio*($cat==='C1'?.7:.4));$hit+=($ratio*.2);} $evasion+=($ratio*.3);break;
                case 'LCK': $sem+=($ratio*2);if($cat==='S1'){$attackPower+=round($val);$magicPower+=round($val);$crit+=($ratio*.3);$hit+=($ratio*.1);$haste+=($ratio*.3);$evasion+=($ratio*.25);$scm+=($ratio*2.5);}else{if(in_array($cat,['M1','M2','M3','M4'],true))$attackPower+=round($val*.7);if(in_array($cat,['C1','C2','C3','M3'],true))$magicPower+=round($val*.7);$crit+=($ratio*.2);$hit+=($ratio*.1);$haste+=($ratio*.1);$evasion+=($ratio*.1);$scm+=($ratio*5);}break;
            }
        }
        // Java Stats.applyAuraEffects(): active player auras can temporarily
        // alter haste/dodge/hit/crit/AP/MP and the server re-sends only changed
        // values when they are added/removed. Recalculate from the authoritative
        // active-aura set so reconnects and stacked durations remain consistent.
        $now=microtime(true);
        $activeAuraIds=[];
        foreach($u->passiveAuras as $auraId=>$active)if(is_array($active))$activeAuraIds[(int)$auraId]=true;
        foreach($u->auras as $auraId=>$active){
            if(!is_array($active)||(float)($active['expiresAt']??0)<=$now)continue;
            $activeAuraIds[(int)$auraId]=true;
        }
        foreach(array_keys($activeAuraIds) as $auraId){
            foreach($this->world->auraEffectsByAura[(int)$auraId]??[] as $ae){
                $stat=strtolower((string)($ae['Stat']??''));$type=(string)($ae['Type']??'+');$value=(float)($ae['Value']??0);
                $applyRate=static fn(float $cur):float=>CombatMath::applyRateEffect($cur,$type,$value);
                // AP/MP remain flat values.  Decimal combat/rate coefficients use the
                // same normalization as CombatMath so both legacy "50 = 50%" rows
                // and current ".50 = 50%" rows behave safely.
                $applyFlat=static function(float $cur)use($type,$value):float{return $type==='+'?$cur+$value:($type==='-'?$cur-$value:($type==='*'?$cur*$value:$cur));};
                switch($stat){
                    case 'tha':$haste=$applyRate($haste);break;
                    case 'tdo':$evasion=$applyRate($evasion);break;
                    case 'thi':$hit=$applyRate($hit);break;
                    case 'tcr':$crit=$applyRate($crit);break;
                    case 'tre':$resist=$applyRate($resist);break;
                    case 'cai':$cai=$applyRate($cai);break;
                    case 'cao':$cao=$applyRate($cao);break;
                    case 'cpi':$cpi=$applyRate($cpi);break;
                    case 'cpo':$cpo=$applyRate($cpo);break;
                    case 'cmi':$cmi=$applyRate($cmi);break;
                    case 'cmo':$cmo=$applyRate($cmo);break;
                    case 'cdi':$cdi=$applyRate($cdi);break;
                    case 'cdo':$cdo=$applyRate($cdo);break;
                    case 'chi':$chi=$applyRate($chi);break;
                    case 'cho':$cho=$applyRate($cho);break;
                    case 'cmc':$cmc=$applyRate($cmc);break;
                    case 'ap':$attackPower=$applyFlat($attackPower);break;
                    case 'mp':$magicPower=$applyFlat($magicPower);break;
                }
            }
        }

        // Match the client's coefficient safety floors.  An aura can strongly
        // mitigate damage, but a bad database row must never make damage negative.
        $cai=max(.20,$cai);$cpi=max(.20,$cpi);$cmi=max(.20,$cmi);
        $cao=max(.10,$cao);$cpo=max(.10,$cpo);$cmo=max(.10,$cmo);
        $cdi=max(.10,$cdi);$cdo=max(.10,$cdo);$chi=max(.10,$chi);$cho=max(.10,$cho);$cmc=max(.10,$cmc);

        $wLevel=(int)($weaponEnh['Level']??1);$iDps=(float)($weaponEnh['DPS']??100);if($iDps==0)$iDps=100;$iDps/=100;
        $baseWeaponDps=round((($this->math->baseHpByLevel($wLevel)/20)*$iDps)*$pcDpsMod);
        $mDPS=(int)($baseWeaponDps+round($magicPower/$intSPtoDPS));$wDPS=(int)($baseWeaponDps+round($attackPower/$intAPtoDPS));
        $dps=in_array($cat,['M1','M2','M3','M4'],true)?$wDPS:$mDPS;$range=(float)($weaponItem['Range']??50)/100;$wdmg=$dps*2;$min=(int)floor($wdmg-($wdmg*$range));$max=(int)ceil($wdmg+($wdmg*$range));

        $external=[];foreach(self::KEYS as $key)$external[$key]=(int)($gear['Weapon'][$key]+$gear['ar'][$key]+$gear['he'][$key]+$gear['ba'][$key]+$title[$key]+$allocated[$key]);
        $sta=[
            '$STR'=>$external['STR'],'$END'=>$external['END'],'$DEX'=>$external['DEX'],'$INT'=>$external['INT'],'$WIS'=>$external['WIS'],'$LCK'=>$external['LCK'],
            '$ap'=>$attackPower,'$mp'=>$magicPower,'$cai'=>$cai,'$cao'=>$cao,'$cdi'=>$cdi,'$cdo'=>$cdo,'$chi'=>$chi,'$cho'=>$cho,'$cmc'=>$cmc,'$cmi'=>$cmi,'$cmo'=>$cmo,'$cpi'=>$cpi,'$cpo'=>$cpo,
            '$sbm'=>$sbm,'$scm'=>$scm,'$sem'=>$sem,'$shb'=>0.0,'$smb'=>0.0,'$srm'=>$srm,'$sp'=>$magicPower,'$tbl'=>$block,'$tcr'=>$crit,'$tdo'=>$evasion,'$tha'=>$haste,'$thi'=>$hit,'$tpa'=>$parry,'$tre'=>$resist,
            '_ap'=>0.0,'_sp'=>0.0,'_tbl'=>0.0,'_tpa'=>0.0,'_tdo'=>0.0,'_tcr'=>0.0,'_thi'=>0.0,'_tha'=>0.0,'_tre'=>0.0,
            '_cpo'=>1.0,'_cpi'=>1.0,'_cao'=>1.0,'_cai'=>1.0,'_cmo'=>1.0,'_cmi'=>1.0,'_cdo'=>1.0,'_cdi'=>1.0,'_cho'=>1.0,'_chi'=>1.0,'_cmc'=>1.0,
            '_sbm'=>$this->math->rate('baseBlockValue',.7),'_scm'=>$this->math->rate('baseCritValue',1.5),'_sem'=>$this->math->rate('baseEventValue',.05),'_shb'=>0.0,'_smb'=>0.0,'_srm'=>$this->math->rate('baseResistValue',.7),
            '_STR'=>$innate['STR'],'_END'=>$innate['END'],'_DEX'=>$innate['DEX'],'_INT'=>$innate['INT'],'_WIS'=>$innate['WIS'],'_LCK'=>$innate['LCK'],
        ];
        $temp=['innate'=>$innate];foreach(['ba','ar','Weapon','he'] as $slot){$s=array_filter($gear[$slot],fn($v)=>$v>0);if($s)$temp[$slot]=array_map('intval',$s);}$allocatedNonZero=array_filter($allocated,fn($v)=>$v>0);if($allocatedNonZero)$temp['StatPoints']=array_map('intval',$allocatedNonZero);
        $hpMax=$this->math->healthByLevel($u->level)+(int)(($external['END']+$innate['END'])*$this->math->rate('intHPperEND',5));
        $mpMax=$this->math->manaByLevel($u->level)+(int)(($external['WIS']+$innate['WIS'])*$this->math->rate('intMPperWIS',5));
        return ['sta'=>$sta,'tempSta'=>$temp,'wDPS'=>max(1,$wDPS),'mDPS'=>max(1,$mDPS),'minDmg'=>max(1,$min),'maxDmg'=>max(1,$max),'hpMax'=>max(1,$hpMax),'mpMax'=>max(1,$mpMax),'classCat'=>$cat];
    }

    private function enhancementPatternIdFromName(string $name): int
    {
        $map=['lucky'=>9,'pneuma'=>27,'anima'=>28,'penitence'=>29,'lament'=>30,'hearty'=>32,'vainglory'=>24,'vim'=>25,'examen'=>26,'forge'=>10,'absolution'=>11,'avarice'=>12,'depths'=>23,'spellbreaker'=>8,'healer'=>7,'wizard'=>6,'hybrid'=>5,'armsman'=>4,'thief'=>3,'fighter'=>2,'adventurer'=>1];
        foreach($map as $needle=>$id)if(str_contains($name,$needle))return $id;
        return 1;
    }

    /** Resolve an equipment enhancement stored either as an item id or definition id. */
    private function resolveEnhancement(int $storedId,string $targetEquipment=''): array
    {
        if($storedId<=0)return ['definition'=>null,'itemId'=>0];
        $enhItem=$this->db->one("SELECT * FROM items WHERE id=? AND LOWER(Type)='enhancement' LIMIT 1",[$storedId]);
        $definition=null;
        $equipment=trim((string)($enhItem['Equipment']??$targetEquipment));
        $name=strtolower((string)($enhItem['Name']??''));

        // An enhancement item can have a stale legacy EnhID. Its own Level and
        // family are authoritative, otherwise e.g. "Weapon Enhancement 100"
        // can accidentally resolve to definition #1 (level 1).
        if($enhItem){
            $patternId=$this->enhancementPatternIdFromName($name);
            $level=max(1,min(100,(int)($enhItem['Level']??1)));
            $definition=$this->db->one('SELECT * FROM enhancements WHERE PatternID=? AND Level=? ORDER BY id LIMIT 1',[$patternId,$level]);
            if(!$definition){
                $candidateId=(int)($enhItem['EnhID']??0);
                if($candidateId>0){
                    $candidate=$this->world->enhancements[$candidateId]??$this->db->one('SELECT * FROM enhancements WHERE id=?',[$candidateId]);
                    if($candidate){
                        // Preserve the candidate's pattern family but force the
                        // catalog item's authoritative level. Never return a
                        // stale level-1 definition just because the old EnhID
                        // points at one.
                        $candidatePattern=(int)($candidate['PatternID']??$patternId);
                        $definition=$this->db->one('SELECT * FROM enhancements WHERE PatternID=? AND Level=? ORDER BY id LIMIT 1',[$candidatePattern,$level]);
                        if(!$definition){
                            $definition=[
                                'id'=>$candidateId,
                                'Name'=>(string)($candidate['Name']??'Enhancement'),
                                'PatternID'=>$candidatePattern,
                                'Rarity'=>max(1,(int)($candidate['Rarity']??($enhItem['Rarity']??1))),
                                'DPS'=>(int)($enhItem['DPS']??($candidate['DPS']??0)),
                                'Level'=>$level,
                            ];
                        }
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
            if($equipment!==''&&strcasecmp($equipment,'None')!==0){$sql.=" ORDER BY (Equipment=? ) DESC, id ASC LIMIT 1";$params[]=$equipment;}
            else{$sql.=' ORDER BY id ASC LIMIT 1';}
            $enhItem=$this->db->one($sql,$params);
        }
        return ['definition'=>$definition,'itemId'=>$enhItem?(int)$enhItem['id']:0];
    }

    private function emptyStats(): array { return ['STR'=>0.0,'END'=>0.0,'DEX'=>0.0,'INT'=>0.0,'WIS'=>0.0,'LCK'=>0.0]; }
    private function itemStats(?array $enh,string $slot): array
    {
        // World.getItemStats() uses this exact LinkedHashMap insertion order.
        // The order matters when a fractional enhancement budget has remainder
        // points because Java distributes those points in key iteration order.
        $out=['END'=>0.0,'STR'=>0.0,'INT'=>0.0,'DEX'=>0.0,'WIS'=>0.0,'LCK'=>0.0];if(!$enh)return $out;$pattern=$this->db->one('SELECT * FROM enhancements_patterns WHERE id=?',[(int)$enh['PatternID']]);if(!$pattern)return $out;
        $budget=(int)round($this->math->itemBudget((int)$enh['Level'],(int)$enh['Rarity'])*(self::EQUIP_RATIO[$slot]??0));
        $pct=['END'=>(int)$pattern['Endurance'],'STR'=>(int)$pattern['Strength'],'INT'=>(int)$pattern['Intelligence'],'DEX'=>(int)$pattern['Dexterity'],'WIS'=>(int)$pattern['Wisdom'],'LCK'=>(int)$pattern['Luck']];
        $total=0;foreach($pct as $key=>$v){$out[$key]=($budget*$v)/100;$total+=$out[$key];}
        $keys=array_keys($out);$i=0;while($total<$budget){$out[$keys[$i]]+=1;$total+=1;$i=($i+1)%count($keys);}return $out;
    }
}
