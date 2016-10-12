# PowerShell console profile
# Alex Sparkman
# 201509015

$console = $host.ui.rawui

$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
$admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator

#$console.BackgroundColor = "Black"

If ($principal.IsInRole($admin))
{
    $console.windowtitle = "D E V A S T A T I O N  -  A D M I N"
}
Else
{
    $console.WindowTitle = "D E V A S T A T I O N"
}

Clear-Host

#Write-Host '    ' -NoNewline
#$([char[]](0x28,0x20,0x2022,0x5F,0x2022,0x29)) -join ''
#' '
#Write-Host '       ' -NoNewline
#$([char[]](0x28,0x20,0x2022,0x5F,0x2022,0x29,0x3E,0x2310,0x25A0,0x2D,0x25A0)) -join ''
#' '
#Write-Host '          ' -NoNewline
#$([char[]](0x28,0x2310,0x25A0,0x5F,0x25A0,0x29)) -join ''
#
#' '


function GetRandomColor()
{
    $color = switch (Get-Random -Minimum 1 -Maximum 8)
    {
        1 {"Gray"}
        2 {"Blue"}
        3 {"Cyan"}
        4 {"Green"}
        5 {"Magenta"}
        6 {"Red"}
        7 {"White"}
        8 {"Yellow"}
    }
    return $color
}

#Write-Host "                  .                                                      ." -ForegroundColor DarkGray
#Write-Host "                .n                   .                 .                  n." -ForegroundColor DarkGray
#Write-Host "          .   .dP                  dP                   9b                 9b.    ." -ForegroundColor DarkGray
#Write-Host "         4    qXb         .       dX                     Xb       .        dXp     t" -ForegroundColor DarkGray
#Write-Host "        dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb" -ForegroundColor DarkGray
#Write-Host "        9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP" -ForegroundColor DarkGray
#Write-Host "         9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP" -ForegroundColor DarkGray
#Write-Host "          ``9XXXXXXXXXXXXXXXXXXXXX'~   ~``OOO8b   d8OOO'~   ~``XXXXXXXXXXXXXXXXXXXXXP'" -ForegroundColor DarkGray
#Write-Host "            ``9XXXXXXXXXXXP' ``9XX'          ``98v8P'          ``XXP' ``9XXXXXXXXXXXP'" -ForegroundColor DarkGray
#Write-Host "                ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~" -ForegroundColor DarkGray
#Write-Host "                                )b.  .dbo.dP'``v'``9b.odb.  .dX(" -ForegroundColor DarkGray
#Write-Host "                              ,dXXXXXXXXXXXb     dXXXXXXXXXXXb." -ForegroundColor DarkGray
#Write-Host "                             dXXXXXXXXXXXP'   .   ``9XXXXXXXXXXXb" -ForegroundColor DarkGray
#Write-Host "                            dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb" -ForegroundColor DarkGray
#Write-Host "                            9XXb'   ``XXXXXb.dX|Xb.dXXXXX'   ``dXXP" -ForegroundColor DarkGray
#Write-Host "                             ``'      9XXXXXX(   )XXXXXXP      ``'" -ForegroundColor DarkGray
#Write-Host "                                      XXXX X.``v'.X XXXX" -ForegroundColor DarkGray
#Write-Host "                                      XP^X'``b   d'``X^XX" -ForegroundColor DarkGray
#Write-Host "                                      X. 9  ``   '  P )X" -ForegroundColor DarkGray
#Write-Host "                                      ``b  ``       '  d'" -ForegroundColor DarkGray
#Write-Host "                                       ``             '" -ForegroundColor DarkGray

@'
                                           
    |\    /\\   /\\                           
     \\  || || || ||           '   _   ;      
    / \\ || || || || \\/\\/\\ \\  < \, \\/\/\ 
   || || || || || || || || || ||  /-|| || | | 
   || || || || || || || || || || (( || || | | 
    \\/   \\/   \\/  \\ \\ \\ ||  \/\\ \\/\\/ 
                              |;              
                              /              

'@

Set-Location C:\GitHub\

Function prompt
{
    Write-Host "$(Get-Location)" -NoNewline #-BackgroundColor Black -ForegroundColor DarkGray
    Write-Host " >>" -NoNewLine
    Return " "
}