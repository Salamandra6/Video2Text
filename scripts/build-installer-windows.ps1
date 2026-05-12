# Video2Text - Build Windows Setup installer
# Requirements on build machine:
#   - Python 3.12
#   - Inno Setup 6 installed
# Run from repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\build-installer-windows.ps1

$ErrorActionPreference = "Stop"

Write-Host "== Video2Text Installer Builder ==" -ForegroundColor Cyan

powershell -ExecutionPolicy Bypass -File .\scripts\build-exe-windows.ps1

$PossibleCompilers = @(
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
)

$ISCC = $null
foreach ($Path in $PossibleCompilers) {
    if (Test-Path $Path) {
        $ISCC = $Path
        break
    }
}

if (-not $ISCC) {
    Write-Host "Inno Setup 6 was not found." -ForegroundColor Yellow
    Write-Host "Install it with:" -ForegroundColor Yellow
    Write-Host "  winget install JRSoftware.InnoSetup" -ForegroundColor Yellow
    throw "Missing Inno Setup compiler ISCC.exe"
}

if (-not (Test-Path "installer")) {
    New-Item -ItemType Directory -Path "installer" | Out-Null
}

Write-Host "Building setup installer with Inno Setup..." -ForegroundColor Cyan
& $ISCC "packaging\video2text_installer.iss"

Write-Host "" 
Write-Host "Installer build completed." -ForegroundColor Green
Write-Host "Output:" -ForegroundColor Green
Write-Host "  installer\Video2Text-Setup.exe"
