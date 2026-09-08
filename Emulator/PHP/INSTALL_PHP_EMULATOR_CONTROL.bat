@echo off
setlocal EnableExtensions
cd /d "%~dp0"

net session >nul 2>&1
if not "%ERRORLEVEL%"=="0" (
  echo.
  echo ERROR: This installer must be run as Administrator.
  echo Right-click this file and choose "Run as administrator".
  pause
  exit /b 1
)

set "ROOT=%~dp0"
set "PS1=%ROOT%supervisor.ps1"
set "TASK=Aera PHP Emulator Supervisor"

if not exist "%PS1%" (
  echo ERROR: supervisor.ps1 was not found at:
  echo %PS1%
  pause
  exit /b 1
)

if not exist "%ROOT%runtime\logs" mkdir "%ROOT%runtime\logs" >nul 2>&1
if not exist "%ROOT%runtime\control\requests" mkdir "%ROOT%runtime\control\requests" >nul 2>&1
if not exist "%ROOT%runtime\control\responses" mkdir "%ROOT%runtime\control\responses" >nul 2>&1

powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$root=[IO.Path]::GetFullPath('%ROOT%'); $task='Aera PHP Emulator Supervisor'; $ps1=Join-Path $root 'supervisor.ps1'; $action=New-ScheduledTaskAction -Execute 'powershell.exe' -Argument ('-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + $ps1 + '"'); $trigger=New-ScheduledTaskTrigger -AtStartup; $principal=New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest; $settings=New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -ExecutionTimeLimit ([TimeSpan]::Zero); Register-ScheduledTask -TaskName $task -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null; Start-ScheduledTask -TaskName $task; Write-Host 'Supervisor task installed and started.'"
if errorlevel 1 (
  echo.
  echo ERROR: Windows could not install/start the supervisor task.
  pause
  exit /b 1
)

echo.
echo Aera PHP Emulator Supervisor is installed and running.
echo It will automatically start with Windows.
echo.
powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%ROOT%aera-panel-control.ps1" status
echo.
echo You can close this window.
timeout /t 3 /nobreak >nul
exit /b 0
