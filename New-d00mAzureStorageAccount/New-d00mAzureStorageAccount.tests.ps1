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
            $result = Test-AzureRmResourceGroupDeployment -ResourceGroupName 'testing' -TemplateFile .\d00mstorageaccount.json -storageAccountName 'd00mstorageaccount'
            $result | Should -BeNullOrEmpty
        }

        It "Should throw with invalid storage account name" {
            $result = Test-AzureRmResourceGroupDeployment -ResourceGroupName 'testing' -TemplateFile .\d00mstorageaccount.json -storageAccountName '!@#$%^&^'
            $result | Should -Not -BeNullOrEmpty
        }
    }
}