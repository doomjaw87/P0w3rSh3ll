<################################
| EXECUTING CODE WITH A TIMEOUT |
#################################

ALL VERSIONS

If you'd like to make sure some code won't execute forever, you can use background jobs to
implement a timeout. Here is a sample function:

#>

function Invoke-CodeWithTimeout
{
    param
    (
        [parameter(mandatory)]
        [scriptblock]
        $code,

        [int]
        $timeout = 5
    )

    $j = Start-Job -ScriptBlock $code
    $completed = Wait-Job $j -Timeout $timeout
    if ($completed -eq $null)
    {
        throw "Job timed out"
        Stop-Job -Job $j
    }
    else
    {
        Receive-Job -Job $j
    }
    Remove-Job -Job $j
}

# So basically, to run some code with a maximum timeout of 5 seconds, try this:
Invoke-CodeWithTimeout -code {Start-Sleep -Seconds 6; get-date} -timeout 5

<#

This approach works; however, it has a considerable overhead related to the jobs it uses. The
overhead of creating background jobs and returning the data to your foreground task may add to
the overall time. Which is why we are looking at a better approach in tomorrow's tip.

#>