<###########################
| CHECKING POWERSHELL HOST |
############################

There are many hosts around these days. Visual studio can host PowerShell,
and so does Visual Studio Code. And there are additional commerical editors. So if you must
know whether a script runs in a given environment, use the host identifier:

#>

$name = $host.Name
$inIse = $name -eq 'Windows PowerShell ISE Host'
"Running in ISE: $inIse"