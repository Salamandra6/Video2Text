# Video2Text - Run native Windows desktop app
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\run-desktop-windows.ps1

$ErrorActionPreference = "Stop"

try {
    if (-not (Test-Path ".venv")) {
        Write-Host "Virtual environment not found. Running setup first..." -ForegroundColor Yellow
        powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
    }

    $PythonExe = Join-Path (Resolve-Path ".\.venv").Path "Scripts\python.exe"

    if (-not (Test-Path $PythonExe)) {
        throw "Python executable not found inside .venv: $PythonExe"
    }

    Write-Host "Installing/updating local package dependencies..." -ForegroundColor Cyan
    & $PythonExe -m pip install --upgrade pip setuptools wheel
    & $PythonExe -m pip install -e .

    Write-Host "Starting Video2Text Desktop..." -ForegroundColor Green
    & $PythonExe -m video2text.desktop_app_v2

    if ($LASTEXITCODE -ne 0) {
        throw "Video2Text Desktop exited with code $LASTEXITCODE"
    }
}
catch {
    Write-Host "" 
    Write-Host "Video2Text Desktop failed to start." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "" 
    Write-Host "Press ENTER to close this window..." -ForegroundColor Yellow
    Read-Host | Out-Null
    exit 1
}
