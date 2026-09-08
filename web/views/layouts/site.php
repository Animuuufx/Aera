<?php
use Aera\Foundation\Auth;
use Aera\Foundation\Session;
use Aera\Foundation\Installer;
try { $user=Installer::isConfigured()?Auth::user():null; } catch (\Throwable $e) { $user=null; }
$success=Session::pull('success'); $error=Session::pull('error'); $warning=Session::pull('warning');
?><!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= e(($title ?? 'Aera').' · Aera') ?></title>
<meta name="description" content="Aera — a community fantasy MMORPG private server.">
<link rel="icon" type="image/png" href="/assets/images/aera-favicon-v13.png">
<link rel="stylesheet" href="/assets/css/app.css?v=24.0.0">
<link rel="stylesheet" href="/assets/css/portal.css?v=21.0.0">
</head>
<body class="portal-body">
<div class="portal-page">
<header class="portal-topbar">
  <div class="portal-topbar-inner">
    <a class="portal-brand" href="/" aria-label="Aera home">
      <img src="/assets/images/aera-logo-gold-v13.png" alt="Aera">
    </a>
    <button class="portal-mobile-toggle" type="button" data-mobile-nav aria-label="Toggle navigation">☰</button>
    <nav class="portal-nav" data-nav-menu>
      <a href="/rankings">Ranking</a>
      <div class="portal-nav-drop"><button type="button">Resources <span>⌄</span></button><div><a href="/play">Play Aera</a><a href="/#news">News</a><a href="/account">Account</a></div></div>
      <div class="portal-nav-drop"><button type="button">Support <span>⌄</span></button><div><a href="/character">Character Lookup</a></div></div>
      <?php if(!$user): ?><a href="/register">Register</a><?php endif; ?>
      <?php if($user && (int)$user['Access']>=40): ?><a href="/admin">Admin</a><?php endif; ?>
    </nav>
    <div class="portal-user-actions">
      <?php if($user): ?>
        <a class="portal-user-link" href="/account">Hi, <?= e($user['Name']) ?></a>
        <form method="post" action="/logout"><?= csrf_field() ?><button type="submit" class="portal-link-button">Logout</button></form>
      <?php else: ?>
        <a class="portal-user-link" href="/login"><span class="portal-signin-icon">♟</span> Sign In</a>
      <?php endif; ?>
    </div>
  </div>
</header>

<section class="portal-banner" aria-label="Aera"></section>

<?php if($success): ?><div class="portal-flash success"><?= e($success) ?></div><?php endif; ?>
<?php if($error): ?><div class="portal-flash error"><?= e($error) ?></div><?php endif; ?>
<?php if($warning): ?><div class="portal-flash warning"><?= e($warning) ?></div><?php endif; ?>

<main class="portal-main"><?= $content ?? '' ?></main>

<footer class="portal-footer">
  <div>© <?= date('Y') ?> Aera. All Rights Reserved.</div>
</footer>
</div>
<script src="/assets/js/app.js?v=24.0.0"></script>
</body>
</html>
