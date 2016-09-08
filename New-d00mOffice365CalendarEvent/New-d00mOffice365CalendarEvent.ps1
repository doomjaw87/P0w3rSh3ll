<#
.SYNOPSIS
    Create a new Office 365 calendar event

.DESCRIPTION
    Creates a new calendar event in Office 365 for a user

.EXAMPLE
    New-d00mOffice365CalendarEvent

.EXAMPLE

.EXAMPLE

#>
function New-d00mOffice365CalendarEvent
{
    [CmdletBinding()]
    param
    (
        [parameter(mandatory)]
        [String]$Title,

        [parameter(mandatory)]
        [string]$Body,

        [parameter(mandatory)]
        [DateTime]$StartTime,

        [parameter(mandatory)]
        [DateTime]$EndTime,

        [ValidateSet('Pacific Standard Time',
                     'Mountain Standard Time',
                     'Central Standard Time',
                     'Eastern Standard Time')]
        [parameter()]
        [String]$TimeZone = ([TimeZoneInfo]::Local).StandardName,

        [parameter()]
        [String]$Location,

        [ValidateSet('Normal',
                     'Personal',
                     'Private',
                     'Confidential')]
        [parameter()]
        [String]$Sensitivity = 'Normal',

        [parameter()]
        [String[]]$Attendees,

        [parameter(mandatory)]
        [pscredential]$Credential
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $cmdStart   = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, 
                                                                 $start)
    }

    process
    {
        $utcOffset = @{'Pacific Standard Time'  = '-08:00'
                       'Mountain Standard Time' = '-07:00'
                       'Central Standard Time'  = '-06:00'
                       'Eastern Standard Time'  = '-05:00'}
        $start = '{0}{1}' -f $StartTime.ToString('yyyy-MM-ddTHH:mm:ss'), $utcOffset.$TimeZone
        Write-Verbose -Message ('{0} : Formatted start = {1}' -f $cmdletName, $start)

        $end   = '{0}{1}' -f $EndTime.ToString('yyyy-MM-ddTHH:mm:ss'), $utcOffset.$TimeZone
        Write-Verbose -Message ('{0} : Formatted end = {1}' -f $cmdletName, $end)
        
        Write-Verbose -Message ('{0} : TimeZone = {1}' -f $cmdletName, $TimeZone)

        $calendarParams = [ordered]@{Subject = $Title
                                     Body    = @{ContentType = 'HTML'
                                                 Content     = $Body}
                                     Start         = $start
                                     StartTimeZone = $TimeZone
                                     End           = $end
                                     EndTimeZone   = $TimeZone
                                     ShowAs        = 'Busy'}
        Write-Verbose -Message ('{0} : Subject = {1}' -f $cmdletName, $Title)
        Write-Verbose -Message ('{0} : Content = {1}' -f $cmdletName, $Body)

        $uri = "https://outlook.office365.com/api/v1.0/users('$($Credential.UserName)')/events"
        Write-Verbose -Message ('{0} : Uri = {1}' -f $cmdletName, $uri)

        $apiParams = @{Uri         = $uri
                       Body        = $(ConvertTo-Json -InputObject $calendarParams -Depth 10)
                       Method      = 'Post'
                       Credential  = $Credential
                       ContentType = 'application/json'}
        $response = Invoke-WebRequest @apiParams
    }

    end
    {
        $end = $($(Get-Date) - $cmdStart).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}