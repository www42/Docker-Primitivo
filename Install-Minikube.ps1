# Uninstall old version
Stop-VM -Name minikube
Remove-VM -Name minikube
rmdir $HOME/.minikube

# Download minikube-windows-amd64.exe, rename it to minikube.exe, and put it into $env:PATH

& minikube.exe start --vm-driver=hyperv --hyperv-virtual-switch="Default Switch" --alsologtostderr

dir $HOME/.minikube
Get-VM -Name minikube | format-table Name,State,AutomaticStartAction

kubectl.exe version
kubectl.exe config use-context minikube
kubectl.exe config current-context
kubectl.exe get nodes

