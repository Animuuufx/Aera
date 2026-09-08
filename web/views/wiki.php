<?php
$title = 'Wiki';
ob_start();
?>
<style>
.wiki-page{max-width:1180px;margin:0 auto;padding:28px 0 56px}
.wiki-hero{position:relative;overflow:hidden;padding:34px 36px;border:1px solid rgba(255,255,255,.08);border-radius:18px;background:linear-gradient(135deg,rgba(205,164,76,.16),rgba(255,255,255,.025) 48%,rgba(0,0,0,.2));box-shadow:0 18px 50px rgba(0,0,0,.18)}
.wiki-hero:after{content:"";position:absolute;inset:auto -90px -120px auto;width:320px;height:320px;border-radius:50%;background:radial-gradient(circle,rgba(205,164,76,.18),transparent 68%);pointer-events:none}
.wiki-kicker{font-size:12px;letter-spacing:.18em;text-transform:uppercase;color:#cda44c;font-weight:800}
.wiki-hero h1{margin:6px 0 8px;font-size:42px;line-height:1.05}
.wiki-hero p{max-width:760px;margin:0;color:rgba(255,255,255,.72);font-size:16px;line-height:1.65}
.wiki-layout{display:grid;grid-template-columns:240px minmax(0,1fr);gap:22px;margin-top:22px;align-items:start}
.wiki-sidebar{position:sticky;top:20px;border:1px solid rgba(255,255,255,.08);border-radius:16px;padding:14px;background:rgba(12,15,20,.72);backdrop-filter:blur(8px)}
.wiki-sidebar-title{padding:8px 10px 10px;color:rgba(255,255,255,.45);font-size:11px;letter-spacing:.14em;text-transform:uppercase;font-weight:800}
.wiki-sidebar a{display:block;padding:10px 12px;border-radius:10px;color:rgba(255,255,255,.76);text-decoration:none;font-size:14px;transition:.18s}
.wiki-sidebar a:hover,.wiki-sidebar a.active{background:rgba(205,164,76,.12);color:#fff}
.wiki-search{margin:0 0 10px;padding:10px 12px;width:100%;box-sizing:border-box;border-radius:10px;border:1px solid rgba(255,255,255,.09);background:rgba(255,255,255,.035);color:#fff;outline:none}
.wiki-search::placeholder{color:rgba(255,255,255,.35)}
.wiki-main{min-width:0}
.wiki-section{scroll-margin-top:28px;padding:26px 28px;margin-bottom:16px;border:1px solid rgba(255,255,255,.08);border-radius:16px;background:rgba(12,15,20,.58)}
.wiki-section h2{margin:0 0 8px;font-size:24px}
.wiki-section .wiki-sub{margin:0 0 18px;color:rgba(255,255,255,.52);font-size:14px;line-height:1.6}
.wiki-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
.wiki-card{padding:16px;border:1px solid rgba(255,255,255,.07);border-radius:12px;background:rgba(255,255,255,.025)}
.wiki-card h3{margin:0 0 7px;font-size:16px}
.wiki-card p,.wiki-card li{margin:0;color:rgba(255,255,255,.68);font-size:14px;line-height:1.65}
.wiki-card ul{margin:0;padding-left:18px}
.wiki-note{margin-top:16px;padding:14px 16px;border-left:3px solid #cda44c;border-radius:8px;background:rgba(205,164,76,.07);color:rgba(255,255,255,.72);font-size:13px;line-height:1.65}
.wiki-table{width:100%;border-collapse:collapse;margin-top:8px}
.wiki-table th,.wiki-table td{text-align:left;padding:11px 12px;border-bottom:1px solid rgba(255,255,255,.07);font-size:13px}
.wiki-table th{color:rgba(255,255,255,.48);font-weight:700;text-transform:uppercase;letter-spacing:.08em;font-size:10px}
.wiki-table td{color:rgba(255,255,255,.7)}
.wiki-code{display:block;margin-top:8px;padding:10px 12px;border-radius:9px;background:rgba(0,0,0,.22);font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:12px;color:rgba(255,255,255,.78);overflow:auto}
@media (max-width:900px){.wiki-layout{grid-template-columns:1fr}.wiki-sidebar{position:static}.wiki-grid{grid-template-columns:1fr}.wiki-hero{padding:26px 22px}.wiki-hero h1{font-size:34px}.wiki-section{padding:22px}}
</style>

<div class="wiki-page">
  <section class="wiki-hero">
    <div class="wiki-kicker">Aera Knowledge Base</div>
    <h1>Wiki</h1>
    <p>Your central guide to Aera. Find information about the game, character progression, combat, equipment, account features, and the systems currently being developed for Beta.</p>
  </section>

  <div class="wiki-layout">
    <aside class="wiki-sidebar" aria-label="Wiki navigation">
      <input id="wiki-search" class="wiki-search" type="search" placeholder="Search the wiki…" aria-label="Search the wiki">
      <div class="wiki-sidebar-title">Sections</div>
      <a href="#getting-started" class="active">Getting Started</a>
      <a href="#accounts">Accounts</a>
      <a href="#characters">Characters</a>
      <a href="#combat">Combat</a>
      <a href="#stats">Stats & Progression</a>
      <a href="#equipment">Equipment & Enhancements</a>
      <a href="#world">World, Maps & NPCs</a>
      <a href="#houses">Houses</a>
      <a href="#guilds">Guilds & Rankings</a>
      <a href="#support">Support & Reporting</a>
    </aside>

    <main class="wiki-main" id="wiki-content">
      <section class="wiki-section" id="getting-started" data-wiki-section data-search="getting started beta play aera login register">
        <h2>Getting Started</h2>
        <p class="wiki-sub">The fastest way to get into Aera and start testing the current game build.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>1. Create an account</h3><p>Use the <a href="/register">Register</a> page to create your Aera account, then sign in from the website.</p></article>
          <article class="wiki-card"><h3>2. Launch the game</h3><p>Use <a href="/play">Play Aera</a> to access the current game client and connect to the server.</p></article>
          <article class="wiki-card"><h3>3. Explore</h3><p>Move through the available maps, interact with NPCs, test combat, and try the systems included in the current build.</p></article>
          <article class="wiki-card"><h3>4. Report issues</h3><p>Beta development depends on player feedback. Report reproducible bugs and include the map, action, and result when possible.</p></article>
        </div>
        <div class="wiki-note"><strong>Beta status:</strong> Aera is still in active development. Features and content can change between builds, and some systems may still have known bugs.</div>
      </section>

      <section class="wiki-section" id="accounts" data-wiki-section data-search="account login register password email account management">
        <h2>Accounts</h2>
        <p class="wiki-sub">Website account tools currently exposed by the Aera portal.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Register & Login</h3><p>Create an account, sign in, and keep your credentials private. The website also provides logout and account-management actions.</p></article>
          <article class="wiki-card"><h3>Account Management</h3><p>Signed-in players can manage account information from the <a href="/account">Account</a> page, including available email and password settings.</p></article>
        </div>
      </section>

      <section class="wiki-section" id="characters" data-wiki-section data-search="characters character lookup level experience gold coins equipment gender country last area">
        <h2>Characters</h2>
        <p class="wiki-sub">Character progression and public profile information.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Character Progression</h3><p>Characters have a level and experience progression, with additional gameplay values tracked by the server such as kills and deaths.</p></article>
          <article class="wiki-card"><h3>Character Lookup</h3><p>The website's <a href="/character">Character Lookup</a> can display public character information and currently equipped items for eligible characters.</p></article>
        </div>
      </section>

      <section class="wiki-section" id="combat" data-wiki-section data-search="combat skills attacks cooldown monsters pvp mana stamina aura buffs">
        <h2>Combat</h2>
        <p class="wiki-sub">Aera's combat runtime is built around the game-server request protocol and supports both PvE and PvP-related state.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Skills & Actions</h3><p>Combat supports skill/action handling, cooldown timing, action-bar state, damage results, and monster targeting.</p></article>
          <article class="wiki-card"><h3>Buffs & Auras</h3><p>The current server and database include support for buffs, skills, and aura data used by gameplay systems.</p></article>
          <article class="wiki-card"><h3>Monsters</h3><p>Monster state includes combat engagement and timed respawn behavior. Monster placements are configurable from game data.</p></article>
          <article class="wiki-card"><h3>PvP</h3><p>The emulator includes persistent PvP queue and match state, alongside the regular world gameplay state.</p></article>
        </div>
      </section>

      <section class="wiki-section" id="stats" data-wiki-section data-search="stats strength intellect dexterity endurance wisdom luck stat points level exp progression">
        <h2>Stats & Progression</h2>
        <p class="wiki-sub">Character progression includes level and stat-related systems that continue to be tuned for Beta.</p>
        <table class="wiki-table">
          <thead><tr><th>Attribute</th><th>Purpose</th></tr></thead>
          <tbody>
            <tr><td>Strength</td><td>Offensive character stat.</td></tr>
            <tr><td>Intellect</td><td>Magic/resource-oriented character stat.</td></tr>
            <tr><td>Dexterity</td><td>Agility-oriented character stat.</td></tr>
            <tr><td>Endurance</td><td>Defensive/survivability-oriented character stat.</td></tr>
            <tr><td>Wisdom</td><td>Character stat used by gameplay calculations.</td></tr>
            <tr><td>Luck</td><td>Luck-oriented character stat used by gameplay calculations.</td></tr>
          </tbody>
        </table>
        <div class="wiki-note">Stat tuning is still part of Beta balancing. Values and formulas may change as combat testing continues.</div>
      </section>

      <section class="wiki-section" id="equipment" data-wiki-section data-search="equipment enhancements weapons classes capes helms weapon helm enhancement level">
        <h2>Equipment & Enhancements</h2>
        <p class="wiki-sub">Equipment data is stored in the Aera database and is applied to characters through the game server.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Equipment Types</h3><p>Aera supports item/equipment data for the gear used by characters, including weapon, class, cape, and helm equipment.</p></article>
          <article class="wiki-card"><h3>Enhancements</h3><p>Enhancement data is represented in the database and resolved by the server so enhanced equipment can contribute to runtime stats and combat calculations.</p></article>
          <article class="wiki-card"><h3>Equipment State</h3><p>The game tracks equipped state separately from inventory ownership, allowing the character's active gear to be serialized to the client.</p></article>
          <article class="wiki-card"><h3>Beta Tuning</h3><p>Enhancement levels and stat coefficients are still subject to balancing and compatibility fixes as the newer client/server contract is finalized.</p></article>
        </div>
      </section>

      <section class="wiki-section" id="world" data-wiki-section data-search="world maps npc monsters spawn placements arrows npc images map data">
        <h2>World, Maps & NPCs</h2>
        <p class="wiki-sub">The world is driven by database-backed map, NPC, monster, and placement data.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Maps</h3><p>Maps and their runtime data are loaded from server-side game data. Placement information controls where world entities appear.</p></article>
          <article class="wiki-card"><h3>NPCs</h3><p>NPCs are database-driven, with support for NPC images and interactable world content.</p></article>
          <article class="wiki-card"><h3>Monster Placements</h3><p>Monster spawn/placement data can be configured for individual maps, including directional and placement presets where supported.</p></article>
          <article class="wiki-card"><h3>Exploration</h3><p>World navigation and interaction are continuously expanding as new Beta areas and content are added.</p></article>
        </div>
      </section>

      <section class="wiki-section" id="houses" data-wiki-section data-search="houses house rooms housing private house save room">
        <h2>Houses</h2>
        <p class="wiki-sub">Private housing is supported by the game server and is part of the persistent gameplay state.</p>
        <div class="wiki-card"><h3>Private Houses</h3><p>Players can use house-related data and room state through the game client. The server supports saving house rooms and maintaining private-house state while the emulator is running.</p></div>
      </section>

      <section class="wiki-section" id="guilds" data-wiki-section data-search="guild rankings leaderboard players guilds wins losses members experience">
        <h2>Guilds & Rankings</h2>
        <p class="wiki-sub">The website exposes public leaderboards for players and guilds.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Player Rankings</h3><p>Player rankings can be viewed at <a href="/rankings?tab=players">/rankings</a> and are ordered using level, experience, kills, and name.</p></article>
          <article class="wiki-card"><h3>Guild Rankings</h3><p>Guild rankings include level, experience, members, kills, wins, and losses where the corresponding guild data exists.</p></article>
        </div>
      </section>

      <section class="wiki-section" id="support" data-wiki-section data-search="support bugs bug report suggestions discord help announcements">
        <h2>Support & Reporting</h2>
        <p class="wiki-sub">Help make the Beta better by reporting problems clearly and sharing useful feedback.</p>
        <div class="wiki-grid">
          <article class="wiki-card"><h3>Bug Reports</h3><p>Include the steps that caused the problem, where it happened, and what you expected to happen. Screenshots or short clips can make reproduction easier.</p></article>
          <article class="wiki-card"><h3>Suggestions</h3><p>Feature ideas and balance feedback should explain what you want changed and why it would improve the game.</p></article>
        </div>
        <div class="wiki-note"><strong>Remember:</strong> Do not share passwords, private account information, or exploit instructions publicly. Report security-sensitive issues directly to Aera staff.</div>
      </section>
    </main>
  </div>
</div>

<script>
(() => {
  const input = document.getElementById('wiki-search');
  const sections = [...document.querySelectorAll('[data-wiki-section]')];
  const links = [...document.querySelectorAll('.wiki-sidebar a[href^="#"]')];
  if (!input) return;

  const normalize = value => value.toLowerCase().trim();
  const filter = () => {
    const q = normalize(input.value);
    sections.forEach(section => {
      const haystack = normalize(section.textContent + ' ' + (section.dataset.search || ''));
      section.style.display = !q || haystack.includes(q) ? '' : 'none';
    });
  };

  input.addEventListener('input', filter);
  links.forEach(link => link.addEventListener('click', () => {
    links.forEach(item => item.classList.remove('active'));
    link.classList.add('active');
  }));
})();
</script>
<?php $content = ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
