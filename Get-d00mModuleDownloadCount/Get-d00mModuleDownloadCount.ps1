<#
.SYNOPSIS
    Get PowerShell gallery module download count

.DESCRIPTION
    Parses PowerShell Gallery module's HTML page for download count.

    Currently acts weird when module doesn't have any downloads, or if the
    download is just 1

.EXAMPLE
    Get-d00mModuleDownloadcount -Name Module1

    This example returns the PowerShellGallery module download count for
    the specified module name, Module1

.EXAMPLE
    'Module1', 'Module2' | Get-d00mModuleDownloadCount

    This example returns the PowerShellGallery module download count for
    the piped in module names, Module1 and Module2
#>
function Get-d00mModuleDownloadCount
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$Name
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
        foreach ($moduleName in $name)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $moduleName)
            try
            {
                $uri = 'https://powershellgallery.com/packages/{0}' -f $moduleName
                Write-Verbose -Message ('{0} : {1} : PowerShellGallery URI = {2}' -f $cmdletName, $moduleName, $uri)

                $params = @{UseBasicParsing = $true
                            Uri             = $uri
                            ErrorAction     = 'Stop'}
                $content = (Invoke-WebRequest @params).Content
                $downloadCount = (($content -split '<p class="stat-label">Downloads</p>')[0] -split '<p class="stat-number">')[-1].Split('<')[0]
                New-Object -TypeName psobject -Property @{ModuleName = $moduleName
                                                          DownloadCount = $downloadCount} |
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