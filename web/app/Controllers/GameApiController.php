<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Config;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use DateTimeImmutable;
use DateTimeZone;
use PDO;
use Throwable;

final class GameApiController
{
    public function version(Request $request): void { $this->settings('loader'); }
    public function clientvars(Request $request): void { $this->settings('game'); }
    private function settings(string $location): never
    {
        $out=[]; foreach(Database::all('SELECT name,value FROM settings_login WHERE location=? ORDER BY id',[$location]) as $row)$out[$row['name']]=$row['value'];
        Response::json($out);
    }
    public function login(Request $request): void
    {
        $name=strtolower(trim((string)$request->input('user'))); $pass=(string)$request->input('pass');
        if($name===''||$pass==='')Response::json(['bSuccess'=>0,'sMsg'=>'Please enter your username and password.']);
        $user=Database::one('SELECT * FROM users WHERE Name=? LIMIT 1',[$name]);
        if(!$user || !password_verify($pass,(string)$user['Hash']))Response::json(['bSuccess'=>0,'sMsg'=>'The username or password is incorrect.']);
        if((int)$user['Access']<1){$reason='';try{$reason=trim((string)Database::scalar("SELECT Details FROM users_logs WHERE UserID=? AND Violation='Panel Ban' ORDER BY id DESC LIMIT 1",[(int)$user['id']],'') );}catch(Throwable){}Response::json(['bSuccess'=>0,'sMsg'=>'This account is banned.'.($reason!==''?' Reason: '.$reason:'')]);}
        $token=bin2hex(random_bytes(32)); $hash=hash('sha256',$token);
        $expires=(new DateTimeImmutable('now',new DateTimeZone((string)Config::get('app.timezone','America/Chicago'))))->modify('+'.(int)Config::get('security.game_session_hours',12).' hours')->format('Y-m-d H:i:s');
        $pdo=Database::connection(); $pdo->beginTransaction();
        try{
            $pdo->prepare('DELETE FROM game_sessions WHERE ExpiresAt < NOW() OR UserID=?')->execute([(int)$user['id']]);
            $pdo->prepare('INSERT INTO game_sessions (UserID,TokenHash,ExpiresAt,IPAddress) VALUES (?,?,?,?)')->execute([(int)$user['id'],$hash,$expires,$request->ip()]);
            $pdo->prepare('UPDATE users SET LastLogin=NOW() WHERE id=?')->execute([(int)$user['id']]); $pdo->commit();
        }catch(Throwable $e){ if($pdo->inTransaction())$pdo->rollBack(); Response::json(['bSuccess'=>0,'sMsg'=>'Login service is temporarily unavailable.']); }
        $servers=[]; foreach(Database::all('SELECT * FROM servers ORDER BY id') as $server){
            $servers[]=['sName'=>$server['Name'],'sIP'=>$server['IP'],'iCount'=>(int)$server['Count'],'iLevel'=>(int)$server['Level'],'iMax'=>(int)$server['Max'],'bOnline'=>(int)$server['Online'],'iChat'=>(int)$server['Chat'],'bUpg'=>(int)$server['Upgrade'],'sLang'=>'xx','iPort'=>(int)$server['Port']];
        }
        Response::json(['bSuccess'=>1,'login'=>[
            'userId'=>(int)$user['id'], 'userid'=>(int)$user['id'],
            'bSuccess'=>1, 'sMsg'=>'success', 'sToken'=>$token,
            'strEmail'=>$user['Email'], 'unm'=>$user['Name'],
            'iAccess'=>(int)$user['Access'], 'iAge'=>(int)$user['Age'],
            'iLevel'=>(int)$user['Level'], 'iUpgDays'=>max(0,(int)$user['UpgradeDays']),
            'iEmailStatus'=>((int)$user['ActivationFlag'] >= 5 ? 5 : 1), 'intActivationFlag'=>(int)$user['ActivationFlag'], 'bCCOnly'=>false
        ],'servers'=>$servers,'polldata'=>[]]);
    }
    public function register(Request $request): void
    {
        // Legacy Flash registration endpoint. The website form uses AccountController.
        $name=strtolower(trim((string)$request->input('Username'))); $email=trim((string)$request->input('Email')); $pass=(string)$request->input('Password');
        if(!preg_match('/^[a-z0-9_]{3,20}$/',$name)||!filter_var($email,FILTER_VALIDATE_EMAIL)||strlen($pass)<8)Response::json(['msg'=>['form'=>['Invalid registration details.']]],403);
        if(Database::one('SELECT id FROM users WHERE Name=? OR Email=? LIMIT 1',[$name,$email]))Response::json(['msg'=>['Username'=>['Username or email is already in use.']]],403);
        $pdo=Database::connection();
        try{$pdo->beginTransaction(); $s=$pdo->prepare("INSERT INTO users (Name,Hash,Email,ColorHair,ColorSkin,ColorEye,HouseInfo) VALUES (?,?,?,?,?,?,?)"); $s->execute([$name,password_hash($pass,PASSWORD_BCRYPT),$email,'5e4f37','eacd8a','1649e','']); $id=(int)$pdo->lastInsertId(); $pdo->prepare('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped) VALUES (?,1,1,1),(?,2,1,1)')->execute([$id,$id]); $pdo->commit(); Response::json('Successfully created!');}
        catch(Throwable $e){if($pdo->inTransaction())$pdo->rollBack(); Response::json(['msg'=>'Registration failed.'],403);}
    }
    private function authenticatedGameUser(Request $request): array
    {
        $id=(int)$request->header('Ccid',0); $token=(string)$request->header('Token','');
        if($id<1||$token==='')Response::json('Invalid Account',403);
        $row=Database::one('SELECT u.* FROM users u INNER JOIN game_sessions s ON s.UserID=u.id WHERE u.id=? AND s.TokenHash=? AND s.ExpiresAt>NOW() LIMIT 1',[$id,hash('sha256',$token)]);
        if(!$row)Response::json('Invalid Account',403);
        Database::run('UPDATE game_sessions SET LastUsedAt=NOW() WHERE UserID=? AND TokenHash=?',[$id,hash('sha256',$token)]);
        return $row;
    }
    public function bank(Request $request): void
    {
        $user=$this->authenticatedGameUser($request);
        $rows=Database::all("SELECT a.id CharItemID,a.UserID,a.ItemID,a.EnhID,a.Equipped,a.Quantity,a.Bank,a.DatePurchased,b.Name,b.Description,b.`Range`,b.DPS,b.Rarity,b.Cost,b.Level,b.Temporary,b.Stack,b.Upgrade,b.Coins,b.Staff,b.File,b.Link,b.Element,b.Type,b.Icon,b.Equipment,e.Rarity EnhRty,e.DPS EnhDPS,e.Level EnhLvl,e.PatternID EnhPatternID FROM users_items a INNER JOIN items b ON a.ItemID=b.id LEFT JOIN enhancements e ON e.id=a.EnhID WHERE a.UserID=? AND a.Bank=1",[(int)$user['id']]);
        $items=[]; foreach($rows as $r)$items[]=['CharItemID'=>(int)$r['CharItemID'],'CharID'=>(int)$r['UserID'],'iQty'=>(int)$r['Quantity'],'bEquip'=>(int)$r['Equipped']===1,'bBank'=>(int)$r['Bank']===1,'ItemID'=>(int)$r['ItemID'],'sName'=>$r['Name'],'sDesc'=>$r['Description'],'iRng'=>(int)$r['Range'],'iDPS'=>(int)$r['DPS'],'iRty'=>(int)$r['Rarity'],'iCost'=>(int)$r['Cost'],'iLvl'=>(int)$r['Level'],'bTemp'=>(int)$r['Temporary']===1,'iStk'=>(int)$r['Stack'],'bUpg'=>(int)$r['Upgrade']===1,'bCoins'=>(int)$r['Coins']===1,'bStaff'=>(int)$r['Staff']===1,'sFile'=>$r['File'],'sLink'=>$r['Link'],'sElmt'=>$r['Element'],'sType'=>$r['Type'],'sIcon'=>$r['Icon'],'sES'=>$r['Equipment'],'EnhID'=>(int)$r['EnhID'],'EnhRty'=>$r['EnhRty']!==null?(int)$r['EnhRty']:null,'EnhDPS'=>$r['EnhDPS']!==null?(int)$r['EnhDPS']:null,'EnhRng'=>(int)$r['Range'],'EnhLvl'=>$r['EnhLvl']!==null?(int)$r['EnhLvl']:null,'EnhPatternID'=>$r['EnhPatternID']!==null?(int)$r['EnhPatternID']:null,'iHrs'=>59100,'dPurchase'=>str_replace(' ','T',(string)$r['DatePurchased'])];
        Response::json($items);
    }
    public function houseSaveRoom(Request $request): void
    {
        $user=$this->authenticatedGameUser($request); $frame=(string)$request->input('frame',''); if($frame==='')Response::text('0',400);
        $pdo=Database::connection(); $pdo->beginTransaction();
        try{
            if($frame==='*'){$pdo->prepare('DELETE FROM users_houses WHERE UserID=?')->execute([(int)$user['id']]);$pdo->commit();Response::text('cleared');}
            $layout=json_decode((string)$request->input('layout',''),true); if(!is_array($layout)||!isset($layout['xi'])||!is_array($layout['xi'])){if($pdo->inTransaction())$pdo->rollBack();Response::text('3',400);}
            foreach($layout['xi'] as $xi){$item=(int)($xi['ID']??0);$x=(int)($xi['x']??0);$y=(int)($xi['y']??0);if($item<1)continue;$exists=Database::one('SELECT id FROM users_houses WHERE UserID=? AND ItemID=? LIMIT 1',[(int)$user['id'],$item]);if($exists)$pdo->prepare('UPDATE users_houses SET Frame=?,X=?,Y=? WHERE id=?')->execute([$frame,$x,$y,(int)$exists['id']]);else $pdo->prepare('INSERT INTO users_houses (UserID,Frame,ItemID,X,Y) VALUES (?,?,?,?,?)')->execute([(int)$user['id'],$frame,$item,$x,$y]);}
            $pdo->commit();Response::text('success');
        }catch(Throwable $e){if($pdo->inTransaction())$pdo->rollBack();Response::text('4',500);}
    }

