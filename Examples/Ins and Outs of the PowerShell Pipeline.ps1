<##########################################
| Ins and Outs of the PowerShell Pipeline |
###########################################

Pipelining is an important technique when the operation you are performing, such as
reading files of indeterminate length, or processing collections of large objects,
requires you to conserve memory resources by breaking a large task into its atomic
components. If you get it wrong, you don't get that benefit. While PowerShell
provides an ample supply of constructs for pipelining, it is all too easy to write
code that simply does not pipeline at all.


                 _______________________________________
                 |                  |                  |
 1, 2, 3   --->  |    2, 4, 6       |  2a, 4b, 6c      |  ---> a2, b4, c6
                 |                  |                  |
                 _______________________________________
                 f1(x)             f2(x)             f3(x)

Each pipeline function, called a filter, performs a transformation on the inputs fed
to it and passes on the result. The operations performed as shown as deliberately
simple and nonsensical: it is purely to illustrate the process. It is the pipeline
itself that deserves attention here, rather than the particular transformations.
Nonetheless, here to start us off are the simple implementations of each operation so
you can follow along.

#>


# Double the input
function f1 ($x) { $x*2 }

# Concatentate the nth letter to the input where n is half the input value
function f2 ($x) { "$x" + [char]([byte][char] "A" + $x/2 - 1) }

# Reverse the 2-character string
function f3 ($x) { $x[1..0] -join ''}


# Instead of writing this...
1, 2, 3 | f1 | f2 | f3


# ... you will need to execute this
1, 2, 3 | %{f1 $_} | %{f2 $_} | %{f3 $_}



<####################################################################
| SCENARIO 1 - GENERATE ALL PIPELINEABLE OUTPUT BEFORE EMITTING ANY |
#####################################################################

The special variable $input is available within a function as a provider of pipeline
data. So we just loop through that pipeline data, calculating a result, and then
writing it out. This is a very common coding pattern seen in many questions on
StackOverflow. It is perfectly reasonable for some languages, but generally it
should be avoided in PowerShell. Even if data is coming in nicely through the
pipeline to the first function, the pipeline dries up completely, because each
function is processing the entire pipeline input until the pipeline is empty, and
only then sending its results onward en masse to the next pipeline participant.

#>

function showInputs
{
    $result = @()
    foreach ($value in $input)
    {
        $result += $value
    }
    Write-Host $result
    Write-Output $result
}

function f1Runner
{
    $result = @()
    foreach ($value in $input)
    {
        $result += f1 $value
    }
    Write-Host $result
    Write-Output $result
}

function f2Runner
{
    $result = @()
    foreach ($value in $input)
    {
        $result += f2 $value
    }
    Write-Host $result
    Write-Output $result
}

function f3Runner
{
    $result = @()
    foreach ($value in $input)
    {
        $result += f3 $value
    }
    Write-Host $result
    Write-Output $result
}

# Here is what happens when you execute. showInput displays all of its inputs (1 2 3).
# It is an artifact of Write-Host that it combines all of the values in to a single,
# space-separated string. Then f1Runner displays all of its calculations (2 4 6). Then
# f2Runner does all of its work, yielding (2A 4B 6C). Finally, f3Runner lets it results
# stream out the end of the pipeline, so you see that there are still 3 values being
# processed because they are emitted one-per-line.

1, 2, 3 | showInputs | f1Runner | f2Runner | f3Runner



<################################################################
| SCENARIO 2 - COLLECT ALL PIPELINE INPUT BEFORE PROCESSING ANY |
#################################################################

The way to fix the previous example is to emit each value as soon as its calculated.
The point to catch from the previous example is that there's no need for you to explicity
aggregate the results; PowerShell will implicitly do that with the pipeline itself. This
set of functions seemingly does just that, emitting one value at a time.

#>

function showInputs
{
    $input | ForEach-Object {
        $result = $_
        Write-Host $result
        Write-Output $result
    }
}

function f1Runner
{
    $input | ForEach-Object {
        $result = f1 $_
        Write-Host $result
        Write-Output $result
    }
}

function f2Runner
{
    $input | ForEach-Object {
        $result = f2 $_
        Write-Host $result
        Write-Output $result
    }
}

function f3Runner
{
    $input | ForEach-Object {
        $result = f3 $_
        Write-Host $result
        Write-Output $result
    }
}

# While these functions do not suffer the deficiency of the previous example
# (generating all the output before emitting anything), the converse is actually
# the problem here: the functions are waiting for all the input before calculating
# anything.

1, 2, 3 | showInputs | f1Runner | f2Runner | f3Runner



<#############################################################################
| SCENARIO 3 - PROCESS EACH INPUT WHEN RECEIVED AND EMIT ITS OUTPUT PROMPTLY |
##############################################################################

Scenario #2 moved a bit closer to real pipelining, and you might surmise from above
that the final piece of the problem can be resolved by moving from the end block to
the process block. And that would be quite correct; the set of functions below show
how. Notice there is no loop here because the process block runs once for each input;
In other words, there is a loop but it is handled by PowerShell itself. Within a 
process block, use the special $_ variable to access the current pipeline item.

#>

function showInputs
{
    process
    {
        $result = $_
        Write-Host $result
        Write-Output $result
    }
}

function f1Runner 
{
    process
    {
        $result = f1 $_
        Write-Host $result
        Write-Output $result
    }
}

function f2Runner
{
    process
    {
        $result = f2 $_
        Write-Host $result
        Write-Output $result
    }
}

function f3Runner
{
    process
    {
        $result = f3 $_
        #Write-Host $result
        Write-Output $result
    }
}
1, 2, 3 | showInputs | f1Runner | f2Runner | f3Runner


# ALSO!!!!!!!!!!!!!!!!!!!!!!!!
# Because the process block is so central to pipelining, there is a special syntax
# to reduce the amount of code you have to write. As noted above using the Function
# keyward with no explicit begin, process, or end block executes the code in the
# context of the end block. Similarly, if you use the Filter keyword with no explicit
# block then the code executes in the process block. Thus, this more concise code
# produces exactly the same result.

Filter showInputs {
    Write-Host $_
    Write-Output $_
}
Filter f1Runner {
    $result = f1 $_
    Write-Host $result
    Write-Output $result
}
Filter f2Runner {
    $result = f2 $_
    Write-Host $result
    Write-Output $result
}
Filter f3Runner {
    $result = f3 $_
    #Write-Host $result
    Write-Output $result
}
1, 2, 3 | showInputs | f1Runner | f2Runner | f3Runner