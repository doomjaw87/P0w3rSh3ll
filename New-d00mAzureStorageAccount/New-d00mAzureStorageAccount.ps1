$params = @{ResourceGroupName  = 'testing'
            TemplateFile       = 'G:\My Drive\git\P0w3rSh3ll\New-d00mAzureStorageAccount\d00mstorageaccount.json'
            StorageAccountName = 'd00mstorageaccount1'}
New-AzureRmResourceGroupDeployment @params