$locations = Get-AzureRmLocation

foreach ($location in $locations)
{
    New-Variable -Name $location.Location -Force
    
    $data = @{rgName = "rg$($location.Location)"
              rgLocation = $location.Location
              displayName = $location.DisplayName}

    $job = Start-Job -Name $location.Location -ArgumentList $data -ScriptBlock {
        #New-Item -Path C:\$($args[0].rgName).txt -Value "$($args[0].rgLocation) $($args[0].displayName)"
        $tag = @{Deployment = 'PowerShell'
                 CreatedBy  = 'Alex Sparkman'
                 DisplayName = $($args[0].DisplayName)}
        New-AzureRmResourceGroup -Name $($args[0].rgName) -Location $($args[0].rgLocation) -Tag $tag -Force
        #New-AzureRmStorageAccount -ResourceGroupName $($args[0].rgName) -Name "rgstorage1" -SkuName Standard_LRS -Location $($args[0].rgLocation) -Kind StorageV2 -Tag $tag -AsJob
    }

    Set-Variable -Name $location.Location -Value $job
}