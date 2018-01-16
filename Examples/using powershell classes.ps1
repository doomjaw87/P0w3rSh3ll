<#############################
| READING POWERSHELL CLASSES |
##############################

Version 5.0 and Later

Starting with PowerShell 5, you can define classes. They have many use cases. One would be
to create libraries of useful functions to better organize them. For this, a class would
define "static" methods. Here is a simple example.

#>

class HelperStuff
{
    # get first character of string and throw exception
    # when string is empty or multi-line
    static [char] GetFirstCharacter([string]$Text)
    {
        if ($Text.Length -eq 0)
        {
            throw 'String is empty'
        }
        if ($text.Contains("``n"))
        {
            throw 'String contains multiple lines'
        }
        return $Text[0]
    }

    # get file extension in lower case
    static [string] GetFileExtension([String]$Path)
    {
        return [io.path]::GetExtension($path).ToLower()
    }
}