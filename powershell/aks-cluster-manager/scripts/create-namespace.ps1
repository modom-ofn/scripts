# Variables
$namespace = Read-Host "Enter the new Kubernetes namespace name"

# Create the namespace
kubectl create namespace $namespace

# Verify the namespace creation
kubectl get namespaces