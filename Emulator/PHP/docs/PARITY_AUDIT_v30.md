# Aera v30 Java → PHP parity audit

## Scope

The audit treats the stock AS3 client as the protocol contract and the bundled Java emulator as the behavioral reference. It covers the whole emulator: configuration, protocol framing, database/world caches, user/login lifecycle, rooms and PvP, requests, scheduled tasks, combat/AI, auras/DoTs, items/inventory/equipment, quests/shops, trade/bank/auction, social systems, admin/control paths and deployment supervision.

## Automated result

`php Emulator/PHP/bin/audit.php` reports:

- 173/173 Java source classes accounted for.
- 94/94 Java RequestManage routes mapped.
- 13/13 Java task classes mapped.
- 104/104 statically identifiable stock-AS3 requests mapped.
- 118/118 advertised PHP routes have explicit handler branches.
- 61/61 shipped database tables recognized.
- 340 literal PHP SQL operations scanned with 0 unknown tables.
- 0 invalid literal INSERT/UPDATE columns found.
- Java/PHP configuration parity manifest contains 30 documented settings.
- Database SQL copies are byte-identical.
- 99/99 protected deployed gamefiles match their recorded SHA-256 hashes.

## Java class disposition

160 Java classes map directly to PHP runtime behavior and 10 are integrated into larger PHP runtime components. Three source-only/dormant Java classes are documented rather than fabricated as active runtime features:

- `Cell` — no active Java runtime use and no `cells` table exists in the shipped schema.
- `MonsterTitle` — no active Java runtime reference and no monster-title table exists in the shipped schema.
- `DragonBuff` — legacy class is not registered by Java `RequestManage`; its dormant raw response behavior remains available as a PHP helper.

These are marked `SOURCE_ONLY_PARITY` in `JAVA_CLASS_PARITY_v30.tsv`; they do not represent missing behavior from the active bundled Java runtime.

## Request logging

`RequestTrace` creates semantic console lines while retaining every request parameter. For example:

```text
Player animu -> message: Hi | Channel: zone | Room: newbie | Cell: Enter
```

Combat, movement, item, shop, quest, trade, guild, party and other requests similarly expose their resolved fields. Any parameter that does not have a semantic label is still printed as `Param N`, preventing silent loss when the client sends an unfamiliar value.

## Detailed manifests

- `JAVA_CLASS_PARITY_v30.tsv`
- `JAVA_REQUEST_PARITY_v30.tsv`
- `JAVA_TASK_PARITY_v30.tsv`
- `AS3_REQUEST_COMPATIBILITY_v30.tsv`
- `CONFIG_PARITY_v30.tsv`
- `PARITY_COUNTS_v30.json`

These files are generated from the bundled source/reference tree and are also validated by `audit.php`.
