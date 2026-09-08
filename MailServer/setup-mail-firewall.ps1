#requires -RunAsAdministrator
# NightVaults / MailEnable firewall rules

$rules = @(
    @{ Name = 'NightVaults Mail SMTP 25';  Port = 25;  Description = 'Inbound/outbound SMTP server-to-server mail delivery.' },
    @{ Name = 'NightVaults Mail SMTP 587'; Port = 587; Description = 'Authenticated SMTP submission with STARTTLS.' },
    @{ Name = 'NightVaults Mail IMAPS 993'; Port = 993; Description = 'Secure IMAP over TLS.' },
    @{ Name = 'NightVaults Mail POP3S 995'; Port = 995; Description = 'Secure POP3 over TLS (optional).' }
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

Write-Host "Mail firewall rules are configured." -ForegroundColor Green
