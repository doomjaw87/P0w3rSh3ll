<#############################
# Exchanging Variable Values #
##############################

Here's a quick tip how to switch variable content in one line:

#>

$a = 1
$b = 2

# switch variable content
$a, $b = $b, $a

$a
$b