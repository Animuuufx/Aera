<?php
declare(strict_types=1);
spl_autoload_register(static function (string $class): void {
    $prefix = 'AeraEmu\\';
    if (!str_starts_with($class, $prefix)) return;
    $relative = substr($class, strlen($prefix));
    $path = __DIR__ . '/' . str_replace('\\', '/', $relative) . '.php';
    if (!is_file($path)) return;

    if ($class === 'AeraEmu\\ExtensionRouter') {
        $code = file_get_contents($path);
        if ($code === false) {
            throw new \RuntimeException('Unable to load ExtensionRouter.php');
        }

        // Keep the large router source untouched while injecting the small
        // server-side staff command at load time. This also avoids maintaining
        // a second command implementation in a separate file.
        $needle = "            if(\$cmd==='help'){";
        $dropAll = <<<'PHP'
            if($cmd==='dropall'){
                $itemId=(int)($p[1]??0);$qty=max(1,(int)($p[2]??1));
                if($itemId<=0||$qty<=0){$this->server->sendRaw($u,['warning','Usage: /dropall itemid amount']);return;}
                $item=$this->world->items[$itemId]??$this->db->one('SELECT * FROM items WHERE id=? LIMIT 1',[$itemId]);
                if(!$item){$this->server->sendRaw($u,['warning','Unknown item ID '.$itemId.'.']);return;}
                $online=array_values(array_filter($this->server->clients(),fn($c)=>$c->authenticated));
                if(!$online){$this->server->sendRaw($u,['warning','There are no players currently online.']);return;}
                $given=0;$failed=0;$actual=0;
                foreach($online as $target){
                    $result=$this->grantItemToPlayer($target->dbId,$itemId,$qty,'/dropall by '.$u->username);
                    if(!empty($result['ok'])){$given++;$actual+=(int)($result['quantity']??0);}else{$failed++;}
                }
                $message='Dropall: gave '.$actual.' x '.$item['Name'].' to '.$given.' of '.count($online).' online player(s).';
                if($failed>0)$message.=' '.$failed.' player(s) could not receive it (for example, a full stack).';
                $this->server->sendRaw($u,['server',$message]);return;
            }
PHP;
        if (str_contains($code, "if(\$cmd==='dropall')") === false && str_contains($code, $needle)) {
            $code = str_replace($needle, $dropAll.$needle, $code, 1);
            $code = str_replace('/giveitem (item id) (player name) [quantity]', '/giveitem (item id) (player name) [quantity]','/dropall (item id) (amount)', $code, 1);
        }

        $code = preg_replace('/^<\?php\s*/', '', $code, 1) ?? $code;
        eval($code);
        return;
    }

    require $path;
});
