<####################
| SETTING TIME ZONE |
#####################

All Versions

While you need administrative privileges to adjust time and date on your computer, each user
can change the time zone, i.e. when you travel. PowerShell 5 comes with a very simple family of
cmdlets to manage time zones.

#>

# First, check your current setting:
Get-TimeZone


# Next, try and change the time zone. The line below opens a window with the names of all
# available time zones:
Get-TimeZone -ListAvailable | Out-GridView


# Once you know the official ID of the time zone you want to set, use Set-TimeZone:
Set-TimeZone -Id 'Chatham Islands Standard Time'

Get-Date

Set-TimeZone -Id 'W. Europte Standard Time'