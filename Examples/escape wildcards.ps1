<###################
| ESCAPE WILDCARDS |
####################

All Versions

When you use the -like operator, it supports three wildcards: 

    "*" representing any number of any characters
    "?" representing one character
    "[a-z]" for a list of characters

In addition, and this is not widely known, it supports the PowerShell escape
character "`" that you can use to escape the wildcards

#>


# When you check for "*" in a string, this line works but is actually wrong:
'*abc' -like '*abc' # $true

# It's wrong because it would also return true in this case:
'xyzabc' -like '*abc' # $true


# Since you want to check for "*" and not use it as a wildcard, it needs to be escaped:
'*abc' -like '`*abc' # $true
'xyzabc' -like '`*abc' # false

# And should you want to use double-quotes, don't forget to escape the escape...

# WRONG
"xyzabc" -like "`*abc" # $true

# CORRECT
"xyzabc" -like "``*abc" # $false

# CORRECT
"*abc" -like "``*abc" # $true