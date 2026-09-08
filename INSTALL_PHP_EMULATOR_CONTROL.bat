@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "TASK=AeraPHPEmulatorSupervisor"
set "OLDTASK=AeraPHPEmulator"
set "SUPERVISOR_PS=%CD%\Emulator\PHP\supervisor.ps1"
set "RUNTIME=%CD%\Emulator\PHP\runtime"

net session >nul 2>&1
if errorlevel 1 (
  echo Run this file as Administrator.
  pause
  exit /b 1
)
if not exist "%SUPERVISOR_PS%" (
  echo Missing %SUPERVISOR_PS%
  pause
  exit /b 1
)

if not exist "%RUNTIME%\control\requests" mkdir "%RUNTIME%\control\requests"
if not exist "%RUNTIME%\control\responses" mkdir "%RUNTIME%\control\responses"
echo running>"%RUNTIME%\control\desired.txt"

rem Allow the IIS application pool to write control requests and read status/logs.
icacls "%RUNTIME%" /grant "IIS_IUSRS:(OI)(CI)M" /T /C >nul
rem The authenticated admin source editor needs Modify access to emulator code/config.
icacls "%CD%\Emulator\PHP\src" /grant "IIS_IUSRS:(OI)(CI)M" /T /C >nul
icacls "%CD%\Emulator\PHP\config" /grant "IIS_IUSRS:(OI)(CI)M" /T /C >nul
icacls "%CD%\Emulator\PHP\bin" /grant "IIS_IUSRS:(OI)(CI)M" /T /C >nul
for %%F in (supervisor.ps1 supervisor.bat watchdog.bat aera-panel-control.ps1) do if exist "%CD%\Emulator\PHP\%%F" icacls "%CD%\Emulator\PHP\%%F" /grant "IIS_IUSRS:M" /C >nul

rem Remove the old task that IIS used to query directly.
schtasks.exe /End /TN "%OLDTASK%" >nul 2>&1
schtasks.exe /Delete /TN "%OLDTASK%" /F >nul 2>&1
schtasks.exe /End /TN "%TASK%" >nul 2>&1
schtasks.exe /Delete /TN "%TASK%" /F >nul 2>&1

schtasks.exe /Create /TN "%TASK%" /SC ONSTART /RU SYSTEM /RL HIGHEST /TR "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File %SUPERVISOR_PS%" /F
if errorlevel 1 (
  echo Failed to create %TASK%.
  pause
  exit /b 1
)

schtasks.exe /Run /TN "%TASK%"
if errorlevel 1 (
  echo Task was created, but it could not be started now. It will start at the next Windows boot.
  pause
  exit /b 1
)

echo.
echo Installed and started %TASK%.
echo The web panel no longer calls schtasks.exe. It communicates through Emulator\PHP\runtime\control.
echo The live console uses a local-only emulator socket on 127.0.0.1:5591.
echo.
pause
