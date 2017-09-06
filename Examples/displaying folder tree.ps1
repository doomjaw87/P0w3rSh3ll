<#########################
| DISPLAYING FOLDER TREE |
##########################

All Versions

PowerShell is a friend with old console commands, so the easiest way of displaying the tree
structure of a folder is the old "tree" command. It works best in a native PowerShell console
because editors often use a different character set. Try this:

#>

Tree $home

# Just make sure you are running this command in a native PowerShell console or VSCode.
# You can then pipe the result to clip.exe and paste it in documentation documents.
Tree $home | clip.exe