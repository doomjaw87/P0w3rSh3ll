<############################################
| ADDING RSS TICKER TO POWERSHELL TITLE BAR |
#############################################

ALL VERSIONS

A new PowerShell background thread can do things for you in the background, for example
updating your PowerShell window title bar with new news feeds every five seconds.

First let's look at how to get to the news feed items:

#>

$rssFeedUrl = 'https://www.reddit.com/r/playark/new/.rss'
$xml = Invoke-RestMethod -Uri $rssFeedUrl
$xml | ForEach-Object {
    "{0}, by {1}" -f $_.title, $_.author.name
}

# Feel free to adjust the RSS ticker URL. If you do, also adjust the property names "title" and
# "description." Each RSS ticker can name these properties freely.

# And here is the complete solution that adds the news items to your title bar:

$code = {
    # receive the visible PowerShell window reference
    param ($ui)
    
    # get rss feed messages
    $rssFeedUrl = 'https://www.reddit.com/r/playark/new/.rss'
    $xml = Invoke-RestMethod -Uri $rssFeedUrl

    # show a random message every 5 seconds
    do
    {
        $message = $xml | Get-Random
        $ui.windowTitle = "{0}, by {1}" -f $message.title, $message.author.name
        Start-Sleep -Seconds 10
    } while ($true)
}

# create a new PowerShell thread
$ps = [PowerShell]::Create()

# add the code, and a reference to the visible powershell window
$null = $ps.AddScript($Code). AddArgument($host.UI.RawUI)

# launch background thread
$null = $ps.begininvoke()