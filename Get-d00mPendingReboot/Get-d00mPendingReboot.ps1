<#
.SYNOPSIS
    Check registry for pending reboot

.DESCRIPTION
    Check 3 registry values for pending reboots

    - HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager, PendingFileRenameOperations
    - HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing, RebootPending
    - HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update, RebootRequired

.EXAMPLE
    Get-d00mPendingReboot -ComputerName Computer1, Computer2

    This example checks the registry for pending reboots on the remote computers,
    Computer1 and Computer2, using default credentials

.EXAMPLE
    $creds = Get-Credential
    Get-Content c:\computerlist.txt | Get-d00mPendingReboot -Credential $creds

    This example checks the registry for pending reboots on the piped in list of computernames
    using the credentials specified

.EXAMPLE
    (Get-AdComputer -Filter {(Enabled -eq 'true')}).Name | Get-d00mPendingReboot

    This example checks the registry for pending reboots on the piped in collection of computernames
    from the Get-AdComputer cmdlet using the default credentials
#>
function Get-d00mPendingReboot
{
    [CmdletBinding()]
    param
    (
        [Alias('Name')]
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Mandatory)]
        [string[]]$ComputerName,

        [parameter()]
        [pscredential]$Credential
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
        foreach ($computer in $ComputerName)
        {
            try
            {
                $params = @{ComputerName = $computer
                            ErrorAction  = 'stop'}
                if ($Credential -ne $null)
                {
                    Write-Verbose -Message ('{0} : {1} : Using specified credential' -f $cmdletName, $computer)
                    $params.Add('Credential', $Credential)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credential' -f $cmdletName, $computer)
                }

                Write-Verbose -Message ('{0} : {1} : Begin checking registry for required reboot' -f $cmdletName, $computer)
                Invoke-Command @params -ScriptBlock {
                    $property = @{ComputerName = $env:COMPUTERNAME}


                    $params = @{Path        = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
                                Name        = 'PendingFileRenameOperations'
                                ErrorAction = 'SilentlyContinue'}
                    $reboot = Get-ItemProperty @params
                    if (($reboot) -and ($reboot.PendingFileRenameOperations.Length -gt 0))
                    {
                        $property.Add($params.Name, $true)
                    }
                    else
                    {
                        $property.Add($params.Name, $false)
                    }
                    $params, $reboot = $null


                    $params = @{Path        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing'
                                Name        = 'RebootPending'
                                ErrorAction = 'SilentlyContinue'}
                    $reboot = Get-ItemProperty @params
                    if (($reboot) -and ($reboot.RebootPending.Length -gt 0))
                    {
                        $property.Add('ComponentBasedServicingReboot', $true)
                    }
                    else
                    {
                        $property.Add('ComponentBasedServicingReboot', $false)
                    }
                    $params, $reboot = $null


                    $params = @{Path        = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'
                                Name        = 'RebootRequired'
                                ErrorAction = 'SilentlyContinue'}
                    $reboot = Get-ItemProperty @params
                    if (($reboot) -and ($reboot.RebootRequired.Length -gt 0))
                    {
                        $property.Add('WindowsUpdateReboot', $true)
                    }
                    else
                    {
                        $property.Add('WindowsUpdateReboot', $false)
                    }

                    Write-Output $property
                } | Write-Output

                Write-Verbose -Message ('{0} : {1} : Checking registry for required reboot complete' -f $cmdletName, $computer)
            }
            catch
            {
                throw
            }
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}