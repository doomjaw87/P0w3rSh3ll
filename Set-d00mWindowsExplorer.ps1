

<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.PARAMETER

.EXAMPLE

.EXAMPLE

.EXAMPLE

#>
function Set-d00mWindowsExplorer
{
    [CmdletBinding(DefaultParameterSetName='Clean')]
    param
    (
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName,

        [parameter()]
        [System.Management.Automation.PSCredential]$Credential,

        [parameter(ParameterSetName='Clean')]
        [switch]$Clean,

        [parameter(ParameterSetName='Default')]
        [switch]$Default
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $ComputerName)
        try
        {
            $sessionParams = @{ComputerName = $ComputerName
                                ErrorAction = 'Stop'}
            if ($Credential -ne $null)
            {
                Write-Verbose -Message ('{0} : Using supplied credentials' -f $cmdletName)
                $sessionParams.Add('Credential', $Credential)
            }
            else
            {
                Write-Verbose -Message ('{0} : Using default credentials' -f $cmdletName)
            }
            $session = New-PSSession @sessionParams

            $scriptBlock = switch ($PSCmdlet.ParameterSetName)
            {
                'Clean'
                {
                    {
                        $regPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                        Set-ItemProperty -Path $regPath -Name Hidden -Value 1 -Force
                        Set-ItemProperty -Path $regPath -Name HideFileExt -Value 0 -Force
                        Set-ItemProperty -Path $regPath -Name ShowSuperHidden -Value 1 -Force
                        Set-ItemProperty -Path $regPath -Name LaunchTo -Value 0 -Force
                        Set-ItemProperty -Path $regPath -Name AutoCheckSelect -Value 0 -Force
                        Set-ItemProperty -Path $regPath -Name DontUsePowerShellOnWinX -Value 0 -Force
                        Stop-Process -Name explorer -Force
                    }
                }

                'Default'
                {
                    {
                        $regPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                        Set-ItemProperty -Path $regPath -Name Hidden -Value 0 -Force
                        Set-ItemProperty -Path $regPath -Name HideFileExt -Value 1 -Force
                        Set-ItemProperty -Path $regPath -Name ShowSuperHidden -Value 0 -Force
                        Set-ItemProperty -Path $regPath -Name LaunchTo -Value 1 -Force
                        Set-ItemProperty -Path $regPath -Name AutoCheckSelect -Value 1 -Force
                        Set-ItemProperty -Path $regPath -Name DontUsePowerShellOnWinX -Value 1 -Force
                        Stop-Process -Name explorer -Force
                    }
                }
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Remove-PSSession -Session $session
        }
        catch
        {
            throw
        }
        Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $ComputerName)
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}