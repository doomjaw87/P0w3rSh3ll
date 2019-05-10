<##########################################
| FORMATTING DATE AND TIME (WITH CULTURE) |
###########################################

All Versions

In the previous tip we illustrated how Get-Date can take a format string and convert DateTime
values to strings. The string conversion always uses your local language though. THat might not
always be what you need. Let's check out the problem, and a solution for it:

Here is an example outputting the weekday name for Chistmas Eve in 2018:

#>

$christmasEve = Get-Date '2018-12-24'

Get-Date -Date $christmasEve -Format '"Christmas Eve in" yyyy "will be on" dddd.'

# If your script was supposed to create output for a different language, you might want to output
# the days of the week in English (or any other language). To take control over the language, you
# need to be aware of two things: first, the formatting option provided by Get-Date and -Format is
# simply a wrapper around the generic .NET method toString(), so you can as well run this and
# get the same result:

$christmasEve = Get-Date -Date '2018-12-24'
$christmasEve.ToString('"Christmas Eve in" yyyy "will be on" dddd.')

# Second, the ToString() method has many of overloads, one of which accepts any object
# implementing the IFormatProvider interface, which happens to include "CultureInfo" objects.

# Here is a solution to output the days of the week in English, regardless of your own operating
# system language:

$christmasEve = Get-Date -Date '2018-12-24'
$culture = [CultureInfo]'en-us'
$christmasEve.ToString('"Christmas Eve in" yyyy "will be on" dddd.', $culture)

# Start playing with other locales, and for example find out what "Monday" is in Chinese or Thai:

$culture = [CultureInfo]'zh'
$christmasEve.ToString('"Monday in Chinese: " dddd.', $culture)

$culture = [CultureInfo]'th'
$christmasEve.ToString('"Monday in Thai: " dddd.', $culture)