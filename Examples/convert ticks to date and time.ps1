<#################################
| CONVERT TICKS TO DATE AND TIME |
##################################

Occasionally, you may run into strange date and time expressions: they might be 
represented as a 64-bit integer like this: 636264671350358729

If you'd like to convert these "ticks" (the smallest time and date increment in Windows), simply
convert the number to a DateTime type:

#>

[DateTime]636264671350358729


# Likewise, to turn a date into ticks, try this:
$date = Get-Date -Date '2017-02-03 19:22:11'
$date.Ticks

# There are two different time formats involving ticks, and here is an
# overview of how you can convert numeric datetime information:

[DateTime]::FromBinary($date.Ticks) # = Friday, February 3, 2017 7:22:11 PM

[DateTime]::FromFileTime($date.Ticks) # = Friday, February 3, 2017 1:22:11 PM

[DateTime]::FromFileTimeUtc($date.Ticks) # = Friday, February 3, 3617 7:22:11 PM