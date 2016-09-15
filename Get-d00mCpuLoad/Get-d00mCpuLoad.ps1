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
    Get-Content C:\list.txt | Get-d00mCpuLoad -Credential (Get-Credential)

    This example returns the average CIM class Win32_Processor LoadPercentage
    from the list of computer names in the file c:\list.txt with the supplied
    credential.

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
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [pscredential]$Credential
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

            try
            {
                $params = @{ClassName    = 'Win32_Processor'
                            ComputerName = $computer
                            ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $params.Add('Credential', $Credential)
                    Write-Verbose ('{0} : Accessing {1} using $Credential parameter' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose ('{0} : Accessing {1} using default credentials' -f $cmdletName, $computer)
                }

                $average = Get-CimInstance @params |
                    Measure-Object -Property LoadPercentage -Average |
                    Select-Object -ExpandProperty Average

                New-Object -TypeName psobject -Property @{ComputerName = $computer
                                                          CPULoad      = $average} |
                    Write-Output
            }
            catch
            {
                throw
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