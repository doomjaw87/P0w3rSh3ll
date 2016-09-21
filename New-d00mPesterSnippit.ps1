$Text = @'
<#
$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe '' {
    It '' {

    }
}
'@
New-IseSnippet -Title 'd00m Pester' -Description 'Create a new d00m Pester test' -Text $Text -Author 'd00mjaw87' -Force