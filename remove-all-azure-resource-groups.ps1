$sub = Get-AzureRmSubscription
if ($sub.Id -eq 'b262856c-1efd-496c-9ce0-ed796a84b848')
{
    Get-AzureRmResourceGroup | % {
        Remove-AzureRmResourceGroup $_.ResourceGroupName -Force -AsJob
    }
}