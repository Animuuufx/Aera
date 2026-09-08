<?php
declare(strict_types=1);

$title = 'Wiki';
ob_start();

$label = ['items'=>'Items','maps'=>'Maps','monsters'=>'Monsters','quests'=>'Quests'][$type] ?? 'Wiki';
$base = '/wiki?type=' . urlencode($type);
if ($q !== '') $base .= '&q=' . urlencode($q);
$pages = max(1, (int)ceil($total / 50));
$fmt = static fn($v) => number_format((int)$v);
$money = static function ($row) {
    $v = (int)($row['Cost'] ?? 0);
    return $v <= 0 ? 'Free' : $v . ' ' . ((int)($row['Coins'] ?? 0) ? 'Coins' : 'Gold');
};

$swfUrl = static function (?string $link, ?string $file): ?string {
    foreach ([$link, $file] as $value) {
        $value = trim((string)$value);
        if ($value === '' || !preg_match('/\.swf(?:[?#].*)?$/i', $value)) continue;
        if (preg_match('#^https?://#i', $value)) return $value;
        if (str_starts_with($value, '/')) return $value;
        return '/gamefiles/' . ltrim($value, '/');
    }
    return null;
};

$previewUrl = null;
if ($detail && in_array($type, ['items', 'maps', 'monsters'], true)) {
    $previewUrl = $swfUrl($detail['Link'] ?? null, $detail['File'] ?? null);
}
?>
<style>
.wk{max-width:1220px;margin:auto;padding:26px 0 60px}.wk-hero{padding:30px;border-radius:18px;border:1px solid rgba(255,255,255,.08);background:linear-gradient(135deg,rgba(205,164,76,.15),rgba(255,255,255,.025));margin-bottom:18px}.wk-k{color:#cda44c;font-size:11px;font-weight:800;letter-spacing:.18em;text-transform:uppercase}.wk h1{margin:6px 0;font-size:38px}.wk p{color:rgba(255,255,255,.68);line-height:1.65}.wk-nav,.wk-search,.wk-card,.wk-detail,.wk-table{border:1px solid rgba(255,255,255,.08);background:rgba(12,15,20,.62);border-radius:14px}.wk-nav{display:flex;gap:8px;padding:8px;flex-wrap:wrap}.wk-nav a{padding:10px 14px;border-radius:10px;color:rgba(255,255,255,.7);text-decoration:none}.wk-nav a.active,.wk-nav a:hover{background:rgba(205,164,76,.12);color:#fff}.wk-search{padding:13px 15px;width:100%;box-sizing:border-box;color:#fff;margin:14px 0;background:rgba(255,255,255,.025)}.wk-search::placeholder{color:rgba(255,255,255,.35)}
.wk-list{overflow:auto}.wk-table{width:100%;border-collapse:collapse}.wk-table th,.wk-table td{padding:12px 13px;text-align:left;border-bottom:1px solid rgba(255,255,255,.06);font-size:13px}.wk-table th{font-size:10px;letter-spacing:.08em;text-transform:uppercase;color:rgba(255,255,255,.42)}.wk-table td{color:rgba(255,255,255,.72)}.wk-table a{color:#e5c36b;text-decoration:none}.wk-desc{max-width:520px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.wk-pager{display:flex;justify-content:space-between;gap:12px;margin-top:14px}.wk-btn{display:inline-block;padding:10px 14px;border-radius:9px;background:rgba(255,255,255,.05);color:#fff;text-decoration:none;border:1px solid rgba(255,255,255,.06);cursor:pointer}.wk-btn:hover{background:rgba(255,255,255,.08)}
.wk-tabs{display:flex;gap:6px;margin-bottom:12px}.wk-tab{appearance:none;border:1px solid rgba(255,255,255,.08);background:rgba(255,255,255,.035);color:rgba(255,255,255,.68);padding:10px 14px;border-radius:9px;cursor:pointer;font-weight:700}.wk-tab.active{background:rgba(205,164,76,.14);color:#fff;border-color:rgba(205,164,76,.35)}.wk-panel{display:none}.wk-panel.active{display:block}.wk-preview{min-height:520px;background:#090b0f;border:1px solid rgba(255,255,255,.08);border-radius:12px;overflow:hidden;display:flex;align-items:center;justify-content:center}.wk-preview ruffle-player{width:100%;height:560px;display:block}.wk-preview-empty{padding:44px;text-align:center;color:rgba(255,255,255,.46)}
.wk-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}.wk-detail{padding:24px}.wk-detail h2{margin:0 0 5px}.wk-meta{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:8px;margin:18px 0}.wk-stat{padding:12px;border-radius:10px;background:rgba(255,255,255,.035)}.wk-stat b{display:block;font-size:10px;color:rgba(255,255,255,.4);text-transform:uppercase;letter-spacing:.08em;margin-bottom:4px}.wk-stat span{color:#fff}.wk-section{margin-top:18px}.wk-section h3{margin:0 0 10px}.wk-note{padding:12px;border-left:3px solid #cda44c;background:rgba(205,164,76,.07);border-radius:7px;margin-top:14px;color:rgba(255,255,255,.7)}.wk-empty{padding:18px;text-align:center;color:rgba(255,255,255,.45)}
@media(max-width:850px){.wk-grid{grid-template-columns:1fr}.wk-meta{grid-template-columns:repeat(2,1fr)}.wk h1{font-size:32px}.wk-preview{min-height:360px}.wk-preview ruffle-player{height:400px}}
</style>

<div class="wk">
 <section class="wk-hero"><div class="wk-k">Aera Game Database</div><h1><?= $detail ? e($detail['Name'] ?? $label) : 'Wiki' ?></h1><p><?= $detail ? 'Complete database entry with stats, requirements, rewards, shops and locations where the server data provides them.' : 'Browse the actual Aera game database. Search every item, map, monster and quest, then open an entry for its full details and related locations.' ?></p></section>
 <nav class="wk-nav">
 <?php foreach ($counts as $t => $c): ?><a class="<?= $type === $t ? 'active' : '' ?>" href="/wiki?type=<?= $t ?>"><?= ucfirst($t) ?> <small>(<?= $fmt($c) ?>)</small></a><?php endforeach; ?>
 </nav>

 <?php if ($detail): ?>
   <div style="margin:14px 0"><a class="wk-btn" href="<?= $base ?>">← Back to <?= e($label) ?></a></div>

   <section class="wk-detail">
    <?php if ($previewUrl): ?>
      <div class="wk-tabs" role="tablist" aria-label="Wiki entry views">
        <button class="wk-tab active" type="button" data-wk-tab="details">Details</button>
        <button class="wk-tab" type="button" data-wk-tab="preview">SWF Preview</button>
      </div>
      <div class="wk-panel active" data-wk-panel="details">
    <?php endif; ?>

    <?php if ($type === 'items'): ?>
      <div class="wk-meta">
       <?php foreach ([['ID','id'],['Type','Type'],['Equipment','Equipment'],['Level','Level'],['Rarity','Rarity'],['Price','Cost'],['Stack','Stack'],['DPS','DPS']] as [$k,$f]): ?><div class="wk-stat"><b><?= $k ?></b><span><?= $k === 'Price' ? e($money($detail)) : e($detail[$f] ?? '0') ?></span></div><?php endforeach; ?>
      </div>
      <p><?= nl2br(e($detail['Description'] ?? '')) ?></p>
      <div class="wk-grid">
       <div class="wk-card"><h3>Item Data</h3><p>Element: <?= e($detail['Element'] ?? 'None') ?><br>Range: <?= e($detail['Range'] ?? 0) ?><br>Icon: <?= e($detail['Icon'] ?? '') ?></p></div>
       <div class="wk-card"><h3>Requirements</h3><?php if ($detail['ReqReputation'] || $detail['ReqClassID'] || $detail['ReqQuests']): ?><p>Reputation: <?= $fmt($detail['ReqReputation']) ?><br>Class ID: <?= $fmt($detail['ReqClassID']) ?><br>Required Quests: <?= e($detail['ReqQuests'] ?? '') ?></p><?php else: ?><p>No special requirements recorded.</p><?php endif; ?></div>
      </div>
      <div class="wk-section wk-card"><h3>Where to find it</h3><?php if ($related['shops'] ?? []): ?><p><b>Shops:</b> <?php foreach ($related['shops'] as $x): ?><span><?= e($x['Name']) ?></span> (stock <?= $fmt($x['QuantityRemain']) ?>), <?php endforeach; ?></p><?php endif; ?><?php if ($related['maps'] ?? []): ?><p><b>Maps:</b> <?php foreach ($related['maps'] as $x): ?><a href="/wiki?type=maps&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a>, <?php endforeach; ?></p><?php endif; ?><?php if (!($related['shops'] ?? []) && !($related['maps'] ?? [])): ?><div class="wk-empty">No shop or map source is recorded for this item.</div><?php endif; ?></div>
      <div class="wk-grid"><div class="wk-card"><h3>Monster Drops</h3><?php if ($related['drops'] ?? []): ?><ul><?php foreach ($related['drops'] as $x): ?><li><a href="/wiki?type=monsters&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — ×<?= $fmt($x['Quantity']) ?>, <?= e($x['Chance']) ?>%</li><?php endforeach; ?></ul><?php else: ?><p>No monster drop record.</p><?php endif; ?></div><div class="wk-card"><h3>Quest Rewards</h3><?php if ($related['questRewards'] ?? []): ?><ul><?php foreach ($related['questRewards'] as $x): ?><li><a href="/wiki?type=quests&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — ×<?= $fmt($x['Quantity']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No quest reward record.</p><?php endif; ?></div></div>

    <?php elseif ($type === 'maps'): ?>
      <div class="wk-meta"><?php foreach ([['ID','id'],['Max Players','MaxPlayers'],['Required Level','ReqLevel'],['PvP','PvP'],['Upgrade','Upgrade']] as [$k,$f]): ?><div class="wk-stat"><b><?= $k ?></b><span><?= e($detail[$f] ?? 0) ?></span></div><?php endforeach; ?></div>
      <div class="wk-grid"><div class="wk-card"><h3>Monsters</h3><?php if ($related['monsters'] ?? []): ?><ul><?php foreach ($related['monsters'] as $x): ?><li><a href="/wiki?type=monsters&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — Room <?= e($x['Frame']) ?>, Spawn #<?= $fmt($x['MonMapID']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No monsters placed here.</p><?php endif; ?></div><div class="wk-card"><h3>NPCs</h3><?php if ($related['npcs'] ?? []): ?><ul><?php foreach ($related['npcs'] as $x): ?><li><?= e($x['Name']) ?> — Room <?= e($x['Frame']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No NPC placements recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Map Items</h3><?php if ($related['items'] ?? []): ?><ul><?php foreach ($related['items'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — <?= e($x['Type']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No map item records.</p><?php endif; ?></div><div class="wk-card"><h3>Exits</h3><?php if ($related['arrows'] ?? []): ?><ul><?php foreach ($related['arrows'] as $x): ?><li><?= e($x['Frame']) ?> → <?= e($x['TargetMapName'] ?? 'Room') ?> / <?= e($x['TargetFrame']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No map transition records.</p><?php endif; ?></div></div>

    <?php elseif ($type === 'monsters'): ?>
      <div class="wk-meta"><?php foreach ([['ID','id'],['Level','Level'],['Health','Health'],['Mana','Mana'],['Gold','Gold'],['Coins','Coin'],['EXP','Experience'],['DPS','DPS'],['Respawn','Respawn']] as [$k,$f]): ?><div class="wk-stat"><b><?= $k ?></b><span><?= $fmt($detail[$f] ?? 0) ?></span></div><?php endforeach; ?></div>
      <div class="wk-note">Damage Reduction: <?= e($detail['DamageReduction'] ?? 0) ?></div>
      <div class="wk-grid"><div class="wk-card"><h3>Where to find it</h3><?php if ($related['maps'] ?? []): ?><ul><?php foreach ($related['maps'] as $x): ?><li><a href="/wiki?type=maps&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — Room <?= e($x['Frame']) ?>, Spawn #<?= $fmt($x['MonMapID']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No map placement recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Drops</h3><?php if ($related['drops'] ?? []): ?><ul><?php foreach ($related['drops'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> — ×<?= $fmt($x['Quantity']) ?>, <?= e($x['Chance']) ?>%</li><?php endforeach; ?></ul><?php else: ?><p>No drops recorded.</p><?php endif; ?></div></div>
      <div class="wk-card"><h3>Skills</h3><?php if ($related['skills'] ?? []): ?><ul><?php foreach ($related['skills'] as $x): ?><li><b><?= e($x['Name']) ?></b> — <?= e($x['Description']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No monster skills assigned.</p><?php endif; ?></div>

    <?php else: ?>
      <div class="wk-meta"><?php foreach ([['ID','id'],['Level','Level'],['EXP','Experience'],['Gold','Gold'],['Coins','Coins'],['Reputation','Reputation'],['Class Points','ClassPoints']] as [$k,$f]): ?><div class="wk-stat"><b><?= $k ?></b><span><?= $fmt($detail[$f] ?? 0) ?></span></div><?php endforeach; ?></div>
      <p><?= nl2br(e($detail['Description'] ?? '')) ?></p>
      <div class="wk-note"><?= e($detail['EndText'] ?? '') ?></div>
      <div class="wk-grid"><div class="wk-card"><h3>Requirements</h3><?php if ($related['requiredItems'] ?? []): ?><ul><?php foreach ($related['requiredItems'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> ×<?= $fmt($x['Quantity']) ?></li><?php endforeach; ?></ul><?php else: ?><p>No item requirements recorded.</p><?php endif; ?></div><div class="wk-card"><h3>Rewards</h3><?php if ($related['rewards'] ?? []): ?><ul><?php foreach ($related['rewards'] as $x): ?><li><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a> ×<?= $fmt($x['Quantity']) ?> (<?= e($x['Rate']) ?>%)</li><?php endforeach; ?></ul><?php else: ?><p>No item rewards recorded.</p><?php endif; ?></div></div>
      <div class="wk-card"><h3>Where to start</h3><?php if ($related['sourceNpc'] ?? []): ?><ul><?php foreach ($related['sourceNpc'] as $x): ?><li><?= e($x['Name']) ?> in <a href="/wiki?type=maps&id=<?= $x['MapID'] ?>"><?= e($x['MapName']) ?></a></li><?php endforeach; ?></ul><?php else: ?><p>No quest-giver location is linked in the current NPC button data.</p><?php endif; ?></div>
    <?php endif; ?>

    <?php if ($previewUrl): ?>
      </div>
      <div class="wk-panel" data-wk-panel="preview">
        <div class="wk-preview" data-wk-preview data-swf-url="<?= e($previewUrl) ?>">
          <div class="wk-preview-empty">Click the SWF Preview tab to load this asset with Ruffle.</div>
        </div>
      </div>
    <?php endif; ?>
   </section>

 <?php else: ?>
   <form method="get"><input type="hidden" name="type" value="<?= e($type) ?>"><input class="wk-search" type="search" name="q" value="<?= e($q) ?>" placeholder="Search <?= strtolower($label) ?> by name…"></form>
   <section class="wk-list"><table class="wk-table"><thead><tr><?php if ($type === 'items'): ?><th>Name</th><th>Type</th><th>Equipment</th><th>Level</th><th>Cost</th><th>Description</th><?php elseif ($type === 'maps'): ?><th>Name</th><th>Level</th><th>Players</th><th>PvP</th><?php elseif ($type === 'monsters'): ?><th>Name</th><th>Level</th><th>Health</th><th>Gold</th><th>EXP</th><th>DPS</th><?php else: ?><th>Name</th><th>Level</th><th>EXP</th><th>Gold</th><th>Coins</th><th>Description</th><?php endif; ?></tr></thead><tbody>
   <?php if (!$rows): ?><tr><td colspan="6" class="wk-empty">No entries found.</td></tr><?php endif; ?>
   <?php foreach ($rows as $x): ?><tr>
    <?php if ($type === 'items'): ?><td><a href="/wiki?type=items&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= e($x['Type']) ?></td><td><?= e($x['Equipment']) ?></td><td><?= $fmt($x['Level']) ?></td><td><?= e($money($x)) ?></td><td class="wk-desc"><?= e($x['Description']) ?></td>
    <?php elseif ($type === 'maps'): ?><td><a href="/wiki?type=maps&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= $fmt($x['ReqLevel']) ?></td><td><?= $fmt($x['MaxPlayers']) ?></td><td><?= ((int)$x['PvP']) ? 'Yes' : 'No' ?></td>
    <?php elseif ($type === 'monsters'): ?><td><a href="/wiki?type=monsters&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= $fmt($x['Level']) ?></td><td><?= $fmt($x['Health']) ?></td><td><?= $fmt($x['Gold']) ?></td><td><?= $fmt($x['Experience']) ?></td><td><?= $fmt($x['DPS']) ?></td>
    <?php else: ?><td><a href="/wiki?type=quests&id=<?= $x['id'] ?>"><?= e($x['Name']) ?></a></td><td><?= $fmt($x['Level']) ?></td><td><?= $fmt($x['Experience']) ?></td><td><?= $fmt($x['Gold']) ?></td><td><?= $fmt($x['Coins']) ?></td><td class="wk-desc"><?= e($x['Description']) ?></td><?php endif; ?>
   </tr><?php endforeach; ?></tbody></table></section>
   <?php if ($pages > 1): ?><div class="wk-pager"><?php if ($page > 1): ?><a class="wk-btn" href="<?= $base ?>&page=<?= $page - 1 ?>">← Previous</a><?php else: ?><span></span><?php endif; ?> <span style="color:rgba(255,255,255,.45);padding:10px 0">Page <?= $fmt($page) ?> of <?= $fmt($pages) ?></span><?php if ($page < $pages): ?><a class="wk-btn" href="<?= $base ?>&page=<?= $page + 1 ?>">Next →</a><?php endif; ?></div><?php endif; ?>
 <?php endif; ?>
</div>

<?php if ($previewUrl): ?>
<script src="https://unpkg.com/@ruffle-rs/ruffle"></script>
<script>
(function () {
  const tabs = document.querySelectorAll('[data-wk-tab]');
  const panels = document.querySelectorAll('[data-wk-panel]');
  const preview = document.querySelector('[data-wk-preview]');
  let loaded = false;

  function activate(name) {
    tabs.forEach(tab => tab.classList.toggle('active', tab.dataset.wkTab === name));
    panels.forEach(panel => panel.classList.toggle('active', panel.dataset.wkPanel === name));

    if (name !== 'preview' || loaded || !preview) return;
    loaded = true;

    try {
      const ruffleFactory = window.RufflePlayer && window.RufflePlayer.newest();
      if (!ruffleFactory) throw new Error('Ruffle failed to initialize.');

      const player = ruffleFactory.createPlayer();
      player.style.width = '100%';
      player.style.height = '560px';
      preview.innerHTML = '';
      preview.appendChild(player);

      player.ruffle().load({
        url: preview.dataset.swfUrl,
        allowScriptAccess: false,
        showSwfDownload: false,
        contextMenu: true,
        splashScreen: true,
        preloader: true
      }).catch(function (error) {
        preview.innerHTML = '<div class="wk-preview-empty">Ruffle could not load this SWF preview.</div>';
        console.error('[Aera Wiki] Ruffle load failed:', error);
      });
    } catch (error) {
      preview.innerHTML = '<div class="wk-preview-empty">Ruffle could not initialize this SWF preview.</div>';
      console.error('[Aera Wiki] Ruffle initialization failed:', error);
    }
  }

  tabs.forEach(tab => tab.addEventListener('click', () => activate(tab.dataset.wkTab)));
}());
</script>
<?php endif; ?>
<?php
$content = ob_get_clean();
include __DIR__ . '/layouts/site.php';
