$here = Split-Path -Path $MyInvocation.MyCommand.Path
$file = (Get-ChildItem -Path $here -Filter '*.ps1') | Where-Object -Property Name -NotLike '*.Tests.ps1'
. $($file.FullName)

Describe 'Set-d00mPowerShellDefaultshell' {
    it 'Outputs string computername on valid computer' {
        $result = Set-d00mPowerShellDefaultShell -ComputerName web01
        $result.ComputerName | 
            Should BeOfType System.String
    }

    it 'Outputs bool PowerShellDefault on valid computer' {
        $result = Set-d00mPowerShellDefaultShell -ComputerName Web01
        $result.PowerShellDefault | 
            Should BeOfType System.Boolean
    }

    it 'Outputs true for success on valid computer' {
        $result = Set-d00mPowerShellDefaultShell -ComputerName web01
        $result.PowerShellDefault | 
            Should be $true
    }

    it 'Throws on invalid computername' {
        {Set-d00mPowerShellDefaultShell -ComputerName Failure} | 
            Should throw
    }
}