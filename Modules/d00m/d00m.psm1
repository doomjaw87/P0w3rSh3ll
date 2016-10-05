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
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
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
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
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
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
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
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
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
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $counter = 1
        $timer.Start()
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
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
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


<#
.SYNOPSIS
    Say some things!

.DESCRIPTION
    Use the SpeechSynthesizer object to speak specified text    

.EXAMPLE
    Get-d00mSayThings 'Hello world!'

    This example gets the first female installed voice and uses
    it to synthesize 'Hello world'

.EXAMPLE
    'Sup world' | Get-d00mSayThings -Gender Male

    This example passes the piped-in string to the first male
    installed voice and synthesizes 'Sup world'
#>
function Get-d00mSayThings
{
    [cmdletbinding()]
    param
    (
        #Things you want me to say
        [parameter(mandatory = $true, 
                   ValueFromPipeline = $true, 
                   Position=0)]
        [string[]]$Things,

        #Gender of speaker voice
        [ValidateSet('Male','Female')]
        [parameter()]
        [string]$Gender = 'Female'
    )

    begin
    {
        Add-Type -AssemblyName System.Speech
        $voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
        $voice.SelectVoiceByHints($Gender)
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        foreach ($thing in $Things)
        {
            Write-Verbose -Message ('{0} : Speaking {1}' -f $cmdletName, $thing)
            $props = @{Spoken = $thing
                       Gender = $Gender}
            try
            {
                $voice.Speak($thing)
                $props.Add('Success', $true)
            }
            catch
            {
                $props.Add('Success', $false)
            }
            $obj = New-Object -TypeName psobject -Property $props
            Write-Output -InputObject $obj
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : Killing $voice object' -f $cmdletName)
        $voice.Dispose()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}


<#
.SYNOPSIS
    Add Chocolatey as a package source

.DESCRIPTION
    Adds Chocolatey as a package source on computers and
    sets if its a trusted repository or not

.EXAMPLE
    Add-d00mChocolateyPackageSource -Trusted

    This example adds Chocolatey as a trusted package source
    on the local computer

.EXAMPLE
    Add-d00mChocolateyPackageSource -ComputerName Computer1, Computer2

    This example adds Chocolatey as an untrusted package source
    on the remote computers, Computer1 and Computer2

.EXAMPLE
    'Computer1' | Add-d00mChocolateyPackageSource -Trusted -Credential (Get-Credential)

    This example adds Chocolatey as a trusted package source on
    the piped in computer, Computer1, using the specified credentials

#>
function Add-d00mChocolateyPackageSource
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [switch]$Trusted,

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
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            
                $sessionParams = @{ComputerName = $computer
                                   ErrorAction  = 'Stop'
                                   ArgumentList = $Trusted}
                if ($Credential -ne $null)
                {
                    $sessionParams.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }

                $result = Invoke-Command @sessionParams -ScriptBlock {
                    If (!(Get-PackageProvider -Name chocolatey))
                    {
                        try
                        {
                            $params = @{Name         = 'Chocolatey'
                                        ProviderName = 'Chocolatey'
                                        Location     = 'https://chocolatey.org/api/v2'
                                        Trusted      = $args[0]
                                        Force        = $true}
                            Register-PackageSource @params
                            Write-Output $true
                        }
                        catch
                        {
                            Write-Output $false
                        }
                    }
                    else
                    {
                        Write-Output $true
                    }
                }

                New-Object -TypeName psobject -Property @{ComputerName     = $computer
                                                          ChocolateyResult = $result
                                                          Trusted          = $Trusted} |
                    Write-Output

                Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $computer)
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
    Creates a new secure password

.DESCRIPTION
    Creates a randomly generated password using ASCII characters

.EXAMPLE
    New-d00mPassword

    This example will generate a random password that is 10
    characters long (default length)

.EXAMPLE
    New-d00mPassword -Lenth 50

    This example will generate a random password that is 50
    characters long
#>
function New-d00mPassword
{
    [CmdletBinding()]
    param
    (
        #Password length
        [parameter()]
        [ValidateScript({$_ -gt 0})]
        [int]$Length = 10
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
        Write-Verbose -Message ('{0} : Generating {1} length password' -f $cmdletName, $Length)
        $ascii = New-Object -TypeName System.Collections.ArrayList
        $a = 33
        while ($a -le 126)
        {
            $ascii.Add([char][byte]$a) | Out-Null
            $a++
        }
        
        $password = New-Object -TypeName System.Text.StringBuilder
        $counter = 1
        while ($counter -le $Length)
        {
            $password.Append(($ascii | Get-Random)) | Out-Null
            $counter++
        }

        Write-Output $password.ToString()
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}


function New-d00mShortcutCheatSheet
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [string]$FilePath = (Get-Location)
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
        $html = New-Object -TypeName System.Text.StringBuilder
        $html.AppendLine('<html>
                            <head>
                                <title>Shortcuts Cheat Sheet</title>
                                <style>
                                    table, tr, td {
                                        border: 1px solid green;
                                        border-collapse: collapse;
                                    }

                                    tr.alt td {
                                        background-color: #171717;
                                    }

                                    tr.heading td {
                                        font-weight: bold;
                                        text-align: center;
                                        font-size: larger;
                                        color: white;
                                        background-color: #333333;
                                    }

                                    body {
                                        background-color: black;
                                        color: #bdbdbd;
                                        font-family: lucida consolas, monospace;
                                    }
                                </style>
                            </head>
                            <body>
                                <table>
                                    <tr class="heading">
                                        <td>Utility</td>
                                        <td>Shortcut</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Add Hardware Wizard</td>
                                        <td>hdwwiz.cpl</td>
                                    </tr>
                                    <tr>
                                        <td>Administrative Tools</td>
                                        <td>control admintools</td>
                                    </tr>
                                    <tr clas="alt">
                                        <td>Calculator</td>
                                        <td>calc</td>
                                    </tr>
                                    <tr>
                                        <td>Command Prompt</td>
                                        <td>cmd</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Computer Management</td>
                                        <td>compmgmt.msc</td>
                                    </tr>
                                    <tr>
                                        <td>Control Panel</td>
                                        <td>control.exe</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Date and Time</td>
                                        <td>timedate.cpl</td>
                                    </tr>
                                    <tr>
                                        <td>Device Manager</td>
                                        <td>devmgmt.msc</td>
                                    </td>
                                    <tr class="alt">
                                        <td>Devices and Printers</td>
                                        <td>control printers</td>
                                    </tr>
                                    <tr>
                                        <td>Dial-In</td>
                                        <td>rasphone</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Disk Cleanup Utility</td>
                                        <td>cleanmgr</td>
                                    </tr>
                                    <tr>
                                        <td>Disk Defragment</td>
                                        <td>dfrg.msc</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Disk Management</td>
                                        <td>diskmgmt.msc</td>
                                    </tr>
                                    <tr>
                                        <td>Disk Partition Manager</td>
                                        <td>diskmgmt.msc</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Event Viewer</td>
                                        <td>eventvwr</td>
                                    </tr>
                                    <tr>
                                        <td>Folders Properties</td>
                                        <td>control folders</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Explorer</td>
                                        <td>Win+e</td>
                                    </tr>
                                    <tr>
                                        <td>Google Chrome</td>
                                        <td>chrome</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Group Policy Editor</td>
                                        <td>gpedit.msc</td>
                                    </tr>
                                    <tr>
                                        <td>Internet Explorer</td>
                                        <td>iexplorer</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Internet Properties</td>
                                        <td>inetcpl.cpl</td>
                                    </tr>
                                    <tr>
                                        <td>Local Security Settings</td>
                                        <td>secpol.cpl</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Local Users and Groups</td>
                                        <td>lusrmgr.msc</td>
                                    </tr>
                                    <tr>
                                        <td>Network Connections</td>
                                        <td>ncpa.cpl</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Notepad</td>
                                        <td>notepad</td>
                                    </tr>
                                    <tr>
                                        <td>Office Excel</td>
                                        <td>excel</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Office Outlook</td>
                                        <td>outlook</td>
                                    </tr>
                                    <tr>
                                        <td>Office Word</td>
                                        <td>winword</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Performance Monitor</td>
                                        <td>perfmon</td>
                                    </tr>
                                    <tr>
                                        <td>PowerShell</td>
                                        <td>powershell</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Power Options</td>
                                        <td>powercfg.cpl</td>
                                    </tr>
                                    <tr>
                                        <td>Registry Editor</td>
                                        <td>regedit</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Remote Desktop Connections</td>
                                        <td>mstsc</td>
                                    </tr>
                                    <tr>
                                        <td>Resource Monitor</td>
                                        <td>resmon</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Restart computer</td>
                                        <td> shutdown /r</td>
                                    </tr>
                                    <tr>
                                        <td>Resultant Set of Policy</td>
                                        <td>rsop.msc</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Security Center</td>
                                        <td>wscui.cpl</td>
                                    </tr>
                                    <tr>
                                        <td>Screen Resolution</td>
                                        <td>desk.cpl</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Shutdown computer</td>
                                        <td>shutdown</td>
                                    </tr>
                                    <tr>
                                        <td>System Configuration Editor</td>
                                        <td>sysedit</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>System Configuration Utility</td>
                                        <td>msconfig</td>
                                    </tr>
                                    <tr>
                                        <td>Task Scheduler</td>
                                        <td>taskschd.msc</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>User Account Management</td>
                                        <td>nusrmgr.cpl</td>
                                    </tr>
                                    <tr>
                                        <td>Windows Firewall</td>
                                        <td>wf.msc</td>
                                    </tr>
                                    <tr class="alt">
                                        <td>Windows Update</td>
                                        <td>wuapp.exe</td>
                                    </tr>
                                </table>
                            </body>
                        </html>') | Out-Null
        $filename = 'Shortcut-CheatSheet.html'
        $html.ToString() | Out-File -FilePath ('{0}\{1}' -f $FilePath, $filename)
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
function Get-d00mDiskSpace
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
    Checks for and install PowerShell module updates

.DESCRIPTION
    Checks for PowerShell module updates through PowerShellGet

.EXAMPLE
    Get-d00mModuleUpdate

    This example iterates through all the locally installed PowerShell
    modules, checks for the latest version, and compares the returned 
    version information to the locally installed module version. If the
    returned version is greater than the locally installed module version,
    the function will return True for that module, otherwise false.

.EXAMPLE
    Get-d00mModuleUpdate -Update

    This example iterates through all the locally installed PowerShell
    modules, checks for the latest version, and compares the returned
    version information to the locally installed module version. If the
    returned version is greater than the locally installed module version,
    the function will try to install the latest version.

    NOTE: If the module being updated is installed from a non-trusted source,
          the function will ask for each module update to confirm.

.EXAMPLE
    Get-d00mModuleUpdate -Update -Force

    This example iterates through all the locally installed Powershell
    modules, checks for the latest version, and compares the returned
    version information to the locally installed module version. If the
    returned version is greater than the locally installed module version,
    the function will try to install the latest version. With with Force switch,
    the function will not ask to confirm for any modules installed from a non-
    trusted source.
#>
function Get-d00mModuleUpdate
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [switch]$Update,

        [parameter()]
        [switch]$Force
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
        if ($Update)
        {
            Get-InstalledModule | ForEach-Object {
                try
                {
                    Write-Verbose -Message ('{0} : {1} : Checking for updates' -f $cmdletName, $_.Name)
                    $module      = Find-Module -Name $_.Name -ErrorAction Stop
                    $newVersion  = $module.Version
                    $needsupdate = $_.Version -lt $newVersion
                }
                catch
                {
                    $newVersion  = 'no longer available'
                    $needsupdate = $true
                }
                Write-Verbose -Message ('{0} : {1} : Local version : {2}' -f $cmdletName, $_.Name, $_.Version)
                Write-Verbose -Message ('{0} : {1} : Latest version : {2}' -f $cmdletName, $_.Name, $newVersion)
                Write-Verbose -Message ('{0} : {1} : Needs update : {2}' -f $cmdletName, $_.Name, $needsupdate)
                if ($needsUpdate)
                {
                    try
                    {
                        Write-Verbose -Message ('{0} : {1} : Updating...' -f $cmdletName, $_.Name)
                        $params = @{Name = $_.Name}
                        if ($force)
                        {
                            $params.Add('Force', $true)
                        }
                        Update-Module @params
                    }
                    catch
                    {
                        throw
                    }   
                }
            }
        }

        else
        {
            Get-InstalledModule | ForEach-Object {
                Try
                {
                    $module      = Find-Module -Name $_.Name -ErrorAction Stop
                    $newVersion  = $module.Version
                    $needsUpdate = $_.Version -lt $newVersion
                }
                catch
                {
                    $newVersion  = 'no longer available'
                    $needsupdate = $true
                }

                $_ | Add-Member -MemberType NoteProperty -Name VersionAvailable -Value $newVersion
                $_ | Add-Member -MemberType NoteProperty -Name NeedsUpdate -Value $needsUpdate

                Write-Output $_
            } | Select-Object -Property Name, NeedsUpdate, Version, VersionAvailable |
            Out-GridView
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
    Sets the default shell to PowerShell

.DESCRIPTION
    Sets registry key to specify PowerShell as default shell.
    (HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon\Shell)
    
.EXAMPLE
    Set-d00mPowerShellDefaultShell -Credential (Get-Credential)

    This example sets PowerShell as the default shell on the local machine using
    the supplied credentials.

.EXAMPLE
    Set-d00mPowerShellDefaultShell -ComputerName Computer1, Computer2 -Credential (Get-Credential)

    This example sets PowerShell as the default shell on the remote computers using
    the supplied credentials.

.EXAMPLE
    Read-Content c:\computers.txt | Set-d00mPowerShellDefaultShell

    This example sets PowerShell as the default shell on the list of computers read from
    the file using the user's current credentials.

.EXAMPLE
    (Get-AdComputer -Filter {(Enabled -eq 'true')}).Name | Set-d00mPowerShellDefaultShell -Credential (Get-Credential)

    This example sets PowerShell as the default shell on the computers returned from the
    Get-AdComputer cmdlet using the supplied credentials.

.EXAMPLE
    Set-d00mPowerShellDefaultShell -VMName vm01, vm02 -VMCredential (Get-Credential)

    This example sets PowerShell as the default shell on the virtual machines vm01 and vm02
    using the supplied VM administrator credentials

.EXAMPLE
    Set-d00mPowerShellDefaultShell -ComputerName Computer1 -Restart

    This example sets PowerShell as the default shell on Computer1 and restarts Computer1
    after execution
#>
function Set-d00mPowerShellDefaultShell
{
    [CmdletBinding(DefaultParameterSetName = "Computer")]
    param
    (
        #Computer names
        [parameter(ValueFromPipelineByPropertyName = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Computer")]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        #Computer name admin credential
        [parameter(ParameterSetName = "Computer")]
        [pscredential]$Credential,

        #VM names
        [parameter(ValueFromPipelineByPropertyName = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "VM")]
        [string[]]$VMName,

        #VM admin credential
        [parameter(ParameterSetNAme = "VM")]
        [pscredential]$VMCredential,

        #Restart computer after completion
        [parameter()]
        [switch]$Restart
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)

        $keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
        Write-Verbose -Message ('{0} : Key Path : {1}' -f $cmdletName, $keyPath)
    }

    process
    {
        Write-Verbose -Message ('{0} : ParameterSetName : {1}' -f $cmdletName, $PSCmdlet.ParameterSetName)

        switch ($PSCmdlet.ParameterSetName)
        {
            "Computer"
            {
                foreach ($computer in $ComputerName)
                {
                    Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
                    try
                    {
                        $params = @{ComputerName = $computer
                                    ErrorAction  = 'Stop'}

                        # Add credentials if specified
                        if ($Credential -ne $null)
                        {
                            $params.Add('Credential', $Credential)
                            Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                        }
                        else
                        {
                            Write-Verbose -Message ('{0} : {1} : Using current user credentials' -f $cmdletName, $computer)
                        }

                        # Set restart flag
                        if ($Restart)
                        {
                            $params.Add('ArgumentList', @($keyPath, $true))
                            Write-Verbose -Message ('{0} : {1} : Restarting computer after execution' -f $cmdletName, $computer)
                        }
                        else
                        {
                            $params.Add('ArgumentList', $keyPath)
                            Write-Verbose -Message ('{0} : {1} : Not restarting computer after execution' -f $cmdletName, $computer)
                        }


                        $result = Invoke-Command @params -ScriptBlock {
                            $shellParams = @{Path  = $args[0]
                                             Name  = 'shell'
                                             Value = 'PowerShell.exe -NoExit'}
                            Set-ItemProperty @shellParams
                    
                            if ($(Get-ItemProperty -Path $args[0] -Name 'shell').Shell -eq 'PowerShell.exe -NoExit')
                            {
                                Write-Output $true
                            }
                            else
                            {
                                Write-Output $false
                            }

                            # Check for restart flag
                            if ($args[1] -ne $null)
                            {
                                Restart-Computer -Force
                            }
                        }

                        New-Object -TypeName psobject -Property @{ComputerName      = $computer
                                                                  PowerShellDefault = $result} | 
                            Write-Output
                    }
                    catch
                    {
                        throw
                    }
                }
            }

            "VM"
            {
                foreach ($vm in $VMName)
                {
                    Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $vm)
                    try
                    {
                        $params = @{VMName       = $vm
                                    ErrorAction  = 'Stop'}
                        if ($VMCredential -ne $null)
                        {
                            $params.Add('Credential', $VMCredential)
                            Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $vm)
                        }
                        else
                        {
                            Write-Verbose -Message ('{0} : {1} : Using current user credentials' -f $cmdletName, $vm)
                        }

                        if ($Restart)
                        {
                            $params.Add('ArgumentList', @($keyPath, $true))
                            Write-Verbose ('{0} : {1} : Restarting VM after execution' -f $cmdletName, $vm)
                        }
                        else
                        {
                            $params.Add('ArgumentList', $keyPath)
                            Write-Verbose ('{0} : {1} : Not restarting VM after execution' -f $cmdletName, $vm)
                        }

                        $result = Invoke-Command @params -ScriptBlock {
                            $shellParams = @{Path  = $args[0]
                                             Name  = 'shell'
                                             Value = 'PowerShell.exe -NoExit'}
                            Set-ItemProperty @shellParams
                    
                            if ($(Get-ItemProperty -Path $args[0] -Name 'shell').Shell -eq 'PowerShell.exe -NoExit')
                            {
                                Write-Output $true
                            }
                            else
                            {
                                Write-Output $false
                            }

                            If ($args[1] -ne $null)
                            {
                                Restart-Computer -Force
                            }
                        }

                        New-Object -TypeName psobject -Property @{ComputerName      = $vm
                                                                  PowerShellDefault = $result} | 
                            Write-Output
                    }
                    catch
                    {
                        throw
                    }
                }
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
function Get-d00mArchitecture
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
    Encrypt a string

.DESCRIPTION
    Convert a string to a Base64 encoded encrypted string

.EXAMPLE
    ConvertTo-d00mEncryptedString -StringToEncrypt 'Hello World'

    This example will convert 'Hello World' to a Base64 encoded
    encrypted string

.EXAMPLE
    'Things and stuff' | ConvertTo-d00mEncryptedString

    This example will convert the piped in string, 'Things and stuff' to
    a Base64 encoded encrypted string

.EXAMPLE
    Read-Content c:\file.txt | ConvertTo-d00mEncryptedString

    This example will read the contents of the file and convert the contents
    into a Base64 encoded encrypted string
#>
function ConvertTo-d00mEncryptedString
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline)]
        [string]$StringToEncrypt
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        $eBytes = New-Object System.Collections.ArrayList
        $pBytes = [System.Text.Encoding]::UTF32.GetBytes($StringToEncrypt)
        foreach ($byte in $pBytes)
        {
            $eBytes.Add($byte*2) | Out-Null
        }
        [System.Convert]::ToBase64String($eBytes) | Write-Output
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.ElapsedMilliseconds)
    }
}


<#
.SYNOPSIS
    Decrypt a string

.DESCRIPTION
    Convert a Base64 encoded encrypted string to plain text

.EXAMPLE
    ConvertFrom-d00mEncryptedString -StringToDecrypt '6AAAAMoAAADmAAAA6AAAAA==

    This example will decrypt the specified string value from a Base64
    encoded encrypted string to plain text

.EXAMPLE
    Read-Content c:\encrypted.txt | ConvertFrom-d00mEncryptedString

    This example will decrypt the contents of the file from a Base64
    encoded encrypted string to plain text

.EXAMPLE
    ConvertTo-d00mEncryptedString 'Hello' | ConvertFrom-d00mEncryptedString

    This example will encrypt the string 'Hello' into a Base64 encrypted
    string and then decrypt the value by piping in the Base64 encrypted
    string to the ConvertFrom-d00mEncryptedString function
#>
function ConvertFrom-d00mEncryptedString
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline)]
        [string]$StringToDecrypt
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        $b64 = [System.Convert]::FromBase64String($StringToDecrypt)
        $eBytes = New-Object -TypeName System.Collections.ArrayList
        foreach ($byte in $b64)
        {
            $eBytes.Add($byte / 2) | Out-Null
        }
        [System.Text.Encoding]::UTF32.GetString($eBytes) | Write-Output
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.ElapsedMilliseconds)
    }
}


