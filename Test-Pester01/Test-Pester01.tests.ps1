$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe "Test-Pester01" {
    It "outputs 'Sup World!'" {
        Test-Pester01 | should be 'Sup world!'
    }
}