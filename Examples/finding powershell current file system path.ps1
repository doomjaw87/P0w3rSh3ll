<################################################
| FINDING POWERSHELL'S CURRENT FILE SYSTEM PATH |
#################################################

ALL VERSIONS

To find out the path your PowerShell is currently using, simply run Get-Location.

However, the current path does not necessarily point to a file system location.

If you need to know the current FILE SYSTEM path PowerShell uses, regardless of the current
provider you are using, try this:

#>

$ExecutionContext.SessionState.Path