<?php $title='Aera Rifts';ob_start(); ?>
<link rel="stylesheet" href="/assets/css/rifts.css?v=1">
<div class="portal-single-page rift-public"><div class="portal-page-title"><span>DYNAMIC WORLD EVENTS</span><h1>Aera Rifts</h1><p>Fight the invasion. Protect the ward. Defeat the Commander together.</p></div>
<?php if(!$ready): ?><p>Rifts are being prepared.</p><?php else: ?>
<section class="portal-widget"><h2><?= number_format((int)($wallet['Shards']??0)) ?> Rift Shards</h2><p><?= (int)($wallet['RiftsClosed']??0) ?> Rifts closed · <?= (int)($wallet['LegendaryClosed']??0) ?> Legendary Rifts · Best contribution: <?= number_format((int)($wallet['HighestContribution']??0)) ?></p>
<p>During an invasion, use the in-game Rift panel or <strong>/rift join</strong>. Kill invaders for materials, then use <strong>/rift deposit</strong> in the defense cell. Stay alive in that cell to defend its ward. Watch for Commander shockwave warnings!</p></section>
<section class="portal-widget"><h2>Shard shop</h2><p>Log out of the game before buying. Rewards go directly to your inventory.</p>
<?php if(!$items): ?><p>New rewards are coming soon.</p><?php endif; ?>
<?php foreach($items as $item): ?><form class="rift-shop-item" method="post" action="/rifts/buy"><?= csrf_field() ?><input type="hidden" name="shop" value="<?= (int)$item['id'] ?>"><input type="hidden" name="token" value="<?= e(bin2hex(random_bytes(32))) ?>"><strong><?= e($item['Name']) ?></strong> · <?= e($item['Type']) ?> · ×<?= (int)$item['Quantity'] ?> · <?= number_format((int)$item['Cost']) ?> shards <button type="submit"><?= $user?'Purchase':'Log in to purchase' ?></button></form><?php endforeach; ?></section>
<section class="portal-widget"><h2>Your contribution rewards</h2><?php foreach($rewards as $r): ?><p><?= e($r['Map']) ?> · <?= e($r['Medal']) ?> · <?= number_format((int)$r['Score']) ?> contribution · <?= (int)$r['Shards'] ?> shards</p><?php endforeach; ?></section>
<section class="portal-widget"><h2>World event history</h2><?php foreach($history as $h): $state=json_decode($h['State'],true)??[]; ?><p><strong><?= e($h['Map']) ?></strong> · <?= e($h['Tier'].' '.$h['Modifier']) ?> · <?= e($h['Status']) ?><?= $h['Status']==='active'?' — '.e($state['phase']??'invasion'):'' ?> · <?= e($h['StartedAt']) ?></p><?php endforeach; ?></section>
<?php endif; ?></div>
<?php $content=ob_get_clean();require __DIR__.'/layouts/site.php'; ?>
