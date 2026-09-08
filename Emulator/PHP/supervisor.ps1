$ErrorActionPreference = 'SilentlyContinue'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Runtime = Join-Path $Root 'runtime'
$Control = Join-Path $Runtime 'control'
$Requests = Join-Path $Control 'requests'
$Responses = Join-Path $Control 'responses'
$StatusFile = Join-Path $Control 'status.json'
$DesiredFile = Join-Path $Control 'desired.txt'
$EmuPidFile = Join-Path $Runtime 'emulator.pid'
$WatchdogPidFile = Join-Path $Runtime 'watchdog.pid'
$StopFile = Join-Path $Runtime 'intentional.stop'
$Watchdog = Join-Path $Root 'watchdog.bat'

New-Item -ItemType Directory -Force -Path $Control,$Requests,$Responses,(Join-Path $Runtime 'logs') | Out-Null

$Utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
function Write-Utf8NoBom([string]$Path, [string]$Text) { [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom) }
if (!(Test-Path $DesiredFile)) { Set-Content -Path $DesiredFile -Value 'running' -Encoding Ascii }

function Read-NumberFile([string]$Path) {
    if (!(Test-Path $Path)) { return $null }
    $v = (Get-Content $Path -Raw).Trim()
    if ($v -match '^\d+$') { return [int]$v }
    return $null
}
function Process-Alive($Id) {
    if (!$Id) { return $false }
    return [bool](Get-Process -Id $Id -ErrorAction SilentlyContinue)
}
function Emulator-Pid { return Read-NumberFile $EmuPidFile }
function Watchdog-Pid { return Read-NumberFile $WatchdogPidFile }
function Emulator-Running { return Process-Alive (Emulator-Pid) }
function Watchdog-Running { return Process-Alive (Watchdog-Pid) }

function Start-Watchdog {
    Remove-Item $StopFile -Force -ErrorAction SilentlyContinue
    if (Watchdog-Running) { return }
    # Do not allow a stale unmanaged emulator to occupy the game port.
    if (Emulator-Running) {
        Stop-Process -Id (Emulator-Pid) -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 400
    }
    $quoted = '"' + $Watchdog + '"'
    $proc = Start-Process -FilePath 'cmd.exe' -ArgumentList '/d','/c',$quoted -WorkingDirectory $Root -WindowStyle Hidden -PassThru
    if ($proc) { Set-Content -Path $WatchdogPidFile -Value $proc.Id -Encoding Ascii }
}

function Stop-All([string]$Reason) {
    Set-Content -Path $StopFile -Value ($Reason + ' ' + (Get-Date -Format o)) -Encoding Ascii
    $ep = Emulator-Pid
    if (Process-Alive $ep) { Stop-Process -Id $ep -Force -ErrorAction SilentlyContinue }
    Start-Sleep -Milliseconds 250
    $wp = Watchdog-Pid
    if (Process-Alive $wp) { Stop-Process -Id $wp -Force -ErrorAction SilentlyContinue }
    Remove-Item $EmuPidFile,$WatchdogPidFile -Force -ErrorAction SilentlyContinue
}

function Write-Status([string]$LastAction='') {
    $ep = Emulator-Pid
    $wp = Watchdog-Pid
    $desired = if (Test-Path $DesiredFile) { (Get-Content $DesiredFile -Raw).Trim() } else { 'running' }
    $obj = [ordered]@{
        supervisorPid = $PID
        heartbeat = (Get-Date -Format o)
        desired = $desired
        running = [bool](Process-Alive $ep)
        emulatorPid = $ep
        watchdogRunning = [bool](Process-Alive $wp)
        watchdogPid = $wp
        lastAction = $LastAction
    }
    $tmp = $StatusFile + '.tmp'
    Write-Utf8NoBom $tmp ($obj | ConvertTo-Json -Compress)
    Move-Item -Force $tmp $StatusFile
}

$lastAction = 'supervisor started'
while ($true) {
    foreach ($file in (Get-ChildItem -Path $Requests -Filter '*.json' -File | Sort-Object LastWriteTime)) {
        $id = [IO.Path]::GetFileNameWithoutExtension($file.Name)
        $responsePath = Join-Path $Responses ($id + '.json')
        try {
            $req = Get-Content $file.FullName -Raw | ConvertFrom-Json
            $action = [string]$req.action
            $ok = $true
            $message = ''
            if ($action -eq 'start') {
                Set-Content -Path $DesiredFile -Value 'running' -Encoding Ascii
                Remove-Item $StopFile -Force -ErrorAction SilentlyContinue
                Start-Watchdog
                $message = 'Start accepted by emulator supervisor.'
            } elseif ($action -eq 'stop') {
                Set-Content -Path $DesiredFile -Value 'stopped' -Encoding Ascii
                Stop-All 'panel stop'
                $message = 'Emulator stopped by supervisor.'
            } elseif ($action -eq 'restart') {
                Set-Content -Path $DesiredFile -Value 'running' -Encoding Ascii
                Stop-All 'panel restart'
                Start-Sleep -Milliseconds 500
                Remove-Item $StopFile -Force -ErrorAction SilentlyContinue
                Start-Watchdog
                $message = 'Emulator restart accepted by supervisor.'
            } else {
                $ok = $false
                $message = 'Unknown supervisor action: ' + $action
            }
            $lastAction = $action
            Write-Utf8NoBom $responsePath (@{id=$id;ok=$ok;message=$message;completedAt=(Get-Date -Format o)} | ConvertTo-Json -Compress)
        } catch {
            Write-Utf8NoBom $responsePath (@{id=$id;ok=$false;message=('Supervisor error: '+$_.Exception.Message);completedAt=(Get-Date -Format o)} | ConvertTo-Json -Compress)
        }
        Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
    }

    $desired = if (Test-Path $DesiredFile) { (Get-Content $DesiredFile -Raw).Trim() } else { 'running' }
    if ($desired -eq 'running') {
        if (!(Watchdog-Running)) { Start-Watchdog }
    } else {
        if (Emulator-Running -or Watchdog-Running) { Stop-All 'desired stopped' }
    }

    Write-Status $lastAction
    Start-Sleep -Milliseconds 500
}
