<##################
| EXPLORE OBJECTS |
###################

In PowerShell, anything is represented by objects, and here is a helpful one-liner that examines
any object and copies its members as text into your clipboard.

#>

"Hello" |
    Get-Member|
        Format-Table -AutoSize -Wrap |
            Out-String -Width 150 |
                clip.exe