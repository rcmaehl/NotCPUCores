#include-once

#include "MsgBoxConstants.au3"
#include "StringConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Windows API
; AutoIt Version : 3.3.14.5
; Description ...: Windows API calls that have been translated to AutoIt functions.
; Author(s) .....: Paul Campbell (PaulIA)
; Dll ...........: kernel32.dll
; ===============================================================================================================================

#Region Global Variables and Constants

; #CONSTANTS# ===================================================================================================================

; FormatMessage Constants
Global Const $FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100
Global Const $FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200
Global Const $FORMAT_MESSAGE_FROM_STRING = 0x00000400
Global Const $FORMAT_MESSAGE_FROM_HMODULE = 0x00000800
Global Const $FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000
Global Const $FORMAT_MESSAGE_ARGUMENT_ARRAY = 0x00002000
; ===============================================================================================================================
#EndRegion Global Variables and Constants

; #CURRENT# =====================================================================================================================
; _WinAPI_Beep
; _WinAPI_FormatMessage
; _WinAPI_GetErrorMessage
; _WinAPI_GetLastError
; _WinAPI_GetLastErrorMessage
; _WinAPI_MessageBeep
; _WinAPI_MsgBox
; _WinAPI_SetLastError
; _WinAPI_ShowError
; _WinAPI_ShowLastError
; _WinAPI_ShowMsg
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_Beep($iFreq = 500, $iDuration = 1000)
	Local $aResult = DllCall("kernel32.dll", "bool", "Beep", "dword", $iFreq, "dword", $iDuration)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_Beep

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, ByRef $pBuffer, $iSize, $vArguments)
	Local $sBufferType = "struct*"
	If IsString($pBuffer) Then $sBufferType = "wstr"
	Local $aResult = DllCall("kernel32.dll", "dword", "FormatMessageW", "dword", $iFlags, "struct*", $pSource, "dword", $iMessageID, _
			"dword", $iLanguageID, $sBufferType, $pBuffer, "dword", $iSize, "ptr", $vArguments)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	If $sBufferType = "wstr" Then $pBuffer = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_FormatMessage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetErrorMessage($iCode, $iLanguage = 0, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'FormatMessageW', 'dword', 0x1000, 'ptr', 0, 'dword', $iCode, _
			'dword', $iLanguage, 'wstr', '', 'dword', 4096, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return SetError($_iCurrentError, $_iCurrentExtended, StringRegExpReplace($aRet[5], '[' & @LF & ',' & @CR & ']*\Z', ''))
EndFunc   ;==>_WinAPI_GetErrorMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc   ;==>_WinAPI_GetLastError

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm, danielkza, Valik
; ===============================================================================================================================
Func _WinAPI_GetLastErrorMessage(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $iLastError = _WinAPI_GetLastError()
	Local $tBufferPtr = DllStructCreate("ptr")

	Local $nCount = _WinAPI_FormatMessage(BitOR($FORMAT_MESSAGE_ALLOCATE_BUFFER, $FORMAT_MESSAGE_FROM_SYSTEM), _
			0, $iLastError, 0, $tBufferPtr, 0, 0)
	If @error Then Return SetError(-@error, @extended, "")

	Local $sText = ""
	Local $pBuffer = DllStructGetData($tBufferPtr, 1)
	If $pBuffer Then
		If $nCount > 0 Then
			Local $tBuffer = DllStructCreate("wchar[" & ($nCount + 1) & "]", $pBuffer)
			$sText = DllStructGetData($tBuffer, 1)
			If StringRight($sText, 2) = @CRLF Then $sText = StringTrimRight($sText, 2)
		EndIf
		; _WinAPI_LocalFree($pBuffer)
		DllCall("kernel32.dll", "handle", "LocalFree", "handle", $pBuffer)
	EndIf

	Return SetError($_iCurrentError, $_iCurrentExtended, $sText)
EndFunc   ;==>_WinAPI_GetLastErrorMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MessageBeep($iType = 1)
	Local $iSound
	Switch $iType
		Case 1
			$iSound = 0
		Case 2
			$iSound = 16
		Case 3
			$iSound = 32
		Case 4
			$iSound = 48
		Case 5
			$iSound = 64
		Case Else
			$iSound = -1
	EndSwitch

	Local $aResult = DllCall("user32.dll", "bool", "MessageBeep", "uint", $iSound)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MessageBeep

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MsgBox($iFlags, $sTitle, $sText)
	BlockInput(0)
	MsgBox($iFlags, $sTitle, $sText & "      ")
EndFunc   ;==>_WinAPI_MsgBox

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetLastError($iErrorCode, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	DllCall("kernel32.dll", "none", "SetLastError", "dword", $iErrorCode)
	Return SetError($_iCurrentError, $_iCurrentExtended, Null)
EndFunc   ;==>_WinAPI_SetLastError

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowError($sText, $bExit = True)
	BlockInput(0)
	MsgBox($MB_SYSTEMMODAL, "Error", $sText & "      ")
	If $bExit Then Exit
EndFunc   ;==>_WinAPI_ShowError

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShowLastError($sText = '', $bAbort = False, $iLanguage = 0, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $sError

	Local $iLastError = _WinAPI_GetLastError()
	While 1
		$sError = _WinAPI_GetErrorMessage($iLastError, $iLanguage)
		If @error And $iLanguage Then
			$iLanguage = 0
		Else
			ExitLoop
		EndIf
	WEnd
	If StringStripWS($sText, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sText &= @CRLF & @CRLF
	Else
		$sText = ''
	EndIf
	_WinAPI_MsgBox(BitOR(0x00040000, BitShift(0x00000010, -2 * (Not $iLastError))), $iLastError, $sText & $sError)
	If $iLastError Then
		_WinAPI_SetLastError($iLastError)
		If $bAbort Then
			Exit $iLastError
		EndIf
	EndIf

	Return SetError($_iCurrentError, $_iCurrentExtended, 1)
EndFunc   ;==>_WinAPI_ShowLastError

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowMsg($sText)
	_WinAPI_MsgBox($MB_SYSTEMMODAL, "Information", $sText)
EndFunc   ;==>_WinAPI_ShowMsg

; #INTERNAL_USE_ONLY#============================================================================================================
; Name ..........: __COMErrorFormating
; Description ...: Called when a COM error occurs and writes the error message with _DebugOut().
; Syntax ........: __COMErrorFormating(Byref $oCOMError[, $sPrefix = @TAB])
; Parameters ....: $oCOMError - [in/out] COM Error object.
;                  $sPrefix - string to prefix each line. Default is @TAB.
; Return values .: $sError
; Author ........: water
; Modified ......: jpm, mLipok
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __COMErrorFormating(ByRef $oCOMError, $sPrefix = @TAB)
	Local Const $STR_STRIPTRAILING = 2 ; to avoid include just for one constant
	Local $sError = "COM Error encountered in " & @ScriptName & " (" & $oCOMError.Scriptline & ") :" & @CRLF & _
			$sPrefix & "Number        " & @TAB & "= 0x" & Hex($oCOMError.Number, 8) & " (" & $oCOMError.Number & ")" & @CRLF & _
			$sPrefix & "WinDescription" & @TAB & "= " & StringStripWS($oCOMError.WinDescription, $STR_STRIPTRAILING) & @CRLF & _
			$sPrefix & "Description   " & @TAB & "= " & StringStripWS($oCOMError.Description, $STR_STRIPTRAILING) & @CRLF & _
			$sPrefix & "Source        " & @TAB & "= " & $oCOMError.Source & @CRLF & _
			$sPrefix & "HelpFile      " & @TAB & "= " & $oCOMError.HelpFile & @CRLF & _
			$sPrefix & "HelpContext   " & @TAB & "= " & $oCOMError.HelpContext & @CRLF & _
			$sPrefix & "LastDllError  " & @TAB & "= " & $oCOMError.LastDllError & @CRLF & _
			$sPrefix & "Retcode       " & @TAB & "= 0x" & Hex($oCOMError.retcode)

	Return $sError
EndFunc   ;==>__COMErrorFormating
