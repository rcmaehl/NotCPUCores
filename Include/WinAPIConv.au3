#include-once

#include "StringConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIConv.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CharToOem
; _WinAPI_ClientToScreen
; _WinAPI_DWordToFloat
; _WinAPI_DWordToInt
; _WinAPI_FloatToInt
; _WinAPI_FloatToDWord
; _WinAPI_GetXYFromPoint
; _WinAPI_GUIDFromString
; _WinAPI_GUIDFromStringEx
; _WinAPI_HashData
; _WinAPI_HashString
; _WinAPI_HiByte
; _WinAPI_HiDWord
; _WinAPI_HiWord
; _WinAPI_IntToDWord
; _WinAPI_IntToFloat
; _WinAPI_LoByte
; _WinAPI_LoDWord
; _WinAPI_LoWord
; _WinAPI_MAKELANGID
; _WinAPI_MAKELCID
; _WinAPI_MakeLong
; _WinAPI_MakeQWord
; _WinAPI_LongMid
; _WinAPI_MakeWord
; _WinAPI_MultiByteToWideChar
; _WinAPI_MultiByteToWideCharEx
; _WinAPI_OemToChar
; _WinAPI_PointFromRect
; _WinAPI_PrimaryLangId
; _WinAPI_ScreenToClient
; _WinAPI_ShortToWord
; _WinAPI_StrFormatByteSize
; _WinAPI_StrFormatByteSizeEx
; _WinAPI_StrFormatKBSize
; _WinAPI_StrFromTimeInterval
; _WinAPI_StringFromGUID
; _WinAPI_SubLangId
; _WinAPI_SwapDWord
; _WinAPI_SwapQWord
; _WinAPI_SwapWord
; _WinAPI_WideCharToMultiByte
; _WinAPI_WordToShort
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_CharToOem($sStr)
	Local $aRet = DllCall('user32.dll', 'bool', 'CharToOemW', 'wstr', $sStr, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_CharToOem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ClientToScreen($hWnd, ByRef $tPoint)
	Local $aRet = DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPoint
EndFunc   ;==>_WinAPI_ClientToScreen

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DWordToFloat($iValue)
	Local $tDWord = DllStructCreate('dword')
	Local $tFloat = DllStructCreate('float', DllStructGetPtr($tDWord))
	DllStructSetData($tDWord, 1, $iValue)

	Return DllStructGetData($tFloat, 1)
EndFunc   ;==>_WinAPI_DWordToFloat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DWordToInt($iValue)
	Local $tData = DllStructCreate('int')
	DllStructSetData($tData, 1, $iValue)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_DWordToInt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FloatToDWord($iValue)
	Local $tFloat = DllStructCreate('float')
	Local $tDWord = DllStructCreate('dword', DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $iValue)

	Return DllStructGetData($tDWord, 1)
EndFunc   ;==>_WinAPI_FloatToDWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FloatToInt($nFloat)
	Local $tFloat = DllStructCreate("float")
	Local $tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $nFloat)

	Return DllStructGetData($tInt, 1)
EndFunc   ;==>_WinAPI_FloatToInt

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetXYFromPoint(ByRef $tPoint, ByRef $iX, ByRef $iY)
	$iX = DllStructGetData($tPoint, "X")
	$iY = DllStructGetData($tPoint, "Y")
EndFunc   ;==>_WinAPI_GetXYFromPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM, guinness
; ===============================================================================================================================
Func _WinAPI_GUIDFromString($sGUID)
	Local $tGUID = DllStructCreate($tagGUID)
	_WinAPI_GUIDFromStringEx($sGUID, $tGUID)
	If @error Then Return SetError(@error + 10, @extended, 0)
	; If Not _WinAPI_GUIDFromStringEx($sGUID, $tGUID) Then Return SetError(@error + 10, @extended, 0)

	Return $tGUID
