#include-once

#include <Array.au3>
#include <GUIEdit.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _BitOr
; Description ...: 64 Bit Implementation of BitOr()
; Syntax ........: _BitOr($iNum1, $iNum2)
; Parameters ....: $iNum1               - an integer value.
;                  $iNum2               - an integer value.
; Return values .: BitOr of $iNum1 and $iNum2
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 12/06/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BitOr($iNum1, $iNum2)

	; Create Arrays of 64 bits
	Local $aNum1[64]
	Local $aNum2[64]
	Local $aNum3[64]
	Local $iTemp = -1
	Local $iIndex = 63

	; Fill Arrays with 0s
	For $iLoop = 0 To 63 Step 1
		$aNum1[$iLoop] = 0
		$aNum2[$iLoop] = 0
		$aNum3[$iLoop] = 0
	Next

	$iTemp = $iNum1
	$iIndex = 0
	Do
		$aNum1[$iIndex] = Mod($iTemp, 2)
		$iTemp = Floor($iTemp / 2)
		$iIndex += 1
	Until $iTemp = 0

	$iTemp = $iNum2
	$iIndex = 0
	Do
		$aNum2[$iIndex] = Mod($iTemp, 2)
		$iTemp = Floor($iTemp / 2)
		$iIndex += 1
	Until $iTemp = 0

	$iTemp = 0
	For $iLoop = 0 To 63 Step 1
		If $aNum1[$iLoop] Or $aNum2[$iLoop] Then $iTemp += 2^$iLoop
	Next

	Return $iTemp

EndFunc

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
		_GUICtrlEdit_LineScroll($hOutput, 0, _GUICtrlEdit_GetLineCount($hOutput))
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