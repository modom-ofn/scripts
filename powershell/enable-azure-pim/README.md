# Azure PIM Group Management Script

This PowerShell script allows you to log in to Azure, list all available Privileged Identity Management (PIM) groups, view their activation status, and activate groups as needed. The script continuously loops, providing you with the option to enable other PIM groups or exit the script.

## Prerequisites

Before running the script, ensure you have the following:

- **Azure CLI**: Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) on your local machine.
- **Azure Permissions**: You need appropriate permissions to list and manage PIM groups in your Azure environment.

## Script Features

- **Log in to Azure**: Uses Azure CLI for secure authentication.
- **List PIM Groups**: Displays all PIM groups with their current activation status (Activated or Not Activated).
- **Activate PIM Groups**: Provides an interactive prompt to enable PIM groups.
- **Looping Functionality**: After activating a group, you can choose to activate another or exit the script.

## Usage

1. Clone this repository or download the script to your local machine.
2. Open a PowerShell terminal.
3. Run the script:

    ```powershell
    .\PIM-Group-Management.ps1
    ```

4. Follow the on-screen instructions:

    - The script will list all available PIM groups and their activation statuses.
    - You'll be prompted to enter the name of the PIM group you wish to activate.
    - After activating a group, you can choose to activate another or exit the script.

## Example Output

```plaintext
Fetching PIM groups...
Group1 - Status: Not Activated
Group2 - Status: Activated
Group3 - Status: Not Activated

Enter the name of the PIM group to activate (or type 'exit' to quit): Group1
Activating PIM group: Group1
PIM group Group1 has been activated.
Returning to the PIM group list...

Fetching PIM groups...
Group1 - Status: Activated
Group2 - Status: Activated
Group3 - Status: Not Activated

Enter the name of the PIM group to activate (or type 'exit' to quit): exit
Script execution completed. Exiting...
```

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This script is provided as-is without any warranty. Modify and use it according to your needs.