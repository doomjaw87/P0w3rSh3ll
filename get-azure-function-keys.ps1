$resourceGroup = 'rgc75b8e17'
$FunctionAppName = 'functionc75b8e17'

$content = Get-AzureRmWebAppPublishingProfile -ResourceGroupName $ResourceGroup -Name $FunctionAppName -OutputFile creds.xml -Format WebDeploy
$username = Select-Xml -Content $content -XPath "//publishProfile[@publishMethod='MSDeploy']/@userName"
$password = Select-Xml -Content $content -XPath "//publishProfile[@publishMethod='MSDeploy']/@userPWD"
$accessToken = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))

$masterApiUrl = "https://$FunctionAppName.scm.azurewebsites.net/api/functions/admin/masterkey"
$masterKeyResult = Invoke-RestMethod -Uri $masterApiUrl -Headers @{"Authorization"=$accessToken;"If-Match"="*"}
$masterKey = $masterKeyResult.Masterkey

$functionApiUrl = "https://$FunctionAppName.azurewebsites.net/admin/host/keys?code=$masterKey"
$functionApiResult = Invoke-WebRequest -UseBasicParsing -Uri $functionApiUrl
$keysCode = $functionApiResult.Content | ConvertFrom-Json
$functionKey = $keysCode.Keys[0].Value

$functionKey

BREAK
$saveString = "##vso[task.setvariable variable=FunctionAppKey;]{0}" -f $functionKey

Write-Host ("Writing: {0}" -f $saveString)
Write-Output ("{0}" -f $saveString)