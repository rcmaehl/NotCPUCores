#include-once

#include "Array.au3"
#include "GuiHeader.au3"
#include "ListViewConstants.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPIConv.au3"
#include "WinAPIGdi.au3"
#include "WinAPIMisc.au3"
#include "WinAPIRes.au3"

; #INDEX# =======================================================================================================================
; Title .........: ListView
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist with ListView control management.
;                  A ListView control is a window that displays a collection of items; each item consists of an icon and a label.
;                  ListView controls provide several ways to arrange and display items. For example, additional information about
;                  each item can be displayed in columns to the right of the icon and label.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hLVLastWnd

; for use with the sort call back functions
Global Const $__LISTVIEWCONSTANT_SORTINFOSIZE = 11
Global $__g_aListViewSortInfo[1][$__LISTVIEWCONSTANT_SORTINFOSIZE]
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__LISTVIEWCONSTANT_ClassName = "SysListView32"
Global Const $__LISTVIEWCONSTANT_WS_MAXIMIZEBOX = 0x00010000
Global Const $__LISTVIEWCONSTANT_WS_MINIMIZEBOX = 0x00020000
Global Const $__LISTVIEWCONSTANT_GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $__LISTVIEWCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__LISTVIEWCONSTANT_WM_SETFONT = 0x0030
Global Const $__LISTVIEWCONSTANT_WM_NOTIFY = 0x004E
Global Const $__LISTVIEWCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__LISTVIEWCONSTANT_ILD_TRANSPARENT = 0x00000001
Global Const $__LISTVIEWCONSTANT_ILD_BLEND25 = 0x00000002
Global Const $__LISTVIEWCONSTANT_ILD_BLEND50 = 0x00000004
Global Const $__LISTVIEWCONSTANT_ILD_MASK = 0x00000010
Global Const $__LISTVIEWCONSTANT_VK_DOWN = 0x28
Global Const $__LISTVIEWCONSTANT_VK_END = 0x23
Global Const $__LISTVIEWCONSTANT_VK_HOME = 0x24
Global Const $__LISTVIEWCONSTANT_VK_LEFT = 0x25
Global Const $__LISTVIEWCONSTANT_VK_NEXT = 0x22
Global Const $__LISTVIEWCONSTANT_VK_PRIOR = 0x21
Global Const $__LISTVIEWCONSTANT_VK_RIGHT = 0x27
Global Const $__LISTVIEWCONSTANT_VK_UP = 0x26
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlListView_GetEmptyText
; _GUICtrlListView_GetGroupState
; _GUICtrlListView_GetInsertMark
; _GUICtrlListView_GetInsertMarkColor
; _GUICtrlListView_GetInsertMarkRect
; _GUICtrlListView_InsertMarkHitTest
; _GUICtrlListView_IsItemVisible
; _GUICtrlListView_MoveGroup
; _GUICtrlListView_SetHotCursor
; _GUICtrlListView_SetInfoTip
; _GUICtrlListView_SetInsertMark
; _GUICtrlListView_SetInsertMarkColor
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlListView_AddArray
; _GUICtrlListView_AddColumn
; _GUICtrlListView_AddItem
; _GUICtrlListView_AddSubItem
; _GUICtrlListView_ApproximateViewHeight
; _GUICtrlListView_ApproximateViewRect
; _GUICtrlListView_ApproximateViewWidth
; _GUICtrlListView_Arrange
; _GUICtrlListView_BeginUpdate
; _GUICtrlListView_CancelEditLabel
; _GUICtrlListView_ClickItem
; _GUICtrlListView_CopyItems
; _GUICtrlListView_Create
; _GUICtrlListView_CreateDragImage
; _GUICtrlListView_CreateSolidBitMap
; _GUICtrlListView_DeleteAllItems
; _GUICtrlListView_DeleteColumn
; _GUICtrlListView_DeleteItem
; _GUICtrlListView_DeleteItemsSelected
; _GUICtrlListView_Destroy
; _GUICtrlListView_DrawDragImage
; _GUICtrlListView_EditLabel
; _GUICtrlListView_EnableGroupView
; _GUICtrlListView_EndUpdate
; _GUICtrlListView_EnsureVisible
; _GUICtrlListView_FindInText
; _GUICtrlListView_FindItem
; _GUICtrlListView_FindNearest
; _GUICtrlListView_FindParam
; _GUICtrlListView_FindText
; _GUICtrlListView_GetBkColor
; _GUICtrlListView_GetBkImage
; _GUICtrlListView_GetCallbackMask
; _GUICtrlListView_GetColumn
; _GUICtrlListView_GetColumnCount
; _GUICtrlListView_GetColumnOrder
; _GUICtrlListView_GetColumnOrderArray
; _GUICtrlListView_GetColumnWidth
; _GUICtrlListView_GetCounterPage
; _GUICtrlListView_GetEditControl
; _GUICtrlListView_GetExtendedListViewStyle
; _GUICtrlListView_GetFocusedGroup
; _GUICtrlListView_GetGroupCount
; _GUICtrlListView_GetGroupInfo
; _GUICtrlListView_GetGroupInfoByIndex
; _GUICtrlListView_GetGroupRect
; _GUICtrlListView_GetGroupViewEnabled
; _GUICtrlListView_GetHeader
; _GUICtrlListView_GetHotCursor
; _GUICtrlListView_GetHotItem
; _GUICtrlListView_GetHoverTime
; _GUICtrlListView_GetImageList
; _GUICtrlListView_GetISearchString
; _GUICtrlListView_GetItem
; _GUICtrlListView_GetItemChecked
; _GUICtrlListView_GetItemCount
; _GUICtrlListView_GetItemCut
; _GUICtrlListView_GetItemDropHilited
; _GUICtrlListView_GetItemEx
; _GUICtrlListView_GetItemFocused
; _GUICtrlListView_GetItemGroupID
; _GUICtrlListView_GetItemImage
; _GUICtrlListView_GetItemIndent
; _GUICtrlListView_GetItemParam
; _GUICtrlListView_GetItemPosition
; _GUICtrlListView_GetItemPositionX
; _GUICtrlListView_GetItemPositionY
; _GUICtrlListView_GetItemRect
; _GUICtrlListView_GetItemRectEx
; _GUICtrlListView_GetItemSelected
; _GUICtrlListView_GetItemSpacing
; _GUICtrlListView_GetItemSpacingX
; _GUICtrlListView_GetItemSpacingY
; _GUICtrlListView_GetItemState
; _GUICtrlListView_GetItemStateImage
; _GUICtrlListView_GetItemText
; _GUICtrlListView_GetItemTextArray
; _GUICtrlListView_GetItemTextString
; _GUICtrlListView_GetNextItem
; _GUICtrlListView_GetNumberOfWorkAreas
; _GUICtrlListView_GetOrigin
; _GUICtrlListView_GetOriginX
; _GUICtrlListView_GetOriginY
; _GUICtrlListView_GetOutlineColor
; _GUICtrlListView_GetSelectedColumn
; _GUICtrlListView_GetSelectedCount
; _GUICtrlListView_GetSelectedIndices
; _GUICtrlListView_GetSelectionMark
; _GUICtrlListView_GetStringWidth
; _GUICtrlListView_GetSubItemRect
; _GUICtrlListView_GetTextBkColor
; _GUICtrlListView_GetTextColor
; _GUICtrlListView_GetToolTips
; _GUICtrlListView_GetTopIndex
; _GUICtrlListView_GetUnicodeFormat
; _GUICtrlListView_GetView
; _GUICtrlListView_GetViewDetails
; _GUICtrlListView_GetViewLarge
; _GUICtrlListView_GetViewList
; _GUICtrlListView_GetViewSmall
; _GUICtrlListView_GetViewTile
; _GUICtrlListView_GetViewRect
; _GUICtrlListView_HideColumn
; _GUICtrlListView_HitTest
; _GUICtrlListView_InsertColumn
; _GUICtrlListView_InsertGroup
; _GUICtrlListView_InsertItem
; _GUICtrlListView_JustifyColumn
; _GUICtrlListView_MapIDToIndex
; _GUICtrlListView_MapIndexToID
; _GUICtrlListView_RedrawItems
; _GUICtrlListView_RegisterSortCallBack
; _GUICtrlListView_RemoveAllGroups
; _GUICtrlListView_RemoveGroup
; _GUICtrlListView_Scroll
; _GUICtrlListView_SetBkColor
; _GUICtrlListView_SetBkImage
; _GUICtrlListView_SetCallBackMask
; _GUICtrlListView_SetColumn
; _GUICtrlListView_SetColumnOrder
; _GUICtrlListView_SetColumnOrderArray
; _GUICtrlListView_SetColumnWidth
; _GUICtrlListView_SetExtendedListViewStyle
; _GUICtrlListView_SetGroupInfo
; _GUICtrlListView_SetHotItem
; _GUICtrlListView_SetHoverTime
; _GUICtrlListView_SetIconSpacing
; _GUICtrlListView_SetImageList
; _GUICtrlListView_SetItem
; _GUICtrlListView_SetItemChecked
; _GUICtrlListView_SetItemCount
; _GUICtrlListView_SetItemCut
; _GUICtrlListView_SetItemDropHilited
; _GUICtrlListView_SetItemEx
; _GUICtrlListView_SetItemFocused
; _GUICtrlListView_SetItemGroupID
; _GUICtrlListView_SetItemImage
; _GUICtrlListView_SetItemIndent
; _GUICtrlListView_SetItemParam
; _GUICtrlListView_SetItemPosition
; _GUICtrlListView_SetItemPosition32
; _GUICtrlListView_SetItemSelected
; _GUICtrlListView_SetItemState
; _GUICtrlListView_SetItemStateImage
; _GUICtrlListView_SetItemText
; _GUICtrlListView_SetOutlineColor
; _GUICtrlListView_SetSelectedColumn
; _GUICtrlListView_SetSelectionMark
; _GUICtrlListView_SetTextBkColor
; _GUICtrlListView_SetTextColor
; _GUICtrlListView_SetToolTips
; _GUICtrlListView_SetUnicodeFormat
; _GUICtrlListView_SetView
; _GUICtrlListView_SetWorkAreas
; _GUICtrlListView_SimpleSort
; _GUICtrlListView_SortItems
; _GUICtrlListView_SubItemHitTest
; _GUICtrlListView_UnRegisterSortCallBack
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagLVBKIMAGE
; $tagLVCOLUMN
; $tagLVGROUP
; $tagLVINSERTMARK
; $tagLVSETINFOTIP
; __GUICtrlListView_ArrayDelete
; __GUICtrlListView_Draw
; __GUICtrlListView_GetGroupInfoEx
; __GUICtrlListView_GetItemOverlayImage
; __GUICtrlListView_IndexToOverlayImageMask
; __GUICtrlListView_IndexToStateImageMask
; __GUICtrlListView_OverlayImageMaskToIndex
; __GUICtrlListView_SetItemOverlayImage
; __GUICtrlListView_Sort
; __GUICtrlListView_StateImageMaskToIndex
; __GUICtrlListView_ReverseColorOrder
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagLVBKIMAGE
; Description ...: Contains information about the background image of a list-view control
; Fields ........: Flags      - This member may be one or more of the following flags.  You can use the LVBKIF_SOURCE_MASK value
;                  +to mask off all but the source flags.  You can use the LVBKIF_STYLE_MASK value to mask off all but the  style
;                  +flags.
;                  |$LVBKIF_SOURCE_NONE     - The control has no background image
;                  |$LVBKIF_SOURCE_URL      - The Image member contains the URL of the background image
;                  |$LVBKIF_STYLE_NORMAL    - The background image is displayed normally
;                  |$LVBKIF_STYLE_TILE      - The background image will be tiled to fill the entire background of the control
;                  |$LVBKIF_FLAG_TILEOFFSET - You use this flag to specify the coordinates of the first tile.  This flag is valid
;                  +only if the $LVBKIF_STYLE_TILE flag is also specified. If this flag is not specified the first tile begins at
;                  +the upper-left corner of the client area.
;                  hBmp        - Not used
;                  Image       - Address of a string that contains the URL of the background image. This member is only valid if
;                  +the $LVBKIF_SOURCE_URL flag is set in Flags.  This member must be initialized to point  to  the  buffer  that
;                  +contains or receives the text before sending the message.
;                  ImageMax    - Size of the buffer at the address in Image.  If information is being sent to the  control,  this
;                  +member is ignored.
;                  XOffPercent - Percentage of the client area that the image should be offset horizontally.  For example, at  0
;                  +percent, the image will be displayed against the left edge of the control's client area.  At 50 percent,  the
;                  +image will be displayed horizontally centered in the control's client area. At 100 percent, the image will be
;                  +displayed against the right edge  of  the  control's  client  area.  This  member  is  only  valid  when  the
;                  +$LVBKIF_STYLE_NORMAL is specified in  Flags.  If  both  $LVBKIF_FLAG_TILEOFFSET  and  $LVBKIF_STYLE_TILE  are
;                  +specified in Flags, then the value specifies the pixel, not percentage offset, of the first tile.  Otherwise,
;                  +the value is ignored.
;                  YOffPercent - Percentage of the control's client area that the image should be offset vertically. For example
;                  +at 0 percent, the image will be displayed against the top edge of the control's client area.  At 50  percent,
;                  +the image will be displayed vertically centered in the control's client area.  At 100 percent, the image will
;                  +be displayed against the bottom edge of the control's client  area.  This  member  is  only  valid  when  the
;                  +$LVBKIF_STYLE_NORMAL is specified in  Flags.  If  both  $LVBKIF_FLAG_TILEOFFSET  and  $LVBKIF_STYLE_TILE  are
;                  +specified in Flags, then the value specifies the pixel, not percentage offset, of the first tile.  Otherwise,
;                  +the value is ignored.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagLVBKIMAGE = "ulong Flags;hwnd hBmp;ptr Image;uint ImageMax;int XOffPercent;int YOffPercent"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagLVCOLUMN
; Description ...: Contains information about a column in report view
; Fields ........: Mask    - Variable specifying which members contain valid information.  This member can be zero,  or  one  or
;                  +more of the following values:
;                  |LVCF_FMT     - The Fmt member is valid
;                  |LVCF_WIDTH   - The CX member is valid
;                  |LVCF_TEXT    - The Text member is valid
;                  |LVCF_SUBITEM - The SubItem member is valid
;                  |LVCF_IMAGE   - The Image member is valid
;                  |LVCF_ORDER   - The Order member is valid.
;                  Fmt     - Alignment of the column header and the subitem text in the column.  This member can be one  of  the
;                  +following values. The alignment of the leftmost column is always left-justified; it cannot be changed:
;                  |LVCFMT_LEFT            - Text is left-aligned
;                  |LVCFMT_RIGHT           - Text is right-aligned
;                  |LVCFMT_CENTER          - Text is centered
;                  |LVCFMT_JUSTIFYMASK     - A bitmask used to select those bits of Fmt that control field justification
;                  |LVCFMT_IMAGE           - The item displays an image from an image list
;                  |LVCFMT_BITMAP_ON_RIGHT - The bitmap appears to the right of text
;                  |LVCFMT_COL_HAS_IMAGES  - The header item contains an image in the image list.
;                  CX      - Width of the column, in pixels
;                  Text    - If column information is being set, this member is the address of a string that contains the column
;                  +header text.  If the structure is receiving information about a column, this member specifies the address  of
;                  +the buffer that receives the column header text.
;                  TextMax - Size of the buffer pointed to by the Text member.  If the structure is  not  receiving  information
;                  +about a column, this member is ignored.
;                  SubItem - Index of subitem associated with the column
;                  Image   - Zero based index of an image within the image list
;                  Order   - Zero-based column offset. Column offset is in left-to-right order.
;                  Microsoft Windows Vista or later
;                    cxMin;       // min snap point
;                    cxDefault;   // default snap point
;                    cxIdeal;     // read only. ideal may not eqaul current width if auto sized (LVS_EX_AUTOSIZECOLUMNS) to a lesser width.
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; Remarks .......:
; ===============================================================================================================================
Global Const $tagLVCOLUMN = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagLVGROUP
; Description ...: Used to set and retrieve groups
; Fields ........: Size      - Size of this structure, in bytes
;                  Mask      - Mask that specifies which members of the structure are valid input.  Can be one or  more  of  the
;                  +following values:
;                  |$LVGF_NONE    - No other items are valid
;                  |$LVGF_HEADER  - Header and HeaderMax members are valid
;                  |$LVGF_FOOTER  - Reserved
;                  |$LVGF_STATE   - Reserved
;                  |$LVGF_ALIGN   - Align member is valid
;                  |$LVGF_GROUPID - GroupId member is valid
;                  Header    - Pointer to a string that contains the header text when item information is being  set.  If  group
;                  +information is being retrieved this member specifies the address of the buffer that receives the header text.
;                  HeaderMax - Size of the buffer pointed to by the Header member. If the structure is not receiving information
;                  +about a group, this member is ignored.
;                  Footer    - Reserved
;                  FooterMax - Reserved
;                  GroupID   - ID of the group
;                  StateMask - Reserved
;                  State     - Reserved
;                  Align     - Indicates the alignment of the header text.  It can have one or more of the following values. Use
;                  +one of the header flags.
;                  |LVGA_HEADER_CENTER - Header text is centered horizontally in the window
;                  |LVGA_HEADER_LEFT   - Header text is aligned at the left of the window
;                  |LVGA_HEADER_RIGHT  - Header text is aligned at the right of the window.
;                  Microsoft Windows Vista or later
;                      pszSubtitle;
;                      cchSubtitle;
;                      pszTask;
;                      cchTask;
;                      pszDescriptionTop;
;                      cchDescriptionTop;
;                      pszDescriptionBottom;
;                      cchDescriptionBottom;
;                      iTitleImage;
;                      iExtendedImage;
;                      iFirstItem;         // Read only
;                      cItems;             // Read only
;                      pszSubsetTitle;     // NULL if group is not subset
;                      cchSubsetTitle;
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; Remarks .......:
; ===============================================================================================================================
Global Const $tagLVGROUP = "uint Size;uint Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;uint StateMask;uint State;uint Align;" & _
		"ptr  pszSubtitle;uint cchSubtitle;ptr pszTask;uint cchTask;ptr pszDescriptionTop;uint cchDescriptionTop;ptr pszDescriptionBottom;" & _
		"uint cchDescriptionBottom;int iTitleImage;int iExtendedImage;int iFirstItem;uint cItems;ptr pszSubsetTitle;uint cchSubsetTitle"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagLVINSERTMARK
