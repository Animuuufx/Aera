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
use ParseError;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use FilesystemIterator;
use Throwable;

final class AdminEmulatorController
{
    public function index(Request $request): void
    {
        $admin = Auth::requireAdmin();
        $server = Database::one('SELECT * FROM servers WHERE id=1');
        $status = $this->controlStatus();
        $snapshot = $this->logSnapshot();
        $pending = Database::all('SELECT * FROM admin_commands ORDER BY id DESC LIMIT 12');
        $runtime = $this->rpcRequest('snapshot', [], 1.2);
        $runtimeData = !empty($runtime['ok']) && is_array($runtime['data'] ?? null) ? $runtime['data'] : [];
        $configuredPort = $this->configuredGamePort();

        View::render('admin.emulator.index', [
            'admin' => $admin,
            'server' => $server,
            'runtimeStatus' => $status,
            'runtimePath' => $this->runtimeRoot(),
            'log' => $snapshot['log'],
            'commands' => $pending,
            'runtimeData' => $runtimeData,
            'configuredPort' => $configuredPort,
            'eventCursor' => (int)($runtimeData['eventCursor'] ?? 0),
            'editorFiles' => $this->editableFiles(),
        ]);
    }


    /** Dedicated player-management page with live emulator state. */
    public function players(Request $request): void
    {
        $admin=Auth::requireAdmin();
        $q=trim((string)$request->input('q',''));$page=max(1,(int)$request->input('page',1));$perPage=40;$offset=($page-1)*$perPage;
        $where='';$params=[];
        if($q!==''){$where=' WHERE LOWER(u.Name) LIKE LOWER(?) OR LOWER(u.Email) LIKE LOWER(?) OR CAST(u.id AS CHAR)=?';$params=['%'.$q.'%','%'.$q.'%',$q];}
        $total=(int)Database::scalar('SELECT COUNT(*) FROM users u'.$where,$params,0);$pages=max(1,(int)ceil($total/$perPage));$page=min($page,$pages);$offset=($page-1)*$perPage;
        $rows=Database::all(
            "SELECT u.id,u.Name,u.Email,u.Level,u.Access,u.Gold,u.Coins,u.CurrentServer,u.LastArea,u.LastLogin,".
            "(SELECT l.Details FROM users_logs l WHERE l.UserID=u.id AND l.Violation='Panel Ban' ORDER BY l.id DESC LIMIT 1) BanReason ".
            'FROM users u'.$where.' ORDER BY u.id ASC LIMIT '.$perPage.' OFFSET '.$offset,$params
        );
        $rpc=$this->rpcRequest('snapshot',[],1.2);$online=[];
        if(!empty($rpc['ok'])&&is_array($rpc['data']['players']??null))foreach($rpc['data']['players'] as $player)$online[(int)($player['id']??0)]=$player;
        foreach($rows as &$row){
            $row['_online']=$online[(int)$row['id']]??null;
            // AdminDataController uses a base64url JSON primary-key token for edit links.
            $row['_edit_key']=rtrim(strtr(base64_encode(json_encode(['id'=>(int)$row['id']],JSON_UNESCAPED_SLASHES)),'+/','-_'),'=');
        }unset($row);
        View::render('admin.players',[
            'admin'=>$admin,'players'=>$rows,'q'=>$q,'page'=>$page,'pages'=>$pages,'total'=>$total,
            'emulatorOnline'=>!empty($rpc['ok']),'runtimeMessage'=>(string)($rpc['message']??''),
        ]);
    }

