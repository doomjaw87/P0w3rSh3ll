BREAK

<##############################
| Launching PowerShell Hidden |
###############################

Sometimes a PowerShell script should just product something, for example a report, which
then opens in Excel or notepad. You don't want to necessarily show the PowerShell console
window while PowerShell is active. 

There is no easy way to hide PowerShell's console windows because even the parameter 
-WindowStyle Hidden will first show the console andhide it only after it showed.

One way is to use a Windows shortcut to launch your script. Right-click an empty spot on
your desktop, then choose New/Shortcut. A new shortcut is created. Enter this line when
asked for a shortcut location:

#>

powershell -noprofile -executionpolicy bypass -file "c:\path\to\script.ps1"

<#

Click "Next," then add a name for your shortcut. Click "Next" again, and you are almost
done. The shortcut has the blue PowerShell icon, and when you double-click it, your
script runs. Just not hidden yet.

Now you simply right-click the newly created shortcut, choose "Properties," and change the
setting "Run" from "Normal Window" to whatever you want. You can also set a hotkey, and
require Admin privileges.

One drawback: on Windows 10, the setting for "Run" no longer includes the option to hide the
program. You can minimize it at most.

#>