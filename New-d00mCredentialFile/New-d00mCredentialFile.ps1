$credsPath = 'c:\credentials.xml'
if (Test-Path -Path $credsPath)
{
    Write-Warning -Message ('{0} already exists, creating backup version' -f $credsPath)
    Move-Item -Path $credsPath -Destination ('c:\credentials_{0}.backup' -f (Get-Date -Format 'yyyyMMdd')) -Force
}
$credentials = @{'DomainAdmin' = (Get-Credential -Message 'Domain administrator')
                 'DomainUser'  = (Get-Credential -Message 'Domain user')
                 'O365Admin'   = (Get-Credential -Message 'Office 365 administrator')
                 'O365User'    = (Get-Credential -Message 'Office 365 user')}
$credentials | Export-Clixml -Path $credsPath -Force