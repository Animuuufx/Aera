# Aera PHP Emulator v30

Aera Expeditions adds private roguelite runs, temporary blessings, Marks and
weekly records. See [installation and rules](docs/EXPEDITIONS.md).

Aera Rifts adds shared dynamic world events, mutations, contribution rewards,
and a Rift Shard shop. See [setup and operations](docs/AERA_RIFTS.md).

v30 completes the full Java/PHP runtime audit: 173 Java classes accounted for, 94/94 Java RequestManage routes, 13/13 Java tasks, 104/104 stock-AS3 requests, schema/config/task/client-contract auditing, and semantic request tracing.

Run `php bin/selftest.php` and `php bin/audit.php` before deployment.

# Aera PHP Emulator v26

v27 fixes inventory equip-state serialization, Java action-bar stat coefficients (`$cmc`/`$tha`), cooldown-mask timing, and same-cell monster targeting.
v26 fixes the stock-client combat/class-action path: Java-format `gar` parsing, `skills_assign` class skills, `sAct` action-bar bootstrap, Java `hp/type` action-result fields, and Java-style monster `sara` responses.

PHP 8.2 CLI implementation of the Aera game-server protocol.

## Request parity

- 94/94 legacy Java `RequestManage` names have explicit routes.
- 24/24 additional stock-client aliases have explicit routes.
- SmartFox string and JSON XT framing are both accepted.
- Private houses, timed rest/respawn state, and PvP queue/match state run inside the persistent emulator process.

Run `php bin\selftest.php` from this directory (or `php Emulator\PHP\bin\selftest.php` from the project root) before deployment. The test requires no database connection.

## Runtime

- Entry: `bin/server.php`
- Watchdog: `watchdog.bat`
- SYSTEM supervisor: `supervisor.ps1`
- Game TCP port: `5588`
- Local live-console port: `127.0.0.1:5591`
- Zone: `zone_master`
- DB: `aera`, using `web/storage/config.php`
- Historical log: `runtime/logs/panel-console.log`
- PID: `runtime/emulator.pid`

## Live panel console

The emulator owns a local-only console socket. `AdminEmulatorController::stream()` attaches to it and proxies output to the authenticated browser with Server-Sent Events. Output is pushed immediately from `Logger` to attached console clients; the panel does not poll the log file.

The same socket accepts authenticated-panel console commands through `/admin/emulator/console-command`.

## Start/stop control

Run project-root `INSTALL_PHP_EMULATOR_CONTROL.bat` once as Administrator. It installs `AeraPHPEmulatorSupervisor` under SYSTEM. The IIS worker never calls `schtasks.exe`; it writes request files into `runtime/control/`, and the supervisor acknowledges them there.

Unexpected emulator exits are restarted by `watchdog.bat`. Intentional Stop/Safe Shutdown writes the desired state as stopped so the supervisor does not immediately bring the emulator back.


## v28 monster state/respawn parity

Monster combat state now stays at `2` while engaged, and timed monster respawns send Java-compatible `mtls` followed by `respawnMon`.
