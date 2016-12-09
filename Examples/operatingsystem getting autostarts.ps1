BREAK

<####################################
| Finding Hidden Autostart Programs |
####################################>

Get-WmiObject -Class Win32_StartupCommand | 
    Select-Object -Property Command, Description, User, Location