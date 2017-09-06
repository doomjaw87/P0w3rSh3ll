<#############################
| MODERN ALTERNATIVE TO MORE |
##############################

All Versions

In a PowerShell console, you can continue to pipe to more, just like in cmd.exe, to view results
page by page. However, more does not support realtime pipelining, so all data needs to be collected
first. This can take a long time a burn much memory:

#>

dir C:\windows -Recurse -ea 0 | More

# a better way is to use PowerShell's own paging mechanism:
dir c:\windows -Recurse -ea 0 | Out-Host -Paging


# NOTE: This requires a true console window - it won't work in graphical hosts.