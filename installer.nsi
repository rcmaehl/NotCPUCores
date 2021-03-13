; Enable Unicode
Unicode True

; Use Modern UI
!include "MUI2.nsh"

; Determine if OS is 32 or 64 bit
!include "x64.nsh"

; Use If/IfNot/Else/EndIf
!include "LogicLib.nsh"


; GLobal variables
!define PRODUCT_NAME "NotCPUCores"
!define PRODUCT_VERSION "1.7.2.1"
!define INSTALLER_NAME "NCC"
!define UNINSTALLER_NAME "uninstall"

; Enable debugging (Set 1 to debug and 0 for production)
!define DEBUGGING_ENABLED 0


; The name of the installer
Name "${PRODUCT_NAME} (${PRODUCT_VERSION})"

; The file to create
OutFile "${INSTALLER_NAME}.exe"


; Registry key to check for directory (this means if the program is already
; installed, it automatically uses the same install directory)
;InstallDirRegKey HKLM "Software\${PRODUCT_NAME}" InstallLocation

; Request to run application as admin
; If there would be an option for normal users it seems things could get
; complicated:
; - A request for admin rights some time after the start does not seem easily
;   possible
; - The admin state would need to be chcked at many points to not manipulate the
;   registry and co which could also be challenging when allowing the user to
;   select a directory since the rights to write must be verified or the error
;   catched (this is also a problem regarding the uninstaller at that point)
RequestExecutionLevel admin


; Run on initialization of the installer
Function .onInit
  ${If} ${DEBUGGING_ENABLED} == 1
    MessageBox MB_OK "Initial install directory: $INSTDIR"
  ${EndIf}

  ; Try to read the installation location from the registry
  ReadRegStr $0 HKLM "Software\${PRODUCT_NAME}" "Path"
  StrCpy $INSTDIR "$0"

  ${If} ${DEBUGGING_ENABLED} == 1
    MessageBox MB_OK "Install directory after reading the registry: $INSTDIR"
  ${EndIf}

  ; Determine the default install location based on the arch of the PC
  ${If} $INSTDIR == ""
    ${If} ${RunningX64}
      StrCpy $INSTDIR "$PROGRAMFILES64\${PRODUCT_NAME}"
    ${Else}
      StrCpy $INSTDIR "$PROGRAMFILES32\${PRODUCT_NAME}"
    ${EndIf}
    ${If} ${DEBUGGING_ENABLED} == 1
      MessageBox MB_OK "Set install directory using the arch of the system: $INSTDIR"
    ${EndIf}
  ${Else}
    ${If} ${DEBUGGING_ENABLED} == 1
      MessageBox MB_OK "Existing install directory found in registry: $INSTDIR"
    ${EndIf}
  ${EndIf}
FunctionEnd


;--------------------------------

; Set installer icon
!define MUI_ICON "Assets\icon.ico"

; Pages [Installer]

!insertmacro MUI_PAGE_LICENSE "LICENSE.md"
!insertmacro MUI_PAGE_COMPONENTS

; Possible save dialog to ask for installation location
;Page Custom AskForInstallationType
;Function AskForInstallationType
;  MessageBox MB_YESNO "Install in user directory (no admin rights necessary)?" IDYES true IDNO false
;  true:
;    StrCpy $INSTDIR "$LOCALAPPDATA\${PRODUCT_NAME}"
;  false:
;    ; See above at RequestExecutionLevel for more info about why this is not
;    ; an easy problem to solve
;FunctionEnd

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Pages [Uninstaller]

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set installer language
!insertmacro MUI_LANGUAGE "English"

;--------------------------------

; Things to install
Section "${PRODUCT_NAME} (required)" ; required executable

SectionIn RO ; read only

; Set output path to the installation directory.
SetOutPath $INSTDIR
${If} ${DEBUGGING_ENABLED} == 1
  MessageBox MB_OK "Install directory for ${PRODUCT_NAME} (required): $INSTDIR"
${EndIf}

; Select file to be installed
${If} ${RunningX64}
  File "/oname=${PRODUCT_NAME}.exe" ${PRODUCT_NAME}.exe
  ${If} ${DEBUGGING_ENABLED} == 1
    MessageBox MB_OK "File that is used: ${PRODUCT_NAME}.exe"
  ${EndIf}
${Else}
  File "/oname=${PRODUCT_NAME}.exe" ${PRODUCT_NAME}_x86.exe
  ${If} ${DEBUGGING_ENABLED} == 1
    MessageBox MB_OK "File that is used: ${PRODUCT_NAME}_x86.exe"
  ${EndIf}
${EndIf}

; Copy icon for start menu shortcut
File "/oname=${PRODUCT_NAME}.ico" Assets\icon.ico

; Write the installation path into the registry
; Write the uninstall keys for Windows
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" '"$INSTDIR\${UNINSTALLER_NAME}.exe"'
WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoModify" 1
WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoRepair" 1
WriteUninstaller "${UNINSTALLER_NAME}.exe"

SectionEnd


; Optional section, shortcuts for now, can be used for translations in future?
Section "Start Menu shortcuts"

; Solution with directory
CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
CreateShortcut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\${PRODUCT_NAME}.ico" 0
; A link to the uninstaller is not necessary but provided for ease of use
CreateShortcut "$SMPROGRAMS\${PRODUCT_NAME}\${UNINSTALLER_NAME}.lnk" "$INSTDIR\${UNINSTALLER_NAME}.exe" "" "$INSTDIR\${UNINSTALLER_NAME}.exe" 0

; Solution with direct link to program (don't forget to remove this file in
; the uninstaller when using this solution)
;CreateShortcut "$SMPROGRAMS\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\${PRODUCT_NAME}.ico" 0

SectionEnd


; After installation success
Function .onInstSuccess

; Update the installer path in the registry so that this path can be recognized
; when an updated installer is executed
WriteRegStr HKLM "Software\${PRODUCT_NAME}" "Path" "$INSTDIR"

FunctionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

; Remove registry keys
DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
DeleteRegKey HKLM "SOFTWARE\${PRODUCT_NAME}"

; Remove files and uninstaller
Delete $INSTDIR\${PRODUCT_NAME}.exe
Delete $INSTDIR\${PRODUCT_NAME}.ico
Delete $INSTDIR\${UNINSTALLER_NAME}.exe

; Remove shortcuts, if there are any
Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
;Delete "$SMPROGRAMS\${PRODUCT_NAME}.lnk"

; Remove directories used
RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
RMDir "$INSTDIR"

SectionEnd
