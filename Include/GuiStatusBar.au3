#include-once

#include "Memory.au3"
#include "SendMessage.au3"
#include "StatusBarConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPIConv.au3"
#include "WinAPISysInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: StatusBar
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist with StatusBar control management.
;                  A status bar is a horizontal window at the bottom of a parent window in which an application can display
;                  various kinds of status information.  The status bar can be divided into parts to display more than one type
;                  of information
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hSBLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__STATUSBARCONSTANT_ClassName = "msctls_statusbar32"
Global Const $__STATUSBARCONSTANT_WM_SIZE = 0x05
Global Const $__STATUSBARCONSTANT_CLR_DEFAULT = 0xFF000000
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlStatusBar_Create
; _GUICtrlStatusBar_Destroy
; _GUICtrlStatusBar_EmbedControl
; _GUICtrlStatusBar_GetBorders
; _GUICtrlStatusBar_GetBordersHorz
; _GUICtrlStatusBar_GetBordersRect
; _GUICtrlStatusBar_GetBordersVert
; _GUICtrlStatusBar_GetCount
; _GUICtrlStatusBar_GetHeight
; _GUICtrlStatusBar_GetIcon
; _GUICtrlStatusBar_GetParts
; _GUICtrlStatusBar_GetRect
; _GUICtrlStatusBar_GetRectEx
; _GUICtrlStatusBar_GetText
; _GUICtrlStatusBar_GetTextFlags
; _GUICtrlStatusBar_GetTextLength
; _GUICtrlStatusBar_GetTextLengthEx
; _GUICtrlStatusBar_GetTipText
; _GUICtrlStatusBar_GetUnicodeFormat
; _GUICtrlStatusBar_GetWidth
; _GUICtrlStatusBar_IsSimple
; _GUICtrlStatusBar_Resize
; _GUICtrlStatusBar_SetBkColor
; _GUICtrlStatusBar_SetIcon
; _GUICtrlStatusBar_SetMinHeight
; _GUICtrlStatusBar_SetParts
; _GUICtrlStatusBar_SetSimple
; _GUICtrlStatusBar_SetText
; _GUICtrlStatusBar_SetTipText
; _GUICtrlStatusBar_SetUnicodeFormat
; _GUICtrlStatusBar_ShowHide
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagBORDERS
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagBORDERS
; Description ...: Structure that recieves the current widths of the horizontal and vertical borders of a status window
; Fields ........: BX - Width of the horizontal border
;                  BY - Width of the vertical border
;                  RX - Width of the border between rectangles
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagBORDERS = "int BX;int BY;int RX"

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost, Steve Podhajecki <gehossafats at netmdc dot com>
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlStatusBar_Create($hWnd, $vPartEdge = -1, $vPartText = "", $iStyles = -1, $iExStyles = 0x00000000)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlStatusBar_Create 1st parameter

	Local $iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)

	If $iStyles = -1 Then $iStyles = 0x00000000
	If $iExStyles = -1 Then $iExStyles = 0x00000000

	Local $aPartWidth[1], $aPartText[1]
	If @NumParams > 1 Then ; more than param passed in
		; setting up arrays
		If IsArray($vPartEdge) Then ; setup part width array
			$aPartWidth = $vPartEdge
		Else
			$aPartWidth[0] = $vPartEdge
		EndIf
		If @NumParams = 2 Then ; part text was not passed in so set array to same size as part width array
			ReDim $aPartText[UBound($aPartWidth)]
		Else
			If IsArray($vPartText) Then ; setup part text array
				$aPartText = $vPartText
			Else
				$aPartText[0] = $vPartText
			EndIf
			; if partwidth array is not same size as parttext array use larger sized array for size
			If UBound($aPartWidth) <> UBound($aPartText) Then
				Local $iLast
				If UBound($aPartWidth) > UBound($aPartText) Then ; width array is larger
					$iLast = UBound($aPartText)
					ReDim $aPartText[UBound($aPartWidth)]
				Else ; text array is larger
					$iLast = UBound($aPartWidth)
					ReDim $aPartWidth[UBound($aPartText)]
					For $x = $iLast To UBound($aPartWidth) - 1
						$aPartWidth[$x] = $aPartWidth[$x - 1] + 75
					Next
					$aPartWidth[UBound($aPartText) - 1] = -1
				EndIf
			EndIf
		EndIf
		If Not IsHWnd($hWnd) Then $hWnd = HWnd($hWnd)
		If @NumParams > 3 Then $iStyle = BitOR($iStyle, $iStyles)
	EndIf

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hWndSBar = _WinAPI_CreateWindowEx($iExStyles, $__STATUSBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
	If @error Then Return SetError(@error, @extended, 0)

	If @NumParams > 1 Then ; set the parts/text
		_GUICtrlStatusBar_SetParts($hWndSBar, UBound($aPartWidth), $aPartWidth)
		For $x = 0 To UBound($aPartText) - 1
			_GUICtrlStatusBar_SetText($hWndSBar, $aPartText[$x], $x)
		Next
	EndIf
	Return $hWndSBar
EndFunc   ;==>_GUICtrlStatusBar_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__STATUSBARCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
			Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
			Local $hParent = _WinAPI_GetParent($hWnd)
			$iDestroyed = _WinAPI_DestroyWindow($hWnd)
			Local $iRet = __UDF_FreeGlobalID($hParent, $nCtrlID)
			If Not $iRet Then
				; can check for errors here if needed, for debug
			EndIf
		Else
			; Not Allowed to Destroy Other Applications Control(s)
			Return SetError(1, 1, False)
		EndIf
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlStatusBar_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_EmbedControl($hWnd, $iPart, $hControl, $iFit = 4)
	Local $aRect = _GUICtrlStatusBar_GetRect($hWnd, $iPart)
	Local $iBarX = $aRect[0]
	Local $iBarY = $aRect[1]
	Local $iBarW = $aRect[2] - $iBarX
	Local $iBarH = $aRect[3] - $iBarY

	Local $iConX = $iBarX
	Local $iConY = $iBarY
	Local $iConW = _WinAPI_GetWindowWidth($hControl)
	Local $iConH = _WinAPI_GetWindowHeight($hControl)

	If $iConW > $iBarW Then $iConW = $iBarW
	If $iConH > $iBarH Then $iConH = $iBarH
	Local $iPadX = ($iBarW - $iConW) / 2
	Local $iPadY = ($iBarH - $iConH) / 2
	If $iPadX < 0 Then $iPadX = 0
	If $iPadY < 0 Then $iPadY = 0

	If BitAND($iFit, 1) = 1 Then $iConX = $iBarX + $iPadX
	If BitAND($iFit, 2) = 2 Then $iConY = $iBarY + $iPadY
	If BitAND($iFit, 4) = 4 Then
		$iPadX = _GUICtrlStatusBar_GetBordersRect($hWnd)
		$iPadY = _GUICtrlStatusBar_GetBordersVert($hWnd)
		$iConX = $iBarX
		If _GUICtrlStatusBar_IsSimple($hWnd) Then $iConX += $iPadX
		$iConY = $iBarY + $iPadY
		$iConW = $iBarW - ($iPadX * 2)
		$iConH = $iBarH - ($iPadY * 2)
	EndIf

	_WinAPI_SetParent($hControl, $hWnd)
	_WinAPI_MoveWindow($hControl, $iConX, $iConY, $iConW, $iConH)
EndFunc   ;==>_GUICtrlStatusBar_EmbedControl

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetBorders($hWnd)
	Local $tBorders = DllStructCreate($tagBORDERS)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		$iRet = _SendMessage($hWnd, $SB_GETBORDERS, 0, $tBorders, 0, "wparam", "struct*")
	Else
		Local $iSize = DllStructGetSize($tBorders)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		$iRet = _SendMessage($hWnd, $SB_GETBORDERS, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tBorders, $iSize)
		_MemFree($tMemMap)
	EndIf
	Local $aBorders[3]
	If $iRet = 0 Then Return SetError(-1, -1, $aBorders)
	$aBorders[0] = DllStructGetData($tBorders, "BX")
	$aBorders[1] = DllStructGetData($tBorders, "BY")
	$aBorders[2] = DllStructGetData($tBorders, "RX")
	Return $aBorders
EndFunc   ;==>_GUICtrlStatusBar_GetBorders

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetBordersHorz($hWnd)
	Local $aBorders = _GUICtrlStatusBar_GetBorders($hWnd)
	Return SetError(@error, @extended, $aBorders[0])
EndFunc   ;==>_GUICtrlStatusBar_GetBordersHorz

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetBordersRect($hWnd)
	Local $aBorders = _GUICtrlStatusBar_GetBorders($hWnd)
	Return SetError(@error, @extended, $aBorders[2])
EndFunc   ;==>_GUICtrlStatusBar_GetBordersRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetBordersVert($hWnd)
	Local $aBorders = _GUICtrlStatusBar_GetBorders($hWnd)
	Return SetError(@error, @extended, $aBorders[1])
EndFunc   ;==>_GUICtrlStatusBar_GetBordersVert

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetCount($hWnd)
	Return _SendMessage($hWnd, $SB_GETPARTS)
EndFunc   ;==>_GUICtrlStatusBar_GetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost) Removed dot notation
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetHeight($hWnd)
	Local $tRECT = _GUICtrlStatusBar_GetRectEx($hWnd, 0)
	Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top") - (_GUICtrlStatusBar_GetBordersVert($hWnd) * 2)
