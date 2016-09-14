<#
.SYNOPSIS
    Get average CPU load from computer(s)

.DESCRIPTION
    Gets CIM class Win32_Processor and measures average LoadPercentage from
    localhost by default, or remote machine(s)

.EXAMPLE
    Get-d00mCpuLoad

    This example returns the average CIM class Win32_Processor LoadPercentage 
    from the local computer

.EXAMPLE
    Get-d00mCpuLoad -ComputerName 'Computer1', 'Computer2', 'Computer3'
    
    This example returns the average CIM class Win32_Processor LoadPercentage
    from the remote computers- Computer1, Computer2, Computer3

.EXAMPLE
    Get-Content C:\list.txt | Get-d00mCpuLoad

    This example returns the average CIM class Win32_Processor LoadPercentage
    from the list of computer names in the file c:\list.txt

.EXAMPLE
    Get-AdComputer -Filter {(Enabled -eq 'true')} | Get-d00mCpuLoad

    This example returns the average CIM class Win32_Processor LoadPercentage
    from the enabled computers returned from the Get-AdComputer cmdlet
#>

function Get-d00mCpuLoad
{
    [cmdletbinding()]
    param
    (
        # Name(s) of computers to query
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, 
                                                                 $start)
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            $average = try
            {
                Get-CimInstance -ClassName Win32_Processor -ComputerName $computer -ErrorAction Stop |
                    Measure-Object -Property LoadPercentage -Average |
                    Select-Object -ExpandProperty Average
            }
            catch
            {
                'Error reaching {0}' -f $computer
            }
            New-Object -TypeName psobject -Property @{ComputerName = $computer
                                                      CPULoad      = $average} |
                Write-Output
        }
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}