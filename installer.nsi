; New "modern" ui, i definitely prefer old one but I am not one to judge.
!include "MUI2.nsh"



; The name of the installer
Name "NotCPUCores"

; The file to create
OutFile "NCC.exe"

; Get if user is running as admin
UserInfo::GetAccountType
Pop $0

${If} $0 = "Admin"
  ; The default installation directory
  InstallDir $PROGRAMFILES64\NotCPUCores
${Else}
  ; Install directory for non-Admins
  InstallDir $LOCALAPPDATA\NotCPUCores
${EndIf}
 

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NotCPUCores" "Install_Dir"

; Request application privileges for Windows Vista and later
RequestExecutionLevel highest

;--------------------------------

; Pages

!insertmacro MUI_PAGE_LICENSE "LICENSE.md"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English" ;sets installer language


;--------------------------------

; Things to install
Section "NotCPUCores (required)" ; required executable

SectionIn RO ; read only

; Set output path to the installation directory.
SetOutPath $INSTDIR

; Select file to be installed
File NotCPUCores.exe


; Write the installation path into the registry
; Write the uninstall keys for Windows
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NotCPUCores" "DisplayName" "NotCPUCores"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NotCPUCores" "UninstallString" '"$INSTDIR\uninstall.exe"'
WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NotCPUCores" "NoModify" 1
WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NotCPUCores" "NoRepair" 1
WriteUninstaller "uninstall.exe"

SectionEnd


; Optional section, shortcuts for now, can be used for translations in future?
Section "Start Menu shortcuts"

CreateDirectory "$SMPROGRAMS\NotCPUCores"
CreateShortcut "$SMPROGRAMS\NotCPUCores\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
CreateShortcut "$SMPROGRAMS\NotCPUCores\NotCPUCores.lnk" "$INSTDIR\NotCPUCores.exe" "" "$INSTDIR\NotCPUCores.exe" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

; Remove registry keys
DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NotCPUCores"
DeleteRegKey HKLM SOFTWARE\NotCPUCores

; Remove files and uninstaller
Delete $INSTDIR\NotCPUCores.exe
Delete $INSTDIR\uninstall.exe

; Remove shortcuts, if any
Delete "$SMPROGRAMS\NotCPUCores\*.*"

; Remove directories used
RMDir "$SMPROGRAMS\NotCPUCores"
RMDir "$INSTDIR"

SectionEnd
