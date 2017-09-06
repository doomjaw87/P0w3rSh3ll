<#######################
| GREETINGS OF THE DAY |
########################

All Versions

Here is a simple approach that takes an array of strings and returns a random string that you
could use for custom greetings in PowerShell:

#>

$greetings =
    'Hello there!',
    'Glad to see you!',
    'Happy coding!',
    'Have a great day!',
    'May the PowerShell be with you.'

$greetings | Get-Random


# All you need to do is add the code to your profile script, for example like this:

# Creat profile if it does not yet exist
$exists = Test-Path -Path $profile.CurrentUserAllHosts
if (!$exists)
{
    $null = New-Item -Path $profile.CurrentUserAllHosts -ItemType File -Force
}

# add code to profile 
@'
$greetings = 
    'Hello there!',
    'Glad to see you!',
    'Happy coding!',
    'Have a great day!',
    'May the PowerShell be with you!'
 
$greetings | Get-Random
'@ | Add-Content -Path $Profile.CurrentUserAllHosts -Encoding Default 
