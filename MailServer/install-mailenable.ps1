#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$DownloadRoot = "$env:ProgramData\NightVaults\MailEnable\downloads"
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an elevated PowerShell window.'
}

$installerUrl = 'https://www.mailenable.com/standard1059.exe'
$installerPath = Join-Path $DownloadRoot 'standard1059.exe'

New-Item -ItemType Directory -Path $DownloadRoot -Force | Out-Null

Write-Host 'NightVaults Mail Server - MailEnable Standard' -ForegroundColor Cyan
Write-Host 'Stable release: MailEnable Standard 10.59' -ForegroundColor Cyan
Write-Host 'Download: official MailEnable site' -ForegroundColor DarkGray
Write-Host ''

if (-not (Test-Path $installerPath)) {
    Write-Host 'Downloading MailEnable Standard 10.59...' -ForegroundColor Cyan
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
} else {
    Write-Host "Using existing installer: $installerPath" -ForegroundColor DarkGray
}

if (-not (Test-Path $installerPath)) {
    throw "MailEnable installer was not downloaded to $installerPath."
}

Write-Host ''
Write-Host 'Starting the official MailEnable installer...' -ForegroundColor Green
Write-Host 'Use the normal GUI wizard. Do not use a silent install for the first setup.' -ForegroundColor Yellow
Write-Host ''

$process = Start-Process -FilePath $installerPath -Verb RunAs -Wait -PassThru
if ($process.ExitCode -ne 0) {
    throw "MailEnable installer exited with code $($process.ExitCode)."
}

Write-Host ''
Write-Host 'MailEnable installer finished.' -ForegroundColor Green
Write-Host ''
Write-Host 'Recommended first-run settings for NightVaults:' -ForegroundColor Cyan
Write-Host '  Primary domain: nightvaults.com'
Write-Host '  Mail hostname: mail.nightvaults.com'
Write-Host '  SMTP server-to-server: TCP 25'
Write-Host '  SMTP submission: TCP 465 and/or 587'
Write-Host '  IMAP over TLS: TCP 993'
Write-Host '  Webmail: enable the IIS web mail component if desired'
Write-Host ''
Write-Host 'After installation, run setup-mail-firewall.ps1 as Administrator.' -ForegroundColor Yellow
Write-Host 'Then publish the records in cloudflare-dns.md.' -ForegroundColor Yellow
