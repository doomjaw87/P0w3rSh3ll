<#############################################
| RESPONDING TO NEW EVENT LOG ENTIRES (PT 2) |
##############################################

ALL VERSIONS

In the previous tip we explaind how PowerShell can listen to "EntryWritten" events and respond
immediately when new event log entries are written. Since event handlers are executed in the
background, and can only run when PowerShell is not busy, let's now complete the example by
using Wait-Event

To install an event handler that responds to newly written event log entries, run this:

#>

# set the event log name you want to subscribe to
# Use Get-EventLog -AsString for a list of available event log names

$Name = 'Application'

# get an instance
$log = [System.Diagnostics.EventLog]$Name

# determine what to do when an event occurs
$Action = {
    # get the original event entry that triggered the event
    $entry = $event.SourceEventArgs.Entry

    # log all events
    Write-Host "Received from $($entry.Source): $($entry.Message)"

    # do something based on a specific event
    if ($entry.EventId -eq 1 -and $entry.Source -eq 'WinLogon')
    {
        Write-Host "Test event was received!" -ForegroundColor Red
    }
}

# subscribe to its "EntryWritten" event
$job = Register-ObjectEvent -InputObject $log -EventName EntryWritten -SourceIdentifier 'NewEventHandler' -Action $Action

# run whenever an event is written to the log, $Action is executed
# use a loop to keep PowerShell busy. You can abort via CTRL+C

Write-Host "Listening to events" -NoNewline

try
{
    do
    {
        Wait-Event -SourceIdentifier NewEventHandler -Timeout 1
        Write-Host "." -NoNewline
    } while ($true)
}
finally
{
    # this executes when CTRL+C is pressed
    Unregister-Event -SourceIdentifier NewEventHandler
    Remove-Job -Name NewEventHandler
    Write-Host ""
    Write-Host "Event handler stopped"
}

# While the event handler is active, PowerShell outputs dots every second, indicating it is
# listening. Now open a second PowerShell window, and run this:

Write-EventLog -LogName Application -Source WinLogon -EntryType Informaiton -Message 'Testing' -EventId 1


<#

Whenever a new Application event log entry is written, the event handler echos the event details.
If the event has an EventID equals 1 and the source of "WinLogon", like in our test event entry, a
red message is output as well.

To end the event handler, press CTRL+C. The code automatically cleans up and removes the
event handler from memory.

This all orks by using Wait-Event: this cmdlet can wait for a specific event to occur, and while it
waits, PowerShell continues to process the event handler. When you specify a timeout (in
seconds), the cmdlet returns control to your script. In our example, control is returned every
second, enabling the script to output a progress indicator like the dots.

If the user presses CTRL+C, the script won't stop immediately. Instead, it first executes the
finally block and makes sure the event handler is cleaned up and removed.



#>