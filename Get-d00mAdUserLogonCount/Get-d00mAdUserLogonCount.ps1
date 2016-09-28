<#
.SYNOPSIS

.DESCRIPTION
    
.EXAMPLE

.EXAMPLE

.EXAMPLE

#>
function Get-d00mAdUserLogonCount
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position = 0)]
        [string[]]$UserName,

        [parameter()]
        [string[]]$AdServer
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
        if ($AdServer -eq $null)
        {
            $AdServer = ((Get-ADForest).GlobalCatalogs).Where{$_ -notlike '*azure*'}
            Write-Verbose -Message ('{0} : Identified {1} Global Catalog AD servers' -f $cmdletName, $AdServer.Count)
        }
        
        foreach ($user in $UserName)
        {
            $logonCounts = New-Object -TypeName System.Collections.ArrayList
            foreach ($server in $AdServer)
            {
                Write-Verbose -Message ('{0} : {1} : {2} : Getting logon counts' -f $cmdletName, $user, $server)
                $params = @{Identity    = $user
                            Properties  = 'LogonCount'
                            Server      = $server
                            ErrorAction = 'Stop'}
                $logonCounts.Add($(Get-AdUSer @params | Select-Object -ExpandProperty LogonCount)) | 
                    Out-Null
            }
            New-Object -TypeName psobject -Property @{UserName        = $user
                                                      TotalLogonCount = $(($logonCounts | Measure-Object -sum).Sum)
                                                      AdServers       = $AdServer
                                                      DateOfQuery     = (Get-Date)} |
                Write-Output
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}