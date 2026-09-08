<?php
$title='Admin Logs';$heading='Admin Logs';$subheading='Complete audit trail for control-panel requests, commands, edits, deletes, uploads, player actions, and emulator controls.';ob_start();
$queryBase='q='.urlencode($q).'&action='.urlencode($action).'&background='.($showBackground?'1':'0');
?>
<div class="toolbar">
  <form class="search-form admin-log-filters" method="get" action="/admin/logs">
    <input name="q" value="<?= e($q) ?>" placeholder="Search admin, path, action, entity, request data...">
    <select name="action">
      <option value="">All actions</option>
      <?php foreach($actions as $a): ?><option value="<?= e($a['Action']) ?>" <?= $action===(string)$a['Action']?'selected':'' ?>><?= e($a['Action']) ?> (<?= number_format((int)$a['Total']) ?>)</option><?php endforeach; ?>
    </select>
    <label class="check-inline"><input type="checkbox" name="background" value="1" <?= $showBackground?'checked':'' ?>> Include live background requests</label>
    <button class="btn btn-ghost" type="submit">Filter</button>
  </form>
  <span class="muted"><strong><?= number_format($total) ?></strong> matching log entries</span>
</div>
<div class="panel table-panel">
  <div class="table-scroll"><table class="data-table admin-log-table">
    <thead><tr><th>ID</th><th>When</th><th>Admin</th><th>Request</th><th>Action</th><th>Target</th><th>Status</th><th>IP</th><th>Details</th></tr></thead>
    <tbody>
    <?php foreach($rows as $r): $status=(int)($r['ResponseStatus']??0); ?>
      <tr>
        <td><?= (int)$r['id'] ?></td>
        <td><?= e($r['CreatedAt']) ?><br><small><?= $r['DurationMs']!==null?number_format((int)$r['DurationMs']).' ms':'pending' ?></small></td>
        <td><strong><?= e($r['AdminName']) ?></strong><br><small>#<?= e($r['AdminUserID']) ?></small></td>
        <td><span class="badge"><?= e($r['Method']) ?></span> <code><?= e($r['Path']) ?></code><?php if((int)$r['IsBackground']===1): ?><br><small>background/live request</small><?php endif; ?></td>
        <td><strong><?= e($r['Action']) ?></strong></td>
        <td><?= e($r['Entity']??'') ?><?php if(($r['EntityID']??'')!==''): ?><br><small><?= e($r['EntityID']) ?></small><?php endif; ?></td>
        <td><?php if($status): ?><span class="badge <?= $status>=200&&$status<400?'good':($status>=400?'danger':'') ?>"><?= $status ?></span><?php else: ?><span class="badge">pending</span><?php endif; ?></td>
        <td><?= e($r['IPAddress']??'') ?></td>
        <td>
          <?php if(($r['RequestData']??'')!==''||($r['FileData']??'')!==''||($r['ErrorMessage']??'')!==''): ?>
            <details><summary>View</summary>
              <?php if(($r['RequestData']??'')!==''): ?><strong>Request</strong><pre><?= e($r['RequestData']) ?></pre><?php endif; ?>
              <?php if(($r['FileData']??'')!==''): ?><strong>Files</strong><pre><?= e($r['FileData']) ?></pre><?php endif; ?>
              <?php if(($r['ErrorMessage']??'')!==''): ?><strong>Error</strong><pre><?= e($r['ErrorMessage']) ?></pre><?php endif; ?>
            </details>
          <?php else: ?><span class="muted">—</span><?php endif; ?>
        </td>
      </tr>
    <?php endforeach; ?>
    <?php if(!$rows): ?><tr><td colspan="9" class="empty-cell">No admin log entries match this filter.</td></tr><?php endif; ?>
    </tbody>
  </table></div>
</div>
<div class="pagination">
<?php if($page>1): ?><a href="?<?= e($queryBase) ?>&page=<?= $page-1 ?>">← Previous</a><?php endif; ?>
<span>Page <?= $page ?> of <?= $pages ?></span>
<?php if($page<$pages): ?><a href="?<?= e($queryBase) ?>&page=<?= $page+1 ?>">Next →</a><?php endif; ?>
</div>
<?php $content=ob_get_clean();require __DIR__.'/../layouts/admin.php'; ?>