EndFunc   ;==>_WinAPI_GUIDFromString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
	Local $aResult = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GUIDFromStringEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_HashData($pMemory, $iSize, $iLength = 32)
	If ($iLength <= 0) Or ($iLength > 256) Then Return SetError(11, 0, 0)

	Local $tData = DllStructCreate('byte[' & $iLength & ']')

	Local $aRet = DllCall('shlwapi.dll', 'uint', 'HashData', 'struct*', $pMemory, 'dword', $iSize, 'struct*', $tData, 'dword', $iLength)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_HashData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_HashString($sString, $bCaseSensitive = True, $iLength = 32)
	Local $iLengthS = StringLen($sString)
	If Not $iLengthS Or ($iLength > 256) Then Return SetError(12, 0, 0)

	Local $tString = DllStructCreate('wchar[' & ($iLengthS + 1) & ']')
	If Not $bCaseSensitive Then
		$sString = StringLower($sString)
	EndIf
	DllStructSetData($tString, 1, $sString)
	Local $sHash = _WinAPI_HashData($tString, 2 * $iLengthS, $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return $sHash
EndFunc   ;==>_WinAPI_HashString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_HiByte($iValue)
	Return BitAND(BitShift($iValue, 8), 0xFF)
EndFunc   ;==>_WinAPI_HiByte

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_HiDWord($iValue)
	Local $tInt64 = DllStructCreate('int64')
	Local $tQWord = DllStructCreate('dword;dword', DllStructGetPtr($tInt64))
	DllStructSetData($tInt64, 1, $iValue)

	Return DllStructGetData($tQWord, 2)
EndFunc   ;==>_WinAPI_HiDWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_HiWord($iLong)
	Return BitShift($iLong, 16)
EndFunc   ;==>_WinAPI_HiWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IntToDWord($iValue)
	Local $tData = DllStructCreate('dword')
	DllStructSetData($tData, 1, $iValue)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_IntToDWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IntToFloat($iInt)
	Local $tInt = DllStructCreate("int")
	Local $tFloat = DllStructCreate("float", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $iInt)

	Return DllStructGetData($tFloat, 1)
EndFunc   ;==>_WinAPI_IntToFloat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoByte($iValue)
	Return BitAND($iValue, 0xFF)
EndFunc   ;==>_WinAPI_LoByte

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoDWord($iValue)
	Local $tInt64 = DllStructCreate('int64')
	Local $tQWord = DllStructCreate('dword;dword', DllStructGetPtr($tInt64))
	DllStructSetData($tInt64, 1, $iValue)

	Return DllStructGetData($tQWord, 1)
EndFunc   ;==>_WinAPI_LoDWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoWord($iLong)
	Return BitAND($iLong, 0xFFFF)
EndFunc   ;==>_WinAPI_LoWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LongMid($iValue, $iStart, $iCount)
	Return BitAND(BitShift($iValue, $iStart), BitOR(BitShift(BitShift(0x7FFFFFFF, 32 - ($iCount + 1)), 1), BitShift(1, -($iCount - 1))))
EndFunc   ;==>_WinAPI_LongMid

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MAKELANGID($iLngIDPrimary, $iLngIDSub)
	Return BitOR(BitShift($iLngIDSub, -10), $iLngIDPrimary)
EndFunc   ;==>_WinAPI_MAKELANGID

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MAKELCID($iLngID, $iSortID)
	Return BitOR(BitShift($iSortID, -16), $iLngID)
EndFunc   ;==>_WinAPI_MAKELCID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MakeLong($iLo, $iHi)
	Return BitOR(BitShift($iHi, -16), BitAND($iLo, 0xFFFF))
EndFunc   ;==>_WinAPI_MakeLong

; #FUNCTION# ====================================================================================================================
; Author ........: jpm
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MakeQWord($iLoDWORD, $iHiDWORD)
	Local $tInt64 = DllStructCreate("uint64")
	Local $tDwords = DllStructCreate("dword;dword", DllStructGetPtr($tInt64))
	DllStructSetData($tDwords, 1, $iLoDWORD)
	DllStructSetData($tDwords, 2, $iHiDWORD)

	Return DllStructGetData($tInt64, 1)
EndFunc   ;==>_WinAPI_MakeQWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MakeWord($iLo, $iHi)
	Local $tWord = DllStructCreate('ushort')
	Local $tByte = DllStructCreate('byte;byte', DllStructGetPtr($tWord))
	DllStructSetData($tByte, 1, $iHi)
	DllStructSetData($tByte, 2, $iLo)

	Return DllStructGetData($tWord, 1)
EndFunc   ;==>_WinAPI_MakeWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM, Alexander Samuelsson (AdmiralAlkex)
; ===============================================================================================================================
Func _WinAPI_MultiByteToWideChar($vText, $iCodePage = 0, $iFlags = 0, $bRetString = False)
	Local $sTextType = "str"
	If Not IsString($vText) Then $sTextType = "struct*"

	; compute size for the output WideChar
	Local $aResult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $iCodePage, "dword", $iFlags, _
			$sTextType, $vText, "int", -1, "ptr", 0, "int", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	; allocate space for output WideChar
	Local $iOut = $aResult[0]
	Local $tOut = DllStructCreate("wchar[" & $iOut & "]")

	$aResult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $iCodePage, "dword", $iFlags, $sTextType, $vText, _
			"int", -1, "struct*", $tOut, "int", $iOut)
	If @error Or Not $aResult[0] Then Return SetError(@error + 20, @extended, 0)

	If $bRetString Then Return DllStructGetData($tOut, 1)
	Return $tOut
