<################################
| READING REGISTRY VALUES FAILS |
#################################

All Versions

Occasionally, reading values of a registry key may fail with a strange error message:

#>

$key = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\0"
Get-ItemProperty -Path $key

# When this occurs, checking the registry key with regedit.exe reveals that one or more of the values in the key are
# damaged. In our example, the value "lParam" seems to be corrputed on all Windows machines. Regedit.exe reports
# "(invalid ... value)"

# In this case, Get-ItemProperty will not read any value. You cannot exclude the value:
Get-ItemProperty -Path $key -Exclude lParam

# What you can do is read just the values that have valid content:
Get-ItemProperty -Path $key -Name DSPath