$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Get-d00mSkypeForBusiness2016Installation' {
    It 'Outputs $true for local computer, pre-installed Office 365 2016' {
        $result = Get-d00mSkypeForBusiness2016Installation
        $result.SkypeForBusiness | should be $true
    }

    It 'Outputs x64 for x64-based local computer installation, pre-installed Office 365 2016' {
        $result = Get-d00mSkypeForBusiness2016Installation
        $result.Version | should be 'x64'
    }

    It 'Outputs $true for valid remote computer, pre-installed Office 365 2016' {
        $result = Get-d00mSkypeForBusiness2016Installation -ComputerName fs-test
        $result.SkypeForBusiness | should be $true
    }

    It 'Outputs x86 for x86-based remote computer installation, pre-installed Office 365 2016' {
        $result = Get-d00mSkypeForBusiness2016Installation -ComputerName fs-test
        $result.Version | should be 'x86'
    }

    It 'Outputs $false for valid remote computer without Skype For Business 2016 installed' {
        $result = Get-d00mSkypeForBusiness2016Installation -ComputerName it03
        $result.SkypeForBusiness | should be $false
    }

    It 'Outputs $true for list of valid computers, pre-installed Office 365 2016' {
        $results = Get-d00mSkypeForBusiness2016Installation -ComputerName it-kevin, neilamos-pc, fs-it-admin
        $results.SkypeForBusiness | should be $true
    }

    It 'Outputs $false for invalid computer' {
        $result = Get-d00mSkypeForBusiness2016Installation -ComputerName failure1
        $result.SkypeForBusiness | should be $false
    }
}