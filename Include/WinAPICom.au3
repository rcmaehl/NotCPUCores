#include-once

#include "APIComConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPICom.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__tagWinAPICom_GUID = "struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];endstruct"
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CLSIDFromProgID
; _WinAPI_CoInitialize
; _WinAPI_CoTaskMemAlloc
; _WinAPI_CoTaskMemFree
; _WinAPI_CoTaskMemRealloc
; _WinAPI_CoUninitialize
; _WinAPI_CreateGUID
; _WinAPI_CreateStreamOnHGlobal
; _WinAPI_GetHGlobalFromStream
; _WinAPI_ProgIDFromCLSID
; _WinAPI_ReleaseStream
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CLSIDFromProgID($sProgID)
	Local $tGUID = DllStructCreate($__tagWinAPICom_GUID)
	Local $aReturn = DllCall('ole32.dll', 'long', 'CLSIDFromProgID', 'wstr', $sProgID, 'struct*', $tGUID)
	If @error Then Return SetError(@error, @extended, '')
	If $aReturn[0] Then Return SetError(10, $aReturn[0], '')

	$aReturn = DllCall('ole32.dll', 'int', 'StringFromGUID2', 'struct*', $tGUID, 'wstr', '', 'int', 39)
	If @error Or Not $aReturn[0] Then Return SetError(@error + 20, @extended, '')

	Return $aReturn[2]
EndFunc   ;==>_WinAPI_CLSIDFromProgID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CoInitialize($iFlags = 0)
	Local $aReturn = DllCall('ole32.dll', 'long', 'CoInitializeEx', 'ptr', 0, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_CoInitialize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CoTaskMemAlloc($iSize)
	Local $aReturn = DllCall('ole32.dll', 'ptr', 'CoTaskMemAlloc', 'uint_ptr', $iSize)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aReturn[0] Then Return SetError(1000, 0, 0)

	Return $aReturn[0]
EndFunc   ;==>_WinAPI_CoTaskMemAlloc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CoTaskMemFree($pMemory)
	DllCall('ole32.dll', 'none', 'CoTaskMemFree', 'ptr', $pMemory)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_CoTaskMemFree

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CoTaskMemRealloc($pMemory, $iSize)
	Local $aReturn = DllCall('ole32.dll', 'ptr', 'CoTaskMemRealloc', 'ptr', $pMemory, 'ulong_ptr', $iSize)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aReturn[0] Then Return SetError(1000, 0, 0)

	Return $aReturn[0]
EndFunc   ;==>_WinAPI_CoTaskMemRealloc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CoUninitialize()
	DllCall('ole32.dll', 'none', 'CoUninitialize')
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_CoUninitialize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateGUID()
	Local $tGUID = DllStructCreate($__tagWinAPICom_GUID)
	Local $aReturn = DllCall('ole32.dll', 'long', 'CoCreateGuid', 'struct*', $tGUID)
	If @error Then Return SetError(@error, @extended, '')
	If $aReturn[0] Then Return SetError(10, $aReturn[0], '')

	$aReturn = DllCall('ole32.dll', 'int', 'StringFromGUID2', 'struct*', $tGUID, 'wstr', '', 'int', 65536)
	If @error Or Not $aReturn[0] Then Return SetError(@error + 20, @extended, '')

	Return $aReturn[2]
EndFunc   ;==>_WinAPI_CreateGUID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateStreamOnHGlobal($hGlobal = 0, $bDeleteOnRelease = True)
	Local $aReturn = DllCall('ole32.dll', 'long', 'CreateStreamOnHGlobal', 'handle', $hGlobal, 'bool', $bDeleteOnRelease, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)

	Return $aReturn[3]
EndFunc   ;==>_WinAPI_CreateStreamOnHGlobal

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetHGlobalFromStream($pStream)
	Local $aReturn = DllCall('ole32.dll', 'uint', 'GetHGlobalFromStream', 'ptr', $pStream, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)

	Return $aReturn[2]
EndFunc   ;==>_WinAPI_GetHGlobalFromStream

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ProgIDFromCLSID($sCLSID)
	Local $tGUID = DllStructCreate($__tagWinAPICom_GUID)
	Local $aReturn = DllCall('ole32.dll', 'uint', 'CLSIDFromString', 'wstr', $sCLSID, 'struct*', $tGUID)
	If @error Or $aReturn[0] Then Return SetError(@error + 20, @extended, '')
	$aReturn = DllCall('ole32.dll', 'uint', 'ProgIDFromCLSID', 'struct*', $tGUID, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aReturn[0] Then Return SetError(10, $aReturn[0], '')

	Local $sID = _WinAPI_GetString($aReturn[2])
	_WinAPI_CoTaskMemFree($aReturn[2])
	Return $sID
EndFunc   ;==>_WinAPI_ProgIDFromCLSID

; #FUNCTION# ====================================================================================================================
; Author.........: Progandy
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_ReleaseStream($pStream)
	Local $aReturn = DllCall('oleaut32.dll', 'long', 'DispCallFunc', 'ptr', $pStream, 'ulong_ptr', 8 * (1 + @AutoItX64), 'uint', 4, _
			'ushort', 23, 'uint', 0, 'ptr', 0, 'ptr', 0, 'str', '')
	If @error Then Return SetError(@error, @extended, 0)
	If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ReleaseStream

#EndRegion Public Functions
