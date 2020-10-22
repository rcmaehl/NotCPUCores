#include-Once

#include "ArrayDisplayInternals.au3"
#include "AutoItConstants.au3"
#include "MsgBoxConstants.au3"
#include "StringConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Array
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions for manipulating arrays.
; Author(s) .....: JdeB, Erik Pilsits, Ultima, Dale (Klaatu) Thompson, Cephas,randallc, Gary Frost, GEOSoft,
;                  Helias Gerassimou(hgeras), Brian Keene, Michael Michta, gcriaco, LazyCoder, Tylo, David Nuttall,
;                  Adam Moore (redndahead), SmOke_N, litlmike, Valik, Melba23
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ArrayAdd
; _ArrayBinarySearch
; _ArrayColDelete
; _ArrayColInsert
; _ArrayCombinations
; _ArrayConcatenate
; _ArrayDelete
; _ArrayDisplay
; _ArrayExtract
; _ArrayFindAll
; _ArrayInsert
; _ArrayMax
; _ArrayMaxIndex
; _ArrayMin
; _ArrayMinIndex
; _ArrayPermute
; _ArrayPop
; _ArrayPush
; _ArrayReverse
; _ArraySearch
; _ArrayShuffle
; _ArraySort
; _ArraySwap
; _ArrayToClip
; _ArrayToString
; _ArrayTranspose
; _ArrayTrim
; _ArrayUnique
; _Array1DToHistogram
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __Array_Combinations
; __Array_ExeterInternal
; __Array_GetNext
; __Array_GreaterThan
; __Array_LessThan
; __Array_MinMaxIndex
; __Array_StringRepeat
; __ArrayDualPivotSort
; __ArrayQuickSort1D
; __ArrayQuickSort2D
; __ArrayUnique_AutoErrFunc
; ===============================================================================================================================

; #GLOBAL CONSTANTS# ============================================================================================================
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, _
		$ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Global Enum $ARRAYUNIQUE_NOCOUNT, $ARRAYUNIQUE_COUNT
Global Enum $ARRAYUNIQUE_AUTO, $ARRAYUNIQUE_FORCE32, $ARRAYUNIQUE_FORCE64, $ARRAYUNIQUE_MATCH, $ARRAYUNIQUE_DISTINCT
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Jos
; Modified.......: Ultima - code cleanup; Melba23 - added 2D support & multiple addition
; ===============================================================================================================================
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)

	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
		Case $ARRAYFILL_FORCE_BOOLEAN
			$hDataType = "Boolean"
	EndSwitch
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + 1]
				$aArray[$iDim_1] = $vValue
				Return $iDim_1
			EndIf
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
			Else
				Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				If UBound($aTmp, $UBOUND_ROWS) = 1 Then
					$aTmp[0] = $vValue
				EndIf
				$vValue = $aTmp
			EndIf
			Local $iAdd = UBound($vValue, $UBOUND_ROWS)
			ReDim $aArray[$iDim_1 + $iAdd]
			For $i = 0 To $iAdd - 1
				If String($hDataType) = "Boolean" Then
					Switch $vValue[$i]
						Case "True", "1"
							$aArray[$iDim_1 + $i] = True
						Case "False", "0", ""
							$aArray[$iDim_1 + $i] = False
					EndSwitch

				ElseIf IsFunc($hDataType) Then
					$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
				Else
					$aArray[$iDim_1 + $i] = $vValue[$i]
				EndIf
			Next
			Return $iDim_1 + $iAdd - 1
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
			Local $iValDim_1, $iValDim_2 = 0, $iColCount
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
				$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
				$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
				$hDataType = 0
			Else
				; Convert string to 2D array
				Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
				Local $aTmp[$iValDim_1][0], $aSplit_2
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
					$iColCount = UBound($aSplit_2)
					If $iColCount > $iValDim_2 Then
						; Increase array size to fit max number of items on line
						$iValDim_2 = $iColCount
						ReDim $aTmp[$iValDim_1][$iValDim_2]
					EndIf
					For $j = 0 To $iColCount - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
					Next
				Next
				$vValue = $aTmp
			EndIf
			; Check if too many columns to fit
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
			For $iWriteTo_Index = 0 To $iValDim_1 - 1
				For $j = 0 To $iDim_2 - 1
					If $j < $iStart Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					ElseIf $j - $iStart > $iValDim_2 - 1 Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					Else
						If String($hDataType) = "Boolean" Then
							Switch $vValue[$iWriteTo_Index][$j - $iStart]
								Case "True", "1"
									$aArray[$iWriteTo_Index + $iDim_1][$j] = True
								Case "False", "0", ""
									$aArray[$iWriteTo_Index + $iDim_1][$j] = False
							EndSwitch

						ElseIf IsFunc($hDataType) Then
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
						Else
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
						EndIf
					EndIf
				Next
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return UBound($aArray, $UBOUND_ROWS) - 1

EndFunc   ;==>_ArrayAdd

; #FUNCTION# ====================================================================================================================
; Author ........: Jos
; Modified.......: Ultima - added $iEnd as parameter, code cleanup; Melba23 - added support for empty & 2D arrays
; ===============================================================================================================================
Func _ArrayBinarySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iColumn = 0)

	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iColumn = Default Then $iColumn = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)

	; Bounds checking
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	If $iDim_1 = 0 Then Return SetError(6, 0, -1)

	If $iEnd < 1 Or $iEnd > $iDim_1 - 1 Then $iEnd = $iDim_1 - 1
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Local $iMid = Int(($iEnd + $iStart) / 2)

	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $aArray[$iStart] > $vValue Or $aArray[$iEnd] < $vValue Then Return SetError(2, 0, -1)
			; Search
			While $iStart <= $iMid And $vValue <> $aArray[$iMid]
				If $vValue < $aArray[$iMid] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
			If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iColumn < 0 Or $iColumn > $iDim_2 Then Return SetError(7, 0, -1)
			If $aArray[$iStart][$iColumn] > $vValue Or $aArray[$iEnd][$iColumn] < $vValue Then Return SetError(2, 0, -1)
			; Search
			While $iStart <= $iMid And $vValue <> $aArray[$iMid][$iColumn]
				If $vValue < $aArray[$iMid][$iColumn] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
			If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
		Case Else
			Return SetError(5, 0, -1)
	EndSwitch

	Return $iMid
EndFunc   ;==>_ArrayBinarySearch

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _ArrayColDelete(ByRef $aArray, $iColumn, $bConvert = False)

	If $bConvert = Default Then $bConvert = False
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(2, 0, -1)
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
	Switch $iDim_2
		Case 2
			If $iColumn < 0 Or $iColumn > 1 Then Return SetError(3, 0, -1)
			If $bConvert Then
				Local $aTempArray[$iDim_1]
				For $i = 0 To $iDim_1 - 1
					$aTempArray[$i] = $aArray[$i][(Not $iColumn)]
				Next
				$aArray = $aTempArray
			Else
				ContinueCase
			EndIf
		Case Else
			If $iColumn < 0 Or $iColumn > $iDim_2 - 1 Then Return SetError(3, 0, -1)
			For $i = 0 To $iDim_1 - 1
				For $j = $iColumn To $iDim_2 - 2
					$aArray[$i][$j] = $aArray[$i][$j + 1]
				Next
			Next
			ReDim $aArray[$iDim_1][$iDim_2 - 1]
	EndSwitch

	Return UBound($aArray, $UBOUND_COLUMNS)
