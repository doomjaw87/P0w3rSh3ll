<################################
| EXAMINING CERTIFICATE DETAILS |
#################################

If you'd like to examine and view the details of a certificate file without the need to import it into
your certificate store, here is a simple example:

#>

# replace path with actual path to CER file
$path = 'c:\path\test.cer'

Add-Type -AssemblyName System.Security
[Security.Cryptography.X509Certificates.X509Certificate2]$cert = [Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromCertFile($Path)
 
$cert | Select-Object -Property * 

# You can now access all details and retrieve thumbprint or check expiration date