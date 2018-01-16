<#########################################
| WINDOWS POWERSHELL AND POWERSHELL CORE |
##########################################

Version 5.1 and Later

Lately there has been confusion about PowerShell versions. There is a "PowerShell 6" open
source initiative at GitHub https://github.com/PowerShell/PowerShell

Does that mean the open source PowerShell 6 is the successor of PowerShell 5, and will eventually ship with Windows?

NO. There are just 2 distinct breeds of PowerShell now, so-called "PowerShell Editions".

"Windows PowerShell" as we know it will continue to exist, and will continue to be the version
shipping with future versions of Windows, addressing the full .NET Framework.

The open-source PowerShell 6 initiative is working on "PowerShell Core" which runs on a limited
.NET subset (.NET core). Its purpose is to run in a minimalistic environments like Nano Server,
and on different platforms like Linux and Apple.

Starting in PowerShell 5.1, you can check your "PowerShell Edition" like this:

#>

$PSVersionTable.PSEdition

# "Desktop" indicates that you are running "Windows PowerShell" on a full .NET Framework.
# "Core" indicates that you are running "PowerShell Core" on .NET Core.