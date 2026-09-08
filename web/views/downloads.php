<?php $title='Downloads'; ob_start(); ?>
<section class="page-hero compact"><span class="eyebrow">AERA CLIENT</span><h1>Downloads</h1><p>Download the latest Aera client and other official game files.</p></section>
<section class="cards">
<?php if(!$downloads): ?>
  <div class="panel"><h2>Downloads are coming soon</h2><p class="muted">The Aera client will be available here when the first build is uploaded.</p></div>
<?php else: foreach($downloads as $d): ?>
  <article class="panel">
    <div class="panel-title"><h2><?= e($d['Title']) ?></h2><?php if($d['Version']): ?><span class="muted">v<?= e($d['Version']) ?></span><?php endif; ?></div>
    <?php if($d['Description']): ?><p><?= nl2br(e($d['Description'])) ?></p><?php endif; ?>
    <?php if($d['FileSize']): ?><p class="muted">File size: <?= e(number_format((float)$d['FileSize']/1048576,1)) ?> MB</p><?php endif; ?>
    <?php if($d['FilePath']): ?><a class="btn btn-gold" href="/<?= e(ltrim($d['FilePath'],'/')) ?>">Download</a><?php elseif($d['ExternalURL']): ?><a class="btn btn-gold" href="<?= e($d['ExternalURL']) ?>" target="_blank" rel="noopener">Download</a><?php endif; ?>
  </article>
<?php endforeach; endif; ?>
</section>
<?php $content=ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
