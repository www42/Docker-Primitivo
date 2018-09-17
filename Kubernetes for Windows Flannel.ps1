# Kubernetes for Windows Flannel
Start-Process "https://1drv.ms/w/s!AgH65RVQdrbiglNr7P7P4VrO8Rxr"

#--------------------------------------------------------------------------------------------
#   DC1    DC          Windows Server 2016         (Build 10.0.14393.2363)   10.80.0.10 /16
#   Host1  Member      Windows Server 2016         (Build 10.0.14393.2363)   10.80.0.51 /16
#   Host2  Member      Windows Server 2016         (Build 10.0.14393.2363)   10.80.0.52 /16
#   Host3  Standalone  Windows Server 2019 Preview (Build 10.0.17723.1000)   10.80.0.53 /16
#   Host4  Linux       Ubuntu 16.04                                          10.80.0.54 /16
#--------------------------------------------------------------------------------------------

$LocalUser = 'Administrator'
$DomUser = 'Adatum\Administrator'
$Pw = ConvertTo-SecureString -String 'Pa55w.rd' -AsPlainText -Force
$LocalCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $LocalUser,$Pw
$DomCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomUser,$Pw

$DC1   = New-PSSession -VMName "Docker-DC1"   -Credential $DomCred
$Host1 = New-PSSession -VMName "Docker-Host1" -Credential $DomCred
$Host2 = New-PSSession -VMName "Docker-Host2" -Credential $DomCred
$Host3 = New-PSSession -VMName "Docker-Host3" -Credential $DomCred

Import-Module -Name "activedirectory" -PSSession $DC1
Get-ADComputer -Filter * | ft Name,DistinguishedName

Enter-PSSession -Session $Host3
#------------------------------
Get-NetIPConfiguration
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "10.80.0.53" -PrefixLength 16 -DefaultGateway "10.80.0.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8"
Get-NetConnectionProfile -InterfaceAlias "Ethernet" | % NetworkCategory
Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" | ft DisplayName,DisplayGroup,Direction,Action,Enabled
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

$ComputerName = "Host4"
#----------------------
$VmName = "Docker-Host4"
$LinuxIso = "C:\iso\ubuntu-16.04-desktop-amd64.iso"
New-LabVm -ComputerName "Host4" -Count 1 -Mem 2GB
Set-VM -Name $VmName -StaticMemory
Set-VM -Name $VmName -AutomaticCheckpointsEnabled $false
Add-VMDvdDrive -VMName $VmName -ControllerNumber 0 -ControllerLocation 1 -Path $LinuxIso
Set-VMFirmware -VMName $VmName -FirstBootDevice (Get-VMDvdDrive -VMName $VmName)
Set-VMFirmware -VMName $VmName -SecureBootTemplate MicrosoftUEFICertificateAuthority
Connect-LabVm $ComputerName

Remove-VMDvdDrive -VMName $VmName -ControllerNumber 0 -ControllerLocation 1

& sudo apt-get install openssh-server
& sudo apt-get install linux-tools-virtual-lts-xenial linux-cloud-tools-virtual-lts-xenial

#-------------------------------------------------------------------------------------
Checkpoint-Lab -Description "Host4 created (Linux), Windows Cumulative Update 07"
#-------------------------------------------------------------------------------------

$VmName = "Docker-Host3"
Set-VMProcessor -VMName $VmName -ExposeVirtualizationExtensions $true
Set-VMNetworkAdapter -VMName $VmName -MacAddressSpoofing On

# putty Host4 (Ubuntu Linux)
# --------------------------
# Install Docker
sudo -i
apt-get remove docker docker-engine docker.io
apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce
docker run hello-world
systemctl enable docker

# Install k8s using kubeadm
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update && apt-get install -y kubelet kubeadm kubectl
vi /etc/fstab # remove a line referencing 'swap.img' , if it exists
swapoff -a
kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16
#  Your Kubernetes master has initialized successfully!
#  
#  To start using your cluster, you need to run the following as a regular user:
#  
#    mkdir -p $HOME/.kube
#    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#    sudo chown $(id -u):$(id -g) $HOME/.kube/config
#  
#  You should now deploy a pod network to the cluster.
#  Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#    https://kubernetes.io/docs/concepts/cluster-administration/addons/
#  
#  You can now join any number of machines by running the following on each node
#  as root:
#  
#    kubeadm join 10.80.0.54:6443 --token scrd0c.m90pptwbler2p6vj --discovery-token-ca-cert-hash sha256:26dca0f8debc936efa776a481993d4845705304afc05ceb4e2aacb04c699b6d4
#  

# regular user paul
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#-------------------------------------------------------------------------------------
Checkpoint-Lab -Description "k8s cluster created"
#-------------------------------------------------------------------------------------

Start-Process "https://kubernetes.io/docs/concepts/cluster-administration/networking/"