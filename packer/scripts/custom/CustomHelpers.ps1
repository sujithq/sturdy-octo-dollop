<#
.SYNOPSIS
    This script contains custom helper functions for various tasks.

.DESCRIPTION
    The CustomHelpers.ps1 script includes a collection of custom helper functions that can be used to perform various tasks. These functions are designed to simplify common operations and improve code reusability.    

.PARAMETER <ParameterName>
    Description of the parameter.

.EXAMPLE
    Example of how to use a function from this script.

    PS> .\CustomHelpers.ps1
    PS> <FunctionName> -Parameter <Value>

.NOTES
    Author: Sujith Quintelier
    Version: 0.0.1
#>

function Setup-Host {
    <#
    .SYNOPSIS
        Configures the host environment by logging into Azure and setting the specified subscription.

    .DESCRIPTION
        The Setup-Host function logs into Azure using a managed identity and sets the active subscription to the provided Azure subscription ID.
        This function ensures the environment is correctly set up for further Azure operations.

    .PARAMETER az_sub_id
        The Azure subscription ID to set as the active subscription for the current session.

    .EXAMPLE
        Setup-Host -az_sub_id "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        Logs into Azure using managed identity and sets the specified subscription ID.

    .OUTPUTS
        The function displays account details after setting the subscription.

    .NOTES
        - This function requires Azure CLI (`az` command) to be installed.
        - The user must be authenticated with managed identity to access the specified Azure subscription.
        - Ensure the managed identity has sufficient permissions on the subscription.

    #>    
    param (
        [string]$az_sub_id
    )

    Write-Host "Setup-Host - Start"

    # Log in using managed identity
    Write-Host "Login using managed identity"
    az login --identity

    # Set Azure subscription
    Write-Host "Set Azure subscription to $az_sub_id"
    az account set -s $az_sub_id

    # Show account details
    Write-Host "Show account details"
    az account show

    Write-Host "Setup-Host - Done"

}

function Download-File {
    <#
    .SYNOPSIS
        Downloads a file from an Azure Storage container.

    .DESCRIPTION
        The Download-File function downloads a specified file from a given Azure Storage account and container.
        The file is downloaded to a specified local directory path.

    .PARAMETER storage_account_name
        The name of the Azure Storage account from which the file will be downloaded.

    .PARAMETER containerName
        The name of the Azure Storage container where the file is located.

    .PARAMETER fileName
        The name of the file to be downloaded from the Azure Storage container.

    .PARAMETER image_folder
        The local directory path where the downloaded file will be saved.

    .EXAMPLE
        Download-File -storage_account_name "myStorageAccount" -containerName "myContainer" -fileName "installer.msi" -image_folder "C:\Downloads"
        Downloads the "installer.msi" file from the "myContainer" container in "myStorageAccount" storage account to "C:\Downloads" directory.

    .OUTPUTS
        None. The function downloads a file to the specified directory path.

    .NOTES
        - This function uses the Azure CLI (`az` command) to download files from an Azure Storage blob.
        - Ensure that the Azure CLI is authenticated and has the necessary permissions to access the storage account and container.
        - The `--auth-mode login` flag requires the user to be authenticated with the Azure CLI.

    #>
    param (
        [string]$storage_account_name,
        [string]$containerName,
        [string]$fileName,
        [string]$image_folder
    )

    Write-Host "Download-File - Start"

    # Define local variables
    $msiPath = "$image_folder/$fileName"
    
    # Download MSI package from Azure Storage
    Write-Host "Downloading file $fileName from storage account $storage_account_name and container $containerName"
    az storage blob download --account-name $storage_account_name --container-name $containerName --name $fileName --file "$msiPath" --auth-mode login

    Write-Host "Download-File - Done"
    
}

function Get-Secret {

    <#
    .SYNOPSIS
        Retrieves a secret from Azure Key Vault.

    .DESCRIPTION
        The Get-Secret function connects to Azure Key Vault and retrieves the value of a specified secret. 
        This can be used to fetch sensitive information like passwords, API keys, or connection strings that are stored in Azure Key Vault.

    .PARAMETER vault_name
        The name of the Azure Key Vault from which the secret is to be retrieved.

    .PARAMETER secret_name
        The name of the secret to retrieve from the specified Azure Key Vault.

    .EXAMPLE
        Get-Secret -vault_name "MyKeyVault" -secret_name "DatabasePassword"
        Retrieves the secret named 'DatabasePassword' from the Key Vault named 'MyKeyVault' and returns its value.

    .OUTPUTS
        The value of the retrieved secret as a string.

    .NOTES
        - This function requires the `az` CLI to be installed and authenticated with the necessary permissions to access the Azure Key Vault.
        - The `az keyvault secret show` command is used to retrieve the secret.
        - Ensure that the vault and secret names are correct and the user running this script has permission to access the vault.

    #>    
    param (
        [string]$vault_name,
        [string]$secret_name
    )

    Write-Host "Get-Secret - Start"

    # Get secret from Azure Key Vault
    Write-Host "Getting secret ($secret_name) from Azure Key Vault ($vault_name)"
    $secret = az keyvault secret show --name $secret_name --vault-name $vault_name --query value -o tsv

    Write-Host "Get-Secret - Done"
    # Return secret
    return $secret
    
}
