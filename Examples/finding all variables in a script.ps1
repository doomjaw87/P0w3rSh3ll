<####################################
| FINDING ALL VARIABLES IN A SCRIPT |
#####################################

All Versions

In the previous tip we illustrated how you can analyze the content of a script block and search for
variables or commands. The same is possible for text-based scripts. The script below will
analyze itself and dump variables and commands:

#>

$filepath = $PSCommandPath
$tokens = $errors = $null

$ast = [System.Management.Automation.Language.Parser]::ParseFile($filepath, [ref]$tokens, [ref]$errors)

# find variables
$ast.FindAll( {$true}, $true) |
    Where-Object { $_.GetType().Name -eq 'VariableExpressionAst'} |
    Select-Object -Property VariablePath -ExpandProperty Extent |
    Select-Object -Property * -ExcludeProperty *ScriptPosition |
    Out-GridView -Title 'Variables'

# find commands
$ast.FindAll( {$true}, $true) |
    Where-Object {$_.GetType().Name -eq 'CommandAst' } |
    Select-Object -ExpandProperty Extent |
    Select-Object -Property * -ExcludeProperty *ScriptPosition |
    Out-GridView -Title 'Commands'


# Just make sure the script is saved to disk, or specify a different path to a valid script in $filepath