Clear-Host

$alphabet = @()
65..90 | %{$alphabet += [char]$_}

$results = (((Invoke-WebRequest -Uri 'http://www.rinkworks.com/namegen/fnames.cgi?d=1&f=0' -UseBasicParsing).RawContent -split "fnames_results'>")[1] -split "</table>")[0]
$results = $($results.Replace('<tr>','').Replace('</tr>','').Replace('<td>','').Replace('</td>','') -split '[\r\n]' | ? {$_}) | Sort-Object

foreach ($letter in $alphabet)
{
    $results | Where {$_[0] -eq $letter} | Get-Random | Select-Object -First 1
}