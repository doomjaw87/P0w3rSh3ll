$obj  = New-Object -ComObject Scripting.FileSystemObject
$path = 'C:\users\Surface'
Get-ChildItem -Path $path | 
    Where {$_.PSIsContainer -eq $true} |
    %{"{0} : {1:N2} MB" -f $_.FullName, ($obj.GetFolder($_.FullName).Size/1MB)} |
    Out-File c:\directorysizes.txt -Append -Force