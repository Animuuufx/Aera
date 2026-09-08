<?php $editing=($mode??'create')==='edit'; $title=$editing?'Edit Download':'Add Download'; $heading=$title; $subheading='Upload a ZIP file or provide an external download URL.'; ob_start(); ?>
<div class="panel">
<form action="<?= $editing?'/admin/downloads/'.(int)$download['id'].'/edit':'/admin/downloads/new' ?>" method="post" enctype="multipart/form-data" class="stack-form">
<?= csrf_field() ?>
<label>Title<input type="text" name="Title" required maxlength="150" value="<?= e((string)($download['Title']??'')) ?>" placeholder="Aera Client"></label>
<label>Version<input type="text" name="Version" maxlength="50" value="<?= e((string)($download['Version']??'')) ?>" placeholder="Beta 1.0"></label>
<label>Description<textarea name="Description" rows="5" placeholder="Describe this download..."><?= e((string)($download['Description']??'')) ?></textarea></label>
<label>Upload Game ZIP <span class="muted">(optional, up to 1 GB)</span><input type="file" name="download_file" accept=".zip,application/zip"></label>
<?php if(!empty($download['FilePath'])): ?><p class="muted">Current file: <code><?= e($download['FilePath']) ?></code>. Uploading another ZIP will replace the database entry's file target.</p><?php endif; ?>
<label>External Download URL <span class="muted">(optional)</span><input type="url" name="ExternalURL" maxlength="1000" value="<?= e((string)($download['ExternalURL']??'')) ?>" placeholder="https://example.com/aera-client.zip"></label>
<label>Sort Order<input type="number" name="SortOrder" value="<?= e((string)($download['SortOrder']??0)) ?>"></label>
<label><input type="checkbox" name="Active" value="1" <?= !isset($download['Active'])||$download['Active']?'checked':'' ?>> Show this download publicly</label>
<div><button class="btn btn-gold" type="submit">Save Download</button> <a class="btn btn-ghost" href="/admin/downloads">Cancel</a></div>
</form>
</div>
<?php $content=ob_get_clean(); require __DIR__.'/../../layouts/admin.php'; ?>
