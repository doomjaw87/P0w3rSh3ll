<###############################
| FIND ALL FILES 2 LEVELS DEEP |
################################

ALL VERSIONS

Yet another file system task: list all *.log files in a folder structure, but only to a maximum depth
of 2 folder structures:

#>

$params = @{Path        = 'c:\windows'
            Filter      = '*.log'
            Recurse     = $true
            Depth       = 2
            Force       = $true
            ErrorAction = 'SilentlyContinue'}

Get-ChildItem @params |
    Select-Object -ExpandProperty FullName