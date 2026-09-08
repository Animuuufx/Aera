#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$InstallRoot = 'C:\Program Files\Stalwart',
    [string]$DownloadRoot = "$env:ProgramData\NightVaults\Stalwart\downloads"
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an elevated PowerShell window.'
}

$binDir = Join-Path $InstallRoot 'bin'
$etcDir = Join-Path $InstallRoot 'etc'
$dataDir = Join-Path $InstallRoot 'data'
$logDir = Join-Path $InstallRoot 'logs'
$serviceName = 'Stalwart'
$stalwartExe = Join-Path $binDir 'stalwart.exe'
$nssmExe = Join-Path $binDir 'nssm.exe'
$configPath = Join-Path $etcDir 'config.json'

foreach ($dir in @($binDir,$etcDir,$dataDir,$logDir,$DownloadRoot)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

Write-Host 'Downloading the latest Stalwart Windows x86_64 release...' -ForegroundColor Cyan
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/stalwartlabs/stalwart/releases/latest' -Headers @{ 'User-Agent' = 'NightVaults-Mail-Installer' }
$asset = $release.assets | Where-Object { $_.name -eq 'stalwart-x86_64-pc-windows-msvc.zip' } | Select-Object -First 1
if (-not $asset) {
    throw 'Could not find the official Stalwart Windows x86_64 ZIP asset in the latest release.'
}

$zipPath = Join-Path $DownloadRoot $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing

$tempExtract = Join-Path $DownloadRoot ('extract-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force

$foundExe = Get-ChildItem -Path $tempExtract -Filter 'stalwart.exe' -File -Recurse | Select-Object -First 1
if (-not $foundExe) {
    Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
    throw 'The Stalwart archive did not contain stalwart.exe.'
}
Copy-Item -Path $foundExe.FullName -Destination $stalwartExe -Force
Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

if (-not (Test-Path $stalwartExe)) {
    throw "Stalwart executable was not installed at $stalwartExe."
}

# IMPORTANT: The first Stalwart start must not have a config.json present.
# A missing config.json is what triggers bootstrap mode and prints the
# one-time temporary administrator credentials.
if (Test-Path $configPath) {
    Write-Host "Existing config detected: $configPath" -ForegroundColor Yellow
    Write-Host 'The installer will not overwrite or delete an existing Stalwart configuration.' -ForegroundColor Yellow
}

if (-not (Test-Path $nssmExe)) {
    Write-Host 'NSSM is not installed. Opening the official download page...' -ForegroundColor Yellow
    Start-Process 'https://www.nssm.cc/download'
    Write-Host ''
    Write-Host 'Download the Windows x64 NSSM build and place nssm.exe here:' -ForegroundColor Yellow
    Write-Host "  $nssmExe" -ForegroundColor White
    Read-Host 'Press Enter after nssm.exe has been placed there'
}

if (-not (Test-Path $nssmExe)) {
    throw "nssm.exe was not found at $nssmExe. Stalwart's Windows service installation cannot continue."
}

$existing = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if (-not $existing) {
    & $nssmExe install $serviceName $stalwartExe '--config' $configPath | Out-Null
}

& $nssmExe set $serviceName AppDirectory $InstallRoot | Out-Null
& $nssmExe set $serviceName AppStdout (Join-Path $logDir 'stdout.log') | Out-Null
& $nssmExe set $serviceName AppStderr (Join-Path $logDir 'stderr.log') | Out-Null
& $nssmExe set $serviceName DisplayName 'Stalwart Mail Server' | Out-Null
& $nssmExe set $serviceName Description 'NightVaults Stalwart mail server for nightvaults.com' | Out-Null
& $nssmExe set $serviceName Start SERVICE_AUTO_START | Out-Null
& $nssmExe set $serviceName AppExit Default Restart | Out-Null
& $nssmExe set $serviceName AppThrottle 5000 | Out-Null

if ($existing -and $existing.Status -eq 'Running') {
    Write-Host 'Stalwart service already exists and is running.' -ForegroundColor Green
} else {
    Start-Service -Name $serviceName
    Write-Host 'Stalwart service started.' -ForegroundColor Green
}

Get-Service -Name $serviceName | Format-Table Name,Status,StartType -AutoSize

Write-Host ''
if (-not (Test-Path $configPath)) {
    Write-Host 'Bootstrap WebUI: http://127.0.0.1:8080/admin' -ForegroundColor Cyan
    Write-Host 'Bootstrap admin username: admin' -ForegroundColor Cyan
    Write-Host 'One-time bootstrap password is in:' -ForegroundColor Cyan
    Write-Host "  $logDir\stderr.log" -ForegroundColor White
} else {
    Write-Host 'Stalwart is already configured; bootstrap credentials will not be generated.' -ForegroundColor Yellow
    Write-Host 'Use the existing WebUI administrator account.' -ForegroundColor Yellow
}
Write-Host 'Setup hostname: mail.nightvaults.com' -ForegroundColor Cyan
Write-Host 'Default email domain: nightvaults.com' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Complete the first-run wizard, then configure DNS from cloudflare-dns.md.' -ForegroundColor Yellow
