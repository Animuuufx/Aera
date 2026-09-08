#requires -RunAsAdministrator
# NightVaults / Stalwart firewall rules

$rules = @(
    @{ Name = 'NightVaults Mail SMTP 25';  Port = 25;  Description = 'Inbound SMTP server-to-server delivery.' },
    @{ Name = 'NightVaults Mail SMTPS 465'; Port = 465; Description = 'Authenticated SMTP submission with implicit TLS.' },
    @{ Name = 'NightVaults Mail SMTP 587'; Port = 587; Description = 'Authenticated SMTP submission with STARTTLS.' },
    @{ Name = 'NightVaults Mail IMAPS 993'; Port = 993; Description = 'Secure IMAP over TLS.' }
)

foreach ($rule in $rules) {
    $existing = Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue
    if (-not $existing) {
        New-NetFirewallRule -DisplayName $rule.Name -Direction Inbound -Action Allow -Protocol TCP -LocalPort $rule.Port -Profile Any -Description $rule.Description | Out-Null
        Write-Host "Added $($rule.Name)" -ForegroundColor Green
    } else {
        Write-Host "Already exists: $($rule.Name)" -ForegroundColor DarkGray
    }
}

Write-Host 'Stalwart mail firewall rules are configured.' -ForegroundColor Green
Write-Host 'Do not expose the Stalwart bootstrap/admin port 8080 to the public Internet.' -ForegroundColor Yellow
