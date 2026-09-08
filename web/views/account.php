<?php ob_start(); ?>
<section class="page-hero compact account-hero">
  <div>
    <span class="eyebrow">Account Management</span>
    <h1><?= e($account['Name']) ?></h1>
    <p>Manage your website login and review your current Aera character.</p>
  </div>
  <a class="btn btn-play" href="/play">Play Aera</a>
</section>

<section class="account-wrap">
  <div class="account-stats">
    <div class="account-stat"><span>Level</span><strong><?= (int)$account['Level'] ?></strong></div>
    <div class="account-stat"><span>Gold</span><strong><?= number_format((int)$account['Gold']) ?></strong></div>
    <div class="account-stat"><span>Coins</span><strong><?= number_format((int)$account['Coins']) ?></strong></div>
    <div class="account-stat"><span>K / D</span><strong><?= (int)$account['KillCount'] ?> / <?= (int)$account['DeathCount'] ?></strong></div>
  </div>

  <div class="account-grid">
    <div class="panel account-panel">
      <div class="panel-title"><h2>Character</h2><span class="badge <?= (int)$account['Upgraded'] ? 'gold' : '' ?>"><?= (int)$account['Upgraded'] ? 'Upgraded' : 'Free' ?></span></div>
      <dl class="account-details">
        <div><dt>Username</dt><dd><?= e($account['Name']) ?></dd></div>
        <div><dt>Gender</dt><dd><?= e($account['Gender']) ?></dd></div>
        <div><dt>Last area</dt><dd><?= e($account['LastArea']) ?></dd></div>
        <div><dt>Server</dt><dd><?= e($account['CurrentServer']) ?></dd></div>
        <div><dt>Bag</dt><dd><?= $inventoryCount ?> / <?= (int)$account['SlotsBag'] ?></dd></div>
        <div><dt>Bank</dt><dd><?= $bankCount ?> / <?= (int)$account['SlotsBank'] ?></dd></div>
        <div><dt>Created</dt><dd><?= e(date('M j, Y',strtotime((string)$account['DateCreated']))) ?></dd></div>
        <div><dt>Last login</dt><dd><?= e(date('M j, Y g:i A',strtotime((string)$account['LastLogin']))) ?></dd></div>
      </dl>
    </div>

    <div class="panel account-panel">
      <div class="panel-title"><h2>Equipped Items</h2><span class="badge"><?= count($equipped) ?> equipped</span></div>
      <?php if($equipped): ?>
      <div class="equipment-list">
        <?php foreach($equipped as $item): ?>
          <div><span><?= e($item['Equipment'] ?: $item['Type']) ?></span><strong><?= e($item['Name']) ?></strong><small>Lv. <?= (int)$item['Level'] ?> · Rarity <?= (int)$item['Rarity'] ?></small></div>
        <?php endforeach; ?>
      </div>
      <?php else: ?><p class="muted">No equipped items were found.</p><?php endif; ?>
    </div>

    <div class="panel account-panel">
      <h2>Change Email</h2>
      <p class="muted">Your email is used for account ownership and recovery workflows.</p>
      <form class="stack-form" method="post" action="/account/email">
        <?= csrf_field() ?>
        <label>Email<input type="email" name="email" maxlength="64" required value="<?= e($account['Email']) ?>"></label>
        <label>Current password<input type="password" name="current_password" required autocomplete="current-password"></label>
        <button class="btn btn-gold" type="submit">Update Email</button>
      </form>
    </div>

    <div class="panel account-panel">
      <h2>Change Password</h2>
      <p class="muted">Changing your password signs out existing game API sessions.</p>
      <form class="stack-form" method="post" action="/account/password">
        <?= csrf_field() ?>
        <label>Current password<input type="password" name="current_password" required autocomplete="current-password"></label>
        <label>New password<input type="password" name="password" minlength="8" maxlength="72" required autocomplete="new-password"></label>
        <label>Confirm new password<input type="password" name="password_confirmation" minlength="8" maxlength="72" required autocomplete="new-password"></label>
        <button class="btn btn-purple" type="submit">Update Password</button>
      </form>
    </div>
  </div>
</section>
<?php $content=ob_get_clean(); $title='Account'; require __DIR__.'/layouts/site.php'; ?>
