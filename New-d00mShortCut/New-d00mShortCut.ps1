<#
.SYNOPSIS
	Create a new shortcut file in the filesystem

.DESCRIPTION
	Given the location (web or on local filesystem) of a file, create
	a shortcut file on the local filesystem.

.EXAMPLE
	New-d00mShortCut -WebDestination 'https://www.google.com' -FilePath 'c:\Google.lnk'

	This example creates a shortcut to the webpage in the c:\ drive.

.EXAMPLE
	New-d00mShortCut -FileSystemDestination 'c:\windows\system32\WindowsPowerShell\v1.0\PowerShell.exe' -FilePath 'c:\Users\Public\Desktop\PowerShell.lnk'

	This example creates a shortcut to the PowerShell.exe in the public user's desktop directory.
	(Which may be something you don't want to do...)
#>

Function New-d00mShortCut
{
	[cmdletbinding()]
	param
	(
		#Web Destination of the shortcut file to be created
		[parameter(mandatory, ParameterSetName='webshortcut')]
		[string]$WebDestination,
        
        #Filesystem destination of the shortcut file to be created
        [parameter(mandatory, parametersetname='filesystemshortcut')]
        [string]$FileSystemDestination,

		#Local filesystem path of the shortcut to be created
		[parameter(mandatory)]
		[string]$FilePath
	)

	begin
	{
		$cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
		$start      = Get-Date
		Write-Verbose -Message ('{0}\{1} : {2} : Begin process' -f $cmdletName, 
                                                                   $PSCmdlet.ParameterSetName, 
                                                                   $start)
	}

	process
	{
        Write-Verbose -Message ('{0}\{1} : Ensuring {2} does not already exist' -f $cmdletName,
                                                                                   $PSCmdlet.ParameterSetName,
                                                                                   $FilePath)
        if (!(Test-Path -Path $FilePath))
        {
            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortCut($FilePath)
            Write-Verbose -Message ('{0}\{1} : Ensuring {2} does not already exist successful' -f $cmdletName,
                                                                                                  $PSCmdlet.ParameterSetName,
                                                                                                  $FilePath)
            if ($PSCmdlet.ParameterSetName -eq 'webshortcut')
            {
                Write-Verbose -Message ('{0}\{1} : Checking URL validity {2}' -f $cmdletName,
                                                                                 $PScmdlet.ParameterSetName,
                                                                                 $WebDestination)
                try
                {
                    $request = Invoke-WebRequest -Uri $WebDestination -ErrorAction Stop
                    if ($request.StatusCode -eq 200)
                    {
                        $shortcut.TargetPath = $WebDestination
                        $shortcut.Save()
                    }
                    else
                    {
                        Write-Error -Message ('Could not find {0}' -f $WebDestination)
                    }
                }
                catch
                {
                    Write-Error -Message ('Could not find {0}' -f $WebDestination)
                }
            }
            else
            {
                Write-Verbose -Message ('{0}\{1} : Ensuring {1} exists' -f $cmdletName,
                                                                           $PSCmdlet.ParameterSetName,
                                                                           $FileSystemDestination)
                if (Test-Path -Path $FileSystemDestination)
                {
                    $shortcut.TargetPath = $FileSystemDestination
                    $shortcut.Save()
                }
                else
                {
                    Write-Error -Message ('{0} does not exist!' -f $FileSystemDestination)
                }
            }
        }
        else
        {
            Write-Error -Message ('{0} already exists!' -f $FilePath)
        }
	}

	end
	{
		$end = Get-Date
		Write-Verbose -Message ('{0}\{1} : {2} : End process' -f $cmdletName, 
                                                                 $PSCmdlet.ParameterSetName,
                                                                 $end)
		$totalruntime = ($end - $start).TotalMilliseconds
		Write-Verbose -Message ('{0}\{1} : Total run time : {2} ms' -f $cmdletName, 
                                                                       $PSCmdlet.ParameterSetName,
                                                                       $totalruntime)
	}
}