#include-once

#include "AutoItConstants.au3"
#include "MsgBoxConstants.au3"
#include "StringConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Internal UDF Library for AutoIt3 _ArrayDisplay() and _DebugArray()
; AutoIt Version : 3.3.14.5
; Description ...: Internal functions for the Array.au3 and Debug.au3
; Author(s) .....: Melba23, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; for use with the sort call back functions
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $ARRAYDISPLAY_COLALIGNLEFT = 0 ; (default) Column text alignment - left
Global Const $ARRAYDISPLAY_TRANSPOSE = 1 ; Transposes the array (2D only)
Global Const $ARRAYDISPLAY_COLALIGNRIGHT = 2 ; Column text alignment - right
Global Const $ARRAYDISPLAY_COLALIGNCENTER = 4 ; Column text alignment - center
Global Const $ARRAYDISPLAY_VERBOSE = 8 ; Verbose - display MsgBox on error and splash screens during processing of large arrays
Global Const $ARRAYDISPLAY_NOROW = 64 ; No 'Row' column displayed

Global Const $_ARRAYCONSTANT_tagHDITEM = "uint Mask;int XY;ptr Text;handle hBMP;int TextMax;int Fmt;lparam Param;int Image;int Order;uint Type;ptr pFilter;uint State"
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & _
		"int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __ArrayDisplay_Share
; __ArrayDisplay_RegisterSortCallBack
; __ArrayDisplay_SortCallBack
; __ArrayDisplay_SortItems
; __ArrayDisplay_AddItem
; __ArrayDisplay_AddSubItem
; __ArrayDisplay_GetColumnCount
; __ArrayDisplay_GetHeader
; __ArrayDisplay_GetItem
; __ArrayDisplay_GetItemCount
; __ArrayDisplay_GetItemFormat
; __ArrayDisplay_GetItemText
; __ArrayDisplay_GetItemTextString
; __ArrayDisplay_SetItemFormat
; ===============================================================================================================================

#EndRegion Functions list

