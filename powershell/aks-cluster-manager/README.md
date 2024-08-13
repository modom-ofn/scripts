# AKS Cluster Management Script

![License](https://img.shields.io/github/license/modom-ofn/scripts) ![Version](https://img.shields.io/badge/version-1.0.0-blue)

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

## Currently Available Scripts

1. **Scale AKS Node Pool**:
   - This script allows you to scale the number of nodes in a specific node pool within your AKS cluster.
2. **List All Pods in a Namespace**:
   - This script lists all the pods in a specified namespace, along with their statuses.
3. **View Logs for a Specific Pod**:
   - This script fetches and displays logs from a specific pod within a namespace.
4. **Get Cluster Info**:
   - This script provides detailed information about your AKS cluster, including node status, services, and other resources.
5. **Deploy a YAML File to a Namespace**:
   - This script allows you to deploy a Kubernetes resource (e.g., deployment, service) from a YAML file to a specific namespace.
6. **Delete Resources in a Namespace**:
   - This script deletes all resources (e.g., pods, services) within a specified namespace.
7. **Upgrade AKS Cluster**:
   - This script helps upgrade the AKS cluster to a specified Kubernetes version.
8. **Backup and Restore Kubernetes Configurations**:
   - These scripts help you back up and restore Kubernetes configurations, such as ConfigMaps and Secrets.
9. **Monitor Resource Usage in a Namespace**:
   - This script uses kubectl top to monitor CPU and memory usage for pods and nodes.
10. **Create a New Namespace**:
   - This script creates a new namespace in your AKS cluster..

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
