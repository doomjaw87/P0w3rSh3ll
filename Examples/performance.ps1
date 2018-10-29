<#########################################
| PERFORMANCE PT 1 - FROM 6 MIN TO 2 SEC |
##########################################

ALL VERSIONS

Here is a common mistake found in many PowerShell scripts

#>

$start = Get-Date
$bucket = @()
1..100000 | ForEach-Object {
    $bucket += "I am adding $_"
}

$bucket.Count
(Get-Date) - $start


<#

In this design, scripts are using an empty array, then employ some sort of loop to add items to
the array. When you run it, you'll notice that it takes forever. In fact, it took more than 6
minutes on our test system and may take even long on yours.

Here is what is causing the slowness: the operator += is evil when applied to arrays, because even
though it seems to dynamically extend the array, in reality it creates a new array with one more
element each time you use +=.

To improve performance drastically, let PowerShell do the array creation: when you return things,
PowerShell automatically creates an array for you - fast:

#>

$start = Get-Date

$bucket = 1..100000 | ForEach-Object {
    "I am adding $_"
}
$bucket.Count
(Get-Date) - $start


# take a look at a slight modification - it yields the exact same result

$start = Get-Date

$bucket = 1..100000 | & { process {
    "I am adding $_"
}}
$bucket.Count
(Get-Date) - $start

<#

This marvel only takes .2 seconds on PowerShell 5.1 and .5 seconds on PowerShell 6.1
As you can see, the code simply replaces the ForEach-Object cmdlet with the equivalent &{
process {$_}}. As it turns out, pipeline operations are severely slowed down by advanced
functions with cmdlet bidning. Once you use a simple function (or a pure script block), you can
speed things up drastically. When you take into account where we started with this tip, we
managed to speed up things from 6+ minutes to 200ms, yielding the exact same result.

One thing to notice: these optimization techniques apply to loops that iterate often. If you use
loops that just iterate a couple of hundred items, you are likely to not experience any significant
difference. However, the more the loop iterates, the more severely will you be bitten by bad
design.

#>