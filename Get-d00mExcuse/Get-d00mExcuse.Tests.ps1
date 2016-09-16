$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Get-d00mExcuse' {
    It 'Outputs a string' {
        Get-d00mExcuse |
            Should BeOfType [System.String]
    }

    It 'Outputs 3 words' {
        (Get-d00mExcuse).Split(' ').Count | Should be 3
    }
}