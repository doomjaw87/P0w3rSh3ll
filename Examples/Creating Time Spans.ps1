<######################
| CREATING TIME SPANS |
#######################

You can use New-TimeSpan to define "amounts" of time, and then add or subtract
them from dates. Here is an example:

#>

$1Day = New-TimeSpan -Days 1
$today = Get-Date
$yesterday = $today - $1Day
$yesterday

# A much easier way uses the built-in methods for DateTime objects:
$today = Get-Date
$yesterday = $today.AddDays(-1)
$yesterday

# Also, you can use the TimeSpan .NET type to create time span objects:
[Timespan]::FromDays(1)