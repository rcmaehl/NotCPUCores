#include-once

#include "ProcessConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Process
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist with Process management.
; Author(s) .....: Erifash, Wouter, Matthew Tucker, Jeremy Landes, Valik
; Dll ...........: kernel32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ProcessGetName
; _ProcessGetPriority
; _RunDOS
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Erifash <erifash [at] gmail [dot] com>, Wouter van Kesteren. guinness - Removed ProcessExists for speed.
; ===============================================================================================================================
Func _ProcessGetName($iPID)
	Local $aProcessList = ProcessList()
	For $i = 1 To UBound($aProcessList) - 1
		If $aProcessList[$i][1] = $iPID Then
			Return $aProcessList[$i][0]
		EndIf
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>_ProcessGetName

; #FUNCTION# ====================================================================================================================
; Author ........: Matthew Tucker
; ===============================================================================================================================
Func _ProcessGetPriority($vProcess)
	Local $iError = 0, $iExtended = 0, $iReturn = -1
	Local $iPID = ProcessExists($vProcess)
	If Not $iPID Then Return SetError(1, 0, -1)
	Local $hDLL = DllOpen('kernel32.dll')

	Do ; Pseudo loop
		Local $aProcessHandle = DllCall($hDLL, 'handle', 'OpenProcess', 'dword', $PROCESS_QUERY_INFORMATION, 'bool', False, 'dword', $iPID)
		If @error Then
			$iError = @error + 10
			$iExtended = @extended
			ExitLoop
		EndIf
		If Not $aProcessHandle[0] Then ExitLoop

		Local $aPriority = DllCall($hDLL, 'dword', 'GetPriorityClass', 'handle', $aProcessHandle[0])
		If @error Then
			$iError = @error
			$iExtended = @extended
			; Fall-through so the handle is closed.
		EndIf

		DllCall($hDLL, 'bool', 'CloseHandle', 'handle', $aProcessHandle[0])
		; No need to test @error.

		If $iError Then ExitLoop

		Switch $aPriority[0]
			Case 0x00000040 ; IDLE_PRIORITY_CLASS
				$iReturn = 0
			Case 0x00004000 ; BELOW_NORMAL_PRIORITY_CLASS
				$iReturn = 1
			Case 0x00000020 ; NORMAL_PRIORITY_CLASS
				$iReturn = 2
			Case 0x00008000 ; ABOVE_NORMAL_PRIORITY_CLASS
				$iReturn = 3
			Case 0x00000080 ; HIGH_PRIORITY_CLASS
				$iReturn = 4
			Case 0x00000100 ; REALTIME_PRIORITY_CLASS
				$iReturn = 5
			Case Else
				$iError = 1
				$iExtended = $aPriority[0]
				$iReturn = -1
		EndSwitch
	Until True ; Executes once
	DllClose($hDLL)
	Return SetError($iError, $iExtended, $iReturn)
EndFunc   ;==>_ProcessGetPriority

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; ===============================================================================================================================
Func _RunDos($sCommand)
	Local $iResult = RunWait(@ComSpec & " /C " & $sCommand, "", @SW_HIDE)
	Return SetError(@error, @extended, $iResult)
EndFunc   ;==>_RunDos
