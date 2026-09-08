<?php $title='Downloads'; $heading='Download Manager'; $subheading='Upload game ZIPs and manage additional download links shown on the public Downloads page.'; ob_start(); ?>
<div class="panel-title"><div><h2>Downloads</h2><p class="muted">Add as many client builds, launchers, patches, mirrors, or external links as needed.</p></div><a class="btn btn-gold" href="/admin/downloads/form">Add Download</a></div>
<div class="panel">
<?php if(!$downloads): ?><p class="muted">No downloads have been configured yet.</p><?php else: ?>
<div class="table-wrap"><table><thead><tr><th>Title</th><th>Version</th><th>Type</th><th>Status</th><th>Order</th><th>Actions</th></tr></thead><tbody>
<?php foreach($downloads as $d): ?><tr><td><strong><?= e($d['Title']) ?></strong><br><small class="muted"><?= e((string)($d['Description']??'')) ?></small></td><td><?= e((string)($d['Version']??'—')) ?></td><td><?= $d['FilePath']?'Uploaded ZIP':'External link' ?></td><td><?= $d['Active']?'Active':'Hidden' ?></td><td><?= e((string)$d['SortOrder']) ?></td><td><a class="btn btn-ghost" href="/admin/downloads/form?id=<?= (int)$d['id'] ?>">Edit</a> <form action="/admin/downloads/<?= (int)$d['id'] ?>/delete" method="post" style="display:inline"><?= csrf_field() ?><button class="btn btn-danger" type="submit" onclick="return confirm('Delete this download?')">Delete</button></form></td></tr><?php endforeach; ?>
</tbody></table></div><?php endif; ?>
</div>
<?php $content=ob_get_clean(); require __DIR__.'/../../layouts/admin.php'; ?>
