BREAK

<##################################
| How PSCustomObject Really Works |
###################################

Can use PSCustomObject to create new objects really fast:

#>

$object = [PSCustomObject]@{Date     = Get-Date
                            Bios     = Get-WmiObject -Class Win32_Bios
                            Computer = $env:COMPUTERNAME
                            OS       = [Environment]::OSVersion
                            Remark   = 'Things and stuff'}


<#

In reality, [PScustomObject] is not a type, and you are not casting a hash table,
either. What truly happens behind the scenes is the combination of two steps that
you can also execute separately:

#>

#requires -Version 3.0

# Create an ordered hash table...
$hash = [Ordered]@{Date     = Get-Date
                   Bios     = Get-WmiObject -Class Win32_Bios
                   Computer = $env:COMPUTERNAME
                   OS       = [Environment]::OSVersion
                   Remark   = 'Things and stuff'}

# Turn hash table into object
$object = New-Object -TypeName PSObject -Property $hash


<#########################
| SPEEDING UP NEW-OBJECT |
##########################

New-Object creates new instances of objects...

#>
    # EXAMPLE
    Add-Type -AssemblyName System.Speech
    $speak = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    $speak.Speak('Hello I am Powershell!')

    # The approach is always the same, so when you use a different class like
    # System.Net.NetworkInformation.Ping, you can ping IP addresses or hostnames
    $ping = New-Object -TypeName System.Net.NetworkInformation.Ping
    $timeout = 1000
    $result = $ping.Send('google.com', $timeout)
    $result

    # In PowerShell 5 or better, there is an alternative to New-Object that works
    # faster: the static method New() which is exposed by any type. You could
    # rewrite the above examples like this:
    Add-Type -AssemblyName System.Speech
    $speak = [System.Speech.Synthesis.SpeechSynthesizer]::New()
    $speak.Speak('Hello I am PowerShell!')

    # Likewise...
    $timeout = 1000
    $ping = [System.Net.NetworkInformation.Ping]::New()
    $result = $ping.Send('google.com', $timeout)

    # Or even shorter...
    [System.Net.NetworkInformation.Ping]::New().Send('google.com', 1000)