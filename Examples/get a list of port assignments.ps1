<###############################
| GET LIST OF PORT ASSIGNMENTS |
################################

All Versions

The IANA (Internet Assigned Numbers Authority) maintains a CSV file with all known port
assignments. PowerShell can download this list:

#>

$out = "$Env:TEMP\portlist.csv"
$url = 'https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv'
$web = Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $out
#Import-Csv -Path $out -Encoding UTF8

# The result is a list with all the port assignments in object oriented format. You could then use this
# information for example to filter out specific ports:

Import-Csv -Path $out -Encoding UTF8 |
    Where-Object 'transport protocol' -eq 'tcp' |
    Where-Object 'Port Number' -lt 1000