BREAK

#########  #       #  #########
#          #       #      #
#   #####  #       #      #
#       #  #       #      #
#       #  #       #      #
#########  #########  #########


<#####################
# WPF Dialog Windows #
######################

It is easy to use WPF (Windows Presentation Foundation) to create and show simple
dialog windows in PowerShell. If you would like to display a quick message, check
this out...
#>
Add-Type -AssemblyName PresentationFramework
$window = New-Object -TypeName Windows.Window
$window.Title = 'Warning!'
$window.WindowStartupLocation = 'CenterScreen'
$window.Topmost = $true
$text = New-Object -TypeName System.Windows.Controls.TextBlock
$text.Text = 'You should stop working and get some sunshine every now and then!'
$text.Margin = 20
$window.Content = $text
$window.SizeToContent = 'WidthAndHeight'
$window.ShowDialog() | Out-Null


<###########################
# WPF Message Box Function #
###########################>
Add-type -AssemblyName PresentationFramework
function Show-d00mWpfMessageBox
{
    param
    (
        [Parameter(Mandatory=$true)]
        $Prompt,

        $Title = 'Windows PowerShell',

        [Windows.MessageBoxButton]
        $Buttons = 'YesNo',

        [Windows.MessageBoxImage]
        $Icon = 'Information'
    )

    [System.Windows.MessageBox]::Show($Prompt, $Title, $Buttons, $Icon)
}


$result = Show-MessageBox -Prompt 'Holla' -Buttons OKCancel -Icon Exclamation

If ($result -eq 'OK')
{
    Restart-Computer -WhatIf
}



<###########################
# DISPLAYING MESSAGE BOXES #
############################

PowerShell can access all public .NET classes, so it is easy
enough to create a message box...
#>
$result = [System.Windows.MessageBox]::Show('Hello from direct .NET call!',
                                            'Hello!',
                                            'OK',
                                            'Information')
$result

<#
However, you would need to know the supported values for the
parameters. PowerShell can easily wrap this .NET call into a
PowerShell function wich then provides IntelliSense for all
parameters...
#>

#requires -Version 3.0
Add-Type -AssemblyName PresentationFramework
function Show-d00mMessageBox
{
    param
    (
        [parameter(mandatory)]
        [string]$Prompt,

        [parameter()]
        [string]$Title = 'PowerShell',

        [parameter()]
        [Windows.MessageBoxButton]$Button = 'OK',

        [parameter()]
        [Windows.MessageBoxImage]$Icon = 'Information'
    )

    [Windows.MessageBox]::Show($Prompt, $Title, $Button, $Icon)
}

$params = @{Prompt = 'Hello from PowerShell .NET function!'
            Title  = 'Hello!'
            Button = 'OK'
            Icon   = 'Information'}
Show-d00mMessageBox @params



