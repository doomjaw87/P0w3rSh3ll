Clear-Host
$length = Get-Random -Minimum 5 -Maximum 11
$counter = 1
$name = New-Object -TypeName System.Text.StringBuilder
$name.Append([char](65..90 | Get-Random)) | Out-Null

while ($counter -le $length)
{
    $name.Append([char](97..122 | Get-Random)) | Out-Null
    $counter++
}

'  
   {0}
' -f $name.ToString()