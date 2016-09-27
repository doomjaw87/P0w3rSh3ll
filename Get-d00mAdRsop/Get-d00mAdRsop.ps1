#requires -Modules ActiveDirectory

<#
.SYNOPSIS
    Generates GPResult for specified computers in domain

.DESCRIPTION
    Generates GPResult reports for...

    1) Specified computers
    2) All non-server enabled Windows computers
    3) All server enabled Windows computers
    4) All enabled Windows computers

    And saves HTML report in specified directory, or current directory by default

.EXAMPLE
    Get-d00mAdRsop -ComputerName Computer1, Computer1

    This example generates a GPResult HTML report for the specified computers,
    Computer1 and Computer2, for the user set in the ManagedBy AD property
    and saves the HTML report in the current directory

.EXAMPLE
    Get-d00mAdRsop -Servers -FilePath C:\Path

    This example generates a GPResult HTML report for all enabled domain computers with
    *Server* part of the OperatingSystem AD attribute and saves the report in c:\Path

.EXAMPLE
    Get-d00mAdRsop -Computers

    This example generates a GPResult HTML report for all enabled domain computers without
    *Server* part of the OperatingSystem AD attribute and saves the reports in the current
    directory
#>
function Get-d00mAdRsop
{
    [CmdletBinding(DefaultParameterSetName='ComputerName')]
    param
    (
        [parameter(ParameterSetName='ComputerName',
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter(ParameterSetName='Computers')]
        [switch]$Computers,

        [parameter(ParameterSetName='Servers')]
        [switch]$Servers,

        [parameter(ParameterSetName='Everything')]
        [switch]$Everything,

        [parameter()]
        [string]$FilePath = (Get-Location)
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
        Write-Verbose -Message ('{0} : ParameterSetName : {1}' -f $cmdletName, $PSCmdlet.ParameterSetName)
        $adComputers = Switch ($PSCmdlet.ParameterSetName)
        {
            'ComputerName'
            {
                foreach ($computer in $ComputerName)
                {
                    Write-Verbose -Message ('{0} : Getting {1} AD object' -f $cmdletName, $computer)
                    try
                    {
                        $params = @{Properties  = 'ManagedBy'
                                    Identity    = $computer
                                    ErrorAction = 'Stop'}
                        Get-AdComputer @params
                    }
                    catch
                    {
                        throw
                    }
                }
            }

            'Computers'
            {
                Write-Verbose -Message ('{0} : Getting all computer AD objects' -f $cmdletName)
                try
                {
                    $params = @{Properties =  'ManagedBy'
                                Filter     =  {(enabled -eq 'true') -and (operatingsystem -notlike '*server*') -and (operatingsystem -like '*windows*')}
                                ErrorAction = 'Stop'}
                    Get-ADComputer @params
                }
                catch
                {
                    throw
                }
            }

            'Servers'
            {
                Write-Verbose -Message ('{0} : Getting all server AD objects' -f $cmdletName)
                try
                {
                    $params = @{Properties =  'ManagedBy'
                                Filter     =  {(enabled -eq 'true') -and (operatingsystem -like '*server*') -and (operatingsystem -like '*windows*')}
                                ErrorAction = 'Stop'}
                    Get-ADComputer @params
                }
                catch
                {
                    throw
                }
            }

            'Everything'
            {
                Write-Verbose -Message ('{0} : Getting all AD objects' -f $cmdletName)
                try
                {
                    $params = @{Properties =  'ManagedBy'
                                Filter     =  {(enabled -eq 'true') -and (operatingsystem -like '*windows*')}
                                ErrorAction = 'Stop'}
                    Get-ADComputer @params
                }
                catch
                {
                    throw
                }
            }
        }

        Write-Verbose -Message ('{0} : Begin execution on {1} AD objects' -f $cmdletName, $adComputers.Count)
        foreach ($computer in $adComputers)
        {
            try
            {
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer.Name)

                $adUser = Get-ADUser -Identity ($computer.ManagedBy)
                Write-Verbose -Message ('{0} : {1} : ManagedBy : {2}' -f $cmdletName, $computer.Name, $adUser.SamAccountName)

                $reportFileName = '{0}_{1}_{2}-gpresult.html' -f $computer.Name, $adUser.SamAccountName, (Get-date -Format 'yyyyMMdd')
                $reportFilePath = Join-Path -Path $FilePath -ChildPath $reportFileName
                
                $argument = '/s {0} /User {1} /H {2} /F' -f $computer.Name, $adUser.SamAccountName, $reportFilePath
                Start-Process -FilePath gpresult.exe -ArgumentList $argument -NoNewWindow
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