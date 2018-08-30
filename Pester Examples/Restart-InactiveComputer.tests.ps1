$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$file = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".tests.",'.')
. "$here\$file"

Describe "TESTINGRestart-InactiveComputer" {
    Mock Restart-Computer { 
        "Restarting!" 
    }

    It "Restarts the computer" {
        Mock Get-Process {}
        TESTINGRestart-InactiveComputer | 
            Should be "Restarting!"    
    }

    It "Does not restart the computer if user is logged on" {
        Mock Get-Process {
            $true
        }
        TESTINGRestart-InactiveComputer |
            Should BeNullOrEmpty
    }
}

Describe "TESTINGRestart-InactiveComputer with Assert-MockCalled" {
    Mock Restart-Computer {
        "Restarting!"
    }
    
    Context "Computer should restart" {
        It "Restarts the computer with Assert-MockCalled" {
            Mock Get-Process {}
            TESTINGRestart-InactiveComputer | Out-Null
            Assert-MockCalled Restart-Computer -Exactly 1
        }
    }

    Context "Computer should not restart" {
        It "Does not restart the computer if user is logged on with Assert-MockCalled" {
            Mock Get-Process {$true}
            TESTINGRestart-InactiveComputer | Out-Null
            Assert-MockCalled Restart-Computer -Exactly 0
        }
    }
}