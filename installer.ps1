Write-Host "Welcome to the Installer of TimeTrackerCLI made by TD3V"
Write-Host "-------------------------------------------------------"
try {
  New-Item -Path $env:APPDATA -Name "ttcli" -ItemType "directory" -Force
  New-Item -Path $evn:APPDATA\ttcli -Name "config.json" -ItemType "file" -Force
  New-Item -Path $env:APPDATA\ttcli -Name "log.json" -ItemType "file" -Force
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/T-D3V/TimeTrackerCLI/master/ttcli.ps1" -OutFile $env:APPDATA\ttcli\ttcli.ps1
  $env:Path += "$evn:APPDATA\ttcli\ttcli.ps1"
  Write-Host "Everything worked you can now use the script with ttcli"
}
catch {
  Write-Host "Something wen wrong if the error perists you may contact the Author"
}