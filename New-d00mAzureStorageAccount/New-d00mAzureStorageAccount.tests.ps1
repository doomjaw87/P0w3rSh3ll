try
{
    $subscription = Get-AzureRmSubscription
}
catch
{
    Login-AzureRmAccount
}

describe "d00m Storage Account Creation Testing" {
    context "Validating ARM template..." {
        It "ARM Template should be valid" {
            $params = @{ResourceGroupName  = 'testing'
                        TemplateFile       = 'G:\My Drive\git\P0w3rSh3ll\New-d00mAzureStorageAccount\d00mstorageaccount.json'
                        StorageAccountName = 'd00mstorageaccount1'}
            $result = Test-AzureRmResourceGroupDeployment @params
            $result | Should -BeNullOrEmpty
        }

        It "Should throw with invalid storage account name" {
            $params = @{ResourceGroupName  = 'testing'
                        TemplateFile       = 'G:\My Drive\git\P0w3rSh3ll\New-d00mAzureStorageAccount\d00mstorageaccount.json'
                        StorageAccountName = '@!##@%$%@#$%^@'}
            $result = Test-AzureRmResourceGroupDeployment @params
            $result | Should -Not -BeNullOrEmpty
        }
    }
}