<########################################
| READING ENVIRONMENT VARIABLES FRESHLY |
#########################################

When you read environment variables in PowerShell, you probably make use of the "env:" drive.
This line retrieves the environment variable %USERNAME%, for example, telling you the name
of the user executing the script:

#>

$env:USERNAME


<#

The "env:" drive always accesses the process set of environment variables. This makes sense in
most cases as many of the environment variables (like "UserName") are defined in this set.
Basically, the process set of environment variables is a "snapshot" of all environment variables
at the time of when an application starts, plus a number of additional pieces of information (like
"UserName").

To read environment variables freshly and explicity from the system or user set, use code like this:

#>

$name = 'temp'
$scope = [EnvironmentVariableTarget]::Machine
$content = [Environment]::GetEnvironmentVariable($name, $scope)
"Content: $content"