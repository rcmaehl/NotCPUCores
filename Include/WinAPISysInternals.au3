#include-once

#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPISys.au3
; Author(s) .....: jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_aInProcess_WinAPI[64][2] = [[0, 0]]
Global $__g_aWinList_WinAPI[64][2] = [[0, 0]]
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; GetWindows Constants
Global Const $GW_HWNDFIRST = 0
Global Const $GW_HWNDLAST = 1
Global Const $GW_HWNDNEXT = 2
Global Const $GW_HWNDPREV = 3
Global Const $GW_OWNER = 4
Global Const $GW_CHILD = 5
Global Const $GW_ENABLEDPOPUP = 6

; GetWindowLong Constants
Global Const $GWL_WNDPROC = 0xFFFFFFFC
Global Const $GWL_HINSTANCE = 0xFFFFFFFA
Global Const $GWL_HWNDPARENT = 0xFFFFFFF8
Global Const $GWL_ID = 0xFFFFFFF4
Global Const $GWL_STYLE = 0xFFFFFFF0
Global Const $GWL_EXSTYLE = 0xFFFFFFEC
Global Const $GWL_USERDATA = 0xFFFFFFEB

Global Const $__WINAPICONSTANT_WM_SETFONT = 0x0030
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
;
; Doc in WinAPISys
; _WinAPI_EnableWindow
; _WinAPI_GetSystemMetrics
;
; Doc in WinAPISysWin
; _WinAPI_CreateWindowEx
; _WinAPI_DestroyWindow
; _WinAPI_EnumWindows
; _WinAPI_EnumWindowsPopup
; _WinAPI_EnumWindowsTop
; _WinAPI_GetClassName
; _WinAPI_GetClientRect
; _WinAPI_GetDesktopWindow
; _WinAPI_GetFocus
; _WinAPI_GetParent
; _WinAPI_GetSysColor
; _WinAPI_GetWindow
; _WinAPI_GetWindowHeight
; _WinAPI_GetWindowLong
; _WinAPI_GetWindowRect
; _WinAPI_GetWindowText
; _WinAPI_GetWindowThreadProcessId
; _WinAPI_GetWindowWidth
; _WinAPI_InProcess
; _WinAPI_InvalidateRect
; _WinAPI_IsClassName
; _WinAPI_IsWindow
; _WinAPI_IsWindowVisible
; _WinAPI_MoveWindow
; _WinAPI_SetFocus
; _WinAPI_SetFont
; _WinAPI_SetParent
; _WinAPI_SetWindowPos
; _WinAPI_SetWindowText
; _WinAPI_ShowWindow
; _WinAPI_UpdateWindow
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __WinAPI_EnumWindowsAdd
; __WinAPI_EnumWindowsChild
; __WinAPI_EnumWindowsInit
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
	If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
	Local $aResult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, _
			"dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, _
			"handle", $hInstance, "struct*", $pParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateWindowEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetClientRect($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "struct*", $tRECT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetClientRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDesktopWindow()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetDesktopWindow")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDesktopWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DestroyWindow($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "DestroyWindow", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DestroyWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_EnableWindow($hWnd, $bEnable = True)
	Local $aResult = DllCall("user32.dll", "bool", "EnableWindow", "hwnd", $hWnd, "bool", $bEnable)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_EnableWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumWindows($bVisible = True, $hWnd = Default)
	__WinAPI_EnumWindowsInit()
	If $hWnd = Default Then $hWnd = _WinAPI_GetDesktopWindow()
	__WinAPI_EnumWindowsChild($hWnd, $bVisible)
	Return $__g_aWinList_WinAPI
EndFunc   ;==>_WinAPI_EnumWindows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_EnumWindowsPopup()
	__WinAPI_EnumWindowsInit()
	Local $hWnd = _WinAPI_GetWindow(_WinAPI_GetDesktopWindow(), $GW_CHILD)
	Local $sClass
	While $hWnd <> 0
		If _WinAPI_IsWindowVisible($hWnd) Then
			$sClass = _WinAPI_GetClassName($hWnd)
			If $sClass = "#32768" Then
				__WinAPI_EnumWindowsAdd($hWnd)
			ElseIf $sClass = "ToolbarWindow32" Then
				__WinAPI_EnumWindowsAdd($hWnd)
			ElseIf $sClass = "ToolTips_Class32" Then
				__WinAPI_EnumWindowsAdd($hWnd)
			ElseIf $sClass = "BaseBar" Then
				__WinAPI_EnumWindowsChild($hWnd)
			EndIf
		EndIf
		$hWnd = _WinAPI_GetWindow($hWnd, $GW_HWNDNEXT)
	WEnd
	Return $__g_aWinList_WinAPI
EndFunc   ;==>_WinAPI_EnumWindowsPopup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_EnumWindowsTop()
	__WinAPI_EnumWindowsInit()
	Local $hWnd = _WinAPI_GetWindow(_WinAPI_GetDesktopWindow(), $GW_CHILD)
	While $hWnd <> 0
		If _WinAPI_IsWindowVisible($hWnd) Then __WinAPI_EnumWindowsAdd($hWnd)
		$hWnd = _WinAPI_GetWindow($hWnd, $GW_HWNDNEXT)
	WEnd
	Return $__g_aWinList_WinAPI
EndFunc   ;==>_WinAPI_EnumWindowsTop

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetClassName($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, '')

	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_GetClassName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetFocus()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetFocus")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetParent($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetParent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSysColor($iIndex)
	Local $aResult = DllCall("user32.dll", "INT", "GetSysColor", "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetSysColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSystemMetrics($iIndex)
	Local $aResult = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetSystemMetrics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindow($hWnd, $iCmd)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetWindow", "hwnd", $hWnd, "uint", $iCmd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowHeight($hWnd)
	Local $tRECT = _WinAPI_GetWindowRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")
EndFunc   ;==>_WinAPI_GetWindowHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowLong($hWnd, $iIndex)
	Local $sFuncName = "GetWindowLongW"
	If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
	Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowLong

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowRect($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall("user32.dll", "bool", "GetWindowRect", "hwnd", $hWnd, "struct*", $tRECT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetWindowRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowText($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetWindowTextW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_GetWindowText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
	Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)

	$iPID = $aResult[2]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowThreadProcessId

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowWidth($hWnd)
	Local $tRECT = _WinAPI_GetWindowRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
EndFunc   ;==>_WinAPI_GetWindowWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
	If $hWnd = $hLastWnd Then Return True
	For $iI = $__g_aInProcess_WinAPI[0][0] To 1 Step -1
		If $hWnd = $__g_aInProcess_WinAPI[$iI][0] Then
			If $__g_aInProcess_WinAPI[$iI][1] Then
				$hLastWnd = $hWnd
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	Local $iPID
	_WinAPI_GetWindowThreadProcessId($hWnd, $iPID)
	Local $iCount = $__g_aInProcess_WinAPI[0][0] + 1
	If $iCount >= 64 Then $iCount = 1
	$__g_aInProcess_WinAPI[0][0] = $iCount
	$__g_aInProcess_WinAPI[$iCount][0] = $hWnd
	$__g_aInProcess_WinAPI[$iCount][1] = ($iPID = @AutoItPID)
	Return $__g_aInProcess_WinAPI[$iCount][1]
EndFunc   ;==>_WinAPI_InProcess

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_InvalidateRect($hWnd, $tRECT = 0, $bErase = True)
	Local $aResult = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hWnd, "struct*", $tRECT, "bool", $bErase)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_InvalidateRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IsClassName($hWnd, $sClassName)
	Local $sSeparator = Opt("GUIDataSeparatorChar")
	Local $aClassName = StringSplit($sClassName, $sSeparator)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $sClassCheck = _WinAPI_GetClassName($hWnd) ; ClassName from Handle
	; check array of ClassNames against ClassName Returned
	For $x = 1 To UBound($aClassName) - 1
		If StringUpper(StringMid($sClassCheck, 1, StringLen($aClassName[$x]))) = StringUpper($aClassName[$x]) Then Return True
	Next
	Return False
EndFunc   ;==>_WinAPI_IsClassName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IsWindow($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "IsWindow", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_IsWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IsWindowVisible($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "IsWindowVisible", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_IsWindowVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MoveWindow($hWnd, $iX, $iY, $iWidth, $iHeight, $bRepaint = True)
	Local $aResult = DllCall("user32.dll", "bool", "MoveWindow", "hwnd", $hWnd, "int", $iX, "int", $iY, "int", $iWidth, _
			"int", $iHeight, "bool", $bRepaint)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MoveWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetFocus($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetFont($hWnd, $hFont, $bRedraw = True)
	_SendMessage($hWnd, $__WINAPICONSTANT_WM_SETFONT, $hFont, $bRedraw, 0, "hwnd")
EndFunc   ;==>_WinAPI_SetFont

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetParent($hWndChild, $hWndParent)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $hWndChild, "hwnd", $hWndParent)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetParent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetWindowPos($hWnd, $hAfter, $iX, $iY, $iCX, $iCY, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hWnd, "hwnd", $hAfter, "int", $iX, "int", $iY, _
			"int", $iCX, "int", $iCY, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowPos

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowText($hWnd, $sText)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowTextW", "hwnd", $hWnd, "wstr", $sText)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowWindow($hWnd, $iCmdShow = 5)
	Local $aResult = DllCall("user32.dll", "bool", "ShowWindow", "hwnd", $hWnd, "int", $iCmdShow)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_UpdateWindow($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "UpdateWindow", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_UpdateWindow

#EndRegion Public Functions

#Region Internal Functions

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_EnumWindowsAdd
; Description ...: Adds window information to the windows enumeration list
; Syntax.........: __WinAPI_EnumWindowsAdd ( $hWnd [, $sClass = ""] )
; Parameters ....: $hWnd        - Handle to the window
;                  $sClass      - Window class name
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by the windows enumeration functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_EnumWindowsAdd($hWnd, $sClass = "")
	If $sClass = "" Then $sClass = _WinAPI_GetClassName($hWnd)
	$__g_aWinList_WinAPI[0][0] += 1
	Local $iCount = $__g_aWinList_WinAPI[0][0]
	If $iCount >= $__g_aWinList_WinAPI[0][1] Then
		ReDim $__g_aWinList_WinAPI[$iCount + 64][2]
		$__g_aWinList_WinAPI[0][1] += 64
	EndIf
	$__g_aWinList_WinAPI[$iCount][0] = $hWnd
	$__g_aWinList_WinAPI[$iCount][1] = $sClass
EndFunc   ;==>__WinAPI_EnumWindowsAdd

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_EnumWindowsChild
; Description ...: Enumerates child windows of a specific window
; Syntax.........: __WinAPI_EnumWindowsChild ( $hWnd [, $bVisible = True] )
; Parameters ....: $hWnd        - Handle of parent window
;                  $bVisible    - Window selection flag:
;                  | True - Returns only visible windows
;                  |False - Returns all windows
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; Remarks .......: This function is used internally by the windows enumeration functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_EnumWindowsChild($hWnd, $bVisible = True)
	$hWnd = _WinAPI_GetWindow($hWnd, $GW_CHILD)
	While $hWnd <> 0
		If (Not $bVisible) Or _WinAPI_IsWindowVisible($hWnd) Then
			__WinAPI_EnumWindowsAdd($hWnd)
			__WinAPI_EnumWindowsChild($hWnd, $bVisible)
		EndIf
		$hWnd = _WinAPI_GetWindow($hWnd, $GW_HWNDNEXT)
	WEnd
EndFunc   ;==>__WinAPI_EnumWindowsChild

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_EnumWindowsInit
; Description ...: Initializes the windows enumeration list
; Syntax.........: __WinAPI_EnumWindowsInit ( )
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by the windows enumeration functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_EnumWindowsInit()
	ReDim $__g_aWinList_WinAPI[64][2]
	$__g_aWinList_WinAPI[0][0] = 0
	$__g_aWinList_WinAPI[0][1] = 64
EndFunc   ;==>__WinAPI_EnumWindowsInit

#EndRegion Internal Functions
