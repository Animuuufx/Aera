@echo off
setlocal
cd /d "%~dp0"

fltmc >nul 2>&1
if errorlevel 1 (
    echo This installer must be run as Administrator.
    echo Right-click this file and choose "Run as administrator".
    pause
    exit /b 1
)

echo ===============================================
echo NightVaults Mail Server - MailEnable Standard
echo ===============================================
echo.
echo Domain: nightvaults.com
echo Mail hostname: mail.nightvaults.com
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-mailenable.ps1"
if errorlevel 1 (
    echo.
    echo MailEnable setup did not complete.
    pause
    exit /b 1
)

echo.
echo MailEnable installer launched successfully.
echo Complete the MailEnable installation wizard, then configure:
echo   SMTP: 25 / 465 / 587
 echo   IMAP: 993
 echo   Primary mail host: mail.nightvaults.com
 echo   Primary domain: nightvaults.com
 echo.
echo Then run setup-mail-firewall.ps1 as Administrator.
echo Add the DNS records from cloudflare-dns.md in Cloudflare.
echo.
pause
