<?php
$title='Assets';
$heading='Asset Manager';
$subheading='Upload website images and add new game SWFs without overwriting existing files.';
ob_start();
?>
<div class="admin-grid two">
  <div class="panel">
    <h2>Upload Website Image</h2>
    <p class="muted">PNG, JPG, GIF, WebP, or SVG. Images go to <code>public/static/uploads</code> and appear in the picker below.</p>
    <form action="/admin/files/image" method="post" enctype="multipart/form-data" class="stack-form">
      <?= csrf_field() ?>
      <input type="file" name="image" required accept="image/png,image/jpeg,image/gif,image/webp,image/svg+xml">
      <button class="btn btn-gold">Upload Image</button>
    </form>
  </div>

  <div class="panel">
    <h2>Add New Game SWF</h2>
    <p class="muted"><strong>Client SWFs:</strong> choose <code>Client SWF / gamefiles root</code> to upload directly to <code>public/gamefiles/</code>.</p>
    <p class="muted"><strong>Protection:</strong> existing files are never overwritten.</p>
    <form action="/admin/files/swf" method="post" enctype="multipart/form-data" class="stack-form">
      <?= csrf_field() ?>
      <label>Destination
        <select name="destination" required>
          <?php foreach($destinations as $key=>$path): ?>
            <?php if($key==='client_root'): ?>
              <option value="<?= e($key) ?>">Client SWF / gamefiles root → gamefiles/</option>
            <?php else: ?>
              <option value="<?= e($key) ?>"><?= e($key) ?> → gamefiles/<?= e($path) ?></option>
            <?php endif; ?>
          <?php endforeach; ?>
        </select>
      </label>
      <input type="file" name="swf" required accept=".swf,application/x-shockwave-flash">
      <button class="btn btn-gold">Add SWF</button>
    </form>
  </div>
</div>

<div class="panel">
  <div class="panel-title"><h2>Image Picker</h2><span class="muted"><?= count($images) ?> images</span></div>
  <?php if(!$images): ?>
    <p class="muted">No static images uploaded yet.</p>
  <?php else: ?>
    <div class="image-grid">
      <?php foreach($images as $img): ?>
        <button class="image-tile" data-copy="<?= e($img) ?>" title="Click to copy path"><img src="/<?= e($img) ?>" alt=""><span><?= e($img) ?></span></button>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</div>
<?php $content=ob_get_clean();require __DIR__.'/../../layouts/admin.php'; ?>
