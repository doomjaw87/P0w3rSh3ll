<###############################
| VALIDATING INTEGER VARIABLEs |
################################

Version 4 and Later

You can easily assign the [int] type to a variable to make sure it can contain only digits. But did
you know that you can also apply a regex validator (at least starting PowerShell 4)?

This way, you can define that a variable should be integer but can only have numbers between 2 and
6 digits, or any other pattern you require:

#>

[ValidatePattern('^\d{2,6}$')][int]$id = 123

$id = 10000

$id = 123456789
# Cannot check variable id. Value WHATEVERVALUE is invalid for variable id