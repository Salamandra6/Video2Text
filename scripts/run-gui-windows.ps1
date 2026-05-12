# Video2Text - Run local graphical interface
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\run-gui-windows.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".venv")) {
    Write-Host "Virtual environment not found. Running setup first..." -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
}

Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& .\.venv\Scripts\Activate.ps1

Write-Host "Starting Video2Text GUI..." -ForegroundColor Green
Write-Host "If the browser does not open automatically, go to: http://localhost:8501" -ForegroundColor Yellow

streamlit run src\video2text\gui.py