<#
.SYNOPSIS
    Connect to a VM

.DESCRIPTION
    Connect to a VM on a remote/local Hyper-V host using default credentials

    THE SERVER MUST BE RUNNING SERVER 2016+

.EXAMPLE
    Connect-d00mVm -VmName vm1

    This example will connect to the local Hyper-V host to a virtual machine
    named vm1 using the default credentials

.EXAMPLE
    Connect-d00mVm -ServerName server1 -VmName vm1

    This example will connect to the remote Hyper-V host named server1 to a
    virtual machine named vm1 using the default credentials
#>
function Connect-d00mVm
{
    [CmdletBinding()]
    param
    (
        [parameter()]
        [string]$ServerName = $env:COMPUTERNAME,

        [parameter(Mandatory = $true)]
        [string]$VmName
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        try
        {
            $params = @{FilePath     = 'VmConnect'
                        ArgumentList = $ServerName, $VmName
                        ErrorAction  = 'Stop'}
            Start-Process @params
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
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.ElapsedMilliseconds)
    }
}


<#
.SYNOPSIS
    Enable RDP connections

.DESCRIPTION
    Configures the registry to allow secure RDP connections and enables the Remote Administration
    and Remote Desktop firewall rule group

.EXAMPLE
    Enable-d00mRdp

    This example will configure the registry to allow secure RDP connections and enables the 
    Remote Administration and Remote Desktop firewall rule group on the local computer

