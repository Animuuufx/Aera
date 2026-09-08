<?php
declare(strict_types=1);
namespace AeraEmu;

use Throwable;

/**
 * Local-only event/RPC bridge used by the authenticated web control panel.
 *
 * It intentionally uses a normal localhost TCP socket instead of WebSockets.
 * IIS/PHP talks to this socket and exposes short/long HTTP requests to the
 * browser, which avoids FastCGI/SSE buffering while still delivering output
 * as soon as the emulator emits it.
 */
final class ConsoleBridge
{
    private $listener = null;
    /** @var array<int,array{socket:resource,buffer:string,subscribed:bool,waitingAfter:?int,waitDeadline:float}> */
    private array $clients = [];
    /** @var list<array<string,mixed>> */
    private array $history = [];
    private int $sequence = 0;
    private int $historyLimit = 1500;

    public function start(string $host, int $port): void
    {
        $errno = 0;
        $errstr = '';
        $listener = @stream_socket_server("tcp://{$host}:{$port}", $errno, $errstr, STREAM_SERVER_BIND | STREAM_SERVER_LISTEN);
        if (!is_resource($listener)) {
            throw new \RuntimeException("Could not bind live console {$host}:{$port}: {$errstr} ({$errno})");
        }
        stream_set_blocking($listener, false);
        $this->listener = $listener;
    }

    public function cursor(): int { return $this->sequence; }

    public function appendReadSockets(array &$read): void
    {
        if (is_resource($this->listener)) $read[] = $this->listener;
        foreach ($this->clients as $client) {
            if (is_resource($client['socket'])) $read[] = $client['socket'];
        }
    }

    public function handles($socket): bool
    {
        if (is_resource($this->listener) && $socket === $this->listener) return true;
        return isset($this->clients[(int)$socket]);
    }

    /**
     * @param callable(string):array<string,mixed>|string $commandHandler
     * @param null|callable(string,array<string,mixed>):array<string,mixed> $rpcHandler
     */
    public function handleReadable($socket, callable $commandHandler, ?callable $rpcHandler = null): void
    {
        if (is_resource($this->listener) && $socket === $this->listener) {
            $this->accept();
            return;
        }

        $id = (int)$socket;
        if (!isset($this->clients[$id])) return;
        $data = @fread($socket, 65536);
        if ($data === '' || $data === false) {
            if (@feof($socket)) $this->drop($id);
            return;
        }

        $this->clients[$id]['buffer'] .= $data;
        while (($pos = strpos($this->clients[$id]['buffer'], "\n")) !== false) {
            $line = trim(substr($this->clients[$id]['buffer'], 0, $pos));
            $this->clients[$id]['buffer'] = substr($this->clients[$id]['buffer'], $pos + 1);
            if ($line === '') continue;
            $payload = json_decode($line, true);
            if (!is_array($payload)) {
                $this->send($id, ['type' => 'error', 'message' => 'Invalid console message.']);
                continue;
            }

            $type = (string)($payload['type'] ?? '');
            if ($type === 'subscribe') {
                $this->clients[$id]['subscribed'] = true;
                $this->send($id, [
                    'type' => 'hello',
                    'pid' => getmypid(),
                    'time' => date(DATE_ATOM),
                    'cursor' => $this->sequence,
                ]);
                continue;
            }

            if ($type === 'waitEvents') {
                $after = max(0, (int)($payload['after'] ?? 0));
                $waitMs = max(100, min(25000, (int)($payload['waitMs'] ?? 20000)));
                if ($this->replyEventsIfAvailable($id, $after)) continue;
                $this->clients[$id]['waitingAfter'] = $after;
                $this->clients[$id]['waitDeadline'] = microtime(true) + ($waitMs / 1000);
                continue;
            }

            if ($type === 'command') {
                $command = trim((string)($payload['command'] ?? ''));
                if ($command === '') {
                    $this->send($id, ['type' => 'result', 'ok' => false, 'message' => 'Command is empty.']);
                    continue;
                }
                try {
                    $result = $commandHandler($command);
                    if (is_string($result)) $result = ['ok' => true, 'message' => $result];
                    $this->send($id, array_merge(['type' => 'result'], $result));
                } catch (Throwable $e) {
                    $this->send($id, ['type' => 'result', 'ok' => false, 'message' => $e->getMessage()]);
                }
                continue;
            }

            if ($type === 'rpc') {
                if ($rpcHandler === null) {
                    $this->send($id, ['type' => 'rpcResult', 'ok' => false, 'message' => 'RPC is unavailable.']);
                    continue;
                }
                $action = trim((string)($payload['action'] ?? ''));
                $params = is_array($payload['params'] ?? null) ? $payload['params'] : [];
                try {
                    $result = $rpcHandler($action, $params);
                    $this->send($id, array_merge(['type' => 'rpcResult'], $result));
                } catch (Throwable $e) {
                    $this->send($id, ['type' => 'rpcResult', 'ok' => false, 'message' => $e->getMessage()]);
                }
                continue;
            }

            if ($type === 'ping') {
                $this->send($id, ['type' => 'pong', 'time' => date(DATE_ATOM), 'cursor' => $this->sequence]);
                continue;
            }

            $this->send($id, ['type' => 'error', 'message' => 'Unknown console message type.']);
        }
    }

