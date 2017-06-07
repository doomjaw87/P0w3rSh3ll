<#################################
| IMPORTANT POWERSHELL VARIABLES |
##################################

Here is a list of important Powershell variables:

#>

# $PSHome         : the path to the place where PowerShell lives
$PSHOME


# $Home           : the path to your personal profile folder
$HOME


# $PSVersionTable : returns the PowerShell version and versions of important subcomponents
$PSVersionTable


# $Profile        : path to your personal autostart script that gets loaded automatically whenever your current PowerShell hosts starts
$profile

# $profile.CurrentUserAllHosts : is the profile script that is loaded with any host


# $env:PSModulePath : lists the folders where PowerShell modules can be stored that are auto-discoverable for PowerShell
$env:PSModulePath -split ';'