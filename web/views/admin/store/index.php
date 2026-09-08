<?php $title='Store'; $heading='Store Manager'; $subheading='Manage products, pricing, images, and purchase links shown on the public Store page.'; ob_start(); ?>
<div class="panel-title"><div><h2>Store</h2><p class="muted">Add game extras, cosmetics, upgrades, supporter packages, or other products.</p></div><a class="btn btn-gold" href="/admin/store/form">Add Product</a></div>
<div class="panel">
<?php if(!$products): ?><p class="muted">No store products have been configured yet.</p><?php else: ?>
<div class="table-wrap"><table><thead><tr><th>Product</th><th>Category</th><th>Price</th><th>Status</th><th>Order</th><th>Actions</th></tr></thead><tbody>
<?php foreach($products as $p): ?><tr><td><strong><?= e($p['Title']) ?></strong><br><small class="muted"><?= e((string)($p['Description']??'')) ?></small></td><td><?= e((string)($p['Category']??'—')) ?></td><td><?= e($p['Currency']) ?> <?= number_format((float)$p['Price'],2) ?></td><td><?= $p['Active']?'Active':'Hidden' ?></td><td><?= e((string)$p['SortOrder']) ?></td><td><a class="btn btn-ghost" href="/admin/store/form?id=<?= (int)$p['id'] ?>">Edit</a> <form action="/admin/store/<?= (int)$p['id'] ?>/delete" method="post" style="display:inline"><?= csrf_field() ?><button class="btn btn-danger" type="submit" onclick="return confirm('Delete this store product?')">Delete</button></form></td></tr><?php endforeach; ?>
</tbody></table></div><?php endif; ?>
</div>
<?php $content=ob_get_clean(); require __DIR__.'/../../layouts/admin.php'; ?>
