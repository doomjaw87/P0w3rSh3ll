<####################
| BEWARE OF ALIASES |
#####################

Can you spot what is wrong here?

#>

function r { "This never runs!" }
r

# When you run function "r", it simply returns the function source code.
# The reason is what the function name "r" conflicts with a built-in alias:
Get-Alias -Name r

# So always make sure you know your built-in alias names - they always have precedence over
# functions or any other command. Better yet, adhere to best practice, and always assign Verb-
# Noun names to your functions.