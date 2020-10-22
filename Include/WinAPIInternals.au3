#include-once

#include "AutoItConstants.au3"
#include "FileConstants.au3"
#include "MsgBoxConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIxxx.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_vEnum, $__g_vExt = 0
Global $__g_iRGBMode = 1
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'

; Image Type Constants
Global Const $IMAGE_BITMAP = 0
Global Const $IMAGE_ICON = 1
Global Const $IMAGE_CURSOR = 2
Global Const $IMAGE_ENHMETAFILE = 3

; _WinAPI_LoadImage(), _WinAPI_CopyImage()
Global Const $LR_DEFAULTCOLOR = 0x0000
Global Const $LR_MONOCHROME = 0x0001
Global Const $LR_COLOR = 0x0002
Global Const $LR_COPYRETURNORG = 0x0004
Global Const $LR_COPYDELETEORG = 0x0008
Global Const $LR_LOADFROMFILE = 0x0010
Global Const $LR_LOADTRANSPARENT = 0x0020
Global Const $LR_DEFAULTSIZE = 0x0040
Global Const $LR_VGACOLOR = 0x0080
Global Const $LR_LOADMAP3DCOLORS = 0x1000
Global Const $LR_CREATEDIBSECTION = 0x2000
Global Const $LR_COPYFROMRESOURCE = 0x4000
Global Const $LR_SHARED = 0x8000

Global Const $__tagCURSORINFO = "dword Size;dword Flags;handle hCursor;" & "struct;long X;long Y;endstruct" ; $tagPOINT
Global Const $__WINVER = __WINVER()
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
;
; Doc in WinAPIDlg
; _WinAPI_GetDlgCtrlID
;
; Doc in WinAPIFiles
; _WinAPI_CreateFile
; _WinAPI_PathIsDirectory
; _WinAPI_ReadFile
; _WinAPI_WriteFile
;
; Doc in WinAPIGdi
; _WinAPI_SwitchColor
;
; Doc in WinAPIMisc
; _WinAPI_GetString
; _WinAPI_StrLen
;
; Doc in WinAPIProc
; _WinAPI_IsWow64Process
;
; Doc in WinAPIRes
; _WinAPI_FreeLibrary
; _WinAPI_GetCursorInfo
; _WinAPI_LoadImage
; _WinAPI_LoadLibrary
;
; Doc in WinAPISys
; _WinAPI_GetModuleHandle
;
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $__tagCURSORINFO
; __CheckErrorArrayBounds
; __CheckErrorCloseHandle
; __DLL
; __EnumWindowsProc
; __FatalExit
; __Inc
; __RGB
; __WINVER()
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateFile($sFileName, $iCreation, $iAccess = 4, $iShare = 0, $iAttributes = 0, $tSecurity = 0)
	Local $iDA = 0, $iSM = 0, $iCD = 0, $iFA = 0

	If BitAND($iAccess, 1) <> 0 Then $iDA = BitOR($iDA, $GENERIC_EXECUTE)
	If BitAND($iAccess, 2) <> 0 Then $iDA = BitOR($iDA, $GENERIC_READ)
	If BitAND($iAccess, 4) <> 0 Then $iDA = BitOR($iDA, $GENERIC_WRITE)

	If BitAND($iShare, 1) <> 0 Then $iSM = BitOR($iSM, $FILE_SHARE_DELETE)
	If BitAND($iShare, 2) <> 0 Then $iSM = BitOR($iSM, $FILE_SHARE_READ)
	If BitAND($iShare, 4) <> 0 Then $iSM = BitOR($iSM, $FILE_SHARE_WRITE)

	Switch $iCreation
		Case 0
			$iCD = $CREATE_NEW
		Case 1
			$iCD = $CREATE_ALWAYS
		Case 2
			$iCD = $OPEN_EXISTING
		Case 3
			$iCD = $OPEN_ALWAYS
		Case 4
			$iCD = $TRUNCATE_EXISTING
	EndSwitch

	If BitAND($iAttributes, 1) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_ARCHIVE)
	If BitAND($iAttributes, 2) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_HIDDEN)
	If BitAND($iAttributes, 4) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_READONLY)
	If BitAND($iAttributes, 8) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_SYSTEM)

	Local $aResult = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sFileName, "dword", $iDA, "dword", $iSM, _
			"struct*", $tSecurity, "dword", $iCD, "dword", $iFA, "ptr", 0)
	If @error Or ($aResult[0] = Ptr(-1)) Then Return SetError(@error, @extended, 0) ; $INVALID_HANDLE_VALUE

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FreeLibrary($hModule)
	Local $aResult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FreeLibrary

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetCursorInfo()
	Local $tCursor = DllStructCreate($__tagCURSORINFO)
	Local $iCursor = DllStructGetSize($tCursor)
	DllStructSetData($tCursor, "Size", $iCursor)
	Local $aRet = DllCall("user32.dll", "bool", "GetCursorInfo", "struct*", $tCursor)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aCursor[5]
	$aCursor[0] = True
	$aCursor[1] = DllStructGetData($tCursor, "Flags") <> 0
	$aCursor[2] = DllStructGetData($tCursor, "hCursor")
	$aCursor[3] = DllStructGetData($tCursor, "X")
	$aCursor[4] = DllStructGetData($tCursor, "Y")
	Return $aCursor
