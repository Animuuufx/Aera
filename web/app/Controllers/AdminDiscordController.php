<?php
declare(strict_types=1);
namespace Aera\Controllers;
use Aera\Foundation\Auth;
use Aera\Foundation\Csrf;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\View;
use Throwable;
final class AdminDiscordController
{
    private function root(): string { return dirname(__DIR__, 3) . '/DiscordBot'; }
    private function envFile(): string { return $this->root() . '/.env'; }
    private function pidFile(): string { return $this->root() . '/discord-bot.pid'; }
    private function script(): string { return $this->root() . '/aera-discord-bot-control.ps1'; }
    public function index(Request $request): void
    {
        $admin=Auth::requireAdmin(); $config=$this->readEnv();
        View::render('admin.discord',['admin'=>$admin,'config'=>$config,'status'=>['ok'=>true,'running'=>false,'message'=>'Checking bot status…'],'health'=>['ok'=>false,'discordReady'=>false,'message'=>'Checking…'],'log'=>$this->tailLog(),'botRoot'=>$this->root(),'configured'=>!empty($config['DISCORD_TOKEN'])]);
    }
    public function save(Request $request): void
    {
        $admin=Auth::requireAdmin(); if((int)($admin['Access']??0)<60){Session::flash('error','Administrator access is required to configure the Discord bot.');Response::redirect('/admin/discord');}
        Csrf::verify($request); $old=$this->readEnv(); $fields=['DISCORD_TOKEN','DISCORD_CLIENT_ID','DISCORD_GUILD_ID','DB_HOST','DB_PORT','DB_NAME','DB_USER','DB_PASSWORD','BOT_STATUS_PORT']; $data=[];
        foreach($fields as $key){$value=trim((string)$request->input($key,''));if(in_array($key,['DISCORD_TOKEN','DB_PASSWORD'],true)&&$value==='')$value=(string)($old[$key]??'');$data[$key]=$this->cleanSubmittedValue($value);}
        if($data['DISCORD_TOKEN']===''||$data['DISCORD_CLIENT_ID']===''){Session::flash('error','Discord token and application/client ID are required.');Response::redirect('/admin/discord');}
        if($data['DB_HOST']==='')$data['DB_HOST']='127.0.0.1';if($data['DB_PORT']==='')$data['DB_PORT']='3306';if($data['DB_NAME']==='')$data['DB_NAME']='aera';if($data['BOT_STATUS_PORT']==='')$data['BOT_STATUS_PORT']='5592';
        if(!ctype_digit($data['BOT_STATUS_PORT'])||(int)$data['BOT_STATUS_PORT']<1024||(int)$data['BOT_STATUS_PORT']>65535){Session::flash('error','Bot health port must be between 1024 and 65535.');Response::redirect('/admin/discord');}
        $root=$this->root();if(!is_dir($root)||!is_file($root.'/package.json')){Session::flash('error','DiscordBot application files are missing.');Response::redirect('/admin/discord');}
        $content='';foreach($data as $key=>$value)$content.=$key.'='.$this->envQuote($value).PHP_EOL;
        if(file_put_contents($this->envFile(),$content,LOCK_EX)===false){Session::flash('error','Could not write DiscordBot/.env. Check IIS/PHP folder permissions.');Response::redirect('/admin/discord');}
        Session::flash('success','Discord bot settings saved securely outside the web root.');Response::redirect('/admin/discord');
    }
    private function cleanSubmittedValue(string $value): string
    {
        $value=trim($value);while(strlen($value)>=4&&str_starts_with($value,'\\"')&&str_ends_with($value,'\\"'))$value=substr($value,2,-2);if(strlen($value)>=2&&$value[0]==='"'&&substr($value,-1)==='"')$value=substr($value,1,-1);return str_replace(['\\"','\\\\'],['"','\\'],$value);
    }
    private function envQuote(string $value): string { return '"'.str_replace(['\\','"',"\r","\n"],['\\\\','\\"','',''],$value).'"'; }
    public function control(Request $request): void
    {
        $admin=Auth::requireAdmin();if((int)($admin['Access']??0)<60)Response::json(['ok'=>false,'message'=>'Administrator access is required.'],403);Csrf::verify($request);$action=strtolower(trim((string)$request->input('action','')));if(!in_array($action,['start','stop','restart','deploy'],true))Response::json(['ok'=>false,'message'=>'Unknown Discord bot action.'],422);
        // Never wait for PowerShell from an IIS request. Start/stop/restart can
        // launch a child process and return immediately; the browser observes
        // the real state through the lightweight /status endpoint.
        $result=$this->queueControl($action);Response::json($result,!empty($result['ok'])?202:500);
    }
    public function status(Request $request): void
    {
        Auth::requireAdmin();
        $health=$this->safeHealth();
        $running=!empty($health['ok']);
        $pid=null;
        $pidFile=$this->pidFile();
        if($running&&is_file($pidFile)){
            $raw=trim((string)@file_get_contents($pidFile));
            if(ctype_digit($raw))$pid=(int)$raw;
        }
        $process=['ok'=>true,'running'=>$running,'pid'=>$pid,'message'=>$running?'Discord bot process is running.':'Discord bot process is stopped.'];
        Response::json(['ok'=>true,'process'=>$process,'health'=>$health,'log'=>$this->tailLog()]);
    }
    private function queueControl(string $action): array
    {
        if(!is_file($this->script()))return ['ok'=>false,'running'=>false,'message'=>'Discord bot control script is missing.'];
        if(!function_exists('popen'))return ['ok'=>false,'running'=>false,'message'=>'PHP process control (popen) is disabled.'];
        $comSpec=(string)getenv('ComSpec');
        $powershell=$comSpec!==''?dirname($comSpec).'/WindowsPowerShell/v1.0/powershell.exe':'powershell.exe';
        if(!is_file($powershell)&&$powershell!=='powershell.exe')$powershell='powershell.exe';
        $script=$this->script();
        $command='start "" /B "'.$powershell.'" -NoProfile -ExecutionPolicy Bypass -File "'.$script.'" -Action '.$action;
        try{
            $pipe=@popen('cmd.exe /D /C '.$command,'r');
            if(!is_resource($pipe))return ['ok'=>false,'running'=>false,'message'=>'Could not queue the Discord bot controller.'];
            @pclose($pipe);
            return ['ok'=>true,'queued'=>true,'action'=>$action,'running'=>false,'message'=>'Discord bot '.$action.' request queued.'];
        }catch(Throwable $e){return ['ok'=>false,'running'=>false,'message'=>'Discord bot controller unavailable: '.$e->getMessage()];}
    }
    private function safeHealth(): array { try{return $this->health();}catch(Throwable $e){return ['ok'=>false,'discordReady'=>false,'message'=>'Health check unavailable.'];} }
    private function health(): array
    {
        $cfg=$this->readEnv();$port=(int)($cfg['BOT_STATUS_PORT']??5592);if($port<1||$port>65535||!function_exists('fsockopen'))return ['ok'=>false,'discordReady'=>false,'message'=>'Health endpoint offline.'];$fp=@fsockopen('127.0.0.1',$port,$errno,$errstr,0.20);if(!$fp)return ['ok'=>false,'discordReady'=>false,'message'=>'Health endpoint offline.'];stream_set_timeout($fp,0,500000);fwrite($fp,"GET /health HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n");$response=stream_get_contents($fp);fclose($fp);$parts=preg_split("/\r\n\r\n/",$response,2);$data=json_decode($parts[1]??'',true);return is_array($data)?$data+['ok'=>true]:['ok'=>false,'discordReady'=>false,'message'=>'Invalid health response.'];
    }
    private function readEnv(): array
    {
        $out=[];$file=$this->envFile();if(!is_file($file))return $out;foreach(file($file,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)?:[] as $line){$line=trim($line);if($line===''||$line[0]==='#'||!str_contains($line,'='))continue;[$k,$v]=explode('=',$line,2);$v=trim($v);if(strlen($v)>=2&&$v[0]==='"'&&substr($v,-1)==='"')$v=str_replace(['\\"','\\\\'],['"','\\'],substr($v,1,-1));$out[trim($k)]=$v;}return $out;
    }
    private function tailLog(): string
    {
        $files=[$this->root().'/discord-bot.log',$this->root().'/discord-bot-error.log'];$chunks=[];foreach($files as $file){if(!is_file($file))continue;$size=filesize($file);$start=max(0,(int)$size-12000);$fp=@fopen($file,'rb');if(!$fp)continue;fseek($fp,$start);$text=(string)stream_get_contents($fp);fclose($fp);if($text!=='')$chunks[]=basename($file).':'.PHP_EOL.$text;}return $chunks?implode(PHP_EOL.PHP_EOL,$chunks):'No Discord bot log has been created yet.';
    }
}
