Add-Type -AssemblyName System.Web

function Get-d00mBing
{
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline,
                   Position = 0)]
        [string[]]$Query
    )

    foreach ($q in $Query)
    {
        $ie = New-Object -ComObject InternetExplorer.Application
        $q = [System.Web.HttpUtility]::UrlEncode($q)
        $ie.Navigate2(('https://www.bing.com/search?q={0}' -f $q))
        $ie.Visible = $true
        Start-Sleep -Seconds 2
        Get-Process iexplore | Stop-Process -Force
    }
}

Function Get-d00mGoogleTrends
{
    [xml]$result = Invoke-WebRequest -Uri http://www.google.com/trends/hottrends/atom/feed?pn=p1
    $result.rss.channel.item.title | Write-Output
}

Function Get-d00mBingPoints
{
    $i = 0
    while ($i -lt 2)
    {
        Get-d00mGoogleTrends | Get-d00mBing
        $i++
    }
}