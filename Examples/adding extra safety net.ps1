<##########################
| ADDING EXTRA SAFETY NET |
###########################

ALL VERSIONS

If you are writing PowerShell functions, and you know a particular function has the potential to
cause a lot of harm, there is an easy way of adding an extra safety net. Below are two functions,
one without safety net, and one with a safety net.

#>

function NoSafety
{
    param
    (
        [parameter(mandatory)]
        $Something
    )

    "Harm done with $Something"
}

function Safety
{
    # step 1: add -whatIf and -Confirm, and mark as harmful
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]
    param
    (
        [Parameter(mandatory)]
        $Something
    )

    # step 2: abort function when confirmation was rejected
    if (!$PSCmdlet.ShouldProcess($env:COMPUTERNAME, "doing something harmful"))
    {
        Write-Warning "Aborted!"
        return
    }

    "Harm done with $Something"
}

# When you run "NoSafety", it starts running right away. When you run "Safety", the user gets a
# confirmation prompt, and only when the confirmation is accepted will the function run.

# There are two parts to this. First, a [CmdletBinding(...)] statement adds the -WhatIf and -Confirm
# parameters, and ConfirmImpact="High" marks the function as potentially dangerous.

# Second, the first thing in your function code is a call to $PSCmdlet.ShouldProcess where you
# define the confirmation message. If the call returns $False, the -Not operator (!) in the code flips
# the result, and the function simply aborts.

# The user can still run the function without confirmation, either by turning confirmation explicitly
# off:

# Or by setting $ConfirmPreference to "None", effectively turning off all automatic confirmation
# dialogs for the current PowerShell session