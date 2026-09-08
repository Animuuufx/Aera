document.addEventListener('click', async (event) => {
  const tile = event.target.closest('[data-copy]');
  if (!tile) return;
  const text = tile.getAttribute('data-copy') || '';
  try {
    await navigator.clipboard.writeText(text);
    const old = tile.title;
    tile.title = 'Copied: ' + text;
    setTimeout(() => tile.title = old, 1400);
  } catch (_) {
    window.prompt('Copy this path:', text);
  }
});

// Public portal interactions.
document.addEventListener('click', (event) => {
  const mobile = event.target.closest('[data-mobile-nav]');
  if (mobile) {
    const menu = document.querySelector('[data-nav-menu]');
    if (menu) menu.classList.toggle('open');
  }

  const tab = event.target.closest('[data-rank-tab]');
  if (tab) {
    const key = tab.getAttribute('data-rank-tab');
    document.querySelectorAll('[data-rank-tab]').forEach((el) => el.classList.toggle('active', el === tab));
    document.querySelectorAll('[data-rank-panel]').forEach((el) => el.classList.toggle('active', el.getAttribute('data-rank-panel') === key));
  }
});

/* Aera v24 web-managed PHP emulator workspace. */
(function () {
  function startEmulatorWorkspace() {
    var root = document.querySelector('[data-emu-workspace]');
    if (!root) return;

    var csrf = (document.querySelector('[data-emu-csrf]') || {}).value || '';
    var log = document.querySelector('[data-emulator-live-log]');
    var liveState = document.querySelector('[data-emulator-live-state]');
    var processState = document.querySelector('[data-emulator-process-state]');
    var processDot = document.querySelector('[data-emulator-process-dot]');
    var supervisor = document.querySelector('[data-emu-supervisor]');
    var commandForm = document.querySelector('[data-emulator-command-form]');
    var commandInput = document.querySelector('[data-emulator-command-input]');
    var commandStatus = document.querySelector('[data-emulator-command-status]');
    var cursor = parseInt(root.getAttribute('data-event-cursor') || '0', 10) || 0;
    var adminAccess = parseInt(root.getAttribute('data-admin-access') || '0', 10) || 0;
    var configuredPort = parseInt(root.getAttribute('data-configured-port') || '5589', 10) || 5589;
    var stopped = false;
    var userScrolled = false;
    var maxLines = 3000;
    var stateTimer = null;
    var selectedEditorFile = '';

    function esc(value) {
      return String(value == null ? '' : value)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;').replace(/'/g, '&#039;');
    }

    function nearBottom() {
      if (!log) return true;
      return (log.scrollHeight - log.scrollTop - log.clientHeight) < 100;
    }

    function setLive(text, failed) {
      if (!liveState) return;
      liveState.textContent = text;
      var parent = liveState.parentElement;
      if (parent) parent.classList.toggle('offline', !!failed);
    }

    function setProcess(state) {
      state = String(state || 'unknown');
      if (processState) processState.textContent = state.charAt(0).toUpperCase() + state.slice(1).replace(/-/g, ' ');
      if (processDot) processDot.classList.toggle('online', state === 'running');
    }

    function trimConsole() {
      if (!log) return;
      var lines = (log.textContent || '').split('\n');
      if (lines.length > maxLines) log.textContent = lines.slice(lines.length - maxLines).join('\n');
    }

    function appendLine(line, prefix) {
      if (!log || typeof line !== 'string' || line === '') return;
      var stick = !userScrolled || nearBottom();
      if (log.textContent && !log.textContent.endsWith('\n')) log.textContent += '\n';
      log.textContent += (prefix || '') + line + '\n';
      trimConsole();
      if (stick) {
        log.scrollTop = log.scrollHeight;
        userScrolled = false;
      }
    }

    if (log) {
      log.addEventListener('scroll', function () { userScrolled = !nearBottom(); });
      log.scrollTop = log.scrollHeight;
    }

    async function postForm(url, values) {
      var body = new FormData();
      body.append('_token', csrf);
      Object.keys(values || {}).forEach(function (key) { body.append(key, values[key] == null ? '' : String(values[key])); });
      var response = await fetch(url, {
        method: 'POST', body: body, credentials: 'same-origin', cache: 'no-store',
        headers: { 'Accept': 'application/json' }
      });
      var data = {};
      try { data = await response.json(); } catch (_) {}
      if (!response.ok && !data.message) data.message = 'HTTP ' + response.status;
      return data;
    }

    async function eventLoop() {
      while (!stopped) {
        try {
          var response = await fetch('/admin/emulator/events?cursor=' + encodeURIComponent(cursor), {
            credentials: 'same-origin', cache: 'no-store', headers: { 'Accept': 'application/json' }
          });
          var data = await response.json();
          if (!response.ok || !data.ok) {
            setLive('Waiting for emulator…', true);
            await new Promise(function (resolve) { setTimeout(resolve, 800); });
            continue;
          }

          setLive('Live', false);
          var events = Array.isArray(data.events) ? data.events : [];
          events.forEach(function (event) {
            if (event.type === 'line' && typeof event.line === 'string') appendLine(event.line, '');
            if (event.type === 'state' && event.state) setProcess(String(event.state));
            if (typeof event.seq === 'number') cursor = Math.max(cursor, event.seq);
          });
          if (typeof data.cursor === 'number') cursor = Math.max(cursor, data.cursor);
        } catch (_) {
          setLive('Reconnecting…', true);
          await new Promise(function (resolve) { setTimeout(resolve, 900); });
        }
      }
    }

    function formatUptime(seconds) {
      seconds = Math.max(0, parseInt(seconds || 0, 10));
      var d = Math.floor(seconds / 86400); seconds %= 86400;
      var h = Math.floor(seconds / 3600); seconds %= 3600;
      var m = Math.floor(seconds / 60); var s = seconds % 60;
      if (d) return d + 'd ' + h + 'h';
      if (h) return h + 'h ' + m + 'm';
      if (m) return m + 'm ' + s + 's';
      return s + 's';
    }

    function renderPlayers(players) {
      var body = document.querySelector('[data-emu-players-body]');
      var count = document.querySelector('[data-emu-player-count]');
      players = Array.isArray(players) ? players : [];
      if (count) count.textContent = players.length + ' online';
      if (!body) return;
      if (!players.length) {
        body.innerHTML = '<tr><td colspan="8" class="muted">No players are online.</td></tr>';
        return;
      }
      body.innerHTML = players.map(function (p) {
        var uid = parseInt(p.id || 0, 10) || 0;
        var access = parseInt(p.access || 0, 10) || 0;
        var banDisabled = (adminAccess < 60 || access >= 40) ? ' disabled' : '';
        var manageHref = '/admin/players?q=' + encodeURIComponent(String(p.name || ''));
        return '<tr>' +
          '<td><strong>' + esc(p.name) + '</strong><small>#' + esc(uid) + '</small></td>' +
          '<td>' + esc(p.level) + '</td>' +
          '<td>' + esc(p.room) + '</td>' +
          '<td>' + esc(p.hp) + '/' + esc(p.hpMax) + '</td>' +
          '<td>' + esc(p.mp) + '/' + esc(p.mpMax) + '</td>' +
          '<td>' + esc(access) + '</td>' +
          '<td>' + esc(p.ip) + '</td>' +
          '<td><div class="emu-player-actions">' +
            '<button type="button" class="btn btn-purple emu-small-btn" data-emu-player-action="message" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '">Message</button>' +
            '<button type="button" class="btn btn-danger emu-small-btn" data-emu-player-action="kick" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '">Kick</button>' +
            '<button type="button" class="btn btn-danger emu-small-btn" data-emu-player-action="ban" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '" data-target-access="' + esc(access) + '"' + banDisabled + '>Ban</button>' +
            '<button type="button" class="btn btn-ghost emu-small-btn" data-emu-player-action="' + (p.muted ? 'unmute' : 'mute') + '" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '" data-target-access="' + esc(access) + '">' + (p.muted ? 'Unmute' : 'Mute') + '</button>' +
            '<button type="button" class="btn btn-good emu-small-btn" data-emu-player-action="promote" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '" data-target-access="' + esc(access) + '"' + ((adminAccess < 60 || access >= adminAccess) ? ' disabled' : '') + '>Promote</button>' +
            '<button type="button" class="btn btn-danger emu-small-btn" data-emu-player-action="demote" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '" data-target-access="' + esc(access) + '"' + ((adminAccess < 60 || access >= adminAccess) ? ' disabled' : '') + '>Demote</button>' +
            '<button type="button" class="btn btn-gold emu-small-btn" data-emu-player-action="give-item" data-user-id="' + esc(uid) + '" data-player="' + esc(p.name) + '">Give Item</button>' +
            '<a class="btn btn-ghost emu-small-btn" href="' + esc(manageHref) + '">Manage</a>' +
          '</div></td>' +
          '</tr>';
      }).join('');
    }

    function renderRooms(rooms) {
      var body = document.querySelector('[data-emu-rooms-body]');
      var count = document.querySelector('[data-emu-room-count]');
      rooms = Array.isArray(rooms) ? rooms : [];
      if (count) count.textContent = rooms.length + ' rooms';
      if (!body) return;
      if (!rooms.length) {
        body.innerHTML = '<tr><td colspan="5" class="muted">No active rooms.</td></tr>';
        return;
      }
      body.innerHTML = rooms.map(function (r) {
        return '<tr><td>' + esc(r.id) + '</td><td><strong>' + esc(r.name) + '</strong></td><td>' + esc(r.players) + '</td><td>' + esc(r.monsters) + '</td><td>' + esc(r.monstersAlive) + '</td></tr>';
      }).join('');
    }

    function updateRuntime(runtime, control) {
      var state = control && control.state ? control.state : (runtime && runtime.running ? 'running' : 'stopped');
      setProcess(state);
      if (supervisor) supervisor.textContent = control && control.supervisorOnline ? 'Supervisor online' : 'Supervisor offline';
      var values = {
        '[data-emu-stat-pid]': runtime ? runtime.pid : '—',
        '[data-emu-stat-players]': runtime ? runtime.playersOnline : 0,
        '[data-emu-stat-rooms]': runtime ? runtime.activeRooms : 0,
        '[data-emu-stat-uptime]': runtime ? formatUptime(runtime.uptime) : '—',
        '[data-emu-stat-port]': runtime ? runtime.gamePort : configuredPort,
        '[data-emu-stat-shutdown]': runtime && runtime.shutdownRemaining != null ? runtime.shutdownRemaining + 's' : '—'
      };
      Object.keys(values).forEach(function (selector) { var el = document.querySelector(selector); if (el) el.textContent = values[selector]; });
      renderPlayers(runtime && runtime.players);
      renderRooms(runtime && runtime.rooms);

      // Event sequence starts from zero each time the emulator process restarts.
      if (runtime && typeof runtime.eventCursor === 'number' && runtime.eventCursor < cursor) cursor = runtime.eventCursor;
    }

    async function refreshState() {
      if (stopped) return;
      try {
        var response = await fetch('/admin/emulator/state', { credentials: 'same-origin', cache: 'no-store', headers: { 'Accept': 'application/json' } });
        var data = await response.json();
        if (data && data.ok) {
          if (parseInt(data.configuredPort || 0, 10) > 0) configuredPort = parseInt(data.configuredPort, 10);
          updateRuntime(data.runtime, data.control);
        }
      } catch (_) {}
    }

    root.addEventListener('click', async function (event) {
      var tab = event.target.closest('[data-emu-tab]');
      if (tab) {
        var name = tab.getAttribute('data-emu-tab');
        root.querySelectorAll('[data-emu-tab]').forEach(function (el) { el.classList.toggle('active', el === tab); });
        root.querySelectorAll('[data-emu-panel]').forEach(function (el) { el.classList.toggle('active', el.getAttribute('data-emu-panel') === name); });
        if (name === 'editor' && !selectedEditorFile) {
          var first = root.querySelector('[data-emu-file]'); if (first) loadEditorFile(first.getAttribute('data-emu-file'));
        }
        return;
      }

      var control = event.target.closest('[data-emu-control]');
      if (control) {
        var action = control.getAttribute('data-emu-control');
        if ((action === 'stop' || action === 'restart') && !window.confirm(action === 'stop' ? 'Hard stop the emulator now?' : 'Restart the emulator now?')) return;
        control.disabled = true;
        try {
          var data = await postForm('/admin/emulator/control/' + encodeURIComponent(action), {});
          appendLine(data.message || action, data.ok ? '< ' : '! ');
          if (action === 'restart' && data.ok) cursor = 0;
          await refreshState();
        } catch (_) { appendLine('Control request failed.', '! '); }
        control.disabled = false;
        return;
      }

      var rpc = event.target.closest('[data-emu-rpc]');
      if (rpc) {
        var rpcAction = rpc.getAttribute('data-emu-rpc');
        var values = { action: rpcAction };
        if (rpcAction === 'safe-shutdown') values.seconds = 300;
        rpc.disabled = true;
        try {
          var result = await postForm('/admin/emulator/rpc', values);
          appendLine(result.message || rpcAction, result.ok ? '< ' : '! ');
          await refreshState();
        } catch (_) { appendLine('Emulator action failed.', '! '); }
        rpc.disabled = false;
        return;
      }

      var playerAction = event.target.closest('[data-emu-player-action]');
      if (playerAction) {
        var action = playerAction.getAttribute('data-emu-player-action') || '';
        var player = playerAction.getAttribute('data-player') || '';
        var userId = parseInt(playerAction.getAttribute('data-user-id') || '0', 10) || 0;
        var values = { action: action, user_id: userId };

        if (action === 'message') {
          var message = window.prompt('Message to ' + player + ':', '');
          if (message == null || !message.trim()) return;
          values.message = message.trim();
        } else if (action === 'kick') {
          var kickReason = window.prompt('Kick reason for ' + player + ':', '');
          if (kickReason == null || !kickReason.trim()) return;
          if (!window.confirm('Kick ' + player + '?')) return;
          values.reason = kickReason.trim();
        } else if (action === 'ban') {
          if (adminAccess < 60) { window.alert('Administrator access is required to ban accounts.'); return; }
          var targetAccess = parseInt(playerAction.getAttribute('data-target-access') || '0', 10) || 0;
          if (targetAccess >= 40) { window.alert('Staff accounts are protected from panel bans.'); return; }
          var banReason = window.prompt('Ban reason for ' + player + ':', '');
          if (banReason == null || !banReason.trim()) return;
          if (!window.confirm('Ban and disconnect ' + player + '?')) return;
          values.reason = banReason.trim();
        } else if (action === 'mute') {
          var targetAccessMute = parseInt(playerAction.getAttribute('data-target-access') || '0', 10) || 0;
          if (targetAccessMute >= 40 && targetAccessMute >= adminAccess) { window.alert('You cannot mute staff of an equal or higher rank.'); return; }
          var muteMinutes = window.prompt('Mute ' + player + ' for how many minutes? (1-1440)', '5');
          if (muteMinutes == null || !/^\d+$/.test(muteMinutes.trim()) || parseInt(muteMinutes, 10) < 1 || parseInt(muteMinutes, 10) > 1440) { if (muteMinutes != null) window.alert('Enter 1-1440 minutes.'); return; }
          var muteReason = window.prompt('Mute reason (optional):', '');
          if (muteReason == null) return;
          values.minutes = parseInt(muteMinutes, 10);
          values.reason = muteReason.trim();
        } else if (action === 'unmute') {
          var targetAccessUnmute = parseInt(playerAction.getAttribute('data-target-access') || '0', 10) || 0;
          if (targetAccessUnmute >= 40 && targetAccessUnmute >= adminAccess) { window.alert('You cannot unmute staff of an equal or higher rank.'); return; }
          if (!window.confirm('Unmute ' + player + ' now?')) return;
        } else if (action === 'promote' || action === 'demote') {
          if (adminAccess < 60) { window.alert('Administrator access is required to change staff ranks.'); return; }
          var currentAccess = parseInt(playerAction.getAttribute('data-target-access') || '0', 10) || 0;
          if (currentAccess >= adminAccess) { window.alert('You cannot change a player with an equal or higher rank.'); return; }
          var promptText = action === 'promote' ? 'Promote ' + player + ' to: support, moderator, administrator, gm, owner' : 'Demote ' + player + ' to: player, support, moderator, administrator, gm';
          var rank = window.prompt(promptText, action === 'promote' ? 'moderator' : 'player');
          if (rank == null || !rank.trim()) return;
          values.rank = rank.trim();
          if (!window.confirm((action === 'promote' ? 'Promote ' : 'Demote ') + player + ' to ' + rank.trim() + '?')) return;
        } else if (action === 'give-item') {
          var itemId = window.prompt('Item ID to give ' + player + ':', '');
          if (itemId == null || !/^\d+$/.test(itemId.trim()) || parseInt(itemId, 10) < 1) { if (itemId != null) window.alert('Enter a valid item ID.'); return; }
          var quantity = window.prompt('Quantity:', '1');
          if (quantity == null || !/^\d+$/.test(quantity.trim()) || parseInt(quantity, 10) < 1) { if (quantity != null) window.alert('Enter a valid quantity.'); return; }
          values.item_id = parseInt(itemId, 10);
          values.quantity = parseInt(quantity, 10);
        } else {
          return;
        }

        playerAction.disabled = true;
        try {
          var playerResult = await postForm('/admin/emulator/player-action', values);
          appendLine(playerResult.message || (action + ' request completed.'), playerResult.ok ? '< ' : '! ');
          if (!playerResult.ok) window.alert(playerResult.message || 'Player action failed.');
          await refreshState();
        } catch (_) {
          appendLine('Player action request failed.', '! ');
        }
        playerAction.disabled = false;
        return;
      }

      var fileButton = event.target.closest('[data-emu-file]');
      if (fileButton) {
        root.querySelectorAll('[data-emu-file]').forEach(function (el) { el.classList.toggle('active', el === fileButton); });
        loadEditorFile(fileButton.getAttribute('data-emu-file'));
        return;
      }

      if (event.target.closest('[data-emu-editor-reload]')) { if (selectedEditorFile) loadEditorFile(selectedEditorFile); return; }
      if (event.target.closest('[data-emu-editor-save]')) { saveEditor(false); return; }
      if (event.target.closest('[data-emu-editor-save-restart]')) { saveEditor(true); return; }
    });

    var broadcastForm = document.querySelector('[data-emu-broadcast-form]');
    if (broadcastForm) broadcastForm.addEventListener('submit', async function (event) {
      event.preventDefault();
      var input = broadcastForm.querySelector('[name="message"]');
      var message = (input && input.value || '').trim();
      if (!message) return;
      var result = await postForm('/admin/emulator/rpc', { action: 'broadcast', message: message });
      appendLine(result.message || 'Broadcast request completed.', result.ok ? '< ' : '! ');
      if (result.ok && input) input.value = '';
    });

    if (commandForm) commandForm.addEventListener('submit', async function (event) {
      event.preventDefault();
      var command = (commandInput && commandInput.value || '').trim();
      if (!command) return;
      appendLine(command, '> ');
      if (commandStatus) commandStatus.textContent = 'Sending…';
      var body = new FormData(commandForm);
      try {
        var response = await fetch(commandForm.action, { method: 'POST', body: body, credentials: 'same-origin', cache: 'no-store', headers: { 'Accept': 'application/json' } });
        var data = await response.json();
        appendLine(data.message || ('HTTP ' + response.status), data.ok ? '< ' : '! ');
        if (commandStatus) commandStatus.textContent = data.ok ? 'Command completed.' : 'Command failed.';
        if (data.ok && commandInput) commandInput.value = '';
      } catch (_) {
        appendLine('Console command connection failed.', '! ');
        if (commandStatus) commandStatus.textContent = 'Could not reach emulator control channel.';
      }
    });

    async function loadEditorFile(file) {
      if (!file) return;
      var textarea = document.querySelector('[data-emu-editor-content]');
      var name = document.querySelector('[data-emu-editor-name]');
      var meta = document.querySelector('[data-emu-editor-meta]');
      var status = document.querySelector('[data-emu-editor-status]');
      if (status) status.textContent = 'Loading ' + file + '…';
      try {
        var response = await fetch('/admin/emulator/editor?file=' + encodeURIComponent(file), { credentials: 'same-origin', cache: 'no-store', headers: { 'Accept': 'application/json' } });
        var data = await response.json();
        if (!data.ok) throw new Error(data.message || 'Could not load source file.');
        selectedEditorFile = data.file;
        if (textarea) textarea.value = data.content || '';
        if (name) name.textContent = data.file;
        if (meta) meta.textContent = (data.bytes || 0).toLocaleString() + ' bytes · ' + (data.modified || '');
        if (status) status.textContent = 'Loaded. PHP files are syntax-checked before saving.';
      } catch (error) {
        if (status) status.textContent = error.message || 'Could not load source file.';
      }
    }

    async function saveEditor(restart) {
      if (!selectedEditorFile) return;
      var textarea = document.querySelector('[data-emu-editor-content]');
      var status = document.querySelector('[data-emu-editor-status]');
      if (!textarea) return;
      if (restart && !window.confirm('Save this file and restart the emulator?')) return;
      if (status) status.textContent = restart ? 'Saving and restarting…' : 'Saving…';
      try {
        var data = await postForm('/admin/emulator/editor/save', { file: selectedEditorFile, content: textarea.value, restart: restart ? 1 : 0 });
        if (status) status.textContent = data.message || (data.ok ? 'Saved.' : 'Save failed.');
        if (data.ok) appendLine(data.message || ('Saved ' + selectedEditorFile), '< ');
        else appendLine(data.message || 'Source save failed.', '! ');
        if (restart && data.ok) cursor = 0;
      } catch (_) {
        if (status) status.textContent = 'Save request failed.';
      }
    }

    setLive('Connecting…', true);
    eventLoop();
    refreshState();
    stateTimer = window.setInterval(refreshState, 2000);
    window.addEventListener('beforeunload', function () { stopped = true; if (stateTimer) window.clearInterval(stateTimer); });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', startEmulatorWorkspace);
  else startEmulatorWorkspace();
})();

