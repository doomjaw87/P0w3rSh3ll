$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe "New-d00mShortCut Web location"{
    It "should fail" {
        {New-d00mShortCut -WebDestination 'failure' -FilePath 'failure.lnk'} | should throw 
    }
}