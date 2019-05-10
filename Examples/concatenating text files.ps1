<###########################
| CONCATENATING TEXT FILES |
############################

All Versions

Let's assume a script has written multiple log files in a folder, all with extension *.log. You would
like to consolidate them into one big file. HEre is a simple approach:

#>

$outPath = "$env:temp\summary.log"

Get-Content -Path "C:\users\asparkma\Documents\*.txt" | Set-Content $outPath

Invoke-Item -Path $outPath

# However, this approach wouldn't give a lot of control to you: all files would need to reside in the
# same foldder, have the same file extension, and you have no control over the order in which they
# are consolidated.

# A more versatile approach would look like this:
$outPath = "$env:temp\summary.log"

Get-ChildItem -Path "C:\users\asparkma\documents\*.txt" -Recurse -File |
    Sort-Object -Property LastWriteTime -Descending |
    Get-Content |
    Set-Content $outPath

Invoke-Item $outPath

# It lets you use all the flexbility of Get-ChildItem, and you get the chance to sort fikles before you
# read their content. This way, the summary keeps the order, and the latest log information always
# appears on top of the summary log file.