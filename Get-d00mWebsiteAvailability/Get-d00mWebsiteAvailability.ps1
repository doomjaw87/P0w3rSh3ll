<#
.SYNOPSIS
    Checks website availability

.DESCRIPTION
    Iterates through passed in $Url's (or uses default values for the parameter) and gets website's
    status code.

.EXAMPLE
    Get-d00mWebsiteAvailability

    This example gets the website's response status code and status description for each of the 
    default $Url values

.EXAMPLE
    Get-d00mWebsiteAvailability -Url 'http://www.google.com'

    This example gets the provided website's response status code and status description
#>


function Get-d00mWebsiteAvailability
{
    [cmdletbinding()]
    param
    (
        #Url of the website to check availability
        [parameter()]
        [string[]]$Url = @('https://secure.frontstrat.com', 
                           'https://login.teamfrontera.com', 
                           'http://www.teamfrontera.com')
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, $start)
    }

    process
    {
        foreach ($website in $Url)
        {
            Write-Verbose -Message ('{0} : Invoking {1}' -f $cmdletName, $website)
            try
            {
                $responseTime = (Measure-Command -Expression {
                    $response = Invoke-WebRequest -Uri $website -UseBasicParsing
                }).TotalMilliseconds
                $props = @{Url         = $website
                           Status      = $response.StatusCode
                           Description = $response.StatusDescription}
                if ($response.StatusCode -eq 200)
                {
                    $props.Add('Alive', $true)
                    $props.Add('ResponseTime', $responseTime)
                }
                else
                {
                    $props.Add('Alive', $false)
                    $props.Add('ResponseTime', $null)
                }
                $obj = New-Object psobject -Property $props
                Write-Output $obj
            }
            catch
            {
                throw $Error[0]
            }
        }   
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}