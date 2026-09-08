param([ValidateSet('start','stop','restart','status','deploy')][string]$Action='status')
$ErrorActionPreference='Stop'
$Root=Split-Path -Parent $MyInvocation.MyCommand.Path
$PidFile=Join-Path $Root 'discord-bot.pid';$LogFile=Join-Path $Root 'discord-bot.log';$ErrorLog=Join-Path $Root 'discord-bot-error.log';$EnvFile=Join-Path $Root '.env';$Package=Join-Path $Root 'package.json'
function Get-BotProcesses {
  $items=@()
  try {
    $items=Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction Stop | Where-Object {
      $cmd=[string]$_.CommandLine
      $cmd -match [regex]::Escape((Join-Path $Root 'src\index.js'))
    }
  } catch {}
  return @($items)
}
function Get-BotProcess {
  $items=Get-BotProcesses
  if($items.Count -gt 0){return $items[0]}
  if(Test-Path $PidFile){Remove-Item $PidFile -Force -ErrorAction SilentlyContinue}
  return $null
}
function Write-Result($ok,$message,$botPid=$null){[pscustomobject]@{ok=$ok;message=$message;pid=$botPid;running=([bool](Get-BotProcess))}|ConvertTo-Json -Compress}
function Invoke-NpmInstall($npm) {
  $installLog=Join-Path $Root 'npm-install.log'
  Remove-Item $installLog -Force -ErrorAction SilentlyContinue
  & $npm --prefix $Root install --omit=dev *> $installLog
  if($LASTEXITCODE -ne 0){
    $detail='npm install failed. Check DiscordBot/npm-install.log.'
    if(Test-Path $installLog){$lines=Get-Content $installLog -Tail 20 -ErrorAction SilentlyContinue;if($lines){$detail+=' '+(($lines -join ' ')-replace '\s+',' ')}}
    throw $detail
  }
}
if(!(Test-Path $Package)){Write-Result $false 'DiscordBot/package.json was not found.';exit 1}
try{switch($Action){
'status'{$p=Get-BotProcess;if($p){Write-Result $true 'Discord bot process is running.' $p.ProcessId}else{Write-Result $true 'Discord bot process is stopped.'};exit 0}
'stop'{$items=Get-BotProcesses;if($items.Count -eq 0){Remove-Item $PidFile -Force -ErrorAction SilentlyContinue;Write-Result $true 'Discord bot is already stopped.';exit 0};foreach($item in $items){Stop-Process -Id ([int]$item.ProcessId) -Force -ErrorAction SilentlyContinue};Start-Sleep -Milliseconds 250;Remove-Item $PidFile -Force -ErrorAction SilentlyContinue;if((Get-BotProcesses).Count -gt 0){Write-Result $false 'Discord bot process could not be stopped.';exit 1};Write-Result $true 'Discord bot stopped.';exit 0}
'start'{if(!(Test-Path $EnvFile)){Write-Result $false 'DiscordBot/.env is not configured. Save the bot settings from the admin panel first.';exit 1};$existing=Get-BotProcess;if($existing){Write-Result $true 'Discord bot is already running.' $existing.ProcessId;exit 0};$node=(Get-Command node -ErrorAction SilentlyContinue).Source;if(!$node){Write-Result $false 'Node.js was not found in PATH. Install Node.js 20+ on the server.';exit 1};if(!(Test-Path (Join-Path $Root 'node_modules'))){$npm=(Get-Command npm -ErrorAction SilentlyContinue).Source;if(!$npm){Write-Result $false 'npm was not found in PATH.';exit 1};Invoke-NpmInstall $npm};Remove-Item $LogFile,$ErrorLog -Force -ErrorAction SilentlyContinue;$p=Start-Process -FilePath $node -ArgumentList @('src/index.js') -WorkingDirectory $Root -RedirectStandardOutput $LogFile -RedirectStandardError $ErrorLog -PassThru -WindowStyle Hidden;Set-Content -Path $PidFile -Value $p.Id -NoNewline;Start-Sleep -Milliseconds 700;$check=Get-BotProcess;if(!$check){Write-Result $false 'Discord bot exited immediately. Check discord-bot.log and discord-bot-error.log.';exit 1};Write-Result $true 'Discord bot started.' $check.ProcessId;exit 0}
'restart'{& $MyInvocation.MyCommand.Path -Action stop | Out-Null;Start-Sleep -Milliseconds 250;& $MyInvocation.MyCommand.Path -Action start;exit $LASTEXITCODE}
'deploy'{if(!(Test-Path $EnvFile)){Write-Result $false 'DiscordBot/.env is not configured.';exit 1};$npm=(Get-Command npm -ErrorAction SilentlyContinue).Source;if(!$npm){Write-Result $false 'npm was not found in PATH.';exit 1};Invoke-NpmInstall $npm;& $npm --prefix $Root run deploy;if($LASTEXITCODE -ne 0){Write-Result $false 'Discord slash-command deployment failed. Check DiscordBot/npm-install.log.';exit 1};Write-Result $true 'Discord slash commands deployed.';exit 0}
}}catch{Write-Result $false $_.Exception.Message;exit 1}
