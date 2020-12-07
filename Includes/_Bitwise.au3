#include-once

#include <Array.au3>
#include <AutoItConstants.au3>

Global $_iBits = 48

; #FUNCTION# ====================================================================================================================
; Name ..........: _BitLimit
; Description ...: Sets BitLimts on other UDF functions
; Syntax ........: _BitLimit($iBits)
; Parameters ....: $iBits               - Max Bit Length for _BitAND, _BitNOT, _BitOR, and _BitXOR
; Return values .: None
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 12/07/2020
; Remarks .......: AutoIt uses the SIGNED 64 bit integer limit
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BitLimit($iBits)

	Select

		Case Not IsInt($iBits)

		Case $iBits < 1

		; Bits over 48 have tricky math that needs to be done to avoid Loose Typing shenanigans
		Case $iBits > 48

		Case $iBits > 64

		Case Else
			$_iBits = $iBits

	EndSelect

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _BitAND
; Description ...: Variable Bit Implementation of BitAND()
; Syntax ........: _BitAND($iNum1, $iNum2)
; Parameters ....: $iNum1               - an integer value.
;                  $iNum2               - an integer value.
; Return values .: BitAND of $iNum1 and $iNum2
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 12/07/2020
; Remarks .......: AutoIt uses the SIGNED 64 bit integer limit
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BitAND($iNum1, $iNum2)

	; Create Arrays of bits
	Local $aNum1[$_iBits]
	Local $aNum2[$_iBits]
	Local $iTemp = -1
	Local $iIndex = 0

	; Fill Arrays with 0s
	For $iLoop = 0 To $_iBits - 1 Step 1
		$aNum1[$iLoop] = 0
		$aNum2[$iLoop] = 0
	Next

	$iTemp = $iNum1
	$iIndex = 0
	Do
		$aNum1[$iIndex] = Mod($iTemp, 2)
		$iTemp = Floor($iTemp / 2)
		$iIndex += 1
	Until $iTemp = 1

	$iTemp = $iNum2
	$iIndex = 0
	Do
		$aNum2[$iIndex] = Mod($iTemp, 2)
		$iTemp = Floor($iTemp / 2)
		$iIndex += 1
	Until $iTemp = 0

	$iTemp = 0
	For $iLoop = 0 To $_iBits - 1 Step 1
		If $aNum1[$iLoop] And $aNum2[$iLoop] Then $iTemp += 2^$iLoop
	Next

	Return $iTemp

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BitNOT
; Description ...: Variable Bit Implementation of BitNOT()
; Syntax ........: _BitNOT($iNum1)
; Parameters ....: $iNum1               - an integer value.
; Return values .: BitNOT of $iNum1
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 12/07/2020
; Remarks .......: AutoIt uses the SIGNED 64 bit integer limit
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BitNOT($iNum1)

	; Create Array of bits
	Local $aNum1[$_iBits]
	Local $iTemp = -1
	Local $iIndex = 0

	; Fill Array with 0s
	For $iLoop = 0 To $_iBits - 1 Step 1
		$aNum1[$iLoop] = 0
	Next


	$iTemp = $iNum1
	$iIndex = 0
	Do
		$aNum1[$iIndex] = Mod($iTemp, 2)
		$iTemp = Floor($iTemp / 2)
		$iIndex += 1
	Until $iTemp = 0

	$iTemp = 0
	For $iLoop = 0 To $_iBits - 1 Step 1
		If Not $aNum1[$iLoop] Then $iTemp += 2^$iLoop
	Next

	Return $iTemp

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BitOR
; Description ...: Variable Bit Implementation of BitOR()
; Syntax ........: _BitOR($iNum1, $iNum2)
; Parameters ....: $iNum1               - an integer value.
;                  $iNum2               - an integer value.
; Return values .: BitOR of $iNum1 and $iNum2
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 12/07/2020
; Remarks .......: AutoIt uses the SIGNED 64 bit integer limit
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BitOR($iNum1, $iNum2)

	; Create Arrays of bits
	Local $aNum1[$_iBits]
	Local $aNum2[$_iBits]
	Local $iTemp = -1
	Local $iIndex = 0

	; Fill Arrays with 0s
	For $iLoop = 0 To $_iBits - 1 Step 1
		$aNum1[$iLoop] = 0
		$aNum2[$iLoop] = 0
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
	For $iLoop = 0 To $_iBits - 1 Step 1
		If $aNum1[$iLoop] Or $aNum2[$iLoop] Then $iTemp += 2^$iLoop
	Next

	Return $iTemp

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BitXOR
; Description ...: Variable Bit Implementation of BitXOR()
; Syntax ........: _BitXOR($iNum1, $iNum2)
; Parameters ....: $iNum1               - an integer value.
;                  $iNum2               - an integer value.
; Return values .: BitXOR of $iNum1 and $iNum2
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 12/07/2020
; Remarks .......: AutoIt uses the SIGNED 64 bit integer limit
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _BitXOR($iNum1, $iNum2)

	; Create Arrays of bits
	Local $aNum1[$_iBits]
	Local $aNum2[$_iBits]
	Local $iTemp = -1
	Local $iIndex = 0

	; Fill Arrays with 0s
	For $iLoop = 0 To $_iBits - 1 Step 1
		$aNum1[$iLoop] = 0
		$aNum2[$iLoop] = 0
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
	For $iLoop = 0 To $_iBits - 1 Step 1
		If Not $aNum1[$iLoop] = $aNum2[$iLoop] Then $iTemp += 2^$iLoop
	Next

	Return $iTemp

EndFunc