.EXAMPLE
    Enable-d00mRdp -ComputerName Computer1, Computer2 -Credential (Get-Credential)

    This example will configure the registry to allow secure RDP connections and enables the
    Remote Administration and Remote Desktop firewall rule group on the remote computers,
    Computer1 and Computer2, using the supplied credentials

.EXAMPLE
    Read-Content C:\file.txt | Enable-d00mRdp -Credential (Get-Credential)

    This example will configure the registry to allow secure RDP connections and enables the
    Remote Administration and Remote Desktop firewall rule group on the computer names found
    in the file c:\file.txt, using the supplied credentials

#>
function Enable-d00mRdp
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

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
                $sessionParams = @{ComputerName = $computer
                                   ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $sessionParams.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using specified credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }
                $session = New-PSSession @sessionParams

                Invoke-Command -Session $session -ScriptBlock {
                    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0 -Force
                    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 0 -Force
                    netsh advfirewall firewall set rule group="Remote Administration" new enable=yes
                    netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes
                }

                Remove-PSSession -Session $session
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


<#
.SYNOPSIS
    Disable RDP connections

.DESCRIPTION
    Configures the registry to disallow any RDP connections and disables the Remote Desktop firewall
    rule group

.EXAMPLE
    Disable-d00mRdp

    This example will configure the registry to disallow RDP connections and disables the
    Remote Desktop firewall rule group on the local computer