EndFunc   ;==>_WinAPI_MultiByteToWideChar

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MultiByteToWideCharEx($sText, $pText, $iCodePage = 0, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $iCodePage, "dword", $iFlags, "STR", $sText, _
			"int", -1, "struct*", $pText, "int", (StringLen($sText) + 1) * 2)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MultiByteToWideCharEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OemToChar($sStr)
	Local $aRet = DllCall('user32.dll', 'bool', 'OemToChar', 'str', $sStr, 'str', '')
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_OemToChar

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_PointFromRect(ByRef $tRECT, $bCenter = True)
	Local $iX1 = DllStructGetData($tRECT, "Left")
	Local $iY1 = DllStructGetData($tRECT, "Top")
	Local $iX2 = DllStructGetData($tRECT, "Right")
	Local $iY2 = DllStructGetData($tRECT, "Bottom")
	If $bCenter Then
		$iX1 = $iX1 + (($iX2 - $iX1) / 2)
		$iY1 = $iY1 + (($iY2 - $iY1) / 2)
	EndIf
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $iX1)
	DllStructSetData($tPoint, "Y", $iY1)
	Return $tPoint
EndFunc   ;==>_WinAPI_PointFromRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_PrimaryLangId($iLngID)
	Return BitAND($iLngID, 0x3FF)
EndFunc   ;==>_WinAPI_PrimaryLangId

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ScreenToClient($hWnd, ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ScreenToClient

; #FUNCTION# ====================================================================================================================
; Author.........: Progandy
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShortToWord($iValue)
	Return BitAND($iValue, 0x0000FFFF)
EndFunc   ;==>_WinAPI_ShortToWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrFormatByteSize($iSize)
	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'StrFormatByteSizeW', 'int64', $iSize, 'wstr', '', 'uint', 1024)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_StrFormatByteSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_StrFormatByteSizeEx($iSize)
	Local $aSymbol = DllCall('kernel32.dll', 'int', 'GetLocaleInfoW', 'dword', 0x0400, 'dword', 0x000F, 'wstr', '', 'int', 2048)
	If @error Then Return SetError(@error + 10, @extended, '')

	Local $sSize = _WinAPI_StrFormatByteSize(0)
	If @error Then Return SetError(@error, @extended, '')

	Return StringReplace($sSize, '0', StringRegExpReplace(Number($iSize), '(?<=\d)(?=(\d{3})+\z)', $aSymbol[3]))
