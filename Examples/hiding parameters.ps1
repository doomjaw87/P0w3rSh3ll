<####################
| HIDING PARAMETERS |
#####################

ALL VERSIONS

In the previous tip we explained how you can dump all the legal values for a PowerShell
attribute. Today we'll take a look at the [Parameter()] attribute and its value DontShow.
Take a look at this function:

#>

function Test-Something
{
    param
    (
        [string]
        [Parameter(Mandatory)]
        $Name,

        [Parameter(DontShow)]
        [Switch]
        $Internal
    )

    "You entered: $name"
    if ($internal)
    {
        Write-Warning "We are in secret test mode!"
    }
}

Test-Something -Name 'Things'

Test-Something -Name 'Secret Things' -Internal