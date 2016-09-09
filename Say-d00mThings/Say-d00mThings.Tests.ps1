$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)


Describe 'Say-d00mThings' {
    It 'Outputs $_.success = $true when saying things' {
        $result = Say-d00mThings -Things 'Testing'
        $result.Success | Should be $true
    }

    It 'Outputs $_.success = $true when piped in strings' {
        $result = 'From the pipeline' | Say-d00mThings
        $result.Success | Should be $true
    }

    It 'Outputs $_.success = $true when piped in file content' {
        'hello from a file' | Out-File -FilePath c:\test-speaking.txt
        $result = Get-Content c:\test-speaking.txt | Say-d00mThings
        $result.Success | Should be $true
        Remove-Item -Path c:\test-speaking.txt -Force
    }

    It 'Outputs $_.Gender = male when speaking with male voice' {
        $result = Say-d00mThings -Things 'I am a dude' -Gender Male
        $result.Gender | Should be 'Male'
    }

    It 'Outputs $_.Gender = female when speaking with a lady voice' {
        $result = Say-d00mThings -Things 'I am a lady' -Gender Female
        $result.Gender | Should be 'Female'
    }

    It 'Outputs $_.Gender = female when not specifying any gender' {
        $result = Say-d00mThings -Things 'I am a lady by default'
        $result.Gender | Should be 'Female'
    }
}