EndFunc   ;==>_ArrayColDelete

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _ArrayColInsert(ByRef $aArray, $iColumn)

	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			Local $aTempArray[$iDim_1][2]
			Switch $iColumn
				Case 0, 1
					For $i = 0 To $iDim_1 - 1
						$aTempArray[$i][(Not $iColumn)] = $aArray[$i]
					Next
				Case Else
					Return SetError(3, 0, -1)
			EndSwitch
			$aArray = $aTempArray
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iColumn < 0 Or $iColumn > $iDim_2 Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1][$iDim_2 + 1]
			For $i = 0 To $iDim_1 - 1
				For $j = $iDim_2 To $iColumn + 1 Step -1
					$aArray[$i][$j] = $aArray[$i][$j - 1]
				Next
				$aArray[$i][$iColumn] = ""
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return UBound($aArray, $UBOUND_COLUMNS)
EndFunc   ;==>_ArrayColInsert

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; ===============================================================================================================================
Func _ArrayCombinations(Const ByRef $aArray, $iSet, $sDelimiter = "")

	If $sDelimiter = Default Then $sDelimiter = ""
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, 0)

	Local $iN = UBound($aArray)
	Local $iR = $iSet
	Local $aIdx[$iR]
	For $i = 0 To $iR - 1
		$aIdx[$i] = $i
	Next
	Local $iTotal = __Array_Combinations($iN, $iR)
	Local $iLeft = $iTotal
	Local $aResult[$iTotal + 1]
	$aResult[0] = $iTotal

	Local $iCount = 1
	While $iLeft > 0
		__Array_GetNext($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$aResult[$iCount] &= $aArray[$aIdx[$i]] & $sDelimiter
		Next
		If $sDelimiter <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
		$iCount += 1
	WEnd
	Return $aResult
EndFunc   ;==>_ArrayCombinations

; #FUNCTION# ====================================================================================================================
; Author ........: Ultima
; Modified.......: Partypooper - added target start index; Melba23 - add 2D support
; ===============================================================================================================================
Func _ArrayConcatenate(ByRef $aArrayTarget, Const ByRef $aArraySource, $iStart = 0)

	If $iStart = Default Then $iStart = 0
	If Not IsArray($aArrayTarget) Then Return SetError(1, 0, -1)
	If Not IsArray($aArraySource) Then Return SetError(2, 0, -1)
	Local $iDim_Total_Tgt = UBound($aArrayTarget, $UBOUND_DIMENSIONS)
	Local $iDim_Total_Src = UBound($aArraySource, $UBOUND_DIMENSIONS)
	Local $iDim_1_Tgt = UBound($aArrayTarget, $UBOUND_ROWS)
	Local $iDim_1_Src = UBound($aArraySource, $UBOUND_ROWS)
	If $iStart < 0 Or $iStart > $iDim_1_Src - 1 Then Return SetError(6, 0, -1)
	Switch $iDim_Total_Tgt
		Case 1
			If $iDim_Total_Src <> 1 Then Return SetError(4, 0, -1)
			ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart]
			For $i = $iStart To $iDim_1_Src - 1
				$aArrayTarget[$iDim_1_Tgt + $i - $iStart] = $aArraySource[$i]
			Next
		Case 2
			If $iDim_Total_Src <> 2 Then Return SetError(4, 0, -1)
			Local $iDim_2_Tgt = UBound($aArrayTarget, $UBOUND_COLUMNS)
			If UBound($aArraySource, $UBOUND_COLUMNS) <> $iDim_2_Tgt Then Return SetError(5, 0, -1)
			ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart][$iDim_2_Tgt]
			For $i = $iStart To $iDim_1_Src - 1
				For $j = 0 To $iDim_2_Tgt - 1
					$aArrayTarget[$iDim_1_Tgt + $i - $iStart][$j] = $aArraySource[$i][$j]
				Next
			Next
		Case Else
			Return SetError(3, 0, -1)
	EndSwitch
	Return UBound($aArrayTarget, $UBOUND_ROWS)
EndFunc   ;==>_ArrayConcatenate

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos - array passed ByRef, jaberwocky6669, Melba23 - added 2D support & multiple deletion
; ===============================================================================================================================
Func _ArrayDelete(ByRef $aArray, $vRange)

	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
	Else
		; Expand range
		Local $iNumber, $aSplit_1, $aSplit_2
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			; Check for correct range syntax
			If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
			$aSplit_2 = StringSplit($aSplit_1[$i], "-")
			Switch $aSplit_2[0]
				Case 1
					$vRange &= $aSplit_2[1] & ";"
				Case 2
					If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
						$iNumber = $aSplit_2[1] - 1
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
					EndIf
			EndSwitch
		Next
		$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
	EndIf
	If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
	; Remove rows
	Local $iCopyTo_Index = 0
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			; Loop through array flagging elements to be deleted
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]] = ChrW(0xFAB1)
			Next
			; Now copy rows to keep to fill deleted rows
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
					ContinueLoop
				Else
					If $iReadFrom_Index <> $iCopyTo_Index Then
						$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
					EndIf
					$iCopyTo_Index += 1
				EndIf
			Next
			ReDim $aArray[$iDim_1 - $vRange[0] + 1]
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			; Loop through array flagging elements to be deleted
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
			Next
			; Now copy rows to keep to fill deleted rows
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
					ContinueLoop
				Else
					If $iReadFrom_Index <> $iCopyTo_Index Then
						For $j = 0 To $iDim_2
							$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
						Next
					EndIf
					$iCopyTo_Index += 1
				EndIf
			Next
			ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
		Case Else
			Return SetError(2, 0, False)
	EndSwitch

	Return UBound($aArray, $UBOUND_ROWS)

EndFunc   ;==>_ArrayDelete

; #FUNCTION# ====================================================================================================================
; Author ........: randallc, Ultima
; Modified.......: Gary Frost (gafrost), Ultima, Zedna, jpm, Melba23, AZJIO, UEZ
; ===============================================================================================================================
Func _ArrayDisplay(Const ByRef $aArray, $sTitle = Default, $sArrayRange = Default, $iFlags = Default, $vUser_Separator = Default, $sHeader = Default, $iMax_ColWidth = Default)
	#forceref $vUser_Separator
	Local $iRet = __ArrayDisplay_Share($aArray, $sTitle, $sArrayRange, $iFlags, Default, $sHeader, $iMax_ColWidth, 0, False)
	Return SetError(@error, @extended, $iRet)
EndFunc   ;==>_ArrayDisplay

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _ArrayExtract(Const ByRef $aArray, $iStart_Row = -1, $iEnd_Row = -1, $iStart_Col = -1, $iEnd_Col = -1)

	If $iStart_Row = Default Then $iStart_Row = -1
	If $iEnd_Row = Default Then $iEnd_Row = -1
	If $iStart_Col = Default Then $iStart_Col = -1
	If $iEnd_Col = Default Then $iEnd_Col = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
	If $iStart_Row = -1 Then $iStart_Row = 0
	If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			Local $aRetArray[$iEnd_Row - $iStart_Row + 1]
			For $i = 0 To $iEnd_Row - $iStart_Row
				$aRetArray[$i] = $aArray[$i + $iStart_Row]
			Next
			Return $aRetArray
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
			If $iStart_Col = -1 Then $iStart_Col = 0
			If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
			If $iStart_Col = $iEnd_Col Then
				Local $aRetArray[$iEnd_Row - $iStart_Row + 1]
			Else
				Local $aRetArray[$iEnd_Row - $iStart_Row + 1][$iEnd_Col - $iStart_Col + 1]
			EndIf
			For $i = 0 To $iEnd_Row - $iStart_Row
				For $j = 0 To $iEnd_Col - $iStart_Col
					If $iStart_Col = $iEnd_Col Then
						$aRetArray[$i] = $aArray[$i + $iStart_Row][$j + $iStart_Col]
					Else
						$aRetArray[$i][$j] = $aArray[$i + $iStart_Row][$j + $iStart_Col]
					EndIf
				Next
			Next
			Return $aRetArray
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return 1

EndFunc   ;==>_ArrayExtract

