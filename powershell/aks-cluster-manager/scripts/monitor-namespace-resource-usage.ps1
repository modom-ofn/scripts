# Requires kubectl to be installed and configured to access the AKS cluster.

# Function to Display Resource Quotas for the Selected Namespace
function Show-ResourceQuota {
    param([string]$namespace)

    $resourceQuota = kubectl get resourcequota --namespace $namespace -o json
    if ($resourceQuota -ne $null -and $resourceQuota -ne "") {
        Write-Host "`nResource Quotas for namespace '$namespace':" -ForegroundColor Cyan
        $quotas = ($resourceQuota | ConvertFrom-Json).items
        foreach ($quota in $quotas) {
            Write-Host "Name: $($quota.metadata.name)"
            Write-Host "Hard Limits:"
            $quota.status.hard.GetEnumerator() | ForEach-Object {
                Write-Host "  $($_.Key): $($_.Value)"
            }
            Write-Host "Used:"
            $quota.status.used.GetEnumerator() | ForEach-Object {
                Write-Host "  $($_.Key): $($_.Value)"
            }
            Write-Host ""
        }
    } else {
        Write-Host "No Resource Quotas set for namespace '$namespace'." -ForegroundColor Yellow
    }
}

# Function to Display Detailed Pod Resource Usage
function Show-PodDetails {
    param([string]$namespace)

    Write-Host "`nFetching pod details for namespace '$namespace'..." -ForegroundColor Cyan
    $pods = kubectl get pods --namespace $namespace -o json | ConvertFrom-Json

    $podData = @()

    foreach ($pod in $pods.items) {
        foreach ($container in $pod.spec.containers) {
            $podName = $pod.metadata.name
            $containerName = $container.name
            $cpuRequest = $container.resources.requests.cpu
            $memRequest = $container.resources.requests.memory
            $cpuLimit = $container.resources.limits.cpu
            $memLimit = $container.resources.limits.memory

            $podData += [PSCustomObject]@{
                PodName       = $podName
                ContainerName = $containerName
                CPURequest    = $cpuRequest
                MemoryRequest = $memRequest
                CPULimit      = $cpuLimit
                MemoryLimit   = $memLimit
            }
        }
    }

    $podData | Format-Table -AutoSize

    # Option to export data to CSV
    $exportChoice = Read-Host "`nDo you want to export pod details to CSV? (y/n)"
    if ($exportChoice -eq 'y') {
        $csvPath = Read-Host "Enter the full path for the CSV file (e.g., C:\pod_details.csv)"
        try {
            $podData | Export-Csv -Path $csvPath -NoTypeInformation
            Write-Host "Pod details exported successfully to $csvPath" -ForegroundColor Green
        } catch {
            Write-Host "Failed to export data. $_" -ForegroundColor Red
        }
    }
}

# Function for Real-time Monitoring
function RealTime-Monitoring {
    param([string]$namespace)

    Write-Host "`nStarting real-time monitoring for namespace '$namespace'..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop."

    try {
        while ($true) {
            Clear-Host
            Write-Host "Timestamp: $(Get-Date)" -ForegroundColor Yellow
            Write-Host "`nPod Resource Usage:" -ForegroundColor Cyan
            kubectl top pod --namespace $namespace

            Write-Host "`nNode Resource Usage:" -ForegroundColor Cyan
            kubectl top node

            Start-Sleep -Seconds 10  # Refresh interval
        }
    } catch [System.Exception] {
        Write-Host "`nReal-time monitoring stopped." -ForegroundColor Green
    }
}

# Main Script Execution

# Retrieve the list of namespaces
$namespaces = kubectl get namespaces -o jsonpath="{.items[*].metadata.name}"

# Convert the space-separated string of namespaces into an array
$namespaceArray = $namespaces -split " "

# Check if there are any namespaces
if ($namespaceArray.Count -eq 0) {
    Write-Host "No namespaces found in the AKS cluster." -ForegroundColor Red
    exit
}

# Display the list of namespaces and ask the user to select one
Write-Host "Available namespaces:" -ForegroundColor Cyan
for ($i = 0; $i -lt $namespaceArray.Count; $i++) {
    Write-Host "$($i+1). $($namespaceArray[$i])"
}

$namespaceSelection = Read-Host "`nEnter the number of the namespace to select"

# Validate user input
if ($namespaceSelection -lt 1 -or $namespaceSelection -gt $namespaceArray.Count) {
    Write-Host "Invalid selection. Exiting." -ForegroundColor Red
    exit
}

# Set the selected namespace
$namespace = $namespaceArray[$namespaceSelection-1]

Write-Host "`nSelected namespace: $namespace" -ForegroundColor Green

# Display Resource Quotas
Show-ResourceQuota -namespace $namespace

# Display Detailed Pod Information
Show-PodDetails -namespace $namespace

# Start Real-time Monitoring
$monitorChoice = Read-Host "`nDo you want to start real-time monitoring? (y/n)"
if ($monitorChoice -eq 'y') {
    RealTime-Monitoring -namespace $namespace
} else {
    Write-Host "Monitoring skipped. Exiting script." -ForegroundColor Yellow
}