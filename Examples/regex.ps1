####      #####    ####    #####  #     #
#   #     #       #        #       #   #
#   #     #      #         #        # #
####      ####   #   ###   ####      #
#   #     #      #     #   #        # #
#    #    #      #     #   #       #   #
#     #   #####   #####    #####  #     #


<####################################
| CHECK NUMBER OF DIGITS IN INTEGER |
#####################################

"^" denotes the beginning of an expression
"$" denotes the end of an expression
"\d" represents a digit
"{4,6}" represents how many are allowed

#>

$integer = 5711567

# is it between 4 and 6 digits?
$is4to6 = $integer -match '^\d{4,6}$'

# is it exactly 7 digits?
$is7 = $integer -match '^d{7}$'

# is it at least 4 digits?
$isatleast4 = $integer -match '^\d{4,}$'

"4-6 digits? $is4to6"
"exactly 7 digits? $is7"
"at least 4 digits? $isatleast4"




<##################################
| ADDING AND REMOVING BACKSLASHES |
###################################

For path components, it is often necessary to "normalize" paths and, for example, make sure
they all end with a backslash.

#>

$path = 'c:\temp'
if ($path -notmatch '\\$')
{
    $path += '\'
}
$path

<#

A regular expression is used to find a backslash at the end of some text, and if it is missing, a
backslash is added.

If you wanted to remove a backslash at the end of a path, you could use -replace directly:

#>

$path = 'c:\temp\' -replace '\\$'
$path