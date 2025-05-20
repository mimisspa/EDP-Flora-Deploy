#define MyAppName "Flora"
#define MyAppVersion "1.0"
#define MyAppPublisher "Mizpa Mae Canchela"
#define MyAppExeName "flora.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".flora"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
AppId={{B7C9A7C0-4229-44C5-8123-FA31EC9390F1}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
ChangesAssociations=yes
DisableProgramGroupPage=yes
OutputDir=C:\Users\NEC\Desktop
OutputBaseFilename=FloraInstaller
SetupIconFile=C:\Users\NEC\Pictures\flora logo.ico
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Main EXE
Source: "EDP-Flora.exe"; DestDir: "{app}"; Flags: ignoreversion

; DLL dependencies
Source: "System.Buffers.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "System.Memory.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "System.Numerics.Vectors.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "System.Threading.Tasks.Extensions.dll"; DestDir: "{app}"; Flags: ignoreversion

; MySQL Setup and DB scripts
Source: "initdb_floweryflowers.sql"; DestDir: "{app}"; Flags: ignoreversion
Source: "floweryflowersDB.sql"; DestDir: "{app}"; Flags: ignoreversion
Source: "setup_mysql.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "mysql-installer-web-community-8.0.42.0.msi"; DestDir: "{tmp}"; Flags: ignoreversion


[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\mysql-installer-web-community-8.0.42.0.msi"" /qn /norestart"; Flags: runhidden waituntilterminated
Filename: "cmd.exe"; Parameters: "/C ""{app}\setup_mysql.bat"""; Flags: runhidden waituntilterminated
Filename: "{app}\{#MyAppExeName}"; Description: "Launch Flora"; Flags: nowait postinstall skipifsilent
