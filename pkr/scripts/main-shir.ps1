<#
.SYNOPSIS
    Automates the downloading and installation of required binaries for a host environment setup.

.DESCRIPTION
    This script configures the environment by:
    - Setting up the Azure subscription using managed identity.
    - Downloading required binaries from predefined URLs or Azure Storage.
    - Installing the binaries using specified arguments and logging the installation process.

    The script uses external functions sourced from `Utils.ps1`, and processes both `.exe` and `.msi` files. For each binary, the script either downloads it from Azure Storage or a provided URL, then installs it with specified arguments.

.PARAMETER AZ_SUB_ID
    The Azure subscription ID used to set up the environment.

.PARAMETER STORAGE_ACCOUNT_NAME
    The name of the Azure Storage account used for downloading binaries.

.PARAMETER IMAGE_FOLDER
    The local directory path where files are stored and logs are saved.

.PARAMETER CONTAINER_NAME
    The name of the Azure Storage container from which files may be downloaded.

.EXAMPLE
    # Example to run the script:
    $env:AZ_SUB_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    $env:STORAGE_ACCOUNT_NAME = "mystorageaccount"
    $env:IMAGE_FOLDER = "C:/temp/packer"
    $env:CONTAINER_NAME = "mycontainer"
    .\main-script.ps1

    This will configure the environment and handle the downloading and installation of binaries specified in the script.

.NOTES
    - The script requires Azure CLI to be installed and configured for managed identity login.
    - The files to be downloaded and installed are defined in the `$files` hash table.
#>

# Define local variables
$az_sub_id = $env:AZ_SUB_ID
$storage_account_name = $env:STORAGE_ACCOUNT_NAME
$image_folder = $env:IMAGE_FOLDER
$containerName = $env:CONTAINER_NAME
$key_vault_name = $env:KEY_VAULT_NAME

Write-Host "Main script - Start"

Import-Module CustomHelpers

Write-Host "Setup Host for $az_sub_id"
Setup-Host -az_sub_id $az_sub_id

$scanner = "WindowsSensor.LionLanner.exe"

$CID = get-secret -vault_name $key_vault_name -secret_name "crowd-CID"

# Define file names and their url and installArgs or extraInstallArgs
$files = [ordered]@{
    "$scanner" = @{downloadFromStorage = $true; installArgs = @("/install", "/quiet", "/norestart", "/log", "$image_folder/$scanner.log", "CID=$CID", "NO_START=1") }
    "shir" = @{Url = "https://www.microsoft.com/EN-US/DOWNLOAD/confirmation.aspx?id=39717"; installArgs = @("/i", "/quiet", "/passive", "/log", "$image_folder/shir.log") }
}

# Loop through each file name and call Download-File
foreach ($fileName in $files.Keys) {
    $fileData = $files[$fileName]
    $Url = $fileData.url
    $downloadFromStorage = $fileData.downloadFromStorage
    if (-not $Url -and $downloadFromStorage -eq $true) {
        Write-Host "Downloading $fileName"
        Download-File -storage_account_name $storage_account_name -containerName $containerName -image_folder $image_folder -fileName $fileName
    }
}

# Loop through each file name and call Install-Binary
foreach ($fileName in $files.Keys) {
    Write-Host "Installing $fileName"

    $extension = [System.IO.Path]::GetExtension($fileName)

    $fileData = $files[$fileName]
    $Url = $fileData.url
    $installArgs = $fileData.installArgs
    $extraInstallArgs = $fileData.extraInstallArgs
    
    $type = "MSI"

    if ($extension -eq ".exe") {
        $type = "EXE"
    }

    $logFile = "$image_folder/$fileName.log"

    if ($Url) {
        if ($installArgs) {
            Install-Binary -Url "$Url" -Type $type -InstallArgs $installArgs
        }
        else {
            Install-Binary -Url "$Url" -Type $type -InstallArgs $extraInstallArgs
        }
    }
    else {
        if ($installArgs) {
            Install-Binary -LocalPath "$image_folder/$fileName" -Type $type -InstallArgs $installArgs
        }
        else {
            Install-Binary -LocalPath "$image_folder/$fileName" -Type $type -ExtraInstallArgs $extraInstallArgs
        }
    }
}

Write-Host "Main script - Done"