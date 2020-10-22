#include-once

#include "APIMiscConstants.au3"
#include "StringConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIConv.au3"
#include "WinAPIMem.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIMisc.au3
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
; _WinAPI_ArrayToStruct
; _WinAPI_CopyStruct
; _WinAPI_CreateMargins
; _WinAPI_CreatePoint
; _WinAPI_CreateRect
; _WinAPI_CreateRectEx
; _WinAPI_CreateSize
; _WinAPI_GetExtended
; _WinAPI_GetMousePos
; _WinAPI_GetMousePosX
; _WinAPI_GetMousePosY
; _WinAPI_MulDiv
; _WinAPI_PlaySound
; _WinAPI_StringLenA
; _WinAPI_StringLenW
; _WinAPI_StructToArray
; _WinAPI_UnionStruct
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ArrayToStruct(Const ByRef $aData, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aData, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'wchar[' & (StringLen($aData[$i]) + 1) & '];'
	Next
	Local $tData = DllStructCreate($tagStruct & 'wchar[1]')

	Local $iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tData, $iCount, $aData[$i])
		$iCount += 1
	Next
	DllStructSetData($tData, $iCount, ChrW(0))
	Return $tData
EndFunc   ;==>_WinAPI_ArrayToStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateMargins($iLeftWidth, $iRightWidth, $iTopHeight, $iBottomHeight)
	Local $tMARGINS = DllStructCreate($tagMARGINS)

	DllStructSetData($tMARGINS, 1, $iLeftWidth)
	DllStructSetData($tMARGINS, 2, $iRightWidth)
	DllStructSetData($tMARGINS, 3, $iTopHeight)
	DllStructSetData($tMARGINS, 4, $iBottomHeight)

	Return $tMARGINS
EndFunc   ;==>_WinAPI_CreateMargins

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreatePoint($iX, $iY)
	Local $tPOINT = DllStructCreate($tagPOINT)
	DllStructSetData($tPOINT, 1, $iX)
	DllStructSetData($tPOINT, 2, $iY)

	Return $tPOINT
EndFunc   ;==>_WinAPI_CreatePoint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRect($iLeft, $iTop, $iRight, $iBottom)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 1, $iLeft)
	DllStructSetData($tRECT, 2, $iTop)
	DllStructSetData($tRECT, 3, $iRight)
	DllStructSetData($tRECT, 4, $iBottom)

	Return $tRECT
EndFunc   ;==>_WinAPI_CreateRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRectEx($iX, $iY, $iWidth, $iHeight)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 1, $iX)
	DllStructSetData($tRECT, 2, $iY)
	DllStructSetData($tRECT, 3, $iX + $iWidth)
	DllStructSetData($tRECT, 4, $iY + $iHeight)

	Return $tRECT
EndFunc   ;==>_WinAPI_CreateRectEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateSize($iWidth, $iHeight)
	Local $tSIZE = DllStructCreate($tagSIZE)
	DllStructSetData($tSIZE, 1, $iWidth)
	DllStructSetData($tSIZE, 2, $iHeight)

	Return $tSIZE
EndFunc   ;==>_WinAPI_CreateSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CopyStruct($tStruct, $sStruct = '')
	Local $iSize = DllStructGetSize($tStruct)
	If Not $iSize Then Return SetError(1, 0, 0)

	Local $tResult
	If Not StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES) Then
		$tResult = DllStructCreate('byte[' & $iSize & ']')
	Else
		$tResult = DllStructCreate($sStruct)
	EndIf
	If DllStructGetSize($tResult) < $iSize Then Return SetError(2, 0, 0)

	_WinAPI_MoveMemory($tResult, $tStruct, $iSize)
	; Return SetError(3, 0, 0) ; cannot really occur
	; EndIf
	Return $tResult
EndFunc   ;==>_WinAPI_CopyStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetExtended()
	Return $__g_vExt
EndFunc   ;==>_WinAPI_GetExtended

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetMousePos($bToClient = False, $hWnd = 0)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)

	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	If $bToClient And Not _WinAPI_ScreenToClient($hWnd, $tPoint) Then Return SetError(@error + 20, @extended, 0)

	Return $tPoint
