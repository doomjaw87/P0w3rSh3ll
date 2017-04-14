<######################################################
| DETERMINE IF ARRAY CONTAINS VALUE - USING WILDCARDS |
#######################################################

If you'd like to know whether an array contains a given element, PowerShell provides the
-contains operator. This operator does not support wildcards, though, so you only can check for
exact matches.

Here is a workaround that helps you filter array elements with wildcards:

#>

$a = 'Hanover', 'Hamburg', 'Vienna', 'Zurich'


# is the exact phrase present in array?
$a -contains 'Hannover'


# is ANY phrase present in array that maches the wildcard expression?
($($a) -like 'ha*').Count -gt 0


# list all phrases from array that match the wildcard expressions
($a) -like 'Ha*'