; Description ...: Used to describe insertion points
; Fields ........: Size     - Size of this structure, in bytes
;                  Flags    - Flag that specifies where the insertion point should appear:
;                  |$LVIM_AFTER - The insertion point appears after the item specified if the $LVIM_AFTER flag is set; otherwise
;                  +it appears before the specified item.
;                  Item     - Item next to which the insertion point appears. If -1, there is no insertion point.
;                  Reserved - Reserved. Must be set to 0.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagLVINSERTMARK = "uint Size;dword Flags;int Item;dword Reserved"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagLVSETINFOTIP
; Description ...: Provides information about tooltip text that is to be set
; Fields ........: Size    - Size of this structure, in bytes
;                  Flags   - Flag that specifies how the text should be set. Set to zero.
;                  Text    - Pointer to a Unicode string that contains the tooltip text
;                  Item    - Contains the zero based index of the item to which this structure refers
;                  SubItem - Contains the one based index of the subitem to which this structure refers
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagLVSETINFOTIP = "uint Size;dword Flags;ptr Text;int Item;int SubItem"

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_AddArray($hWnd, ByRef $aItems)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tItem = DllStructCreate($tagLVITEM)
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	DllStructSetData($tItem, "Mask", $LVIF_TEXT)
	DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
	DllStructSetData($tItem, "TextMax", 4096)
	Local $iLastItem = _GUICtrlListView_GetItemCount($hWnd)
	_GUICtrlListView_BeginUpdate($hWnd)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			For $iI = 0 To UBound($aItems) - 1
				DllStructSetData($tItem, "Item", $iI)
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tBuffer, "Text", $aItems[$iI][0])
				_SendMessage($hWnd, $LVM_INSERTITEMW, 0, $tItem, 0, "wparam", "struct*")
				For $iJ = 1 To UBound($aItems, $UBOUND_COLUMNS) - 1
					DllStructSetData($tItem, "SubItem", $iJ)
					DllStructSetData($tBuffer, "Text", $aItems[$iI][$iJ])
					_SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
				Next
			Next
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			For $iI = 0 To UBound($aItems) - 1
				DllStructSetData($tItem, "Item", $iI + $iLastItem)
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tBuffer, "Text", $aItems[$iI][0])
				_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
				_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
				If $bUnicode Then
					_SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
				Else
					_SendMessage($hWnd, $LVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
				EndIf
				For $iJ = 1 To UBound($aItems, $UBOUND_COLUMNS) - 1
					DllStructSetData($tItem, "SubItem", $iJ)
					DllStructSetData($tBuffer, "Text", $aItems[$iI][$iJ])
					_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
					_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
					If $bUnicode Then
						_SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
					Else
						_SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
					EndIf
				Next
			Next
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		For $iI = 0 To UBound($aItems) - 1
			DllStructSetData($tItem, "Item", $iI + $iLastItem)
			DllStructSetData($tItem, "SubItem", 0)
			DllStructSetData($tBuffer, "Text", $aItems[$iI][0])
			If $bUnicode Then
				GUICtrlSendMsg($hWnd, $LVM_INSERTITEMW, 0, $pItem)
			Else
				GUICtrlSendMsg($hWnd, $LVM_INSERTITEMA, 0, $pItem)
			EndIf
			For $iJ = 1 To UBound($aItems, $UBOUND_COLUMNS) - 1
				DllStructSetData($tItem, "SubItem", $iJ)
				DllStructSetData($tBuffer, "Text", $aItems[$iI][$iJ])
				If $bUnicode Then
					GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
				Else
					GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
				EndIf
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate($hWnd)
EndFunc   ;==>_GUICtrlListView_AddArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_AddColumn($hWnd, $sText, $iWidth = 50, $iAlign = -1, $iImage = -1, $bOnRight = False)
	Return _GUICtrlListView_InsertColumn($hWnd, _GUICtrlListView_GetColumnCount($hWnd), $sText, $iWidth, $iAlign, $iImage, $bOnRight)
EndFunc   ;==>_GUICtrlListView_AddColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_AddItem($hWnd, $sText, $iImage = -1, $iParam = 0)
	Return _GUICtrlListView_InsertItem($hWnd, $sText, -1, $iImage, $iParam)
EndFunc   ;==>_GUICtrlListView_AddItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_AddSubItem($hWnd, $iIndex, $sText, $iSubItem, $iImage = -1)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $iMask = $LVIF_TEXT
	If $iImage <> -1 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_AddSubItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_ApproximateViewHeight($hWnd, $iCount = -1, $iCX = -1, $iCY = -1)
	If IsHWnd($hWnd) Then
		Return BitShift((_SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 16)
	Else
		Return BitShift((GUICtrlSendMsg($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 16)
	EndIf
EndFunc   ;==>_GUICtrlListView_ApproximateViewHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_ApproximateViewRect($hWnd, $iCount = -1, $iCX = -1, $iCY = -1)
	Local $iView
	If IsHWnd($hWnd) Then
		$iView = _SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))
	Else
		$iView = GUICtrlSendMsg($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))
	EndIf
	Local $aView[2]
	$aView[0] = BitAND($iView, 0xFFFF)
	$aView[1] = BitShift($iView, 16)
	Return $aView
EndFunc   ;==>_GUICtrlListView_ApproximateViewRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_ApproximateViewWidth($hWnd, $iCount = -1, $iCX = -1, $iCY = -1)
	If IsHWnd($hWnd) Then
		Return BitAND((_SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 0xFFFF)
	Else
		Return BitAND((GUICtrlSendMsg($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 0xFFFF)
	EndIf
EndFunc   ;==>_GUICtrlListView_ApproximateViewWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_Arrange($hWnd, $iArrange = 0)
	Local $aArrange[4] = [$LVA_DEFAULT, $LVA_ALIGNLEFT, $LVA_ALIGNTOP, $LVA_SNAPTOGRID]
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ARRANGE, $aArrange[$iArrange]) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ARRANGE, $aArrange[$iArrange], 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_Arrange

; #INTERNAL_USE_ONLY#==============================================================================
; Name...........: __GUICtrlListView_ArrayDelete
; Description ...: Deletes the specified element from the given array, returning the adjusted array.
; Syntax.........: __GUICtrlListView_ArrayDelete ( ByRef $avArray, $iElement )
; Parameters ....: $avArray     - The array from which an element is to be deleted
;                  $iElement    - The index of the element to be deleted
; Return values .: Success - Returns 1 and the original Array is updated
;                  Failure - Returns 0 and the original Array
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Array is passed via ByRef  - Jos van der zande, for exclusive use with listview sort - GaryFrost
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_ArrayDelete(ByRef $avArray, $iElement)
	If Not IsArray($avArray) Then Return SetError(1, 0, "")

	; We have to define this here so that we're sure that $avArray is an array
	; before we get it's size.
	Local $iUpper = UBound($avArray) ; Size of original array

	; If the array is only 1 element in size then we can't delete the 1 element.
	If $iUpper = 1 Then
		SetError(2)
		Return ""
	EndIf

	Local $avNewArray[$iUpper - 1][$__LISTVIEWCONSTANT_SORTINFOSIZE]
	$avNewArray[0][0] = $avArray[0][0]
	If $iElement < 0 Then
		$iElement = 0
	EndIf
	If $iElement > ($iUpper - 1) Then
		$iElement = ($iUpper - 1)
	EndIf
	If $iElement > 0 Then
		For $iCntr = 0 To $iElement - 1
			For $x = 1 To $__LISTVIEWCONSTANT_SORTINFOSIZE - 1
				$avNewArray[$iCntr][$x] = $avArray[$iCntr][$x]
			Next
		Next
	EndIf
	If $iElement < ($iUpper - 1) Then
		For $iCntr = ($iElement + 1) To ($iUpper - 1)
			For $x = 1 To $__LISTVIEWCONSTANT_SORTINFOSIZE - 1
				$avNewArray[$iCntr - 1][$x] = $avArray[$iCntr][$x]
			Next
		Next
	EndIf
	$avArray = $avNewArray
	SetError(0)
	Return 1
EndFunc   ;==>__GUICtrlListView_ArrayDelete

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__LISTVIEWCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlListView_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_CancelEditLabel($hWnd)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LVM_CANCELEDITLABEL)
	Else
		GUICtrlSendMsg($hWnd, $LVM_CANCELEDITLABEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_CancelEditLabel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlListView_ClickItem($hWnd, $iIndex, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_GUICtrlListView_EnsureVisible($hWnd, $iIndex, False)
	Local $tRECT = _GUICtrlListView_GetItemRectEx($hWnd, $iIndex, $LVIR_LABEL)
	Local $tPoint = _WinAPI_PointFromRect($tRECT, True)
	$tPoint = _WinAPI_ClientToScreen($hWnd, $tPoint)
	Local $iX, $iY
	_WinAPI_GetXYFromPoint($tPoint, $iX, $iY)
	Local $iMode = Opt("MouseCoordMode", 1)
	If Not $bMove Then
		Local $aPos = MouseGetPos()
		_WinAPI_ShowCursor(False)
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
		MouseMove($aPos[0], $aPos[1], 0)
		_WinAPI_ShowCursor(True)
	Else
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
	EndIf
	Opt("MouseCoordMode", $iMode)
EndFunc   ;==>_GUICtrlListView_ClickItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_CopyItems($hWnd_Source, $hWnd_Destination, $bDelFlag = False)
	Local $a_Indices, $tItem = DllStructCreate($tagLVITEM), $iIndex
	Local $iCols = _GUICtrlListView_GetColumnCount($hWnd_Source)

	Local $iItems = _GUICtrlListView_GetItemCount($hWnd_Source)
	_GUICtrlListView_BeginUpdate($hWnd_Source)
	_GUICtrlListView_BeginUpdate($hWnd_Destination)
	If BitAND(_GUICtrlListView_GetExtendedListViewStyle($hWnd_Source), $LVS_EX_CHECKBOXES) == $LVS_EX_CHECKBOXES Then
		For $i = 0 To $iItems - 1
			If (_GUICtrlListView_GetItemChecked($hWnd_Source, $i)) Then
				If IsArray($a_Indices) Then
					ReDim $a_Indices[UBound($a_Indices) + 1]
				Else
					Local $a_Indices[2]
				EndIf
				$a_Indices[0] = $a_Indices[0] + 1
				$a_Indices[UBound($a_Indices) - 1] = $i
			EndIf
		Next

		If (IsArray($a_Indices)) Then
			For $i = 1 To $a_Indices[0]
				DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
				DllStructSetData($tItem, "Item", $a_Indices[$i])
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tItem, "StateMask", -1)
				_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
				$iIndex = _GUICtrlListView_AddItem($hWnd_Destination, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], 0), DllStructGetData($tItem, "Image"))
				_GUICtrlListView_SetItemChecked($hWnd_Destination, $iIndex)
				For $x = 1 To $iCols - 1
					DllStructSetData($tItem, "Item", $a_Indices[$i])
					DllStructSetData($tItem, "SubItem", $x)
					_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
					_GUICtrlListView_AddSubItem($hWnd_Destination, $iIndex, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], $x), $x, DllStructGetData($tItem, "Image"))
				Next
				;_GUICtrlListView_SetItemChecked($hWnd_Source, $a_Indices[$i], False)
			Next
			If $bDelFlag Then
				For $i = $a_Indices[0] To 1 Step -1
					_GUICtrlListView_DeleteItem($hWnd_Source, $a_Indices[$i])
				Next
			EndIf
		EndIf
	EndIf
	If (_GUICtrlListView_GetSelectedCount($hWnd_Source)) Then
		$a_Indices = _GUICtrlListView_GetSelectedIndices($hWnd_Source, 1)
		For $i = 1 To $a_Indices[0]
			DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
			DllStructSetData($tItem, "Item", $a_Indices[$i])
			DllStructSetData($tItem, "SubItem", 0)
			DllStructSetData($tItem, "StateMask", -1)
			_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
			$iIndex = _GUICtrlListView_AddItem($hWnd_Destination, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], 0), DllStructGetData($tItem, "Image"))
			For $x = 1 To $iCols - 1
				DllStructSetData($tItem, "Item", $a_Indices[$i])
				DllStructSetData($tItem, "SubItem", $x)
				_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
				_GUICtrlListView_AddSubItem($hWnd_Destination, $iIndex, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], $x), $x, DllStructGetData($tItem, "Image"))
			Next
		Next
		_GUICtrlListView_SetItemSelected($hWnd_Source, -1, False)
		If $bDelFlag Then
			For $i = $a_Indices[0] To 1 Step -1
				_GUICtrlListView_DeleteItem($hWnd_Source, $a_Indices[$i])
			Next
		EndIf
	EndIf
	_GUICtrlListView_EndUpdate($hWnd_Source)
	_GUICtrlListView_EndUpdate($hWnd_Destination)
