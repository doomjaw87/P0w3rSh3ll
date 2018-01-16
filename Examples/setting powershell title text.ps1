<################################
| SETTING POWERSHELL TITLE TEXT |
#################################

ALL VERSIONS

You probably know that you can change the title of a PowerShell host window with a line like this:

#>

$host.UI.RawUI.WindowTitle = 'Alex is Awesome!'

# When you add this to your prompt function, the title text can be dynamic:

function Prompt
{
    # get current path
    $path = Get-Location

    # get current time
    $date = Get-Date -Format 'dddd, MMMM dd'

    # create title text
    $host.UI.RawUI.WindowTitle = ">>$path<< [$date]"

    # output prompt
    'PS> '
}