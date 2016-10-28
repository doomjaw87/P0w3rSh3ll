<#########################
# Cmdlet Error Reporting #
#########################>

# These will error and flood the console with red error text
$data1 = Get-ChildItem -Path C:\NotARealDirectory -Filter *.ps1
$data2 = Get-Process -FileVersionInfo


# These will still error but not flood the console with red error text
$data1 = Get-ChildItem -Path C:\NotARealDirectory -Filter *.ps1 -ErrorAction SilentlyContinue -ErrorVariable errorList
$data2 = Get-Process -FileVersionInfo -ErrorAction SilentlyContinue -ErrorVariable +errorList

# The ErrorVariable errorList will then be available to do whatever you want with it
$issues = $errorList.CategoryInfo | Select-Object -Property Category, TargetName
$issues