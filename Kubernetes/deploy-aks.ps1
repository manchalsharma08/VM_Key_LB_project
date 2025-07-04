# deploy-aks.ps1
# --------------------------------------------
# This script creates a Resource Group and AKS Cluster in Azure using Azure CLI.
# Make sure you are logged into Azure using `az login` before running.

# Set variables
$resourceGroupName = "mymeerg01"
$location = "eastus"
$aksClusterName = "mymeeaks"
$nodeCount = 2
$nodeVMSize = "Standard_B2s"

# Create the Resource Group
az group create `
  --name $resourceGroupName `
  --location $location

# Create the AKS Cluster
az aks create `
  --resource-group $resourceGroupName `
  --name $aksClusterName `
  --node-count $nodeCount `
  --node-vm-size $nodeVMSize `
  --generate-ssh-keys `
  --enable-managed-identity `
  --network-plugin azure `
  --network-policy calico


  # After the AKS cluster is created, you can configure kubectl to use the new cluster
az aks get-credentials `
  --resource-group $resourceGroupName `
  --name $aksClusterName       

 # Set the cluster subscription
az account set --subscription 3a734e32-021d-4243-89ff-c3495e6aa4da
# Get credentials for the AKS cluster
az aks get-credentials --resource-group mymeerg01 --name mymeeaks --overwrite-existing