EndFunc   ;==>_GUICtrlListView_CopyItems

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlListView_Create($hWnd, $sHeaderText, $iX, $iY, $iWidth = 150, $iHeight = 150, $iStyle = 0x0000000D, $iExStyle = 0x00000000, $bCoInit = False)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlListViewCreate 1st parameter
	If Not IsString($sHeaderText) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlListViewCreate

	If $iWidth = -1 Then $iWidth = 150
	If $iHeight = -1 Then $iHeight = 150
	If $iStyle = -1 Then $iStyle = $LVS_DEFAULT
	If $iExStyle = -1 Then $iExStyle = 0x00000000

	Local Const $S_OK = 0x0
	Local Const $S_FALSE = 0x1
	Local Const $RPC_E_CHANGED_MODE = 0x80010106
	Local Const $E_INVALIDARG = 0x80070057
	Local Const $E_OUTOFMEMORY = 0x8007000E
	Local Const $E_UNEXPECTED = 0x8000FFFF
	Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
	;======================================
	Local Const $COINIT_APARTMENTTHREADED = 0x02
	;======================================
	Local $iStr_len = StringLen($sHeaderText)
	If $iStr_len Then $sHeaderText = StringSplit($sHeaderText, $sSeparatorChar)

	$iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $iStyle)

	;=========================================================================================================
	If $bCoInit Then
		Local $aResult = DllCall('ole32.dll', 'long', 'CoInitializeEx', 'ptr', 0, 'dword', $COINIT_APARTMENTTHREADED)
		If @error Then Return SetError(@error, @extended, 0)
		Switch $aResult[0]
			Case $S_OK
			Case $S_FALSE
			Case $RPC_E_CHANGED_MODE
				; "-->or the thread that called CoInitializeEx currently belongs to the neutral threaded apartment.")
			Case $E_INVALIDARG
			Case $E_OUTOFMEMORY
			Case $E_UNEXPECTED
		EndSwitch
	EndIf
	;=========================================================================================================
	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hList = _WinAPI_CreateWindowEx($iExStyle, $__LISTVIEWCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_SendMessage($hList, $__LISTVIEWCONSTANT_WM_SETFONT, _WinAPI_GetStockObject($__LISTVIEWCONSTANT_DEFAULT_GUI_FONT), True)
	If $iStr_len Then
		For $x = 1 To $sHeaderText[0]
			_GUICtrlListView_InsertColumn($hList, $x - 1, $sHeaderText[$x], 75)
		Next
	EndIf
	Return $hList
EndFunc   ;==>_GUICtrlListView_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_CreateDragImage($hWnd, $iIndex)
	Local $aDrag[3]

	Local $tPoint = DllStructCreate($tagPOINT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$aDrag[0] = _SendMessage($hWnd, $LVM_CREATEDRAGIMAGE, $iIndex, $tPoint, 0, "wparam", "struct*", "handle")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			$aDrag[0] = _SendMessage($hWnd, $LVM_CREATEDRAGIMAGE, $iIndex, $pMemory, 0, "wparam", "ptr", "handle")
			_MemRead($tMemMap, $pMemory, $tPoint, $iPoint)
			_MemFree($tMemMap)
		EndIf
	Else
		$aDrag[0] = Ptr(GUICtrlSendMsg($hWnd, $LVM_CREATEDRAGIMAGE, $iIndex, DllStructGetPtr($tPoint)))
	EndIf
	$aDrag[1] = DllStructGetData($tPoint, "X")
	$aDrag[2] = DllStructGetData($tPoint, "Y")
	Return $aDrag
EndFunc   ;==>_GUICtrlListView_CreateDragImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_CreateSolidBitMap($hWnd, $iColor, $iWidth, $iHeight)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _WinAPI_CreateSolidBitmap($hWnd, $iColor, $iWidth, $iHeight)
EndFunc   ;==>_GUICtrlListView_CreateSolidBitMap

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Melba23
; ===============================================================================================================================
Func _GUICtrlListView_DeleteAllItems($hWnd)
	; Check if deletion necessary
	If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
	; Determine ListView type
	Local $vCID = 0
	If IsHWnd($hWnd) Then
		; Check ListView ControlID to detect UDF control
		$vCID = _WinAPI_GetDlgCtrlID($hWnd)
	Else
		$vCID = $hWnd
		; Get ListView handle
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	; If native ListView - could be either type of item
	If $vCID < $_UDF_STARTID Then
		; Try deleting as native items
		Local $iParam = 0
		For $iIndex = _GUICtrlListView_GetItemCount($hWnd) - 1 To 0 Step -1
			$iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
			; Check if LV item
			If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
				GUICtrlDelete($iParam)
			EndIf
		Next
		; Return if no items left
		If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
	EndIf
	; Has to be UDF Listview and/or UDF items
	Return _SendMessage($hWnd, $LVM_DELETEALLITEMS) <> 0
EndFunc   ;==>_GUICtrlListView_DeleteAllItems

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_DeleteColumn($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_DELETECOLUMN, $iCol) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_DELETECOLUMN, $iCol, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_DeleteColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Melba23
; ===============================================================================================================================
Func _GUICtrlListView_DeleteItem($hWnd, $iIndex)
	; Determine ListView type
	Local $vCID = 0
	If IsHWnd($hWnd) Then
		; Check if the ListView has a ControlID
		$vCID = _WinAPI_GetDlgCtrlID($hWnd)
	Else
		$vCID = $hWnd
		; Get ListView handle
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	; If native ListView - could be either type of item
	If $vCID < $_UDF_STARTID Then
		; Try deleting as native item
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
		; Check if LV item
		If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
			If GUICtrlDelete($iParam) Then
				Return True
			EndIf
		EndIf
	EndIf
	; Has to be UDF Listview and/or UDF item
	Return _SendMessage($hWnd, $LVM_DELETEITEM, $iIndex) <> 0
EndFunc   ;==>_GUICtrlListView_DeleteItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Melba23
; ===============================================================================================================================
Func _GUICtrlListView_DeleteItemsSelected($hWnd)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hWnd)
	; Delete all?
	If _GUICtrlListView_GetSelectedCount($hWnd) = $iItemCount Then
		Return _GUICtrlListView_DeleteAllItems($hWnd)
	Else
		Local $aSelected = _GUICtrlListView_GetSelectedIndices($hWnd, True)
		If Not IsArray($aSelected) Then Return SetError($LV_ERR, $LV_ERR, 0)
		; Unselect all items
		_GUICtrlListView_SetItemSelected($hWnd, -1, False)
		; Determine ListView type
		Local $vCID = 0, $iNative_Delete, $iUDF_Delete
		If IsHWnd($hWnd) Then
			; Check if the ListView has a ControlID
			$vCID = _WinAPI_GetDlgCtrlID($hWnd)
		Else
			$vCID = $hWnd
			; Get ListView handle
			$hWnd = GUICtrlGetHandle($hWnd)
		EndIf
		; Loop through items
		For $iIndex = $aSelected[0] To 1 Step -1
			; If native ListView - could be either type of item
			If $vCID < $_UDF_STARTID Then
				; Try deleting as native item
				Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $aSelected[$iIndex])
				; Check if LV item
				If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
					; Delete native item
					$iNative_Delete = GUICtrlDelete($iParam)
					; If deletion successful move to next
					If $iNative_Delete Then ContinueLoop
				EndIf
			EndIf
			; Has to be UDF Listview and/or UDF item
			$iUDF_Delete = _SendMessage($hWnd, $LVM_DELETEITEM, $aSelected[$iIndex])
			; Check for failed deletion
			If $iNative_Delete + $iUDF_Delete = 0 Then
				; $iIndex will be > 0
				ExitLoop
			EndIf
		Next
		; If all deleted return True; else return False
		Return Not $iIndex
	EndIf
EndFunc   ;==>_GUICtrlListView_DeleteItemsSelected

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__LISTVIEWCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
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
EndFunc   ;==>_GUICtrlListView_Destroy

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_Draw
; Description ...: Draws an image list item in the specified device context
; Syntax.........: __GUICtrlListView_Draw ($hWnd, $iIndex, $hDC, $iX, $iY [, $iStyle=0] )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - Zero based index of the image to draw
;                  $hDC         - Handle to the destination device context
;                  $iX          - X coordinate where the image will be drawn
;                  $iY          - Y coordinate where the image will be drawn
;                  $iStyle      - Drawing style and overlay image:
;                  |1 - Draws the image transparently using the mask, regardless of the background color
;                  |2 - Draws the image, blending 25 percent with the system highlight color
;                  |4 - Draws the image, blending 50 percent with the system highlight color
;                  |8 - Draws the mask
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __GUICtrlListView_Draw($hWnd, $iIndex, $hDC, $iX, $iY, $iStyle = 0)
	Local $iFlags = 0

	If BitAND($iStyle, 1) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_TRANSPARENT)
	If BitAND($iStyle, 2) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_BLEND25)
	If BitAND($iStyle, 4) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_BLEND50)
	If BitAND($iStyle, 8) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_MASK)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Draw", "handle", $hWnd, "int", $iIndex, "handle", $hDC, "int", $iX, "int", $iY, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>__GUICtrlListView_Draw

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_DrawDragImage(ByRef $hWnd, ByRef $aDrag)
	Local $hDC = _WinAPI_GetWindowDC($hWnd)
	Local $tPoint = _WinAPI_GetMousePos(True, $hWnd)
	_WinAPI_InvalidateRect($hWnd)
	__GUICtrlListView_Draw($aDrag[0], 0, $hDC, DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y"))
	_WinAPI_ReleaseDC($hWnd, $hDC)
EndFunc   ;==>_GUICtrlListView_DrawDragImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_EditLabel($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $aResult
	If IsHWnd($hWnd) Then
		$aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hWnd)
		If @error Then Return SetError(@error, @extended, 0)
		If $aResult = 0 Then Return 0

		If $bUnicode Then
			Return _SendMessage($hWnd, $LVM_EDITLABELW, $iIndex, 0, 0, "wparam", "lparam", "hwnd")
		Else
			Return _SendMessage($hWnd, $LVM_EDITLABEL, $iIndex, 0, 0, "wparam", "lparam", "hwnd")
		EndIf
	Else
		$aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", GUICtrlGetHandle($hWnd))
		If @error Then Return SetError(@error, @extended, 0)
		If $aResult = 0 Then Return 0

		If $bUnicode Then
			Return HWnd(GUICtrlSendMsg($hWnd, $LVM_EDITLABELW, $iIndex, 0))
		Else
			Return HWnd(GUICtrlSendMsg($hWnd, $LVM_EDITLABEL, $iIndex, 0))
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListView_EditLabel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_EnableGroupView($hWnd, $bEnable = True)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ENABLEGROUPVIEW, $bEnable)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ENABLEGROUPVIEW, $bEnable, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_EnableGroupView

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__LISTVIEWCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlListView_EndUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_EnsureVisible($hWnd, $iIndex, $bPartialOK = False)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ENSUREVISIBLE, $iIndex, $bPartialOK)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ENSUREVISIBLE, $iIndex, $bPartialOK)
	EndIf
EndFunc   ;==>_GUICtrlListView_EnsureVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (added reverse search)
; ===============================================================================================================================
Func _GUICtrlListView_FindInText($hWnd, $sText, $iStart = -1, $bWrapOK = True, $bReverse = False)
	Local $iCount = _GUICtrlListView_GetItemCount($hWnd)
	Local $iColumns = _GUICtrlListView_GetColumnCount($hWnd)
	If $iColumns = 0 Then $iColumns = 1

	If $bReverse And $iStart = -1 Then Return -1

	Local $sList
	If $bReverse Then
		For $iI = $iStart - 1 To 0 Step -1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	Else
		For $iI = $iStart + 1 To $iCount - 1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	EndIf

	If (($iStart = -1) Or Not $bWrapOK) And Not $bReverse Then Return -1

	If $bReverse And $bWrapOK Then
		For $iI = $iCount - 1 To $iStart + 1 Step -1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	Else
		For $iI = 0 To $iStart - 1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	EndIf

	Return -1
EndFunc   ;==>_GUICtrlListView_FindInText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_FindItem($hWnd, $iStart, ByRef $tFindInfo, $sText = "")
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Text", $sText)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tFindInfo, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_FINDITEM, $iStart, $tFindInfo, 0, "wparam", "struct*")
		Else
			Local $iFindInfo = DllStructGetSize($tFindInfo)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iFindInfo + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iFindInfo
			DllStructSetData($tFindInfo, "Text", $pText)
			_MemWrite($tMemMap, $tFindInfo, $pMemory, $iFindInfo)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			$iRet = _SendMessage($hWnd, $LVM_FINDITEM, $iStart, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tFindInfo, "Text", $pBuffer)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_FINDITEM, $iStart, DllStructGetPtr($tFindInfo))
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_FindItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_FindNearest($hWnd, $iX, $iY, $iDir = 0, $iStart = -1, $bWrapOK = True)
	Local $aDir[8] = [$__LISTVIEWCONSTANT_VK_LEFT, $__LISTVIEWCONSTANT_VK_RIGHT, $__LISTVIEWCONSTANT_VK_UP, $__LISTVIEWCONSTANT_VK_DOWN, $__LISTVIEWCONSTANT_VK_HOME, $__LISTVIEWCONSTANT_VK_END, $__LISTVIEWCONSTANT_VK_PRIOR, $__LISTVIEWCONSTANT_VK_NEXT]

	Local $tFindInfo = DllStructCreate($tagLVFINDINFO)
	Local $iFlags = $LVFI_NEARESTXY
	If $bWrapOK Then $iFlags = BitOR($iFlags, $LVFI_WRAP)
	DllStructSetData($tFindInfo, "Flags", $iFlags)
	DllStructSetData($tFindInfo, "X", $iX)
	DllStructSetData($tFindInfo, "Y", $iY)
	DllStructSetData($tFindInfo, "Direction", $aDir[$iDir])
	Return _GUICtrlListView_FindItem($hWnd, $iStart, $tFindInfo)
EndFunc   ;==>_GUICtrlListView_FindNearest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_FindParam($hWnd, $iParam, $iStart = -1)
	Local $tFindInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tFindInfo, "Flags", $LVFI_PARAM)
	DllStructSetData($tFindInfo, "Param", $iParam)
	Return _GUICtrlListView_FindItem($hWnd, $iStart, $tFindInfo)
EndFunc   ;==>_GUICtrlListView_FindParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_FindText($hWnd, $sText, $iStart = -1, $bPartialOK = True, $bWrapOK = True)
	Local $tFindInfo = DllStructCreate($tagLVFINDINFO)
	Local $iFlags = $LVFI_STRING
	If $bPartialOK Then $iFlags = BitOR($iFlags, $LVFI_PARTIAL)
	If $bWrapOK Then $iFlags = BitOR($iFlags, $LVFI_WRAP)
	DllStructSetData($tFindInfo, "Flags", $iFlags)
	Return _GUICtrlListView_FindItem($hWnd, $iStart, $tFindInfo, $sText)
EndFunc   ;==>_GUICtrlListView_FindText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetBkColor($hWnd)
	Local $i_Color
	If IsHWnd($hWnd) Then
		$i_Color = _SendMessage($hWnd, $LVM_GETBKCOLOR)
	Else
		$i_Color = GUICtrlSendMsg($hWnd, $LVM_GETBKCOLOR, 0, 0)
	EndIf
	Return __GUICtrlListView_ReverseColorOrder($i_Color)
EndFunc   ;==>_GUICtrlListView_GetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetBkImage($hWnd)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tImage = DllStructCreate($tagLVBKIMAGE)
	DllStructSetData($tImage, "ImageMax", 4096)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tImage, "Image", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_GETBKIMAGEW, 0, $tImage, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $iImage = DllStructGetSize($tImage)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iImage + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iImage
			DllStructSetData($tImage, "Image", $pText)
			_MemWrite($tMemMap, $tImage, $pMemory, $iImage)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETBKIMAGEW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETBKIMAGEA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tImage, $iImage)
			_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pImage = DllStructGetPtr($tImage)
		DllStructSetData($tImage, "Image", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETBKIMAGEW, 0, $pImage)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETBKIMAGEA, 0, $pImage)
		EndIf
	EndIf
	Local $aImage[4]
	Switch BitAND(DllStructGetData($tImage, "Flags"), $LVBKIF_SOURCE_MASK)
		Case $LVBKIF_SOURCE_HBITMAP
			$aImage[0] = 1
		Case $LVBKIF_SOURCE_URL
			$aImage[0] = 2
	EndSwitch
	$aImage[1] = DllStructGetData($tBuffer, "Text")
	$aImage[2] = DllStructGetData($tImage, "XOffPercent")
	$aImage[3] = DllStructGetData($tImage, "YOffPercent")
	Return SetError($iRet <> 0, 0, $aImage)
