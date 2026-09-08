param(
    [Parameter(Mandatory=$true)]
    [string]$ApplicationId,
    [int]$Port = 6463
)

$ErrorActionPreference = 'SilentlyContinue'
$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()

$ipc = $null
$ipcReader = $null
$ipcWriter = $null
$activitySet = $false

function New-Nonce {
    return ([guid]::NewGuid().ToString())
}

function Send-IpcFrame {
    param(
        [int]$Opcode,
        [string]$Json
    )
    if ($null -eq $ipc) { return $false }
    try {
        $body = [System.Text.Encoding]::UTF8.GetBytes($Json)
        $buffer = New-Object System.IO.MemoryStream
        $writer = New-Object System.IO.BinaryWriter($buffer)
        $writer.Write([int32]$Opcode)
        $writer.Write([int32]$body.Length)
        $writer.Write($body)
        $writer.Flush()
        $packet = $buffer.ToArray()
        $ipc.Write($packet, 0, $packet.Length)
        $ipc.Flush()
        return $true
    }
    catch {
        $ipc = $null
        return $false
    }
}

function Connect-Discord {
    if ($ipc -and $ipc.IsConnected) { return $true }
    for ($i = 0; $i -le 9; $i++) {
        try {
            $pipe = New-Object System.IO.Pipes.NamedPipeClientStream('.', "discord-ipc-$i", ([System.IO.Pipes.PipeDirection]::InOut), ([System.IO.Pipes.PipeOptions]::None))
            $pipe.Connect(500)
            $pipe.ReadMode = [System.IO.Pipes.PipeTransmissionMode]::Byte
            $ipc = $pipe
            $handshake = @{ v = 1; client_id = $ApplicationId } | ConvertTo-Json -Compress
            if (-not (Send-IpcFrame -Opcode 0 -Json $handshake)) {
                $ipc.Dispose()
                $ipc = $null
                continue
            }
            return $true
        }
        catch {
            if ($ipc) { $ipc.Dispose() }
            $ipc = $null
        }
    }
    return $false
}

function Set-DiscordActivity {
    param(
        [string]$Player,
        [long]$StartUnixSeconds
    )
    if (-not $Player) { return }
    if (-not (Connect-Discord)) { return }

    $activity = @{
        type = 0
        details = 'Playing as ' + $Player
        state = 'Aera'
        timestamps = @{ start = $StartUnixSeconds }
        instance = $true
    }
    $args = @{ pid = $PID; activity = $activity }
    $payload = @{
        cmd = 'SET_ACTIVITY'
        args = $args
        nonce = (New-Nonce)
    } | ConvertTo-Json -Compress -Depth 10

    if (Send-IpcFrame -Opcode 1 -Json $payload) {
        $script:activitySet = $true
    }
}

function Clear-DiscordActivity {
    if ($ipc -and $ipc.IsConnected -and $activitySet) {
        $payload = @{
            cmd = 'SET_ACTIVITY'
            args = @{ pid = $PID; activity = $null }
            nonce = (New-Nonce)
        } | ConvertTo-Json -Compress -Depth 10
        Send-IpcFrame -Opcode 1 -Json $payload | Out-Null
    }
    $script:activitySet = $false
}

function Handle-Client {
    param([System.Net.Sockets.TcpClient]$Client)
    $stream = $Client.GetStream()
    try {
        $first = New-Object System.Collections.Generic.List[byte]
        while ($true) {
            $byte = $stream.ReadByte()
            if ($byte -lt 0) { break }
            if ($byte -eq 0 -or $byte -eq 10) { break }
            $first.Add([byte]$byte)
            if ($first.Count -gt 64) { break }
        }
        $header = [System.Text.Encoding]::UTF8.GetString($first.ToArray())
        if ($header -like '<policy-file-request/*') {
            $policy = '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="' + $Port + '" /></cross-domain-policy>' + [char]0
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($policy)
            $stream.Write($bytes, 0, $bytes.Length)
            $stream.Flush()
            return
        }

        $buffer = $header
        if ($buffer.Length -gt 0) {
            try {
                $msg = $buffer | ConvertFrom-Json
                if ($msg.type -eq 'presence') {
                    Set-DiscordActivity -Player ([string]$msg.player) -StartUnixSeconds ([long]$msg.start)
                }
            } catch {}
        }

        $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::UTF8, $false, 4096, $true)
        while ($Client.Connected) {
            $line = $reader.ReadLine()
            if ($null -eq $line) { break }
            if ($line.Trim().Length -eq 0) { continue }
            try {
                $msg = $line | ConvertFrom-Json
                if ($msg.type -eq 'presence') {
                    Set-DiscordActivity -Player ([string]$msg.player) -StartUnixSeconds ([long]$msg.start)
                }
            } catch {}
        }
    }
    finally {
        try { $Client.Close() } catch {}
    }
}

try {
    while ($true) {
        if ($listener.Pending()) {
            $client = $listener.AcceptTcpClient()
            Handle-Client -Client $client
            Clear-DiscordActivity
        }
        else {
            Start-Sleep -Milliseconds 100
        }
        if ($ipc -and -not $ipc.IsConnected) {
            try { $ipc.Dispose() } catch {}
            $ipc = $null
        }
    }
}
finally {
    Clear-DiscordActivity
    if ($ipc) { try { $ipc.Dispose() } catch {} }
    try { $listener.Stop() } catch {}
}
