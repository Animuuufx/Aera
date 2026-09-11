<?php
declare(strict_types=1);
namespace Aera\Controllers;
use Aera\Foundation\{Auth,Csrf,Database,Request,Response,Session,View};
use RuntimeException;
use Throwable;

final class RiftController
{
    public static function ready(): bool
    { return (bool)Database::scalar("SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='rift_events'"); }
    public function index(Request $request): void
    {
        $user=Auth::user();$ready=self::ready();
        View::render('rifts',['ready'=>$ready,'user'=>$user,
            'wallet'=>$ready&&$user?Database::one('SELECT * FROM users_rifts WHERE UserID=?',[(int)$user['id']]):null,
            'items'=>$ready?Database::all('SELECT s.*,i.Name,i.Type FROM rift_shop s JOIN items i ON i.id=s.ItemID WHERE s.Enabled=1 AND s.Cost>0 ORDER BY s.Cost,s.id'):[],
            'history'=>$ready?Database::all('SELECT id,Map,Tier,Modifier,Status,StartedAt,State FROM rift_events ORDER BY id DESC LIMIT 30'):[],
            'rewards'=>$ready&&$user?Database::all('SELECT r.*,e.Map FROM rift_rewards r JOIN rift_events e ON e.id=r.EventID WHERE r.UserID=? ORDER BY r.EventID DESC LIMIT 20',[(int)$user['id']]):[]]);
    }
    public function buy(Request $request): void
    {
        $user=Auth::requireUser();Csrf::verify($request);$pdo=Database::connection();
        try{
            $token=(string)$request->input('token','');if(!preg_match('/^[a-f0-9]{64}$/D',$token))throw new RuntimeException('Invalid purchase token.');
            $pdo->beginTransaction();
            $u=Database::one('SELECT SlotsBag,CurrentServer,Access FROM users WHERE id=? FOR UPDATE',[(int)$user['id']]);
            if(!$u||(int)$u['Access']<1)throw new RuntimeException('Account is unavailable.');
            if(strcasecmp((string)$u['CurrentServer'],'Offline')!==0)throw new RuntimeException('Log out of the game before purchasing a Rift item.');
            if(Database::one('SELECT Token FROM rift_purchases WHERE Token=?',[$token]))throw new RuntimeException('This purchase was already processed.');
            $s=Database::one('SELECT s.*,i.Stack,i.EnhID,i.Equipment FROM rift_shop s JOIN items i ON i.id=s.ItemID WHERE s.id=? AND s.Enabled=1 FOR UPDATE',[(int)$request->input('shop',0)]);
            if(!$s||(int)$s['Cost']<1||(int)$s['Quantity']<1||(int)$s['Quantity']>max(1,(int)$s['Stack']))throw new RuntimeException('This shop reward is not available.');
            if(in_array((string)$s['Equipment'],['ho','hi'],true))throw new RuntimeException('House items are not supported in the Rift shop.');
            $wallet=Database::one('SELECT Shards FROM users_rifts WHERE UserID=? FOR UPDATE',[(int)$user['id']]);
            if((int)($wallet['Shards']??0)<(int)$s['Cost'])throw new RuntimeException('Not enough Rift Shards.');
            $owned=Database::one('SELECT id,Quantity FROM users_items WHERE UserID=? AND ItemID=? AND Bank=0 FOR UPDATE',[(int)$user['id'],(int)$s['ItemID']]);
            if($owned){
                if((int)$owned['Quantity']+(int)$s['Quantity']>max(1,(int)$s['Stack']))throw new RuntimeException('You already own the maximum quantity.');
                Database::run('UPDATE users_items SET Quantity=Quantity+? WHERE id=?',[(int)$s['Quantity'],(int)$owned['id']]);
            }else{
                $count=(int)Database::scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND Bank=0',[(int)$user['id']]);
                if($count>=(int)$u['SlotsBag'])throw new RuntimeException('Your inventory is full.');
                Database::run('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped,Quantity,Bank,Wear,DatePurchased) VALUES (?,?,?,0,?,0,0,NOW())',[(int)$user['id'],(int)$s['ItemID'],(int)$s['EnhID'],(int)$s['Quantity']]);
            }
            Database::run('UPDATE users_rifts SET Shards=Shards-? WHERE UserID=?',[(int)$s['Cost'],(int)$user['id']]);
            Database::run('INSERT INTO rift_purchases (Token,UserID,ShopID,Cost) VALUES (?,?,?,?)',[$token,(int)$user['id'],(int)$s['id'],(int)$s['Cost']]);
            $pdo->commit();Session::flash('success','Rift reward added to your inventory.');
        }catch(Throwable $e){if($pdo->inTransaction())$pdo->rollBack();Session::flash('error',$e instanceof RuntimeException&&!($e instanceof \PDOException)?$e->getMessage():'Purchase failed. No shards were spent.');}
        Response::redirect('/rifts');
    }
}
