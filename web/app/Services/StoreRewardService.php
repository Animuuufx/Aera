<?php
declare(strict_types=1);
namespace Aera\Services;

use Aera\Foundation\Database;
use RuntimeException;

final class StoreRewardService
{
    public static function ensureTables(): void
    {
        Database::run('CREATE TABLE IF NOT EXISTS store_product_rewards (id INT UNSIGNED NOT NULL AUTO_INCREMENT,ProductID INT UNSIGNED NOT NULL,RewardType ENUM("item","title") NOT NULL,RewardID INT UNSIGNED NOT NULL,Quantity INT UNSIGNED NOT NULL DEFAULT 1,CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (id),UNIQUE KEY uq_store_reward (ProductID,RewardType,RewardID)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        Database::run('CREATE TABLE IF NOT EXISTS store_orders (id INT UNSIGNED NOT NULL AUTO_INCREMENT,ProductID INT UNSIGNED NOT NULL,UserID INT UNSIGNED NOT NULL,PaymentID VARCHAR(120) NOT NULL,Status VARCHAR(30) NOT NULL DEFAULT "pending",GrantedAt DATETIME NULL,CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (id),UNIQUE KEY uq_store_payment (PaymentID),KEY idx_store_user (UserID,CreatedAt)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        Database::run('CREATE TABLE IF NOT EXISTS users_titles (id INT UNSIGNED NOT NULL AUTO_INCREMENT,UserID INT UNSIGNED NOT NULL,TitleID INT UNSIGNED NOT NULL,DatePurchased DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (id),UNIQUE KEY uq_user_title (UserID,TitleID)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    }
    public static function options(): array { self::ensureTables(); return ['items'=>Database::all('SELECT id,Name,Type,Equipment,Icon FROM items ORDER BY Name ASC LIMIT 10000'),'titles'=>Database::all('SELECT id,Name FROM titles ORDER BY Name ASC LIMIT 10000')]; }
    public static function rewards(int $productId): array { self::ensureTables(); return Database::all('SELECT * FROM store_product_rewards WHERE ProductID=? ORDER BY RewardType ASC,id ASC',[$productId]); }
    public static function saveRewards(int $productId,array $itemIds,array $itemQty,array $titleIds): void
    {
        self::ensureTables();$pdo=Database::connection();$pdo->beginTransaction();
        try{$pdo->prepare('DELETE FROM store_product_rewards WHERE ProductID=?')->execute([$productId]);$seen=[];
            foreach($itemIds as $i=>$raw){$rid=(int)$raw;if($rid<1||isset($seen['i'.$rid]))continue;$seen['i'.$rid]=1;$q=max(1,min(9999,(int)($itemQty[$i]??1)));$pdo->prepare('INSERT INTO store_product_rewards (ProductID,RewardType,RewardID,Quantity) VALUES (?,"item",?,?)')->execute([$productId,$rid,$q]);}
            foreach($titleIds as $raw){$rid=(int)$raw;if($rid<1||isset($seen['t'.$rid]))continue;$seen['t'.$rid]=1;$pdo->prepare('INSERT INTO store_product_rewards (ProductID,RewardType,RewardID,Quantity) VALUES (?,"title",?,1)')->execute([$productId,$rid]);}
            $pdo->commit();
        }catch(\Throwable $e){if($pdo->inTransaction())$pdo->rollBack();throw $e;}
    }
    public static function rewardsOwnedByUser(int $userId,int $productId): bool
    {
        self::ensureTables();
        $x=Database::one('SELECT r.id FROM store_product_rewards r LEFT JOIN users_items ui ON r.RewardType="item" AND ui.UserID=? AND ui.ItemID=r.RewardID AND ui.Bank=0 LEFT JOIN users_titles ut ON r.RewardType="title" AND ut.UserID=? AND ut.TitleID=r.RewardID WHERE r.ProductID=? AND ((r.RewardType="item" AND ui.id IS NOT NULL) OR (r.RewardType="title" AND ut.id IS NOT NULL)) LIMIT 1',[$userId,$userId,$productId]);
        return (bool)$x;
    }
    public static function assertPurchasable(int $userId,int $productId): void
    {
        if($userId<1||$productId<1)throw new RuntimeException('Invalid store purchase.');
        if(self::rewardsOwnedByUser($userId,$productId))throw new RuntimeException('You already own a reward from this store product.');
    }
    public static function ownedProductIds(int $userId,array $productIds): array
    {
        self::ensureTables();$ids=array_values(array_unique(array_filter(array_map('intval',$productIds),fn($v)=>$v>0)));if(!$ids||$userId<1)return [];
        $ph=implode(',',array_fill(0,count($ids),'?'));
        $params=array_merge([$userId,$userId],$ids);
        $rows=Database::all('SELECT DISTINCT r.ProductID FROM store_product_rewards r LEFT JOIN users_items ui ON r.RewardType="item" AND ui.UserID=? AND ui.ItemID=r.RewardID AND ui.Bank=0 LEFT JOIN users_titles ut ON r.RewardType="title" AND ut.UserID=? AND ut.TitleID=r.RewardID WHERE r.ProductID IN ('.$ph.') AND ((r.RewardType="item" AND ui.id IS NOT NULL) OR (r.RewardType="title" AND ut.id IS NOT NULL))', $params);
        return array_map('intval',array_column($rows,'ProductID'));
    }
    public static function recordPending(int $userId,int $productId,string $paypalOrderId): void
    {
        self::ensureTables();if($userId<1||$productId<1||$paypalOrderId==='')throw new RuntimeException('Invalid PayPal order.');self::assertPurchasable($userId,$productId);
        $x=Database::one('SELECT UserID,ProductID,Status FROM store_orders WHERE PaymentID=? LIMIT 1',[$paypalOrderId]);
        if($x){if((int)$x['UserID']!==$userId||(int)$x['ProductID']!==$productId)throw new RuntimeException('PayPal order/account mismatch.');return;}
        Database::run('INSERT INTO store_orders (ProductID,UserID,PaymentID,Status) VALUES (?,?,?,"pending")',[$productId,$userId,$paypalOrderId]);
    }
    public static function grant(int $userId,int $productId,string $paymentId): bool
    {
        self::ensureTables();$x=Database::one('SELECT * FROM store_orders WHERE PaymentID=? LIMIT 1',[$paymentId]);
        if($x){if((int)$x['UserID']!==$userId||(int)$x['ProductID']!==$productId)throw new RuntimeException('Payment/account mismatch.');if((string)$x['Status']==='granted')return true;}
        else Database::run('INSERT INTO store_orders (ProductID,UserID,PaymentID,Status) VALUES (?,?,?,"captured")',[$productId,$userId,$paymentId]);
        $rewards=self::rewards($productId);if(!$rewards)throw new RuntimeException('This product has no configured rewards.');
        $pdo=Database::connection();$pdo->beginTransaction();
        try{
            foreach($rewards as $r){$rid=(int)$r['RewardID'];$qty=max(1,(int)$r['Quantity']);
                if($r['RewardType']==='item'){$item=Database::one('SELECT id FROM items WHERE id=? LIMIT 1',[$rid]);if(!$item)throw new RuntimeException('Store reward item #'.$rid.' no longer exists.');$owned=Database::one('SELECT id FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1',[$userId,$rid]);if($owned)$pdo->prepare('UPDATE users_items SET Quantity=Quantity+? WHERE id=?')->execute([$qty,(int)$owned['id']]);else $pdo->prepare('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,DatePurchased) VALUES (?,?,1,0,?,0,NOW())')->execute([$userId,$rid,$qty]);}
                else{if(!Database::one('SELECT id FROM titles WHERE id=? LIMIT 1',[$rid]))throw new RuntimeException('Store reward title #'.$rid.' no longer exists.');$pdo->prepare('INSERT IGNORE INTO users_titles (UserID,TitleID) VALUES (?,?)')->execute([$userId,$rid]);}
            }
            $pdo->prepare('UPDATE store_orders SET Status="granted",GrantedAt=NOW() WHERE PaymentID=?')->execute([$paymentId]);$pdo->commit();return true;
        }catch(\Throwable $e){if($pdo->inTransaction())$pdo->rollBack();throw $e;}
    }
}
