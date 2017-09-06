<####################################
| GREETINGS OF THE DAY (WITH VOICE) |
#####################################

All Versions

In the previous tip we explained how you can add a personal greeting to your PowerShell profile.
This greeting can also be spoken out, provided your volume is turned up. This works for all
PowerShell hosts including VSCode.

This will add the code to your profile script:

#>


# Create Profile if it does not yet exist
$exists = Test-Path -Path $profile.CurrentUserAllHosts
if (!$exists)
{
    $null = New-Item -Path $profile.CurrentUserAllHosts -ItemType File -Force
}

# Add code to profile
@'
$greetings = 'Hello there!',
             'Glad to see you!',
             'Happing coding!',
             'Have a great day!',
             'May the PowerShell be with you!'

$text = $greetings | Get-Random
$null = (New-Object -COM Sapi.SPVoice).Speak($text)
'@ | Add-Content -PassThru $profile.CurrentUserAllHosts -Encoding Default