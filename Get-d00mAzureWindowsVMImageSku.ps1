$params = @{Location      = 'southcentralus'
            PublisherName = 'microsoftwindowsserver'
            Offer         = 'windowsserver'}
Get-AzureRmVMImageSku @params