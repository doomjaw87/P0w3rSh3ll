<#
.SYNOPSIS
    Get last boot up time from computer(s)

.DESCRIPTION
    Query computer(s) Win32_OperatingSystem for LastBootUpTime

.EXAMPLE
    Get-d00mLastBootupTime

    This example returns the last boot up time for the local machine

.EXAMPLE
    Get-d00mLastBootupTime -ComputerName Computer1, Computer2 -Credential (Get-Credential)

    This example returns the last boot up time for the identified remote computers using
    the supplied credentials

.EXAMPLE
    Read-Content -Path c:\list.txt | Get-d00mLastBootupTime

    This example feeds a list of computers from the file to the function to query Win32_Computersystem
    to get the last boot up time
#>

function Get-d00mLastBootupTime
{
    [CmdletBinding()]
    param
    (
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
            try
            {
                $sessionParams = @{ComputerName = $computer
                                   ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $sessionParams.Add('Credential', $Credential)
                }
                $session = New-CimSession @sessionParams

                $cimParams = @{CimSession  = $session
                               ClassName   = 'Win32_OperatingSystem'
                               Property    = 'LastBootupTime'
                               ErrorAction = 'Stop'}
                $lastBoot  = Get-CimInstance @cimParams | 
                    Select-Object -ExpandProperty LastBootupTime
                $difference = $(Get-Date) - $lastBoot
                New-Object -TypeName psobject -Property $([ordered]@{ComputerName   = $computer
                                                                     LastBootupTime = $lastBoot
                                                                     Difference     = $difference}) |
                    Write-Output
                Remove-CimSession -CimSession $session
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