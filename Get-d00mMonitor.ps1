<#
.SYNOPSIS

.DESCRIPTION
    
.EXAMPLE

.EXAMPLE

.EXAMPLE

#>

function Get-d00mComputerMonitor
{
    [CmdletBinding()]
    param
    (
        [CmdletBinding()]
        [String[]]$ComputerName = $env:COMPUTERNAME
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, 
                                                                 $start)
        $wmiParams = @{Namespace   = 'ROOT\WMI'
                       Query       = "SELECT * FROM WmiMonitorID WHERE Active='True'"
                       ErrorAction = 'Stop'}
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName,
                                                                     $computer)
            try
            {
                $monitors = Get-WmiObject @wmiParams -ComputerName $computer
                if ($monitors)
                {
                     $monitors | 
                     ForEach-Object {
                        
                     }
                }
                else
                {
                    Write-Error -Message ('{0} : {1} : Could not find any WMI monitors' -f $cmdletName,
                                                                                           $computer)
                }
            }
            catch
            {

            }
        }
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}