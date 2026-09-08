<?php
$pretty=ucwords(str_replace('_',' ',$table));
$title=($mode==='create'?'Create ':'Edit ').$pretty;
$heading=$title;
$relations=$relations??[];
$editor=$editor??[];
$tableLower=strtolower($table);
$isNpcButton=$tableLower==='npcs_buttons';
$isNpc=$tableLower==='npcs';
$isNpcPlacement=in_array($tableLower,['maps_npc','maps_npcs'],true);
$isMapArrow=$tableLower==='maps_arrows';
$isMonsterPlacement=$tableLower==='maps_monsters';
$isItem=$tableLower==='items';
$filePicker=$editor['filePicker']??null;
$itemFields=$editor['itemFields']??[];
$subheading=$isItem
    ? 'Item fields use complete type, icon, equipment, rarity, boolean, relation, quest, and live SWF selectors.'
    : (($isNpc||$isNpcButton||$isNpcPlacement||$isMapArrow||$isMonsterPlacement)
    ? ($isMapArrow
        ? 'Map arrows use map, room, coordinate, and destination selectors.'
        : ($isMonsterPlacement
            ? 'Monster placements use live map/monster selectors and database X/Y spawn coordinates.'
            : 'NPC fields use purpose-built controls and live database selectors.'))
    : ($filePicker
        ? 'Fields are generated from the live MySQL 5.7 schema. File fields use the SWFs currently available in gamefiles.'
        : 'Fields are generated from the live MySQL 5.7 schema. Linked ID fields use live database selectors.'));

$colorCss=static function($value,string $fallback='#000000'): string {
    $v=trim((string)$value);if($v==='')return $fallback;
    if(str_starts_with(strtolower($v),'0x'))$v=substr($v,2);elseif(str_starts_with($v,'#'))$v=substr($v,1);
    $v=preg_replace('/[^0-9a-f]/i','',$v)??'';if($v==='')return $fallback;
    return '#'.strtoupper(str_pad(substr($v,-6),6,'0',STR_PAD_LEFT));
};
$canonicalAction=static function($value): string {
    $k=strtolower(trim((string)$value));
    $map=['shop'=>'Shop','hairshop'=>'HairShop','hair shop'=>'HairShop','enhancement'=>'Enhancement','enhanceshop'=>'Enhancement','enhancementshop'=>'Enhancement','quest'=>'Quest','quests'=>'Quest','join'=>'Join','bank'=>'Bank','auction'=>'Auction','guildlist'=>'GuildList','guild list'=>'GuildList','redeem'=>'Redeem','outfits'=>'Outfits','dailylogin'=>'DailyLogin','daily login'=>'DailyLogin','worldboss'=>'WorldBoss','world boss'=>'WorldBoss','battlepass'=>'BattlePass','battle pass'=>'BattlePass'];
    return $map[$k]??(string)$value;
};
$actionDefs=[];foreach(($editor['actions']??[]) as $a)$actionDefs[(string)$a['value']]=$a;
$currentAction=$canonicalAction($row['Action']??'');
$currentButtonValue=(string)($row['Value']??'');
$questIds=$currentAction==='Quest'?array_values(array_filter(array_map('intval',preg_split('/[^0-9]+/',$currentButtonValue,-1,PREG_SPLIT_NO_EMPTY)?:[]),fn($v)=>$v>0)):[];
$joinParts=$currentAction==='Join'?(preg_split('/[|,:]/',$currentButtonValue,3)?:[]):[];
$joinMap=trim((string)($joinParts[0]??''));$joinFrame=trim((string)($joinParts[1]??'Enter'));$joinPad=trim((string)($joinParts[2]??'Spawn'));
if($joinFrame==='')$joinFrame='Enter';if($joinPad==='')$joinPad='Spawn';
ob_start();
?>
<div class="panel form-panel <?= ($isNpc||$isNpcButton||$isNpcPlacement||$isMapArrow||$isMonsterPlacement)?'npc-data-editor':'' ?>">
<form method="post" enctype="multipart/form-data" action="/admin/data/<?= e($table) ?>/<?= $mode==='create'?'new':'edit' ?>" class="db-form" data-admin-data-form data-editor-kind="<?= e($tableLower) ?>">
<?= csrf_field() ?>
<?php if($mode==='edit'): ?><input type="hidden" name="key" value="<?= e($key) ?>"><?php endif; ?>
<?php if($isNpcButton): ?>
<div class="npc-editor-note"><strong>NPC Button</strong><span>Choose the action first. The Value control will automatically change to the matching shop, quest, map, or no-value selector.</span></div>
<?php elseif($isNpc): ?>
<div class="npc-editor-note"><strong>NPC Appearance</strong><span>Use the normal equipped-item avatar, or choose a PNG/JPG/GIF in <code>Image</code> to render the NPC as a static image. Image NPCs keep the same name, job, buttons, popup, placement, and E-key interaction.</span></div>
<?php elseif($isNpcPlacement): ?>
<div class="npc-editor-note"><strong>NPC Placement</strong><span>Choose the NPC and map, then select a known map frame and set the exact X/Y coordinates.</span></div>
<?php elseif($isMapArrow): ?>
<div class="npc-editor-note"><strong>Database Map Arrow</strong><span>Choose the source map/room, exact X/Y, and any rotation angle. Then send the player to another room in that map or to a different map, room, and pad.</span></div>
<?php elseif($isMonsterPlacement): ?>
<div class="npc-editor-note"><strong>Monster Placement</strong><span>Choose the monster and map, select the room/frame, then set its exact X/Y spawn coordinates. The map SWF no longer needs a hard-coded monster marker for database-positioned instances.</span></div>
<?php elseif($isItem): ?>
<div class="npc-editor-note"><strong>Item Editor</strong><span>Choose valid client item types, icons, equipment slots, rarities, enhancements, factions, class requirements, quest requirements, and deployed SWF files instead of entering internal codes manually.</span></div>
<?php endif; ?>
<div class="form-grid">
<?php foreach($columns as $c):
    $name=(string)$c['Field'];$fieldLower=strtolower($name);$value=$row[$name]??$c['Default'];$auto=str_contains(strtolower((string)$c['Extra']),'auto_increment');$readonly=$mode==='edit'&&$c['Key']==='PRI';
    if($mode==='create'&&$auto)continue;
    $relation=$relations[$name]??null;
