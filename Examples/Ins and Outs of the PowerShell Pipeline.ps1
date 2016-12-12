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



# SCENARIO 1 - GENERATE ALL PIPELINEABLE OUTPUT BEFORE EMITTING ANY
# https://www.simple-talk.com/sysadmin/powershell/ins-and-outs-of-the-powershell-pipeline/