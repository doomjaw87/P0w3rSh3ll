<######################################
| USING PESTER TESTS TO TEST ANYTHING |
#######################################

Pester is an open source module shipping with Windows 10 and Windows Server 2016, and can
be downloaded from the PowerShell Gallery for free.

Pester is a testing framework primarily used to test PowerShell code. You are not limited to code
tests, though, and so you can test anything with Pester. Here is a little example that tests your
PowerShell version and a couple of its settings...

#>

# Installing Pester...
# Install-Module -Name Pester -Force -SkipPublisherCheck


Describe 'PowerShell Basic Check' {

    Context 'PS Versioning' {
        
        It 'major version at least 5' {
            $host.Version.Major -ge 5 | Should be $true
        }

        It 'minor version at least 1' {
            $host.Version.Minor -ge 1 | Should be $true
        }

        #It 'is current version' {
        #    $host.Version.Major -ge 5 -and $host.Version.Minor -ge 1 | Should be $true
        #}
    }

    Context 'PS Settings' {

        It 'can execute scripts' {
            (Get-ExecutionPolicy) | Should Not Be 'Restricted'
        }

        It 'does not use AllSigned' {
            (Get-ExecutionPolicy) | Should Not Be 'AllSigned'
        }

        It 'does not have GPO restrictions' {
            (Get-ExecutionPolicy -Scope MachinePolicy) | Should Be 'Undefined'
            (Get-ExecutionPolicy -Scope UserPolicy) | Should Be 'Undefined'
        }
    }
}