<?php $title='Aera Rifts';$heading='Aera Rifts';$subheading='Shared world invasions, contribution rewards, and event history.';ob_start(); ?>
<link rel="stylesheet" href="/assets/css/rifts.css?v=1"><div class="rift-admin">
<?php if(!$ready): ?>
<div class="flash warning">Install Database/patches/v30_80_aera_rifts.sql and restart the emulator to enable Rifts.</div>
<?php else: $state=$runtime['data']??[]; ?>
<section class="card"><h2>Current event</h2>
<p><?= e(!empty($state['active'])?$state['tier'].' · '.$state['modifier'].' Rift in '.$state['map'].' · '.$state['phase'].' · '.$state['progress'].'% · '.$state['players'].' contributors':'No active Rift') ?></p>
<?php if(!empty($state['active'])): ?><progress aria-label="Rift phase progress" max="100" value="<?= (int)$state['progress'] ?>"></progress><?php endif; ?>
<?php if(empty($runtime['ok'])): ?><p><?= e($runtime['message']??'Emulator unavailable') ?></p><?php endif; ?>
<form method="post" action="/admin/rifts"><?= csrf_field() ?>
<label>Location / definition <select name="definition" required><?php foreach($definitions as $d): ?><option value="<?= (int)$d['id'] ?>"><?= e($d['Name'].' — '.$d['Map'].(!$d['Enabled']?' (disabled)':'')) ?></option><?php endforeach; ?></select></label>
<label>Tier <select name="tier"><?php foreach(['Normal','Heroic','Legendary'] as $v): ?><option><?= e($v) ?></option><?php endforeach; ?></select></label>
<label>Modifier <select name="modifier"><?php foreach(['Random','Blood','Arcane','Titan','Swift','Golden','Corrupted'] as $v): ?><option><?= e($v) ?></option><?php endforeach; ?></select></label>
<label>Reward multiplier <input type="number" name="multiplier" min="0.1" max="10" step="0.1" value="1" required></label>
<button name="action" value="rift-start">Start Rift</button><button name="action" value="rift-stop" formnovalidate>Stop Rift</button><button name="action" value="rift-boss" formnovalidate>Spawn Final Boss</button><button name="action" value="rift-multiplier">Set Reward Multiplier</button>
</form><p><a href="/admin/rifts">Refresh status</a> · <a href="/rifts">View Shard shop and history</a></p></section>
<section class="card"><h2>Create encounter</h2><p>Choose existing assets. The map must have database monster placements. Objectives use the first placement cell as the defense area.</p>
<form method="post" action="/admin/rifts"><?= csrf_field() ?><input type="hidden" name="action" value="definition">
<label>Name <input name="name" maxlength="100" required></label><label>Map <select name="map"><?php foreach($maps as $m): ?><option><?= e($m['Name']) ?></option><?php endforeach; ?></select></label>
<?php foreach(['invader','elite','crystal','commander'] as $role): ?><label><?= e(ucfirst($role)) ?> <select name="<?= e($role) ?>"><?php foreach($monsters as $m): ?><option value="<?= (int)$m['id'] ?>"><?= e($m['Name'].' (#'.$m['id'].')') ?></option><?php endforeach; ?></select></label><?php endforeach; ?>
<button>Create enabled definition</button></form><p><a href="/admin/data/rift_definitions">Edit definitions, goals, duration, and base rewards</a></p></section>
<section class="card"><h2>Shard shop</h2><form method="post" action="/admin/rifts"><?= csrf_field() ?><input type="hidden" name="action" value="shop"><label>Item ID <input type="number" name="item" min="1" required></label><label>Shard cost <input type="number" name="cost" min="1" max="1000000" required></label><button>Add item</button></form><a href="/admin/data/rift_shop">Edit shop rewards</a></section>
<section class="card"><h2>Recent Rifts</h2><table><thead><tr><th>Location</th><th>Tier</th><th>Modifier</th><th>Result</th><th>Started</th></tr></thead><tbody><?php foreach($history as $h): ?><tr><td><?= e($h['Map']) ?></td><td><?= e($h['Tier']) ?></td><td><?= e($h['Modifier']) ?></td><td><?= e($h['Status']) ?></td><td><?= e($h['StartedAt']) ?></td></tr><?php endforeach; ?></tbody></table></section>
<?php endif; ?>
</div>
<?php $content=ob_get_clean();require __DIR__.'/../layouts/admin.php'; ?>
