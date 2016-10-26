function Get-d00mSharePermissions
{
    param
    (
        [cmdletbinding()]
        [parameter(mandatory                      = $true,
                   Position                       = 0,
                   ValueFromPipeline              = $true,
                   ValueFromPipelineByPropertyName= $true)]
        [string[]]$ComputerName,

        [parameteR(mandatory = $true,
                   Position  = 1)]
        [string[]]$ShareName
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
        foreach ($computer in $ComputerName)
        {
            Write-Verbose -Message ('{0} : {1} : Begin execution' -f $cmdletName, $computer)

            foreach ($s in $ShareName)
            {
                Write-Verbose -Message ('{0} : {1} : Getting {2} share permission settings' -f $cmdletName, $computer, $s)

                try
                {
                    $params = @{Class        = 'Win32_LogicalShareSecuritySetting'
                                Filter       = ("Name='{0}'" -f $s)
                                ComputerName = $computer
                                ErrorAction  = 'Stop'}
                    $shareSecurity = Get-WmiObject @params
                    if ($shareSecurity)
                    {
                        Write-Verbose -Message ('{0} : {1} : Found {2} share' -f $cmdletName, $computer, $s)
                        foreach ($share in $shareSecurity)
                        {
                            $descriptor = $share.GetSecurityDescriptor()

                            Write-Verbose -Message ('{0} : {1} : Iterating through {2} ACLs' -f $cmdletName, $computer, $s)
                            foreach ($dacl in $descriptor.Descriptor.DACL)
                            {
                                $props = @{ComputerName = $computer
                                           ShareName    = $s
                                           Domain       = $dacl.Trustee.Domain
                                           ID           = $dacl.Trustee.Name}

                                $mask = switch ($dacl.AccessMask)
                                {
				                    2032127     {'FullControl'}
				                    1179785     {'Read'}
				                    1180063     {'Read, Write'}
				                    1179817     {'ReadAndExecute'}
				                    -1610612736 {'ReadAndExecuteExtended'}
				                    1245631     {'ReadAndExecute, Modify, Write'}
				                    1180095     {'ReadAndExecute, Write'}
				                    268435456   {'FullControl (Sub Only)'}
				                    default     {$DACL.AccessMask}                                
                                }
                                $props.Add('Access', $mask)

                                $type = switch ($dacl.AceType)
                                {
                                    0 {'Allow'}
                                    1 {'Deny'}
                                    2 {'Audit'}
                                }
                                $props.Add('AccessType', $type)

                                New-Object -TypeName psobject -Property $props | 
                                    Write-Output

                                $mask, $type = $null
                            }
                        }
                    }

                    else
                    {
                        Write-Warning -Message ('{0} : {1} : Could not find share {2}' -f $cmdletName, $computer, $s)
                    }
                }
            
                catch
                {
                    throw
                }

                Write-Verbose -Message ('{0} : {1} : End {2} execution' -f $cmdletName, $computer, $s)
            }

            Write-Verbose -Message ('{0} : {1} : End execution' -f $cmdletName, $computer)
        }
    }

    end
    {
        $timer.Stop()
        Write-Verbose -Message ('{0} : End execution. {1} ms' -f $cmdletName, $timer.ElapsedMilliseconds)
    }
}