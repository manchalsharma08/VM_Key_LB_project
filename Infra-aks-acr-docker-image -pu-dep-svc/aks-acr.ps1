# Set variables
$RG_NAME = "myapp1-rg"
$LOCATION = "eastus"
$ACR_NAME = "myacr$((Get-Random -Maximum 9999))"
$AKS_NAME = "myaks-cluster"
$nodeVMSize = "Standard_B2s"

Write-Host "Creating Resource Group: $RG_NAME"
az group create --name $RG_NAME --location $LOCATION

Write-Host "Creating Azure Container Registry: $ACR_NAME"
az acr create `
  --name $ACR_NAME `
  --resource-group $RG_NAME `
  --sku Basic `
  --admin-enabled true

Write-Host "Creating AKS Cluster: $AKS_NAME and attaching ACR"
az aks create `
  --resource-group $RG_NAME `
  --name $AKS_NAME `
  --node-count 2 `
  --node-vm-size $nodeVMSize `
  --generate-ssh-keys `
  --enable-managed-identity `
  --attach-acr $ACR_NAME `
  --network-plugin azure `
  --network-policy calico 

Write-Host "`n✅ AKS + ACR created successfully!"
Write-Host "🔗 ACR Login Server: $(az acr show --name $ACR_NAME --query loginServer --output tsv)"
Write-Host "🔗 AKS Cluster: $AKS_NAME in $LOCATION"
# Configure kubectl to use the new AKS cluster
az aks get-credentials --resource-group $RG_NAME --name $AKS_NAME