<#
.SYNOPSIS
	Create a new shortcut file in the filesystem

.DESCRIPTION
	Given the location (web or on local filesystem) of a file, create
	a shortcut file on the local filesystem.

.EXAMPLE
	New-d00mShortCut -Destination 'https://www.google.com' -FilePath 'c:\Google.lnk'

	This example creates a shortcut to the webpage in the c:\ drive.

.EXAMPLE
	New-d00mShortCut -Destination 'c:\windows\system32\WindowsPowerShell\v1.0\PowerShell.exe' -FilePath 'c:\Users\Public\Desktop\PowerShell.lnk'

	This example creates a shortcut to the PowerShell.exe in the public user's desktop directory.
	(Which may be something you don't want to do...)
#>

Function New-d00mShortCut
{
	[cmdletbinding()]
	param
	(
		#Destination of the shortcut file to be created
		[parameter(mandatory, position=0)]
		[string]$Destination,

		#Local filesystem path of the shortcut to be created
		[parameter(mandatory, position=1)]
		[string]$FilePath
	)

	begin
	{
		$cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
		$start      = Get-Date
		Write-Verbose -Message ('{0} : {1} : Begin process' -f $cmdletName, $start)
	}

	process
	{
		Write-Verbose -Message ('{1} : Destination : {1}' -f $cmdletName, $Destination)
		$shell = New-Object -ComObject WScript.Shell
		$shortcut = $shell.CreateShortCut("$FilePath")
		$shortcut.TargetPath = "$Destination"
		$shortcut.Save()
	}

	end
	{
		$end = Get-Date
		Write-Verbose -Message ('{0} : {1} : End process' -f $cmdletName, $end)
		$totalruntime = ($end - $start).TotalMilliseconds
		Write-Verbose -Message ('{0} : Total run time : {1} ms' -f $cmdletName, $totalruntime)
	}
}