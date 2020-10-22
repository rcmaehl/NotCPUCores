#include-once

#include "WinAPIGdiInternals.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIGdiDC.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; DrawIconEx Constants
Global Const $DI_MASK = 0x0001
Global Const $DI_IMAGE = 0x0002
Global Const $DI_NORMAL = 0x0003
Global Const $DI_COMPAT = 0x0004
Global Const $DI_DEFAULTSIZE = 0x0008
Global Const $DI_NOMIRROR = 0x0010

; EnumDisplayDevice Constants
Global Const $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 0x00000001
Global Const $DISPLAY_DEVICE_MULTI_DRIVER = 0x00000002
Global Const $DISPLAY_DEVICE_PRIMARY_DEVICE = 0x00000004
Global Const $DISPLAY_DEVICE_MIRRORING_DRIVER = 0x00000008
Global Const $DISPLAY_DEVICE_VGA_COMPATIBLE = 0x00000010
Global Const $DISPLAY_DEVICE_REMOVABLE = 0x00000020
Global Const $DISPLAY_DEVICE_DISCONNECT = 0x02000000
Global Const $DISPLAY_DEVICE_REMOTE = 0x04000000
Global Const $DISPLAY_DEVICE_MODESPRUNED = 0x08000000
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CreateCompatibleDC
; _WinAPI_DeleteDC
; _WinAPI_DrawEdge
; _WinAPI_DrawFrameControl
; _WinAPI_DrawIcon
; _WinAPI_DrawIconEx
; _WinAPI_DrawText
; _WinAPI_EnumDisplayDevices
; _WinAPI_FillRect
; _WinAPI_FrameRect
; _WinAPI_GetBkMode
; _WinAPI_GetDC
; _WinAPI_GetDCEx
; _WinAPI_GetDeviceCaps
; _WinAPI_GetTextColor
; _WinAPI_GetWindowDC
; _WinAPI_PrintWindow
; _WinAPI_ReleaseDC
; _WinAPI_RestoreDC
; _WinAPI_SaveDC
; _WinAPI_SetBkColor
; _WinAPI_SetBkMode
; _WinAPI_SetTextColor
; _WinAPI_TwipsPerPixelX
; _WinAPI_TwipsPerPixelY
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateCompatibleDC($hDC)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleDC", "handle", $hDC)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateCompatibleDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DeleteDC($hDC)
	Local $aResult = DllCall("gdi32.dll", "bool", "DeleteDC", "handle", $hDC)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DeleteDC

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawEdge($hDC, $tRECT, $iEdgeType, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "DrawEdge", "handle", $hDC, "struct*", $tRECT, "uint", $iEdgeType, _
			"uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawEdge

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawFrameControl($hDC, $tRECT, $iType, $iState)
	Local $aResult = DllCall("user32.dll", "bool", "DrawFrameControl", "handle", $hDC, "struct*", $tRECT, "uint", $iType, _
			"uint", $iState)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawFrameControl

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DrawIcon($hDC, $iX, $iY, $hIcon)
	Local $aResult = DllCall("user32.dll", "bool", "DrawIcon", "handle", $hDC, "int", $iX, "int", $iY, "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DrawIconEx($hDC, $iX, $iY, $hIcon, $iWidth = 0, $iHeight = 0, $iStep = 0, $hBrush = 0, $iFlags = 3)
	Local $iOptions
	Switch $iFlags
		Case 1
			$iOptions = $DI_MASK
		Case 2
			$iOptions = $DI_IMAGE
		Case 3
			$iOptions = $DI_NORMAL
		Case 4
			$iOptions = $DI_COMPAT
		Case 5
			$iOptions = $DI_DEFAULTSIZE
		Case Else
			$iOptions = $DI_NOMIRROR
	EndSwitch

	Local $aResult = DllCall("user32.dll", "bool", "DrawIconEx", "handle", $hDC, "int", $iX, "int", $iY, "handle", $hIcon, _
			"int", $iWidth, "int", $iHeight, "uint", $iStep, "handle", $hBrush, "uint", $iOptions)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawIconEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawText($hDC, $sText, ByRef $tRECT, $iFlags)
	Local $aResult = DllCall("user32.dll", "int", "DrawTextW", "handle", $hDC, "wstr", $sText, "int", -1, "struct*", $tRECT, _
			"uint", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_EnumDisplayDevices($sDevice, $iDevNum)
	Local $tName = 0, $iFlags = 0, $aDevice[5]

	If $sDevice <> "" Then
		$tName = DllStructCreate("wchar Text[" & StringLen($sDevice) + 1 & "]")
		DllStructSetData($tName, "Text", $sDevice)
	EndIf
	Local Const $tagDISPLAY_DEVICE = "dword Size;wchar Name[32];wchar String[128];dword Flags;wchar ID[128];wchar Key[128]"
	Local $tDevice = DllStructCreate($tagDISPLAY_DEVICE)
	Local $iDevice = DllStructGetSize($tDevice)
	DllStructSetData($tDevice, "Size", $iDevice)
	Local $aRet = DllCall("user32.dll", "bool", "EnumDisplayDevicesW", "struct*", $tName, "dword", $iDevNum, "struct*", $tDevice, "dword", 1)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $iN = DllStructGetData($tDevice, "Flags")
	If BitAND($iN, $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) <> 0 Then $iFlags = BitOR($iFlags, 1)
	If BitAND($iN, $DISPLAY_DEVICE_PRIMARY_DEVICE) <> 0 Then $iFlags = BitOR($iFlags, 2)
	If BitAND($iN, $DISPLAY_DEVICE_MIRRORING_DRIVER) <> 0 Then $iFlags = BitOR($iFlags, 4)
	If BitAND($iN, $DISPLAY_DEVICE_VGA_COMPATIBLE) <> 0 Then $iFlags = BitOR($iFlags, 8)
	If BitAND($iN, $DISPLAY_DEVICE_REMOVABLE) <> 0 Then $iFlags = BitOR($iFlags, 16)
	If BitAND($iN, $DISPLAY_DEVICE_MODESPRUNED) <> 0 Then $iFlags = BitOR($iFlags, 32)
	$aDevice[0] = True
	$aDevice[1] = DllStructGetData($tDevice, "Name")
	$aDevice[2] = DllStructGetData($tDevice, "String")
	$aDevice[3] = $iFlags
	$aDevice[4] = DllStructGetData($tDevice, "ID")
	Return $aDevice
EndFunc   ;==>_WinAPI_EnumDisplayDevices

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FillRect($hDC, $tRECT, $hBrush)
	Local $aResult
	If IsPtr($hBrush) Then
		$aResult = DllCall("user32.dll", "int", "FillRect", "handle", $hDC, "struct*", $tRECT, "handle", $hBrush)
	Else
		$aResult = DllCall("user32.dll", "int", "FillRect", "handle", $hDC, "struct*", $tRECT, "dword_ptr", $hBrush)
	EndIf
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FillRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FrameRect($hDC, $tRECT, $hBrush)
	Local $aResult = DllCall("user32.dll", "int", "FrameRect", "handle", $hDC, "struct*", $tRECT, "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FrameRect

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetBkMode($hDC)
	Local $aResult = DllCall("gdi32.dll", "int", "GetBkMode", "handle", $hDC)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetBkMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDC($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDCEx($hWnd, $hRgn, $iFlags)
	Local $aRet = DllCall('user32.dll', 'handle', 'GetDCEx', 'hwnd', $hWnd, 'handle', $hRgn, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetDCEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDeviceCaps($hDC, $iIndex)
	Local $aResult = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hDC, "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDeviceCaps

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetTextColor($hDC)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'GetTextColor', 'handle', $hDC)
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 4294967295 Then Return SetError(1000, 0, -1)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_GetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowDC($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetWindowDC", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowDC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PrintWindow($hWnd, $hDC, $bClient = False)
	Local $aRet = DllCall('user32.dll', 'bool', 'PrintWindow', 'hwnd', $hWnd, 'handle', $hDC, 'uint', $bClient)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PrintWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ReleaseDC($hWnd, $hDC)
	Local $aResult = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReleaseDC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RestoreDC($hDC, $iID)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'RestoreDC', 'handle', $hDC, 'int', $iID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RestoreDC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SaveDC($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SaveDC', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SaveDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetBkColor($hDC, $iColor)
	Local $aResult = DllCall("gdi32.dll", "INT", "SetBkColor", "handle", $hDC, "INT", $iColor)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetBkMode($hDC, $iBkMode)
	Local $aResult = DllCall("gdi32.dll", "int", "SetBkMode", "handle", $hDC, "int", $iBkMode)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetBkMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetTextColor($hDC, $iColor)
	Local $aResult = DllCall("gdi32.dll", "INT", "SetTextColor", "handle", $hDC, "INT", $iColor)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_TwipsPerPixelX()
	Local $hDC, $iTwipsPerPixelX
	$hDC = _WinAPI_GetDC(0)
	Local Const $__WINAPICONSTANT_LOGPIXELSX = 88
	$iTwipsPerPixelX = 1440 / _WinAPI_GetDeviceCaps($hDC, $__WINAPICONSTANT_LOGPIXELSX)
	_WinAPI_ReleaseDC(0, $hDC)
	Return $iTwipsPerPixelX
EndFunc   ;==>_WinAPI_TwipsPerPixelX

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_TwipsPerPixelY()
	Local $hDC, $iTwipsPerPixelY
	$hDC = _WinAPI_GetDC(0)
	Local Const $__WINAPICONSTANT_LOGPIXELSY = 90
	$iTwipsPerPixelY = 1440 / _WinAPI_GetDeviceCaps($hDC, $__WINAPICONSTANT_LOGPIXELSY)
	_WinAPI_ReleaseDC(0, $hDC)
	Return $iTwipsPerPixelY
EndFunc   ;==>_WinAPI_TwipsPerPixelY

#EndRegion Public Functions

#Region Internal Functions

#EndRegion Internal Functions
