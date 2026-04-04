Write-Host "Starting Declarative Windows 11 Provisioning..." -ForegroundColor Green

# 1. Ensure Winget is working
$wingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $wingetPath) {
    Write-Warning "Winget not found. Ensure the Windows Store is updated."
    exit
}

# 2. Define packages
$packages = @(
    "Mozilla.Firefox"
    "Git.Git"
    "Valve.Steam"
)

# 3. Install packages (Winget is naturally idempotent, but we suppress errors if already installed)
foreach ($pkg in $packages) {
    Write-Host "Checking $pkg..."
    # Winget skips installation if the package is already present
    & $wingetPath install --id $pkg -e --accept-package-agreements --accept-source-agreements
}

# 4. Idempotent Looking Glass Setup
Write-Host "Checking Looking Glass Host status..." -ForegroundColor Cyan

# Check if the Looking Glass executable already exists
$lgInstallPath = "C:\Program Files\Looking Glass (Host)\looking-glass-host.exe"

if (Test-Path $lgInstallPath) {
    Write-Host "Looking Glass is already installed. Skipping." -ForegroundColor DarkGray
} else {
    Write-Host "Looking Glass missing. Downloading and installing..." -ForegroundColor Yellow

    $lgSetupPath = "$env:TEMP\looking-glass-host-setup.exe"
    $lgUrl = "https://looking-glass.io/artifact/stable/host"

    Invoke-WebRequest -Uri $lgUrl -OutFile $lgSetupPath

    Write-Host "Executing silent installation..."
    Start-Process -FilePath $lgSetupPath -ArgumentList "/S" -Wait -NoNewWindow

    Remove-Item -Path $lgSetupPath -Force
    Write-Host "Looking Glass successfully installed!" -ForegroundColor Green
}

Write-Host "Provisioning Complete!" -ForegroundColor Green
