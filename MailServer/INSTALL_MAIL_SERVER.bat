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
echo NightVaults Mail Server - Stalwart
echo ===============================================
echo.
echo This setup uses Stalwart Mail Server for Windows.
echo Domain: nightvaults.com
echo Mail hostname: mail.nightvaults.com
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-stalwart.ps1"
if errorlevel 1 (
    echo.
    echo Stalwart setup did not complete.
    pause
    exit /b 1
)

echo.
echo Next steps:
echo   1. Open http://127.0.0.1:8080/admin
echo   2. Complete the Stalwart setup wizard.
echo   3. Set the server hostname to mail.nightvaults.com.
echo   4. Set the default mail domain to nightvaults.com.
echo   5. Add the generated DNS records in Cloudflare.
echo.
pause
