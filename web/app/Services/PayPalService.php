<?php
declare(strict_types=1);
namespace Aera\Services;

use Aera\Foundation\Config;
use RuntimeException;

final class PayPalService
{
    private static function base(): string { return strtolower((string)Config::get('paypal.mode','sandbox'))==='live' ? 'https://api-m.paypal.com' : 'https://api-m.sandbox.paypal.com'; }
    private static function credentials(): array
    {
        $id=trim((string)Config::get('paypal.client_id','')); $secret=(string)Config::get('paypal.client_secret','');
        if($id===''||$secret==='')throw new RuntimeException('PayPal Client ID and Client Secret are not configured.'); return [$id,$secret];
    }
    private static function request(string $method,string $url,string $token,array $body=[]): array
    {
        $ch=curl_init($url);if($ch===false)throw new RuntimeException('Unable to initialize cURL.');$headers=['Authorization: Bearer '.$token,'Content-Type: application/json','Accept: application/json'];
        curl_setopt_array($ch,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_CUSTOMREQUEST=>strtoupper($method),CURLOPT_HTTPHEADER=>$headers,CURLOPT_TIMEOUT=>30]);if($body)curl_setopt($ch,CURLOPT_POSTFIELDS,json_encode($body,JSON_UNESCAPED_SLASHES));
        $raw=(string)curl_exec($ch);$err=curl_error($ch);$code=(int)curl_getinfo($ch,CURLINFO_RESPONSE_CODE);curl_close($ch);$data=json_decode($raw,true);if(!is_array($data))$data=[];
        if($err!==''||$code<200||$code>=300)throw new RuntimeException('PayPal API error (HTTP '.$code.'): '.(string)($data['message']??$data['error_description']??$err??'Request rejected.'));return $data;
    }
    private static function accessToken(bool $clientToken=false): array
    {
        [$id,$secret]=self::credentials();$ch=curl_init(self::base().'/v1/oauth2/token');if($ch===false)throw new RuntimeException('Unable to initialize cURL.');
        $domain=parse_url((string)Config::get('app.url','https://nightvaults.com'),PHP_URL_HOST)?:'localhost';
        $body=$clientToken?'grant_type=client_credentials&response_type=client_token&intent=sdk_init&domains[]='.rawurlencode($domain):'grant_type=client_credentials&response_type=token';
        curl_setopt_array($ch,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_POST=>true,CURLOPT_POSTFIELDS=>$body,CURLOPT_HTTPHEADER=>['Authorization: Basic '.base64_encode($id.':'.$secret),'Content-Type: application/x-www-form-urlencoded','Accept: application/json'],CURLOPT_TIMEOUT=>30]);
        $raw=(string)curl_exec($ch);$err=curl_error($ch);$code=(int)curl_getinfo($ch,CURLINFO_RESPONSE_CODE);curl_close($ch);$data=json_decode($raw,true);
        if($err!==''||!is_array($data)||$code<200||$code>=300||empty($data['access_token']))throw new RuntimeException('PayPal authentication failed.');return $data;
    }
    public static function browserClientToken(): string { return (string)self::accessToken(true)['access_token']; }
    public static function createOrder(string $currency,string $amount,string $productTitle): array
    {
        $token=(string)self::accessToken(false)['access_token'];return self::request('POST',self::base().'/v2/checkout/orders',$token,['intent'=>'CAPTURE','purchase_units'=>[['description'=>mb_substr($productTitle,0,127),'amount'=>['currency_code'=>strtoupper($currency),'value'=>number_format((float)$amount,2,'.','')]]]]);
    }
    public static function captureOrder(string $orderId): array { $token=(string)self::accessToken(false)['access_token'];return self::request('POST',self::base().'/v2/checkout/orders/'.rawurlencode($orderId).'/capture',$token); }
}