?>
<div class="db-field <?= ($isNpcButton&&$fieldLower==='value')?'npc-value-label':'' ?>">
<span><?= e($name) ?> <small><?= e($c['Type']) ?><?= $c['Null']==='YES'?' · nullable':'' ?><?= $relation?' · linked to '.e($relation['table']):'' ?></small></span>

<?php if($isItem&&$fieldLower==='type'): ?>
    <div class="relation-control" data-relation-control>
        <input type="search" class="relation-search" data-relation-search placeholder="Search item types..." autocomplete="off" <?= $readonly?'disabled':'' ?>>
        <select name="<?= e($name) ?>" data-relation-select data-item-type <?= $readonly?'disabled':'' ?>>
            <option value="">Select item type...</option>
            <?php $found=false;foreach(($itemFields['type']??[]) as $opt):$sel=strcasecmp((string)$value,(string)$opt['value'])===0;if($sel)$found=true; ?>
                <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
            <?php endforeach; ?>
            <?php if(!$found&&$value!==null&&$value!==''): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> — existing custom type</option><?php endif; ?>
        </select>
    </div>

<?php elseif($isItem&&$fieldLower==='element'): ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>>
        <?php $found=false;foreach(($itemFields['element']??[]) as $opt):$sel=strcasecmp((string)$value,(string)$opt['value'])===0;if($sel)$found=true; ?>
            <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
        <?php endforeach; ?>
        <?php if(!$found&&$value!==null&&$value!==''): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> — existing custom element</option><?php endif; ?>
    </select>

<?php elseif($isItem&&$fieldLower==='icon'): ?>
    <div class="relation-control" data-relation-control>
        <input type="search" class="relation-search" data-relation-search placeholder="Search item icons..." autocomplete="off" <?= $readonly?'disabled':'' ?>>
        <select name="<?= e($name) ?>" data-relation-select data-item-icon <?= $readonly?'disabled':'' ?>>
            <option value="">Select icon...</option>
            <?php $found=false;foreach(($itemFields['icon']??[]) as $opt):$sel=strcasecmp((string)$value,(string)$opt['value'])===0;if($sel)$found=true; ?>
                <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
            <?php endforeach; ?>
            <?php if(!$found&&$value!==null&&$value!==''): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> — existing custom icon</option><?php endif; ?>
        </select>
        <small class="field-help">Uses the icon linkage loaded by the client, such as <code>iwsword</code>, <code>iiclass</code>, <code>iipet</code>, or <code>iibag</code>.</small>
    </div>

<?php elseif($isItem&&$fieldLower==='equipment'): ?>
    <select name="<?= e($name) ?>" data-item-equipment <?= $readonly?'disabled':'' ?>>
        <?php $found=false;foreach(($itemFields['equipment']??[]) as $opt):$sel=strcasecmp((string)$value,(string)$opt['value'])===0;if($sel)$found=true; ?>
            <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
        <?php endforeach; ?>
        <?php if(!$found&&$value!==null&&$value!==''): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> — existing custom slot</option><?php endif; ?>
    </select>
    <small class="field-help">This is the client's <code>sES</code> equipment-slot code.</small>

<?php elseif($isItem&&$fieldLower==='rarity'): ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>>
        <?php $found=false;foreach(($itemFields['rarity']??[]) as $opt):$sel=(string)$value===(string)$opt['value'];if($sel)$found=true; ?>
            <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
        <?php endforeach; ?>
        <?php if(!$found&&$value!==null&&$value!==''): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> — existing custom rarity</option><?php endif; ?>
    </select>
    <small class="field-help">Rarity values match the client's built-in <code>getRarityString()</code> list.</small>

<?php elseif($isItem&&in_array($fieldLower,['coins','sell','temporary','upgrade','staff','trade','market'],true)): ?>
    <?php $enabled=(int)$value!==0; ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>>
        <option value="1" <?= $enabled?'selected':'' ?>>Yes / Enabled (1)</option>
        <option value="0" <?= !$enabled?'selected':'' ?>>No / Disabled (0)</option>
    </select>

