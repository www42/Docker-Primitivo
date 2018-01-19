$ComputerName = "U1"

$VmName = "$Lab-$ComputerName"
New-LabVm -ComputerName $ComputerName

Add-VMDvdDrive -VMName $VmName
$Iso = "C:\iso\ubuntu-16.04-desktop-amd64.iso"
Set-VMDvdDrive -VMName $VmName -Path $Iso
Set-VMFirmware -VMName $VmName -FirstBootDevice (Get-VMDvdDrive -VMName $VmName)
Set-VMFirmware -VMName $VmName -SecureBootTemplate "MicrosoftUEFICertificateAuthority"

Connect-LabVm -ComputerName $ComputerName