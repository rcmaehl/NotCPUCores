#include-once

#include "EditConstants.au3"
#include "GuiStatusBar.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "ToolTipConstants.au3" ; for _GUICtrlEdit_ShowBalloonTip()
#include "UDFGlobalID.au3"
#include "WinAPIConv.au3"
#include "WinAPIHObj.au3"
#include "WinAPISysInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: Edit
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist with Edit control management.
;                  An edit control is a rectangular control window typically used in a dialog box to permit the user to enter
;                  and edit text by typing on the keyboard.
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hEditLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__EDITCONSTANT_ClassName = "Edit"
Global Const $__EDITCONSTANT_GUI_CHECKED = 1
Global Const $__EDITCONSTANT_GUI_HIDE = 32
Global Const $__EDITCONSTANT_GUI_EVENT_CLOSE = -3
Global Const $__EDITCONSTANT_GUI_ENABLE = 64
Global Const $__EDITCONSTANT_GUI_DISABLE = 128
Global Const $__EDITCONSTANT_SS_CENTER = 1
Global Const $__EDITCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__EDITCONSTANT_WS_CAPTION = 0x00C00000
Global Const $__EDITCONSTANT_WS_POPUP = 0x80000000
Global Const $__EDITCONSTANT_WS_SYSMENU = 0x00080000
Global Const $__EDITCONSTANT_WS_MINIMIZEBOX = 0x00020000
Global Const $__EDITCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__EDITCONSTANT_WM_SETFONT = 0x0030
Global Const $__EDITCONSTANT_WM_GETTEXTLENGTH = 0x000E
Global Const $__EDITCONSTANT_WM_GETTEXT = 0x000D
Global Const $__EDITCONSTANT_WM_SETTEXT = 0x000C
Global Const $__EDITCONSTANT_SB_LINEUP = 0
Global Const $__EDITCONSTANT_SB_LINEDOWN = 1
Global Const $__EDITCONSTANT_SB_PAGEDOWN = 3
Global Const $__EDITCONSTANT_SB_PAGEUP = 2
Global Const $__EDITCONSTANT_SB_SCROLLCARET = 4
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlEdit_GetHandle
; _GUICtrlEdit_GetIMEStatus
; _GUICtrlEdit_GetThumb
; _GUICtrlEdit_GetWordBreakProc
; _GUICtrlEdit_SetHandle
; _GUICtrlEdit_SetIMEStatus
; _GUICtrlEdit_SetWordBreakProc
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlEdit_AppendText
; _GUICtrlEdit_BeginUpdate
; _GUICtrlEdit_CanUndo
; _GUICtrlEdit_CharFromPos
; _GUICtrlEdit_Create
; _GUICtrlEdit_Destroy
; _GUICtrlEdit_EmptyUndoBuffer
; _GUICtrlEdit_EndUpdate
; _GUICtrlEdit_FmtLines
; _GUICtrlEdit_Find
; _GUICtrlEdit_GetCueBanner
; _GUICtrlEdit_GetFirstVisibleLine
; _GUICtrlEdit_GetLimitText
; _GUICtrlEdit_GetLine
; _GUICtrlEdit_GetLineCount
; _GUICtrlEdit_GetMargins
; _GUICtrlEdit_GetModify
; _GUICtrlEdit_GetPasswordChar
; _GUICtrlEdit_GetRECT
; _GUICtrlEdit_GetRECTEx
; _GUICtrlEdit_GetSel
; _GUICtrlEdit_GetText
; _GUICtrlEdit_GetTextLen
; _GUICtrlEdit_HideBalloonTip
; _GUICtrlEdit_InsertText
; _GUICtrlEdit_LineFromChar
; _GUICtrlEdit_LineIndex
; _GUICtrlEdit_LineLength
; _GUICtrlEdit_LineScroll
; _GUICtrlEdit_PosFromChar
; _GUICtrlEdit_ReplaceSel
; _GUICtrlEdit_Scroll
; _GUICtrlEdit_SetCueBanner
; _GUICtrlEdit_SetLimitText
; _GUICtrlEdit_SetMargins
; _GUICtrlEdit_SetModify
; _GUICtrlEdit_SetPasswordChar
; _GUICtrlEdit_SetReadOnly
; _GUICtrlEdit_SetRECT
; _GUICtrlEdit_SetRECTEx
; _GUICtrlEdit_SetRECTNP
; _GUICtrlEdit_SetRectNPEx
; _GUICtrlEdit_SetSel
; _GUICtrlEdit_SetTabStops
; _GUICtrlEdit_SetText
; _GUICtrlEdit_ShowBalloonTip
; _GUICtrlEdit_Undo
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $__tagEDITBALLOONTIP
; __GUICtrlEdit_FindText
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagEDITBALLOONTIP
; Description ...: Contains information about a balloon tip
; Fields ........: Size     - Size of this structure, in bytes
;                  Title    - Pointer to the buffer that holds Title of the ToolTip
;                  Text     - Pointer to the buffer that holds Text of the ToolTip
;                  Icon     - Type of Icon.  This can be one of the following values:
;                  |$TTI_ERROR   - Use the error icon
;                  |$TTI_INFO    - Use the information icon
;                  |$TTI_NONE    - Use no icon
;                  |$TTI_WARNING - Use the warning icon
; Author ........: Gary Frost (gafrost)
; Remarks .......: For use with Edit control (minimum O.S. Win XP)
; ===============================================================================================================================
Global Const $__tagEDITBALLOONTIP = "dword Size;ptr Title;ptr Text;int Icon"

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_AppendText($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iLength = _GUICtrlEdit_GetTextLen($hWnd)
	_GUICtrlEdit_SetSel($hWnd, $iLength, $iLength)
	_SendMessage($hWnd, $EM_REPLACESEL, True, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlEdit_AppendText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__EDITCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlEdit_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_CanUndo($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_CANUNDO) <> 0
EndFunc   ;==>_GUICtrlEdit_CanUndo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_CharFromPos($hWnd, $iX, $iY)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $aReturn[2]

	Local $iRet = _SendMessage($hWnd, $EM_CHARFROMPOS, 0, _WinAPI_MakeLong($iX, $iY))
	$aReturn[0] = _WinAPI_LoWord($iRet)
	$aReturn[1] = _WinAPI_HiWord($iRet)
	Return $aReturn
EndFunc   ;==>_GUICtrlEdit_CharFromPos

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_Create($hWnd, $sText, $iX, $iY, $iWidth = 150, $iHeight = 150, $iStyle = 0x003010C4, $iExStyle = 0x00000200)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlEdit_Create 1st parameter
	If Not IsString($sText) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlEdit_Create

	If $iWidth = -1 Then $iWidth = 150
	If $iHeight = -1 Then $iHeight = 150
	If $iStyle = -1 Then $iStyle = 0x003010C4
	If $iExStyle = -1 Then $iExStyle = 0x00000200

	If BitAND($iStyle, $ES_READONLY) = $ES_READONLY Then
		$iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $iStyle)
	Else
		$iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_TABSTOP, $iStyle)
	EndIf
	;=========================================================================================================

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hEdit = _WinAPI_CreateWindowEx($iExStyle, $__EDITCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_SendMessage($hEdit, $__EDITCONSTANT_WM_SETFONT, _WinAPI_GetStockObject($__EDITCONSTANT_DEFAULT_GUI_FONT), True)
	_GUICtrlEdit_SetText($hEdit, $sText)
	_GUICtrlEdit_SetLimitText($hEdit, 0)
	Return $hEdit
EndFunc   ;==>_GUICtrlEdit_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__EDITCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hEditLastWnd) Then
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
EndFunc   ;==>_GUICtrlEdit_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_EmptyUndoBuffer($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_EMPTYUNDOBUFFER)
EndFunc   ;==>_GUICtrlEdit_EmptyUndoBuffer

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__EDITCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlEdit_EndUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_FmtLines($hWnd, $bSoftBreak = False)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_FMTLINES, $bSoftBreak)
EndFunc   ;==>_GUICtrlEdit_FmtLines

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_Find($hWnd, $bReplace = False)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iPos = 0, $iCase, $iOccurance = 0, $iReplacements = 0
	Local $aPartsRightEdge[3] = [125, 225, -1]
	Local $iOldMode = Opt("GUIOnEventMode", 0)

	Local $aSel = _GUICtrlEdit_GetSel($hWnd)
	Local $sText = _GUICtrlEdit_GetText($hWnd)

	Local $hGuiSearch = GUICreate("Find", 349, 177, -1, -1, BitOR($__UDFGUICONSTANT_WS_CHILD, $__EDITCONSTANT_WS_MINIMIZEBOX, $__EDITCONSTANT_WS_CAPTION, $__EDITCONSTANT_WS_POPUP, $__EDITCONSTANT_WS_SYSMENU))
	Local $idStatusBar1 = _GUICtrlStatusBar_Create($hGuiSearch, $aPartsRightEdge)
	_GUICtrlStatusBar_SetText($idStatusBar1, "Find: ")

	GUISetIcon(@SystemDir & "\shell32.dll", 22, $hGuiSearch)
	GUICtrlCreateLabel("Find what:", 9, 10, 53, 16, $__EDITCONSTANT_SS_CENTER)
	Local $idInputSearch = GUICtrlCreateInput("", 80, 8, 257, 21)
	Local $idLblReplace = GUICtrlCreateLabel("Replace with:", 9, 42, 69, 17, $__EDITCONSTANT_SS_CENTER)
	Local $idInputReplace = GUICtrlCreateInput("", 80, 40, 257, 21)
	Local $idChkWholeOnly = GUICtrlCreateCheckbox("Match whole word only", 9, 72, 145, 17)
	Local $idChkMatchCase = GUICtrlCreateCheckbox("Match case", 9, 96, 145, 17)
	Local $idBtnFindNext = GUICtrlCreateButton("Find Next", 168, 72, 161, 21, 0)
	Local $idBtnReplace = GUICtrlCreateButton("Replace", 168, 96, 161, 21, 0)
	Local $idBtnClose = GUICtrlCreateButton("Close", 104, 130, 161, 21, 0)
	If (IsArray($aSel) And $aSel <> $EC_ERR) Then
		GUICtrlSetData($idInputSearch, StringMid($sText, $aSel[0] + 1, $aSel[1] - $aSel[0]))
		If $aSel[0] <> $aSel[1] Then ; text was selected when function was invoked
			$iPos = $aSel[0]
			If BitAND(GUICtrlRead($idChkMatchCase), $__EDITCONSTANT_GUI_CHECKED) = $__EDITCONSTANT_GUI_CHECKED Then $iCase = 1
			$iOccurance = 1
			Local $iTPose
			While 1 ; set the current occurance so search starts from here
				$iTPose = StringInStr($sText, GUICtrlRead($idInputSearch), $iCase, $iOccurance)
				If Not $iTPose Then ; this should never happen, but just in case
					$iOccurance = 0
					ExitLoop
				ElseIf $iTPose = $iPos + 1 Then ; found the occurance
					ExitLoop
				EndIf
				$iOccurance += 1
			WEnd
		EndIf
		_GUICtrlStatusBar_SetText($idStatusBar1, "Find: " & GUICtrlRead($idInputSearch))
	EndIf

	If $bReplace = False Then
		GUICtrlSetState($idLblReplace, $__EDITCONSTANT_GUI_HIDE)
		GUICtrlSetState($idInputReplace, $__EDITCONSTANT_GUI_HIDE)
		GUICtrlSetState($idBtnReplace, $__EDITCONSTANT_GUI_HIDE)
	Else
		_GUICtrlStatusBar_SetText($idStatusBar1, "Replacements: " & $iReplacements, 1)
		_GUICtrlStatusBar_SetText($idStatusBar1, "With: ", 2)
	EndIf
	GUISetState(@SW_SHOW)

	Local $iMsgFind
	While 1
		$iMsgFind = GUIGetMsg()
		Select
			Case $iMsgFind = $__EDITCONSTANT_GUI_EVENT_CLOSE Or $iMsgFind = $idBtnClose
				ExitLoop
			Case $iMsgFind = $idBtnFindNext
				GUICtrlSetState($idBtnFindNext, $__EDITCONSTANT_GUI_DISABLE)
				GUICtrlSetCursor($idBtnFindNext, 15)
				Sleep(100)
				_GUICtrlStatusBar_SetText($idStatusBar1, "Find: " & GUICtrlRead($idInputSearch))
				If $bReplace = True Then
					_GUICtrlStatusBar_SetText($idStatusBar1, "Find: " & GUICtrlRead($idInputSearch))
					_GUICtrlStatusBar_SetText($idStatusBar1, "With: " & GUICtrlRead($idInputReplace), 2)
				EndIf
				__GUICtrlEdit_FindText($hWnd, $idInputSearch, $idChkMatchCase, $idChkWholeOnly, $iPos, $iOccurance, $iReplacements)
				Sleep(100)
				GUICtrlSetState($idBtnFindNext, $__EDITCONSTANT_GUI_ENABLE)
				GUICtrlSetCursor($idBtnFindNext, 2)
			Case $iMsgFind = $idBtnReplace
				GUICtrlSetState($idBtnReplace, $__EDITCONSTANT_GUI_DISABLE)
				GUICtrlSetCursor($idBtnReplace, 15)
				Sleep(100)
				_GUICtrlStatusBar_SetText($idStatusBar1, "Find: " & GUICtrlRead($idInputSearch))
				_GUICtrlStatusBar_SetText($idStatusBar1, "With: " & GUICtrlRead($idInputReplace), 2)
				If $iPos Then
					_GUICtrlEdit_ReplaceSel($hWnd, GUICtrlRead($idInputReplace))
					$iReplacements += 1
					$iOccurance -= 1
					_GUICtrlStatusBar_SetText($idStatusBar1, "Replacements: " & $iReplacements, 1)
				EndIf
				__GUICtrlEdit_FindText($hWnd, $idInputSearch, $idChkMatchCase, $idChkWholeOnly, $iPos, $iOccurance, $iReplacements)
				Sleep(100)
				GUICtrlSetState($idBtnReplace, $__EDITCONSTANT_GUI_ENABLE)
				GUICtrlSetCursor($idBtnReplace, 2)
		EndSelect
	WEnd
	GUIDelete($hGuiSearch)
	Opt("GUIOnEventMode", $iOldMode)
