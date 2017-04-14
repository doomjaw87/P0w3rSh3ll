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



<#####################################
| TEXTS WITH MAXIMUM LENGTH (PART 2) |
######################################

Here is another strategy to make sure a text does not exceed a given length. In contrast to our
previous tip, this code will not pad spaces in case the text is shorter than the maximum length:

#>

$text = 'this'
$maxLength = 10
$cutOff = [math]::Min($maxLength, $text.Length)
$text.Substring(0, $cutOff)

# Key is the Min() method which determines the smaller of two values