# Variables
# Retrieve the list of node pools
$nodePools = az aks nodepool list `
  --resource-group $resourceGroupName `
  --cluster-name $aksClusterName `
  --query "[].{Name:name}" `
  --output tsv

# Check if there are any node pools
if ($nodePools.Count -eq 0) {
    Write-Host "No node pools found in the specified AKS cluster."
    exit
}

# Display the list of node pools and ask the user to select one
Write-Host "Available node pools:"
for ($i = 0; $i -lt $nodePools.Count; $i++) {
    Write-Host "$($i+1). $($nodePools[$i])"
}

$selection = Read-Host "Enter the number of the node pool to select"

# Validate user input
if ($selection -lt 1 -or $selection -gt $nodePools.Count) {
    Write-Host "Invalid selection. Exiting."
    exit
}

# Set the selected node pool name
$nodePoolName = $nodePools[$selection-1]

Write-Host "Selected node pool: $nodePoolName"

# Retrieve the current node count for the selected node pool
$currentNodeCount = az aks nodepool show `
  --resource-group $resourceGroupName `
  --cluster-name $aksClusterName `
  --name $nodePoolName `
  --query "count" `
  --output tsv

Write-Host "Current node count for node pool '$nodePoolName': $currentNodeCount"

$newNodeCount = Read-Host "Enter the new desired number of nodes"

# Scale the node pool
az aks nodepool scale `
  --resource-group $resourceGroupName `
  --cluster-name $aksClusterName `
  --name $nodePoolName `
  --node-count $newNodeCount

# Verify the scale operation
kubectl get nodes