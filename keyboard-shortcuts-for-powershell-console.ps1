<############################################
| KEYBOARD SHORTCUTS FOR POWERSHELL CONSOLE |
#############################################

All Versions

The PowerShell console starting in version 5 ships with a modeul called PSReadLine which
does much more than just coloring command tokens. It comes with a persistent command
history, and also can bind custom commands to keyboard shortcuts.

#>

Set-PSReadlineKeyHandler -Chord Ctrl+H -ScriptBlock {
    Get-History |
    Out-GridView -Title 'Select Command' -PassThru |
    Invoke-History
}

# When you run this is a PowerShell console (it won't work in the PowerShell ISE!),
# pressing CTRL+H opens up a grid view window with all of the commands in your 
# command history. You can then easily select one command, and execute it.

# Obviously, this is just an example. You can bind any script block to unused
# keyboard shortcuts, and for example commit changes to Bit, or open your favorite
# news ticker