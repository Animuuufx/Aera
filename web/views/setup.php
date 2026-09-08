<?php
use Aera\Foundation\Session;
$title='Setup';
$error=Session::pull('error');
$success=Session::pull('success');
$warning=Session::pull('warning');
ob_start();
?>
<section class="setup-shell">
  <div class="setup-card portal-setup-card">
    <div class="setup-head">
      <span class="eyebrow">AERA FOUNDATION 3.2</span>
      <h1><?= $configured && !$dbOk ? 'Repair Database Connection' : 'Server Setup' ?></h1>
      <p><?= $configured && !$dbOk
        ? 'The PHP framework is running, but the saved MySQL connection is not working. Update it here without deleting your game data.'
        : 'Configure the custom PHP framework and the MySQL 5.7-compatible aera database.' ?></p>
    </div>

    <?php if($autoRepaired): ?><div class="flash success">The old broken connection was detected and automatically repaired using the compatible database settings from the original server files.</div><?php endif; ?>
    <?php if($error): ?><div class="flash error"><?= e($error) ?></div><?php endif; ?>
    <?php if($success): ?><div class="flash success"><?= e($success) ?></div><?php endif; ?>
    <?php if($warning): ?><div class="flash warning"><?= e($warning) ?></div><?php endif; ?>

    <div class="req-grid">
      <?php foreach($requirements as $req): ?>
        <div class="req <?= $req['ok']?'ok':'bad' ?>"><span><?= $req['ok']?'✓':'!' ?></span><div><b><?= e($req['label']) ?></b><small><?= e($req['value']) ?></small></div></div>
      <?php endforeach; ?>
    </div>

    <?php if($configured): ?>
      <div class="db-diagnostic <?= $dbOk ? 'connected' : 'failed' ?>">
        <div>
          <span class="status-dot <?= $dbOk ? 'online' : '' ?>"></span>
          <strong><?= $dbOk ? 'Database connected' : 'Database connection failed' ?></strong>
        </div>
        <dl>
          <div><dt>Host</dt><dd><?= e($diagnostic['host']) ?></dd></div>
          <div><dt>Port</dt><dd><?= (int)$diagnostic['port'] ?></dd></div>
          <div><dt>Database</dt><dd>aera</dd></div>
          <div><dt>User</dt><dd><?= e($diagnostic['username']) ?></dd></div>
        </dl>
        <?php if(!$dbOk && !empty($diagnostic['error'])): ?><p><?= e($diagnostic['error']) ?></p><?php endif; ?>
      </div>
    <?php endif; ?>

    <?php if(!$configured || !$dbOk): ?>
      <form method="post" action="/setup" class="setup-form"><?= csrf_field() ?>
        <h2>MySQL connection</h2>
        <div class="form-grid">
          <label>Host<input name="db_host" value="<?= e($defaults['host']) ?>" required></label>
          <label>Port<input name="db_port" value="<?= (int)$defaults['port'] ?>" inputmode="numeric" required></label>
          <label>MySQL user<input name="db_user" value="<?= e($defaults['user']) ?>" required></label>
          <label>MySQL password<input name="db_password" type="password" autocomplete="current-password" placeholder="Leave blank to keep saved password"></label>
        </div>
        <p class="field-help">Database name is fixed to <code>aera</code>. Repairing the connection preserves the existing schema and game data.</p>

        <h2>Administrator <?= $configured ? '<small>(optional during repair)</small>' : '' ?></h2>
        <div class="form-grid">
          <label>Username<input name="admin_username" pattern="[a-zA-Z0-9_]{3,20}" <?= $configured ? '' : 'required' ?>></label>
          <label>Email<input name="admin_email" type="email" <?= $configured ? '' : 'required' ?>></label>
          <label class="span2">Password<input name="admin_password" type="password" minlength="8" maxlength="72" <?= $configured ? '' : 'required' ?>></label>
        </div>
        <p class="field-help">Leave the administrator fields empty during a connection-only repair. Fill all three to create or reset an Access 60 administrator.</p>
        <button class="portal-action-button setup-submit" type="submit"><strong><?= $configured ? 'Repair Connection' : 'Install Aera' ?></strong><span><?= $configured ? 'Save MySQL settings + repair admin tables' : 'Create database + administrator' ?></span></button>
      </form>
    <?php else: ?>
      <div class="installed-box">
        <h2>Aera is ready</h2>
        <p>The custom framework can reach the <code>aera</code> database.</p>
        <div class="hero-actions"><a class="btn btn-gold" href="/admin">Open Admin Panel</a><a class="btn btn-ghost" href="/">Open Website</a><a class="btn btn-ghost" href="/health">Health JSON</a></div>
      </div>
    <?php endif; ?>
  </div>
</section>
<?php $content=ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
