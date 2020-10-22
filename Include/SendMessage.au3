#include-once

; #INDEX# =======================================================================================================================
; Title .........: SendMessage
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist SendMessage calls.
; Author(s) .....: Valik, Gary Frost
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _SendMessage
; _SendMessageA
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Valik
; Modified.......: Gary Frost (GaryFrost) aka gafrost
; ===============================================================================================================================
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
	Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
	Return $aResult
EndFunc   ;==>_SendMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Valik
; Modified.......: Gary Frost (GaryFrost) aka gafrost
; ===============================================================================================================================
Func _SendMessageA($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
	Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageA", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
	Return $aResult
EndFunc   ;==>_SendMessageA
