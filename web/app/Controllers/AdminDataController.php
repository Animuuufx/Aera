<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Auth;
use Aera\Foundation\Csrf;
use Aera\Foundation\Config;
use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\Session;
use Aera\Foundation\View;
use PDO;
use Throwable;

final class AdminDataController
{
    private ?array $tableCache = null;

    private function tables(): array
    {
        if($this->tableCache !== null) return $this->tableCache;
        $this->tableCache=[];
        $rows=Database::connection()->query('SHOW TABLES')->fetchAll(PDO::FETCH_NUM);
        foreach($rows as $row){
            $actual=(string)($row[0]??'');
            if($actual!=='') $this->tableCache[strtolower($actual)]=$actual;
        }
        return $this->tableCache;
    }
    private function tableIfExists(string $table): ?string
    {
        if(!preg_match('/^[A-Za-z0-9_]+$/',$table)) return null;
        return $this->tables()[strtolower($table)]??null;
    }
    /**
     * Keep the NPC image columns available even when the administrator copied
     * the patch but has not visited /setup yet. This only runs for the NPC
     * table and only adds columns that are actually missing.
     */
    private function ensureNpcImageColumns(string $table): void
    {
        if(strtolower($table)!=='npcs') return;
        try{
            $stmt=Database::connection()->query("SHOW COLUMNS FROM `{$table}`");
            $rows=$stmt?$stmt->fetchAll(PDO::FETCH_ASSOC):[];
            $have=[];foreach($rows as $row){$f=(string)($row['Field']??'');if($f!=='')$have[strtolower($f)]=true;}
            $adds=[];
            if(!isset($have['image']))$adds[]="ADD COLUMN `Image` varchar(255) NULL DEFAULT NULL AFTER `GroundID`";
            if(!isset($have['imagescale']))$adds[]="ADD COLUMN `ImageScale` double NOT NULL DEFAULT 1 AFTER `Image`";
            if(!isset($have['imageoffsetx']))$adds[]="ADD COLUMN `ImageOffsetX` double NOT NULL DEFAULT 0 AFTER `ImageScale`";
            if(!isset($have['imageoffsety']))$adds[]="ADD COLUMN `ImageOffsetY` double NOT NULL DEFAULT 0 AFTER `ImageOffsetX`";
            if($adds)Database::connection()->exec("ALTER TABLE `{$table}` ".implode(', ',$adds));
        }catch(Throwable $e){
            // The normal form/database error path will still explain any DB
            // permission problem; do not turn every admin page into a 500 here.
        }
    }

    private function tableName(string $table): string
    {
        $actual=$this->tableIfExists($table);
        if($actual!==null){
            $this->ensureNpcImageColumns($actual);
            return $actual;
        }
        Response::abort(404,'Unknown table');
    }
    private function columns(string $table): array
    {
        $stmt = Database::connection()->query("SHOW FULL COLUMNS FROM `{$table}`");
        return $stmt ? $stmt->fetchAll(PDO::FETCH_ASSOC) : [];
    }
    private function primary(string $table): array
    {
        // MySQL 5.7 SHOW KEYS supports WHERE but not ORDER BY. The previous
        // query appended ORDER BY Seq_in_index, which caused every
        // /admin/data/{table} page to throw SQL syntax error 1064.
        $stmt = Database::connection()->query("SHOW KEYS FROM `{$table}` WHERE Key_name='PRIMARY'");
        $rows = $stmt ? $stmt->fetchAll(PDO::FETCH_ASSOC) : [];

        usort($rows, static function (array $a, array $b): int {
            $aSeq = (int)($a['Seq_in_index'] ?? $a['SEQ_IN_INDEX'] ?? 0);
            $bSeq = (int)($b['Seq_in_index'] ?? $b['SEQ_IN_INDEX'] ?? 0);
            return $aSeq <=> $bSeq;
        });

        $primary = [];
        foreach ($rows as $row) {
            $column = $row['Column_name'] ?? $row['COLUMN_NAME'] ?? null;
            if ($column !== null) $primary[] = (string)$column;
        }
        return $primary;
    }
    private function relationDefinition(string $table,string $field): ?array
    {
        $t=strtolower($table);$f=strtolower($field);

        // Runtime placement identifiers are not foreign keys. They must remain
        // freely editable because they identify an instance inside one map.
        if(in_array($f,['npcmapid','monmapid'],true)) return null;

        // NPC equipment is a real items relation, but each slot should only
        // offer compatible equipment rather than thousands of unrelated items.
        if($t==='npcs'){
            $npcSlots=[
                'weaponid'=>['table'=>'items','where'=>"LOWER(`Equipment`)='weapon'"],
                'armorid'=>['table'=>'items','where'=>"LOWER(`Equipment`) IN ('co','ar') OR LOWER(`Type`)='class'"],
                'helmid'=>['table'=>'items','where'=>"LOWER(`Equipment`)='he'"],
                'capeid'=>['table'=>'items','where'=>"LOWER(`Equipment`)='ba'"],
                'groundid'=>['table'=>'items','where'=>"LOWER(`Equipment`)='mi'"],
            ];
            if(isset($npcSlots[$f])) return $npcSlots[$f];
        }

        // A class record points at the class item that owns the armor SWF.
        // Limit this selector to actual class/armor items and show its file.
        if($t==='classes' && $f==='itemid'){
            return [
                'table'=>'items',
                'where'=>"LOWER(`Type`)='class' OR LOWER(`Equipment`)='ar'",
                'labels'=>['Name','File'],
            ];
        }

        // Aera's older schemas rarely declare physical FOREIGN KEY constraints,
        // so the admin editor also understands the conventional *ID columns.
        $map=[
            'achievementid'=>'achievements','auraid'=>'auras','classid'=>'classes',
            'reqclassid'=>'classes','enhid'=>'enhancements','enhancementid'=>'enhancements',
            'factionid'=>'factions','friendid'=>'users','guildid'=>'guilds','hairid'=>'hairs',
            'hairshopid'=>'hairs_shops','itemid'=>'items','reqitemid'=>'items','mapid'=>'maps','targetmapid'=>'maps',
            'monsterid'=>'monsters','npcid'=>'npcs','questid'=>'quests','redeemid'=>'redeems',
            'shopid'=>'shops','skillid'=>'skills','titleid'=>'titles','userid'=>'users',
            'buyerid'=>'users','ownerid'=>'users','fromuserid'=>'users','touserid'=>'users',
            'authorid'=>'users','adminuserid'=>'users','warid'=>'wars','patternid'=>'enhancements_patterns',
        ];
        if(isset($map[$f])) return ['table'=>$map[$f]];
        if($t==='admin_commands' && $f==='requestedby') return ['table'=>'users'];
        return null;
    }
    private function relationLabelColumns(string $target,array $columns): array
    {
        $available=[];foreach($columns as $c)$available[strtolower((string)$c['Field'])]=(string)$c['Field'];
        $specific=[
            'users'=>['Name','Email'],'items'=>['Name','Type'],'maps'=>['Name','File'],
            'npcs'=>['Name','Job'],'quests'=>['Name'],'shops'=>['Name'],'monsters'=>['Name'],
            'skills'=>['Name'],'hairs'=>['Name','Gender'],'enhancements'=>['Name','Level'],
            'enhancements_patterns'=>['Name'],'factions'=>['Name'],'guilds'=>['Name'],
            'titles'=>['Name'],'achievements'=>['Name'],'auras'=>['Name'],'redeems'=>['Code'],
            'wars'=>['Name'],'hairs_shops'=>['Name'],'classes'=>['ItemID'],
        ];
        $preferred=$specific[strtolower($target)]??['Name','Title','Code','Email','Slug','Action','File'];
        $out=[];foreach($preferred as $name){$k=strtolower($name);if(isset($available[$k]))$out[]=$available[$k];if(count($out)>=2)break;}
        return $out;
    }
    private function relationOptions(string $table,array $columns): array
    {
        $relations=[];
        foreach($columns as $column){
            $field=(string)($column['Field']??'');if($field==='')continue;
            $def=$this->relationDefinition($table,$field);if($def===null)continue;
            $target=$this->tableIfExists((string)$def['table']);if($target===null)continue;
            $targetCols=$this->columns($target);$available=[];foreach($targetCols as $c)$available[strtolower((string)$c['Field'])]=(string)$c['Field'];
            $valueCol=$available['id']??null;if($valueCol===null)continue;
            $labels=[];
            if(!empty($def['labels'])&&is_array($def['labels'])){
                foreach($def['labels'] as $label){$key=strtolower((string)$label);if(isset($available[$key]))$labels[]=$available[$key];}
            }
            if(!$labels)$labels=$this->relationLabelColumns($target,$targetCols);
            $selectCols=array_values(array_unique(array_merge([$valueCol],$labels)));
            $sql='SELECT '.implode(',',array_map(fn($c)=>"`{$c}`",$selectCols))." FROM `{$target}`";
            if(!empty($def['where']))$sql.=' WHERE '.$def['where'];
            $order=$labels[0]??$valueCol;$sql.=" ORDER BY `{$order}` ASC LIMIT 10000";
            try{$rows=Database::all($sql);}catch(Throwable $e){continue;}
            $options=[];
            foreach($rows as $r){
                $id=$r[$valueCol]??null;if($id===null)continue;
                $parts=[];foreach($labels as $labelCol){$v=trim((string)($r[$labelCol]??''));if($v!==''&&!in_array($v,$parts,true))$parts[]=$v;}
                $label='#'.$id.($parts?' — '.implode(' · ',$parts):'');
                $options[]=['value'=>(string)$id,'label'=>$label];
            }
            $relations[$field]=['table'=>$target,'options'=>$options];
        }
        return $relations;
    }