EndFunc   ;==>_GUICtrlEdit_Find

; #FUNCTION# ====================================================================================================================
; Author ........: Guinness
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetCueBanner($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tText = DllStructCreate("wchar[4096]")
	If _SendMessage($hWnd, $EM_GETCUEBANNER, $tText, 4096, 0, "struct*") <> 1 Then Return SetError(-1, 0, "")
	Return _WinAPI_WideCharToMultiByte($tText)
EndFunc   ;==>_GUICtrlEdit_GetCueBanner

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlEdit_FindText
; Description ...:
; Syntax.........: __GUICtrlEdit_FindText ( $hWnd, $idInputSearch, $idChkMatchCase, $idChkWholeOnly, ByRef $iPos, ByRef $iOccurance, ByRef $iReplacements )
; Parameters ....: $hWnd          - Handle to the control
;                  $idInputSearch   - controlID
;                  $idChkMatchCase  - controlID
;                  $idChkWholeOnly  - controlID
;                  $iPos          - position of text found
;                  $iOccurance    - occurance to find
;                  $iReplacements - # of occurances replaced
; Return values .:
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlEdit_Find
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlEdit_FindText($hWnd, $idInputSearch, $idChkMatchCase, $idChkWholeOnly, ByRef $iPos, ByRef $iOccurance, ByRef $iReplacements)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iCase = 0, $iWhole = 0
	Local $bExact = False
	Local $sFind = GUICtrlRead($idInputSearch)

	Local $sText = _GUICtrlEdit_GetText($hWnd)

	If BitAND(GUICtrlRead($idChkMatchCase), $__EDITCONSTANT_GUI_CHECKED) = $__EDITCONSTANT_GUI_CHECKED Then $iCase = 1
	If BitAND(GUICtrlRead($idChkWholeOnly), $__EDITCONSTANT_GUI_CHECKED) = $__EDITCONSTANT_GUI_CHECKED Then $iWhole = 1
	If $sFind <> "" Then
		$iOccurance += 1
		$iPos = StringInStr($sText, $sFind, $iCase, $iOccurance)
		If $iWhole And $iPos Then
			Local $s_Compare2 = StringMid($sText, $iPos + StringLen($sFind), 1)
			If $iPos = 1 Then
				If ($iPos + StringLen($sFind)) - 1 = StringLen($sText) Or _
						($s_Compare2 = " " Or $s_Compare2 = @LF Or $s_Compare2 = @CR Or _
						$s_Compare2 = @CRLF Or $s_Compare2 = @TAB) Then $bExact = True
			Else
				Local $s_Compare1 = StringMid($sText, $iPos - 1, 1)
				If ($iPos + StringLen($sFind)) - 1 = StringLen($sText) Then
					If ($s_Compare1 = " " Or $s_Compare1 = @LF Or $s_Compare1 = @CR Or _
							$s_Compare1 = @CRLF Or $s_Compare1 = @TAB) Then $bExact = True
				Else
					If ($s_Compare1 = " " Or $s_Compare1 = @LF Or $s_Compare1 = @CR Or _
							$s_Compare1 = @CRLF Or $s_Compare1 = @TAB) And _
							($s_Compare2 = " " Or $s_Compare2 = @LF Or $s_Compare2 = @CR Or _
							$s_Compare2 = @CRLF Or $s_Compare2 = @TAB) Then $bExact = True
				EndIf
			EndIf
			If $bExact = False Then ; found word, but as part of another word, so search again
				__GUICtrlEdit_FindText($hWnd, $idInputSearch, $idChkMatchCase, $idChkWholeOnly, $iPos, $iOccurance, $iReplacements)
			Else ; found it
				_GUICtrlEdit_SetSel($hWnd, $iPos - 1, ($iPos + StringLen($sFind)) - 1)
				_GUICtrlEdit_Scroll($hWnd, $__EDITCONSTANT_SB_SCROLLCARET)
			EndIf
		ElseIf $iWhole And Not $iPos Then ; no more to find
			$iOccurance = 0
			MsgBox($MB_SYSTEMMODAL, "Find", "Reached End of document, Can not find the string '" & $sFind & "'")
		ElseIf Not $iWhole Then
			If Not $iPos Then ; wrap around search and select
				$iOccurance = 1
				_GUICtrlEdit_SetSel($hWnd, -1, 0)
				_GUICtrlEdit_Scroll($hWnd, $__EDITCONSTANT_SB_SCROLLCARET)
				$iPos = StringInStr($sText, $sFind, $iCase, $iOccurance)
				If Not $iPos Then ; no more to find
					$iOccurance = 0
					MsgBox($MB_SYSTEMMODAL, "Find", "Reached End of document, Can not find the string  '" & $sFind & "'")
				Else ; found it
					_GUICtrlEdit_SetSel($hWnd, $iPos - 1, ($iPos + StringLen($sFind)) - 1)
					_GUICtrlEdit_Scroll($hWnd, $__EDITCONSTANT_SB_SCROLLCARET)
				EndIf
			Else ; set selection
				_GUICtrlEdit_SetSel($hWnd, $iPos - 1, ($iPos + StringLen($sFind)) - 1)
				_GUICtrlEdit_Scroll($hWnd, $__EDITCONSTANT_SB_SCROLLCARET)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>__GUICtrlEdit_FindText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetFirstVisibleLine($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETFIRSTVISIBLELINE)
EndFunc   ;==>_GUICtrlEdit_GetFirstVisibleLine

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_GetHandle
; Description ...: Gets a handle of the memory currently allocated for a multiline edit control's text
; Syntax.........: _GUICtrlEdit_GetHandle ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - Memory handle identifying the buffer that holds the content of the edit control
;                  Failure      - 0
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: If the function succeeds, the application can access the contents of the edit control by casting the
;                  return value to HLOCAL and passing it to LocalLock. LocalLock returns a pointer to a buffer that is a
;                  null-terminated array of CHARs or WCHARs, depending on whether an ANSI or Unicode function created the control.
;                  For example, if CreateWindowExA was used the buffer is an array of CHARs, but if CreateWindowExW was used the
;                  buffer is an array of WCHARs. The application may not change the contents of the buffer. To unlock the buffer,
;                  the application calls LocalUnlock before allowing the edit control to receive new messages.
; +
;                  If your application cannot abide by the restrictions imposed by EM_GETHANDLE, use the GetWindowTextLength and
;                  GetWindowText functions to copy the contents of the edit control into an application-provided buffer.
; Related .......: _GUICtrlEdit_SetHandle
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetHandle($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return Ptr(_SendMessage($hWnd, $EM_GETHANDLE))
EndFunc   ;==>_GUICtrlEdit_GetHandle

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_GetIMEStatus
; Description ...: Gets a set of status flags that indicate how the edit control interacts with the Input Method Editor (IME)
; Syntax.........: _GUICtrlEdit_GetIMEStatus ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - One or More of the Following Flags
;                  |$EIMES_GETCOMPSTRATONCE - The edit control hooks the WM_IME_COMPOSITION message
;                  |$EIMES_CANCELCOMPSTRINFOCUS - The edit control cancels the composition string when it receives the WM_SETFOCUS message
;                  |$EIMES_COMPLETECOMPSTRKILLFOCUS - The edit control completes the composition string upon receiving the WM_KILLFOCUS message
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetIMEStatus($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETIMESTATUS, $EMSIS_COMPOSITIONSTRING)
EndFunc   ;==>_GUICtrlEdit_GetIMEStatus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetLimitText($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETLIMITTEXT)
EndFunc   ;==>_GUICtrlEdit_GetLimitText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), Jos van der Zande <jdeb at autoitscript com >
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlEdit_GetLine($hWnd, $iLine)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iLength = _GUICtrlEdit_LineLength($hWnd, $iLine)
	If $iLength = 0 Then Return ""
	Local $tBuffer = DllStructCreate("short Len;wchar Text[" & $iLength & "]")
	DllStructSetData($tBuffer, "Len", $iLength + 1)
	Local $iRet = _SendMessage($hWnd, $EM_GETLINE, $iLine, $tBuffer, 0, "wparam", "struct*")

	If $iRet = 0 Then Return SetError($EC_ERR, $EC_ERR, "")

	Local $tText = DllStructCreate("wchar Text[" & $iLength & "]", DllStructGetPtr($tBuffer))
	Return DllStructGetData($tText, "Text")
EndFunc   ;==>_GUICtrlEdit_GetLine

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetLineCount($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETLINECOUNT)
EndFunc   ;==>_GUICtrlEdit_GetLineCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetMargins($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $aMargins[2]
	Local $iMargins = _SendMessage($hWnd, $EM_GETMARGINS)
	$aMargins[0] = _WinAPI_LoWord($iMargins) ; Left Margin
	$aMargins[1] = _WinAPI_HiWord($iMargins) ; Right Margin
	Return $aMargins
EndFunc   ;==>_GUICtrlEdit_GetMargins

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetModify($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETMODIFY) <> 0
EndFunc   ;==>_GUICtrlEdit_GetModify

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetPasswordChar($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETPASSWORDCHAR)
EndFunc   ;==>_GUICtrlEdit_GetPasswordChar

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetRECT($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $aRect[4]

	Local $tRECT = _GUICtrlEdit_GetRECTEx($hWnd)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlEdit_GetRECT

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetRECTEx($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tRECT = DllStructCreate($tagRECT)
	_SendMessage($hWnd, $EM_GETRECT, 0, $tRECT, 0, "wparam", "struct*")
	Return $tRECT
EndFunc   ;==>_GUICtrlEdit_GetRECTEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetSel($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $aSel[2]
	Local $tStart = DllStructCreate("uint Start")
	Local $tEnd = DllStructCreate("uint End")
	_SendMessage($hWnd, $EM_GETSEL, $tStart, $tEnd, 0, "struct*", "struct*")
	$aSel[0] = DllStructGetData($tStart, "Start")
	$aSel[1] = DllStructGetData($tEnd, "End")
	Return $aSel
EndFunc   ;==>_GUICtrlEdit_GetSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetText($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iTextLen = _GUICtrlEdit_GetTextLen($hWnd) + 1
	Local $tText = DllStructCreate("wchar Text[" & $iTextLen & "]")
	_SendMessage($hWnd, $__EDITCONSTANT_WM_GETTEXT, $iTextLen, $tText, 0, "wparam", "struct*")
	Return DllStructGetData($tText, "Text")
EndFunc   ;==>_GUICtrlEdit_GetText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetTextLen($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__EDITCONSTANT_WM_GETTEXTLENGTH)
EndFunc   ;==>_GUICtrlEdit_GetTextLen

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_GetThumb
; Description ...: Retrieves the position of the scroll box (thumb) in the vertical scroll
; Syntax.........: _GUICtrlEdit_GetThumb ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - The position of the scroll box
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: I think WM_VSCROLL events probably work better
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetThumb($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETTHUMB)
EndFunc   ;==>_GUICtrlEdit_GetThumb

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_GetWordBreakProc
; Description ...: Retrieves the address of the current Wordwrap function
; Syntax.........: _GUICtrlEdit_GetWordBreakProc ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - The address of the application-defined Wordwrap function
;                  Failure      - 0
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlEdit_SetWordBreakProc
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_GetWordBreakProc($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_GETWORDBREAKPROC)
EndFunc   ;==>_GUICtrlEdit_GetWordBreakProc

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_HideBalloonTip($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_HIDEBALLOONTIP) <> 0
EndFunc   ;==>_GUICtrlEdit_HideBalloonTip

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_InsertText($hWnd, $sText, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $iIndex = -1 Then
		_GUICtrlEdit_AppendText($hWnd, $sText)
	Else
		_GUICtrlEdit_SetSel($hWnd, $iIndex, $iIndex)
		_SendMessage($hWnd, $EM_REPLACESEL, True, $sText, 0, "wparam", "wstr")
	EndIf
EndFunc   ;==>_GUICtrlEdit_InsertText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_LineFromChar($hWnd, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_LINEFROMCHAR, $iIndex)
EndFunc   ;==>_GUICtrlEdit_LineFromChar

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_LineIndex($hWnd, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_LINEINDEX, $iIndex)
EndFunc   ;==>_GUICtrlEdit_LineIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_LineLength($hWnd, $iIndex = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iCharIndex = _GUICtrlEdit_LineIndex($hWnd, $iIndex)
	Return _SendMessage($hWnd, $EM_LINELENGTH, $iCharIndex)
EndFunc   ;==>_GUICtrlEdit_LineLength

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_LineScroll($hWnd, $iHoriz, $iVert)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_LINESCROLL, $iHoriz, $iVert) <> 0
EndFunc   ;==>_GUICtrlEdit_LineScroll

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_PosFromChar($hWnd, $iIndex)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $aCoord[2]
	Local $iRet = _SendMessage($hWnd, $EM_POSFROMCHAR, $iIndex)
	$aCoord[0] = _WinAPI_LoWord($iRet)
	$aCoord[1] = _WinAPI_HiWord($iRet)
	Return $aCoord
EndFunc   ;==>_GUICtrlEdit_PosFromChar

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_ReplaceSel($hWnd, $sText, $bUndo = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_REPLACESEL, $bUndo, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlEdit_ReplaceSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_Scroll($hWnd, $iDirection)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If BitAND($iDirection, $__EDITCONSTANT_SB_LINEDOWN) <> $__EDITCONSTANT_SB_LINEDOWN And _
			BitAND($iDirection, $__EDITCONSTANT_SB_LINEUP) <> $__EDITCONSTANT_SB_LINEUP And _
			BitAND($iDirection, $__EDITCONSTANT_SB_PAGEDOWN) <> $__EDITCONSTANT_SB_PAGEDOWN And _
			BitAND($iDirection, $__EDITCONSTANT_SB_PAGEUP) <> $__EDITCONSTANT_SB_PAGEUP And _
			BitAND($iDirection, $__EDITCONSTANT_SB_SCROLLCARET) <> $__EDITCONSTANT_SB_SCROLLCARET Then Return 0

	If $iDirection == $__EDITCONSTANT_SB_SCROLLCARET Then
		Return _SendMessage($hWnd, $EM_SCROLLCARET)
	Else
		Return _SendMessage($hWnd, $EM_SCROLL, $iDirection)
	EndIf
EndFunc   ;==>_GUICtrlEdit_Scroll

; #FUNCTION# ====================================================================================================================
; Author ........: Guinness
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetCueBanner($hWnd, $sText, $bOnFocus = False)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tText = _WinAPI_MultiByteToWideChar($sText)

	Return _SendMessage($hWnd, $EM_SETCUEBANNER, $bOnFocus, $tText, 0, "wparam", "struct*") = 1
EndFunc   ;==>_GUICtrlEdit_SetCueBanner

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_SetHandle
; Description ...: Sets the handle of the memory that will be used
; Syntax.........: _GUICtrlEdit_SetHandle ( $hWnd, $hMemory )
; Parameters ....: $hWnd        - Handle to the control
;                  $hMemory     - A handle to the memory buffer the edit control uses to store the currently displayed text
;                  +instead of allocating its own memory
; Return values .:
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlEdit_GetHandle
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetHandle($hWnd, $hMemory)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETHANDLE, $hMemory, 0, 0, "handle")
EndFunc   ;==>_GUICtrlEdit_SetHandle

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_SetIMEStatus
; Description ...: Sets the status flags that determine how an edit control interacts with the Input Method Editor (IME)
; Syntax.........: _GUICtrlEdit_SetIMEStatus ( $hWnd, $iComposition )
; Parameters ....: $hWnd         - Handle to the control
;                  $iComposition - One or more of the following:
;                  |$EIMES_GETCOMPSTRATONCE - The edit control hooks the WM_IME_COMPOSITION message
;                  |$EIMES_CANCELCOMPSTRINFOCUS - The edit control cancels the composition string when it receives the WM_SETFOCUS message
;                  |$EIMES_COMPLETECOMPSTRKILLFOCUS - The edit control completes the composition string upon receiving the WM_KILLFOCUS message
; Return values .: Success      - the previous value of the $iComposition parameter
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetIMEStatus($hWnd, $iComposition)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_SETIMESTATUS, $EMSIS_COMPOSITIONSTRING, $iComposition)
EndFunc   ;==>_GUICtrlEdit_SetIMEStatus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetLimitText($hWnd, $iLimit)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETLIMITTEXT, $iLimit)
EndFunc   ;==>_GUICtrlEdit_SetLimitText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetMargins($hWnd, $iMargin = 0x1, $iLeft = 0xFFFF, $iRight = 0xFFFF)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETMARGINS, $iMargin, _WinAPI_MakeLong($iLeft, $iRight))
EndFunc   ;==>_GUICtrlEdit_SetMargins

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetModify($hWnd, $bModified)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETMODIFY, $bModified)
EndFunc   ;==>_GUICtrlEdit_SetModify

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetPasswordChar($hWnd, $sDisplayChar = "0")
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	$sDisplayChar = StringLeft($sDisplayChar, 1)
	If Asc($sDisplayChar) = 48 Then
		_SendMessage($hWnd, $EM_SETPASSWORDCHAR)
	Else
		_SendMessage($hWnd, $EM_SETPASSWORDCHAR, Asc($sDisplayChar))
	EndIf
EndFunc   ;==>_GUICtrlEdit_SetPasswordChar

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetReadOnly($hWnd, $bReadOnly)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_SETREADONLY, $bReadOnly) <> 0
EndFunc   ;==>_GUICtrlEdit_SetReadOnly

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetRECT($hWnd, $aRect)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $aRect[0])
	DllStructSetData($tRECT, "Top", $aRect[1])
	DllStructSetData($tRECT, "Right", $aRect[2])
	DllStructSetData($tRECT, "Bottom", $aRect[3])
	_GUICtrlEdit_SetRECTEx($hWnd, $tRECT)
EndFunc   ;==>_GUICtrlEdit_SetRECT

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetRECTEx($hWnd, $tRECT)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETRECT, 0, $tRECT, 0, "wparam", "struct*")
EndFunc   ;==>_GUICtrlEdit_SetRECTEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetRECTNP($hWnd, $aRect)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $aRect[0])
	DllStructSetData($tRECT, "Top", $aRect[1])
	DllStructSetData($tRECT, "Right", $aRect[2])
	DllStructSetData($tRECT, "Bottom", $aRect[3])
	_GUICtrlEdit_SetRectNPEx($hWnd, $tRECT)
