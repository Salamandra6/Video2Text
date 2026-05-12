# Video2Text - Create a Windows desktop shortcut
# Run from the repository root after setup:
#   powershell -ExecutionPolicy Bypass -File .\scripts\install-desktop-shortcut-windows.ps1

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path ".").Path
$Launcher = Join-Path $RepoRoot "scripts\run-desktop-windows.ps1"

if (-not (Test-Path $Launcher)) {
    throw "Launcher not found: $Launcher"
}

$Desktop = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $Desktop "Video2Text Desktop.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$Launcher`""
$Shortcut.WorkingDirectory = $RepoRoot
$Shortcut.IconLocation = "powershell.exe,0"
$Shortcut.Description = "Open Video2Text Desktop"
$Shortcut.Save()

Write-Host "Shortcut created: $ShortcutPath" -ForegroundColor Green
