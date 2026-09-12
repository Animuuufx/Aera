<?php
declare(strict_types=1);
require dirname(__DIR__).'/src/Autoload.php';
use AeraEmu\ExpeditionRun;
$checks=0;
function check(bool $value,string $message): void { global $checks;$checks++;if(!$value)throw new RuntimeException($message); }
function rejects(callable $fn,string $message): void { try{$fn();}catch(RuntimeException){check(true,$message);return;}check(false,$message); }
$r=new ExpeditionRun(1,'solo','seed','2026-W37',1);$r->members=[1=>'Tester'];
rejects(fn()=>new ExpeditionRun(1,'fake','s','w',1),'Invalid mode');
rejects(fn()=>$r->choose(1,'bloodlust'),'Cannot choose in lobby');
for($room=1;$room<=10;$room++){
    $r->next();check($r->phase==='combat'&&$r->depth===$room,'Advance one room');
    rejects(fn()=>$r->next(),'No skipping combat');rejects(fn()=>$r->vote(1),'No premature continue');
    $r->clear();$bank=$r->bank;$r->clear();check($r->bank===$bank,'Duplicate clear does not mint rewards');
    check(count(array_unique($r->offers[1]))===3,'Three distinct choices');
    rejects(fn()=>$r->choose(2,'bloodlust'),'No outsider choice');
    rejects(fn()=>$r->choose(1,'forged'),'No forged choice');
    $chosen=$r->offers[1][0];$r->choose(1,$chosen);
    rejects(fn()=>$r->choose(1,$chosen),'No replayed choice');
    check($r->phase==='decision','All choices done');$r->vote(1);
}
check($r->finiteComplete()&&$r->bank===180,'Ten-room completion and bank');
check($r->payout('cashed_out')===180&&$r->payout('defeated')===90,'Cash-out and loss payout');
$a=new ExpeditionRun(2,'weekly','weekly:1:2026-W37','2026-W37',1);$a->members=[1=>'A'];
$b=new ExpeditionRun(3,'weekly','weekly:1:2026-W37','2026-W37',2);$b->members=[2=>'B'];
for($i=0;$i<30;$i++){
    $a->next();$b->next();check($a->modifier===$b->modifier&&$a->kind===$b->kind&&$a->roll('room:'.$a->depth,8)===$b->roll('room:'.$b->depth,8),'Weekly encounters deterministic');
    $a->clear();$b->clear();check($a->offers[1]===$b->offers[2],'Weekly offers deterministic');
    $a->choose(1,$a->offers[1][0]);$b->choose(2,$b->offers[2][2]);$a->vote(1);$b->vote(2);
}
check(!$a->finiteComplete(),'Weekly continues beyond room 10');
$party=new ExpeditionRun(4,'party','party','2026-W37',1,4);$party->members=[1=>'A',2=>'B'];$party->next();$party->clear();
$party->choose(1,$party->offers[1][0]);check($party->phase==='blessing','Wait for every player choice');
$party->choose(2,$party->offers[2][0]);$party->vote(1);$party->vote(1);
rejects(fn()=>$party->next(),'Duplicate vote cannot replace other member');rejects(fn()=>$party->vote(3),'Outsider vote rejected');
$party->vote(2);$party->next();check($party->depth===2,'Unanimous party advance');
$r->modifier='Calm';$r->blessings=[1=>['bloodlust'=>1,'ward'=>1,'executioner'=>1]];
check($r->outgoing(1,100,100,100)===108,'Bloodlust effect');check($r->outgoing(1,100,20,100)===123,'Executioner threshold');
check($r->incoming(1,100)===94&&$r->incoming(2,100)===100,'Ward isolated by member');
$r->modifier='Glass Cannon';check($r->outgoing(1,100,100,100)===162,'Glass Cannon multiplier');
$r->blessings[1]['ward']=100;check($r->incoming(1,100)===40,'Reduction bounded');check($r->outgoing(1,0,100,100)===0,'Miss remains miss');
check(ExpeditionRun::week(strtotime('2027-01-01 UTC'))==='2026-W53','UTC ISO year boundary');
echo "Expedition rules: $checks checks passed.\n";
