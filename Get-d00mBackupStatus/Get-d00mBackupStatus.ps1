<#
.SYNOPSIS
    Get server backup status

.DESCRIPTION
    Gets backup policy and summary from servers and creates HTML report

.EXAMPLE
    Get-d00mBackupStatus -ComputerName Server1 -OperatingSystem 2012

    This example retrieves the backup policy and summary from Server1 using
    the Server 2012 WindowsServerBackup PowerShell module and creates an HTML
    report in the current directory

.EXAMPLE
    Get-d00mBackupStatus -ComputerName Server1, Server2 -OperatingSystem 2012 -FilePath \\server1\share

    This example retrieves the backup policy and summary from Server1, Server2 using the
    Server 2012 WindowsServerBakcup PowerShell module and creates an HTML report
    in the specified file path

.EXAMPLE
    Get-ADComputer -Filter {(enabled -eq 'true') -and (operatingsystem -like '*server*') -and (location -notlike '*azure*')} -Properties name, operatingsystem | 
        select name, operatingsystem | 
        Get-d00mBackupStatus -Verbose -FilePath '\\server1\share\'

    This example retrieves the backup policy and summary from all AD servers using either
    the PSSnapin or module to create an HTML report in the specified file path

#>
function Get-d00mBackupStatus
{
    [CmdletBinding()]
    param
    (
        [alias('Name')]
        [parameter(mandatory,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

        [parameter(mandatory,
                   ValueFromPipelineByPropertyName)]
        [string[]]$OperatingSystem,

        [parameter()]
        [string]$FilePath,

        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        try
        {
            foreach ($computer in $ComputerName)
            {
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)

                $params = @{ComputerName = $computer
                            ErrorAction  = 'Stop'}

                if ($Credential -ne $Null)
                {
                    $params.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }

                if ($OperatingSystem -like '*2008*')
                {
                    $params.Add('ScriptBlock', {Add-PSSnapin -Name Windows.ServerBackup
                                                $summary = Get-WBSummary
                                                $policy = Get-WBPolicy
                                                New-Object -TypeName psobject -Property @{ComputerName = $env:COMPUTERNAME
                                                LastSuccessfulBackupTime = $summary.LastSuccessfulBackupTime
                                                LastSuccessfulBackupTargetPath = $summary.LastSuccessfulBackupTargetPath
                                                NextBackupTime = $summary.NextBackupTime
                                                VolumesToBackup = $policy.VolumesToBackup
                                                BareMetalRecovery = $policy.BMR
                                                SystemState = $policy.SystemState
                                                VssBackupOptions = $policy.VssBackupOptions} | Write-Output})
                }

                if ($OperatingSystem -like '*2012*')
                {
                    $params.Add('ScriptBlock', {Import-Module -Name WindowsServerBackup
                                                $summary = Get-WBSummary
                                                $policy = Get-WBPolicy
                                                New-Object -TypeName psobject -Property @{ComputerName = $env:COMPUTERNAME
                                                LastSuccessfulBackupTime = $summary.LastSuccessfulBackupTime
                                                LastSuccessfulBackupTargetPath = $summary.LastSuccessfulBackupTargetPath
                                                NextBackupTime = $summary.NextBackupTime
                                                VolumesToBackup = $policy.VolumesToBackup
                                                BareMetalRecovery = $policy.BMR
                                                SystemState = $policy.SystemState
                                                VssBackupOptions = $policy.VssBackupOptions} | Write-Output})
                }

                Write-Verbose -Message ('{0} : {1} : Getting Backup status' -f $cmdletName, $computer)
                $result = Invoke-Command @params
                Write-Verbose -Message ('{0} : {1} : Getting backup status complete' -f $cmdletName, $computer)

                $html = New-Object -TypeName System.Text.StringBuilder
                $html.AppendLine("
                <html>
                    <head>
                        <title>Backup Report</title>
                        <style>
                            table, tr, td {
                                border: 1px solid green;
                                border-collapse: collapse;
                            }
                            
                            tr.alt td {
                                background-color: `#171717;
                            }

                            tr.heading td {
                                font-weight: bold;
                                text-align: center;
                                font-size: larger;
                                color: white;
                                background-color: `#333333;
                            }

                            body {
                                background-color: black;
                                color: `#bdbdbd;
                                font-family: lucida consolas, monospace;
                            }
                        </style>
                    </head>
                    <body>
                        <table>
                            <tr class=`"heading`">
                                <td colspan=`"2`">$($computer) Backup Report</td>
                            </tr>
                            <tr>
                                <td>Report</td>
                                <td>$($cmdletName)</td>
                            </tr>
                            <tr>
                                <td>Date</td>
                                <td>$(Get-Date)</td>
                            </tr>
                        </table>
                        </br>
                        <table>
                            <tr class=`"heading`">
                                <td>ComputerName</td>
                                <td>LastSuccessfulBackupTime</td>
                                <td>LastSuccessfulBackupTargetPath</td>
                                <td>NextBackupTime</td>
                                <td>BareMetalRecovery</td>
                                <td>SystemState</td>
                                <td>VssBackupOptions</td>
                            </tr>
                            <tr>
                                <td>$($result.ComputerName)</td>
                                <td>$($result.LastSuccessfulBackupTime)</td>
                                <td>$($result.LastSuccessfulBackupTargetPath)</td>
                                <td>$($result.NextBackupTime)</td>
                                <td>$($result.BareMetalRecovery)</td>
                                <td>$($result.SystemState)</td>
                                <td>$($result.VssBackupOptions)</td>
                            </tr>
                            <tr class=`"heading`">
                                <td colspan=`"7`">
                                        Volumes to Backup
                                </td>
                            </tr>") | Out-Null
                foreach ($volume in $result.VolumesToBackup)
                {
                    $html.AppendLine("
                        <tr>
                            <td colspan=`"7`">$($volume)</td>
                        </tr>") | Out-Null
                }
                $html.AppendLine("
                    </table>
                </body>
                </html") | Out-Null
                $html.ToString() | Out-File -FilePath ('{0}\{1}\{1}_BackupStatusReport_{2}.html' -f $FilePath, $computer, (Get-Date -Format 'yyyyMMdd')) -Force


                Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $computer)
            }
        }
        catch
        {
            throw
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}