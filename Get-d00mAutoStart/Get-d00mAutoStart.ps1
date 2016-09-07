<#
.SYNOPSIS
    Get start up programs information

.DESCRIPTION
    Query Win32_StartupCommand for process name, location, user, command,
    and description information for local and remote computers

.EXAMPLE
    Get-d00mAutoStart

    This example gets start up process information for the local computer

.EXAMPLE
    Get-d00mAutoStart -ComputerName computer1, computer2

    This example gets start up process information for the remote
    computers, Computer1 and Computer2

.EXAMPLE
    Get-AdComputer | Get-d00mAutoStart

    This example gets a list of computers from AD and retrieves auto start
    process information for each
#>
function Get-d00mAutoStart
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start = Get-Date
        Write-Verbose ('{0} : Begin execution : {1}' -f $cmdletName, $start)
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            try
            {
                $params = @{ComputerName = $computer
                            ClassName    = 'Win32_StartupCommand'
                            ErrorAction  = 'Stop'}
                $autostarts = Get-CimInstance @params
                foreach ($autostart in $autostarts)
                {
                    $props = @{ComputerName = $computer
                               Name         = $autostart.Name
                               Location     = $autostart.Location
                               User         = $autostart.User
                               Command      = $autostart.Command
                               Description  = $autostart.Description}
                    $obj = New-Object psobject -Property $props
                    Write-Output $props
                }
            }
            catch
            {
                Write-Output $false
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