#Define Command Parameters
[CmdLetBinding()]
param (
  [Parameter()]
  [string]
  $function,
  [Parameter()]
  [bool]
  $hidden
)

#Get Config
$config = Get-Content -Raw -Path "$env:APPDATA\ttcli\config.json" | ConvertFrom-Json

#When Hidden don't display the window
if($hidden){
  $t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
  add-type -name win -member $t -namespace native
  [native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)
}

#Set callable actions for task scheduler
function login() {
  Add-Content -Path "$env:APPDATA\ttcli\log.txt" -Value "Logged in at: $(Get-Date -Format "dddd MM/dd/yyyy HH:mm K")"
}

function lock(){
  Add-Content -Path "$env:APPDATA\ttcli\log.txt" -Value "Locked at: $(Get-Date -Format "dddd MM/dd/yyyy HH:mm K")"
}

function unlock(){
  Add-Content -Path "$env:APPDATA\ttcli\log.txt" -Value "Unlocked at: $(Get-Date -Format "dddd MM/dd/yyyy HH:mm K")"
}

function idle(){
  Add-Content -Path "$env:APPDATA\ttcli\log.txt" -Value "Idle at: $(Get-Date -Format "dddd MM/dd/yyyy HH:mm K")"
}

#Export the Log copy from location to current location
function export(){
  Copy-Item -Path "$env:APPDATA\ttcli\log.txt" -Destination (Get-Location)
}

#Run Action
try{
  &$function
}catch{
  Write-Host "Welcome to TimeTrackerCLI by TD3V" -ForegroundColor $config.color
  Write-Host "---------------------------------------------" -ForegroundColor $config.color
  if($debugScript){
    Write-Host "The following error occured:" -ForegroundColor $config.color
    Write-Host "$($_.Exception.Message)" -ForegroundColor $config.color
  }else{
    Write-Host "An error occured, if it persits you can check the documentation or contact the creator." -ForegroundColor $config.color
  }
  Write-Host "---------------------------------------------" -ForegroundColor $config.color

}