<?php
declare(strict_types=1);

$title = 'Wiki';
ob_start();

$labels = ['items' => 'Items', 'maps' => 'Maps', 'monsters' => 'Monsters', 'quests' => 'Quests'];
$label = $labels[$type] ?? 'Wiki';
$base = '/wiki?type=' . urlencode($type);
if ($q !== '') $base .= '&q=' . urlencode($q);
$pages = max(1, (int)ceil($total / 50));
$fmt = static fn($v): string => number_format((int)$v);

$money = static function (array $row): string {
    $cost = (int)($row['Cost'] ?? 0);
    if ($cost === 0) return 'Free';
    return number_format($cost) . ' ' . ((int)($row['Coins'] ?? 0) === 1 ? 'Coins' : 'Gold');
};

// Build the real public SWF URL. The database may store only a basename,
// while the public gamefiles directory is organized by asset type.
$previewUrl = null;
if ($detail && in_array($type, ['items', 'maps', 'monsters'], true)) {
    $file = trim(str_replace('\\', '/', (string)($detail['File'] ?? '')));
    $name = basename($file);
    if ($name !== '' && preg_match('/\.swf$/i', $name)) {
        if ($type === 'items' && strcasecmp((string)($detail['Type'] ?? ''), 'Class') === 0) {
            $previewUrl = '/gamefiles/classes/M/' . rawurlencode($name);
        } elseif ($type === 'maps') {
            $previewUrl = '/gamefiles/maps/' . rawurlencode($name);
        } elseif ($type === 'monsters') {
            $previewUrl = '/gamefiles/mon/' . rawurlencode($name);
        } elseif (str_contains($file, '/')) {
            $previewUrl = '/gamefiles/' . str_replace('%2F', '/', rawurlencode(ltrim($file, '/')));
        } else {
            $previewUrl = '/gamefiles/' . rawurlencode($name);
        }
    }
}
?>
<style>
.wk{max-width:1220px;margin:auto;padding:26px 0 60px}.wk-hero,.wk-detail,.wk-card,.wk-table,.wk-nav,.wk-search{border:1px solid rgba(255,255,255,.08);background:rgba(12,15,20,.62);border-radius:14px}.wk-hero{padding:30px;background:linear-gradient(135deg,rgba(205,164,76,.15),rgba(255,255,255,.025));margin-bottom:18px}.wk-k{color:#cda44c;font-size:11px;font-weight:800;letter-spacing:.18em;text-transform:uppercase}.wk h1{margin:6px 0;font-size:38px}.wk p{color:rgba(255,255,255,.68);line-height:1.65}.wk-nav{display:flex;gap:8px;padding:8px;flex-wrap:wrap}.wk-nav a{padding:10px 14px;border-radius:10px;color:rgba(255,255,255,.7);text-decoration:none}.wk-nav a.active,.wk-nav a:hover{background:rgba(205,164,76,.12);color:#fff}.wk-search{padding:13px 15px;width:100%;box-sizing:border-box;color:#fff;margin:14px 0;background:rgba(255,255,255,.025)}.wk-search::placeholder{color:rgba(255,255,255,.35)}
.wk-list{overflow:auto}.wk-table{width:100%;border-collapse:collapse}.wk-table th,.wk-table td{padding:12px 13px;text-align:left;border-bottom:1px solid rgba(255,255,255,.06);font-size:13px}.wk-table th{font-size:10px;letter-spacing:.08em;text-transform:uppercase;color:rgba(255,255,255,.42)}.wk-table td{color:rgba(255,255,255,.72)}.wk-table a{color:#e5c36b;text-decoration:none}.wk-desc{max-width:520px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.wk-pager{display:flex;justify-content:space-between;gap:12px;margin-top:14px}.wk-btn{display:inline-block;padding:10px 14px;border-radius:9px;background:rgba(255,255,255,.05);color:#fff;text-decoration:none;border:1px solid rgba(255,255,255,.06)}.wk-btn:hover{background:rgba(255,255,255,.08)}
.wk-tabs{display:flex;gap:6px;margin-bottom:12px}.wk-tab{appearance:none;border:1px solid rgba(255,255,255,.08);background:rgba(255,255,255,.035);color:rgba(255,255,255,.68);padding:10px 14px;border-radius:9px;cursor:pointer;font-weight:700}.wk-tab.active{background:rgba(205,164,76,.14);color:#fff;border-color:rgba(205,164,76,.35)}.wk-panel{display:none}.wk-panel.active{display:block}.wk-preview{height:560px;background:#090b0f;border:1px solid rgba(255,255,255,.08);border-radius:12px;overflow:hidden;display:flex;align-items:center;justify-content:center}.wk-preview ruffle-player{width:100%;height:100%;display:block}.wk-empty{padding:30px;text-align:center;color:rgba(255,255,255,.45)}
.wk-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}.wk-detail{padding:24px}.wk-meta{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:8px;margin:18px 0}.wk-stat{padding:12px;border-radius:10px;background:rgba(255,255,255,.035)}.wk-stat b{display:block;font-size:10px;color:rgba(255,255,255,.4);text-transform:uppercase;letter-spacing:.08em;margin-bottom:4px}.wk-stat span{color:#fff}.wk-section{margin-top:18px}.wk-section h3{margin:0 0 10px}.wk-note{padding:12px;border-left:3px solid #cda44c;background:rgba(205,164,76,.07);border-radius:7px;margin-top:14px;color:rgba(255,255,255,.7)}
@media(max-width:850px){.wk-grid{grid-template-columns:1fr}.wk-meta{grid-template-columns:repeat(2,1fr)}.wk h1{font-size:32px}.wk-preview{height:400px}}
</style>

<div class="wk">
<section class="wk-hero"><div class="wk-k">Aera Game Database</div><h1><?= e($detail['Name'] ?? $label) ?></h1><p><?= $detail ? 'Database entry with stats, requirements, rewards and locations.' : 'Browse Aera items, maps, monsters and quests.' ?></p></section>
<nav class="wk-nav"><?php foreach ($counts as $t => $c): ?><a class="<?= $type === $t ? 'active' : '' ?>" href="/wiki?type=<?= urlencode($t) ?>"><?= e(ucfirst($t)) ?> <small>(<?= $fmt($c) ?>)</small></a><?php endforeach; ?></nav>

<?php if ($detail): ?>
<div style="margin:14px 0"><a class="wk-btn" href="<?= e($base) ?>">← Back to <?= e($label) ?></a></div>
<section class="wk-detail">
<?php if ($previewUrl): ?><div class="wk-tabs"><button class="wk-tab active" type="button" data-tab="details">Details</button><button class="wk-tab" type="button" data-tab="preview">SWF Preview</button></div><div class="wk-panel active" data-panel="details"><?php endif; ?>

<?php if ($type === 'items'): ?>
<div class="wk-meta"><?php foreach ([['ID','id'],['Type','Type'],['Level','Level'],['Rarity','Rarity'],['Cost','Cost'],['Stack','Stack'],['DPS','DPS']] as [$k,$f]): ?><div class="wk-stat"><b><?= e($k) ?></b><span><?= $k === 'Cost' ? e($money($detail)) : e($detail[$f] ?? '0') ?></span></div><?php endforeach; ?></div>
<p><?= nl2br(e($detail['Description'] ?? '')) ?></p>
<div class="wk-grid"><div class="wk-card"><h3>Item Data</h3><p>Element: <?= e($detail['Element'] ?? 'None') ?><br>Range: <?= e($detail['Range'] ?? 0) ?><br>Icon: <?= e($detail['Icon'] ?? '') ?></p></div><div class="wk-card"><h3>Requirements</h3><p>Reputation: <?= $fmt($detail['ReqReputation'] ?? 0) ?><br>Class ID: <?= $fmt($detail['ReqClassID'] ?? 0) ?><br>Required Quests: <?= e($detail['ReqQuests'] ?? '') ?></p></div></div>
<div class="wk-section wk-card"><h3>Where to find it</h3><?php if ($related['shops'] ?? []): ?><p><b>Shops:</b> <?php foreach ($related['shops'] as $x): ?><?= e($x['Name']) ?>, <?php endforeach; ?></p><?php endif; ?><?php if ($related['maps'] ?? []): ?><p><b>Maps:</b> <?php foreach ($related['maps'] as $x): ?><a href="/wiki?type=maps&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a>, <?php endforeach; ?></p><?php endif; ?><?php if (!($related['shops'] ?? []) && !($related['maps'] ?? []) && !($related['drops'] ?? []) && !($related['questRewards'] ?? [])): ?><div class="wk-empty">No source data recorded.</div><?php endif; ?></div>
<div class="wk-grid"><div class="wk-card"><h3>Monster Drops</h3><?php if ($related['drops'] ?? []): ?><ul><?php foreach ($related['drops'] as $x): ?><li><a href="/wiki?type=monsters&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — ×<?= $fmt($x['Quantity']) ?>, <?= e($x['Chance']) ?>%</li><?php endforeach; ?></ul><?php else: ?><p>No drops recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Quest Rewards</h3><?php if ($related['questRewards'] ?? []): ?><ul><?php foreach ($related['questRewards'] as $x): ?><li><a href="/wiki?type=quests&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — ×<?= $fmt($x['Quantity']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No quest rewards recorded.</p><?php endif; ?></div></div>

<?php elseif ($type === 'maps'): ?>
<div class="wk-meta"><?php foreach ([['ID','id'],['Max Players','MaxPlayers'],['Required Level','ReqLevel'],['PvP','PvP'],['Upgrade','Upgrade']] as [$k,$f]): ?><div class="wk-stat"><b><?= e($k) ?></b><span><?= e($detail[$f] ?? 0) ?></span></div><?php endforeach; ?></div>
<div class="wk-grid"><div class="wk-card"><h3>Monsters</h3><?php if ($related['monsters'] ?? []): ?><ul><?php foreach ($related['monsters'] as $x): ?><li><a href="/wiki?type=monsters&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — <?= e($x['Frame']) ?></li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div><div class="wk-card"><h3>NPCs</h3><?php if ($related['npcs'] ?? []): ?><ul><?php foreach ($related['npcs'] as $x): ?><li><?= e($x['Name']) ?> — <?= e($x['Frame']) ?></li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Map Items</h3><?php if ($related['items'] ?? []): ?><ul><?php foreach ($related['items'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Exits</h3><?php if ($related['arrows'] ?? []): ?><ul><?php foreach ($related['arrows'] as $x): ?><li><?= e($x['Frame']) ?> → <?= e($x['TargetMapName'] ?? 'Room') ?> / <?= e($x['TargetFrame']) ?></li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div></div>

<?php elseif ($type === 'monsters'): ?>
<div class="wk-meta"><?php foreach ([['ID','id'],['Level','Level'],['Health','Health'],['Mana','Mana'],['Gold','Gold'],['Coins','Coin'],['EXP','Experience'],['DPS','DPS'],['Respawn','Respawn']] as [$k,$f]): ?><div class="wk-stat"><b><?= e($k) ?></b><span><?= $fmt($detail[$f] ?? 0) ?></span></div><?php endforeach; ?></div>
<div class="wk-note">Damage Reduction: <?= e($detail['DamageReduction'] ?? 0) ?></div><div class="wk-grid"><div class="wk-card"><h3>Where to find it</h3><?php if ($related['maps'] ?? []): ?><ul><?php foreach ($related['maps'] as $x): ?><li><a href="/wiki?type=maps&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — <?= e($x['Frame']) ?></li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Drops</h3><?php if ($related['drops'] ?? []): ?><ul><?php foreach ($related['drops'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — ×<?= $fmt($x['Quantity']) ?>, <?= e($x['Chance']) ?>%</li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div></div>

<?php else: ?>
<div class="wk-meta"><?php foreach ([['ID','id'],['Level','Level'],['EXP','Experience'],['Gold','Gold'],['Coins','Coins'],['Reputation','Reputation'],['Class Points','ClassPoints']] as [$k,$f]): ?><div class="wk-stat"><b><?= e($k) ?></b><span><?= $fmt($detail[$f] ?? 0) ?></span></div><?php endforeach; ?></div><p><?= nl2br(e($detail['Description'] ?? '')) ?></p><div class="wk-grid"><div class="wk-card"><h3>Requirements</h3><?php if ($related['requiredItems'] ?? []): ?><ul><?php foreach ($related['requiredItems'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> ×<?= $fmt($x['Quantity']) ?></li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Rewards</h3><?php if ($related['rewards'] ?? []): ?><ul><?php foreach ($related['rewards'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> ×<?= $fmt($x['Quantity']) ?> (<?= e($x['Rate']) ?>%)</li><?php endforeach; ?></ul><?php else: ?><p>None recorded.</p><?php endif; ?></div></div>
<?php endif; ?>

<?php if ($previewUrl): ?></div><div class="wk-panel" data-panel="preview"><div class="wk-preview"><div class="wk-empty">Open the SWF Preview tab to load this asset with Ruffle.</div></div></div><?php endif; ?>
</section>
<?php else: ?>
<form method="get"><input type="hidden" name="type" value="<?= e($type) ?>"><input class="wk-search" name="q" type="search" value="<?= e($q) ?>" placeholder="Search <?= e(strtolower($label)) ?> by name…"></form>
<section class="wk-list"><table class="wk-table"><thead><tr><?php if ($type === 'items'): ?><th>Name</th><th>Type</th><th>Level</th><th>Cost</th><th>Description</th><?php elseif ($type === 'maps'): ?><th>Name</th><th>Level</th><th>Players</th><th>PvP</th><?php elseif ($type === 'monsters'): ?><th>Name</th><th>Level</th><th>Health</th><th>Gold</th><th>EXP</th><th>DPS</th><?php else: ?><th>Name</th><th>Level</th><th>EXP</th><th>Gold</th><th>Coins</th><th>Description</th><?php endif; ?></tr></thead><tbody>
<?php foreach ($rows as $x): ?><tr><?php if ($type === 'items'): ?><td><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= e($x['Type']) ?></td><td><?= $fmt($x['Level']) ?></td><td><?= e($money($x)) ?></td><td class="wk-desc"><?= e($x['Description']) ?></td><?php elseif ($type === 'maps'): ?><td><a href="/wiki?type=maps&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= $fmt($x['ReqLevel']) ?></td><td><?= $fmt($x['MaxPlayers']) ?></td><td><?= ((int)$x['PvP']) ? 'Yes' : 'No' ?></td><?php elseif ($type === 'monsters'): ?><td><a href="/wiki?type=monsters&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= $fmt($x['Level']) ?></td><td><?= $fmt($x['Health']) ?></td><td><?= $fmt($x['Gold']) ?></td><td><?= $fmt($x['Experience']) ?></td><td><?= $fmt($x['DPS']) ?></td><?php else: ?><td><a href="/wiki?type=quests&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= $fmt($x['Level']) ?></td><td><?= $fmt($x['Experience']) ?></td><td><?= $fmt($x['Gold']) ?></td><td><?= $fmt($x['Coins']) ?></td><td class="wk-desc"><?= e($x['Description']) ?></td><?php endif; ?></tr><?php endforeach; ?>
<?php if (!$rows): ?><tr><td colspan="6" class="wk-empty">No entries found.</td></tr><?php endif; ?></tbody></table></section>
<?php if ($pages > 1): ?><div class="wk-pager"><span style="color:rgba(255,255,255,.45);padding:10px 0">Page <?= $fmt($page) ?> of <?= $fmt($pages) ?></span><span><?php if ($page > 1): ?><a class="wk-btn" href="<?= e($base) ?>&page=<?= $page - 1 ?>">← Previous</a><?php endif; ?> <?php if ($page < $pages): ?><a class="wk-btn" href="<?= e($base) ?>&page=<?= $page + 1 ?>">Next →</a><?php endif; ?></span></div><?php endif; ?>
<?php endif; ?>
</div>

<?php if ($previewUrl): ?><script src="https://unpkg.com/@ruffle-rs/ruffle"></script><script>
(function(){
const tabs=document.querySelectorAll('[data-tab]'), panels=document.querySelectorAll('[data-panel]');
const preview=document.querySelector('.wk-preview'); let loaded=false;
function activate(name){
 tabs.forEach(t=>t.classList.toggle('active',t.dataset.tab===name));
 panels.forEach(p=>p.classList.toggle('active',p.dataset.panel===name));
 if(name!=='preview'||loaded||!preview)return; loaded=true;
 const factory=window.RufflePlayer&&window.RufflePlayer.newest();
 if(!factory){preview.innerHTML='<div class="wk-empty">Ruffle could not initialize.</div>';return;}
 const player=factory.createPlayer(); player.style.width='100%'; player.style.height='100%'; preview.innerHTML=''; preview.appendChild(player);
 player.ruffle().load({url:<?= json_encode($previewUrl, JSON_UNESCAPED_SLASHES) ?>,allowScriptAccess:false,showSwfDownload:false,contextMenu:true,preloader:true}).catch(function(){preview.innerHTML='<div class="wk-empty">This SWF could not be loaded.</div>';});
}
tabs.forEach(t=>t.addEventListener('click',()=>activate(t.dataset.tab)));
})();
</script><?php endif; ?>
<?php
$content = ob_get_clean();
include __DIR__ . '/layouts/site.php';
