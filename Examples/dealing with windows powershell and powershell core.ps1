<##########################################################
| DEALING WITH "WINDOWS POWERSHELL" AND "POWERSHELL CORE" |
###########################################################

ALL VERSIONS

There are 2 PowerShell Editions now: "Windows PowerShell" shipping with Windows, and
running on the full .NET Framework, and the limited "PowerShell Core" running on .NET Core
which is available cross-platform and runs on Nano Server, for example.

Script authors targeting a specific PowerShell edition can now use the #requires statement to
make sure their scripts run on the intended edition.

For example, to ensure that a script runs on PowerShell Core, add this on top o a script:

#>

#requires -PSEdition Core
Get-Process