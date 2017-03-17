<############################
| WHERE-OBJECT AND .WHERE() |
#############################

Beginning in PowerShell 4, you can use the Where() and Foreach() methods in place of Where-Object
and ForEach-Object whenever you do not want to use the streaming mechanism of the pipeline.

So if you already leaded all data into a variable, the non-streaming mechanism can be faster:

#>

$services = Get-Service

# Pipeline streaming
$services | Where-Object {$_.Status -eq 'Running'}

# Non-streaming
$services.Where{$_.State -eq 'Running'}


# To save on resources, the most efficient way remains the streaming pipeline mode, and not
# using variables:

Get-Service | Where-Object {$_.Status -eq 'Running'}

# NOTE: Where-Object and .Where() use different array types, so their output is technically
# speaking not identical:
(1..10 | Where-Object {$_ -gt 0}).GetType().FullName # = System.Object[]
((1..10).Where{$_ -gt 0}).GetType().FullName # = System.Collections.ObjectModel.Collection`1[[System.Management.Automation.PSObject, System.Management.Automation, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35]]