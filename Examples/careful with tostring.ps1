<##########################
| CAREFUL WITH TOSTRING() |
###########################

All Versions

Any .NET object has a method ToString() that returns a text representation. This is also waht you
get when you output an object in a string. However, the value returned by ToString() can vary,
and you should never use it to make critical assumptions.

Here is an example - these lines both product a FileInfo object which represents the exact
same ilfe. Only the way how the object was created is different. All object properties are
identical. Yet, ToString() differs:

#>

$file1 = Get-ChildItem -Path $env:windir -Filter regedit.exe
$file1.FullName # = c:\WINDOWS\regedit.exe
$file1.GetType().FullName # = System.IO.FileInfo
$file1.ToString() # = regedit.exe

$file2 = Get-Item -Path $env:windir\regedit.exe
$file2.FullName # = c:\WINDOWS\regedit.exe
$file2.GetType().FullName # = System.IO.FileInfo
$file2.ToString() # = C:\WINDOWS\regedit.exe