// v30.24: lightweight search for live database relation selectors.
document.addEventListener('input', function (event) {
  var search = event.target.closest('[data-relation-search]');
  if (!search) return;
  var wrap = search.closest('[data-relation-control]');
  var select = wrap ? wrap.querySelector('[data-relation-select]') : null;
  if (!select) return;
  var needle = String(search.value || '').trim().toLowerCase();
  Array.prototype.forEach.call(select.options, function (option, index) {
    if (index === 0 || option.selected) { option.hidden = false; return; }
    option.hidden = needle !== '' && option.text.toLowerCase().indexOf(needle) === -1;
  });
});

// v30.25: purpose-built NPC / NPC-button / NPC-placement admin controls.
(function () {
  function parseMapCells(form) {
    var node = form ? form.querySelector('[data-npc-map-cells-json]') : null;
    if (!node) return {};
    try { return JSON.parse(node.textContent || '{}') || {}; } catch (_) { return {}; }
  }

  function optionSearch(input, select) {
    if (!input || !select) return;
    var needle = String(input.value || '').trim().toLowerCase();
    Array.prototype.forEach.call(select.options, function (option, index) {
      if (index === 0 || option.selected) { option.hidden = false; return; }
      option.hidden = needle !== '' && option.text.toLowerCase().indexOf(needle) === -1;
    });
  }

  document.addEventListener('input', function (event) {
    var search = event.target.closest('[data-local-select-search]');
    if (search) {
      var wrap = search.closest('.relation-control');
      optionSearch(search, wrap ? wrap.querySelector('select') : null);
      return;
    }
    var multiSearch = event.target.closest('[data-npc-multi-search]');
    if (multiSearch) {
      var mode = multiSearch.closest('[data-npc-value-mode]');
      var needle = String(multiSearch.value || '').trim().toLowerCase();
      Array.prototype.forEach.call(mode ? mode.querySelectorAll('[data-search-label]') : [], function (row) {
        row.hidden = needle !== '' && String(row.getAttribute('data-search-label') || '').indexOf(needle) === -1;
      });
      return;
    }
    var colorText = event.target.closest('[data-npc-color-text]');
    if (colorText) {
      var colorWrap = colorText.closest('[data-npc-color-control]');
      var picker = colorWrap ? colorWrap.querySelector('[data-npc-color-picker]') : null;
      var raw = String(colorText.value || '').trim().replace(/^0x/i, '').replace(/^#/, '').replace(/[^0-9a-f]/ig, '');
      if (picker && raw.length > 0) {
        raw = ('000000' + raw).slice(-6);
        picker.value = '#' + raw;
      }
    }
  });

  document.addEventListener('change', function (event) {
    var picker = event.target.closest('[data-npc-color-picker]');
    if (picker) {
      var wrap = picker.closest('[data-npc-color-control]');
      var text = wrap ? wrap.querySelector('[data-npc-color-text]') : null;
      if (text) text.value = '0x' + String(picker.value || '#000000').replace('#', '').toUpperCase();
    }
  });

  document.addEventListener('click', function (event) {
    var clear = event.target.closest('[data-npc-color-clear]');
    if (!clear) return;
    var wrap = clear.closest('[data-npc-color-control]');
    var text = wrap ? wrap.querySelector('[data-npc-color-text]') : null;
    if (text) text.value = '';
  });

  function mapById(mapData, id) {
    return mapData[String(id)] || null;
  }
  function mapByName(mapData, name) {
    var key;
    var needle = String(name || '').toLowerCase();
    for (key in mapData) {
      if (!Object.prototype.hasOwnProperty.call(mapData, key)) continue;
      if (String(mapData[key].name || '').toLowerCase() === needle) return mapData[key];
    }
    return null;
  }
  function uniqueFrames(map) {
    var out = [];
    var seen = {};
    Array.prototype.forEach.call(map && map.cells ? map.cells : [], function (cell) {
      var frame = String(cell.frame || 'Enter');
      var k = frame.toLowerCase();
      if (!seen[k]) { seen[k] = true; out.push(frame); }
    });
    if (!out.length) out.push('Enter');
    return out;
  }
  function padsForFrame(map, frame) {
    var out = [];
    var seen = {};
    Array.prototype.forEach.call(map && map.cells ? map.cells : [], function (cell) {
      if (String(cell.frame || '').toLowerCase() !== String(frame || '').toLowerCase()) return;
      var pad = String(cell.pad || 'Spawn');
      var k = pad.toLowerCase();
      if (!seen[k]) { seen[k] = true; out.push(pad); }
    });
    if (!out.length) out.push('Spawn');
    return out;
  }
  function replaceSelectOptions(select, values, desired) {
    if (!select) return '';
    var wanted = String(desired || '');
    select.innerHTML = '';
    Array.prototype.forEach.call(values || [], function (value) {
      var option = document.createElement('option');
      option.value = value;
      option.textContent = value;
      if (String(value).toLowerCase() === wanted.toLowerCase()) option.selected = true;
      select.appendChild(option);
    });
    if (wanted && !Array.prototype.some.call(select.options, function (o) { return String(o.value).toLowerCase() === wanted.toLowerCase(); })) {
      var legacy = document.createElement('option');
      legacy.value = wanted;
      legacy.textContent = wanted + ' (existing)';
      legacy.selected = true;
      select.appendChild(legacy);
    }
    if (!select.value && select.options.length) select.selectedIndex = 0;
    return select.value;
  }

  function initNpcButtonEditor(form) {
    var actionSelect = form.querySelector('[data-npc-action-select]');
    var editor = form.querySelector('[data-npc-value-editor]');
    if (!actionSelect || !editor) return;
    var output = editor.querySelector('[data-npc-value-output]');
    var mapData = parseMapCells(form);
    var actionHelp = form.querySelector('[data-npc-action-help]');

    function activeMode() {
      var action = String(actionSelect.value || '').toLowerCase();
      var found = null;
      Array.prototype.forEach.call(editor.querySelectorAll('[data-npc-value-mode]'), function (mode) {
        var key = String(mode.getAttribute('data-npc-value-mode') || '').toLowerCase();
        var show = key === action;
        mode.hidden = !show;
        if (show) found = mode;
      });
      if (!found) {
        found = editor.querySelector('[data-npc-value-mode="__unknown"]');
        if (found) found.hidden = false;
      }
      return found;
    }

    function syncSingle(mode) {
      var select = mode ? mode.querySelector('[data-npc-value-single]') : null;
      if (output && select) output.value = select.value || '';
    }
    function syncMulti(mode) {
      var values = [];
      Array.prototype.forEach.call(mode ? mode.querySelectorAll('[data-npc-value-multi] input[type="checkbox"]:checked') : [], function (cb) { values.push(cb.value); });
      if (output) output.value = values.join(',');
    }
    function syncJoin(mode, preserveCurrent) {
      if (!mode) return;
      var mapSelect = mode.querySelector('[data-npc-join-map]');
      var frameSelect = mode.querySelector('[data-npc-join-frame]');
      var padSelect = mode.querySelector('[data-npc-join-pad]');
      var map = mapByName(mapData, mapSelect ? mapSelect.value : '');
      var desiredFrame = preserveCurrent ? (frameSelect.getAttribute('data-current') || frameSelect.value || 'Enter') : (frameSelect.value || 'Enter');
      var frame = replaceSelectOptions(frameSelect, uniqueFrames(map), desiredFrame);
      var desiredPad = preserveCurrent ? (padSelect.getAttribute('data-current') || padSelect.value || 'Spawn') : (padSelect.value || 'Spawn');
      var pad = replaceSelectOptions(padSelect, padsForFrame(map, frame), desiredPad);
      if (output) output.value = mapSelect && mapSelect.value ? [mapSelect.value, frame || 'Enter', pad || 'Spawn'].join('|') : '';
      frameSelect.removeAttribute('data-current');
      padSelect.removeAttribute('data-current');
    }

    function syncActive(preserveJoin) {
      var mode = activeMode();
      if (!mode) return;
      if (mode.querySelector('[data-npc-value-single]')) syncSingle(mode);
      else if (mode.querySelector('[data-npc-value-multi]')) syncMulti(mode);
      else if (mode.classList.contains('npc-join-editor')) syncJoin(mode, !!preserveJoin);
      else if (mode.classList.contains('npc-no-value') && mode.getAttribute('data-npc-value-mode') !== '__unknown') { if (output) output.value = ''; }
      var selected = actionSelect.options[actionSelect.selectedIndex];
      if (actionHelp) {
        var modeName = selected ? selected.getAttribute('data-value-mode') : '';
        actionHelp.textContent = modeName === 'single' ? 'Value is linked to the selected database record.' : modeName === 'multi' ? 'Value stores the selected IDs.' : modeName === 'join' ? 'Value is built from the selected map, frame, and pad.' : modeName === 'none' ? 'This action does not require a Value.' : '';
      }
    }

    actionSelect.addEventListener('change', function () { syncActive(false); });
    editor.addEventListener('change', function (event) {
      var mode = event.target.closest('[data-npc-value-mode]');
      if (!mode) return;
      if (event.target.matches('[data-npc-value-single]')) syncSingle(mode);
      else if (event.target.matches('[data-npc-value-multi] input[type="checkbox"]')) syncMulti(mode);
      else if (event.target.matches('[data-npc-join-map]')) syncJoin(mode, false);
      else if (event.target.matches('[data-npc-join-frame]')) {
        var mapSelect = mode.querySelector('[data-npc-join-map]');
        var padSelect = mode.querySelector('[data-npc-join-pad]');
        var map = mapByName(mapData, mapSelect ? mapSelect.value : '');
        replaceSelectOptions(padSelect, padsForFrame(map, event.target.value), 'Spawn');
        syncJoin(mode, false);
      }
      else if (event.target.matches('[data-npc-join-pad]')) syncJoin(mode, false);
    });
    syncActive(true);
  }

  function initNpcPlacementEditor(form) {
    var mapSelect = form.querySelector('[data-map-id-select]');
    var frameSelect = form.querySelector('[data-map-frame-select]');
    if (!mapSelect || !frameSelect) return;
    var mapData = parseMapCells(form);
    var initial = frameSelect.getAttribute('data-current-frame') || frameSelect.value || 'Enter';
    function refresh(preserve) {
      var map = mapById(mapData, mapSelect.value);
      replaceSelectOptions(frameSelect, uniqueFrames(map), preserve ? initial : 'Enter');
      initial = frameSelect.value || 'Enter';
    }
    mapSelect.addEventListener('change', function () { refresh(false); });
    refresh(true);
  }

  function initMapArrowEditor(form) {
    var sourceMap = form.querySelector('[data-map-arrow-source-map]');
    var sourceFrame = form.querySelector('[data-map-arrow-source-frame]');
    var sourceCustom = form.querySelector('[data-map-arrow-source-frame-custom]');
    var targetType = form.querySelector('[data-map-arrow-target-type]');
    var targetMap = form.querySelector('[data-map-arrow-target-map]');
    var targetFrame = form.querySelector('[data-map-arrow-target-frame]');
    var targetFrameCustom = form.querySelector('[data-map-arrow-target-frame-custom]');
    var targetPad = form.querySelector('[data-map-arrow-target-pad]');
    var targetPadCustom = form.querySelector('[data-map-arrow-target-pad-custom]');
    if (!sourceMap || !sourceFrame || !targetType || !targetFrame || !targetPad) return;

    var mapData = parseMapCells(form);
    var initialSourceFrame = sourceFrame.getAttribute('data-current-frame') || sourceFrame.value || 'Enter';
    var initialTargetFrame = targetFrame.getAttribute('data-current-frame') || targetFrame.value || 'Enter';
    var initialTargetPad = targetPad.getAttribute('data-current-pad') || targetPad.value || 'Spawn';
    var targetMapWrap = targetMap ? targetMap.closest('.db-field') : null;

    function effectiveTargetMap() {
      return String(targetType.value || 'Room').toLowerCase() === 'map'
        ? mapById(mapData, targetMap ? targetMap.value : '')
        : mapById(mapData, sourceMap.value);
    }

    function refreshSource(preserve) {
      var map = mapById(mapData, sourceMap.value);
      replaceSelectOptions(sourceFrame, uniqueFrames(map), preserve ? initialSourceFrame : 'Enter');
      initialSourceFrame = sourceFrame.value || 'Enter';
    }

    function refreshTarget(preserve) {
      var isMap = String(targetType.value || 'Room').toLowerCase() === 'map';
      if (targetMapWrap) targetMapWrap.hidden = !isMap;
      if (targetMap) targetMap.required = isMap;
      var map = effectiveTargetMap();
      var frameWanted = preserve ? initialTargetFrame : (targetFrame.value || 'Enter');
      var frame = replaceSelectOptions(targetFrame, uniqueFrames(map), frameWanted);
      var padWanted = preserve ? initialTargetPad : (targetPad.value || 'Spawn');
      replaceSelectOptions(targetPad, padsForFrame(map, frame), padWanted);
      initialTargetFrame = targetFrame.value || 'Enter';
      initialTargetPad = targetPad.value || 'Spawn';
    }

    function addCustom(input, select, afterChange) {
      if (!input || !select) return;
      function apply() {
        var value = String(input.value || '').trim();
        if (!value) return;
        var values = Array.prototype.map.call(select.options, function (o) { return o.value; });
        if (values.map(function (v) { return String(v).toLowerCase(); }).indexOf(value.toLowerCase()) === -1) values.push(value);
        replaceSelectOptions(select, values, value);
        input.value = '';
        if (afterChange) afterChange(value);
      }
      input.addEventListener('change', apply);
      input.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') { event.preventDefault(); apply(); }
      });
    }

    sourceMap.addEventListener('change', function () { refreshSource(false); if (String(targetType.value).toLowerCase() !== 'map') refreshTarget(false); });
    targetType.addEventListener('change', function () { refreshTarget(false); });
    if (targetMap) targetMap.addEventListener('change', function () { refreshTarget(false); });
    targetFrame.addEventListener('change', function () {
      var map = effectiveTargetMap();
      replaceSelectOptions(targetPad, padsForFrame(map, targetFrame.value), 'Spawn');
    });
    addCustom(sourceCustom, sourceFrame, null);
    addCustom(targetFrameCustom, targetFrame, function (value) {
      var map = effectiveTargetMap();
      replaceSelectOptions(targetPad, padsForFrame(map, value), 'Spawn');
    });
    addCustom(targetPadCustom, targetPad, null);

    refreshSource(true);
    refreshTarget(true);
  }

  function init() {
    Array.prototype.forEach.call(document.querySelectorAll('[data-admin-data-form]'), function (form) {
      initNpcButtonEditor(form);
      initNpcPlacementEditor(form);
      initMapArrowEditor(form);
    });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
