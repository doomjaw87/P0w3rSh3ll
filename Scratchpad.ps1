Clear-host

$creds = Get-Credential
<#
$uri = 'https://outlook.office.com/api/v2.0/me/calendars'
Invoke-RestMethod -UseBasicParsing $uri -Credential $creds -Method Get
#>

# Get calendars
#$t = Invoke-WebRequest -Uri "https://outlook.office365.com/api/v1.0/me/calendars" -Credential $Mycreds | Select-Object -Property Content



#Invoke-RestMethod -Uri "https://outlook.office365.com/api/v1.0/users/stratadmin@teamfrontera.com/calendarview?startDateTime=$(Get-Date)&endDateTime=$((Get-Date).AddDays(7))" -Credential $creds | ForEach-Object {$_.Value}
#Invoke-RestMethod -Uri 'https://outlook.office365.com/api/v1.0/users/namos@teamfrontera.com' -Credential $creds
#Invoke-RestMethod -Uri "https://outlook.office365.com/api/v1.0/users('namos@teamfrontera.com')" -Credential $creds


$uri = "https://outlook.office365.com/api/v1.0/users('asparkman@teamfrontera.com')/events"

<#
$body = @{Subject = 'O365 Calendar API2!'
          Body    = @{ContentType = 'HTML'
                      Content     = 'Testing from O365 REST API2'}
          Start   = '2016-09-09T13:00:00-06:00'
          StartTimeZone = 'Central Standard Time'
          End     = '2016-09-10T14:00:00-06:00'
          EndTimeZone = 'Central Standard Time'
          ShowAs  = 'Busy'
          #Attendees = @(@{EmailAddress = @{Address = 'kprocious@teamfrontera.com'
          #                                 Name    = 'Kevin Procious'}
          #                Type = 'Required'})
        }
#>

$body = @{body = @{ContentType = 'HTML'
                   Content = 'Testing from my function!'}
          StartTimeZone = 'Central Standard Time'
          Subject = 'Hello World'
          ShowAs = 'Busy'
          Start = '2016-09-08T19:43:00-06:00'
          End = '2016-09-09T19:43:00-06:00'
          EndTimeZone = 'Central Standard Time'}

$body = @{Subject = 'Testing again'
          Body    = @{ContentType = 'HTML'
                      Content     = 'Why the fuck is this not working?'}
          Start   = '2016-09-10T19:43:00-06:00'
          StartTimeZone = 'Central Standard Time'
          End     = '2016-09-10T20:00:19-06:00'
          EndTimeZone = 'Central Standard Time'
          ShowAs = 'Busy'}

Invoke-RestMethod -Uri $uri -Method Post -Body (Convertto-Json $body -Depth 100) -Credential $creds -ContentType 'application/json' -Verbose