Func __ArrayDisplay_Share(Const ByRef $aArray, $sTitle = Default, $sArrayRange = Default, $iFlags = Default, $vUser_Separator = Default, $sHeader = Default, $iMax_ColWidth = Default, $hUser_Function = Default, $bDebug = True)
	Local $vTmp, $sMsgBoxTitle = (($bDebug) ? ("DebugArray") : ("ArrayDisplay"))

	; Default values
	If $sTitle = Default Then $sTitle = $sMsgBoxTitle
	If $sArrayRange = Default Then $sArrayRange = ""
	If $iFlags = Default Then $iFlags = 0
	If $vUser_Separator = Default Then $vUser_Separator = ""
	If $sHeader = Default Then $sHeader = ""
	If $iMax_ColWidth = Default Then $iMax_ColWidth = 350
	If $hUser_Function = Default Then $hUser_Function = 0

	; Check for transpose, column align, verbosity and "Row" column visibility
	Local $iTranspose = BitAND($iFlags, $ARRAYDISPLAY_TRANSPOSE)
	Local $iColAlign = BitAND($iFlags, 6) ; 0 = Left (default); 2 = Right; 4 = Center
	Local $iVerbose = BitAND($iFlags, $ARRAYDISPLAY_VERBOSE)
	Local $iNoRow = BitAND($iFlags, $ARRAYDISPLAY_NOROW)

	; Set lower button border
	Local $iButtonBorder = (($bDebug) ? (40) : (20))

	; Check valid array
	Local $sMsg = "", $iRet = 1
	If IsArray($aArray) Then
		; Dimension checking
		Local $iDimension = UBound($aArray, $UBOUND_DIMENSIONS), $iRowCount = UBound($aArray, $UBOUND_ROWS), $iColCount = UBound($aArray, $UBOUND_COLUMNS)
		If $iDimension > 2 Then
			$sMsg = "Larger than 2D array passed to function"
			$iRet = 2
		EndIf
		If $iDimension = 1 Then
			$iTranspose = 0
		EndIf
	Else
		$sMsg = "No array variable passed to function"
	EndIf
	If $sMsg Then
		If $iVerbose And MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR + $MB_YESNO, _
				$sMsgBoxTitle & " Error: " & $sTitle, $sMsg & @CRLF & @CRLF & "Exit the script?") = $IDYES Then
			Exit
		Else
			Return SetError($iRet, 0, 0)
		EndIf
	EndIf

	; Determine copy separator
	Local $iCW_ColWidth = Number($vUser_Separator)

	; Get current separator character
	Local $sCurr_Separator = Opt("GUIDataSeparatorChar")

	; Set default user separator if required
	If $vUser_Separator = "" Then $vUser_Separator = $sCurr_Separator

	; Declare variables
	Local $iItem_Start = 0, $iItem_End = $iRowCount - 1, $iSubItem_Start = 0, $iSubItem_End = (($iDimension = 2) ? ($iColCount - 1) : (0))
	; Flag to determine if range set
	Local $bRange_Flag = False, $avRangeSplit
	; Check for range settings
	If $sArrayRange Then
		; Split into separate dimension sections
		Local $aArray_Range = StringRegExp($sArrayRange & "||", "(?U)(.*)\|", 3)
		; Dimension 1
		If $aArray_Range[0] Then
			$avRangeSplit = StringSplit($aArray_Range[0], ":")
			If @error Then
				$iItem_End = Number($avRangeSplit[1])
			Else
				$iItem_Start = Number($avRangeSplit[1])
				If $avRangeSplit[2] <> "" Then
					$iItem_End = Number($avRangeSplit[2])
				EndIf
			EndIf
		EndIf
		; Check row bounds
		If $iItem_Start < 0 Then $iItem_Start = 0
		If $iItem_End > $iRowCount - 1 Then $iItem_End = $iRowCount - 1
		If $iItem_Start > $iItem_End Then
			$vTmp = $iItem_Start
			$iItem_Start = $iItem_End
			$iItem_End = $vTmp
		EndIf
		; Check if range set
		If $iItem_Start <> 0 Or $iItem_End <> $iRowCount - 1 Then $bRange_Flag = True
		; Dimension 2
		If $iDimension = 2 And $aArray_Range[1] Then
			$avRangeSplit = StringSplit($aArray_Range[1], ":")
			If @error Then
				$iSubItem_End = Number($avRangeSplit[1])
			Else
				$iSubItem_Start = Number($avRangeSplit[1])
				If $avRangeSplit[2] <> "" Then
					$iSubItem_End = Number($avRangeSplit[2])
				EndIf
			EndIf
			; Check column bounds
			If $iSubItem_Start > $iSubItem_End Then
				$vTmp = $iSubItem_Start
				$iSubItem_Start = $iSubItem_End
				$iSubItem_End = $vTmp
			EndIf
			If $iSubItem_Start < 0 Then $iSubItem_Start = 0
			If $iSubItem_End > $iColCount - 1 Then $iSubItem_End = $iColCount - 1
			; Check if range set
			If $iSubItem_Start <> 0 Or $iSubItem_End <> $iColCount - 1 Then $bRange_Flag = True
		EndIf
	EndIf

	; Create data display
	Local $sDisplayData = "[" & $iRowCount & "]"
	If $iDimension = 2 Then
		$sDisplayData &= " [" & $iColCount & "]"
	EndIf
	; Create tooltip data
	Local $sTipData = ""
	If $bRange_Flag Then
		If $sTipData Then $sTipData &= " - "
		$sTipData &= "Range set"
	EndIf
	If $iTranspose Then
		If $sTipData Then $sTipData &= " - "
		$sTipData &= "Transposed"
	EndIf

	; Split custom header on separator
	Local $asHeader = StringSplit($sHeader, $sCurr_Separator, $STR_NOCOUNT) ; No count element
	If UBound($asHeader) = 0 Then Local $asHeader[1] = [""]
	$sHeader = "Row"
	Local $iIndex = $iSubItem_Start
	If $iTranspose Then
		; All default headers
		$sHeader = "Col"
		For $j = $iItem_Start To $iItem_End
			$sHeader &= $sCurr_Separator & "Row " & $j
		Next
	Else
		; Create custom header with available items
		If $asHeader[0] Then
			; Set as many as available
			For $iIndex = $iSubItem_Start To $iSubItem_End
				; Check custom header available
				If $iIndex >= UBound($asHeader) Then ExitLoop
				$sHeader &= $sCurr_Separator & $asHeader[$iIndex]
			Next
		EndIf
		; Add default headers to fill to end
		For $j = $iIndex To $iSubItem_End
			$sHeader &= $sCurr_Separator & "Col " & $j
		Next
	EndIf
	; Remove "Row" header if not needed
	If $iNoRow Then $sHeader = StringTrimLeft($sHeader, 4)

	; Display splash dialog if required
	If $iVerbose And ($iItem_End - $iItem_Start + 1) * ($iSubItem_End - $iSubItem_Start + 1) > 10000 Then
		SplashTextOn($sMsgBoxTitle, "Preparing display" & @CRLF & @CRLF & "Please be patient", 300, 100)
	EndIf

	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 64
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 102
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 512
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 4
	Local Const $_ARRAYCONSTANT_GUI_DOCKHCENTER = 8
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_GUI_FOCUS = 256
	Local Const $_ARRAYCONSTANT_SS_CENTER = 0x1
	Local Const $_ARRAYCONSTANT_SS_CENTERIMAGE = 0x0200
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMRECT = (0x1000 + 14)
	Local Const $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH = (0x1000 + 29)
	Local Const $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH = (0x1000 + 30)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_GETSELECTEDCOUNT = (0x1000 + 50)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVIS_SELECTED = 0x0002
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_WM_SETREDRAW = 11
	Local Const $_ARRAYCONSTANT_LVSCW_AUTOSIZE = -1
	Local Const $_ARRAYCONSTANT_LVSCW_AUTOSIZE_USEHEADER = -2

	; Set coord mode 1
	Local $iCoordMode = Opt("GUICoordMode", 1)

	; Create GUI
	Local $iOrgWidth = 210, $iHeight = 200, $iMinSize = 250
	Local $hGUI = GUICreate($sTitle, $iOrgWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX))
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $iButtonWidth_1 = $aiGUISize[0] / 2
	Local $iButtonWidth_2 = $aiGUISize[0] / 3
	; Create ListView
	Local $idListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - $iButtonBorder, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)
	Local $idCopy_ID = 9999, $idCopy_Data = 99999, $idData_Label = 99999, $idUser_Func = 99999, $idExit_Script = 99999
	If $bDebug Then
		; Create buttons
		$idCopy_ID = GUICtrlCreateButton("Copy Data && Hdr/Row", 0, $aiGUISize[1] - $iButtonBorder, $iButtonWidth_1, 20)
		$idCopy_Data = GUICtrlCreateButton("Copy Data Only", $iButtonWidth_1, $aiGUISize[1] - $iButtonBorder, $iButtonWidth_1, 20)
		Local $iButtonWidth_Var = $iButtonWidth_1
		Local $iOffset = $iButtonWidth_1
		If IsFunc($hUser_Function) Then
			; Create UserFunc button if function passed
			$idUser_Func = GUICtrlCreateButton("Run User Func", $iButtonWidth_2, $aiGUISize[1] - 20, $iButtonWidth_2, 20)
			$iButtonWidth_Var = $iButtonWidth_2
			$iOffset = $iButtonWidth_2 * 2
		EndIf
		; Create Exit button and data label
		$idExit_Script = GUICtrlCreateButton("Exit Script", $iOffset, $aiGUISize[1] - 20, $iButtonWidth_Var, 20)
		$idData_Label = GUICtrlCreateLabel($sDisplayData, 0, $aiGUISize[1] - 20, $iButtonWidth_Var, 18, BitOR($_ARRAYCONSTANT_SS_CENTER, $_ARRAYCONSTANT_SS_CENTERIMAGE))
	Else
		$idData_Label = GUICtrlCreateLabel($sDisplayData, 0, $aiGUISize[1] - 20, $aiGUISize[0], 18, BitOR($_ARRAYCONSTANT_SS_CENTER, $_ARRAYCONSTANT_SS_CENTERIMAGE))
	EndIf
	; Change label colour and create tooltip if required
	Select
		Case $iTranspose Or $bRange_Flag
			GUICtrlSetColor($idData_Label, 0xFF0000)
			GUICtrlSetTip($idData_Label, $sTipData)
	EndSelect
	; Set resizing
	GUICtrlSetResizing($idListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($idCopy_ID, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSetResizing($idCopy_Data, $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSetResizing($idData_Label, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSetResizing($idUser_Func, $_ARRAYCONSTANT_GUI_DOCKHCENTER + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSetResizing($idExit_Script, $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)

	; Start ListView update
	GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_WM_SETREDRAW, 0, 0)

	; Fill listview
	Local $iRowIndex, $iColFill

	If $iTranspose Then
		For $i = $iSubItem_Start To $iSubItem_End
			; Create ListView item
			$iRowIndex = __ArrayDisplay_AddItem($idListView, "NULL")
			; Add row number if required and determine start column for data
			If $iNoRow Then
				$iColFill = 0
			Else
				__ArrayDisplay_AddSubItem($idListView, $iRowIndex, "Col " & $i, 0)
				$iColFill = 1
			EndIf
			; Fill row with data
			For $j = $iItem_Start To $iItem_End
				If $iDimension = 2 Then
					$vTmp = $aArray[$j][$i]
				Else
					$vTmp = $aArray[$j]
				EndIf
				Switch VarGetType($vTmp)
					Case "Array"
						__ArrayDisplay_AddSubItem($idListView, $iRowIndex, "{Array}", $iColFill)
					Case Else
						__ArrayDisplay_AddSubItem($idListView, $iRowIndex, $vTmp, $iColFill)
				EndSwitch
				$iColFill += 1
			Next
		Next
	Else
		For $i = $iItem_Start To $iItem_End
			; Create ListView item
			$iRowIndex = __ArrayDisplay_AddItem($idListView, "NULL")
			; Add row number if required and determine start column for data
			If $iNoRow Then
				$iColFill = 0
			Else
				__ArrayDisplay_AddSubItem($idListView, $iRowIndex, "Row " & $i, 0)
				$iColFill = 1
			EndIf
			; Fill row with data
			For $j = $iSubItem_Start To $iSubItem_End
				If $iDimension = 2 Then
					$vTmp = $aArray[$i][$j]
				Else
					$vTmp = $aArray[$i]
				EndIf
				Switch VarGetType($vTmp)
					Case "Array"
						__ArrayDisplay_AddSubItem($idListView, $iRowIndex, "{Array}", $iColFill)
					Case Else
						__ArrayDisplay_AddSubItem($idListView, $iRowIndex, $vTmp, $iColFill)
				EndSwitch
				$iColFill += 1
			Next
		Next
	EndIf

	; Align columns if required - $iColAlign = 2 for Right and 4 for Center
	If $iColAlign Then
		; Loop through columns
		For $i = 0 To $iColFill - 1
			 __ArrayDisplay_JustifyColumn($idListView, $i, $iColAlign / 2)
		Next
	EndIf

	; End ListView update
	GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_WM_SETREDRAW, 1, 0)

	; Allow for borders with and without vertical scrollbar
	Local $iBorder = (($iRowIndex > 19) ? (65) : (45))
	; Adjust dialog width
	Local $iWidth = $iBorder, $iColWidth = 0, $aiColWidth[$iColFill], $iMin_ColWidth = 55
	; Get required column widths to fit items
	For $i = 0 To UBound($aiColWidth) - 1
		GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH, $i, $_ARRAYCONSTANT_LVSCW_AUTOSIZE)
		$iColWidth = GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
		; Check width of header if set
		If $sHeader <> "" Then
			GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH, $i, $_ARRAYCONSTANT_LVSCW_AUTOSIZE_USEHEADER)
			Local $iColWidthHeader = GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
			; Set minimum if required
			If $iColWidth < $iMin_ColWidth And $iColWidthHeader < $iMin_ColWidth Then
				GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH, $i, $iMin_ColWidth)
				$iColWidth = $iMin_ColWidth
			ElseIf $iColWidthHeader < $iColWidth Then
				GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH, $i, $iColWidth)
			Else
				$iColWidth = $iColWidthHeader
			EndIf
		Else
			; Set minimum if required
			If $iColWidth < $iMin_ColWidth Then
				GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH, $i, $iMin_ColWidth)
				$iColWidth = $iMin_ColWidth
			EndIf
		EndIf
		; Add to total width
		$iWidth += $iColWidth
		; Store  value
		$aiColWidth[$i] = $iColWidth
	Next
	; Now check max size
	If $iWidth > @DesktopWidth - 100 Then
		; Apply max col width limit to reduce width
		$iWidth = $iBorder
		For $i = 0 To UBound($aiColWidth) - 1
			If $aiColWidth[$i] > $iMax_ColWidth Then
				; Reset width
				GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_SETCOLUMNWIDTH, $i, $iMax_ColWidth)
				$iWidth += $iMax_ColWidth
			Else
				; Retain width
				$iWidth += $aiColWidth[$i]
			EndIf
		Next
	EndIf
	; Check max/min width
	If $iWidth > @DesktopWidth - 100 Then
		$iWidth = @DesktopWidth - 100
	ElseIf $iWidth < $iMinSize Then
		$iWidth = $iMinSize
	EndIf

	; Get row height
	Local $tRECT = DllStructCreate("struct; long Left;long Top;long Right;long Bottom; endstruct") ; $tagRECT
	DllCall("user32.dll", "struct*", "SendMessageW", "hwnd", GUICtrlGetHandle($idListView), "uint", $_ARRAYCONSTANT_LVM_GETITEMRECT, "wparam", 0, "struct*", $tRECT)
	; Set required GUI height
	Local $aiWin_Pos = WinGetPos($hGUI)
	Local $aiLV_Pos = ControlGetPos($hGUI, "", $idListView)
	$iHeight = (($iRowIndex + 4) * (DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top"))) + $aiWin_Pos[3] - $aiLV_Pos[3]
	; Check min/max height
	If $iHeight > @DesktopHeight - 100 Then
		$iHeight = @DesktopHeight - 100
	ElseIf $iHeight < $iMinSize Then
		$iHeight = $iMinSize
	EndIf

	If $iVerbose Then SplashOff()

	; Display and resize dialog
	GUISetState(@SW_HIDE, $hGUI)
	WinMove($hGUI, "", (@DesktopWidth - $iWidth) / 2, (@DesktopHeight - $iHeight) / 2, $iWidth, $iHeight)
	GUISetState(@SW_SHOW, $hGUI)

	; Switch to GetMessage mode
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $iMsg

	__ArrayDisplay_RegisterSortCallBack($idListView, 2, True, "__ArrayDisplay_SortCallBack")

	While 1

		$iMsg = GUIGetMsg() ; Variable needed to check which "Copy" button was pressed
		Switch $iMsg
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop

			Case $idCopy_ID, $idCopy_Data
				; Count selected rows
				Local $iSel_Count = GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETSELECTEDCOUNT, 0, 0)
				; Display splash dialog if required
				If $iVerbose And (Not $iSel_Count) And ($iItem_End - $iItem_Start) * ($iSubItem_End - $iSubItem_Start) > 10000 Then
					SplashTextOn($sMsgBoxTitle, "Copying data" & @CRLF & @CRLF & "Please be patient", 300, 100)
				EndIf
				; Generate clipboard text
				Local $sClip = "", $sItem, $aSplit
				; Add items
				For $i = 0 To GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0) - 1
					; Skip if copying selected rows and item not selected
					If $iSel_Count And Not (GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, $_ARRAYCONSTANT_LVIS_SELECTED) <> 0) Then
						ContinueLoop
					EndIf
					$sItem = __ArrayDisplay_GetItemTextString($idListView, $i)
					If $iMsg = $idCopy_ID And $iNoRow Then
						; Add row data
						$sItem = "Row " & ($i + (($iTranspose) ? ($iSubItem_Start) : ($iItem_Start))) & $sCurr_Separator & $sItem
					EndIf
					If $iMsg = $idCopy_Data And Not $iNoRow Then
						; Remove Row data
						$sItem = StringRegExpReplace($sItem, "^Row\s\d+\|(.*)$", "$1")
					EndIf
					If $iCW_ColWidth Then
						; Expand columns
						$aSplit = StringSplit($sItem, $sCurr_Separator)
						$sItem = ""
						For $j = 1 To $aSplit[0]
							$sItem &= StringFormat("%-" & $iCW_ColWidth + 1 & "s", StringLeft($aSplit[$j], $iCW_ColWidth))
						Next
					Else
						; Use defined separator
						$sItem = StringReplace($sItem, $sCurr_Separator, $vUser_Separator)
					EndIf
					$sClip &= $sItem & @CRLF
				Next
				$sItem = $sHeader
				; Add header line if required
				If $iMsg = $idCopy_ID Then
					$sItem = $sHeader
					If $iNoRow Then
						; Add "Row" to header
						$sItem = "Row|" & $sItem
					EndIf
					If $iCW_ColWidth Then
						$aSplit = StringSplit($sItem, $sCurr_Separator)
						$sItem = ""
						For $j = 1 To $aSplit[0]
							$sItem &= StringFormat("%-" & $iCW_ColWidth + 1 & "s", StringLeft($aSplit[$j], $iCW_ColWidth))
						Next
					Else
						$sItem = StringReplace($sItem, $sCurr_Separator, $vUser_Separator)
					EndIf
					$sClip = $sItem & @CRLF & $sClip
				EndIf
				;Send to clipboard
				ClipPut($sClip)
				; Remove splash if used
				SplashOff()
				; Refocus ListView
				GUICtrlSetState($idListView, $_ARRAYCONSTANT_GUI_FOCUS)

			Case $idListView
				; Kick off the sort callback
				__ArrayDisplay_SortItems($idListView, GUICtrlGetState($idListView))

			Case $idUser_Func
				; Get selected indices
				Local $aiSelItems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0) - 1
					If (GUICtrlSendMsg($idListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, $_ARRAYCONSTANT_LVIS_SELECTED) <> 0) Then
						$aiSelItems[0] += 1
						ReDim $aiSelItems[$aiSelItems[0] + 1]
						$aiSelItems[$aiSelItems[0]] = $i + $iItem_Start
					EndIf
				Next

				; Pass array and selection to user function
				$hUser_Function($aArray, $aiSelItems)
				GUICtrlSetState($idListView, $_ARRAYCONSTANT_GUI_FOCUS)

			Case $idExit_Script
				; Clear up
				GUIDelete($hGUI)
				Exit
		EndSwitch
	WEnd

	; Clear up
	GUIDelete($hGUI)
	Opt("GUICoordMode", $iCoordMode) ; Reset original Coord mode
	Opt("GUIOnEventMode", $iOnEventMode) ; Reset original GUI mode
