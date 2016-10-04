Import-Module C:\github\P0w3rSh3ll\Modules\d00m\d00m.psm1 -Force
$alphabet = @('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')

$counter = 1
$thingToSay = New-Object -TypeName System.Text.StringBuilder
while ($counter -le 1000)
{
    $thingToSay.Append($($alphabet | Get-Random)) | Out-Null 
    $counter++
}
$t = Get-d00mSayThings $thingToSay.ToString()
$t.Spoke