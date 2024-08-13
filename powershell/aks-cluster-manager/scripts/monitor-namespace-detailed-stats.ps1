# Variables
# Retrieve the list of namespaces
$namespaces = kubectl get namespaces -o jsonpath="{.items[*].metadata.name}"

# Convert the space-separated string of namespaces into an array
$namespaceArray = $namespaces -split " "

# Check if there are any namespaces
if ($namespaceArray.Count -eq 0) {
    Write-Host "No namespaces found in the AKS cluster."
    exit
}

# Display the list of namespaces and ask the user to select one
Write-Host "Available namespaces:"
for ($i = 0; $i -lt $namespaceArray.Count; $i++) {
    Write-Host "$($i+1). $($namespaceArray[$i])"
}

$namespaceSelection = Read-Host "Enter the number of the namespace to select"

# Validate user input
if ($namespaceSelection -lt 1 -or $namespaceSelection -gt $namespaceArray.Count) {
    Write-Host "Invalid selection. Exiting."
    exit
}

# Set the selected namespace
$namespace = $namespaceArray[$namespaceSelection-1]

Write-Host "Selected namespace: $namespace"

# Monitor CPU and memory usage for pods in the namespace
Write-Host "CPU and Memory usage for Pods in the selected namespace:"
kubectl top pod --namespace $namespace

# Monitor CPU and memory usage for nodes in the cluster
Write-Host "CPU and Memory usage for Nodes in the cluster:"
kubectl top node

# Display resource requests and limits for all pods in the selected namespace
Write-Host "`nResource Requests and Limits for Pods in the selected namespace:"
kubectl get pods --namespace $namespace -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{range .spec.containers[*]}{.name}{'\t'}{.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\t'}{.resources.limits.cpu}{'\t'}{.resources.limits.memory}{'\n'}{end}{end}" | `
Format-Table -Property @{Name="Pod";Expression={$_[0]}}, @{Name="Container";Expression={$_[1]}}, `
@{Name="Request CPU";Expression={$_[2]}}, @{Name="Request Memory";Expression={$_[3]}}, `
@{Name="Limit CPU";Expression={$_[4]}}, @{Name="Limit Memory";Expression={$_[5]}}

# Monitor Persistent Volume usage in the selected namespace
Write-Host "`nPersistent Volume usage in the selected namespace:"
kubectl get pvc --namespace $namespace -o custom-columns="NAME:.metadata.name,STATUS:.status.phase,VOLUME:.spec.volumeName,CAPACITY:.status.capacity.storage,ACCESS MODES:.spec.accessModes,STORAGECLASS:.spec.storageClassName,AGE:.metadata.creationTimestamp"

# Display details of all pods in the selected namespace
Write-Host "`nDetailed pod status in the selected namespace:"
kubectl get pods --namespace $namespace -o wide

# Display resource quotas in the selected namespace (if any)
Write-Host "`nResource Quotas in the selected namespace (if any):"
kubectl get resourcequota --namespace $namespace -o custom-columns="NAME:.metadata.name,HARD:.spec.hard,USED:.status.used"

# Display limit ranges in the selected namespace (if any)
Write-Host "`nLimit Ranges in the selected namespace (if any):"
kubectl get limitrange --namespace $namespace -o custom-columns="NAME:.metadata.name,CPU MIN:.spec.limits[*].min.cpu,CPU MAX:.spec.limits[*].max.cpu,MEMORY MIN:.spec.limits[*].min.memory,MEMORY MAX:.spec.limits[*].max.memory"