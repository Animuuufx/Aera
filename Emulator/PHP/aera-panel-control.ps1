param([Parameter(Position=0)][ValidateSet('start','stop','restart','status')][string]$Action='status')
$Root=Split-Path -Parent $MyInvocation.MyCommand.Path
$Control=Join-Path $Root 'runtime\control'
$Status=Join-Path $Control 'status.json'
if($Action -eq 'status'){
  if(Test-Path $Status){Get-Content $Status -Raw;exit 0}
  Write-Output 'Supervisor status unavailable. Run INSTALL_PHP_EMULATOR_CONTROL.bat as Administrator.';exit 2
}
$id=[Guid]::NewGuid().ToString('N')
$requests=Join-Path $Control 'requests';$responses=Join-Path $Control 'responses'
New-Item -ItemType Directory -Force -Path $requests,$responses|Out-Null
@{id=$id;action=$Action;requestedAt=(Get-Date -Format o)}|ConvertTo-Json -Compress|Set-Content (Join-Path $requests ($id+'.json')) -Encoding UTF8
Write-Output ('Queued '+$Action+' request '+$id+'.')
