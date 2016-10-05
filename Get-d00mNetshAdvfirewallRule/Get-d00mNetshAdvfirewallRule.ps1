<#
.SYNOPSIS
    Get Netsh AdvFirewall rule results

.DESCRIPTION
    Using the hnetcfg.fwpolicy2 COM object, create an HTML
    report of all Windows Firewall rules

.EXAMPLE
    Get-d00mNetshAdvFirewallRule -ComputerName Computer1

    This example will use the hnetcfg.fwpolicy2 COM object to
    create an HTML report of all Windows Firewall rules on the 
    remote computer, Computer1, saved to the current directory
    using default credentials

.EXAMPLE
    'Computer1', 'Computer2' | Get-d00mNetshAdvFirewallRule -Filepath \\server1\share

    This example will use the hnetcfg.fwpolicy2 COM object to
    create an HTML report of all Windows Firewall rules on the
    piped on computer names, Computer1 and Computer2, saved to
    the specified file path using default credentials

.EXAMPLE
    'Server1' | Get-d00mNetshAdvFirewallRule -Credential (Get-Credential)

    This example will use the hnetcfg.fwpolicy2 COM object to
    create an HTML report of all Windows Firewall rules on the
    piped in computer name, Server1, saved to the current directory
    using the specified credentials

#>
function Get-d00mNetshAdvFirewallRule
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [pscredential]$Credential,

        [parameter()]
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
            $html = New-Object -TypeName System.Text.StringBuilder
            $html.AppendLine("<html>
                                <head>
                                    <title>$($computer) Firewall Rule Report</title>
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

            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            
            $sessionParams = @{ComputerName = $computer
                               ErrorAction  = 'Stop'}
            if ($Credential -ne $null)
            {
                $sessionParams.Add('Credential', $Credential)
                Write-Verbose -Message ('{0} : {1} : Using supplied credential' -f $cmdletName, $computer)
            }
            else
            {
                Write-Verbose -Message ('{0} : {1} : Using default credential' -f $cmdletName, $computer)
            }

            try
            {
                Write-Verbose -Message ('{0} : {1} : Creating remote session' -f $cmdletName, $computer)
                $session = New-PSSession @sessionParams

                Invoke-Command -Session $session -ScriptBlock {
                    (New-Object -ComObject hnetcfg.fwpolicy2).Rules |
                        Write-Output
                } | ForEach-Object {
                    $html.AppendLine(('
                        <table>
                            <tr class="heading">
                                <td colspan="2">{0}</td>
                            </tr>
                            <tr class="alt">
                                <td>Description</td>
                                <td>{1}</td>
                            </tr>
                            <tr>
                                <td>ApplicationName</td>
                                <td>{2}</td>
                            </td>
                            <tr class="alt">
                                <td>ServiceName</td>
                                <td>{3}</td>
                            </tr>
                            <tr>
                                <td>Protocol</td>
                                <td>{4}</td>
                            </tr>
                            <tr class="alt">
                                <td>LocalPorts</td>
                                <td>{5}</td>
                            </tr>
                            <tr>
                                <td>RemotePorts</td>
                                <td>{6}</td>
                            </tr>
                            <tr class="alt">
                                <td>LocalAddresses</td>
                                <td>{7}</td>
                            </tr>
                            <tr>
                                <td>RemoteAddresses</td>
                                <td>{8}</td>
                            </tr>
                            <tr class="alt">
                                <td>IcmpTypesAndCodes</td>
                                <td>{9}</td>
                            </tr>
                            <tr>
                                <td>Direction</td>
                                <td>{10}</td>
                            </tr>
                            <tr class="alt">
                                <td>Interfaces</td>
                                <td>{11}</td>
                            </tr>
                            <tr>
                                <td>InterfacesType</td>
                                <td>{12}</td>
                            </tr>
                            <tr class="alt">
                                <td>Enabled</td>
                                <td>{13}</td>
                            </tr>
                            <tr>
                                <td>Grouping</td>
                                <td>{14}</td>
                            </tr>
                            <tr class="alt">
                                <td>Profiles</td>
                                <td>{15}</td>
                            </tr>
                            <tr>
                                <td>EdgeTraversal</td>
                                <td>{16}</td>
                            </tr>
                            <tr class="alt">
                                <td>Action</td>
                                <td>{17}</td>
                            </tr>
                            <tr>
                                <td>EdgeTraversalOptions</td>
                                <td>{18}</td>
                            </tr>
                        </table>
                        </br>' -f $_.Name, 
                                  $_.Description, 
                                  $_.ApplicationName, 
                                  $_.ServiceName,
                                  $(switch($_.Protocol){6{'TCP'} 17{'UDP'} 1{'ICMPv4'} 58{'ICMPv6'}}),
                                  $_.LocalPorts,
                                  $_.RemotePorts,
                                  $_.LocalAddresses,
                                  $_.RemoteAddresses,
                                  $_.IcmpTypesAndCodes,
                                  $(switch($_.Direction){2{'Outbound'} 1{'Inbound'}}),
                                  $_.Interfaces,
                                  $_.InterfaceTypes,
                                  $_.Enabled,
                                  $_.Grouping,
                                  $(switch($_.Profiles){1{'Domain'} 2{'Private'} 3{'Domain and Private'} 4{'Public'} 5{'Public and Domain'} 6{'Public and Private'} 2147483647{'All'}}),
                                  $_.EdgeTraversal,
                                  $(switch($_.Action){0{'Block'} 1{'Allow'}}),
                                  $_.EdgeTraversalOptions
                                  )) | Out-Null
                }

                $html.ToString() | Out-File -FilePath (Join-Path -Path $FilePath -ChildPath ('{0}_AdvFirewallRuleReport_{1}.html' -f $computer, (Get-Date -Format 'yyyyMMdd')))

                Write-Verbose -Message ('{0} : {1} : Removing remote session' -f $cmdletName, $computer)
                Remove-PSSession -Session $session
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