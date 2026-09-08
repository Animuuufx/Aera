@echo off
setlocal
cd /d "%~dp0"

echo ===============================================
echo NightVaults Mail Server - MailEnable Standard
echo ===============================================
echo.
echo This setup uses MailEnable Standard for Windows.
echo Download the current stable installer from:
echo https://www.mailenable.com/download.asp
echo.
echo Recommended stable release: MailEnable Standard 10.59.
echo Do not use the 10.60 beta for the production mail server.
echo.
start "" "https://www.mailenable.com/download.asp"
echo After installing MailEnable Standard with Webmail enabled,
echo run:
echo.
echo   powershell -ExecutionPolicy Bypass -File "%~dp0provision-mailboxes.ps1"
echo   powershell -ExecutionPolicy Bypass -File "%~dp0setup-mail-firewall.ps1"
echo.
echo Then follow cloudflare-dns.md for Cloudflare DNS and DKIM.
echo.
pause
