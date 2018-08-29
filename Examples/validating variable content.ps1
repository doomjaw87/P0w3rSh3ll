<##############################
# Validating Variable Content #
###############################

Beginning in PowerShell 5, you can assign a validator to a variable.
The validator can take a regular expression, and once you assign new
values to the variable, the validator checks to see whether the new
content matches the regular expression pattern. If not, an exception is
thrown, and the variable content stays untouched.

Here is an example showing a variable that stores MAC address:

#>


# success
[ValidatePattern('^[a-fA-F0-9:]{17}|[a-fA-F0-9]{12}$')][string]$mac = 'A0:B1:C2:D3:E4:F5'

# success
[ValidatePattern('^[a-fA-F0-9:]{17}|[a-fA-F0-9]{12}$')][string]$mac = 'a0b1c2d3e4f5'

# failure!
[ValidatePattern('^[a-fA-F0-9:]{17}|[a-fA-F0-9]{12}$')][string]$mac = 'A0:B1:C2:D3:E4:Q5'