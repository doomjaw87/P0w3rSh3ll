﻿<#########################
| Cmdlet Error Reporting |
#########################>

# These will error and flood the console with red error text
$data1 = Get-ChildItem -Path C:\NotARealDirectory -Filter *.ps1
$data2 = Get-Process -FileVersionInfo


# These will still error but not flood the console with red error text
$data1 = Get-ChildItem -Path C:\NotARealDirectory -Filter *.ps1 -ErrorAction SilentlyContinue -ErrorVariable errorList
$data2 = Get-Process -FileVersionInfo -ErrorAction SilentlyContinue -ErrorVariable +errorList

# The ErrorVariable errorList will then be available to do whatever you want with it
$issues = $errorList.CategoryInfo | Select-Object -Property Category, TargetName
$issues




<###################################
| Catching Errors from Native EXEs |
####################################

Whenever the console application emits an error, it goes through console output channel #2.
Since this channel is redirected to the regular output in the example above, PowerShell
receives it. Whenever the ErrorActionPreference is set to "Stop," PowerShell turns any input
from that channel into a .NET RemoteException that you can catch.

Here is a framework to use when you'd like to catch console application errors:
#>

try
{
    # Save current ErrorActionPreference
    $oldEAP = $ErrorActionPreference

    # Set ErrorActionPreference to Stop
    $ErrorActionPreference = 'Stop'

    # Run the console exe that might emit an error and redirect the error
    # channel #2 to the output channel #1
    net use failure 2>&1
}
catch [System.Management.Automation.RemoteException]
{
    # Catch the error emitted by the EXE
    $errmsg = $_.Exception.Message
    Write-warning $errmsg
}
finally
{
    # Reset the ErrorActionPrefence to previous value
    $ErrorActionPreference = $oldEAP
}



<#################################################
| Advanced Error Handling: Rethrowing Exceptions |
##################################################

When you handle errors, you may sometimes want to replace the original
exception with your own.
#>

function Do-Something
{
    # This function uses internal error handling
    try
    {
        Get-Process -Name NotThereOhWell -ErrorAction Stop
    }
    # Catch this error type
    catch [Microsoft.PowerShell.Commands.ProcessCommandException]
    {
        $oldE = $_.Exception

        # Handle the error, OR SHOWN HERE: issue a new exception to the caller
        $newE = New-Object -TypeName System.InvalidOperationException('Do- Something: A fatal error occured', $oldE)
        throw $newE
    }
}

# Function will encounter an internal error
# Error message shows error message generated by function instead
Do-Something


# If the caller used an error handler, too, this what would happen:
try
{
    Do-Something
}
catch
{
    [pscustomobject]@{
        Message = $_.Exception.Message
        OriginalMessage = $_.Exception.InnerException.Message
    }
}
# So the caller can see the error message returned, plus also the 
# original error message received by Do-Something internally