<?php
declare(strict_types=1);
namespace AeraEmu;

use RuntimeException;

/** In-game shard purchases share the website's wallet and replay ledger. */
final class RiftShop
{
    public function __construct(private Database $db) {}
    public function buy(ClientSession $u,int $listingId,string $token): void
    {
        if(!$u->authenticated||$u->access<1)throw new RuntimeException('Please log in again.');
        if($u->tradeTarget!==null)throw new RuntimeException('Finish your trade before purchasing.');
        if($u->state===2)throw new RuntimeException('Leave combat before purchasing.');
        if($u->riftShopToken===''||!hash_equals($u->riftShopToken,$token))throw new RuntimeException('Refresh the Rift shop before purchasing.');
        $this->db->tx(function(Database $db)use($u,$listingId,$token){
            $account=$db->one('SELECT Access,SlotsBag FROM users WHERE id=? FOR UPDATE',[$u->dbId]);
            if(!$account||(int)$account['Access']<1)throw new RuntimeException('Your account is unavailable.');
            if($db->one('SELECT Token FROM rift_purchases WHERE Token=?',[$token]))throw new RuntimeException('This purchase was already completed.');
            $s=$db->one('SELECT s.*,i.Name,i.Stack,i.EnhID,i.Equipment,i.Staff,i.Upgrade,i.Level,i.FactionID,i.ReqReputation FROM rift_shop s JOIN items i ON i.id=s.ItemID WHERE s.id=? AND s.Enabled=1 FOR UPDATE',[$listingId]);
            if(!$s||(int)$s['Cost']<1||(int)$s['Quantity']<1||(int)$s['Quantity']>max(1,(int)$s['Stack']))throw new RuntimeException('This reward is unavailable.');
            if(in_array($s['Equipment'],['ho','hi'],true))throw new RuntimeException('House items are unavailable in this shop.');
            if((int)$s['Staff']===1&&$u->access<40)throw new RuntimeException('This reward is restricted to staff.');
            if((int)$s['Upgrade']===1&&(int)($u->user['UpgradeDays']??0)<=0)throw new RuntimeException('Membership is required for this reward.');
            if((int)$s['Level']>$u->level)throw new RuntimeException('Your level is too low for this reward.');
            if((int)$s['FactionID']>1&&(int)$db->scalar('SELECT Reputation FROM users_factions WHERE UserID=? AND FactionID=?',[$u->dbId,(int)$s['FactionID']],-1)<(int)$s['ReqReputation'])throw new RuntimeException('Reputation requirement not met.');
            $wallet=$db->one('SELECT Shards FROM users_rifts WHERE UserID=? FOR UPDATE',[$u->dbId]);
            if((int)($wallet['Shards']??0)<(int)$s['Cost'])throw new RuntimeException('Not enough Rift Shards.');
            $owned=$db->one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 FOR UPDATE',[$u->dbId,(int)$s['ItemID']]);
            if($owned){
                if((int)$owned['Quantity']+(int)$s['Quantity']>max(1,(int)$s['Stack']))throw new RuntimeException('You already own the maximum quantity.');
                $db->run('UPDATE users_items SET Quantity=Quantity+? WHERE id=?',[(int)$s['Quantity'],(int)$owned['id']]);
            }else{
                if((int)$db->scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND Bank=0',[$u->dbId])>=(int)$account['SlotsBag'])throw new RuntimeException('Your inventory is full.');
                $db->run('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,0,?,0,0,NOW())',[$u->dbId,(int)$s['ItemID'],(int)$s['EnhID'],(int)$s['Quantity']]);
            }
            $db->run('UPDATE users_rifts SET Shards=Shards-? WHERE UserID=?',[(int)$s['Cost'],$u->dbId]);
            $db->run('INSERT INTO rift_purchases (Token,UserID,ShopID,Cost) VALUES (?,?,?,?)',[$token,$u->dbId,$listingId,(int)$s['Cost']]);
        });
        $u->riftShopToken='';
    }
}
