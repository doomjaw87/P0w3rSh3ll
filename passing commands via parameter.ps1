<#################################
# Passing commands via Parameter #
##################################

Here is a rather unusual case for function parameters: a user can
pass an output command:

#>

function Get-ProcessList
{
    param
    (
        [string]
        [validateSet('GridView', 'String')]
        $OutputMode = 'String'
    )

    Get-Process | & "Out-$OutputMode"
}

# output as a string
Get-ProcessList -OutputMode String

# output in a grid view window
Get-ProcessList -OutputMode GridView