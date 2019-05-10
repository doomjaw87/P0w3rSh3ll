$jenkinsUrl = 'http://10.101.222.4:8080/scriptText'

$apiToken = '11a65a6453b20fb37200d8d2bd20b091a7'
$authUsername = 'automationuser'
$headers = @{Authorization = $("Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($authUsername):$($apiToken)")))")}

$script = @"
def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
    com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
    Jenkins.instance,
    null,
    null
);
for (c in creds) {
    println "`${c.id} : `${c.description}"
}
"@

$params = @{Body = "script=$($script)"
    Headers = $headers
    Uri = $jenkinsUrl
    Method = 'Post'}
$response = Invoke-WebRequest @params
$response.Content