<##############################
| CLEARING ALL USER VARIABLES |
###############################

All Versions

In the previous tip we illustrated how you can identify built-in PowerShell variables with an approach like this:

#>

$ps = [PowerShell]::Create()
$null = $ps.AddScript('$null=$host;Get-Variable')
$ps.Invoke()
$ps.Runspace.Close()
$ps.Dispose()

# Now let's do the opposite and create a function that dumps only your variables

function Get-UserVariable ($Name = '*')
{
    # these variables may exist in certain environments (like ISE, or after use of ForEach)
    $special = 'ps','psise','psunsupportedconsoleapplications','foreach','profile'
    $ps = [PowerShell]::Create()
    $null = $ps.AddScript('$null=$host;Get-Variable')
    $reserved = $ps.Invoke() |
        Select-Object -ExpandProperty Name
    $ps.Runspace.Close()
    $ps.Dispose()
    Get-Variable -Scope Global |
        Where-Object Name -Like $name |
        Where-Object {$reserved -notcontains $_.Name} |
        Where-Object {$special -notcontains $_.Name} |
        Where-Object Name
}

# Now it's really easy to identify all the variables you (or your scripts) have created that still linger in memory
# To clean up your runspace, you can now delete all your variables in one line
Get-UserVariable | Remove-Variable -WhatIf