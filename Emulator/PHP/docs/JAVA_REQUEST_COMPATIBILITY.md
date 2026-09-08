# Java → PHP request compatibility

The legacy Java `RequestManage` registers 94 extension request names. The PHP `ExtensionRouter` has explicit routing for all 94, plus 24 request aliases used by newer stock-client paths (118/118 advertised routes total).

v22 also fixes the SmartFoxServer string-response wire format globally. Java's `sendResponse(String[], -1, ...)` inserts `-1` after the command. The old PHP emulator omitted that field, shifting the client's response array and breaking login plus many string-protocol requests.

The PHP emulator now emits:

```text
%xt%command%-1%param1%param2%...%
```

and accepts both legacy string XT requests and JSON XT requests.

Run protocol/request self-test:

```bat
php Emulator\PHP\bin\selftest.php
```

This verifies login-response indexing, STR/JSON parsing, 94/94 registered Java request routes, all 118/118 advertised PHP routes, and the runtime state fields used by houses, PvP, rest, and respawn without requiring MySQL.

## v25 behavioral parity

- `house` now validates the equipped house item, loads the owner's house inventory and `users_houses` placement data, creates/reuses `house-<CharID>`, and returns complete `houseData` in `moveToArea`.
- `housesave` persists `HouseInfo` and updates an already-open house room.
- `restRequest` starts Java-style one-second regeneration (12.5% health and 10% mana per tick) and stops on combat, movement between rooms, death, or full resources.
- `resPlayerTimed` rejects restore attempts until eight seconds after death, then restores resources and emits `resTimed`, `clearAuras`, and updated player state.
- `PVPQr` maintains per-warzone queues, counts slots, creates a private match at capacity, alternates teams, emits `PVPI`, and schedules the Java-style staggered auto-join.
- `PVPIr` supports early acceptance and safe decline/cleanup without leaking empty prepared rooms.
- PvP `gar` combat handles player targets, team protection, kill/death persistence, monster objective scores, `PVPE`/`PVPS`/`PVPC` packets, match completion, and safe return to `faroff`.
- Direct joins to PvP maps remain locked; entry must pass through matchmaking.

Subsystems that are intentionally unavailable in the supplied database/content set return explicit failure packets (for example dungeon matchmaking and external ad/referral services) rather than falling through to an unknown request.
## v26 combat and class-action parity

The combat path is now aligned to the actual Java `Action`, `Damage`, `Users.loadSkills`, `RetrieveInventory`, `AggroMonster`, and `MonsterAttack` behavior used by this project:

- Stock-client `gar` strings such as `11, aa>m:1, wvz` are parsed as action ID + skill reference/target + client marker.
- Class skills come from `skills_assign`; equipped-weapon specials come from `items_skills`.
- Login/inventory bootstrap emits `updateClass`, `clearAuras`, passive aura state, and `sAct` before `loadInventoryBig`.
- Player `sarsa` and monster `sara` results use `hp`, `cInf`, `tInf`, and `type`, which are the fields read by the existing AS3 client.
- Non-PvP player action results are private to the attacker while shared state/animation is broadcast to the room, matching Java.
- Basic monster results are private to the damaged player through `sara`; shared monster/player state and animation still reach the rest of the room.
- `aggroMon` accepts all supplied monster IDs.

The self-test contains an exact `gar` wire fixture and static regressions for these compatibility requirements.

