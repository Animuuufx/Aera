<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Config;
use Aera\Foundation\Csrf;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\Upload;
use Aera\Foundation\View;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use RuntimeException;

final class AdminFilesController
{
    private array $swfDirs=['client_root'=>'','class_m'=>'classes/M','class_f'=>'classes/F','swords'=>'items/swords','axes'=>'items/axes','bows'=>'items/bows','daggers'=>'items/daggers','guns'=>'items/guns','maces'=>'items/maces','polearms'=>'items/polearms','staff'=>'items/staff','staves'=>'items/staves','capes'=>'items/capes','helms'=>'items/helms','pets'=>'items/pets','houses'=>'items/houses','house_items'=>'items/house','maps'=>'maps','monsters'=>'mon','hairs_m'=>'hairs/M','hairs_f'=>'hairs/F','interface'=>'interface'];
    public function index(Request $request): void
    {
        $admin=Auth::requireAdmin();$public=(string)Config::get('paths.public');$images=[];$static=$public.'/static';if(is_dir($static)){foreach(new RecursiveIteratorIterator(new RecursiveDirectoryIterator($static,\FilesystemIterator::SKIP_DOTS)) as $f){if($f->isFile()&&preg_match('/\.(png|jpe?g|gif|webp|svg)$/i',$f->getFilename()))$images[]=str_replace('\\','/',substr($f->getPathname(),strlen($public)+1));}}
        sort($images);View::render('admin.files.index',['admin'=>$admin,'images'=>$images,'destinations'=>$this->swfDirs]);
    }
    public function image(Request $request): void { Auth::requireAdmin();Csrf::verify($request);try{$name=Upload::image($request->file('image')??[],(string)Config::get('paths.public').'/static/uploads');Session::flash('success','Uploaded static/uploads/'.$name);}catch(RuntimeException $e){Session::flash('error',$e->getMessage());}Response::redirect('/admin/files'); }
    public function swf(Request $request): void
    {
        Auth::requireAdmin();Csrf::verify($request);$dest=(string)$request->input('destination');if(!isset($this->swfDirs[$dest])){Session::flash('error','Invalid gamefile destination.');Response::redirect('/admin/files');}
        try{
            $relativeDir=$this->swfDirs[$dest];
            $base=(string)Config::get('paths.public').'/gamefiles';
            $dir=$relativeDir===''?$base:$base.'/'.$relativeDir;
            $name=Upload::swfCreateOnly($request->file('swf')??[],$dir);
            $displayPath='gamefiles/'.($relativeDir===''?'':$relativeDir.'/').$name;
            Session::flash('success','Added '.$displayPath.' (existing SWFs are never overwritten).');
        }catch(RuntimeException $e){Session::flash('error',$e->getMessage());}Response::redirect('/admin/files');
    }
}
