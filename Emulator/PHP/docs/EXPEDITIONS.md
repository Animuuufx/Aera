# Aera Expeditions v1

This feature runs in the PHP 8.2 emulator on Client-Fixes and uses the existing
SmartFox XT string/JSON protocol and AS3 client. There is no Java emulator source
in this branch to update. No new art assets or external packages are required.

## Install

1. Import `Database/patches/v30_82_expeditions.sql` into the game database. It is
   rerunnable and uses MySQL 5.7.9-compatible SQL. It creates seven new InnoDB
   tables without changing existing player, inventory or currency tables.
2. Review `expedition_maps`. The migration seeds up to eight existing public,
   non-member, non-PvP level-1 maps with monster placements. Set `Enabled=0` for
   maps that are not suitable arenas. At least one usable map is required.
   A placement's existing frame, monster art and base stats are reused. The
   client uses database positioning to place 1–4 enemies in that frame; inspect
   the selected maps in-game for sensible ground coordinates and native map
   scripts. Native arrows that attempt cell travel are rejected by the server.
3. Publish the existing client FLA with `Sources/Client/src` as its source path
   using the project's normal Animate publishing workflow, then deploy that
   client SWF through the existing game loader. The source includes a new
   `liteAssets.draw.expeditionPanel` class. A standalone panel compilation is
   useful as a syntax check but is not a replacement game client.
4. Restart the PHP emulator. Missing expedition tables disable the feature
   without affecting normal gameplay. No database migration is run automatically.
5. Open **Your Hero → Expedition**, or type `/expedition` or `/gauntlet`.

## Play

- **Solo:** ten rooms. **Party:** ten rooms with up to four players. A player in
  an existing game party creates the lobby; other members explicitly join it.
  The lobby creator launches, locking the expedition roster. No late joins or
  re-entry after departure. Changes to the social party after launch do not
  alter the expedition roster.
- **Endless:** solo, until cash-out or defeat. **Weekly:** solo endless with a
  common seed and frozen content snapshot per UTC ISO week and rules version.
  Gear/classes remain the player's own; this is not a normalized competitive
  tournament. Raise `ExpeditionRun::VERSION` when changing generation/balance.
- Rooms roll an existing map/monster placement and one of six modifiers.
  Every third room is elite; every fifth is a boss. Depth and party size scale
  enemy health; depth scales damage. Bosses take priority over elites.
- Clear every enemy, then choose one of three distinct temporary blessings.
  All party members must choose before continuing, and continue votes must be
  unanimous. Any member can cash out the entire party after a room is cleared.
- Each room adds `5 + 2 × depth` Marks to each player's pending bank, plus ten
  for bosses. Ten-room completion pays 180 Marks. Cash-out and completion pay
  100%; wipe, departure, disconnect, timeout or graceful shutdown pay floor(50%).
  Kills give no normal drops, XP or gold, preventing duplicate farming rewards.
- Fallen party members cannot use normal respawn inside a run. A surviving
  teammate's room clear revives them. Room transitions restore HP/mana and
  clear timed combat effects and cooldowns. Class passives and equipment remain.
- A ten-minute room/lobby/decision timeout, four-hour run timeout, 1,000-room
  safety ceiling, bounded stats and one-million-Mark bank cap prevent unbounded
  runtime growth. Endless is not an infinite-duration server reservation.

## Blessings and modifiers

Blessings only live in `ExpeditionRun`; they never write account stats or auras.
Bloodlust increases damage, Iron Ward reduces damage, Executioner increases
damage below 30% enemy HP, Vampiric Edge heals from actual damage (not overkill),
Renewal restores HP per second, and Arcane Reserve restores mana per second.
Descriptions show stack caps. Both direct hits and player DoTs use run effects;
effects are inactive outside the assigned room. Enemy skills are disabled for
v1 templates because some existing skills depend on world-specific behavior.

Calm has no extra effect; Blood Moon adds 30% enemy damage; Titan doubles enemy
health; Glass Cannon adds 50% damage to both sides; Swarm doubles the non-boss
enemy count; Mana Drought drains 2% maximum mana each second.

## Persistence and operations

`users_expeditions` holds spendable Marks and lifetime earnings.
`expedition_rewards` is keyed by run/player. Settlement locks the run and writes
the ledger, wallets, weekly records and terminal run status in one transaction.
Failed settlements retain their original outcome for retry. Replayed requests
cannot upgrade a loss payout or award the same run again.

`expedition_weekly` stores each player's best depth, with elapsed milliseconds
as the tie-breaker. The panel displays the first five of the server's top ten.
Weeks use UTC Monday boundaries; runs that cross a boundary remain assigned to
their starting week. `expedition_weeks` freezes the selected map/monster data
across restarts and content-cache reloads. Do not delete the active snapshot.

An abrupt process crash interrupts active runs on restart and discards their
unsettled bank. Active combat is deliberately not resumed from a partial
checkpoint. Already committed payouts remain intact. Use a graceful emulator
shutdown to settle active runs at half value before stopping.

`expedition_shop` is reward catalogue scaffolding with ItemID, Cost, Quantity
and Enabled. There is no purchase endpoint or fulfillment in v1. Leave entries
disabled until a future shop implementation adds atomic debit/delivery and
inventory restrictions. Marks are earned and visible now.

## Verification

Run `php Emulator/PHP/bin/expedition_selftest.php` for deterministic generation,
choices, vote replay, progression, caps, payouts and ISO week boundary checks.

Run `expedition_mysql_selftest.php` against a NEW EMPTY disposable database
named `*_expedition_test`, with `AERA_EXPEDITION_TEST_DSN`,
`AERA_EXPEDITION_TEST_USER`, and `AERA_EXPEDITION_TEST_PASSWORD` environment
variables. It refuses non-test or nonempty databases. It imports the migration
twice and exercises actual transactions, rollback/retry, weekly records,
startup recovery, private-room admission, combat hooks and room clear handling.
The test leaves its fixture data for inspection.

Before live release, publish the FLA and play through solo and two-player runs:
inspect enemy positions in every enabled map; choose each blessing; cash out;
wipe; disconnect; attempt outsider goto and respawn; verify balances after
restart; and confirm normal map combat and Rift events still work.

Implementation validation: 166 run-rule checks and 39 MySQL integration checks
passed. MySQL testing used local 8.0.46 with MySQL 5.7.9-compatible statements;
an actual 5.7.9 runtime was not available. Both the standalone panel and full
AS3 source compile with the installed AIR SDK. Three existing type errors were
fixed to enable that check: map-arrow interaction uses an InteractiveObject
guard, the NPC image actor uses an explicit AvatarMC cast, and bank responses
must be arrays. This source-only compiler output omits FLA artwork and must not
replace the published game SWF.

Rift event, shop and polling checks and aura checks pass. The existing main
selftest reports pre-existing logout/chat failures; the enhancement check has
a stale persistence marker, and the parity audit reports stale AS3 manifests,
enhancement schema metadata and a missing gamefile hash manifest. These were
confirmed against the unchanged branch and are not bypassed by expedition tests.
