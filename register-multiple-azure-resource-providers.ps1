@(
    'microsoft.web', 
    'microsoft.insights'
) | ForEach-Object {
    try
    {
        $params = @{ProviderNameSpace = $_
                    Verbose           = $true}
        Register-AzureRmResourceProvider @params
    }
    catch
    {
        throw
    }
}