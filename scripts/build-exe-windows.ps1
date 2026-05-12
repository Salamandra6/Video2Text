# Video2Text - Build portable Windows EXE folder with PyInstaller
# Run from repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\build-exe-windows.ps1

$ErrorActionPreference = "Stop"

Write-Host "== Video2Text EXE Builder ==" -ForegroundColor Cyan

if (-not (Test-Path ".venv")) {
    Write-Host "Virtual environment not found. Running setup..." -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
}

$PythonExe = Join-Path (Resolve-Path ".\.venv").Path "Scripts\python.exe"

if (-not (Test-Path $PythonExe)) {
    throw "Python executable not found inside .venv: $PythonExe"
}

Write-Host "Installing build dependencies..." -ForegroundColor Cyan
& $PythonExe -m pip install --upgrade pip setuptools wheel
& $PythonExe -m pip install -e ".[build]"

Write-Host "Cleaning previous build..." -ForegroundColor Cyan
if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }

Write-Host "Building EXE with PyInstaller..." -ForegroundColor Cyan
& $PythonExe -m PyInstaller `
    --noconfirm `
    --clean `
    --windowed `
    --name "Video2Text" `
    --collect-all customtkinter `
    --collect-all faster_whisper `
    --collect-all ctranslate2 `
    --collect-all huggingface_hub `
    --hidden-import tkinter `
    --hidden-import docx `
    --paths "src" `
    "src\video2text\desktop_app_v2.py"

Write-Host "" 
Write-Host "EXE build completed." -ForegroundColor Green
Write-Host "Portable app folder:" -ForegroundColor Green
Write-Host "  dist\Video2Text"
Write-Host "Main EXE:" -ForegroundColor Green
Write-Host "  dist\Video2Text\Video2Text.exe"
