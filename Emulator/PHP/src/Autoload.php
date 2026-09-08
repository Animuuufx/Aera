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

        // Aera admin command patch: /dropall itemid amount.
        // Injected here so the command is deployed with a normal source commit
        // without rewriting the large ExtensionRouter.php blob.
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
        if (!str_contains($code, "if(\$cmd==='dropall')") && str_contains($code, $needle)) {
            $dropAllCount = 0;
            $code = str_replace($needle, $dropAll.$needle, $code, $dropAllCount);
            $helpNeedle = '/giveitem (item id) (player name) [quantity]';
            $helpReplacement = '/giveitem (item id) (player name) [quantity] /dropall (item id) (amount)';
            $helpReplacements = 0;
            $code = str_replace($helpNeedle, $helpReplacement, $code, $helpReplacements);
        }

        $code = preg_replace('/^<\?php\s*/', '', $code, 1) ?? $code;
        eval($code);
        return;
    }

    if ($class === 'AeraEmu\\GameServer') {
        $code = file_get_contents($path);
        if ($code === false) {
            throw new \RuntimeException('Unable to load GameServer.php');
        }

        // Console patch: lets trusted local control clients (including the
        // Discord bot) run the same item grant logic across every authenticated
        // online player without exposing the game socket command publicly.
        $needle = "        if(\$name==='help'){";
        $dropAll = <<<'PHP'
        if($name==='dropall'){
            $parts=preg_split('/\s+/',trim($args))?:[];
            $itemId=(int)($parts[0]??0);$qty=(int)($parts[1]??0);
            if($itemId<=0||$qty<=0)return ['ok'=>false,'message'=>'Usage: dropall <item id> <amount>'];
            $item=$this->world->items[$itemId]??$this->db->one('SELECT * FROM items WHERE id=? LIMIT 1',[$itemId]);
            if(!$item)return ['ok'=>false,'message'=>'Unknown item ID '.$itemId.'.'];
            $online=array_values(array_filter($this->clients,static fn($c)=>$c->authenticated));
            if(!$online)return ['ok'=>false,'message'=>'There are no players currently online.'];
            $given=0;$failed=0;$actual=0;
            foreach($online as $target){
                $result=$this->router->grantItemToPlayer($target->dbId,$itemId,$qty,'Discord /dropall');
                if(!empty($result['ok'])){$given++;$actual+=(int)($result['quantity']??0);}else{$failed++;}
            }
            $message='Dropall: gave '.$actual.' x '.$item['Name'].' to '.$given.' of '.count($online).' online player(s).';
            if($failed>0)$message.=' '.$failed.' player(s) could not receive it (for example, a full stack).';
            $this->log->warn('Discord /dropall executed: item='.$itemId.' amount='.$qty.' players='.$given.' failed='.$failed.' total='.$actual);
            return ['ok'=>true,'message'=>$message];
        }
PHP;
        if (!str_contains($code, "if(\$name==='dropall')") && str_contains($code, $needle)) {
            $dropAllCount = 0;
            $code = str_replace($needle, $dropAll.$needle, $code, $dropAllCount);
            $helpNeedle = 'Commands: status, players, rooms, say <message>, reload, clear all, safe-shutdown [seconds], cancel-shutdown, restart, stop';
            $helpReplacement = $helpNeedle.', dropall <item id> <amount>';
            $helpReplacements = 0;
            $code = str_replace($helpNeedle, $helpReplacement, $code, $helpReplacements);
        }

        $code = preg_replace('/^<\?php\s*/', '', $code, 1) ?? $code;
        eval($code);
        return;
    }

    require $path;
});
