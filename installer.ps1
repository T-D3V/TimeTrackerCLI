Write-Host "Welcome to the Installer of TimeTrackerCLI made by TD3V"
Write-Host "-------------------------------------------------------"
try {
  New-Item -Path $env:APPDATA -Name "ttcli" -ItemType "directory" -Force
  New-Item -Path $env:APPDATA\ttcli -Name "config.json" -ItemType "file" -Force
  Add-Content -Path "$env:APPDATA\ttcli\config.json" -Value "{color: 'green'}"
  New-Item -Path $env:APPDATA\ttcli -Name "log.txt" -ItemType "file" -Force
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/T-D3V/TimeTrackerCLI/master/ttcli.ps1" -OutFile $env:APPDATA\ttcli\ttcli.ps1
  [System.Environment]::SetEnvironmentVariable('Path',$env:Path + ";$env:APPDATA\ttcli",[System.EnvironmentVariableTarget]::Machine)
  $scheduler = new-object -com("Schedule.Service")
  $scheduler.Connect()
  $folder = $scheduler.GetFolder("\")
  $definition = $scheduler.NewTask(0)
  $triggers = $definition.Triggers
  $trigger = $triggers.Create(11) # TRIGGER_TYPE
  $trigger.StateChange = 7 # TASK_SESSION_LOCK 

  $action = $definition.Actions.Create(0)
  $action.Path = "powershell"
  $action.Arguments = "ttcli lock"
  $folder.RegisterTaskDefinition("TTCLI catch SessionLock", $definition, 6, "", "" , 0)

  $scheduler = new-object -com("Schedule.Service")
  $scheduler.Connect()
  $folder = $scheduler.GetFolder("\")
  $definition = $scheduler.NewTask(0)
  $triggers = $definition.Triggers
  $trigger = $triggers.Create(11) # TRIGGER_TYPE
  $trigger.StateChange = 8 # TASK_SESSION_LOCK 

  $action = $definition.Actions.Create(0)
  $action.Path = "powershell"
  $action.Arguments = "ttcli unlock"
  $folder.RegisterTaskDefinition("TTCLI catch SessionUnlock", $definition, 6, "", "" , 0)

  $scheduler = new-object -com("Schedule.Service")
  $scheduler.Connect()
  $folder = $scheduler.GetFolder("\")
  $definition = $scheduler.NewTask(0)
  $triggers = $definition.Triggers
  $trigger = $triggers.Create(11) # TRIGGER_TYPE
  $trigger.StateChange = 2 # TASK_SESSION_LOCK 

  $action = $definition.Actions.Create(0)
  $action.Path = "powershell"
  $action.Arguments = "ttcli login"
  $folder.RegisterTaskDefinition("TTCLI catch Login", $definition, 6, "", "" , 0)

  $scheduler = new-object -com("Schedule.Service")
  $scheduler.Connect()
  $folder = $scheduler.GetFolder("\")
  $definition = $scheduler.NewTask(0)
  $triggers = $definition.Triggers
  $trigger = $triggers.Create(11) # TRIGGER_TYPE
  $trigger.StateChange = 4 # TASK_SESSION_LOCK 

  $action = $definition.Actions.Create(0)
  $action.Path = "powershell"
  $action.Arguments = "ttcli idle"
  $folder.RegisterTaskDefinition("TTCLI catch Idle", $definition, 6, "", "" , 0)

  Write-Host "-------------------------------------------------------"
  Write-Host "Everything worked you can now use the script with ttcli as command"
}
catch {
  Write-Host "Something wen wrong if the error perists you may contact the Author"
}