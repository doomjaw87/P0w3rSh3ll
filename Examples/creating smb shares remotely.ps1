<###############################
| CREATING SMB SHARES REMOTELY |
################################

Version 3 and later

Here are a couple of lines that remotely create an SMB share on a server

#>

#requires -Version 3.0 -Modules CimCmdlets, SmbShare -RunAsAdministrator
$ComputerName = 'Server1'
$shareName    = 'Stuff'
$fullAccess   = 'domain\groupName'


$session = New-CimSession -ComputerName $ComputerName
New-SmbShare -Name $shareName -Path c:\whatever -FullAccess $fullAccess -CimSession $session
Remove-CimSession -CimSession $session