; #FUNCTION# ====================================================================================================================
; Author ........: GEOSoft, Ultima
; Modified.......:
; ===============================================================================================================================
Func _ArrayFindAll(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iSubItem = 0, $bRow = False)

	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iCase = Default Then $iCase = 0
	If $iCompare = Default Then $iCompare = 0
	If $iSubItem = Default Then $iSubItem = 0
	If $bRow = Default Then $bRow = False

	$iStart = _ArraySearch($aArray, $vValue, $iStart, $iEnd, $iCase, $iCompare, 1, $iSubItem, $bRow)
	If @error Then Return SetError(@error, 0, -1)

	Local $iIndex = 0, $avResult[UBound($aArray, ($bRow ? $UBOUND_COLUMNS : $UBOUND_ROWS))] ; Set dimension for Column/Row
	Do
		$avResult[$iIndex] = $iStart
		$iIndex += 1
		$iStart = _ArraySearch($aArray, $vValue, $iStart + 1, $iEnd, $iCase, $iCompare, 1, $iSubItem, $bRow)
	Until @error

	ReDim $avResult[$iIndex]
	Return $avResult
EndFunc   ;==>_ArrayFindAll

; #FUNCTION# ====================================================================================================================
; Author ........: Jos
; Modified.......: Ultima - code cleanup; Melba23 - element position check, 2D support & multiple insertions
; ===============================================================================================================================
Func _ArrayInsert(ByRef $aArray, $vRange, $vValue = "", $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)

	If $vValue = Default Then $vValue = ""
	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
	EndSwitch
	Local $aSplit_1, $aSplit_2
	If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
	Else
		; Expand range
		Local $iNumber
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			; Check for correct range syntax
			If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
			$aSplit_2 = StringSplit($aSplit_1[$i], "-")
			Switch $aSplit_2[0]
				Case 1
					$vRange &= $aSplit_2[1] & ";"
				Case 2
					If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
						$iNumber = $aSplit_2[1] - 1
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
					EndIf
			EndSwitch
		Next
		$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
	EndIf
	If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
	For $i = 2 To $vRange[0]
		If $vRange[$i] < $vRange[$i - 1] Then Return SetError(3, 0, -1)
	Next
	Local $iCopyTo_Index = $iDim_1 + $vRange[0]
	Local $iInsertPoint_Index = $vRange[0]
	; Get lowest insert point
	Local $iInsert_Index = $vRange[$iInsertPoint_Index]
	; Insert lines
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + $vRange[0] + 1]
				For $iReadFromIndex = $iDim_1 To 0 Step -1
					; Copy existing elements
					$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
					; Move up array
					$iCopyTo_Index -= 1
					; Get next insert point
					$iInsert_Index = $vRange[$iInsertPoint_Index]
					While $iReadFromIndex = $iInsert_Index
						; Insert new item
						$aArray[$iCopyTo_Index] = $vValue
						; Move up array
						$iCopyTo_Index -= 1
						; Reset insert index
						$iInsertPoint_Index -= 1
						If $iInsertPoint_Index < 1 Then ExitLoop 2
						; Get next insert point
						$iInsert_Index = $vRange[$iInsertPoint_Index]
					WEnd
				Next
				Return $iDim_1 + $vRange[0] + 1
			EndIf
			ReDim $aArray[$iDim_1 + $vRange[0] + 1]
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
			Else
				Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				If UBound($aTmp, $UBOUND_ROWS) = 1 Then
					$aTmp[0] = $vValue
					$hDataType = 0
				EndIf
				$vValue = $aTmp
			EndIf
			For $iReadFromIndex = $iDim_1 To 0 Step -1
				; Copy existing elements
				$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
				; Move up array
				$iCopyTo_Index -= 1
				; Get next insert point
				$iInsert_Index = $vRange[$iInsertPoint_Index]
				While $iReadFromIndex = $iInsert_Index
					; Insert new item
					If $iInsertPoint_Index <= UBound($vValue, $UBOUND_ROWS) Then
						If IsFunc($hDataType) Then
							$aArray[$iCopyTo_Index] = $hDataType($vValue[$iInsertPoint_Index - 1])
						Else
							$aArray[$iCopyTo_Index] = $vValue[$iInsertPoint_Index - 1]
						EndIf
					Else
						$aArray[$iCopyTo_Index] = ""
					EndIf
					; Move up array
					$iCopyTo_Index -= 1
					; Reset insert index
					$iInsertPoint_Index -= 1
					If $iInsertPoint_Index = 0 Then ExitLoop 2
					; Get next insert point
					$iInsert_Index = $vRange[$iInsertPoint_Index]
				WEnd
			Next
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(6, 0, -1)
			Local $iValDim_1, $iValDim_2
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(7, 0, -1)
				$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
				$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
				$hDataType = 0
			Else
				; Convert string to 2D array
				$aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
				StringReplace($aSplit_1[0], $sDelim_Item, "")
				$iValDim_2 = @extended + 1
				Local $aTmp[$iValDim_1][$iValDim_2]
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $j = 0 To $iValDim_2 - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
					Next
				Next
				$vValue = $aTmp
			EndIf
			; Check if too many columns to fit
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(8, 0, -1)
			ReDim $aArray[$iDim_1 + $vRange[0] + 1][$iDim_2]
			For $iReadFromIndex = $iDim_1 To 0 Step -1
				; Copy existing elements
				For $j = 0 To $iDim_2 - 1
					$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFromIndex][$j]
				Next
				; Move up array
				$iCopyTo_Index -= 1
				; Get next insert point
				$iInsert_Index = $vRange[$iInsertPoint_Index]
				While $iReadFromIndex = $iInsert_Index
					; Insert new item
					For $j = 0 To $iDim_2 - 1
						If $j < $iStart Then
							$aArray[$iCopyTo_Index][$j] = ""
						ElseIf $j - $iStart > $iValDim_2 - 1 Then
							$aArray[$iCopyTo_Index][$j] = ""
						Else
							If $iInsertPoint_Index - 1 < $iValDim_1 Then
								If IsFunc($hDataType) Then
									$aArray[$iCopyTo_Index][$j] = $hDataType($vValue[$iInsertPoint_Index - 1][$j - $iStart])
								Else
									$aArray[$iCopyTo_Index][$j] = $vValue[$iInsertPoint_Index - 1][$j - $iStart]
								EndIf
							Else
								$aArray[$iCopyTo_Index][$j] = ""
							EndIf
						EndIf
					Next
					; Move up array
					$iCopyTo_Index -= 1
					; Reset insert index
					$iInsertPoint_Index -= 1
					If $iInsertPoint_Index = 0 Then ExitLoop 2
					; Get next insert point
					$iInsert_Index = $vRange[$iInsertPoint_Index]
				WEnd
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return UBound($aArray, $UBOUND_ROWS)
EndFunc   ;==>_ArrayInsert

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup; Melba23 - Added 2D support
; ===============================================================================================================================
Func _ArrayMax(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)

	Local $iResult = _ArrayMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then
		Return $aArray[$iResult]
	Else
		Return $aArray[$iResult][$iSubItem]
	EndIf
EndFunc   ;==>_ArrayMax

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos - Added $iCompNumeric and $iStart parameters and logic; Melba23 - Added 2D support; guinness - Reduced duplicate code.
; ===============================================================================================================================
Func _ArrayMaxIndex(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)

	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	If $iSubItem = Default Then $iSubItem = 0
	Local $iRet = __Array_MinMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, __Array_GreaterThan) ; Pass a delegate function to check if value1 > value2.
	Return SetError(@error, 0, $iRet)
EndFunc   ;==>_ArrayMaxIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup; Melba23 - Added 2D support
; ===============================================================================================================================
Func _ArrayMin(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)

	Local $iResult = _ArrayMinIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then
		Return $aArray[$iResult]
	Else
		Return $aArray[$iResult][$iSubItem]
	EndIf
EndFunc   ;==>_ArrayMin

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos - Added $iCompNumeric and $iStart parameters and logic; Melba23 - Added 2D support; guinness - Reduced duplicate code.
; ===============================================================================================================================
Func _ArrayMinIndex(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	If $iSubItem = Default Then $iSubItem = 0
	Local $iRet = __Array_MinMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, __Array_LessThan) ; Pass a delegate function to check if value1 < value2.
	Return SetError(@error, 0, $iRet)
