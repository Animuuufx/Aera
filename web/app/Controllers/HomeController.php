<?php
declare(strict_types=1);
namespace Aera\Controllers;

use Aera\Foundation\Database;
use Aera\Foundation\Request;
use Aera\Foundation\Response;
use Aera\Foundation\View;
use PDO;
use Throwable;

final class HomeController
{
    private const NEWS_PER_PAGE = 5;

    private function hasTable(string $table): bool
    {
        try {
            $rows = Database::connection()->query('SHOW TABLES')->fetchAll(PDO::FETCH_NUM);
            foreach ($rows as $row) {
                $actual = (string)($row[0] ?? '');
                if ($actual !== '' && strcasecmp($actual, $table) === 0) return true;
            }
        } catch (Throwable) {
        }
        return false;
    }

    public function index(Request $r): void
    {
        $totalNews = (int) Database::scalar('SELECT COUNT(*) FROM news_posts WHERE Published=1', [], 0);
        $newsPages = max(1, (int) ceil($totalNews / self::NEWS_PER_PAGE));
        $newsPage = max(1, min($newsPages, (int) $r->input('news_page', 1)));
        $offset = ($newsPage - 1) * self::NEWS_PER_PAGE;

        $news = Database::all(
            'SELECT n.id,n.Title,n.Slug,n.Excerpt,n.Body,n.Image,n.Pinned,n.PublishedAt,u.Name AuthorName '
            . 'FROM news_posts n LEFT JOIN users u ON u.id=n.AuthorID '
            . 'WHERE n.Published=1 ORDER BY n.PublishedAt DESC,n.id DESC '
            . 'LIMIT ' . self::NEWS_PER_PAGE . ' OFFSET ' . $offset
        );

        $topPlayers = [];
        $topGuilds = [];

        try {
            if ($this->hasTable('users')) {
                $topPlayers = Database::all('SELECT Name,Level,Exp,KillCount,Country FROM users WHERE Access>=1 ORDER BY Level DESC,Exp DESC,KillCount DESC,Name ASC LIMIT 10');
            }
        } catch (Throwable) {
            $topPlayers = [];
        }

        try {
            if ($this->hasTable('guilds')) {
                $topGuilds = Database::all('SELECT Name,Level,Exp,TotalKills,Wins FROM guilds ORDER BY Level DESC,Exp DESC,TotalKills DESC,Name ASC LIMIT 10');
            }
        } catch (Throwable) {
            $topGuilds = [];
        }

        View::render('home', [
            'news' => $news,
            'totalNews' => $totalNews,
            'newsPage' => $newsPage,
            'newsPages' => $newsPages,
            'topPlayers' => $topPlayers,
            'topGuilds' => $topGuilds,
        ]);
    }

    public function rankings(Request $r): void
    {
        $tab = strtolower(trim((string) $r->input('tab', 'players')));
        if (!in_array($tab, ['players', 'guilds'], true)) $tab = 'players';

        $players = [];
        $guilds = [];

        if ($tab === 'players') {
            try {
                if ($this->hasTable('users')) {
                    $players = Database::all(
                        'SELECT Name,Level,Exp,KillCount,DeathCount,Country '
                        . 'FROM users WHERE Access>=1 '
                        . 'ORDER BY Level DESC,Exp DESC,KillCount DESC,Name ASC LIMIT 100'
                    );
                }
            } catch (Throwable) {
                $players = [];
            }
        } else {
            try {
                if ($this->hasTable('guilds')) {
                    if ($this->hasTable('users_guilds')) {
                        $guilds = Database::all(
                            'SELECT g.Name,g.Level,g.Exp,g.TotalKills,g.Wins,g.Loses,g.MaxMembers,'
                            . '(SELECT COUNT(*) FROM users_guilds ug WHERE ug.GuildID=g.id) AS Members '
                            . 'FROM guilds g '
                            . 'ORDER BY g.Level DESC,g.Exp DESC,g.TotalKills DESC,g.Wins DESC,g.Name ASC LIMIT 100'
                        );
                    } else {
                        $guilds = Database::all(
                            'SELECT Name,Level,Exp,TotalKills,Wins,Loses,MaxMembers,0 AS Members '
                            . 'FROM guilds '
                            . 'ORDER BY Level DESC,Exp DESC,TotalKills DESC,Wins DESC,Name ASC LIMIT 100'
                        );
                    }
                }
            } catch (Throwable) {
                $guilds = [];
            }
        }

        View::render('rankings', ['players' => $players, 'guilds' => $guilds, 'activeTab' => $tab]);
    }

    public function play(Request $r): void { View::render('play'); }

    public function news(Request $r,string $slug): void
    {
        $post=Database::one('SELECT n.*,u.Name AuthorName FROM news_posts n LEFT JOIN users u ON u.id=n.AuthorID WHERE n.Slug=? AND n.Published=1 LIMIT 1',[$slug]);
        if(!$post) Response::abort(404,'News post not found.');
        View::render('news',['post'=>$post]);
    }

    public function wiki(Request $r): void { View::render('wiki'); }

    public function character(Request $r): void
    {
        $name=trim((string)$r->input('name',''));
        $character=null; $equipped=[]; $guild=null;
        if($name!=='') {
            $character=Database::one('SELECT id,Name,Level,Gold,Coins,Exp,Gender,Country,DateCreated,LastLogin,LastArea,CurrentServer,KillCount,DeathCount,Upgraded FROM users WHERE LOWER(Name)=LOWER(?) AND Access>=1 LIMIT 1',[$name]);
            if($character) {
                $equipped=Database::all('SELECT i.Name,i.Type,i.Equipment,i.Level FROM users_items ui INNER JOIN items i ON i.id=ui.ItemID WHERE ui.UserID=? AND ui.Equipped=1 ORDER BY i.Equipment,i.Name',[(int)$character['id']]);
                $guild=Database::one('SELECT g.Name,g.Level,ug.Rank FROM users_guilds ug INNER JOIN guilds g ON g.id=ug.GuildID WHERE ug.UserID=? LIMIT 1',[(int)$character['id']]);
            }
        }
        $riftStats=$character&&$this->hasTable('users_rifts')?Database::one('SELECT * FROM users_rifts WHERE UserID=?',[(int)$character['id']]):null;
        View::render('character',['riftStats'=>$riftStats,'query'=>$name,'character'=>$character,'equipped'=>$equipped,'guild'=>$guild]);
    }
}
