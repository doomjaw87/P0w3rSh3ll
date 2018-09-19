Clear-Host
$token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjkwYmYyNjExZjA2MDViN2QiLCJpYXQiOjE1MzczNzU1MDksIm5iZiI6MTUzNzM3NTUwOSwiaXNzIjoiaHR0cHM6Ly93d3cuYmF0dGxlbWV0cmljcy5jb20iLCJzdWIiOiJ1cm46dXNlcjo0OTc4NCJ9.5YPrsBcs5UbW4GHVKxqNNRxHUeiZuqGySdxYKhfa90s'

$servers = @('2489660','2489537','2272778','2326688','2326689')
#$servers = @('2489660')

$output = New-Object -TypeName System.Text.StringBuilder

foreach ($s in $servers)
{
    $response = $null
    $params = @{Method        = 'Get'
                Uri           = "https://api.battlemetrics.com/servers/$s"
                Headers       = @{Authorization = "Bearer $($token)"}
                Body          = @{include='player'}
                TimeoutSec    = 10
                ErrorAction   = 'SilentlyContinue'
                ErrorVariable = 'oops'}
    $response = Invoke-RestMethod @params

    if ($response)
    {
        $output.AppendLine("$($response.data.attributes.name)") | Out-Null
        if ($response.included.Count -gt 0)
        {
            foreach ($p in $response.included)
            {
                $time = [timespan]::FromSeconds((($response.included | Where {$_.attributes.name -eq $p.attributes.name}).meta.metadata | where {$_.key -eq 'time'}).value)
                $output.AppendLine("- $($p.attributes.name) ($($time.Hours.ToString('00')):$($time.Minutes.ToString('00')))") | Out-Null
            }
        }
        else
        {
            $output.AppendLine('- No players found') | Out-Null
        }
        $output.AppendLine('') | Out-Null
    }
    else
    {
        $output.AppendLine("Could not find server $($s)") | Out-Null
    }
}
$output.ToString()