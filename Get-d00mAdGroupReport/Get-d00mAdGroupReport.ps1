#requires -modules ActiveDirectory

<#
.SYNOPSIS
    Active Directory group HTML report

.DESCRIPTION
    Generate HTML report on Active Directory group's properties and members

.EXAMPLE
    Get-d00mAdGroupReport

    This example will generate a HTML report on all Active Directory groups
    properites and members saved to the current directory

.EXAMPLE
    Get-d00mAdGroupReport -GroupName Group1, Group2 -FilePath \\server1\share

    This example will generate a HTML report on the Group1 and Group2
    Active Directory groups properties and members saved to the specified
    directory
#>

function Get-d00mAdGroupReport
{
    [CmdletBinding()]
    param
    (
        [Alias('Name')]
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$GroupName,

        [parameter()]
        [string]$FilePath
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
            $html = New-Object -TypeName System.Text.StringBuilder
            $html.AppendLine("
            <html>
                <head>
                    <title>d00m AD Group Report</title>
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
                            <td colspan=`"2`">d00m AD Group Report</td>
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

            if ($GroupName -eq $null)
            {
                Write-Verbose -Message ('{0} : GroupName is null. Getting all AD groups' -f $cmdletName)
                $GroupName = (Get-ADGroup -Filter *).Name
            }
        
            if ($FilePath -eq '')
            {
                $FilePath = (Get-Location)
                Write-Verbose -Message ('{0} : FilePath is null. Saving report to current directory' -f $cmdletName)
            }

            $GroupName = $GroupName | Sort-Object

            foreach ($group in $GroupName)
            {
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $group)

                Write-Verbose -Message ('{0} : {1} : Getting properties' -f $cmdletName, $group)
                $adGroup = Get-AdGroup -Identity $group -Properties *
                $html.AppendLine(('
                    <table>
                        <tr class="heading">
                            <center>
                                <td colspan="2">{0}</td>
                            </center>
                        </tr>
                        <tr>
                            <td>DistinguishedName</td>
                            <td>{1}</td>
                        </tr>
                        <tr>
                            <td>GroupCategory</td>
                            <td>{2}</td>
                        </tr>
                        <tr>
                            <td>GroupScope</td>
                            <td>{3}</td>
                        </tr>
                        <tr>
                            <td>SID</td>
                            <td>{4}</td>
                        </tr>
                        <tr>
                            <td>Description</td>
                            <td>{5}</td>
                        </tr>
                        <tr>
                            <td>WhenCreated</td>
                            <td>{6}</td>
                        </tr>
                        <tr>
                            <td>WhenChanged</td>
                            <td>{7}</td>
                        </tr>
                        <tr class="heading">
                            <center>
                                <td colspan="2">Members</td>
                            </center>
                        </tr>' -f $adGroup.Name, 
                                  $adGroup.DistinguishedName, 
                                  $adGroup.GroupCategory, 
                                  $adGroup.GroupScope, 
                                  $adGroup.SID, 
                                  $adGroup.Description,
                                  $adGroup.WhenCreated,
                                  $adGroup.WhenChanged)) | Out-Null
            
                Write-Verbose -Message ('{0} : {1} : Getting members' -f $cmdletName, $group)
                $members = Get-ADGroupMember -Identity $adGroup
                foreach ($member in $members)
                {
                    $html.AppendLine(('
                        <tr>
                            <td colspan="2">{0}</td>
                        </tr>' -f $member.DistinguishedName)) | Out-Null
                }
                $html.AppendLine('
                    </table>
                    </br>') | Out-Null

                Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $group)
            }

            $reportName = 'ADGroupReport_{0}.html' -f (Get-Date -Format 'yyyyMMdd')
            $html.ToString() | Out-File -FilePath (Join-Path -Path $FilePath -ChildPath $reportName) -Force
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