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

final class AccountController
{
    public function registerForm(Request $r): void { if(Auth::user()) Response::redirect('/account'); View::render('register'); }
    public function register(Request $r): void
    {
        Csrf::verify($r); $name=strtolower(trim((string)$r->input('username'))); $email=trim((string)$r->input('email')); $pass=(string)$r->input('password'); $confirm=(string)$r->input('password_confirmation'); $errors=[];
        if(!preg_match('/^[a-z0-9_]{3,20}$/',$name))$errors[]='Username must be 3-20 letters, numbers, or underscores.';
        if(!filter_var($email,FILTER_VALIDATE_EMAIL)||strlen($email)>64)$errors[]='Enter a valid email address.';
        if(strlen($pass)<8||strlen($pass)>72)$errors[]='Password must be 8-72 characters.';
        if($pass!==$confirm)$errors[]='Passwords do not match.';
        if(!$errors && Database::one('SELECT id FROM users WHERE LOWER(Name)=? OR LOWER(Email)=LOWER(?) LIMIT 1',[$name,$email]))$errors[]='That username or email is already in use.';
        if($errors){Session::flash('error',implode(' ',$errors));Response::redirect('/register');}
        $pdo=Database::connection();
        try{$pdo->beginTransaction();$pdo->prepare("INSERT INTO users (Name,Hash,Email,ColorHair,ColorSkin,ColorEye,ColorBase,ColorTrim,ColorAccessory,HouseInfo,CurrentServer) VALUES (?,?,?,?,?,?,?,?,?,?,?)")->execute([$name,password_hash($pass,PASSWORD_BCRYPT),$email,'5e4f37','eacd8a','1649e','000000','000000','000000','','Offline']);$id=(int)$pdo->lastInsertId();foreach([1,2] as $item){if(Database::one('SELECT id FROM items WHERE id=?',[$item]))$pdo->prepare('INSERT INTO users_items (UserID,ItemID,EnhID,Equipped) VALUES (?,?,1,1)')->execute([$id,$item]);}$pdo->commit();}
        catch(\Throwable $e){if($pdo->inTransaction())$pdo->rollBack();Session::flash('error','Account creation failed.');Response::redirect('/register');}
        Session::flash('success','Account created. You can sign in now.');Response::redirect('/login');
    }
    public function loginForm(Request $r): void { if(Auth::user())Response::redirect('/account');View::render('login'); }
    public function login(Request $r): void { Csrf::verify($r); if(!Auth::attempt((string)$r->input('username'),(string)$r->input('password'))){Session::flash('error','Invalid username or password.');Response::redirect('/login');}$u=Auth::user();Response::redirect($u&&(int)$u['Access']>=40?'/admin':'/account'); }
    public function logout(Request $r): void { Csrf::verify($r);Auth::logout();Response::redirect('/'); }
    public function account(Request $r): void
    {
        $u=Auth::requireUser();$equipped=Database::all("SELECT i.Name,i.Type,i.Equipment,i.Level,i.Rarity,ui.Quantity FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 ORDER BY i.Name",[(int)$u['id']]);
        $inventory=(int)Database::scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND Bank=0',[(int)$u['id']]);$bank=(int)Database::scalar('SELECT COUNT(*) FROM users_items WHERE UserID=? AND Bank=1',[(int)$u['id']]);
        View::render('account',['account'=>$u,'equipped'=>$equipped,'inventoryCount'=>$inventory,'bankCount'=>$bank]);
    }
    public function email(Request $r): void
    {
        Csrf::verify($r);$u=Auth::requireUser();$email=trim((string)$r->input('email'));$current=(string)$r->input('current_password');
        if(!password_verify($current,(string)$u['Hash'])){Session::flash('error','Current password is incorrect.');Response::redirect('/account');}
        if(!filter_var($email,FILTER_VALIDATE_EMAIL)||strlen($email)>64){Session::flash('error','Enter a valid email.');Response::redirect('/account');}
        if(Database::one('SELECT id FROM users WHERE LOWER(Email)=LOWER(?) AND id<>? LIMIT 1',[$email,(int)$u['id']])){Session::flash('error','That email is already in use.');Response::redirect('/account');}
        Database::run('UPDATE users SET Email=? WHERE id=?',[$email,(int)$u['id']]);Auth::refresh();Session::flash('success','Email updated.');Response::redirect('/account');
    }
    public function password(Request $r): void
    {
        Csrf::verify($r);$u=Auth::requireUser();$current=(string)$r->input('current_password');$pass=(string)$r->input('password');$confirm=(string)$r->input('password_confirmation');
        if(!password_verify($current,(string)$u['Hash'])){Session::flash('error','Current password is incorrect.');Response::redirect('/account');}
        if(strlen($pass)<8||strlen($pass)>72||$pass!==$confirm){Session::flash('error','New password must be 8-72 characters and both entries must match.');Response::redirect('/account');}
        $pdo=Database::connection();$pdo->beginTransaction();try{$pdo->prepare('UPDATE users SET Hash=? WHERE id=?')->execute([password_hash($pass,PASSWORD_BCRYPT),(int)$u['id']]);$pdo->prepare('DELETE FROM game_sessions WHERE UserID=?')->execute([(int)$u['id']]);$pdo->commit();}catch(\Throwable $e){if($pdo->inTransaction())$pdo->rollBack();throw $e;}Auth::refresh();Session::flash('success','Password updated. Active game tokens were signed out.');Response::redirect('/account');
    }
}
