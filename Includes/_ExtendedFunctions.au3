#include-once

#include <Array.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _ConsoleWrite
; Description ...: Writes data to the STDOUT stream or GUI handle.
; Syntax ........: _ConsoleWrite($sMessage[, $hOutput = False])
; Parameters ....: $sMessage            - The data you wish to output. This may either be text or binary.
;                  $hOutput             - [optional] Handle of the Console. Default is False, for STDOUT.
; Return values .: The amount of data written. If writing binary, the number of bytes written, if writing text, the number of
;                  characters written.
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 07/07/2020
; Remarks .......:
; Related .......: ConsoleWrite
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ConsoleWrite($sMessage, $hOutput = False)

	If $hOutput = False Then
		ConsoleWrite($sMessage)
	Else
		_GUICtrlEdit_SetSel($hOutput, StringLen(GUICtrlRead($hOutput)), -1)
		GUICtrlSetData($hOutput, $sMessage, True)
	EndIf

	If IsBinary($sMessage) Then
		Return BinaryLen($sMessage)
	Else
		Return StringLen($sMessage)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniRead
; Description ...: Reads a value from a standard format .ini file and only returns Valid results
; Syntax ........: _IniRead($hFile, $sSection, $sKey, $sValid, $sDefault)
; Parameters ....: $hFile               - The filename of the .ini file.
;                  $sSection            - The section name in the .ini file.
;                  $sKey                - The key name in the .ini file.
;                  $sValid              - Valid results separated with Opt("GUIDataSeparatorChar"), blank for allow all
;                  $sDefault            - The default value to return if the requested key is not found.
;                  $bCaseSensitive      - [optional] Should valid matching be case sensitive
; Return values .: Success              - the requested key value as a string.
;                  Failure              - the default string if requested key not found or not Valid
; Author ........: Robert Maehl (rcmaehl)
; Modified ......: 07/07/2020
; Remarks .......:
; Related .......: IniRead
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IniRead($hFile, $sSection, $sKey, $sValid, $sDefault, $bCaseSensitive = False)
	Local $sReturn = IniRead($hFile, $sSection, $sKey, $sDefault)

	If $sValid = "" Then
		Return $sReturn
	Else
		Local $aValid = StringSplit($sValid, Opt("GUIDataSeparatorChar"), $STR_NOCOUNT)
		If _ArraySearch($aValid, $sReturn, 0, 0, $bCaseSensitive) = -1 Then
			Return $sDefault
		Else
			Return $sReturn
		EndIf
	EndIf

EndFunc