<########################
| ALTERNATE GET-SERVICE |
#########################

All Versions

The cmdlet Get-Service has a number of drawbacks. For example, there is no parameter to filter
running or stopped services, and the results do not include the service startmode.

WMI can deliver such information. Here is a simple function that gets the most often needed
service information:

#>

function Get-ServiceWithWMI
{
    param
    (
        $Name      = '*',
        $State     = '*',
        $StartMode = '*'
    )

    Get-WmiObject -Class Win32_Service |
        Where-Object Name -Like $Name |
        Where-Object State -like $State | 
        Where-Object StartMode -Like $StartMode |
        Select-Object -Property Name, DisplayName, StartMode, State, ProcessID, Description
}