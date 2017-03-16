# Sort-Object Multiple Properties #

<#

I have a custom array that I want to sort by property A first descending, and then sort by property B with
default ascending.

If I do $ARRAY | Sort-Object -Property PROP_A, PROP_B it works fine, but I want PROP_A to be sorted in
reverse.

Apparently the -Descending switch is applied to the entire command, and not to individual properties
("sort prop_a -descending, prop_b" is no valid)

I tried doing sort prop_a -descending | sort prop_b but it does not provide the desired results.

How can I accomplish this?

#>

# use a calculated field and set the Ascending attribute to False
$array | Sort-Object -Property @{Expression = {$_.PROP_A}; Ascending = $false}, PROP_B

# short version
$array | sort @{e={$_.PROP_A};a=0},PROP_B