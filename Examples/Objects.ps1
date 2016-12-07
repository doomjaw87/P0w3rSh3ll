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