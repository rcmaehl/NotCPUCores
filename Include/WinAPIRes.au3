#include-once

#include "APILocaleConstants.au3"
#include "APIResConstants.au3"
#include "WinAPIConv.au3"
#include "WinAPIError.au3"
#include "WinAPIIcons.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIRes.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_vVal
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagVS_FIXEDFILEINFO = 'dword Signature;dword StrucVersion;dword FileVersionMS;dword FileVersionLS;dword ProductVersionMS;dword ProductVersionLS;dword FileFlagsMask;dword FileFlags;dword FileOS;dword FileType;dword FileSubtype;dword FileDateMS;dword FileDateLS'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_BeginUpdateResource
; _WinAPI_ClipCursor
; _WinAPI_CopyCursor
; _WinAPI_CreateCaret
; _WinAPI_DestroyCaret
; _WinAPI_DestroyCursor
; _WinAPI_EndUpdateResource
; _WinAPI_EnumResourceLanguages
; _WinAPI_EnumResourceNames
; _WinAPI_EnumResourceTypes
; _WinAPI_FindResource
; _WinAPI_FindResourceEx
; _WinAPI_FreeResource
; _WinAPI_GetCaretBlinkTime
; _WinAPI_GetCaretPos
; _WinAPI_GetClipCursor
; _WinAPI_GetCursor
; _WinAPI_GetFileVersionInfo
; _WinAPI_HideCaret
; _WinAPI_LoadBitmap
; _WinAPI_LoadCursor
; _WinAPI_LoadCursorFromFile
; _WinAPI_LoadIndirectString
; _WinAPI_LoadString
; _WinAPI_LoadLibraryEx
; _WinAPI_LoadResource
; _WinAPI_LoadStringEx
; _WinAPI_LockResource
; _WinAPI_SetCaretBlinkTime
; _WinAPI_SetCaretPos
; _WinAPI_SetCursor
; _WinAPI_SetSystemCursor
; _WinAPI_ShowCaret
; _WinAPI_ShowCursor
; _WinAPI_SizeOfResource
; _WinAPI_UpdateResource
; _WinAPI_VerQueryRoot
; _WinAPI_VerQueryValue
; _WinAPI_VerQueryValueEx
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BeginUpdateResource($sFilePath, $bDelete = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'BeginUpdateResourceW', 'wstr', $sFilePath, 'bool', $bDelete)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginUpdateResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ClipCursor($tRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'ClipCursor', 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ClipCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CopyCursor($hCursor)
	Return _WinAPI_CopyIcon($hCursor)
EndFunc   ;==>_WinAPI_CopyCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateCaret($hWnd, $hBitmap, $iWidth = 0, $iHeight = 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'CreateCaret', 'hwnd', $hWnd, 'handle', $hBitmap, 'int', $iWidth, 'int', $iHeight)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateCaret

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DestroyCaret()
	Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCaret')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DestroyCaret

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DestroyCursor($hCursor)
	Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCursor', 'handle', $hCursor)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DestroyCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_EndUpdateResource($hUpdate, $bDiscard = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EndUpdateResourceW', 'handle', $hUpdate, 'bool', $bDiscard)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EndUpdateResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumResourceLanguages($hModule, $sType, $sName)
	Local $iLibrary = 0, $sTypeOfType = 'int', $sTypeOfName = 'int'

	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf
	Dim $__g_vEnum[101] = [0]
	Local $hEnumProc = DllCallbackRegister('__EnumResLanguagesProc', 'bool', 'handle;ptr;ptr;word;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceLanguagesW', 'handle', $hModule, $sTypeOfType, $sType, _
			$sTypeOfName, $sName, 'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumResourceLanguages

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumResourceNames($hModule, $sType)
	Local $aRet, $hEnumProc, $iLibrary = 0, $sTypeOfType = 'int'

	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	Dim $__g_vEnum[101] = [0]
	$hEnumProc = DllCallbackRegister('__EnumResNamesProc', 'bool', 'handle;ptr;ptr;long_ptr')
	$aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceNamesW', 'handle', $hModule, $sTypeOfType, $sType, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or (Not $__g_vEnum[0]) Then
		$__g_vEnum = @error + 10
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumResourceNames

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumResourceTypes($hModule)
	Local $iLibrary = 0
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	Dim $__g_vEnum[101] = [0]
	Local $hEnumProc = DllCallbackRegister('__EnumResTypesProc', 'bool', 'handle;ptr;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceTypesW', 'handle', $hModule, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or (Not $__g_vEnum[0]) Then
		$__g_vEnum = @error + 10
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumResourceTypes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindResource($hInstance, $sType, $sName)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hInstance, $sTypeOfName, $sName, $sTypeOfType, $sType)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceExW', 'handle', $hInstance, $sTypeOfType, $sType, _
			$sTypeOfName, $sName, 'ushort', $iLanguage)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FreeResource($hData)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FreeResource', 'handle', $hData)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FreeResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetCaretBlinkTime()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetCaretBlinkTime')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetCaretBlinkTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCaretPos()
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetCaretPos', 'struct*', $tagPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[2]
	For $i = 0 To 1
		$aResult[$i] = DllStructGetData($tPOINT, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetCaretPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetClipCursor()
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetClipCursor', 'struct*', $tRECT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetClipCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCursor()
	Local $aRet = DllCall('user32.dll', 'handle', 'GetCursor')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFileVersionInfo($sFilePath, ByRef $pBuffer, $iFlags = 0)
	Local $aRet
	If $__WINVER >= 0x0600 Then
		$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeExW', 'dword', BitAND($iFlags, 0x03), 'wstr', $sFilePath, _
				'ptr', 0)
	Else
		$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeW', 'wstr', $sFilePath, 'ptr', 0)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)
	$pBuffer = __HeapReAlloc($pBuffer, $aRet[0], 1)
	If @error Then Return SetError(@error + 100, @extended, 0)
	Local $iNbByte = $aRet[0]
	If $__WINVER >= 0x0600 Then
		$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoExW', 'dword', BitAND($iFlags, 0x07), 'wstr', $sFilePath, _
				'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
	Else
		$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoW', 'wstr', $sFilePath, _
				'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $iNbByte
