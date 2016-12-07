BREAK
<#############################
| Listing Enumeration Values |
##############################

If you'd like to know what the allowed string values are for a parameter
that accepts an enumeration, first take a look at a simple example that
changes console foreground colors...
#>
$host.UI.RawUI.ForegroundColor = 'Red'

$host.UI.RawUI.ForegroundColor = 'White'

<#
How do you know the names of the colors that are supported by the console,
though? For this, you need to know the true datatype that ForegroundColor
really supports:
#>
$host.UI.RawUI.ForegroundColor.GetType().FullName

<#
Now you can check whether it is really an enumeration:
#>
$host.UI.RawUI.ForegroundColor.GetType().IsEnum

<#
If it is, like in this example, you can list its names:
#>
[System.Enum]::GetNames([System.ConsoleColor])


<###################################
| Understanding Enumeration Values |
####################################

Most enumerations are just an easy way of labelling numeric values.
The values "Red" and "White" are really integer numbers...
#>
[int][System.ConsoleColor]::Red # = 12
[int][System.ConsoleColor]::White # = 15

<#
It immediately becomes evident how much harder would be to read code like
this. Still there is a use case. If you'd like to set random colors for
your console, you could use numeric values. There are 16 available console
colors, so this would re-colorize your console with a random background
and foreground color.
#>

$background, $foreground = 0..15 | Get-Random -Count 2
$host.UI.RawUI.ForegroundColor = $foreground
$host.UI.RawUI.BackgroundColor = $background


<#################################
| Creating Your Own Enumerations |
##################################

Beginning in PowerShell 5, you can create your own enumerations using the
"Enum" keyword.
#>
#requires -Version 5.0

Enum ComputerType
{
    ManagedServer
    ManagedClient
    Server
    Client
}

function Connect-Computer
{
    param
    (
        [ComputerType]$Type,
        [string]$name
    )
    ('ComputerName: {0}' -f $name) | Write-Output
    ('Type: {0}' -f $Type) | Write-Output
}
Connect-Computer -Name 'Testing' -Type ManagedServer


