#include-once

; #INDEX# =======================================================================================================================
; Title .........: MsgBox_Constants
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Constants to be included in an AutoIt v3 script when using function MsgBox.
; Author(s) .....: guinness, jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; Message Box Constants
; Indicates the buttons displayed in the message box
Global Const $MB_OK = 0 ; One push button: OK
Global Const $MB_OKCANCEL = 1 ; Two push buttons: OK and Cancel
Global Const $MB_ABORTRETRYIGNORE = 2 ; Three push buttons: Abort, Retry, and Ignore
Global Const $MB_YESNOCANCEL = 3 ; Three push buttons: Yes, No, and Cancel
Global Const $MB_YESNO = 4 ; Two push buttons: Yes and No
Global Const $MB_RETRYCANCEL = 5 ; Two push buttons: Retry and Cancel
Global Const $MB_CANCELTRYCONTINUE = 6 ; Three buttons: Cancel, Try Again and Continue
Global Const $MB_HELP = 0x4000 ; Adds a Help button to the message box. When the user clicks the Help button or presses F1, the system sends a WM_HELP message to the owner.

; Displays an icon in the message box
Global Const $MB_ICONSTOP = 16 ; Stop-sign icon
Global Const $MB_ICONERROR = 16 ; Stop-sign icon
Global Const $MB_ICONHAND = 16 ; Stop-sign icon
Global Const $MB_ICONQUESTION = 32 ; Question-mark icon
Global Const $MB_ICONEXCLAMATION = 48 ; Exclamation-point icon
Global Const $MB_ICONWARNING = 48 ; Exclamation-point icon
Global Const $MB_ICONINFORMATION = 64 ; Icon consisting of an 'i' in a circle
Global Const $MB_ICONASTERISK = 64 ; Icon consisting of an 'i' in a circle
Global Const $MB_USERICON = 0x00000080

; Indicates the default button
Global Const $MB_DEFBUTTON1 = 0 ; The first button is the default button
Global Const $MB_DEFBUTTON2 = 256 ; The second button is the default button
Global Const $MB_DEFBUTTON3 = 512 ; The third button is the default button
Global Const $MB_DEFBUTTON4 = 768 ; The fourth button is the default button.

; Indicates the modality of the dialog box
Global Const $MB_APPLMODAL = 0 ; Application modal
Global Const $MB_SYSTEMMODAL = 4096 ; System modal
Global Const $MB_TASKMODAL = 8192 ; Task modal

; Indicates miscellaneous message box attributes
Global Const $MB_DEFAULT_DESKTOP_ONLY = 0x00020000 ; Same as desktop of the interactive window station
Global Const $MB_RIGHT = 0x00080000 ; The text is right-justified.
Global Const $MB_RTLREADING = 0x00100000 ; Displays message and caption text using right-to-left reading order on Hebrew and Arabic systems.
Global Const $MB_SETFOREGROUND = 0x00010000 ; The message box becomes the foreground window
Global Const $MB_TOPMOST = 0x00040000 ; The message box is created with the WS_EX_TOPMOST window style.
Global Const $MB_SERVICE_NOTIFICATION = 0x00200000 ; The caller is a service notifying the user of an event.

Global Const $MB_RIGHTJUSTIFIED = $MB_RIGHT ; Do not use, see $MB_RIGHT. Included for backwards compatibility.

; Indicates the button selected in the message box
Global Const $IDTIMEOUT = -1 ; The message box timed out
Global Const $IDOK = 1 ; OK button was selected
Global Const $IDCANCEL = 2 ; Cancel button was selected
Global Const $IDABORT = 3 ; Abort button was selected
Global Const $IDRETRY = 4 ; Retry button was selected
Global Const $IDIGNORE = 5 ; Ignore button was selected
Global Const $IDYES = 6 ; Yes button was selected
Global Const $IDNO = 7 ; No button was selected
Global Const $IDCLOSE = 8 ; Close button was selected
Global Const $IDHELP = 9 ; Help button was selected
Global Const $IDTRYAGAIN = 10 ; Try Again button was selected
Global Const $IDCONTINUE = 11 ; Continue button was selected
; ===============================================================================================================================
