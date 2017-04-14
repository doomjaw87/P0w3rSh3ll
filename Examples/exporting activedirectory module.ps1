<###################################
| EXPORTING ACTIVEDIRECTORY MODULE |
####################################

To manage users and computers in your Active Directory from PowerShell, you need the
ActiveDirectory module which comes as part of the free RSAT tools from Microsoft.

Provided you are domain administrator and have remoting access to your domain controller, you
can also export the ActiveDirectory module from your DC, and use it locally via implicit remoting.

#>

# create a session
$dc = 'CISExch02'
$session = New-PSSession -ComputerName $dc -Credential (Get-Credential)

# export the ActiveDirectory module from the server to a local module "ADStuff"
Export-PSSession -Session $session -OutputModule ADStuff -Module ActiveDirectory -AllowClobber -Force

# remove the session
Remove-PSSession -Session $session