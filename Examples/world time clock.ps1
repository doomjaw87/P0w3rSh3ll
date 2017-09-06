<###################
| WORLD TIME CLOCK |
####################

Version 5 and later

PowerShell 5 comes with Get-TimeZone which returns all defined time zones and their time
offset. This is all you need for a one-liner world clock

#>


$isSummer = (Get-Date).IsDaylightSavingTime()

Get-TimeZone -ListAvailable | ForEach-Object {
    $dateTime = [DateTime]::UtcNow + $_.BaseUtcOffset
    $cities = $_.DisplayName.Split(')')[-1].Trim()
    if ($isSummer -and $_.SupportsDaylightSavingsTime)
    {
        $dateTime = $dateTime.AddHours(1)
    }
    '{0,-30}: {1:HH:mm"h"} ({2})' -f $_.Id, $dateTime, $cities
}