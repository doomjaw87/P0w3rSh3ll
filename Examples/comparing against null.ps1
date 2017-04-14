<##########################
| COMPARING AGAINST $NULL |
###########################

ALL VERSIONS

If you want to find out whether a variable contains $Null (nothing), always make sure you keep
$null on the left side of the comparison. Most of the time, the order does not really matter:

#>

$a = $null
$b = 12

$a -eq $null
# True

$b -eq $null
# False


# However, if a variable contains an array, placing the array on the left side of the comparison
# operator makes it work like a filter. so now order becomes vital:

# this all produces inconsistent and fishy results:
$a = $null
$a -eq $null # works: returns $true

$a = 1, 2, 3
$a -eq $null # fails: returns $null

$a = 1, 2, $null, 3, 4, 5
$a -eq $null # fails: returns $null

$a = 1, 2, $null, 3, 4, $null, 5
$a -eq $null # fails: returns array of 2x $null
($a -eq $null).Count


# If you place the variable on the left side, PowerShell checks for $null values inside the array and
# returns these, or $null if there are no such values

# If you place the variable on the right side, PowerShell checks whether the variable is $null

# By reversing the operands, all is FINE!

$a = $null
$null -eq $a # works: $true

$a = 1, 2, 3
$null -eq $a # works: $false

$a = 1, 2, $null, 3, 4
$null -eq $a # works: $false

$a = 1, 2, $null, 3, 4, $null, 5
$null -eq $a # works: $false


# This can be eliminated by placing $null on the left rather than on the right side of the comparison