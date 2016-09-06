﻿<#
.SYNOPSIS
    Add Chocolatey as a PowerShell Package Management source

.DESCRIPTION
    Add Chocolatey (http://chocolatey.org/api/v2/) as a package source
    for PowerShell Package Management

.EXAMPLE
    Add-d00mChocolateyPackageSource

    This examples adds Chocolatey as an untrusted package source on local computer (default)

.EXAMPLE
    Add-d00mChocolateyPackageSource -Trusted

    This example adds Chocolatey as a trusted package source on local computer

.EXAMPLE
    Add-d00mChocolateyPackageSource -ComputerName 'computer1', 'computer2'

    This example adds Chocolatey as an untrusted package source (default) on the remote computers
    named Computer1 and Computer2
#>

function Add-d00mChocolateyPackageSource
{
    [CmdletBinding()]
    param
    (
        [parameter(ParameterSetName='remote')]
        [string[]]$ComputerName,

        [parameter(ParameterSetName='remote')]
        [pscredential]$Credential,

        [parameter()]
        [switch]$Trusted
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
        $params = @('Chocolatey',
                    'http://chocolatey.org/api/v2')
        If ($Trusted)
        {
            $params += $true
        }
        else
        {
            $params += $false
        }

        if ($PSCmdlet.ParameterSetName -eq 'remote')
        {
            foreach ($computer in $ComputerName)
            {
                Write-Verbose -Message ('{0}\{1} : {2} : Begin execution' -f $cmdletName, 
                                                                             $PSCmdlet.ParameterSetName, 
                                                                             $computer)
                $remoteParams = @{ComputerName = $computer
                                  ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $remoteParams.Add('Credential', $Credential)
                }

                try
                {
                    $result = Invoke-Command @remoteParams -ScriptBlock {
                        If (!(Get-PackageProvider -Name chocolatey))
                        {
                            try
                            {
                                $localParams = @{Name         = $args[0]
                                                 ProviderName = $args[0]
                                                 Location     = $args[1]
                                                 Trusted      = $args[2]
                                                 Force        = $true}
                                Register-PackageSource @localParams
                                return $true
                            }
                            catch
                            {
                                return $false
                            }
                        }
                        else
                        {
                            return $true
                        }
                    } -ArgumentList $params
                }
                catch
                {
                    $result = $false
                }
            }
        }

        else
        {
            if (!(Get-PackageProvider -Name chocolatey))
            {
                $localParams = @{Name         = 'Chocolatey'
                                 ProviderName = 'Chocolatey'
                                 Location     = 'http://chocolatey.org/api/v2/'
                                 Force        = $true}
                if ($Trusted)
                {
                    $localParams.Add('Trusted', $true)
                }
                else
                {
                    $localParams.Add('Trusted', $false)
                }

                try
                {
                    Register-PackageSource @localParams
                    $result = $true
                }
                catch
                {
                    $result = $false
                }
            }
            else
            {
                $result = $true
            }
        }

        Write-Output $result
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}