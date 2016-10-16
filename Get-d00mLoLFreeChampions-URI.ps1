Clear-Host

$championRotation = New-Object -TypeName System.Collections.ArrayList
(Invoke-WebRequest -uri http://freechampionrotation.com/ -UseBasicParsing).Images.OuterHTMl | ForEach-Object {
    $championRotation.Add($_.Split('"')[3]) | Out-Null
}

$champs = $championRotation | Select-Object -Unique
$champs.ForEach{
    $uri = 'http://leagueoflegends.wikia.com/wiki/{0}' -f ($_.Replace(' ','_'))
    $result = Invoke-WebRequest -Uri $uri -UseBasicParsing
    $result.RawContent
}