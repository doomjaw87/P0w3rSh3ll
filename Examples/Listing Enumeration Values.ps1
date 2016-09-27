Clear-Host

@'

     Listing Enumeration Values

If you'd like to know what the allowed string values are for a parameter
that accepts an enumeration, first take a look at a simple example that
changes console foreground colors...

'@

$host.UI.RawUI.ForegroundColor = 'Red'
Write-Host ('     $host.UI.RawUI.ForegroundColor = {0}' -f $host.UI.RawUI.ForegroundColor)

$host.UI.RawUI.ForegroundColor = 'White'
Write-Host ('     $host.UI.RawUI.ForegroundColor = {0}' -f $host.UI.RawUI.ForegroundColor)

@'

How do you know the names of the colors that are supported by the console,
though? For this, you need to know the true datatype that ForegroundColor
really supports:

'@
Write-Host ('     $host.UI.RawUI.ForegroundColor.GetType().FullName = {0}' -f $host.UI.RawUI.ForegroundColor.GetType().FullName)

@'

Now you can check whether it is really an enumeration:

'@
Write-Host ('     $host.UI.RawUI.ForegroundColor.GetType().IsEnum = {0}' -f $host.UI.RawUI.ForegroundColor.GetType().IsEnum)

@'

If it is, like in this example, you can list its names:

'@
Write-Host '[System.Enum]::GetNames([System.ConsoleColor])'
[System.Enum]::GetNames([System.ConsoleColor])