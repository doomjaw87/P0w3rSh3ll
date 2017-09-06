<##########################################
| FINDING ALL VARIABLES IN A SCRIPT BLOCK |
###########################################

All Versions

To analyze the content of a script block, you can easily examine the AST, and, for example,
create a list of all variables in the code:

#>

$code = {
    $a = 'Test'
    $b = 12
    Get-Service
    Get-Process
    $number = 100
}

$code.ast.FindAll( { $true }, $true) |
    Where-Object {$_.gettype().Name -eq 'VariableExpressionAst'} |
    Select-Object -Property VariablePath -ExpandProperty Extent |
    Out-GridView