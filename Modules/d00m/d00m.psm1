function Connect-d00mFrontera
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [string]$ConnectionName = 'FS-VPN',

        [parameter()]
        [string]$ComputerName   = 'fs-it-admin.frontera.msft'
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
        if (!(Get-NetIPInterface -InterfaceAlias $ConnectionName -ErrorAction SilentlyContinue))
        {
            $params = @{FilePath     = 'rasdial.exe'
                        NoNewWindow  = $true
                        ArgumentList = $ConnectionName
                        ErrorAction  = 'Stop'
                        Wait         = $true}
            Start-Process @params
            Write-Verbose -Message ('{0} : Connected to VPN : {1}' -f $cmdletName,
                                                                      $ConnectionName)
        }
        else
        {
            Write-Warning -Message ('Already connected to {0}' -f $ConnectionName)
        }

        Write-Verbose -Message ('{0} : Connecting RDP : {1}' -f $cmdletName,
                                                                $ComputerName)
        $params = @{ComputerName = $ComputerName
                    Count        = 1
                    ErrorAction  = 'SilentlyContinue'}
        While (!(Test-Connection @params))
        {
            Write-Verbose -Message ('{0} : Could not find {1}... waiting...' -f $cmdletName,
                                                                                $ComputerName)
            Start-Sleep -Seconds 1
        }
        Start-Process -FilePath mstsc.exe -ArgumentList "/v $ComputerName"
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}

function Disconnect-d00mFrontera
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [string]$ConnectionName = 'FS-VPN'
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
        if (Get-NetIPInterface -InterfaceAlias $ConnectionName -ErrorAction SilentlyContinue)
        {
            $params = @{FilePath     = 'rasdial.exe'
                        NoNewWindow  = $true
                        ArgumentList = '/d'
                        ErrorAction  = 'SilentlyContinue'
                        Wait         = $true}
            Start-Process @params
        }
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}

<#
.SYNOPSIS
    Creates new BOFH-style excuses

.DESCRIPTION
    Randomly generates BOFH-style excuses from 3 different word lists

.EXAMPLE
    Get-d00mExcuse

    This example outputs a single randomly generated BOFH-style excuse

.EXAMPLE
    Get-d00mExcuse -Count 10

    This example outputs 10 randly generated BOFH-style excuses

.EXAMPLE
    Get-d00mExcuse -Speak

    This example uses the speech synthesizer to speak the output of 
    the randomly generated BOFH-style excuse
#>
function Get-d00mExcuse
{
    [CmdletBinding()]
    param
    (
        #Number of excuses to generate
        [parameter()]
        [int]$Count = 1,

        #Specify if the computer should speak the excuse
        [parameter()]
        [switch]$Speak
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)
        $counter = 1
    }

    process
    {
        $list1 = @("Temporary", "Intermittant", "Partial",
            "Redundant", "Total", "Multiplexed",
            "Inherent", "Duplicated", "Dual-Homed",
            "Synchronous", "Bidirectional", "Serial",
            "Asynchronous", "Multiple", "Replicated",
            "Non-Replicated", "Unregistered", "Non-Specific",
            "Generic", "Migrated", "Localized",
            "Resignalled", "Dereferenced", "Nullified",
            "Aborted", "Serious", "Minor",
            "Major", "Extraneous", "Illegal",
            "Insufficient", "Viral", "Unsupported",
            "Outmoded", "Legacy", "Permanent",
            "Invalid", "Depreciated", "Virtual",
            "Unreportable", "Undetermined", "Undiagnosable",
            "Unfiltered", "Static", "Dynamic",
            "Delayed", "Immediate", "Nonfatal",
            "Fatal", "Non-valid", "Unvalidated",
            "Non-static", "Unreplicatable", "Non-serious")
        Write-Verbose -Message ('{0} : list1 count : {1}' -f $cmdletName, $list1.Count)

        $list2 = @("Array", "Systems", "Hardware",
            "Software", "Firmware", "Backplane",
            "Logic-Subsystem", "Integrity", "Subsystem",
            "Memory", "Comms", "Integrity",
            "Checksum", "Protocol", "Parity",
            "Bus", "Timing", "Synchronization",
            "Topology", "Transmission", "Reception"
            "Stack", "Framing", "Code",
            "Programming", "Peripheral", "Environmental",
            "Loading", "Operation", "Parameter",
            "Syntax", "Initialization", "Execution",
            "Resource", "Encryption", "Decryption",
            "File", "Precondition", "Authentication",
            "Paging", "Swapfile", "Service",
            "Gateway", "Request", "Proxy",
            "Media", "Registry", "Configuration",
            "Metadata", "Streaming", "Retrieval",
            "Installation", "Library", "Handler")
        Write-Verbose -Message ('{0} : list2 count : {1}' -f $cmdletName, $list2.Count)

        $list3 = @("Interruption", "Destabilization", "Destruction",
            "Desynchronization", "Failure", "Dereferencing",
            "Overflow", "Underflow", "Packet",
            "Interrupt", "Corruption", "Anomoly",
            "Seizure", "Override", "Reclock",
            "Rejection", "Invalidation", "Halt",
            "Exhaustion", "Infection", "Incompatibility",
            "Timeout", "Expiry", "Unavailability",
            "Bug", "Condition", "Crash",
            "Dump", "Crashdump", "Stackdump",
            "Problem", "Lockout")
        Write-Verbose -Message ('{0} : list3 count : {1}' -f $cmdletName, $list3.Count)

        if ($Speak)
        {
            Add-Type -AssemblyName System.Speech
            $voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
            $voice.SelectVoiceByHints('Female')
        }

        while ($counter -le $Count)
        {
            $message = '{0} {1} {2}' -f (Get-Random -InputObject $list1),
                                        (Get-Random -InputObject $list2),
                                        (Get-Random -InputObject $list3)
            $message | Write-Output
            if ($Speak)
            {
                $voice.Speak($message)
            }
            $counter++
        }
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}

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
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)
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
                    $html.AppendLine(('
                                    <table>
                                        <tr class="heading">
                                            <td colspan="2">Win32_CDROMDrive</td>
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
                                </br>' -f $cim.Name,
                                          $cim.Drive,
                                          $cim.MediaLoaded)) | Out-Null
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
                        if ($drive.DriveType -ne 5)
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
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
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
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)
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
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
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
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, 
                                                                 $start)
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
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}



function Get-d00mRandomColor
{
    $(switch(Get-Random -Minimum 1 -Maximum 15)
    {
        1  {'Gray'}
        2  {'Blue'}
        3  {'Green'}
        4  {'Cyan'}
        5  {'Red'}
        6  {'Magenta'}
        7  {'Yellow'}
        8  {'White'}
        9  {'Black'}
        10 {'DarkBlue'}
        11 {'DarkGreen'}
        12 {'DarkCyan'}
        13 {'DarkRed'}
        14 {'DarkMagenta'}
        15 {'DarkYellow'}
    }) | Write-Output
}
function Get-d00mRandomSpace
{
    $(switch(Get-Random -Minimum 1 -Maximum 15)
    {
        1  {' '}
        2  {'  '}
        3  {'   '}
        4  {'    '}
        6  {'     '}
        7  {'      '}
        8  {'       '}
        9  {'        '}
        10 {'         '}
        11 {'          '}
        12 {'           '}
        13 {'            '}
        14 {'             '}
        15 {'              '}
    }) | Write-Output
}
function New-d00mColorFlood
{
    while ($true)
    {
        $params = @{BackgroundColor = $(Get-d00mRandomColor)
                    NoNewLine       = $true}
        Write-Host $(Get-d00mRandomSpace) @params
    }
}