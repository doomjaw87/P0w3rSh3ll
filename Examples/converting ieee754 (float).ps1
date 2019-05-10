<############################
| Convertin IEEE754 (Float) |
#############################

All Versions

PowerShell is extremely versatile and nowadays, often used with IoT and sensors as well. Some
return values in IEEE754 float format which typically is a series of four hexadecimal bytes.

Let's assume a sensor returns a value in the hexadecimal formal of 3FA8FE3B and uses
IEEE754 formatting. How do you get the real value?

Technically, you have to reverse the byte order, then use the BitConverter to produce a "Single"
value.

Take 3FA8FE3B, split into pairs, reverse the order, then convert to a number

#>

$bytes = 0x3B, 0xFE, 0xA8, 0x3F
[System.BitConverter]::ToSingle($bytes, 0)

# As it turns out, the hex value 0x3FA8FE3B returns the sensor value 1.320258. Today, we
# focused on the BitConverter class that provides methods to convert byte arrays to numeric
# values. Tomorrow, we look at the other part: splitting text hex values into pairs and reversing the
# order.

# Learning points:
# # Use [BitConverter] to convert raw bytes and byte arrays into other numeric formats. The
# # class comes with a mutlitude of methods:
[System.BitConverter] | Get-Member -Static | Select-Object -ExpandProperty Name



<#########
| PART 2 |
##########

ALL VERSIONS

Yesterday we looked at how PowerShell can turn IEEE754 floating point values returned by a 
sensor into the actual value. This involved reversing the byte order and using the BitConverter
class.

If you have received a IEEE754 value in hex format, like 0x3FA8FE3B, the first task is to split the
hex value into four bytes. There is a surprisingly easy way to do this: treat the hext value as an
IPv4 address. These addresses internally use four bytes as well.

Here is a quick and simple approach to turn the sensor hex value into a useful numeric value:

#>

$hexInput = 0x3Fa8FE3B

$bytes = ([Net.IPAddress]$hexInput). GetAddressBytes()
$numericValue = [System.BitConverter]::ToSingle($bytes, 0)

"sensor: $numericValue"