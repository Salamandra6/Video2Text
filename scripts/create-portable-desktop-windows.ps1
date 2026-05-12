# Video2Text - Create portable app folder directly on Windows Desktop
# Run from repository root:
#   powershell -ExecutionPolicy Bypass -File .\scripts\create-portable-desktop-windows.ps1

$ErrorActionPreference = "Stop"

Write-Host "== Video2Text Portable Desktop Creator ==" -ForegroundColor Cyan

$Desktop = [Environment]::GetFolderPath("Desktop")
$PortableDest = Join-Path $Desktop "Video2Text-Portable"
$SourceFolder = Join-Path (Resolve-Path ".").Path "dist\Video2Text"
$SourceExe = Join-Path $SourceFolder "Video2Text.exe"

if (-not (Test-Path $SourceExe)) {
    Write-Host "Portable EXE was not found. Building it first..." -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File .\scripts\build-exe-windows.ps1
}

if (-not (Test-Path $SourceExe)) {
    throw "Could not find built EXE at: $SourceExe"
}

if (Test-Path $PortableDest) {
    Write-Host "Removing previous portable folder from Desktop..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $PortableDest
}

Write-Host "Copying portable app to Desktop..." -ForegroundColor Cyan
Copy-Item -Recurse -Force $SourceFolder $PortableDest

$PortableExe = Join-Path $PortableDest "Video2Text.exe"
$ShortcutPath = Join-Path $Desktop "Video2Text Portable.lnk"

Write-Host "Creating desktop shortcut..." -ForegroundColor Cyan
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $PortableExe
$Shortcut.WorkingDirectory = $PortableDest
$Shortcut.IconLocation = $PortableExe
$Shortcut.Description = "Open Video2Text Portable"
$Shortcut.Save()

Write-Host "" 
Write-Host "Portable app created successfully." -ForegroundColor Green
Write-Host "Folder:" -ForegroundColor Green
Write-Host "  $PortableDest"
Write-Host "EXE:" -ForegroundColor Green
Write-Host "  $PortableExe"
Write-Host "Shortcut:" -ForegroundColor Green
Write-Host "  $ShortcutPath"
