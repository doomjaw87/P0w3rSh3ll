write-host 'hello world!'
$ip = Invoke-RestMethod -Uri http://checkip.amazonaws.com
@{ComputerName = hostname
  PublicIp     = [ipaddress]$ip.Trim()}
New-Object -TypeName psobject -Property $props | Write-Output