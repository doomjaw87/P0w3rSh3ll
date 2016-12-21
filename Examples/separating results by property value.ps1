BREAK
<#######################################
| Separating Results by Property Value |
########################################

If you use PowerShell remoting to receive information from remote machines, you
can use fan-out simply by specifying more than one comptuer name. PowerShell
will then automagically contact all machines simultaneously, which saves a lot
of time (all of this requires that you ahve set up and enabled PowerShell on
the affected machines, of course, which is not covered here).

The results come back in random order because all contacted machines return
their informatino to you when they are ready.

To sparate result data again per computer, use Group-Object

#>

$pc1 = $env:COMPUTERNAME
$pc2 = 'labhyperv-01'

$code =
{
    Get-Service | Where-Object -Property Status -eq 'Running'
}


# Get all results
$result = Invoke-Command -ScriptBlock $code -ComputerName $pc1, $pc2

# Separate per computer
$groups = $result | Group-Object -Property PSComputerName -AsHashTable
$groups

# Access per computer results separately
$groups.$pc1
$groups.$pc2