# deploy-aks.ps1
# --------------------------------------------
# This script creates a Resource Group and AKS Cluster in Azure using Azure CLI.
# Make sure you are logged into Azure using `az login` before running.

# Set variables
# Variables
$resourceGroupName = "mymeerg01"
$location = "eastus"
$aksClusterName = "mymeeaks"
$nodeCount = 2
$nodeVMSize = "Standard_B2s"
$ACR_NAME = "mymeeacr01"
$acrSku = "Basic"

# Create Resource Group
az group create `
  --name $resourceGroupName `
  --location $location

# Check if resource group creation was successful
if ($LASTEXITCODE -eq 0) {
  
  # Create ACR
  az acr create `
    --resource-group $resourceGroupName `
    --name $ACR_NAME `
    --sku $acrSku `
    --location $location `
    --admin-enabled false

  # Check if ACR creation was successful
  if ($LASTEXITCODE -eq 0) {

    # Create AKS and attach ACR
    az aks create `
      --resource-group $resourceGroupName `
      --name $aksClusterName `
      --node-count $nodeCount `
      --node-vm-size $nodeVMSize `
      --generate-ssh-keys `
      --enable-managed-identity `
      --network-plugin azure `
      --network-policy calico `
      --attach-acr $ACR_NAME
  }
}



#   # After the AKS cluster is created, you can configure kubectl to use the new cluster
# az aks get-credentials `
#   --resource-group $resourceGroupName `
#   --name $aksClusterName       

#  # Set the cluster subscription
# az account set --subscription 3a734e32-021d-4243-89ff-c3495e6aa4da
# # Get credentials for the AKS cluster
# az aks get-credentials --resource-group mymeerg01 --name mymeeaks --overwrite-existing


