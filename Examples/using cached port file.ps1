<#########################
| USING CACHED PORT FILE |
##########################

All Versions

In the previous tip we explained how you can download port assignments via PowerShell from
IANA. This process requires internet access and can take a while. So here is code that looks for
a cached CSV file. If it is present, port data is loaded from the file offline, else the data is
retrieved online and a cache file is written. Note especially how Tee-Object is used to create
the cache file:

#>

$url = 'https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv'
$csvFile = "$env:TEMP\ports.csv"
$exists = Test-Path -Path $csvFile

if (!$exists)
{
    Write-Warning "Retrieving data online..."

    $portInfo = Invoke-WebRequest -Uri $url -UseBasicParsing |
        Select-Object -ExpandProperty Content |
        Tee-Object -FilePath $csvFile | ConvertFrom-Csv
}
else
{
    Write-Warning "Loading cached file..."
    $portInfo = Import-Csv -Path $csvFile
}

$portInfo | Out-GridView