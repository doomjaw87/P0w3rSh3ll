<###################
| PARSING RAW TEXT |
####################

Sometimes, you may want to extract vaulable information from pure text results.
One easy way is the use of Select-String. This example extracts only the text
lines containing "IPv4"...

#>

ipconfig | Select-String 'IPv4'


# If you are just interested in the actual IP address, you can refine the result
# and use a regular expression to extract the value you are after:

$data = ipconfig | Select-String 'IPv4'
[regex]::Matches($data,"\b(?:\d{1,3}\.){3}\d{1,3}\b")  | select-Object -ExpandProperty Value

# [Regex]::Matches() takes the raw data and a regular expression pattern 
# describing what you are after. The content matching the pattern can then be 
# found in the property "value".



<############################
| PARSING RAW TEXT (Part 3) |
#############################

In the previous tip we illustrated how you can use Select-String to find lines
in raw text containing a specific word. It took some effort to extract the
actual value(s) representing a given pattern:

#>
$data = ipconfig | Select-STring 'IPv4'
[regex]::Matches($data,"\b(?:\d{1,3}\.){3}\d{1,3}\b") | Select-Object -ExpandProperty Value


# NEW WAY! #
# This effor is not necessary, though, because Select-String is already using
# regular expression match, and returns match objects:

ipconfig | Select-String '\b(?:\d{1,3}\.){3}\d{1,3}\b' | Select-Object -Property *