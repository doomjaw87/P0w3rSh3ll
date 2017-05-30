<##############################
| TESTING ORGANIZATIONAL UNIT |
###############################

All Versions

Provided you have installed the free Microsoft RSAT tools, here is simple way to check
whether an OU exists:

#>

$ouPath = 'OU=TestOU, DC=Whatever, DC=Local'
$exists = $(
    try
    {
        Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction Ignore
    }
    catch
    { }
) -ne $null

"$ouPath : $exists"


# $exists will be $true or $false, indicating whether the OU was found. Note the use of try/catch
# error handling: Get-ADOrganizationalUnit can raise terminating errors when the specified OU
# does not exist, so try/catch is needed to capture these exceptions.