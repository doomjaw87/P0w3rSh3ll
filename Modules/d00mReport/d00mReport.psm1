<#
.SYNOPSIS
    Generates system inventory HTML report

.DESCRIPTION
    Queries useful properties from different WMI classes
    via CIM and generates an HTML report saved to the
    file system

.EXAMPLE
    Get-d00mHardwareReport

    This example generates a system inventory HTML report
    saved to the current file system location using the
    default credentials.

.EXAMPLE
    Computer1, Computer2 | Get-d00mHardwareReport

    This example generates a system inventory HTML report
    for the computer names piped in to the cmdlet saved
    to the current file system location using the default
    credentials.

.EXAMPLE
    Get-d00mHardwareReport -ComputerName Computer1 -Credential (Get-Credential)

    This example generates a systme inventory HTML report
    for Computer1 using the credentials suppied saved to
    the current file system location.

.EXAMPLE
    Get-d00mHardwareReport -FilePath c:\path\to\report

    This example generates a system inventory HTML report
    for the local machine using default credentials and saved
    to the file system path specified.
#>
function Get-d00mHardwareReport
{
    [CmdletBinding()]
    param
    (
        #Computer names to create a systems inventory report
        [parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        #File system path to save the report
        [parameter()]
        [string]$FilePath = $(Get-Location),

        #Credentials to use for querying WMI
        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            $html = New-Object -TypeName System.Text.StringBuilder
            $html.AppendLine("<html>
                                <head>
                                    <title>$($computer) Hardware Inventory</title>
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
                                            <td>Date</td>
                                        </tr>
                                        <tr>
                                            <td>$($cmdletName)</td>
                                            <td>$(Get-Date)</td>
                                        </tr>
                                    </table>
                                </br>") | Out-Null
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

                $session = New-CimSession @sessionParams

                $cimParams = @{CimSession  = $session
                               ErrorAction = 'SilentlyContinue'}

                Write-Verbose -Message ('{0} : {1} : Getting Win32_Baseboard...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_BaseBoard @cimParams
                if ($cim)
                {
                    $html.AppendLine(('
                                    <table>
                                        <tr class="heading">
                                            <td colspan="2">
                                                Win32_BaseBoard
                                            </td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Name</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Manufacturer</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Product</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>SerialNumber</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Status</td>
                                            <td>{4}</td>
                                        </tr>
                                    </table>
                                </br>' -f $cim.Name,
                                          $cim.Manufacturer,
                                          $cim.Product,
                                          $cim.SerialNumber,
                                          $cim.Status)) | Out-Null
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_Bios...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_Bios @cimParams
                if ($cim)
                {
                    $html.AppendLine(('
                                    <table>
                                        <tr class="heading">
                                            <td colspan="2">Win32_Bios</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>SerialNumber</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Manufacturer</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Name</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>PrimaryBios</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>ReleaseDate</td>
                                            <td>{4}</td>
                                        </tr>
                                        <tr>
                                            <td>Version</td>
                                            <td>{5}</td>
                                        </tr>
                                    </table>
                                </br>' -f $cim.SerialNumber,
                                          $cim.Manufacturer,
                                          $cim.Name,
                                          $cim.PrimaryBIOS,
                                          $cim.ReleaseDate,
                                          $cim.Version)) | Out-Null
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_CdRomDrive...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_CDROMDrive @cimParams
                if ($cim)
                {
                    foreach ($cd in $cim)
                    {
                        $html.AppendLine(('
                                    <table>
                                        <tr class="heading">
                                            <td colspan="2">Win32_CDROMDrive {1}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Name</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Drive</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>MediaLoaded</td>
                                            <td>{2}</td>
                                        </tr>
                                    </table>
                                </br>' -f $cd.Name,
                                          $cd.Drive,
                                          $cd.MediaLoaded)) | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_ComputerSystem...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_ComputerSystem @cimParams
                if ($cim)
                {
                    $html.AppendLine(('
                                    <table>
                                        <tr class="heading">
                                            <td colspan="2">Win32_ComputerSystem</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Caption</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>UserName</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Manufacturer</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>Model</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>SystemType</td>
                                            <td>{4}</td>
                                        </tr>
                                        <tr>
                                            <td>PrimaryOwnerName</td>
                                            <td>{5}</td>
                                        </tr>
                                    </table>
                                </br>' -f $cim.Caption,
                                          $cim.UserName,
                                          $cim.Manufacturer,
                                          $cim.Model,
                                          $cim.SystemType,
                                          $cim.PrimaryOwnerName)) | Out-Null
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_DiskDrive...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_DiskDrive @cimParams
                if ($cim)
                {
                    foreach ($disk in $cim)
                    {
                        $html.AppendLine(('
                                    <table>
                                        <tr class="heading">
                                            <td colspan="2">Win32_DiskDrive : {0}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Index</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>DeviceID</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Model</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>SerialNumber</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>InterfaceType</td>
                                            <td>{4}</td>
                                        </tr>
                                        <tr>
                                            <td>Size</td>
                                            <td>{5}</td>
                                        </tr>
                                        <tr class="alt">
                                            <td>Partitions</td>
                                            <td>{6}</td>
                                        </tr>
                                    </table>
                                </br>' -f $disk.Index,
                                          $disk.DeviceID,
                                          $disk.Model,
                                          $disk.SerialNumber,
                                          $disk.InterfaceType,
                                          $([int]$(($disk.Size)/1GB)),
                                          $disk.Partitions)) | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_LogicalDisk...' -f $cmdletName, $computer) 
                $cim = Get-CimInstance -ClassName Win32_LogicalDisk @cimParams
                if ($cim)
                {
                    foreach ($drive in $cim)
                    {
                        $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">Win32_LogicalDisk : {0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>DeviceID</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>Description</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>DriveType</td>
                                                <td>{2}</td>
                                            </tr>' -f $drive.DeviceID,
                                                      $drive.Description,
                                                      $drive.DriveType)) | Out-Null
                        if ($drive.DriveType -eq 3)
                        {
                            $percentFree = [math]::Round((($drive.Freespace)/($drive.Size))*100)
                            $status = switch ($percentFree)
                            {
                                {$_ -le 10} {'CRITICAL'}
                                {($_ -gt 10) -and ($_ -le 25)} {'WARNING'}
                                default {'OK'}
                            }
                            $html.AppendLine(('
                                            <tr>
                                                <td>VolumeName</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>FileSystem</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>FreeSpace</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>UsedSpace</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr>
                                                <td>Size</td>
                                                <td>{4}</td>
                                            <tr class="alt">
                                                <td>PercentFree</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr>
                                                <td>Status</td>
                                                <td>{6}</td>
                                            </tr>' -f $drive.VolumeName,
                                                      $drive.FileSystem,
                                                      $([int]$($($drive.FreeSpace)/1GB)),
                                                      $([int]$($($drive.Size - $drive.FreeSpace)/1GB)),
                                                      $([int]$($($drive.Size)/1GB)),
                                                      $percentFree,
                                                      $status)) | Out-Null
                        }
                        $html.AppendLine('</table>
                                        </br>') | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_NetworkAdapter...' -f $cmdletName, $computer) 
                $cim = Get-CimInstance -ClassName Win32_NetworkAdapter @cimParams -Filter "NetEnabled='True'"
                if ($cim)
                {
                    foreach ($adapter in $cim)
                    {
                        $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">Win32_NetworkAdapter {0} </td>
                                            </tr>
                                            <tr>
                                                <td>Index</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Name</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>Connection</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>DeviceID</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr>
                                                <td>MACAddress</td>
                                                <td>{4}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Manufacturer</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr>
                                                <td>AdapterType</td>
                                                <td>{6}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Speed</td>
                                                <td>{7}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $adapter.InterfaceIndex,
                                              $adapter.ProductName,
                                              $adapter.NetConnectionID,
                                              $adapter.DeviceID,
                                              $adapter.MACAddress,
                                              $adapter.Manufacturer,
                                              $adapter.AdapterType,
                                              $adapter.Speed)) | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_NetworkAdapterConfiguration...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration @cimParams -Filter "IPEnabled='True'"
                if ($cim)
                {
                    foreach ($adapter in $cim)
                    {
                        $ip = ''
                        if ($adapter.IPAddress.Count -gt 1)
                        {
                            foreach ($address in $adapter.IPAddress)
                            {
                                $ip += $address + '; '
                            }
                        }
                        else
                        {
                            $ip = $adapter.IPAddress[0]
                        }
                        
                        $gateway = ''
                        if ($adapter.DefaultIPGateway.Count -gt 1)
                        {
                            $counter = 0
                            foreach ($g in $adapter.DefaultIPGateway)
                            {
                                $gateway += $g + '; '
                            }
                        }
                        else
                        {
                            if ($adapter.DefaultIPGateway -ne $null)
                            {
                                $gateway = $adapter.DefaultIPGateway[0]
                            }
                            else
                            {
                                $gateway = 'null'
                            }
                        }

                        $dnsserverorder = ''
                        if ($adapter.DnsServerSearchOrder.Count -gt 1)
                        {
                            foreach ($dns in $adapter.DnsServerSearchOrder)
                            {
                                $dnsserverorder += $dns + '; '
                            }
                        }
                        else
                        {
                            if ($adapter.DnsServerSearchOrder -ne $null)
                            {
                                $dnsserverorder = $adapter.DnsServerSearchOrder[0]
                            }
                            else
                            {
                                $dnsserverorder = 'null'
                            }
                        }

                        $subnet = ''
                        if ($adapter.IPSubnet.Count -gt 1)
                        {
                            foreach ($subnet in $adapter.IPSubnet)
                            {
                                $subnet += $subnet + '; '
                            }
                        }
                        else
                        {
                            if ($adapter.IPSubnet -ne $null)
                            {
                                $subnet = $adapter.IPSubnet[0]
                            }
                            else
                            {
                                $subnet = 'null'
                            }
                        }

                        $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">Win32_NetworkAdapterConfiguration {0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>InterfaceIndex</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>ServiceName</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>IPAddress</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>DHCPEnabled</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>DHCPServer</td>
                                                <td>{4}</td>
                                            </tr>
                                            <tr>
                                                <td>DefaultIPGateway</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>DNSServerSearchOrder</td>
                                                <td>{6}</td>
                                            </tr>
                                            <tr>
                                                <td>WINSPrimaryServer</td>
                                                <td>{7}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>IPSubnet</td>
                                                <td>{8}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $adapter.InterfaceIndex,
                                              $adapter.ServiceName,
                                              $ip,
                                              $adapter.DHCPEnabled,
                                              $adapter.DHCPServer,
                                              $gateway,
                                              $dnsserverorder,
                                              $adapter.WINSPrimaryServer,
                                              $subnet)) | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_OperatingSystem...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_OperatingSystem @cimParams
                if ($cim)
                {
                    $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">Win32_OperatingSystem</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>BuildNumber</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>Caption</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Manufacturer</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>OSArchitecture</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>RegisteredUser</td>
                                                <td>{4}</td>
                                            </tr> 
                                            <tr>
                                                <td>SerialNumber</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Version</td>
                                                <td>{6}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $cim.BuildNumber,
                                              $cim.Caption,
                                              $cim.Manufacturer,
                                              $cim.OSArchitecture,
                                              $cim.RegisteredUser,
                                              $cim.SerialNumber,
                                              $cim.Version)) | Out-Null
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_PhysicalMemory...' -f $cmdletName, $computer) 
                $cim = Get-CimInstance -ClassName Win32_PhysicalMemory @cimParams
                if ($cim)
                {
                    foreach ($mem in $cim)
                    {
                        $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">Win32_PhysicalMemory {0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>BankLabel</td>
                                                <td>{0}</td>
                                            <tr>
                                                <td>DeviceLocator</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Capacity</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>Manufacturer</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>PartNumber</td>
                                                <td>{4}</td>
                                            </tr>
                                            <tr>
                                                <td>SerialNumber</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Speed</td>
                                                <td>{6}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $mem.BankLabel,
                                              $mem.DeviceLocator,
                                              $($mem.Capacity/1GB),
                                              $mem.Manufacturer,
                                              $mem.PartNumber,
                                              $mem.SerialNumber,
                                              $mem.Speed)) | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting WMIMonitorID...' -f $cmdletName, $computer) 
                $cim = Get-CimInstance -ClassName WMIMonitorID -Namespace root\wmi @cimParams
                if ($cim)
                {
                    $count = 0
                    foreach ($mon in $cim)
                    {
                        # check for null values
                        if (!([string]::IsNullOrEmpty($mon.ManufacturerName)))
                        {
                            $man = [System.Text.Encoding]::ASCII.GetString($mon.ManufacturerName)
                        }
                        else
                        {
                            $man = 'null'
                        }

                        if (!([string]::IsNullOrEmpty($mon.UserFriendlyName)))
                        {
                            $name = [System.Text.Encoding]::ASCII.GetString($mon.UserFriendlyName)
                        }
                        else
                        {
                            $name = 'null'
                        }

                        if (!([string]::IsNullOrEmpty($mon.SerialNumberID)))
                        {
                            $id = $mon.SerialNumberID -join ''
                        }
                        else
                        {
                            $id = 'null'
                        }

                        $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">WMIMonitorID {0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>ManufacturerName</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>UserFriendlyName</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>SerialNumberID</td>
                                                <td>{3}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $count,
                                              $man,
                                              $name,
                                              $id)) | Out-Null
                        $count++
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_Processor...' -f $cmdletName, $computer) 
                $cim = Get-CimInstance -ClassName Win32_Processor @cimParams
                if ($cim)
                {
                    $count = 0
                    foreach ($proc in $cim)
                    {
                        $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">Win32_Processor {0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Name</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>Manufacturer</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Caption</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr>
                                                <td>DeviceID</td>
                                                <td>{4}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>CurrentClockSpeed</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr>
                                                <td>NumberOfCores</td>
                                                <td>{6}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>ProcessorID</td>
                                                <td>{7}</td>
                                            </tr>
                                            <tr>
                                                <td>Status</td>
                                                <td>{8}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $count,
                                              $proc.Name,
                                              $proc.Manufacturer,
                                              $proc.Caption,
                                              $proc.DeviceID,
                                              $proc.CurrentClockSpeed,
                                              $proc.NumberOfCores,
                                              $proc.ProcessorID,
                                              $proc.Status)) | Out-Null
                        $count++
                    }
                }
                $cim = $null

                $html.ToString() | 
                    Out-File -FilePath ('{0}\{1}_HardwareReport_{2}.html' -f $FilePath, 
                                                                             $computer, 
                                                                             $(Get-Date -Format 'yyyyMMdd'))
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


<#
.SYNOPSIS
    Generates installed software HTML report

.DESCRIPTION
    Gets registry values for installed programs and
    generates an HTML report saved to the current
    file path location by default

.EXAMPLE
    Get-d00mSoftwareReport

    This example generates an installed software HTML report
    for the local computer and saved to the current file path
    location.
    
.EXAMPLE
    Get-d00mSoftwareReport -ComputerName Computer1, Computer2

    This example generates an installed software HTML report
    for the remote computers, Computer1 and Computer2, and saves
    them to the current file path location

.EXAMPLE
    'Computer1' | Get-d00mSoftwareReport -Credential (Get-Credential)

    This example generates an installed software HTML report
    for the piped in computer name using the credentials supplied and
    saves to the current file path location

.EXAMPLE
    (Get-AdComputer -Filter {(Enabled -eq 'true')}).Name | Get-d00mSoftwareReport -FilePath C:\path

    This example generates an installed software HTML report for each
    of the computer names returned from the Get-AdComputer cmdlet and saves
    them to the file path specifed
#>
function Get-d00mSoftwareReport
{
    [CmdletBinding()]
    param
    (
        #Computer names to create an installed software inventory report
        [parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        #File system path to save the report
        [parameter()]
        [string]$FilePath = $(Get-Location),

        #Credentials to use for accessing remote computer
        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
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
                                    <title>$($computer) Software Inventory</title>
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
                                            <td>Date</td>
                                        </tr>
                                        <tr>
                                            <td>$($cmdletName)</td>
                                            <td>$(Get-Date)</td>
                                        </tr>
                                    </table>
                                </br>") | Out-Null

            try
            {
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
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
                $session = New-PSSession @sessionParams

                Invoke-Command -Session $session -ScriptBlock {
                    $keys    = 'SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'
                    $reg     = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', [Microsoft.Win32.RegistryView]::Default)
                    $regKey  = $reg.OpenSubKey($keys)
                    $subKeys = $regKey.GetSubKeyNames()
                    foreach ($key in $subKeys)
                    {
                        $thisKey    = ('{0}\\{1}' -f $keys, $key)
                        $thisSubKey = $reg.OpenSubKey($thisKey)
                        
                        $name = $null
                        $name = $thisSubKey.GetValue('DisplayName')
                        if ([System.String]::IsNullOrEmpty($name))
                        {
                            $name = 'No DisplayName'
                        }

                        $version = $null
                        $version = $thisSubKey.GetValue('DisplayVersion')
                        if ([system.String]::IsNullOrEmpty($version))
                        {
                            $version = 'No DisplayVersion'
                        }

                        $location = $null
                        $location = $thisSubKey.GetValue('InstallLocation')
                        if ([System.String]::IsNullOrEmpty($location))
                        {
                            $location = 'No InstallLocation'
                        }

                        $publisher = $null
                        $publisher = $thisSubKey.GetValue('Publisher')
                        if ([System.String]::IsNullOrEmpty($publisher))
                        {
                            $publisher = 'No Publisher'
                        }

                        $comments = $null
                        $comments = $thisSubKey.GetValue('Comments')
                        if ([System.String]::IsNullOrEmpty($comments))
                        {
                            $comments = 'No Comments'
                        }
                        $props = @{DisplayName     = $name
                                   DisplayVersion  = $version
                                   InstallLocation = $location
                                   Publisher       = $publisher
                                   Comments        = $comments
                                   KeyName         = $key.ToString().Replace('{','').Replace('}','')}
                        New-Object -TypeName psobject -Property $props | 
                            Write-Output
                    }
                } | ForEach-Object {
                        $html.AppendLine(('
                            <table>
                                <tr class="heading">
                                    <td colspan="2">{0}</td>
                                </tr>
                                <tr class="alt">
                                    <td>DisplayName</td>
                                    <td>{0}</td>
                                </tr>
                                <tr>
                                    <td>DisplayVersion</td>
                                    <td>{1}</td>
                                </tr>
                                <tr class="alt">
                                    <td>InstallLocation</td>
                                    <td>{2}</td>
                                </tr>
                                <tr>
                                    <td>Publisher</td>
                                    <td>{3}</td>
                                </tr>
                                <tr class="alt">
                                    <td>Comments</td>
                                    <td>{4}</td>
                                </tr>
                                <tr>
                                    <td>KeyName</td>
                                    <td>{5}</td>
                                </tr>
                            </table>
                        </br>' -f $_.DisplayName,
                                  $_.DisplayVersion,
                                  $_.InstallLocation,
                                  $_.Publisher,
                                  $_.Comments,
                                  $_.KeyName)) | Out-Null
                    }
                $html.ToString() | 
                    Out-File -FilePath ('{0}\{1}_SoftwareReport_{2}.html' -f $FilePath, 
                                                                             $computer, 
                                                                             $(Get-Date -Format 'yyyyMMdd'))
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


<#
.SYNOPSIS
    Generates services HTML report

.DESCRIPTION
    Executes Get-Service on computers and gets the Name, DisplayName, ServiceName, Status,
    and StartType and generates an HTML report in the current file system location by default.

.EXAMPLE
    Get-d00mServiceReport

    This example gets the services on the local machine using the default credentials
    and generates an HTML report in the current file system location.

.EXAMPLE
    Get-d00mServiceReport -ComputerName Computer1, Computer2

    This example gets the services on the remote computers, Computer1 and Computer2, and generates
    an HTML report for each in the current file system location.

.EXAMPLE
    'Computer1' | Get-d00mServiceReport -Credential (Get-Credential)

    This example gets the services on the piped in computername, Computer1, using the specified
    credentials and generates an HTML report in the current file system location.

.EXAMPLe
    Get-d00mServiceReport -FilePath c:\path

    This example gets the services for the local computer using the default credentials and
    generates an HTML report saved to the specified file system path.
#>
function Get-d00mServiceReport
{
    [CmdletBinding()]
    param
    (
        #Computer names to create a services report
        [parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        #File system path to save the report
        [parameter()]
        [string]$FilePath = $(Get-Location),

        #Credentials to use for accessing remote computer
        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
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
                $html = New-Object -TypeName System.Text.StringBuilder
                $html.AppendLine("<html>
                                <head>
                                    <title>$($computer) Service Inventory</title>
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
                                            <td>Date</td>
                                        </tr>
                                        <tr>
                                            <td>$($cmdletName)</td>
                                            <td>$(Get-Date)</td>
                                        </tr>
                                    </table>
                                </br>") | Out-Null
                $params = @{ComputerName = $computer
                            ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    Write-Verbose -Message ('{0} : {1} : Using specified credentials' -f $cmdletName, $computer)
                    $params.Add('Credential', $Credential)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }
                $session = New-PSSession @params

                Invoke-Command $session -ErrorAction Stop -ScriptBlock {
                    Get-Service | 
                        Sort-Object -Property Name | 
                        ForEach-Object {
                            $svcProps = @{Name        = $_.Name
                                          DisplayName = $_.DisplayName
                                          ServiceName = $_.ServiceName
                                          Status      = $_.Status
                                          StartType   = $_.StartType}
                            New-Object -TypeName psobject -Property $svcProps |
                                Write-Output
                        }
                } | ForEach-Object {
                    $html.AppendLine(('
                                        <table>
                                            <tr class="heading">
                                                <td colspan="2">{0}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>Name</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>DisplayName</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>ServiceName</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>Status</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr class="alt">
                                                <td>StartType</td>
                                                <td>{4}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $_.Name,
                                              $_.DisplayName,
                                              $_.ServiceName,
                                              $_.Status,
                                              $_.StartType)) | Out-Null
                    }
                $html.ToString() | 
                    Out-File -FilePath ('{0}\{1}_SoftwareReport_{2}.html' -f $FilePath, 
                                                                             $computer, 
                                                                             $(Get-Date -Format 'yyyyMMdd'))
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


<#
.SYNOPSIS
    Get disk space statistics

.DESCRIPTION
    Query hard drives in Win32_LogicalDisk for size and freespace
    in GB and percent of diskspace still free using a CIM session

.EXAMPLE
    Get-d00mDiskSpace

    This example queries Win32_LogicalDisk on the local machine
    and gets freespace (GB), size (GB), and percent free for each
    disk using default credentials through a CIM session

.EXAMPLE
    Get-d00mDiskSpace -ComputerName Computer1, Computer2

    This example queries Win32_LogicalDisk on the remote computers,
    Computer1 and Computer2, and gets freespace (GB), size (GB), and 
    percent free for each disk using default credentials through CIM
    sessions

.EXAMPLE
    'Computer1' | Get-d00mDiskSpace -Credential (Get-Credential)

    This example queries Win32_LogicalDisk on the piped in computer
    name, Computer1, and gets freespace (GB), size (GB), and percent
    free for each disk using specified credentials through a CIM
    session

#>
function Get-d00mDiskSpaceReport
{
    [CmdletBinding()]
    param
    (
        #Computers to query disk space
        [parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        #Credentials to use for accessing computer
        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
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
                $cimSession = New-CimSession @sessionParams

                $cimParams = @{ClassName  = 'Win32_LogicalDisk'
                               CimSession = $cimSession
                               Filter     = 'DriveType<>5'}
                Get-CimInstance @cimParams | ForEach-Object {
                    New-Object -TypeName psobject -Property @{ComputerName = $computer
                                                              DeviceId     = $_.DeviceID
                                                              VolumeName   = $_.VolumeName
                                                              Size         = [math]::Round($_.Size/1GB)
                                                              FreeSpace    = [math]::Round($_.FreeSpace/1GB)
                                                              PercentFree  = [math]::Round(($_.FreeSpace/$_.Size)*100)}
                } | Write-Output
            }

            catch
            {
                throw
            }

            Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $computer)
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}


<#
.SYNOPSIS
    Retrieve OS and processor architecture (32 or 64)

.DESCRIPTION
    Query Win32_Processor.DataWidth and Win32_OperatingSystem.OSArchitecture for
    32 or 64-bit

.EXAMPLE
    Get-d00mArchitecture

    This example queries Win32_Processor.DataWidth and Win32_OperatingSystem.OSArchitecture
    for 32 or 64-bit on the local computer using default credentials

.EXAMPLE
    Get-d00mArchitecture -ComputerName computer1, computer2 -Credential (Get-Credential)

    This example queries Win32_Processor.DataWidth and Win32_OperatingSystem.OSArchitecture
    on the remote computers, computer1 and computer2, for 32 or 64-bit using the supplied
    credentials
#>
function Get-d00mArchitectureReport
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position=0)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

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
            Write-Verbose -Message ('{0} : {1} : Begin processing' -f $cmdletName, $computer)
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
            
            $session = New-CimSession @sessionParams

            Write-Verbose -Message ('{0} : {1} : Getting Win32_Processor.DataWidth' -f $cmdletName, $computer)
            $procArch = Get-CimInstance -CimSession $session -ClassName Win32_Processor -Property DataWidth

            Write-Verbose -Message ('{0} : {1} : Getting Win32_OperatingSystem.OSArchitecture' -f $cmdletName, $computer)
            $osArch   = Get-CimInstance -CimSession $session -ClassName Win32_OperatingSystem -Property OSArchitecture
            
            Remove-CimSession -CimSession $session

            if ($procArch.Count -gt 1)
            {
                Write-Verbose -Message ('{0} : {1} : Detected more than 1 processor' -f $cmdletName, $computer)
                foreach ($p in $procArch)
                {
                    New-Object -TypeName psobject -Property @{ComputerName          = $computer
                                                              ProcessorArchitecture = ('{0} : {1}' -f $p.DeviceID, $p.DataWidth)
                                                              OSArchitecture        = $osArch.OSArchitecture} |
                        Write-Output
                }
            }
            else
            {
                Write-Verbose -Message ('{0} : {1} : Detected 1 processor' -f $cmdletName, $computer)
                New-Object -TypeName psobject -Property @{ComputerName          = $computer
                                                          ProcessorArchitecture = ('{0} : {1}' -f $procArch.DeviceID, $procArch.DataWidth)
                                                          OSArchitecture        = $osArch.OSArchitecture} |
                    Write-Output
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


<#
.SYNOPSIS
    Generate Event Log HTML Report

.DESCRIPTION
    Iterate through available event logs for Error, Warning, or FailureAudit
    event entires generated in the past 24 hours and saves the report in the
    current directory using current credentials by default
    
.EXAMPLE
    Get-d00mEventLogReport -ComputerName Computer1

    This example iterates through available event logs on the remote computer
    Computer1 for Error, Warning, or FailureAudit event entries generated
    in the past 24 hours and saves the report in the current directory using
    current credentials

.EXAMPLE
    'Computer1', 'Computer2' | Get-d00mEventLogReport -Credential (Get-Credential)

    This example iterates through available event logs on the remote computers
    piped into the function for Error, Warning, or FailureAudit event entries
    generated in the past 24 hours and saves the report in the current directory
    using the specified credentials

.EXAMPLE
    Get-d00mEventLogReport -Credential (Get-Credential) -FilePath \\server1\share

    This example iterates through available event logs on the local computer
    for Error, Warning, or FailureAudit event entries generated in the past 24
    generated in the past 24 hours and saves the report in the specified directory
    using the specified credentials
#>
function Get-d00mEventLogReport
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

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
            try
            {
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)

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

                $session = New-PSSession @sessionParams
                $html = New-Object -TypeName System.Text.StringBuilder
                $html.AppendLine("
                <html>
                    <head>
                        <title>$($computer) Event Log Report</title>
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
                                <td>Event Log Report</td>
                            </tr>
                            <tr>
                                <td>Date Range</td>
                                <td>$((Get-Date).AddDays(-1)) - $(Get-Date)</td>
                            </tr>
                        </table>
                        </br>") | Out-Null

                $logs = Invoke-Command -Session $session -ScriptBlock {
                    Get-EventLog -List -AsString | Write-Output
                }

                Write-Verbose -Message ('{0} : {1} : Found {2} available event logs' -f $cmdletName, $computer, $logs.Count)

                foreach ($log in $logs)
                {
                    Write-Verbose -Message ('{0} : {1} : Getting {2} event log entries' -f $cmdletName, $computer, $log)
                    $events = Invoke-Command -Session $session -ScriptBlock {
                        $params = @{LogName     = $args[0]
                                    After       = $((Get-Date).AddDays(-1))
                                    EntryType   = 'Error', 'Warning', 'FailureAudit'
                                    ErrorAction = 'SilentlyContinue'}
                        Get-EventLog @params | Write-Output
                    } -ArgumentList $log
                    if ($events.Count -gt 0)
                    {
                        $html.AppendLine(('
                        <table>
                            <tr class="heading">
                                <td colspan="5"><center>{0}</center></td>
                            </tr>
                            <tr class="heading">
                                <td>TimeGenerated</td>
                                <td>EntryType</td>
                                <td>EventID</td>
                                <td>Source</td>
                                <td>Message</td>
                            </tr>' -f $log)) | Out-Null
                        $counter = 1
                        foreach ($event in $events)
                        {
                            if ([bool]!($counter%2))
                            {
                                $html.AppendLine('<tr>') | Out-Null
                            }
                            else
                            {
                                $html.AppendLine('<tr class="alt">') | Out-Null
                            }
                            $html.AppendLine(('
                                <td>{0}</td>
                                <td>{1}</td>
                                <td>{2}</td>
                                <td>{3}</td>
                                <td>{4}</td>
                            </tr>' -f $event.TimeGenerated,
                                      $event.EntryType,
                                      $event.EventID,
                                      $event.Source,
                                      $event.Message)) | Out-Null
                            $counter++
                        }
                        $html.AppendLine('</table></br>') | Out-Null
                    }
                    else
                    {
                        $html.AppendLine('
                        <table>
                            <tr class="heading">
                                <td colspan="5"><center>{0}</center>
                            </tr>
                            <tr>
                                <td>
                                    <center>
                                    No Error, Critical, Failure Audit events detected! :D
                                    </center>
                                </td>
                            </tr>
                        </table>
                        </br>' -f $log) | Out-Null
                    }
                }
                $html.AppendLine('
                    </body>
                </html>') | Out-Null

                $reportName = '{0}_EventLogReport_{1}.html' -f $computer, (Get-Date -Format 'yyyyMMdd')
                $html.ToString() | Out-File -FilePath (Join-Path -Path $FilePath -ChildPath $reportName) -Force

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


<#
.SYNOPSIS
    Generate WinSat scores

.DESCRIPTION
    Run winsat.exe prepop on computers and get Win32_WinSat scores

.EXAMPLE
    Get-d00mWinsatScore

    This runs winsat.exe prepop on the local computer and returns
    the Win32_WinSat scores using default credentials

.EXAMPLE
    Get-d00mWinsatScore -ComputerName Computer1, Computer2

    This runs winsat.exe prepop on the remote computers, Computer1
    and Computer2, and returns the Win32_WinSat scores using default
    credentials

.EXAMPLE
    Get-d00mWinsatScore -Credential (Get-Credential)

    This runs winsat.exe prepop on the local computer and returns
    the Win32_WinSat scores using the specified credentials

#>
function Get-d00mWinsatScoreReport
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter()]
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
        foreach ($computer in $ComputerName)
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
            $session = New-PSSession @sessionParams
            $cimSession = New-CimSession @sessionParams

            Write-Verbose -Message ('{0} : {1} : Running winsat.exe prepop' -f $cmdletName, $computer)
            Invoke-Command -Session $session -ScriptBlock {
                Start-Process -FilePath winsat.exe -ArgumentList 'prepop' -NoNewWindow
            }
            Remove-PSSession -Session $session

            Write-Verbose -Message ('{0} : {1} : Getting Win32_Winsat' -f $cmdletName, $computer)
            $cimParams = @{ClassName   = 'Win32_WinSat'
                           CimSession  = $cimSession
                           ErrorAction = 'Stop'}
            $cim = Get-CimInstance @cimParams
            Remove-CimSession -CimSession $cimSession

            New-Object -TypeName psobject -Property @{ComputerName  = $computer
                                                      CPUScore      = $cim.CPUScore
                                                      D3DScore      = $cim.D3DScore
                                                      DiskScore     = $cim.DiskScore
                                                      GraphicsScore = $cim.GraphicsSCore
                                                      MemoryScore   = $cim.MemoryScore} |
                Write-Output
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}


<#
.SYNOPSIS
    Generate monitor HTML report

.DESCRIPTION
    Queries WMIMonitorID to generate a HTML report

.EXAMPLE
    Get-d00mMonitorReport -ComputerName Computer1

    This example will query WMIMonitorID to generate a HTML report
    on the specified computer, Computer1, saved to the current directory

.EXAMPLE
    Get-d00mMonitorReport -ComputerName Computer1, Computer2 -FilePath \\server\share

    This example will query WMIMonitorID to generate a HTML report
    for the specified computers, Computer1 and Computer2, saved to the specified
    directory

.EXAMPLE
    $credential = Get-Credential
    Get-Content C:\list.txt | Get-d00mMonitorReport -FilePath \\server\share -Credential $credential

    This example will query WMIMonitorID to generate a HTML report
    for the piped in computer names from the list at c:\list.txt, saved to the 
    current directory by default using the specified credentials
#>

function Get-d00mMonitorReport
{
    [CmdletBinding()]
    param
    (
        [alias('name')]
        [parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName,

        [parameter()]
        [string]$FilePath = (Get-Location),

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
        $computerTimer = New-Object -TypeName System.Diagnostics.Stopwatch
        foreach ($computer in $ComputerName)
        {
            $computerTimer.Start()

            $html = New-Object -TypeName System.Text.StringBuilder
            $html.AppendLine("<html>
                                <head>
                                    <title>$($computer) Monitor Report</title>
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
                                            <td>Date</td>
                                        </tr>
                                        <tr>
                                            <td>$($cmdletName)</td>
                                            <td>$(Get-Date)</td>
                                        </tr>
                                    </table>
                                </br>") | Out-Null

            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)

            $params = @{ComputerName = $computer
                        ErrorAction  = 'Stop'}
            if ($Credential -ne $null)
            {
                $params.Add('Credential', $Credential)
                Write-Verbose -Message ('{0} : {1} : Using specified credentials' -f $cmdletName, $computer)
            }
            else
            {
                Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
            }

            Try
            {
                Write-Verbose -Message ('{0} : {1} : Opening CIM session' -f $cmdletName, $computer)
                $session = New-CimSession @params

                Write-Verbose -Message ('{0} : {1} : Getting root/WMI/WmiMonitorID properties' -f $cmdletName, $computer)
                $cimParams = @{CimSession = $session
                               ClassName  = 'WmiMonitorID'
                               Namespace  = 'root/WMI'}
                Get-CimInstance @cimParams | ForEach-Object {
                    if ($_.UserFriendlyName)
                    {
                        $html.AppendLine(('
                        <table>
                            <tr class="heading">
                                <td colspan="2">{0}</td>
                            </tr>
                            <tr class="alt">
                                <td>UserFriendlyName</td>
                                <td>{1}</td>
                            </tr>
                            <tr>
                                <td>SerialNumber</td>
                                <td>{2}</td>
                            </tr>
                            <tr class="alt">
                                <td>ProductCodeID</td>
                                <td>{3}</td>
                            </tr>
                            <tr>
                                <td>ManufacturerName</td>
                                <td>{4}</td>
                            </tr>
                            <tr class="alt">
                                <td>Active</td>
                                <td>{5}</td>
                            </tr>
                            <tr>
                                <td>YearOfManufacture</td>
                                <td>{6}</td>
                            </tr>
                        </table>
                        </br>' -f $_.InstanceName,
                                  [System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName),
                                  [System.Text.Encoding]::ASCII.GetString($_.SerialNumberID),
                                  [System.Text.Encoding]::ASCII.GetString($_.ProductCodeID),
                                  [System.Text.Encoding]::ASCII.GetString($_.ManufacturerName),
                                  $_.Active,
                                  $_.YearOfManufacture)) | Out-Null
                    }
                }
                $html.AppendLine('</body></html>') | Out-Null

                Write-Verbose -Message ('{0} : {1} : Removing CIM session' -f $cmdletName, $computer)
                Remove-CimSession -CimSession $session

                Write-Verbose -Message ('{0} : {1} : Saving HTML report to {2}' -f $cmdletName, $comuter, $FilePath)
                $html.ToString() | Out-File -FilePath (Join-Path -Path $FilePath -ChildPath ('{0}_MonitorReport_{1}.html' -f $computer, $(Get-Date -Format 'yyyyMMdd'))) -Force
            }
            catch
            {
                throw
            }
            $computerTimer.Stop()
            Write-Verbose -Message ('{0} : {1} : End execution. {2} ms' -f $cmdletName, $computer, $computerTimer.ElapsedMilliseconds)
            $computerTimer.Reset()
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}