;~ 	Opt("GUIDataSeparatorChar", $sCurr_Separator) ; Reset original separator

	Return 1
EndFunc   ;==>__ArrayDisplay_Share

; #DUPLICATED Functions to avoid big #include <GuiListView.au3># ================================================================
; Functions have been simplified (unicode inprocess) according to __ArrayDisplay_Share() needs

Func __ArrayDisplay_RegisterSortCallBack($hWnd, $vCompareType = 2, $bArrows = True, $sSort_Callback = "__ArrayDisplay_SortCallBack")
	  #Au3Stripper_Ignore_Funcs=$sSort_Callback
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

;~ 	Local Const $LVM_GETHEADER = (0x1000 + 31) ; 0x101F
	Local $hHeader =  HWnd(GUICtrlSendMsg($hWnd, 0x101F, 0, 0))

	$__g_aArrayDisplay_SortInfo[1] = $hWnd ; Handle of listview

	$__g_aArrayDisplay_SortInfo[2] = DllCallbackRegister($sSort_Callback, "int", "int;int;hwnd") ; Handle of callback

	$__g_aArrayDisplay_SortInfo[3] = -1 ; $nColumn
	$__g_aArrayDisplay_SortInfo[4] = -1 ; nCurCol
	$__g_aArrayDisplay_SortInfo[5] = 1 ; $nSortDir
	$__g_aArrayDisplay_SortInfo[6] = -1 ; $nCol
	$__g_aArrayDisplay_SortInfo[7] = 0 ; $bSet
	$__g_aArrayDisplay_SortInfo[8] = $vCompareType ; Treat as Strings, Numbers or use Windows API to compare
	$__g_aArrayDisplay_SortInfo[9] = $bArrows ; Use arrows in the header of the columns?
	$__g_aArrayDisplay_SortInfo[10] = $hHeader ; Handle to the Header

	Return $__g_aArrayDisplay_SortInfo[2] <> 0
