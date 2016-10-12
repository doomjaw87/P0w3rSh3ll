<#
$credPath = 'c:\creds_{0}.xml' -f (Get-Date -Format 'yyyyMMdd')
$creds = Import-Clixml -Path $credPath
'Saved Credentials:'
'  $creds.Local = {0}' -f $creds.Local.UserName
'  $creds.Remote = {0}' -f $creds.Remote.UserName
'  $creds.Domain = {0}' -f $creds.Domain.UserName
Set-Location c:\

#>

Set-Location -Path C:\GitHub\