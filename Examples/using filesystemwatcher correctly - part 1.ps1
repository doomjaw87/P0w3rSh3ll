<####################################
| USING FILESYSTEMWATCHER CORRECTLY |
#####################################

ALL VERSIONS

A FileSystemWatcher can monitor a file or folder for changes, so your PowerShell code can
immediately be notified when new files are copied to a folder, or when files are deleted or
changed.

Often, you find example code for synchronous monitoring like this:

#>

# make sure you adjust this
$pathToMonitor = 'C:\test_monitor'
New-Item $pathToMonitor -ItemType Directory -Force

$fileSystemWatcher = New-Object -TypeName System.IO.FileSystemWatcher
$fileSystemWatcher.Path = $pathToMonitor
$fileSystemWatcher.IncludeSubdirectories = $true

Write-Host "Monitoring content of $pathToMonitor"
explorer $pathToMonitor

while ($true)
{
    $change = $fileSystemWatcher.WaitForChanged('All', 1000)
    if ($change.TimedOut -eq $false)
    {
        # get information about the changes detected
        Write-Host "Change detected:"
        $change | Out-Default

        # uncomment this to see the issue
        Start-Sleep -Seconds 5
    }
    else
    {
        Write-Host "." -NoNewline
    }
}

<#

This example works just fine. When you add files to the folder being monitored, or make
changes, the file of change is detected. You could easily take that information and invoke
actions. For example, in your IT, people could drop files with instructions into a drop folder,
and your script could respond to these files.

However, this approach has a back side: when a change is detected, control is returned to your
script so it can process the change. If another file change occurs while your script is no longer
waiting for events, it gets lost. You can easily check for yourself:

Add a lengthy statement such as "Start-Sleep -Seconds 5" to the code that executes when a
change was detected, then apply multiple changes to your folder. As you'll see, the first change
will be detected, but during the five second interval in which your PowerShell is kept busy, all other
change events get lost.

#>