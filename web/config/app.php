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
    'paypal' => [
        'mode' => 'sandbox',
        'client_id' => 'AU0ZwVV1n7hGYG9mQ7dFVk7m_v7fJ0WNMwtGoo-oKAERD0b4012IQn8MCX5UlqnGEo09dbOmUzZy_dL1',
        'client_secret' => '',
        'merchant_email' => 'animufx1119@gmail.com',
        'brand_name' => 'Aera',
    ],
    'paths' => [],
];
