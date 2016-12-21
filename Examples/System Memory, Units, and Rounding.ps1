<#####################################
| SYSTEM MEMORY, UNITS, AND ROUNDING |
######################################

Sometimes, you'd like to use different units of measurements. The total system
memory is reported in bytes, for example. Here are some examples how you can
turn bytes into GB and still make the result look nice:

#>

$memory = Get-WmiObject -Class Win32_ComputerSystem |
    Select-Object -ExpandProperty TotalPhysicalMemory

$memoryGB = $memory/1GB

# Raw result in bytes
$memoryGB

# Rounding
[Int]$memoryGB
[Math]::Round($memoryGB)
[Math]::Round($memoryGB, 1)

# String formatting
'{0:n1} GB' -f $memoryGB