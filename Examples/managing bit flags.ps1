<##############################
| MANAGING BIT FLAGS (PART 1) |
###############################

Occasionally, you might have to deal with big flag values. Each bit in a number represents a
certain setting, and your code might need to determine whether a given flag is set, or set a given
flag without tampering with the other bits.

This typically involves a lot of fiddling with binary operators. In PowerShell 5, however, there is a 
much easier approach, thanks to the support for flag enumerations.

Let's assume you have a vaule like 56823 and would like to know which bits are set. You could
convert the number to visualize the bits:

#>

[Convert]::ToString(56823, 2)
# 1101110111110111

# If you know the meaning of each bit, a much more powerful way is to define an enumeration:
#requires -Version 5
[flags()]
enum CustomBitFlags
{
    None     = 0
    Option1  = 1
    Option2  = 2
    Option3  = 4
    Option4  = 8
    Option5  = 16
    Option6  = 32
    Option7  = 64
    Option8  = 128
    Option9  = 256
    Option10 = 512
    Option11 = 1024
    Option12 = 2048
    Option13 = 4096
    Option14 = 8192
    Option15 = 16384
    Option16 = 32768
    Option17 = 65536
}

# For each bit, provide a friendly name, and make sure you add the attribute [Flags] (which allows
# multiple vaules to be set).

# Now it's super easy to decipher the decimal - simply convert it into your new enum type
$rawFlags = 56823
[CustomBitFlags]$flags = $rawFlags
# Option1, Option2, Option3, Option5, Option6, Option7, Option8, Option9, Option11, Option12, Option13, Option15, Option16

# And if you just wanted to check whether or not a given flag was set, use the method HasFlag()
$flags.HasFlag([CustomBitFlags]::Option1)
# true

$flags.HasFlag([CustomBitFlags]::Option4)
# false



<##########################
| MANAGING BIT FLAGS PT 2 |
###########################

In the previous tip we illustrated how you can use PowerShell 5's new enumsx to easily decipher
big flags, and even test for individual flags.

If you cannot use PowerShell 5, in older PowerShell versions, you can still use this technique.
Simply define the enum via C# code.

#>

# this is the decimal we want to decipher
$rawFlags = 56823

# define an enum with the friendly names for the flags
# don't forget [Flags]
# IMPORTANT: you cannot change your type inside a PowerShell session!
# if you made changes to the enum, close PowerShell and open a new
# PowerShell!
$enum ='
using System;
[Flags]
public enum BitFlags 
{
    None    = 0,
    Option1 = 1,
    Option2 = 2,
    Option3 = 4,
    Option4 = 8,
    Option5 = 16,
    Option6 = 32,
    Option7 = 64,
    Option8 = 128,
    Option9 = 256,
    Option10= 512,
    Option11= 1024,
    Option12= 2048,
    Option13= 4096,
    Option14= 8192,
    Option15= 16384,
    Option16= 32768,
    Option17= 65536
}'
Add-Type -TypeDefinition $enum

# convert the decimal to the new enum
[BitFlags]$flags = $rawFlags
$flags
#Option1, Option2, Option3, Option5, Option6, Option7, Option8, Option9, Option11, Option12, Option13, Option15, Option16

# test individual flags
$flags.HasFlag([BitFlags]::Option1)
#true

$flags.HasFlag([BitFlags]::Option2)
#true



<##############################
| MANAGING BIT FLAGS (PART 3) |
###############################

Setting or clearing bit flags in a decimal is not particular hard but unintuitive. Here is a quick
refresher showing how you can set and clear individual bits in a number:

#>

$decimal = 6254
[convert]::ToString($decimal, 2)
# 1100001101110

# set bit 4
$bit = 4
$decimal = $decimal -bor [math]::Pow(2, $bit)
[convert]::ToString($decimal, 2)
# 1100001111110

# set bit 0
$bit = 0
$decimal = $decimal -bor [math]::Pow(2, $bit)
[convert]::ToString($decimal, 2)
# 1100001111111

# clear bit 1
$bit = 1
$decimal = $decimal -band -bnot [math]::Pow(2, $bit)
[convert]::ToString($decimal, 2)
# 1100001111101



<############################
| MANAGING BIT FLAGS (pt 4) |
#############################

In PowerShell 5, the new support for enums makes dealing with bit values much easier as
you've seen in previous tips. Even setting or clearing bits no longer requires cumbersome logical
operators anymore.

Let's first define an enum and make the decimal more manageable:

#>

#requires -Version 5
[flags()]
enum GardenPartyItems
{
    Chair = 0
    Table = 1
    Barbecue = 2
    Fridge = 4
    Candle = 8
    Knife = 16
}
$decimal = 11
[GardenPartyItems]$flags = $decimal
$flags
# Table, Barbecue, Candle