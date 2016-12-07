BREAK

<#########################
| GETTING UNIVERSAL TIME |
#########################>
[System.DateTime]::Now
[System.DateTime]::UtcNow.ToString("o")
[system.datetime]::Now.ToUniversalTime().ToString("o")



<#########################################
| Time Zone Management in PowerShell 5.1 |
##########################################

PowerShell 5.1 (available on Windows 10 and Server 2016) comes with some new cmdlets
to manage computer time zones. Get-TimeZone returns the current settings, and Set-TimeZone
would change it:

#>

Get-TimeZone



<##################################
| Exploiting Your Command History |
###################################

PowerShell "records" all your interactive command input to its command history, and
Get-History shows them. If you played around with PowerShell for a while and then
decieded that it wasn't all that bad what you did, here is a script that copies all
interactive commands from command history to your clipboard. You can then paste it into
the PowerShell ISE, and make it a script:

#>

# Define how old your commands may be at most to be included
$maxAgeHours = 4

# Get all command history items that were started after this
$DateLimit = (Get-Date).AddHours(-$maxAgeHours)

# Get all command-line commands
Get-History |

    # Exclude all that were aborted
    Where-Object ExecutionStatus -eq Completed |

    # Exclude all that are older than the limit set above
    Where-Object StartExecutionTime -gt $DateLimit |

    # Just get the command-line
    Select-Object -ExpandProperty CommandLine |

    # Copy all to clipboard
    clip.exe