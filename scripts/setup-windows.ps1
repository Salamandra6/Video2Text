# Video2Text - Windows local setup
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1

param(
    [string]$PythonVersion = "3.12"
)

$ErrorActionPreference = "Stop"

Write-Host "== Video2Text Windows setup ==" -ForegroundColor Cyan
Write-Host "Python target: $PythonVersion"

try {
    py -$PythonVersion --version
} catch {
    Write-Host "Python $PythonVersion was not found." -ForegroundColor Yellow
    Write-Host "Install it with: winget install Python.Python.3.12" -ForegroundColor Yellow
    throw
}

if (Test-Path ".venv") {
    Write-Host "Existing .venv found. It will be reused." -ForegroundColor Yellow
} else {
    Write-Host "Creating virtual environment..." -ForegroundColor Cyan
    py -$PythonVersion -m venv .venv
}

Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& .\.venv\Scripts\Activate.ps1

Write-Host "Upgrading pip, setuptools and wheel..." -ForegroundColor Cyan
python -m pip install --upgrade pip setuptools wheel

Write-Host "Installing Video2Text in editable mode..." -ForegroundColor Cyan
pip install -e .

Write-Host "\nSetup complete." -ForegroundColor Green
Write-Host "To activate later, run: .\.venv\Scripts\Activate.ps1"
Write-Host "Test command: video2text --help"
