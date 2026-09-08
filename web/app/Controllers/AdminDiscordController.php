<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Csrf;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\View;

final class AdminDiscordController
{
    private function root(): string { return dirname(__DIR__,4).'/DiscordBot'; }
    private function envFile(): string { return $this->root().'/.env'; }
    private function script(): string { return $this->root().'/aera-discord-bot-control.ps1'; }

    public function index(Request $request): void
    {
        $admin=Auth::requireAdmin();$config=$this->readEnv();$status=$this->control('status');$health=$this->health();$log=$this->tailLog();
        View::render('admin.discord',['admin'=>$admin,'config'=>$config,'status'=>$status,'health'=>$health,'log'=>$log,'botRoot'=>$this->root(),'configured'=>!empty($config['DISCORD_TOKEN'])]);
    }

    public function save(Request $request): void
    {
        $admin=Auth::requireAdmin();if((int)($admin['Access']??0)<60){Session::flash('error','Administrator access is required to configure the Discord bot.');Response::redirect('/admin/discord');}
        Csrf::verify($request);$old=$this->readEnv();$fields=['DISCORD_TOKEN','DISCORD_CLIENT_ID','DISCORD_GUILD_ID','DB_HOST','DB_PORT','DB_NAME','DB_USER','DB_PASSWORD','BOT_STATUS_PORT'];$data=[];
        foreach($fields as $key){$value=(string)$request->input($key,'');if(in_array($key,['DISCORD_TOKEN','DB_PASSWORD'],true)&&trim($value)==='')$value=(string)($old[$key]??'');$data[$key]=trim($value);}
        if($data['DISCORD_TOKEN']===''||$data['DISCORD_CLIENT_ID']===''){Session::flash('error','Discord token and application/client ID are required.');Response::redirect('/admin/discord');}
        if($data['DB_HOST']==='')$data['DB_HOST']='127.0.0.1';if($data['DB_PORT']==='')$data['DB_PORT']='3306';if($data['DB_NAME']==='')$data['DB_NAME']='aera';if($data['BOT_STATUS_PORT']==='')$data['BOT_STATUS_PORT']='5592';
        if(!ctype_digit($data['BOT_STATUS_PORT'])||((int)$data['BOT_STATUS_PORT']<1024||(int)$data['BOT_STATUS_PORT']>65535)){Session::flash('error','Bot health port must be between 1024 and 65535.');Response::redirect('/admin/discord');}
        $root=$this->root();if(!is_dir($root)||!is_file($root.'/package.json')){Session::flash('error','DiscordBot application files are missing.');Response::redirect('/admin/discord');}
        $content='';foreach($data as $key=>$value)$content.=$key.'="'.$this->envEscape($value).'"'.PHP_EOL;
        if(file_put_contents($this->envFile(),$content,LOCK_EX)===false){Session::flash('error','Could not write DiscordBot/.env. Check IIS/PHP folder permissions.');Response::redirect('/admin/discord');}
        @chmod($this->envFile(),0600);Session::flash('success','Discord bot settings saved securely outside the web root.');Response::redirect('/admin/discord');
    }

    public function control(Request $request): void
    {
        $admin=Auth::requireAdmin();if((int)($admin['Access']??0)<60)Response::json(['ok'=>false,'message'=>'Administrator access is required.'],403);Csrf::verify($request);
        $action=strtolower(trim((string)$request->input('action','')));if(!in_array($action,['start','stop','restart','deploy'],true))Response::json(['ok'=>false,'message'=>'Unknown Discord bot action.'],422);
        $result=$this->runControl($action);Response::json($result,!empty($result['ok'])?200:500);
    }

    public function status(Request $request): void { Auth::requireAdmin();Response::json(['ok'=>true,'process'=>$this->runControl('status'),'health'=>$this->health()]); }

    private function runControl(string $action): array
    {
        if(!is_file($this->script()))return ['ok'=>false,'message'=>'Discord bot control script is missing.'];
        $powershell=getenv('ComSpec')?dirname((string)getenv('ComSpec')).'/WindowsPowerShell/v1.0/powershell.exe':'powershell.exe';
        $cmd='-NoProfile -ExecutionPolicy Bypass -File '.escapeshellarg($this->script()).' -Action '.escapeshellarg($action);$descriptor=[1=>['pipe','w'],2=>['pipe','w']];
        $proc=@proc_open($powershell.' '.$cmd,$descriptor,$pipes,$this->root());if(!is_resource($proc))return ['ok'=>false,'message'=>'Could not start the Discord bot controller.'];
        $stdout=stream_get_contents($pipes[1]);$stderr=stream_get_contents($pipes[2]);foreach($pipes as $pipe)fclose($pipe);$exit=proc_close($proc);$raw=trim((string)$stdout);$decoded=json_decode($raw,true);
        if(is_array($decoded))return $decoded+['exitCode'=>$exit];return ['ok'=>$exit===0,'message'=>$raw!==''?$raw:trim((string)$stderr),'exitCode'=>$exit];
    }

    private function health(): array
    {
        $cfg=$this->readEnv();$port=(int)($cfg['BOT_STATUS_PORT']??5592);$fp=@fsockopen('127.0.0.1',$port,$errno,$errstr,0.35);if(!$fp)return ['ok'=>false,'message'=>'Health endpoint offline.'];
        stream_set_timeout($fp,1);fwrite($fp,"GET /health HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n");$response=stream_get_contents($fp);fclose($fp);$parts=preg_split("/\r\n\r\n/",$response,2);$data=json_decode($parts[1]??'',true);return is_array($data)?$data+['ok'=>true]:['ok'=>false,'message'=>'Invalid health response.'];
    }

    private function readEnv(): array
    {
        $out=[];$file=$this->envFile();if(!is_file($file))return $out;
        foreach(file($file,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[] as $line){$line=trim($line);if($line===''||$line[0]==='#'||!str_contains($line,'='))continue;[$k,$v]=explode('=',$line,2);$v=trim($v);if(strlen($v)>=2&&$v[0]==='"'&&substr($v,-1)==='"')$v=str_replace(['\\"','\\\\'],['"','\\'],substr($v,1,-1));$out[trim($k)]=$v;}return $out;
    }
    private function envEscape(string $value): string { return str_replace(['\\','"','\r','\n'],['\\\\','\\"','',''],$value); }
    private function tailLog(): string
    {
        $file=$this->root().'/discord-bot.log';if(!is_file($file))return 'No Discord bot log has been created yet.';$size=filesize($file);$start=max(0,(int)$size-12000);$fp=fopen($file,'rb');if(!$fp)return '';fseek($fp,$start);$text=(string)stream_get_contents($fp);fclose($fp);return $start>0?'…'.PHP_EOL.$text:$text;
    }
}
