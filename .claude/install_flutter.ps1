$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$installDir = 'C:\Users\user\flutter'
$zipPath = 'C:\Users\user\flutter_sdk.zip'
$url = 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.27.4-stable.zip'

if (Test-Path "$installDir\bin\flutter.bat") {
    Write-Host "ALREADY_INSTALLED"
    exit 0
}

Write-Host "Downloading Flutter SDK..."
try {
    Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
    $size = (Get-Item $zipPath).Length
    Write-Host "DOWNLOADED: $size bytes"
} catch {
    Write-Host "DOWNLOAD_ERROR: $($_.Exception.Message)"
    exit 1
}

Write-Host "Extracting Flutter SDK..."
try {
    Expand-Archive -Path $zipPath -DestinationPath 'C:\Users\user\' -Force
    Write-Host "EXTRACTED"
} catch {
    Write-Host "EXTRACT_ERROR: $($_.Exception.Message)"
    exit 1
}

if (Test-Path "$installDir\bin\flutter.bat") {
    Write-Host "INSTALLED_OK"
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "INSTALL_VERIFY_FAILED"
    exit 1
}
