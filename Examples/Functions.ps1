BREAK

<#################################################
| Using Named Parameters in Powershell Functions |
##################################################

When creating a PowerShell function, all parameters are positional until
you start adding the "Position" attribute. Once you start to do this,
all parameters with no "Position" are suddenly named and must be 
specified. 


Classic function declaration, producing 3 positional parameters:

#>

function Test-Command
{
    param
    (
        [string]$Name,
        [int]$ID,
        [string]$Email
    )
    New-Object -TypeName System.Management.Automation.PSObject -Property @{
        Name  = $Name
        ID    = $ID
        Email = $Email
    } | Write-Output
}

# Classic syntax:
Test-Command 'Alex' 123 'things@stuff.com'


<#

Add the "Position" parameter attribute to at least one parameter, the others
become named...

#>

fucntion Test-Command
{
    param
    (
        [Parameter(Position=0)]
        [string]$Name,

        [Parameter(Position=1)]
        [int]$ID,

        # No position parameter attribute
        [string]$Email
    )

    New-Object -TypeName System.Management.Automation.PSObject @{
        Name  = $Name
        ID    = $ID
        Email = $Email
    } | Write-Output
}

# "Position" parameter attribute makes all non-"Position" parameters "Named" parameters
Test-Command 'Alex' 123 -Email 'things@stuff.com'



<#################################
| Validating Function Parameters |
##################################

You can use Regular Expression patterns to validate function parameters...

#>

function Get-ZipCode
{
    param
    (
        [ValidatePattern('^\d{5}$')]
        [string]
        $ZIP
    )

    'Here is the Zip code you entered: {0}' -f $ZIP | Write-Output
}

Get-ZipCode -ZIP '12345'

# This will be mad
Get-ZipCode -ZIP '123456'



<#####################
| Most Popular Verbs |
######################

Let's explore which command verbs are most popular in PowerShell...

#>

Get-Command -CommandType Cmdlet, function |
    Group-Object -Property Verb |
    Sort-Object -Property Count -Descending