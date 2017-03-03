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