EndFunc   ;==>_WinAPI_GetCursorInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDlgCtrlID($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDlgCtrlID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetModuleHandle($sModuleName)
	Local $sModuleNameType = "wstr"
	If $sModuleName = "" Then
		$sModuleName = 0
		$sModuleNameType = "ptr"
	EndIf

	Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetModuleHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetString($pString, $bUnicode = True)
	Local $iLength = _WinAPI_StrLen($pString, $bUnicode)
	If @error Or Not $iLength Then Return SetError(@error + 10, @extended, '')

	Local $tString = DllStructCreate(($bUnicode ? 'wchar' : 'char') & '[' & ($iLength + 1) & ']', $pString)
	If @error Then Return SetError(@error, @extended, '')

	Return SetExtended($iLength, DllStructGetData($tString, 1))
EndFunc   ;==>_WinAPI_GetString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsWow64Process($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', ($__WINVER < 0x0600 ? 0x00000400 : 0x00001000), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, False)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsWow64Process', 'handle', $hProcess[0], 'bool*', 0)
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, False)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_IsWow64Process

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadImage($hInstance, $sImage, $iType, $iXDesired, $iYDesired, $iLoad)
	Local $aResult, $sImageType = "int"
	If IsString($sImage) Then $sImageType = "wstr"
	$aResult = DllCall("user32.dll", "handle", "LoadImageW", "handle", $hInstance, $sImageType, $sImage, "uint", $iType, _
			"int", $iXDesired, "int", $iYDesired, "uint", $iLoad)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadLibrary($sFileName)
	Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryW", "wstr", $sFileName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadLibrary

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsDirectory($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsDirectoryW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsDirectory

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ReadFile($hFile, $pBuffer, $iToRead, ByRef $iRead, $tOverlapped = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToRead, _
			"dword*", 0, "struct*", $tOverlapped)
	If @error Then Return SetError(@error, @extended, False)

	$iRead = $aResult[4]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReadFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_StrLen($pString, $bUnicode = True)
	Local $W = ''
	If $bUnicode Then $W = 'W'

	Local $aRet = DllCall('kernel32.dll', 'int', 'lstrlen' & $W, 'struct*', $pString)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_StrLen

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_SwitchColor($iColor)
	If $iColor = -1 Then Return $iColor
	Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
EndFunc   ;==>_WinAPI_SwitchColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WriteFile($hFile, $pBuffer, $iToWrite, ByRef $iWritten, $tOverlapped = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToWrite, _
			"dword*", 0, "struct*", $tOverlapped)
	If @error Then Return SetError(@error, @extended, False)

	$iWritten = $aResult[4]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_WriteFile

#EndRegion Public Functions

#Region Internal Functions

Func __CheckErrorArrayBounds(Const ByRef $aData, ByRef $iStart, ByRef $iEnd, $nDim = 1, $iDim = $UBOUND_DIMENSIONS)
	; Bounds checking
	If Not IsArray($aData) Then Return SetError(1, 0, 1)
	If UBound($aData, $iDim) <> $nDim Then Return SetError(2, 0, 1)

	If $iStart < 0 Then $iStart = 0

	Local $iUBound = UBound($aData) - 1
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound

	If $iStart > $iEnd Then Return SetError(4, 0, 1)

	Return 0
EndFunc   ;==>__CheckErrorArrayBounds

Func __CheckErrorCloseHandle($aRet, $hFile, $bLastError = False, $iCurErr = @error, $iCurExt = @extended)
	If Not $iCurErr And Not $aRet[0] Then $iCurErr = 10
	Local $aLastError = DllCall("kernel32.dll", "dword", "GetLastError") ; _WinAPI_GetLastError()
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
	If $iCurErr Then DllCall("kernel32.dll", "none", "SetLastError", "dword", $aLastError[0]) ; _WinAPI_SetLastError($iLastError)
	If $bLastError Then $iCurExt = $aLastError[0]
	Return SetError($iCurErr, $iCurExt, $iCurErr)
EndFunc   ;==>__CheckErrorCloseHandle

Func __DLL($sPath, $bPin = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetModuleHandleExW', 'dword', ($bPin ? 0x0001 : 0x0002), "wstr", $sPath, 'ptr*', 0)
	If Not $aRet[3] Then
		Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryW", "wstr", $sPath)
		If Not $aResult[0] Then Return 0
	EndIf
	Return 1
EndFunc   ;==>__DLL

Func __EnumWindowsProc($hWnd, $bVisible)
	Local $aResult
	If $bVisible Then
		$aResult = DllCall("user32.dll", "bool", "IsWindowVisible", "hwnd", $hWnd)
		If Not $aResult[0] Then
			Return 1
		EndIf
	EndIf
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0][0]][0] = $hWnd
	$aResult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	$__g_vEnum[$__g_vEnum[0][0]][1] = $aResult[2]
	Return 1
