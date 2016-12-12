BREAK

<#################################
| Using Traps and Error Handling | 
##################################

Traps are exception handlers that help you catch errors and handle them
according to your needs. A Trap statement anywhere in your script:

#>

Trap
{
    'Something awful happened.'
}
1/$null


# Whenever an error occurs and an exception is raised, PowerShell executes the
# script block specified in your script. However, it also will still display
# its own error message. To avoid that, your trap must handle the error so it
# will not continue bubble up and eventually be handled by PowerShell. To handle
# an exception, add the Continue statement:

Trap
{
    'Something awful happened.'
    Continue
}
1/$null


# Now, PowerShell no longer handles the error rather the exception is handled by
# your trap. Next, you'd probably like to find out more about the actual error to
# allow your Trap to handle the error more specifically. Inside your trap, in $_
# you have access to the error record:

Trap
{
    ('Something awful happened - to be more precise: {0}' -f $_.Exception.Message)
    Continue
}
1/$null




<###########################
| Understanding Trap Scope |
############################

Traps are a great way of handling errors but you may want to control where
PowerShell continues once an error occurs. There is a simple rule: a trap that
uses the Continue keyword continues execution in the next line in the scope of
the current trap. What does that mean?

#>

# If you have onne scope, PowerShell continues execution with the next statement
# following the error:

Trap 
{
    'Something terrible happened.'
    Continue
}
'Hello'
1/$null
'World'


# To create logical blocks, add scopes to your script, which can be functions or
# a basic script block. The next example will omit all remaining commands in the
# script block containing the error and PowerShell will continue with the next 
# statement outside the script block:

Trap
{
    'Something terrible happened.'
    Continue
}
& {
    'Hello'
    1/$null
    'World'
}
'Outside'