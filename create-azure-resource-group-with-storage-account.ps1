1..10 | %{
    $guid = (New-Guid).Guid.split('-')[0]

    $tags = @{Deployment = 'PowerShell'
              CreatedBy  = 'Alex Sparkman'
              Guid       = $guid}

    $params = @{Name = "rg$guid"
                Location = 'West US'
                Tag      = $tags
                Force    = $true}
    New-AzureRmResourceGroup @params

    $params = @{ResourceGroupName = "rg$guid"
                Name              = "storage$guid"
                Location          = 'West US'
                SkuName           = 'Standard_LRS'
                Kind              = 'StorageV2'
                Tags              = $tags
                AsJob             = $true}
    New-AzureRmStorageAccount @params

    $params = @{ResourceGroupName = "rg$guid"
                Name              = "pip$guid"
                Location          = 'West US'
                Sku               = 'Basic'
                AllocationMethod  = 'Dynamic'
                IpAddressVersion  = 'IPv4'
                DomainNameLabel   = "dns$($guid)"
                Tag               = $tags
                AsJob             = $true}
    New-AzureRmPublicIpAddress @params

    $params = @{Name = 'subnet1'
                AddressPrefix = '1.0.0.0/24'}
    $subnet = New-AzureRmVirtualNetworkSubnetConfig @params

    $params = @{ResourceGroupName = "rg$guid"
                Location          = 'West US'
                Name              = "vnet$guid"
                AddressPrefix     = '1.0.0.0/16'
                DnsServer         = '8.8.8.8'
                Subnet            = $subnet
                Tag               = $tags
                AsJob             = $true}
    $vnet = New-AzureRmVirtualNetwork @params
}