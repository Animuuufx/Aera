<?php
declare(strict_types=1);
namespace Aera\Services;

use Aera\Foundation\Database;
use PDO;
use RuntimeException;

final class StoreRewardService
{
    public static function ensureTables(): void
    {
        Database::run('CREATE TABLE IF NOT EXISTS store_product_rewards (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            ProductID INT UNSIGNED NOT NULL,
            RewardType ENUM("item","title") NOT NULL,
            RewardID INT UNSIGNED NOT NULL,
            Quantity INT UNSIGNED NOT NULL DEFAULT 1,
            CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY uq_store_reward (ProductID,RewardType,RewardID)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        Database::run('CREATE TABLE IF NOT EXISTS store_orders (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            ProductID INT UNSIGNED NOT NULL,
            UserID INT UNSIGNED NOT NULL,
            PaymentID VARCHAR(120) NOT NULL,
            Status VARCHAR(30) NOT NULL DEFAULT "captured",
            GrantedAt DATETIME NULL,
            CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY uq_store_payment (PaymentID),
            KEY idx_store_user (UserID,CreatedAt)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        Database::run('CREATE TABLE IF NOT EXISTS users_titles (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            UserID INT UNSIGNED NOT NULL,
            TitleID INT UNSIGNED NOT NULL,
            DatePurchased DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY uq_user_title (UserID,TitleID)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    }

    public static function options(): array
    {
        self::ensureTables();
        return [
            'items'=>Database::all('SELECT id,Name,Type,Equipment,Icon FROM items ORDER BY Name ASC LIMIT 10000'),
            'titles'=>Database::all('SELECT id,Name FROM titles ORDER BY Name ASC LIMIT 10000'),
        ];
    }

    public static function rewards(int $productId): array
    {
        self::ensureTables();
        return Database::all('SELECT * FROM store_product_rewards WHERE ProductID=? ORDER BY RewardType ASC,id ASC',[$productId]);
    }

    public static function saveRewards(int $productId, array $itemIds, array $itemQty, array $titleIds): void
    {
        self::ensureTables();
        $pdo=Database::connection();
        $pdo->beginTransaction();
        try {
            $pdo->prepare('DELETE FROM store_product_rewards WHERE ProductID=?')->execute([$productId]);
            $seen=[];
            foreach($itemIds as $i=>$rawId){
                $rid=(int)$rawId; if($rid<1||isset($seen['i'.$rid]))continue; $seen['i'.$rid]=true;
                $qty=max(1,min(9999,(int)($itemQty[$i]??1)));
                $pdo->prepare('INSERT INTO store_product_rewards (ProductID,RewardType,RewardID,Quantity) VALUES (?,"item",?,?)')->execute([$productId,$rid,$qty]);
            }
            foreach($titleIds as $rawId){
                $rid=(int)$rawId; if($rid<1||isset($seen['t'.$rid]))continue; $seen['t'.$rid]=true;
                $pdo->prepare('INSERT INTO store_product_rewards (ProductID,RewardType,RewardID,Quantity) VALUES (?,"title",?,1)')->execute([$productId,$rid]);
            }
            $pdo->commit();
        } catch(\Throwable $e){ if($pdo->inTransaction())$pdo->rollBack(); throw $e; }
    }

    public static function grant(int $userId,int $productId,string $paymentId): bool
    {
        if($userId<1||$productId<1||$paymentId==='')throw new RuntimeException('Invalid store reward request.');
        self::ensureTables();
        $existing=Database::one('SELECT id,Status FROM store_orders WHERE PaymentID=? LIMIT 1',[$paymentId]);
        if($existing){return (string)$existing['Status']==='granted';}
        $rewards=self::rewards($productId);
        if(!$rewards)throw new RuntimeException('This product has no configured rewards.');
        $pdo=Database::connection(); $pdo->beginTransaction();
        try{
            $pdo->prepare('INSERT INTO store_orders (ProductID,UserID,PaymentID,Status) VALUES (?,?,?,"captured")')->execute([$productId,$userId,$paymentId]);
            foreach($rewards as $r){
                $rid=(int)$r['RewardID']; $qty=max(1,(int)$r['Quantity']);
                if((string)$r['RewardType']==='item'){
                    $item=Database::one('SELECT id FROM items WHERE id=? LIMIT 1',[$rid]);
                    if(!$item)throw new RuntimeException('Store reward item #'.$rid.' no longer exists.');
                    $owned=Database::one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 LIMIT 1',[$userId,$rid]);
                    if($owned){$pdo->prepare('UPDATE users_items SET Quantity=Quantity+? WHERE id=?')->execute([$qty,(int)$owned['id']]);}
                    else{$pdo->prepare('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,DatePurchased) VALUES (?,?,1,0,?,0,NOW())')->execute([$userId,$rid,$qty]);}
                } else {
                    $title=Database::one('SELECT id FROM titles WHERE id=? LIMIT 1',[$rid]);
                    if(!$title)throw new RuntimeException('Store reward title #'.$rid.' no longer exists.');
                    $pdo->prepare('INSERT IGNORE INTO users_titles (UserID,TitleID) VALUES (?,?)')->execute([$userId,$rid]);
                }
            }
            $pdo->prepare('UPDATE store_orders SET Status="granted",GrantedAt=NOW() WHERE id=?')->execute([(int)$pdo->lastInsertId()]);
            $pdo->commit(); return true;
        }catch(\Throwable $e){if($pdo->inTransaction())$pdo->rollBack();throw $e;}
    }
}
