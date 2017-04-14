<##########################
| INVOKING A SCRIPT BLOCK |
###########################

Code inside a script block can either be invoked by call operators such as "&" or ".", or by calling
the Invoke() method.

One difference is the output when there is more than one result: call operators return a plain
object array whereas Invoke() returns a collection

#>

$code = { Get-Process }

'$code.GetType().FullName = {0}' -f $code.GetType().FullName
# System.Management.Automation.ScriptBlock


# Object array
$result1 = & $code
'$result1.GetType().FullName = {0}' -f $result1.GetType().FullName

# Collection
$result2 = $code.Invoke()
'$result2.GetType().FullName = {0}' -f $result2.GetType().FullName


# The collection returned by Invoke() has additional methods such as RemoveAt() and Insert() that
# can help when you need to modify the result data and insert or remove elements efficiently.

# You can achieve similar things when you manually cast a cmdlet result to an ArrayList:
$arrayList = [Collections.ArrayList]@(Get-Process)