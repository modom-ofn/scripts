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

# Retrieve the list of pods in the selected namespace
$pods = kubectl get pods --namespace $namespace -o jsonpath="{.items[*].metadata.name}"

# Convert the space-separated string of pods into an array
$podArray = $pods -split " "

# Check if there are any pods
if ($podArray.Count -eq 0) {
    Write-Host "No pods found in the selected namespace."
    exit
}

# Display the list of pods and ask the user to select one
Write-Host "Available pods:"
for ($i = 0; $i -lt $podArray.Count; $i++) {
    Write-Host "$($i+1). $($podArray[$i])"
}

$podSelection = Read-Host "Enter the number of the pod to select"

# Validate user input
if ($podSelection -lt 1 -or $podSelection -gt $podArray.Count) {
    Write-Host "Invalid selection. Exiting."
    exit
}

# Set the selected pod name
$podName = $podArray[$podSelection-1]

Write-Host "Selected pod: $podName"

# View logs
kubectl logs $podName --namespace $namespace