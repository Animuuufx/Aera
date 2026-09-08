<?php
use Aera\Foundation\Auth;
$title='Home';
$user=Auth::user();
ob_start();

$newsPage = max(1, (int)($newsPage ?? 1));
$newsPages = max(1, (int)($newsPages ?? 1));
$totalNews = max(0, (int)($totalNews ?? count($news ?? [])));
?>
<div class="portal-content-grid">
  <section class="portal-feed" id="news">
    <?php if(!$news): ?>
      <article class="portal-news-card">
        <a class="portal-news-image" href="/register" style="background-image:url('/assets/images/news/news-update.jpg')"></a>
        <div class="portal-news-body">
          <h2><a href="/register">Welcome to Aera</a></h2>
          <div class="portal-news-meta"><span>By Aera Staff</span><i>•</i><span><?= e(date('M j, Y')) ?></span><i>•</i><b>Announcements</b></div>
          <p>No news posts have been published yet. Create the first update from the admin panel.</p>
        </div>
      </article>
    <?php else: ?>
      <?php foreach($news as $post):
        $img=!empty($post['Image'])?('/'.ltrim((string)$post['Image'],'/')):'/assets/images/news/news-update.jpg';
      ?>
      <article class="portal-news-card">
        <a class="portal-news-image" href="/news/<?= e($post['Slug']) ?>" style="background-image:url('<?= e($img) ?>')" aria-label="<?= e($post['Title']) ?>"></a>
        <div class="portal-news-body">
          <h2><a href="/news/<?= e($post['Slug']) ?>"><?= e($post['Title']) ?></a></h2>
          <div class="portal-news-meta">
            <span>By <?= e($post['AuthorName'] ?: 'Aera Staff') ?></span><i>•</i>
            <span><?= e(date('M j, Y',strtotime((string)$post['PublishedAt']))) ?></span><i>•</i>
            <b><?= !empty($post['Pinned'])?'Announcements':'Events' ?></b>
          </div>
          <p><?= e($post['Excerpt'] ?: rtrim(substr(strip_tags((string)$post['Body']),0,205)).(strlen(strip_tags((string)$post['Body']))>205?'…':'')) ?></p>
        </div>
      </article>
      <?php endforeach; ?>

      <?php if($totalNews > 5):
        $start=max(1,min($newsPage-2,$newsPages-4));
        $end=min($newsPages,$start+4);
      ?>
      <nav class="portal-pagination" aria-label="News pages">
        <?php if($newsPage>1): ?>
          <a href="/?news_page=1#news">First</a>
          <a href="/?news_page=<?= $newsPage-1 ?>#news">Previous</a>
        <?php else: ?>
          <span class="disabled">First</span><span class="disabled">Previous</span>
        <?php endif; ?>
        <?php for($page=$start;$page<=$end;$page++): ?>
          <?php if($page===$newsPage): ?><b aria-current="page"><?= $page ?></b><?php else: ?><a href="/?news_page=<?= $page ?>#news"><?= $page ?></a><?php endif; ?>
        <?php endfor; ?>
        <?php if($newsPage<$newsPages): ?>
          <a href="/?news_page=<?= $newsPage+1 ?>#news">Next</a>
          <a href="/?news_page=<?= $newsPages ?>#news">Last</a>
        <?php else: ?>
          <span class="disabled">Next</span><span class="disabled">Last</span>
        <?php endif; ?>
      </nav>
      <?php endif; ?>
    <?php endif; ?>
  </section>

  <aside class="portal-sidebar">
    <?php if(!$user): ?>
    <section class="portal-widget portal-login-widget">
      <div class="portal-widget-title"><strong>Login</strong></div>
      <form method="post" action="/login" class="portal-login-form">
        <?= csrf_field() ?>
        <label><span>Username</span><input name="username" required autocomplete="username"><i>♟</i></label>
        <label><span>Password</span><input type="password" name="password" required autocomplete="current-password"><i>◆</i></label>
        <div class="portal-login-actions"><a href="/register">Create account</a><button type="submit">SIGN IN <span>♟+</span></button></div>
      </form>
    </section>
    <?php else: ?>
    <section class="portal-widget portal-account-widget">
      <div class="portal-widget-title"><strong>Adventurer</strong><span>ONLINE</span></div>
      <div class="portal-account-summary"><span class="portal-avatar-letter"><?= e(strtoupper(substr((string)$user['Name'],0,1))) ?></span><div><h3><?= e($user['Name']) ?></h3><p>Level <?= (int)$user['Level'] ?> · <?= number_format((int)$user['Gold']) ?> Gold</p></div></div>
      <div class="portal-account-buttons"><a href="/play">PLAY NOW</a><a href="/account">ACCOUNT</a></div>
    </section>
    <?php endif; ?>

    <section class="portal-widget portal-lookup-widget">
      <div class="portal-widget-title"><strong>Character Lookup</strong></div>
      <form method="get" action="/character" class="portal-search-form"><input name="name" placeholder="Search Character..." minlength="2" maxlength="32" required><button type="submit" aria-label="Search">⌕</button></form>
    </section>

    <section class="portal-widget portal-rank-widget" id="rankings">
      <div class="portal-rank-tabs"><button class="active" type="button" data-rank-tab="players">Top Players</button><button type="button" data-rank-tab="guilds">Top Guilds</button></div>
      <div class="portal-rank-list active" data-rank-panel="players">
        <?php if(!$topPlayers): ?><p class="portal-widget-empty">No ranked players yet.</p><?php else: ?>
          <?php foreach($topPlayers as $n=>$player): ?><a href="/character?name=<?= urlencode((string)$player['Name']) ?>"><strong><?= $n+1 ?></strong><span><?= e($player['Name']) ?></span><small>Lv <?= (int)$player['Level'] ?></small></a><?php endforeach; ?>
        <?php endif; ?>
      </div>
      <div class="portal-rank-list" data-rank-panel="guilds">
        <?php if(!$topGuilds): ?><p class="portal-widget-empty">No guilds have been created yet.</p><?php else: ?>
          <?php foreach($topGuilds as $n=>$guild): ?><div><strong><?= $n+1 ?></strong><span><?= e($guild['Name']) ?></span><small>Lv <?= (int)$guild['Level'] ?></small></div><?php endforeach; ?>
        <?php endif; ?>
      </div>
      <a class="portal-rank-more" href="/rankings">VIEW FULL RANKINGS</a>
    </section>

    <section class="portal-widget portal-community-widget">
      <div class="portal-widget-title"><strong>Aera Community</strong></div>
      <div class="portal-community-inner"><span class="portal-discord-mark"><img src="/assets/images/aera-crest-gold-v13.png" alt="Aera"></span><div><strong>Join our community</strong><p>Find parties, follow updates, report bugs, and meet other adventurers.</p></div></div>
      <a class="portal-community-button" href="/register">JOIN THE COMMUNITY</a>
    </section>
  </aside>
</div>
<?php $content=ob_get_clean(); require __DIR__.'/layouts/site.php'; ?>
