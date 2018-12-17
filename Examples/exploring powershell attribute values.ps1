<########################################
| EXPLORING POWERSHELL ATTRIBUTE VALUES |
#########################################

ALL VERSIONS

As you might know, you can add attributes to variables and parameters to more specifically
define them. For example, the line below defines a function with a parameter that accepts only
three distinct string values and is mandatory:

#>

function Test-Attribute
{
    [CmdletBinding()]
    param
    (
        [string]
        [Parameter(Mandatory)]
        [ValidateSet("A","B","C")]
        $Choice
    )

    "Choice: $Choice"
}

# If you ever wondered what your choices are with these attribtes, here is how. All you need to
# know is the true name of the type that represents an attribute. PowerShell's own attributes all
# reside in the System.Management.Automation namespace. Here are the two most commonly
# used:

# [Parameter()] = [System.Management.Automation.ParameterAttribute]
# [CmdletBinding()] = [System.Management.Automation.CmdletBindingAttribute]

# To find out the legal values for a given attribute, simply instantiate an object of the given type,
# and look at its properties:

[System.Management.Automation.ParameterAttribute]::new() |
    Get-Member -MemberType *Property |
    Select-Object -ExpandProperty Name


# When you add the expected data type to each value, the list becomes even more usable:
[System.Management.Automation.ParameterAttribute]::new() |
    Get-Member -MemberType *Property |
    ForEach-Object {
        [PSCustomObject]@{
            Name = $_.Name
            Type = ($_.Definition -split ' ' )[0]
        }
    }


# And this would be the list for [CmdletBinding()]:
[System.Management.Automation.CmdletBindingAttribute]::new() |
    Get-Member -MemberType *Property |
    ForEach-Object -MemberName *Property |
    ForEach-Object {
        [PSCustomObject]@{
            Name = $_.Name
            Type = ($_.Definition -split ' ' )[0]
        }
    }