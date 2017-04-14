<#############################
| DETECTING CHARACTER CODE 0 |
##############################

Occasionally, strings use a "Byte 0" character as a delimiter. Unlike most other delimiters, this
delimiter does not show in text output but can still be used to separate the text parts.

PowerShell can deal with character code 0 strings. It is represented by a backtick followed by
the number 0. Note that text needs to be placed in double-quotes in order to convert the backtick
sequence to byte 0.

Here is an example illustrating how you split text that uses code 0 as delimiter.

#>

# create a sample text
$text = "Part1`0Part 2`0Part 3"

# delimiter does not show in output
$text

# ... but can be used t split:
$text -split "`0"