EndFunc   ;==>_WinAPI_GetFileVersionInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_HideCaret($hWnd)
	Local $aRet = DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_HideCaret

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadBitmap($hInstance, $sBitmap)
	Local $sBitmapType = "int"
	If IsString($sBitmap) Then $sBitmapType = "wstr"
	Local $aResult = DllCall("user32.dll", "handle", "LoadBitmapW", "handle", $hInstance, $sBitmapType, $sBitmap)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadCursor($hInstance, $sName)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('user32.dll', 'handle', 'LoadCursorW', 'handle', $hInstance, $sTypeOfName, $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadCursorFromFile($sFilePath)
	Local $aRet = DllCall('user32.dll', 'handle', 'LoadCursorFromFileW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadCursorFromFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadIndirectString($sStrIn)
	Local $aRet = DllCall('shlwapi.dll', 'uint', 'SHLoadIndirectString', 'wstr', $sStrIn, 'wstr', '', 'uint', 4096, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_LoadIndirectString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost used correct syntax, Original concept Raik
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_LoadString($hInstance, $iStringID)
	Local $aResult = DllCall("user32.dll", "int", "LoadStringW", "handle", $hInstance, "uint", $iStringID, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_WinAPI_LoadString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadLibraryEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadResource($hInstance, $hResource)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'LoadResource', 'handle', $hInstance, 'handle', $hResource)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadStringEx($hModule, $iID, $iLanguage = $LOCALE_USER_DEFAULT)
	Local $iLibrary = 0
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(@error + 20, @extended, '')
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	Local $sResult = ''
	Local $pData = __ResLoad($hModule, 6, Floor($iID / 16) + 1, $iLanguage)
	If Not @error Then
		Local $iOffset = 0
		For $i = 0 To Mod($iID, 16) - 1
			$iOffset += 2 * (DllStructGetData(DllStructCreate('ushort', $pData + $iOffset), 1) + 1)
		Next
		$sResult = DllStructGetData(DllStructCreate('ushort;wchar[' & DllStructGetData(DllStructCreate('ushort', $pData + $iOffset), 1) & ']', $pData + $iOffset), 2)
		If @error Then $sResult = ''
	Else
		Return SetError(10, 0, '')
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf

	Return SetError(Number(Not $sResult), 0, $sResult)
EndFunc   ;==>_WinAPI_LoadStringEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LockResource($hData)
	Local $aRet = DllCall('kernel32.dll', 'ptr', 'LockResource', 'handle', $hData)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetCaretBlinkTime($iDuration)
	Local $iPrev = _WinAPI_GetCaretBlinkTime()
	If Not $iPrev Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('user32.dll', 'bool', 'SetCaretBlinkTime', 'uint', $iDuration)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $iPrev
EndFunc   ;==>_WinAPI_SetCaretBlinkTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetCaretPos($iX, $iY)
	Local $aRet = DllCall('user32.dll', 'int', 'SetCaretPos', 'int', $iX, 'int', $iY)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetCaretPos

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetCursor($hCursor)
	Local $aResult = DllCall("user32.dll", "handle", "SetCursor", "handle", $hCursor)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetSystemCursor($hCursor, $iID, $bCopy = False)
	If $bCopy Then
		$hCursor = _WinAPI_CopyCursor($hCursor)
	EndIf

	Local $aRet = DllCall('user32.dll', 'bool', 'SetSystemCursor', 'handle', $hCursor, 'dword', $iID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetSystemCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShowCaret($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShowCaret', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShowCaret

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowCursor($bShow)
	Local $aResult = DllCall("user32.dll", "int", "ShowCursor", "bool", $bShow)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SizeOfResource($hInstance, $hResource)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'SizeofResource', 'handle', $hInstance, 'handle', $hResource)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SizeOfResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UpdateResource($hUpdate, $sType, $sName, $iLanguage, $pData, $iSize)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'UpdateResourceW', 'handle', $hUpdate, $sTypeOfType, $sType, $sTypeOfName, $sName, _
			'word', $iLanguage, 'ptr', $pData, 'dword', $iSize)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UpdateResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_VerQueryRoot($pData)
	Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\', 'ptr*', 0, 'uint*', 0)
	If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, @extended, 0)

	Local $tVFFI = DllStructCreate($tagVS_FIXEDFILEINFO)
	If Not _WinAPI_MoveMemory($tVFFI, $aRet[3], $aRet[4]) Then Return SetError(@error + 20, @extended, 0)

	Return $tVFFI
EndFunc   ;==>_WinAPI_VerQueryRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_VerQueryValue($pData, $sValues = '')
	$sValues = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
	If Not $sValues Then
		$sValues = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
	EndIf
	$sValues = StringSplit($sValues, '|', $STR_NOCOUNT)
	Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, _
			'uint*', 0)
	If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, 0, 0)

	Local $iLength = Floor($aRet[4] / 4)
	Local $tLang = DllStructCreate('dword[' & $iLength & ']', $aRet[3])
	If @error Then Return SetError(@error + 20, 0, 0)

	Local $sCP, $aInfo[101][UBound($sValues) + 1] = [[0]]
	For $i = 1 To $iLength
		__Inc($aInfo)
		$aInfo[$aInfo[0][0]][0] = _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))
		$sCP = Hex(_WinAPI_MakeLong(_WinAPI_HiWord(DllStructGetData($tLang, 1, $i)), _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))), 8)
		For $j = 0 To UBound($sValues) - 1
			$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $sValues[$j], _
					'ptr*', 0, 'uint*', 0)
			If Not @error And $aRet[0] And $aRet[4] Then
				$aInfo[$aInfo[0][0]][$j + 1] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
			Else
				$aInfo[$aInfo[0][0]][$j + 1] = ''
			EndIf
		Next
	Next
	__Inc($aInfo, -1)
	Return $aInfo
