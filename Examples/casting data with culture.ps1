<############################
| CASTING DATA WITH CULTURE |
#############################

When casting data (converting it to a different data type), PowerShell supports two approaches
that can differ considerably.

Here is an example, both lines cast a string into a DatTime object:

#>

# This represents a forceful cast. It will either succeed or fail, and it always uses
# culture-neutral format (US format), so it expects a month-day-year scheme.
[DateTime]'12.1.2017'

# This represents a "TryCast." The cast with either succeed or silently return $null. This
# cast honors the current locale, so if you run the code on a German system, the text is interpreted
# in a day-month-year scheme.
'12.1.2017' -as [DateTime]