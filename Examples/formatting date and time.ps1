<###########################
| FORMATTING DATE AND TIME |
############################

All Versions

Formatting date and time to your needs is easy with the -Format parameter provided by Get-
Date. You can use it either with the current date, or external DateTime variables. Simply use the
wildcards for the date and time elements you want to convert to an output string.

Here are a couple of examples. To output the current date in ISO format, for example, run this:

#>

Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# To use a datetime object that already exists that you might have read from somewhere else,
# submit it to Get-Date via -Date:

# find out last boot time
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$lastBoot = $os.LastBootUpTime

# raw datetime output
$lastBoot

# formatted string output
Get-Date -Date $lastBoot -Format '"Last reboot at " MMM dd, yyyy "at" HH:Mm:ss "and" fffff "milliseconds."'

# The format string accepts both the wildcards for datetime components, and static text. Just make
# sure you enclose the static in double quotes
