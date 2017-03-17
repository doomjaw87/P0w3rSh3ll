<#####################################
| TEXTS WITH MAXIMUM LENGTH (PART 1) |
######################################

If you want to make sure a text is of given length, here is an easy approach:

#>

$text = 'this is a long text'
$maxLength = 10

$text.PadRight($maxLength).Substring(0, $maxLength)


# This code first pads the text in case it is shorter than the maximum length, and then SubString()
# is cutting off excess text