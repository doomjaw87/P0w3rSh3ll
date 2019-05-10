<#################
| SCANNING PORTS |
##################

All Versions

Here is a straightforward way to test ports on a local or remote system. You can even specify
a timeout (in milliseconds):

#>

function Get-PortInfo
{
    param
    (
        [parameter(mandatory)]
        [int]$Port,

        [parameter(mandatory)]
        [int]$TimeoutMilliseconds,

        [string]$ComputerName = $env:COMPUTERNAME
    )

    $tcpObject = New-Object -TypeName System.Net.Sockets.TcpClient
    $connect = $tcpObject.BeginConnect($ComputerName, $Port, $null, $null)

    $wait = $connect.AsyncWaitHandle.WaitOne($TimeoutMilliseconds, $false)

    $result = @{
        ComputerName = $ComputerName
    }

    if (!$wait)
    {
        $tcpObject.Close()
        $result.Online = $false
        $result.Error = 'Timeout'
    } else {
        try
        {
            $null = $tcpObject.EndConnect($connect)
            $result.Online = $true
        }
        catch
        {
            $result.Online = $false
        }
        $tcpObject.Close()
    }
    $tcpObject.Dispose()
    [pscustomobject]$result
}