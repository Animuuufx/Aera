<?php $title='Store'; $heading=$mode==='edit'?'Edit Product':'Add Product'; $subheading='Configure the product shown on the public Aera Store page.'; ob_start(); ?>
<div class="panel-title"><div><h2><?= $mode==='edit'?'Edit Product':'Add Product' ?></h2></div><a class="btn btn-ghost" href="/admin/store">Back to Store</a></div>
<div class="panel"><form method="post" action="<?= $mode==='edit'?'/admin/store/'.(int)$product['id'].'/edit':'/admin/store/new' ?>">
<?= csrf_field() ?>
<div class="form-grid">
<label>Title<input type="text" name="Title" maxlength="150" required value="<?= e((string)($product['Title']??'')) ?>"></label>
<label>Category<input type="text" name="Category" maxlength="80" placeholder="Cosmetics, Supporter, Upgrade..." value="<?= e((string)($product['Category']??'')) ?>"></label>
<label>Price<input type="number" name="Price" min="0" step="0.01" value="<?= e((string)($product['Price']??'0.00')) ?>"></label>
<label>Currency<input type="text" name="Currency" maxlength="10" value="<?= e((string)($product['Currency']??'USD')) ?>"></label>
<label>Sort Order<input type="number" name="SortOrder" value="<?= e((string)($product['SortOrder']??0)) ?>"></label>
<label>Image URL<input type="url" name="ImageURL" maxlength="1000" placeholder="https://..." value="<?= e((string)($product['ImageURL']??'')) ?>"></label>
<label class="form-full">Purchase URL<input type="url" name="PurchaseURL" maxlength="1000" placeholder="https://..." value="<?= e((string)($product['PurchaseURL']??'')) ?>"><small class="muted">Optional. Leave blank to show “Coming soon”.</small></label>
<label class="form-full">Description<textarea name="Description" rows="6" maxlength="5000"><?= e((string)($product['Description']??'')) ?></textarea></label>
<label class="check-row"><input type="checkbox" name="Active" value="1" <?= !isset($product['Active'])||$product['Active']?'checked':'' ?>> Active on public Store</label>
</div>
<div style="margin-top:20px"><button class="btn btn-gold" type="submit">Save Product</button></div>
</form></div>
<?php $content=ob_get_clean(); require __DIR__.'/../../layouts/admin.php'; ?>