EndFunc   ;==>_WinAPI_GetMousePos

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetMousePosX($bToClient = False, $hWnd = 0)
	Local $tPoint = _WinAPI_GetMousePos($bToClient, $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tPoint, "X")
EndFunc   ;==>_WinAPI_GetMousePosX

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetMousePosY($bToClient = False, $hWnd = 0)
	Local $tPoint = _WinAPI_GetMousePos($bToClient, $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tPoint, "Y")
EndFunc   ;==>_WinAPI_GetMousePosY

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MulDiv($iNumber, $iNumerator, $iDenominator)
	Local $aResult = DllCall("kernel32.dll", "int", "MulDiv", "int", $iNumber, "int", $iNumerator, "int", $iDenominator)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MulDiv

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PlaySound($sSound, $iFlags = $SND_SYSTEM_NOSTOP, $hInstance = 0)
	Local $sTypeOfSound = 'ptr'
	If $sSound Then
		If IsString($sSound) Then
			$sTypeOfSound = 'wstr'
		EndIf
	Else
		$sSound = 0
		$iFlags = 0
	EndIf

	Local $aRet = DllCall('winmm.dll', 'bool', 'PlaySoundW', $sTypeOfSound, $sSound, 'handle', $hInstance, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PlaySound

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_StringLenA(Const ByRef $tString)
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenA", "struct*", $tString)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_StringLenA

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_StringLenW(Const ByRef $tString)
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $tString)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_StringLenW

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_StructToArray(ByRef $tStruct, $iItems = 0)
	Local $iSize = 2 * Floor(DllStructGetSize($tStruct) / 2)
	Local $pStruct = DllStructGetPtr($tStruct)

	If Not $iSize Or Not $pStruct Then Return SetError(1, 0, 0)

	Local $tData, $iLength, $iOffset = 0
	Local $aResult[101] = [0]

	While 1
		$iLength = _WinAPI_StrLen($pStruct + $iOffset)
		If Not $iLength Then
			ExitLoop
		EndIf
		If 2 * (1 + $iLength) + $iOffset > $iSize Then Return SetError(3, 0, 0)
		$tData = DllStructCreate('wchar[' & (1 + $iLength) & ']', $pStruct + $iOffset)
		If @error Then Return SetError(@error + 10, 0, 0)
		__Inc($aResult)
		$aResult[$aResult[0]] = DllStructGetData($tData, 1)
		If $aResult[0] = $iItems Then
			ExitLoop
		EndIf
		$iOffset += 2 * (1 + $iLength)
		If $iOffset >= $iSize Then Return SetError(3, 0, 0)
	WEnd
	If Not $aResult[0] Then Return SetError(2, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_StructToArray

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UnionStruct($tStruct1, $tStruct2, $sStruct = '')
	Local $aSize[2] = [DllStructGetSize($tStruct1), DllStructGetSize($tStruct2)]

	If Not $aSize[0] Or Not $aSize[1] Then Return SetError(1, 0, 0)

	Local $tResult
	If Not StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES) Then
		$tResult = DllStructCreate('byte[' & ($aSize[0] + $aSize[1]) & ']')
	Else
		$tResult = DllStructCreate($sStruct)
	EndIf
	If DllStructGetSize($tResult) < ($aSize[0] + $aSize[1]) Then Return SetError(2, 0, 0)

	_WinAPI_MoveMemory($tResult, $tStruct1, $aSize[0])
	_WinAPI_MoveMemory(DllStructGetPtr($tResult) + $aSize[0], $tStruct2, $aSize[1])
	; If (Not _WinAPI_MoveMemory($tResult, $tStruct1, $aSize[0])) Or (Not _WinAPI_MoveMemory($pResult + $aSize[0], $tStruct2, $aSize[1])) Then
	; Return SetError(3, 0, 0) ; cannot really occur
	; EndIf

	Return $tResult
EndFunc   ;==>_WinAPI_UnionStruct

#EndRegion Public Functions
