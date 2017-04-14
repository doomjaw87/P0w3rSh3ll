<#########################################
| USING A POWERSHELL PARAMETER VALIDATOR |
##########################################

PowerShell function parameters support a ValidateScript attribute where you can assign
PowerShell code. The code is invoked when the parameter receives a value from a user, and
can return $True or $False. If the code returns $false, the argument is rejected.

Here is a sample that accepts file names only if the file exists in the Windows folder:

#>

function Get-SomeFile
{
    param
    (
        [parameter(mandatory)]
        [validatescript({Test-Path -Path "$env:windir\$_"})]
        $File
    )

    "$File exists in your shit."
}