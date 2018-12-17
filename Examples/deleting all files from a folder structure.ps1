<#############################################
| DELETING ALL FILES FROM A FOLDER STRUCTURE |
##############################################

ALL VERSIONS

Sometimes tasks sound worse than they actually are. Let's say you need to clear
a folder structure and remove all files, leaving empty folders. Let's further
assume there are files on a whitelist that should not be deleted. With PowerShell,
that's easy to accomplish.

#>


$Path = 'C:\sample'
$WhiteList = 'Important.txt', 'Something.csv'

Get-ChildItem -Path $Path -File -Exclude $WhiteList -Recurse -Force |

# Remove -whatIf if you want to actually delete files
# TEST THOROUGHLY BEFORE DOING THIS
# You could also add the -Force parameter to forcefully remove files
Remove-Item -WhatIf