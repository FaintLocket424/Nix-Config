# 1. Check for Administrative Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit
}

Write-Host "Starting Declarative Windows 11 Provisioning..." -ForegroundColor Green

# Function to clear desktop shortcuts (Winget/Installers often ignore --no-shortcut)
function Clear-DesktopShortcuts {
    $paths = @(
        [Environment]::GetFolderPath("CommonDesktopDirectory"),
        [Environment]::GetFolderPath("Desktop")
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            Get-ChildItem -Path $path -Filter "*.lnk" | Remove-Item -Force
        }
    }
}

# 2. Install Packages via Winget
# Nvidia.Driver.Display will install the latest drivers for the 1080 Ti
$packages = @(
    "Mozilla.Firefox",
    "Git.Git",
    "Valve.Steam",
    "TechPowerUp.NVCleanstall"
    "AppWork.JDownloader"
    "LizardByte.Sunshine"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..." -ForegroundColor Cyan
    winget install --id $pkg -e --silent --accept-package-agreements --accept-source-agreements
    Clear-DesktopShortcuts
}

# 3. Run Win11Debloat (Fix: Download and run locally)
Write-Host "Downloading and running Win11Debloat..." -ForegroundColor Magenta
$debloatZip = "$env:TEMP\Win11Debloat.zip"
$debloatDir = "$env:TEMP\Win11Debloat-master"
$url = "https://github.com/Raphire/Win11Debloat/archive/refs/heads/master.zip"

Invoke-WebRequest -Uri $url -OutFile $debloatZip
Expand-Archive -Path $debloatZip -DestinationPath $env:TEMP -Force

# Execute the local script with default parameters
# Parameters: -Silent, -RemoveApps, -DisableTelemetry, -DisableBing
$debloatScriptPath = "$debloatDir\Win11Debloat.ps1"
if (Test-Path $debloatScriptPath) {
    & $debloatScriptPath -Silent -RemoveApps -DisableTelemetry -DisableBing -DisableWidgets -ClearStartAllUsers -DisableGameBarIntegration -DisableDVR -RemoveCommApps -RemoveW11Outlook -EnableDarkMode -TaskbarAlignLeft -PreventUpdateAutoReboot -DisableStickyKeys -RevertContextMenu -DisableEdgeAI -DisablePaintAI -DisableNotepadAI
    & $debloatScriptPath -Silent -RemoveApps -Apps "Microsoft.OneDrive"
}

# Cleanup Debloat files
Remove-Item $debloatZip -Force
Remove-Item $debloatDir -Recurse -Force

# 4. Robust Activation Check
Write-Host "Checking Windows activation status..." -ForegroundColor Cyan

# We query for Windows products that have a partial product key (the ones actually installed)
$licenseStatus = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "PartialProductKey IS NOT NULL AND Name LIKE '%Windows%'").LicenseStatus

# Status 1 = Licensed (Activated)
if ($licenseStatus -contains 1) {
    Write-Host "Windows is already activated. Skipping MAS." -ForegroundColor DarkGray
} else {
    Write-Host "Windows is not activated (Status: $licenseStatus). Running MAS HWID Activation..." -ForegroundColor Yellow
    $masUri = "https://get.activated.win"
    $masScript = Invoke-RestMethod -Uri $masUri
    & ([scriptblock]::Create($masScript)) /HWID
}

# 5. Looking Glass Host Setup
Write-Host "Checking Looking Glass Host status..." -ForegroundColor Cyan
$lgInstallPath = "C:\Program Files\Looking Glass (Host)\looking-glass-host.exe"

if (Test-Path $lgInstallPath) {
    Write-Host "Looking Glass is already installed. Skipping." -ForegroundColor DarkGray
} else {
    Write-Host "Looking Glass missing. Downloading..." -ForegroundColor Yellow
    $lgZip = "$env:TEMP\lg-host.zip"
    $lgExtract = "$env:TEMP\lg-host"
    Invoke-WebRequest -Uri "https://looking-glass.io/artifact/stable/host" -OutFile $lgZip

    Expand-Archive -Path $lgZip -DestinationPath $lgExtract -Force
    $installer = Get-ChildItem -Path $lgExtract -Recurse -Filter "looking-glass-host-setup.exe" | Select-Object -First 1

    if ($installer) {
        Write-Host "Installing Looking Glass..."
        Start-Process -FilePath $installer.FullName -ArgumentList "/S" -Wait
    }

    Remove-Item $lgZip -Force
    Remove-Item $lgExtract -Recurse -Force
}

Write-Host "Checking for Custom Fonts in Shared Drive..." -ForegroundColor Cyan
$fontSource = "Z:\fonts"

if (Test-Path $fontSource) {
    $fonts = Get-ChildItem -Path $fontSource -Filter "*.ttf"

    if ($fonts.Count -gt 0) {
        # Initialize the Windows Shell COM Object
        $shellApp = New-Object -ComObject Shell.Application
        # 0x14 is the magic hex code for the System Fonts directory
        $windowsFonts = $shellApp.Namespace(0x14)

        foreach ($font in $fonts) {
            $fontDest = Join-Path "C:\Windows\Fonts" $font.Name

            # Only install if the font isn't already in the Windows Font folder
            if (-not (Test-Path $fontDest)) {
                Write-Host "Installing Font: $($font.Name)..." -ForegroundColor Yellow
                # CopyHere automatically extracts the font name and adds the Registry keys!
                $windowsFonts.CopyHere($font.FullName)
            } else {
                Write-Host "Font already installed: $($font.Name)" -ForegroundColor DarkGray
            }
        }
    } else {
        Write-Host "No .ttf fonts found in Z:\fonts." -ForegroundColor DarkGray
    }
}

# Final cleanup
Clear-DesktopShortcuts
Write-Host "Provisioning Complete! A restart is highly recommended." -ForegroundColor Green
