$Text = @'
<#
.SYNOPSIS

.DESCRIPTION
    
.EXAMPLE

.EXAMPLE

.EXAMPLE

#>

function 
{
    [CmdletBinding()]
    param
    (

    )

    begin
    {
        $cmdletName = $PSCmdlet.MyInvocation.MyCommand.Name
        $start      = Get-Date
        Write-Verbose -Message ('{0} : Begin execution : {1}' -f $cmdletName, 
                                                                 $start)
    }

    process
    {
 
    }

    end
    {
        $end = ($(Get-Date) - $start).TotalMilliseconds
        Write-Verbose -Message ('{0} : End execution' -f $cmdletName)
        Write-Verbose -Message ('Total execution time: {0} ms' -f $end)
    }
}
'@
New-IseSnippet -Title 'd00m Function' -Description 'Create a new d00m function' -Text $Text -Author 'd00mjaw87'