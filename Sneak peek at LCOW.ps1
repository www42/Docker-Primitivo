Start-Process "http://stefanscherer.github.io/sneak-peek-at-lcow/"
Start-Process "https://github.com/linuxkit/lcow"
$LcowPath = "C:\Labs\Docker\LCOW_20180122"

mkdir $LcowPath
Invoke-WebRequest -UseBasicParsing -OutFile "$LcowPath\dockerd.exe" https://master.dockerproject.org/windows/x86_64/dockerd.exe
Invoke-WebRequest -UseBasicParsing -OutFile "$LcowPath\docker.exe" https://master.dockerproject.org/windows/x86_64/docker.exe


Set-VMProcessor -VMName Windows_10 -ExposeVirtualizationExtensions $true
Set-VMMemory -VMName Windows_10 -StartupBytes 4GB
Set-VMNetworkAdapter -VMName Windows_10 -MacAddressSpoofing On
Start-VM Windows_10