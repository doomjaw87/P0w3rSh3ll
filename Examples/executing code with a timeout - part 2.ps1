<#########################################
| EXECUTING CODE WITH A TIMEOUT - PART 2 |
##########################################

All Versions

In the previous tip we implemented a timeout using PowerShell background jobs so you could
set a maximum time some code was allowed to run before it raised an exception.

Here is a more lightweight alternative that uses in-process threads rather than out-of-process
executables:

#>

function Invoke-CodeWithTimeout2
{
    param
    (
        [parameter(mandatory)]
        [scriptblock]
        $Code,
        [int]
        $Timeout = 5
    )

    $ps = [PowerShell]::Create()
    $null = $ps.AddScript($Code)
    $handle = $ps.BeginInvoke()
    $start = Get-Date
    do
    {
        $timeConsumed = (Get-Date) - $start
        if ($timeConsumed.TotalSeconds -gt $Timeout)
        {
            $ps.Stop()
            $ps.Dispose()
            throw "Job timed out."
        }
        Start-Sleep -Milliseconds 300
    } until ($handle.isCompleted)

    $ps.EndInvoke($handle)
    $ps.Runspace.Close()
    $ps.Dispose()
}


# And here is how to use the new timeout
Invoke-CodeWithTimeout2 -Code {Start-Sleep -Seconds 6; Get-Date} -Timeout 5

Invoke-CodeWithTimeout2 -Code {Start-Sleep -Seconds 3; Get-Date} -Timeout 5