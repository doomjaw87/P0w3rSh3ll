<##############################
| GENERATING RANDOM PASSWORDS |
###############################

All Versions

Here is a very simple way to create complex random passwords

#>

Add-Type -AssemblyName System.Web
$passwordLength = 12
$specialCharCount = 3
[System.Web.Security.Membership]::GeneratePassword($passwordLength, $specialCharCount)

# The API call lets you choose the length of the password, and the number of non-alphanumeric
# characters it contains