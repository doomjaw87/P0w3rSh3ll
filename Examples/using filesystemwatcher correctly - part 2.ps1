<#############################################
| USING FILESYSTEMWATCHER CORRECTLY - PART 2 |
##############################################

All Versions

In the previous tip we introduced the FileSystemWatcher and illustrated how it can miss
filesystem changes when your handler code takes too long.

To use the FileSystemWatcher correctly, you should use it asynchronously and make sure it
uses a queue. So even if your script is buys processing a filesystem change, it should continue
to log new filesystem changes and process them once PowerShell is done processing previous
changes.

#>


# make sure you adjust this to point to the folder you want to monitor
$pathToMonitor = 'C:\Test'

explorer $pathToMonitor

$fileSystemWatcher = New-Object -TypeName System.IO.FileSystemWatcher
$fileSystemWatcher.Path = $pathToMonitor
$fileSystemWatcher.IncludeSubdirectories = $true

# make sure the watcher emits events
$fileSystemWatcher.EnableRaisingEvents = $true

# define the code that should execute when a file change is detected
$action = {
    $details = $event.SourceEventArgs
    $name = $etails.Name
    $fullPath = $details.FullPath
    $oldFullPath = $details.OldFullPath
    $oldName = $details.OldName
    $changeType = $details.ChangeType
    $timeStamp = $event.TimeGenerated
    $text = "{0} was {1} at {2}" -f $fullPath, $changeType, $timeStamp
    Write-Host ""
    Write-Host $text -ForegroundColor Green

    # you can also execute code based on the change type here
    switch ($changeType)
    {
        'Changed' {'CHANGED!'}
        'Created' {'CREATED!'}
        'Deleted' {'DELETED!'
            Write-Host 'Deletion handler start' -ForegroundColor Gray
            Start-Sleep -Seconds 4
            Write-Host 'Deletion handler end' -ForegroundColor Gray
        }
        'Renamed' {
            $text = "File {0} was renamed to {1}" -f $oldName, $name
            Write-Host $text -ForegroundColor Yellow
        }
        default {
            Write-Host $_ -ForegroundColor Red -BackgroundColor White
        }
    }
}

# add event handlers
$handlers = . {
    Register-ObjectEvent -InputObject $fileSystemWatcher -EventName Changed -Action $action -SourceIdentifier FSChange
    Register-ObjectEvent -InputObject $fileSystemWatcher -EventName Created -Action $action -SourceIdentifier FSCreate
    Register-ObjectEvent -InputObject $fileSystemWatcher -EventName Deleted -Action $action -SourceIdentifier FSDelete
    Register-ObjectEvent -InputObject $fileSystemWatcher -EventName Renamed -Action $action -SourceIdentifier FSRename
}

Write-Host "Watching for changes to $pathToMonitor"

try
{
    do
    {
        Wait-Event -Timeout 1
        Write-Host "." -NoNewline
    } while ($true)
}
finally
{
    # this gets executed when user presses ctrl+c
    # remove the event handlers
    Unregister-Event -SourceIdentifier FSChange
    Unregister-Event -SourceIdentifier FSCreate
    Unregister-Event -SourceIdentifier FSDelete
    Unregister-Event -SourceIdentifier FSRename
    
    # remove background jobs
    $handlers | Remove-Job

    # remove filesystemwatcher
    $fileSystemWatcher.EnableRaisingEvents = $false
    $fileSystemWatcher.Dispose()

    "Event handler disabled."
}


<#

When you run this, the folder specified in $PathToMonitor will be monitored for changes, and
when a change occurs, a message is emitted. When you press CTRL+C, the script ends, and all
event handlers are automatically cleaned up in the finally block.

What's more important: this code uses a queue instantly, so when there are many changes in a 
short period of time, they are processed once PowerShell is no longer busy. You can test this
by uncommenting the masked part in the code for deletion events. Now, whenever a file is
deleted, the handler takes 4 extra seconds.

Event if you delete a great number of files, they will be listed eventually. The approach
presented here is much more dependable than asynchronous handlers based on
WaitForChange() as illustrated in the previous tip.

#>