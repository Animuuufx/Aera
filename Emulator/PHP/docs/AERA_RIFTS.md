# Aera Rifts

Rifts are shared world events hosted by the PHP emulator. Every public instance
of the selected map shares progress and Commander health. Private rooms, houses,
and PvP rooms are excluded. One event runs at a time per named game server.

## Installation

1. Import `Database/patches/v30_80_aera_rifts.sql` into the game database. It only
   creates six new InnoDB tables; it does not change existing items or accounts.
2. Deploy the changed emulator and website sources and restart the emulator.
3. Republish the client FLA in Adobe Animate with `Sources/Client/src` on its
   source path, and deploy the resulting client SWF through your normal release
   process. The new HUD and `/rift` chat command require this client rebuild.
   Older clients still receive announcements and fight the event monsters.
4. Open `/admin/rifts`. Create an encounter using an existing public map and four
   monster templates: invader, elite, crystal, and Commander. The map must have
   database monster placements. Use a crystal-looking monster asset for crystals.
   Newly created definitions are enabled for random selection immediately.
5. Set goals, duration, and base shard rewards through the linked definition
   editor. Add existing reward item IDs and shard costs to the shop. No invented
   asset paths or assumed production monster/item IDs are shipped.
6. Start a test event from the admin page and verify it with two accounts in
   different public instances before enabling it on a live server.

`rifts_enabled` controls automatic scheduling only. Set it to `false` in
`Emulator/PHP/config/emulator.php` during rollout to allow manual events only.
Automatic events start 30–90 minutes after startup or the previous event ends,
provided at least one authenticated player is online and an enabled definition
exists. `rift_min_interval` and `rift_max_interval` are configurable seconds.

## Player experience

- All online players receive the opening announcement and a HUD with location,
  phase, shared progress, mutation, and contributor count. Late joiners receive
  current state. `/rift` shows status and the player's shard balance.
- `/rift join` or **Travel to Rift** travels to the event map using normal map
  access restrictions. Public rooms fill normally.
- Invasion kills across all public instances advance one meter. At 50%, living
  enemies are replaced by the elite wave. Kills already earned remain credited.
- Objectives require crystal kills, material turn-ins, and defending the ward.
  Rift invaders grant one event-only material to each damaging participant per
  kill, up to ten carried. `/rift deposit` or **Deposit materials** consumes these
  materials in the defense cell. These are not tradable inventory items.
- The first database monster placement defines the defense cell, displayed in
  the HUD. Alive players in that cell defend the ward; invaders there target
  defenders. Its integrity falls by one per second while undefended until the
  defense objective is complete. A destroyed ward fails the event. This initial
  protection objective uses a virtual ward, not a new NPC asset.
- The Commander appears only after every objective completes, or when forced by
  an admin. Starting HP scales from its monster template, tier, mutation, and
  unique contributors at spawn. Health is shared across room copies; additional
  entrants do not reset it. Other placements contain adds.
- Shockwaves warn five seconds before striking the Commander's cell. Leave the
  cell to evade. They deal 25% of maximum player HP, rising to 45% below 30% boss
  health. Corrupted Rifts shorten the attack cycle from 20 to 12 seconds.
- Completed events award every contributing account, including disconnected
  players, through a transaction. Cancelled, failed, expired, and interrupted
  events award no shards. Normal monsters return when the event ends.

## Mutations and tiers

| Modifier | Effect |
| --- | --- |
| Blood | Enemy base damage +30% |
| Arcane | Non-Commander enemies restore 3% maximum HP and full MP every 10 seconds |
| Titan | Enemy and Commander HP ×2.5; shards ×1.5 |
| Swift | Attack interval ×0.65, with the existing one-second minimum |
| Golden | 1% of randomly selected mutations; shards ×5 |
| Corrupted | More frequent telegraphed Commander shockwaves |

Normal, Heroic, and Legendary tiers multiply HP by 1, 1.7, and 3; shard rewards
by 1, 1.5, and 3. Automatic events have a 2% Legendary chance. Heroic is an admin
selection. Legendary events announce **LEGENDARY RIFT DETECTED**.

Swift affects server attack cadence, not visual walking speed. Healing/support
scoring, arbitrary NPC escort objectives, additional boss abilities, Discord
notifications, and achievements/titles remain extension points.

## Contribution and economy

`score = min(10000, floor(effective damage / 100)) + kills × 100 + objectives × 150`.
Damage excludes overkill. Direct attacks and damage over time count. A kill is
credited to each player who damaged that monster, not merely the final attacker.
Objective credit includes crystal kills, deposited materials, and defended
seconds. Objective-only play can earn rewards without dealing damage.

| Medal | Minimum score | Base shard multiplier |
| --- | ---: | ---: |
| Bronze | 1 | 1 |
| Silver | 1,500 | 2 |
| Gold | 5,000 | 3 |
| Legendary | 15,000 | 5 |

Final shards apply medal, tier, mutation, and admin multipliers to `BaseShards`.
Admin multipliers are restricted to 0.1–10. Ordinary monster loot/XP rewards are
suppressed for event monsters to keep the Rift ledger authoritative.

`/rifts` provides the shard shop, recent events, and the signed-in player's reward
history. Buying requires game logout and checks account status, balance, bag
space, and stack limits. Wallet debit, inventory grant, and purchase token are
committed together. A replayed purchase token cannot debit twice. House items
are excluded; equipment, cosmetics, enhancements, and material items use their
existing inventory definitions. Public character pages show Rift statistics.

## Persistence and operations

Event state is checkpointed every five seconds and at phase changes. Rewards use
an event-row lock, a unique `(EventID, UserID)` ledger, and one database transaction
for all credits and completion. Failed payouts roll back and retry on later ticks.
An emulator restart marks its still-active events **interrupted** rather than
replaying stale combat. Active encounters do not resume after restart.

Admin controls: start, stop, choose definition/map, tier and modifier, force the
Commander, and set reward multiplier. Actions reuse authenticated, CSRF-protected
admin routes and the existing local console RPC bridge. The generic data editor
can disable definitions and shop entries. Avoid deleting assets or changing map
placements while an event is active.

## Validation

Run `php Emulator/PHP/bin/rift_selftest.php` with PDO SQLite enabled. The test uses
an isolated in-memory database, never the configured game database. It covers
phase progression, account rewards, overkill, shared health, disconnected DoTs,
low-level objectives, mutations, telegraphs, rollback/retry, and cleanup.
Run `php web/tests/rift_shop_selftest.php` for purchase replay, inventory limits,
account restrictions, balance checks, and atomic inventory/wallet rollback.
SQLite adapts MySQL locking/upsert syntax for the test; a staging MySQL/game-client
playtest is still necessary to validate deployment, assets, and real concurrency.

Also run the existing emulator self-test, aura/enhancement tests, and parity audit.
At implementation time, the branch already fails its general self-test and
enhancement marker check; the parity audit reports stale AS3 request manifests,
missing `EnhItemID` schema declarations, and absent `GAMEFILES_SHA256.txt`.
Those baseline failures are independent of Rifts.
