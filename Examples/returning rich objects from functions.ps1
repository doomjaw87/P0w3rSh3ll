<########################################
# Returning Rich Objects from Functions #
#########################################

If a PowerShell function needs to return more than one information
kind, always make sure you wrap the pieces of information inside a 
rich object. The easiest way to product such a custom object is
[PSCustomObject]@{} like this:

#>


function Get-TestData
{
    # if a function is to return more than one information kind,
    # wrap it in a custom object

    [PSCustomObject]@{
        # wrap anything you'd like to return
        ID     = 1
        Random = Get-Random
        Date   = Get-Date
        Text   = 'Yolo'
        Bios   = Get-WmiObject -Class Win32_BIOS
        User   = $env:USERNAME
    }
}

# The core of the custom object is a hash table: any hash table key
# turns into a property. The awesome thing about this approach is that
# you can use variables and even commands inside the hash table, so it
# is easy to collect all the information you want to return, and combine it
# in one self-descriptive object:

Get-TestData

# Whenever a function returns objects with more than 4 properties,
# PowerShell formats the output as list, else as table.

# Typically, tabular design is easier to read, especially when there are
# multiple data sets. While you get tabular design by default with 4 or
# less properties, you might not always want to limit your return values
# to just 4 properties. So why not do it like cmdlets do?

# Cmdlets by default show only a fraction of properites:

Get-Service | Select-Object -First 1

# You get the full property list only when you use Select-Object and ask
# for all properties explicity:

Get-Service | Select-Object -First 1 -Property *

# Apparently, there are first- and second-class citizens. In your own
# functions, you define the first-class citizen like so:

function Get-TestData2
{
    # define the first-class citizen
    [string[]]$Visible = 'ID', 'Date', 'User'
    $info = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', $visible)

    [PSCustomObject]@{
        # wrap anything you'd like to return
        ID = 1
        Random = Get-Random
        Date = Get-Date
        Text = 'Yolo'
        BIOS = Get-WmiObject -Class Win32_BIOS
        User = $env:USERNAME    
    } | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $info -PassThru     
}

# Now, your function behaves exactly like cmdlets, and as long as you
# don't define more than 4 first-class citizens, you get tabular design by
# default:

Get-TestData2