    /** Player actions: message, kick, ban/unban and give item. */
    public function playerAction(Request $request): void
    {
        $admin=Auth::requireAdmin();Csrf::verify($request);
        $action=strtolower(trim((string)$request->input('action','')));$userId=(int)$request->input('user_id',0);$q=trim((string)$request->input('return_q',''));
        $target=$userId>0?Database::one('SELECT id,Name,Access FROM users WHERE id=? LIMIT 1',[$userId]):null;
        if(!$target){Session::flash('error','Player could not be found.');Response::redirect('/admin/players');}
        $adminAccess=(int)($admin['Access']??0);$targetAccess=(int)$target['Access'];$name=(string)$target['Name'];
        $back='/admin/players'.($q!==''?'?q='.urlencode($q):'');

        if($action==='message'){
            $message=trim((string)$request->input('message',''));if($message===''){Session::flash('error','Enter a message.');Response::redirect($back);}
            $result=$this->rpcRequest('message-player',['userId'=>$userId,'name'=>$name,'message'=>substr($message,0,500)],2.0);
            if(!empty($result['ok'])){$this->auditPlayer($admin,$request,'message',$target,['message'=>$message]);Session::flash('success',(string)$result['message']);}
            else Session::flash('error',(string)($result['message']?:'Player must be online to receive a message.'));
            Response::redirect($back);
        }

        if($action==='kick'){
            $reason=trim((string)$request->input('reason',''));if($reason===''){Session::flash('error','Enter a kick reason.');Response::redirect($back);}
            if($userId===(int)$admin['id']){Session::flash('error','You cannot kick your own panel account.');Response::redirect($back);}
            if($adminAccess<60&&$targetAccess>=40){Session::flash('error','Moderators cannot kick staff accounts.');Response::redirect($back);}
            $result=$this->rpcRequest('kick',['userId'=>$userId,'name'=>$name,'reason'=>substr($reason,0,250)],2.0);
            if(!empty($result['ok'])){try{Database::run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$userId,'Panel Kick',$reason]);}catch(Throwable){}$this->auditPlayer($admin,$request,'kick',$target,['reason'=>$reason]);Session::flash('success',(string)$result['message'].' Reason: '.$reason);}
            else Session::flash('error',(string)($result['message']?:'Player is not online.'));
            Response::redirect($back);
        }

        if($action==='ban'){
            if($adminAccess<60){Session::flash('error','Administrator access is required to ban accounts.');Response::redirect($back);}
            $reason=trim((string)$request->input('reason',''));if($reason===''){Session::flash('error','Enter a ban reason.');Response::redirect($back);}
            if($userId===(int)$admin['id']){Session::flash('error','You cannot ban your own panel account.');Response::redirect($back);}
            if($targetAccess>=40){Session::flash('error','Staff accounts cannot be banned from this panel action.');Response::redirect($back);}
            if($targetAccess<1){Session::flash('warning',$name.' is already banned.');Response::redirect($back);}
            Database::run("UPDATE users SET Access=0,CurrentServer='Offline' WHERE id=?",[$userId]);
            try{Database::run('DELETE FROM game_sessions WHERE UserID=?',[$userId]);}catch(Throwable){}
            try{Database::run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$userId,'Panel Ban',$reason]);}catch(Throwable){}
            $result=$this->rpcRequest('ban-player',['userId'=>$userId,'name'=>$name,'reason'=>substr($reason,0,500)],2.0);
            $this->auditPlayer($admin,$request,'ban',$target,['reason'=>$reason]);
            Session::flash(!empty($result['ok'])?'success':'warning',$name.' was banned. Reason: '.$reason.(!empty($result['ok'])?' Active session disconnected.':' Emulator control is offline; the database ban is still active.'));
            Response::redirect($back);
        }

        if($action==='unban'){
            if($adminAccess<60){Session::flash('error','Administrator access is required to unban accounts.');Response::redirect($back);}
            if($targetAccess>0){Session::flash('warning',$name.' is not banned.');Response::redirect($back);}
            Database::run('UPDATE users SET Access=1 WHERE id=?',[$userId]);
            try{Database::run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$userId,'Panel Unban','Unbanned by '.$admin['Name']]);}catch(Throwable){}
            $this->auditPlayer($admin,$request,'unban',$target,null);Session::flash('success',$name.' was unbanned.');Response::redirect($back);
        }

        if($action==='mute'){
            $minutes=max(1,min(1440,(int)$request->input('minutes',5)));$reason=trim((string)$request->input('reason',''));
            if($targetAccess>=40&&$targetAccess>=$adminAccess){Session::flash('error','You cannot mute staff of an equal or higher rank.');Response::redirect($back);}
            $result=$this->rpcRequest('mute-player',['userId'=>$userId,'minutes'=>$minutes,'reason'=>substr($reason,0,250)],2.0);
            if(!empty($result['ok'])){$this->auditPlayer($admin,$request,'mute',$target,['minutes'=>$minutes,'reason'=>$reason]);Session::flash('success',(string)$result['message']);}else Session::flash('error',(string)($result['message']?:'Player must be online.'));
            Response::redirect($back);
        }

        if($action==='unmute'){
            if($targetAccess>=40&&$targetAccess>=$adminAccess){Session::flash('error','You cannot unmute staff of an equal or higher rank.');Response::redirect($back);}
            $result=$this->rpcRequest('unmute-player',['userId'=>$userId],2.0);
            if(!empty($result['ok'])){$this->auditPlayer($admin,$request,'unmute',$target,null);Session::flash('success',(string)$result['message']);}else Session::flash('error',(string)($result['message']?:'Player must be online.'));
            Response::redirect($back);
        }

        if($action==='promote'||$action==='demote'){
            if($adminAccess<60){Session::flash('error','Administrator access is required to change staff ranks.');Response::redirect($back);}
            if($userId===(int)$admin['id']){Session::flash('error','You cannot change your own staff rank.');Response::redirect($back);}
            if($targetAccess>=$adminAccess){Session::flash('error','You cannot change a player with an equal or higher rank.');Response::redirect($back);}
            $newAccess=$this->rankAccess((string)$request->input('rank',''));
            if($newAccess===null){Session::flash('error','Choose a valid rank.');Response::redirect($back);}
            if($newAccess>$adminAccess){Session::flash('error','You cannot assign a rank higher than your own.');Response::redirect($back);}
            if($action==='promote'&&$newAccess<=$targetAccess){Session::flash('error','Promote must assign a higher rank.');Response::redirect($back);}
            if($action==='demote'&&$newAccess>=$targetAccess){Session::flash('error','Demote must assign a lower rank.');Response::redirect($back);}
            $result=$this->rpcRequest('set-access',['userId'=>$userId,'access'=>$newAccess,'source'=>'web player management '.$action.' by '.$admin['Name']],2.2);
            if(empty($result['ok'])){
                // Preserve the database change if the emulator is offline; it will apply on next login.
                Database::run('UPDATE users SET Access=? WHERE id=?',[$newAccess,$userId]);
                $this->auditPlayer($admin,$request,$action,$target,['old_access'=>$targetAccess,'new_access'=>$newAccess,'rank'=>$this->rankName($newAccess),'live'=>false]);
                Session::flash('warning',$name.' is now '.$this->rankName($newAccess).'. Emulator is offline, so the live client could not refresh.');
            }else{
                $this->auditPlayer($admin,$request,$action,$target,['old_access'=>$targetAccess,'new_access'=>$newAccess,'rank'=>$this->rankName($newAccess),'live'=>true]);Session::flash('success',(string)$result['message']);
            }
            Response::redirect($back);
        }

        if($action==='give-item'){
            $itemId=(int)$request->input('item_id',0);$quantity=max(1,min(999999,(int)$request->input('quantity',1)));
            $item=$itemId>0?Database::one('SELECT id,Name,Temporary,Stack FROM items WHERE id=? LIMIT 1',[$itemId]):null;
            if(!$item){Session::flash('error','Unknown item ID.');Response::redirect($back);}
            $result=$this->rpcRequest('give-item',['userId'=>$userId,'itemId'=>$itemId,'quantity'=>$quantity],2.2);
            if(!empty($result['ok'])){$this->auditPlayer($admin,$request,'give_item',$target,['item_id'=>$itemId,'item'=>$item['Name'],'quantity'=>$quantity]);Session::flash('success',(string)$result['message'].' Recipient: '.$name.'.');}
            else Session::flash('error',(string)($result['message']?:'Could not give the item. Make sure the emulator is running.'));
            Response::redirect($back);
        }

        Session::flash('error','Unknown player action.');Response::redirect($back);
    }

    /** Live player actions from the emulator Players tab. */
    public function livePlayerAction(Request $request): void
    {
        $admin=Auth::requireAdmin();
        Csrf::verify($request);
        $action=strtolower(trim((string)$request->input('action','')));
        $userId=(int)$request->input('user_id',0);
        $target=$userId>0?Database::one('SELECT id,Name,Access FROM users WHERE id=? LIMIT 1',[$userId]):null;
        if(!$target) Response::json(['ok'=>false,'message'=>'Player could not be found.'],404);

        $adminAccess=(int)($admin['Access']??0);
        $targetAccess=(int)($target['Access']??0);
        $name=(string)$target['Name'];

        if($action==='message'){
            $message=trim((string)$request->input('message',''));
            if($message==='') Response::json(['ok'=>false,'message'=>'Enter a message.'],422);
            $message=substr($message,0,500);
            $result=$this->rpcRequest('message-player',['userId'=>$userId,'name'=>$name,'message'=>$message],2.0);
            if(!empty($result['ok'])) $this->auditPlayer($admin,$request,'message',$target,['message'=>$message,'source'=>'emulator_players_tab']);
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Player must be online to receive a message.')],!empty($result['ok'])?200:400);
        }

        if($action==='kick'){
            $reason=trim((string)$request->input('reason',''));
            if($reason==='') Response::json(['ok'=>false,'message'=>'Enter a kick reason.'],422);
            if($userId===(int)$admin['id']) Response::json(['ok'=>false,'message'=>'You cannot kick your own panel account.'],403);
            if($adminAccess<60&&$targetAccess>=40) Response::json(['ok'=>false,'message'=>'Moderators cannot kick staff accounts.'],403);
            $reason=substr($reason,0,250);
            $result=$this->rpcRequest('kick',['userId'=>$userId,'name'=>$name,'reason'=>$reason],2.0);
            if(!empty($result['ok'])){
                try{Database::run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$userId,'Panel Kick',$reason]);}catch(Throwable){}
                $this->auditPlayer($admin,$request,'kick',$target,['reason'=>$reason,'source'=>'emulator_players_tab']);
            }
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Player is not online.')],!empty($result['ok'])?200:400);
        }

        if($action==='ban'){
            if($adminAccess<60) Response::json(['ok'=>false,'message'=>'Administrator access is required to ban accounts.'],403);
            $reason=trim((string)$request->input('reason',''));
            if($reason==='') Response::json(['ok'=>false,'message'=>'Enter a ban reason.'],422);
            if($userId===(int)$admin['id']) Response::json(['ok'=>false,'message'=>'You cannot ban your own panel account.'],403);
            if($targetAccess>=40) Response::json(['ok'=>false,'message'=>'Staff accounts are protected from panel bans.'],403);
            $reason=substr($reason,0,500);
            $result=$this->rpcRequest('ban-player',['userId'=>$userId,'name'=>$name,'reason'=>$reason],2.2);
            if(!empty($result['ok'])){
                try{Database::run('INSERT INTO users_logs (UserID,Violation,Details) VALUES (?,?,?)',[$userId,'Panel Ban',$reason]);}catch(Throwable){}
                $this->auditPlayer($admin,$request,'ban',$target,['reason'=>$reason,'source'=>'emulator_players_tab']);
            }
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Could not ban player.')],!empty($result['ok'])?200:400);
        }

        if($action==='mute'){
            $minutes=max(1,min(1440,(int)$request->input('minutes',5)));$reason=trim((string)$request->input('reason',''));
            if($targetAccess>=40&&$targetAccess>=$adminAccess) Response::json(['ok'=>false,'message'=>'You cannot mute staff of an equal or higher rank.'],403);
            $result=$this->rpcRequest('mute-player',['userId'=>$userId,'minutes'=>$minutes,'reason'=>substr($reason,0,250)],2.0);
            if(!empty($result['ok'])) $this->auditPlayer($admin,$request,'mute',$target,['minutes'=>$minutes,'reason'=>$reason,'source'=>'emulator_players_tab']);
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Player must be online.')],!empty($result['ok'])?200:400);
        }

        if($action==='unmute'){
            if($targetAccess>=40&&$targetAccess>=$adminAccess) Response::json(['ok'=>false,'message'=>'You cannot unmute staff of an equal or higher rank.'],403);
            $result=$this->rpcRequest('unmute-player',['userId'=>$userId],2.0);
            if(!empty($result['ok'])) $this->auditPlayer($admin,$request,'unmute',$target,['source'=>'emulator_players_tab']);
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Player must be online.')],!empty($result['ok'])?200:400);
        }

        if($action==='promote'||$action==='demote'){
            if($adminAccess<60) Response::json(['ok'=>false,'message'=>'Administrator access is required to change staff ranks.'],403);
            if($userId===(int)$admin['id']) Response::json(['ok'=>false,'message'=>'You cannot change your own staff rank.'],403);
            if($targetAccess>=$adminAccess) Response::json(['ok'=>false,'message'=>'You cannot change a player with an equal or higher rank.'],403);
            $newAccess=$this->rankAccess((string)$request->input('rank',''));
            if($newAccess===null) Response::json(['ok'=>false,'message'=>'Choose a valid rank.'],422);
            if($newAccess>$adminAccess) Response::json(['ok'=>false,'message'=>'You cannot assign a rank higher than your own.'],403);
            if($action==='promote'&&$newAccess<=$targetAccess) Response::json(['ok'=>false,'message'=>'Promote must assign a higher rank.'],422);
            if($action==='demote'&&$newAccess>=$targetAccess) Response::json(['ok'=>false,'message'=>'Demote must assign a lower rank.'],422);
            $result=$this->rpcRequest('set-access',['userId'=>$userId,'access'=>$newAccess,'source'=>'emulator players tab '.$action.' by '.$admin['Name']],2.2);
            if(!empty($result['ok'])) $this->auditPlayer($admin,$request,$action,$target,['old_access'=>$targetAccess,'new_access'=>$newAccess,'rank'=>$this->rankName($newAccess),'source'=>'emulator_players_tab']);
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Could not update rank.')],!empty($result['ok'])?200:400);
        }

        if($action==='give-item'){
            $itemId=(int)$request->input('item_id',0);
            $quantity=max(1,min(999999,(int)$request->input('quantity',1)));
            $item=$itemId>0?Database::one('SELECT id,Name FROM items WHERE id=? LIMIT 1',[$itemId]):null;
            if(!$item) Response::json(['ok'=>false,'message'=>'Unknown item ID.'],404);
            $result=$this->rpcRequest('give-item',['userId'=>$userId,'itemId'=>$itemId,'quantity'=>$quantity],2.2);
            if(!empty($result['ok'])) $this->auditPlayer($admin,$request,'give_item',$target,['item_id'=>$itemId,'item'=>$item['Name'],'quantity'=>$quantity,'source'=>'emulator_players_tab']);
            Response::json(['ok'=>(bool)($result['ok']??false),'message'=>(string)($result['message']??'Could not give the item.')],!empty($result['ok'])?200:400);
        }

        Response::json(['ok'=>false,'message'=>'Unsupported player action.'],422);
    }

    /**
     * IIS-safe true-live console feed. The request waits inside the emulator's
     * localhost event bridge until new output exists; it does not poll a log
     * file or require streaming output through FastCGI.
     */
    public function events(Request $request): void
    {
        Auth::requireAdmin();
        if (session_status() === PHP_SESSION_ACTIVE) @session_write_close();
        @set_time_limit(30);

        $after = max(0, (int)$request->input('cursor', 0));
        $result = $this->consoleRequest([
            'type' => 'waitEvents',
            'after' => $after,
            'waitMs' => 22000,
        ], 24.5, 'events');

        if (empty($result['ok'])) {
            Response::json([
                'ok' => false,
                'events' => [],
                'cursor' => $after,
                'message' => (string)($result['message'] ?? 'Emulator event channel is offline.'),
            ], 503);
        }

        $payload = is_array($result['payload'] ?? null) ? $result['payload'] : [];
        Response::json([
            'ok' => true,
            'events' => is_array($payload['events'] ?? null) ? $payload['events'] : [],
            'cursor' => max($after, (int)($payload['cursor'] ?? $after)),
        ]);
    }

    /** Current process/player/room state for the web dashboard. */
    public function state(Request $request): void
    {
        Auth::requireAdmin();
        $control = $this->controlStatus();
        $rpc = $this->rpcRequest('snapshot', [], 1.2);
        Response::json([
            'ok' => true,
            'control' => $control,
            'runtime' => !empty($rpc['ok']) && is_array($rpc['data'] ?? null) ? $rpc['data'] : null,
            'configuredPort' => $this->configuredGamePort(),
            'runtimeMessage' => (string)($rpc['message'] ?? ''),
        ]);
    }

    /** Structured web actions against the running emulator process. */
    public function rpc(Request $request): void
    {
        Auth::requireAdmin();
        Csrf::verify($request);
        $action = strtolower(trim((string)$request->input('action', '')));
        $allowed = ['broadcast','kick','reload-data','safe-shutdown','cancel-shutdown'];
        if (!in_array($action, $allowed, true)) Response::json(['ok'=>false,'message'=>'Unsupported emulator action.'], 422);

        $params = [];
        if ($action === 'broadcast') $params['message'] = trim((string)$request->input('message', ''));
        if ($action === 'kick') { $params['userId']=(int)$request->input('user_id',0);$params['name']=trim((string)$request->input('name',''));$params['reason']=trim((string)$request->input('reason','')); }
        if ($action === 'safe-shutdown') $params['seconds'] = max(10, min(3600, (int)$request->input('seconds', 300)));

        $result = $this->rpcRequest($action, $params, 2.0);
        Response::json([
            'ok' => (bool)($result['ok'] ?? false),
            'message' => (string)($result['message'] ?? ''),
            'data' => $result['data'] ?? null,
        ], !empty($result['ok']) ? 200 : 400);
    }

    /** AJAX process controls. The SYSTEM supervisor remains the stable process owner. */
    public function control(Request $request, string $action): void
    {
        Auth::requireAdmin();
        Csrf::verify($request);
        if (!in_array($action, ['start','stop','restart'], true)) Response::json(['ok'=>false,'message'=>'Invalid control action.'], 404);
        [$ok, $message] = $this->runControl($action);
        Response::json(['ok'=>$ok,'message'=>$message,'control'=>$this->controlStatus()], $ok ? 200 : 500);
    }

    /** Save the SmartFox game socket port from the Aera Emulator panel. */
    public function port(Request $request): void
    {
        Auth::requireAdmin();
        Csrf::verify($request);

        $port=(int)$request->input('port',0);
        if($port<1024 || $port>65535){
            Session::flash('error','Game port must be between 1024 and 65535.');
            Response::redirect('/admin/emulator');
        }

        [, $consolePort]=$this->consoleEndpoint();
        if($port===$consolePort){
            Session::flash('error','Game port cannot use '.$consolePort.' because that port is reserved for the local admin console.');
            Response::redirect('/admin/emulator');
        }

        $settingsFile=$this->runtimeSettingsFile();
        @mkdir(dirname($settingsFile),0775,true);
        $settings=[];
        if(is_file($settingsFile)){
            $loaded=json_decode((string)@file_get_contents($settingsFile),true);
            if(is_array($loaded))$settings=$loaded;
        }
        $settings['port']=$port;
        $json=json_encode($settings,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES).PHP_EOL;
        if(@file_put_contents($settingsFile,$json,LOCK_EX)===false){
            Session::flash('error','Could not save Emulator/PHP/runtime/settings.json. Re-run INSTALL_PHP_EMULATOR_CONTROL.bat as Administrator to repair IIS permissions.');
            Response::redirect('/admin/emulator');
        }

        // The server-list SWF reads servers.Port, so keep the client destination
        // and emulator listener in sync from one panel setting.
        try{
            $serverName=$this->configuredServerName();
            Database::run('UPDATE servers SET Port=? WHERE id=1 OR Name=?',[$port,$serverName]);
        }catch(Throwable $e){
            Session::flash('error','Port setting was saved, but the servers table could not be updated: '.$e->getMessage());
            Response::redirect('/admin/emulator');
        }

        $status=$this->controlStatus();
        if(($status['state']??'')==='running'){
            [$ok,$message]=$this->runControl('restart');
            Session::flash($ok?'success':'warning',$ok
                ? 'Game port saved as '.$port.'. Emulator restart queued; clients will now use the same port from the servers table.'
                : 'Game port saved as '.$port.', but the emulator restart could not be queued: '.$message);
        }else{
            Session::flash('success','Game port saved as '.$port.'. The emulator will bind to it on the next start, and the client server list was updated.');
        }
        Response::redirect('/admin/emulator');
    }

    /** Send a terminal-style command to the running emulator. */
    public function consoleCommand(Request $request): void
    {
        Auth::requireAdmin();
        Csrf::verify($request);
        $command = trim((string)$request->input('command', ''));
        if ($command === '' || strlen($command) > 500) Response::json(['ok'=>false,'message'=>'Enter a command up to 500 characters.'], 422);

        $result = $this->consoleRequest(['type'=>'command','command'=>$command], 2.2, 'result');
        if (empty($result['ok'])) Response::json(['ok'=>false,'message'=>(string)($result['message'] ?? 'The emulator console is offline.')], 503);
        $payload = is_array($result['payload'] ?? null) ? $result['payload'] : [];
        Response::json([
            'ok' => (bool)($payload['ok'] ?? false),
            'message' => (string)($payload['message'] ?? ''),
        ], !empty($payload['ok']) ? 200 : 400);
    }

    /** Return an editable emulator source/config file. */
    public function editorRead(Request $request): void
    {
        Auth::requireAdmin();
        $relative = (string)$request->input('file', 'src/GameServer.php');
        $file = $this->resolveEditableFile($relative);
        if ($file === null) Response::json(['ok'=>false,'message'=>'That emulator file is not editable from the panel.'], 404);
        $contents = @file_get_contents($file['path']);
        if (!is_string($contents)) Response::json(['ok'=>false,'message'=>'Could not read the emulator file.'], 500);
        Response::json([
            'ok'=>true,
            'file'=>$file['relative'],
            'content'=>$contents,
            'modified'=>date(DATE_ATOM, (int)(@filemtime($file['path']) ?: time())),
            'bytes'=>strlen($contents),
        ]);
    }

    /** Save emulator code with syntax validation and an automatic backup. */
    public function editorSave(Request $request): void
    {
        $admin = Auth::requireAdmin();
        Csrf::verify($request);
        $relative = (string)$request->input('file', '');
        $content = (string)$request->input('content', '');
        $restart = (string)$request->input('restart', '0') === '1';
        if (strlen($content) > 2_000_000) Response::json(['ok'=>false,'message'=>'Editor files are limited to 2 MB.'], 413);

        $file = $this->resolveEditableFile($relative);
        if ($file === null) Response::json(['ok'=>false,'message'=>'That emulator file is not editable from the panel.'], 404);

        if (strtolower(pathinfo($file['path'], PATHINFO_EXTENSION)) === 'php') {
            try {
                token_get_all($content, TOKEN_PARSE);
            } catch (ParseError $e) {
                Response::json(['ok'=>false,'message'=>'PHP syntax error: '.$e->getMessage()], 422);
            }
        }

        $backupRoot = $this->runtimeRoot().'/runtime/backups/editor/'.date('Ymd_His').'_'.$admin['id'];
        $backup = $backupRoot.'/'.$file['relative'];
        @mkdir(dirname($backup), 0775, true);
        if (!@copy($file['path'], $backup)) Response::json(['ok'=>false,'message'=>'Could not create the automatic source backup.'], 500);

        $tmp = $file['path'].'.aera-'.bin2hex(random_bytes(5)).'.tmp';
        if (@file_put_contents($tmp, $content, LOCK_EX) === false) Response::json(['ok'=>false,'message'=>'Could not write the temporary source file.'], 500);
        if (!@rename($tmp, $file['path'])) {
            @unlink($tmp);
            Response::json(['ok'=>false,'message'=>'Could not replace the emulator source file. Check IIS permissions.'], 500);
        }

        $message = 'Saved '.$file['relative'].'. Backup: '.str_replace('\\','/',$backup);
        $restartResult = null;
        if ($restart) {
            [$ok,$restartMessage] = $this->runControl('restart');
            $restartResult = ['ok'=>$ok,'message'=>$restartMessage];
            $message .= $ok ? ' Emulator restart queued.' : ' Saved, but restart failed: '.$restartMessage;
        }

        Response::json([
            'ok'=>true,
            'message'=>$message,
            'file'=>$file['relative'],
            'restart'=>$restartResult,
        ]);
    }

    /** Legacy form controls retained as no-JavaScript fallback. */
    public function action(Request $request, string $action): void
    {
        Auth::requireAdmin();
        Csrf::verify($request);

        if ($action === 'safe-shutdown') {
            $result = $this->rpcRequest('safe-shutdown', ['seconds'=>300], 2.0);
            Session::flash(!empty($result['ok']) ? 'success' : 'error', (string)($result['message'] ?? 'Could not start safe shutdown.'));
        } elseif ($action === 'reload-data') {
            $result = $this->rpcRequest('reload-data', [], 2.0);
            Session::flash(!empty($result['ok']) ? 'success' : 'error', (string)($result['message'] ?? 'Could not reload emulator data.'));
        } elseif (in_array($action, ['start','stop','restart'], true)) {
            [$ok,$message] = $this->runControl($action);
            Session::flash($ok ? 'success' : 'error', $message);
        } else {
            Response::abort(404);
        }
        Response::redirect('/admin/emulator');
    }

    private function auditPlayer(array $admin,Request $request,string $action,array $target,?array $details): void
    {
        try{Database::run('INSERT INTO admin_audit (AdminUserID,Action,Entity,EntityID,Details,IPAddress) VALUES (?,?,?,?,?,?)',[(int)$admin['id'],$action,'player',(string)$target['id'],$details===null?null:json_encode($details,JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE),$request->ip()]);}catch(Throwable){}
    }

    private function runtimeRoot(): string
    {
        return rtrim((string)Config::get('paths.project'), '/\\').'/Emulator/PHP';
    }

    private function runtimeSettingsFile(): string
    {
        return $this->runtimeRoot().'/runtime/settings.json';
    }

    /** @return array<string,mixed> */
    private function emulatorConfig(): array
    {
        $file=$this->runtimeRoot().'/config/emulator.php';
        $cfg=is_file($file)?(array)require $file:[];
        $settingsFile=$this->runtimeSettingsFile();
        if(is_file($settingsFile)){
            $runtime=json_decode((string)@file_get_contents($settingsFile),true);
            if(is_array($runtime)){
                $port=(int)($runtime['port']??0);
                if($port>=1024 && $port<=65535)$cfg['port']=$port;
            }
        }
        return $cfg;
    }

    private function configuredGamePort(): int
    {
        $cfg=$this->emulatorConfig();
        $port=(int)($cfg['port']??5589);
        return ($port>=1024 && $port<=65535)?$port:5589;
    }

    private function configuredServerName(): string
    {
        $cfg=$this->emulatorConfig();
        $name=trim((string)($cfg['server_name']??'Aera'));
        return $name!==''?$name:'Aera';
    }

    private function controlRoot(): string { return $this->runtimeRoot().'/runtime/control'; }

    /** @return array{0:string,1:int} */
    private function consoleEndpoint(): array
    {
        $cfg = $this->emulatorConfig();
        return [(string)($cfg['console_host'] ?? '127.0.0.1'), (int)($cfg['console_port'] ?? 5591)];
    }

    /**
     * @param array<string,mixed> $payload
     * @return array{ok:bool,message:string,payload?:array<string,mixed>}
     */
    private function consoleRequest(array $payload, float $timeout, string $expectedType): array
    {
        [$host,$port] = $this->consoleEndpoint();
        $errno=0; $errstr='';
        $socket = @stream_socket_client("tcp://{$host}:{$port}", $errno, $errstr, min(1.2,$timeout), STREAM_CLIENT_CONNECT);
        if (!is_resource($socket)) return ['ok'=>false,'message'=>'Emulator control socket is offline: '.($errstr ?: 'connection failed')];

        $seconds = max(1, (int)ceil($timeout));
        stream_set_timeout($socket, $seconds);
        @fwrite($socket, json_encode($payload, JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE)."\n");
        $deadline = microtime(true)+$timeout;
        while (microtime(true)<$deadline && !feof($socket)) {
            $line = @fgets($socket);
            if ($line === false) {
                $meta = stream_get_meta_data($socket);
                if (!empty($meta['timed_out'])) break;
                usleep(10000);
                continue;
            }
            $data = json_decode(trim($line), true);
            if (!is_array($data)) continue;
            if (($data['type'] ?? '') === $expectedType) {
                @fclose($socket);
                return ['ok'=>true,'message'=>'','payload'=>$data];
            }
        }
        @fclose($socket);
        return ['ok'=>false,'message'=>'The emulator did not answer the web control request in time.'];
    }

    private function rankAccess(string $rank): ?int
    {
        $rank=strtolower(trim($rank));$rank=str_replace([' ','-','_'],'',$rank);
        return match($rank){'1','player','regular','user'=>1,'30','support','helper'=>30,'40','mod','moderator'=>40,'60','admin','administrator'=>60,'90','gm','gamemaster'=>90,'100','owner'=>100,default=>null};
    }
    private function rankName(int $access): string
    { return $access>=100?'Owner':($access>=90?'Game Master':($access>=60?'Administrator':($access>=40?'Moderator':($access>=30?'Support':'Player')))); }

    /** @param array<string,mixed> $params @return array<string,mixed> */
    private function rpcRequest(string $action, array $params = [], float $timeout = 1.5): array
    {
        $result = $this->consoleRequest(['type'=>'rpc','action'=>$action,'params'=>$params], $timeout, 'rpcResult');
        if (empty($result['ok'])) return ['ok'=>false,'message'=>(string)($result['message'] ?? 'RPC failed.')];
        $payload = is_array($result['payload'] ?? null) ? $result['payload'] : [];
        return [
            'ok'=>(bool)($payload['ok'] ?? false),
            'message'=>(string)($payload['message'] ?? ''),
            'data'=>is_array($payload['data'] ?? null) ? $payload['data'] : null,
        ];
    }

    /** @return array{0:bool,1:string} */
    private function runControl(string $action): array
    {
        if (!in_array($action, ['start','stop','restart'], true)) return [false,'Invalid emulator action.'];
        $status=$this->controlStatus();
        if (empty($status['supervisorOnline'])) return [false,'Aera PHP Emulator Supervisor is not running. Run INSTALL_PHP_EMULATOR_CONTROL.bat once as Administrator.'];

        $root=$this->controlRoot(); $requests=$root.'/requests'; $responses=$root.'/responses';
        @mkdir($requests,0775,true); @mkdir($responses,0775,true);
        if (!is_writable($requests)) return [false,'IIS cannot write emulator control requests. Re-run INSTALL_PHP_EMULATOR_CONTROL.bat as Administrator to repair permissions.'];

        $id=bin2hex(random_bytes(12));
        $payload=json_encode(['id'=>$id,'action'=>$action,'requestedAt'=>date(DATE_ATOM)],JSON_UNESCAPED_SLASHES);
        $tmp=$requests.'/'.$id.'.tmp'; $requestFile=$requests.'/'.$id.'.json';
        if (@file_put_contents($tmp,$payload,LOCK_EX)===false || !@rename($tmp,$requestFile)) { @unlink($tmp); return [false,'Could not queue the emulator control request.']; }

        $responseFile=$responses.'/'.$id.'.json'; $deadline=microtime(true)+5.0;
        while (microtime(true)<$deadline) {
            clearstatcache(true,$responseFile);
            if (is_file($responseFile)) {
                $data=json_decode((string)@file_get_contents($responseFile),true); @unlink($responseFile);
                if (is_array($data)) return [(bool)($data['ok']??false),(string)($data['message']??ucfirst($action).' processed.')];
            }
            usleep(100000);
        }
        return [false,'The supervisor did not acknowledge the request. Check Emulator/PHP/runtime/control/status.json.'];
    }

    /** @return array{state:string,supervisorOnline:bool,taskInstalled:bool,message:string} */
    private function controlStatus(): array
    {
        $file=$this->controlRoot().'/status.json';
        if (!is_file($file)) return ['state'=>'unknown','supervisorOnline'=>false,'taskInstalled'=>false,'message'=>'Supervisor status unavailable.'];
        $data=json_decode((string)@file_get_contents($file),true);
        if (!is_array($data)) return ['state'=>'unknown','supervisorOnline'=>false,'taskInstalled'=>false,'message'=>'Supervisor status is invalid.'];
        $heartbeat=strtotime((string)($data['heartbeat']??''))?:0; $online=$heartbeat>0&&(time()-$heartbeat)<=6; $running=$online&&!empty($data['running']);
        $state=$running?'running':($online?'stopped':'supervisor-offline');
        $message=$online?('Supervisor online · desired='.(string)($data['desired']??'unknown').' · emulatorPid='.(string)($data['emulatorPid']??'-')):'Supervisor heartbeat is stale. Re-run INSTALL_PHP_EMULATOR_CONTROL.bat as Administrator.';
        return ['state'=>$state,'supervisorOnline'=>$online,'taskInstalled'=>$online,'message'=>$message];
    }

    /** @return array{log:string,version:string} */
    private function logSnapshot(): array
    {
        $path=$this->activeLogPath();
        if ($path===null) return ['log'=>'No emulator output yet. Start it from the panel.','version'=>'none'];
        clearstatcache(true,$path);
        return ['log'=>$this->tailFile($path,250,262144),'version'=>(int)(@filemtime($path)?:0).':'.(int)(@filesize($path)?:0)];
    }

    private function activeLogPath(): ?string
    {
        $runtime=$this->runtimeRoot(); $panelLog=$runtime.'/runtime/logs/panel-console.log';
        if (is_file($panelLog)) return $panelLog;
        $files=glob($runtime.'/runtime/logs/*.log')?:[]; if(!$files)return null;
        usort($files,static fn(string $a,string $b):int=>((int)@filemtime($b))<=>((int)@filemtime($a)));
        return $files[0]??null;
    }

    private function tailFile(string $path,int $maxLines,int $maxBytes): string
    {
        $handle=@fopen($path,'rb'); if(!is_resource($handle))return 'Unable to read emulator log.';
        try{@fseek($handle,0,SEEK_END);$size=(int)@ftell($handle);$read=min(max(0,$size),$maxBytes);if($read>0)@fseek($handle,-$read,SEEK_END);$data=$read>0?(string)@fread($handle,$read):'';}finally{@fclose($handle);}
        if($data==='')return 'Log is empty.'; if($read<$size){$firstBreak=strpos($data,"\n");if($firstBreak!==false)$data=substr($data,$firstBreak+1);} $lines=preg_split('/\r\n|\r|\n/',$data)?:[];if(count($lines)>$maxLines)$lines=array_slice($lines,-$maxLines);return implode("\n",$lines);
    }

    /** @return list<string> */
    private function editableFiles(): array
    {
        $root=$this->runtimeRoot(); $files=[];
        foreach(['src','config','bin'] as $dir) {
            $base=$root.'/'.$dir; if(!is_dir($base))continue;
            $it=new RecursiveIteratorIterator(new RecursiveDirectoryIterator($base,FilesystemIterator::SKIP_DOTS));
            foreach($it as $entry) {
                if(!$entry->isFile())continue;
                $ext=strtolower($entry->getExtension()); if(!in_array($ext,['php','json'],true))continue;
                $relative=str_replace('\\','/',substr($entry->getPathname(),strlen($root)+1)); $files[]=$relative;
            }
        }
        foreach(['supervisor.ps1','supervisor.bat','watchdog.bat','aera-panel-control.ps1'] as $name) if(is_file($root.'/'.$name))$files[]=$name;
        sort($files,SORT_NATURAL|SORT_FLAG_CASE); return array_values(array_unique($files));
    }

    /** @return array{path:string,relative:string}|null */
    private function resolveEditableFile(string $relative): ?array
    {
        $relative=trim(str_replace('\\','/',$relative),'/');
        if($relative===''||str_contains($relative,'..')||str_contains($relative,"\0"))return null;
        if(!in_array($relative,$this->editableFiles(),true))return null;
        $root=realpath($this->runtimeRoot()); $path=realpath($this->runtimeRoot().'/'.$relative);
        if($root===false||$path===false||!is_file($path))return null;
        $rootNorm=rtrim(str_replace('\\','/',$root),'/').'/'; $pathNorm=str_replace('\\','/',$path);
        if(!str_starts_with(strtolower($pathNorm),strtolower($rootNorm)))return null;
        return ['path'=>$path,'relative'=>$relative];
    }
}
