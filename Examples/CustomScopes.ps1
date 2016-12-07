BREAK

<######################
| Using Custom Scopes |
#######################

When you change variables, you might need to clean up later and ensure 
that you reverted them back to some default value - unless you use 
custom scopes.

The construct & { [code] } creates a new scope and any variable defined 
inside of it will be deleted again once the scope exits. This is why the 
below example, $ErrorActionPreference is automatically restored to 
whatever it was before.

#>

function Do-Stuff
{
    & {
        try
        {
            # Set the ErrorActionPreference to Stop
            $ErrorActionPreference = 'Stop'

            net user doesnotexist 2>&1
        }
        catch [System.Management.Automation.RemoteException]
        {
            $_.Exception.Message | Write-Warning
            # ErrorActionPreference will revert to previous 
            # value when scope exits
        }
    }
}

<#

The construction & { [code] } creates a new scope, and any variable 
defined inside of it will be deleted again once the scope exits. This is 
why in above example, $ErrorActionPreference is automatically restored
to what is was before.

#>



<############################################
| Using Custom Scopes to Discard Any Output |
#############################################

Custom scopes can be used to discard any output emitted by any part
of code inside your scope. To do that, use this structure: $null = . {[code]}
Whatever you execute in the braces will run, and all variables and
functions you might create will work outside of the scope, but there
will not be any output.
#>

function Out-Voice ($Text)
{
    $sapi = New-Object -ComObject Sapi.SpVoice
    $sapi.Speak($text)
}

out-Voice -Text 'Hello, dude'

<#

When you run it, it makes Windows speak, but also outputs the number 1.
As it turns out, the method Speak() does this, and when you consider larger
and more complex portions of code, there are many places where you'd produce
data that you really don't need.

Below is a fool-proof "diaper" function building that does the exact same, but
is guaranteed to not return any value:

#>

function Out-voice ($Text)
{
    $null = . {
        $sapi = New-Object -ComObject Sapi.SpVoice
        $sapi.Speak($Text)
    }
}

Out-Voice -Text 'Hello, dude again'