EndFunc   ;==>_GUICtrlListView_GetBkImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetCallbackMask($hWnd)
	Local $iFlags = 0
	Local $iMask = _SendMessage($hWnd, $LVM_GETCALLBACKMASK)
	If BitAND($iMask, $LVIS_CUT) <> 0 Then $iFlags = BitOR($iFlags, 1)
	If BitAND($iMask, $LVIS_DROPHILITED) <> 0 Then $iFlags = BitOR($iFlags, 2)
	If BitAND($iMask, $LVIS_FOCUSED) <> 0 Then $iFlags = BitOR($iFlags, 4)
	If BitAND($iMask, $LVIS_SELECTED) <> 0 Then $iFlags = BitOR($iFlags, 8)
	If BitAND($iMask, $LVIS_OVERLAYMASK) <> 0 Then $iFlags = BitOR($iFlags, 16)
	If BitAND($iMask, $LVIS_STATEIMAGEMASK) <> 0 Then $iFlags = BitOR($iFlags, 32)
	Return $iFlags
EndFunc   ;==>_GUICtrlListView_GetCallbackMask

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetColumn($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	DllStructSetData($tColumn, "Mask", $LVCF_ALLDATA)
	DllStructSetData($tColumn, "TextMax", 4096)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tColumn, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_GETCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iColumn
			DllStructSetData($tColumn, "Text", $pText)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tColumn, $iColumn)
			_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		DllStructSetData($tColumn, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Local $aColumn[9]
	Switch BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_JUSTIFYMASK)
		Case $LVCFMT_RIGHT
			$aColumn[0] = 1
		Case $LVCFMT_CENTER
			$aColumn[0] = 2
		Case Else
			$aColumn[0] = 0
	EndSwitch
	$aColumn[1] = BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_IMAGE) <> 0
	$aColumn[2] = BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_BITMAP_ON_RIGHT) <> 0
	$aColumn[3] = BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_COL_HAS_IMAGES) <> 0
	$aColumn[4] = DllStructGetData($tColumn, "CX")
	$aColumn[5] = DllStructGetData($tBuffer, "Text")
	$aColumn[6] = DllStructGetData($tColumn, "SubItem")
	$aColumn[7] = DllStructGetData($tColumn, "Image")
	$aColumn[8] = DllStructGetData($tColumn, "Order")
	Return SetError($iRet = 0, 0, $aColumn)
EndFunc   ;==>_GUICtrlListView_GetColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetColumnCount($hWnd)
	;Local Const $HDM_GETITEMCOUNT = 0x1200
	Return _SendMessage(_GUICtrlListView_GetHeader($hWnd), 0x1200)
EndFunc   ;==>_GUICtrlListView_GetColumnCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetColumnOrder($hWnd)
	Local $a_Cols = _GUICtrlListView_GetColumnOrderArray($hWnd), $s_Cols = ""
	Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
	For $i = 1 To $a_Cols[0]
		$s_Cols &= $a_Cols[$i] & $sSeparatorChar
	Next
	$s_Cols = StringTrimRight($s_Cols, 1)
	Return $s_Cols
EndFunc   ;==>_GUICtrlListView_GetColumnOrder

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetColumnOrderArray($hWnd)
	Local $iColumns = _GUICtrlListView_GetColumnCount($hWnd)
	Local $tBuffer = DllStructCreate("int[" & $iColumns & "]")
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETCOLUMNORDERARRAY, $iColumns, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_SendMessage($hWnd, $LVM_GETCOLUMNORDERARRAY, $iColumns, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNORDERARRAY, $iColumns, DllStructGetPtr($tBuffer))
	EndIf

	Local $aBuffer[$iColumns + 1]
	$aBuffer[0] = $iColumns
	For $iI = 1 To $iColumns
		$aBuffer[$iI] = DllStructGetData($tBuffer, 1, $iI)
	Next
	Return $aBuffer
EndFunc   ;==>_GUICtrlListView_GetColumnOrderArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetColumnWidth($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETCOLUMNWIDTH, $iCol)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNWIDTH, $iCol, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetColumnWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetCounterPage($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETCOUNTPERPAGE)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETCOUNTPERPAGE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetCounterPage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetEditControl($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $LVM_GETEDITCONTROL))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETEDITCONTROL, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetEditControl

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_GetEmptyText
; Description ...: Gets the text meant for display when the list-view control appears empty
; Syntax.........: _GUICtrlListView_GetEmptyText ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - Text meant for display when the list-view control appears emtpy
;                  Failure      - ""
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: Minimum OS: Windows Vista
; Related .......:
; Link ..........: @@MsdnLink@@ LVM_GETEMPTYTEXT
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlListView_GetEmptyText($hWnd)
	Local $tText = DllStructCreate("char[4096]")
	Local $iRet

	If IsHWnd($hWnd) Then
		Local $iText = DllStructGetSize($tText)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iText + 4096, $tMemMap)
		Local $pText = $pMemory + $iText
		DllStructSetData($tText, "Text", $pText)
		_MemWrite($tMemMap, $pText, $pMemory, $iText)
		$iRet = _SendMessage($hWnd, $LVM_GETEMPTYTEXT, 4096, $pMemory)
		_MemRead($tMemMap, $pText, $tText, 4096)
		_MemFree($tMemMap)
		If $iRet = 0 Then Return SetError(-1, 0, "")
		Return DllStructGetData($tText, 1)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETEMPTYTEXT, 4096, DllStructGetPtr($tText))
		If $iRet = 0 Then Return SetError(-1, 0, "")
		Return DllStructGetData($tText, 1)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetEmptyText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetExtendedListViewStyle($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETEXTENDEDLISTVIEWSTYLE)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetExtendedListViewStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetFocusedGroup($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETFOCUSEDGROUP)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETFOCUSEDGROUP, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetFocusedGroup

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetGroupCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETGROUPCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETGROUPCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetGroupCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost), guinness - Replaced retrieving the header and alignment code with __GUICtrlListView_GetGroupInfoEx.
; ===============================================================================================================================
Func _GUICtrlListView_GetGroupInfo($hWnd, $iGroupID)
	Local $tGroup = __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, BitOR($LVGF_HEADER, $LVGF_ALIGN))
	Local $iErr = @error
	Local $aGroup[2]
	$aGroup[0] = _WinAPI_WideCharToMultiByte(DllStructGetData($tGroup, "Header"))
	Select
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_CENTER) <> 0
			$aGroup[1] = 1
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_RIGHT) <> 0
			$aGroup[1] = 2
		Case Else
			$aGroup[1] = 0
	EndSelect
	Return SetError($iErr, 0, $aGroup)
EndFunc   ;==>_GUICtrlListView_GetGroupInfo

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __GUICtrlListView_GetGroupInfoEx
; Description ...: Retrieves group information
; Syntax ........: __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, $iMask)
; Parameters ....: $hWnd        - Handle to the control
;                  $iGroupID    - ID that specifies the group whose information is retrieved
;                  $iMask       - Can be a combination of the following:
;                  |$LVGF_NONENo other items are valid.
;                  |$LVGF_HEADER
;                  |$LVGF_FOOTER
;                  |$LVGF_STATE
;                  |$LVGF_ALIGN
;                  |$LVGF_GROUPID
;                  |$LVGF_SUBTITLE
;                  |$LVGF_TASK
;                  |$LVGF_DESCRIPTIONTOP
;                  |$LVGF_DESCRIPTIONBOTTOM
;                  |$LVGF_TITLEIMAGE
;                  |$LVGF_EXTENDEDIMAGE
;                  |$LVGF_ITEMS
;                  |$LVGF_SUBSET
;                  |$LVGF_SUBSETITEMS
; Return values .: Success      - $tagLVGROUP structure
; Author ........: Paul Campbell (PaulIA)
; Modified.......: guinness
; Remarks .......: This function is used internally and should not normally be called
; Related .......: $tagLVGROUP
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, $iMask)
	Local $tGroup = DllStructCreate($tagLVGROUP)
	Local $iGroup = DllStructGetSize($tGroup)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", $iMask)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFO, $iGroupID, $tGroup, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup, $tMemMap)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFO, $iGroupID, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tGroup, $iGroup)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETGROUPINFO, $iGroupID, DllStructGetPtr($tGroup))
	EndIf
	Return SetError($iRet <> $iGroupID, 0, $tGroup)
EndFunc   ;==>__GUICtrlListView_GetGroupInfoEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Matt Diesel (Mat) #2726 - Added group id to returned array.
; ===============================================================================================================================
Func _GUICtrlListView_GetGroupInfoByIndex($hWnd, $iIndex)
	Local $tGroup = DllStructCreate($tagLVGROUP)
	Local $iGroup = DllStructGetSize($tGroup)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", BitOR($LVGF_HEADER, $LVGF_ALIGN, $LVGF_GROUPID))
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFOBYINDEX, $iIndex, $tGroup, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup, $tMemMap)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFOBYINDEX, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tGroup, $iGroup)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETGROUPINFOBYINDEX, $iIndex, DllStructGetPtr($tGroup))
	EndIf
	Local $aGroup[3]
	$aGroup[0] = _WinAPI_WideCharToMultiByte(DllStructGetData($tGroup, "Header"))
	Select
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_CENTER) <> 0
			$aGroup[1] = 1
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_RIGHT) <> 0
			$aGroup[1] = 2
		Case Else
			$aGroup[1] = 0
	EndSelect
	$aGroup[2] = DllStructGetData($tGroup, "GroupID")
	Return SetError($iRet = 0, 0, $aGroup)
EndFunc   ;==>_GUICtrlListView_GetGroupInfoByIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetGroupRect($hWnd, $iGroupID, $iGet = $LVGGR_GROUP)
	Local $tGroup = DllStructCreate($tagRECT)
	DllStructSetData($tGroup, "Top", $iGet)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPRECT, $iGroupID, $tGroup, 0, "wparam", "struct*")
		Else
			Local $iGroup = DllStructGetSize($tGroup)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup, $tMemMap)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPRECT, $iGroupID, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tGroup, $iGroup)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETGROUPRECT, $iGroupID, DllStructGetPtr($tGroup))
	EndIf
	Local $aGroup[4]
	For $x = 0 To 3
		$aGroup[$x] = DllStructGetData($tGroup, $x + 1)
	Next
	Return SetError($iRet = 0, 0, $aGroup)
EndFunc   ;==>_GUICtrlListView_GetGroupRect

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_GetGroupState
; Description ...: Gets the state for a specified group
; Syntax.........: _GUICtrlListView_GetGroupState ( $hWnd, $iGroupID, $iMask )
; Parameters ....: $hWnd        - Handle to the control
;                  $iGroupID    - ID that specifies the group whose information is retrieved
;                  $iMask       - Can be a combination of the following:
;                  |  $LVGS_NORMAL            - Groups are expanded, the group name is displayed, and all items in the group are displayed.
;                  |  $LVGS_COLLAPSED         - The group is collapsed.
;                  |  $LVGS_HIDDEN            - The group is hidden.
;                  |  $LVGS_NOHEADER          - The group does not display a header
;                  |  $LVGS_COLLAPSIBLE       - The group can be collapsed
;                  |  $LVGS_FOCUSED           - The group has keyboard focus
;                  |  $LVGS_SELECTED          - The group is selected
;                  |  $LVGS_SUBSETED          - The group displays only a portion of its items
;                  |  $LVGS_SUBSETLINKFOCUSED - The subset link of the group has keyboard focus
; Return values .: Success      - Returns the combination of state values that are set
;                  Failure      - 0
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: Minimum operating systems: Windows Vista
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlListView_GetGroupState($hWnd, $iGroupID, $iMask)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETGROUPSTATE, $iGroupID, $iMask)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETGROUPSTATE, $iGroupID, $iMask)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetGroupState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetGroupViewEnabled($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ISGROUPVIEWENABLED) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ISGROUPVIEWENABLED, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_GetGroupViewEnabled

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetHeader($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $LVM_GETHEADER))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETHEADER, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHeader

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetHotCursor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETHOTCURSOR, 0, 0, 0, "wparam", "lparam", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_GETHOTCURSOR, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHotCursor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetHotItem($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETHOTITEM)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETHOTITEM, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHotItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetHoverTime($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETHOVERTIME)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETHOVERTIME, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHoverTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetImageList($hWnd, $iImageList)
	Local $aImageList[3] = [$LVSIL_NORMAL, $LVSIL_SMALL, $LVSIL_STATE]
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETIMAGELIST, $aImageList[$iImageList], 0, 0, "wparam", "lparam", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_GETIMAGELIST, $aImageList[$iImageList], 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetImageList

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_GetInsertMark
; Description ...: Retrieves the position of the insertion point
; Syntax.........: _GUICtrlListView_GetInsertMark ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - Array with the following format:
;                  |[0] - True if the insertion point appears after the item, otherwise False
;                  |[1] - Item next to which the insertion point appears.  If this is -1, there is no insertion point.
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; +
;                  An insertion point can appear only if the control is in icon view, small icon view, or tile view,
;                  and is not in group view mode.
; Related .......: _GUICtrlListView_SetInsertMark
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_GetInsertMark($hWnd)
	Local $tMark = DllStructCreate($tagLVINSERTMARK)
	Local $iMark = DllStructGetSize($tMark)
	DllStructSetData($tMark, "Size", $iMark)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETINSERTMARK, 0, $tMark, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iMark, $tMemMap)
			_MemWrite($tMemMap, $tMark)
			$iRet = _SendMessage($hWnd, $LVM_GETINSERTMARK, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tMark, $iMark)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETINSERTMARK, 0, DllStructGetPtr($tMark))
	EndIf
	Local $aMark[2]
	$aMark[0] = DllStructGetData($tMark, "Flags") = $LVIM_AFTER
	$aMark[1] = DllStructGetData($tMark, "Item")
	Return SetError($iRet = 0, 0, $aMark)
EndFunc   ;==>_GUICtrlListView_GetInsertMark

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_GetInsertMarkColor
; Description ...: Retrieves the color of the insertion point
; Syntax.........: _GUICtrlListView_GetInsertMarkColor ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - Color of the insertion point
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; Related .......: _GUICtrlListView_SetInsertMarkColor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_GetInsertMarkColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETINSERTMARKCOLOR, $LVSIL_STATE)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETINSERTMARKCOLOR, $LVSIL_STATE, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetInsertMarkColor

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_GetInsertMarkRect
; Description ...: Retrieves the rectangle that bounds the insertion point
; Syntax.........: _GUICtrlListView_GetInsertMarkRect ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - Array with the following format:
;                  |[0] = True if insertion point found, otherwise False
;                  |[1] = X coordinate of the upper left corner of the rectangle
;                  |[2] = Y coordinate of the upper left corner of the rectangle
;                  |[3] = X coordinate of the lower right corner of the rectangle
;                  |[4] = Y coordinate of the lower right corner of the rectangle
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_GetInsertMarkRect($hWnd)
	Local $aRect[5]

	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$aRect[0] = _SendMessage($hWnd, $LVM_GETINSERTMARKRECT, 0, $tRECT, 0, "wparam", "struct*") <> 0
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			$aRect[0] = _SendMessage($hWnd, $LVM_GETINSERTMARKRECT, 0, $pMemory, 0, "wparam", "ptr") <> 0
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		$aRect[0] = GUICtrlSendMsg($hWnd, $LVM_GETINSERTMARKRECT, 0, DllStructGetPtr($tRECT)) <> 0
	EndIf
	$aRect[1] = DllStructGetData($tRECT, "Left")
	$aRect[2] = DllStructGetData($tRECT, "Top")
	$aRect[3] = DllStructGetData($tRECT, "Right")
	$aRect[4] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetInsertMarkRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetISearchString($hWnd)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iBuffer
	If IsHWnd($hWnd) Then
		If $bUnicode Then
			$iBuffer = _SendMessage($hWnd, $LVM_GETISEARCHSTRINGW) + 1
		Else
			$iBuffer = _SendMessage($hWnd, $LVM_GETISEARCHSTRINGA) + 1
		EndIf
	Else
		If $bUnicode Then
			$iBuffer = GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGW, 0, 0) + 1
		Else
			$iBuffer = GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGA, 0, 0) + 1
		EndIf
	EndIf
	If $iBuffer = 1 Then Return ""
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETISEARCHSTRINGW, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			If $bUnicode Then
				_SendMessage($hWnd, $LVM_GETISEARCHSTRINGW, 0, $pMemory)
			Else
				_SendMessage($hWnd, $LVM_GETISEARCHSTRINGA, 0, $pMemory)
			EndIf
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pBuffer = DllStructGetPtr($tBuffer)
		If $bUnicode Then
			GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGW, 0, $pBuffer)
		Else
			GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGA, 0, $pBuffer)
		EndIf
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlListView_GetISearchString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItem($hWnd, $iIndex, $iSubItem = 0)
	Local $aItem[8]

	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "StateMask", -1)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Local $iState = DllStructGetData($tItem, "State")
	If BitAND($iState, $LVIS_CUT) <> 0 Then $aItem[0] = BitOR($aItem[0], 1)
	If BitAND($iState, $LVIS_DROPHILITED) <> 0 Then $aItem[0] = BitOR($aItem[0], 2)
	If BitAND($iState, $LVIS_FOCUSED) <> 0 Then $aItem[0] = BitOR($aItem[0], 4)
	If BitAND($iState, $LVIS_SELECTED) <> 0 Then $aItem[0] = BitOR($aItem[0], 8)
	$aItem[1] = __GUICtrlListView_OverlayImageMaskToIndex($iState)
	$aItem[2] = __GUICtrlListView_StateImageMaskToIndex($iState)
	$aItem[3] = _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem)
	$aItem[4] = DllStructGetData($tItem, "Image")
	$aItem[5] = DllStructGetData($tItem, "Param")
	$aItem[6] = DllStructGetData($tItem, "Indent")
	$aItem[7] = DllStructGetData($tItem, "GroupID")
	Return $aItem
