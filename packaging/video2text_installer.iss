; Video2Text Windows Installer Script
; Requires Inno Setup 6 installed on the build machine.

#define MyAppName "Video2Text"
#define MyAppVersion "0.1.0"
#define MyAppPublisher "Video2Text"
#define MyAppExeName "Video2Text.exe"

[Setup]
AppId={{7F1C2B78-8F0B-4E38-BD98-VIDEO2TEXT001}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..\installer
OutputBaseFilename=Video2Text-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Crear acceso directo en el escritorio"; GroupDescription: "Accesos directos:"; Flags: unchecked

[Files]
Source: "..\dist\Video2Text\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Video2Text"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\Video2Text"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Abrir Video2Text"; Flags: nowait postinstall skipifsilent
