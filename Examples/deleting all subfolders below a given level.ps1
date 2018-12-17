<##############################################
| DELETING ALL SUBFOLDERS BELOW A GIVEN LEVEL |
###############################################

ALL VERSIONS

Here is another file system task that sounds worse than it actually is. Let's say you need to
remove all folders below a given level in a folder structure. Here is how:

#>


# Task:
# Remove all folders one level below the given path
Get-ChildItem -Path C:\users\asparkma\Documents\*\ -Directory -Recurse |
    # Remove -WhatIf to actually delete
    # Attention: test thoroughly before doing this
    # You may want to add -Force to Remove-Item to forcefully delete
    Remove-Item -WhatIf


# Simply use * in your path. To delete all folders two levels below a given path, adjust
# accordingly:
Get-ChildItem -Path c:\users\asparkma\documents\*\*\ -Directory -Recurse |
    Remove-Item -WhatIf