EndFunc   ;==>_GUICtrlListView_GetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Siao for external control
; ===============================================================================================================================
Func _GUICtrlListView_GetItemChecked($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tLVITEM = DllStructCreate($tagLVITEM)
	Local $iSize = DllStructGetSize($tLVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, False)
	DllStructSetData($tLVITEM, "Mask", $LVIF_STATE)
	DllStructSetData($tLVITEM, "Item", $iIndex)
	DllStructSetData($tLVITEM, "StateMask", 0xffff)

	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $tLVITEM, 0, "wparam", "struct*") <> 0
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
			_MemWrite($tMemMap, $tLVITEM)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr") <> 0
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr") <> 0
			EndIf
			_MemRead($tMemMap, $pMemory, $tLVITEM, $iSize)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tLVITEM)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMW, 0, $pItem) <> 0
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMA, 0, $pItem) <> 0
		EndIf
	EndIf

	If Not $iRet Then Return SetError($LV_ERR, $LV_ERR, False)
	Return BitAND(DllStructGetData($tLVITEM, "State"), 0x2000) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETITEMCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETITEMCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemCut($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_CUT) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemCut

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemDropHilited($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_DROPHILITED) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemDropHilited

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemEx($hWnd, ByRef $tItem)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
			_MemWrite($tMemMap, $tItem)
			If $bUnicode Then
				_SendMessage($hWnd, $LVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				_SendMessage($hWnd, $LVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tItem, $iItem)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_GetItemEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemFocused($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_FOCUSED) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemFocused

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemGroupID($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_GROUPID)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "GroupID")
EndFunc   ;==>_GUICtrlListView_GetItemGroupID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemImage($hWnd, $iIndex, $iSubItem = 0)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_IMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Image")
EndFunc   ;==>_GUICtrlListView_GetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemIndent($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_INDENT)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Indent")
EndFunc   ;==>_GUICtrlListView_GetItemIndent

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_GetItemOverlayImage
; Description ...: Gets the overlay image that is superimposed over the item's icon image
; Syntax.........: __GUICtrlListView_GetItemOverlayImage ( $hWnd, $iIndex )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - Zero based index of the item
; Return values .: Success      - Zero based image index
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally and should not normally be called
; Related .......: __GUICtrlListView_SetItemOverlayImage
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_GetItemOverlayImage($hWnd, $iIndex)
	Return BitShift(_GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_OVERLAYMASK), 8)
EndFunc   ;==>__GUICtrlListView_GetItemOverlayImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemParam($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_PARAM)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Param")
EndFunc   ;==>_GUICtrlListView_GetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemPosition($hWnd, $iIndex)
	Local $aPoint[2], $iRet

	Local $tPoint = DllStructCreate($tagPOINT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			If Not _SendMessage($hWnd, $LVM_GETITEMPOSITION, $iIndex, $tPoint, 0, "wparam", "struct*") Then Return $aPoint
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			If Not _SendMessage($hWnd, $LVM_GETITEMPOSITION, $iIndex, $pMemory, 0, "wparam", "ptr") Then Return $aPoint
			_MemRead($tMemMap, $pMemory, $tPoint, $iPoint)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMPOSITION, $iIndex, DllStructGetPtr($tPoint))
		If Not $iRet Then Return $aPoint
	EndIf
	$aPoint[0] = DllStructGetData($tPoint, "X")
	$aPoint[1] = DllStructGetData($tPoint, "Y")
	Return $aPoint
EndFunc   ;==>_GUICtrlListView_GetItemPosition

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemPositionX($hWnd, $iIndex)
	Local $aPoint = _GUICtrlListView_GetItemPosition($hWnd, $iIndex)
	Return $aPoint[0]
EndFunc   ;==>_GUICtrlListView_GetItemPositionX

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemPositionY($hWnd, $iIndex)
	Local $aPoint = _GUICtrlListView_GetItemPosition($hWnd, $iIndex)
	Return $aPoint[1]
EndFunc   ;==>_GUICtrlListView_GetItemPositionY

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemRect($hWnd, $iIndex, $iPart = 3)
	Local $tRECT = _GUICtrlListView_GetItemRectEx($hWnd, $iIndex, $iPart)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetItemRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemRectEx($hWnd, $iIndex, $iPart = 3)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $iPart)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT, $pMemory, $iRect)
			_SendMessage($hWnd, $LVM_GETITEMRECT, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETITEMRECT, $iIndex, DllStructGetPtr($tRECT))
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlListView_GetItemRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemSelected($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_SELECTED) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemSelected

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemSpacing($hWnd, $bSmall = False)
	Local $iSpace
	If IsHWnd($hWnd) Then
		$iSpace = _SendMessage($hWnd, $LVM_GETITEMSPACING, $bSmall)
	Else
		$iSpace = GUICtrlSendMsg($hWnd, $LVM_GETITEMSPACING, $bSmall, 0)
	EndIf
	Local $aSpace[2]
	$aSpace[0] = BitAND($iSpace, 0xFFFF)
	$aSpace[1] = BitShift($iSpace, 16)
	Return $aSpace
EndFunc   ;==>_GUICtrlListView_GetItemSpacing

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemSpacingX($hWnd, $bSmall = False)
	If IsHWnd($hWnd) Then
		Return BitAND(_SendMessage($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 0xFFFF)
	Else
		Return BitAND(GUICtrlSendMsg($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 0xFFFF)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemSpacingX

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemSpacingY($hWnd, $bSmall = False)
	If IsHWnd($hWnd) Then
		Return BitShift(_SendMessage($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 16)
	Else
		Return BitShift(GUICtrlSendMsg($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 16)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemSpacingY

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemState($hWnd, $iIndex, $iMask)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETITEMSTATE, $iIndex, $iMask)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETITEMSTATE, $iIndex, $iMask)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemStateImage($hWnd, $iIndex)
	Return BitShift(_GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_STATEIMAGEMASK), 12)
EndFunc   ;==>_GUICtrlListView_GetItemStateImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "TextMax", 4096)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			_SendMessage($hWnd, $LVM_GETITEMTEXTW, $iIndex, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + 4096, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			If $bUnicode Then
				_SendMessage($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				_SendMessage($hWnd, $LVM_GETITEMTEXTA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pText, $tBuffer, 4096)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			GUICtrlSendMsg($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pItem)
		Else
			GUICtrlSendMsg($hWnd, $LVM_GETITEMTEXTA, $iIndex, $pItem)
		EndIf
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlListView_GetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemTextArray($hWnd, $iItem = -1)
	Local $sItems = _GUICtrlListView_GetItemTextString($hWnd, $iItem)
	If $sItems = "" Then
		Local $aItems[1] = [0]
		Return SetError($LV_ERR, $LV_ERR, $aItems)
	EndIf
	Return StringSplit($sItems, Opt('GUIDataSeparatorChar'))
EndFunc   ;==>_GUICtrlListView_GetItemTextArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetItemTextString($hWnd, $iItem = -1)
	Local $sRow = "", $sSeparatorChar = Opt('GUIDataSeparatorChar'), $iSelected
	If $iItem = -1 Then
		$iSelected = _GUICtrlListView_GetNextItem($hWnd) ; get current row selected
	Else
		$iSelected = $iItem ; get row
	EndIf
	For $x = 0 To _GUICtrlListView_GetColumnCount($hWnd) - 1
		$sRow &= _GUICtrlListView_GetItemText($hWnd, $iSelected, $x) & $sSeparatorChar
	Next
	Return StringTrimRight($sRow, 1)
EndFunc   ;==>_GUICtrlListView_GetItemTextString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetNextItem($hWnd, $iStart = -1, $iSearch = 0, $iState = 8)
	Local $aSearch[5] = [$LVNI_ALL, $LVNI_ABOVE, $LVNI_BELOW, $LVNI_TOLEFT, $LVNI_TORIGHT]

	Local $iFlags = $aSearch[$iSearch]
	If BitAND($iState, 1) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_CUT)
	If BitAND($iState, 2) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_DROPHILITED)
	If BitAND($iState, 4) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_FOCUSED)
	If BitAND($iState, 8) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_SELECTED)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETNEXTITEM, $iStart, $iFlags)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETNEXTITEM, $iStart, $iFlags)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetNextItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetNumberOfWorkAreas($hWnd)
	Local $tBuffer = DllStructCreate("int Data")
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETNUMBEROFWORKAREAS, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_SendMessage($hWnd, $LVM_GETNUMBEROFWORKAREAS, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETNUMBEROFWORKAREAS, 0, DllStructGetPtr($tBuffer))
	EndIf

	Return DllStructGetData($tBuffer, "Data")
EndFunc   ;==>_GUICtrlListView_GetNumberOfWorkAreas

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetOrigin($hWnd)
	Local $tPoint = DllStructCreate($tagPOINT)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETORIGIN, 0, $tPoint, 0, "wparam", "struct*")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			$iRet = _SendMessage($hWnd, $LVM_GETORIGIN, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tPoint, $iPoint)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETORIGIN, 0, DllStructGetPtr($tPoint))
	EndIf
	Local $aOrigin[2]
	$aOrigin[0] = DllStructGetData($tPoint, "X")
	$aOrigin[1] = DllStructGetData($tPoint, "Y")
	Return SetError(@error, $iRet = 1, $aOrigin)
EndFunc   ;==>_GUICtrlListView_GetOrigin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetOriginX($hWnd)
	Local $aOrigin = _GUICtrlListView_GetOrigin($hWnd)
	Return $aOrigin[0]
EndFunc   ;==>_GUICtrlListView_GetOriginX

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetOriginY($hWnd)
	Local $aOrigin = _GUICtrlListView_GetOrigin($hWnd)
	Return $aOrigin[1]
EndFunc   ;==>_GUICtrlListView_GetOriginY

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetOutlineColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETOUTLINECOLOR)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETOUTLINECOLOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetOutlineColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetSelectedColumn($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETSELECTEDCOLUMN)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETSELECTEDCOLUMN, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectedColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetSelectedCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETSELECTEDCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETSELECTEDCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectedCount

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_GetCheckedIndices
; Description ...: Retrieve indices of checked item(s)
; Syntax.........: __GUICtrlListView_GetCheckedIndices ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .: Success      - Checked indices Based on $bArray:
;                  +Array       - With the following format
;                  |[0] - Number of Items in array (n)
;                  |[1] - First item index
;                  |[2] - Second item index
;                  |[n] - Last item index
;                  Failure      - Based on $bArray
;                  |Array       - With the following format
;                  |[0] - Number of Items in array (0)
; Author ........: jpm
; Modified.......: Melba23 (based on code by benners)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __GUICtrlListView_GetCheckedIndices($hWnd)
	Local $iCount = _GUICtrlListView_GetItemCount($hWnd)
	; Create max size array
	Local $aSelected[$iCount + 1] = [0]
	For $i = 0 To $iCount - 1
		If _GUICtrlListView_GetItemChecked($hWnd, $i) Then
			$aSelected[0] += 1
			$aSelected[$aSelected[0]] = $i
		EndIf
	Next
	; Remove unfilled elements
	ReDim $aSelected[$aSelected[0] + 1]
	Return $aSelected
EndFunc   ;==>__GUICtrlListView_GetCheckedIndices

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetSelectedIndices($hWnd, $bArray = False)
	Local $sIndices, $aIndices[1] = [0]
	Local $iRet, $iCount = _GUICtrlListView_GetItemCount($hWnd)
	For $iItem = 0 To $iCount
		If IsHWnd($hWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMSTATE, $iItem, $LVIS_SELECTED)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMSTATE, $iItem, $LVIS_SELECTED)
		EndIf
		If $iRet Then
			If (Not $bArray) Then
				If StringLen($sIndices) Then
					$sIndices &= "|" & $iItem
				Else
					$sIndices = $iItem
				EndIf
			Else
				ReDim $aIndices[UBound($aIndices) + 1]
				$aIndices[0] = UBound($aIndices) - 1
				$aIndices[UBound($aIndices) - 1] = $iItem
			EndIf
		EndIf
	Next
	If (Not $bArray) Then
		Return String($sIndices)
	Else
		Return $aIndices
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectedIndices

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetSelectionMark($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETSELECTIONMARK)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETSELECTIONMARK, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectionMark

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetStringWidth($hWnd, $sString)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sString) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sString)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETSTRINGWIDTHW, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer, $pMemory, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETSTRINGWIDTHW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETSTRINGWIDTHA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pBuffer = DllStructGetPtr($tBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETSTRINGWIDTHW, 0, $pBuffer)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETSTRINGWIDTHA, 0, $pBuffer)
		EndIf
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_GetStringWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetSubItemRect($hWnd, $iIndex, $iSubItem, $iPart = 0)
	Local $aPart[2] = [$LVIR_BOUNDS, $LVIR_ICON]

	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Top", $iSubItem)
	DllStructSetData($tRECT, "Left", $aPart[$iPart])
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETSUBITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT, $pMemory, $iRect)
			_SendMessage($hWnd, $LVM_GETSUBITEMRECT, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETSUBITEMRECT, $iIndex, DllStructGetPtr($tRECT))
	EndIf
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetSubItemRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetTextBkColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETTEXTBKCOLOR)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETTEXTBKCOLOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetTextBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetTextColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETTEXTCOLOR)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETTEXTCOLOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetToolTips($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $LVM_GETTOOLTIPS))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETTOOLTIPS, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetTopIndex($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETTOPINDEX)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETTOPINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetUnicodeFormat($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETUNICODEFORMAT) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETUNICODEFORMAT, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetView($hWnd)
	Local $iView
	If IsHWnd($hWnd) Then
		$iView = _SendMessage($hWnd, $LVM_GETVIEW)
	Else
		$iView = GUICtrlSendMsg($hWnd, $LVM_GETVIEW, 0, 0)
	EndIf
	Switch $iView
		Case $LV_VIEW_ICON
			Return Int($LV_VIEW_ICON)
		Case $LV_VIEW_DETAILS
			Return Int($LV_VIEW_DETAILS)
		Case $LV_VIEW_LIST
			Return Int($LV_VIEW_LIST)
		Case $LV_VIEW_SMALLICON
			Return Int($LV_VIEW_SMALLICON)
		Case $LV_VIEW_TILE
			Return Int($LV_VIEW_TILE)
		Case Else
			Return -1
	EndSwitch
