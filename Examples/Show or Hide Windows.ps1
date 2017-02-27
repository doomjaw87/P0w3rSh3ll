<#######################
| SHOW OR HIDE WINDOWS |
########################

PowerShell can call internal Windows API functions, and in this example, we'd like to show how
you can change the show state of an application window. You'll be able to maximize, minimize,
hide, or show, for example.

The example uses PowerShell 5's new enum capability to give the showstate numbers
meaningful names. In older versions of PowerShell, simply remove the enum, and use the 
appropriate showstate numbers directly in the code.

The key learning point here is to use Add-Type to take a C#-style signature of an API
method and return a type that exposes this method to your PowerShell code.

#>

#requires -Version 5.0
# this enum works in PowerShell 5 only
# in earlier versions, simply remove the enum
# and use the numbers for the desired window state
# directly

Enum ShowStates
{
    Hide = 0
    Normal = 1
    Minimized = 2
    Maximized = 3
    ShowNoActivateRecentPosition = 4
    Show = 5
    MinimizeActivateNext = 6
    MinimizeNoActivate = 7
    ShowNoActivate = 8
    Restore = 9
    ShowDefault = 10
    ForceMinimize = 11
}

# The c#-style signature of an API function (see also www.pinvoke.net)
$code = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$type = Add-Type -MemberDefinition $code -Name myAPI -PassThru

# access a process
# (in this example, we are accessing the current powershell host
# with its process id being present in $pid, but you can use
# any process ID instead)
$process = Get-Process -Id $pid

# get the process window handle
$hwnd = $process.MainWindowHandle

# apply a new window size to the handle, i.e. hide the window completely
$type::ShowWindowAsync($hwnd, [ShowStates]::Hide)

Start-Sleep -Seconds 2

# restore the window handle again
$type::ShowWindowAsync($hwnd, [ShowStates]::Show)