#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$Domain = 'nightvaults.com',
    [string]$Url = 'http://127.0.0.1:8080'
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an elevated PowerShell window.'
}

$cli = Get-Command 'stalwart-cli.exe' -ErrorAction SilentlyContinue
if (-not $cli) { $cli = Get-Command 'stalwart-cli' -ErrorAction SilentlyContinue }
if (-not $cli) {
    throw 'stalwart-cli was not found in PATH. Install the official Stalwart CLI Windows MSI, then run this script again.'
}

$user = Read-Host 'Stalwart administrator username'
$securePassword = Read-Host 'Stalwart administrator password' -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
    $password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
} finally {
    if ($ptr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
    $securePassword = $null
}

function Invoke-Stalwart {
    param([string[]]$Arguments)
    & $cli.Source @('--url', $Url, '--user', $user, '--password', $password) @Arguments
    if ($LASTEXITCODE -ne 0) { throw "stalwart-cli failed with exit code $LASTEXITCODE." }
}

try {
    Write-Host "Looking up domain $Domain..." -ForegroundColor Cyan
    $domainOutput = Invoke-Stalwart @('query','Domain','--where',"name=$Domain",'--fields','id,name') | Out-String
    $domainId = ($domainOutput -split "`r?`n" | Where-Object { $_ -match '\bDomain\b' -and $_ -match '[A-Za-z0-9]{6,}' } | Select-Object -First 1)
    if ($domainOutput -notmatch $Domain) {
        throw "Domain $Domain was not found. Complete the Stalwart setup wizard and create the domain first."
    }

    # The CLI text renderer can vary between versions. Prefer asking for the ID only.
    $idOutput = Invoke-Stalwart @('query','Domain','--where',"name=$Domain",'--fields','id') | Out-String
    $domainId = ($idOutput -split "`r?`n" | Where-Object { $_ -match '^[A-Za-z0-9_-]{6,}$' } | Select-Object -First 1)
    if (-not $domainId) {
        throw "Could not determine the Stalwart domain ID for $Domain. Create the mailboxes manually in WebUI > Management > Directory > Accounts."
    }

    foreach ($mailbox in @('animu','admin','support')) {
        Write-Host "`nConfiguring $mailbox@$Domain" -ForegroundColor Cyan
        $mailSecure = Read-Host "Password for $mailbox@$Domain" -AsSecureString
        $mailPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($mailSecure)
        try {
            $mailPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($mailPtr)
        } finally {
            if ($mailPtr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($mailPtr) }
            $mailSecure = $null
        }

        $credentialJson = @{ '0' = @{ '@type' = 'Password'; secret = $mailPassword } } | ConvertTo-Json -Compress
        $existing = (Invoke-Stalwart @('query','Account','--where',"name=$mailbox",'--fields','id,name,domainId') | Out-String)
        if ($existing -match $mailbox) {
            Write-Host "Account already exists. Update it through the Stalwart WebUI if the password needs changing." -ForegroundColor Yellow
        } else {
            Invoke-Stalwart @('create','Account/User','--field',"name=$mailbox",'--field',"domainId=$domainId",'--field',"credentials=$credentialJson") | Out-Null
            Write-Host "Created $mailbox@$Domain" -ForegroundColor Green
        }
        $mailPassword = $null
    }

    # Force newly created account data to become effective immediately.
    Invoke-Stalwart @('create','Action','--json','{"@type":"InvalidateCaches"}') | Out-Null
    Write-Host "`nNightVaults mailboxes are configured:" -ForegroundColor Green
    Write-Host "  animu@$Domain"
    Write-Host "  admin@$Domain"
    Write-Host "  support@$Domain"
} finally {
    $password = $null
}
