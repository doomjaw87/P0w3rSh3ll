<####################################
| FINDING ALL PROFILES WITH DESKTOP |
#####################################

This simple line dumps all paths to all desktops found in any of the local user profiles - just make
sure you are running the line with Administrator privileges to see other people's profiles

#>

Resolve-Path -Path c:\users\*\Desktop -ErrorAction SilentlyContinue


# If you would like to get the usernames for those profiles that have a Desktop, try this.
# The code takes the paths and splits them at the slash, producing an array of path components.
# Index -2 is the second-last component, thus the username
Resolve-Path -Path c:\users\*\desktop -ErrorAction SilentlyContinue |
    ForEach-Object {
        $_.Path.Split('\')[-2]
    }

