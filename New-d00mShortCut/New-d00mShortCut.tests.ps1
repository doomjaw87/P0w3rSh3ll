Clear-Host

$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'New-d00mShortCut' {
    It 'Outputs $false for invalid web address' {
        New-d00mShortCut -WebDestination 'http://notreal.fake' -FilePath 'c:\failure.lnk' | should be $false
    }

    It 'Outputs $true for valid web address' {
        New-d00mShortCut -WebDestination 'http://www.google.com' -FilePath 'c:\success-web.lnk' | should be $true
    }

    It 'Outputs $true for valid web address, pre-existing shortcut file, without $Force' {
        New-d00mShortCut -WebDestination 'http://www.google.com' -FilePath 'c:\success-web.lnk' | Should be $true
    }

    It 'Outputs $true for valid web address, pre-existing shortcut file, with $Force' {
        New-d00mShortCut -WebDestination 'http://www.google.com' -FilePath 'c:\success-web.lnk' -Force | Should be $true
    }

    It 'Outputs $false for invalid file system destination' {
        New-d00mShortCut -FileSystemDestination 'c:\notreal.txt' -FilePath 'c:\failure.lnk' | should be $false
    }

    It 'Outputs $true for valid file system destination' {
        New-d00mShortCut -FileSystemDestination 'c:\success-web.lnk' -FilePath 'c:\success-file.lnk' | should be $true
    }

    It 'Outputs $true for valid file system destination, pre-existing shortcut file, without $Force' {
        New-d00mShortCut -FileSystemDestination 'c:\success-web.lnk' -FilePath 'c:\success-file.lnk' | should be $true
    }

    It 'Outputs $true for valid file system destination, pre-existing shortcut file, with $Force' {
        New-d00mShortCut -FileSystemDestination 'c:\success-web.lnk' -FilePath 'C:\success-file.lnk' -Force | should be $true
    }
}

Remove-Item -Path C:\success-web.lnk -Force -ErrorAction SilentlyContinue
Remove-Item -Path C:\success-file.lnk -Force -ErrorAction SilentlyContinue