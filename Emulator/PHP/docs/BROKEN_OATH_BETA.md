# The Broken Oath — beta content pack

A compact chapter using only existing `web/public/gamefiles` SWFs. No map SWF,
client FLA, or loader is created or modified by this pack.

| Area / join name | Existing map | Story / enemies | Shop |
| --- | --- | --- | --- |
| Briarwatch `/join briarwatch` | `fawnforest.swf` | Elowen traces frozen roots; blighted wolves and a rootwarden | Forest garb, Briarbound Runeblade, wolf companion |
| Winterpass `/join winterpass` | `frostgale.swf` | Soren follows stolen memories; frost wisps and the bound queen | Arctic garb, Winterpass Reaver, snow wolf |
| Oath Ruins `/join oathruins` | `~Lostruinsbenzaj.swf` | Ilyra rebuilds a broken ward; stone sentinels and a lich | Oath garb, Oathkeeper Blade, arcane wolf |

Scout Elowen also appears in `newbie`, with a **Begin: Briarwatch** button.
Each guide appears at camp and on all three selected combat screens. Buttons
open the area's quests and shop, visit its combat screens, return to camp,
and travel forward/back through the chapter. Travel is open for exploration;
quest acceptance and completion follow the six-step story order.

Each area's first quest asks for four guaranteed monster drops; its second
asks for one boss drop. Accept the quest before fighting and collect the drops.
Temporary objectives clear on logout, while completed story progress persists.
All six quests are one-time. Ordinary monsters respawn and remain a source of
gold for the shops after the story. No premium currency or membership required.

Completing Winterpass awards **Winterpass Ranger**, a ranged physical class.
Completing the finale awards **Oath Warden**, a melee physical class. Each has
an auto attack and four active attacks, including one two-target attack. These
are intentionally simple beta disciplines, with no unimplemented passive or
control effects promised in their descriptions. Both use new equipment visuals
with validated male/female exports. Pets are cosmetic companions.

Initial tuning: monster levels 3–11, normal HP 550–1,450, boss HP 1,900–5,200;
shops use gold and equipment requires level 1. Treat this as an initial balance
pass to adjust after live playtesting, not a guaranteed completion time.

## Install on the VPS

1. Deploy the selected existing assets (or your updated `gamefiles` directory),
   including both genders of ForestKin2, ArcticRanger, and AsgardianKnight.
2. Deploy the changed `Emulator/PHP/src/ExtensionRouter.php`. It enforces the
   chapter order, blocks repeated/bulk story rewards, and reserves client-write
   protection for story slot 90. Other quest slots retain their existing behavior.
3. Back up the database. Import `Database/patches/v30_81_broken_oath_beta.sql`
   into the Aera database using an account allowed to create/drop procedures.
   The current database schema through v30_80 is required. The installer
   resolves `newbie` by name and refuses a first import if its reserved IDs
   (810000–810199) or quest slot 90 are already occupied. Re-importing updates
   this pack's content without resetting player story progress.
4. Restart the emulator to load the content. No client or loader rebuild is
   needed for this pack when using the current database-NPC client.
5. Visit `newbie` and speak to Scout Elowen, or use `/join briarwatch`.

## Verification and live check

Run `php -n tools/content/build_beta.php` to regenerate the SQL and manifest.
Run `php -n tools/content/check_beta.php` to validate schema columns, required
fields, lengths, IDs, references, hotbars, quest sequence and server progression
rules. The generator validates exported SWF linkage names, both armor genders,
and every selected map frame without executing the assets.

The SQL has not been imported into the VPS and the maps have not been played
in the AIR client here. Before announcing beta, walk the full route with a fresh
character: verify NPC placement and buttons, kill/turn in each quest, equip both
classes, inspect their attacks, buy/equip each shop item, and reconnect to check
story persistence. Check both character genders. Existing map SWFs can contain
built-in NPCs, navigation or scripts; confirm those don't obscure the added
actors or take the player somewhere unintended. All chapter travel remains
available through the database NPC buttons if old map arrows point elsewhere.
