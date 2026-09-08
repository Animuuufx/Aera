<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Csrf;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\Upload;
use Aera\Foundation\View;
use RuntimeException;
use Throwable;

final class AdminNewsController
{
    public function index(Request $request): void { $admin=Auth::requireAdmin();$posts=Database::all('SELECT n.*,u.Name AuthorName FROM news_posts n LEFT JOIN users u ON u.id=n.AuthorID ORDER BY n.Pinned DESC,n.PublishedAt DESC');View::render('admin.news.index',['admin'=>$admin,'posts'=>$posts]); }
    public function createForm(Request $request): void { $admin=Auth::requireAdmin();View::render('admin.news.form',['admin'=>$admin,'post'=>[],'mode'=>'create']); }
    public function editForm(Request $request,string $id): void { $admin=Auth::requireAdmin();$post=Database::one('SELECT * FROM news_posts WHERE id=?',[(int)$id]);if(!$post)Response::abort(404);View::render('admin.news.form',['admin'=>$admin,'post'=>$post,'mode'=>'edit']); }
    public function create(Request $request): void { $this->save($request,null); }
    public function edit(Request $request,string $id): void { $this->save($request,(int)$id); }
    private function save(Request $request,?int $id): void
    {
        $admin=Auth::requireAdmin();Csrf::verify($request);$title=trim((string)$request->input('Title'));$slug=$this->slug((string)$request->input('Slug',$title));$body=trim((string)$request->input('Body'));if($title===''||$body===''){Session::flash('error','Title and body are required.');Response::redirect($id?'/admin/news/'.$id.'/edit':'/admin/news/new');}
        $image=(string)$request->input('Image','');$file=$request->file('image_upload');if($file&&($file['error']??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_NO_FILE){try{$name=Upload::image($file,(string)\Aera\Foundation\Config::get('paths.public').'/static/uploads');$image='static/uploads/'.$name;}catch(RuntimeException $e){Session::flash('error',$e->getMessage());Response::redirect($id?'/admin/news/'.$id.'/edit':'/admin/news/new');}}
        $vals=[$title,$slug,trim((string)$request->input('Excerpt','')),$body,$image!==''?$image:null,(int)(bool)$request->input('Published',0),(int)(bool)$request->input('Pinned',0),(int)$admin['id']];
        try{if($id){Database::run('UPDATE news_posts SET Title=?,Slug=?,Excerpt=?,Body=?,Image=?,Published=?,Pinned=?,AuthorID=?,UpdatedAt=NOW() WHERE id=?',array_merge($vals,[$id]));}else{Database::run('INSERT INTO news_posts (Title,Slug,Excerpt,Body,Image,Published,Pinned,AuthorID,PublishedAt) VALUES (?,?,?,?,?,?,?,?,NOW())',$vals);}Session::flash('success','News post saved.');}
        catch(Throwable $e){Session::flash('error','Unable to save post: '.$e->getMessage());}Response::redirect('/admin/news');
    }
    public function delete(Request $request,string $id): void { Auth::requireAdmin();Csrf::verify($request);Database::run('DELETE FROM news_posts WHERE id=?',[(int)$id]);Session::flash('success','News post deleted.');Response::redirect('/admin/news'); }
    private function slug(string $v): string { $v=strtolower(trim($v));$v=preg_replace('/[^a-z0-9]+/','-',$v);return trim((string)$v,'-')?:('post-'.time()); }
}