EndFunc   ;==>_ArrayMinIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits
; Modified.......: Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayPermute(ByRef $aArray, $sDelimiter = "")

	If $sDelimiter = Default Then $sDelimiter = ""
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, 0)
	Local $iSize = UBound($aArray), $iFactorial = 1, $aIdx[$iSize], $aResult[1], $iCount = 1

	If UBound($aArray) Then
		For $i = 0 To $iSize - 1
			$aIdx[$i] = $i
		Next
		For $i = $iSize To 1 Step -1
			$iFactorial *= $i
		Next
		ReDim $aResult[$iFactorial + 1]
		$aResult[0] = $iFactorial
		__Array_ExeterInternal($aArray, 0, $iSize, $sDelimiter, $aIdx, $aResult, $iCount)
	Else
		$aResult[0] = 0
	EndIf
	Return $aResult
EndFunc   ;==>_ArrayPermute

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Ultima - code cleanup; Melba23 - added support for empty arrays
; ===============================================================================================================================
Func _ArrayPop(ByRef $aArray)
	If (Not IsArray($aArray)) Then Return SetError(1, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, "")

	Local $iUBound = UBound($aArray) - 1
	If $iUBound = -1 Then Return SetError(3, 0, "")
	Local $sLastVal = $aArray[$iUBound]

	; Remove last item
	If $iUBound > -1 Then
		ReDim $aArray[$iUBound]
	EndIf

	; Return last item
	Return $sLastVal
EndFunc   ;==>_ArrayPop

; #FUNCTION# ====================================================================================================================
; Author ........: Helias Gerassimou(hgeras), Ultima - code cleanup/rewrite (major optimization), fixed support for $vValue as an array
; Modified.......:
; ===============================================================================================================================
Func _ArrayPush(ByRef $aArray, $vValue, $iDirection = 0)

	If $iDirection = Default Then $iDirection = 0
	If (Not IsArray($aArray)) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
	Local $iUBound = UBound($aArray) - 1

	If IsArray($vValue) Then ; $vValue is an array
		Local $iUBoundS = UBound($vValue)
		If ($iUBoundS - 1) > $iUBound Then Return SetError(2, 0, 0)

		; $vValue is an array smaller than $aArray
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To $iUBoundS Step -1
				$aArray[$i] = $aArray[$i - $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$aArray[$i] = $vValue[$i]
			Next
		Else ; slide left, add to end
			For $i = 0 To $iUBound - $iUBoundS
				$aArray[$i] = $aArray[$i + $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$aArray[$i + $iUBound - $iUBoundS + 1] = $vValue[$i]
			Next
		EndIf
	Else
		; Check for empty array
		If $iUBound > -1 Then
			If $iDirection Then ; slide right, add to front
				For $i = $iUBound To 1 Step -1
					$aArray[$i] = $aArray[$i - 1]
				Next
				$aArray[0] = $vValue
			Else ; slide left, add to end
				For $i = 0 To $iUBound - 1
					$aArray[$i] = $aArray[$i + 1]
				Next
				$aArray[$iUBound] = $vValue
			EndIf
		EndIf
	EndIf

	Return 1
EndFunc   ;==>_ArrayPush

; #FUNCTION# ====================================================================================================================
; Author ........: Brian Keene
; Modified.......: Jos - added $iStart parameter and logic; Tylo - added $iEnd parameter and rewrote it for speed
; ===============================================================================================================================
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)

	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
	If Not UBound($aArray) Then Return SetError(4, 0, 0)

	Local $vTmp, $iUBound = UBound($aArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Reverse
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		$vTmp = $aArray[$i]
		$aArray[$i] = $aArray[$iEnd]
		$aArray[$iEnd] = $vTmp
		$iEnd -= 1
	Next

	Return 1
EndFunc   ;==>_ArrayReverse

; #FUNCTION# ====================================================================================================================
; Author ........: Michael Michta <MetalGX91 at GMail dot com>
; Modified.......: gcriaco <gcriaco at gmail dot com>; Ultima - 2D arrays supported, directional search, code cleanup, optimization; Melba23 - added support for empty arrays and row search; BrunoJ - Added compare option 3 to use a regex pattern
; ===============================================================================================================================
Func _ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)

	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iCase = Default Then $iCase = 0
	If $iCompare = Default Then $iCompare = 0
	If $iForward = Default Then $iForward = 1
	If $iSubItem = Default Then $iSubItem = -1
	If $bRow = Default Then $bRow = False

	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray) - 1
	If $iDim_1 = -1 Then Return SetError(3, 0, -1)
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1

	; Same var Type of comparison
	Local $bCompType = False
	If $iCompare = 2 Then
		$iCompare = 0
		$bCompType = True
	EndIf
	; Bounds checking
	If $bRow Then
		If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(5, 0, -1)
		If $iEnd < 1 Or $iEnd > $iDim_2 Then $iEnd = $iDim_2
		If $iStart < 0 Then $iStart = 0
		If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Else
		If $iEnd < 1 Or $iEnd > $iDim_1 Then $iEnd = $iDim_1
		If $iStart < 0 Then $iStart = 0
		If $iStart > $iEnd Then Return SetError(4, 0, -1)
	EndIf
	; Direction (flip if $iForward = 0)
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf

	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1 ; 1D array search
			If Not $iCompare Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $aArray[$i] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $aArray[$i] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If $iCompare = 3 Then
						If StringRegExp($aArray[$i], $vValue) Then Return $i
					Else
						If StringInStr($aArray[$i], $vValue, $iCase) > 0 Then Return $i
					EndIf
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iDim_Sub
			If $bRow Then
				; Search rows
				$iDim_Sub = $iDim_1
				If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
				If $iSubItem < 0 Then
					; will search for all Col
					$iSubItem = 0
				Else
					$iDim_Sub = $iSubItem
				EndIf
			Else
				; Search columns
				$iDim_Sub = $iDim_2
				If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
				If $iSubItem < 0 Then
					; will search for all Col
					$iSubItem = 0
				Else
					$iDim_Sub = $iSubItem
				EndIf
			EndIf
			; Now do the search
			For $j = $iSubItem To $iDim_Sub
				If Not $iCompare Then
					If Not $iCase Then
						For $i = $iStart To $iEnd Step $iStep
							If $bRow Then
								If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$j][$i] = $vValue Then Return $i
							Else
								If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$i][$j] = $vValue Then Return $i
							EndIf
						Next
					Else
						For $i = $iStart To $iEnd Step $iStep
							If $bRow Then
								If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$j][$i] == $vValue Then Return $i
							Else
								If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$i][$j] == $vValue Then Return $i
							EndIf
						Next
					EndIf
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $iCompare = 3 Then
							If $bRow Then
								If StringRegExp($aArray[$j][$i], $vValue) Then Return $i
							Else
								If StringRegExp($aArray[$i][$j], $vValue) Then Return $i
							EndIf
						Else
							If $bRow Then
								If StringInStr($aArray[$j][$i], $vValue, $iCase) > 0 Then Return $i
							Else
								If StringInStr($aArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
							EndIf
						EndIf
					Next
				EndIf
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _ArrayShuffle(ByRef $aArray, $iStart_Row = 0, $iEnd_Row = 0, $iCol = -1)

	; Fisher–Yates algorithm

	If $iStart_Row = Default Then $iStart_Row = 0
	If $iEnd_Row = Default Then $iEnd_Row = 0
	If $iCol = Default Then $iCol = -1

	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	If $iEnd_Row = 0 Then $iEnd_Row = $iDim_1 - 1
	If $iStart_Row < 0 Or $iStart_Row > $iDim_1 - 1 Then Return SetError(3, 0, -1)
	If $iEnd_Row < 1 Or $iEnd_Row > $iDim_1 - 1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)

	Local $vTmp, $iRand
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = $iEnd_Row To $iStart_Row + 1 Step -1
				$iRand = Random($iStart_Row, $i, 1)
				$vTmp = $aArray[$i]
				$aArray[$i] = $aArray[$iRand]
				$aArray[$iRand] = $vTmp
			Next
			Return 1
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iCol < -1 Or $iCol > $iDim_2 - 1 Then Return SetError(5, 0, -1)
			Local $iCol_Start, $iCol_End
			If $iCol = -1 Then
				$iCol_Start = 0
				$iCol_End = $iDim_2 - 1
			Else
				$iCol_Start = $iCol
				$iCol_End = $iCol
			EndIf
			For $i = $iEnd_Row To $iStart_Row + 1 Step -1
				$iRand = Random($iStart_Row, $i, 1)
				For $j = $iCol_Start To $iCol_End
					$vTmp = $aArray[$i][$j]
					$aArray[$i][$j] = $aArray[$iRand][$j]
					$aArray[$iRand][$j] = $vTmp
				Next
			Next
			Return 1
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

