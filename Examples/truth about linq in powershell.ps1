<#################################
| TRUTH ABOUT LINQ IN POWERSHELL |
##################################

All Versions

Lately there have been reports about using Linq, a .NET query language, with PowerShell in an
effort to speed up code.

Until there is true Linq support in PowerShell, using Linq is very cumbersome and requires strict
typing and access to undocumented methods. What's more, the same can be achieved with
pure PowerShell approaches, and the speed increase often is just marginal - at least not very
relevant to ITPro-related tasks.

Here is a test case with a very simple Linq statement that sums up numbers. It takes all files
from your Windows folder, and sums up the file lenghts:

#>


$numbers = Get-ChildItem -Path $env:windir -File | Select-Object -ExpandProperty Length

(Measure-Command {
    $sum1 = [Linq.Enumerable]::Sum([int[]]$numbers)
}).TotalMilliseconds

(Measure-Command {
    $sum2 = ($numbers | Measure-Object -Sum).Sum
}).TotalMilliseconds

(Measure-Command {
    $sum3 = 0
    foreach ($number in $numbers)
    {
        $sum3+=$number
    }
}).TotalMilliseconds

<#

When you run it multiple times, you'll see how execution times will even out pretty much. The
Linq approach does work, but it is very sensitive to data types. You have to cast the array of 
numbers to an array of integers, for example, or else Linq's Sum() method will not work.

There are two rules of thumb to extract, Linq is not worth using at this time, because it is not
integrated in PowerShell and produces hard to read code. It is almost like using C# source code
within PowerShell. Second, if you do want to speed up things, try and avoid the pipeline where
possible. A foreach-loop is much faster than piping many objects to ForEach-Object individually.

If Linq was better integrated into PowerShell in the future, it would indeed be highly interesting.

#>