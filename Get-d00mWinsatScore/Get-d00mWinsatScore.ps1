<#
.SYNOPSIS
    Generate WinSat scores

.DESCRIPTION
    Run winsat.exe prepop on computers and get Win32_WinSat scores

.EXAMPLE
    Get-d00mWinsatScore

    This runs winsat.exe prepop on the local computer and returns
    the Win32_WinSat scores using default credentials

.EXAMPLE
    Get-d00mWinsatScore -ComputerName Computer1, Computer2

    This runs winsat.exe prepop on the remote computers, Computer1
    and Computer2, and returns the Win32_WinSat scores using default
    credentials

.EXAMPLE
    Get-d00mWinsatScore -Credential (Get-Credential)

    This runs winsat.exe prepop on the local computer and returns
    the Win32_WinSat scores using the specified credentials

#>
function Get-d00mWinsatScore
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

        [Parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            $sessionParams = @{ComputerName = $computer
                               ErrorAction  = 'Stop'}
            if ($Credential -ne $null)
            {
                $sessionParams.Add('Credential', $Credential)
                Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
            }
            else
            {
                Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
            }
            $session = New-PSSession @sessionParams
            $cimSession = New-CimSession @sessionParams

            Write-Verbose -Message ('{0} : {1} : Running winsat.exe prepop' -f $cmdletName, $computer)
            Invoke-Command -Session $session -ScriptBlock {
                Start-Process -FilePath winsat.exe -ArgumentList 'prepop' -NoNewWindow
            }
            Remove-PSSession -Session $session

            Write-Verbose -Message ('{0} : {1} : Getting Win32_Winsat' -f $cmdletName, $computer)
            $cimParams = @{ClassName   = 'Win32_WinSat'
                           CimSession  = $cimSession
                           ErrorAction = 'Stop'}
            $cim = Get-CimInstance @cimParams
            Remove-CimSession -CimSession $cimSession

            New-Object -TypeName psobject -Property @{ComputerName  = $computer
                                                      CPUScore      = $cim.CPUScore
                                                      D3DScore      = $cim.D3DScore
                                                      DiskScore     = $cim.DiskScore
                                                      GraphicsScore = $cim.GraphicsSCore
                                                      MemoryScore   = $cim.MemoryScore} |
                Write-Output
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}