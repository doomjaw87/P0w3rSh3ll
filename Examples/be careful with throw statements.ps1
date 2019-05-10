<#####################################
| BE CAREFUL WITH "THROW" STATEMENTS |
######################################

All Versions

Throw is a PowerShell statement that emits an exception to the collar and then exits the code. At
least in theory. In the real world, throw might not exit the code, and the results can be
devastating.

To understand the problem, take a look at this demo function:

#>

function Copy-Log
{
    "Doing prerequisites"
    "Testing whether target path exists"
    "If target path does not exist, bail out"
    throw "Target path does not exist"
    "Copy log files to target path"
    "Delete log files in original location"
}

# When you run Copy-Log, it simulates a fail, assuming a hypothetical target path does not exist.
# When the target path is not preset, log files cannot be copied. When log files cannot be copied,
# they should not be deleted. That's why the code needs to exit when throw is called.

# HOWEVER, this is based on the default $ErrorActionPreference value of 'Continue'. When a user
# happens to change this to 'SilentlyContinue' in order to surpress error messages, throw
# suddenly gets completely ignored and all code executes.

# In this scenario, you would have lost all log files because the copy process did not work, yet the
# code continued and deleted the original files.

# Important learning point:
# - If it is important for you to exit a function, throw may not really exit the function. You
#   might want to use a different method to exit your code, for example the "return" statement.