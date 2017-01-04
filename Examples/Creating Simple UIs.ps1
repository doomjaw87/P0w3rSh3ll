<######################
| CREATING SIMPLE UIs |
#######################

Function and cmdlet parameters are basically the technique how PowerShell creates
user interfaces. These text-based interfaces can easily be turned into graphical
interfaces.

If you'd like to send a mail message, you could use Send-MailMessage and provide
the details via text-based parameters. Or, you could create a graphical interface
and name it Send-MailMessageUI:

#>

function Send-MailMessageUI
{
    Show-Command -Name Show-MailMessage
}

Send-MailMessageUI

# Now when you run Send-MailMessageUI, all parameters are turned into text fields
# and check boxes. Even a non-scripter can now fill out this form, then click "Run"
# to execute the command.