<?php elseif($isItem&&$fieldLower==='reqquests'): ?>
    <?php
        $selectedReqQuestIds=array_values(array_filter(array_map('intval',preg_split('/[^0-9]+/',(string)$value,-1,PREG_SPLIT_NO_EMPTY)?:[]),fn($v)=>$v>0));
    ?>
    <div class="relation-control">
        <input type="search" class="relation-search" data-local-select-search placeholder="Search required quests..." autocomplete="off">
        <select name="<?= e($name) ?>[]" multiple size="8" data-local-select <?= $readonly?'disabled':'' ?>>
            <?php foreach(($itemFields['quests']??[]) as $opt):$qid=(int)$opt['value']; ?>
                <option value="<?= e($qid) ?>" <?= in_array($qid,$selectedReqQuestIds,true)?'selected':'' ?>><?= e($opt['label']) ?></option>
            <?php endforeach; ?>
        </select>
        <small class="field-help">Select one or more quest IDs. They are saved as the comma-separated <code>ReqQuests</code> value used by the emulator.</small>
        <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>
    </div>

<?php elseif($isItem&&$fieldLower==='link'): ?>
    <input name="<?= e($name) ?>" value="<?= e($value) ?>" list="item-link-values" <?= $readonly?'readonly':'' ?> placeholder="SWF linkage / export name">
    <small class="field-help">The symbol linkage inside the selected SWF. For many equipment SWFs this matches the filename without <code>.swf</code>.</small>

<?php elseif($isItem&&$fieldLower==='meta'): ?>
    <input name="<?= e($name) ?>" value="<?= e($value) ?>" list="item-meta-values" <?= $readonly?'readonly':'' ?>>
    <small class="field-help">Optional client/emulator metadata. Leave blank unless the item feature requires it.</small>

<?php elseif($isItem&&in_array($fieldLower,['level','dps','range','quantity','stack','cost','reqreputation','reqclasspoints','queststringvalue'],true)): ?>
    <?php $min=in_array($fieldLower,['level','quantity','stack'],true)?1:0; ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" min="<?= $min ?>" step="1" <?= $readonly?'readonly':'' ?>>

<?php elseif($isItem&&$fieldLower==='queststringindex'): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" min="-1" step="1" <?= $readonly?'readonly':'' ?>>
    <small class="field-help"><code>-1</code> disables the quest-string requirement.</small>

<?php elseif($isNpcButton&&$fieldLower==='action'): ?>
    <select name="<?= e($name) ?>" data-npc-action-select <?= $readonly?'disabled':'' ?>>
        <option value="">Select NPC action...</option>
        <?php foreach(($editor['actions']??[]) as $a): $selected=strcasecmp($currentAction,(string)$a['value'])===0; ?>
        <option value="<?= e($a['value']) ?>" data-value-mode="<?= e($a['mode']??'none') ?>" <?= $selected?'selected':'' ?>><?= e($a['label']) ?></option>
        <?php endforeach; ?>
        <?php if($currentAction!==''&&!isset($actionDefs[$currentAction])): ?><option value="<?= e($currentAction) ?>" selected><?= e($currentAction) ?> (legacy/custom)</option><?php endif; ?>
    </select>
    <small class="field-help" data-npc-action-help></small>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>

