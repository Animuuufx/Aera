#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$Domain = 'nightvaults.com',
    [string]$PostOffice = 'nightvaults.com'
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an elevated Windows PowerShell window.'
}

try {
    Add-PSSnapin MailEnable.Provision.Command -ErrorAction Stop
} catch {
    throw 'MailEnable PowerShell provisioning snap-in is not installed. Install MailEnable Standard with the management/provisioning components first.'
}

function Test-MailEnablePostOffice {
    try {
        $null = Get-MailEnablePostoffice -Postoffice $PostOffice -ErrorAction Stop
        return $true
    } catch { return $false }
}

if (-not (Test-MailEnablePostOffice)) {
    Write-Host "Creating MailEnable post office/domain: $Domain" -ForegroundColor Cyan
    New-MailEnablePostoffice -Domain $Domain -Postoffice $PostOffice | Out-Null
} else {
    Write-Host "MailEnable post office already exists: $PostOffice" -ForegroundColor DarkGray
}

$accounts = @('animu','admin','support')

foreach ($mailbox in $accounts) {
    Write-Host "`nConfiguring $mailbox@$Domain" -ForegroundColor Cyan
    $password = Read-Host "Enter password for $mailbox@$Domain" -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    try {
        $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        $existing = $null
        try { $existing = Get-MailEnableMailbox -Postoffice $PostOffice -Mailbox $mailbox -ErrorAction Stop } catch {}

        if ($existing) {
            Set-MailEnableMailbox -Postoffice $PostOffice -Mailbox $mailbox -Setting mailboxPassword -Value $plain
            Write-Host "Updated password for $mailbox@$Domain" -ForegroundColor Green
        } else {
            New-MailEnableMailbox -Mailbox $mailbox -Domain $Domain -Password $plain -Right USER | Out-Null
            Write-Host "Created $mailbox@$Domain" -ForegroundColor Green
        }
    } finally {
        if ($bstr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
        $plain = $null
        $password = $null
    }
}

Write-Host "`nMailEnable provisioning complete." -ForegroundColor Green
Write-Host "Mailboxes:" -ForegroundColor Cyan
$accounts | ForEach-Object { Write-Host "  $_@$Domain" }
Write-Host "`nNext: configure DKIM for $Domain and add the generated DKIM TXT record in Cloudflare." -ForegroundColor Yellow