EndFunc   ;==>_GUICtrlListView_GetView

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetViewDetails($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_DETAILS
EndFunc   ;==>_GUICtrlListView_GetViewDetails

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetViewLarge($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_ICON
EndFunc   ;==>_GUICtrlListView_GetViewLarge

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetViewList($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_LIST
EndFunc   ;==>_GUICtrlListView_GetViewList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetViewSmall($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_SMALLICON
EndFunc   ;==>_GUICtrlListView_GetViewSmall

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_GetViewTile($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_TILE
EndFunc   ;==>_GUICtrlListView_GetViewTile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_GetViewRect($hWnd)
	Local $aRect[4] = [0, 0, 0, 0]

	Local $iView = _GUICtrlListView_GetView($hWnd)
	If ($iView <> 1) And ($iView <> 3) Then Return $aRect

	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETVIEWRECT, 0, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_SendMessage($hWnd, $LVM_GETVIEWRECT, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETVIEWRECT, 0, DllStructGetPtr($tRECT))
	EndIf
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetViewRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_HideColumn($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCOLUMNWIDTH, $iCol) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_HideColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_HitTest($hWnd, $iX = -1, $iY = -1)
	Local $aTest[10]

	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	Local $aResult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return 0

	If $iX = -1 Then $iX = DllStructGetData($tPoint, "X")
	If $iY = -1 Then $iY = DllStructGetData($tPoint, "Y")

	Local $tTest = DllStructCreate($tagLVHITTESTINFO)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$aTest[0] = _SendMessage($hWnd, $LVM_HITTEST, 0, $tTest, 0, "wparam", "struct*")
		Else
			Local $iTest = DllStructGetSize($tTest)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iTest, $tMemMap)
			_MemWrite($tMemMap, $tTest, $pMemory, $iTest)
			$aTest[0] = _SendMessage($hWnd, $LVM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tTest, $iTest)
			_MemFree($tMemMap)
		EndIf
	Else
		$aTest[0] = GUICtrlSendMsg($hWnd, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
	EndIf
	Local $iFlags = DllStructGetData($tTest, "Flags")
	$aTest[1] = BitAND($iFlags, $LVHT_NOWHERE) <> 0
	$aTest[2] = BitAND($iFlags, $LVHT_ONITEMICON) <> 0
	$aTest[3] = BitAND($iFlags, $LVHT_ONITEMLABEL) <> 0
	$aTest[4] = BitAND($iFlags, $LVHT_ONITEMSTATEICON) <> 0
	$aTest[5] = BitAND($iFlags, $LVHT_ONITEM) <> 0
	$aTest[6] = BitAND($iFlags, $LVHT_ABOVE) <> 0
	$aTest[7] = BitAND($iFlags, $LVHT_BELOW) <> 0
	$aTest[8] = BitAND($iFlags, $LVHT_TOLEFT) <> 0
	$aTest[9] = BitAND($iFlags, $LVHT_TORIGHT) <> 0
	Return $aTest
EndFunc   ;==>_GUICtrlListView_HitTest

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_IndexToOverlayImageMask
; Description ...: Converts an image index to a overlay image mask
; Syntax.........: __GUICtrlListView_IndexToOverlayImageMask ( $iIndex )
; Parameters ....: $iIndex      - One based overlay index
; Return values .: Success      - Image index mask
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally and should not normally be called
; Related .......: __GUICtrlListView_OverlayImageMaskToIndex
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_IndexToOverlayImageMask($iIndex)
	Return BitShift($iIndex, -8)
EndFunc   ;==>__GUICtrlListView_IndexToOverlayImageMask

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_IndexToStateImageMask
; Description ...: Converts an image index to a state image mask
; Syntax.........: __GUICtrlListView_IndexToStateImageMask ( $iIndex )
; Parameters ....: $iIndex      - One based image index
; Return values .: Success      - Image index mask
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally and should not normally be called
; Related .......: __GUICtrlListView_StateImageMaskToIndex
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_IndexToStateImageMask($iIndex)
	Return BitShift($iIndex, -12)
EndFunc   ;==>__GUICtrlListView_IndexToStateImageMask

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_InsertColumn($hWnd, $iIndex, $sText, $iWidth = 50, $iAlign = -1, $iImage = -1, $bOnRight = False)
	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	Local $iMask = BitOR($LVCF_FMT, $LVCF_WIDTH, $LVCF_TEXT)
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $iFmt = $aAlign[$iAlign]
	If $iImage <> -1 Then
		$iMask = BitOR($iMask, $LVCF_IMAGE)
		$iFmt = BitOR($iFmt, $LVCFMT_COL_HAS_IMAGES, $LVCFMT_IMAGE)
	EndIf
	If $bOnRight Then $iFmt = BitOR($iFmt, $LVCFMT_BITMAP_ON_RIGHT)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	DllStructSetData($tColumn, "CX", $iWidth)
	DllStructSetData($tColumn, "TextMax", $iBuffer)
	DllStructSetData($tColumn, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tColumn, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_INSERTCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iColumn
			DllStructSetData($tColumn, "Text", $pText)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_INSERTCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_INSERTCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		DllStructSetData($tColumn, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	; added, not sure why justification is not working on insert
	If $iAlign > 0 Then _GUICtrlListView_SetColumn($hWnd, $iRet, $sText, $iWidth, $iAlign, $iImage, $bOnRight)
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Yoan Roblet (Arcker), Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_InsertGroup($hWnd, $iIndex, $iGroupID, $sHeader, $iAlign = 0)
	Local $aAlign[3] = [$LVGA_HEADER_LEFT, $LVGA_HEADER_CENTER, $LVGA_HEADER_RIGHT]

	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0

	Local $tHeader = _WinAPI_MultiByteToWideChar($sHeader)
	Local $pHeader = DllStructGetPtr($tHeader)
	Local $iHeader = StringLen($sHeader)
	Local $tGroup = DllStructCreate($tagLVGROUP)
	Local $iGroup = DllStructGetSize($tGroup)
	Local $iMask = BitOR($LVGF_HEADER, $LVGF_ALIGN, $LVGF_GROUPID)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", $iMask)
	DllStructSetData($tGroup, "HeaderMax", $iHeader)
	DllStructSetData($tGroup, "GroupID", $iGroupID)
	DllStructSetData($tGroup, "Align", $aAlign[$iAlign])
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tGroup, "Header", $pHeader)
			$iRet = _SendMessage($hWnd, $LVM_INSERTGROUP, $iIndex, $tGroup, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup + $iHeader, $tMemMap)
			Local $pText = $pMemory + $iGroup
			DllStructSetData($tGroup, "Header", $pText)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			_MemWrite($tMemMap, $tHeader, $pText, $iHeader)
			$iRet = _SendMessage($hWnd, $LVM_INSERTGROUP, $iIndex, $tGroup, 0, "wparam", "struct*")
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tGroup, "Header", $pHeader)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTGROUP, $iIndex, DllStructGetPtr($tGroup))
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertGroup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_InsertItem($hWnd, $sText, $iIndex = -1, $iImage = -1, $iParam = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iBuffer, $tBuffer, $iRet
	If $iIndex = -1 Then $iIndex = 999999999

	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Param", $iParam)
	; If $sText <> -1 Then
	$iBuffer = StringLen($sText) + 1
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
	DllStructSetData($tItem, "TextMax", $iBuffer)
	; Else
	; DllStructSetData($tItem, "Text", -1)
	; EndIf
	Local $iMask = BitOR($LVIF_TEXT, $LVIF_PARAM)
	If $iImage >= 0 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Image", $iImage)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Or ($sText = -1) Then
			$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertItem

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_InsertMarkHitTest
; Description ...: Retrieves the insertion point closest to a specified point
; Syntax.........: _GUICtrlListView_InsertMarkHitTest ( $hWnd [, $iX = -1 [, $iY = -1]] )
; Parameters ....: $hWnd        - Handle to the control
;                  $iX          - X position test point or -1 to use the current mouse position
;                  $iY          - Y position test point or -1 to use the current mouse position
; Return values .: Success      - Array with the following format:
;                  |[0] - True if the insertion point appears after the item, otherwise False
;                  |[1] - Item next to which the insertion point appears. If this is -1, there is no insertion point.
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; Related .......: _GUICtrlListView_GetInsertMark
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_InsertMarkHitTest($hWnd, $iX = -1, $iY = -1)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	Local $aResult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return 0

	If $iX = -1 Then $iX = DllStructGetData($tPoint, "X")
	If $iY = -1 Then $iY = DllStructGetData($tPoint, "Y")

	Local $tMark = DllStructCreate($tagLVINSERTMARK)
	Local $iMark = DllStructGetSize($tMark)
	DllStructSetData($tPoint, "X", $iX)
	DllStructSetData($tPoint, "Y", $iY)
	DllStructSetData($tMark, "Size", $iMark)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_INSERTMARKHITTEST, $tPoint, $tMark, 0, "struct*", "struct*")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemM = _MemInit($hWnd, $iPoint + $iMark, $tMemMap)
			Local $pMemP = $pMemM + $iPoint ; BUG ??? was referencing $pMemP
			_MemWrite($tMemMap, $tMark, $pMemM, $iMark)
			_MemWrite($tMemMap, $tPoint, $pMemP, $iPoint)
			_SendMessage($hWnd, $LVM_INSERTMARKHITTEST, $pMemP, $pMemM, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemM, $tMark, $iMark)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_INSERTMARKHITTEST, DllStructGetPtr($tPoint), DllStructGetPtr($tMark))
	EndIf
	Local $aTest[2]
	$aTest[0] = DllStructGetData($tMark, "Flags") = $LVIM_AFTER
	$aTest[1] = DllStructGetData($tMark, "Item")
	Return $aTest
EndFunc   ;==>_GUICtrlListView_InsertMarkHitTest

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_IsItemVisible
; Description ...: Gets the state for a specified group
; Syntax.........: _GUICtrlListView_IsItemVisible ( $hWnd, $iIndex )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - An index of the item in the list-view control
; Return values .:  True        - Visible
;                  False        - Not Visible
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: Minimum operating systems: Windows Vista
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlListView_IsItemVisible($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ISITEMVISIBLE, $iIndex) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ISITEMVISIBLE, $iIndex, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_IsItemVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_JustifyColumn($hWnd, $iIndex, $iAlign = -1)
	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $iMask = $LVCF_FMT
	Local $iFmt = $aAlign[$iAlign]
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn, $tMemMap)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_JustifyColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_MapIDToIndex($hWnd, $iID)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_MAPIDTOINDEX, $iID)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_MAPIDTOINDEX, $iID, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_MapIDToIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_MapIndexToID($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_MAPINDEXTOID, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_MAPINDEXTOID, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_MapIndexToID

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_MoveGroup
; Description ...: Moves the group to the specified zero based index
; Syntax.........: _GUICtrlListView_MoveGroup ( $hWnd, $iGroupID [, $iIndex = -1] )
; Parameters ....: $hWnd        - Handle to the control
;                  $iGroupID    - ID of the group to move
;                  $iIndex      - Zero based index of an item where the group will move
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_MoveGroup($hWnd, $iGroupID, $iIndex = -1)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_MOVEGROUP, $iGroupID, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_MOVEGROUP, $iGroupID, $iIndex)
	EndIf
EndFunc   ;==>_GUICtrlListView_MoveGroup

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_OverlayImageMaskToIndex
; Description ...: Converts an overlay image mask to an image index
; Syntax.........: __GUICtrlListView_OverlayImageMaskToIndex ( $iMask )
; Parameters ....: $iMask       - Image index mask
; Return values .: Success      - Image index
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally and should not normally be called
; Related .......: __GUICtrlListView_IndexToOverlayImageMask
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_OverlayImageMaskToIndex($iMask)
	Return BitShift(BitAND($LVIS_OVERLAYMASK, $iMask), 8)
EndFunc   ;==>__GUICtrlListView_OverlayImageMaskToIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_RedrawItems($hWnd, $iFirst, $iLast)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_REDRAWITEMS, $iFirst, $iLast) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_REDRAWITEMS, $iFirst, $iLast) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_RedrawItems

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_RegisterSortCallBack($hWnd, $vCompareType = 1, $bArrows = True, $sPrivateCallback = "__GUICtrlListView_Sort")
	#Au3Stripper_Ignore_Funcs=$sPrivateCallback
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If IsBool($vCompareType) Then $vCompareType = ($vCompareType) ? 1 : 0

	Local $hHeader = _GUICtrlListView_GetHeader($hWnd)

	ReDim $__g_aListViewSortInfo[UBound($__g_aListViewSortInfo) + 1][$__LISTVIEWCONSTANT_SORTINFOSIZE]

	$__g_aListViewSortInfo[0][0] = UBound($__g_aListViewSortInfo) - 1
	Local $iIndex = $__g_aListViewSortInfo[0][0]

	$__g_aListViewSortInfo[$iIndex][1] = $hWnd ; Handle/ID of listview

	$__g_aListViewSortInfo[$iIndex][2] = _
			DllCallbackRegister($sPrivateCallback, "int", "int;int;hwnd") ; Handle of callback
	$__g_aListViewSortInfo[$iIndex][3] = -1 ; $nColumn
	$__g_aListViewSortInfo[$iIndex][4] = -1 ; nCurCol
	$__g_aListViewSortInfo[$iIndex][5] = 1 ; $nSortDir
	$__g_aListViewSortInfo[$iIndex][6] = -1 ; $nCol
	$__g_aListViewSortInfo[$iIndex][7] = 0 ; $bSet
	$__g_aListViewSortInfo[$iIndex][8] = $vCompareType ; Treat as Strings, Numbers or use Windows API to compare
	$__g_aListViewSortInfo[$iIndex][9] = $bArrows ; Use arrows in the header of the columns?
	$__g_aListViewSortInfo[$iIndex][10] = $hHeader ; Handle to the Header

	Return $__g_aListViewSortInfo[$iIndex][2] <> 0
EndFunc   ;==>_GUICtrlListView_RegisterSortCallBack

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_RemoveAllGroups($hWnd)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LVM_REMOVEALLGROUPS)
	Else
		GUICtrlSendMsg($hWnd, $LVM_REMOVEALLGROUPS, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_RemoveAllGroups

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_RemoveGroup($hWnd, $iGroupID)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_REMOVEGROUP, $iGroupID)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_REMOVEGROUP, $iGroupID, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_RemoveGroup

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_ReverseColorOrder
; Description ...: Convert Hex RGB or BGR Color to Hex RGB or BGR Color
; Syntax.........: __GUICtrlListView_ReverseColorOrder ( $iColor )
; Parameters ....: $iColor      - Color to convert
; Return values .: Color        - Hex RGB or BGR Color
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: This function is used interanally only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_ReverseColorOrder($iColor)
	Local $sH = Hex(String($iColor), 6)
	Return '0x' & StringMid($sH, 5, 2) & StringMid($sH, 3, 2) & StringMid($sH, 1, 2)
