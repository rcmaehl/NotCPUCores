#include-once

#include "StringConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: String
; AutoIt Version : 3.3.14.5
; Description ...: Functions that assist with String management.
; Author(s) .....: Jarvis Stubblefield, SmOke_N, Valik, Wes Wolfe-Wolvereness, WeaponX, Louis Horvath, JdeB, Jeremy Landes, Jon, jchd, BrewManNH, guinness
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _HexToString
; _StringBetween
; _StringExplode
; _StringInsert
; _StringProper
; _StringRepeat
; _StringTitleCase
; _StringToHex
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Jarvis Stubblefield
; Modified.......: SmOke_N - (Re-write using BinaryToString for speed)
; ===============================================================================================================================
Func _HexToString($sHex)
	If Not (StringLeft($sHex, 2) == "0x") Then $sHex = "0x" & $sHex
	Return BinaryToString($sHex, $SB_UTF8)
EndFunc   ;==>_HexToString

; #FUNCTION# ====================================================================================================================
; Author ........: SmOke_N (Thanks to Valik for helping with the new StringRegExp (?s)(?i) issue)
; Modified.......: SmOke_N - (Re-write for speed and accuracy), jchd, Melba23 (added mode)
; ===============================================================================================================================
Func _StringBetween($sString, $sStart, $sEnd, $iMode = $STR_ENDISSTART, $bCase = False)
	; If starting from beginning of string
	$sStart = $sStart ? "\Q" & $sStart & "\E" : "\A"

	; Set mode
	If $iMode <> $STR_ENDNOTSTART Then $iMode = $STR_ENDISSTART

	; If ending at end of string
	If $iMode = $STR_ENDISSTART Then
		; Use lookahead
		$sEnd = $sEnd ? "(?=\Q" & $sEnd & "\E)" : "\z"
	Else
		; Capture end string
		$sEnd = $sEnd ? "\Q" & $sEnd & "\E" : "\z"
	EndIf

	; Set correct case sensitivity
	If $bCase = Default Then
		$bCase = False
	EndIf

	Local $aReturn = StringRegExp($sString, "(?s" & (Not $bCase ? "i" : "") & ")" & $sStart & "(.*?)" & $sEnd, $STR_REGEXPARRAYGLOBALMATCH)
	If @error Then Return SetError(1, 0, 0)
	Return $aReturn
EndFunc   ;==>_StringBetween

; #FUNCTION# ====================================================================================================================
; Author ........: WeaponX
; Modified.......:
; ===============================================================================================================================
Func _StringExplode($sString, $sDelimiter, $iLimit = 0)
	If $iLimit = Default Then $iLimit = 0
	If $iLimit > 0 Then
		Local Const $NULL = Chr(0) ; Different from the Null keyword.

		; Replace delimiter with NULL character using given limit
		$sString = StringReplace($sString, $sDelimiter, $NULL, $iLimit)

		; Split on NULL character, this will leave the remainder in the last element
		$sDelimiter = $NULL
	ElseIf $iLimit < 0 Then
		; Find delimiter occurence from right-to-left
		Local $iIndex = StringInStr($sString, $sDelimiter, $STR_NOCASESENSEBASIC, $iLimit)
		If $iIndex Then
			; Split on left side of string only
			$sString = StringLeft($sString, $iIndex - 1)
		EndIf
	EndIf
	Return StringSplit($sString, $sDelimiter, BItOR($STR_ENTIRESPLIT, $STR_NOCOUNT))
EndFunc   ;==>_StringExplode

; #FUNCTION# ====================================================================================================================
; Author ........: Louis Horvath <celeri at videotron dot ca>
; Modified.......: jchd - Removed explicitly checking if the source and insert strings were strings and forcing an @error return value, czardas - re-write for optimization
; ===============================================================================================================================
Func _StringInsert($sString, $sInsertion, $iPosition)
	; Retrieve the length of the source string
	Local $iLength = StringLen($sString)
	; Casting Int() takes care of String/Int, Numbers
	$iPosition = Int($iPosition)
	; Adjust the position to accomodate negative values (insertion from the right)
	If $iPosition < 0 Then $iPosition = $iLength + $iPosition
	; Check the insert position is within bounds
	If $iLength < $iPosition Or $iPosition < 0 Then Return SetError(1, 0, $sString)
	; Insert the string
	Return StringLeft($sString, $iPosition) & $sInsertion & StringRight($sString, $iLength - $iPosition)
EndFunc   ;==>_StringInsert

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......:
; ===============================================================================================================================
Func _StringProper($sString)
	Local $bCapNext = True, $sChr = "", $sReturn = ""
	For $i = 1 To StringLen($sString)
		$sChr = StringMid($sString, $i, 1)
		Select
			Case $bCapNext = True
				If StringRegExp($sChr, '[a-zA-ZÀ-ÿšœžŸ]') Then
					$sChr = StringUpper($sChr)
					$bCapNext = False
				EndIf
			Case Not StringRegExp($sChr, '[a-zA-ZÀ-ÿšœžŸ]')
				$bCapNext = True
			Case Else
				$sChr = StringLower($sChr)
		EndSelect
		$sReturn &= $sChr
	Next
	Return $sReturn
EndFunc   ;==>_StringProper

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......: guinness - Removed Select...EndSelect statement and replaced with an If...EndIf as well as optimised the code.
; ===============================================================================================================================
Func _StringRepeat($sString, $iRepeatCount)
	; Casting Int() takes care of String/Int, Numbers.
	$iRepeatCount = Int($iRepeatCount)
	If $iRepeatCount = 0 Then Return "" ; Return a blank string if the repeat count is zero.
	; Zero is a valid repeat integer.
	If StringLen($sString) < 1 Or $iRepeatCount < 0 Then Return SetError(1, 0, "")
	Local $sResult = ""
	While $iRepeatCount > 1
		If BitAND($iRepeatCount, 1) Then $sResult &= $sString
		$sString &= $sString
		$iRepeatCount = BitShift($iRepeatCount, 1)
	WEnd
	Return $sString & $sResult
EndFunc   ;==>_StringRepeat

; #FUNCTION# ====================================================================================================================
; Author ........: BrewManNH
; Modified ......:
; ===============================================================================================================================
Func _StringTitleCase($sString)
	Local $bCapNext = True, $sChr = "", $sReturn = ""
	For $i = 1 To StringLen($sString)
		$sChr = StringMid($sString, $i, 1)
		Select
			Case $bCapNext = True
				If StringRegExp($sChr, "[a-zA-Z\xC0-\xFF0-9]") Then
					$sChr = StringUpper($sChr)
					$bCapNext = False
				EndIf
			Case Not StringRegExp($sChr, "[a-zA-Z\xC0-\xFF'0-9]")
				$bCapNext = True
			Case Else
				$sChr = StringLower($sChr)
		EndSelect
		$sReturn &= $sChr
	Next
	Return $sReturn
EndFunc   ;==>_StringTitleCase

; #FUNCTION# ====================================================================================================================
; Author ........: Jarvis Stubblefield
; Modified.......: SmOke_N - (Re-write using StringToBinary for speed)
; ===============================================================================================================================
Func _StringToHex($sString)
	Return Hex(StringToBinary($sString, $SB_UTF8))
EndFunc   ;==>_StringToHex
