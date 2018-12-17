<#####################################
| MAKING ERROR RECORDS MORE READABLE |
######################################

ALL VERSIONS

Whenever PowerShell encounters an error, it emits an Error Record with detailed information
about the problem. Unfortunately, these objects are a bit cryptic and won't show all of their
information by default. To get to the beef, a function like the below is of invaluable help:

#>


# With it, you can deceipher the error information collected in $Error
# $Error | ConvertFrom-ErrorRecord | Out-GridView


function ConvertFrom-ErrorRecord
{
    param
    (
        # we receive either a legit error record...
        [management.automation.errorrecord[]]
        [parameter(
            mandatory,
            ValueFromPipeline,
            ParameterSetName='ErrorRecord')]
        $ErrorRecord,

        # ... or a special stop exception which is raised by
        # cmdlets with -ErrorAction Stop
        [Management.Automation.ActionPreferencesStopException[]]
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName='StopException'
        )]
        $Exception
    )

    process
    {
        # if we received a stop exception in $Exception,
        # the error record is to be found inside of it
        # in all other cases. $ErrorRecord was received
        # directly
        if ($PSCmdlet.ParameterSetName -eq 'StopException')
        {
            $ErrorRecord = $Exception.ErrorRecord
        }

        # compose a new object out of the interesting properties
        # found in the error record object
        $ErrorRecord | ForEach-Object {
            [PSCustomObject]@{
                Exception = $_.Exception.Message
                Reason    = $_.CategoryInfo.Reason
                Target    = $_.CategoryInfo.TargetName
                Script    = $_.InvocationInfo.ScriptName
                Line      = $_.InvocationInfo.ScriptLineNumber
                Column    = $_.InvocationInfo.OffsetInLine
            }
        }
    }
}