    /** Build reusable live-database options for purpose-built admin controls. */
    private function lookupOptions(string $target,string $valueColumn='id',?array $preferredLabels=null,?string $where=null): array
    {
        $actual=$this->tableIfExists($target);if($actual===null)return [];
        $columns=$this->columns($actual);$available=[];foreach($columns as $c)$available[strtolower((string)$c['Field'])]=(string)$c['Field'];
        $valueActual=$available[strtolower($valueColumn)]??null;if($valueActual===null)return [];
        $labels=$preferredLabels??$this->relationLabelColumns($actual,$columns);$labelActual=[];
        foreach($labels as $label){$key=strtolower((string)$label);if(isset($available[$key]))$labelActual[]=$available[$key];}
        if(!$labelActual)$labelActual=$this->relationLabelColumns($actual,$columns);
        $select=array_values(array_unique(array_merge([$valueActual],$labelActual,isset($available['id'])?[$available['id']]:[])));
        $sql='SELECT '.implode(',',array_map(fn($c)=>"`{$c}`",$select))." FROM `{$actual}`";
        if($where!==null&&trim($where)!=='')$sql.=' WHERE '.$where;
        $order=$labelActual[0]??$valueActual;$sql.=" ORDER BY `{$order}` ASC LIMIT 10000";
        try{$rows=Database::all($sql);}catch(Throwable $e){return [];}
        $out=[];foreach($rows as $r){$value=$r[$valueActual]??null;if($value===null)continue;$parts=[];foreach($labelActual as $label){$v=trim((string)($r[$label]??''));if($v!==''&&!in_array($v,$parts,true))$parts[]=$v;}
            $prefix='';if(isset($available['id'])&&isset($r[$available['id']]))$prefix='#'.(string)$r[$available['id']].' — ';
            $out[]=['value'=>(string)$value,'label'=>$prefix.($parts?implode(' · ',$parts):(string)$value)];}
        return $out;
    }

    /**
     * Scan the deployed gamefiles tree, not a hard-coded list.
     * That means files uploaded through Asset Manager immediately appear here.
     */
    private function gamefileSwfs(string $relativeDir): array
    {
        $public=rtrim((string)Config::get('paths.public'),"/\\");
        $root=$public.'/gamefiles';
        $relativeDir=trim(str_replace('\\','/',$relativeDir),'/');
        $dir=$root.($relativeDir!==''?'/'.$relativeDir:'');

        if(!is_dir($dir))return [];

        $out=[];
        try{
            $iterator=new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($dir,\FilesystemIterator::SKIP_DOTS),
                \RecursiveIteratorIterator::LEAVES_ONLY
            );
            foreach($iterator as $file){
                if(!$file->isFile()||!preg_match('/\.swf$/i',$file->getFilename()))continue;
                $full=str_replace('\\','/',$file->getPathname());
                $rootNorm=rtrim(str_replace('\\','/',$root),'/').'/';
                if(stripos($full,$rootNorm)!==0)continue;
                $gamePath=substr($full,strlen($rootNorm));
                $out[]=[
                    'gamePath'=>$gamePath,
                    'name'=>basename($gamePath),
                    'folder'=>str_replace('\\','/',dirname($gamePath)),
                ];
            }
        }catch(Throwable $e){
            return [];
        }

