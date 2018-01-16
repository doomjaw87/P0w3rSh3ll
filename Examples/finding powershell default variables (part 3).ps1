<################################################
| FINDING POWERSHELL DEFAULT VARIABLES (PART 3) |
#################################################

All Versions

In the previous tip we illustrated how you can identify built-in PowerShell variables with an
approach like this:

#>

$ps = [PowerShell]::Create()
$null = $ps.AddScript('$null=$host;Get-Variable')
$ps.Invoke()
$ps.Runspace.Close()
$ps.Dispose()

# Apparetnly, this code still misses some variables that aren't created by the PowerShell core
# engine, but instead are added later by individual hosts, like powershell.exe or the ISE. These
# missing variables need to be added manually. Forntunately, there aren't too many.

$ps = [PowerShell]::Create()
$null = $ps.AddScript('$null=$host;Get-Variable')
[system.Collection.ArrayList]$result = $ps.Invoke() |
    Select-Object -ExpandProperty Name
$ps.Runspace.Close()
$ps.Dispose()

# add host-specific variables
$special = 'ps','psise','psunsupportedconsoleapplications','foreach','profile'
$result.AddRange($special)

# Now the code produces a complete list of reserved PowerShell variables, and in case we still
# missed some, simply add them to $Special

# As a side note, the code nicely illustrates how [System.Collections.ArrayList] products a better
# array. In contrast to regular arrays of type [Object[]], the ArrayList object has additional methods
# like AddRange() that can be used to quickly add a number of new elements.