BREAK

<##############################
| Translating SID to Username |
##############################>

# Test SIDs...
# S-1-5-21-3140313827-3151114326-2973884846-8307
# S-1-5-21-3140313827-3151114326-2973884846-8281
# S-1-5-21-3140313827-3151114326-2973884846-8249
# S-1-5-21-3140313827-3151114326-2973884846-8308



function ConvertFrom-d00mSID
{
    param
    (
        [parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Value')]
        [string[]]$Sid
    )

    foreach ($s in $Sid)
    {
        try
        {
            $objSid  = New-Object -TypeName System.Security.Principal.SecurityIdentifier($s)
            $objUser = $objSid.Translate([System.Security.Principal.NTAccount])
            New-Object -TypeName psobject -Property @{Sid      = $s
                                                      Username = $objUser.Value} | 
                Write-Output
        }
        catch
        {
            throw
        }
    }
}