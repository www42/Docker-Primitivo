$ComputerName = "SVR2"

New-LabVm -ComputerName $ComputerName

$Iso = "D:\iso\Windows_InsiderPreview_Server_17074.iso"
$VmName = "$Lab-$ComputerName"
Add-VMDvdDrive -VMName $VmName
Set-VMDvdDrive -VMName $VmName -Path $Iso
Set-VMFirmware -VMName $VmName -FirstBootDevice (Get-VMDvdDrive -VMName $VmName)

Connect-LabVm -ComputerName $ComputerName

Set-VMProcessor -VMName $VmName -ExposeVirtualizationExtensions $true
Set-VMMemory -VMName $VmName -StartupBytes 10GB
Set-VMNetworkAdapter -VMName $VmName -MacAddressSpoofing On

$LocalCred = New-Object -TypeName System.Management.Automation.PSCredential 'Administrator',(ConvertTo-SecureString $LabPw -AsPlainText -Force)

$SVR2 = New-PSSession -VMName $VmName -Credential $LocalCred
Enter-PSSession $SVR2

Install-WindowsFeature -Name Containers,Hyper-V -IncludeManagementTools -Restart
dir "$env:ProgramFiles\Linux Containers"

Get-PackageProvider -ListAvailable
Find-PackageProvider -Name "*docker*"
Install-PackageProvider -Name "DockerMsftProviderInsider" -Force
Find-Package -ProviderName "DockerMsftProviderInsider"
Install-Package -Name "Docker" -ProviderName "DockerMsftProviderInsider" -Force
Restart-Computer
# we got 17.06.2-ee-6
# docker pull    microsoft/nanoserver-insider       ... ok
# docker run ... microsoft/nanoserver-insider       ... error

Uninstall-Package docker

# try 2.0.0-ee-1-tp6 (17.06.3-ee-1-tp6)
Install-PackageProvider -Name "DockerProvider" -Force
Find-Package -ProviderName "DockerProvider"
Find-Package -ProviderName "DockerProvider" -RequiredVersion "preview"
Install-Package -Name "Docker" -RequiredVersion "preview" -ProviderName "DockerProvider" -Force

# isolation hyperv funktioniert
docker run --rm -ti --isolation hyperv microsoft/nanoserver-insider cmd