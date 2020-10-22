#include-once

#include "HeaderConstants.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPIConv.au3"
#include "WinAPIHObj.au3"
#include "WinAPISysInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: Header
; AutoIt Version : 3.3.14.5
; Description ...: Functions that assist with Header control management.
;                  A header control is a window that is usually positioned above columns of text or numbers.  It contains a title
;                  for each column, and it can be divided into parts.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hHDRLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__HEADERCONSTANT_ClassName = "SysHeader32"
Global Const $__HEADERCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__HEADERCONSTANT_SWP_SHOWWINDOW = 0x0040
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlHeader_AddItem
; _GUICtrlHeader_ClearFilter
; _GUICtrlHeader_ClearFilterAll
; _GUICtrlHeader_Create
; _GUICtrlHeader_CreateDragImage
; _GUICtrlHeader_DeleteItem
; _GUICtrlHeader_Destroy
; _GUICtrlHeader_EditFilter
; _GUICtrlHeader_GetBitmapMargin
; _GUICtrlHeader_GetImageList
; _GUICtrlHeader_GetItem
; _GUICtrlHeader_GetItemAlign
; _GUICtrlHeader_GetItemBitmap
; _GUICtrlHeader_GetItemCount
; _GUICtrlHeader_GetItemDisplay
; _GUICtrlHeader_GetItemFlags
; _GUICtrlHeader_GetItemFormat
; _GUICtrlHeader_GetItemImage
; _GUICtrlHeader_GetItemOrder
; _GUICtrlHeader_GetItemParam
; _GUICtrlHeader_GetItemRect
; _GUICtrlHeader_GetItemRectEx
; _GUICtrlHeader_GetItemText
; _GUICtrlHeader_GetItemWidth
; _GUICtrlHeader_GetOrderArray
; _GUICtrlHeader_GetUnicodeFormat
; _GUICtrlHeader_HitTest
; _GUICtrlHeader_InsertItem
; _GUICtrlHeader_Layout
; _GUICtrlHeader_OrderToIndex
; _GUICtrlHeader_SetBitmapMargin
; _GUICtrlHeader_SetFilterChangeTimeout
; _GUICtrlHeader_SetHotDivider
; _GUICtrlHeader_SetImageList
; _GUICtrlHeader_SetItem
; _GUICtrlHeader_SetItemAlign
; _GUICtrlHeader_SetItemBitmap
; _GUICtrlHeader_SetItemDisplay
; _GUICtrlHeader_SetItemFlags
; _GUICtrlHeader_SetItemFormat
; _GUICtrlHeader_SetItemImage
; _GUICtrlHeader_SetItemOrder
; _GUICtrlHeader_SetItemParam
; _GUICtrlHeader_SetItemText
; _GUICtrlHeader_SetItemWidth
; _GUICtrlHeader_SetOrderArray
; _GUICtrlHeader_SetUnicodeFormat
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagHDHITTESTINFO
; $tagHDLAYOUT
; $tagHDTEXTFILTER
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagHDHITTESTINFO
; Description ...: Contains information about a hit test
; Fields ........: X     - Horizontal postion to be hit test, in client coordinates
;                  Y     - Vertical position to be hit test, in client coordinates
;                  Flags - Information about the results of a hit test
;                  Item  - If the hit test is successful, contains the index of the item at the hit test point
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: This structure is used with the $HDM_HITTEST message.
; ===============================================================================================================================
Global Const $tagHDHITTESTINFO = $tagPOINT & ";uint Flags;int Item"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagHDLAYOUT
; Description ...: Contains information used to set the size and position of the control
; Fields ........: Rect      - Pointer to a RECT structure that contains the rectangle that the header control will occupy
;                  WindowPos - Pointer to a WINDOWPOS structure that receives information about the size/position of the control
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: This structure is used with the $HDM_LAYOUT message
; ===============================================================================================================================
Global Const $tagHDLAYOUT = "ptr Rect;ptr WindowPos"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagHDTEXTFILTER
; Description ...: Contains information about header control text filters
; Fields ........: Text    - Pointer to the buffer containing the filter
;                  TextMax - The maximum size, in characters, for an edit control buffer
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagHDTEXTFILTER = "ptr Text;int TextMax"

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_AddItem($hWnd, $sText, $iWidth = 50, $iAlign = 0, $iImage = -1, $bOnRight = False)
	Return _GUICtrlHeader_InsertItem($hWnd, _GUICtrlHeader_GetItemCount($hWnd), $sText, $iWidth, $iAlign, $iImage, $bOnRight)
