$gitPath = "$env:APPDATA\..\Local\GitHub\GitHub.appref-ms"

if (Test-Path $gitPath)
{
    Start-Process -FilePath $gitPath -ArgumentList '--open-shell'
}
else
{
    Write-Output $false
}