EndFunc   ;==>__ArrayDisplay_RegisterSortCallBack

#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
	; Switch the sorting direction
	If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then ; $nColumn = nCurCol ?
		If Not $__g_aArrayDisplay_SortInfo[7] Then ; $bSet
			$__g_aArrayDisplay_SortInfo[5] *= -1 ; $nSortDir
			$__g_aArrayDisplay_SortInfo[7] = 1 ; $bSet
		EndIf
	Else
		$__g_aArrayDisplay_SortInfo[7] = 1 ; $bSet
	EndIf
	$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3] ; $nCol = $nColumn
	Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
	Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])

	If $__g_aArrayDisplay_SortInfo[8] = 1 Then
		; force Treat as Number if possible
		If (StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
		If (StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
	EndIf

	Local $nResult
	If $__g_aArrayDisplay_SortInfo[8] < 2 Then
		; Treat as String or Number
		$nResult = 0 ; No change of item1 and item2 positions
		If $sVal1 < $sVal2 Then
			$nResult = -1 ; Put item2 before item1
		ElseIf $sVal1 > $sVal2 Then
			$nResult = 1 ; Put item2 behind item1
		EndIf
	Else
		; Use API handling
		$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
	EndIf

	$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5] ; $nSortDir

	Return $nResult
EndFunc   ;==>__ArrayDisplay_SortCallBack

Func __ArrayDisplay_SortItems($hWnd, $iCol)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $pFunction = DllCallbackGetPtr($__g_aArrayDisplay_SortInfo[2]) ; get pointer to call back
	$__g_aArrayDisplay_SortInfo[3] = $iCol ; $nColumn = column clicked
	$__g_aArrayDisplay_SortInfo[7] = 0 ; $bSet
	$__g_aArrayDisplay_SortInfo[4] = $__g_aArrayDisplay_SortInfo[6] ; nCurCol = $nCol
;~ 	Local Const $LVM_SORTITEMSEX = ($LVM_FIRST + 81) ; 0x1000 + 81
	Local $aResult = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1051, "hwnd", $hWnd, "ptr", $pFunction)
	If $aResult[0] <> 0 Then
		If $__g_aArrayDisplay_SortInfo[9] Then ; Use arrow in header
			Local $hHeader = $__g_aArrayDisplay_SortInfo[10], $iFormat
			For $x = 0 To __ArrayDisplay_GetItemCount($hHeader) - 1
				$iFormat = __ArrayDisplay_GetItemFormat($hHeader, $x)
				If BitAND($iFormat, 0x00000200) Then ; $HDF_SORTDOWN
					__ArrayDisplay_SetItemFormat($hHeader, $x, BitXOR($iFormat, 0x00000200))
				ElseIf BitAND($iFormat, 0x00000400) Then ; $HDF_SORTUP
					__ArrayDisplay_SetItemFormat($hHeader, $x, BitXOR($iFormat, 0x00000400))
				EndIf
			Next
			$iFormat = __ArrayDisplay_GetItemFormat($hHeader, $iCol)
			If $__g_aArrayDisplay_SortInfo[5] = 1 Then ; ascending
				__ArrayDisplay_SetItemFormat($hHeader, $iCol, BitOR($iFormat, 0x00000400))
			Else ; descending
				__ArrayDisplay_SetItemFormat($hHeader, $iCol, BitOR($iFormat, 0x00000200))
			EndIf
		EndIf

		Return True
	EndIf

	Return False
