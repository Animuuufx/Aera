# Aera Web — IIS v7

Custom PHP 8.2 framework for Aera. No Laravel.

## v7 changes
- Removed Store from the main navigation.
- Hardened `/admin/data/{table}` on MySQL 5.7 by using direct metadata queries for `SHOW TABLES`, `SHOW FULL COLUMNS`, `SHOW KEYS`, and table status.
- Rankings now query only the selected leaderboard.
- Guild ranking member counts no longer depend on `GROUP BY` behavior.
- Generic 500 pages include a short error reference while full details remain in `storage/logs`.

Recommended IIS physical path: `C:\Aera\web\public`.
Preserve `storage/config.php` when applying a patch over an existing installation.
