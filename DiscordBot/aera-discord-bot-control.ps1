param(
    [ValidateSet('start','stop','restart','status','deploy')]
    [string]$Action = 'status'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$PidFile = Join-Path $Root 'discord-bot.pid'
$LogFile = Join-Path $Root 'discord-bot.log'
$EnvFile = Join-Path $Root '.env'
$Package = Join-Path $Root 'package.json'

function Get-BotProcess {
    if (!(Test-Path $PidFile)) { return $null }
    try {
        $pid = [int](Get-Content $PidFile -Raw).Trim()
        return Get-Process -Id $pid -ErrorAction Stop
    } catch {
        Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
        return $null
    }
}

function Write-Result($ok, $message, $pid = $null) {
    [pscustomobject]@{ ok = $ok; message = $message; pid = $pid; running = [bool](Get-BotProcess) } | ConvertTo-Json -Compress
}

if (!(Test-Path $Package)) { Write-Result $false 'DiscordBot/package.json was not found.'; exit 1 }

try {
    switch ($Action) {
        'status' {
            $p = Get-BotProcess
            if ($p) { Write-Result $true 'Discord bot process is running.' $p.Id }
            else { Write-Result $true 'Discord bot process is stopped.' }
            exit 0
        }
        'stop' {
            $p = Get-BotProcess
            if (!$p) { Write-Result $true 'Discord bot is already stopped.'; exit 0 }
            Stop-Process -Id $p.Id -Force -ErrorAction Stop
            Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
            Write-Result $true 'Discord bot stopped.'
            exit 0
        }
        'start' {
            if (!(Test-Path $EnvFile)) { Write-Result $false 'DiscordBot/.env is not configured. Save the bot settings from the admin panel first.'; exit 1 }
            $existing = Get-BotProcess
            if ($existing) { Write-Result $true 'Discord bot is already running.' $existing.Id; exit 0 }
            $node = (Get-Command node -ErrorAction SilentlyContinue).Source
            if (!$node) { Write-Result $false 'Node.js was not found in PATH. Install Node.js 20+ on the server.'; exit 1 }
            if (!(Test-Path (Join-Path $Root 'node_modules'))) {
                $npm = (Get-Command npm -ErrorAction SilentlyContinue).Source
                if (!$npm) { Write-Result $false 'npm was not found in PATH.'; exit 1 }
                & $npm --prefix $Root install --omit=dev | Out-Null
                if ($LASTEXITCODE -ne 0) { Write-Result $false 'npm install failed.'; exit 1 }
            }
            $out = [System.IO.Path]::GetFullPath($LogFile)
            $p = Start-Process -FilePath $node -ArgumentList @('src/index.js') -WorkingDirectory $Root -RedirectStandardOutput $out -RedirectStandardError $out -PassThru -WindowStyle Hidden
            Set-Content -Path $PidFile -Value $p.Id -NoNewline
            Start-Sleep -Milliseconds 500
            $check = Get-BotProcess
            if (!$check) { Write-Result $false 'Discord bot exited immediately. Check discord-bot.log.'; exit 1 }
            Write-Result $true 'Discord bot started.' $check.Id
            exit 0
        }
        'restart' {
            & $MyInvocation.MyCommand.Path -Action stop | Out-Null
            & $MyInvocation.MyCommand.Path -Action start
            exit $LASTEXITCODE
        }
        'deploy' {
            if (!(Test-Path $EnvFile)) { Write-Result $false 'DiscordBot/.env is not configured.'; exit 1 }
            $npm = (Get-Command npm -ErrorAction SilentlyContinue).Source
            if (!$npm) { Write-Result $false 'npm was not found in PATH.'; exit 1 }
            & $npm --prefix $Root install --omit=dev | Out-Null
            if ($LASTEXITCODE -ne 0) { Write-Result $false 'npm install failed.'; exit 1 }
            & $npm --prefix $Root run deploy
            if ($LASTEXITCODE -ne 0) { Write-Result $false 'Discord slash-command deployment failed.'; exit 1 }
            Write-Result $true 'Discord slash commands deployed.'
            exit 0
        }
    }
} catch {
    Write-Result $false $_.Exception.Message
    exit 1
}
