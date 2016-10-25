function Get-d00mDirectorySize
{
    [cmdletbinding()]
    param
    (
        [parameter(mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position=0)]
        [string[]]$DirectoryPath
    )

    begin
    {
        $timer = New-Object -TypeName System.Diagnostics.Stopwatch
        $cmdletName = $MyInvocation.MyCommand.Name
        
        $timer.Start()
        Write-Verbose -Message ('{0} : Begin execution {1}' -f $cmdletName, (Get-Date))
    }

    process
    {
        foreach ($dPath in $DirectoryPath)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $dPath)
            try
            {
                Get-ChildItem -Path $dPath -Directory | ForEach-Object {
                    $dirPath = $_.FullName
                    $size = (Get-ChildItem -Path $_.FullName -Recurse -Force | Measure-Object -Property length -Sum).Sum/1mb
                    New-Object -TypeName psobject -Property @{PathName = $dirPath
                                                              SizeMB   = ('{0:N2}' -f ($size))} |
                    Write-Output
                }
            }
            catch
            {

            }

            Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $dPath)
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution. {1} ms' -f $cmdletName, $timer.ElapsedMilliseconds)
    }
}