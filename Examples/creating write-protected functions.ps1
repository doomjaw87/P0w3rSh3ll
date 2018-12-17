<#####################################
| CREATING WRITE-PROTECTED FUNCTIONS |
######################################

ALL VERSIONS

PowerShell functions by default can be overridden anytime, and you can also remove them
using Remove-Item:

#>


function Test-LifeSpan
{
    'Hello!'
}

Test-LifeSpan

Remove-Item -Path Function:Test-LifeSpan

Test-LifeSpan

# For security-relavant functions, you might want to create functions in a way that makes them
# immune against overwriting. Here is how:

$funcName = 'Test-ConstantFunc'
$expression = {
    param($test)
    "Hello $test, I cannot be removed!"
}

Set-Item -Path function:$funcName -Value $expression -Options Constant,AllScope

# The new function is created directly on the function: drive using Set-Item. This way, you can
# apply additional options to the function, like Constant and AllScope. The function works as
# excepted.

# "Constant" makes sure the function can neither be overwritten nor deleted.

# Even more importantly, "AllScope" makes sure the function cannot be masked in child scopes.
# With write protection, a common workaround is to use a separate child scope to define a new
# function with same name.