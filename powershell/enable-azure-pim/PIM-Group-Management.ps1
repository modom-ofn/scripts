# Log in to Azure using Azure CLI
az login

# Function to list PIM groups and their activation status
function List-PIMGroups {
    Write-Host "Fetching PIM groups..." -ForegroundColor Yellow
    $pimGroups = az ad group list --query "[?securityEnabled==true].{Name:displayName, ObjectId:id}" -o json | ConvertFrom-Json

    foreach ($group in $pimGroups) {
        $status = az role assignment list --assignee $group.ObjectId --query "[].{Role:roleDefinitionName, Status:condition}" -o tsv
        $isActivated = if ($status) { "Activated" } else { "Not Activated" }
        Write-Host "$($group.Name) - Status: $isActivated"
    }
}

# Function to activate a PIM group
function Enable-PIMGroup {
    param (
        [string]$groupName
    )

    $group = az ad group list --filter "displayName eq '$groupName'" --query "[].{Name:displayName, ObjectId:id}" -o json | ConvertFrom-Json

    if ($group) {
        Write-Host "Activating PIM group: $($group.Name)" -ForegroundColor Green
        az role assignment create --assignee $group.ObjectId --role "Privileged Role Administrator"
        Write-Host "PIM group $($group.Name) has been activated."
    } else {
        Write-Host "Group not found. Please ensure the group name is correct." -ForegroundColor Red
    }
}

# Main script loop
do {
    Clear-Host
    List-PIMGroups
    $choice = Read-Host "Enter the name of the PIM group to activate (or type 'exit' to quit):"

    if ($choice -ne "exit") {
        Enable-PIMGroup -groupName $choice
        Write-Host "Returning to the PIM group list..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
    }

} while ($choice -ne "exit")

Write-Host "Script execution completed. Exiting..." -ForegroundColor Cyan
