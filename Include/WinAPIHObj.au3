#include-once

#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIHObj.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
;
; DuplicateHandle options
Global Const $DUPLICATE_CLOSE_SOURCE = 0x00000001
Global Const $DUPLICATE_SAME_ACCESS = 0x00000002
;
; _WinAPI_GetCurrentObject(), _WinAPI_GetObjectType()
Global Const $OBJ_BITMAP = 7
Global Const $OBJ_BRUSH = 2
Global Const $OBJ_COLORSPACE = 14
Global Const $OBJ_DC = 3
Global Const $OBJ_ENHMETADC = 12
Global Const $OBJ_ENHMETAFILE = 13
Global Const $OBJ_EXTPEN = 11
Global Const $OBJ_FONT = 6
Global Const $OBJ_MEMDC = 10
Global Const $OBJ_METADC = 4
Global Const $OBJ_METAFILE = 9
Global Const $OBJ_PAL = 5
Global Const $OBJ_PEN = 1
Global Const $OBJ_REGION = 8

; Stock Object Constants
Global Const $NULL_BRUSH = 5 ; Null brush (equivalent to HOLLOW_BRUSH)
Global Const $NULL_PEN = 8 ; NULL pen. The null pen draws nothing
Global Const $BLACK_BRUSH = 4 ; Black brush
Global Const $DKGRAY_BRUSH = 3 ; Dark gray brush
Global Const $DC_BRUSH = 18 ; Solid color brush. The default color is white
Global Const $GRAY_BRUSH = 2 ; Gray brush
Global Const $HOLLOW_BRUSH = $NULL_BRUSH ; Hollow brush (equivalent to NULL_BRUSH)
Global Const $LTGRAY_BRUSH = 1 ; Light gray brush
Global Const $WHITE_BRUSH = 0 ; White brush
Global Const $BLACK_PEN = 7 ; Black pen
Global Const $DC_PEN = 19 ; Solid pen color. The default color is white
Global Const $WHITE_PEN = 6 ; White pen
Global Const $ANSI_FIXED_FONT = 11 ; Windows fixed-pitch (monospace) system font
Global Const $ANSI_VAR_FONT = 12 ; Windows variable-pitch (proportional space) system font
Global Const $DEVICE_DEFAULT_FONT = 14 ; Windows Device-dependent font
Global Const $DEFAULT_GUI_FONT = 17 ; Default font for user interface objects such as menus and dialog boxes
Global Const $OEM_FIXED_FONT = 10 ; Original equipment manufacturer (OEM) dependent fixed-pitch (monospace) font
Global Const $SYSTEM_FONT = 13 ; System font. By default, the system uses the system font to draw menus, dialog box controls, and text
Global Const $SYSTEM_FIXED_FONT = 16 ; Fixed-pitch (monospace) system font. This stock object is provided only for compatibility with 16-bit Windows versions earlier than 3.0
Global Const $DEFAULT_PALETTE = 15 ; Default palette. This palette consists of the static colors in the system palette
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CloseHandle
; _WinAPI_DeleteObject
; _WinAPI_DuplicateHandle
; _WinAPI_GetCurrentObject
; _WinAPI_GetCurrentProcess
; _WinAPI_GetObject
; _WinAPI_GetObjectInfoByHandle
; _WinAPI_GetObjectNameByHandle
; _WinAPI_GetObjectType
; _WinAPI_GetStdHandle
; _WinAPI_GetStockObject
; _WinAPI_SelectObject
; _WinAPI_SetHandleInformation
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CloseHandle($hObject)
	Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CloseHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DeleteObject($hObject)
	Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DeleteObject

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DuplicateHandle($hSourceProcessHandle, $hSourceHandle, $hTargetProcessHandle, $iDesiredAccess, $iInheritHandle, $iOptions)
	Local $aResult = DllCall("kernel32.dll", "bool", "DuplicateHandle", _
			"handle", $hSourceProcessHandle, _
			"handle", $hSourceHandle, _
			"handle", $hTargetProcessHandle, _
			"handle*", 0, _
			"dword", $iDesiredAccess, _
			"bool", $iInheritHandle, _
			"dword", $iOptions)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $aResult[4]
EndFunc   ;==>_WinAPI_DuplicateHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentObject($hDC, $iType)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'GetCurrentObject', 'handle', $hDC, 'uint', $iType)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetCurrentObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentProcess()
	Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentProcess

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetObject($hObject, $iSize, $pObject)
	Local $aResult = DllCall("gdi32.dll", "int", "GetObjectW", "handle", $hObject, "int", $iSize, "struct*", $pObject)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetObject

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetObjectInfoByHandle($hObject)
	Local $tagPUBLIC_OBJECT_BASIC_INFORMATION = 'ulong Attributes;ulong GrantedAcess;ulong HandleCount;ulong PointerCount;ulong Reserved[10]'
	Local $tPOBI = DllStructCreate($tagPUBLIC_OBJECT_BASIC_INFORMATION)
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryObject', 'handle', $hObject, 'uint', 0, 'struct*', $tPOBI, _
			'ulong', DllStructGetSize($tPOBI), 'ptr', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[4]
	For $i = 0 To 3
		$aResult[$i] = DllStructGetData($tPOBI, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetObjectInfoByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetObjectNameByHandle($hObject)
	Local $tagUNICODE_STRING = 'struct;ushort Length;ushort MaximumLength;ptr Buffer;endstruct'
	Local $tagPUBLIC_OBJECT_TYPE_INFORMATION = 'struct;' & $tagUNICODE_STRING & ';ulong Reserved[22];endstruct'
	Local $tPOTI = DllStructCreate($tagPUBLIC_OBJECT_TYPE_INFORMATION & ';byte[32]')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryObject', 'handle', $hObject, 'uint', 2, 'struct*', $tPOTI, _
			'ulong', DllStructGetSize($tPOTI), 'ulong*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')
	Local $pData = DllStructGetData($tPOTI, 3)
	If Not $pData Then Return SetError(11, 0, '')

	Return _WinAPI_GetString($pData)
EndFunc   ;==>_WinAPI_GetObjectNameByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetObjectType($hObject)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'GetObjectType', 'handle', $hObject)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetObjectType

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetStdHandle($iStdHandle)
	If $iStdHandle < 0 Or $iStdHandle > 2 Then Return SetError(2, 0, -1)
	Local Const $aHandle[3] = [-10, -11, -12]

	Local $aResult = DllCall("kernel32.dll", "handle", "GetStdHandle", "dword", $aHandle[$iStdHandle])
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetStdHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetStockObject($iObject)
	Local $aResult = DllCall("gdi32.dll", "handle", "GetStockObject", "int", $iObject)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetStockObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SelectObject($hDC, $hGDIObj)
	Local $aResult = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hGDIObj)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SelectObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetHandleInformation($hObject, $iMask, $iFlags)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetHandleInformation", "handle", $hObject, "dword", $iMask, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetHandleInformation

#EndRegion Public Functions
