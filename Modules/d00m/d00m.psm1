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

.DESCRIPTION
    
.EXAMPLE

.EXAMPLE

.EXAMPLE

#>

function Get-d00mHardwareReport
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [string]$FilePath = $(Get-Location),

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
            $html.AppendLine(('<html>
                                <head>
                                    <title>{0} Hardware Inventory</title>
                                </head>
                                <body>
                                    <table>
                                        <tr>
                                            <td colspan="2">{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Report</td>
                                            <td>Date</td>
                                        </tr>
                                        <tr>
                                            <td>{1}</td>
                                            <td>{2}</td>
                                        </tr>
                                    </table>
                                </br>' -f $computer, $cmdletName, $(Get-Date))) | Out-Null
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
                    $html.AppendLine(('<table>
                                        <tr>
                                            <td colspan="2">
                                                Win32_BaseBoard
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Name</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Manufacturer</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr>
                                            <td>Product</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>SerialNumber</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr>
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
                    $html.AppendLine(('<table>
                                        <tr>
                                            <td colspan="2">Win32_Bios</td>
                                        </tr>
                                        <tr>
                                            <td>SerialNumber</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Manufacturer</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr>
                                            <td>Name</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>PrimaryBios</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr>
                                            <td>ReleaseDate</td>
                                            <td>{4}</td>
                                        </tr>
                                        <tr>
                                            <td>BiosVersion</td>
                                            <td>{5}</td>
                                        </tr>
                                    </table>
                                </br>' -f $cim.SerialNumber,
                                          $cim.Manufacturer,
                                          $cim.Name,
                                          $cim.PrimaryBIOS,
                                          $cim.ReleaseDate,
                                          $cim.BIOSVersion)) | Out-Null
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_CdRomDrive...' -f $cmdletName, $computer)
                $cim = Get-CimInstance -ClassName Win32_CDROMDrive @cimParams
                if ($cim)
                {
                    $html.AppendLine(('<table>
                                        <tr>
                                            <td colspan="2">Win32_CDROMDrive</td>
                                        </tr>
                                        <tr>
                                            <td>Name</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>Drive</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr>
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
                    $html.AppendLine(('<table>
                                        <tr>
                                            <td colspan="2">Win32_ComputerSystem</td>
                                        </tr>
                                        <tr>
                                            <td>Caption</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>UserName</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr>
                                            <td>Manufacturer</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>Model</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr>
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
                                        <tr>
                                            <td colspan="2">Win32_DiskDrive : {0}</td>
                                        </tr>
                                        <tr>
                                            <td>Index</td>
                                            <td>{0}</td>
                                        </tr>
                                        <tr>
                                            <td>DeviceID</td>
                                            <td>{1}</td>
                                        </tr>
                                        <tr>
                                            <td>Model</td>
                                            <td>{2}</td>
                                        </tr>
                                        <tr>
                                            <td>SerialNumber</td>
                                            <td>{3}</td>
                                        </tr>
                                        <tr>
                                            <td>InterfaceType</td>
                                            <td>{4}</td>
                                        </tr>
                                        <tr>
                                            <td>Size</td>
                                            <td>{5}</td>
                                        </tr>
                                        <tr>
                                            <td>Partitions</td>
                                            <td>{6}</td>
                                        </tr>
                                    </table>
                                </br>' -f $disk.Index,
                                          $disk.DeviceID,
                                          $disk.Model,
                                          $disk.SerialNumber,
                                          $disk.InterfaceType,
                                          $disk.Size,
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
                                            <tr>
                                                <td colspan="2">Win32_LogicalDisk : {0}</td>
                                            </tr>
                                            <tr>
                                                <td>DeviceID</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>Description</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
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
                                            <tr>
                                                <td>FileSystem</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>FreeSpace</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>UsedSpace</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr>
                                                <td>Size</td>
                                                <td>{4}</td>
                                            <tr>
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
                                            <tr>
                                                <td colspan="2">Win32_NetworkAdapter {0} </td>
                                            </tr>
                                            <tr>
                                                <td>Index</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>Name</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>Connection</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>DeviceID</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr>
                                                <td>MACAddress</td>
                                                <td>{4}</td>
                                            </tr>
                                            <tr>
                                                <td>Manufacturer</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr>
                                                <td>AdapterType</td>
                                                <td>{6}</td>
                                            </tr>
                                            <tr>
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
                        $html.AppendLine(('
                                        <table>
                                            <tr>
                                                <td colspan="2">Win32_NetworkAdapterConfiguration {0}</td>
                                            </tr>
                                            <tr>
                                                <td>InterfaceIndex</td>
                                                <td>{0}</td>
                                            </tr>
                                            <tr>
                                                <td>ServiceName</td>
                                                <td>{1}</td>
                                            </tr>
                                            <tr>
                                                <td>IPAddress</td>
                                                <td>{2}</td>
                                            </tr>
                                            <tr>
                                                <td>DHCPEnabled</td>
                                                <td>{3}</td>
                                            </tr>
                                            <tr>
                                                <td>DHCPServer</td>
                                                <td>{4}</td>
                                            </tr>
                                            <tr>
                                                <td>DefaultIPGateway</td>
                                                <td>{5}</td>
                                            </tr>
                                            <tr>
                                                <td>DNSServerSearchOrder</td>
                                                <td>{6}</td>
                                            </tr>
                                            <tr>
                                                <td>WINSPrimaryServer</td>
                                                <td>{7}</td>
                                            </tr>
                                            <tr>
                                                <td>IPSubnet</td>
                                                <td>{8}</td>
                                            </tr>
                                        </table>
                                    </br>' -f $adapter.InterfaceIndex,
                                              $adapter.ServiceName,
                                              $adapter.IPAddress[0],
                                              $adapter.DHCPEnabled,
                                              $adapter.DHCPServer,
                                              $adapter.DefaultIPGateway[0],
                                              $adapter.DNSServerSearchOrder[0],
                                              $adapter.WINSPrimaryServer,
                                              $adapter.IPSubnet[0])) | Out-Null
                    }
                }
                $cim = $null

                Write-Verbose -Message ('{0} : {1} : Getting Win32_OperatingSystem...' -f $cmdletName, $computer) 
                Write-Verbose -Message ('{0} : {1} : Getting Win32_PhysicalMemory...' -f $cmdletName, $computer) 
                Write-Verbose -Message ('{0} : {1} : Getting Win32_WMIMonitorID...' -f $cmdletName, $computer) 
                Write-Verbose -Message ('{0} : {1} : Getting Win32_Processor...' -f $cmdletName, $computer) 


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