<?php elseif($isNpcButton&&$fieldLower==='value'): ?>
    <div class="npc-value-editor" data-npc-value-editor data-initial-value="<?= e($currentButtonValue) ?>">
        <input type="hidden" name="<?= e($name) ?>" value="<?= e($currentButtonValue) ?>" data-npc-value-output>

        <?php foreach(($editor['actions']??[]) as $a): $action=(string)$a['value'];$modeType=(string)($a['mode']??'none'); ?>
            <?php if($modeType==='single'): ?>
            <div class="npc-value-mode" data-npc-value-mode="<?= e($action) ?>" hidden>
                <div class="relation-control">
                    <input type="search" class="relation-search" data-local-select-search placeholder="Search <?= e(strtolower($a['label'])) ?>..." autocomplete="off">
                    <select data-npc-value-single data-action="<?= e($action) ?>">
                        <option value="">Select <?= e(strtolower($a['label'])) ?>...</option>
                        <?php $found=false;foreach(($editor['valueOptions'][$action]??[]) as $opt):$sel=strcasecmp($currentAction,$action)===0&&(string)$currentButtonValue===(string)$opt['value'];if($sel)$found=true; ?><option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option><?php endforeach; ?>
                        <?php if(strcasecmp($currentAction,$action)===0&&$currentButtonValue!==''&&!$found): ?><option value="<?= e($currentButtonValue) ?>" selected>#<?= e($currentButtonValue) ?> — missing/deleted relation</option><?php endif; ?>
                    </select>
                </div>
            </div>
            <?php elseif($modeType==='multi'): ?>
            <div class="npc-value-mode" data-npc-value-mode="<?= e($action) ?>" hidden>
                <input type="search" class="relation-search" data-npc-multi-search placeholder="Search quests..." autocomplete="off">
                <div class="npc-checklist" data-npc-value-multi data-action="<?= e($action) ?>">
                    <?php foreach(($editor['valueOptions'][$action]??[]) as $opt): ?><label data-search-label="<?= e(strtolower($opt['label'])) ?>"><input type="checkbox" value="<?= e($opt['value']) ?>" <?= in_array((int)$opt['value'],$questIds,true)?'checked':'' ?>> <span><?= e($opt['label']) ?></span></label><?php endforeach; ?>
                </div>
                <small class="field-help">Check every quest this NPC should offer. The database Value is stored as a comma-separated Quest ID list.</small>
            </div>
            <?php elseif($modeType==='join'): ?>
            <div class="npc-value-mode npc-join-editor" data-npc-value-mode="<?= e($action) ?>" hidden>
                <label class="inline-field"><span>Map</span><select data-npc-join-map><option value="">Select map...</option><?php $joinFound=false;foreach(($editor['valueOptions'][$action]??[]) as $opt):$sel=strcasecmp($joinMap,(string)$opt['value'])===0;if($sel)$joinFound=true; ?><option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option><?php endforeach; ?><?php if($joinMap!==''&&!$joinFound): ?><option value="<?= e($joinMap) ?>" selected><?= e($joinMap) ?> (missing map)</option><?php endif; ?></select></label>
                <label class="inline-field"><span>Frame / Cell</span><select data-npc-join-frame data-current="<?= e($joinFrame) ?>"><option value="<?= e($joinFrame) ?>" selected><?= e($joinFrame) ?></option></select></label>
                <label class="inline-field"><span>Pad</span><select data-npc-join-pad data-current="<?= e($joinPad) ?>"><option value="<?= e($joinPad) ?>" selected><?= e($joinPad) ?></option></select></label>
                <small class="field-help">Stored as <code>map|frame|pad</code>.</small>
            </div>
            <?php elseif($modeType==='none'): ?>
            <div class="npc-value-mode npc-no-value" data-npc-value-mode="<?= e($action) ?>" hidden><strong>No Value required</strong><span><?= e($a['help']??'This action does not use the Value field.') ?></span></div>
            <?php endif; ?>
        <?php endforeach; ?>
        <div class="npc-value-mode npc-no-value" data-npc-value-mode="__unknown" hidden><strong>Legacy/custom action</strong><span>The current Value will be preserved.</span></div>
    </div>

<?php elseif($isNpcButton&&$fieldLower==='icon'): ?>
    <div class="relation-control npc-icon-control" data-relation-control>
        <input type="search" class="relation-search" data-relation-search placeholder="Search NPC icons..." autocomplete="off" <?= $readonly?'disabled':'' ?>>
        <select name="<?= e($name) ?>" data-relation-select <?= $readonly?'disabled':'' ?>><option value="">— No icon / use button default —</option><?php $iconFound=false;foreach(($editor['icons']??[]) as $icon):$sel=strcasecmp((string)$value,(string)$icon)===0;if($sel)$iconFound=true; ?><option value="<?= e($icon) ?>" <?= $sel?'selected':'' ?>><?= e($icon) ?></option><?php endforeach; ?><?php if($value!==null&&$value!==''&&!$iconFound): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> (existing custom icon)</option><?php endif; ?></select>
        <small class="field-help">These values match the icon labels used by items/existing NPC buttons. Your <code>mcIcon</code> MovieClip can use matching frame labels.</small>
        <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>
    </div>

<?php elseif($isNpc&&$fieldLower==='image'): ?>
    <div class="relation-control" data-relation-control>
        <input type="search" class="relation-search" data-relation-search placeholder="Search deployed NPC images..." autocomplete="off" <?= $readonly?'disabled':'' ?>>
        <select name="<?= e($name) ?>" data-relation-select <?= $readonly?'disabled':'' ?>>
            <option value="">— Use normal SWF/equipment avatar —</option>
            <?php $imageFound=false;foreach(($editor['npcImages']??[]) as $opt):$sel=strcasecmp((string)$value,(string)$opt['value'])===0;if($sel)$imageFound=true; ?>
                <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
            <?php endforeach; ?>
            <?php if($value!==null&&$value!==''&&!$imageFound): ?><option value="<?= e($value) ?>" selected><?= e($value) ?> (existing/custom path)</option><?php endif; ?>
        </select>
        <small class="field-help">Choose an existing image from <code>public/gamefiles/npcs/</code>, or upload a new one below. The database stores paths like <code>npcs/Kael.png</code>.</small>
        <div class="npc-image-upload" style="margin-top:10px;padding:10px;border:1px solid #343434;background:#111">
            <label style="display:block;font-weight:700;margin-bottom:6px">Upload new NPC image</label>
            <input type="file" name="npc_image_upload" accept="image/png,image/jpeg,image/gif,.png,.jpg,.jpeg,.gif" <?= $readonly?'disabled':'' ?>>
            <small class="field-help">PNG, JPG/JPEG, or GIF up to 15 MB. Saving this record uploads it directly to <code>public/gamefiles/npcs/</code> and automatically selects the new file.</small>
        </div>
        <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>
    </div>

