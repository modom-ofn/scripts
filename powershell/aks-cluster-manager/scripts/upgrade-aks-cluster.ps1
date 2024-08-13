# Variables
$k8sVersion = Read-Host "Enter the desired Kubernetes version (e.g., 1.23.5)"

# Upgrade the AKS cluster
az aks upgrade `
  --resource-group $resourceGroupName `
  --name $aksClusterName `
  --kubernetes-version $k8sVersion `
  --no-wait

# Verify the upgrade
az aks show --resource-group $resourceGroupName --name $aksClusterName --output table