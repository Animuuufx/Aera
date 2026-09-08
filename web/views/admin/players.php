<?php
$title='Players';$heading='Player Management';$subheading='Message, kick, ban, unban, edit, or grant items without leaving the control panel.';ob_start();
$adminAccess=(int)($admin['Access']??0);
// Build the generic data-editor primary-key token from the row itself.
// This intentionally does not depend on controller-injected _edit_key state, so
// mixed deployments/opcode caches cannot produce /edit?key= with an empty key.
$playerEditKey=static function(int $id): string {
    $json=json_encode(['id'=>$id],JSON_UNESCAPED_SLASHES);
    return rtrim(strtr(base64_encode((string)$json),'+/','-_'),'=');
};
?>
<style>
/* Critical player-management UI is intentionally inline so stale CDN/browser CSS can never hide it. */
.player-row-actions{display:flex!important;align-items:center!important;gap:8px!important;flex-wrap:wrap!important;min-width:150px!important}
.player-row-actions .btn{display:inline-flex!important;align-items:center!important;justify-content:center!important;white-space:nowrap!important;text-decoration:none!important}
.player-manage-dialog{width:min(920px,calc(100vw - 32px));max-width:920px;max-height:calc(100vh - 32px);padding:0;border:1px solid #484848;background:#111;color:#eee;box-shadow:0 24px 90px rgba(0,0,0,.82);overflow:hidden}
.player-manage-dialog::backdrop{background:rgba(0,0,0,.72)}
.player-manage-shell{display:flex;flex-direction:column;max-height:calc(100vh - 36px);min-height:260px}
.player-manage-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 16px;background:#181818;border-bottom:1px solid #343434;position:sticky;top:0;z-index:2}
.player-manage-head-info{display:grid;gap:2px}.player-manage-head-info small{color:#888}.player-manage-head-actions{display:flex;gap:7px;flex-wrap:wrap}
.player-manage-body{overflow-y:auto;overflow-x:hidden;padding:14px;scrollbar-gutter:stable}
.player-manage-grid{display:grid;grid-template-columns:repeat(2,minmax(260px,1fr));gap:10px}
.player-manage-card{display:grid;gap:8px;padding:12px;background:#191919;border:1px solid #303030;min-width:0}
.player-manage-card input,.player-manage-card select{width:100%;min-width:0;background:#0e0e0e;border:1px solid #363636;color:#eee;padding:9px 10px;box-sizing:border-box}
.player-manage-card small,.player-manage-card p{margin:0;color:#7d7d7d;font-size:10px}.player-manage-card button:disabled{opacity:.4;cursor:not-allowed}
.player-manage-item-inputs{display:grid;grid-template-columns:2fr 1fr;gap:7px}
@media(max-width:760px){.player-manage-dialog{width:calc(100vw - 14px);max-height:calc(100vh - 14px)}.player-manage-shell{max-height:calc(100vh - 18px)}.player-manage-grid{grid-template-columns:1fr}.player-manage-head{align-items:flex-start;flex-direction:column}.player-manage-head-actions{width:100%}}
</style>
<div class="toolbar player-toolbar">
  <form class="search-form" method="get" action="/admin/players">
    <input name="q" value="<?= e($q) ?>" placeholder="Search player name, email, or ID...">
    <button class="btn btn-ghost" type="submit">Search</button>
  </form>
  <div class="player-summary"><strong><?= number_format($total) ?></strong> players <span>·</span> Emulator <span class="badge <?= $emulatorOnline?'good':'' ?>"><?= $emulatorOnline?'Online':'Offline' ?></span></div>
</div>

<div class="panel table-panel player-panel">
  <div class="table-scroll" style="overflow:auto;max-width:100%;">
    <table class="data-table player-table" style="min-width:980px;">
      <thead><tr><th>Player</th><th>Status</th><th>Level</th><th>Access</th><th>Location</th><th>Last Login</th><th>Actions</th></tr></thead>
      <tbody>
      <?php foreach($players as $p): $online=is_array($p['_online']); $banned=(int)$p['Access']<1; $dialogId='player-manage-'.(int)$p['id']; ?>
        <tr>
          <td><strong><?= e($p['Name']) ?></strong><small>#<?= (int)$p['id'] ?> · <?= e($p['Email']) ?></small><?php if($banned&&trim((string)($p['BanReason']??''))!==''): ?><small class="ban-reason">Ban: <?= e($p['BanReason']) ?></small><?php endif; ?></td>
          <td><?php if($banned): ?><span class="badge danger">Banned</span><?php elseif($online): ?><span class="badge good">Online</span><?php else: ?><span class="badge">Offline</span><?php endif; ?></td>
          <td><?= (int)$p['Level'] ?></td>
          <td><?= (int)$p['Access'] ?></td>
          <td><?php if($online): ?><?= e((string)($p['_online']['room']??'')) ?> <small><?= e((string)($p['_online']['frame']??'')) ?></small><?php else: ?><?= e((string)$p['CurrentServer']) ?><small><?= e((string)$p['LastArea']) ?></small><?php endif; ?></td>
          <td><?= e((string)$p['LastLogin']) ?></td>
          <td>
            <div class="player-row-actions">
              <a class="btn btn-ghost emu-small-btn" href="/admin/data/users/edit?key=<?= urlencode($playerEditKey((int)$p['id'])) ?>">Edit</a>
              <button class="btn btn-danger emu-small-btn" type="button" onclick="document.getElementById('<?= e($dialogId) ?>').showModal()">Manage</button>
            </div>
          </td>
        </tr>
      <?php endforeach; ?>
      <?php if(!$players): ?><tr><td colspan="7" class="empty-cell">No players found.</td></tr><?php endif; ?>
      </tbody>
    </table>
  </div>
</div>

<?php foreach($players as $p): $online=is_array($p['_online']); $banned=(int)$p['Access']<1; $dialogId='player-manage-'.(int)$p['id']; ?>
<dialog id="<?= e($dialogId) ?>" class="player-manage-dialog" aria-label="Manage <?= e($p['Name']) ?>">
  <div class="player-manage-shell">
    <div class="player-manage-head">
      <div class="player-manage-head-info"><strong>Manage <?= e($p['Name']) ?></strong><small>#<?= (int)$p['id'] ?> · <?= $online?'Online':'Offline' ?></small></div>
      <div class="player-manage-head-actions">
        <a class="btn btn-ghost emu-small-btn" href="/admin/data/users/edit?key=<?= urlencode($playerEditKey((int)$p['id'])) ?>">Edit Player</a>
        <form method="dialog"><button class="btn btn-ghost emu-small-btn" type="submit">Close</button></form>
      </div>
    </div>
    <div class="player-manage-body">
      <div class="player-manage-grid">
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="message"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Message</strong><input name="message" maxlength="500" placeholder="Private staff message..." required><button class="btn btn-purple" type="submit" <?= !$online?'disabled':'' ?>>Send</button>
          <?php if(!$online): ?><small>Player must be online.</small><?php endif; ?>
        </form>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="kick"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Kick</strong><input name="reason" maxlength="250" placeholder="Kick reason..." required><button class="btn btn-danger" type="submit" <?= !$online?'disabled':'' ?>>Kick</button>
          <?php if(!$online): ?><small>Player must be online.</small><?php endif; ?>
        </form>
        <?php if($banned): ?>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="unban"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Unban</strong><p>Restore this account to player access.</p><button class="btn btn-good" type="submit" <?= $adminAccess<60?'disabled':'' ?>>Unban</button>
        </form>
        <?php else: ?>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="ban"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Ban</strong><input name="reason" maxlength="500" placeholder="Ban reason..." required><button class="btn btn-danger" type="submit" <?= ($adminAccess<60||(int)$p['Access']>=40)?'disabled':'' ?>>Ban</button>
          <?php if((int)$p['Access']>=40): ?><small>Staff accounts are protected.</small><?php elseif($adminAccess<60): ?><small>Administrator access required.</small><?php endif; ?>
        </form>
        <?php endif; ?>
        <?php $runtimeMuted=$online&&!empty($p['_online']['muted']); ?>
        <?php if($runtimeMuted): ?>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="unmute"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Unmute</strong><p>Remove the active session mute immediately.</p><button class="btn btn-good" type="submit" <?= !$online?'disabled':'' ?>>Unmute</button><small><?= (int)($p['_online']['muteSeconds']??0) ?> seconds remaining.</small>
        </form>
        <?php else: ?>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="mute"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Mute</strong><div class="player-manage-item-inputs"><input type="number" min="1" max="1440" name="minutes" value="5" title="Minutes" required><input name="reason" maxlength="250" placeholder="Reason (optional)"></div><button class="btn btn-danger" type="submit" <?= !$online?'disabled':'' ?>>Mute</button><small>Applies immediately to the current session.</small>
        </form>
        <?php endif; ?>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="promote"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Promote</strong><select name="rank" required><option value="30">Support (30)</option><option value="40">Moderator (40)</option><option value="60">Administrator (60)</option><option value="90">Game Master (90)</option><option value="100">Owner (100)</option></select><button class="btn btn-good" type="submit" <?= ($adminAccess<60||(int)$p['id']===(int)($admin['id']??0)||(int)$p['Access']>=$adminAccess)?'disabled':'' ?>>Promote</button><small>Updates the connected player immediately.</small>
        </form>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="demote"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Demote</strong><select name="rank" required><option value="1">Player (1)</option><option value="30">Support (30)</option><option value="40">Moderator (40)</option><option value="60">Administrator (60)</option><option value="90">Game Master (90)</option></select><button class="btn btn-danger" type="submit" <?= ($adminAccess<60||(int)$p['id']===(int)($admin['id']??0)||(int)$p['Access']>=$adminAccess)?'disabled':'' ?>>Demote</button><small>Can demote all the way back to a regular player.</small>
        </form>
        <form method="post" action="/admin/players/action" class="player-manage-card">
          <?= csrf_field() ?><input type="hidden" name="action" value="give-item"><input type="hidden" name="user_id" value="<?= (int)$p['id'] ?>"><input type="hidden" name="return_q" value="<?= e($q) ?>">
          <strong>Give Item</strong><div class="player-manage-item-inputs"><input type="number" min="1" name="item_id" placeholder="Item ID" required><input type="number" min="1" name="quantity" value="1" title="Quantity" required></div><button class="btn btn-gold" type="submit">Give Item</button><small>Online players refresh instantly.</small>
        </form>
      </div>
    </div>
  </div>
</dialog>
<?php endforeach; ?>

<div class="pagination"><?php if($page>1): ?><a href="?page=<?= $page-1 ?>&q=<?= urlencode($q) ?>">← Previous</a><?php endif; ?><span>Page <?= $page ?> of <?= $pages ?></span><?php if($page<$pages): ?><a href="?page=<?= $page+1 ?>&q=<?= urlencode($q) ?>">Next →</a><?php endif; ?></div>
<script>
// Close player dialogs with Escape (native dialog behavior) and when clicking the backdrop.
document.querySelectorAll('.player-manage-dialog').forEach(function(d){
  d.addEventListener('click',function(ev){
    var r=d.getBoundingClientRect();
    if(ev.clientX<r.left||ev.clientX>r.right||ev.clientY<r.top||ev.clientY>r.bottom)d.close();
  });
});
</script>
<?php $content=ob_get_clean();require __DIR__.'/../layouts/admin.php'; ?>
