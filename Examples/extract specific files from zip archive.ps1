<##########################################
# Extract Specific Files from ZIP Archive #
###########################################

Version 5 and later

Starting with PowerShell 5, cmdlets like Extract-Archive can extract the content of
ZIP files to disk. However, you can always extract only the entire archive.

If you'd rather like to extract individual files, you can resort to .NET methods.
Here is a sample that does this:

- It takes a ZIP file and opens it for reading
- It identifies all files inside the ZIP file that match a given file extension
- It extracts only these files to an output folder of your choice

Comments in the code explain what the code does. Just make sure you adjust the initial
variables and specify a ZIP file that exists, and a file extension that exists inside
the ZIP file:

#>

#requires -Version 5.0

# change $Path to a ZIP file that exists on your system!
$Path = "$Home\Documents\Test_Zip.zip"

# change extension filter to a file extension that exists
# inside your ZIP file
$Filter = '*.txt'

# change output path to a folder where you want the extracted
# files to appear
$OutPath = "$Home\Documents\Test_Zip_Output"

# ensure the output folder exists
$exists = Test-Path -Path $OutPath
if ($exists -eq $false)
{
    $null = New-Item -Path $OutPath -ItemType Directory -Force
}
else
{
    $null = Remove-Item -Path $OutPath -Recurse -Force
    $null = New-Item -Path $OutPath -ItemType Directory -Force
}

# load ZIP methods
Add-Type -AssemblyName System.IO.Compression.FileSystem

# open ZIP archive for reading
$zip = [System.IO.Compression.ZipFile]::OpenRead($Path)

# find all files in ZIP that match the filter (i.e. file extension)
$zip.Entries | 
    Where-Object {$_.FullName -like $Filter} |
    ForEach-Object { 
        # extract the selected items from the ZIP archive
        # and copy them to the out folder
        $FileName = $_.Name
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$OutPath\$FileName", $true)
}

# close ZIP file
$zip.Dispose()

# open out folder
explorer $OutPath 