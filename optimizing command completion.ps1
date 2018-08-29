<################################
# Optimizing Command Completion #
#################################

The PowerShell console (powershell.exe, pwsh.exe) offers extension
completion support. When you enter a command and then add a
space and a hypen, pressing tab will cycle through the available parameters.

There is a substantial difference between Windows
PowerShell (powershell.exe) and PowerShell on Linux and macOS
(pwsh.exe). When you tab on the latter, they show all available
options at once, and you can pick the suggestion that you need.

To add that behavior to powershell.exe, simply run this line:

#>

Set-PSReadlineOption -EditMode Emacs

# Next time you enter the beginning of a parameter and press TAB, you
# see all available choices at once. Then, the command is repeated,
# and you can type the first characters of your choice. Pressing TAB
# now completes your choice.

# Windows users may hear an annoying bell sound while doing this. To
# turn this off, run:

Set-PSReadlineOption -BellStyle None