EndFunc   ;==>_ArrayShuffle

; #FUNCTION# ====================================================================================================================
; Author ........: Jos
; Modified.......: LazyCoder - added $iSubItem option; Tylo - implemented stable QuickSort algo; Jos - changed logic to correctly Sort arrays with mixed Values and Strings; Melba23 - implemented stable pivot algo
; ===============================================================================================================================
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)

	If $iDescending = Default Then $iDescending = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iSubItem = Default Then $iSubItem = 0
	If $iPivot = Default Then $iPivot = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($aArray) - 1
	If $iUBound = -1 Then Return SetError(5, 0, 0)

	; Bounds checking
	If $iEnd = Default Then $iEnd = 0
	If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
	If $iStart < 0 Or $iStart = Default Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Sort
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iPivot Then ; Switch algorithms as required
				__ArrayDualPivotSort($aArray, $iStart, $iEnd)
			Else
				__ArrayQuickSort1D($aArray, $iStart, $iEnd)
			EndIf
			If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
		Case 2
			If $iPivot Then Return SetError(6, 0, 0) ; Error if 2D array and $iPivot
			Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)

			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf

			__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch

	Return 1
EndFunc   ;==>_ArraySort

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayQuickSort1D
; Description ...: Helper function for sorting 1D arrays
; Syntax.........: __ArrayQuickSort1D ( ByRef $aArray, ByRef $iStart, ByRef $iEnd )
; Parameters ....: $aArray - Array to sort
;                  $iStart  - Index of array to start sorting at
;                  $iEnd    - Index of array to stop sorting at
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	Local $vTmp

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $aArray[$i]

			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $aArray[$j]
					; If $vTmp >= $vCur Then ExitLoop
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$aArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step -1
					If (StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
					$aArray[$j + 1] = $aArray[$j]
				Next
			EndIf

			$aArray[$j + 1] = $vTmp
		Next
		Return
	EndIf

	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
	Do
		If $bNum Then
			; While $aArray[$L] < $vPivot
			While ($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or (Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			; While $aArray[$R] > $vPivot
			While ($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or (Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($aArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($aArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			$vTmp = $aArray[$L]
			$aArray[$L] = $aArray[$R]
			$aArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort1D($aArray, $iStart, $R)
	__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc   ;==>__ArrayQuickSort1D

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayQuickSort2D
; Description ...: Helper function for sorting 2D arrays
; Syntax.........: __ArrayQuickSort2D ( ByRef $aArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax )
; Parameters ....: $aArray  - Array to sort
;                  $iStep    - Step size (should be 1 to sort ascending, -1 to sort descending!)
;                  $iStart   - Index of array to start sorting at
;                  $iEnd     - Index of array to stop sorting at
;                  $iSubItem - Sub-index to sort on in 2D arrays
;                  $iSubMax  - Maximum sub-index that array has
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
	If $iEnd <= $iStart Then Return

	; QuickSort
	Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
	Do
		If $bNum Then
			; While $aArray[$L][$iSubItem] < $vPivot
			While ($iStep * ($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or (Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			; While $aArray[$R][$iSubItem] > $vPivot
			While ($iStep * ($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or (Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			For $i = 0 To $iSubMax
				$vTmp = $aArray[$L][$i]
				$aArray[$L][$i] = $aArray[$R][$i]
				$aArray[$R][$i] = $vTmp
			Next
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc   ;==>__ArrayQuickSort2D

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayDualPivotSort
; Description ...: Helper function for sorting 1D arrays
; Syntax.........: __ArrayDualPivotSort ( ByRef $aArray, $iPivot_Left, $iPivot_Right [, $bLeftMost = True ] )
; Parameters ....: $aArray  - Array to sort
;                  $iPivot_Left  - Index of the array to start sorting at
;                  $iPivot_Right - Index of the array to stop sorting at
;                  $bLeftMost    - Indicates if this part is the leftmost in the range
; Return values .: None
; Author ........: Erik Pilsits
; Modified.......: Melba23
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
	If $iPivot_Left > $iPivot_Right Then Return
	Local $iLength = $iPivot_Right - $iPivot_Left + 1
	Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
	If $iLength < 45 Then ; Use insertion sort for small arrays - value chosen empirically
		If $bLeftMost Then
			$i = $iPivot_Left
			While $i < $iPivot_Right
				$j = $i
				$iAi = $aArray[$i + 1]
				While $iAi < $aArray[$j]
					$aArray[$j + 1] = $aArray[$j]
					$j -= 1
					If $j + 1 = $iPivot_Left Then ExitLoop
				WEnd
				$aArray[$j + 1] = $iAi
				$i += 1
			WEnd
		Else
			While 1
				If $iPivot_Left >= $iPivot_Right Then Return 1
				$iPivot_Left += 1
				If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
			WEnd
			While 1
				$k = $iPivot_Left
				$iPivot_Left += 1
				If $iPivot_Left > $iPivot_Right Then ExitLoop
				$iA1 = $aArray[$k]
				$iA2 = $aArray[$iPivot_Left]
				If $iA1 < $iA2 Then
					$iA2 = $iA1
					$iA1 = $aArray[$iPivot_Left]
				EndIf
				$k -= 1
				While $iA1 < $aArray[$k]
					$aArray[$k + 2] = $aArray[$k]
					$k -= 1
				WEnd
				$aArray[$k + 2] = $iA1
				While $iA2 < $aArray[$k]
					$aArray[$k + 1] = $aArray[$k]
					$k -= 1
				WEnd
				$aArray[$k + 1] = $iA2
				$iPivot_Left += 1
			WEnd
			$iLast = $aArray[$iPivot_Right]
			$iPivot_Right -= 1
			While $iLast < $aArray[$iPivot_Right]
				$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
				$iPivot_Right -= 1
			WEnd
			$aArray[$iPivot_Right + 1] = $iLast
		EndIf
		Return 1
	EndIf
	Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
	Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
	$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
	$iE2 = $iE3 - $iSeventh
	$iE1 = $iE2 - $iSeventh
	$iE4 = $iE3 + $iSeventh
	$iE5 = $iE4 + $iSeventh
	If $aArray[$iE2] < $aArray[$iE1] Then
		$t = $aArray[$iE2]
		$aArray[$iE2] = $aArray[$iE1]
		$aArray[$iE1] = $t
	EndIf
	If $aArray[$iE3] < $aArray[$iE2] Then
		$t = $aArray[$iE3]
		$aArray[$iE3] = $aArray[$iE2]
		$aArray[$iE2] = $t
		If $t < $aArray[$iE1] Then
			$aArray[$iE2] = $aArray[$iE1]
			$aArray[$iE1] = $t
		EndIf
	EndIf
	If $aArray[$iE4] < $aArray[$iE3] Then
		$t = $aArray[$iE4]
		$aArray[$iE4] = $aArray[$iE3]
		$aArray[$iE3] = $t
		If $t < $aArray[$iE2] Then
			$aArray[$iE3] = $aArray[$iE2]
			$aArray[$iE2] = $t
			If $t < $aArray[$iE1] Then
				$aArray[$iE2] = $aArray[$iE1]
				$aArray[$iE1] = $t
			EndIf
		EndIf
	EndIf
	If $aArray[$iE5] < $aArray[$iE4] Then
		$t = $aArray[$iE5]
		$aArray[$iE5] = $aArray[$iE4]
		$aArray[$iE4] = $t
		If $t < $aArray[$iE3] Then
			$aArray[$iE4] = $aArray[$iE3]
			$aArray[$iE3] = $t
			If $t < $aArray[$iE2] Then
				$aArray[$iE3] = $aArray[$iE2]
				$aArray[$iE2] = $t
				If $t < $aArray[$iE1] Then
					$aArray[$iE2] = $aArray[$iE1]
					$aArray[$iE1] = $t
				EndIf
			EndIf
		EndIf
	EndIf
	Local $iLess = $iPivot_Left
	Local $iGreater = $iPivot_Right
	If (($aArray[$iE1] <> $aArray[$iE2]) And ($aArray[$iE2] <> $aArray[$iE3]) And ($aArray[$iE3] <> $aArray[$iE4]) And ($aArray[$iE4] <> $aArray[$iE5])) Then
		Local $iPivot_1 = $aArray[$iE2]
		Local $iPivot_2 = $aArray[$iE4]
		$aArray[$iE2] = $aArray[$iPivot_Left]
		$aArray[$iE4] = $aArray[$iPivot_Right]
		Do
			$iLess += 1
		Until $aArray[$iLess] >= $iPivot_1
		Do
			$iGreater -= 1
		Until $aArray[$iGreater] <= $iPivot_2
		$k = $iLess
		While $k <= $iGreater
			$iAk = $aArray[$k]
			If $iAk < $iPivot_1 Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $iAk
				$iLess += 1
			ElseIf $iAk > $iPivot_2 Then
				While $aArray[$iGreater] > $iPivot_2
					$iGreater -= 1
					If $iGreater + 1 = $k Then ExitLoop 2
				WEnd
				If $aArray[$iGreater] < $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
				Else
					$aArray[$k] = $aArray[$iGreater]
				EndIf
				$aArray[$iGreater] = $iAk
				$iGreater -= 1
			EndIf
			$k += 1
		WEnd
		$aArray[$iPivot_Left] = $aArray[$iLess - 1]
		$aArray[$iLess - 1] = $iPivot_1
		$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
		$aArray[$iGreater + 1] = $iPivot_2
		__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
		__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
		If ($iLess < $iE1) And ($iE5 < $iGreater) Then
			While $aArray[$iLess] = $iPivot_1
				$iLess += 1
			WEnd
			While $aArray[$iGreater] = $iPivot_2
				$iGreater -= 1
			WEnd
			$k = $iLess
			While $k <= $iGreater
				$iAk = $aArray[$k]
				If $iAk = $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $iAk
					$iLess += 1
				ElseIf $iAk = $iPivot_2 Then
					While $aArray[$iGreater] = $iPivot_2
						$iGreater -= 1
						If $iGreater + 1 = $k Then ExitLoop 2
					WEnd
					If $aArray[$iGreater] = $iPivot_1 Then
						$aArray[$k] = $aArray[$iLess]
						$aArray[$iLess] = $iPivot_1
						$iLess += 1
					Else
						$aArray[$k] = $aArray[$iGreater]
					EndIf
					$aArray[$iGreater] = $iAk
					$iGreater -= 1
				EndIf
				$k += 1
			WEnd
		EndIf
		__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
	Else
		Local $iPivot = $aArray[$iE3]
		$k = $iLess
		While $k <= $iGreater
			If $aArray[$k] = $iPivot Then
				$k += 1
				ContinueLoop
			EndIf
			$iAk = $aArray[$k]
			If $iAk < $iPivot Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $iAk
				$iLess += 1
			Else
				While $aArray[$iGreater] > $iPivot
					$iGreater -= 1
				WEnd
				If $aArray[$iGreater] < $iPivot Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
				Else
					$aArray[$k] = $iPivot
				EndIf
				$aArray[$iGreater] = $iAk
				$iGreater -= 1
			EndIf
			$k += 1
		WEnd
		__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
		__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
	EndIf
EndFunc   ;==>__ArrayDualPivotSort

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _ArraySwap(ByRef $aArray, $iIndex_1, $iIndex_2, $bCol = False, $iStart = -1, $iEnd = -1)

	If $bCol = Default Then $bCol = False
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
	If $iDim_2 = -1 Then ; 1D array so force defaults
		$bCol = False
		$iStart = -1
		$iEnd = -1
	EndIf
	; Bounds check
	If $iStart > $iEnd Then Return SetError(5, 0, -1)
	If $bCol Then
		If $iIndex_1 < 0 Or $iIndex_2 > $iDim_2 Then Return SetError(3, 0, -1)
		If $iStart = -1 Then $iStart = 0
		If $iEnd = -1 Then $iEnd = $iDim_1
	Else
		If $iIndex_1 < 0 Or $iIndex_2 > $iDim_1 Then Return SetError(3, 0, -1)
		If $iStart = -1 Then $iStart = 0
		If $iEnd = -1 Then $iEnd = $iDim_2
	EndIf
	Local $vTmp
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			$vTmp = $aArray[$iIndex_1]
			$aArray[$iIndex_1] = $aArray[$iIndex_2]
			$aArray[$iIndex_2] = $vTmp
		Case 2
			If $iStart < -1 Or $iEnd < -1 Then Return SetError(4, 0, -1)
			If $bCol Then
				If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(4, 0, -1)
				For $j = $iStart To $iEnd
					$vTmp = $aArray[$j][$iIndex_1]
					$aArray[$j][$iIndex_1] = $aArray[$j][$iIndex_2]
					$aArray[$j][$iIndex_2] = $vTmp
				Next
			Else
				If $iStart > $iDim_2 Or $iEnd > $iDim_2 Then Return SetError(4, 0, -1)
				For $j = $iStart To $iEnd
					$vTmp = $aArray[$iIndex_1][$j]
					$aArray[$iIndex_1][$j] = $aArray[$iIndex_2][$j]
					$aArray[$iIndex_2][$j] = $vTmp
				Next
			EndIf
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return 1

EndFunc   ;==>_ArraySwap

; #FUNCTION# ====================================================================================================================
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos - added $iStart parameter and logic, Ultima - added $iEnd parameter, make use of _ArrayToString() instead of duplicating efforts; Melba23 - added 2D support
; ===============================================================================================================================
Func _ArrayToClip(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
	Local $sResult = _ArrayToString($aArray, $sDelim_Col, $iStart_Row, $iEnd_Row, $sDelim_Row, $iStart_Col, $iEnd_Col)
	If @error Then Return SetError(@error, 0, 0)
	If ClipPut($sResult) Then Return 1
	Return SetError(-1, 0, 0)
EndFunc   ;==>_ArrayToClip

; #FUNCTION# ====================================================================================================================
; Author ........: Brian Keene <brian_keene at yahoo dot com>, Valik - rewritten
; Modified.......: Ultima - code cleanup; Melba23 - added support for empty and 2D arrays
; ===============================================================================================================================
Func _ArrayToString(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)

	If $sDelim_Col = Default Then $sDelim_Col = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iStart_Row = Default Then $iStart_Row = -1
	If $iEnd_Row = Default Then $iEnd_Row = -1
	If $iStart_Col = Default Then $iStart_Col = -1
	If $iEnd_Col = Default Then $iEnd_Col = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iStart_Row = -1 Then $iStart_Row = 0
	If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
	If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, "")
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
	Local $sRet = ""
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = $iStart_Row To $iEnd_Row
				$sRet &= $aArray[$i] & $sDelim_Col
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Col))
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iStart_Col = -1 Then $iStart_Col = 0
			If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
			If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
			For $i = $iStart_Row To $iEnd_Row
				For $j = $iStart_Col To $iEnd_Col
					$sRet &= $aArray[$i][$j] & $sDelim_Col
				Next
				$sRet = StringTrimRight($sRet, StringLen($sDelim_Col)) & $sDelim_Row
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Row))
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return 1

EndFunc   ;==>_ArrayToString

; #FUNCTION# ====================================================================================================================
; Author ........: jchd
; Modified.......: jpm, czardas
; ===============================================================================================================================
Func _ArrayTranspose(ByRef $aArray)
	Switch UBound($aArray, 0)
		Case 0
			Return SetError(2, 0, 0)
		Case 1
			Local $aTemp[1][UBound($aArray)]
			For $i = 0 To UBound($aArray) - 1
				$aTemp[0][$i] = $aArray[$i]
			Next
			$aArray = $aTemp
		Case 2
			Local $iDim_1 = UBound($aArray, 1), $iDim_2 = UBound($aArray, 2)
			If $iDim_1 <> $iDim_2 Then
				Local $aTemp[$iDim_2][$iDim_1]
				For $i = 0 To $iDim_1 - 1
					For $j = 0 To $iDim_2 - 1
						$aTemp[$j][$i] = $aArray[$i][$j]
					Next
				Next
				$aArray = $aTemp
			Else ; optimimal method for a square grid
				Local $vElement
				For $i = 0 To $iDim_1 - 1
					For $j = $i + 1 To $iDim_2 - 1
						$vElement = $aArray[$i][$j]
						$aArray[$i][$j] = $aArray[$j][$i]
						$aArray[$j][$i] = $vElement
					Next
				Next
			EndIf
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_ArrayTranspose

; #FUNCTION# ====================================================================================================================
; Author ........: Adam Moore (redndahead)
; Modified.......: Ultima - code cleanup, optimization; Melba23 - added 2D support
; ===============================================================================================================================
Func _ArrayTrim(ByRef $aArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)

	If $iDirection = Default Then $iDirection = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iSubItem = Default Then $iSubItem = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)

	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iEnd = 0 Then $iEnd = $iDim_1
	If $iStart > $iEnd Then Return SetError(3, 0, -1)
	If $iStart < 0 Or $iEnd < 0 Then Return SetError(3, 0, -1)
	If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iDirection Then
				For $i = $iStart To $iEnd
					$aArray[$i] = StringTrimRight($aArray[$i], $iTrimNum)
				Next
			Else
				For $i = $iStart To $iEnd
					$aArray[$i] = StringTrimLeft($aArray[$i], $iTrimNum)
				Next
			EndIf
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iSubItem < 0 Or $iSubItem > $iDim_2 Then Return SetError(5, 0, -1)
			If $iDirection Then
				For $i = $iStart To $iEnd
					$aArray[$i][$iSubItem] = StringTrimRight($aArray[$i][$iSubItem], $iTrimNum)
				Next
			Else
				For $i = $iStart To $iEnd
					$aArray[$i][$iSubItem] = StringTrimLeft($aArray[$i][$iSubItem], $iTrimNum)
				Next
			EndIf
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return 1
EndFunc   ;==>_ArrayTrim

; #FUNCTION# ====================================================================================================================
; Author ........: SmOke_N
; Modified.......: litlmike, Erik Pilsits, BrewManNH, Melba23
; ===============================================================================================================================
Func _ArrayUnique(Const ByRef $aArray, $iColumn = 0, $iBase = 0, $iCase = 0, $iCount = $ARRAYUNIQUE_COUNT, $iIntType = $ARRAYUNIQUE_AUTO)

	If $iColumn = Default Then $iColumn = 0
	If $iBase = Default Then $iBase = 0
	If $iCase = Default Then $iCase = 0
	If $iCount = Default Then $iCount = $ARRAYUNIQUE_COUNT
	; Check array
	If UBound($aArray, $UBOUND_ROWS) = 0 Then Return SetError(1, 0, 0)
	Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS), $iNumColumns = UBound($aArray, $UBOUND_COLUMNS)
	If $iDims > 2 Then Return SetError(2, 0, 0)
	; Check parameters
	If $iBase < 0 Or $iBase > 1 Or (Not IsInt($iBase)) Then Return SetError(3, 0, 0)
	If $iCase < 0 Or $iCase > 1 Or (Not IsInt($iCase)) Then Return SetError(3, 0, 0)
	If $iCount < 0 Or $iCount > 1 Or (Not IsInt($iCount)) Then Return SetError(4, 0, 0)
	If $iIntType < 0 Or $iIntType > 4 Or (Not IsInt($iIntType)) Then Return SetError(5, 0, 0)
	If $iColumn < 0 Or ($iNumColumns = 0 And $iColumn > 0) Or ($iNumColumns > 0 And $iColumn >= $iNumColumns) Then Return SetError(6, 0, 0)

	; Autocheck of first element
	If $iIntType = $ARRAYUNIQUE_AUTO Then
		Local $bInt, $sVarType
		If $iDims = 1 Then
			$bInt = IsInt($aArray[$iBase])
			$sVarType = VarGetType($aArray[$iBase])
		Else
			$bInt = IsInt($aArray[$iBase][$iColumn])
			$sVarType = VarGetType($aArray[$iBase][$iColumn])
		EndIf
		If $bInt And $sVarType = "Int64" Then
			$iIntType = $ARRAYUNIQUE_FORCE64
		Else
			$iIntType = $ARRAYUNIQUE_FORCE32
		EndIf
	EndIf
	; Create error handler
	ObjEvent("AutoIt.Error", __ArrayUnique_AutoErrFunc)
	; Create dictionary
	Local $oDictionary = ObjCreate("Scripting.Dictionary")
	; Set case sensitivity
	$oDictionary.CompareMode = Number(Not $iCase)
	; Add elements to dictionary
	Local $vElem, $sType, $vKey, $bCOMError = False
	For $i = $iBase To UBound($aArray) - 1
		If $iDims = 1 Then
			; 1D array
			$vElem = $aArray[$i]
		Else
			; 2D array
			$vElem = $aArray[$i][$iColumn]
		EndIf
		; Determine method to use
		Switch $iIntType
			Case $ARRAYUNIQUE_FORCE32
				; Use element as key
				$oDictionary.Item($vElem) ; Check if key exists - automatically created if not
				If @error Then
					$bCOMError = True ; Failed with an Int64, Ptr or Binary datatype
					ExitLoop
				EndIf
			Case $ARRAYUNIQUE_FORCE64
				$sType = VarGetType($vElem)
				If $sType = "Int32" Then
					$bCOMError = True ; Failed with an Int32 datatype
					ExitLoop
				EndIf ; Create key
				$vKey = "#" & $sType & "#" & String($vElem)
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
				EndIf
			Case $ARRAYUNIQUE_MATCH
				$sType = VarGetType($vElem)
				If StringLeft($sType, 3) = "Int" Then
					$vKey = "#Int#" & String($vElem)
				Else
					$vKey = "#" & $sType & "#" & String($vElem)
				EndIf
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
				EndIf
			Case $ARRAYUNIQUE_DISTINCT
				$vKey = "#" & VarGetType($vElem) & "#" & String($vElem)
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
				EndIf
		EndSwitch
	Next
	; Create return array
	Local $aValues, $j = 0
	If $bCOMError Then ; Mismatch Int32/64
		Return SetError(7, 0, 0)
	ElseIf $iIntType <> $ARRAYUNIQUE_FORCE32 Then
		; Extract values associated with the unique keys
		Local $aValues[$oDictionary.Count]
		For $vKey In $oDictionary.Keys()
			$aValues[$j] = $oDictionary($vKey)
			; Check for Ptr datatype
			If StringLeft($vKey, 5) = "#Ptr#" Then
				$aValues[$j] = Ptr($aValues[$j])
			EndIf
			$j += 1
		Next
	Else
		; Only need to list the unique keys
		$aValues = $oDictionary.Keys()
	EndIf
	; Add count if required
	If $iCount Then
		_ArrayInsert($aValues, 0, $oDictionary.Count)
	EndIf
	; Return array
	Return $aValues

EndFunc   ;==>_ArrayUnique

; #FUNCTION# ====================================================================================================================
; Author ........: jchd, jpm
; Modified.......:
; ===============================================================================================================================
Func _Array1DToHistogram($aArray, $iSizing = 100)
	If UBound($aArray, 0) > 1 Then Return SetError(1, 0, "")
	$iSizing = $iSizing * 8
	Local $t, $n, $iMin = 0, $iMax = 0, $iOffset = 0
	For $i = 0 To UBound($aArray) - 1
		$t = $aArray[$i]
		$t = IsNumber($t) ? Round($t) : 0
		If $t < $iMin Then $iMin = $t
		If $t > $iMax Then $iMax = $t
	Next
	Local $iRange = Int(Round(($iMax - $iMin) / 8)) * 8
	Local $iSpaceRatio = 4
	For $i = 0 To UBound($aArray) - 1
		$t = $aArray[$i]
		If $t Then
			$n = Abs(Round(($iSizing * $t) / $iRange) / 8)

			$aArray[$i] = ""
			If $t > 0 Then
				If $iMin Then
					$iOffset = Int(Abs(Round(($iSizing * $iMin) / $iRange) / 8) / 8 * $iSpaceRatio)
					$aArray[$i] = __Array_StringRepeat(ChrW(0x20), $iOffset)
				EndIf
			Else
				If $iMin <> $t Then
					$iOffset = Int(Abs(Round(($iSizing * ($t - $iMin)) / $iRange) / 8) / 8 * $iSpaceRatio)
					$aArray[$i] = __Array_StringRepeat(ChrW(0x20), $iOffset)
				EndIf
			EndIf
			$aArray[$i] &= __Array_StringRepeat(ChrW(0x2588), Int($n / 8))

			$n = Mod($n, 8)
			If $n > 0 Then $aArray[$i] &= ChrW(0x2588 + 8 - $n)
			$aArray[$i] &= ' ' & $t
		Else
			$aArray[$i] = ""
		EndIf
	Next

	Return $aArray
EndFunc   ;==>_Array1DToHistogram

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_StringRepeat
; Description ...: Repeats a string a specified number of times
; Syntax.........: __Array_StringRepeat ( $sString, $iRepeatCount )
; Parameters ....: $sString - String to repeat
;                  $iRepeatCount - Number of times to repeat the string
; Return values .: a string with specified number of repeats.
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......: jpm
; Remarks .......: This function is used internally. similar to _StringRepeat() but if $iRepeatCount = 0 returns ""
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_StringRepeat($sString, $iRepeatCount)
	; Casting Int() takes care of String/Int, Numbers.
	$iRepeatCount = Int($iRepeatCount)
	; Zero is a valid repeat integer.
	If StringLen($sString) < 1 Or $iRepeatCount <= 0 Then Return SetError(1, 0, "")
	Local $sResult = ""
	While $iRepeatCount > 1
		If BitAND($iRepeatCount, 1) Then $sResult &= $sString
		$sString &= $sString
		$iRepeatCount = BitShift($iRepeatCount, 1)
	WEnd
	Return $sString & $sResult
EndFunc   ;==>__Array_StringRepeat

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_ExeterInternal
; Description ...: Permute Function based on an algorithm from Exeter University.
; Syntax.........: __Array_ExeterInternal ( ByRef $aArray, $iStart, $iSize, $sDelimiter, ByRef $aIdx, ByRef $aResult )
; Parameters ....: $aArray - The Array to get Permutations
;                  $iStart - Starting Point for Loop
;                  $iSize - End Point for Loop
;                  $sDelimiter - String result separator
;                  $aIdx - Array Used in Rotations
;                  $aResult - Resulting Array
; Return values .: Success      - Computer name
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. Permute Function based on an algorithm from Exeter University.
; +
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_ExeterInternal(ByRef $aArray, $iStart, $iSize, $sDelimiter, ByRef $aIdx, ByRef $aResult, ByRef $iCount)
	If $iStart == $iSize - 1 Then
		For $i = 0 To $iSize - 1
			$aResult[$iCount] &= $aArray[$aIdx[$i]] & $sDelimiter
		Next
		If $sDelimiter <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], StringLen($sDelimiter))
		$iCount += 1
	Else
		Local $iTemp
		For $i = $iStart To $iSize - 1
			$iTemp = $aIdx[$i]

			$aIdx[$i] = $aIdx[$iStart]
			$aIdx[$iStart] = $iTemp
			__Array_ExeterInternal($aArray, $iStart + 1, $iSize, $sDelimiter, $aIdx, $aResult, $iCount)
			$aIdx[$iStart] = $aIdx[$i]
			$aIdx[$i] = $iTemp
		Next
	EndIf
EndFunc   ;==>__Array_ExeterInternal

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_Combinations
; Description ...: Creates Combination
; Syntax.........: __Array_Combinations ( $iN, $iR )
; Parameters ....: $iN - Value passed on from UBound($aArray)
;                  $iR - Size of the combinations set
; Return values .: Integer value of the number of combinations
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. PBased on an algorithm by Kenneth H. Rosen.
; +
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_Combinations($iN, $iR)
	Local $i_Total = 1

	For $i = $iR To 1 Step -1
		$i_Total *= ($iN / $i)
		$iN -= 1
	Next
	Return Round($i_Total)
EndFunc   ;==>__Array_Combinations

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_GetNext
; Description ...: Creates Combination
; Syntax.........: __Array_GetNext ( $iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx )
; Parameters ....: $iN - Value passed on from UBound($aArray)
;                  $iR - Size of the combinations set
;                  $iLeft - Remaining number of combinations
;                  $iTotal - Total number of combinations
;                  $aIdx - Array containing combinations
; Return values .: Function only changes values ByRef
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. PBased on an algorithm by Kenneth H. Rosen.
; +
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_GetNext($iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx)
	If $iLeft == $iTotal Then
		$iLeft -= 1
		Return
	EndIf

	Local $i = $iR - 1
	While $aIdx[$i] == $iN - $iR + $i
		$i -= 1
	WEnd

	$aIdx[$i] += 1
	For $j = $i + 1 To $iR - 1
		$aIdx[$j] = $aIdx[$i] + $j - $i
	Next

	$iLeft -= 1
EndFunc   ;==>__Array_GetNext

Func __Array_MinMaxIndex(Const ByRef $aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, $fuComparison) ; Always swapped the comparison params around e.g. it was for min 100 > 1000 whereas 1000 < 100 makes more sense in a min function.
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iCompNumeric <> 1 Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iSubItem = Default Then $iSubItem = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iDim_1 < 0 Then Return SetError(1, 0, -1)
	If $iEnd = -1 Then $iEnd = $iDim_1
	If $iStart = -1 Then $iStart = 0
	If $iStart < -1 Or $iEnd < -1 Then Return SetError(3, 0, -1)
	If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	If $iDim_1 < 0 Then Return SetError(5, 0, -1)
	Local $iMaxMinIndex = $iStart
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If $fuComparison(Number($aArray[$i]), Number($aArray[$iMaxMinIndex])) Then $iMaxMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $fuComparison($aArray[$i], $aArray[$iMaxMinIndex]) Then $iMaxMinIndex = $i
				Next
			EndIf
		Case 2
			If $iSubItem < 0 Or $iSubItem > UBound($aArray, $UBOUND_COLUMNS) - 1 Then Return SetError(6, 0, -1)
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If $fuComparison(Number($aArray[$i][$iSubItem]), Number($aArray[$iMaxMinIndex][$iSubItem])) Then $iMaxMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $fuComparison($aArray[$i][$iSubItem], $aArray[$iMaxMinIndex][$iSubItem]) Then $iMaxMinIndex = $i
				Next
			EndIf
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return $iMaxMinIndex
EndFunc   ;==>__Array_MinMaxIndex

Func __Array_GreaterThan($vValue1, $vValue2)
	Return $vValue1 > $vValue2
EndFunc   ;==>__Array_GreaterThan

Func __Array_LessThan($vValue1, $vValue2)
	Return $vValue1 < $vValue2
EndFunc   ;==>__Array_LessThan

Func __ArrayUnique_AutoErrFunc()
	; Do nothing special, just check @error after suspect functions.
EndFunc   ;==>__ArrayUnique_AutoErrFunc
