Clear-Host

invoke-restmethod https://d00mfunction.azurewebsites.net/api/GenerateGuids?code=CWX75BndDtJffbUP8qj4ZJf8pZaZJqxAlkw1A1cCetfG18DhhDLP5Q==



$base = 'https://d00mfunction.azurewebsites.net/api/d00mPowerShellHTTPTrigger?'
$code = 'YUNHZaVAWo8wVHeRCZvRoJWsULDQohC81rF75vPm0kkwX1K55Vps4w=='
$uri  = "$($base)code=$($code)"

$body = @{Name  = 'From GET'
          Thing = 'This is the from GET method'}
Invoke-RestMethod -Uri $uri -Method Get -Body $body

$body = @{Name  = 'From POST'
          Thing = 'This is from the POST method'} | ConvertTo-Json
Invoke-RestMethod -Uri $uri -Method Post -Body $body

$uri = 'https://d00mfunction.azurewebsites.net/api/d00mAge'
Invoke-RestMethod -Uri $uri -Method Get

$body = @{Month = '6'
          Day   = '1'
          Year  = '2009'
          Which = 'His'}
Invoke-RestMethod -Uri $uri -Method Get -Body $body

$body = @{Month = '11'
          Day   = '16'
          Year  = '1988'
          Which = 'His'}
Invoke-RestMethod -Uri $uri -Method Get -Body $body

$body = @{Which = 'Hers'}
Invoke-RestMethod -Uri $uri -Method Get -Body $body

$body = @{Month = '6'
          Day   = '12'
          Year  = '2012'
          Which = 'Hers'}
Invoke-RestMethod -Uri $uri -Method Get -Body $body