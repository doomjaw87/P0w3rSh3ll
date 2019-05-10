$credentialIdToChange = 'testusername'
$newPassword = 'newp@ssw0rd123!'

$jenkinsUrl = 'http://10.101.222.4:8080/scriptText'

$apiToken = '11a65a6453b20fb37200d8d2bd20b091a7'
$authUsername = 'automationuser'
$headers = @{Authorization = $("Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($authUsername):$($apiToken)")))")}

$script = @"
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl

def changePassword = { username, new_password ->
    def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
        com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
        jenkins.model.Jenkins.instance
    )

    def c = creds.findResult { it.username == username ? it : null }

    if (c) {
        println "Found credential `${c.id} for username `${c.username}"

        def credentials_store = jenkins.model.Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

        def result = credentials_store.updateCredentials(
            com.cloudbees.plugins.credentials.domains.Domain.global(), 
            c, 
            new UsernamePasswordCredentialsImpl(c.scope, null, c.description, c.username, new_password)
        )

        if (result) {
            println "Password changed for `${username}" 
        } 
        else {
            println "Failed to change password for `${username}"
        }
    } 
    
    else {
        println "could not find credential for `${username}"
    }
}

changePassword("$credentialIdToChange", "$newPassword")
"@

$params = @{Body = "script=$($script)"
    Headers = $headers
    Uri = $jenkinsUrl
    Method = 'Post'}
$response = Invoke-WebRequest @params
$response.Content