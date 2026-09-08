AERA FOUNDATION - IIS ROUTING
=============================

Recommended IIS site Physical Path:
  C:\Aera\web\public

Requirements:
  - IIS FastCGI configured for PHP 8.2.9
  - Microsoft URL Rewrite Module 2.x
  - PHP extension pdo_mysql enabled
  - MySQL 5.7.9

The active public/web.config routes clean URLs such as /setup, /login, /account,
/admin and /api/* to index.php while leaving real files such as SWFs, CSS and JS alone.

If URL Rewrite is not installed yet, these physical diagnostics still work:
  https://nightvaults.com/setup.php
  https://nightvaults.com/health.php

Once URL Rewrite is active, use:
  https://nightvaults.com/setup
  https://nightvaults.com/health

The framework does NOT use Laravel.
