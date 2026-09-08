<?php $title='Rankings'; ob_start(); ?>
<div class="portal-single-page portal-rankings-page">
  <div class="portal-page-title">
    <span>AERA LEADERBOARDS</span>
    <h1>Rankings</h1>
    <p>See the highest-ranked adventurers and guilds across Aera.</p>
  </div>

  <nav class="ranking-page-tabs" aria-label="Ranking type">
    <a class="<?= $activeTab==='players'?'active':'' ?>" href="/rankings?tab=players">Players</a>
    <a class="<?= $activeTab==='guilds'?'active':'' ?>" href="/rankings?tab=guilds">Guilds</a>
  </nav>

  <?php if($activeTab==='players'): ?>
    <section class="portal-widget ranking-table-card">
      <div class="portal-widget-title"><strong>Top Players</strong><span>Top <?= count($players) ?></span></div>
      <div class="ranking-table-wrap">
        <table class="ranking-table">
          <thead><tr><th>#</th><th>Player</th><th>Level</th><th>EXP</th><th>Kills</th><th>Deaths</th><th>Country</th></tr></thead>
          <tbody>
          <?php if(!$players): ?><tr><td colspan="7" class="ranking-empty">No ranked players yet.</td></tr><?php endif; ?>
          <?php foreach($players as $i=>$player): ?>
            <tr>
              <td class="ranking-position"><?= $i+1 ?></td>
              <td><a class="ranking-name" href="/character?name=<?= urlencode((string)$player['Name']) ?>"><?= e($player['Name']) ?></a></td>
              <td><?= number_format((int)$player['Level']) ?></td>
              <td><?= number_format((int)$player['Exp']) ?></td>
              <td><?= number_format((int)$player['KillCount']) ?></td>
              <td><?= number_format((int)$player['DeathCount']) ?></td>
              <td><?= e(strtoupper((string)$player['Country'])) ?></td>
            </tr>
          <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </section>
  <?php else: ?>
    <section class="portal-widget ranking-table-card">
      <div class="portal-widget-title"><strong>Top Guilds</strong><span>Top <?= count($guilds) ?></span></div>
      <div class="ranking-table-wrap">
        <table class="ranking-table">
          <thead><tr><th>#</th><th>Guild</th><th>Level</th><th>EXP</th><th>Members</th><th>Kills</th><th>Wins</th><th>Losses</th></tr></thead>
          <tbody>
          <?php if(!$guilds): ?><tr><td colspan="8" class="ranking-empty">No guilds have been created yet.</td></tr><?php endif; ?>
          <?php foreach($guilds as $i=>$guild): ?>
            <tr>
              <td class="ranking-position"><?= $i+1 ?></td>
              <td><span class="ranking-name"><?= e($guild['Name']) ?></span></td>
              <td><?= number_format((int)$guild['Level']) ?></td>
              <td><?= number_format((int)$guild['Exp']) ?></td>
              <td><?= number_format((int)$guild['Members']) ?> / <?= number_format((int)$guild['MaxMembers']) ?></td>
              <td><?= number_format((int)$guild['TotalKills']) ?></td>
              <td><?= number_format((int)$guild['Wins']) ?></td>
              <td><?= number_format((int)$guild['Loses']) ?></td>
            </tr>
          <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </section>
  <?php endif; ?>
</div>
<?php $content=ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