EndFunc   ;==>__ArrayDisplay_SortItems

Func __ArrayDisplay_AddItem($hWnd, $sText)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
	DllStructSetData($tItem, "Param", 0)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	$iBuffer *= 2
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
	DllStructSetData($tItem, "TextMax", $iBuffer)

;~ Local Const $LVIF_PARAM = 0x00000004
;~ Local Const $LVIF_TEXT = 0x00000001
	Local $iMask = 0x00000005 ; LVIF_TEXT + $LVIF_PARAM
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", 999999999) ; add item
	DllStructSetData($tItem, "Image", -1) ; no image
	Local $pItem = DllStructGetPtr($tItem)
;~ Local Const $_ARRAYCONSTANTS_LVM_INSERTITEMW = (0x1000 + 77) ; 0x104D
	Local $iRet = GUICtrlSendMsg($hWnd, 0x104D, 0, $pItem)

	Return $iRet
EndFunc   ;==>__ArrayDisplay_AddItem

Func __ArrayDisplay_AddSubItem($hWnd, $iIndex, $sText, $iSubItem)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	$iBuffer *= 2
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
;~ Local Const $LVIF_TEXT = 0x00000001
	Local $iMask = 0x00000001 ; $LVIF_TEXT
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $iMask) ; just text
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Image", -1) ; no image
	Local $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Text", $pBuffer)
