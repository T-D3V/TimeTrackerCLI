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