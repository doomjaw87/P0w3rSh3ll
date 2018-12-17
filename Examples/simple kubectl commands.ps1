# Switch contexts
#kubectl config use-context docker-for-desktop
#kubectl config use-context aws

# Get Cluster Information
#kubectl cluster-info

# Get all node names
#kubectl describe nodes | select-string Name: | where {$_ -notlike '*host*'} | %{$_.ToString().Split(' ')[-1]}

# Get all service names
#kubectl describe services | select-string name: | %{$_.Tostring().Split(' ')[-1]}

# Get all deployment names
#kubectl describe deployments | select-string name: | %{$_.ToString().Split(' ')[-1]}

# Get all pod names
#kubectl describe pods | select-string Name: | where {$_ -notlike '*SecretName:*'} | %{$_.ToString().Split(' ')[-1]}

# xzibit json
#((kubectl get deployments -o json | ConvertFrom-Json).items.metadata.annotations.'kubectl.kubernetes.io/last-applied-configuration' | ConvertFrom-Json)

# can perform different gets for different types within the same command
#kubectl get node/ip-10-107-16-225.ec2.internal pod/datadog-agent-c4zdh service/kubernetes

# list all containers in the pods
# Important to note that linux single quotes must be double quotes in windows
#kubectl get pods -o=jsonpath="{range .items[*]}{'\n'}{.metadata.name}{' ('}{.metadata.labels.app}{')'}{':\t'}{range .spec.containers[*]}{.image}{', '}{.imageID}{' poop '}{end}{end}"

#kubectl get pods -o=jsonpath="{range .items[*]}-----------------------------{'\n'}{'Name:\t'}{.metadata.name}{'\n'}{'App:\t'}{.metadata.labels.app}{'\n'} {'\n'}{end}"