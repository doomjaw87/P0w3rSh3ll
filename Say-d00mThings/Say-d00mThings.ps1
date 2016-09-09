function Say-d00mThings
{
    [cmdletbinding()]
    param
    (
        #Things you want me to say
        [parameter(mandatory, 
                   ValueFromPipeline, 
                   Position=0)]
        [string[]]$Things,

        #Gender of speaker voice
        [ValidateSet('Male','Female')]
        [parameter()]
        [string]$Gender = 'Female'
    )

    begin
    {
        Add-Type -AssemblyName System.Speech
        $voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
        $voice.SelectVoiceByHints($Gender)
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start = Get-Date
    }

    process
    {
        foreach ($thing in $Things)
        {
            Write-Verbose -Message ('{0} : Speaking {1}' -f $cmdletName, $thing)
            $props = @{Spoken = $thing
                       Gender = $Gender}
            try
            {
                $voice.Speak($thing)
                $props.Add('Success', $true)
            }
            catch
            {
                $props.Add('Success', $false)
            }
            $obj = New-Object -TypeName psobject -Property $props
            Write-Output -InputObject $obj
        }
    }

    end
    {
        Write-Verbose -Message ('{0} : Killing $voice object' -f $cmdletName)
        $voice.Dispose()
        $end = $($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}