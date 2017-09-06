<##################################
| CHECK FOR DAYLIGHT SAVINGS TIME |
###################################

All Versions

Here is how PowerShell can find out whether Daylight Savings Time is currently effective -
a potentially needed detail when doing GMT calculations:

#>

(Get-Date).IsDaylightSavingTime()