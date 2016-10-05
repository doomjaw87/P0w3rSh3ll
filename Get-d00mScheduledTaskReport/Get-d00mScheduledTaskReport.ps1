<#
.SYNOPSIS
    Generate Scheduled Task Report

.DESCRIPTION
    Uses Schedule.Service COM Object to iterate through all scheduled
    tasks on target computers

.EXAMPLE
    Get-d00mScheduledTaskReport

    This example uses the Schedule.Service COM object to iterate through
    all scheduled tasks on the local computer and creates an HTML report
    saved in the current directory

.EXAMPLE
    Get-d00mScheduledTaskReport -ComputerName Computer1, Computer1

    This example uses the Schedule.Service COM object to iterate through
    all scheduled tasks on the remote computers, Computer1 and Computer2,
    and creates an HTML report saved in the current directory

.EXAMPLE
    Get-d00mScheduledTaskReport -ComputerName Computer1 -FilePath \\server\share
    
    This example uses the Schedule.Service COM object to iterate through
    all scheduled tasks on the remote computer, Computer1, and creates an
    HTML report saved in the specified directory
#>
function Get-d00mScheduledTaskReport
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

        [Parameter()]
        [string]$FilePath = (Get-Location)
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
        foreach ($computer in $ComputerName)
        {
            try
            {
                $sessionParams = @{ComputerName = $computer
                                   ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $sessionParams.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }
            
                $html = New-Object -TypeName System.Text.StringBuilder
                $html.AppendLine("
                    <html>
                        <head>
                            <title>$($computer) Scheduled Task Report</title>
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
                                    <td colspan=`"2`">$($computer)</td>
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
                        </br>") | Out-Null

                $html.AppendLine('
                            <table>
                                <tr class="heading">
                                    <td>Path</td>
                                    <td>State</td>
                                    <td>LastRunTime</td>
                                    <td>LastRunResult</td>
                                    <td>NextRunTime</td>
                                    <td>Enabled</td>
                                    <td>Author</td>
                                    <td>Description</td>
                                    <td>Priority</td>
                                    <td>Context</td>
                                    <td>Command</td>
                                    <td>Arguments</td>
                                    <td>RunLevel</td>
                                    <td>UserID</td>
                                </tr>') | Out-Null

                Write-Verbose -Message ('{0} : {1} : Connecting to Schedule.Service COMObject' -f $cmdletName, $computer)
                $sch = New-Object -ComObject Schedule.Service
                $sch.Connect($computer)
                $root = $sch.Getfolder('\')
                $tasks = $root.GetTasks(0)
                $counter = 1

                Write-Verbose -Message ('{0} : {1} : Iterating through scheduled tasks in root directory' -f $cmdletName, $computer)
                foreach ($task in $tasks)
                {
                    if ([bool]!($counter%2))
                    {
                        $html.AppendLine('<tr class="alt">') | Out-Null
                    }
                    else
                    {
                        $html.AppendLine('<tr>') | Out-Null
                    }
                    [xml]$xml = $task.Xml
                    $state = switch($task.State)
                    {
                        1 {'Disabled'}
                        2 {'Queued'}
                        3 {'Ready'}
                        4 {'Running'}
                        Default {'Unknown'}
                    }
                    $html.AppendLine(('
                                    <td>{0}</td>
                                    <td>{1}</td>
                                    <td>{2}</td>
                                    <td>{3}</td>
                                    <td>{4}</td>
                                    <td>{5}</td>
                                    <td>{6}</td>
                                    <td>{7}</td>
                                    <td>{8}</td>
                                    <td>{9}</td>
                                    <td>{10}</td>
                                    <td>{11}</td>
                                    <td>{12}</td>
                                    <td>{13}</td>
                                </tr>' -f $task.Path,
                                          $state,
                                          $task.LastRunTime,
                                          $task.LastTaskResult,
                                          $task.NextRunTime,
                                          $task.Enabled,
                                          $xml.Task.RegistrationInfo.Author,
                                          $xml.Task.RegistrationInfo.Description,
                                          $xml.Task.Settings.Priority,
                                          $xml.Task.Actions.Context,
                                          $xml.Task.Actions.Exec.Command,
                                          $xml.Task.Actions.Exec.Arguments,
                                          $xml.Task.Principals.Principal.RunLevel,
                                          $xml.Task.Principals.Principal.UserId
                                          )) | Out-Null
                    $counter++
                }

                Write-Verbose -Message ('{0} : {1} : Iterating through scheduled tasks in subdirectories' -f $cmdletName, $computer)
                $subFolders = $root.GetFolders(0)
                $subFolders | ForEach-Object {
                    $tasks = $_.GetTasks(0)
                    foreach ($task in $tasks)
                    {
                        if ([bool]!($counter%2))
                        {
                            $html.AppendLine('<tr class="alt">') | Out-Null
                        }
                        else
                        {
                            $html.AppendLine('<tr>') | Out-Null
                        }
                        [xml]$xml = $task.Xml
                        $state = switch($task.State)
                        {
                            1 {'Disabled'}
                            2 {'Queued'}
                            3 {'Ready'}
                            4 {'Running'}
                            Default {'Unknown'}
                        }
                        $html.AppendLine(('
                                        <td>{0}</td>
                                        <td>{1}</td>
                                        <td>{2}</td>
                                        <td>{3}</td>
                                        <td>{4}</td>
                                        <td>{5}</td>
                                        <td>{6}</td>
                                        <td>{7}</td>
                                        <td>{8}</td>
                                        <td>{9}</td>
                                        <td>{10}</td>
                                        <td>{11}</td>
                                        <td>{12}</td>
                                        <td>{13}</td>
                                    </tr>' -f $task.Path,
                                              $state,
                                              $task.LastRunTime,
                                              $task.LastTaskResult,
                                              $task.NextRunTime,
                                              $task.Enabled,
                                              $xml.Task.RegistrationInfo.Author,
                                              $xml.Task.RegistrationInfo.Description,
                                              $xml.Task.Settings.Priority,
                                              $xml.Task.Actions.Context,
                                              $xml.Task.Actions.Exec.Command,
                                              $xml.Task.Actions.Exec.Arguments,
                                              $xml.Task.Principals.Principal.RunLevel,
                                              $xml.Task.Principals.Principal.UserId
                                              )) | Out-Null
                        $counter++
                    }
                }
                $xml = $null
                $html.AppendLine('</table></body></html>') | Out-Null
                $reportName = '{0}_ScheduledTaskReport_{1}.html' -f $computer, (Get-Date -Format 'yyyyMMdd')
                $html.ToString() | Out-File -FilePath (Join-Path -Path $FilePath -ChildPath $reportName) -Force
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