    private function serverRows(): array
    {
        $servers=[];
        foreach(Database::all('SELECT * FROM servers ORDER BY id') as $server){
            $servers[]=[
                'sName'=>$server['Name'], 'sIP'=>$server['IP'], 'iCount'=>(int)$server['Count'],
                'iLevel'=>(int)$server['Level'], 'iMax'=>(int)$server['Max'], 'bOnline'=>(int)$server['Online'],
                'iChat'=>(int)$server['Chat'], 'bUpg'=>(int)$server['Upgrade'], 'sLang'=>'xx', 'iPort'=>(int)$server['Port']
            ];
        }
        return $servers;
    }

    public function servers(Request $request): void { Response::json($this->serverRows()); }

    public function serversExtended(Request $request): void
    {
        // The stock client posts uid/token for the staff server refresh endpoint.
        $uid=(int)$request->input('uid',0); $token=(string)$request->input('token','');
        if($uid<1 || $token==='') Response::json(['error'=>'Unauthorized'],403);
        $user=Database::one(
            'SELECT u.id,u.Access FROM users u INNER JOIN game_sessions s ON s.UserID=u.id WHERE u.id=? AND s.TokenHash=? AND s.ExpiresAt>NOW() LIMIT 1',
            [$uid,hash('sha256',$token)]
        );
        if(!$user || (int)$user['Access']<24) Response::json(['error'=>'Unauthorized'],403);
        Response::json($this->serverRows());
    }

