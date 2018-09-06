$storageAccount = 'd00mfunctionstorage'
$accesskey      = 'p2BTjoC90VwIGaU74uBxqiDPYqfdjlxg93xFmR9xoMM+Gw84vJdhqPB0DRPj2A1CXYDwAoJlkcQTphyEGcDlkw=='
$tableName = 'd00mTable'
$partitionKey = 1
$count = 1

$table_Url = "https://$storageAccount.table.core.windows.net/$tableName"
$gmtTime = (Get-Date).ToUniversalTime().ToString('R')
$signString = "$gmtTime`n/$storageAccount/$tableName"
$hmacsha = New-Object -TypeName System.Security.Cryptography.HMACSHA256
$hmacsha.Key = [Convert]::FromBase64String($accesskey)
$signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($signString))
$signature = [Convert]::ToBase64String($signature)
$headers = @{'x-ms-date'    = $gmtTime
             Authorization  = "SharedKeyLite $($storageAccount):$signature"
             'x-ms-version' = '2017-04-17'
             Accept         = 'application/json;odata=fullmetadata'}
$items = Invoke-RestMethod -Method Get -Uri $table_Url -Headers $headers -ContentType application/json

if ($items.value)
{
    $keys = ($items | Where {$_.value.partitionKey -eq $partitionKey}).Value.rowKey
    $rowKey = $keys | %{Invoke-Expression $_} | Sort-Object -Descending | Select-Object -First 1
}
else
{
    $rowKey = 1
}

while ($count -le 10)
{
    $resource = "$tableName(PartitionKey='$partitionKey',RowKey='$rowKey')"
    $table_Url = "https://$storageAccount.table.core.windows.net/$resource"
    $body = @{
        Random = $((Get-Random).ToString())
        Guid   = $((New-Guid).Guid)
    } | ConvertTo-Json

    $gmtTime = (Get-Date).ToUniversalTime().ToString('R')
    $signString = "$gmtTime`n/$storageAccount/$resource"
    $hmacsha = New-Object -TypeName System.Security.Cryptography.HMACSHA256
    $hmacsha.Key = [Convert]::FromBase64String($accesskey)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($signString))
    $signature = [Convert]::ToBase64String($signature)

    $headers = @{'x-ms-date'      = $gmtTime
                 Authorization    = "SharedKeyLite $($storageAccount):$signature"
                 'x-ms-version'   = '2017-04-17'
                 Accept           = 'application/json;odata=fullmetadata'}
    $item = Invoke-RestMethod -Method PUT -Uri $table_Url -Headers $headers -Body $body -ContentType application/json
    $rowKey++
    $count++
}