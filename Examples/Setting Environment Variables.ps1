<################################
| SETTING ENVIRONMENT VARIABLES |
#################################

When setting environment variables through the PowerShell "env:" drive, you are always just
manipulating the process set. It applies to your current PowerShell instance, and all applications
that you start from there. Changes will not persist though.

To permanently set an environment variable, use this code instead:

#>

$name = 'Test'
$value = 'Hello'
$scope = [EnvironmentVariableTarget]::User
[Environment]::SetEnvironmentVariable($name, $value, $scope)

# This example sets a new environment variable named "test" with content "hello" on the user level.
# Note that this change will affect only programs that you launch after you set this variable. All new
# applications receive a "snapshot" of all environment variables in their process set.

# To permanently delete an environment, set $value to an emtpy string
$name = 'Test'
$value = ''
$scope = [EnvironmentVariableTarget]::User
[Environment]::SetEnvironmentVariable($name, $value, $scope)