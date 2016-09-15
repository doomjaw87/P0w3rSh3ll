<#
.SYNOPSIS
    Sets the default shell to PowerShell

.DESCRIPTION
    Sets registry key to specify PowerShell as default shell.
    (HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon\Shell)
    
.EXAMPLE
    Set-d00mPowerShellDefaultShell -Credential (Get-Credential)

    This example sets PowerShell as the default shell on the local machine using
    the supplied credentials.

.EXAMPLE
    Set-d00mPowerShellDefaultShell -ComputerName Computer1, Computer2 -Credential (Get-Credential)

    This example sets PowerShell as the default shell on the remote computers using
    the supplied credentials.

.EXAMPLE
    Read-Content c:\computers.txt | Set-d00mPowerShellDefaultShell

    This example sets PowerShell as the default shell on the list of computers read from
    the file using the user's current credentials.

.EXAMPLE
    (Get-AdComputer -Filter {(Enabled -eq 'true')}).Name | Set-d00mPowerShellDefaultShell -Credential (Get-Credential)

    This example sets PowerShell as the default shell on the computers returned from the
    Get-AdComputer cmdlet using the supplied credentials.
#>

function Set-d00mPowerShellDefaultShell
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipelineByPropertyName,
                   ValueFromPipeline)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)

        $keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
        Write-Verbose -Message ('{0} : Key Path : {1}' -f $cmdletName, $keyPath)
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            try
            {
                $params = @{ComputerName = $computer
                            ErrorAction  = 'Stop'
                            ArgumentList = $keyPath}
                if ($Credential -ne $null)
                {
                    $params.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using current user credentials' -f $cmdletName, $computer)
                }

                $result = Invoke-Command @params -ScriptBlock {
                    $shellParams = @{Path  = $args[0]
                                     Name  = 'shell'
                                     Value = 'PowerShell.exe -NoExit'}
                    Set-ItemProperty @shellParams
                    
                    if ($(Get-ItemProperty -Path $args[0] -Name 'shell').Shell -eq 'PowerShell.exe -NoExit')
                    {
                        Write-Output $true
                    }
                    else
                    {
                        Write-Output $false
                    }
                }

                New-Object -TypeName psobject -Property @{ComputerName      = $computer
                                                          PowerShellDefault = $result} | 
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