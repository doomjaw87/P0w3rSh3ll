<######################################
# ACCEPTING DIFFERENT PARAMETER TYPES #
#######################################

ALL VERSIONS

Occasionally, you might want to create a function that accepts different parameter types. Let's
say you want the user to be able to either submit an employee name, or an Active Directory
object.

Tyere is one fixed rule in PowerShell: variables cannot have multiple data types at the same
time. Since parameters are variables, a given parameter can only have one distinct type.

However, you can use paramter sets to define mutual exclusive parameters which is a great
way to deal with different input types. Below is an example of a function that accepts either a
service name, or a service object. This is basically how Get-Service works inside, and the below
example just illustrates how this is done:

#>

function Get-MyService
{
    [cmdletbinding(DefaultParameterSetName='String')]
    param
    (
        [string]
        [parameter(mandatory,
            position=0,
            valuefrompipeline,
            parametersetname='string')]
        $Name,

        [System.serviceprocess.servicecontroller]
        [parameter(mandatory,
            position=0,
            valuefrompipeline,
            parametersetname='object')]
        $Service
    )

    process
    {
        # if the user entered a string, get the real object
        if ($PSCmdlet.ParameterSetName -eq 'string')
        {
            $service = Get-Service -Name $name
        }
        else
        {
            # else, if the user piped the expected object in the first place
            # you are good to go
        }

        # this call tells you which parameter set was invoked
        $pscmdlet.ParameterSetName

        # at the end, you have an object
        $Service
    }
}

# As you can see, the user can submit a service name or a service object. The Get-MyService
# function mimics the behavior found in Get-Service, and returns a service object, regardless
# of which input was chosen. Here is the syntax of the above function.