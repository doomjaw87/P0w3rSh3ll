$totalNumberOfThings = 10

$currentCount = 0

while ($currentCount -le $totalNumberOfThings)
{
    $params = @{Activity         = 'Currently Doing Stuff'
                CurrentOperation = "$currentCount / $totalNumberOfThings"
                PercentComplete  = $currentCount}
    Write-Progress @params
    $currentCount++
    Start-Sleep -Seconds 1
}