EndFunc   ;==>_WinAPI_StrFormatByteSizeEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrFormatKBSize($iSize)
	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'StrFormatKBSizeW', 'int64', $iSize, 'wstr', '', 'uint', 1024)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_StrFormatKBSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrFromTimeInterval($iTime, $iDigits = 7)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'StrFromTimeIntervalW', 'wstr', '', 'uint', 1024, 'dword', $iTime, _
			'int', $iDigits)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return StringStripWS($aRet[1], $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc   ;==>_WinAPI_StrFromTimeInterval

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_StringFromGUID($tGUID)
	Local $aResult = DllCall("ole32.dll", "int", "StringFromGUID2", "struct*", $tGUID, "wstr", "", "int", 40)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")

	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_StringFromGUID

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SubLangId($iLngID)
	Return BitShift($iLngID, 10)
EndFunc   ;==>_WinAPI_SubLangId

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SwapDWord($iValue)
	Local $tStruct1 = DllStructCreate('dword;dword')
	Local $tStruct2 = DllStructCreate('byte[4];byte[4]', DllStructGetPtr($tStruct1))
	DllStructSetData($tStruct1, 1, $iValue)
	For $i = 1 To 4
		DllStructSetData($tStruct2, 2, DllStructGetData($tStruct2, 1, 5 - $i), $i)
	Next

	Return DllStructGetData($tStruct1, 2)
EndFunc   ;==>_WinAPI_SwapDWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SwapQWord($iValue)
	Local $tStruct1 = DllStructCreate('int64;int64')
	Local $tStruct2 = DllStructCreate('byte[8];byte[8]', DllStructGetPtr($tStruct1))
	DllStructSetData($tStruct1, 1, $iValue)
	For $i = 1 To 8
		DllStructSetData($tStruct2, 2, DllStructGetData($tStruct2, 1, 9 - $i), $i)
	Next

	Return DllStructGetData($tStruct1, 2)
EndFunc   ;==>_WinAPI_SwapQWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SwapWord($iValue)
	Local $tStruct1 = DllStructCreate('word;word')
	Local $tStruct2 = DllStructCreate('byte[2];byte[2]', DllStructGetPtr($tStruct1))
	DllStructSetData($tStruct1, 1, $iValue)
	For $i = 1 To 2
		DllStructSetData($tStruct2, 2, DllStructGetData($tStruct2, 1, 3 - $i), $i)
	Next

	Return DllStructGetData($tStruct1, 2)
EndFunc   ;==>_WinAPI_SwapWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM, Alexander Samuelsson (AdmiralAlkex), Melba23
; ===============================================================================================================================
Func _WinAPI_WideCharToMultiByte($vUnicode, $iCodePage = 0, $bRetNoStruct = True, $bRetBinary = False)
	Local $sUnicodeType = "wstr"
	If Not IsString($vUnicode) Then $sUnicodeType = "struct*"
	Local $aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, "int", -1, _
			"ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 20, @extended, "")

	Local $tMultiByte = DllStructCreate((($bRetBinary) ? ("byte") : ("char")) & "[" & $aResult[0] & "]")

	$aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, _
			"int", -1, "struct*", $tMultiByte, "int", $aResult[0], "ptr", 0, "ptr", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	If $bRetNoStruct Then Return DllStructGetData($tMultiByte, 1)
	Return $tMultiByte
EndFunc   ;==>_WinAPI_WideCharToMultiByte

; #FUNCTION# ====================================================================================================================
; Author.........: Progandy
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WordToShort($iValue)
	If BitAND($iValue, 0x00008000) Then
		Return BitOR($iValue, 0xFFFF8000)
	EndIf
	Return BitAND($iValue, 0x00007FFF)
EndFunc   ;==>_WinAPI_WordToShort

#EndRegion Public Functions
