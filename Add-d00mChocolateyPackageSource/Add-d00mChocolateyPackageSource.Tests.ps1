$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Add-d00mChocolateyPackageSource' {
    It 'Outputs $true for local computer' {
        Add-d00mChocolateyPackageSource | should be $true
    }

    It 'Outputs $false for non-existant remote computer' {
        Add-d00mChocolateyPackageSource -ComputerName failure | should be $false
    }

    It 'Outputs $true for valid remote computer' {
        Add-d00mChocolateyPackageSource -ComputerName fs-test | Should be $true
    }
}