EndFunc   ;==>__GUICtrlListView_ReverseColorOrder

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_Scroll($hWnd, $iDX, $iDY)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SCROLL, $iDX, $iDY) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SCROLL, $iDX, $iDY) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_Scroll

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetBkColor($hWnd, $iColor)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETBKCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetBkImage($hWnd, $sURL = "", $iStyle = 0, $iXOffset = 0, $iYOffset = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	If Not IsHWnd($hWnd) Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $aStyle[2] = [$LVBKIF_STYLE_NORMAL, $LVBKIF_STYLE_TILE]

	Local $iBuffer = StringLen($sURL) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tImage = DllStructCreate($tagLVBKIMAGE)
	Local $iRet = 0
	If $sURL <> "" Then $iRet = $LVBKIF_SOURCE_URL
	$iRet = BitOR($iRet, $aStyle[$iStyle])
	DllStructSetData($tBuffer, "Text", $sURL)
	DllStructSetData($tImage, "Flags", $iRet)
	DllStructSetData($tImage, "XOffPercent", $iXOffset)
	DllStructSetData($tImage, "YOffPercent", $iYOffset)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tImage, "Image", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETBKIMAGEW, 0, $tImage, 0, "wparam", "struct*")
		Else
			Local $iImage = DllStructGetSize($tImage)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iImage + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iImage
			DllStructSetData($tImage, "Image", $pText)
			_MemWrite($tMemMap, $tImage, $pMemory, $iImage)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETBKIMAGEW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETBKIMAGEA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pImage = DllStructGetPtr($tImage)
		DllStructSetData($tImage, "Image", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKIMAGEW, 0, $pImage)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKIMAGEA, 0, $pImage)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetBkImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetCallBackMask($hWnd, $iMask)
	Local $iFlags = 0

	If BitAND($iMask, 1) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_CUT)
	If BitAND($iMask, 2) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_DROPHILITED)
	If BitAND($iMask, 4) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_FOCUSED)
	If BitAND($iMask, 8) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_SELECTED)
	If BitAND($iMask, 16) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_OVERLAYMASK)
	If BitAND($iMask, 32) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_STATEIMAGEMASK)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCALLBACKMASK, $iFlags) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCALLBACKMASK, $iFlags, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetCallBackMask

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetColumn($hWnd, $iIndex, $sText, $iWidth = -1, $iAlign = -1, $iImage = -1, $bOnRight = False)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]

	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	Local $iMask = $LVCF_TEXT
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	$iMask = BitOR($iMask, $LVCF_FMT)
	Local $iFmt = $aAlign[$iAlign]
	If $iWidth <> -1 Then $iMask = BitOR($iMask, $LVCF_WIDTH)
	If $iImage <> -1 Then
		$iMask = BitOR($iMask, $LVCF_IMAGE)
		$iFmt = BitOR($iFmt, $LVCFMT_COL_HAS_IMAGES, $LVCFMT_IMAGE)
	Else
		$iImage = 0
	EndIf
	If $bOnRight Then $iFmt = BitOR($iFmt, $LVCFMT_BITMAP_ON_RIGHT)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	DllStructSetData($tColumn, "CX", $iWidth)
	DllStructSetData($tColumn, "TextMax", $iBuffer)
	DllStructSetData($tColumn, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tColumn, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iColumn
			DllStructSetData($tColumn, "Text", $pText)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		DllStructSetData($tColumn, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetColumnOrder($hWnd, $sOrder)
	Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
	Return _GUICtrlListView_SetColumnOrderArray($hWnd, StringSplit($sOrder, $sSeparatorChar))
EndFunc   ;==>_GUICtrlListView_SetColumnOrder

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetColumnOrderArray($hWnd, $aOrder)
	Local $tBuffer = DllStructCreate("int[" & $aOrder[0] & "]")
	For $iI = 1 To $aOrder[0]
		DllStructSetData($tBuffer, 1, $aOrder[$iI], $iI)
	Next

	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNORDERARRAY, $aOrder[0], $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer, $pMemory, $iBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNORDERARRAY, $aOrder[0], $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNORDERARRAY, $aOrder[0], DllStructGetPtr($tBuffer))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetColumnOrderArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetColumnWidth($hWnd, $iCol, $iWidth)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetColumnWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetExtendedListViewStyle($hWnd, $iExStyle, $iExMask = 0)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETEXTENDEDLISTVIEWSTYLE, $iExMask, $iExStyle)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETEXTENDEDLISTVIEWSTYLE, $iExMask, $iExStyle)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_SetExtendedListViewStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetGroupInfo($hWnd, $iGroupID, $sHeader, $iAlign = 0, $iState = $LVGS_NORMAL)
	Local $tGroup = 0

	; Validate the ID of the group contains a list of items when using the $LVGS_SELECTED state
	If BitAND($iState, $LVGS_SELECTED) Then
		$tGroup = __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, BitOR($LVGF_GROUPID, $LVGF_ITEMS))
		If DllStructGetData($tGroup, "GroupId") <> $iGroupID Or DllStructGetData($tGroup, "cItems") = 0 Then Return False
	EndIf

	Local $aAlign[3] = [$LVGA_HEADER_LEFT, $LVGA_HEADER_CENTER, $LVGA_HEADER_RIGHT]

	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0

	Local $tHeader = _WinAPI_MultiByteToWideChar($sHeader)
	Local $pHeader = DllStructGetPtr($tHeader)
	Local $iHeader = StringLen($sHeader)
	$tGroup = DllStructCreate($tagLVGROUP)
	Local $pGroup = DllStructGetPtr($tGroup)
	Local $iGroup = DllStructGetSize($tGroup)
	Local $iMask = BitOR($LVGF_HEADER, $LVGF_ALIGN, $LVGF_STATE)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", $iMask)
	DllStructSetData($tGroup, "HeaderMax", $iHeader)
	DllStructSetData($tGroup, "Align", $aAlign[$iAlign])
	DllStructSetData($tGroup, "State", $iState)
	DllStructSetData($tGroup, "StateMask", $iState)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tGroup, "Header", $pHeader)
			$iRet = _SendMessage($hWnd, $LVM_SETGROUPINFO, $iGroupID, $pGroup)
			DllStructSetData($tGroup, "Mask", $LVGF_GROUPID)
			DllStructSetData($tGroup, "GroupID", $iGroupID)
			_SendMessage($hWnd, $LVM_SETGROUPINFO, 0, $pGroup)
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup + $iHeader, $tMemMap)
			Local $pText = $pMemory + $iGroup
			DllStructSetData($tGroup, "Header", $pText)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			_MemWrite($tMemMap, $tHeader, $pText, $iHeader)
			$iRet = _SendMessage($hWnd, $LVM_SETGROUPINFO, $iGroupID, $pMemory)
			DllStructSetData($tGroup, "Mask", $LVGF_GROUPID)
			DllStructSetData($tGroup, "GroupID", $iGroupID)
			_SendMessage($hWnd, $LVM_SETGROUPINFO, 0, $pMemory)
			_MemFree($tMemMap)
		EndIf
		_WinAPI_InvalidateRect($hWnd)
	Else
		DllStructSetData($tGroup, "Header", $pHeader)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETGROUPINFO, $iGroupID, $pGroup)
		DllStructSetData($tGroup, "Mask", $LVGF_GROUPID)
		DllStructSetData($tGroup, "GroupID", $iGroupID)
		GUICtrlSendMsg($hWnd, $LVM_SETGROUPINFO, 0, $pGroup)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetGroupInfo

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_SetHotCursor
; Description ...: Sets the cursor handle that the control uses
; Syntax.........: _GUICtrlListView_SetHotCursor ( $hWnd, $hCursor )
; Parameters ....: $hWnd        - Handle to the control
;                  $hCursor     - Handle to the cursor to be set
; Return values .: Success      - Handle to the previous hot cursor
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Currently not tested
; Related .......: _GUICtrlListView_GetHotCursor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_SetHotCursor($hWnd, $hCursor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETHOTCURSOR, 0, $hCursor, 0, "wparam", "handle", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_SETHOTCURSOR, 0, $hCursor))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetHotCursor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetHotItem($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETHOTITEM, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETHOTITEM, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetHotItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetHoverTime($hWnd, $iTime)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETHOVERTIME, 0, $iTime)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETHOVERTIME, 0, $iTime)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetHoverTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetIconSpacing($hWnd, $iCX, $iCY)
	Local $iRet, $aPadding[2]

	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETICONSPACING, 0, _WinAPI_MakeLong($iCX, $iCY))
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETICONSPACING, 0, _WinAPI_MakeLong($iCX, $iCY))
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	$aPadding[0] = BitAND($iRet, 0xFFFF)
	$aPadding[1] = BitShift($iRet, 16)
	Return $aPadding
EndFunc   ;==>_GUICtrlListView_SetIconSpacing

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetImageList($hWnd, $hHandle, $iType = 0)
	Local $aType[3] = [$LVSIL_NORMAL, $LVSIL_SMALL, $LVSIL_STATE]

	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETIMAGELIST, $aType[$iType], $hHandle, 0, "wparam", "handle", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_SETIMAGELIST, $aType[$iType], $hHandle))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetImageList

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_SetInfoTip
; Description ...: Sets ToolTip text
; Syntax.........: _GUICtrlListView_SetInfoTip ( $hWnd, $iIndex, $sText [, $iSubItem = 0] )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - Zero based index of the item
;                  $sText       - String that contains the tooltip text
;                  $iSubItem    - One based index of the subitem
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_SetInfoTip($hWnd, $iIndex, $sText, $iSubItem = 0)
	Local $tBuffer = _WinAPI_MultiByteToWideChar($sText)
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $iBuffer = StringLen($sText)
	Local $tInfo = DllStructCreate($tagLVSETINFOTIP)
	Local $iInfo = DllStructGetSize($tInfo)
	DllStructSetData($tInfo, "Size", $iInfo)
	DllStructSetData($tInfo, "Item", $iIndex)
	DllStructSetData($tInfo, "SubItem", $iSubItem)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tInfo, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETINFOTIP, 0, $tInfo, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iInfo + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iInfo
			DllStructSetData($tInfo, "Text", $pText)
			_MemWrite($tMemMap, $tInfo, $pMemory, $iInfo)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETINFOTIP, 0, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tInfo, "Text", $pBuffer)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETINFOTIP, 0, DllStructGetPtr($tInfo))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetInfoTip

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_SetInsertMark
; Description ...: Sets the insertion point to the defined position
; Syntax.........: _GUICtrlListView_SetInsertMark ( $hWnd, $iIndex [, $bAfter = False] )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - Zero based index of the item
;                  $bAfter      - Insertion point:
;         $i_Cols          | True - The insertion point will appear after the item
;                  |False - The insertion point will appear before the item
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; +
;                  An insertion point can only appear if the control is in icon view, small icon view,  or  tile
;                  view, and not in group view mode.
; Related .......: _GUICtrlListView_GetInsertMark
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_SetInsertMark($hWnd, $iIndex, $bAfter = False)
	Local $tMark = DllStructCreate($tagLVINSERTMARK)
	Local $iMark = DllStructGetSize($tMark)
	DllStructSetData($tMark, "Size", $iMark)
	If $bAfter Then DllStructSetData($tMark, "Flags", $LVIM_AFTER)
	DllStructSetData($tMark, "Item", $iIndex)
	DllStructSetData($tMark, "Reserved", 0)
	Local $iRet
	If IsHWnd($hWnd) Then
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMark, $tMemMap)
		_MemWrite($tMemMap, $tMark, $pMemory, $iMark)
		$iRet = _SendMessage($hWnd, $LVM_SETINSERTMARK, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETINSERTMARK, 0, DllStructGetPtr($tMark))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetInsertMark

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlListView_SetInsertMarkColor
; Description ...: Sets the color of the insertion point
; Syntax.........: _GUICtrlListView_SetInsertMarkColor ( $hWnd, $iColor )
; Parameters ....: $hWnd        - Handle to the control
;                  $iColor      - Color to set the insertion point
; Return values .: Success      - The previous insertion point color
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum operating systems Windows XP.
; Related .......: _GUICtrlListView_GetInsertMarkColor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlListView_SetInsertMarkColor($hWnd, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETINSERTMARKCOLOR, 0, $iColor)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETINSERTMARKCOLOR, 0, $iColor)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetInsertMarkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItem($hWnd, $sText, $iIndex = 0, $iSubItem = 0, $iImage = -1, $iParam = -1, $iIndent = -1)
	Local $pBuffer, $iBuffer
	If $sText <> -1 Then
		$iBuffer = StringLen($sText) + 1
		Local $tBuffer
		If _GUICtrlListView_GetUnicodeFormat($hWnd) Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		$pBuffer = DllStructGetPtr($tBuffer)
		DllStructSetData($tBuffer, "Text", $sText)
	Else
		$iBuffer = 0
		$pBuffer = -1 ; LPSTR_TEXTCALLBACK
	EndIf

	Local $tItem = DllStructCreate($tagLVITEM)
	Local $iMask = $LVIF_TEXT
	If $iImage <> -1 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	If $iParam <> -1 Then $iMask = BitOR($iMask, $LVIF_PARAM)
	If $iIndent <> -1 Then $iMask = BitOR($iMask, $LVIF_INDENT)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	DllStructSetData($tItem, "Image", $iImage)
	DllStructSetData($tItem, "Param", $iParam)
	DllStructSetData($tItem, "Indent", $iIndent)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemChecked($hWnd, $iIndex, $bCheck = True)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $pMemory, $tMemMap, $iRet

	Local $tItem = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tItem)
	Local $iItem = DllStructGetSize($tItem)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If $iIndex <> -1 Then
		DllStructSetData($tItem, "Mask", $LVIF_STATE)
		DllStructSetData($tItem, "Item", $iIndex)
		If ($bCheck) Then
			DllStructSetData($tItem, "State", 0x2000)
		Else
			DllStructSetData($tItem, "State", 0x1000)
		EndIf
		DllStructSetData($tItem, "StateMask", 0xf000)
		If IsHWnd($hWnd) Then
			If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
				Return _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*") <> 0
			Else
				$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
				_MemWrite($tMemMap, $tItem)
				If $bUnicode Then
					$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
				Else
					$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
				EndIf
				_MemFree($tMemMap)
				Return $iRet <> 0
			EndIf
		Else
			If $bUnicode Then
				Return GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0
			Else
				Return GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0
			EndIf
		EndIf
	Else
		For $x = 0 To _GUICtrlListView_GetItemCount($hWnd) - 1
			DllStructSetData($tItem, "Mask", $LVIF_STATE)
			DllStructSetData($tItem, "Item", $x)
			If ($bCheck) Then
				DllStructSetData($tItem, "State", 0x2000)
			Else
				DllStructSetData($tItem, "State", 0x1000)
			EndIf
			DllStructSetData($tItem, "StateMask", 0xf000)
			If IsHWnd($hWnd) Then
				If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
					If Not _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*") <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				Else
					$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
					_MemWrite($tMemMap, $tItem)
					If $bUnicode Then
						$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
					Else
						$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
					EndIf
					_MemFree($tMemMap)
					If Not $iRet <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				EndIf
			Else
				If $bUnicode Then
					If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				Else
					If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				EndIf
			EndIf
		Next
		Return True
	EndIf
	Return False
EndFunc   ;==>_GUICtrlListView_SetItemChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemCount($hWnd, $iItems)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETITEMCOUNT, $iItems, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL)) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETITEMCOUNT, $iItems, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL)) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetItemCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemCut($hWnd, $iIndex, $bEnabled = True)
	Local $iState = 0

	If $bEnabled Then $iState = $LVIS_CUT
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $LVIS_CUT)
EndFunc   ;==>_GUICtrlListView_SetItemCut

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemDropHilited($hWnd, $iIndex, $bEnabled = True)
	Local $iState = 0

	If $bEnabled Then $iState = $LVIS_DROPHILITED
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $LVIS_DROPHILITED)
EndFunc   ;==>_GUICtrlListView_SetItemDropHilited

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetItemEx($hWnd, ByRef $tItem)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iRet
	If IsHWnd($hWnd) Then
		Local $iItem = DllStructGetSize($tItem)
		Local $iBuffer = DllStructGetData($tItem, "TextMax")
		Local $pBuffer = DllStructGetData($tItem, "Text")
		If $bUnicode Then $iBuffer *= 2
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iItem
		DllStructSetData($tItem, "Text", $pText)
		_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		If $pBuffer <> 0 Then _MemWrite($tMemMap, $pBuffer, $pText, $iBuffer)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemFocused($hWnd, $iIndex, $bEnabled = True)
	Local $iState = 0

	If $bEnabled Then $iState = $LVIS_FOCUSED
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $LVIS_FOCUSED)
EndFunc   ;==>_GUICtrlListView_SetItemFocused

