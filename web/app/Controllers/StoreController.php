<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Csrf;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\View;
use Aera\Services\StoreRewardService;
use Throwable;

final class StoreController
{
    private function ensureTable(): void
    {
        Database::run('CREATE TABLE IF NOT EXISTS store_products (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            Title VARCHAR(150) NOT NULL,
            Description TEXT NULL,
            Category VARCHAR(80) NULL,
            Price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            Currency VARCHAR(10) NOT NULL DEFAULT "USD",
            ImageURL VARCHAR(1000) NULL,
            PurchaseURL VARCHAR(1000) NULL,
            SortOrder INT NOT NULL DEFAULT 0,
            Active TINYINT(1) NOT NULL DEFAULT 1,
            CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            UpdatedAt DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (id), KEY idx_store_active (Active, SortOrder, id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        StoreRewardService::ensureTables();
    }

    public function index(Request $request): void
    {
        $this->ensureTable();
        $products=Database::all('SELECT * FROM store_products WHERE Active=1 ORDER BY SortOrder ASC,id DESC');
        View::render('store',['products'=>$products]);
    }

    public function admin(Request $request): void
    {
        $admin=Auth::requireAdmin(); $this->ensureTable();
        $products=Database::all('SELECT * FROM store_products ORDER BY SortOrder ASC,id DESC');
        View::render('admin.store.index',['admin'=>$admin,'products'=>$products]);
    }

    public function form(Request $request): void
    {
        $admin=Auth::requireAdmin(); $this->ensureTable();
        $id=(int)$request->input('id',0);
        $product=$id?Database::one('SELECT * FROM store_products WHERE id=?',[$id]):[];
        if($id&&!$product) Response::abort(404,'Store product not found.');
        $rewardData=StoreRewardService::options();
        $rewards=$id?StoreRewardService::rewards($id):[];
        View::render('admin.store.form',['admin'=>$admin,'product'=>$product,'mode'=>$id?'edit':'create','items'=>$rewardData['items'],'titles'=>$rewardData['titles'],'rewards'=>$rewards]);
    }

    public function create(Request $request): void { $this->save($request,null); }
    public function edit(Request $request,string $id): void { $this->save($request,(int)$id); }

    private function save(Request $request,?int $id): void
    {
        Auth::requireAdmin(); Csrf::verify($request); $this->ensureTable();
        $title=trim((string)$request->input('Title'));
        if($title===''){Session::flash('error','A store product title is required.'); Response::redirect($id?'/admin/store/form?id='.$id:'/admin/store/form');}
        $description=trim((string)$request->input('Description',''));
        $category=trim((string)$request->input('Category',''));
        $price=max(0,(float)$request->input('Price',0));
        $currency=strtoupper(trim((string)$request->input('Currency','USD')));
        $image=trim((string)$request->input('ImageURL',''));
        $purchase=trim((string)$request->input('PurchaseURL',''));
        $sort=(int)$request->input('SortOrder',0);
        $active=(int)(bool)$request->input('Active',0);
        try {
            $pdo=Database::connection(); $pdo->beginTransaction();
            if($id)$pdo->prepare('UPDATE store_products SET Title=?,Description=?,Category=?,Price=?,Currency=?,ImageURL=?,PurchaseURL=?,SortOrder=?,Active=?,UpdatedAt=NOW() WHERE id=?')->execute([$title,$description,$category,$price,$currency,$image?:null,$purchase?:null,$sort,$active,$id]);
            else{$pdo->prepare('INSERT INTO store_products (Title,Description,Category,Price,Currency,ImageURL,PurchaseURL,SortOrder,Active) VALUES (?,?,?,?,?,?,?,?,?)')->execute([$title,$description,$category,$price,$currency,$image?:null,$purchase?:null,$sort,$active]);$id=(int)$pdo->lastInsertId();}
            $pdo->commit();
            StoreRewardService::saveRewards((int)$id,(array)$request->input('ItemIDs',[]),(array)$request->input('ItemQty',[]),(array)$request->input('TitleIDs',[]));
            Session::flash('success','Store product and rewards saved.');
        } catch(Throwable $e) { if(Database::connection()->inTransaction())Database::connection()->rollBack(); Session::flash('error','Unable to save store product: '.$e->getMessage()); }
        Response::redirect('/admin/store');
    }

    public function delete(Request $request,string $id): void
    {
        Auth::requireAdmin(); Csrf::verify($request); $this->ensureTable();
        Database::run('DELETE FROM store_product_rewards WHERE ProductID=?',[(int)$id]);
        Database::run('DELETE FROM store_products WHERE id=?',[(int)$id]);
        Session::flash('success','Store product deleted.'); Response::redirect('/admin/store');
    }

    /** Call this only after PayPal has verified and captured the order. */
    public function grantAfterCapture(int $userId,int $productId,string $paypalOrderId): bool
    {
        $this->ensureTable();
        return StoreRewardService::grant($userId,$productId,$paypalOrderId);
    }
}
