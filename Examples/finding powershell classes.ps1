<#############################
| FINDING POWERSHELL CLASSES |
##############################

Version 5 And Later

Starting in PowerShell 5, you can define PowerShell classes. They are defined dynamically and 
live in memory. So how would you know the names of the classes that have been added?

#>

class TestClass
{

}

# How would you be able to check whether a class named "TestClass" exists in memory? Here is
# a helper function called Get-PSClass

function Get-PSClass($Name = '*')
{
    [AppDomain]::CurrentDomain.GetAssemblies() |
        Where-Object { $_.GetCustomAttributes($false) |
        Where-Object { $_ -is [System.Management.Automation.DynamicClassImplementationAssemblyAttribute]} } |
        ForEach-Object { $_.GetTypes() |
        Where-Object IsPublic |
        Where-Object { $_.Name -like $Name } |
        Select-Object -ExpandProperty Name
    }
} 
