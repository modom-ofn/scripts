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

$yamlFilePath = Read-Host "Enter the full path to the YAML file (e.g., C:\path\to\your\resource.yaml)"

# Deploy the resource
kubectl apply -f $yamlFilePath --namespace $namespace

# Verify the deployment
kubectl get all --namespace $namespace