    /** Service pending long-poll event waiters even when their sockets are idle. */
    public function tick(): void
    {
        $now = microtime(true);
        foreach (array_keys($this->clients) as $id) {
            if (!isset($this->clients[$id])) continue;
            $after = $this->clients[$id]['waitingAfter'];
            if ($after === null) continue;
            if ($this->replyEventsIfAvailable($id, $after)) continue;
            if ($now >= $this->clients[$id]['waitDeadline']) {
                $this->send($id, [
                    'type' => 'events',
                    'events' => [],
                    'cursor' => $this->sequence,
                    'time' => date(DATE_ATOM),
                ]);
                if (isset($this->clients[$id])) {
                    $this->clients[$id]['waitingAfter'] = null;
                    $this->clients[$id]['waitDeadline'] = 0.0;
                }
            }
        }
    }

    public function broadcastLine(string $line): void
    {
        $line = rtrim($line, "\r\n");
        if ($line === '') return;
        $this->emit(['type' => 'line', 'line' => $line, 'time' => date(DATE_ATOM)]);
    }

    public function broadcastState(string $state, array $extra = []): void
    {
        $this->emit(array_merge(['type' => 'state', 'state' => $state, 'time' => date(DATE_ATOM)], $extra));
    }

    public function close(): void
    {
        foreach (array_keys($this->clients) as $id) $this->drop($id);
        if (is_resource($this->listener)) @fclose($this->listener);
        $this->listener = null;
    }

    private function accept(): void
    {
        $peer = '';
        $socket = @stream_socket_accept($this->listener, 0, $peer);
        if (!is_resource($socket)) return;
        stream_set_blocking($socket, false);
        $id = (int)$socket;
        $this->clients[$id] = [
            'socket' => $socket,
            'buffer' => '',
            'subscribed' => false,
            'waitingAfter' => null,
            'waitDeadline' => 0.0,
        ];
    }

    private function emit(array $payload): void
    {
        $payload['seq'] = ++$this->sequence;
        $this->history[] = $payload;
        if (count($this->history) > $this->historyLimit) {
            $this->history = array_slice($this->history, -$this->historyLimit);
        }

        foreach (array_keys($this->clients) as $id) {
            if (!isset($this->clients[$id])) continue;
            if ($this->clients[$id]['subscribed']) $this->send($id, $payload);
            $after = $this->clients[$id]['waitingAfter'];
            if ($after !== null && $payload['seq'] > $after) $this->replyEventsIfAvailable($id, $after);
        }
    }

    private function replyEventsIfAvailable(int $id, int $after): bool
    {
        if (!isset($this->clients[$id])) return true;
        $events = [];
        foreach ($this->history as $event) {
            if ((int)($event['seq'] ?? 0) > $after) $events[] = $event;
            if (count($events) >= 250) break;
        }
        if (!$events) return false;
        $cursor = (int)($events[count($events)-1]['seq'] ?? $this->sequence);
        $this->send($id, ['type' => 'events', 'events' => $events, 'cursor' => $cursor, 'time' => date(DATE_ATOM)]);
        if (isset($this->clients[$id])) {
            $this->clients[$id]['waitingAfter'] = null;
            $this->clients[$id]['waitDeadline'] = 0.0;
        }
        return true;
    }

    private function send(int $id, array $payload): void
    {
        if (!isset($this->clients[$id])) return;
        $socket = $this->clients[$id]['socket'];
        if (!is_resource($socket)) {
            $this->drop($id);
            return;
        }
        $json = json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        if (!is_string($json) || @fwrite($socket, $json . "\n") === false) $this->drop($id);
    }

    private function drop(int $id): void
    {
        if (!isset($this->clients[$id])) return;
        $socket = $this->clients[$id]['socket'];
        if (is_resource($socket)) @fclose($socket);
        unset($this->clients[$id]);
    }
}
