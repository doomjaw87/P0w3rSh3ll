<################################
| CREATING RANDOM MAC ADDRESSES |
#################################

If you just need a bunch of randomly generated MAC addresses, and you don't care much about
whether these addresses are actually valid, then here is a one liner

#>

(0..5 | ForEach-Object {
    '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15), (Get-Random -Minimum 0 -Maximum 15)
}) -join ':'


# Add it to a loop, and you get as many MAC addresses as you need:
0..100 |
    ForEach-Object {
        (0..5 |
            ForEach-Object {
                '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15), (Get-Random -Minimum 0 -Maximum 15)
            }) -join ':'
    }