<######################
| BULK RENAMING FILES |
#######################

Here is a quick way to bulk-rename files. But be careful...
this small piece of code can rename thousands of files in
a blink of an eye.

#>

$path = "$home\Pictures"
$filter = '*.jpg'
Get-ChildItem -Path $path -Filter $filter |
    Rename-Item -NewName {$_.Name -replace 'DSC', 'TEST'}