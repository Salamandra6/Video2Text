# Video2Text - Run native Windows desktop app
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\run-desktop-windows.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".venv")) {
    Write-Host "Virtual environment not found. Running setup first..." -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
}

Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& .\.venv\Scripts\Activate.ps1

Write-Host "Starting Video2Text Desktop..." -ForegroundColor Green
python -m video2text.desktop_app