EndFunc   ;==>_WinAPI_VerQueryValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_VerQueryValueEx($hModule, $sValues = '', $iLanguage = 0x0400)
	$__g_vVal = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
	If Not $__g_vVal Then
		$__g_vVal = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
	EndIf
	$__g_vVal = StringSplit($__g_vVal, '|')
	If Not IsArray($__g_vVal) Then Return SetError(1, 0, 0)
	Local $iLibrary = 0
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then
				Return SetError(@error + 10, @extended, 0)
			EndIf
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	Dim $__g_vEnum[101][$__g_vVal[0] + 1] = [[0]]
	Local $hEnumProc = DllCallbackRegister('__EnumVerValuesProc', 'bool', 'ptr;ptr;ptr;word;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceLanguagesW', 'handle', $hModule, 'int', 16, 'int', 1, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', $iLanguage)
	Do
		If @error Then
			$__g_vEnum = @error + 20
		Else
			If Not $aRet[0] Then
				Switch _WinAPI_GetLastError()
					Case 0, 15106 ; ERROR_SUCCESS, ERROR_RESOURCE_ENUM_USER_STOP
						ExitLoop
					Case Else
						$__g_vEnum = 20
				EndSwitch
			Else
				ExitLoop
			EndIf
		EndIf
	Until 1
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If Not $__g_vEnum[0][0] Then $__g_vEnum = 230
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_VerQueryValueEx

#EndRegion Public Functions

#Region Internal Functions

Func __EnumResLanguagesProc($hModule, $iType, $iName, $iLanguage, $lParam)
	#forceref $hModule, $iType, $iName, $lParam

	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0]] = $iLanguage
	Return 1
