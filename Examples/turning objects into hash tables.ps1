<###################################
| TURNING OBJECTS INTO HASH TABLES |
####################################

ALL VERSIONS

In one of the previous tips we examined how Get-Member can retrieve the property names for
an object. Here is another use case that takes any object, turns it into a hash table with sorted
properties, and excludes empty properties.

#>



# take an object...
$process = Get-Process -Id $pid

# ...and turn it into a hash table
$hashTable = $process | ForEach-Object {
    $object = $_

    # determine the property names in this object and create
    # a sorted list
    $columns = $_ |
        Get-Member -MemberType *Property |
        Select-Object -ExpandProperty Name |
        Sort-Object

    # create an empty hash table
    $hashTable = @{}

    # take all properties, and add keys to the hash table for each property
    $columns | ForEach-Object {

        # exclude empty properties
        if (![String]::IsNullOrEmpty($object.$_ ))
        {
            # add a key (property) to the hash table with the 
            # property value
            $hashTable.$_ = $object.$_
        }
    }

    $hashTable
}

$hashTable | Out-GridView