        usort($out,static fn(array $a,array $b): int=>strnatcasecmp((string)$a['gamePath'],(string)$b['gamePath']));
        return $out;
    }

    /**
     * Scan deployed gamefiles for bitmap formats that Flash Player can load.
     * WebP/SVG are intentionally excluded; the legacy Flash Loader supports
     * PNG, JPEG and GIF directly.
     */
    private function gamefileImages(string $relativeDir=''): array
    {
        $public=rtrim((string)Config::get('paths.public'),"/\\");
        $root=$public.'/gamefiles';
        $relativeDir=trim(str_replace('\\','/',$relativeDir),'/');
        $dir=$root.($relativeDir!==''?'/'.$relativeDir:'');
        if(!is_dir($dir))return [];

        $out=[];
        try{
            $iterator=new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($dir,\FilesystemIterator::SKIP_DOTS),
                \RecursiveIteratorIterator::LEAVES_ONLY
            );
            foreach($iterator as $file){
                if(!$file->isFile()||!preg_match('/\.(png|jpe?g|gif)$/i',$file->getFilename()))continue;
                $full=str_replace('\\','/',$file->getPathname());
                $rootNorm=rtrim(str_replace('\\','/',$root),'/').'/';
                if(stripos($full,$rootNorm)!==0)continue;
                $gamePath=substr($full,strlen($rootNorm));
                $out[]=[
                    'value'=>$gamePath,
                    'label'=>$gamePath,
                    'folder'=>str_replace('\\','/',dirname($gamePath)),
                ];
            }
        }catch(Throwable $e){return [];}
        usort($out,static fn(array $a,array $b): int=>strnatcasecmp((string)$a['value'],(string)$b['value']));
        return $out;
    }

    /** Build the File-field picker for a database table. */
    private function gamefilePicker(string $table): ?array
    {
        $t=strtolower($table);
        $options=[];
        $help='Choose an SWF that already exists under gamefiles. Files uploaded through Asset Manager appear automatically.';

        $add=static function(array &$options,string $value,string $label,string $group=''): void {
            $value=trim(str_replace('\\','/',$value));
            if($value==='')return;
            $key=strtolower($value);
            if(isset($options[$key]))return;
            $options[$key]=['value'=>$value,'label'=>$label,'group'=>$group];
        };

        if($t==='maps'){
            foreach($this->gamefileSwfs('maps') as $file){
                $value=preg_replace('#^maps/#i','',(string)$file['gamePath'])??(string)$file['name'];
                $add($options,$value,'maps/'.$value,(string)$file['folder']);
            }
            $help='Map files are loaded from gamefiles/maps. The database stores the path relative to that maps folder.';
        }
        elseif(in_array($t,['monsters','monster'],true)){
            foreach($this->gamefileSwfs('mon') as $file){
                $value=preg_replace('#^mon/#i','',(string)$file['gamePath'])??(string)$file['name'];
                $add($options,$value,'mon/'.$value,(string)$file['folder']);
            }
            $help='Monster files are loaded from gamefiles/mon. The database stores the path relative to that folder.';
        }
        elseif(in_array($t,['hairs','hair'],true)){
            foreach($this->gamefileSwfs('hairs') as $file){
                $add($options,(string)$file['gamePath'],(string)$file['gamePath'],(string)$file['folder']);
            }
            $help='Hair files keep their gamefiles-relative path, such as hairs/M/Hair.swf or hairs/F/Hair.swf.';
        }
        elseif($t==='items'){
            // Normal equipment/assets load using a path relative to gamefiles.
            foreach($this->gamefileSwfs('items') as $file){
                $add($options,(string)$file['gamePath'],(string)$file['gamePath'],(string)$file['folder']);
            }

            // Armor/class items are different: the client adds classes/M or
            // classes/F itself, so the item File column stores only the basename.
            $classFiles=[];
            foreach($this->gamefileSwfs('classes') as $file){
                $name=(string)$file['name'];$key=strtolower($name);
                $gender='';
                if(preg_match('#^classes/([MF])/#i',(string)$file['gamePath'],$m))$gender=strtoupper($m[1]);
                if(!isset($classFiles[$key]))$classFiles[$key]=['name'=>$name,'genders'=>[]];
                if($gender!==''&&!in_array($gender,$classFiles[$key]['genders'],true))$classFiles[$key]['genders'][]=$gender;
            }
            foreach($classFiles as $class){
                sort($class['genders']);
                $coverage=$class['genders']?implode('/',$class['genders']):'class';
                $add($options,(string)$class['name'],'classes/'.$class['name'].' ['.$coverage.']','classes');
            }
            $help='All gamefiles/items SWFs are listed. Class/armor SWFs from classes/M and classes/F are also listed; class armor stores only the SWF filename because the client chooses M/F automatically. Pet files appear under items/pets.';
        }
        else{
            // Support custom/extended tables if they use the common asset names.
            $folderMap=[
                'pets'=>'items/pets','pet'=>'items/pets',
                'capes'=>'items/capes','cape'=>'items/capes',
                'helms'=>'items/helms','helm'=>'items/helms',
                'swords'=>'items/swords','axes'=>'items/axes','bows'=>'items/bows',
                'daggers'=>'items/daggers','guns'=>'items/guns','maces'=>'items/maces',
                'polearms'=>'items/polearms','staff'=>'items/staff','staves'=>'items/staves',
                'houses'=>'items/houses','house_items'=>'items/house',
            ];
            if(isset($folderMap[$t])){
                $folder=$folderMap[$t];
                foreach($this->gamefileSwfs($folder) as $file){
                    $add($options,(string)$file['gamePath'],(string)$file['gamePath'],(string)$file['folder']);
                }
            }else{
                return null;
            }
        }

        $options=array_values($options);
        usort($options,static fn(array $a,array $b): int=>strnatcasecmp((string)$a['label'],(string)$b['label']));
        return ['options'=>$options,'help'=>$help];
    }

    /** Return distinct non-empty values already used by a live table column. */
    private function distinctColumnValues(string $table,string $column): array
    {
        $actual=$this->tableIfExists($table);if($actual===null)return [];
        $cols=$this->columns($actual);$available=[];
        foreach($cols as $c)$available[strtolower((string)$c['Field'])]=(string)$c['Field'];
        $col=$available[strtolower($column)]??null;if($col===null)return [];
        try{
            $rows=Database::all("SELECT DISTINCT `{$col}` v FROM `{$actual}` WHERE `{$col}` IS NOT NULL AND TRIM(CAST(`{$col}` AS CHAR))<>'' ORDER BY `{$col}` ASC LIMIT 10000");
        }catch(Throwable $e){return [];}
        $out=[];
        foreach($rows as $row){$v=trim((string)($row['v']??''));if($v!==''&&!in_array($v,$out,true))$out[]=$v;}
        return $out;
    }

    /** Merge canonical values with values already present in the live database. */
    private function itemOptionList(array $canonical,array $live=[]): array
    {
        $out=[];$seen=[];
        foreach(array_merge($canonical,array_map(fn($v)=>['value'=>$v,'label'=>$v],$live)) as $entry){
            if(is_string($entry))$entry=['value'=>$entry,'label'=>$entry];
            $value=(string)($entry['value']??'');if($value==='')continue;
            $key=strtolower($value);if(isset($seen[$key]))continue;$seen[$key]=true;
            $out[]=['value'=>$value,'label'=>(string)($entry['label']??$value)];
        }
        return $out;
    }

    /** Full option metadata for the Items editor. */
    private function itemEditorDefinition(): array
    {
        $types=[
            ['value'=>'Sword','label'=>'Sword'],
            ['value'=>'Axe','label'=>'Axe'],
            ['value'=>'Dagger','label'=>'Dagger'],
            ['value'=>'Gun','label'=>'Gun'],
            ['value'=>'Bow','label'=>'Bow'],
            ['value'=>'Mace','label'=>'Mace'],
            ['value'=>'Polearm','label'=>'Polearm'],
            ['value'=>'Staff','label'=>'Staff'],
            ['value'=>'Wand','label'=>'Wand'],
            ['value'=>'Class','label'=>'Class'],
            ['value'=>'Armor','label'=>'Armor / Costume'],
            ['value'=>'Helm','label'=>'Helm'],
            ['value'=>'Cape','label'=>'Cape'],
            ['value'=>'Pet','label'=>'Pet'],
            ['value'=>'Ring','label'=>'Ring'],
            ['value'=>'Amulet','label'=>'Amulet'],
            ['value'=>'Necklace','label'=>'Necklace'],
            ['value'=>'Belt','label'=>'Belt'],
            ['value'=>'House','label'=>'House'],
            ['value'=>'Wall Item','label'=>'House Wall Item'],
            ['value'=>'Floor Item','label'=>'House Floor Item'],
            ['value'=>'Misc','label'=>'Ground / Misc'],
            ['value'=>'Item','label'=>'Item'],
            ['value'=>'Quest Item','label'=>'Quest Item'],
            ['value'=>'Resource','label'=>'Resource'],
            ['value'=>'Note','label'=>'Note'],
            ['value'=>'ServerUse','label'=>'Server Use'],
            ['value'=>'ClientUse','label'=>'Client Use'],
            ['value'=>'Enhancement','label'=>'Enhancement'],
            ['value'=>'Refinement','label'=>'Refinement'],
            ['value'=>'Egg','label'=>'Egg'],
        ];

        $icons=[
            ['value'=>'iwsword','label'=>'iwsword — Sword'],
            ['value'=>'iwaxe','label'=>'iwaxe — Axe'],
            ['value'=>'iwdagger','label'=>'iwdagger — Dagger'],
            ['value'=>'iwgun','label'=>'iwgun — Gun'],
            ['value'=>'iwbow','label'=>'iwbow — Bow'],
            ['value'=>'iwmace','label'=>'iwmace — Mace'],
            ['value'=>'iwpolearm','label'=>'iwpolearm — Polearm'],
            ['value'=>'iwstaff','label'=>'iwstaff — Staff'],
            ['value'=>'iwwand','label'=>'iwwand — Wand'],
            ['value'=>'iwarmor','label'=>'iwarmor — Armor'],
            ['value'=>'iiclass','label'=>'iiclass — Class'],
            ['value'=>'iihelm','label'=>'iihelm — Helm'],
            ['value'=>'iicape','label'=>'iicape — Cape'],
            ['value'=>'iipet','label'=>'iipet — Pet'],
            ['value'=>'iibag','label'=>'iibag — Generic item / bag'],
            ['value'=>'iidesign','label'=>'iidesign — Design / misc'],
            ['value'=>'iibook','label'=>'iibook — Book / class'],
            ['value'=>'iicrystal','label'=>'iicrystal — Crystal / currency'],
            ['value'=>'iipack','label'=>'iipack — Pack'],
            ['value'=>'ihhouse','label'=>'ihhouse — House'],
            ['value'=>'ihfloor','label'=>'ihfloor — Floor item'],
            ['value'=>'ihwall','label'=>'ihwall — Wall item'],
            ['value'=>'icbxp','label'=>'icbxp — XP boost'],
            ['value'=>'icbgold','label'=>'icbgold — Gold boost'],
            ['value'=>'icbrep','label'=>'icbrep — Reputation boost'],
            ['value'=>'icbcp','label'=>'icbcp — Class-point boost'],
            ['value'=>'ich1','label'=>'ich1 — Consumable / potion'],
        ];

        $equipment=[
            ['value'=>'None','label'=>'None — non-equipment'],
            ['value'=>'Weapon','label'=>'Weapon'],
            ['value'=>'ar','label'=>'ar — Class armor'],
            ['value'=>'co','label'=>'co — Armor / costume'],
            ['value'=>'he','label'=>'he — Helm'],
            ['value'=>'ba','label'=>'ba — Cape / back'],
            ['value'=>'pe','label'=>'pe — Pet'],
            ['value'=>'am','label'=>'am — Amulet / accessory'],
            ['value'=>'mi','label'=>'mi — Misc / ground preview'],
            ['value'=>'ho','label'=>'ho — House'],
            ['value'=>'hi','label'=>'hi — House item'],
            ['value'=>'en','label'=>'en — Legacy equipment slot'],
            ['value'=>'tt','label'=>'tt — Legacy equipment slot'],
            ['value'=>'gd','label'=>'gd — Legacy equipment slot'],
            ['value'=>'enh','label'=>'enh — Enhancement slot'],
        ];

        $elements=[
            ['value'=>'None','label'=>'None'],
            ['value'=>'Physical','label'=>'Physical'],
            ['value'=>'Fire','label'=>'Fire'],
            ['value'=>'Water','label'=>'Water'],
            ['value'=>'Ice','label'=>'Ice'],
            ['value'=>'Energy','label'=>'Energy'],
            ['value'=>'Earth','label'=>'Earth'],
            ['value'=>'Wind','label'=>'Wind'],
            ['value'=>'Light','label'=>'Light'],
            ['value'=>'Darkness','label'=>'Darkness'],
            ['value'=>'Chaos','label'=>'Chaos'],
        ];

        // These values exactly match Game.getRarityString() in the client.
        $rarities=[
            ['value'=>'0','label'=>'0 — Unknown'],
            ['value'=>'10','label'=>'10 — Unknown'],
            ['value'=>'11','label'=>'11 — Common'],
            ['value'=>'12','label'=>'12 — Weird'],
            ['value'=>'13','label'=>'13 — Awesome'],
            ['value'=>'14','label'=>'14 — 1% Drop'],
            ['value'=>'15','label'=>'15 — 5% Drop'],
            ['value'=>'16','label'=>'16 — Boss Drop'],
            ['value'=>'17','label'=>'17 — Secret'],
            ['value'=>'18','label'=>'18 — Junk'],
            ['value'=>'19','label'=>'19 — Impossible'],
            ['value'=>'20','label'=>'20 — Artifact'],
            ['value'=>'21','label'=>'21 — Limited Time Drop'],
            ['value'=>'23','label'=>'23 — Crazy'],
            ['value'=>'24','label'=>'24 — Expensive'],
            ['value'=>'30','label'=>'30 — Rare'],
            ['value'=>'35','label'=>'35 — Epic'],
            ['value'=>'40','label'=>'40 — Import Item'],
            ['value'=>'50','label'=>'50 — Seasonal Item'],
            ['value'=>'55','label'=>'55 — Seasonal Rare'],
            ['value'=>'60','label'=>'60 — Event Item'],
            ['value'=>'65','label'=>'65 — Event Rare'],
            ['value'=>'68','label'=>'68 — New Collection Chest'],
            ['value'=>'70','label'=>'70 — Limited Rare'],
            ['value'=>'75','label'=>"75 — Collector's Rare"],
            ['value'=>'80','label'=>'80 — Promotional Item'],
            ['value'=>'90','label'=>'90 — Ultra Rare'],
            ['value'=>'95','label'=>'95 — Super Mega Ultra Rare'],
            ['value'=>'100','label'=>'100 — Legendary Item'],
        ];

        return [
            'type'=>$this->itemOptionList($types,$this->distinctColumnValues('items','Type')),
            'icon'=>$this->itemOptionList($icons,$this->distinctColumnValues('items','Icon')),
            'equipment'=>$this->itemOptionList($equipment,$this->distinctColumnValues('items','Equipment')),
            'element'=>$this->itemOptionList($elements,$this->distinctColumnValues('items','Element')),
            'rarity'=>$this->itemOptionList($rarities,$this->distinctColumnValues('items','Rarity')),
            'quests'=>$this->lookupOptions('quests','id',['Name']),
            'links'=>$this->distinctColumnValues('items','Link'),
            'meta'=>$this->distinctColumnValues('items','Meta'),
            'typeDefaults'=>[
                'Sword'=>['icon'=>'iwsword','equipment'=>'Weapon'],
                'Axe'=>['icon'=>'iwaxe','equipment'=>'Weapon'],
                'Dagger'=>['icon'=>'iwdagger','equipment'=>'Weapon'],
                'Gun'=>['icon'=>'iwgun','equipment'=>'Weapon'],
                'Bow'=>['icon'=>'iwbow','equipment'=>'Weapon'],
                'Mace'=>['icon'=>'iwmace','equipment'=>'Weapon'],
                'Polearm'=>['icon'=>'iwpolearm','equipment'=>'Weapon'],
                'Staff'=>['icon'=>'iwstaff','equipment'=>'Weapon'],
                'Wand'=>['icon'=>'iwwand','equipment'=>'Weapon'],
                'Class'=>['icon'=>'iiclass','equipment'=>'ar'],
                'Armor'=>['icon'=>'iwarmor','equipment'=>'co'],
                'Helm'=>['icon'=>'iihelm','equipment'=>'he'],
                'Cape'=>['icon'=>'iicape','equipment'=>'ba'],
                'Pet'=>['icon'=>'iipet','equipment'=>'pe'],
                'House'=>['icon'=>'ihhouse','equipment'=>'ho'],
                'Wall Item'=>['icon'=>'ihwall','equipment'=>'hi'],
                'Floor Item'=>['icon'=>'ihfloor','equipment'=>'hi'],
                'Misc'=>['icon'=>'iidesign','equipment'=>'mi'],
                'Item'=>['icon'=>'iibag','equipment'=>'None'],
                'Quest Item'=>['icon'=>'iibag','equipment'=>'None'],
                'Resource'=>['icon'=>'iibag','equipment'=>'None'],
                'Note'=>['icon'=>'iibag','equipment'=>'None'],
                'ServerUse'=>['icon'=>'iibag','equipment'=>'None'],
                'ClientUse'=>['icon'=>'iibag','equipment'=>'None'],
                'Egg'=>['icon'=>'iibag','equipment'=>'None'],
                'Enhancement'=>['icon'=>'iidesign','equipment'=>'enh'],
                'Refinement'=>['icon'=>'iidesign','equipment'=>'enh'],
            ],
        ];
    }

    /** Metadata used by the richer NPC / NPC-button / placement editors. */
    private function editorDefinition(string $table): array
    {
        $t=strtolower($table);$out=['kind'=>$t];
        $filePicker=$this->gamefilePicker($table);
        if($filePicker!==null)$out['filePicker']=$filePicker;
        if($t==='items')$out['itemFields']=$this->itemEditorDefinition();
        if($t==='npcs'){
            // NPC image assets live in one predictable location. The create/edit
            // form also has a direct uploader that writes to gamefiles/npcs.
            $out['npcImages']=$this->gamefileImages('npcs');
        }
        if($t==='npcs_buttons'){
            $out['actions']=[
                ['value'=>'Shop','label'=>'Shop','mode'=>'single','target'=>'shops','help'=>'Select a shop.'],
                ['value'=>'HairShop','label'=>'Hair Shop','mode'=>'single','target'=>'hairs_shops','help'=>'Select a hair shop.'],
                ['value'=>'Enhancement','label'=>'Enhancement','mode'=>'single','target'=>'enhancements','help'=>'Select an enhancement entry.'],
                ['value'=>'Quest','label'=>'Quest(s)','mode'=>'multi','target'=>'quests','help'=>'Select one or more quests.'],
                ['value'=>'Join','label'=>'Join Map','mode'=>'join','target'=>'maps','help'=>'Select a map, frame/cell and pad.'],
                ['value'=>'Bank','label'=>'Bank','mode'=>'none','help'=>'No value is required.'],
                ['value'=>'Auction','label'=>'Auction','mode'=>'none','help'=>'No value is required.'],
                ['value'=>'GuildList','label'=>'Guild List','mode'=>'none','help'=>'No value is required.'],
                ['value'=>'Redeem','label'=>'Redeem','mode'=>'none','help'=>'No value is required.'],
                ['value'=>'Outfits','label'=>'Outfits','mode'=>'none','help'=>'No value is required.'],
                ['value'=>'DailyLogin','label'=>'Daily Login','mode'=>'none','help'=>'Recognized legacy action; current client may show the disabled-action notice.'],
                ['value'=>'WorldBoss','label'=>'World Boss','mode'=>'none','help'=>'Recognized legacy action; current client may show the disabled-action notice.'],
                ['value'=>'BattlePass','label'=>'Battle Pass','mode'=>'none','help'=>'Recognized legacy action; current client may show the disabled-action notice.'],
            ];
            $out['valueOptions']=[
                'Shop'=>$this->lookupOptions('shops','id',['Name']),
                'HairShop'=>$this->lookupOptions('hairs_shops','id',['Name']),
                'Enhancement'=>$this->lookupOptions('enhancements','id',['Name','Level']),
                'Quest'=>$this->lookupOptions('quests','id',['Name']),
                'Join'=>$this->lookupOptions('maps','Name',['Name','File']),
            ];
            $icons=['iwarmor','iwsword','iwaxe','iwbow','iwdagger','iwgun','iwmace','iwpolearm','iwstaff','iihelm','iibag','iiclass','iidesign','iicrystal','ich1','ihhouse','ihfloor','icbgold','icbxp','icbrep','icbcp'];
            foreach(['items','npcs_buttons'] as $iconTable){$actual=$this->tableIfExists($iconTable);if($actual===null)continue;$available=[];foreach($this->columns($actual) as $c)$available[strtolower((string)$c['Field'])]=(string)$c['Field'];$col=$available['icon']??null;if($col===null)continue;try{$rows=Database::all("SELECT DISTINCT `{$col}` IconValue FROM `{$actual}` WHERE `{$col}` IS NOT NULL AND `{$col}`<>'' ORDER BY `{$col}`");foreach($rows as $r){$v=trim((string)($r['IconValue']??''));if($v!=='')$icons[]=$v;}}catch(Throwable $e){}}
            $icons=array_values(array_unique(array_filter($icons)));natcasesort($icons);$out['icons']=array_values($icons);
        }
        if($t==='npcs_buttons'||$t==='maps_npc'||$t==='maps_npcs'||$t==='maps_arrows'||$t==='maps_monsters'){
            $out['mapCells']=$this->mapCellEditorData();
        }
        return $out;
    }

    /** Known map frames/pads used by Join, NPC placement, and map-arrow forms. */
    private function mapCellEditorData(): array
    {
        $maps=$this->tableIfExists('maps');if($maps===null)return [];
        $out=[];try{$mapRows=Database::all("SELECT id,Name FROM `{$maps}` ORDER BY Name");}catch(Throwable $e){return [];}
        foreach($mapRows as $m){$id=(int)($m['id']??0);$name=(string)($m['Name']??'');if($id<=0||$name==='')continue;$out[(string)$id]=['id'=>$id,'name'=>$name,'cells'=>[]];}

        $addCell=static function(array &$out,int $mapId,string $frame,string $pad='Spawn'): void {
            $id=(string)$mapId;if(!isset($out[$id]))return;$frame=trim($frame);$pad=trim($pad);if($frame==='')return;if($pad==='')$pad='Spawn';$key=strtolower($frame.'|'.$pad);$out[$id]['cells'][$key]=['frame'=>$frame,'pad'=>$pad];
        };

        $cells=$this->tableIfExists('maps_cells');if($cells!==null){try{foreach(Database::all("SELECT MapID,Frame,Pad FROM `{$cells}` ORDER BY MapID,Frame,Pad") as $r)$addCell($out,(int)($r['MapID']??0),(string)($r['Frame']??''),(string)($r['Pad']??'Spawn'));}catch(Throwable $e){}}
        foreach(['maps_npcs','maps_npc'] as $pt){$actual=$this->tableIfExists($pt);if($actual===null)continue;try{foreach(Database::all("SELECT MapID,Frame FROM `{$actual}` WHERE Frame IS NOT NULL AND Frame<>'' ORDER BY MapID,Frame") as $r)$addCell($out,(int)($r['MapID']??0),(string)($r['Frame']??''),'Spawn');}catch(Throwable $e){}}
        $monsters=$this->tableIfExists('maps_monsters');if($monsters!==null){try{foreach(Database::all("SELECT MapID,Frame FROM `{$monsters}` WHERE Frame IS NOT NULL AND Frame<>'' ORDER BY MapID,Frame") as $r)$addCell($out,(int)($r['MapID']??0),(string)($r['Frame']??''),'Spawn');}catch(Throwable $e){}}
        $arrows=$this->tableIfExists('maps_arrows');if($arrows!==null){try{foreach(Database::all("SELECT MapID,Frame,TargetType,TargetMapID,TargetFrame,TargetPad FROM `{$arrows}` ORDER BY MapID,Frame,id") as $r){$addCell($out,(int)($r['MapID']??0),(string)($r['Frame']??''),'Spawn');$targetMap=(strcasecmp((string)($r['TargetType']??'Room'),'Map')===0)?(int)($r['TargetMapID']??0):(int)($r['MapID']??0);$addCell($out,$targetMap,(string)($r['TargetFrame']??''),(string)($r['TargetPad']??'Spawn'));}}catch(Throwable $e){}}
        foreach($out as &$map){$key='enter|spawn';if(!isset($map['cells'][$key]))$map['cells'][$key]=['frame'=>'Enter','pad'=>'Spawn'];$map['cells']=array_values($map['cells']);}unset($map);
        return $out;
    }

    private function normalizeSpecialData(string $table,array $data): array
    {
        $t=strtolower($table);
        if($t==='npcs'){
            if(array_key_exists('Gender',$data))$data['Gender']=str_starts_with(strtoupper(trim((string)$data['Gender'])),'F')?'F':'M';
            foreach(['ColorHair','ColorSkin','ColorEye','ColorBase','ColorTrim','ColorAccessory'] as $field){if(!array_key_exists($field,$data))continue;$v=trim((string)$data[$field]);if($v===''){ $data[$field]=null; continue; }if(str_starts_with(strtolower($v),'0x'))$v=substr($v,2);elseif(str_starts_with($v,'#'))$v=substr($v,1);$v=preg_replace('/[^0-9a-f]/i','',$v)??'';$data[$field]=$v===''?null:'0x'.strtoupper(str_pad(substr($v,-6),6,'0',STR_PAD_LEFT));}
            foreach(['Level','Health','Mana','DPS','WeaponID','ArmorID','HelmID','CapeID','GroundID'] as $field){if(array_key_exists($field,$data)&&$data[$field]!==null&&$data[$field]!=='')$data[$field]=(int)$data[$field];}
            if(array_key_exists('Image',$data)){
                $image=trim(str_replace('\\','/',(string)$data['Image']));
                while(str_starts_with($image,'/'))$image=substr($image,1);
                if(str_starts_with(strtolower($image),'gamefiles/'))$image=substr($image,10);
                $data['Image']=$image===''?null:$image;
            }
            if(array_key_exists('ImageScale',$data)){
                $scale=(float)$data['ImageScale'];if($scale<=0)$scale=1.0;$data['ImageScale']=max(0.05,min(10.0,$scale));
            }
            foreach(['ImageOffsetX','ImageOffsetY'] as $field){if(array_key_exists($field,$data))$data[$field]=max(-2000.0,min(2000.0,(float)$data[$field]));}
        }
        if($t==='npcs_buttons'){
            $allowed=['shop'=>'Shop','hairshop'=>'HairShop','hair shop'=>'HairShop','enhancement'=>'Enhancement','enhanceshop'=>'Enhancement','enhancementshop'=>'Enhancement','quest'=>'Quest','quests'=>'Quest','join'=>'Join','bank'=>'Bank','auction'=>'Auction','guildlist'=>'GuildList','guild list'=>'GuildList','redeem'=>'Redeem','outfits'=>'Outfits','dailylogin'=>'DailyLogin','daily login'=>'DailyLogin','worldboss'=>'WorldBoss','world boss'=>'WorldBoss','battlepass'=>'BattlePass','battle pass'=>'BattlePass'];
            $raw=strtolower(trim((string)($data['Action']??'')));if(isset($allowed[$raw]))$data['Action']=$allowed[$raw];$action=(string)($data['Action']??'');$value=trim((string)($data['Value']??''));
            if(in_array($action,['Bank','Auction','GuildList','Redeem','Outfits','DailyLogin','WorldBoss','BattlePass'],true))$data['Value']='';
            elseif($action==='Quest'){$ids=[];foreach(preg_split('/[^0-9]+/',$value,-1,PREG_SPLIT_NO_EMPTY)?:[] as $id){$n=(int)$id;if($n>0)$ids[$n]=$n;}$data['Value']=implode(',',array_values($ids));}
            else $data['Value']=$value;
            if(isset($data['Icon']))$data['Icon']=trim((string)$data['Icon']);
            if(isset($data['NPCID'])&&$data['NPCID']!==null)$data['NPCID']=(int)$data['NPCID'];
        }
        if($t==='maps_npc'||$t==='maps_npcs'){
            foreach(['MapID','NpcID','NPCID','NpcMapID'] as $field){if(array_key_exists($field,$data)&&$data[$field]!==null&&$data[$field]!=='')$data[$field]=(int)$data[$field];}
            foreach(['X','Y'] as $field){if(array_key_exists($field,$data)&&$data[$field]!==null&&$data[$field]!=='')$data[$field]=(float)$data[$field];}
            if(array_key_exists('Turn',$data))$data['Turn']=str_starts_with(strtolower(trim((string)$data['Turn'])),'l')?'Left':'Right';
        }
        if($t==='maps_monsters'){
            foreach(['MapID','MonsterID','MonMapID','Aggresive','Enabled'] as $field){
                if(array_key_exists($field,$data)&&$data[$field]!==null&&$data[$field]!=='')$data[$field]=(int)$data[$field];
            }
            foreach(['X','Y'] as $field){
                if(!array_key_exists($field,$data))continue;
                $data[$field]=($data[$field]===null||trim((string)$data[$field])==='')?null:(float)$data[$field];
            }
            if(array_key_exists('Frame',$data)){
                $data['Frame']=trim((string)$data['Frame']);
                if($data['Frame']==='')$data['Frame']='Enter';
            }
            if(isset($data['Aggresive']))$data['Aggresive']=(int)((int)$data['Aggresive']!==0);
            if(isset($data['Enabled']))$data['Enabled']=(int)((int)$data['Enabled']!==0);

            // MonMapID is the runtime instance ID used by combat packets. Make
            // creation behave like NPC placement: leaving it blank chooses the
            // next free ID inside the selected map automatically.
            if((int)($data['MonMapID']??0)<=0 && (int)($data['MapID']??0)>0){
                try{
                    $next=(int)(Database::one(
                        'SELECT COALESCE(MAX(`MonMapID`),0)+1 n FROM `maps_monsters` WHERE `MapID`=?',
                        [(int)$data['MapID']]
                    )['n']??1);
                    $data['MonMapID']=max(1,$next);
                }catch(Throwable $e){
                    $data['MonMapID']=1;
                }
            }
        }
        if($t==='maps_arrows'){
            foreach(['MapID','TargetMapID','Enabled'] as $field){if(array_key_exists($field,$data)&&$data[$field]!==null&&$data[$field]!=='')$data[$field]=(int)$data[$field];}
            foreach(['X','Y'] as $field){if(array_key_exists($field,$data)&&$data[$field]!==null&&$data[$field]!=='')$data[$field]=(float)$data[$field];}
            if(array_key_exists('Rotation',$data)){
                if($data['Rotation']===null||trim((string)$data['Rotation'])===''){
                    $data['Rotation']=null;
                }else{
                    $rotation=fmod((float)$data['Rotation'],360.0);
                    if($rotation<0)$rotation+=360.0;
                    $data['Rotation']=round($rotation,3);
                }
            }
            foreach(['Frame','TargetFrame','TargetPad'] as $field){if(array_key_exists($field,$data))$data[$field]=trim((string)$data[$field]);}
            if(isset($data['Frame'])&&$data['Frame']==='')$data['Frame']='Enter';
            if(isset($data['TargetFrame'])&&$data['TargetFrame']==='')$data['TargetFrame']='Enter';
            if(isset($data['TargetPad'])&&$data['TargetPad']==='')$data['TargetPad']='Spawn';
            if(array_key_exists('Direction',$data)){
                $allowedDirections=[
                    'Right','Slight Down-Right','Down-Right','Steep Down-Right',
                    'Down','Steep Down-Left','Down-Left','Slight Down-Left',
                    'Left','Slight Up-Left','Up-Left','Steep Up-Left',
                    'Up','Steep Up-Right','Up-Right','Slight Up-Right'
                ];
                $dir=trim((string)$data['Direction']);
                $data['Direction']=in_array($dir,$allowedDirections,true)?$dir:'Right';
            }
            if(array_key_exists('TargetType',$data))$data['TargetType']=strcasecmp(trim((string)$data['TargetType']),'Map')===0?'Map':'Room';
            if(($data['TargetType']??'Room')==='Room')$data['TargetMapID']=null;
            if(isset($data['Enabled']))$data['Enabled']=(int)(bool)$data['Enabled'];
        }
        return $data;
    }

    private function token(array $pk): string { return rtrim(strtr(base64_encode(json_encode($pk,JSON_UNESCAPED_SLASHES)),'+/','-_'),'='); }
    private function untoken(string $token): array { $raw=base64_decode(strtr($token,'-_','+/'),true); $v=$raw?json_decode($raw,true):null; return is_array($v)?$v:[]; }
    /**
     * Build a safe row-identity predicate.
     *
     * Most tables use their complete PRIMARY KEY token. The legacy `users`
     * schema is unusual: its PRIMARY KEY is (`id`,`Name`,`Hash`) even though
     * the application treats the auto-increment `id` as the stable player
     * identity everywhere else. Player Management intentionally links to the
     * editor with only `{"id":N}` so password hashes never have to be
     * embedded in URLs.
     *
     * When a complete primary key is not present, accept an auto-increment
     * column from the token only if it resolves to exactly one live row. This
     * keeps the generic editor safe for other legacy/composite-key tables.
     */
    private function wherePk(string $table,array $pk,array &$params): string
    {
        $valid=$this->primary($table);
        if(!$valid) Response::abort(400,'This table has no primary key.');

        $complete=true;
        foreach($valid as $col){
            if(!array_key_exists($col,$pk)){ $complete=false; break; }
        }
        if($complete){
            $parts=[];
            foreach($valid as $col){ $parts[]="`{$col}`=?"; $params[]=$pk[$col]; }
            return implode(' AND ',$parts);
        }

        // Legacy identity fallback: use a supplied AUTO_INCREMENT column only
        // when it uniquely identifies one row. This is what allows the users
        // editor to use the safe id-only token generated by Player Management.
        foreach($this->columns($table) as $column){
            $field=(string)($column['Field']??'');
            $extra=strtolower((string)($column['Extra']??''));
            if($field==='' || !str_contains($extra,'auto_increment') || !array_key_exists($field,$pk)) continue;

            $value=$pk[$field];
            $count=(int)(Database::one("SELECT COUNT(*) c FROM `{$table}` WHERE `{$field}`=?",[$value])['c']??0);
            if($count===1){
                $params[]=$value;
                return "`{$field}`=?";
            }
        }

        Response::abort(400,'Incomplete primary key.');
    }
    public function index(Request $request): void
    {
        $admin=Auth::requireAdmin();
        $stmt=Database::connection()->query('SHOW TABLE STATUS');
        $status=$stmt ? $stmt->fetchAll(PDO::FETCH_ASSOC) : [];
        $tables=[];
        foreach($status as $row){
            $tables[]=[
                'TABLE_NAME'=>$row['Name'] ?? '',
                'ENGINE'=>$row['Engine'] ?? '',
                'TABLE_ROWS'=>$row['Rows'] ?? 0,
            ];
        }
        usort($tables,fn($a,$b)=>strcasecmp((string)$a['TABLE_NAME'],(string)$b['TABLE_NAME']));
        View::render('admin.data.index',['admin'=>$admin,'tables'=>$tables]);
    }
    public function table(Request $request,string $table): void
    {
        $admin=Auth::requireAdmin();$table=$this->tableName($table);$cols=$this->columns($table);$pk=$this->primary($table);$page=max(1,(int)$request->input('page',1));$limit=50;$offset=($page-1)*$limit;
        $q=trim((string)$request->input('q',''));$params=[];$where='';
        if($q!==''){$searchable=array_values(array_filter($cols,fn($c)=>preg_match('/char|text/i',(string)$c['Type'])));if($searchable){$parts=[];foreach($searchable as $c){$parts[]='`'.$c['Field'].'` LIKE ?';$params[]='%'.$q.'%';}$where=' WHERE '.implode(' OR ',$parts);}}
        $order=$pk?(' ORDER BY `'.$pk[0].'` DESC'):'';$sql="SELECT * FROM `{$table}`{$where}{$order} LIMIT {$limit} OFFSET {$offset}";$rows=Database::all($sql,$params);$count=(int)(Database::one("SELECT COUNT(*) c FROM `{$table}`{$where}",$params)['c']??0);
        foreach($rows as &$row){$pkv=[];foreach($pk as $col)$pkv[$col]=$row[$col];$row['_key']=$this->token($pkv);}unset($row);
        View::render('admin.data.table',['admin'=>$admin,'table'=>$table,'columns'=>$cols,'rows'=>$rows,'primary'=>$pk,'page'=>$page,'pages'=>max(1,(int)ceil($count/$limit)),'q'=>$q]);
    }
    public function createForm(Request $request,string $table): void { $admin=Auth::requireAdmin();$table=$this->tableName($table);$columns=$this->columns($table);View::render('admin.data.form',['admin'=>$admin,'table'=>$table,'columns'=>$columns,'relations'=>$this->relationOptions($table,$columns),'editor'=>$this->editorDefinition($table),'row'=>[],'mode'=>'create','key'=>'']); }
    public function create(Request $request,string $table): void
    {
        $admin=Auth::requireAdmin();Csrf::verify($request);$table=$this->tableName($table);$cols=$this->columns($table);
        try{$data=$this->collect($request,$table,$cols,true);}catch(Throwable $e){Session::flash('error','Upload/save failed: '.$e->getMessage());Response::redirect('/admin/data/'.$table.'/new');return;}
        if(!$data)Response::abort(400,'No values supplied.');
        $names=array_keys($data);$sql='INSERT INTO `'.$table.'` ('.implode(',',array_map(fn($c)=>"`{$c}`",$names)).') VALUES ('.implode(',',array_fill(0,count($names),'?')).')';
        try{Database::run($sql,array_values($data));$this->audit($admin,'create',$table,(string)Database::connection()->lastInsertId(),$data,$request);Session::flash('success','Record created.');}catch(Throwable $e){Session::flash('error','Create failed: '.$e->getMessage());}
        Response::redirect('/admin/data/'.$table);
    }
    public function editForm(Request $request,string $table): void
    {
        $admin=Auth::requireAdmin();$table=$this->tableName($table);$key=(string)$request->input('key','');$pk=$this->untoken($key);$params=[];$where=$this->wherePk($table,$pk,$params);$row=Database::one("SELECT * FROM `{$table}` WHERE {$where} LIMIT 1",$params);if(!$row)Response::abort(404);
        $columns=$this->columns($table);View::render('admin.data.form',['admin'=>$admin,'table'=>$table,'columns'=>$columns,'relations'=>$this->relationOptions($table,$columns),'editor'=>$this->editorDefinition($table),'row'=>$row,'mode'=>'edit','key'=>$key]);
    }
    public function edit(Request $request,string $table): void
    {
        $admin=Auth::requireAdmin();Csrf::verify($request);$table=$this->tableName($table);$key=(string)$request->input('key','');$pk=$this->untoken($key);$cols=$this->columns($table);
        try{$data=$this->collect($request,$table,$cols,false);}catch(Throwable $e){Session::flash('error','Upload/save failed: '.$e->getMessage());Response::redirect('/admin/data/'.$table.'/edit?key='.rawurlencode($key));return;}
        $params=[];$where=$this->wherePk($table,$pk,$params);
        if($data){$sets=implode(',',array_map(fn($c)=>"`{$c}`=?",array_keys($data)));try{Database::run("UPDATE `{$table}` SET {$sets} WHERE {$where}",array_merge(array_values($data),$params));$this->audit($admin,'update',$table,json_encode($pk),$data,$request);Session::flash('success','Record updated.');}catch(Throwable $e){Session::flash('error','Update failed: '.$e->getMessage());}}
        Response::redirect('/admin/data/'.$table);
    }
    public function delete(Request $request,string $table): void
    {
        $admin=Auth::requireAdmin();Csrf::verify($request);$table=$this->tableName($table);$pk=$this->untoken((string)$request->input('key',''));$params=[];$where=$this->wherePk($table,$pk,$params);
        try{Database::run("DELETE FROM `{$table}` WHERE {$where} LIMIT 1",$params);$this->audit($admin,'delete',$table,json_encode($pk),null,$request);Session::flash('success','Record deleted.');}catch(Throwable $e){Session::flash('error','Delete failed: '.$e->getMessage());}Response::redirect('/admin/data/'.$table);
    }
    /**
     * Save an NPC image uploaded directly from the NPC create/edit form.
     * The stored database value is always relative to public/gamefiles/.
     */
    private function handleNpcImageUpload(string $table): ?string
    {
        if(strtolower($table)!=='npcs' || !isset($_FILES['npc_image_upload'])) return null;
        $file=$_FILES['npc_image_upload'];
        $error=(int)($file['error']??UPLOAD_ERR_NO_FILE);
        if($error===UPLOAD_ERR_NO_FILE) return null;
        if($error!==UPLOAD_ERR_OK) throw new \RuntimeException('NPC image upload failed (PHP upload error '.$error.').');

        $tmp=(string)($file['tmp_name']??'');
        $original=(string)($file['name']??'npc.png');
        $size=(int)($file['size']??0);
        if($tmp==='' || !is_uploaded_file($tmp)) throw new \RuntimeException('NPC image upload was not received correctly.');
        if($size<=0 || $size>15*1024*1024) throw new \RuntimeException('NPC image must be between 1 byte and 15 MB.');

        $ext=strtolower(pathinfo($original,PATHINFO_EXTENSION));
        if($ext==='jpeg')$ext='jpg';
        if(!in_array($ext,['png','jpg','gif'],true)) throw new \RuntimeException('NPC images must be PNG, JPG/JPEG, or GIF.');

        if(function_exists('finfo_open')){
            $finfo=@finfo_open(FILEINFO_MIME_TYPE);
            $mime=$finfo?(@finfo_file($finfo,$tmp)?:''):'';
            if($finfo)@finfo_close($finfo);
            $allowed=['image/png','image/jpeg','image/gif'];
            if($mime!=='' && !in_array(strtolower($mime),$allowed,true)) throw new \RuntimeException('The uploaded file is not a supported image.');
        }

        $base=pathinfo($original,PATHINFO_FILENAME);
        $base=preg_replace('/[^A-Za-z0-9._-]+/','-',$base)??'npc';
        $base=trim($base,'.-_');if($base==='')$base='npc';
        if(strlen($base)>90)$base=substr($base,0,90);

        $public=rtrim((string)Config::get('paths.public'),"/\\");
        $dir=$public.'/gamefiles/npcs';
        if(!is_dir($dir) && !@mkdir($dir,0775,true) && !is_dir($dir)) throw new \RuntimeException('Could not create public/gamefiles/npcs.');

        $filename=$base.'.'.$ext;
        $dest=$dir.'/'.$filename;
        $n=2;
        while(file_exists($dest)){
            $filename=$base.'-'.$n.'.'.$ext;
            $dest=$dir.'/'.$filename;
            $n++;
        }
        if(!@move_uploaded_file($tmp,$dest)) throw new \RuntimeException('Could not save NPC image to public/gamefiles/npcs.');
        return 'npcs/'.$filename;
    }

    private function collect(Request $request,string $table,array $columns,bool $creating): array
    {
        $data=[];
        foreach($columns as $c){
            $name=$c['Field'];$extra=strtolower((string)$c['Extra']);
            if($creating&&str_contains($extra,'auto_increment'))continue;
            if(!$creating&&$c['Key']==='PRI')continue;
            if(!array_key_exists($name,$_POST))continue;
            $v=$_POST[$name];
            if(is_array($v))$v=implode(',',array_map('strval',$v));
            if($v===''&&$c['Null']==='YES')$v=null;
            $data[$name]=$v;
        }
        if(strtolower($table)==='npcs'){
            $uploaded=$this->handleNpcImageUpload($table);
            if($uploaded!==null)$data['Image']=$uploaded;
        }
        return $this->normalizeSpecialData($table,$data);
    }
    private function audit(array $admin,string $action,string $entity,string $id,mixed $details,Request $request): void
    {try{Database::run('INSERT INTO admin_audit (AdminUserID,Action,Entity,EntityID,Details,IPAddress) VALUES (?,?,?,?,?,?)',[(int)$admin['id'],$action,$entity,$id,$details===null?null:json_encode($details,JSON_UNESCAPED_SLASHES),$request->ip()]);}catch(Throwable $e){}}
}
