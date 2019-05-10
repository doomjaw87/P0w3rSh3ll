<##########################################
| ENABLE REAL-TIME STREAMING WITH FOREACH |
###########################################

All Versions

Classic foreach loops are the fastest loop available but they come with a severe limitation.
Foreach loops do not support streaming. You need to always wait for the entire foreach loop to
finish before you can start processing the results.

Here are some examples illustrating this. With the code below, you have to wait a long time until
you see the results:

#>

$elements = 1..100
$result = foreach ($item in $elements)
{
    "processing $item"
    # simulate some work and delay
    Start-Sleep -Milliseconds 50
}
$result | Out-GridView

# You cannot pipe the results directly. The following code produces a syntax error:
$elements = 1..100
foreach ($item in $elements)
{
    "processing $item"
    # simulate some work and delay
    Start-Sleep -Milliseconds 50
} | Out-GridView

# You could use $() to enable piping, but you would still have to wait for the loop to finish before
# the results are piped in one big chunk:
$elements = 1..100
$(foreach ($item in $elements)
{
    "processing $item"
    # simulate some work and delay
    Start-Sleep -Seconds 50
}) | Out-GridView

# Here is a little-known trick that adds real-time streaming to foreach: simply use a script block!
$elements = 1..100
& {
    foreach ($item in $elements)
    {
        "processing $item"
        # simulate some work and delay
        Start-Sleep -Milliseconds 50
    }
} | Out-GridView