<?php elseif($isNpc&&$fieldLower==='imagescale'): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value===null||$value===''?'1':$value) ?>" min="0.05" max="10" step="0.01" <?= $readonly?'readonly':'' ?>>
    <small class="field-help">Image size multiplier. 1.00 = native image size. Fine 0.01 increments are supported, including values such as 0.06, 0.07, 0.08, and 0.09.</small>

<?php elseif($isNpc&&in_array($fieldLower,['imageoffsetx','imageoffsety'],true)): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value===null||$value===''?'0':$value) ?>" min="-2000" max="2000" step="1" <?= $readonly?'readonly':'' ?>>
    <small class="field-help"><?= $fieldLower==='imageoffsetx'?'Horizontal':'Vertical' ?> adjustment from the NPC's X/Y foot anchor.</small>

<?php elseif($isNpc&&$fieldLower==='gender'): ?>
    <?php $g=str_starts_with(strtoupper(trim((string)$value)),'F')?'F':'M'; ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>><option value="M" <?= $g==='M'?'selected':'' ?>>Male</option><option value="F" <?= $g==='F'?'selected':'' ?>>Female</option></select>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($g) ?>"><?php endif; ?>

<?php elseif($isNpc&&str_starts_with($fieldLower,'color')): ?>
    <div class="npc-color-control" data-npc-color-control>
        <input type="color" value="<?= e($colorCss($value,$fieldLower==='colorskin'?'#E2C3A3':'#000000')) ?>" data-npc-color-picker <?= $readonly?'disabled':'' ?>>
        <input type="text" name="<?= e($name) ?>" value="<?= e($value) ?>" placeholder="0xRRGGBB" data-npc-color-text <?= $readonly?'readonly':'' ?>>
        <?php if(!$readonly): ?><button class="btn btn-ghost npc-color-clear" type="button" data-npc-color-clear>Clear</button><?php endif; ?>
    </div>

<?php elseif($isNpc&&in_array($fieldLower,['level','health','mana','dps'],true)): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" min="<?= $fieldLower==='level'?'1':'0' ?>" step="1" <?= $readonly?'readonly':'' ?>>

<?php elseif($isNpc&&$fieldLower==='slogan'): ?>
    <textarea name="<?= e($name) ?>" rows="4" <?= $readonly?'readonly':'' ?> placeholder="NPC dialog shown when clicked..."><?= e($value) ?></textarea>

<?php elseif($isMonsterPlacement&&$fieldLower==='frame'): ?>
    <select name="<?= e($name) ?>" data-map-frame-select data-current-frame="<?= e($value?:'Enter') ?>" <?= $readonly?'disabled':'' ?>><option value="<?= e($value?:'Enter') ?>" selected><?= e($value?:'Enter') ?></option></select>
    <small class="field-help">Choose the timeline room/frame where this monster exists.</small>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>

<?php elseif($isMonsterPlacement&&in_array($fieldLower,['x','y'],true)): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" step="0.01" inputmode="decimal" <?= $readonly?'readonly':'' ?> placeholder="Map coordinate">
    <small class="field-help">Exact <?= strtoupper($fieldLower) ?> spawn coordinate. Leave both X and Y empty only for legacy maps that still use an embedded monster marker.</small>

<?php elseif($isMonsterPlacement&&$fieldLower==='monmapid'): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" min="0" step="1" <?= $readonly?'readonly':'' ?> placeholder="Auto">
    <small class="field-help">Runtime monster instance ID inside this map. Leave blank/0 when creating and the next free ID is assigned automatically.</small>

<?php elseif($isMonsterPlacement&&$fieldLower==='aggresive'): ?>
    <?php $aggressive=(int)$value!==0; ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>><option value="0" <?= !$aggressive?'selected':'' ?>>Passive (0)</option><option value="1" <?= $aggressive?'selected':'' ?>>Aggressive (1)</option></select>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= $aggressive?'1':'0' ?>"><?php endif; ?>

<?php elseif($isMonsterPlacement&&$fieldLower==='enabled'): ?>
    <?php $enabled=(int)$value!==0; ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>><option value="1" <?= $enabled?'selected':'' ?>>Enabled</option><option value="0" <?= !$enabled?'selected':'' ?>>Disabled</option></select>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= $enabled?'1':'0' ?>"><?php endif; ?>

<?php elseif($isMapArrow&&$fieldLower==='frame'): ?>
    <div class="map-arrow-room-control" data-map-arrow-source-room-control>
        <select name="<?= e($name) ?>" data-map-arrow-source-frame data-current-frame="<?= e($value?:'Enter') ?>" <?= $readonly?'disabled':'' ?>><option value="<?= e($value?:'Enter') ?>" selected><?= e($value?:'Enter') ?></option></select>
        <input type="text" class="relation-search map-arrow-custom-room" value="" data-map-arrow-source-frame-custom placeholder="Custom room/frame..." autocomplete="off">
        <small class="field-help">Choose a known room or type a custom timeline frame. Existing NPCs, monsters, and arrows are used to discover room names.</small>
    </div>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>

<?php elseif($isMapArrow&&in_array($fieldLower,['x','y'],true)): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" step="0.01" inputmode="decimal" <?= $readonly?'readonly':'' ?>>
    <small class="field-help"><?= strtoupper($fieldLower) ?> position of the arrow in map coordinates.</small>

