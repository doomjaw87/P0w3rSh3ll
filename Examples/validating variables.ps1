<#######################
| VALIDATING VARIABLES |
########################

All Versions

Variables and function parameters can be automatically validated through validation attributes.
Here is a simple example making sure $test1 can only store values between 1 and 10:

#>

[ValidateRange(1, 10)]$test1 = 10


# Once you assign a value less than 1 or greater than 10 to it, PowerShell throws an exception.
# You just don't have any control over the exception text.

# By using a script validator, you can pick the error message yourself:

[ValidateScript({
    if ($_ -gt 10)
    {
        throw 'You have submitted a value greater than 10. That will not work, dummy!'
    }
    elseif ($_ -lt 1)
    {
        throw 'You have submitted a value lower than 1. That will not work, dummy!'
    }
    $true
})]$test2 = 11