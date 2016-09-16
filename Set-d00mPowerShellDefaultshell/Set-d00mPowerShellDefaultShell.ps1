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
    [CmdletBinding(DefaultParameterSetName = "Computer")]
    param
    (
        #Computer names
        [parameter(ValueFromPipelineByPropertyName = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Computer")]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        #Computer name admin credential
        [parameter(ParameterSetName = "Computer")]
        [pscredential]$Credential,

        #VM names
        [parameter(ValueFromPipelineByPropertyName = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "VM")]
        [string[]]$VMName,

        #VM admin credential
        [parameter(ParameterSetNAme = "VM")]
        [pscredential]$VMCredential,

        #Restart computer after completion
        [parameter()]
        [switch]$Restart
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
        Write-Verbose -Message ('{0} : ParameterSetName : {1}' -f $cmdletName, $PSCmdlet.ParameterSetName)

        switch ($PSCmdlet.ParameterSetName)
        {
            "Computer"
            {
                foreach ($computer in $ComputerName)
                {
                    Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
                    try
                    {
                        $params = @{ComputerName = $computer
                                    ErrorAction  = 'Stop'}

                        # Add credentials if specified
                        if ($Credential -ne $null)
                        {
                            $params.Add('Credential', $Credential)
                            Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                        }
                        else
                        {
                            Write-Verbose -Message ('{0} : {1} : Using current user credentials' -f $cmdletName, $computer)
                        }

                        # Set restart flag
                        if ($Restart)
                        {
                            $params.Add('ArgumentList', @($keyPath, $true))
                            Write-Verbose -Message ('{0} : {1} : Restarting computer after execution' -f $cmdletName, $computer)
                        }
                        else
                        {
                            $params.Add('ArgumentList', $keyPath)
                            Write-Verbose -Message ('{0} : {1} : Not restarting computer after execution' -f $cmdletName, $computer)
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

                            # Check for restart flag
                            if ($args[1] -ne $null)
                            {
                                Restart-Computer -Force
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

            "VM"
            {
                foreach ($vm in $VMName)
                {
                    Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $vm)
                    try
                    {
                        $params = @{VMName       = $vm
                                    ErrorAction  = 'Stop'}
                        if ($VMCredential -ne $null)
                        {
                            $params.Add('Credential', $VMCredential)
                            Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $vm)
                        }
                        else
                        {
                            Write-Verbose -Message ('{0} : {1} : Using current user credentials' -f $cmdletName, $vm)
                        }

                        if ($Restart)
                        {
                            $params.Add('ArgumentList', @($keyPath, $true))
                            Write-Verbose ('{0} : {1} : Restarting VM after execution' -f $cmdletName, $vm)
                        }
                        else
                        {
                            $params.Add('ArgumentList', $keyPath)
                            Write-Verbose ('{0} : {1} : Not restarting VM after execution' -f $cmdletName, $vm)
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

                            If ($args[1] -ne $null)
                            {
                                Restart-Computer -Force
                            }
                        }

                        New-Object -TypeName psobject -Property @{ComputerName      = $vm
                                                                  PowerShellDefault = $result} | 
                            Write-Output
                    }
                    catch
                    {
                        throw
                    }
                }
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