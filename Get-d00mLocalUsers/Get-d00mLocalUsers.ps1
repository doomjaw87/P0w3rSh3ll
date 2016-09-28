<#
.SYNOPSIS

.DESCRIPTION
    
.EXAMPLE

.EXAMPLE

.EXAMPLE

#>
function Get-d00mLocalUsers
{
    [CmdletBinding()]
    param
    (
        #Computer name(s) to check for pending reboot
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position=0)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [parameter()]
        [validateset('Administrators',
                     'Backup Operators',
                     'Event Log Readers',
                     'Guests',
                     'Performance Log Users',
                     'Performance Monitor Users',
                     'Power Users',
                     'Remote Desktop Users',
                     'Remote Management Users',
                     'Users')]
        [string[]]$LocalGroup = 'Administrators',

        [parameter()]
        [pscredential]$Credential
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
            $sessionParams = @{ComputerName = $computer
                               ErrorAction  = 'Stop'}
            if ($Credential -ne $null)
            {
                $sessionParams.Add('Credential', $Credential)
                Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
            }
            else
            {
                Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
            }

            $session = New-PSSession @sessionParams
            foreach ($group in $LocalGroup)
            {
                Write-Verbose -Message ('{0} : {1} : Getting {2} members' -f $cmdletName, $computer, $group)
                $members = Invoke-Command -Session $session -ErrorAction Stop -ScriptBlock {
                    net.exe localgroup $args[0] |
                        Where-Object {
                            $_ -and $_ -notmatch 'command completed successfully'
                        } | Select-Object -Skip 4
                } -ArgumentList $group
                foreach ($member in $members)
                {
                    New-Object -TypeName psobject -Property @{ComputerName = $computer
                                                              LocalGroup   = $group
                                                              UserName     = $member} |
                        Write-Output
                }
            }

            Remove-PSSession -Session $session
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}