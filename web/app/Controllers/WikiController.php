<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Config;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\View;
use Throwable;

final class WikiController
{
    private const TYPES = ['items','maps','monsters','quests'];

    public function index(Request $r): void
    {
        $type = strtolower(trim((string)$r->input('type','items')));
        if (!in_array($type,self::TYPES,true)) $type='items';
        $id = max(0,(int)$r->input('id',0));
        $q = trim((string)$r->input('q',''));
        $page = max(1,(int)$r->input('page',1));

        $detail = null; $related = []; $total = 0; $rows = [];
        if ($id > 0) {
            $detail = $this->detail($type,$id,$related);
        } else {
            [$rows,$total] = $this->listing($type,$q,$page);
        }

        $counts=[];
        foreach(self::TYPES as $t) {
            try { $counts[$t]=(int)Database::scalar('SELECT COUNT(*) FROM `'.$t.'`',[],0); }
            catch(Throwable) { $counts[$t]=0; }
        }
        View::render('wiki',['type'=>$type,'id'=>$id,'q'=>$q,'page'=>$page,'rows'=>$rows,'total'=>$total,'detail'=>$detail,'related'=>$related,'counts'=>$counts]);
    }

    /**
     * Serves a SWF through PHP so the wiki preview does not depend on IIS
     * resolving a non-existent /gamefiles/<basename>.swf URL. The database
     * can store a basename while the real file may live in a nested folder.
     */
    public function gamefile(Request $r): never
    {
        $name = trim(str_replace('\\','/',(string)$r->input('file','')));
        if ($name === '' || str_contains($name,'..') || !preg_match('/\.swf$/i',$name)) {
            Response::abort(404,'SWF not found.');
        }

        $public = (string)Config::get('paths.public');
        $root = rtrim($public,'/\\') . DIRECTORY_SEPARATOR . 'gamefiles';
        if (!is_dir($root)) Response::abort(404,'SWF directory not found.');

        $namePath = trim(str_replace('\\','/',ltrim($name,'/')));
        if (str_starts_with(strtolower($namePath),'gamefiles/')) {
            $namePath = substr($namePath,10);
        }

        // Only allow safe relative paths when a caller supplies a folder.
        $candidate = $root . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $namePath);
        if (is_file($candidate)) {
            $this->streamSwf($candidate);
        }

