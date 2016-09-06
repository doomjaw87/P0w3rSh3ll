<#
.SYNOPSIS
    Checks for Skype for Business 2016 installation

.DESCRIPTION
    Checks file system for Skype for Business 2016 application. Returns a PSObject with whether or not
    the script found the application and which version it detected (x86 or x64).

.EXAMPLE
    Get-d00mSkypeForBusiness2016Installation

    This example will check the local computer's file system for the Skype For Business 2016 application

.EXAMPLE
    Get-d00mSkypeForBusiness2016Installation -ComputerName computer1, computer2 -Credential (Get-Credential)
    
    This example will check the remote computers file system for the Skype for Business 2016 application using
    the provided credentials.

.EXAMPLE
    Get-AdComputer | Get-d00mSkypeForBusiness2016Installation

    This example will get AD computers and pipe the computer name property to the cmdlet and then retrieve
    Skype For Business 2016 installation information for each computer passed in.
#>


function Get-d00mSkypeForBusiness2016Installation
{
    [cmdletbinding()]
    param
    (
        [parameter(ValueFromPipelineByPropertyName)]
        [string[]]$computerName = $env:COMPUTERNAME,

        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start = Get-Date
        Write-Verbose ('{0} : Begin execution : {1}' -f $cmdletName, $start)
    }

    process
    {
        foreach ($computer in $computerName)
        {
            $params = @{ComputerName = $computer}
            if ($Credential -ne $Null)
            {
                $params.Add('Credential', $Credential)
            }
            Write-Verbose ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            $result = Invoke-Command @params -ScriptBlock {
                if (Test-Path -Path 'C:\Program Files\Microsoft Office\root\Office16\lync.exe')
                {
                    return 'x64'
                }
                else
                {
                    if (Test-Path -Path 'C:\Program Files (x86)\Microsoft Office\root\Office16\lync.exe')
                    {
                        return 'x86'
                    }
                    else
                    {
                        return $null
                    }
                }
            }
            $props = @{ComputerName = $computer}
            if ($result)
            {
                $props.Add('SkypeForBusiness', $true)
                $props.Add('Version', $result)
            }
            else
            {
                $props.Add('SkypeForBusiness', $false)
                $props.Add('Version', $result)
            }
            $obj = New-Object -TypeName psobject -Property $props
            Write-Output $obj
        }
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}