    public function charPage(Request $request): void
    {
        $name=strtolower(trim((string)$request->input('id','')));
        if($name==='') Response::text('Empty');
        $user=Database::one('SELECT u.*,h.Name HairName,h.File HairFile FROM users u LEFT JOIN hairs h ON h.id=u.HairID WHERE LOWER(u.Name)=? LIMIT 1',[$name]);
        if(!$user) Response::text('Empty');

        $equipped=[];
        foreach(Database::all('SELECT i.* FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1',[(int)$user['id']]) as $item){
            $equipped[(string)$item['Equipment']]=$item;
        }
        $class=$equipped['ar']??null; $armor=$equipped['co']??$class; $weapon=$equipped['Weapon']??null;
        $helm=$equipped['he']??null; $cape=$equipped['ba']??null; $pet=$equipped['pe']??null; $misc=$equipped['mi']??null;
        $guild=Database::one('SELECT g.Name FROM users_guilds ug INNER JOIN guilds g ON g.id=ug.GuildID WHERE ug.UserID=? LIMIT 1',[(int)$user['id']]);
        $pairs=[
            'strName'=>$user['Name'], 'intLevel'=>(string)(int)$user['Level'].($guild?' --- '.$guild['Name'].' Guild':''),
            'strGender'=>$user['Gender'], 'strFaction'=>'Neutral', 'ia1'=>(string)(int)$user['Achievement'],
            'intColorHair'=>$user['ColorHair'], 'intColorSkin'=>$user['ColorSkin'], 'intColorEye'=>$user['ColorEye'],
            'intColorBase'=>$user['ColorBase'], 'intColorTrim'=>$user['ColorTrim'], 'intColorAccessory'=>$user['ColorAccessory'],
            'strHairFile'=>$user['HairFile']??'', 'strHairName'=>$user['HairName']??'',
            'strClassName'=>$class['Name']??'', 'strClassFile'=>$class['File']??'', 'strClassLink'=>$class['Link']??'',
            'strArmorName'=>$armor['Name']??'', 'strArmorFile'=>$armor['File']??'', 'strArmorLink'=>$armor['Link']??'',
            'strWeaponName'=>$weapon['Name']??'', 'strWeaponFile'=>$weapon['File']??'', 'strWeaponLink'=>$weapon['Link']??'', 'strWeaponType'=>$weapon['Type']??'',
            'strHelmName'=>$helm['Name']??'', 'strHelmFile'=>$helm['File']??'none', 'strHelmLink'=>$helm['Link']??'',
            'strCapeName'=>$cape['Name']??'', 'strCapeFile'=>$cape['File']??'none', 'strCapeLink'=>$cape['Link']??'',
            'strPetName'=>$pet['Name']??'', 'strPetFile'=>$pet['File']??'none', 'strPetLink'=>$pet['Link']??'',
            'strMiscName'=>$misc['Name']??'', 'strMiscFile'=>$misc['File']??'none', 'strMiscLink'=>$misc['Link']??''
        ];
        Response::text('&'.http_build_query($pairs,'','&',PHP_QUERY_RFC3986));
    }

    public function bookLore(Request $request): void { Response::json(['success'=>true,'data'=>[]]); }
}