; #FUNCTION# ====================================================================================================================
; Author ........: Yoan Roblet (Arcker), Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemGroupID($hWnd, $iIndex, $iGroupID)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_GROUPID)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "GroupID", $iGroupID)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemGroupID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemImage($hWnd, $iIndex, $iImage, $iSubItem = 0)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_IMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Image", $iImage)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemIndent($hWnd, $iIndex, $iIndent)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_INDENT)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Indent", $iIndent)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemIndent

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_SetItemOverlayImage
; Description ...: Sets the overlay image is superimposed over the item's icon image
; Syntax.........: __GUICtrlListView_SetItemOverlayImage ( $hWnd, $iIndex, $iImage )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - Zero based index of the item
;                  $iImage      - One based overlay image index
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally and should not normally be called
; Related .......: __GUICtrlListView_GetItemOverlayImage
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_SetItemOverlayImage($hWnd, $iIndex, $iImage)
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, __GUICtrlListView_IndexToOverlayImageMask($iImage), $LVIS_OVERLAYMASK)
EndFunc   ;==>__GUICtrlListView_SetItemOverlayImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemParam($hWnd, $iIndex, $iParam)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_PARAM)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Param", $iParam)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetItemPosition($hWnd, $iIndex, $iCX, $iCY)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETITEMPOSITION, $iIndex, _WinAPI_MakeLong($iCX, $iCY)) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETITEMPOSITION, $iIndex, _WinAPI_MakeLong($iCX, $iCY)) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetItemPosition

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetItemPosition32($hWnd, $iIndex, $iCX, $iCY)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $iCX)
	DllStructSetData($tPoint, "Y", $iCY)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETITEMPOSITION32, $iIndex, $tPoint, 0, "wparam", "struct*")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			_MemWrite($tMemMap, $tPoint)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMPOSITION32, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMPOSITION32, $iIndex, DllStructGetPtr($tPoint))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemPosition32

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemSelected($hWnd, $iIndex, $bSelected = True, $bFocused = False)
	Local $tStruct = DllStructCreate($tagLVITEM)
	Local $iRet, $iSelected = 0, $iFocused = 0, $iSize, $tMemMap, $pMemory
	If ($bSelected = True) Then $iSelected = $LVIS_SELECTED
	If ($bFocused = True And $iIndex <> -1) Then $iFocused = $LVIS_FOCUSED
	DllStructSetData($tStruct, "Mask", $LVIF_STATE)
	DllStructSetData($tStruct, "Item", $iIndex)
	DllStructSetData($tStruct, "State", BitOR($iSelected, $iFocused))
	DllStructSetData($tStruct, "StateMask", BitOR($LVIS_SELECTED, $iFocused))
	$iSize = DllStructGetSize($tStruct)
	If IsHWnd($hWnd) Then
		$pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		_MemWrite($tMemMap, $tStruct, $pMemory, $iSize)
		$iRet = _SendMessage($hWnd, $LVM_SETITEMSTATE, $iIndex, $pMemory)
		_MemFree($tMemMap)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMSTATE, $iIndex, DllStructGetPtr($tStruct))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemSelected

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $iStateMask)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_STATE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "State", $iState)
	DllStructSetData($tItem, "StateMask", $iStateMask)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem) <> 0
EndFunc   ;==>_GUICtrlListView_SetItemState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetItemStateImage($hWnd, $iIndex, $iImage)
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, BitShift($iImage, -12), $LVIS_STATEIMAGEMASK)
EndFunc   ;==>_GUICtrlListView_SetItemStateImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost), added code by Ultima to set row text
; ===============================================================================================================================
Func _GUICtrlListView_SetItemText($hWnd, $iIndex, $sText, $iSubItem = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)

	Local $iRet

	If $iSubItem = -1 Then
		Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
		Local $i_Cols = _GUICtrlListView_GetColumnCount($hWnd)
		Local $a_Text = StringSplit($sText, $sSeparatorChar)
		If $i_Cols > $a_Text[0] Then $i_Cols = $a_Text[0]
		For $i = 1 To $i_Cols
			$iRet = _GUICtrlListView_SetItemText($hWnd, $iIndex, $a_Text[$i], $i - 1)
			If Not $iRet Then ExitLoop
		Next
		Return $iRet
	EndIf

	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $LVIF_TEXT)
	DllStructSetData($tItem, "item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetOutlineColor($hWnd, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETOUTLINECOLOR, 0, $iColor)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETOUTLINECOLOR, 0, $iColor)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetOutlineColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SetSelectedColumn($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LVM_SETSELECTEDCOLUMN, $iCol)
		_WinAPI_InvalidateRect($hWnd)
	Else
		GUICtrlSendMsg($hWnd, $LVM_SETSELECTEDCOLUMN, $iCol, 0)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetSelectedColumn

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetSelectionMark($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETSELECTIONMARK, 0, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETSELECTIONMARK, 0, $iIndex)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetSelectionMark

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetTextBkColor($hWnd, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETTEXTBKCOLOR, 0, $iColor) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETTEXTBKCOLOR, 0, $iColor) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetTextBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetTextColor($hWnd, $iColor)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETTEXTCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETTEXTCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetToolTips($hWnd, $hToolTip)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETTOOLTIPS, 0, $hToolTip, 0, "wparam", "hwnd", "hwnd")
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_SETTOOLTIPS, 0, $hToolTip))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetUnicodeFormat($hWnd, $bUnicode)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETUNICODEFORMAT, $bUnicode)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETUNICODEFORMAT, $bUnicode, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetView($hWnd, $iView)
	Local $aView[5] = [$LV_VIEW_ICON, $LV_VIEW_DETAILS, $LV_VIEW_LIST, $LV_VIEW_SMALLICON, $LV_VIEW_TILE]

	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETVIEW, $aView[$iView]) <> -1
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETVIEW, $aView[$iView], 0) <> -1
	EndIf
EndFunc   ;==>_GUICtrlListView_SetView

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SetWorkAreas($hWnd, $iLeft, $iTop, $iRight, $iBottom)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $iLeft)
	DllStructSetData($tRECT, "Top", $iTop)
	DllStructSetData($tRECT, "Right", $iRight)
	DllStructSetData($tRECT, "Bottom", $iBottom)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_SETWORKAREAS, 1, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT, $pMemory, $iRect)
			_SendMessage($hWnd, $LVM_SETWORKAREAS, 1, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_SETWORKAREAS, 1, DllStructGetPtr($tRECT))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetWorkAreas

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: guinness - Re-write of function to remove magic numbers and unnecessary use of UBound. Melba23 - Added optional parameter to reverse the $vSortSense variable.
; Modified.......: Melba23 to fix checked item bug in __GUICtrlListView_GetCheckedIndices
; ===============================================================================================================================
Func _GUICtrlListView_SimpleSort($hWnd, ByRef $vSortSense, $iCol, $bToggleSense = True)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hWnd)
	If $iItemCount Then
		Local $iDescending = 0
		If UBound($vSortSense) Then
			$iDescending = $vSortSense[$iCol]
		Else
			$iDescending = $vSortSense
		EndIf
		Local $vSeparatorChar = Opt('GUIDataSeparatorChar')
		Local $iColumnCount = _GUICtrlListView_GetColumnCount($hWnd)
		Local Enum $iIndexValue = $iColumnCount, $iItemParam ; Additional columns for the index value and ItemParam
		Local $aListViewItems[$iItemCount][$iColumnCount + 2]

		Local $aSelectedItems = StringSplit(_GUICtrlListView_GetSelectedIndices($hWnd), $vSeparatorChar)
		Local $aCheckedItems = __GUICtrlListView_GetCheckedIndices($hWnd)
		Local $sItemText, $iFocused = -1
		For $i = 0 To $iItemCount - 1 ; Rows
			If $iFocused = -1 Then
				If _GUICtrlListView_GetItemFocused($hWnd, $i) Then $iFocused = $i
			EndIf
			_GUICtrlListView_SetItemSelected($hWnd, $i, False)
			_GUICtrlListView_SetItemChecked($hWnd, $i, False)
			For $j = 0 To $iColumnCount - 1 ; Columns
				$sItemText = StringStripWS(_GUICtrlListView_GetItemText($hWnd, $i, $j), $STR_STRIPTRAILING)
				If (StringIsFloat($sItemText) Or StringIsInt($sItemText)) Then
					$aListViewItems[$i][$j] = Number($sItemText)
				Else
					$aListViewItems[$i][$j] = $sItemText
				EndIf
			Next
			$aListViewItems[$i][$iIndexValue] = $i ; Index value
			$aListViewItems[$i][$iItemParam] = _GUICtrlListView_GetItemParam($hWnd, $i) ; ItemParam
		Next

		; Sort the ListView array
		_ArraySort($aListViewItems, $iDescending, 0, 0, $iCol)

		For $i = 0 To $iItemCount - 1 ; Rows
			For $j = 0 To $iColumnCount - 1 ; Columns
				_GUICtrlListView_SetItemText($hWnd, $i, $aListViewItems[$i][$j], $j)
			Next

			_GUICtrlListView_SetItemParam($hWnd, $i, $aListViewItems[$i][$iItemParam]) ; ItemParam

			For $j = 1 To $aSelectedItems[0]
				If $aListViewItems[$i][$iIndexValue] = $aSelectedItems[$j] Then
					If $aListViewItems[$i][$iIndexValue] = $iFocused Then
						_GUICtrlListView_SetItemSelected($hWnd, $i, True, True)
					Else
						_GUICtrlListView_SetItemSelected($hWnd, $i, True)
					EndIf
					ExitLoop
				EndIf
			Next
			For $j = 1 To $aCheckedItems[0]
				If $aListViewItems[$i][$iIndexValue] = $aCheckedItems[$j] Then
					_GUICtrlListView_SetItemChecked($hWnd, $i, True)
					ExitLoop
				EndIf
			Next
		Next
		If $bToggleSense Then ; Automatic sort sense toggle
			If UBound($vSortSense) Then
				$vSortSense[$iCol] = Not $iDescending
			Else
				$vSortSense = Not $iDescending
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListView_SimpleSort

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_Sort
; Description ...: Our sorting callback function
; Syntax.........: __GUICtrlListView_Sort ( $nItem1, $nItem2, $hWnd )
; Parameters ....: $nItem1      - Param of 1st item
;                  $nItem2      - Param of 2nd item
;                  $hWnd        - Handle of the control
; Return values .: None
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
#Au3Stripper_Ignore_Funcs=__GUICtrlListView_Sort
Func __GUICtrlListView_Sort($nItem1, $nItem2, $hWnd)
	Local $iIndex, $sVal1, $sVal2, $nResult

	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next

	; Switch the sorting direction
	If $__g_aListViewSortInfo[$iIndex][3] = $__g_aListViewSortInfo[$iIndex][4] Then ; $nColumn = nCurCol ?
		If Not $__g_aListViewSortInfo[$iIndex][7] Then ; $bSet
			$__g_aListViewSortInfo[$iIndex][5] *= -1 ; $nSortDir
			$__g_aListViewSortInfo[$iIndex][7] = 1 ; $bSet
		EndIf
	Else
		$__g_aListViewSortInfo[$iIndex][7] = 1 ; $bSet
	EndIf
	$__g_aListViewSortInfo[$iIndex][6] = $__g_aListViewSortInfo[$iIndex][3] ; $nCol = $nColumn
	$sVal1 = _GUICtrlListView_GetItemText($hWnd, $nItem1, $__g_aListViewSortInfo[$iIndex][3])
	$sVal2 = _GUICtrlListView_GetItemText($hWnd, $nItem2, $__g_aListViewSortInfo[$iIndex][3])

	If $__g_aListViewSortInfo[$iIndex][8] = 1 Then
		; force Treat as Number if possible
		If (StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
		If (StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
	EndIf

	If $__g_aListViewSortInfo[$iIndex][8] < 2 Then
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

	$nResult = $nResult * $__g_aListViewSortInfo[$iIndex][5] ; $nSortDir

	Return $nResult
EndFunc   ;==>__GUICtrlListView_Sort

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_SortItems($hWnd, $iCol)
	Local $iRet, $iIndex, $pFunction, $hHeader, $iFormat

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next

	$pFunction = DllCallbackGetPtr($__g_aListViewSortInfo[$iIndex][2]) ; get pointer to call back
	$__g_aListViewSortInfo[$iIndex][3] = $iCol ; $nColumn = column clicked
	$__g_aListViewSortInfo[$iIndex][7] = 0 ; $bSet
	$__g_aListViewSortInfo[$iIndex][4] = $__g_aListViewSortInfo[$iIndex][6] ; nCurCol = $nCol
	$iRet = _SendMessage($hWnd, $LVM_SORTITEMSEX, $hWnd, $pFunction, 0, "hwnd", "ptr")
	If $iRet <> 0 Then
		If $__g_aListViewSortInfo[$iIndex][9] Then ; Use arrow in header
			$hHeader = $__g_aListViewSortInfo[$iIndex][10]
			For $x = 0 To _GUICtrlHeader_GetItemCount($hHeader) - 1
				$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $x)
				If BitAND($iFormat, $HDF_SORTDOWN) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTDOWN))
				ElseIf BitAND($iFormat, $HDF_SORTUP) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTUP))
				EndIf
			Next
			$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $iCol)
			If $__g_aListViewSortInfo[$iIndex][5] = 1 Then ; ascending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTUP))
			Else ; descending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTDOWN))
			EndIf
		EndIf
	EndIf

	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SortItems

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlListView_StateImageMaskToIndex
; Description ...: Converts a state image mask to an image index
; Syntax.........: __GUICtrlListView_StateImageMaskToIndex ( $iMask )
; Parameters ....: $iMask       - State image mask
; Return values .: Success      - One base state image index
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally and should not normally be called
; Related .......: __GUICtrlListView_IndexToStateImageMask
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlListView_StateImageMaskToIndex($iMask)
	Return BitShift(BitAND($iMask, $LVIS_STATEIMAGEMASK), 12)
EndFunc   ;==>__GUICtrlListView_StateImageMaskToIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListView_SubItemHitTest($hWnd, $iX = -1, $iY = -1)
	Local $iTest, $tTest, $pMemory, $tMemMap, $iFlags, $aTest[11]

	If $iX = -1 Then $iX = _WinAPI_GetMousePosX(True, $hWnd)
	If $iY = -1 Then $iY = _WinAPI_GetMousePosY(True, $hWnd)
	$tTest = DllStructCreate($tagLVHITTESTINFO)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_SUBITEMHITTEST, 0, $tTest, 0, "wparam", "struct*")
		Else
			$iTest = DllStructGetSize($tTest)
			$pMemory = _MemInit($hWnd, $iTest, $tMemMap)
			_MemWrite($tMemMap, $tTest)
			_SendMessage($hWnd, $LVM_SUBITEMHITTEST, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tTest, $iTest)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_SUBITEMHITTEST, 0, DllStructGetPtr($tTest))
	EndIf
	$iFlags = DllStructGetData($tTest, "Flags")
	$aTest[0] = DllStructGetData($tTest, "Item")
	$aTest[1] = DllStructGetData($tTest, "SubItem")
	$aTest[2] = BitAND($iFlags, $LVHT_NOWHERE) <> 0
	$aTest[3] = BitAND($iFlags, $LVHT_ONITEMICON) <> 0
	$aTest[4] = BitAND($iFlags, $LVHT_ONITEMLABEL) <> 0
	$aTest[5] = BitAND($iFlags, $LVHT_ONITEMSTATEICON) <> 0
	$aTest[6] = BitAND($iFlags, $LVHT_ONITEM) <> 0
	$aTest[7] = BitAND($iFlags, $LVHT_ABOVE) <> 0
	$aTest[8] = BitAND($iFlags, $LVHT_BELOW) <> 0
	$aTest[9] = BitAND($iFlags, $LVHT_TOLEFT) <> 0
	$aTest[10] = BitAND($iFlags, $LVHT_TORIGHT) <> 0
	Return $aTest
EndFunc   ;==>_GUICtrlListView_SubItemHitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListView_UnRegisterSortCallBack($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			DllCallbackFree($__g_aListViewSortInfo[$x][2])
			__GUICtrlListView_ArrayDelete($__g_aListViewSortInfo, $x)
			$__g_aListViewSortInfo[0][0] -= 1
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_GUICtrlListView_UnRegisterSortCallBack
