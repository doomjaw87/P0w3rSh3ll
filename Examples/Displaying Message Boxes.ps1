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