<?php
declare(strict_types=1);
return [
    'app' => [
        'name' => 'Aera',
        'url' => 'https://nightvaults.com',
        'timezone' => 'America/Chicago',
        'debug' => false,
        'version' => '3.2.0',
    ],
    // These defaults intentionally match the database connection in the
    // original web package supplied for this rebuild. Setup can override them.
    'db' => [
        'host' => 'localhost',
        'port' => 9519,
        'database' => 'aera',
        'username' => 'root',
        'password' => '123',
    ],
    'session' => ['name' => 'aera_session'],
    'security' => ['admin_min_access' => 40, 'game_session_hours' => 12],
    'paths' => [],
];
