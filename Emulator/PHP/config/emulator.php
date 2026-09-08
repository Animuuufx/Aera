<?php
declare(strict_types=1);
return [
    'host'=>'0.0.0.0','port'=>5589,
    'console_host'=>'127.0.0.1','console_port'=>5591,
    'zone'=>'zone_master','server_name'=>'Aera','staff_only'=>false,
    // Java aqworld.conf parity.
    'max_connections_per_ip'=>5,'tick_ms'=>50,
    'antiflood_message_tolerance'=>3,'antiflood_message_warnings'=>3,'antiflood_message_minimum_ms'=>1000,'antiflood_message_max_repeated'=>3,
    'antiflood_request_tolerance'=>10,'antiflood_request_warnings'=>1,'antiflood_request_minimum_ms'=>500,'antiflood_request_counter_max'=>10,
    'antiflood_request_repeat_enabled'=>true,'antiflood_request_max_repeated'=>10,
    'antiflood_request_exceptions'=>['message','retrieveUserData','retrieveUserDatas','retrieveInventory','firstJoin','gar','mv','loadWarVars','serverUseItem'],
    'monster_regen_percent'=>0.05,'monster_regen_interval'=>3.0,
    'basic_hit_mana'=>4,'basic_crit_mana'=>6,
    'monster_accuracy_equal_level'=>0.90,'monster_accuracy_min'=>0.82,'monster_accuracy_max'=>0.96,'pve_dodge_cap'=>0.35,
    'safe_shutdown_seconds'=>300,'admin_command_poll_seconds'=>2.0,'admin_command_stale_seconds'=>120,
    'server_message_interval_seconds'=>1800,'warzone_queue_interval_seconds'=>5.0,
    'trace_requests'=>true,'trace_request_params'=>true,
];
