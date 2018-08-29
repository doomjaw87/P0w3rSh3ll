<#########################
# Setting Mouse Position #
##########################

PowerShell cna place the mouse cursor anywhere on your screen.

#>

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.Forms') | Out-Null
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(500, 100)