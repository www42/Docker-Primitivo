#region Prerequisites

# Directory C:\Program Files\Linux Containers
# At the end of the day there should be three files:
#
#        bootx64.efi   (from LinuxKit)
#        initrd.img    (from LinuxKit)
#        uvm.vhdx  


$dir = "$Env:ProgramFiles\Linux Containers”
mkdir $dir

# Set special permission
function set_perms {
  param([string] $Root)
  # Give the virtual machines group full control
  $acl = Get-Acl -Path $Root
  $vmGroupRule = new-object System.Security.AccessControl.FileSystemAccessRule("NT VIRTUAL MACHINE\Virtual Machines", "FullControl","ContainerInherit,ObjectInherit", "None", "Allow")
  $acl.SetAccessRule($vmGroupRule)
  Set-Acl -AclObject $acl -Path $Root
}
set_perms -Root  $dir

# Download tool to uncompress .xz file
curl https://tukaani.org/xz/xz-5.2.3-windows.zip -OutFile "$HOME\Downloads\xz-5.2.3-windows.zip"
Expand-Archive -Path "$HOME\Downloads\xz-5.2.3-windows.zip" -DestinationPath "$HOME\Downloads\xz-5.2.3-windows"
$xz = "$HOME\Downloads\xz-5.2.3-windows\bin_x86-64\xz.exe"

#endregion

#region Download LinuxKit

# Inspect source
Start-Process "https://github.com/friism/linuxkit/releases"

$Uri = "https://github.com/friism/linuxkit/releases/download/preview-1/linuxkit.zip"
Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $HOME\Downloads\linuxkit.zip

Expand-Archive $HOME\Downloads\linuxkit.zip -DestinationPath "$dir\." 

 #endregion 

 #region Download vhdx

# Inspect source
Start-Process -FilePath "https://partner-images.canonical.com/hyper-v/linux-containers/xenial/current"

$Uri = "https://partner-images.canonical.com/hyper-v/linux-containers/xenial/current/xenial-container-hyperv.vhdx.xz"
Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $HOME\Downloads\xenial-container-hyperv.vhdx.xz

& $xz -d $HOME\Downloads\xenial-container-hyperv.vhdx.xz
dir "$HOME\Downloads\xenial-container-hyperv.vhdx"

Copy-Item -Path "$HOME\Downloads\xenial-container-hyperv.vhdx" -Destination "$dir\uvm.vhdx"

#endregion

#region Start Docker daemon -- Start new Powershell console (not ISE)

$env:LCOW_SUPPORTED=1
$env:LCOW_API_PLATFORM_IF_OMITTED="linux"
C:\Labs\Docker\LCOW\dockerd.exe -D --experimental -H "npipe:////./pipe//docker_lcow" --data-root C:\Labs\Docker\LCOW\data-root

#endregion

#region Try it -- Start new Powershell console (not ISE)

$env:DOCKER_HOST = "npipe:////./pipe//docker_lcow"

#endregion