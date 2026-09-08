<?php
declare(strict_types=1);
namespace AeraEmu;

final class RoomState
{
    /** @var array<int,ClientSession> */ public array $clients=[];
    /** @var array<int,array<string,mixed>> */ public array $monsters=[];
    /** Runtime-only data for private houses, PvP teams, and room scores. */
    public array $meta=[];
    public function __construct(public int $id, public string $name, public array $map, array $monsters=[], array $meta=[])
    { $this->monsters=$monsters;$this->meta=$meta; }
}
