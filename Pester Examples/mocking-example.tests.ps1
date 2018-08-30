<#################################
# Pester Testing Mocking Example #
##################################

Pester provides a set of Mocking functions making it easy to fake dependencies
and also to verify behavior. Using these mocking functions can allow you to
"shim" a data layer or mock other complex functions that already have their
own tests.

With the set of Mocking functions that Pester exposes, one can:
- Mock the behavior of ANY PowerShell command
- Verify that specific commands were (or were not) called
- Verify the number of times a command was called with a set of specified parameters

MOCKING FUNCTIONS
- Mock
    Mocks the behavior of an existing command with an alternate implementation

- Assert-VerifiableMocks
    Checks if any verifiable mock has been invoked. If so, this will throw an
    exception

- Assert-MockCalled
    Checks if a Mocked command has been called a certain number of times and
    throws an exception if has not

#>

# EXAMPLE

function Build ($version) {
    Write-Host "a build was run for version: $version"
}

function BuildIfChanged {
	$thisVersion = Get-Version
	$nextVersion = Get-NextVersion
	if ($thisVersion -ne $nextVersion) { Build $nextVersion }
	return $nextVersion
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "BuildIfChanged" {
    Context "When there are Changes" {
    	Mock Get-Version {return 1.1}
    	Mock Get-NextVersion {return 1.2}
    	Mock Build {} -Verifiable -ParameterFilter {$version -eq 1.2}

    	$result = BuildIfChanged

	    It "Builds the next version" {
	        Assert-VerifiableMocks
	    }
	    It "returns the next version number" {
	        $result | Should Be 1.2
	    }
    }
    Context "When there are no Changes" {
    	Mock Get-Version { return 1.1 }
    	Mock Get-NextVersion { return 1.1 }
    	Mock Build {}

    	$result = BuildIfChanged

	    It "Should not build the next version" {
	        Assert-MockCalled Build -Times 0 -ParameterFilter {$version -eq 1.1}
	    }
    }
}