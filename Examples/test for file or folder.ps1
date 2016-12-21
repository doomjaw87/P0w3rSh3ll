Clear-Host

<##########################
| TEST FOR FILE OR FOLDER |
###########################

Test-Path can check whether a file or folder exists. If you add -PathType and
specify Leaf (for files) or Container (for folders), the result can be even 
more specific:

#>

$path = 'C:\Windows'

Test-Path -Path $path # returns $true

Test-Path -Path $path -PathType Leaf # returns false

Test-Path -Path $path -PathType Container # returns true