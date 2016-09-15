$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Get-d00mCpuLoad' {
    It 'Throws exception for invalid computername' {
        {Get-d00mCpuLoad -ComputerName 'Failure'} | 
            Should throw
    }

    It 'Outputs a double for cpu load' {
        $result = Get-d00mCpuLoad
        $result.CPULoad | 
            Should BeOfType System.Double
    }

    It 'Outputs a string for computername' {
        $result = Get-d00mCpuLoad
        $result.ComputerName | 
            Should BeOfType System.String
    }

    It 'Accepts pipeline input for computername' {
        {'Fs-Test' | Get-d00mCpuLoad} | 
            Should Not throw
    }

    It 'Accepts multiple pipeline input for computername' {
        {'Clinicalops1', 'Clinicalops2', 'Clinicalops3', 'Clinicalops4' | Get-d00mCpuLoad} |
            Should Not Throw
    }

    It 'Accepts computernames feed from file' {
        $list = New-Object -TypeName System.Text.StringBuilder
        $list.AppendLine('fs-test') | Out-Null
        $list.AppendLine('fs-it-admin') | Out-Null
        New-Item -Path $here -Name 'names.txt' -ItemType File -Value $list.ToString() -Force
        {Get-Content -Path $here\names.txt | Get-d00mCpuLoad} |
            Should Not Throw
        Remove-Item -Path $here\names.txt -Force
    }

    It 'Throws exception for invalid credentials' {
        $credential = New-Object -TypeName pscredential -ArgumentList 'notreal', ('failure' | ConvertTo-SecureString -AsPlainText -Force)
        {Get-d00mCpuLoad -ComputerName -Credential ($credential)} | 
            Should throw
    }
}