EndFunc   ;==>__EnumResLanguagesProc

Func __EnumResNamesProc($hModule, $iType, $iName, $lParam)
	#forceref $hModule, $iType, $lParam

	Local $iLength = _WinAPI_StrLen($iName)
	__Inc($__g_vEnum)
	If $iLength Then
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $iName), 1)
	Else
		$__g_vEnum[$__g_vEnum[0]] = Number($iName)
	EndIf
	Return 1
EndFunc   ;==>__EnumResNamesProc

Func __EnumResTypesProc($hModule, $iType, $lParam)
	#forceref $hModule, $lParam

	Local $iLength = _WinAPI_StrLen($iType)
	__Inc($__g_vEnum)
	If $iLength Then
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $iType), 1)
	Else
		$__g_vEnum[$__g_vEnum[0]] = Number($iType)
	EndIf
	Return 1
EndFunc   ;==>__EnumResTypesProc

Func __EnumVerValuesProc($hModule, $iType, $iName, $iLanguage, $iDefault)
	Local $aRet, $iEnum = 1, $iError = 0

	Switch $iDefault
		Case -1

		Case 0x0400
			$iLanguage = 0x0400
			$iEnum = 0
		Case Else
			If $iLanguage <> $iDefault Then
				Return 1
			EndIf
			$iEnum = 0
	EndSwitch
	Do
		Local $pData = __ResLoad($hModule, $iType, $iName, $iLanguage)
		If @error Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, 'uint*', 0)
		If @error Or Not $aRet[0] Or Not $aRet[4] Then
			$iError = @error + 20
			ExitLoop
		EndIf
		Local $tData = DllStructCreate('ushort;ushort', $aRet[3])
		If @error Then
			$iError = @error + 30
			ExitLoop
		EndIf
	Until 1
	If Not $iError Then
		__Inc($__g_vEnum)
		$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tData, 1)
		Local $sCP = Hex(_WinAPI_MakeLong(DllStructGetData($tData, 2), DllStructGetData($tData, 1)), 8)
		For $i = 1 To $__g_vVal[0]
			$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $__g_vVal[$i], _
					'ptr*', 0, 'uint*', 0)
			If Not @error And $aRet[0] And $aRet[4] Then
				$__g_vEnum[$__g_vEnum[0][0]][$i] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
			Else
				$__g_vEnum[$__g_vEnum[0][0]][$i] = ''
			EndIf
		Next
	Else
		$__g_vEnum = @error + 40
	EndIf
	If $__g_vEnum Then Return SetError($iError, 0, 0)

	Return $iEnum
EndFunc   ;==>__EnumVerValuesProc

Func __ResLoad($hInstance, $sType, $sName, $iLanguage)
	Local $hInfo = _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
	If Not $hInfo Then Return SetError(@error + 10, @extended, 0)

	Local $iSize = _WinAPI_SizeOfResource($hInstance, $hInfo)
	If Not $iSize Then Return SetError(@error + 20, @extended, 0)

	Local $hData = _WinAPI_LoadResource($hInstance, $hInfo)
	If Not $hData Then Return SetError(@error + 30, @extended, 0)

	Local $pData = _WinAPI_LockResource($hData)
	If Not $pData Then Return SetError(@error + 40, @extended, 0)

	Return SetExtended($iSize, $pData)
EndFunc   ;==>__ResLoad

#EndRegion Internal Functions
