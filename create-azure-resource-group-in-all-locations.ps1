Get-AzureRmLocation | %{
    New-AzureRmResourceGroup -Name "rg$($_.Location)" -Location $_.Location -Tag @{Deployment='PowerShell';CreatedBy='Alex Sparkman';Location=$($_.DisplayName)}
}