;~ Local Const $_ARRAYCONSTANTS_LVM_SETITEMW = (0x1000 + 76) ; 0x104C
	Local $iRet = GUICtrlSendMsg($hWnd, 0x104C, 0, $pItem)

	Return $iRet <> 0
EndFunc   ;==>__ArrayDisplay_AddSubItem

Func __ArrayDisplay_GetColumnCount($hWnd)
;~ 	Local Const $LVM_GETHEADER = (0x1000 + 31) ; 0x101F
	Local $hHeader = HWnd(GUICtrlSendMsg($hWnd, 0x101F, 0, 0))

	Return __ArrayDisplay_GetItemCount($hHeader)
EndFunc   ;==>__ArrayDisplay_GetColumnCount

Func __ArrayDisplay_GetHeader($hWnd)

;~ 	Local Const $LVM_GETHEADER = (0x1000 + 31) ; 0x101F
	Return HWnd(GUICtrlSendMsg($hWnd, 0x101F, 0, 0))
EndFunc   ;==>__ArrayDisplay_GetHeader

Func __ArrayDisplay_GetItem($hWnd, $iIndex, ByRef $tItem)
	;Global Const $HDM_GETITEMW = $HDM_FIRST + 11 ; 0x1200 + 11
	Local $aResult = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x120B, "wparam", $iIndex, "struct*", $tItem)

	Return $aResult[0] <> 0
