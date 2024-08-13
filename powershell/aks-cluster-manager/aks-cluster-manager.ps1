# Variables
# Prompt the user for input
$subscriptionId = Read-Host "Enter the Azure Subscription ID"
$resourceGroupName = Read-Host "Enter the Azure Resource Group"
$aksClusterName = Read-Host "Enter the AKS Cluster Name"
$scriptsFolderPath = "./scripts"

# Log in to Azure
az login

# Set the correct subscription (if needed)
az account set --subscription $subscriptionId

# Get AKS credentials for kubectl
az aks get-credentials `
  --resource-group $resourceGroupName `
  --name $aksClusterName

# Try to execute 'kubectl get nodes'
try {
    $nodes = kubectl get nodes -ErrorAction Stop
    Write-Host "Connected to AKS Cluster successfully."
    Write-Host $nodes

    # Function to display the menu and execute selected script
    function Show-Menu {
        param (
            [string]$scriptsFolder
        )

        # Get all script files in the folder
        $scriptFiles = Get-ChildItem -Path $scriptsFolder -Filter *.ps1

        if ($scriptFiles.Count -eq 0) {
            Write-Host "No scripts found in the $scriptsFolder folder."
            return
        }

        # Display the menu
        Write-Host "Please select a script to run:"
        for ($i = 0; $i -lt $scriptFiles.Count; $i++) {
            $scriptName = $scriptFiles[$i].Name
            Write-Host "$($i+1). $scriptName"
        }
        Write-Host "0. Exit"

        # Get user input
        $choice = Read-Host "Enter the number of the script to run"

        # Handle user input
        if ($choice -eq 0) {
            Write-Host "Exiting."
            return
        } elseif ($choice -gt 0 -and $choice -le $scriptFiles.Count) {
            $selectedScript = $scriptFiles[$choice-1].FullName
            Write-Host "Running script: $selectedScript"
            & $selectedScript
        } else {
            Write-Host "Invalid choice. Please try again."
            Show-Menu -scriptsFolder $scriptsFolder
        }
    }

    # Display the interactive menu
    Show-Menu -scriptsFolder $scriptsFolderPath
}
catch {
    Write-Host "Failed to connect to the AKS Cluster."
    Write-Host "Error details:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
