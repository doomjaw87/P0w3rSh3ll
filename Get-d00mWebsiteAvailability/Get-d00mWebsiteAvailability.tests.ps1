$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Get-d00mWebsiteAvailability' {
    It 'ValidWebsite.Description = OK' {
        $obj = Get-d00mWebsiteAvailability -Url 'http://www.google.com' 
        $obj.Description | Should be 'OK'
    }

    It 'ValidWebsite.Alive = $true' {
        $obj = Get-d00mWebsiteAvailability -url 'https://portal.office.com'
        $obj.Alive | Should be $true
    }

    It 'ValidWebsite.Status = 200' {
        $obj = Get-d00mWebsiteAvailability -Url 'https://apps.rackspace.com'
        $obj.Status | Should be '200'
    }

    It 'ValidWebsite.Status.GetType = Int' {
        $obj = Get-d00mWebsiteAvailability -Url 'https://apps.rackspace.com'
        $obj.Status | Should BeOfType [Int]
    }

    It 'ValidWebsite.ResponseTime > 0' {
        $obj = Get-d00mWebsiteAvailability -Url 'https://github.com'
        $obj.ResponseTime | Should BeGreaterThan 0 
    }

    It 'InvalidWebsite should fail' {
        {Get-d00mWebsiteAvailability -Url 'failure'} | Should throw
    }
}