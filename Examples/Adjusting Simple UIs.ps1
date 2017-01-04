<#######################
| ADJUSTING SIMPLE UIs |
########################

If you'd like to adjust the number of parameters that show up in the UI, simply
write your own functions.

In the below example, Send-MailMessage is wrapped inside a custom function that
exposes only some of the properties, and initializes others (like SMTP server 
and credentials) internally.

Here is a very simple email sender that just shows the text boxes to send emails:

#>

function Send-MailMessageCustomized
{
    param
    (
        [parameter(mandatory)]
        [string]$From,

        [parameter(mandatory)]
        [string]$To,

        [parameter(mandatory)]
        [string]$Subject,

        [parameter(mandatory)]
        [string]$Body,

        [parameter()]
        [switch]$BodyAsHtml
    )

    $username = 'mymailusername'
    $password = 'mymailpassword'
    $smtpServer=  'mysmtpserver.com'

    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, ($password | ConvertTo-SecureString -AsPlainText -Force)
    $params = @{From       = $From
                To         = $To
                Subject    = $Subject
                Body       = $Body
                BodyAsHtml = $BodyAsHtml
                SmtpServer = $smtpServer
                Encoding   = 'UTF8'
                Credential = $credential}
}

function Send-MailMessageUI
{
    Show-Command -Name Send-MailMessageCustomized
}

Send-MailMessageUI