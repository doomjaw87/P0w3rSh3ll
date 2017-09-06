<################################################
| FINDING POWERSHELL DEFAULT VARIABLES (Part 1) |
#################################################

Sometimes it would be useful to identify the automatic PowerShell variables managed by
PowerShell so you could differentiate between built-in variables and your own. Get-Variable
always dumps all variables.

Here is simple trick that uses a separate new and fresh PowerShell runspace to determine the
built-in PowerShell variables:

#>


# create a new PowerShell
$ps = [PowerShell]::Create()


# get all variables inside of it
$null = $ps.AddCommand('Get-Variable')
$result = $ps.Invoke()


# dispose new PowerShell
$ps.Runspace.Close()
$ps.Dispose()


# check results
$varCount = $result.Count
Write-Warning "Found $varCount variables."

$result | Out-GridView