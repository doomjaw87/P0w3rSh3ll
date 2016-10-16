$key = 'RGAPI-c6677da3-1764-4d89-8df0-46afc571b0bd'
$free = (Invoke-RestMethod -Uri ('https://na.api.pvp.net/api/lol/na/v1.2/champion?freeToPlay=true&api_key={0}' -f $key)).Champions
foreach ($champion in $free)
{
    (Invoke-RestMethod -Uri ('https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/{0}?champData=tags&api_key={1}' -f $champion.id, $key)) |
    ForEach-Object {
        $props = [ordered]@{Name  = $_.Name
                            Title = $_.Title
                            Tags  = $_.Tags}
        New-Object -TypeName psobject -Property $props |
            Write-Output
    }
}