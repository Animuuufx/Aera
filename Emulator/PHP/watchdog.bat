@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
if not exist runtime\logs mkdir runtime\logs
if exist runtime\intentional.stop exit /b 0
:loop
if exist runtime\intentional.stop exit /b 0
call :findphp
if not defined PHP_EXE (
  echo [%date% %time%] ERROR PHP CLI php.exe was not found.>>runtime\logs\panel-console.log
  timeout /t 15 /nobreak >nul
  goto loop
)
echo [%date% %time%] Starting Aera PHP Emulator using !PHP_EXE!>>runtime\logs\panel-console.log
"!PHP_EXE!" -d display_errors=1 -d log_errors=0 bin\server.php >> runtime\logs\process-stdout.log 2>&1
set EXITCODE=!ERRORLEVEL!
if exist runtime\intentional.stop (
  echo [%date% %time%] PHP Emulator intentional stop. Exit=!EXITCODE!>>runtime\logs\panel-console.log
  exit /b 0
)
echo [%date% %time%] PHP Emulator unexpected exit !EXITCODE!. Restarting in 5 seconds.>>runtime\logs\panel-console.log
timeout /t 5 /nobreak >nul
goto loop

:findphp
set "PHP_EXE="
for %%P in ("C:\PHP\php.exe" "C:\php\php.exe" "C:\Program Files\PHP\php.exe" "C:\Program Files\PHP\v8.2\php.exe") do if exist %%~P set "PHP_EXE=%%~P"
if defined PHP_EXE exit /b 0
for /f "delims=" %%P in ('where php.exe 2^>nul') do if not defined PHP_EXE set "PHP_EXE=%%P"
if defined PHP_EXE exit /b 0
for /f "tokens=2,*" %%A in ('%windir%\system32\inetsrv\appcmd.exe list config /section:system.webServer/fastCgi /text:* 2^>nul ^| findstr /i "fullPath.*php-cgi.exe"') do (
  set "CGI=%%B"
)
if defined CGI (
  for %%P in ("!CGI!") do if exist "%%~dpPphp.exe" set "PHP_EXE=%%~dpPphp.exe"
)
exit /b 0
