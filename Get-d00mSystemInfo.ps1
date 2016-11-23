<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.PARAMETER

.EXAMPLE

.EXAMPLE

.EXAMPLE

#>
function Get-d00mSystemInfo
{
    [CmdletBinding()]
    param
    (
        [alias('name')]
        [parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName,

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
            try
            {
                Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)
                $sessionParams = @{ComputerName = $computer
                                   ErrorAction  = 'SilentlyContinue'}
                if ($Credential -ne $null)
                {
                    Write-Verbose -Message ('{0} : {1} : Using supplied credentials' -f $cmdletName, $computer)
                    $sessionParams.Add('Credential', $Credential)
                }
                else
                {
                    Write-Verbose -Message ('{0} : {1} : Using default credentials' -f $cmdletName, $computer)
                }
                
                $session = New-PsSession @sessionParams
                if ($session)
                {
                    $systeminfo = Invoke-Command -Session $session -ScriptBlock {
                        systeminfo /FO csv | 
                            ConvertFrom-Csv |
                            Write-Output
                    }

                    $procs = New-Object -TypeName System.Collections.ArrayList
                    $procsList = $systeminfo.'Processor(s)'.Split(',')
                    foreach ($p in $procsList)
                    {
                        if ($p -notlike '*Installed*')
                        {
                            $procs.Add($p) | Out-Null
                        }
                    }

                    $hotfixes = New-Object -TypeName System.Collections.ArrayList
                    $hotfixList = $systeminfo.'Hotfix(s)'.Split(',')
                    foreach ($h in $hotfixList)
                    {
                        if ($h -notlike '*Installed*')
                        {
                            $hotfixes.Add($h) | Out-Null
                        }
                    }

                    $nics = New-Object -TypeName System.Collections.ArrayList
                    $nicList = $systeminfo.'Network Card(s)'.Split(',')
                    foreach ($n in $nicList)
                    {
                        if (($n -notlike '*Installed*') -and ($n -like '*]:*') -and ($n -notlike '*.*') -and ($n -notlike '*::*'))
                        {
                            if ($n -like '      ')
                            {
                                $n = ($n -split '      ')[-1]
                            }
                            $nics.Add($n) | Out-Null
                        }
                    }

                    New-Object -TypeName psobject -Property @{HostName               = $systeminfo.'Host Name'
                                                              OSName                 = $systeminfo.'OS Name'
                                                              OSVersion              = $systeminfo.'OS Version'
                                                              OSManufacturer         = $systeminfo.'OS Manufacturer'
                                                              OSConfiguration        = $systeminfo.'OS Configuration'
                                                              OSBuildType            = $systeminfo.'OS Build Type'
                                                              RegisteredOwner        = $systeminfo.'Registered Owner'
                                                              RegisteredOrganization = $systeminfo.'Registered Organization'
                                                              ProductID              = $systeminfo.'Product ID'
                                                              OriginalInstallDate    = $systeminfo.'Original Install Date'
                                                              SystemBootTime         = $systeminfo.'System Boot Time'
                                                              SystemManufacturer     = $systeminfo.'System Manufacturer'
                                                              SystemModel            = $systeminfo.'System Model'
                                                              SystemType             = $systeminfo.'System Type'
                                                              Processors             = $procs
                                                              BIOSVersion            = $systeminfo.'BIOS Version'
                                                              WindowsDirectory       = $systeminfo.'Windows Directory'
                                                              SystemDirectory        = $systeminfo.'System Directory'
                                                              BootDevice             = $systeminfo.'Boot Device'
                                                              SystemLocale           = $systeminfo.'System Locale'
                                                              InputLocale            = $systeminfo.'Input Locale'
                                                              TimeZone               = $systeminfo.'Time Zone'
                                                              TotalPhysicalMemory    = [math]::Round(([int]$systeminfo.'Total Physical Memory'.Split(' ')[0])/1024)
                                                              Domain                 = $systeminfo.'Domain'
                                                              LogonServer            = $systeminfo.'Logon Server'
                                                              Hotfixes               = $hotfixes
                                                              NetworkInterfaces      = $nics
                                                              HyperVRequirements     = $systeminfo.'Hyper-V Requirements'.Split(',')} | 
                        Write-Output

                    Remove-PSSession -Session $session
                }
                else
                {
                    Write-Warning -Message ('{0} : {1} : Could not establish remote PSSession' -f $cmdletName, $computer)
                }
            }
            catch
            {
                throw
            }
            Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $computer)
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $timer.Elapsed.TotalMilliseconds)
    }
}