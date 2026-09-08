<?php
declare(strict_types=1);
namespace AeraEmu;

final class Config
{
    private array $emulator;
    private array $db;
    private string $root;

    public function __construct(string $emulatorRoot)
    {
        $this->root=rtrim(str_replace('\\','/',$emulatorRoot),'/');
        $file=$this->root.'/config/emulator.php';
        $this->emulator=is_file($file)?(array)require $file:[];

        // Web-panel runtime overrides live outside source/config so changing the
        // game port never rewrites PHP source. Only explicitly supported keys
        // are accepted here.
        $runtimeSettingsFile=$this->root.'/runtime/settings.json';
        if(is_file($runtimeSettingsFile)){
            $runtimeSettings=json_decode((string)@file_get_contents($runtimeSettingsFile),true);
            if(is_array($runtimeSettings)){
                $runtimePort=(int)($runtimeSettings['port']??0);
                if($runtimePort>=1024 && $runtimePort<=65535)$this->emulator['port']=$runtimePort;
            }
        }

        $projectRoot=dirname(dirname($this->root));
        $defaults=[];$defaultFile=$projectRoot.'/web/config/app.php';if(is_file($defaultFile))$defaults=(array)require $defaultFile;
        $runtime=[];$runtimeFile=$projectRoot.'/web/storage/config.php';if(is_file($runtimeFile)){$loaded=require $runtimeFile;if(is_array($loaded))$runtime=$loaded;}
        $db=array_replace((array)($defaults['db']??[]),(array)($runtime['db']??[]));
        // The Java emulator used database.name from aqworld.conf. Keep the current
        // project's configured DB when supplied, and fall back to aera only when absent.
        $db['database']=(string)($db['database']??$db['name']??'aera');if($db['database']==='')$db['database']='aera';
        $db['host']=(string)($db['host']??'127.0.0.1');$db['port']=(int)($db['port']??3306);
        $db['username']=(string)($db['username']??$db['user']??'');$db['password']=(string)($db['password']??$db['pass']??'');
        $this->db=$db;
    }
    public function get(string $key,mixed $default=null): mixed { return $this->emulator[$key]??$default; }
    public function db(): array { return $this->db; }
    public function root(): string { return $this->root; }
    public function projectRoot(): string { return dirname(dirname($this->root)); }
}
