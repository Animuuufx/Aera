<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\AdminLogger;
use Aera\Foundation\View;

final class AdminController
{
    public function dashboard(Request $request): void
    {
        $admin=Auth::requireAdmin();
        $counts=[]; foreach(['users','items','maps','monsters','quests','shops','skills','news_posts'] as $table){ try{$counts[$table]=(int)(Database::one("SELECT COUNT(*) c FROM `{$table}`")['c']??0);}catch(\Throwable $e){$counts[$table]=0;} }
        $server=Database::one('SELECT * FROM servers WHERE id=1');
        try{AdminLogger::ensureTable();$recent=Database::all('SELECT * FROM admin_logs WHERE IsBackground=0 ORDER BY id DESC LIMIT 12');}catch(\Throwable){$recent=[];}
        View::render('admin.dashboard',['admin'=>$admin,'counts'=>$counts,'server'=>$server,'recent'=>$recent]);
    }

    public function logs(Request $request): void
    {
        $admin=Auth::requireAdmin();
        AdminLogger::ensureTable();
        $q=trim((string)$request->input('q',''));
        $action=trim((string)$request->input('action',''));
        $showBackground=(string)$request->input('background','0')==='1';
        $page=max(1,(int)$request->input('page',1));$perPage=75;
        $where=[];$params=[];
        if(!$showBackground)$where[]='l.IsBackground=0';
        if($q!==''){$where[]='(LOWER(l.AdminName) LIKE LOWER(?) OR LOWER(l.Path) LIKE LOWER(?) OR LOWER(l.Action) LIKE LOWER(?) OR LOWER(COALESCE(l.Entity,\'\')) LIKE LOWER(?) OR LOWER(COALESCE(l.EntityID,\'\')) LIKE LOWER(?) OR LOWER(COALESCE(l.RequestData,\'\')) LIKE LOWER(?))';for($i=0;$i<6;$i++)$params[]='%'.$q.'%';}
        if($action!==''){$where[]='l.Action=?';$params[]=$action;}
        $sqlWhere=$where?' WHERE '.implode(' AND ',$where):'';
        $total=(int)Database::scalar('SELECT COUNT(*) FROM admin_logs l'.$sqlWhere,$params,0);
        $pages=max(1,(int)ceil($total/$perPage));$page=min($page,$pages);$offset=($page-1)*$perPage;
        $rows=Database::all('SELECT l.* FROM admin_logs l'.$sqlWhere.' ORDER BY l.id DESC LIMIT '.$perPage.' OFFSET '.$offset,$params);
        $actions=Database::all('SELECT Action,COUNT(*) Total FROM admin_logs GROUP BY Action ORDER BY Action ASC');
        View::render('admin.logs',[
            'admin'=>$admin,'rows'=>$rows,'actions'=>$actions,'q'=>$q,'action'=>$action,'showBackground'=>$showBackground,
            'page'=>$page,'pages'=>$pages,'total'=>$total,
        ]);
    }
}
