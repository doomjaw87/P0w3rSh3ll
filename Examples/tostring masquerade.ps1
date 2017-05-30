<########################
| TOSTRING() MASQUERADE |
#########################

All Versions

In the previous tip we explained that ToString() is a fuzzy way of describing an object, and that
the object author can decide what ToString() returns. This is especially true for your PowerShell
code. Have a look how easily you can overwrite ToString() for any object.

#>

$a = 1
$a.toString()

$a | Add-Member -MemberType ScriptMethod -Name toString -Value {'totally not an int'} -Force
$a.ToString()
$a.GetType().FullName

Remove-Variable -Name a