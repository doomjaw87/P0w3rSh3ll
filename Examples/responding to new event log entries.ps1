<######################################
| RESPONDING TO NEW EVENT LOG ENTRIES |
#######################################

All Versions

If you'd like to respond to new event log entries in real time, here is how your PowerShell code
can be notified the moment a new event entry is written:

#>

# Use Get-EventLog -AsString for a list of available event log names
$Name = 'Application'

# get an instance
$Log = [System.Diagnostics.EventLog]$Name

# determine what to do when an event occurs
$Action = {
    
    # get the original event entry that triggered the event
    $entry = $event.SourceEventArgs.Entry

    # do something based on the event
    if ($entry.EventId -eq 1 -and $entry.Source -eq 'WinLogon')
    {
        Write-Host 'Test event received!'
    }
}

# subscribe to its "EventWritten" event
$job = Register-ObjectEvent -InputObject $log -EventName EntryWritten -SourceIdentifier 'NewEventHandler' -Action $Action


# This code snippet installs a background event listener which responds whenever the event log
# emits a "EntryWritten" event. When that occurs, the code in $Action executes. It gets the event
# that triggered the action by querying the $event variable, and in our example, when the EventId
# equals 1, adn the event source is "WinLogon", a message is written. Of course, you could as
# well send off an email, write a log, or do whatever else is useful.

# To see the event handler in action, simply write a test event entry that meets the criteria
Write-EventLog -LogName Application -Source WinLogon -EntryType Information -Message 'Testing' -EventId 1

# Once you run the above line, the event handler executes and writes its message to the console.


# Note that this example installs an asynchronous handler that works in the background whenever
# PowerShell is not busy, and for as long as PowerShell runs. You can't keep the script busy by
# running Start-Sleep or a loop (because then PowerShell would be busy, and unable to process
# the event handler in the background). To keep this event handler responsive, you could start the
# script with the -NoExit parameter

# PowerShell.exe -noprofile -noexit -file "c:\script.ps1"


# To remove the handler, run:
Unregister-Event -SourceIdentifier NewEventHandler
Remove-Job -Name NewEventHandler