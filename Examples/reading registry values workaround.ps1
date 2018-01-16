<#######################################
| READING REGISTRY VALUES (WORKAROUND) |
########################################

All Versions

In the previous tip we illustrated that Get-ItemProperty cannot read registry values when
there is a value present with corrupted content:

#>

$key = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\0"
Get-ItemProperty -Path $key


# As a workaround, you can instead use Get-Item to access the registry key, and then use its .NET
# members to read all of its values:

$key = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\0"
$key = Get-Item -Path $key

$hash = @{}
foreach ($prop in $key.Property)
{
    $hash.$prop = $key.GetValue($prop)
}
$hash