<?php $title='Character Lookup'; ob_start(); ?>
<div class="portal-single-page">
  <div class="portal-page-title"><span>CHARACTER LOOKUP</span><h1>Find an Adventurer</h1><p>Search public character information from the Aera world.</p></div>
  <section class="portal-widget portal-character-search-card">
    <form method="get" action="/character" class="portal-search-form portal-search-large"><input name="name" value="<?= e($query) ?>" placeholder="Character name" minlength="2" maxlength="32" required><button type="submit">SEARCH</button></form>
  </section>
  <?php if($query!=='' && !$character): ?><div class="portal-message-card">No character named <strong><?= e($query) ?></strong> was found.</div><?php endif; ?>
  <?php if($character): ?>
  <div class="portal-character-grid">
    <section class="portal-widget portal-character-card">
      <div class="portal-character-head"><span class="portal-avatar-letter large"><?= e(strtoupper(substr((string)$character['Name'],0,1))) ?></span><div><span class="portal-red-label">LEVEL <?= (int)$character['Level'] ?></span><h2><?= e($character['Name']) ?></h2><p><?= $guild?e($guild['Name']).' · Guild Lv '.(int)$guild['Level']:'No guild' ?></p></div></div>
      <div class="portal-character-stats"><div><span>Gold</span><b><?= number_format((int)$character['Gold']) ?></b></div><div><span>Coins</span><b><?= number_format((int)$character['Coins']) ?></b></div><div><span>Kills</span><b><?= number_format((int)$character['KillCount']) ?></b></div><div><span>Deaths</span><b><?= number_format((int)$character['DeathCount']) ?></b></div></div>
      <dl class="portal-character-details"><div><dt>Last Area</dt><dd><?= e($character['LastArea']) ?></dd></div><div><dt>Server</dt><dd><?= e($character['CurrentServer']) ?></dd></div><div><dt>Joined</dt><dd><?= e(date('M j, Y',strtotime((string)$character['DateCreated']))) ?></dd></div><div><dt>Membership</dt><dd><?= (int)$character['Upgraded']?'Upgraded':'Free' ?></dd></div></dl>
    </section>
    <section class="portal-widget portal-equipment-card"><div class="portal-widget-title"><strong>Equipped Items</strong><span><?= count($equipped) ?></span></div><?php if(!$equipped): ?><p class="portal-widget-empty">No equipped items found.</p><?php else: ?><div class="portal-equipment-list"><?php foreach($equipped as $item): ?><div><span><?= e($item['Equipment'] ?: $item['Type']) ?></span><strong><?= e($item['Name']) ?></strong><small>Lv <?= (int)$item['Level'] ?></small></div><?php endforeach; ?></div><?php endif; ?></section>
  </div>
  <?php endif; ?>
</div>
<?php $content=ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
