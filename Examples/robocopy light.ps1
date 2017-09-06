<#################
| ROBOCOPY LIGHT |
##################

All Versions

Robocopy.exe is an extremely powerful and versatile built-in command to copy files efficiently
from one location to another. Unfortunately, this command has so many options and switches
that very often make it hard to use.

If all you want is to copy files from A to B, here is a simple PowerShell function that wraps
robocopy and turns the beast into a simple-to-use copy command:

#>

function Copy-FileWithRobocopy
{
    param
    (
        [parameter(mandatory)]
        $Source,

        [parameter(Mandatory)]
        $Destination,

        $Filter = '*'
    )

    robocopy.exe $Source $Destination $Filter /S /R:0
}