<?php elseif($isMapArrow&&$fieldLower==='direction'): ?>
    <?php
        $arrowDirections=[
            'Right'=>0,
            'Slight Down-Right'=>22.5,
            'Down-Right'=>45,
            'Steep Down-Right'=>67.5,
            'Down'=>90,
            'Steep Down-Left'=>112.5,
            'Down-Left'=>135,
            'Slight Down-Left'=>157.5,
            'Left'=>180,
            'Slight Up-Left'=>202.5,
            'Up-Left'=>225,
            'Steep Up-Left'=>247.5,
            'Up'=>270,
            'Steep Up-Right'=>292.5,
            'Up-Right'=>315,
            'Slight Up-Right'=>337.5
        ];
        $direction=trim((string)($value?:'Right'));
        if(!array_key_exists($direction,$arrowDirections))$direction='Right';
    ?>
    <select name="<?= e($name) ?>" data-db-arrow-direction <?= $readonly?'disabled':'' ?>>
        <?php foreach($arrowDirections as $d=>$angle): ?>
            <option
                value="<?= e($d) ?>"
                data-angle="<?= e($angle) ?>"
                <?= $direction===$d?'selected':'' ?>
            ><?= e($d) ?> (<?= e($angle) ?>°)</option>
        <?php endforeach; ?>
    </select>
    <small class="field-help">
        16 built-in directions are available now. Choosing one also updates the Rotation field.
        You can still type any exact custom Rotation angle below.
    </small>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($direction) ?>"><?php endif; ?>

<?php elseif($isMapArrow&&$fieldLower==='rotation'): ?>
    <input
        type="number"
        name="<?= e($name) ?>"
        value="<?= e($value) ?>"
        data-db-arrow-rotation
        min="0"
        max="359.999"
        step="0.1"
        list="db-arrow-angle-presets"
        inputmode="decimal"
        <?= $readonly?'readonly':'' ?>
        placeholder="Example: 45"
    >
    <datalist id="db-arrow-angle-presets">
        <option value="0" label="Right"></option>
        <option value="15" label="15°"></option>
        <option value="22.5" label="Slight Down-Right"></option>
        <option value="30" label="30°"></option>
        <option value="45" label="Down-Right"></option>
        <option value="60" label="60°"></option>
        <option value="67.5" label="Steep Down-Right"></option>
        <option value="75" label="75°"></option>
        <option value="90" label="Down"></option>
        <option value="105" label="105°"></option>
        <option value="112.5" label="Steep Down-Left"></option>
        <option value="120" label="120°"></option>
        <option value="135" label="Down-Left"></option>
        <option value="150" label="150°"></option>
        <option value="157.5" label="Slight Down-Left"></option>
        <option value="165" label="165°"></option>
        <option value="180" label="Left"></option>
        <option value="195" label="195°"></option>
        <option value="202.5" label="Slight Up-Left"></option>
        <option value="210" label="210°"></option>
        <option value="225" label="Up-Left"></option>
        <option value="240" label="240°"></option>
        <option value="247.5" label="Steep Up-Left"></option>
        <option value="255" label="255°"></option>
        <option value="270" label="Up"></option>
        <option value="285" label="285°"></option>
        <option value="292.5" label="Steep Up-Right"></option>
        <option value="300" label="300°"></option>
        <option value="315" label="Up-Right"></option>
        <option value="330" label="330°"></option>
        <option value="337.5" label="Slight Up-Right"></option>
        <option value="345" label="345°"></option>
    </datalist>
    <small class="field-help">
        Exact clockwise angle. You can type <strong>any decimal angle</strong>, not just a preset.
        0°=Right, 45°=Down-Right, 90°=Down, 135°=Down-Left,
        180°=Left, 225°=Up-Left, 270°=Up, 315°=Up-Right.
        Leave blank to use the legacy Direction selector.
    </small>

<?php elseif($isMapArrow&&$fieldLower==='targettype'): ?>
    <?php $targetType=strcasecmp(trim((string)($value?:'Room')),'Map')===0?'Map':'Room'; ?>
    <select name="<?= e($name) ?>" data-map-arrow-target-type <?= $readonly?'disabled':'' ?>><option value="Room" <?= $targetType==='Room'?'selected':'' ?>>Another room in this map</option><option value="Map" <?= $targetType==='Map'?'selected':'' ?>>Another map</option></select>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($targetType) ?>"><?php endif; ?>

<?php elseif($isMapArrow&&$fieldLower==='targetframe'): ?>
    <div class="map-arrow-room-control" data-map-arrow-target-room-control>
        <select name="<?= e($name) ?>" data-map-arrow-target-frame data-current-frame="<?= e($value?:'Enter') ?>" <?= $readonly?'disabled':'' ?>><option value="<?= e($value?:'Enter') ?>" selected><?= e($value?:'Enter') ?></option></select>
        <input type="text" class="relation-search map-arrow-custom-room" value="" data-map-arrow-target-frame-custom placeholder="Custom destination room/frame..." autocomplete="off">
    </div>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>