EndFunc   ;==>__ArrayDisplay_GetItem

Func __ArrayDisplay_GetItemCount($hWnd)
	;Local Const $HDM_GETITEMCOUNT = 0x1200
	Local $aResult = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1200, "wparam", 0, "lparam", 0)

	Return $aResult[0]
EndFunc   ;==>__ArrayDisplayr_GetItemCount

Func __ArrayDisplay_GetItemFormat($hWnd, $iIndex)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagHDITEM)
	DllStructSetData($tItem, "Mask", 0x00000004) ; $HDI_FORMAT
	__ArrayDisplay_GetItem($hWnd, $iIndex, $tItem)

	Return DllStructGetData($tItem, "Fmt")
EndFunc   ;==>__ArrayDisplay_GetItemFormat

Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
	Local $tBuffer = DllStructCreate("wchar Text[4096]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "TextMax", 4096)
	DllStructSetData($tItem, "Text", $pBuffer)
	;Global Const $LVM_GETITEMTEXTW = (0x1000 + 115) ; 0X1073
	If IsHWnd($hWnd) Then
		DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
	Else
		Local $pItem = DllStructGetPtr($tItem)
		GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
	EndIf

	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>__ArrayDisplay_GetItemText

Func __ArrayDisplay_GetItemTextString($hWnd, $iItem)
	Local $sRow = "", $sSeparatorChar = Opt('GUIDataSeparatorChar')
	Local $iSelected = $iItem ; get row
	For $x = 0 To __ArrayDisplay_GetColumnCount($hWnd) - 1
		$sRow &= __ArrayDisplay_GetItemText($hWnd, $iSelected, $x) & $sSeparatorChar
	Next

	Return StringTrimRight($sRow, 1)
EndFunc   ;==>__ArrayDisplay_GetItemTextString

Func __ArrayDisplay_JustifyColumn($idListView, $iIndex, $iAlign = -1)
	;Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]

	Local $tColumn = DllStructCreate("uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal") ; $tagLVCOLUMN
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	DllStructSetData($tColumn, "Mask", 0x01) ; $LVCF_FMT
	DllStructSetData($tColumn, "Fmt", $iAlign)
	Local $pColumn = DllStructGetPtr($tColumn)
	Local $iRet = GUICtrlSendMsg($idListView, 0x1060 , $iIndex, $pColumn) ; $_ARRAYCONSTANT_LVM_SETCOLUMNW
	Return $iRet <> 0
EndFunc   ;==>__ArrayDisplay_JustifyColumn

Func __ArrayDisplay_SetItemFormat($hWnd, $iIndex, $iFormat)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagHDITEM)
	DllStructSetData($tItem, "Mask", 0x00000004) ; $HDI_FORMAT
	DllStructSetData($tItem, "Fmt", $iFormat)
	;Global Const $HDM_SETITEMW = $HDM_FIRST + 12 ; 0x1200 + 12
	Local $aResult = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x120C, "wparam", $iIndex, "struct*", $tItem)

	Return $aResult[0] <> 0
EndFunc   ;==>__ArrayDisplay_SetItemFormat

; ===============================================================================================================================