EndFunc   ;==>_GUICtrlStatusBar_GetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Steve Podhajecki <gehossafats at netmdc dotcom>
; Modified.......: Gary Frost (GaryFrost)
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetIcon($hWnd, $iIndex = 0)
	Return _SendMessage($hWnd, $SB_GETICON, $iIndex, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlStatusBar_GetIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetParts($hWnd)
	Local $iCount = _GUICtrlStatusBar_GetCount($hWnd)
	Local $tParts = DllStructCreate("int[" & $iCount & "]")
	Local $aParts[$iCount + 1]
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		$aParts[0] = _SendMessage($hWnd, $SB_GETPARTS, $iCount, $tParts, 0, "wparam", "struct*")
	Else
		Local $iParts = DllStructGetSize($tParts)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iParts, $tMemMap)
		$aParts[0] = _SendMessage($hWnd, $SB_GETPARTS, $iCount, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tParts, $iParts)
		_MemFree($tMemMap)
	EndIf
	For $iI = 1 To $iCount
		$aParts[$iI] = DllStructGetData($tParts, 1, $iI)
	Next
	Return $aParts
EndFunc   ;==>_GUICtrlStatusBar_GetParts

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetRect($hWnd, $iPart)
	Local $tRECT = _GUICtrlStatusBar_GetRectEx($hWnd, $iPart)
	If @error Then Return SetError(@error, 0, 0)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlStatusBar_GetRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetRectEx($hWnd, $iPart)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		$iRet = _SendMessage($hWnd, $SB_GETRECT, $iPart, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		$iRet = _SendMessage($hWnd, $SB_GETRECT, $iPart, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	Return SetError($iRet = 0, 0, $tRECT)
EndFunc   ;==>_GUICtrlStatusBar_GetRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetText($hWnd, $iPart)
	Local $bUnicode = _GUICtrlStatusBar_GetUnicodeFormat($hWnd)

	Local $iBuffer = _GUICtrlStatusBar_GetTextLength($hWnd, $iPart) + 1
	If $iBuffer = 1 Then Return SetError(1, 0, "")

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		_SendMessage($hWnd, $SB_GETTEXTW, $iPart, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		If $bUnicode Then
			_SendMessage($hWnd, $SB_GETTEXTW, $iPart, $pMemory, 0, "wparam", "ptr")
		Else
			_SendMessage($hWnd, $SB_GETTEXT, $iPart, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlStatusBar_GetText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetTextFlags($hWnd, $iPart)
	If _GUICtrlStatusBar_GetUnicodeFormat($hWnd) Then
		Return _SendMessage($hWnd, $SB_GETTEXTLENGTHW, $iPart)
	Else
		Return _SendMessage($hWnd, $SB_GETTEXTLENGTH, $iPart)
	EndIf
EndFunc   ;==>_GUICtrlStatusBar_GetTextFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetTextLength($hWnd, $iPart)
	Return _WinAPI_LoWord(_GUICtrlStatusBar_GetTextFlags($hWnd, $iPart))
EndFunc   ;==>_GUICtrlStatusBar_GetTextLength

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetTextLengthEx($hWnd, $iPart)
	Return _WinAPI_HiWord(_GUICtrlStatusBar_GetTextFlags($hWnd, $iPart))
EndFunc   ;==>_GUICtrlStatusBar_GetTextLengthEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (GaryFrost)
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetTipText($hWnd, $iPart)
	Local $bUnicode = _GUICtrlStatusBar_GetUnicodeFormat($hWnd)

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		_SendMessage($hWnd, $SB_GETTIPTEXTW, _WinAPI_MakeLong($iPart, 4096), $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, 4096, $tMemMap)
		If $bUnicode Then
			_SendMessage($hWnd, $SB_GETTIPTEXTW, _WinAPI_MakeLong($iPart, 4096), $pMemory, 0, "wparam", "ptr")
		Else
			_SendMessage($hWnd, $SB_GETTIPTEXTA, _WinAPI_MakeLong($iPart, 4096), $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tBuffer, 4096)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlStatusBar_GetTipText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetUnicodeFormat($hWnd)
	Return _SendMessage($hWnd, $SB_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlStatusBar_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost) Removed dot notation
; ===============================================================================================================================
Func _GUICtrlStatusBar_GetWidth($hWnd, $iPart)
	Local $tRECT = _GUICtrlStatusBar_GetRectEx($hWnd, $iPart)
	Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left") - (_GUICtrlStatusBar_GetBordersHorz($hWnd) * 2)
EndFunc   ;==>_GUICtrlStatusBar_GetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_IsSimple($hWnd)
	Return _SendMessage($hWnd, $SB_ISSIMPLE) <> 0
EndFunc   ;==>_GUICtrlStatusBar_IsSimple

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_Resize($hWnd)
	_SendMessage($hWnd, $__STATUSBARCONSTANT_WM_SIZE)
EndFunc   ;==>_GUICtrlStatusBar_Resize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost), jpm
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetBkColor($hWnd, $iColor)
	$iColor = _SendMessage($hWnd, $SB_SETBKCOLOR, 0, $iColor)
EndFunc   ;==>_GUICtrlStatusBar_SetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetIcon($hWnd, $iPart, $hIcon = -1, $sIconFile = "")
	If $hIcon = -1 Then Return _SendMessage($hWnd, $SB_SETICON, $iPart, $hIcon, 0, "wparam", "handle") <> 0 ; Remove Icon
	If StringLen($sIconFile) <= 0 Then Return _SendMessage($hWnd, $SB_SETICON, $iPart, $hIcon) <> 0 ; set icon from icon handle
	; set icon from file
	Local $tIcon = DllStructCreate("handle")
	Local $vResult = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $sIconFile, "int", $hIcon, "ptr", 0, "struct*", $tIcon, "uint", 1)
	If @error Then Return SetError(@error, @extended, False)
	$vResult = $vResult[0]
	If $vResult > 0 Then $vResult = _SendMessage($hWnd, $SB_SETICON, $iPart, DllStructGetData($tIcon, 1), 0, "wparam", "handle")
	DllCall("user32.dll", "bool", "DestroyIcon", "handle", DllStructGetData($tIcon, 1))
	; No need to test @error.
	Return $vResult
EndFunc   ;==>_GUICtrlStatusBar_SetIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetMinHeight($hWnd, $iMinHeight)
	_SendMessage($hWnd, $SB_SETMINHEIGHT, $iMinHeight)
	_GUICtrlStatusBar_Resize($hWnd)
EndFunc   ;==>_GUICtrlStatusBar_SetMinHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetParts($hWnd, $vPartEdge = -1, $vPartWidth = 25)
	If IsArray($vPartEdge) And IsArray($vPartWidth) Then Return False

	;== start sizing parts
	Local $tParts, $iParts
	If IsArray($vPartEdge) Then ; adding array of parts (contains widths)
		$vPartEdge[UBound($vPartEdge) - 1] = -1
		$iParts = UBound($vPartEdge)
		$tParts = DllStructCreate("int[" & $iParts & "]")
		For $x = 0 To $iParts - 2
			DllStructSetData($tParts, 1, $vPartEdge[$x], $x + 1)
		Next
		DllStructSetData($tParts, 1, -1, $iParts)
	Else
		If $vPartEdge < -1 Then Return False

		If IsArray($vPartWidth) Then ; adding array of part widths (make parts an array)
			$iParts = UBound($vPartWidth)
			$tParts = DllStructCreate("int[" & $iParts & "]")
			Local $iPartRightEdge = 0
			For $x = 0 To $iParts - 2
				$iPartRightEdge += $vPartWidth[$x]
				If $vPartWidth[$x] <= 0 Then Return False
				DllStructSetData($tParts, 1, $iPartRightEdge, $x + 1)
			Next
			DllStructSetData($tParts, 1, -1, $iParts)
		ElseIf $vPartEdge > 1 Then ; adding parts with default width
			$iParts = $vPartEdge
			$tParts = DllStructCreate("int[" & $iParts & "]")
			For $x = 1 To $iParts - 1
				DllStructSetData($tParts, 1, $vPartWidth * $x, $x)
			Next
			DllStructSetData($tParts, 1, -1, $iParts)
		Else ; defaulting to 1 part
			$iParts = 1
			$tParts = DllStructCreate("int")
			DllStructSetData($tParts, 1, -1)
		EndIf
	EndIf
	;== end set sizing

	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		_SendMessage($hWnd, $SB_SETPARTS, $iParts, $tParts, 0, "wparam", "struct*")
	Else
		Local $iSize = DllStructGetSize($tParts)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		_MemWrite($tMemMap, $tParts)
		_SendMessage($hWnd, $SB_SETPARTS, $iParts, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	_GUICtrlStatusBar_Resize($hWnd)
	Return True
EndFunc   ;==>_GUICtrlStatusBar_SetParts

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetSimple($hWnd, $bSimple = True)
	_SendMessage($hWnd, $SB_SIMPLE, $bSimple)
EndFunc   ;==>_GUICtrlStatusBar_SetSimple

; #FUNCTION# ====================================================================================================================
; Author ........: rysiora, JdeB, tonedef, Gary Frost (gafrost)
; Modified.......: Gary Frost (gafrost) re-written also added $iUFlag
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetText($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
	Local $bUnicode = _GUICtrlStatusBar_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sText) + 1
	Local $tText
	If $bUnicode Then
		$tText = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tText = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tText, "Text", $sText)
	If _GUICtrlStatusBar_IsSimple($hWnd) Then $iPart = $SB_SIMPLEID
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		$iRet = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $iUFlag), $tText, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		_MemWrite($tMemMap, $tText)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $iUFlag), $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $SB_SETTEXT, BitOR($iPart, $iUFlag), $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlStatusBar_SetText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetTipText($hWnd, $iPart, $sText)
	Local $bUnicode = _GUICtrlStatusBar_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sText) + 1
	Local $tText
	If $bUnicode Then
		$tText = DllStructCreate("wchar TipText[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tText = DllStructCreate("char TipText[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tText, "TipText", $sText)
	If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
		_SendMessage($hWnd, $SB_SETTIPTEXTW, $iPart, $tText, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		_MemWrite($tMemMap, $tText, $pMemory, $iBuffer)
		If $bUnicode Then
			_SendMessage($hWnd, $SB_SETTIPTEXTW, $iPart, $pMemory, 0, "wparam", "ptr")
		Else
			_SendMessage($hWnd, $SB_SETTIPTEXTA, $iPart, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUICtrlStatusBar_SetTipText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_SetUnicodeFormat($hWnd, $bUnicode = True)
	Return _SendMessage($hWnd, $SB_SETUNICODEFORMAT, $bUnicode)
EndFunc   ;==>_GUICtrlStatusBar_SetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlStatusBar_ShowHide($hWnd, $iState)
	If $iState <> @SW_HIDE And $iState <> @SW_SHOW Then Return SetError(1, 1, False)
	Return _WinAPI_ShowWindow($hWnd, $iState)
EndFunc   ;==>_GUICtrlStatusBar_ShowHide
