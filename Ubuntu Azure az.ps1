az --version
az login
#region Variables
$Name = "Docker-Ubu1"
$ResourceGroup = "DockerRG"
$Location = "westeurope"
$Image = "UbuntuLTS"
$Size = "Standard_D2s_v3"
$Vnet = "Docker-Vnet"
$Subnet = "default"
$AdminUserName = "tj"
$SshKeyValue = 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAww0DrolFGkG2uMgHz/EIkYdkNG6pJULP44OHZcXG85c+Ab1jSdXr9BLyaWx8L4QX76Rs+bRwboLUogKg1Lz0O9fXtssuKlY+PtW1DHvaH/xirC1Unjz99LD5TFxN8HB054G1go2S29BUCQUMtmCa2oSRPisLQLZspLjgkATFDSubWYM6SBREuGQDZ9MOMm3rk1rSZsgaNxayZYIVbJ2yk2oh5Nub7A1P8hU3h8RpXDlHMTEvKyBJsU6DjaF/ipX8Xm9TZ0Vc1PoXz0MWuEGnB1ZYgf23QWhz0bdwuZd2QnfxxeMEWNOlCeJJWQvMkVuQEXIO2UCD95s9oKku7zLcow== tj'
#endregion
#region Set Location
az account list-locations
az configure --defaults location=$Location
#endregion
#region Create Resource Group
az group list
az group create --name $ResourceGroup
az configure --defaults group=$ResourceGroup
#endregion
#region Create VNet
az network vnet create --name $Vnet --resource-group $ResourceGroup --location $Location --address-prefix 10.42.0.0/16 --subnet-name "Pilot"  --subnet-prefix 10.42.0.0/24
az network vnet list
#endregion
#region Create VM
az vm create `
  --name $Name `
  --resource-group $ResourceGroup `
  --location $Location `
  --image $Image `
  --size $Size `
  --vnet-name $Vnet `
  --subnet $Subnet `
  --admin-username $AdminUserName `
  --ssh-key-value $SshKeyValue
#endregion


az vm list --show-details
az network vnet show --name $Vnet
