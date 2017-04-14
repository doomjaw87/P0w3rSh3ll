<###########################################
| AUTO-DECLARING ALIAS NAMES FOR FUNCTIONS |
############################################

You probably know that PowerShell supports alias names for commands. But did you know that
you can define alias names for PowerShell functions inside a function definition (introduced in
PowerShell 4)? Have a look:

#>

function Get-AlcoholicBeverage
{
    [Alias('Beer','Drink')]
    [cmdletbinding()]
    param()

    "Here is your beer"
}

# The "official" name for the function is Get-AlcoholicBeverage, but this function is also available
# via the aliases "Beer" and "Drink". Powershell automatically adds these aliases when the
# function is defined:
Get-Alias -Definition Get-AlcoholicBeverage