        // If the database stores only a basename (e.g. NewWarriorB2.swf),
        // search the complete gamefiles tree for an exact filename match.
        $basename = basename($namePath);
        $matches = [];
        try {
            $iterator = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($root, \FilesystemIterator::SKIP_DOTS),
                \RecursiveIteratorIterator::LEAVES_ONLY
            );
            foreach ($iterator as $file) {
                if ($file->isFile() && strcasecmp($file->getFilename(),$basename) === 0) {
                    $matches[] = $file->getPathname();
                }
            }
        } catch(Throwable) {
            $matches = [];
        }

        if (!$matches) Response::abort(404,'SWF not found.');

        // Prefer the male class asset for class SWFs when both genders exist.
        usort($matches, static function(string $a,string $b): int {
            $al = strtolower(str_replace('\\','/',$a));
            $bl = strtolower(str_replace('\\','/',$b));
            $ap = str_contains($al,'/gamefiles/classes/m/') ? 0 : 1;
            $bp = str_contains($bl,'/gamefiles/classes/m/') ? 0 : 1;
            return $ap <=> $bp ?: strcmp($al,$bl);
        });

        $this->streamSwf($matches[0]);
    }

    private function streamSwf(string $path): never
    {
        if (!is_file($path) || !is_readable($path)) Response::abort(404,'SWF not found.');
        header('Content-Type: application/x-shockwave-flash');
        header('Content-Length: ' . (string)filesize($path));
        header('Cache-Control: public, max-age=86400');
        header('X-Content-Type-Options: nosniff');
        readfile($path);
        exit;
    }

    private function listing(string $type,string $q,int $page): array
    {
        $limit=50; $offset=($page-1)*$limit; $where=''; $params=[]; $name='Name';
        if($q!=='') { $where=' WHERE `Name` LIKE ? '; $params[]='%'.$q.'%'; }
        $queries=[
            'items'=>"SELECT id,Name,Type,Equipment,Level,Cost,Coins,Rarity,Description FROM items{$where} ORDER BY Name ASC LIMIT {$limit} OFFSET {$offset}",
            'maps'=>"SELECT id,Name,File,MaxPlayers,ReqLevel,PvP,Upgrade FROM maps{$where} ORDER BY Name ASC LIMIT {$limit} OFFSET {$offset}",
            'monsters'=>"SELECT id,Name,Level,Health,Gold,Coin,Experience,ClassPoint,Reputation,DPS FROM monsters{$where} ORDER BY Name ASC LIMIT {$limit} OFFSET {$offset}",
            'quests'=>"SELECT id,Name,Level,Description,Experience,Gold,Coins,Reputation,ClassPoints,Upgrade,Once FROM quests{$where} ORDER BY Name ASC LIMIT {$limit} OFFSET {$offset}",
        ];
        unset($name);
        try { $rows=Database::all($queries[$type],$params); $total=(int)Database::scalar('SELECT COUNT(*) FROM `'.$type.'`'.($q!==''?' WHERE `Name` LIKE ?':''),$q!==''?['%'.$q.'%']:[],0); return [$rows,$total]; }
        catch(Throwable) { return [[],0]; }
    }

    private function detail(string $type,int $id,array &$related): ?array
    {
        try {
            if($type==='items') {
                $d=Database::one('SELECT i.*,e.Name EnhancementName,ep.Wisdom,ep.Strength,ep.Luck,ep.Dexterity,ep.Endurance,ep.Intelligence FROM items i LEFT JOIN enhancements e ON e.id=i.EnhID LEFT JOIN enhancements_patterns ep ON ep.id=e.PatternID WHERE i.id=? LIMIT 1',[$id]);
                if(!$d) return null;
                $related['shops']=Database::all('SELECT s.id,s.Name,si.QuantityRemain FROM shops_items si INNER JOIN shops s ON s.id=si.ShopID WHERE si.ItemID=? ORDER BY s.Name',[$id]);
                $related['maps']=Database::all('SELECT m.id,m.Name FROM maps_items mi INNER JOIN maps m ON m.id=mi.MapID WHERE mi.ItemID=? ORDER BY m.Name',[$id]);
                $related['drops']=Database::all('SELECT mo.id,mo.Name,md.Quantity,md.Chance FROM monsters_drops md INNER JOIN monsters mo ON mo.id=md.MonsterID WHERE md.ItemID=? ORDER BY mo.Name',[$id]);
                $related['questRewards']=Database::all('SELECT q.id,q.Name,qr.Quantity,qr.Rate FROM quests_rewards qr INNER JOIN quests q ON q.id=qr.QuestID WHERE qr.ItemID=? ORDER BY q.Name',[$id]);
                $related['requirements']=Database::all('SELECT i2.id,i2.Name,ir.Quantity FROM items_requirements ir INNER JOIN items i2 ON i2.id=ir.ReqItemID WHERE ir.ItemID=? ORDER BY i2.Name',[$id]);
                return $d;
            }
            if($type==='maps') {
                $d=Database::one('SELECT * FROM maps WHERE id=? LIMIT 1',[$id]); if(!$d) return null;
                $related['monsters']=Database::all('SELECT mo.id,mo.Name,mm.MonMapID,mm.Frame,mm.X,mm.Y,mm.Aggresive FROM maps_monsters mm INNER JOIN monsters mo ON mo.id=mm.MonsterID WHERE mm.MapID=? AND mm.Enabled=1 ORDER BY mo.Name,mm.MonMapID',[$id]);
                $related['npcs']=Database::all('SELECT n.id,n.Name,mn.NpcMapID,mn.Frame,mn.X,mn.Y FROM maps_npc mn INNER JOIN npcs n ON n.id=mn.NpcID WHERE mn.MapID=? ORDER BY n.Name,mn.NpcMapID',[$id]);
                $related['items']=Database::all('SELECT i.id,i.Name,i.Type FROM maps_items mi INNER JOIN items i ON i.id=mi.ItemID WHERE mi.MapID=? ORDER BY i.Name',[$id]);
                $related['arrows']=Database::all('SELECT ma.*,tm.Name TargetMapName FROM maps_arrows ma LEFT JOIN maps tm ON tm.id=ma.TargetMapID WHERE ma.MapID=? AND ma.Enabled=1 ORDER BY ma.Frame,ma.id',[$id]);
                return $d;
            }
            if($type==='monsters') {
                $d=Database::one('SELECT * FROM monsters WHERE id=? LIMIT 1',[$id]); if(!$d) return null;
                $related['maps']=Database::all('SELECT m.id,m.Name,mm.MonMapID,mm.Frame,mm.X,mm.Y,mm.Aggresive FROM maps_monsters mm INNER JOIN maps m ON m.id=mm.MapID WHERE mm.MonsterID=? AND mm.Enabled=1 ORDER BY m.Name,mm.MonMapID',[$id]);
                $related['drops']=Database::all('SELECT i.id,i.Name,i.Type,md.Quantity,md.Chance FROM monsters_drops md INNER JOIN items i ON i.id=md.ItemID WHERE md.MonsterID=? ORDER BY i.Name',[$id]);
                $related['skills']=Database::all('SELECT s.id,s.Name,s.Description FROM monsters_skills ms INNER JOIN skills s ON s.id=ms.SkillID WHERE ms.MonsterID=? ORDER BY s.Name',[$id]);
                return $d;
            }
            $d=Database::one('SELECT q.*,f.Name FactionName FROM quests q LEFT JOIN factions f ON f.id=q.FactionID WHERE q.id=? LIMIT 1',[$id]); if(!$d) return null;
            $related['requiredItems']=Database::all('SELECT i.id,i.Name,qr.Quantity FROM quests_required_items qr INNER JOIN items i ON i.id=qr.ItemID WHERE qr.QuestID=? ORDER BY i.Name',[$id]);
            if(!$related['requiredItems']) $related['requiredItems']=Database::all('SELECT i.id,i.Name,qr.Quantity FROM quests_requirements qr INNER JOIN items i ON i.id=qr.ItemID WHERE qr.QuestID=? ORDER BY i.Name',[$id]);
            $related['rewards']=Database::all('SELECT i.id,i.Name,i.Type,qr.Quantity,qr.Rate,qr.RewardType FROM quests_rewards qr INNER JOIN items i ON i.id=qr.ItemID WHERE qr.QuestID=? ORDER BY i.Name',[$id]);
            $related['sourceNpc']=[];
            try { $related['sourceNpc']=Database::all("SELECT DISTINCT n.id,n.Name,m.id MapID,m.Name MapName FROM npcs_buttons nb INNER JOIN npcs n ON n.id=nb.NPCID INNER JOIN maps_npc mn ON mn.NpcID=n.id INNER JOIN maps m ON m.id=mn.MapID WHERE (LOWER(nb.Action) LIKE '%quest%' OR LOWER(nb.Text) LIKE '%quest%') AND nb.Value=? ORDER BY m.Name,n.Name",[(string)$id]); } catch(Throwable) {}
            return $d;
        } catch(Throwable) { return null; }
    }
}
