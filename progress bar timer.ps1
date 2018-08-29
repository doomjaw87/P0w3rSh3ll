<####################
# Progess Bar Timer #
#####################

Here is a simple example using the PowerShell progress bar. The
code displays a progress bar counting down a break. Simply adjust
the number of seconds you'd like to pause. You could use this
example for displaying breaks in classes or conferences:

#>

$seconds = 5
1..$seconds |
    ForEach-Object {
        $percent = $_ * 100 / $seconds

        $params = @{Activity        = 'Break'
                    Status          = "$($seconds - $_) seconds remain"
                    PercentComplete = $percent}
        Write-Progress @params

        Start-Sleep -Seconds 1
    }