<?php elseif($isMapArrow&&$fieldLower==='targetpad'): ?>
    <div class="map-arrow-room-control">
        <select name="<?= e($name) ?>" data-map-arrow-target-pad data-current-pad="<?= e($value?:'Spawn') ?>" <?= $readonly?'disabled':'' ?>><option value="<?= e($value?:'Spawn') ?>" selected><?= e($value?:'Spawn') ?></option></select>
        <input type="text" class="relation-search map-arrow-custom-room" value="" data-map-arrow-target-pad-custom placeholder="Custom pad (usually Spawn)..." autocomplete="off">
        <small class="field-help">Pad used when the player arrives. <code>Spawn</code> works for most rooms.</small>
    </div>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>

<?php elseif($isMapArrow&&$fieldLower==='enabled'): ?>
    <?php $enabled=(int)$value!==0; ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>><option value="1" <?= $enabled?'selected':'' ?>>Enabled</option><option value="0" <?= !$enabled?'selected':'' ?>>Disabled</option></select>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= $enabled?'1':'0' ?>"><?php endif; ?>

<?php elseif($isNpcPlacement&&$fieldLower==='frame'): ?>
    <select name="<?= e($name) ?>" data-map-frame-select data-current-frame="<?= e($value?:'Enter') ?>" <?= $readonly?'disabled':'' ?>><option value="<?= e($value?:'Enter') ?>" selected><?= e($value?:'Enter') ?></option></select>
    <small class="field-help">Frames are loaded from <code>maps_cells</code> and existing placements for the selected map.</small>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>

<?php elseif($isNpcPlacement&&$fieldLower==='turn'): ?>
    <?php $turn=str_starts_with(strtolower(trim((string)$value)),'l')?'Left':'Right'; ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>><option value="Right" <?= $turn==='Right'?'selected':'' ?>>Right</option><option value="Left" <?= $turn==='Left'?'selected':'' ?>>Left</option></select>
    <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($turn) ?>"><?php endif; ?>

<?php elseif($isNpcPlacement&&in_array($fieldLower,['x','y'],true)): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" step="0.01" inputmode="decimal" <?= $readonly?'readonly':'' ?>>

<?php elseif($isNpcPlacement&&$fieldLower==='npcmapid'): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" min="1" step="1" <?= $readonly?'readonly':'' ?>>
    <small class="field-help">Unique NPC instance ID inside this map.</small>

<?php elseif($fieldLower==='file'&&$filePicker): ?>
    <div class="relation-control" data-relation-control>
        <input type="search" class="relation-search" data-relation-search placeholder="Search available SWF files..." autocomplete="off" <?= $readonly?'disabled':'' ?>>
        <select name="<?= e($name) ?>" data-relation-select <?= $readonly?'disabled':'' ?>>
            <?php if($c['Null']==='YES'||$value===null||$value===''): ?>
                <option value="" <?= $value===null||$value===''?'selected':'' ?>>— None / no SWF —</option>
            <?php else: ?>
                <option value="">Select an SWF file...</option>
            <?php endif; ?>
            <?php
                $fileFound=false;
                foreach(($filePicker['options']??[]) as $opt):
                    $sel=(string)$value===(string)$opt['value'];
                    if($sel)$fileFound=true;
            ?>
                <option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option>
            <?php endforeach; ?>
            <?php if(!$fileFound&&$value!==null&&$value!==''): ?>
                <option value="<?= e($value) ?>" selected><?= e($value) ?> — current value (file not found)</option>
            <?php endif; ?>
        </select>
        <small class="field-help"><?= e($filePicker['help']??'Choose an available SWF file.') ?></small>
        <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>
    </div>

<?php elseif($relation): ?>
    <div class="relation-control" data-relation-control>
        <input type="search" class="relation-search" data-relation-search placeholder="Search <?= e($relation['table']) ?>..." autocomplete="off" <?= $readonly?'disabled':'' ?>>
        <select name="<?= e($name) ?>" data-relation-select <?= (($isNpcPlacement||$isMonsterPlacement)&&$fieldLower==='mapid')?'data-map-id-select':'' ?> <?= ($isMapArrow&&$fieldLower==='mapid')?'data-map-arrow-source-map':'' ?> <?= ($isMapArrow&&$fieldLower==='targetmapid')?'data-map-arrow-target-map':'' ?> <?= $readonly?'disabled':'' ?>>
            <?php if($c['Null']==='YES'||$value===null||$value===''): ?><option value="" <?= $value===null||$value===''?'selected':'' ?>>— None —</option><?php else: ?><option value="">Select...</option><?php endif; ?>
            <?php $found=false;foreach($relation['options'] as $opt):$sel=(string)$value===(string)$opt['value'];if($sel)$found=true; ?><option value="<?= e($opt['value']) ?>" <?= $sel?'selected':'' ?>><?= e($opt['label']) ?></option><?php endforeach; ?>
            <?php if(!$found&&$value!==null&&$value!==''): ?><option value="<?= e($value) ?>" selected>#<?= e($value) ?> — missing/deleted relation</option><?php endif; ?>
        </select>
        <?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>
    </div>

<?php elseif(preg_match('/text/i',(string)$c['Type'])): ?>
    <textarea name="<?= e($name) ?>" rows="5" <?= $readonly?'readonly':'' ?>><?= e($value) ?></textarea>
