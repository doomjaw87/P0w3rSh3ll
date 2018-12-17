<#############################################
| Using Solid Alternatives for $MyInvocation |
##############################################

All Versions

Lines like $MyInvocation.MyCommand.Defintion can be useful to determine the folder in which
the current script is stored, i.e. to access other resources located in the same folder.

However, ever since PowerShell 3, there have been easy alternatives to find out the current
script name and/or the path to the folder that contains the current script. Run the following code
to test for yourself.

#>

$MyInvocation.MyCommand.Definition

$PSCommandPath

Split-Path -Path $MyInvocation.MyCommand.Definition

$PSScriptRoot


<#

If you run these lines interactively (or in an "untitled" script), they all return nothing. Once you
save the script and run the script file, though, the first two lines return the script path, and the 
second two lines return the folder path in which the script is located.

The good thing about $PSCommandPath and $PSScriptRoot is that they always contain the
same information. $MyInvocation, in contrast, can change, and will change once this variable is
read from within a function:

#>

function test
{
    $MyInvocation.MyCommand.Definition
    $PSCommandPath

    Split-Path -Path $MyInvocation.MyCommand.Definition
    $PSScriptRoot
}

test

# Now, $MyInvocation turns out to be useless because it always returns information about who
# invoked the current script block