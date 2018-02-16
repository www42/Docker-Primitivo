docker version --format '{{json .}}'
docker version --format '{{.Server.Os}}'
docker version --format '{{upper .Server.Os}}'
docker version --format 'Client={{upper .Client.Os}}, Server={{upper .Server.Os}}'

docker version
kubectl version --client
kubectl config current-context
kubectl config get-contexts
kubectl config use-context "docker-for-desktop"
kubectl cluster-info
kubectl get nodes --all-namespaces
kubectl get pods
kubectl create -f C:\temp\nginx-deployment.yaml
kubectl get pods --all-namespaces

#region get k8s pods info
(kubectl get pods --all-namespaces -o=json | convertfrom-json).items | select @{L = 'nodeName'; E = {$_.spec.nodeName}}, @{L = 'podIP'; E = {$_.status.podIP}}, @{L = 'hostIP'; E = {$_.status.hostIP}}, @{L = 'podName'; E = {$_.metadata.name}}, @{L = 'states'; E = {$_.status.containerStatuses.state}} | format-Table *
#endregion