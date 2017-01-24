<#######################
| USING A PROGRESS BAR |
########################

Using a progress bar can be valuable as long as you don't call Write-Progress
excessively. Especially with long-running loops, it makes no sense to call
Write-Progress for each loop iteration. If you do, your scripts become very
slow.
#>
$min = 1
$max = 10000
$start = Get-Date
$min..$max | ForEach-Object {
    $percent = $_ * 100 / $max
    Write-Progress -Activity 'Counting' -Status "Processing $_" -PercentComplete $percent
}
$end = Get-Date
($end-$start).TotalMilliseconds


<#
This delay is directly related to the number of calls to Write-Progress, so if you change
the value for $max to 100000, the script takes 10 times the time, just because Write-Progress
is called 10 times more often. That's why you should add an intelligent mechanism to limit
the number of calls to Write-Progress. The following example updates the progress bar in 0.1%
increments.
#>
$min = 1
$max = 10000
$start = Get-Date
$interval = $max / 1000
$min..$max | ForEach-Object {
    $percent = $_ * 100 / $max
    if ($_ % $interval -eq 0)
    {
        Write-Progress -Activity 'Counting' -Status "Processing $_" -PercentComplete $percent
    }
}
$end = Get-Date
($end-$start).TotalMilliseconds



<#######################
| HIDING PROGRESS BARS |
########################

Some cmdlets and scripts use progress bars to indicate progress. As you learned above,
progress bars cause delays, so if you don't care about progress indicators, you may want
to hide progress bars. Here is how that can be accomplished.

If you want to get rid of the progress, use the $ProgressPrefence variable to temporarily
hide progress bars. Note how the code is put into braces and called via &. This way, all
variable changes inside the braces are discarded once the code is done, and there is no
need for you to reset $ProgressPreference to the old value

#>

& {
    $ProgressPreference = 'SilentlyContinue'
    $path = "$home\Pictures\test.jpg"
    $url = 'http://www.powertheshell.com/wp-content/uploads/groupWPK2015.jpg'
    Invoke-WebRequest -Uri $url -OutFile $path
}