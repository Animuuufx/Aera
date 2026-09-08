<?php $title='Store'; $heading='PayPal Settings'; $subheading='Configure the PayPal account and checkout mode used by the Aera Store.'; ob_start(); ?>
<div class="panel-title"><div><h2>PayPal Settings</h2><p class="muted">Credentials are stored in Aera's server-side runtime configuration and are never sent to the browser.</p></div><a class="btn btn-ghost" href="/admin/store">Back to Store</a></div>
<div class="panel">
<form method="post" action="/admin/store/paypal">
<?= csrf_field() ?>
<div class="form-grid">
<label>Mode<select name="mode"><option value="sandbox" <?= $paypal['mode']==='sandbox'?'selected':'' ?>>Sandbox — testing</option><option value="live" <?= $paypal['mode']==='live'?'selected':'' ?>>Live — real payments</option></select></label>
<label>PayPal Client ID<input type="text" name="client_id" autocomplete="off" value="<?= e($paypal['clientId']) ?>" placeholder="Paste your PayPal Client ID"></label>
<label>PayPal Client Secret<input type="password" name="client_secret" autocomplete="new-password" value="" placeholder="Leave blank to keep the existing secret"><small class="muted">The existing secret is preserved when this field is left blank.</small></label>
<label>Merchant Email<input type="email" name="merchant_email" value="<?= e($paypal['merchantEmail']) ?>" placeholder="your-paypal-email@example.com"></label>
<label>Store Brand Name<input type="text" name="brand_name" maxlength="120" value="<?= e($paypal['brandName']) ?>" placeholder="Aera"></label>
</div>
<div style="margin-top:20px;padding:15px;border:1px solid #252a31;background:rgba(255,255,255,.025)">
<strong>Status:</strong> <?= $paypal['configured'] ? '<span style="color:#7ddc9a">Configured</span>' : '<span style="color:#ef443f">Missing Client ID or Client Secret</span>' ?>
<p class="muted" style="margin-top:8px">Use Sandbox while testing with PayPal sandbox accounts. Switch to Live only when your live Client ID and Client Secret are ready.</p>
</div>
<div style="margin-top:20px;display:flex;gap:10px;align-items:center"><button class="btn btn-gold" type="submit">Save PayPal Settings</button><button class="btn btn-ghost" type="button" onclick="testPayPal()">Test PayPal Connection</button><span id="paypal-test-status" class="muted"></span></div>
</form>
</div>
<script>
async function testPayPal(){const out=document.getElementById('paypal-test-status');out.textContent='Testing…';try{const r=await fetch('/admin/store/paypal/test',{cache:'no-store',headers:{'Accept':'application/json'}});const d=await r.json();if(!r.ok||!d.ok)throw new Error(d.error||('Request failed (HTTP '+r.status+').'));out.textContent='✓ '+d.message+' ('+d.mode+')';out.style.color='#7ddc9a';}catch(e){out.textContent='✕ '+(e.message||'Connection test failed.');out.style.color='#ef443f';}}
</script>
<?php $content=ob_get_clean(); require __DIR__.'/../../layouts/admin.php'; ?>
