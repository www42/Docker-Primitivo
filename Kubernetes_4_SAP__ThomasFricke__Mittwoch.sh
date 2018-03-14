# install tab completion for bash
apt-get install bash-completion
source /etc/bash-completion

# install docker
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

# install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
source <(kubectl completion bash)

# install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
source <(minikube completion bash)
# no VM needed (Linux only)
minikube start --vm-driver=none

# copy & paste nginx.yaml
#  https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment
kubectl create -f ./nginx.yaml


kubectl config get-contexts

kubectl edit deployment nginx-deployment
minikube service list
minikube get-k8s-versions