<?php elseif(preg_match('/enum\((.*)\)/i',(string)$c['Type'],$m)): $opts=str_getcsv($m[1],',',"'"); ?>
    <select name="<?= e($name) ?>" <?= $readonly?'disabled':'' ?>><?php foreach($opts as $o): ?><option value="<?= e($o) ?>" <?= (string)$value===(string)$o?'selected':'' ?>><?= e($o) ?></option><?php endforeach; ?></select><?php if($readonly): ?><input type="hidden" name="<?= e($name) ?>" value="<?= e($value) ?>"><?php endif; ?>
<?php elseif(preg_match('/int|double|float|decimal/i',(string)$c['Type'])): ?>
    <input type="number" name="<?= e($name) ?>" value="<?= e($value) ?>" step="<?= preg_match('/int/i',(string)$c['Type'])?'1':'any' ?>" <?= $readonly?'readonly':'' ?>>
<?php else: ?>
    <input name="<?= e($name) ?>" value="<?= e($value) ?>" <?= $readonly?'readonly':'' ?>>
<?php endif; ?>
</div>
<?php endforeach; ?>
</div>
<div class="form-actions"><a class="btn btn-ghost" href="/admin/data/<?= e($table) ?>">Cancel</a><button class="btn btn-gold" type="submit"><?= $mode==='create'?'Create Record':'Save Changes' ?></button></div>
<?php if($isNpcButton||$isNpcPlacement||$isMapArrow||$isMonsterPlacement): ?><script type="application/json" data-npc-map-cells-json><?= json_encode($editor['mapCells']??[],JSON_UNESCAPED_SLASHES|JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT) ?></script><?php endif; ?>
<?php if($isMapArrow): ?>
<script>
(function(){
    var form=document.currentScript&&document.currentScript.closest('form');
    if(!form)return;
    var direction=form.querySelector('[data-db-arrow-direction]');
    var rotation=form.querySelector('[data-db-arrow-rotation]');
    if(!direction||!rotation)return;

    direction.addEventListener('change',function(){
        var option=direction.options[direction.selectedIndex];
        if(!option)return;
        var angle=option.getAttribute('data-angle');
        if(angle!==null&&angle!=='')rotation.value=angle;
    });
})();
</script>
<?php endif; ?>
<?php if($isItem): ?>
<datalist id="item-link-values"><?php foreach(($itemFields['links']??[]) as $opt): ?><option value="<?= e($opt) ?>"></option><?php endforeach; ?></datalist>
<datalist id="item-meta-values"><?php foreach(($itemFields['meta']??[]) as $opt): ?><option value="<?= e($opt) ?>"></option><?php endforeach; ?></datalist>
<script type="application/json" data-item-type-defaults><?= json_encode($itemFields['typeDefaults']??[],JSON_UNESCAPED_SLASHES|JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT) ?></script>
<script>
(function(){
    var form=document.currentScript&&document.currentScript.closest('form');
    if(!form)return;
    var type=form.querySelector('[data-item-type]');
    var icon=form.querySelector('[data-item-icon]');
    var equipment=form.querySelector('[data-item-equipment]');
    var dataNode=form.querySelector('[data-item-type-defaults]');
    if(!type||!icon||!equipment||!dataNode)return;
    var defaults={};try{defaults=JSON.parse(dataNode.textContent||'{}');}catch(e){}
    var previousType=type.value;
    function applyDefaults(){
        var next=defaults[type.value]||null;
        var prev=defaults[previousType]||null;
        if(next){
            if(!icon.value||(prev&&icon.value===prev.icon))icon.value=next.icon||icon.value;
            if(!equipment.value||(prev&&equipment.value===prev.equipment))equipment.value=next.equipment||equipment.value;
        }
        previousType=type.value;
    }
    type.addEventListener('change',applyDefaults);
})();
</script>
<?php endif; ?>
</form></div>
<?php if(in_array($tableLower,['npcs','items','maps','monsters','hairs','classes','pets','pet','capes','helms','swords','axes','bows','daggers','guns','maces','polearms','staff','staves','houses','house_items'],true)): ?><div class="panel hint-panel"><h3><?= $isNpc?'NPC Images':'Gamefile SWFs' ?></h3><?php if($isNpc): ?><p>NPC image assets are stored in <code>public/gamefiles/npcs/</code>. You can upload them directly from the Image field above; the image selector refreshes from that folder.</p><?php else: ?><p>The selector above is built from the SWFs currently present under <code>public/gamefiles</code>. Add a new SWF from the <a href="/admin/files">Assets tab</a>, then refresh this form and it will appear automatically.</p><?php endif; ?><?php if($tableLower==='items'): ?><p>Items include weapons, capes, helms, pets, grounds, houses/house items, and class armor. Class armor scans both <code>classes/M</code> and <code>classes/F</code>.</p><?php elseif($tableLower==='classes'): ?><p>Classes do not have a separate File column in this schema. Choose the linked class ItemID; the selector is limited to class items and shows the SWF filename attached to each item.</p><?php endif; ?></div><?php endif; ?>
<?php $content=ob_get_clean();require __DIR__.'/../../layouts/admin.php'; ?>
