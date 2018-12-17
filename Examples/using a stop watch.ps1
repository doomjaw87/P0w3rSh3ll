<####################
| USING A STOPWATCH |
#####################

All Versions

In PowerShell, to measure time, you can simply subtract datetime values from another:

#>

$start = Get-Date

$null = Read-Host -Prompt 'Press enter as fast as you can!'

$stop = Get-Date
$timeSpan = $stop - $start
$timeSpan.TotalMilliseconds


# an elegant alternative is a stop watch:
$stopWatch = [Diagnostics.Stopwatch]::StartNew()
$null = Read-Host -Prompt 'Press enter as fast as you can!'

$stopWatch.Stop()
$stopWatch.ElapsedMilliseconds


# The specific stop watch advantage is its ability to be paused and continued