<########################
| WORKING WITH GENERICS |
#########################

Generic types can use placeholders for actual types, and you may be wondering why that can be
exciting.

There are a number of data types, for example, that have no NULL value. Integers for example,
and also Boolean values, have no way of signaling that a value is invalid or not set. You can
work around this by defining that an integer with 0 (or -1) should be an "undefined" value. But
what if all numbers can be legal values? With Booleans, it's the same: while you can define
$false as "undefined", there are times when you really need: $true, $false, and undefined.

Generics to the rescue, you can use the Nullable type to create your own nullable type from any
valid value type. Here's an example:

#>

[Nullable[int]]$number = $null
$number
#

[Nullable[bool]]$flag = $null
$flag
#

# Try the same with regular data types, and you always get a conversion:
[int]$null
# 0

[bool]$null
# False