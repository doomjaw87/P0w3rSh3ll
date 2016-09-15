$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Get-d00mLastBootupTime' {
    It 'Does not throw exception on local computer' {
        {Get-d00mLastBootupTime} | 
            Should not throw
    }

    It 'Should throw on invalid computer' {
        {Get-d00mLastBootupTime -ComputerName 'Failure'} | 
            Should throw
    }

    It 'Outputs String for computername' {
        $result = Get-d00mLastBootupTime
        $result.ComputerName |
            Should BeOftype [System.String]
    }

    It 'Outputs DateTime for LastBootUpTime' {
        $result = Get-d00mLastBootupTime
        $result.LastBootupTime | 
            Should BeOfType [System.DateTime]
    }

    It 'Outputs TimeSpan for Difference' {
        $result = Get-d00mLastBootupTime
        $result.Difference | 
            Should BeOfType [System.TimeSpan]
    }
}