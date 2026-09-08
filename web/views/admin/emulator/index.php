<?php
$title='Emulator';
$heading='Web Emulator';
$subheading='Run, inspect, control, and edit the Aera PHP emulator from one live web workspace.';
$state=strtolower((string)($runtimeStatus['state']??'unknown'));
$running=$state==='running';
$players=is_array($runtimeData['players']??null)?$runtimeData['players']:[];
$rooms=is_array($runtimeData['rooms']??null)?$runtimeData['rooms']:[];
ob_start();
?>
<input type="hidden" value="<?= e(\Aera\Foundation\Csrf::token()) ?>" data-emu-csrf>
<div class="emu-workspace" data-emu-workspace data-event-cursor="<?= (int)$eventCursor ?>" data-admin-access="<?= (int)($admin['Access']??0) ?>" data-configured-port="<?= (int)($configuredPort??5589) ?>">
  <div class="panel emu-toolbar">
    <div class="server-status-large">
      <span class="status-dot <?= $running?'online':'' ?>" data-emulator-process-dot></span>
      <div>
        <h3><?= e($server['Name']??'Aera') ?> PHP Emulator</h3>
        <p><?= e($runtimePath) ?></p>
        <p><span data-emulator-process-state><?= e(ucfirst(str_replace('-',' ',$state))) ?></span> · <span data-emu-supervisor><?= !empty($runtimeStatus['supervisorOnline'])?'Supervisor online':'Supervisor offline' ?></span></p>
      </div>
    </div>
    <div class="emu-toolbar-actions">
      <button class="btn btn-good" type="button" data-emu-control="start">Start</button>
      <button class="btn btn-gold" type="button" data-emu-control="restart">Restart</button>
      <button class="btn btn-danger" type="button" data-emu-control="stop">Stop</button>
      <button class="btn btn-purple" type="button" data-emu-rpc="safe-shutdown">Safe Shutdown</button>
      <button class="btn btn-ghost" type="button" data-emu-rpc="cancel-shutdown">Cancel Shutdown</button>
      <button class="btn btn-ghost" type="button" data-emu-rpc="reload-data">Reload DB Cache</button>
    </div>
  </div>

  <?php if(empty($runtimeStatus['supervisorOnline'])): ?>
    <div class="alert warning">Run <strong>C:\inetpub\wwwroot\Aera\INSTALL_PHP_EMULATOR_CONTROL.bat</strong> once as Administrator. The panel controls the SYSTEM supervisor through its local control channel.</div>
  <?php endif; ?>

  <div class="panel emu-port-panel">
    <div class="panel-title">
      <h2>Game Socket Port</h2>
      <span>Saved here, used by both the PHP emulator and the Aera server list.</span>
    </div>
    <form class="emu-inline-form" method="post" action="/admin/emulator/port">
      <?= csrf_field() ?>
      <label for="aera-game-port"><strong>TCP Port</strong></label>
      <input id="aera-game-port" type="number" name="port" min="1024" max="65535" step="1" value="<?= (int)($configuredPort??5589) ?>" required>
      <button class="btn btn-good" type="submit">Save Port</button>
      <span class="muted">Default: 5589. If the emulator is running, saving automatically restarts it on the new port.</span>
    </form>
  </div>

  <div class="emu-stats" data-emu-stats>
    <div class="stat-card"><span>Process</span><strong data-emu-stat-pid><?= e($runtimeData['pid']??'-') ?></strong><small>PID</small></div>
    <div class="stat-card"><span>Players</span><strong data-emu-stat-players><?= e($runtimeData['playersOnline']??0) ?></strong><small>online now</small></div>
    <div class="stat-card"><span>Rooms</span><strong data-emu-stat-rooms><?= e($runtimeData['activeRooms']??0) ?></strong><small>active instances</small></div>
    <div class="stat-card"><span>Uptime</span><strong data-emu-stat-uptime><?= e($runtimeData['uptime']??0) ?>s</strong><small>current process</small></div>
    <div class="stat-card"><span>Game Port</span><strong data-emu-stat-port><?= e($runtimeData['gamePort']??($configuredPort??5589)) ?></strong><small>SmartFox socket</small></div>
    <div class="stat-card"><span>Shutdown</span><strong data-emu-stat-shutdown><?= isset($runtimeData['shutdownRemaining'])&&$runtimeData['shutdownRemaining']!==null?e($runtimeData['shutdownRemaining'].'s'):'—' ?></strong><small>countdown</small></div>
  </div>

  <div class="emu-tabs" role="tablist">
    <button class="active" type="button" data-emu-tab="console">Live Console</button>
    <button type="button" data-emu-tab="players">Players</button>
    <button type="button" data-emu-tab="rooms">Rooms</button>
    <button type="button" data-emu-tab="editor">Source Editor</button>
    <button type="button" data-emu-tab="commands">Command History</button>
  </div>

  <section class="emu-tab-panel active" data-emu-panel="console">
    <div class="panel emulator-console-panel">
      <div class="panel-title">
        <h2>Attached Live Process Console</h2>
        <span class="emulator-live-label offline"><i></i><span data-emulator-live-state>Connecting…</span> · event channel</span>
      </div>
      <pre class="log-window emulator-terminal" data-emulator-live-log><?= e($log) ?></pre>
      <form class="emulator-command-bar" method="post" action="/admin/emulator/console-command" data-emulator-command-form>
        <?= csrf_field() ?>
        <span>&gt;</span>
        <input type="text" name="command" maxlength="500" autocomplete="off" spellcheck="false" placeholder="help, status, players, rooms, say &lt;message&gt;, reload…" data-emulator-command-input>
        <button class="btn btn-good" type="submit">Send</button>
      </form>
      <div class="emulator-command-hint"><span data-emulator-command-status>New emulator output appears here as soon as the process emits it.</span></div>
    </div>
    <div class="panel emu-broadcast-panel">
      <div class="panel-title"><h2>Broadcast to Server</h2></div>
      <form class="emu-inline-form" data-emu-broadcast-form>
        <input type="text" maxlength="500" placeholder="Message all online players…" name="message">
        <button class="btn btn-gold" type="submit">Broadcast</button>
      </form>
    </div>
  </section>

  <section class="emu-tab-panel" data-emu-panel="players">
    <div class="panel">
      <div class="panel-title"><h2>Online Players</h2><span data-emu-player-count><?= count($players) ?> online</span></div>
      <div class="table-scroll"><table class="emu-live-table emu-player-table"><thead><tr><th>Player</th><th>Level</th><th>Room</th><th>HP</th><th>MP</th><th>Access</th><th>IP</th><th>Actions</th></tr></thead><tbody data-emu-players-body>
      <?php if(!$players): ?><tr><td colspan="8" class="muted">No players are online.</td></tr><?php endif; ?>
      <?php foreach($players as $p): $pn=(string)($p['name']??'');$pid=(int)($p['id']??0);$pa=(int)($p['access']??0); ?><tr><td><strong><?= e($pn) ?></strong><small>#<?= $pid ?></small></td><td><?= e($p['level']??'') ?></td><td><?= e($p['room']??'') ?></td><td><?= e(($p['hp']??0).'/'.($p['hpMax']??0)) ?></td><td><?= e(($p['mp']??0).'/'.($p['mpMax']??0)) ?></td><td><?= $pa ?></td><td><?= e($p['ip']??'') ?></td><td><div class="emu-player-actions"><button type="button" class="btn btn-purple emu-small-btn" data-emu-player-action="message" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>">Message</button><button type="button" class="btn btn-danger emu-small-btn" data-emu-player-action="kick" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>">Kick</button><button type="button" class="btn btn-danger emu-small-btn" data-emu-player-action="ban" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>" data-target-access="<?= $pa ?>" <?= (int)($admin['Access']??0)<60||$pa>=40?'disabled':'' ?>>Ban</button><button type="button" class="btn btn-ghost emu-small-btn" data-emu-player-action="<?= !empty($p['muted'])?'unmute':'mute' ?>" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>" data-target-access="<?= $pa ?>"><?= !empty($p['muted'])?'Unmute':'Mute' ?></button><button type="button" class="btn btn-good emu-small-btn" data-emu-player-action="promote" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>" data-target-access="<?= $pa ?>" <?= (int)($admin['Access']??0)<60||$pa>=(int)($admin['Access']??0)?'disabled':'' ?>>Promote</button><button type="button" class="btn btn-danger emu-small-btn" data-emu-player-action="demote" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>" data-target-access="<?= $pa ?>" <?= (int)($admin['Access']??0)<60||$pa>=(int)($admin['Access']??0)?'disabled':'' ?>>Demote</button><button type="button" class="btn btn-gold emu-small-btn" data-emu-player-action="give-item" data-user-id="<?= $pid ?>" data-player="<?= e($pn) ?>">Give Item</button><a class="btn btn-ghost emu-small-btn" href="/admin/players?q=<?= urlencode($pn) ?>">Manage</a></div></td></tr><?php endforeach; ?>
      </tbody></table></div>
    </div>
  </section>

  <section class="emu-tab-panel" data-emu-panel="rooms">
    <div class="panel">
      <div class="panel-title"><h2>Active Rooms</h2><span data-emu-room-count><?= count($rooms) ?> rooms</span></div>
      <div class="table-scroll"><table class="emu-live-table"><thead><tr><th>ID</th><th>Room</th><th>Players</th><th>Monsters</th><th>Alive</th></tr></thead><tbody data-emu-rooms-body>
      <?php if(!$rooms): ?><tr><td colspan="5" class="muted">No active rooms.</td></tr><?php endif; ?>
      <?php foreach($rooms as $r): ?><tr><td><?= e($r['id']??'') ?></td><td><strong><?= e($r['name']??'') ?></strong></td><td><?= e($r['players']??0) ?></td><td><?= e($r['monsters']??0) ?></td><td><?= e($r['monstersAlive']??0) ?></td></tr><?php endforeach; ?>
      </tbody></table></div>
    </div>
  </section>

  <section class="emu-tab-panel" data-emu-panel="editor">
    <div class="panel emu-editor-panel">
      <div class="panel-title"><h2>PHP Emulator Source Editor</h2><span>Automatic backup + PHP syntax validation</span></div>
      <div class="emu-editor-grid">
        <aside class="emu-file-list" data-emu-file-list>
          <?php foreach($editorFiles as $i=>$file): ?><button type="button" class="<?= $i===0?'active':'' ?>" data-emu-file="<?= e($file) ?>"><?= e($file) ?></button><?php endforeach; ?>
        </aside>
        <div class="emu-editor-main">
          <div class="emu-editor-head"><strong data-emu-editor-name><?= e($editorFiles[0]??'') ?></strong><span data-emu-editor-meta>Select a file to edit.</span></div>
          <textarea spellcheck="false" data-emu-editor-content></textarea>
          <div class="emu-editor-actions">
            <span data-emu-editor-status>Edits are saved to the live project, with a timestamped backup first.</span>
            <button class="btn btn-ghost" type="button" data-emu-editor-reload>Reload File</button>
            <button class="btn btn-good" type="button" data-emu-editor-save>Save</button>
            <button class="btn btn-gold" type="button" data-emu-editor-save-restart>Save &amp; Restart</button>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="emu-tab-panel" data-emu-panel="commands">
    <div class="panel"><div class="panel-title"><h2>Database Command History</h2></div><div class="table-scroll"><table><thead><tr><th>ID</th><th>Command</th><th>Status</th><th>Requested</th><th>Result</th></tr></thead><tbody>
      <?php foreach($commands as $c): ?><tr><td><?= e($c['id']) ?></td><td><?= e($c['Command']) ?></td><td><span class="badge <?= $c['Status']==='complete'?'good':'' ?>"><?= e($c['Status']) ?></span></td><td><?= e($c['RequestedAt']) ?></td><td><?= e($c['Result']??'') ?></td></tr><?php endforeach; ?>
    </tbody></table></div></div>
  </section>
</div>
<?php $content=ob_get_clean();require __DIR__.'/../../layouts/admin.php'; ?>
