<#####################
| Illegal Characters |
#####################>

# Path to Check
$filenameToCheck = 'testfile:?.txt'

# Get invalid characters and escape them for use with RegEx
$illegal = [Regex]::Escape(-join [System.IO.Path]::GetInvalidFileNameChars())
$pattern = '[{0}]' -f $illegal

# Find illegal characters
$invalid = [regex]::Matches($filenameToCheck, $pattern, 'IgnoreCase').Value | 
    Sort-Object -Unique

if ($invalid)
{
    $characters = New-Object -TypeName System.Text.StringBuilder
    foreach ($invalidCharacter in $invalid)
    {
        $characters.Append(('{0} ' -f $invalidCharacter)) |
            Out-Null
    }
    'Do not use invalid characters in file names... {0}' -f $characters.ToString()
}
else
{
    'All is good in the hood.'
}