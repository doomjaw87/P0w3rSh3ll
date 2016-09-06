<#
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
                $remoteParams = @{ComputerName = $computer}
                if ($Credential -ne $null)
                {
                    $remoteParams.Add('Credential', $Credential)
                }
                Invoke-Command @remoteParams -ScriptBlock {
                    If (!(Get-PackageProvider -Name chocolatey))
                    {
                        $localParams = @{Name         = $args[0]
                                         ProviderName = $args[0]
                                         Location     = $args[1]
                                         Trusted      = $args[2]}
                        Register-PackageSource @localParams -Force
                    }
                    else
                    {
                        Write-Warning 'Chocolatey package source already exists!'
                    }
                } -ArgumentList $params
            }
        }
        else
        {
            if (!(Get-PackageProvider -Name chocolatey))
            {
                $localParams = @{Name         = 'Chocolatey'
                                 ProviderName = 'Chocolatey'
                                 Location     = 'http://chocolatey.org/api/v2/'}
                if ($Trusted)
                {
                    $localParams.Add('Trusted', $true)
                }
                else
                {
                    $localParams.Add('Trusted', $false)
                }
            }
        }
    }

    end
    {

    }
}