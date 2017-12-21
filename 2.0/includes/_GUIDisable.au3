#include-once

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
; #INDEX# =======================================================================================================================
; Title .........: _GUIDisable
; AutoIt Version : v3.2.2.0 or higher
; Language ......: English
; Description ...: Creates a dimming effect on the current/selected GUI.
; Note ..........:
; Author(s) .....: guinness
; Remarks .......: Thanks to supersonic for the idea of adjusting the UDF when using Classic themes in Windows Vista+.
; ===============================================================================================================================

; #INCLUDES# ====================================================================================================================
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

; #GLOBAL VARIABLES# ============================================================================================================
Global Enum $__hGUIDisableHWnd, $__hGUIDisableHWndPrevious, $__iGUIDisableMax
Global $__aGUIDisable[$__iGUIDisableMax]

Func _GUIDisable($hWnd, $iAnimate = Default, $iBrightness = Default, $bColor = 0x000000)
	Local Const $AW_SLIDE_IN_TOP = 0x00040004, $AW_SLIDE_OUT_TOP = 0x00050008

	If $iAnimate = Default Then
		$iAnimate = 1
	EndIf
	If $iBrightness = Default Then
		$iBrightness = 5
	EndIf

	If $hWnd = -1 And $__aGUIDisable[$__hGUIDisableHWnd] = 0 Then
		Local $iLabel = GUICtrlCreateLabel('', -99, -99, 1, 1)
		$hWnd = _WinAPI_GetParent(GUICtrlGetHandle($iLabel))
		If @error Then
			Return SetError(1, 0 * GUICtrlDelete($iLabel), 0)
		EndIf
		GUICtrlDelete($iLabel)
	EndIf

	If IsHWnd($__aGUIDisable[$__hGUIDisableHWnd]) Then
		GUIDelete($__aGUIDisable[$__hGUIDisableHWnd])
		GUISwitch($__aGUIDisable[$__hGUIDisableHWndPrevious])
		$__aGUIDisable[$__hGUIDisableHWnd] = 0
		$__aGUIDisable[$__hGUIDisableHWndPrevious] = 0
	Else
		$__aGUIDisable[$__hGUIDisableHWndPrevious] = $hWnd

		Local $iLeft = 0, $iTop = 0
		Local $iStyle = GUIGetStyle($__aGUIDisable[$__hGUIDisableHWndPrevious])
		Local $sCurrentTheme = RegRead('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes', 'CurrentTheme')
		Local $iIsClassicTheme = Number(StringInStr($sCurrentTheme, 'Basic.theme', 2) = 0 And StringInStr($sCurrentTheme, 'Ease of Access Themes', 2) > 0)

		Local $aWinGetPos = WinGetClientSize($__aGUIDisable[$__hGUIDisableHWndPrevious])
		$__aGUIDisable[$__hGUIDisableHWnd] = GUICreate('', $aWinGetPos[0], $aWinGetPos[1], $iLeft + 3, $iTop + 3, $WS_POPUP, $WS_EX_MDICHILD, $__aGUIDisable[$__hGUIDisableHWndPrevious])
		GUISetBkColor($bColor, $__aGUIDisable[$__hGUIDisableHWnd])
		WinSetTrans($__aGUIDisable[$__hGUIDisableHWnd], '', Round($iBrightness * (255 / 100)))
		If not $iAnimate Then
			GUISetState(@SW_SHOW, $__aGUIDisable[$__hGUIDisableHWnd])
		EndIf
		GUISetState(@SW_DISABLE, $__aGUIDisable[$__hGUIDisableHWnd])
		GUISwitch($__aGUIDisable[$__hGUIDisableHWndPrevious])
	EndIf
	Return $__aGUIDisable[$__hGUIDisableHWnd]
EndFunc   ;==>_GUIDisable

; #INTERNAL_USE_ONLY#============================================================================================================
Func __GUIDisable_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $iHeight = _WinAPI_HiWord($ilParam)
	Local $iWidth = _WinAPI_LoWord($ilParam)
	If $hWnd = $__aGUIDisable[$__hGUIDisableHWndPrevious] Then
		Local $iWinGetPos = WinGetPos($__aGUIDisable[$__hGUIDisableHWnd])
		If @error = 0 Then
			WinMove($__aGUIDisable[$__hGUIDisableHWnd], '', $iWinGetPos[0], $iWinGetPos[1], $iWidth, $iHeight)
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>__GUIDisable_WM_SIZE
