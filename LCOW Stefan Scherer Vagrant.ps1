# Thanks to Stefan Scherer
Start-Process "http://stefanscherer.github.io/sneak-peek-at-lcow/"

# Hyper-V Host
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

# Windows 10 (1709): No additional VmSwitch required, use "Default Switch"

# Windows Server 2016:
# $na = Get-NetAdapter -Physical | ? status -eq "up"
# New-VMSwitch -Name "External Network" -NetAdapterName $na.Name

Get-NetConnectionProfile | ft InterfaceAlias,InterfaceIndex,NetworkCategory
Set-NetConnectionProfile -InterfaceIndex 6,13 -NetworkCategory Private
Enable-PSRemoting
Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force

vagrant --version
vagrant plugin install vagrant-reload

git --version
mkdir C:\Git
cd C:\Git
git clone https://github.com/StefanScherer/docker-windows-box
cd .\docker-windows-box\lcow
vagrant up

Get-VM
$Cred = Get-Credential
$W10 = New-PSSession -VMName Windows_10 -Credential $Cred

Enter-PSSession -Session $W10
 cd \
 Get-Command docker,dockerd
 Get-Service docker | ft Name,DisplayName,StartType,Status
 Get-WindowsOptionalFeature -Online -FeatureName *hyper* | ft FeatureName,DisplayName,State
 Get-WindowsOptionalFeature -Online -FeatureName containers | ft FeatureName,DisplayName,State
Exit-PSSession

Stop-VM -Name Windows_10
Set-VMProcessor -VMName Windows_10 -ExposeVirtualizationExtensions $true
Set-VMMemory -VMName Windows_10 -StartupBytes 8GB
Set-VMNetworkAdapter -VMName Windows_10 -MacAddressSpoofing On
Start-VM Windows_10


vagrant package --output mynew.box