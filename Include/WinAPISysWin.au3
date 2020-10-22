#include-once

#include "WinAPIError.au3"
#include "WinAPISysInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: Windows API
; AutoIt Version : 3.3.14.5
; Description ...: Windows API calls that have been translated to AutoIt functions.
; Author(s) .....: Paul Campbell (PaulIA), gafrost, Siao, Zedna, arcker, Prog@ndy, PsaltyDS, Raik, jpm
; Dll ...........: kernel32.dll, user32.dll, gdi32.dll, comdlg32.dll, shell32.dll, ole32.dll, winspool.drv
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; FlashWindowEx Constants
Global Const $FLASHW_CAPTION = 0x00000001
Global Const $FLASHW_TRAY = 0x00000002
Global Const $FLASHW_TIMER = 0x00000004
Global Const $FLASHW_TIMERNOFG = 0x0000000C

Global Const $tagUPDATELAYEREDWINDOWINFO = 'dword Size;hwnd hDstDC;long DstX;long DstY;long cX;long cY;hwnd hSrcDC;long SrcX;long SrcY;dword crKey;byte BlendOp;byte BlendFlags;byte Alpha;byte AlphaFormat;dword Flags;long DirtyLeft;long DirtyTop;long DirtyRight;long DirtyBottom'
Global Const $tagWINDOWINFO = 'dword Size;struct;long rWindow[4];endstruct;struct;long rClient[4];endstruct;dword Style;dword ExStyle;dword WindowStatus;uint cxWindowBorders;uint cyWindowBorders;word atomWindowType;word CreatorVersion'
Global Const $tagWNDCLASS = 'uint Style;ptr hWndProc;int ClsExtra;int WndExtra;ptr hInstance;ptr hIcon;ptr hCursor;ptr hBackground;ptr MenuName;ptr ClassName'
Global Const $tagWNDCLASSEX = 'uint Size;uint Style;ptr hWndProc;int ClsExtra;int WndExtra;ptr hInstance;ptr hIcon;ptr hCursor;ptr hBackground;ptr MenuName;ptr ClassName;ptr hIconSm'
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _WinAPI_AdjustWindowRectEx
; _WinAPI_AnimateWindow
; _WinAPI_BeginDeferWindowPos
; _WinAPI_BringWindowToTop
; _WinAPI_BroadcastSystemMessage
; _WinAPI_CallWindowProc
; _WinAPI_CallWindowProcW
; _WinAPI_CascadeWindows
; _WinAPI_ChangeWindowMessageFilterEx
; _WinAPI_ChildWindowFromPointEx
; _WinAPI_CloseWindow
; _WinAPI_DeferWindowPos
; _WinAPI_DefWindowProc
; _WinAPI_DefWindowProcW
; _WinAPI_DeregisterShellHookWindow
; _WinAPI_DragAcceptFiles
; _WinAPI_DragFinish
; _WinAPI_DragQueryFileEx
; _WinAPI_DragQueryPoint
; _WinAPI_EndDeferWindowPos
; _WinAPI_EnumChildWindows
; _WinAPI_FindWindow
; _WinAPI_FlashWindow
; _WinAPI_FlashWindowEx
; _WinAPI_GetAncestor
; _WinAPI_GetClassInfoEx
; _WinAPI_GetClassLongEx
; _WinAPI_GetClientHeight
; _WinAPI_GetClientWidth
; _WinAPI_GetDlgItem
; _WinAPI_GetForegroundWindow
; _WinAPI_GetLayeredWindowAttributes
; _WinAPI_GetGUIThreadInfo
; _WinAPI_GetLastActivePopup
; _WinAPI_GetMessageExtraInfo
; _WinAPI_GetShellWindow
; _WinAPI_GetTopWindow
; _WinAPI_GetWindowDisplayAffinity
; _WinAPI_GetWindowInfo
; _WinAPI_GetWindowPlacement
; _WinAPI_IsChild
; _WinAPI_IsHungAppWindow
; _WinAPI_IsIconic
; _WinAPI_IsWindowUnicode
; _WinAPI_IsZoomed
; _WinAPI_KillTimer
; _WinAPI_OpenIcon
; _WinAPI_PostMessage
; _WinAPI_RegisterClass
; _WinAPI_RegisterClassEx
; _WinAPI_RegisterShellHookWindow
; _WinAPI_RegisterWindowMessage
; _WinAPI_SendMessageTimeout
; _WinAPI_SetForegroundWindow
; _WinAPI_SetLayeredWindowAttributes
; _WinAPI_SetMessageExtraInfo
; _WinAPI_SetSysColors
; _WinAPI_SetTimer
; _WinAPI_SetWindowDisplayAffinity
; _WinAPI_SetWindowLong
; _WinAPI_SetClassLongEx
; _WinAPI_SetWindowPlacement
; _WinAPI_ShowOwnedPopups
; _WinAPI_SwitchToThisWindow
; _WinAPI_TileWindows
; _WinAPI_UnregisterClass
; _WinAPI_UpdateLayeredWindow
; _WinAPI_UpdateLayeredWindowEx
; _WinAPI_UpdateLayeredWindowIndirect
; _WinAPI_WindowFromPoint
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagFLASHWINFO
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagFLASHWINFO
; Description ...: Contains the flash status for a window and the number of times the system should flash the window
; Fields ........: Size    - The size of the structure, in bytes
;                  hWnd    - A handle to the window to be flashed. The window can be either opened or minimized.
;                  Flags   - The flash status. This parameter can be one or more of the following values:
;                  |$FLASHW_ALL       - Flash both the window caption and taskbar button
;                  |$FLASHW_CAPTION   - Flash the window caption
;                  |$FLASHW_STOP      - Stop flashing
;                  |$FLASHW_TIMER     - Flash continuously, until the $FLASHW_STOP flag is set
;                  |$FLASHW_TIMERNOFG - Flash continuously until the window comes to the foreground
;                  |$FLASHW_TRAY      - Flash the taskbar button
;                  Count   - The number of times to flash the window
;                  Timeout - The rate at which the window is to be flashed, in milliseconds
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: Needs Constants.au3 for pre-defined constants
; ===============================================================================================================================
Global Const $tagFLASHWINFO = "uint Size;hwnd hWnd;dword Flags;uint Count;dword TimeOut"

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AdjustWindowRectEx(ByRef $tRECT, $iStyle, $iExStyle = 0, $bMenu = False)
	Local $aRet = DllCall('user32.dll', 'bool', 'AdjustWindowRectEx', 'struct*', $tRECT, 'dword', $iStyle, 'bool', $bMenu, _
			'dword', $iExStyle)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AdjustWindowRectEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AnimateWindow($hWnd, $iFlags, $iDuration = 1000)
	Local $aRet = DllCall('user32.dll', 'bool', 'AnimateWindow', 'hwnd', $hWnd, 'dword', $iDuration, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AnimateWindow

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_BeginDeferWindowPos($iAmount = 1)
	Local $aRet = DllCall('user32.dll', 'handle', 'BeginDeferWindowPos', 'int', $iAmount)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginDeferWindowPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BringWindowToTop($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'BringWindowToTop', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BringWindowToTop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BroadcastSystemMessage($iMsg, $wParam = 0, $lParam = 0, $iFlags = 0, $iRecipients = 0)
	Local $aRet = DllCall('user32.dll', 'long', 'BroadcastSystemMessageW', 'dword', $iFlags, 'dword*', $iRecipients, _
			'uint', $iMsg, 'wparam', $wParam, 'lparam', $lParam)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, 0)

	Return SetExtended($aRet[2], $aRet[0])
EndFunc   ;==>_WinAPI_BroadcastSystemMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Siao
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CallWindowProc($pPrevWndFunc, $hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "CallWindowProc", "ptr", $pPrevWndFunc, "hwnd", $hWnd, "uint", $iMsg, _
			"wparam", $wParam, "lparam", $lParam)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CallWindowProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CallWindowProcW($pPrevWndProc, $hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('user32.dll', 'lresult', 'CallWindowProcW', 'ptr', $pPrevWndProc, 'hwnd', $hWnd, 'uint', $iMsg, _
			'wparam', $wParam, 'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CallWindowProcW

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CascadeWindows($aWnds, $tRECT = 0, $hParent = 0, $iFlags = 0, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aWnds, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $iCount = $iEnd - $iStart + 1
	Local $tWnds = DllStructCreate('hwnd[' & $iCount & ']')

	$iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tWnds, 1, $aWnds[$i], $iCount)
		$iCount += 1
	Next

	Local $aRet = DllCall('user32.dll', 'word', 'CascadeWindows', 'hwnd', $hParent, 'uint', $iFlags, 'struct*', $tRECT, _
			'uint', $iCount - 1, 'struct*', $tWnds)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CascadeWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ChangeWindowMessageFilterEx($hWnd, $iMsg, $iAction)
	Local $tCFS, $aRet

	If $hWnd And ($__WINVER > 0x0600) Then
		Local Const $tagCHANGEFILTERSTRUCT = 'dword cbSize; dword ExtStatus'
		$tCFS = DllStructCreate($tagCHANGEFILTERSTRUCT)
		DllStructSetData($tCFS, 1, DllStructGetSize($tCFS))
		$aRet = DllCall('user32.dll', 'bool', 'ChangeWindowMessageFilterEx', 'hwnd', $hWnd, 'uint', $iMsg, 'dword', $iAction, _
				'struct*', $tCFS)
	Else
		$tCFS = 0
		$aRet = DllCall('user32.dll', 'bool', 'ChangeWindowMessageFilter', 'uint', $iMsg, 'dword', $iAction)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return SetExtended(DllStructGetData($tCFS, 2), 1)
EndFunc   ;==>_WinAPI_ChangeWindowMessageFilterEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ChildWindowFromPointEx($hWnd, $tPOINT, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'ChildWindowFromPointEx', 'hwnd', $hWnd, 'struct', $tPOINT, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ChildWindowFromPointEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseWindow

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_DeferWindowPos($hInfo, $hWnd, $hAfter, $iX, $iY, $iWidth, $iHeight, $iFlags)
	Local $aRet = DllCall('user32.dll', 'handle', 'DeferWindowPos', 'handle', $hInfo, 'hwnd', $hWnd, 'hwnd', $hAfter, _
			'int', $iX, 'int', $iY, 'int', $iWidth, 'int', $iHeight, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeferWindowPos

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DefWindowProc($hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "DefWindowProc", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, _
			"lparam", $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DefWindowProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DefWindowProcW($hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('user32.dll', 'lresult', 'DefWindowProcW', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DefWindowProcW

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DeregisterShellHookWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'DeregisterShellHookWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeregisterShellHookWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragAcceptFiles($hWnd, $bAccept = True)
	DllCall('shell32.dll', 'none', 'DragAcceptFiles', 'hwnd', $hWnd, 'bool', $bAccept)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DragAcceptFiles

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragFinish($hDrop)
	DllCall('shell32.dll', 'none', 'DragFinish', 'handle', $hDrop)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DragFinish

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragQueryFileEx($hDrop, $iFlag = 0)
	Local $aRet = DllCall('shell32.dll', 'uint', 'DragQueryFileW', 'handle', $hDrop, 'uint', -1, 'ptr', 0, 'uint', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aRet[0] Then Return SetError(10, 0, 0)

	Local $iCount = $aRet[0]
	Local $aResult[$iCount + 1]
	For $i = 0 To $iCount - 1
		$aRet = DllCall('shell32.dll', 'uint', 'DragQueryFileW', 'handle', $hDrop, 'uint', $i, 'wstr', '', 'uint', 4096)
		If Not $aRet[0] Then Return SetError(11, 0, 0)
		If $iFlag Then
			Local $bDir = _WinAPI_PathIsDirectory($aRet[3])
			If (($iFlag = 1) And $bDir) Or (($iFlag = 2) And Not $bDir) Then
				ContinueLoop
			EndIf
		EndIf
		$aResult[$i + 1] = $aRet[3]
		$aResult[0] += 1
	Next
	If Not $aResult[0] Then Return SetError(12, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_DragQueryFileEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragQueryPoint($hDrop)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('shell32.dll', 'bool', 'DragQueryPoint', 'handle', $hDrop, 'struct*', $tPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_DragQueryPoint

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_EndDeferWindowPos($hInfo)
	Local $aRet = DllCall('user32.dll', 'bool', 'EndDeferWindowPos', 'handle', $hInfo)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EndDeferWindowPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumChildWindows($hWnd, $bVisible = True)
	If Not _WinAPI_GetWindow($hWnd, 5) Then Return SetError(2, 0, 0) ; $GW_CHILD

	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'bool', 'hwnd;lparam')

	Dim $__g_vEnum[101][2] = [[0]]
	DllCall('user32.dll', 'bool', 'EnumChildWindows', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $bVisible)
	If @error Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumChildWindows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindWindow($sClassName, $sWindowName)
	Local $aResult = DllCall("user32.dll", "hwnd", "FindWindowW", "wstr", $sClassName, "wstr", $sWindowName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FindWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FlashWindow($hWnd, $bInvert = True)
	Local $aResult = DllCall("user32.dll", "bool", "FlashWindow", "hwnd", $hWnd, "bool", $bInvert)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FlashWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Yoan Roblet (arcker)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FlashWindowEx($hWnd, $iFlags = 3, $iCount = 3, $iTimeout = 0)
	Local $tFlash = DllStructCreate($tagFLASHWINFO)
	Local $iFlash = DllStructGetSize($tFlash)
	Local $iMode = 0
	If BitAND($iFlags, 1) <> 0 Then $iMode = BitOR($iMode, $FLASHW_CAPTION)
	If BitAND($iFlags, 2) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TRAY)
	If BitAND($iFlags, 4) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TIMER)
	If BitAND($iFlags, 8) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TIMERNOFG)
	DllStructSetData($tFlash, "Size", $iFlash)
	DllStructSetData($tFlash, "hWnd", $hWnd)
	DllStructSetData($tFlash, "Flags", $iMode)
	DllStructSetData($tFlash, "Count", $iCount)
	DllStructSetData($tFlash, "Timeout", $iTimeout)
	Local $aResult = DllCall("user32.dll", "bool", "FlashWindowEx", "struct*", $tFlash)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FlashWindowEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetAncestor($hWnd, $iFlags = 1)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetAncestor", "hwnd", $hWnd, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetAncestor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetClassInfoEx($sClass, $hInstance = 0)
	Local $sTypeOfClass = 'ptr'
	If IsString($sClass) Then
		$sTypeOfClass = 'wstr'
	EndIf

	Local $tWNDCLASSEX = DllStructCreate($tagWNDCLASSEX)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetClassInfoExW', 'handle', $hInstance, $sTypeOfClass, $sClass, _
			'struct*', $tWNDCLASSEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tWNDCLASSEX
EndFunc   ;==>_WinAPI_GetClassInfoEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetClassLongEx($hWnd, $iIndex)
	Local $aRet
	If @AutoItX64 Then
		$aRet = DllCall('user32.dll', 'ulong_ptr', 'GetClassLongPtrW', 'hwnd', $hWnd, 'int', $iIndex)
	Else
		$aRet = DllCall('user32.dll', 'dword', 'GetClassLongW', 'hwnd', $hWnd, 'int', $iIndex)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetClassLongEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetClientHeight($hWnd)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")
EndFunc   ;==>_WinAPI_GetClientHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetClientWidth($hWnd)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
EndFunc   ;==>_WinAPI_GetClientWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDlgItem($hWnd, $iItemID)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetDlgItem", "hwnd", $hWnd, "int", $iItemID)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDlgItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetForegroundWindow()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetForegroundWindow")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetForegroundWindow

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_GetGUIThreadInfo($iThreadId)
    Local Const $tagGUITHREADINFO = 'dword Size;dword Flags;hwnd hWndActive;hwnd hWndFocus;hwnd hWndCapture;hwnd hWndMenuOwner;hwnd hWndMoveSize;hwnd hWndCaret;struct rcCaret;long left;long top;long right;long bottom;endstruct'
	Local $tGTI = DllStructCreate($tagGUITHREADINFO)
	DllStructSetData($tGTI, 1, DllStructGetSize($tGTI))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetGUIThreadInfo', 'dword', $iThreadId, 'struct*', $tGTI)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[11]
	For $i = 0 To 10
		$aResult[$i] = DllStructGetData($tGTI, $i + 2)
	Next
	For $i = 9 To 10
		$aResult[$i] -= $aResult[$i - 2]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetGUIThreadInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetLastActivePopup($hWnd)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetLastActivePopup', 'hwnd', $hWnd)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	If $aRet[0] = $hWnd Then Return SetError(1, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetLastActivePopup

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetLayeredWindowAttributes($hWnd, ByRef $iTransColor, ByRef $iTransGUI, $bColorRef = False)
	$iTransColor = -1
	$iTransGUI = -1
	Local $aResult = DllCall("user32.dll", "bool", "GetLayeredWindowAttributes", "hwnd", $hWnd, "INT*", $iTransColor, _
			"byte*", $iTransGUI, "dword*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	If Not $bColorRef Then
		$aResult[2] = Int(BinaryMid($aResult[2], 3, 1) & BinaryMid($aResult[2], 2, 1) & BinaryMid($aResult[2], 1, 1))
	EndIf
	$iTransColor = $aResult[2]
	$iTransGUI = $aResult[3]
	Return $aResult[4]
EndFunc   ;==>_WinAPI_GetLayeredWindowAttributes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetMessageExtraInfo()
	Local $aRet = DllCall('user32.dll', 'lparam', 'GetMessageExtraInfo')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetMessageExtraInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetShellWindow()
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetShellWindow')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetShellWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTopWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetTopWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTopWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowDisplayAffinity($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetWindowDisplayAffinity', 'hwnd', $hWnd, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetWindowDisplayAffinity

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowInfo($hWnd)
	Local $tWINDOWINFO = DllStructCreate($tagWINDOWINFO)
	DllStructSetData($tWINDOWINFO, 'Size', DllStructGetSize($tWINDOWINFO))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetWindowInfo', 'hwnd', $hWnd, 'struct*', $tWINDOWINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tWINDOWINFO
EndFunc   ;==>_WinAPI_GetWindowInfo

; #FUNCTION# ====================================================================================================================
; Author ........: PsaltyDS, with help from Siao and SmOke_N, at www.autoitscript.com/forum
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowPlacement($hWnd)
	; Create struct to receive data
	Local $tWindowPlacement = DllStructCreate($tagWINDOWPLACEMENT)
	DllStructSetData($tWindowPlacement, "length", DllStructGetSize($tWindowPlacement))
	Local $aRet = DllCall("user32.dll", "bool", "GetWindowPlacement", "hwnd", $hWnd, "struct*", $tWindowPlacement)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tWindowPlacement
EndFunc   ;==>_WinAPI_GetWindowPlacement

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsChild($hWnd, $hWndParent)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsChild', 'hwnd', $hWndParent, 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsChild

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsHungAppWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsHungAppWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsHungAppWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsIconic($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsIconic', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsIconic

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsWindowUnicode($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsWindowUnicode', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsWindowUnicode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsZoomed($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsZoomed', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsZoomed

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_KillTimer($hWnd, $iTimerID)
	Local $aRet = DllCall('user32.dll', 'bool', 'KillTimer', 'hwnd', $hWnd, 'uint_ptr', $iTimerID)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_KillTimer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenIcon($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'OpenIcon', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PostMessage($hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, _
			"lparam", $lParam)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_PostMessage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterClass($tWNDCLASS)
	Local $aRet = DllCall('user32.dll', 'word', 'RegisterClassW', 'struct*', $tWNDCLASS)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterClass

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterClassEx($tWNDCLASSEX)
	Local $aRet = DllCall('user32.dll', 'word', 'RegisterClassExW', 'struct*', $tWNDCLASSEX)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterClassEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterShellHookWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterShellHookWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterShellHookWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RegisterWindowMessage($sMessage)
	Local $aResult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMessage)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_RegisterWindowMessage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SendMessageTimeout($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iTimeout = 1000, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'lresult', 'SendMessageTimeoutW', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam, 'uint', $iFlags, 'uint', $iTimeout, 'dword_ptr*', 0)
	If @error Then Return SetError(@error, @extended, -1)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), -1)

	Return $aRet[7]
EndFunc   ;==>_WinAPI_SendMessageTimeout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetClassLongEx($hWnd, $iIndex, $iNewLong)
	Local $aRet
	If @AutoItX64 Then
		$aRet = DllCall('user32.dll', 'ulong_ptr', 'SetClassLongPtrW', 'hwnd', $hWnd, 'int', $iIndex, 'long_ptr', $iNewLong)
	Else
		$aRet = DllCall('user32.dll', 'dword', 'SetClassLongW', 'hwnd', $hWnd, 'int', $iIndex, 'long', $iNewLong)
	EndIf
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetClassLongEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetForegroundWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetForegroundWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetForegroundWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: PsaltyDS
; ===============================================================================================================================
Func _WinAPI_SetLayeredWindowAttributes($hWnd, $iTransColor, $iTransGUI = 255, $iFlags = 0x03, $bColorRef = False)
	If $iFlags = Default Or $iFlags = "" Or $iFlags < 0 Then $iFlags = 0x03
	If Not $bColorRef Then
		$iTransColor = Int(BinaryMid($iTransColor, 3, 1) & BinaryMid($iTransColor, 2, 1) & BinaryMid($iTransColor, 1, 1))
	EndIf
	Local $aResult = DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hWnd, "INT", $iTransColor, _
			"byte", $iTransGUI, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetLayeredWindowAttributes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetMessageExtraInfo($lParam)
	Local $aRet = DllCall('user32.dll', 'lparam', 'SetMessageExtraInfo', 'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetMessageExtraInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetSysColors($vElements, $vColors)
	Local $bIsEArray = IsArray($vElements), $bIsCArray = IsArray($vColors)
	Local $iElementNum

	If Not $bIsCArray And Not $bIsEArray Then
		$iElementNum = 1
	ElseIf $bIsCArray Or $bIsEArray Then
		If Not $bIsCArray Or Not $bIsEArray Then Return SetError(-1, -1, False)
		If UBound($vElements) <> UBound($vColors) Then Return SetError(-1, -1, False)
		$iElementNum = UBound($vElements)
	EndIf

	Local $tElements = DllStructCreate("int Element[" & $iElementNum & "]")
	Local $tColors = DllStructCreate("INT NewColor[" & $iElementNum & "]")

	If Not $bIsEArray Then
		DllStructSetData($tElements, "Element", $vElements, 1)
	Else
		For $x = 0 To $iElementNum - 1
			DllStructSetData($tElements, "Element", $vElements[$x], $x + 1)
		Next
	EndIf

	If Not $bIsCArray Then
		DllStructSetData($tColors, "NewColor", $vColors, 1)
	Else
		For $x = 0 To $iElementNum - 1
			DllStructSetData($tColors, "NewColor", $vColors[$x], $x + 1)
		Next
	EndIf
	Local $aResult = DllCall("user32.dll", "bool", "SetSysColors", "int", $iElementNum, "struct*", $tElements, "struct*", $tColors)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetSysColors

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetTimer($hWnd, $iTimerID, $iElapse, $pTimerFunc)
	Local $aRet = DllCall('user32.dll', 'uint_ptr', 'SetTimer', 'hwnd', $hWnd, 'uint_ptr', $iTimerID, 'uint', $iElapse, _
			'ptr', $pTimerFunc)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetTimer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowDisplayAffinity($hWnd, $iAffinity)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetWindowDisplayAffinity', 'hwnd', $hWnd, 'dword', $iAffinity)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWindowDisplayAffinity

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
	_WinAPI_SetLastError(0) ; as suggested in MSDN
	Local $sFuncName = "SetWindowLongW"
	If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
	Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowLong

; #FUNCTION# ====================================================================================================================
; Author ........: PsaltyDS
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowPlacement($hWnd, $tWindowPlacement)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowPlacement", "hwnd", $hWnd, "struct*", $tWindowPlacement)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowPlacement

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShowOwnedPopups($hWnd, $bShow)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShowOwnedPopups', 'hwnd', $hWnd, 'bool', $bShow)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShowOwnedPopups

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SwitchToThisWindow($hWnd, $bAltTab = False)
	DllCall('user32.dll', 'none', 'SwitchToThisWindow', 'hwnd', $hWnd, 'bool', $bAltTab)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_SwitchToThisWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TileWindows($aWnds, $tRECT = 0, $hParent = 0, $iFlags = 0, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aWnds, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $iCount = $iEnd - $iStart + 1
	Local $tWnds = DllStructCreate('hwnd[' & $iCount & ']')
	$iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tWnds, 1, $aWnds[$i], $iCount)
		$iCount += 1
	Next

	Local $aRet = DllCall('user32.dll', 'word', 'TileWindows', 'hwnd', $hParent, 'uint', $iFlags, 'struct*', $tRECT, _
			'uint', $iCount - 1, 'struct*', $tWnds)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TileWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterClass($sClass, $hInstance = 0)
	Local $sTypeOfClass = 'ptr'
	If IsString($sClass) Then
		$sTypeOfClass = 'wstr'
	EndIf

	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterClassW', $sTypeOfClass, $sClass, 'handle', $hInstance)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnregisterClass

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UpdateLayeredWindow($hWnd, $hDestDC, $tPTDest, $tSize, $hSrcDC, $tPTSrce, $iRGB, $tBlend, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "UpdateLayeredWindow", "hwnd", $hWnd, "handle", $hDestDC, "struct*", $tPTDest, _
			"struct*", $tSize, "handle", $hSrcDC, "struct*", $tPTSrce, "dword", $iRGB, "struct*", $tBlend, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_UpdateLayeredWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_UpdateLayeredWindowEx($hWnd, $iX, $iY, $hBitmap, $iOpacity = 255, $bDelete = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'GetDC', 'hwnd', $hWnd)
	Local $hDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $hDC)
	Local $hDestDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hBitmap)
	Local $hDestSv = $aRet[0]
	Local $tPOINT
	If ($iX = -1) And ($iY = -1) Then
		$tPOINT = DllStructCreate('int;int')
	Else
		$tPOINT = DllStructCreate('int;int;int;int')
		DllStructSetData($tPOINT, 3, $iX)
		DllStructSetData($tPOINT, 4, $iY)
	EndIf
	DllStructSetData($tPOINT, 1, 0)
	DllStructSetData($tPOINT, 2, 0)
	Local $tBLENDFUNCTION = DllStructCreate($tagBLENDFUNCTION)
	DllStructSetData($tBLENDFUNCTION, 1, 0)
	DllStructSetData($tBLENDFUNCTION, 2, 0)
	DllStructSetData($tBLENDFUNCTION, 3, $iOpacity)
	DllStructSetData($tBLENDFUNCTION, 4, 1)

	Local Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
	Local $tObj = DllStructCreate($tagBITMAP)
	DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
;~ 	Return _WinAPI_CreateSize(DllStructGetData($tObj, 'bmWidth'), DllStructGetData($tObj, 'bmHeight'))
;~ Local $tSIZE = _WinAPI_GetBitmapDimension($hBitmap)
	Local $tSize = DllStructCreate($tagSIZE, DllStructGetPtr($tObj, "bmWidth"))

	$aRet = DllCall('user32.dll', 'bool', 'UpdateLayeredWindow', 'hwnd', $hWnd, 'handle', $hDC, 'ptr', DllStructGetPtr($tPOINT, 3), _
			'struct*', $tSIZE, 'handle', $hDestDC, 'struct*', $tPOINT, 'dword', 0, 'struct*', $tBLENDFUNCTION, 'dword', 0x02)
	Local $iError = @error
	DllCall('user32.dll', 'bool', 'ReleaseDC', 'hwnd', $hWnd, 'handle', $hDC)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hDestSv)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hDestDC)
	If $iError Then Return SetError($iError, 0, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	If $bDelete Then
		DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hBitmap)
	EndIf
	Return $aRet[0]
EndFunc   ;==>_WinAPI_UpdateLayeredWindowEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UpdateLayeredWindowIndirect($hWnd, $tULWINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'UpdateLayeredWindowIndirect', 'hwnd', $hWnd, 'struct*', $tULWINFO)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UpdateLayeredWindowIndirect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, trancexx
; ===============================================================================================================================
Func _WinAPI_WindowFromPoint(ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "hwnd", "WindowFromPoint", "struct", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WindowFromPoint

#EndRegion Public Functions

#Region Internal Functions

Func __EnumDefaultProc($pData, $lParam)
	#forceref $lParam

	Local $iLength = _WinAPI_StrLen($pData)
	__Inc($__g_vEnum)
	If $iLength Then
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $pData), 1)
	Else
		$__g_vEnum[$__g_vEnum[0]] = ''
	EndIf
	Return 1
EndFunc   ;==>__EnumDefaultProc

#EndRegion Internal Functions
