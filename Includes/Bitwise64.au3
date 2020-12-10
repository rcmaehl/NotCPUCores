Func _BitAND64($iValue1, $iValue2)
  If VarGetType($iValue1) <> "Int64" And VarGetType($iValue2) <> "Int64" Then Return BitAND($iValue1, $iValue2)
  $iValue1 = __DecToBin64($iValue1)
  $iValue2 = __DecToBin64($iValue2)
  Local $aValueANDed[64]
  For $i = 0 To 63
    $aValueANDed[$i] = ($iValue1[$i] And $iValue2[$i]) ? 1 : 0
  Next
  Return __BinToDec64($aValueANDed)
EndFunc   ;==>_BitAND64

Func _BitOR64($iValue1, $iValue2)
  If VarGetType($iValue1) <> "Int64" And VarGetType($iValue2) <> "Int64" Then Return BitOR($iValue1, $iValue2)
  $iValue1 = __DecToBin64($iValue1)
  $iValue2 = __DecToBin64($iValue2)
  Local $aValueORed[64]
  For $i = 0 To 63
    $aValueORed[$i] = ($iValue1[$i] Or $iValue2[$i]) ? 1 : 0
  Next
  Return __BinToDec64($aValueORed)
EndFunc   ;==>_BitOR64

Func _BitXOR64($iValue1, $iValue2)
  If VarGetType($iValue1) <> "Int64" And VarGetType($iValue2) <> "Int64" Then Return BitXOR($iValue1, $iValue2)
  $iValue1 = __DecToBin64($iValue1)
  $iValue2 = __DecToBin64($iValue2)
  Local $aValueXORed[64]
  For $i = 0 To 63
    $aValueXORed[$i] = (($iValue1[$i] And (Not $iValue2[$i])) Or ((Not $iValue1[$i]) And $iValue2)) ? 1 : 0
  Next
  Return __BinToDec64($aValueXORed)
EndFunc   ;==>_BitXOR64

Func _BitNOT64($iValue)
  If Not VarGetType($iValue) = "Int64" Then Return BitNOT($iValue)
  $iValue = __DecToBin64($iValue)
  For $i = 0 To 63
    $iValue[$i] = Not $iValue[$i]
  Next
  Return __BinToDec64($iValue)
EndFunc   ;==>_BitNOT64

Func _BitRotate64($iValue, $iShift)
  If VarGetType($iValue) <> "Int64" Then Return BitRotate($iValue, $iShift, "D")
  $iValue = __DecToBin64($iValue)
  Local $iTmp
  If $iShift < 0 Then ; rotate right
    For $i = 1 To Abs($iShift)
      $iTmp = $iValue[0]
      For $j = 1 To 63
        $iValue[$j - 1] = $iValue[$j]
      Next
      $iValue[63] = $iTmp
    Next
  Else
    For $i = 1 To $iShift
      $iTmp = $iValue[63]
      For $j = 63 To 1 Step -1
        $iValue[$j] = $iValue[$j - 1]
      Next
      $iValue[0] = $iTmp
    Next
  EndIf
  Return __BinToDec64($iValue)
EndFunc   ;==>_BitRotate64

Func _BitShift64($iValue, $iShift, $bSigned = True)
  If $iShift <= 0 Then $bSigned = True
  If VarGetType($iValue) <> "Int64" Then
    If $bSigned Then Return BitShift($iValue, $iShift)
    If $iShift > 0 Then
      $iValue = BitAND(BitShift($iValue, 1), 0x7FFFFFFF)
      Return BitShift($iValue, $iShift-1)
    EndIf
  EndIf
  $iValue = __DecToBin64($iValue)
  Local $iTmp
  If $iShift > 0 Then ; shift right
    $iTmp = $bSigned ? $iValue[63] : 0
    For $i = 1 To Abs($iShift)
      For $j = 1 To 63
        $iValue[$j - 1] = $iValue[$j]
      Next
      $iValue[63] = $iTmp
    Next
  Else
    For $i = 1 To Abs($iShift)
      For $j = 63 To 1 Step -1
        $iValue[$j] = $iValue[$j - 1]
      Next
      $iValue[0] = 0
    Next
  EndIf
  Return __BinToDec64($iValue)
EndFunc   ;==>_BitShift64

Func __DecToBin64($iDec)
  Local $tI64 = DllStructCreate("int64 num"), $aBin[64], $iVal
  Local $tI32 = DllStructCreate("align 4;uint low;uint high", DllStructGetPtr($tI64))
  $tI64.num = $iDec
  For $i = 0 To 31
    $iVal = 2 ^ $i
    $aBin[$i] = BitAND($tI32.low, $iVal) ? 1 : 0
    $aBin[$i + 32] = BitAND($tI32.high, $iVal) ? 1 : 0
  Next
  Return $aBin
EndFunc   ;==>__DecToBin64

Func __BinToDec64($aBin)
  Local $tI32 = DllStructCreate("align 4;uint low;uint high"), $iVal
  Local $tI64 = DllStructCreate("UINT64 num", DllStructGetPtr($tI32))
  For $i = 0 To 31
    $iVal = 2 ^ $i
    $tI32.low += $aBin[$i] ? $iVal : 0
    $tI32.high += $aBin[$i + 32] ? $iVal : 0
  Next
  Return $tI64.num
EndFunc   ;==>__BinToDec64