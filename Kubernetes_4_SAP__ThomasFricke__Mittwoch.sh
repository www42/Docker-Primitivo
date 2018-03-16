# Strategy
#  1. Get a VM with Ubuntu 16.04 OS
#  2. Install Docker
#  3. Install kubectl tool
#  4. Install minikube

# install tab completion for bash
apt-get install bash-completion
source /etc/bash-completion

# 2. Install Docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce
sudo docker run hello-world

# 3. Install kubectl tool
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# Enable auto completion on Linux bash
source <(kubectl completion bash)

# 4. Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
# Enable auto completion on Linux bash
source <(minikube completion bash)
# minikube start macht folgendes: startet eine VM (die zuvor downgeloaded wurde), provisioniert Kubernetes, erzeugt eine config für kubectl
# --vm-driver=none   Run minikube directly on OS, no VM needed (on Linux only)
minikube start --vm-driver=none

# First deployment
# copy & paste nginx.yaml
#  https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment
kubectl create -f ./nginx.yaml


# https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
# kubectl kann viele Cluster verwalten 
# Dazu benutzt es eine config-Datei. Default ist $HOME\.kube\config
dir $HOME\.kube
$KUBECONFIG

# Die config enthält clusters, contexts, and users.
# diese Datei kann man sich auch anschauen
kubectl config view
kubectl config view --minify
kubectl config get-contexts
kubectl config current-context

# Man wechselt nicht den Cluster sondern den Context
kubectl config use-context minikube
kubectl config use-context docker-for-desktop

# Client Version ist die Client Version
# Server Version die die Version vom API Server des Clusters
kubectl version
kubectl version --short=true

# Get some cluster diagnostics
kubectl get componentstatuses


kubectl edit deployment nginx-deployment
minikube service list
minikube get-k8s-versions

kubectl get nodes
kubectl get pods
kubectl get pods --all-namespaces

(kubectl get pods --all-namespaces -o=json | 
    convertfrom-json).items | 
    select @{L = 'nodeName'; E = {$_.spec.nodeName}}, @{L = 'podIP'; E = {$_.status.podIP}}, @{L = 'hostIP'; E = {$_.status.hostIP}}, @{L = 'podName'; E = {$_.metadata.name}}, @{L = 'states'; E = {$_.status.containerStatuses.state}} |
    format-Table *
