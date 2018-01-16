<############################
| USING POWERSHELL CLASSES 2|
#############################

Version 5 and Later

Starting in PowerShell 5, you can define PowerShell classes. You can use classes to create new 
objects, and by defining one or more "constructors", you can easily initialize the newly created
objects as well.

#>

class Employee
{
    [int]$Id
    [string]$Name

    Employee([int]$Id, [string]$Name)
    {
        $this.Id   = $Id
        $this.Name = $Name
    }

    Employee([string]$Name)
    {
        $this.Id   = -1
        $this.Name = $Name
    }

    Employee()
    {
        $this.Id   = -1
        $this.Name = 'Undefined'
    }
}

# Once you run this code, there is a new class called "Employee" with three constructors. And
# here is how you can use the new class:

[Employee]::new()

[Employee]::new('Alex')

[Employee]::new(123, 'Alex')