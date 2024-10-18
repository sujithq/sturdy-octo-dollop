# function Install-Gateway([string] $gwPath)
# {
#     # uninstall any existing gateway
#     UnInstall-Gateway
#     Write-Host "Start Microsoft Integration Runtime installation"
#     $process = Start-Process "msiexec.exe" "/i $gwPath /quiet /passive" -Wait -PassThru
#     if ($process.ExitCode -ne 0)
#     {
#         throw "Failed to install Microsoft Integration Runtime. msiexec exit code: $($process.ExitCode)"
#     }
#     Start-Sleep -Seconds 30
#     Write-Host "Succeed to install Microsoft Integration Runtime"
# }

function Register-Gateway()
{
    $cmd = Get-CmdFilePath

    if (![string]::IsNullOrEmpty($env:adf_port))
    {
        Write-Host "Start to enable remote access."
        $process = Start-Process $cmd "-era $env:adf_port $env:adf_cert" -Wait -PassThru -NoNewWindow
        if ($process.ExitCode -ne 0)
        {
            throw "Failed to enable remote access. Exit code: $($process.ExitCode)"
        }
        Write-Host "Succeed to enable remote access."
    }

    Write-Host "Start to register Microsoft Integration Runtime with key: $env:adf_key."
    $process = Start-Process $cmd "-k $env:adf_key" -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -ne 0)
    {
        throw "Failed to register Microsoft Integration Runtime. Exit code: $($process.ExitCode)"
    }
    Write-Host "Succeed to register Microsoft Integration Runtime."
}

function Get-CmdFilePath()
{
    $filePath = Get-ItemPropertyValue "hklm:\Software\Microsoft\DataTransfer\DataManagementGateway\ConfigurationManager" "DiacmdPath"
    if ([string]::IsNullOrEmpty($filePath))
    {
        throw "Get-InstalledFilePath: Cannot find installed File Path"
    }

    return (Split-Path -Parent $filePath) + "\dmgcmd.exe"
}

# function Validate-Input([string]$path, [string]$env:adf_key)
# {
#     if ([string]::IsNullOrEmpty($path))
#     {
#         throw "Microsoft Integration Runtime path is not specified"
#     }
#     if (!(Test-Path -Path $path))
#     {
#         throw "Invalid Microsoft Integration Runtime path: $path"
#     }
#     if ([string]::IsNullOrEmpty($env:adf_key))
#     {
#         throw "Microsoft Integration Runtime Auth key is empty"
#     }
# }

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

# Validate-Input
# Install-Gateway
Register-Gateway