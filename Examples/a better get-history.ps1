<#######################
| A BETTER GET-HISTORY |
########################

When you type "h" in PowerShell, you see the history of commands you entered during your session.
Here is a clever alternative called "h+" that opens up a grid view window instead and lets you
pick the commands from your history. Hold CTRL to select multiple items.

All selected items are placed into the clipboard. From there, you choose what to do: you can paste them
into documentations, or paste them back into PowerShell to execute them. Even when you paste
them back into PowerShell, you get the chance to review the commands before you press ENTER to run
them.

#>

function h+
{
    $viewParams = @{Title      = 'Command History - press CTRL to selectle multiple - Selected commands copied to clipboard'
                    OutputMode = 'Multiple'}

    $loopParams = @{Begin   = {[Text.StringBuilder]$sb=''}
                    Process = {$null = $sb.AppendLine($_.CommandLine)}
                    End     = {$sb.ToString() | .\clip.exe}}

    Get-History | Out-GridView @viewParams | ForEach-Object @loopParams
}