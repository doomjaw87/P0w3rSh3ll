<#
.SYNOPSIS
    Get backup status from computer

.DESCRIPTION
    Queries Microsoft-Windows-Backup event log for event ID 4 and where Provider
    name is Microsoft-Windows-Backup and returns newest entry

.EXAMPLE
    Get-d00mBackupStatus

    This example gets the latest backup datetime from local machine using default
    credentials

.EXAMPLE
    Get-d00mBackupStatus -ComputerName Server1, Server2 -Credential (Get-Credential)

    This example gets the latest backup datetime from the remote computers, Server1
    and Server2, using supplied credentials

.EXAMPLE
    (Get-AdComputer).Name | Get-d00mBackupStatus -Credential (Get-Credential)

    This example gets the latest backup datetime from the computer names returned
    from the Get-AdComputer cmdlet using supplied credentials

#>
function Get-d00mBackupStatus
{
    [CmdletBinding()]
    param
    (
        #Computer name(s) to check
        [parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position=0)]
        [string[]]$ComputerName = $env:COMPUTERNAME,

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
            $filter = @{LogName      = 'Microsoft-Windows-Backup'
                        ProviderName = 'Microsoft-Windows-Backup'
                        Id           = 4}
        
            $params = @{FilterHashTable = $filter
                        ErrorAction     = 'Stop'
                        ComputerName    = $computer}
            
            if ($Credential -ne $null)
            {
                Write-Verbose -Message ('{0} : Using supplied credentials' -f $cmdletName)
                $params.Add('Credential', $Credential) | Out-Null
            }
            else
            {
                Write-Verbose -Message ('{0} : Using default credentials' -f $cmdletName)
            }

            try
            {
                Write-Verbose -Message ('{0} : {1} : Getting event log' -f $cmdletName, $computer)
                $event = Get-WinEvent @params |
                    Select-Object -First 1
                New-Object -TypeName psobject -Property @{ComputerName = $computer
                                                          TimeCreated  = $event.TimeCreated
                                                          Message      = $event.Message} | 
                    Write-Output
            }
            catch
            {
                throw
            }
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}