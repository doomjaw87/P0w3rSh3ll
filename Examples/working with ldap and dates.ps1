<##############################
| WORKING WITH LDAP AND DATES |
###############################

LDAP filters are a fast and powerful way of retrieving information from Active Directory.
However, LDAP filters user a very low-level date and time format. It is basically a huge integer
number. Fortunately, PowerShell contains a way of converting real DateTime objects into these
numbers, and vice versa.

Here is a code sample that uses Get-AdUser from the ActiveDirectory module to find all users who
recently changed their passwords. If you don't have this module, go download the free RSAT
tools from Microsoft.

#>

# find all AD Users who changed their password in the last 5 days
$date = (Get-Date).AddDays(-5)
$ticks = $date.ToFileTime()

$ldap = "(&(objectCategory=person)(objectClass=user)(pwdLastSet>=$ticks))"
Get-AdUser -LDAPFilter $ldap -Properties |
    Select-Object -Property Name, PasswordLastSet