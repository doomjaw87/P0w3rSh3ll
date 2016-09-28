function Install-d00mWMF5
{
    [CmdletBinding()]
    param
    (
        #Filepath to WMF 5 MSU
        [parameter(Mandatory = $True)]
        [string]$FilePath
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.StopWatch
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, (Get-Date))
        $timer.Start()
    }

    process
    {
        try
        {
            New-Item -Path C:\temp -Name wmf5 -ItemType Directory -Force
            expand -f:* "$FilePath" "c:\temp\wmf5"
            $wmf5FilePath = Get-ChildItem -Path C:\temp\wmf5 | Where-Object {$_.Extension -eq '.cab' -and $_.Name -notlike '*WSUS*'}
            
            $argumentList = '/online /add-package /packagepath:c:\temp\wmf5\{0} /quiet /norestart' -f $wmf5FilePath.Name
            Start-Process -FilePath 'dism.exe' -ArgumentList $argumentList -Wait

            Remove-Item C:\temp\wmf5 -Recurse -Force
        }
        catch
        {
            throw
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}