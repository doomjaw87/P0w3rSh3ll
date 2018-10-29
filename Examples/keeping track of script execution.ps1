<####################################
| KEEPING TRACK OF SCRIPT EXECUTION |
#####################################

ALL VERSIONS

Here is a chunk of code that demonstrates how you can store private settings in the Windows
Registry:

#>


# store settings here
$path = "HKCU:\software\powerTips\settings"

# check if key exists
$exists = Test-Path -Path $path
if ($exists -eq $false)
{
    # if this is first run, initialize registry key
    $null = New-Item -Path $path -Force
}

# read existing value
$currentValue = Get-ItemProperty -Path $path
$lastRun = $currentvalue.LastRun
if ($lastRun -eq $null)
{
    [pscustomobject]@{
        FirstRun = $true
        LastRun  = $null
        Interval = $null
    }
}
else
{
    $lastRunDate = Get-Date -Date $lastRun
    $today = Get-Date
    $timeSpan = $today - $lastRunDate
    [pscustomobject]@{
        FirstRun = $true
        LastRun  = $lastRunDate
        Interval = $timeSpan
    }
}

# write current date and time to registry
$date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$null = New-ItemProperty -Path $path -Name LastRun -PropertyType String -Value $date -Force

# Whenever you run this code, it returns an object telling you when this script was run the last
# time and how much time has passed since