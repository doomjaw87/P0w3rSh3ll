<###########################
| HIDING COMMON PARAMETERS |
############################

ALL VERSIONS

In our last tip we explained how you can hide paramters from IntelliSense. This has a cool side
effect that we'd like to point you to today.

PowerShell supports two different types of functions: simple functions and advanced functions. A
simple function just exposes the paramters you define. An advanced function also adds all the
common parameters. Here are two sample functions:

#>

function Simple
{
    param
    (
        $Name
    )
}

function Advanced
{
    param
    (
        [parameter(mandatory)]
        $Name
    )
}

# When you run Simple in an editor with IntelliSense, you see just the -Name parameter. When
# you do the same with Advanced, you also see a bunch of common parameters that are present
# always.
# Whenever you use an attribute (pattern of attributes are [Name(Value)]), PowerShell creates an
# advanced function, and there is no way for you to exclude the common parameters. What could
# you do to benefit from the advantages of advanced functions (i.e. mandatory parameters) but still
# would like to only show your own parameters to the user?

# Here is a secret trick. Compare the following two functions:
function Advanced2
{
    param
    (
        [parameter(mandatory)]
        [string]
        $Name,

        [int]
        $Id,

        [switch]
        $Force
    )
}

function AdvancedWithoutCommon
{
    param
    (
        [parameter(mandatory)]
        [string]
        $Name,

        [int]
        $Id,

        [switch]
        $Force,

        # Add a dummy "dontshow" parameter
        [parameter(dontshow)]
        $Anything
    )
}

<#

When you run the "Advanced2" function, you see your own parameters plus the common
parameters. When you do the same with "AdvancedWithoutCommon", you only see your own
parameters but still keep the functionality of advanced functions, i.e. the -Name parameter is still
mandatory

The effect is created by adding at least one hidden parameter. Hidden parameters were
introduced in PowerShell 5 to facilitate class methods (prevent hidden properties from showing).
Since class members don't show common parameters, the attribute value "DontShow" not only
hides that particular member from intellisense, it also hides all common parameters.

Which in turn yields to another interesting fact: even though the common parameters are now
hidden from IntelliSense, they are still present and can be used.

#>