EndFunc   ;==>__EnumWindowsProc

Func __FatalExit($iCode, $sText = '')
	If $sText Then MsgBox($MB_SYSTEMMODAL, 'AutoIt', $sText)
	DllCall('kernel32.dll', 'none', 'FatalExit', 'int', $iCode) ; _WinAPI_FatalExit($iCode)
EndFunc   ;==>__FatalExit

Func __Inc(ByRef $aData, $iIncrement = 100)
	Select
		Case UBound($aData, $UBOUND_COLUMNS)
			If $iIncrement < 0 Then
				ReDim $aData[$aData[0][0] + 1][UBound($aData, $UBOUND_COLUMNS)]
			Else
				$aData[0][0] += 1
				If $aData[0][0] > UBound($aData) - 1 Then
					ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, $UBOUND_COLUMNS)]
				EndIf
			EndIf
		Case UBound($aData, $UBOUND_ROWS)
			If $iIncrement < 0 Then
				ReDim $aData[$aData[0] + 1]
			Else
				$aData[0] += 1
				If $aData[0] > UBound($aData) - 1 Then
					ReDim $aData[$aData[0] + $iIncrement]
				EndIf
			EndIf
		Case Else
			Return 0
	EndSelect
	Return 1
EndFunc   ;==>__Inc

Func __RGB($iColor)
	If $__g_iRGBMode Then
		$iColor = _WinAPI_SwitchColor($iColor)
	EndIf
	Return $iColor
EndFunc   ;==>__RGB

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WINVER
; Description ...: Retrieves version of the current operating system
; Syntax.........: __WINVER ( )
; Parameters ....: none
; Return values .: Returns the binary version of the current OS.
;                            0x0603 - Windows 8.1
;                            0x0602 - Windows 8 / Windows Server 2012
;                            0x0601 - Windows 7 / Windows Server 2008 R2
;                            0x0600 - Windows Vista / Windows Server 2008
;                            0x0502 - Windows XP 64-Bit Edition / Windows Server 2003 / Windows Server 2003 R2
;                            0x0501 - Windows XP
; Author ........: Yashield
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __WINVER()
	Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
	DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc   ;==>__WINVER

#EndRegion Internal Functions
