<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Config;
use Aera\Foundation\Csrf;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\View;
use RuntimeException;
use Throwable;

final class DownloadController
{
    private function ensureTable(): void
    {
        Database::run('CREATE TABLE IF NOT EXISTS downloads (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            Title VARCHAR(150) NOT NULL,
            Description TEXT NULL,
            Version VARCHAR(50) NULL,
            FilePath VARCHAR(500) NULL,
            ExternalURL VARCHAR(1000) NULL,
            FileSize BIGINT UNSIGNED NULL,
            Active TINYINT(1) NOT NULL DEFAULT 1,
            SortOrder INT NOT NULL DEFAULT 0,
            CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            UpdatedAt DATETIME NULL DEFAULT NULL,
            PRIMARY KEY (id),
            KEY idx_downloads_active (Active, SortOrder, id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    }

    public function index(Request $request): void
    {
        $this->ensureTable();
        $downloads=Database::all('SELECT * FROM downloads WHERE Active=1 ORDER BY SortOrder ASC,id DESC');
        View::render('downloads',['downloads'=>$downloads]);
    }

    public function admin(Request $request): void
    {
        $admin=Auth::requireAdmin(); $this->ensureTable();
        $downloads=Database::all('SELECT * FROM downloads ORDER BY SortOrder ASC,id DESC');
        View::render('admin.downloads.index',['admin'=>$admin,'downloads'=>$downloads]);
    }

    public function create(Request $request): void { $this->save($request,null); }
    public function edit(Request $request,string $id): void { $this->save($request,(int)$id); }

    public function form(Request $request): void
    {
        $admin=Auth::requireAdmin(); $this->ensureTable(); $id=(int)$request->input('id',0); $download=$id?Database::one('SELECT * FROM downloads WHERE id=?',[$id]):[];
        if($id&&!$download) Response::abort(404,'Download not found.');
        View::render('admin.downloads.form',['admin'=>$admin,'download'=>$download,'mode'=>$id?'edit':'create']);
    }

    private function save(Request $request,?int $id): void
    {
        $admin=Auth::requireAdmin(); Csrf::verify($request); $this->ensureTable();
        $title=trim((string)$request->input('Title')); $description=trim((string)$request->input('Description','')); $version=trim((string)$request->input('Version',''));
        $url=trim((string)$request->input('ExternalURL','')); $sort=(int)$request->input('SortOrder',0); $active=(int)(bool)$request->input('Active',0); $path=$id?(string)(Database::one('SELECT FilePath FROM downloads WHERE id=?',[$id])['FilePath']??''):''; $size=$id?(int)(Database::one('SELECT FileSize FROM downloads WHERE id=?',[$id])['FileSize']??0):0;
        if($title===''){Session::flash('error','A download title is required.');Response::redirect($id?'/admin/downloads/form?id='.$id:'/admin/downloads/form');}
        $file=$request->file('download_file');
        if($file&&($file['error']??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_NO_FILE){
            try{
                $error=(int)$file['error']; if($error!==UPLOAD_ERR_OK) throw new RuntimeException('ZIP upload failed. Check PHP upload_max_filesize/post_max_size.');
                if(($file['size']??0)>1024*1024*1024) throw new RuntimeException('ZIP must be 1 GB or smaller.');
                $name=basename(str_replace('\\','/',(string)$file['name'])); $name=preg_replace('/[^A-Za-z0-9._-]+/','_',$name)?:'download.zip';
                if(strtolower(pathinfo($name,PATHINFO_EXTENSION))!=='zip') throw new RuntimeException('Only .zip files are accepted.');
                $dir=rtrim((string)Config::get('paths.public'),'/\\').'/downloads'; if(!is_dir($dir)&&!mkdir($dir,0775,true)&&!is_dir($dir)) throw new RuntimeException('Download directory is not writable.');
                $target=$dir.'/'.$name; if(file_exists($target)) $target=$dir.'/'.pathinfo($name,PATHINFO_FILENAME).'-'.date('YmdHis').'.zip';
                if(!is_uploaded_file((string)$file['tmp_name'])||!move_uploaded_file((string)$file['tmp_name'],$target)) throw new RuntimeException('Could not save ZIP.');
                $path='downloads/'.basename($target); $size=(int)filesize($target); $url='';
            }catch(RuntimeException $e){Session::flash('error',$e->getMessage());Response::redirect($id?'/admin/downloads/form?id='.$id:'/admin/downloads/form');}
        }
        if($path===''&&$url===''){Session::flash('warning','No ZIP or external URL was supplied; the download entry was not given a download target.');}
        try{
            if($id) Database::run('UPDATE downloads SET Title=?,Description=?,Version=?,FilePath=?,ExternalURL=?,FileSize=?,Active=?,SortOrder=?,UpdatedAt=NOW() WHERE id=?',[$title,$description,$version,$path?:null,$url?:null,$size?:null,$active,$sort,$id]);
            else Database::run('INSERT INTO downloads (Title,Description,Version,FilePath,ExternalURL,FileSize,Active,SortOrder) VALUES (?,?,?,?,?,?,?,?)',[$title,$description,$version,$path?:null,$url?:null,$size?:null,$active,$sort]);
            Session::flash('success','Download entry saved.');
        }catch(Throwable $e){Session::flash('error','Unable to save download: '.$e->getMessage());}
        Response::redirect('/admin/downloads');
    }

    public function delete(Request $request,string $id): void
    {
        Auth::requireAdmin(); Csrf::verify($request); $this->ensureTable(); $row=Database::one('SELECT FilePath FROM downloads WHERE id=?',[(int)$id]);
        if($row&&$row['FilePath']) @unlink(rtrim((string)Config::get('paths.public'),'/\\').'/'.ltrim((string)$row['FilePath'],'/\\'));
        Database::run('DELETE FROM downloads WHERE id=?',[(int)$id]); Session::flash('success','Download entry deleted.'); Response::redirect('/admin/downloads');
    }
}
