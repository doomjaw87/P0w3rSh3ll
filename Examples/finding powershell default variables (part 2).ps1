<#######################################
| FINDING POWERSHELL DEFAULT VARIABLES |
########################################

In the previous tip we explained how you can use a separate new and fresh PowerShell to
retrieve all default variables. When you examine these variables closely, you will discover that
still some PowerShell variables are missing.

Heree is a modified version called Get-BuiltInPSVariable that includes all reserved
PowerShell variables.

#>

function Get-BuiltInPSVariable($Name='*')
{
    # create a new PowerShell
    $ps = [PowerShell]::Create()

    # get all variables inside of it
    $ps.AddScript('$null=$host;Get-Variable')
    $ps.Invoke() |
        Where-Object Name -Like $Name

    # dispose new PowerShell
    $ps.Runspace.Close()
    $ps.Dispose()
}

# To not miss out on any built-in PowerShell variable, this approach uses AddScript() instead of
# AddCommand(), and issues more than one command. Some PowerShell variables are created
# only after at least one command has run.

# You can now dump all PowerShell built-in variables, or search for selected.