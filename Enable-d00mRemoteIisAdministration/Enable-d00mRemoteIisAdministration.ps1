<#
.SYNOPSIS
    Enables remote management of IIS

.DESCRIPTION
    Enables remote management of IIS by...
    - Installing Web-Server WindowsFeature
    - Installing Web-Mgmt-Service WindowsFeature
    - Adds EnableRemoteManagement registry key = 1
    - Adds firewall rule to allow incoming WMSVC requests on domain profile
    - Sets WMSVC to startup type = automatic
    - Sets WMSVC status = running
    - Restarts WMSVC service

.EXAMPLE
    Enable-d00mRemoteIisAdministration -ComputerName Server1 -Credential (Get-Credential)

    This example enables remote IIS administration on Server1 using the supplied credentials.

.EXAMPLE
    Read-content c:\servers.txt | Enable-d00mRemoteIisAdministration

    This example enables remote IIS administration on the list of computers found in the file
    using the current user's credentials.

.EXAMPLE
    (Get-AdComputer -Filter {(Enabled -eq 'true') -and (OperatingSystem -like '*Server*')}).Name |
        Enable-d00mRemoteIisAdministration -Credential (Get-Credential)

    This example enables remote IIS administration on the returned computers from the Get-AdComputer cmdlet
    using the supplied credentials.

#>

function Enable-d00mRemoteIisAdministration
{
    [CmdletBinding()]
    param
    (
        #Computer(s) to enable remote IIS administration
        [parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

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
                $params = @{ComputerName = $computer
                            ErrorAction  = 'Stop'
                            ArgumentList = $cmdletName}
                if ($Credential -ne $null)
                {
                    $params.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : Using supplied credentials' -f $cmdletName)
                }
                else
                {
                    Write-Verbose -Message ('{0} : Using current user credentials' -f $cmdletName)
                }

                $result = Invoke-Command @params -ScriptBlock {
                    If ((Get-WindowsFeature -Name Web-Server).Installed -ne 'True')
                    {
                        Install-WindowsFeature -Name Web-Server
                    }

                    if ((Get-WindowsFeature -Name Web-Mgmt-Service).Installed -ne 'True')
                    {
                        Install-WindowsFeature -Name Web-Mgmt-Service
                    }

                    if (Get-Service -Name WMSVC)
                    {
                        If (!(Get-NetFirewallRule -DisplayName 'IIS Remote Management' -ErrorAction SilentlyContinue))
                        {
                            $fwParams = @{Name        = 'IIS Remote Management'
                                          DisplayName = 'IIS Remote Management'
                                          Description = 'IIS Remote Management'
                                          Enabled     = 'True'
                                          Profile     = 'Domain'
                                          Direction   = 'Inbound'
                                          Action      = 'Allow'
                                          Service     = 'wmsvc'}
                            New-NetFirewallRule @fwParams
                        }

                        $keyPath = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
                        if ((Get-ItemProperty -Path $keyPath -Name EnableRemoteManagement).EnableRemoteManagement -ne 1)
                        {
                            Set-ItemProperty -Path $keyPath -Name EnableRemoteManagement -Value 1
                        }

                        Set-Service -Name WMSVC -StartupType Automatic -Status Running
                        Restart-Service -Name WMSVC -Force
                        Write-Output $true
                    }
                    else
                    {
                        Write-Output $false
                    }
                }
                New-Object -TypeName psobject -Property @{ComputerName        = $computer
                                                          IISRemoteManagement = $result} |
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