<##############################################
# Using persisting variables inside functions #
###############################################

By default, when a PowerShell function exits, it "forgets" all internal
variables. However, there is a workaround that creates persisting
internal variables. Here is how:

#>


# create a script block with internal variables
# that will persist

$c = & {
    # define an internal variable that will
    # persist and keep its value even though
    # the function exits

    $a = 0

    {
        # use the internal variable
        $script:a++
        "You called me $a times!"
    }.GetNewClosure()
}

# this code creates a script block with an internal variable that keeps its
# value. When you run this script block multiple times, the counter
# increments.

& $c
& $c
& $c

# Yet the variable $a inside the script block is neither global nor
# scriptglobal. It only exists inside the script block

$a

# To turn the script block into a function: add this:
Set-Item -Path function:Test-Function -Value $c
Test-Function
Test-Function