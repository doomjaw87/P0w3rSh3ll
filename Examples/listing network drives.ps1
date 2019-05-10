<#########################
| LISTING NETWORK DRIVES |
##########################

All Versions

There are many ways to create a list of network drives. One involes a COM interface that was 
used by VBScript as well, and we'll pick it up to illustrate a special PowerShell technique.

To dump all network drives, simply run these lines:

#>

$obj = New-Object -ComObject WScript.Network
$obj.EnumNetworkDrives()

# The method returns two strings per each network drive: the assigned drive letter, and the original
# url. To turn this into something useful, you would have to create a loop tha treturns two
# elements per iteration.
# Here is a clever approach that does just this:

$obj = New-Object -ComObject WScript.Network
$result = $obj.EnumNetworkDrives()

foreach ($entry in $result)
{
    $letter = $entry
    $null = $foreach.MoveNext()
    $path = $foreach.Current

    [pscustomobject]@{
        DriveLetter = $letter
        UNCPath = $Path
    }
}

# Inside the foreach loop, there is a little-known automatic variable called $foreach. It controls the
# iterations. When you call MoveNext(), it iterates over the collection, moving to the next element.
# With Current, you can read the current value of the iterator. This way, the loop processes two
# items at a time instead of just one.