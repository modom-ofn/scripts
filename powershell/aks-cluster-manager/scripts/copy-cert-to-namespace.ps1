# Variables
# Prompt the user for input
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

$secretName = Read-Host "Enter the name for the secret"
$certFilePath = Read-Host "Enter the full path to the certificate file (e.g., C:\path\to\your\certificate.crt)"
$keyFilePath = Read-Host "Enter the full path to the private key file (e.g., C:\path\to\your\private.key)"

# Set the Kubernetes context
kubectl config use-context $aksClusterName

# Create the secret in the specified namespace
kubectl create secret tls $secretName `
  --namespace $namespace `
  --cert=$certFilePath `
  --key=$keyFilePath

# Verify the secret has been created
kubectl get secret $secretName --namespace $namespace