EndFunc   ;==>_GUICtrlEdit_SetRECTNP

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetRectNPEx($hWnd, $tRECT)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETRECTNP, 0, $tRECT, 0, "wparam", "struct*")
EndFunc   ;==>_GUICtrlEdit_SetRectNPEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetSel($hWnd, $iStart, $iEnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETSEL, $iStart, $iEnd)
EndFunc   ;==>_GUICtrlEdit_SetSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetTabStops($hWnd, $aTabStops)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If Not IsArray($aTabStops) Then Return SetError(-1, -1, False)

	Local $sTabStops = ""
	Local $iNumTabStops = UBound($aTabStops)

	For $x = 0 To $iNumTabStops - 1
		$sTabStops &= "int;"
	Next
	$sTabStops = StringTrimRight($sTabStops, 1)
	Local $tTabStops = DllStructCreate($sTabStops)
	For $x = 0 To $iNumTabStops - 1
		DllStructSetData($tTabStops, $x + 1, $aTabStops[$x])
	Next
	Local $iRet = _SendMessage($hWnd, $EM_SETTABSTOPS, $iNumTabStops, $tTabStops, 0, "wparam", "struct*") <> 0
	_WinAPI_InvalidateRect($hWnd)
	Return $iRet
EndFunc   ;==>_GUICtrlEdit_SetTabStops

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetText($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $__EDITCONSTANT_WM_SETTEXT, 0, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlEdit_SetText

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlEdit_SetWordBreakProc
; Description ...: Replaces an edit control's default Wordwrap function with an application-defined Wordwrap function
; Syntax.........: _GUICtrlEdit_SetWordBreakProc ( $hWnd, $iAddressFunc )
; Parameters ....: $hWnd         - Handle to the control
;                  $iAddressFunc - The address of the application-defined Wordwrap function
; Return values .:
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlEdit_GetWordBreakProc
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlEdit_SetWordBreakProc($hWnd, $iAddressFunc)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $EM_SETWORDBREAKPROC, 0, $iAddressFunc)
EndFunc   ;==>_GUICtrlEdit_SetWordBreakProc

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_ShowBalloonTip($hWnd, $sTitle, $sText, $iIcon)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tTitle = _WinAPI_MultiByteToWideChar($sTitle)
	Local $tText = _WinAPI_MultiByteToWideChar($sText)
	Local $tTT = DllStructCreate($__tagEDITBALLOONTIP)
	DllStructSetData($tTT, "Size", DllStructGetSize($tTT))
	DllStructSetData($tTT, "Title", DllStructGetPtr($tTitle))
	DllStructSetData($tTT, "Text", DllStructGetPtr($tText))
	DllStructSetData($tTT, "Icon", $iIcon)
	Return _SendMessage($hWnd, $EM_SHOWBALLOONTIP, 0, $tTT, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlEdit_ShowBalloonTip

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlEdit_Undo($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $EM_UNDO) <> 0
EndFunc   ;==>_GUICtrlEdit_Undo
