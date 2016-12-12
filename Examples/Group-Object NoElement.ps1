BREAK

<######################################################
| Analyzing Result Frequencies Without Wasting Memory |
#######################################################

Use Group-Object to group objects based on shared property values, but don't
forget to use -NoElement parameter to discard the actual objects and return
only the frequency.

#>

Measure-Command -Expression {Get-ChildItem -Path c:\Windows -File | Group-Object -Property Extension} |
    Select-Object -Property TotalMilliseconds


Measure-Command -Expression {Get-ChildItem -Path C:\Windows -File | Group-Object -Property Extension -NoElement} |
    Select-Object -Property TotalMilliseconds