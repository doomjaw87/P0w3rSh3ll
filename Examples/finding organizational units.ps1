<###############################
| FINDING ORGANIZATIONAL UNITS |
################################

All Versions

Get-ADOrganizationalUnit (From Microsoft's free RSAT tools) can search for organizational units
based on fully distinguished name or GUID, or you use the -Filter parameter.

Unfortunately, -Filter cannot easily be automated. The code below does not work and will not
return all organizational units with "Test" in their name:

#>

$Name = 'Test'
Get-ADOrganizationalUnit -Filter {Name -like "*$Name*"}

# This is surprising since this line works (provided you have organizational units with "Test" in their
# name in the first place
Get-ADOrganizationalUnit -Filter {Name -like "*Test*"}

# Ofen a simple LDAP filter works best and can help if youd't like to search with simple wildcards.
# The code below finds all organizational units with "Test" in their name:
$name = 'Test'
Get-ADOrganizationalUnit -LDAPFilter "(Name=*$name*)"