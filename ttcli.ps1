[CmdLetBinding()]
param (
  [Parameter()]
  [string]
  $function,
  [Parameter()]
  [bool]
  $hidden,
  [Parameter()]
  [bool]
  $debugScript
)

if($hidden){
  $t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
  add-type -name win -member $t -namespace native
  [native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)
}

function track(){
  $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
  $stopwatch.start()
}

function lock(){
  $stopwatch.Stop()
  Add-Content -Path "$env:APPDATA\ttcli\log.json" -Value "Locked at: $(Get-Date -Format "dddd MM/dd/yyyy HH:mm K")"
}

function unlock(){
  $stopwatch.Start()
  Add-Content -Path "$env:APPDATA\ttcli\log.json" -Value "Unlocked at: $(Get-Date -Format "dddd MM/dd/yyyy HH:mm K")"
}

function export(){

}

function close {
  $events = Get-EventSubscriber | Where-Object { $_.SourceObject -eq [Microsoft.Win32.SystemEvents] } 
  $jobs = $events | Select-Object -ExpandProperty Action
  $events | Unregister-Event
  $jobs | Remove-Job
}

try{
  &$function
}catch{
  Write-Host "Welcome to TimeTrackerCLI by TD3V"
  Write-Host "---------------------------------------------"
  if($debugScript){
    Write-Host "The following error occured:"
    Write-Host "$($_.Exception.Message)"
  }else{
    Write-Host "An error occured, if it persits you can check the documentation or contact the creator."
  }
  Write-Host "---------------------------------------------"

}