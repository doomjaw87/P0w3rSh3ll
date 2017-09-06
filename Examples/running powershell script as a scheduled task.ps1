<################################################
| RUNNING POWERSHELL SCRIPT AS A SCHEDULED TASK |
#################################################

Version 3 and later

If you need to run a PowerShell script in regular intervals, why not run it as a scheduled task?
Here are some lines that help you create a new scheduled task to run a PowerShell script at 6AM:

#>

#requires -Modules ScheduledTasks
#requires -Version 3.0
#requires -RunAsAdministrator

$TaskName = 'RunPSScriptAt6'
$User = 'domain\user'
$scriptPath = '\\server\share\script.ps1'

$Trigger = New-ScheduledTaskTrigger -At 6:00am -Daily
$Action  = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-ExecutionPolicy Bypass -NoProfile -File $scriptPath"

$props = @{TaskName = $TaskName
           Trigger  = $Trigger
           User     = $User
           Action   = $Action
           RunLevel = 'Highest'
           Force    = $true}
Register-ScheduledTask @props