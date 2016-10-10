function Get-d00mBingRewardPoints
{
    try
    {
        [xml]$result = Invoke-WebRequest -Uri http://www.google.com/trends/hottrends/atom/feed?pn=p1 -UseBasicParsing
        $result.rss.channel.item.title | ForEach-Object {
            $q = [System.Web.HttpUtility]::UrlEncode($_)
            $url = 'https://www.bing.com/search?q={0}' -f $q
            Start microsoft-edge:$url
            Start-Sleep -Seconds 3
        }
        $result = $null

        [xml]$result = Invoke-WebRequest -Uri http://www.google.com/trends/hottrends/atom/feed?pn=p2 -UseBasicParsing
        $result.rss.channel.item.title | ForEach-Object {
            $q = [System.Web.HttpUtility]::UrlEncode($_)
            $url = 'https://www.bing.com/search?q={0}' -f $q
            Start microsoft-edge:$url
            Start-Sleep -Seconds 3
        }
    }
    catch
    {

    }
}