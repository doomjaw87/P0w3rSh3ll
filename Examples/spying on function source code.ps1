<#################################
| SPYING ON FUNCTION SOURCE CODE |
##################################

All Versions

Here is a quick way to find the source code of PowerShell functions:

#>

${function:Clear-Host} | clip

# This would copy the Clear-Host source code to the clipboard, and when you paste it, you'll see
# how Clear-Host works:

$RawUI = $Host.UI.RawUI
$RawUI.CursorPosition = @{X=0;Y=0}
$RawUI.SetBufferContents(
    @{Top = -1; Bottom = -1; Right = -1; Left = -1},
    @{Character = ' '; ForegroundColor = $rawui.ForegroundColor; BackgroundColor = $rawui.BackgroundColor})
# .Link
# https://go.microsoft.com/fwlink/?LinkID=225747
# .ExternalHelp System.Management.Automation.dll-help.xml


# As always, there is much to learn. If you'd like to fill the PowerShell console with a character
# different than space, i.e. 'X', with yellow foreground on green background, try this:

$host.UI.RawUI.SetBufferContents(
    @{Top = -1; Bottom = -1; Right = -1; Left = -1},
    @{Character = 'X'; ForegroundColor = 'Yellow'; BackgroundColor = 'Green'}) 
