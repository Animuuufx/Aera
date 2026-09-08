<?php
declare(strict_types=1);
namespace Aera\Services;
use Aera\Foundation\Config;
use RuntimeException;
final class PayPalService
{
    private static function base(): string { return strtolower((string)Config::get('paypal.mode','sandbox'))==='live' ? 'https://api-m.paypal.com' : 'https://api-m.sandbox.paypal.com'; }
    public static function clientIdOrEmpty(): string { return trim((string)Config::get('paypal.client_id','')); }
    public static function clientId(): string { $id=self::clientIdOrEmpty();if($id==='')throw new RuntimeException('PayPal Client ID is not configured.');return $id; }
    public static function clientSecretConfigured(): bool { return trim((string)Config::get('paypal.client_secret',''))!==''; }
    public static function merchantEmail(): string { return trim((string)Config::get('paypal.merchant_email','')); }
    public static function brandName(): string { return trim((string)Config::get('paypal.brand_name','Aera')); }
    public static function mode(): string { return strtolower((string)Config::get('paypal.mode','sandbox'))==='live'?'live':'sandbox'; }
    private static function credentials(): array { $id=self::clientId();$secret=(string)Config::get('paypal.client_secret','');if(trim($secret)==='')throw new RuntimeException('PayPal Client Secret is not configured.');return [$id,$secret]; }
    private static function token(bool $clientToken=false): string
    {
        [$id,$secret]=self::credentials();
        $ch=curl_init(self::base().'/v1/oauth2/token');
        if($ch===false)throw new RuntimeException('Unable to initialize cURL.');
        $post='grant_type=client_credentials';if($clientToken)$post.='&response_type=client_token&domains[]=nightvaults.com';
        curl_setopt_array($ch,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_POST=>true,CURLOPT_POSTFIELDS=>$post,CURLOPT_USERPWD=>$id.':'.$secret,CURLOPT_HTTPAUTH=>CURLAUTH_BASIC,CURLOPT_HTTPHEADER=>['Content-Type: application/x-www-form-urlencoded','Accept: application/json'],CURLOPT_TIMEOUT=>30,CURLOPT_SSL_VERIFYPEER=>true,CURLOPT_SSL_VERIFYHOST=>2]);
        $raw=(string)curl_exec($ch);$err=curl_error($ch);$errno=curl_errno($ch);$code=(int)curl_getinfo($ch,CURLINFO_RESPONSE_CODE);$contentType=(string)curl_getinfo($ch,CURLINFO_CONTENT_TYPE);curl_close($ch);
        if($err!=='')throw new RuntimeException('Unable to connect to PayPal (cURL '.$errno.'): '.$err);
        $data=json_decode($raw,true);
        if(!is_array($data)||$code<200||$code>=300||empty($data['access_token'])){
            $detail=is_array($data)?(string)($data['error_description']??$data['message']??'Authentication rejected.'):'Non-JSON response from PayPal (content-type: '.$contentType.', HTTP '.$code.').';
            throw new RuntimeException('PayPal authentication failed (HTTP '.$code.'): '.$detail);
        }
        return (string)$data['access_token'];
    }
    public static function testConnection(): array { $token=self::token(false); return ['ok'=>true,'mode'=>self::mode(),'message'=>'PayPal credentials authenticated successfully.','hasToken'=>$token!=='']; }
    public static function browserClientToken(): string { return self::token(true); }
    private static function accessToken(): string { return self::token(false); }
    private static function request(string $method,string $url,string $token,array $body=[]): array
    {
        $ch=curl_init($url);if($ch===false)throw new RuntimeException('Unable to initialize cURL.');$headers=['Authorization: Bearer '.$token,'Content-Type: application/json','Accept: application/json'];curl_setopt_array($ch,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_CUSTOMREQUEST=>strtoupper($method),CURLOPT_HTTPHEADER=>$headers,CURLOPT_TIMEOUT=>30,CURLOPT_SSL_VERIFYPEER=>true,CURLOPT_SSL_VERIFYHOST=>2]);if($body)curl_setopt($ch,CURLOPT_POSTFIELDS,json_encode($body,JSON_UNESCAPED_SLASHES));$raw=(string)curl_exec($ch);$err=curl_error($ch);$errno=curl_errno($ch);$code=(int)curl_getinfo($ch,CURLINFO_RESPONSE_CODE);$contentType=(string)curl_getinfo($ch,CURLINFO_CONTENT_TYPE);curl_close($ch);$data=json_decode($raw,true);if($err!=='')throw new RuntimeException('Unable to connect to PayPal (cURL '.$errno.'): '.$err);if(!is_array($data))$data=[];if($code<200||$code>=300)throw new RuntimeException('PayPal API error (HTTP '.$code.'): '.(string)($data['message']??$data['details'][0]['description']??$data['error_description']??('Non-JSON response (content-type: '.$contentType.').')));return $data;
    }
    public static function createOrder(string $currency,string $amount,string $productTitle): array { return self::request('POST',self::base().'/v2/checkout/orders',self::accessToken(),['intent'=>'CAPTURE','purchase_units'=>[['description'=>mb_substr($productTitle,0,127),'amount'=>['currency_code'=>strtoupper($currency),'value'=>number_format((float)$amount,2,'.','')]]]]); }
    public static function captureOrder(string $orderId): array { return self::request('POST',self::base().'/v2/checkout/orders/'.rawurlencode($orderId).'/capture',self::accessToken()); }
}
