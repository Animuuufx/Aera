<?php $title='Store'; ob_start(); ?>
<section class="portal-section"><div class="panel-title"><div><h1>Aera Store</h1><p class="muted">Support Aera and browse available items, upgrades, and other extras.</p></div></div>
<?php if(!$products): ?>
<div class="panel"><h2>Store coming soon</h2><p class="muted">There are no store products available yet. Check back soon.</p></div>
<?php else: ?>
<div class="store-grid">
<?php foreach($products as $p): ?>
<article class="store-card">
<?php if(!empty($p['ImageURL'])): ?><div class="store-card-image"><img src="<?= e($p['ImageURL']) ?>" alt="<?= e($p['Title']) ?>" loading="lazy"></div><?php endif; ?>
<div class="store-card-body">
<?php if(!empty($p['Category'])): ?><div class="store-category"><?= e($p['Category']) ?></div><?php endif; ?>
<h2><?= e($p['Title']) ?></h2>
<?php if(!empty($p['Description'])): ?><p><?= nl2br(e($p['Description'])) ?></p><?php endif; ?>
<div class="store-card-footer"><strong><?= e($p['Currency']) ?> <?= number_format((float)$p['Price'],2) ?></strong><?php if(!empty($p['PurchaseURL'])): ?><a class="btn btn-gold" href="<?= e($p['PurchaseURL']) ?>" target="_blank" rel="noopener">Purchase</a><?php else: ?><span class="muted">Coming soon</span><?php endif; ?></div>
</div></article>
<?php endforeach; ?>
</div>
<?php endif; ?></section>
<?php $content=ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
