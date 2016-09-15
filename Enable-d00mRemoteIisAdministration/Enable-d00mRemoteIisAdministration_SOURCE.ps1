function Enable-d00mRemoteIisAdministration
{
    [cmdletbinding()]
    param
    (
        [parameter(mandatory,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    begin
    {
        Write-Verbose "$($PSCmdlet.MyInvocation.MyCommand.Name) : Begin execution"
        $credential = Get-Credential -Message 'Remote administrator credential' -UserName 'frontera\stratadmin'
    }

    process
    {
        ForEach ($computer in $ComputerName)
        {
            Write-Verbose "$($PSCmdlet.MyInvocation.MyCommand.Name) : $computer : Begin execution"
            $result = Invoke-Command -ComputerName $computer -ScriptBlock {
                
                If (!((Get-WindowsFeature -Name Web-Server).Installed -eq 'True'))
                {
                    Install-WindowsFeature -Name Web-Server
                }
                If (!((Get-WindowsFeature -Name Web-Mgmt-Service).Installed -eq 'True'))
                {
                    Install-WindowsFeature -Name Web-Mgmt-Service
                }
                If (Get-Service -Name WMSVC)
                {
                    If (!(Get-NetFirewallRule -DisplayName 'IIS Remote Management' -ErrorAction SilentlyContinue))
                    {
                        $params = @{Name        = 'IIS Remote Management'
                                    DisplayName = 'IIS Remote Management'
                                    Description = 'IIS Remote Management'
                                    Enabled     = 'True'
                                    Profile     = 'Domain'
                                    Direction   = 'Inbound'
                                    Action      = 'Allow'
                                    Service     = 'wmsvc'}
                        New-NetFirewallRule @params
                    }
                    If (!((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement).EnableRemoteManagement -eq 1))
                    {
                        Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1
                    }
                    Set-Service -Name WMSVC -StartupType Automatic -Status Running
                    Restart-Service -Name WMSVC -Force
                    Write-Output 'Enabled'
                }
                Else
                {
                    Write-Output 'Can not find WMSVC service'
                }
            }
            $properties = @{ComputerName        = $computer
                            IISRemoteManagement = $result}
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }

    end
    {
        Write-Verbose "$($PSCmdlet.MyInvocation.MyCommand.Name) : End execution"
    }
}