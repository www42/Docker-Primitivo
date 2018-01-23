# Thanks to Stefan Scherer
Start-Process "http://stefanscherer.github.io/sneak-peek-at-lcow/"

# Thanks to Rolf Neugebauer
Start-Process "https://github.com/linuxkit/lcow"


$LcowPath = "C:\Labs\Docker\LCOW_20180122"

mkdir $LcowPath
Invoke-WebRequest -UseBasicParsing -OutFile "$LcowPath\dockerd.exe" https://master.dockerproject.org/windows/x86_64/dockerd.exe
Invoke-WebRequest -UseBasicParsing -OutFile "$LcowPath\docker.exe" https://master.dockerproject.org/windows/x86_64/docker.exe

mkdir "$env:ProgramFiles\Linux Containers"
Invoke-WebRequest -OutFile "$env:TEMP\linuxkit-lcow.zip" "https://23-111085629-gh.circle-artifacts.com/0/release.zip"
Expand-Archive -Path "$env:TEMP\linuxkit-lcow.zip" -DestinationPath "$env:ProgramFiles\Linux Containers" -Force