EndFunc   ;==>_GUICtrlHeader_AddItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_ClearFilter($hWnd, $iIndex)
	Return _SendMessage($hWnd, $HDM_CLEARFILTER, $iIndex) <> 0
EndFunc   ;==>_GUICtrlHeader_ClearFilter

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_ClearFilterAll($hWnd)
	Return _SendMessage($hWnd, $HDM_CLEARFILTER, -1) <> 0
EndFunc   ;==>_GUICtrlHeader_ClearFilterAll

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlHeader_Create($hWnd, $iStyle = 0x00000046)
	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hHeader = _WinAPI_CreateWindowEx(0, $__HEADERCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	Local $tWindowPos = _GUICtrlHeader_Layout($hHeader, $tRECT)
	Local $iFlags = BitOR(DllStructGetData($tWindowPos, "Flags"), $__HEADERCONSTANT_SWP_SHOWWINDOW)
	_WinAPI_SetWindowPos($hHeader, DllStructGetData($tWindowPos, "InsertAfter"), _
			DllStructGetData($tWindowPos, "X"), DllStructGetData($tWindowPos, "Y"), _
			DllStructGetData($tWindowPos, "CX"), DllStructGetData($tWindowPos, "CY"), $iFlags)
	_WinAPI_SetFont($hHeader, _WinAPI_GetStockObject($__HEADERCONSTANT_DEFAULT_GUI_FONT))
	Return $hHeader
EndFunc   ;==>_GUICtrlHeader_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_CreateDragImage($hWnd, $iIndex)
	Return Ptr(_SendMessage($hWnd, $HDM_CREATEDRAGIMAGE, $iIndex))
EndFunc   ;==>_GUICtrlHeader_CreateDragImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_DeleteItem($hWnd, $iIndex)
	Return _SendMessage($hWnd, $HDM_DELETEITEM, $iIndex) <> 0
EndFunc   ;==>_GUICtrlHeader_DeleteItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__HEADERCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
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
	Else
		$iDestroyed = GUICtrlDelete($hWnd)
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlHeader_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_EditFilter($hWnd, $iIndex, $bDiscard = True)
	Return _SendMessage($hWnd, $HDM_EDITFILTER, $iIndex, $bDiscard) <> 0
EndFunc   ;==>_GUICtrlHeader_EditFilter

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetBitmapMargin($hWnd)
	Return _SendMessage($hWnd, $HDM_GETBITMAPMARGIN)
EndFunc   ;==>_GUICtrlHeader_GetBitmapMargin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetImageList($hWnd)
	Return Ptr(_SendMessage($hWnd, $HDM_GETIMAGELIST))
EndFunc   ;==>_GUICtrlHeader_GetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItem($hWnd, $iIndex, ByRef $tItem)
	Local $bUnicode = _GUICtrlHeader_GetUnicodeFormat($hWnd)

	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		$iRet = _SendMessage($hWnd, $HDM_GETITEMW, $iIndex, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
		_MemWrite($tMemMap, $tItem)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $HDM_GETITEMW, $iIndex, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $HDM_GETITEMA, $iIndex, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tItem, $iItem)
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlHeader_GetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemAlign($hWnd, $iIndex)
	Switch BitAND(_GUICtrlHeader_GetItemFormat($hWnd, $iIndex), $HDF_JUSTIFYMASK)
		Case $HDF_LEFT
			Return 0
		Case $HDF_RIGHT
			Return 1
		Case $HDF_CENTER
			Return 2
		Case Else
			Return -1
	EndSwitch
EndFunc   ;==>_GUICtrlHeader_GetItemAlign

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemBitmap($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_BITMAP)
	_GUICtrlHeader_GetItem($hWnd, $iIndex, $tItem)
	Return DllStructGetData($tItem, "hBmp")
EndFunc   ;==>_GUICtrlHeader_GetItemBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemCount($hWnd)
	Return _SendMessage($hWnd, $HDM_GETITEMCOUNT)
EndFunc   ;==>_GUICtrlHeader_GetItemCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemDisplay($hWnd, $iIndex)
	Local $iRet = 0

	Local $iFormat = _GUICtrlHeader_GetItemFormat($hWnd, $iIndex)
	If BitAND($iFormat, $HDF_BITMAP) <> 0 Then $iRet = BitOR($iRet, 1)
	If BitAND($iFormat, $HDF_BITMAP_ON_RIGHT) <> 0 Then $iRet = BitOR($iRet, 2)
	If BitAND($iFormat, $HDF_OWNERDRAW) <> 0 Then $iRet = BitOR($iRet, 4)
	If BitAND($iFormat, $HDF_STRING) <> 0 Then $iRet = BitOR($iRet, 8)
	Return $iRet
EndFunc   ;==>_GUICtrlHeader_GetItemDisplay

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemFlags($hWnd, $iIndex)
	Local $iRet = 0

	Local $iFormat = _GUICtrlHeader_GetItemFormat($hWnd, $iIndex)
	If BitAND($iFormat, $HDF_IMAGE) <> 0 Then $iRet = BitOR($iRet, 1)
	If BitAND($iFormat, $HDF_RTLREADING) <> 0 Then $iRet = BitOR($iRet, 2)
	If BitAND($iFormat, $HDF_SORTDOWN) <> 0 Then $iRet = BitOR($iRet, 4)
	If BitAND($iFormat, $HDF_SORTUP) <> 0 Then $iRet = BitOR($iRet, 8)
	Return $iRet
EndFunc   ;==>_GUICtrlHeader_GetItemFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemFormat($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_FORMAT)
	_GUICtrlHeader_GetItem($hWnd, $iIndex, $tItem)
	Return DllStructGetData($tItem, "Fmt")
EndFunc   ;==>_GUICtrlHeader_GetItemFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemImage($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_IMAGE)
	_GUICtrlHeader_GetItem($hWnd, $iIndex, $tItem)
	Return DllStructGetData($tItem, "Image")
EndFunc   ;==>_GUICtrlHeader_GetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemOrder($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_ORDER)
	_GUICtrlHeader_GetItem($hWnd, $iIndex, $tItem)
	Return DllStructGetData($tItem, "Order")
EndFunc   ;==>_GUICtrlHeader_GetItemOrder

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemParam($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_PARAM)
	_GUICtrlHeader_GetItem($hWnd, $iIndex, $tItem)
	Return DllStructGetData($tItem, "Param")
EndFunc   ;==>_GUICtrlHeader_GetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemRect($hWnd, $iIndex)
	Local $aRect[4]

	Local $tRECT = _GUICtrlHeader_GetItemRectEx($hWnd, $iIndex)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlHeader_GetItemRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemRectEx($hWnd, $iIndex)
	Local $tRECT = DllStructCreate($tagRECT)
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		_SendMessage($hWnd, $HDM_GETITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_MemWrite($tMemMap, $tRECT)
		_SendMessage($hWnd, $HDM_GETITEMRECT, $iIndex, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlHeader_GetItemRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemText($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlHeader_GetUnicodeFormat($hWnd)

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_TEXT)
	DllStructSetData($tItem, "TextMax", 4096)
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
		_SendMessage($hWnd, $HDM_GETITEMW, $iIndex, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + DllStructGetSize($tBuffer), $tMemMap)
		Local $pText = $pMemory + $iItem
		DllStructSetData($tItem, "Text", $pText)
		_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		If $bUnicode Then
			_SendMessage($hWnd, $HDM_GETITEMW, $iIndex, $pMemory, 0, "wparam", "ptr")
		Else
			_SendMessage($hWnd, $HDM_GETITEMA, $iIndex, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pText, $tBuffer, DllStructGetSize($tBuffer))
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlHeader_GetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetItemWidth($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_WIDTH)
	_GUICtrlHeader_GetItem($hWnd, $iIndex, $tItem)
	Return DllStructGetData($tItem, "XY")
EndFunc   ;==>_GUICtrlHeader_GetItemWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetOrderArray($hWnd)
	Local $iItems = _GUICtrlHeader_GetItemCount($hWnd)
	Local $tBuffer = DllStructCreate("int[" & $iItems & "]")
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		_SendMessage($hWnd, $HDM_GETORDERARRAY, $iItems, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $iBuffer = DllStructGetSize($tBuffer)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		_SendMessage($hWnd, $HDM_GETORDERARRAY, $iItems, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
		_MemFree($tMemMap)
	EndIf

	Local $aBuffer[$iItems + 1]
	$aBuffer[0] = $iItems
	For $iI = 1 To $iItems
		$aBuffer[$iI] = DllStructGetData($tBuffer, 1, $iI)
	Next
	Return $aBuffer
EndFunc   ;==>_GUICtrlHeader_GetOrderArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_GetUnicodeFormat($hWnd)
	Return _SendMessage($hWnd, $HDM_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlHeader_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_HitTest($hWnd, $iX, $iY)
	Local $tTest = DllStructCreate($tagHDHITTESTINFO)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	Local $aTest[11]
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		$aTest[0] = _SendMessage($hWnd, $HDM_HITTEST, 0, $tTest, 0, "wparam", "struct*")
	Else
		Local $iTest = DllStructGetSize($tTest)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iTest, $tMemMap)
		_MemWrite($tMemMap, $tTest)
		$aTest[0] = _SendMessage($hWnd, $HDM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tTest, $iTest)
		_MemFree($tMemMap)
	EndIf
	Local $iFlags = DllStructGetData($tTest, "Flags")
	$aTest[1] = BitAND($iFlags, $HHT_NOWHERE) <> 0
	$aTest[2] = BitAND($iFlags, $HHT_ONHEADER) <> 0
	$aTest[3] = BitAND($iFlags, $HHT_ONDIVIDER) <> 0
	$aTest[4] = BitAND($iFlags, $HHT_ONDIVOPEN) <> 0
	$aTest[5] = BitAND($iFlags, $HHT_ONFILTER) <> 0
	$aTest[6] = BitAND($iFlags, $HHT_ONFILTERBUTTON) <> 0
	$aTest[7] = BitAND($iFlags, $HHT_ABOVE) <> 0
	$aTest[8] = BitAND($iFlags, $HHT_BELOW) <> 0
	$aTest[9] = BitAND($iFlags, $HHT_TORIGHT) <> 0
	$aTest[10] = BitAND($iFlags, $HHT_TOLEFT) <> 0
	Return $aTest
EndFunc   ;==>_GUICtrlHeader_HitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_InsertItem($hWnd, $iIndex, $sText, $iWidth = 50, $iAlign = 0, $iImage = -1, $bOnRight = False)
	Local $aAlign[3] = [$HDF_LEFT, $HDF_RIGHT, $HDF_CENTER]
	Local $bUnicode = _GUICtrlHeader_GetUnicodeFormat($hWnd)

	Local $pBuffer, $iBuffer
	If $sText <> -1 Then
		$iBuffer = StringLen($sText) + 1
		Local $tBuffer
		If $bUnicode Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		DllStructSetData($tBuffer, "Text", $sText)
		$pBuffer = DllStructGetPtr($tBuffer)
	Else
		$iBuffer = 0
		$pBuffer = -1 ; LPSTR_TEXTCALLBACK
	EndIf
	Local $tItem = DllStructCreate($tagHDITEM)
	Local $iFmt = $aAlign[$iAlign]
	Local $iMask = BitOR($HDI_WIDTH, $HDI_FORMAT)
	If $sText <> "" Then
		$iMask = BitOR($iMask, $HDI_TEXT)
		$iFmt = BitOR($iFmt, $HDF_STRING)
	EndIf
	If $iImage <> -1 Then
		$iMask = BitOR($iMask, $HDI_IMAGE)
		$iFmt = BitOR($iFmt, $HDF_IMAGE)
	EndIf
	If $bOnRight Then $iFmt = BitOR($iFmt, $HDF_BITMAP_ON_RIGHT)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "XY", $iWidth)
	DllStructSetData($tItem, "Fmt", $iFmt)
	DllStructSetData($tItem, "Image", $iImage)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		DllStructSetData($tItem, "Text", $pBuffer)
		$iRet = _SendMessage($hWnd, $HDM_INSERTITEMW, $iIndex, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		If $sText <> -1 Then
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		Else
			DllStructSetData($tItem, "Text", -1) ; LPSTR_TEXTCALLBACK
		EndIf
		_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $HDM_INSERTITEMW, $iIndex, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $HDM_INSERTITEMA, $iIndex, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlHeader_InsertItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_Layout($hWnd, ByRef $tRECT)
	Local $tLayout = DllStructCreate($tagHDLAYOUT)
	Local $tWindowPos = DllStructCreate($tagWINDOWPOS)
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		DllStructSetData($tLayout, "Rect", DllStructGetPtr($tRECT))
		DllStructSetData($tLayout, "WindowPos", DllStructGetPtr($tWindowPos))
		_SendMessage($hWnd, $HDM_LAYOUT, 0, $tLayout, 0, "wparam", "struct*")
	Else
		Local $iLayout = DllStructGetSize($tLayout)
		Local $iRect = DllStructGetSize($tRECT)
		Local $iWindowPos = DllStructGetSize($tWindowPos)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iLayout + $iRect + $iWindowPos, $tMemMap)
		DllStructSetData($tLayout, "Rect", $pMemory + $iLayout)
		DllStructSetData($tLayout, "WindowPos", $pMemory + $iLayout + $iRect)
		_MemWrite($tMemMap, $tLayout, $pMemory, $iLayout)
		_MemWrite($tMemMap, $tRECT, $pMemory + $iLayout, $iRect)
		_SendMessage($hWnd, $HDM_LAYOUT, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory + $iLayout + $iRect, $tWindowPos, $iWindowPos)
		_MemFree($tMemMap)
	EndIf
	Return $tWindowPos
EndFunc   ;==>_GUICtrlHeader_Layout

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_OrderToIndex($hWnd, $iOrder)
	Return _SendMessage($hWnd, $HDM_ORDERTOINDEX, $iOrder)
EndFunc   ;==>_GUICtrlHeader_OrderToIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetBitmapMargin($hWnd, $iWidth)
	Return _SendMessage($hWnd, $HDM_SETBITMAPMARGIN, $iWidth)
EndFunc   ;==>_GUICtrlHeader_SetBitmapMargin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetFilterChangeTimeout($hWnd, $iTimeOut)
	Return _SendMessage($hWnd, $HDM_SETFILTERCHANGETIMEOUT, 0, $iTimeOut)
EndFunc   ;==>_GUICtrlHeader_SetFilterChangeTimeout

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetHotDivider($hWnd, $iFlag, $iInputValue)
	Return _SendMessage($hWnd, $HDM_SETHOTDIVIDER, $iFlag, $iInputValue)
EndFunc   ;==>_GUICtrlHeader_SetHotDivider

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetImageList($hWnd, $hImage)
	Return _SendMessage($hWnd, $HDM_SETIMAGELIST, 0, $hImage, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlHeader_SetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItem($hWnd, $iIndex, ByRef $tItem)
	Local $bUnicode = _GUICtrlHeader_GetUnicodeFormat($hWnd)

	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		$iRet = _SendMessage($hWnd, $HDM_SETITEMW, $iIndex, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
		_MemWrite($tMemMap, $tItem)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $HDM_SETITEMW, $iIndex, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $HDM_SETITEMA, $iIndex, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlHeader_SetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemAlign($hWnd, $iIndex, $iAlign)
	Local $aAlign[3] = [$HDF_LEFT, $HDF_RIGHT, $HDF_CENTER]

	Local $iFormat = _GUICtrlHeader_GetItemFormat($hWnd, $iIndex)
	$iFormat = BitAND($iFormat, BitNOT($HDF_JUSTIFYMASK))
	$iFormat = BitOR($iFormat, $aAlign[$iAlign])
	Return _GUICtrlHeader_SetItemFormat($hWnd, $iIndex, $iFormat)
EndFunc   ;==>_GUICtrlHeader_SetItemAlign

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemBitmap($hWnd, $iIndex, $hBitmap)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", BitOR($HDI_FORMAT, $HDI_BITMAP))
	DllStructSetData($tItem, "Fmt", $HDF_BITMAP)
	DllStructSetData($tItem, "hBMP", $hBitmap)
	Return _GUICtrlHeader_SetItem($hWnd, $iIndex, $tItem)
EndFunc   ;==>_GUICtrlHeader_SetItemBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemDisplay($hWnd, $iIndex, $iDisplay)
	Local $iFormat = BitAND(_GUICtrlHeader_GetItemFormat($hWnd, $iIndex), Not $HDF_DISPLAYMASK)
	If BitAND($iDisplay, 1) <> 0 Then $iFormat = BitOR($iFormat, $HDF_BITMAP)
	If BitAND($iDisplay, 2) <> 0 Then $iFormat = BitOR($iFormat, $HDF_BITMAP_ON_RIGHT)
	If BitAND($iDisplay, 4) <> 0 Then $iFormat = BitOR($iFormat, $HDF_OWNERDRAW)
	If BitAND($iDisplay, 8) <> 0 Then $iFormat = BitOR($iFormat, $HDF_STRING)
	Return _GUICtrlHeader_SetItemFormat($hWnd, $iIndex, $iFormat)
EndFunc   ;==>_GUICtrlHeader_SetItemDisplay

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemFlags($hWnd, $iIndex, $iFlags)
	Local $iFormat = _GUICtrlHeader_GetItemFormat($hWnd, $iIndex)
	$iFormat = BitAND($iFormat, BitNOT($HDF_FLAGMASK))
	If BitAND($iFlags, 1) <> 0 Then $iFormat = BitOR($iFormat, $HDF_IMAGE)
	If BitAND($iFlags, 2) <> 0 Then $iFormat = BitOR($iFormat, $HDF_RTLREADING)
	If BitAND($iFlags, 4) <> 0 Then $iFormat = BitOR($iFormat, $HDF_SORTDOWN)
	If BitAND($iFlags, 8) <> 0 Then $iFormat = BitOR($iFormat, $HDF_SORTUP)
	Return _GUICtrlHeader_SetItemFormat($hWnd, $iIndex, $iFormat)
EndFunc   ;==>_GUICtrlHeader_SetItemFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemFormat($hWnd, $iIndex, $iFormat)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_FORMAT)
	DllStructSetData($tItem, "Fmt", $iFormat)
	Return _GUICtrlHeader_SetItem($hWnd, $iIndex, $tItem)
EndFunc   ;==>_GUICtrlHeader_SetItemFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemImage($hWnd, $iIndex, $iImage)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_IMAGE)
	DllStructSetData($tItem, "Image", $iImage)
	Return _GUICtrlHeader_SetItem($hWnd, $iIndex, $tItem)
EndFunc   ;==>_GUICtrlHeader_SetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemOrder($hWnd, $iIndex, $iOrder)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_ORDER)
	DllStructSetData($tItem, "Order", $iOrder)
	Return _GUICtrlHeader_SetItem($hWnd, $iIndex, $tItem)
EndFunc   ;==>_GUICtrlHeader_SetItemOrder

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemParam($hWnd, $iIndex, $iParam)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_PARAM)
	DllStructSetData($tItem, "Param", $iParam)
	Return _GUICtrlHeader_SetItem($hWnd, $iIndex, $tItem)
EndFunc   ;==>_GUICtrlHeader_SetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemText($hWnd, $iIndex, $sText)
	Local $bUnicode = _GUICtrlHeader_GetUnicodeFormat($hWnd)

	Local $iBuffer, $pBuffer
	If $sText <> -1 Then
		$iBuffer = StringLen($sText) + 1
		Local $tBuffer
		If $bUnicode Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		DllStructSetData($tBuffer, "Text", $sText)
		$pBuffer = DllStructGetPtr($tBuffer)
	Else
		$iBuffer = 0
		$pBuffer = -1 ; LPSTR_TEXTCALLBACK
	EndIf
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_TEXT)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		DllStructSetData($tItem, "Text", $pBuffer)
		$iRet = _SendMessage($hWnd, $HDM_SETITEMW, $iIndex, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		If $sText <> -1 Then
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		Else
			DllStructSetData($tItem, "Text", -1) ; LPSTR_TEXTCALLBACK
		EndIf
		_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $HDM_SETITEMW, $iIndex, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $HDM_SETITEMA, $iIndex, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlHeader_SetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetItemWidth($hWnd, $iIndex, $iWidth)
	Local $tItem = DllStructCreate($tagHDITEM)
	DllStructSetData($tItem, "Mask", $HDI_WIDTH)
	DllStructSetData($tItem, "XY", $iWidth)
	Return _GUICtrlHeader_SetItem($hWnd, $iIndex, $tItem)
EndFunc   ;==>_GUICtrlHeader_SetItemWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetOrderArray($hWnd, ByRef $aOrder)
	Local $tBuffer = DllStructCreate("int[" & $aOrder[0] & "]")
	For $iI = 1 To $aOrder[0]
		DllStructSetData($tBuffer, 1, $aOrder[$iI], $iI)
	Next
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hHDRLastWnd) Then
		$iRet = _SendMessage($hWnd, $HDM_SETORDERARRAY, $aOrder[0], $tBuffer, 0, "wparam", "struct*")
	Else
		Local $iBuffer = DllStructGetSize($tBuffer)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		_MemWrite($tMemMap, $tBuffer)
		$iRet = _SendMessage($hWnd, $HDM_SETORDERARRAY, $aOrder[0], $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlHeader_SetOrderArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlHeader_SetUnicodeFormat($hWnd, $bUnicode)
	Return _SendMessage($hWnd, $HDM_SETUNICODEFORMAT, $bUnicode)
EndFunc   ;==>_GUICtrlHeader_SetUnicodeFormat
