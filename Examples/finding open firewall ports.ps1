<##############################
| FINDING OPEN FIREWALL PORTS |
###############################

All Versions

Here is a piece of PowerShell code that connects to the local firewall and dumps the open
firewall ports:

#>

$firewall = New-Object -ComObject HNetCfg.FwPolicy2
$firewall.Rules | Where-Object {$_.Action -eq 0} |
    Select-Object Name, ApplicationName, LocalPorts