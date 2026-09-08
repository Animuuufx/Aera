<?php
declare(strict_types=1);
namespace AeraEmu;

final class Protocol
{
    public static function frame(string $payload): string { return $payload . "\0"; }

    public static function sys(string $action, int $room, string $body=''): string
    {
        return self::frame("<msg t='sys'><body action='".self::x($action)."' r='{$room}'>{$body}</body></msg>");
    }

    /**
     * SmartFoxServer 1.x string extension response.
     *
     * The Java AbstractExtension#sendResponse(String[], room, ...) wire format is:
     *   %xt%<command>%<room>%<param1>%<param2>%...%
     *
     * The old PHP emulator omitted the room slot. AQW's client intentionally reads
     * response data starting at index 2 (index 1 is the SFS room), so omitting it
     * shifts every value and breaks loginResponse plus most string XT replies.
     */
    public static function raw(array $parts, int $room=-1): string
    {
        if ($parts === []) return self::frame('%xt%%'.$room.'%');

        $command = array_shift($parts);
        $out = '%xt%' . self::rawValue($command) . '%' . $room . '%';
        foreach ($parts as $part) $out .= self::rawValue($part) . '%';
        return self::frame($out);
    }

    private static function rawValue(mixed $value): string
    {
        if (is_bool($value)) $value = $value ? 'true' : 'false';
        if ($value === null) $value = '';
        // Percent is the string-protocol separator. Match the legacy server's
        // safe behavior by preventing user data from injecting new fields.
        return str_replace('%', '&#37;', (string)$value);
    }

    public static function json(array $obj, int $room=-1): string
    {
        return self::frame(json_encode(
            ['t'=>'xt','b'=>['r'=>$room,'o'=>$obj]],
            JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE
        ));
    }

    public static function policy(int $port=5589): string
    {
        $port=max(1,min(65535,$port));
        return self::frame('<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="'.$port.'" /></cross-domain-policy>');
    }

    public static function x(string $s): string
    {
        return htmlspecialchars($s, ENT_QUOTES|ENT_XML1, 'UTF-8');
    }

    /** @return array{type:string,action?:string,room?:int,xml?:string,ext?:string,cmd?:string,params?:array} */
    public static function parse(string $message): array
    {
        if ($message === '<policy-file-request/>') return ['type'=>'policy'];

        if (str_starts_with($message, '%')) {
            $bits = explode('%', trim($message, '%'));
            if (($bits[0] ?? '') === 'xt') {
                return [
                    'type'=>'ext',
                    'ext'=>$bits[1]??'',
                    'cmd'=>$bits[2]??'',
                    'room'=>(int)($bits[3]??-1),
                    'params'=>array_slice($bits,4),
                ];
            }
            return ['type'=>'raw'];
        }

        // SmartFox JSON XT requests are uncommon in this client, but accepting
        // them keeps the emulator compatible with auxiliary/custom clients.
        if (str_starts_with(ltrim($message), '{')) {
            $data = json_decode($message, true);
            if (is_array($data) && ($data['t'] ?? null) === 'xt' && is_array($data['b'] ?? null)) {
                $b = $data['b'];
                return [
                    'type'=>'ext',
                    'ext'=>(string)($b['x'] ?? 'zm'),
                    'cmd'=>(string)($b['c'] ?? ''),
                    'room'=>(int)($b['r'] ?? -1),
                    'params'=>is_array($b['p'] ?? null) ? array_values($b['p']) : [],
                ];
            }
            return ['type'=>'unknown'];
        }

        if (!str_starts_with($message, '<')) return ['type'=>'unknown'];
        $action=''; $room=0;
        if (preg_match('/<body\s+[^>]*action=[\'\"]([^\'\"]+)[\'\"][^>]*>/i',$message,$m)) {
            $action=html_entity_decode($m[1],ENT_QUOTES|ENT_XML1,'UTF-8');
        }
        if (preg_match('/<body\s+[^>]*r=[\'\"](-?\d+)[\'\"]/i',$message,$m)) $room=(int)$m[1];
        return ['type'=>'sys','action'=>$action,'room'=>$room,'xml'=>$message];
    }

    public static function tag(string $xml,string $tag): ?string
    {
        if (preg_match('/<'.preg_quote($tag,'/').'\b[^>]*><!\[CDATA\[(.*?)\]\]><\/'.preg_quote($tag,'/').'>/si',$xml,$m)) return $m[1];
        if (preg_match('/<'.preg_quote($tag,'/').'\b[^>]*>(.*?)<\/'.preg_quote($tag,'/').'>/si',$xml,$m)) return html_entity_decode(strip_tags($m[1]),ENT_QUOTES|ENT_XML1,'UTF-8');
        return null;
    }

    public static function attr(string $xml,string $tag,string $attr): ?string
    {
        if (preg_match('/<'.preg_quote($tag,'/').'\b[^>]*'.preg_quote($attr,'/').'=[\'\"]([^\'\"]*)[\'\"]/i',$xml,$m)) return html_entity_decode($m[1],ENT_QUOTES|ENT_XML1,'UTF-8');
        return null;
    }
}
