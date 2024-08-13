# AKS Cluster Management Script

## Overview

This script is designed to simplify the management of an Azure Kubernetes Service (AKS) cluster by allowing users to connect to the cluster and execute custom PowerShell scripts from a specified folder. The script performs the following tasks:

1. Prompts the user to input necessary Azure and AKS details.
2. Logs into Azure and sets the appropriate subscription.
3. Retrieves AKS credentials for use with `kubectl`.
4. Provides an interactive menu to execute scripts located in a designated folder.

## Prerequisites

- **Azure CLI**: The script uses the `az` command-line tool to interact with Azure. Ensure that the Azure CLI is installed and properly configured.
- **kubectl**: The script assumes that `kubectl` is installed and available in your system's PATH.
- **PowerShell**: This script should be run in a PowerShell environment.

## Usage

1. **Run the Script**: Execute the script in a PowerShell terminal.
2. **Input Prompts**:
   - You will be prompted to enter the Azure Subscription ID, the Resource Group Name where your AKS cluster resides, and the AKS Cluster Name itself.
   - These inputs are necessary for logging into Azure and retrieving the correct AKS credentials.
3. **Azure Login**:
   - The script will log into your Azure account and set the active subscription based on the provided Subscription ID.
4. **Connect to AKS**:
   - The script retrieves the credentials for the AKS cluster and attempts to connect by executing the `kubectl get nodes` command.
   - If successful, it displays the nodes in the cluster.
5. **Script Execution Menu**:
   - After successfully connecting to the AKS cluster, the script presents an interactive menu of PowerShell scripts located in the `./scripts` folder.
   - You can select a script to run by entering the corresponding number.
   - If no scripts are found, or if an invalid selection is made, the script will handle these scenarios gracefully.

## Customization

- **Scripts Folder**: By default, the script looks for PowerShell scripts in the `./scripts` folder relative to where the script is run. You can change the path by modifying the `$scriptsFolderPath` variable.
  
- **Adding Scripts**: To add new scripts for execution, simply place them in the `./scripts` folder, and they will automatically appear in the interactive menu.

## Error Handling

- If the script fails to connect to the AKS cluster, it will catch the error and display a message indicating the failure along with the error details.

## Example

To run the script, follow these steps:

```powershell
.\aks-cluster-manager.ps1
```

After entering the required details, you will see an interactive menu allowing you to select and run scripts.

## License

This script is provided as-is without any warranty. Modify and use it according to your needs.
