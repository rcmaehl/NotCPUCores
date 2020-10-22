#include-once

#include "ComboConstants.au3"
#include "DirConstants.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPIConv.au3"
#include "WinAPIHObj.au3"
#include "WinAPISysInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: ComboBox
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist with ComboBox control management.
; Author(s) .....: gafrost, PaulIA, Valik
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hCBLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__COMBOBOXCONSTANT_ClassName = "ComboBox"
Global Const $__COMBOBOXCONSTANT_EM_GETLINE = 0xC4
Global Const $__COMBOBOXCONSTANT_EM_LINEINDEX = 0xBB
Global Const $__COMBOBOXCONSTANT_EM_LINELENGTH = 0xC1
Global Const $__COMBOBOXCONSTANT_EM_REPLACESEL = 0xC2

Global Const $__COMBOBOXCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__COMBOBOXCONSTANT_DEFAULT_GUI_FONT = 17
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlComboBox_SetLocale
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlComboBox_AddDir
; _GUICtrlComboBox_AddString
; _GUICtrlComboBox_AutoComplete
; _GUICtrlComboBox_BeginUpdate
; _GUICtrlComboBox_Create
; _GUICtrlComboBox_DeleteString
; _GUICtrlComboBox_Destroy
; _GUICtrlComboBox_EndUpdate
; _GUICtrlComboBox_FindString
; _GUICtrlComboBox_FindStringExact
; _GUICtrlComboBox_GetComboBoxInfo
; _GUICtrlComboBox_GetCount
; _GUICtrlComboBox_GetCueBanner
; _GUICtrlComboBox_GetCurSel
; _GUICtrlComboBox_GetDroppedControlRect
; _GUICtrlComboBox_GetDroppedControlRectEx
; _GUICtrlComboBox_GetDroppedState
; _GUICtrlComboBox_GetDroppedWidth
; _GUICtrlComboBox_GetEditSel
; _GUICtrlComboBox_GetEditText
; _GUICtrlComboBox_GetExtendedUI
; _GUICtrlComboBox_GetHorizontalExtent
; _GUICtrlComboBox_GetItemHeight
; _GUICtrlComboBox_GetLBText
; _GUICtrlComboBox_GetLBTextLen
; _GUICtrlComboBox_GetList
; _GUICtrlComboBox_GetListArray
; _GUICtrlComboBox_GetLocale
; _GUICtrlComboBox_GetLocaleCountry
; _GUICtrlComboBox_GetLocaleLang
; _GUICtrlComboBox_GetLocalePrimLang
; _GUICtrlComboBox_GetLocaleSubLang
; _GUICtrlComboBox_GetMinVisible
; _GUICtrlComboBox_GetTopIndex
; _GUICtrlComboBox_InitStorage
; _GUICtrlComboBox_InsertString
; _GUICtrlComboBox_LimitText
; _GUICtrlComboBox_ReplaceEditSel
; _GUICtrlComboBox_ResetContent
; _GUICtrlComboBox_SelectString
; _GUICtrlComboBox_SetCueBanner
; _GUICtrlComboBox_SetCurSel
; _GUICtrlComboBox_SetDroppedWidth
; _GUICtrlComboBox_SetEditSel
; _GUICtrlComboBox_SetEditText
; _GUICtrlComboBox_SetExtendedUI
; _GUICtrlComboBox_SetHorizontalExtent
; _GUICtrlComboBox_SetItemHeight
; _GUICtrlComboBox_SetMinVisible
; _GUICtrlComboBox_SetTopIndex
; _GUICtrlComboBox_ShowDropDown
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagCOMBOBOXINFO
; __GUICtrlComboBox_IsPressed
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagCOMBOBOXINFO
; Description ...: Contains combo box status information
; Fields ........: cbSize      - The size, in bytes, of the structure. The calling application must set this to sizeof(COMBOBOXINFO).
;                  rcItem      - A RECT structure that specifies the coordinates of the edit box.
;                  |EditLeft
;                  |EditTop
;                  |EditRight
;                  |EditBottom
;                  rcButton    - A RECT structure that specifies the coordinates of the button that contains the drop-down arrow.
;                  |BtnLeft
;                  |BtnTop
;                  |BtnRight
;                  |BtnBottom
;                  stateButton - The combo box button state. This parameter can be one of the following values.
;                  |0                       - The button exists and is not pressed.
;                  |$STATE_SYSTEM_INVISIBLE - There is no button.
;                  |$STATE_SYSTEM_PRESSED   - The button is pressed.
;                  hCombo      - A handle to the combo box.
;                  hEdit       - A handle to the edit box.
;                  hList       - A handle to the drop-down list.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCOMBOBOXINFO = "dword Size;struct;long EditLeft;long EditTop;long EditRight;long EditBottom;endstruct;" & _
		"struct;long BtnLeft;long BtnTop;long BtnRight;long BtnBottom;endstruct;dword BtnState;hwnd hCombo;hwnd hEdit;hwnd hList"

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_AddDir($hWnd, $sFilePath, $iAttributes = 0, $bBrackets = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If BitAND($iAttributes, $DDL_DRIVES) = $DDL_DRIVES And Not $bBrackets Then
		Local $sText
		Local $hGui_no_brackets = GUICreate("no brackets")
		Local $idCombo_no_brackets = GUICtrlCreateCombo("", 240, 40, 120, 120)
		Local $iRet = GUICtrlSendMsg($idCombo_no_brackets, $CB_DIR, $iAttributes, $sFilePath)
		For $i = 0 To _GUICtrlComboBox_GetCount($idCombo_no_brackets) - 1
			_GUICtrlComboBox_GetLBText($idCombo_no_brackets, $i, $sText)
			$sText = StringReplace(StringReplace(StringReplace($sText, "[", ""), "]", ":"), "-", "")
			_GUICtrlComboBox_InsertString($hWnd, $sText)
		Next
		GUIDelete($hGui_no_brackets)
		Return $iRet
	Else
		Return _SendMessage($hWnd, $CB_DIR, $iAttributes, $sFilePath, 0, "wparam", "wstr")
	EndIf
EndFunc   ;==>_GUICtrlComboBox_AddDir

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_AddString($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_ADDSTRING, 0, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlComboBox_AddString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_AutoComplete($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If Not __GUICtrlComboBox_IsPressed('08') And Not __GUICtrlComboBox_IsPressed("2E") Then ;backspace pressed or Del
		Local $sEditText = _GUICtrlComboBox_GetEditText($hWnd)
		If StringLen($sEditText) Then
			Local $sInputText
			Local $iRet = _GUICtrlComboBox_FindString($hWnd, $sEditText)
			If ($iRet <> $CB_ERR) Then
				_GUICtrlComboBox_GetLBText($hWnd, $iRet, $sInputText)
				_GUICtrlComboBox_SetEditText($hWnd, $sInputText)
				_GUICtrlComboBox_SetEditSel($hWnd, StringLen($sEditText), StringLen($sInputText))
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlComboBox_AutoComplete

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlComboBox_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__COMBOBOXCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlComboBox_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_Create($hWnd, $sText, $iX, $iY, $iWidth = 100, $iHeight = 120, $iStyle = 0x00200042, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlComboBox_Create 1st parameter
	If Not IsString($sText) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlComboBox_Create

	Local $aText, $sDelimiter = Opt("GUIDataSeparatorChar")

	If $iWidth = -1 Then $iWidth = 100
	If $iHeight = -1 Then $iHeight = 120
	Local Const $WS_VSCROLL = 0x00200000
	If $iStyle = -1 Then $iStyle = BitOR($WS_VSCROLL, $CBS_AUTOHSCROLL, $CBS_DROPDOWN)
	If $iExStyle = -1 Then $iExStyle = 0x00000000

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_TABSTOP, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hCombo = _WinAPI_CreateWindowEx($iExStyle, $__COMBOBOXCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hCombo, _WinAPI_GetStockObject($__COMBOBOXCONSTANT_DEFAULT_GUI_FONT))
	If StringLen($sText) Then
		$aText = StringSplit($sText, $sDelimiter)
		For $x = 1 To $aText[0]
			_GUICtrlComboBox_AddString($hCombo, $aText[$x])
		Next
	EndIf
	Return $hCombo
EndFunc   ;==>_GUICtrlComboBox_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_DeleteString($hWnd, $iIndex)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_DELETESTRING, $iIndex)
EndFunc   ;==>_GUICtrlComboBox_DeleteString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__COMBOBOXCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hCBLastWnd) Then
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
EndFunc   ;==>_GUICtrlComboBox_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlComboBox_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__COMBOBOXCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlComboBox_EndUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_FindString($hWnd, $sText, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_FINDSTRING, $iIndex, $sText, 0, "int", "wstr")
EndFunc   ;==>_GUICtrlComboBox_FindString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_FindStringExact($hWnd, $sText, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_FINDSTRINGEXACT, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlComboBox_FindStringExact

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetComboBoxInfo($hWnd, ByRef $tInfo)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	$tInfo = DllStructCreate($tagCOMBOBOXINFO)
	Local $iInfo = DllStructGetSize($tInfo)
	DllStructSetData($tInfo, "Size", $iInfo)
	Return _SendMessage($hWnd, $CB_GETCOMBOBOXINFO, 0, $tInfo, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlComboBox_GetComboBoxInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetCount($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETCOUNT)
EndFunc   ;==>_GUICtrlComboBox_GetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetCueBanner($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tText = DllStructCreate("wchar[4096]")
	If _SendMessage($hWnd, $CB_GETCUEBANNER, $tText, 4096, 0, "struct*") <> 1 Then Return SetError(-1, 0, "")
	Return _WinAPI_WideCharToMultiByte($tText)
EndFunc   ;==>_GUICtrlComboBox_GetCueBanner

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetCurSel($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETCURSEL)
EndFunc   ;==>_GUICtrlComboBox_GetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetDroppedControlRect($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $aRect[4]

	Local $tRECT = _GUICtrlComboBox_GetDroppedControlRectEx($hWnd)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")

	Return $aRect
EndFunc   ;==>_GUICtrlComboBox_GetDroppedControlRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetDroppedControlRectEx($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tRECT = DllStructCreate($tagRECT)
	_SendMessage($hWnd, $CB_GETDROPPEDCONTROLRECT, 0, $tRECT, 0, "wparam", "struct*")
	Return $tRECT
EndFunc   ;==>_GUICtrlComboBox_GetDroppedControlRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetDroppedState($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETDROPPEDSTATE) <> 0
EndFunc   ;==>_GUICtrlComboBox_GetDroppedState

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetDroppedWidth($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETDROPPEDWIDTH)
EndFunc   ;==>_GUICtrlComboBox_GetDroppedWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetEditSel($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tStart = DllStructCreate("dword Start")
	Local $tEnd = DllStructCreate("dword End")

	Local $iRet = _SendMessage($hWnd, $CB_GETEDITSEL, $tStart, $tEnd, 0, "struct*", "struct*")
	If $iRet = 0 Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)

	Local $aSel[2]
	$aSel[0] = DllStructGetData($tStart, "Start")
	$aSel[1] = DllStructGetData($tEnd, "End")
	Return $aSel
EndFunc   ;==>_GUICtrlComboBox_GetEditSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Melba23
; ===============================================================================================================================
Func _GUICtrlComboBox_GetEditText($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tInfo
	If _GUICtrlComboBox_GetComboBoxInfo($hWnd, $tInfo) Then
		Local $hEdit = DllStructGetData($tInfo, "hEdit")
		Local $iLine = 0
		Local $iIndex = _SendMessage($hEdit, $__COMBOBOXCONSTANT_EM_LINEINDEX, $iLine)
		Local $iLength = _SendMessage($hEdit, $__COMBOBOXCONSTANT_EM_LINELENGTH, $iIndex)
		If $iLength = 0 Then Return ""
		Local $tBuffer = DllStructCreate("short Len;wchar Text[" & $iLength & "]")
		DllStructSetData($tBuffer, "Len", $iLength)

		Local $iRet = _SendMessage($hEdit, $__COMBOBOXCONSTANT_EM_GETLINE, $iLine, $tBuffer, 0, "wparam", "struct*")
		If $iRet = 0 Then Return SetError(-1, -1, "")

		Local $tText = DllStructCreate("wchar Text[" & $iLength & "]", DllStructGetPtr($tBuffer))
		Return DllStructGetData($tText, "Text")
	Else
		Return SetError(-1, -1, "")
	EndIf
EndFunc   ;==>_GUICtrlComboBox_GetEditText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetExtendedUI($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETEXTENDEDUI) <> 0
EndFunc   ;==>_GUICtrlComboBox_GetExtendedUI

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetHorizontalExtent($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETHORIZONTALEXTENT)
EndFunc   ;==>_GUICtrlComboBox_GetHorizontalExtent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetItemHeight($hWnd, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETITEMHEIGHT, $iIndex)
EndFunc   ;==>_GUICtrlComboBox_GetItemHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLBText($hWnd, $iIndex, ByRef $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iLen = _GUICtrlComboBox_GetLBTextLen($hWnd, $iIndex)
	Local $tBuffer = DllStructCreate("wchar Text[" & $iLen + 1 & "]")
	Local $iRet = _SendMessage($hWnd, $CB_GETLBTEXT, $iIndex, $tBuffer, 0, "wparam", "struct*")

	If ($iRet == $CB_ERR) Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)

	$sText = DllStructGetData($tBuffer, "Text")
	Return $iRet
EndFunc   ;==>_GUICtrlComboBox_GetLBText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLBTextLen($hWnd, $iIndex)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETLBTEXTLEN, $iIndex)
EndFunc   ;==>_GUICtrlComboBox_GetLBTextLen

; #FUNCTION# ====================================================================================================================
; Author ........: Jason Boggs
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlComboBox_GetList($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $sDelimiter = Opt("GUIDataSeparatorChar")
	Local $sResult = "", $sItem
	For $i = 0 To _GUICtrlComboBox_GetCount($hWnd) - 1
		_GUICtrlComboBox_GetLBText($hWnd, $i, $sItem)
		$sResult &= $sItem & $sDelimiter
	Next

	Return StringTrimRight($sResult, StringLen($sDelimiter))
EndFunc   ;==>_GUICtrlComboBox_GetList

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetListArray($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $sDelimiter = Opt("GUIDataSeparatorChar")
	Return StringSplit(_GUICtrlComboBox_GetList($hWnd), $sDelimiter)
EndFunc   ;==>_GUICtrlComboBox_GetListArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLocale($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETLOCALE)
EndFunc   ;==>_GUICtrlComboBox_GetLocale

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLocaleCountry($hWnd)
	Return _WinAPI_HiWord(_GUICtrlComboBox_GetLocale($hWnd))
EndFunc   ;==>_GUICtrlComboBox_GetLocaleCountry

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLocaleLang($hWnd)
	Return _WinAPI_LoWord(_GUICtrlComboBox_GetLocale($hWnd))
EndFunc   ;==>_GUICtrlComboBox_GetLocaleLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLocalePrimLang($hWnd)
	Return _WinAPI_PrimaryLangId(_GUICtrlComboBox_GetLocaleLang($hWnd))
EndFunc   ;==>_GUICtrlComboBox_GetLocalePrimLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetLocaleSubLang($hWnd)
	Return _WinAPI_SubLangId(_GUICtrlComboBox_GetLocaleLang($hWnd))
EndFunc   ;==>_GUICtrlComboBox_GetLocaleSubLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetMinVisible($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETMINVISIBLE)
EndFunc   ;==>_GUICtrlComboBox_GetMinVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_GetTopIndex($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_GETTOPINDEX)
EndFunc   ;==>_GUICtrlComboBox_GetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_InitStorage($hWnd, $iNum, $iBytes)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_INITSTORAGE, $iNum, $iBytes)
EndFunc   ;==>_GUICtrlComboBox_InitStorage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_InsertString($hWnd, $sText, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_INSERTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlComboBox_InsertString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_LimitText($hWnd, $iLimit = 0)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $CB_LIMITTEXT, $iLimit)
EndFunc   ;==>_GUICtrlComboBox_LimitText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_ReplaceEditSel($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tInfo
	If _GUICtrlComboBox_GetComboBoxInfo($hWnd, $tInfo) Then
		Local $hEdit = DllStructGetData($tInfo, "hEdit")
		_SendMessage($hEdit, $__COMBOBOXCONSTANT_EM_REPLACESEL, True, $sText, 0, "wparam", "wstr")
	EndIf
EndFunc   ;==>_GUICtrlComboBox_ReplaceEditSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_ResetContent($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $CB_RESETCONTENT)
EndFunc   ;==>_GUICtrlComboBox_ResetContent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SelectString($hWnd, $sText, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SELECTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlComboBox_SelectString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetCueBanner($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tText = _WinAPI_MultiByteToWideChar($sText)

	Return _SendMessage($hWnd, $CB_SETCUEBANNER, 0, $tText, 0, "wparam", "struct*") = 1
EndFunc   ;==>_GUICtrlComboBox_SetCueBanner

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetCurSel($hWnd, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETCURSEL, $iIndex)
EndFunc   ;==>_GUICtrlComboBox_SetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetDroppedWidth($hWnd, $iWidth)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETDROPPEDWIDTH, $iWidth)
EndFunc   ;==>_GUICtrlComboBox_SetDroppedWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetEditSel($hWnd, $iStart, $iStop)
	If Not HWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETEDITSEL, 0, _WinAPI_MakeLong($iStart, $iStop)) <> -1
EndFunc   ;==>_GUICtrlComboBox_SetEditSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetEditText($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_GUICtrlComboBox_SetEditSel($hWnd, 0, -1)
	_GUICtrlComboBox_ReplaceEditSel($hWnd, $sText)
EndFunc   ;==>_GUICtrlComboBox_SetEditText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetExtendedUI($hWnd, $bExtended = False)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETEXTENDEDUI, $bExtended) = 0
EndFunc   ;==>_GUICtrlComboBox_SetExtendedUI

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetHorizontalExtent($hWnd, $iWidth)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $CB_SETHORIZONTALEXTENT, $iWidth)
EndFunc   ;==>_GUICtrlComboBox_SetHorizontalExtent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetItemHeight($hWnd, $iHeight, $iComponent = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETITEMHEIGHT, $iComponent, $iHeight)
EndFunc   ;==>_GUICtrlComboBox_SetItemHeight

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlComboBox_SetLocale
; Description ...: Set the current locale of the ComboBox
; Syntax.........: _GUICtrlComboBox_SetLocale ( $hWnd, $iLocale )
; Parameters ....: $hWnd        - Handle to control
;                  $iLocale     - Specifies the locale identifier for the ComboBox to use for sorting when adding text
; Return values .: Success      - The previous locale identifier
;                  Failure      - -1
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: _WinAPI_MAKELANGID, _WinAPI_MAKELCID, _WinAPI_PrimaryLangId, _WinAPI_SubLangId
; Related .......: _GUICtrlComboBox_GetLocale
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlComboBox_SetLocale($hWnd, $iLocal)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETLOCALE, $iLocal)
EndFunc   ;==>_GUICtrlComboBox_SetLocale

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetMinVisible($hWnd, $iMinimum)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETMINVISIBLE, $iMinimum) <> 0
EndFunc   ;==>_GUICtrlComboBox_SetMinVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_SetTopIndex($hWnd, $iIndex)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $CB_SETTOPINDEX, $iIndex) = 0
EndFunc   ;==>_GUICtrlComboBox_SetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBox_ShowDropDown($hWnd, $bShow = False)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $CB_SHOWDROPDOWN, $bShow)
EndFunc   ;==>_GUICtrlComboBox_ShowDropDown

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlComboBox_IsPressed
; Description ...: Check if key has been pressed
; Syntax.........: __GUICtrlComboBox_IsPressed ( $sHexKey [, $vDLL = 'user32.dll'] )
; Parameters ....: $sHexKey     - Key to check for
;                  $vDLL        - Handle to dll or default to user32.dll
; Return values .: True         - 1
;                  False        - 0
; Author ........: ezzetabi and Jon
; Modified.......:
; Remarks .......: If calling this function repeatidly, should open 'user32.dll' and pass in handle.
;                  Make sure to close at end of script
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __GUICtrlComboBox_IsPressed($sHexKey, $vDLL = 'user32.dll')
	; $hexKey must be the value of one of the keys.
	; _Is_Key_Pressed will return 0 if the key is not pressed, 1 if it is.
	Local $a_R = DllCall($vDLL, "short", "GetAsyncKeyState", "int", '0x' & $sHexKey)
	If @error Then Return SetError(@error, @extended, False)
	Return BitAND($a_R[0], 0x8000) <> 0
EndFunc   ;==>__GUICtrlComboBox_IsPressed
