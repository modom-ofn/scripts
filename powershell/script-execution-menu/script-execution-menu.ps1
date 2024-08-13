# Function to display the interactive menu
function Show-Menu {
    param (
        [string]$scriptsFolder = "scripts"
    )

    # Get all the script files in the folder
    $scripts = Get-ChildItem -Path $scriptsFolder -Filter *.ps1

    # Check if there are any scripts available
    if ($scripts.Count -eq 0) {
        Write-Host "No scripts found in the '$scriptsFolder' folder."
        return
    }

    # Display the menu
    Write-Host "Select a script to run:"
    for ($i = 0; $i -lt $scripts.Count; $i++) {
        Write-Host "$($i + 1). $($scripts[$i].Name)"
    }
    Write-Host "Q. Quit"

    # Get user input
    $selection = Read-Host "Enter your selection"

    # Handle the selection
    switch ($selection) {
        { $_ -eq 'Q' -or $_ -eq 'q' } {
            Write-Host "Exiting..."
            return
        }
        { $_ -match '^\d+$' -and $_ -le $scripts.Count -and $_ -ge 1 } {
            $selectedScript = $scripts[$selection - 1].FullName
            Write-Host "Running script: $($scripts[$selection - 1].Name)"
            & $selectedScript
        }
        default {
            Write-Host "Invalid selection. Please try again."
            Show-Menu -scriptsFolder $scriptsFolder
        }
    }
}

# Run the interactive menu
Show-Menu