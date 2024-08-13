# Script Execution Menu - PowerShell Script

![License](https://img.shields.io/github/license/modom-ofn/scripts) ![Version](https://img.shields.io/badge/version-1.0.0-blue)

## Overview

This PowerShell script provides an interactive menu that allows users to select and execute other PowerShell scripts from a specified folder. It’s designed to streamline the execution of scripts by presenting a user-friendly interface for script selection.

## Prerequisites

- **PowerShell**: Ensure that you have PowerShell installed on your system.

## Usage

1. **Run the Script**: Execute the script in a PowerShell terminal.
2. **Interactive Menu**:
   - The script will display a list of all `.ps1` scripts found in the specified folder (by default, the `scripts` folder).
   - You can select a script by entering the corresponding number.
   - To exit the menu, enter `Q` or `q`.

3. **Script Execution**:
   - Upon selection, the chosen script will be executed automatically.
   - If no scripts are found, the script will notify you that the folder is empty and return to the prompt.

## Customization

- **Scripts Folder**: By default, the script looks for other scripts in the `scripts` folder. You can change the folder by modifying the `$scriptsFolder` parameter when calling the `Show-Menu` function.

  Example:
  ```powershell
  Show-Menu -scriptsFolder "path/to/your/scripts"
  ```
- **Add New Scripts**: To add new scripts to the menu, simply place them in the designated folder.

## Error Handling
- **Invalid Selections: If an invalid selection is made (e.g., entering a non-existent number), the script will prompt you to try again and will re-display the menu.
- **No Scripts Found: If the script folder is empty, a message will be displayed, and the script will exit.

## Example
  To run the script, follow these steps:

  ```powershell
  Copy code
  .\YourScriptName.ps1
  ```
  You will be presented with a menu listing available scripts. Make your selection to execute the script.

## License

This script is provided as-is without any warranty. Modify and use it according to your needs.
