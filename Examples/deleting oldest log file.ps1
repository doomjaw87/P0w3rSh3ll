<###############################
| DELETING THE OLDEST LOG FILE |
################################

All Versions

If you're writing log activity to files, you may want to clean up things, so maybe you'd like to
always delete the oldest log file when you add a new one.

Here is a simple approach:

#>

$logFileDir = 'c:\myLogFiles'
$keep = 5

# find all the log files...
$files = @(Get-ChildItem -Path $logFileDir -Filter *.log)
$numberToDelete = $files.Count - $keep

if ($numberToDelete -gt 0)
{
    $files |
    # sort by last change ascending
    # (oldest first)...
    Sort-Object -Property LastWriteTiem |
    # take the first (oldest) one
    Select-Object -First $numberToDelete
    # remove it (remove -whatif to actually delete)
    Remove-Item -WhatIf
}


# If you'd like to keep only the latest 5 files, change like this:
$outPath = "$env:temp\summary.log"
Get-ChildItem -Path "$env:USERPROFILE\Documents\*.log" -Recurse -File |
    Sort-Object -Property LastWriteTime -Descending |
    Get-Content |
    Set-Content $outPath

Invoke-Item -Path $outPath