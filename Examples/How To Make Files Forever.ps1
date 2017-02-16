BREAK

<############################
| HOW TO MAKE FILES FOREVER |
############################>

$path = 'c:\forever{0}' -f (Get-Random -Minimum 1 -Maximum 100)
New-Item -Path $path -ItemType Directory -Force
$i = 0
while ($true)
{
    $params = @{Path     = $path
                Name     = ('hello_world_{0}.txt' -f $t)
                ItemType = 'File'
                Value    = ('Hello {0}' -f $i)
                Force    = $true}
    New-Item @params
}