.EXAMPLE
    Disable-d00mRdp -ComputerName Computer1, Computer2 -Credential (Get-Credential)

    This example will configure the registry to disallow RDP connections and disables the 
    Remote Desktop firewall rule group on the remote computers, Computer1 and Computer2, using
    the supplied credentials

.EXAMPLE
    Read-Content C:\file.txt | Disable-d00mRdp -Credential (Get-Credential)

    This example will configure the registry to disallow RDP connections and disables the
    Remote Desktop firewall rule group on the computer names found in the file c:\file.txt,
    using the supplied credentials
#>
function Disable-d00mRdp
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

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
                $sessionParams = @{ComputerName = $computer
                                   ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $sessionParams.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using specified credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }
                $session = New-PSSession @sessionParams

                Invoke-Command -Session $session -ScriptBlock {
                    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 1 -Force
                    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 1 -Force
                    netsh advfirewall firewall set rule group="Remote Desktop" new enable=no
                }

                Remove-PSSession -Session $session
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

<#
function Enable-d00mFirewallRuleGroup
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [pscredential]$Credential,

        [ValidateSet('File and Printer Sharing', 'Remote Management', 'Volume Management', 'Event Log Management',
                     'Performance Monitor Management', 'Service Management', 'Scheduled Task Management', 'Firewall Management')]
        [parameter()]
        [string[]]$RulesToEnable
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
                $sessionParams = @{ComputerName = $Computer
                                   ErrorAction  = 'Stop'}
                if ($Credential -ne $null)
                {
                    $sessionParams.Add('Credential', $Credential)
                    Write-Verbose -Message ('{0} : {1} : Using specified credentials' -f $cmdletName, $computer)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }
                $session = New-PSSession @sessionParams

                foreach ($rule in $RulesToEnable)
                {
                    Invoke-Command -Session $session -ScriptBlock {
                        netsh advfirewall firewall set rule group="$($args[0])" new enable=yes
                    } -ArgumentList $rule
                }

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
#>


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



Export-ModuleMember -Function Connect-d00mFrontera, 
                              Disconnect-d00mFrontera, 
                              Get-d00mExcuse, 
                              Get-d00mHardwareReport, 
                              Get-d00mSoftwareReport, 
                              Get-d00mServiceReport, 
                              New-d00mColorFlood,
                              Get-d00mSayThings,
                              Add-d00mChocolateyPackageSource,
                              New-d00mPassword,
                              New-d00mShortcutCheatSheet,
                              Get-d00mDiskSpace,
                              Get-d00mModuleUpdate,
                              Set-d00mPowerShellDefaultShell,
                              Get-d00mArchitecture,
                              ConvertTo-d00mEncryptedString,
                              ConvertFrom-d00mEncryptedString,
                              Connect-d00mVm,
                              Enable-d00mRdp,
                              Disable-d00mRdp,
                              Get-d00mEventLogReport,
                              Get-d00mScheduledTaskReport
                              #Enable-d00mFirewallRuleGroup