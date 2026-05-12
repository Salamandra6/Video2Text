# Video2Text - Build Windows Setup installer
# Requirements on build machine:
#   - Python 3.12
#   - Inno Setup 6 installed
# Run from repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\build-installer-windows.ps1

$ErrorActionPreference = "Stop"

function Find-InnoCompiler {
    $Candidates = @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 6\ISCC.exe",
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
    )

    foreach ($Candidate in $Candidates) {
        if ($Candidate -and (Test-Path $Candidate)) {
            return $Candidate
        }
    }

    $Command = Get-Command "ISCC.exe" -ErrorAction SilentlyContinue
    if ($Command) {
        return $Command.Source
    }

    $SearchRoots = @(
        ${env:ProgramFiles(x86)},
        ${env:ProgramFiles},
        "$env:LOCALAPPDATA\Programs"
    ) | Where-Object { $_ -and (Test-Path $_) }

    foreach ($Root in $SearchRoots) {
        $Found = Get-ChildItem -Path $Root -Filter "ISCC.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($Found) {
            return $Found.FullName
        }
    }

    return $null
}

Write-Host "== Video2Text Installer Builder ==" -ForegroundColor Cyan

powershell -ExecutionPolicy Bypass -File .\scripts\build-exe-windows.ps1

$ISCC = Find-InnoCompiler

if (-not $ISCC) {
    Write-Host "Inno Setup 6 was not found or ISCC.exe could not be located." -ForegroundColor Yellow
    Write-Host "Try installing or repairing it with:" -ForegroundColor Yellow
    Write-Host "  winget install --id JRSoftware.InnoSetup --source winget" -ForegroundColor Yellow
    Write-Host "Then close PowerShell, open it again, and rerun this script." -ForegroundColor Yellow
    throw "Missing Inno Setup compiler ISCC.exe"
}

Write-Host "Using Inno Setup compiler:" -ForegroundColor Cyan
Write-Host "  $ISCC" -ForegroundColor Green

if (-not (Test-Path "installer")) {
    New-Item -ItemType Directory -Path "installer" | Out-Null
}

Write-Host "Building setup installer with Inno Setup..." -ForegroundColor Cyan
& $ISCC "packaging\video2text_installer.iss"

Write-Host "" 
Write-Host "Installer build completed." -ForegroundColor Green
Write-Host "Output:" -ForegroundColor Green
Write-Host "  installer\Video2Text-Setup.exe"
