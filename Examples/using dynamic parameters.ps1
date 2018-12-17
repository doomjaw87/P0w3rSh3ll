<###########################
| USING DYNAMIC PARAMETERS |
############################

ALL VERSIONS

Most PowerShell functions use static parameters. They are defined in param() block and are
always present. A little-known fact is that you can also add dynamic parameters
programmatically on the fly. The big advantage of dynamic parameters is taht you are
completely free as to when they should appear, and what kind of values they should accept. The
drawback si that you need to use a lot of low level code to "program" the parameter attributes.

Here is a sample function. It has only one static parameter called "Company." Only when you 
choose a company will the function add a new dynamic parameter called "Department." The new
and dynamic -Department parameter exposes a list of valid values depending on which company
was chosen. In essence, the -Department parameter is assigned an individual ValidateSet
attribute based in the chosen company:

#>

function Test-Department
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Microsoft','Amazon','Google' ,'Facebook')]
        $Company
    )
 
    dynamicparam
    {
        # this hash table defines the departments available in each company
        $data = @{
            Microsoft = 'CEO', 'Marketing', 'Delivery'
            Google = 'Marketing', 'Delivery'
            Amazon = 'CEO', 'IT', 'Carpool'
            Facebook = 'CEO', 'Facility', 'Carpool'
        }
 
        # check to see whether the user already chose a company
        if ($Company)
        {
            # yes, so create a new dynamic parameter
            $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
            $attributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
 
            # define the parameter attribute
            $attribute = New-Object System.Management.Automation.ParameterAttribute
            $attribute.Mandatory = $false
            $attributeCollection.Add($attribute)
 
            # create the appropriate ValidateSet attribute, listing the legal values for
            # this dynamic parameter
            $attribute = New-Object System.Management.Automation.ValidateSetAttribute( $data.$Company)
            $attributeCollection.Add($attribute)
 
            # compose the dynamic -Department parameter
            $Name = 'Department'
            $dynParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter($Name,
            [string], $attributeCollection)
            $paramDictionary.Add($Name, $dynParam)
 
            # return the collection of dynamic parameters
            $paramDictionary
        }
    }
 
    end
    {
        # take the dynamic parameters from $PSBoundParameters
        $Department = $PSBoundParameters.Department
   
        "Chosen department for $Company : $Department"
    }
}