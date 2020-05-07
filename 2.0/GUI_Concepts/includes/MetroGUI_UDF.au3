; #UDF# =======================================================================================================================
; Name ..........: MetroGUI UDF
; Description ...: Create borderless GUIs with modern buttons, checkboxes, toggles, radios MsgBoxes and progressbars.
; Version .......: v5.1.0.0
; Author ........: BB_19
; ===============================================================================================================================

#include-once
#include "MetroThemes.au3"
#include "MetroUDF-Required\StringSize.au3"
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <WinAPISys.au3>
#include <Array.au3>
#include "MetroUDF-Required\SSCtrlHover.au3"

_GDIPlus_Startup()
Opt("WinWaitDelay", 0) ;Required for faster WinActivate when using the fullscreen mode

;Global Variables
Global $Font_DPI_Ratio = _GetFontDPI_Ratio()[2], $gDPI = _GDIPlus_GraphicsGetDPIRatio()
Global $iHoverReg[0], $iGUI_LIST[0]
Global $iMsgBoxTimeout = 0 ;internal msgbox counter
Global $GUI_TOP_MARGIN = Number(29 * $gDPI, 1) + Number(10 * $gDPI, 1)
Global Const $m_hDll = DllCallbackRegister('_iEffectControl', 'lresult', 'hwnd;uint;wparam;lparam;uint_ptr;dword_ptr')
Global Const $m_pDll = DllCallbackGetPtr($m_hDll)
OnAutoItExitRegister('_iMExit')
Global Const $bMarg = 4 * $gDPI ;Border margin

;Options
Global $HIGHDPI_SUPPORT = False ;Enables HighDPI support
Global $ControlBtnsAutoMode = True ;Enables the automated fullscreen toggle on button click
Global $mOnEventMode = False

;Check OnEventMode
If Opt("GUIOnEventMode", 0) Then
	Opt("GUIOnEventMode", 1)
	$mOnEventMode = True
EndIf

#Region Metro Functions Overview
;========================================MAIN GUI==================================================
;_Metro_CreateGUI 			  - Creates a borderless Metro-Style GUI
;_SetTheme					  - Sets the GUI color scheme from the included MetroThemes.au3
;_Metro_AddControlButtons	  - Adds the selected control buttons to the gui. (Close,Maximize,Minimize,Fullscreen Toogle, Menu button)
;_Metro_GUIDelete			  - Destroys all created metro buttons,checkboxes,radios etc., deletes the GUI and reduces memory usage.
;_Metro_EnableHighDPIScaling  - Enables high DPI support: Detects the users DPI settings and resizes GUI and all controls to look perfectly sharp.
;_Metro_EnableOnEventMode - Allows using the MetroUDF with OnEventMode enabled
;_Metro_SetGUIOption    	  - Allows to set different options like dragmove, resize and min. resize width/height.
;_Metro_FullscreenToggle 	  - Toggles between fullscreen and normal window. NOTE: $AllowResize has to be set True when creating a gui and this also requires the creation of a fullscreen control button.
;_Metro_AddControlButton_Back - Creates a back button on the left+top side of the gui.
;_Metro_MenuStart 			  	- Shows/creates a menu window that slides in from the right side of the gui. (Similar to Android menus or Windows 10 calculator app)
;_Metro_RightClickMenu		- Shows/creates a rightclick menu window with the provided button names.

;==========================================Buttons=================================================
;_Metro_CreateButton   - Creates metro style buttons. Hovering creates a frame around the buttons.
;_Metro_CreateButtonEx - Creates Windows 10 style buttons with a frame around. Hovering changes the button color to a lighter color.
;_Metro_CreateButtonEx2 - Creates a button with slightly rounded corners and no frame. Hovering changes the button color to a lighter color.
;_Metro_DisableButton  - Disables a metro button and adds a grayed out look to it.
;_Metro_EnableButton   - Enables a metro button and removes grayed out look of it.

;==========================================Toggles=================================================
;_Metro_CreateToggle - Creates a Windows 10 style toggle with a text on the right side.(NEW Style)
;_Metro_CreateToggleEx - Creates a Windows 8 style toggle with a text on the right side.
;_Metro_ToggleIsChecked - Checks if a toggle is checked or not. Returns True or False.
;_Metro_ToggleCheck - Checks/Enables a toggle.
;_Metro_ToggleUnCheck - Unchecks/Disables a toggle.
;_Metro_ToggleSwitch - Toggles between checked/unchecked state and then returns the current state.  -> Should only be used to handle user clicks

;===========================================Radios=================================================
;_Metro_CreateRadio - Creates a metro style radio.
;_Metro_CreateRadioEx - Creates a metro style radio with colored checkmark.
;_Metro_RadioCheck - Checks the selected radio and unchecks all other radios in the selected group.
;_Metro_RadioIsChecked - Checks if the radio in a specific group is selected.

;==========================================Checkboxes==============================================
;_Metro_CreateCheckbox - Creates a modern looking checkbox.
;_Metro_CreateCheckboxEx - Creates a classic-style checkbox with the default black white colors.
;_Metro_CreateCheckboxEx2 - Creates a modern rounded checkbox.
;_Metro_CheckboxIsChecked - Checks if a checkbox is checked. Returns True or False.
;_Metro_CheckboxCheck - Checks a checkbox.
;_Metro_CheckboxUncheck - Unchecks a checkbox.
; Metro_CheckboxSwitch - Toggles between checked/unchecked state and then returns the current state.  -> Should only be used to handle user clicks

;=============================================MsgBox===============================================
;_Metro_MsgBox - Creates a MsgBox with a OK button and displays the text. _GUIDisable($GUI, 0, 30) should be used before, so the MsgBox is better visible and afterwards _GUIDisable($GUI).

;=============================================Progress=============================================
;_Metro_CreateProgress - Creates a simple progressbar.
;_Metro_SetProgress - Sets the progress in % of a progressbar.

;=============================================Other=============================================
; _Metro_InputBox - Creates a simple modern input box
; _Metro_AddHSeperator - Adds a horizontal seperator line to the GUI
; _Metro_AddVSeperator - Adds a vertical seperator line to the GUI

#EndRegion Metro Functions Overview


#Region MetroGUI===========================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateGUI
; Description ...: Creates a modern borderless GUI with the colors of the selected theme.
; Syntax ........: _Metro_CreateGUI($Title, $Width, $Height[, $Left = -1[, $Top = -1[, $AllowResize = False[, $ParentGUI = ""]]]])
; Parameters ....: $Title               - Title of the window
;                  $Width               - Width
;                  $Height              - Height
;                  $Left                - [optional] Window pos X. Default is -1.
;                  $Top                 - [optional] Window pos Y. Default is -1.
;                  $AllowResize         - [optional] True/False. Default is False. ;Enables resizing + drag move for the gui.
;                  $ParentGUI           - [optional] Handle to the parent gui. Default is "".
; Return values .: Handle to the created gui
; Example .......: _Metro_CreateGUI("Example", 500, 300, -1, -1, True)
; ===============================================================================================================================
Func _Metro_CreateGUI($Title, $Width, $Height, $Left = -1, $Top = -1, $AllowResize = False, $ParentGUI = "")
	Local $GUI_Return

	;HighDPI Support
	If $HIGHDPI_SUPPORT Then
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
	EndIf
	Local $gID
	If $AllowResize Then
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0) ;Adds compatibility for Windows 7 Basic theme
		$GUI_Return = GUICreate($Title, $Width, $Height, $Left, $Top, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX), -1, $ParentGUI)
		$gID = _Metro_SetGUIOption($GUI_Return, True, True, $Width, $Height)
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", BitOR(1, 2, 4))
	Else
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0) ;Adds compatibility for Windows 7 Basic theme
		$GUI_Return = GUICreate($Title, $Width, $Height, $Left, $Top, -1, -1, $ParentGUI)
		$gID = _Metro_SetGUIOption($GUI_Return, False, False, $Width, $Height)
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", BitOR(1, 2, 4))
	EndIf
	_WinAPI_SetWindowSubclass($GUI_Return, $m_pDll, 1010, $gID)
	WinMove($GUI_Return, "", Default, Default, $Width, $Height)

	
	If Not $ParentGUI Then
		Local $Center_GUI = _GetDesktopWorkArea($GUI_Return)
		If ($Left = -1) And ($Top = -1) Then
			WinMove($GUI_Return, "", ($Center_GUI[2] - $Width) / 2, ($Center_GUI[3] - $Height) / 2, $Width, $Height)
		EndIf
	Else
		If ($Left = -1) And ($Top = -1) Then
			Local $GUI_NewPos = _WinPos($ParentGUI, $Width, $Height)
			WinMove($GUI_Return, "", $GUI_NewPos[0], $GUI_NewPos[1], $Width, $Height)
		EndIf
	EndIf

	GUISetBkColor($GUIThemeColor)
	
	_CreateBorder($GUI_Return, $Width, $Height, $GUIBorderColor)

	Return ($GUI_Return)
EndFunc   ;==>_Metro_CreateGUI

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_SetGUIOption
; Description ...: Allows to set different options like dragmove, resize and min. resize width/height.
; Syntax ........: _Metro_SetGUIOption($mGUI[, $AllowDragMove = False[, $AllowResize = False[, $Win_MinWidth = ""[,
;                  $Win_MinHeight = ""]]]])
; Parameters ....: $mGUI                - a map.
;                  $AllowDragMove       - [optional] Allow dragmove (Moving GUI by holding leftclick). Default is False.
;                  $AllowResize         - [optional] Allow resizing of the GUI. Default is False.
;                  $Win_MinWidth        - [optional] Min. width of the GUI in px (For resizing). Default is "".
;                  $Win_MinHeight       - [optional] Min. height of the GUI in px(For resizing). Default is "".
; Example .......: _Metro_SetGUIOption($Form1, True, True, 400, 300)
; ===============================================================================================================================
Func _Metro_SetGUIOption($mGUI, $AllowDragMove = False, $AllowResize = False, $Win_MinWidth = "", $Win_MinHeight = "")
	Local $iGui_Count
	;Check if Gui is already registered
	For $iGUIs = 0 To UBound($iGUI_LIST) - 1 Step +1
		If $iGUI_LIST[$iGUIs][0] = $mGUI Then
			$iGui_Count = $iGUIs
			ExitLoop
		EndIf
	Next

	If ($iGui_Count == "") Then
		$iGui_Count = UBound($iGUI_LIST)
		ReDim $iGUI_LIST[$iGui_Count + 1][16]
	EndIf
	
	$iGUI_LIST[$iGui_Count][0] = $mGUI
	$iGUI_LIST[$iGui_Count][1] = $AllowDragMove ;Drag
	$iGUI_LIST[$iGui_Count][2] = $AllowResize ;Resize
	
	If $AllowResize Then
		If $Win_MinWidth = "" Then
			$Win_MinWidth = WinGetPos($mGUI, "")
			If @error Then
				$Win_MinWidth = 80 * $gDPI
			Else
				$Win_MinWidth = $Win_MinWidth[2]
			EndIf
		EndIf
		If $Win_MinHeight = "" Then
			$Win_MinHeight = WinGetPos($mGUI, "")
			If @error Then
				$Win_MinHeight = 50 * $gDPI
			Else
				$Win_MinHeight = $Win_MinHeight[3]
			EndIf
		EndIf
		$iGUI_LIST[$iGui_Count][3] = $Win_MinWidth ;Set Min Width of the Window
		$iGUI_LIST[$iGui_Count][4] = $Win_MinHeight ;Set Min Height of the Window
	EndIf

	Return $iGui_Count
EndFunc   ;==>_Metro_SetGUIOption


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_GUIDelete
; Description ...: Destroys all created metro buttons,checkboxes,radios etc., deletes the GUI and reduces memory usage.
; Syntax ........: _Metro_GUIDelete($GUI)
; Parameters ....:  $GUI  - Handle to the gui to be deleted
; ===============================================================================================================================
Func _Metro_GUIDelete($GUI)
	GUISetState(@SW_HIDE, $GUI) ;To prevent visible delay when the gui is being deleted
	_WinAPI_RemoveWindowSubclass($GUI, $m_pDll, 1010)
	GUIDelete($GUI)
	
	;Remove from Global GUI List
	Local $CLEANED_GUI_LIST[0]
	For $i_HR = 0 To UBound($iGUI_LIST) - 1 Step +1
		If $iGUI_LIST[$i_HR][0] <> $GUI Then
			ReDim $CLEANED_GUI_LIST[UBound($CLEANED_GUI_LIST) + 1][16]
			For $i_Hx = 0 To 11 Step +1
				$CLEANED_GUI_LIST[UBound($CLEANED_GUI_LIST) - 1][$i_Hx] = $iGUI_LIST[$i_HR][$i_Hx]
			Next
		EndIf
	Next
	$iGUI_LIST = $CLEANED_GUI_LIST

;~ 	_ReduceMemory()
EndFunc   ;==>_Metro_GUIDelete


; #FUNCTION# ====================================================================================================================
; Name ..........: _iControlDelete
; Description ...:  Internal function that will free resources and remove the control from the Hover REG
; Syntax ........: _iControlDelete($hControl)
; Parameters ....: $hControl            - a handle value.
; ===============================================================================================================================
Func _iControlDelete($hControl)

	For $i = 0 To UBound($iHoverReg) - 1
		If $iHoverReg[$i][0] = $hControl Then
			Switch ($iHoverReg[$i][3])
				Case "5", "7"
					_WinAPI_DeleteObject($iHoverReg[$i][5])
					_WinAPI_DeleteObject($iHoverReg[$i][6])
					_WinAPI_DeleteObject($iHoverReg[$i][7])
					_WinAPI_DeleteObject($iHoverReg[$i][8])
				Case "6"
					_WinAPI_DeleteObject($iHoverReg[$i][5])
					_WinAPI_DeleteObject($iHoverReg[$i][6])
					_WinAPI_DeleteObject($iHoverReg[$i][7])
					_WinAPI_DeleteObject($iHoverReg[$i][8])
					_WinAPI_DeleteObject($iHoverReg[$i][9])
					_WinAPI_DeleteObject($iHoverReg[$i][10])
					_WinAPI_DeleteObject($iHoverReg[$i][11])
					_WinAPI_DeleteObject($iHoverReg[$i][12])
					_WinAPI_DeleteObject($iHoverReg[$i][13])
					_WinAPI_DeleteObject($iHoverReg[$i][14])
				Case Else
					_WinAPI_DeleteObject($iHoverReg[$i][5])
					_WinAPI_DeleteObject($iHoverReg[$i][6])
			EndSwitch
			;Empty array index
			For $i2 = 0 To UBound($iHoverReg, 2) - 1
				$iHoverReg[$i][$i2] = ""
			Next
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_iControlDelete



; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_AddControlButtons
; Description ...: Creates the selected control buttons for a metro style gui.
; Syntax ........: _Metro_AddControlButtons([$CloseBtn = True[, $MaximizeBtn = True[, $MinimizeBtn = True[, $FullScreenBtn = True[,
;                  $MenuBtn = False]]]]])
; Parameters ....: $CloseBtn            - [optional] True/False. Default is True. ;Adds a close button
;                  $MaximizeBtn         - [optional] True/False. Default is True. ;Adds a maximize/restore button
;                  $MinimizeBtn         - [optional] True/False. Default is True. ;Adds a minimize button
;                  $FullScreenBtn       - [optional] True/False. Default is True. ;Adds a fullscreen toggle button
;                  $MenuBtn             - [optional] True/False. Default is False.;Adds a Menu Button that can be used with _Metro_MenuStart

;                  $GUI_BG_Color        - [optional] Custom color for the background of the buttons. Example: "0x000000", Default is $GUIThemeColor of the selected theme
;                  $GUI_Font_Color      - [optional] Custom color for the text color of the buttons. Example: "0xFFFFFF", Default is $FontThemeColor of the selected theme
; Return values .: Array with size 7 that contains all handles of the created control buttons. Note: Array size is always the same and so is the order of the handles even if not all buttons are created. See below:
;				   Array[0] = Close button
;				   Array[1] = Maximize button
;				   Array[2] = Restore button
;				   Array[3] = Minimize button
;				   Array[4] = Fullscreen ON button
;				   Array[5] = Fullscreen OFF button
;				   Array[6] = Menu button
; Example .......: _Metro_AddControlButtons(True, True, True, True, True)
; ===============================================================================================================================
Func _Metro_AddControlButtons($CloseBtn = True, $MaximizeBtn = True, $MinimizeBtn = True, $FullScreenBtn = False, $MenuBtn = False, $GUI_BG_Color = $GUIThemeColor, $GUI_Font_Color = $FontThemeColor, $tMargin = 2)
	Local $ButtonsToCreate_Array[5]
	$ButtonsToCreate_Array[0] = $CloseBtn
	$ButtonsToCreate_Array[1] = $MaximizeBtn
	$ButtonsToCreate_Array[2] = $MinimizeBtn
	$ButtonsToCreate_Array[3] = $FullScreenBtn
	$ButtonsToCreate_Array[4] = $MenuBtn
	
	$GUI_BG_Color = "0xFF" & Hex($GUI_BG_Color, 6)
	$GUI_Font_Color = "0xFF" & Hex($GUI_Font_Color, 6)

	Return _iCreateControlButtons($ButtonsToCreate_Array, $GUI_BG_Color, $GUI_Font_Color, False, $tMargin)
EndFunc   ;==>_Metro_AddControlButtons

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_EnableHighDPIScaling
; Description ...: Enables high DPI support: Detects the users DPI settings and resizes GUI and all controls to look perfectly sharp
; Syntax ........: _Metro_EnableHighDPIScaling()
; ===============================================================================================================================
Func _Metro_EnableHighDPIScaling($Enable = True)
	$HIGHDPI_SUPPORT = $Enable
EndFunc   ;==>_Metro_EnableHighDPIScaling

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_EnableOnEventMode
; Description ...: Allows using the UDF with OnEventMode enabled.
; Syntax ........: _Metro_EnableOnEventMode([$Enable = True])
; ===============================================================================================================================
Func _Metro_EnableOnEventMode($Enable = True)
	$mOnEventMode = $Enable
EndFunc   ;==>_Metro_EnableOnEventMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_FullscreenToggle
; Description ...: Toggles between fullscreen and normal window. NOTE: $AllowResize has to be set True when creating a gui and this also requires the creation of a fullscreen control button.
; Syntax ........: _Metro_FullscreenToggle($mGUI, $Control_Buttons_Array)
; Parameters ....: $mGUI                  - Handle to the GUI.
;                  $Control_Buttons_Array - Array containing the control button handles as returned from _Metro_AddControlButtons.
; Note2 .........: Fullscreen toggle only works with ONE gui at the same time. You can't create 2 Guis which are toggled to fullscreen at the same time. They will interfere with each other.
; ===============================================================================================================================
Func _Metro_FullscreenToggle($mGUI)
	GUISetState(@SW_SHOW, $mGUI) ;Fixes a bug that occurs when using multiple child windows
	Local $iGui_Count = _iGetGUIID($mGUI)

	If ($iGui_Count == "") Then
		ConsoleWrite("Fullscreen-Toggle failed: GUI not registered. Not created with _Metro_CreateGUI ?" & @CRLF)
		Return SetError(1) ;
	EndIf
	If Not $iGUI_LIST[$iGui_Count][2] Then
		ConsoleWrite("Fullscreen-Toggle failed: GUI is not registered for resizing. Please use _Metro_SetGUIOption to enable resizing." & @CRLF)
		Return SetError(2) ;
	EndIf
	
	Local $mWin_State = WinGetState($mGUI)
	Local $tRET = _WinAPI_GetWindowPlacement($mGUI)
	Local $FullScreenPOS = _GetDesktopWorkArea($mGUI, True)
	Local $CurrentPos = WinGetPos($mGUI)
	
	Local $MaxBtn = _iGetCtrlHandlebyType("3", $mGUI)
	Local $RestoreBtn = _iGetCtrlHandlebyType("4", $mGUI)
	Local $FullScreenBtn = _iGetCtrlHandlebyType("9", $mGUI)
	Local $FullscreenRsBtn = _iGetCtrlHandlebyType("10", $mGUI)


	If $iGUI_LIST[$iGui_Count][11] Then ;Already in fullscreen -> Restore
		$iGUI_LIST[$iGui_Count][11] = False ;Remove fullscreen state
		If (BitAND($iGUI_LIST[$iGui_Count][9], 32) = 32) Then ; If previous state was maximized
			GUISetState(@SW_MAXIMIZE)
			$tRET = $iGUI_LIST[$iGui_Count][10]
			DllStructSetData($tRET, "rcNormalPosition", $iGUI_LIST[$iGui_Count][5], 1) ; left
			DllStructSetData($tRET, "rcNormalPosition", $iGUI_LIST[$iGui_Count][6], 2) ; top
			DllStructSetData($tRET, "rcNormalPosition", $iGUI_LIST[$iGui_Count][7], 3) ; right
			DllStructSetData($tRET, "rcNormalPosition", $iGUI_LIST[$iGui_Count][8], 4) ; bottom
			_WinAPI_SetWindowPlacement($mGUI, $tRET)
			If $MaxBtn Then
				GUICtrlSetState($MaxBtn, 32)
				GUICtrlSetState($RestoreBtn, 16)
			EndIf
		Else
			WinMove($mGUI, "", $iGUI_LIST[$iGui_Count][5], $iGUI_LIST[$iGui_Count][6], $iGUI_LIST[$iGui_Count][7], $iGUI_LIST[$iGui_Count][8])
			If $MaxBtn Then
				GUICtrlSetState($RestoreBtn, 32)
				GUICtrlSetState($MaxBtn, 16)
			EndIf
		EndIf

		GUICtrlSetState($FullscreenRsBtn, 32)
		GUICtrlSetState($FullScreenBtn, 16)
		
	Else ;Not in fullscreen mode -> Enter fullscreen mode
		
		If (BitAND($mWin_State, 32) = 32) Then ; If window is maximized
			;Replace array with current window position with the currently saved restore/normal position
			$CurrentPos[0] = DllStructGetData($tRET, "rcNormalPosition", 1)
			$CurrentPos[1] = DllStructGetData($tRET, "rcNormalPosition", 2)
			$CurrentPos[2] = DllStructGetData($tRET, "rcNormalPosition", 3)
			$CurrentPos[3] = DllStructGetData($tRET, "rcNormalPosition", 4)

			;Set new fullscreen position
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[0], 1) ; left
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[1], 2) ; top
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[0] + $FullScreenPOS[2], 3) ; right
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[1] + $FullScreenPOS[3], 4) ; bottom
			_WinAPI_SetWindowPlacement($mGUI, $tRET)
			Sleep(50)
			$iGUI_LIST[$iGui_Count][10] = $tRET
			GUISetState(@SW_RESTORE)
		Else
			Sleep(50)
			WinMove($mGUI, "", $FullScreenPOS[0], $FullScreenPOS[1], $FullScreenPOS[2], $FullScreenPOS[3])
		EndIf
		$iGUI_LIST[$iGui_Count][11] = True ;Fullscreen state
		GUICtrlSetState($FullScreenBtn, 32)
		If $MaxBtn Then
			GUICtrlSetState($MaxBtn, 32)
			GUICtrlSetState($RestoreBtn, 32)
		EndIf
		GUICtrlSetState($FullscreenRsBtn, 16)
		$iGUI_LIST[$iGui_Count][5] = $CurrentPos[0]
		$iGUI_LIST[$iGui_Count][6] = $CurrentPos[1]
		$iGUI_LIST[$iGui_Count][7] = $CurrentPos[2]
		$iGUI_LIST[$iGui_Count][8] = $CurrentPos[3]
		$iGUI_LIST[$iGui_Count][9] = $mWin_State
		;Workaround for the Windows 10 bug(or feature as MS would call it) that causes the taskbar to be on top of the GUI even when it is in fullscreen mode (Thx @MS for breaking stuff with every update)
		WinActivate("[CLASS:Shell_TrayWnd]")
		WinActivate($mGUI)

	EndIf
EndFunc   ;==>_Metro_FullscreenToggle



; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_AddControlButton_Back
; Description ...: Creates a back button on the left+top side of the gui.
; Syntax ........: _Metro_AddControlButton_Back([, $GUI_BG_Color = $GUIThemeColor[, $GUI_Font_Color = $FontThemeColor]])
; Parameters ....: $GUI_BG_Color        - [optional] Background color. Default is $GUIThemeColor.
;                  $GUI_Font_Color      - [optional] Text color. Default is $FontThemeColor.
; Return values .: Handle to the button
; Remarks .......: If a menu control button is visible, then it has to be hidden first before showing this button, as they are on the same position.
; Example .......: _Metro_AddControlButton_Back()
; ===============================================================================================================================
Func _Metro_AddControlButton_Back($GUI_BG_Color = $GUIThemeColor, $GUI_Font_Color = $FontThemeColor, $tMargin = 2)
	Local $cbDPI = _HighDPICheck()
	Local $CurrentGUI = GetCurrentGUI()
	
	;Set Colors
	$GUI_BG_Color = "0xFF" & Hex($GUI_BG_Color, 6)
	$GUI_Font_Color = "0xFF" & Hex($GUI_Font_Color, 6)
	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $Hover_BK_Color = StringReplace(_AlterBrightness($GUI_BG_Color, -20), "0x", "0xFF")
	Else
		Local $Hover_BK_Color = StringReplace(_AlterBrightness($GUI_BG_Color, +20), "0x", "0xFF")
	EndIf

	Local $FrameSize = Round(1 * $cbDPI)
	Local $hPen = _GDIPlus_PenCreate($GUI_Font_Color, Round(1 * $cbDPI))
	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $hPen1 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUI_Font_Color, +60), "0x", "0xFF"), Round(1 * $cbDPI)) ;inactive
	Else
		Local $hPen1 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUI_Font_Color, -80), "0x", "0xFF"), Round(1 * $cbDPI)) ;inactive
	EndIf
	_GDIPlus_PenSetStartCap($hPen, 0x03)
	_GDIPlus_PenSetStartCap($hPen1, 0x03)
	;Create Button Array
	Local $Control_Button_Array[16]

	;Calc Sizes
	Local $CBw = Number(45 * $cbDPI, 1)
	Local $CBh = Number(29 * $cbDPI, 1)
	Local $cMarginR = Number($tMargin * $cbDPI, 1)

	;Create GuiPics and set hover states
	
	$Control_Button_Array[1] = False ; Hover state
	$Control_Button_Array[2] = False ; Set inactive state
	$Control_Button_Array[3] = "0" ; Type
	$Control_Button_Array[15] = GetCurrentGUI()

	;Create Graphics
	Local $Control_Button_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
	Local $Control_Button_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4)
	Local $Control_Button_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)

	;Create Back Button

	;Calc size+pos
	Local $mpX = $CBw / 2.95, $mpY = $CBh / 2.1
	Local $apos1 = cAngle($mpX, $mpY, 135, 12 * $cbDPI)
	Local $apos2 = cAngle($mpX, $mpY, 45, 12 * $cbDPI)

	;Add arrow
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic1[0], $mpX, $mpY, $apos1[0], $apos1[1], $hPen) ;r
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic1[0], $mpX, $mpY, $apos2[0], $apos2[1], $hPen) ;l

	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic2[0], $mpX, $mpY, $apos1[0], $apos1[1], $hPen) ;r
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic2[0], $mpX, $mpY, $apos2[0], $apos2[1], $hPen) ;l

	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic3[0], $mpX, $mpY, $apos1[0], $apos1[1], $hPen1) ;r
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic3[0], $mpX, $mpY, $apos2[0], $apos2[1], $hPen1) ;l
	
	;Release resources
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen1)

	;Create bitmap handles and set graphic
	$Control_Button_Array[0] = GUICtrlCreatePic("", $cMarginR, $cMarginR, $CBw, $CBh)
	$Control_Button_Array[5] = _iGraphicCreateBitmapHandle($Control_Button_Array[0], $Control_Button_Graphic1)
	$Control_Button_Array[6] = _iGraphicCreateBitmapHandle($Control_Button_Array[0], $Control_Button_Graphic2, False)
	$Control_Button_Array[7] = _iGraphicCreateBitmapHandle($Control_Button_Array[0], $Control_Button_Graphic3, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Control_Button_Array[0], 768 + 32 + 2)

	_cHvr_Register($Control_Button_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Control_Button_Array), $CurrentGUI)
	Return $Control_Button_Array[0]
EndFunc   ;==>_Metro_AddControlButton_Back




; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_MenuStart
; Description ...: Shows/creates a menu window that slides in from the right side of the gui. (Similar to Android menus or Windows 10 calculator app)
; Syntax ........: _Metro_MenuStart($mGUI, $Metro_MenuBtn, $mWidth, $ButtonsArray)
; Parameters ....: $mGUI                - Handle to the gui.
;                  $Metro_MenuBtn       - Handle to the menu button that is returned by _Metro_AddControlButtons. (this would be $Array[6] returned by _Metro_AddControlButtons function)
;                  $mWidth              - Width of the Menu
;                  $ButtonsArray        - An array containing button names to be created.
;                                         Example: Local $MenuButtonsArray[4] = ["Settings","About","Contact","Exit"] ; id 0 = Settings, 1 = About, 2 = Contact, 3 = Exit
;                  $bFont               - [optional] Custom font for the buttons. Default "Arial"
;                  $bFontSize           - [optional] Custom font size for the buttons. Default 9
;                  $bFontStyle          - [optional] Custom font style for the buttons. Default 1
; Return values .: index of the clicked button from $ButtonsArray or @error and value "none" if nothing is clicked. Example: Users selects "Exit" button in the menu, so this function would return "3".
; ===============================================================================================================================
Func _Metro_MenuStart($mGUI, $mWidth, $ButtonsArray, $bFont = "Segoe UI", $bFontSize = 9, $bFontStyle = 0)
	Local $Metro_MenuBtn = _iGetCtrlHandlebyType("8", $mGUI)
	If Not $Metro_MenuBtn Then Return SetError(1)
	GUICtrlSetState($Metro_MenuBtn, 128)

	Local $iButtonsArray[UBound($ButtonsArray)]
	Local $cbDPI = _HighDPICheck()

	Local $blockclose = True
	Local $mPos = WinGetPos($mGUI)
	Local $cMarginR = Number(2 * $cbDPI, 1)
	Local $CBh = Number(29 * $cbDPI, 1)
	Local $mGuiHeight = $mPos[3] - ($cMarginR * 2) - $CBh
	Local $mGuiWidth = $mWidth * $cbDPI
	Local $mGuiX = $mPos[0] + $cMarginR, $mGuiY = $mPos[1] + $cMarginR + $CBh
	Local $AnimStep = $mGuiWidth / 10, $mGuiWidthAnim = $AnimStep
	Local $MenuForm = GUICreate("", $mGuiWidthAnim, $mGuiHeight, $mGuiX, $mGuiY, $WS_POPUP, $WS_EX_MDICHILD, $mGUI)
	Local $ButtonStep = (30 * $cbDPI)
	If StringInStr($GUI_Theme_Name, "Light") Then
		GUISetBkColor(_AlterBrightness($GUIThemeColor, -10), $MenuForm)
	Else
		GUISetBkColor(_AlterBrightness($GUIThemeColor, +10), $MenuForm)
	EndIf
	For $iB = 0 To UBound($ButtonsArray) - 1 Step +1
		$iButtonsArray[$iB] = _iCreateMButton($ButtonsArray[$iB], 0, $ButtonStep * $iB + ($iB * 2), $mGuiWidth - $cMarginR, 30 * $cbDPI, $GUIThemeColor, $FontThemeColor, $bFont, $bFontSize, $bFontStyle)
	Next

	GUISetState(@SW_SHOW, $MenuForm)

	For $i = 0 To 8 Step +1
		$mGuiWidthAnim = $mGuiWidthAnim + $AnimStep
		WinMove($MenuForm, "", $mGuiX, $mGuiY, $mGuiWidthAnim, $mGuiHeight)
		Sleep(1)
	Next

	If $mOnEventMode Then Opt("GUIOnEventMode", 0) ;Temporarily deactivate oneventmode
	
	While 1
		If Not $blockclose Then
			If Not WinActive($MenuForm) Then
				$mPos = WinGetPos($mGUI)
				$mGuiX = $mPos[0] + $cMarginR
				$mGuiY = $mPos[1] + $cMarginR + $CBh
				For $i = 0 To 8 Step +1
					$mGuiWidthAnim = $mGuiWidthAnim - $AnimStep
					WinMove($MenuForm, "", $mGuiX, $mGuiY, $mGuiWidthAnim, $mGuiHeight)
					Sleep(1)
				Next
				GUIDelete($MenuForm)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;reactivate oneventmode
				GUICtrlSetState($Metro_MenuBtn, 64)
				Return SetError(1, 0, "none")
			EndIf
		Else
			$blockclose = False
		EndIf
		Local $imsg = GUIGetMsg()
		For $iB = 0 To UBound($iButtonsArray) - 1 Step +1
			If $imsg = $iButtonsArray[$iB] Then
				$mPos = WinGetPos($mGUI)
				$mGuiX = $mPos[0] + $cMarginR
				$mGuiY = $mPos[1] + $cMarginR + $CBh
				For $if = 0 To 8 Step +2
					$mGuiWidthAnim = $mGuiWidthAnim - $AnimStep
					WinMove($MenuForm, "", $mGuiX, $mGuiY, $mGuiWidthAnim, $mGuiHeight)
					Sleep(1)
				Next
				GUIDelete($MenuForm)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;reactivate oneventmode
				GUICtrlSetState($Metro_MenuBtn, 64)
				Return $iB
			EndIf
		Next
	WEnd

EndFunc   ;==>_Metro_MenuStart


Func _iCreateMButton($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Arial", $Fontsize = 9, $FontStyle = 1)
	Local $Button_Array[16]

	If Not $HIGHDPI_SUPPORT Then
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	$Button_Array[1] = False ; Set hover OFF
	$Button_Array[3] = "2" ; Type
	$Button_Array[15] = GetCurrentGUI()

	;Set Colors
	$BG_Color = StringReplace($BG_Color, "0x", "0xFF")
	$Font_Color = StringReplace($Font_Color, "0x", "0xFF")
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)

	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $BG_ColorD = StringReplace(_AlterBrightness($GUIThemeColor, -12), "0x", "0xFF")
		$BG_Color = StringReplace(_AlterBrightness($GUIThemeColor, -25), "0x", "0xFF")
	Else
		Local $BG_ColorD = StringReplace(_AlterBrightness($GUIThemeColor, +12), "0x", "0xFF")
		$BG_Color = StringReplace(_AlterBrightness($GUIThemeColor, +25), "0x", "0xFF")
	EndIf

	;Create Button graphics
	Local $Button_Graphic1 = _iGraphicCreate($Width, $Height, $BG_ColorD, 0, 5) ;Default
	Local $Button_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5) ;Hover

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate(0, 0, $Width, $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)

	;Draw button text
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)

	;Set graphic and return Bitmap handle
	$Button_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Button_Array[5] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)

	;For GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 802)
	_cHvr_Register($Button_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Array))
	Return $Button_Array[0]
EndFunc   ;==>_iCreateMButton



Func _Metro_RightClickMenu($mGUI, $mWidth, $ButtonsArray, $bFont = "Segoe UI", $bFontSize = 9, $bFontStyle = 0)
	Local $mPos = MouseGetPos()
	Local $iButtonsArray[UBound($ButtonsArray)]
	Local $cbDPI = _HighDPICheck()
	Local $ButtonStep = (25 * $cbDPI)
	Local $cMarginR = Number(2 * $cbDPI, 1)
	
	Local $DesktopSize = _GetDesktopWorkArea($mGUI, False)
	If @error Then Return
	;Fix position if  it is offscreen
	Local $mHeight = UBound($ButtonsArray) * $ButtonStep + (2 * UBound($ButtonsArray))
	If $mPos[0] + $mWidth > $DesktopSize[2] Then
		$mPos[0] = $mPos[0] - ($mPos[0] + $mWidth - $DesktopSize[2] + 2)
	EndIf
	If $mPos[1] + $mHeight > $DesktopSize[3] Then
		$mPos[1] = $mPos[1] - ($mPos[1] + $mHeight - $DesktopSize[3] + 2)
	EndIf
	Local $MenuForm = GUICreate("", $mWidth, $mHeight, $mPos[0], $mPos[1], $WS_POPUP, 0, $mGUI)

	If StringInStr($GUI_Theme_Name, "Light") Then
		GUISetBkColor(_AlterBrightness($GUIThemeColor, -10), $MenuForm)
	Else
		GUISetBkColor(_AlterBrightness($GUIThemeColor, +10), $MenuForm)
	EndIf
	For $iB = 0 To UBound($ButtonsArray) - 1 Step +1
		$iButtonsArray[$iB] = _iCreateMButton($ButtonsArray[$iB], $cMarginR / 2, $ButtonStep * $iB + ($iB * 2), $mWidth - $cMarginR, $ButtonStep, $GUIThemeColor, $FontThemeColor, $bFont, $bFontSize, $bFontStyle)
	Next
	GUISetState(@SW_SHOW, $MenuForm)
	
	If $mOnEventMode Then Opt("GUIOnEventMode", 0) ;Temporarily disable oneventmode

	While 1
		If Not WinActive($MenuForm) Then
			GUIDelete($MenuForm)
			If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;reactivate oneventmode
			Return SetError(1, 0, "none")
		EndIf
		Local $imsg = GUIGetMsg()
		For $iB = 0 To UBound($iButtonsArray) - 1 Step +1
			If $imsg = $iButtonsArray[$iB] Then
				GUIDelete($MenuForm)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;reactivate oneventmode
				Return $iB
			EndIf
		Next
	WEnd
EndFunc   ;==>_Metro_RightClickMenu






Func _iCreateControlButtons($ButtonsToCreate_Array, $GUI_BG_Color = $GUIThemeColor, $GUI_Font_Color = "0xFFFFFF", $CloseButtonOnStyle = False, $tMargin = 2)
	;HighDPI Support
	Local $cbDPI = _HighDPICheck()

	;Set Colors
	;=========================================================================
	Local $FrameSize = Round(1 * $cbDPI), $Hover_BK_Color

	If StringInStr($GUI_Theme_Name, "Light") Then
		$Hover_BK_Color = StringReplace(_AlterBrightness($GUI_BG_Color, -20), "0x", "0xFF")
	Else
		$Hover_BK_Color = StringReplace(_AlterBrightness($GUI_BG_Color, +20), "0x", "0xFF")
	EndIf
	Local $hPen = _GDIPlus_PenCreate($GUI_Font_Color, Round(1 * $cbDPI))
	Local $hPen2 = _GDIPlus_PenCreate($GUI_Font_Color, Round(1 * $cbDPI))
	Local $hPen3 = _GDIPlus_PenCreate("0xFFFFFFFF", Round(1 * $cbDPI))
	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $hPen4 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUI_Font_Color, +90), "0x", "0xFF"), $FrameSize) ;inactive
	Else
		Local $hPen4 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUI_Font_Color, -80), "0x", "0xFF"), $FrameSize) ;inactive
	EndIf
	Local $hPen5 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness("0xFFFFFF", -80), "0x", "0xFF"), $FrameSize) ;inactive style 2
	
	If $GUI_BG_Color <> 0 Then
		$GUI_BG_Color = "0xFF" & Hex($GUI_BG_Color, 6)
	EndIf
	Local $hBrush = _GDIPlus_BrushCreateSolid($GUI_BG_Color), $hBrush2 = _GDIPlus_BrushCreateSolid($Hover_BK_Color)

	;=========================================================================

	;Create Button Arrays
	Local $Control_Buttons[16]
	Local $Button_Close_Array[16]
	Local $Button_Minimize_Array[16]
	Local $Button_Maximize_Array[16]
	Local $Button_Restore_Array[16]
	Local $Button_Menu_Array[16]
	Local $Button_FullScreen_Array[16]
	Local $Button_FSRestore_Array[16]

	;Calc Sizes
	Local $CBw = Number(45 * $cbDPI, 1)
	Local $CBh = Number(29 * $cbDPI, 1)
	Local $cMarginR = Number($tMargin * $cbDPI, 1)
	Local $CurrentGUI = GetCurrentGUI()

	Local $Win_POS = WinGetPos($CurrentGUI)
	Local $PosCount = 0

	;Create GuiPics and set hover states
	If $ButtonsToCreate_Array[0] Then
		$PosCount = $PosCount + 1
		$Button_Close_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		$Button_Close_Array[1] = False ; Hover state
		$Button_Close_Array[2] = False ; Inactive Color state
		$Button_Close_Array[3] = "0" ; Type
		$Button_Close_Array[15] = $CurrentGUI
	EndIf



	If $ButtonsToCreate_Array[1] Then
		$PosCount = $PosCount + 1
		$Button_Maximize_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		$Button_Maximize_Array[1] = False
		$Button_Maximize_Array[2] = False ; Inactive Color state
		$Button_Maximize_Array[3] = "3"
		$Button_Maximize_Array[8] = True ;Visible state
		$Button_Maximize_Array[15] = $CurrentGUI

		$Button_Restore_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		$Button_Restore_Array[1] = False
		$Button_Restore_Array[2] = False ;Inactive Color state
		$Button_Restore_Array[3] = "4"
		$Button_Restore_Array[8] = True ;Visible state
		$Button_Restore_Array[15] = $CurrentGUI
		If $ButtonsToCreate_Array[3] Then
			$Button_FSRestore_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
			$Button_FSRestore_Array[1] = False
			$Button_FSRestore_Array[2] = False ; Inactive Color state
			$Button_FSRestore_Array[3] = "10"
			$Button_FSRestore_Array[15] = $CurrentGUI
		EndIf
	EndIf

	If $ButtonsToCreate_Array[2] Then
		$PosCount = $PosCount + 1
		$Button_Minimize_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		$Button_Minimize_Array[1] = False
		$Button_Minimize_Array[2] = False ; Inactive Color state
		$Button_Minimize_Array[3] = "0"
		$Button_Minimize_Array[15] = $CurrentGUI
	EndIf

	If $ButtonsToCreate_Array[3] Then
		$PosCount = $PosCount + 1
		$Button_FullScreen_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		$Button_FullScreen_Array[1] = False
		$Button_FullScreen_Array[2] = False ; Inactive Color state
		$Button_FullScreen_Array[3] = "9"
		$Button_FullScreen_Array[15] = $CurrentGUI

		If $Button_FSRestore_Array[15] <> $CurrentGUI Then
			$Button_FSRestore_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
			$Button_FSRestore_Array[1] = False
			$Button_FSRestore_Array[2] = False ; Inactive Color state
			$Button_FSRestore_Array[3] = "10"
			$Button_FSRestore_Array[15] = $CurrentGUI
		EndIf
	EndIf

	If $ButtonsToCreate_Array[4] Then
		$Button_Menu_Array[0] = GUICtrlCreatePic("", $cMarginR, $cMarginR, $CBw, $CBh)
		$Button_Menu_Array[1] = False
		$Button_Menu_Array[2] = False ; Inactive Color state
		$Button_Menu_Array[3] = "8"
		$Button_Menu_Array[15] = $CurrentGUI
	EndIf

	;Create Graphics
	If $ButtonsToCreate_Array[0] Then
		Local $Button_Close_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 4, 4), $Button_Close_Graphic2 = _iGraphicCreate($CBw, $CBh, "0xFFE81123", 4, 4), $Button_Close_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 4, 4)
	EndIf
	If $ButtonsToCreate_Array[1] Then
		Local $Button_Maximize_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Maximize_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Maximize_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
		Local $Button_Restore_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Restore_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Restore_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf
	If $ButtonsToCreate_Array[2] Then
		Local $Button_Minimize_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Minimize_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Minimize_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf
	If $ButtonsToCreate_Array[3] Then
		Local $Button_FullScreen_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_FullScreen_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_FullScreen_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
		Local $Button_FSRestore_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_FSRestore_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_FSRestore_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf
	If $ButtonsToCreate_Array[4] Then
		Local $Button_Menu_Graphic1 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Menu_Graphic2 = _iGraphicCreate($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Menu_Graphic3 = _iGraphicCreate($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf

	;Set close button BG color style
	If $CloseButtonOnStyle Then
		_GDIPlus_GraphicsClear($Button_Close_Graphic1[0], "0xFFB52231") ;
		_GDIPlus_GraphicsClear($Button_Close_Graphic3[0], "0xFFB52231") ;
	EndIf

	;Create Close Button==========================================================================================================
	If $ButtonsToCreate_Array[0] Then
		If $CloseButtonOnStyle Then
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic1[0], 17 * $cbDPI, 9 * $cbDPI, 27 * $cbDPI, 19 * $cbDPI, $hPen3)
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic1[0], 27 * $cbDPI, 9 * $cbDPI, 17 * $cbDPI, 19 * $cbDPI, $hPen3)
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic3[0], 17 * $cbDPI, 9 * $cbDPI, 27 * $cbDPI, 19 * $cbDPI, $hPen5)
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic3[0], 27 * $cbDPI, 9 * $cbDPI, 17 * $cbDPI, 19 * $cbDPI, $hPen5)
		Else
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic1[0], 17 * $cbDPI, 9 * $cbDPI, 27 * $cbDPI, 19 * $cbDPI, $hPen)
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic1[0], 27 * $cbDPI, 9 * $cbDPI, 17 * $cbDPI, 19 * $cbDPI, $hPen)
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic3[0], 17 * $cbDPI, 9 * $cbDPI, 27 * $cbDPI, 19 * $cbDPI, $hPen4)
			_GDIPlus_GraphicsDrawLine($Button_Close_Graphic3[0], 27 * $cbDPI, 9 * $cbDPI, 17 * $cbDPI, 19 * $cbDPI, $hPen4)
		EndIf
		_GDIPlus_GraphicsDrawLine($Button_Close_Graphic2[0], 17 * $cbDPI, 9 * $cbDPI, 27 * $cbDPI, 19 * $cbDPI, $hPen3)
		_GDIPlus_GraphicsDrawLine($Button_Close_Graphic2[0], 27 * $cbDPI, 9 * $cbDPI, 17 * $cbDPI, 19 * $cbDPI, $hPen3)
	EndIf
	;=============================================================================================================================

	;Create Maximize & Restore Button=============================================================================================
	If $ButtonsToCreate_Array[1] Then
		_GDIPlus_GraphicsDrawRect($Button_Maximize_Graphic1[0], Round(17 * $cbDPI), 9 * $cbDPI, 9 * $cbDPI, 9 * $cbDPI, $hPen)
		_GDIPlus_GraphicsDrawRect($Button_Maximize_Graphic2[0], Round(17 * $cbDPI), 9 * $cbDPI, 9 * $cbDPI, 9 * $cbDPI, $hPen2)
		_GDIPlus_GraphicsDrawRect($Button_Maximize_Graphic3[0], Round(17 * $cbDPI), 9 * $cbDPI, 9 * $cbDPI, 9 * $cbDPI, $hPen4)

		Local $kWH = Round(7 * $cbDPI), $resmargin = Round(2 * $cbDPI)
		_GDIPlus_GraphicsDrawRect($Button_Restore_Graphic1[0], Round(17 * $cbDPI) + $resmargin, (11 * $cbDPI) - $resmargin, $kWH, $kWH, $hPen)
		_GDIPlus_GraphicsFillRect($Button_Restore_Graphic1[0], Round(17 * $cbDPI), 11 * $cbDPI, $kWH, $kWH, $hBrush)
		_GDIPlus_GraphicsDrawRect($Button_Restore_Graphic1[0], Round(17 * $cbDPI), 11 * $cbDPI, $kWH, $kWH, $hPen)

		_GDIPlus_GraphicsDrawRect($Button_Restore_Graphic2[0], Round(17 * $cbDPI) + $resmargin, (11 * $cbDPI) - $resmargin, $kWH, $kWH, $hPen2)
		_GDIPlus_GraphicsFillRect($Button_Restore_Graphic2[0], Round(17 * $cbDPI), 11 * $cbDPI, $kWH, $kWH, $hBrush2)
		_GDIPlus_GraphicsDrawRect($Button_Restore_Graphic2[0], Round(17 * $cbDPI), 11 * $cbDPI, $kWH, $kWH, $hPen2)

		_GDIPlus_GraphicsDrawRect($Button_Restore_Graphic3[0], Round(17 * $cbDPI) + $resmargin, (11 * $cbDPI) - $resmargin, $kWH, $kWH, $hPen4)
		_GDIPlus_GraphicsFillRect($Button_Restore_Graphic3[0], Round(17 * $cbDPI), 11 * $cbDPI, $kWH, $kWH, $hBrush)
		_GDIPlus_GraphicsDrawRect($Button_Restore_Graphic3[0], Round(17 * $cbDPI), 11 * $cbDPI, $kWH, $kWH, $hPen4)
	EndIf
	;=============================================================================================================================


	;Create Minimize Button=======================================================================================================
	If $ButtonsToCreate_Array[2] Then
		_GDIPlus_GraphicsDrawLine($Button_Minimize_Graphic1[0], 18 * $cbDPI, 14 * $cbDPI, 27 * $cbDPI, 14 * $cbDPI, $hPen)
		_GDIPlus_GraphicsDrawLine($Button_Minimize_Graphic2[0], 18 * $cbDPI, 14 * $cbDPI, 27 * $cbDPI, 14 * $cbDPI, $hPen2)
		_GDIPlus_GraphicsDrawLine($Button_Minimize_Graphic3[0], 18 * $cbDPI, 14 * $cbDPI, 27 * $cbDPI, 14 * $cbDPI, $hPen4)
	EndIf
	;=============================================================================================================================

	;Create FullScreen / Fullscreen Restore Button================================================================================
	If $ButtonsToCreate_Array[3] Then

		;Calc size+pos
		Local $Cutpoint = ($FrameSize * 0.3)
		Local $LowerLinePos[2], $UpperLinePos
		$LowerLinePos[0] = Round($CBw / 2.9)
		$LowerLinePos[1] = Round($CBh / 1.5)
		$UpperLinePos = cAngle($LowerLinePos[0], $LowerLinePos[1], 135, $CBw / 2.5)
		$UpperLinePos[0] = Round($UpperLinePos[0])
		$UpperLinePos[1] = Round($UpperLinePos[1])

		;Add arrow1
		Local $apos1 = cAngle($LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] + $Cutpoint, 180, 5 * $cbDPI)
		Local $apos2 = cAngle($LowerLinePos[0] - $Cutpoint, $LowerLinePos[1] - $Cutpoint, 90, 5 * $cbDPI)

		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic1[0], $LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] + $Cutpoint, $apos1[0], $apos1[1], $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic1[0], $LowerLinePos[0] - $Cutpoint, $LowerLinePos[1] - $Cutpoint, $apos2[0], $apos2[1], $hPen) ;l
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic2[0], $LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] + $Cutpoint, $apos1[0], $apos1[1], $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic2[0], $LowerLinePos[0] - $Cutpoint, $LowerLinePos[1] - $Cutpoint, $apos2[0], $apos2[1], $hPen) ;l
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic3[0], $LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] + $Cutpoint, $apos1[0], $apos1[1], $hPen4) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic3[0], $LowerLinePos[0] - $Cutpoint, $LowerLinePos[1] - $Cutpoint, $apos2[0], $apos2[1], $hPen4) ;l


		;Add arrow2
		$apos1 = cAngle($UpperLinePos[0] + $Cutpoint, $UpperLinePos[1] + $Cutpoint, 270, 5 * $cbDPI)
		$apos2 = cAngle($UpperLinePos[0] - $Cutpoint, $UpperLinePos[1] - $Cutpoint, 0, 5 * $cbDPI)

		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic1[0], $UpperLinePos[0] + $Cutpoint, $UpperLinePos[1] + $Cutpoint, $apos1[0], $apos1[1], $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic1[0], $UpperLinePos[0] - $Cutpoint, $UpperLinePos[1] - $Cutpoint, $apos2[0], $apos2[1], $hPen) ;l
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic2[0], $UpperLinePos[0] + $Cutpoint, $UpperLinePos[1] + $Cutpoint, $apos1[0], $apos1[1], $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic2[0], $UpperLinePos[0] - $Cutpoint, $UpperLinePos[1] - $Cutpoint, $apos2[0], $apos2[1], $hPen) ;l
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic3[0], $UpperLinePos[0] + $Cutpoint, $UpperLinePos[1] + $Cutpoint, $apos1[0], $apos1[1], $hPen4) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic3[0], $UpperLinePos[0] - $Cutpoint, $UpperLinePos[1] - $Cutpoint, $apos2[0], $apos2[1], $hPen4) ;l

		;Add line
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic1[0], $LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] - $Cutpoint, $UpperLinePos[0], $UpperLinePos[1], $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic2[0], $LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] - $Cutpoint, $UpperLinePos[0], $UpperLinePos[1], $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_FullScreen_Graphic3[0], $LowerLinePos[0] + $Cutpoint, $LowerLinePos[1] - $Cutpoint, $UpperLinePos[0], $UpperLinePos[1], $hPen4) ;r


		;=============================================================================================================================


		;Calc size+pos arrow 1
		$Cutpoint = ($FrameSize * 0.3)
		Local $mpX = Round($CBw / 2, 0), $mpY = Round($CBh / 2.35, 0)
		$apos1 = cAngle($mpX - $Cutpoint, $mpY - $Cutpoint, 90, 4 * $cbDPI)
		$apos2 = cAngle($mpX + $Cutpoint, $mpY + $Cutpoint, 180, 4 * $cbDPI)
		Local $apos4 = cAngle($mpX + $Cutpoint, $mpY - $Cutpoint, 135, 8 * $cbDPI)

		;Add arrow1
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic1[0], $mpX - $Cutpoint, $mpY - $Cutpoint, $apos1[0], $apos1[1], $hPen) ;h
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic1[0], $mpX + $Cutpoint, $mpY + $Cutpoint, $apos2[0], $apos2[1], $hPen) ;v
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic2[0], $mpX - $Cutpoint, $mpY - $Cutpoint, $apos1[0], $apos1[1], $hPen) ;h
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic2[0], $mpX + $Cutpoint, $mpY + $Cutpoint, $apos2[0], $apos2[1], $hPen) ;v
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic3[0], $mpX - $Cutpoint, $mpY - $Cutpoint, $apos1[0], $apos1[1], $hPen4) ;h
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic3[0], $mpX + $Cutpoint, $mpY + $Cutpoint, $apos2[0], $apos2[1], $hPen4) ;v
		
		;Calc size+pos arrow2
		$Cutpoint = ($FrameSize * 0.3)
		Local $mpX1 = Round($CBw / 2.2, 0), $mpY1 = Round($CBh / 2, 0)
		$apos1 = cAngle($mpX1 - $Cutpoint, $mpY1 - $Cutpoint, 360, 4 * $cbDPI)
		$apos2 = cAngle($mpX1 + $Cutpoint, $mpY1 + $Cutpoint, 270, 4 * $cbDPI)
		Local $apos3 = cAngle($mpX1 - $Cutpoint, $mpY1 + $Cutpoint, 315, 8 * $cbDPI)

		;Add arrow2
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic1[0], $mpX1 - $Cutpoint, $mpY1 - $Cutpoint, $apos1[0], $apos1[1], $hPen) ;v
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic1[0], $mpX1 + $Cutpoint, $mpY1 + $Cutpoint, $apos2[0], $apos2[1], $hPen) ;h
		
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic2[0], $mpX1 - $Cutpoint, $mpY1 - $Cutpoint, $apos1[0], $apos1[1], $hPen) ;v
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic2[0], $mpX1 + $Cutpoint, $mpY1 + $Cutpoint, $apos2[0], $apos2[1], $hPen) ;h
		
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic3[0], $mpX1 - $Cutpoint, $mpY1 - $Cutpoint, $apos1[0], $apos1[1], $hPen4) ;v
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic3[0], $mpX1 + $Cutpoint, $mpY1 + $Cutpoint, $apos2[0], $apos2[1], $hPen4) ;h

		;Add lines
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic1[0], $mpX1 - $Cutpoint, $mpY1 + $Cutpoint, $apos3[0] + $Cutpoint, $apos3[1] - $Cutpoint, $hPen)
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic1[0], $mpX + $Cutpoint, $mpY - $Cutpoint, $apos4[0] - $Cutpoint, $apos4[1] + $Cutpoint, $hPen)
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic2[0], $mpX1 - $Cutpoint, $mpY1 + $Cutpoint, $apos3[0] + $Cutpoint, $apos3[1] - $Cutpoint, $hPen)
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic2[0], $mpX + $Cutpoint, $mpY - $Cutpoint, $apos4[0] - $Cutpoint, $apos4[1] + $Cutpoint, $hPen)
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic3[0], $mpX1 - $Cutpoint, $mpY1 + $Cutpoint, $apos3[0] + $Cutpoint, $apos3[1] - $Cutpoint, $hPen4)
		_GDIPlus_GraphicsDrawLine($Button_FSRestore_Graphic3[0], $mpX + $Cutpoint, $mpY - $Cutpoint, $apos4[0] - $Cutpoint, $apos4[1] + $Cutpoint, $hPen4)
		
	EndIf
	;=============================================================================================================================


	;Create Menu Button===========================================================================================================
	If $ButtonsToCreate_Array[4] Then
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic1[0], $CBw / 3, $CBh / 2.9, ($CBw / 3) * 2, $CBh / 2.9, $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic1[0], $CBw / 3, $CBh / 2.9 + ($FrameSize * 4), ($CBw / 3) * 2, $CBh / 2.9 + ($FrameSize * 4), $hPen) ;r
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic1[0], $CBw / 3, $CBh / 2.9 + ($FrameSize * 8), ($CBw / 3) * 2, $CBh / 2.9 + ($FrameSize * 8), $hPen) ;r

		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic2[0], $CBw / 3, $CBh / 2.9, ($CBw / 3) * 2, $CBh / 2.9, $hPen)
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic2[0], $CBw / 3, $CBh / 2.9 + ($FrameSize * 4), ($CBw / 3) * 2, $CBh / 2.9 + ($FrameSize * 4), $hPen)
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic2[0], $CBw / 3, $CBh / 2.9 + ($FrameSize * 8), ($CBw / 3) * 2, $CBh / 2.9 + ($FrameSize * 8), $hPen)

		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic3[0], $CBw / 3, $CBh / 2.9, ($CBw / 3) * 2, $CBh / 2.9, $hPen4)
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic3[0], $CBw / 3, $CBh / 2.9 + ($FrameSize * 4), ($CBw / 3) * 2, $CBh / 2.9 + ($FrameSize * 4), $hPen4)
		_GDIPlus_GraphicsDrawLine($Button_Menu_Graphic3[0], $CBw / 3, $CBh / 2.9 + ($FrameSize * 8), ($CBw / 3) * 2, $CBh / 2.9 + ($FrameSize * 8), $hPen4)
	EndIf
	;=============================================================================================================================

	;Release resources
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_PenDispose($hPen3)
	_GDIPlus_PenDispose($hPen4)
	_GDIPlus_PenDispose($hPen5)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($hBrush2)

	;Create bitmap handles
	If $ButtonsToCreate_Array[0] Then
		$Button_Close_Array[5] = _iGraphicCreateBitmapHandle($Button_Close_Array[0], $Button_Close_Graphic1)
		$Button_Close_Array[6] = _iGraphicCreateBitmapHandle($Button_Close_Array[0], $Button_Close_Graphic2, False)
		$Button_Close_Array[7] = _iGraphicCreateBitmapHandle($Button_Close_Array[0], $Button_Close_Graphic3, False)
		GUICtrlSetResizing($Button_Close_Array[0], 768 + 32 + 4)
		$Control_Buttons[0] = $Button_Close_Array[0]
		_cHvr_Register($Button_Close_Array[0], "_iHoverOff", "_iHoverOn", '', "", _iAddHover($Button_Close_Array), $CurrentGUI)
	EndIf
	If $ButtonsToCreate_Array[1] Then
		$Button_Maximize_Array[5] = _iGraphicCreateBitmapHandle($Button_Maximize_Array[0], $Button_Maximize_Graphic1)
		$Button_Maximize_Array[6] = _iGraphicCreateBitmapHandle($Button_Maximize_Array[0], $Button_Maximize_Graphic2, False)
		$Button_Maximize_Array[7] = _iGraphicCreateBitmapHandle($Button_Maximize_Array[0], $Button_Maximize_Graphic3, False)
		$Button_Restore_Array[5] = _iGraphicCreateBitmapHandle($Button_Restore_Array[0], $Button_Restore_Graphic1)
		$Button_Restore_Array[6] = _iGraphicCreateBitmapHandle($Button_Restore_Array[0], $Button_Restore_Graphic2, False)
		$Button_Restore_Array[7] = _iGraphicCreateBitmapHandle($Button_Restore_Array[0], $Button_Restore_Graphic3, False)
		GUICtrlSetResizing($Button_Maximize_Array[0], 768 + 32 + 4)
		GUICtrlSetResizing($Button_Restore_Array[0], 768 + 32 + 4)

		$Control_Buttons[1] = $Button_Maximize_Array[0]
		$Control_Buttons[2] = $Button_Restore_Array[0]
		GUICtrlSetState($Button_Restore_Array[0], 32)
		
		_cHvr_Register($Button_Maximize_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Maximize_Array), $CurrentGUI)
		_cHvr_Register($Button_Restore_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Restore_Array), $CurrentGUI)
	EndIf

	If $ButtonsToCreate_Array[2] Then
		$Button_Minimize_Array[5] = _iGraphicCreateBitmapHandle($Button_Minimize_Array[0], $Button_Minimize_Graphic1)
		$Button_Minimize_Array[6] = _iGraphicCreateBitmapHandle($Button_Minimize_Array[0], $Button_Minimize_Graphic2, False)
		$Button_Minimize_Array[7] = _iGraphicCreateBitmapHandle($Button_Minimize_Array[0], $Button_Minimize_Graphic3, False)
		GUICtrlSetResizing($Button_Minimize_Array[0], 768 + 32 + 4)
		$Control_Buttons[3] = $Button_Minimize_Array[0]
		_cHvr_Register($Button_Minimize_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Minimize_Array), $CurrentGUI)
	EndIf

	If $ButtonsToCreate_Array[3] Then
		$Button_FullScreen_Array[5] = _iGraphicCreateBitmapHandle($Button_FullScreen_Array[0], $Button_FullScreen_Graphic1)
		$Button_FullScreen_Array[6] = _iGraphicCreateBitmapHandle($Button_FullScreen_Array[0], $Button_FullScreen_Graphic2, False)
		$Button_FullScreen_Array[7] = _iGraphicCreateBitmapHandle($Button_FullScreen_Array[0], $Button_FullScreen_Graphic3, False)

		$Button_FSRestore_Array[5] = _iGraphicCreateBitmapHandle($Button_FSRestore_Array[0], $Button_FSRestore_Graphic1)
		$Button_FSRestore_Array[6] = _iGraphicCreateBitmapHandle($Button_FSRestore_Array[0], $Button_FSRestore_Graphic2, False)
		$Button_FSRestore_Array[7] = _iGraphicCreateBitmapHandle($Button_FSRestore_Array[0], $Button_FSRestore_Graphic3, False)

		GUICtrlSetResizing($Button_FullScreen_Array[0], 768 + 32 + 4)
		GUICtrlSetResizing($Button_FSRestore_Array[0], 768 + 32 + 4)
		GUICtrlSetState($Button_FSRestore_Array[0], 32)

		$Control_Buttons[4] = $Button_FullScreen_Array[0]
		$Control_Buttons[5] = $Button_FSRestore_Array[0]
		_cHvr_Register($Button_FullScreen_Array[0], "_iHoverOff", "_iHoverOn", "_iFullscreenToggleBtn", "", _iAddHover($Button_FullScreen_Array), $CurrentGUI)
		_cHvr_Register($Button_FSRestore_Array[0], "_iHoverOff", "_iHoverOn", "_iFullscreenToggleBtn", "", _iAddHover($Button_FSRestore_Array), $CurrentGUI)
	EndIf

	If $ButtonsToCreate_Array[4] Then
		$Button_Menu_Array[5] = _iGraphicCreateBitmapHandle($Button_Menu_Array[0], $Button_Menu_Graphic1)
		$Button_Menu_Array[6] = _iGraphicCreateBitmapHandle($Button_Menu_Array[0], $Button_Menu_Graphic2, False)
		$Button_Menu_Array[7] = _iGraphicCreateBitmapHandle($Button_Menu_Array[0], $Button_Menu_Graphic3, False)
		GUICtrlSetResizing($Button_Menu_Array[0], 768 + 32 + 2)
		$Control_Buttons[6] = $Button_Menu_Array[0]
		_cHvr_Register($Button_Menu_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Menu_Array), $CurrentGUI)
	EndIf

	Return $Control_Buttons
EndFunc   ;==>_iCreateControlButtons

#EndRegion MetroGUI===========================================================================================



#Region MetroButtons===========================================================================================
; ===============================================================================================================================
; Name ..........: _Metro_CreateButton
; Description ...: Creates metro style buttons. Hovering creates a frame around the buttons.
; Syntax ........: _Metro_CreateButton($Text, $Left, $Top, $Width, $Height[, $BGColor = $ButtonBKColor[,
;                  $FontColor = $ButtonTextColor[, $Font = "Arial"[, $Fontsize = 12.5[, $FontStyle = 1 $FrameColor = "0xFFFFFF"]]]]])
; Parameters ....: $Text               - Text of the button.
;                  $Left               - Left pos.
;                  $Top                - Top pos.
;                  $Width              - Width.
;                  $Height             - Height.
;                  $BGColor         - [optional] Button background color. Default is $ButtonBKColor.
;                  $FontColor       - [optional] Font colore. Default is $ButtonTextColor.
;                  $Font            - [optional] Font. Default is "Arial".
;                  $Fontsize        - [optional] Fontsize. Default is 12.5.
;                  $FontStyle       - [optional] Fontstyle. Default is 1.
;                  $FrameColor      - [optional] Button frame color. Default is "0xFFFFFF".
; Return values .: Handle to the button.
; Example .......: _Metro_CreateButton("Button 1",50,50,120,34)
; ===============================================================================================================================

Func _Metro_CreateButton($Text, $Left, $Top, $Width, $Height, $BG_Color = $ButtonBKColor, $Font_Color = $ButtonTextColor, $Font = "Arial", $Fontsize = 10, $FontStyle = 1, $FrameColor = "0xFFFFFF")
	Local $Button_Array[16]

	Local $btnDPI = _HighDPICheck()
	;HighDPI Support
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	$Button_Array[1] = False ; Set hover OFF
	$Button_Array[3] = "2" ; Type
	$Button_Array[15] = GetCurrentGUI()

	;Calculate Framesize
	Local $FrameSize = Round(4 * $btnDPI)
	If Not (Mod($FrameSize, 2) = 0) Then $FrameSize = $FrameSize - 1

	;Set Colors
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	$FrameColor = "0xFF" & Hex($FrameColor, 6)
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $Brush_BTN_FontColorDis = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($Font_Color, -30), "0x", "0xFF"))
	Local $Pen_BTN_FrameHoverColor = _GDIPlus_PenCreate($FrameColor, $FrameSize)

	;Create Button graphics
	Local $Button_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5) ;Default
	Local $Button_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5) ;Hover
	Local $Button_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5) ;Disabled

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate(0, 0, $Width, $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)

	;Draw button text
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColorDis)

	;Add frame
	_GDIPlus_GraphicsDrawRect($Button_Graphic2[0], 0, 0, $Width, $Height, $Pen_BTN_FrameHoverColor)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush_BTN_FontColorDis)
	_GDIPlus_PenDispose($Pen_BTN_FrameHoverColor)
	
	;Set graphic and return Bitmap handle
	$Button_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Button_Array[5] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)
	$Button_Array[7] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic3, False)

	;For GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 768)
	_cHvr_Register($Button_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Array))

	Return $Button_Array[0]
EndFunc   ;==>_Metro_CreateButton

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateButtonEx
; Description ...: Creates Windows 10 style buttons with a frame around. Hovering changes the button color to a lighter color.
; Syntax ........: _Metro_CreateButtonEx($Text, $Left, $Top, $Width, $Height[, $BG_Color = $ButtonBKColor[,
;                  $Font_Color = $ButtonTextColor[, $Font = "Arial"[, $Fontsize = 12.5[, $FontStyle = 1[,
;                  $FrameColor = "0xFFFFFF"]]]]]])
; Parameters ....: $Text            	- Text of the button.
;                  $Left              	- Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color       	    - [optional] Button background color. Default is $ButtonBKColor.
;                  $Font_Color       	- [optional] Font colore. Default is $ButtonTextColor.
;                  $Font            	- [optional] Font. Default is "Arial".
;                  $Fontsize        	- [optional] Fontsize. Default is 12.5.
;                  $FontStyle       	- [optional] Fontstyle. Default is 1.
;                  $FrameColor      	- [optional] Button frame color. Default is "0xFFFFFF".
; Return values .: Handle to the button.
; Example .......: _Metro_CreateButtonEx("Button 1",50,50,120,34)
; ===============================================================================================================================

Func _Metro_CreateButtonEx($Text, $Left, $Top, $Width, $Height, $BG_Color = $ButtonBKColor, $Font_Color = $ButtonTextColor, $Font = "Arial", $Fontsize = 10, $FontStyle = 1, $FrameColor = "0xFFFFFF")
	Local $Button_Array[16]

	Local $btnDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	$Button_Array[1] = False ; Set hover OFF
	$Button_Array[3] = "2" ; Type
	$Button_Array[15] = GetCurrentGUI()

	;Calculate Framesize
	Local $FrameSize = Round(2 * $btnDPI)
	If Not (Mod($FrameSize, 2) = 0) Then $FrameSize = $FrameSize - 1

	;Set Colors
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	$FrameColor = "0xFF" & Hex($FrameColor, 6)
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $Pen_BTN_FrameHoverColor = _GDIPlus_PenCreate($FrameColor, $FrameSize)
	Local $Pen_BTN_FrameHoverColorDis = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($Font_Color, -30), "0x", "0xFF"), $FrameSize)
	Local $Brush_BTN_FontColorDis = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($Font_Color, -30), "0x", "0xFF"))

	;Create Button graphics
	Local $Button_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5) ;Default
	Local $Button_Graphic2 = _iGraphicCreate($Width, $Height, StringReplace(_AlterBrightness($BG_Color, 25), "0x", "0xFF"), 0, 5) ;Hover
	Local $Button_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5) ;Disabled

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate(0, 0, $Width, $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)

	;Draw button text
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColorDis)

	;Add frame
	_GDIPlus_GraphicsDrawRect($Button_Graphic1[0], 0, 0, $Width, $Height, $Pen_BTN_FrameHoverColor)
	_GDIPlus_GraphicsDrawRect($Button_Graphic2[0], 0, 0, $Width, $Height, $Pen_BTN_FrameHoverColor)
	_GDIPlus_GraphicsDrawRect($Button_Graphic3[0], 0, 0, $Width, $Height, $Pen_BTN_FrameHoverColorDis)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush_BTN_FontColorDis)
	_GDIPlus_PenDispose($Pen_BTN_FrameHoverColor)
	_GDIPlus_PenDispose($Pen_BTN_FrameHoverColorDis)

	;Set graphic and return Bitmap handle
	$Button_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Button_Array[5] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)
	$Button_Array[7] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic3, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 768)

	;Register Hover funcs
	_cHvr_Register($Button_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Array))
	
	Return $Button_Array[0]

EndFunc   ;==>_Metro_CreateButtonEx



; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateButtonEx2
; Description ...: Creates a button without a frame and slightly rounded corners. Hovering changes the button color to a lighter color.
; Syntax ........: _Metro_CreateButtonEx2($Text, $Left, $Top, $Width, $Height[, $BG_Color = $ButtonBKColor[,
;                  $Font_Color = $ButtonTextColor[, $Font = "Arial"[, $Fontsize = 12.5[, $FontStyle = 1[,
;                  $FrameColor = "0xFFFFFF"]]]]]])
; Parameters ....: $Text            	- Text of the button.
;                  $Left              	- Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color       	    - [optional] Button background color. Default is $ButtonBKColor.
;                  $Font_Color       	- [optional] Font colore. Default is $ButtonTextColor.
;                  $Font            	- [optional] Font. Default is "Arial".
;                  $Fontsize        	- [optional] Fontsize. Default is 12.5.
;                  $FontStyle       	- [optional] Fontstyle. Default is 1.
;                  $FrameColor      	- [optional] Button frame color. Default is "0xFFFFFF".
; Return values .: Handle to the button.
; Example .......: _Metro_CreateButtonEx2("Button 1",50,50,120,34)
; ===============================================================================================================================

Func _Metro_CreateButtonEx2($Text, $Left, $Top, $Width, $Height, $BG_Color = $ButtonBKColor, $Font_Color = $ButtonTextColor, $Font = "Arial", $Fontsize = 10, $FontStyle = 1, $FrameColor = "0xFFFFFF")
	Local $Button_Array[16]

	Local $btnDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	$Button_Array[1] = False ; Set hover OFF
	$Button_Array[3] = "2" ; Type
	$Button_Array[15] = GetCurrentGUI()
	
	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $Font_Color1 = _AlterBrightness($Font_Color, 7)
	Else
		Local $Font_Color1 = _AlterBrightness($Font_Color, -15)
	EndIf
	;Set Colors
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	$Font_Color1 = "0xFF" & Hex($Font_Color1, 6)
	$FrameColor = "0xFF" & Hex($FrameColor, 6)
	
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $Brush_BTN_FontColor1 = _GDIPlus_BrushCreateSolid($Font_Color1)
	Local $Brush_BTN_FontColorDis = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($Font_Color, -30), "0x", "0xFF"))

	;Create Button graphics
	Local $Button_Graphic1 = _iGraphicCreate($Width, $Height, StringReplace($GUIThemeColor, "0x", "0xFF"), 5, 5) ;Default
	Local $Button_Graphic2 = _iGraphicCreate($Width, $Height, StringReplace($GUIThemeColor, "0x", "0xFF"), 5, 5) ;Hover
	Local $Button_Graphic3 = _iGraphicCreate($Width, $Height, StringReplace($GUIThemeColor, "0x", "0xFF"), 5, 5) ;Disabled

	Local $iRadius = 3, $Margin = ($iRadius / 2) * $gDPI
	Local $iWidth = $Width - ($Margin * 2), $iHeight = $Height - ($Margin * 2)
	Local $hPath = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath, $Margin + $iWidth - ($iRadius * 2), $Margin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath, $Margin + $iWidth - ($iRadius * 2), $Margin + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath, $Margin, $Margin + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath, $Margin, $Margin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath)

	Local $hBrush = _GDIPlus_BrushCreateSolid($BG_Color)
	Local $hBrushHover = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($BG_Color, +25), "0x", "0xFF"))
	_GDIPlus_GraphicsFillPath($Button_Graphic1[0], $hPath, $hBrush)
	_GDIPlus_GraphicsFillPath($Button_Graphic2[0], $hPath, $hBrushHover)
	_GDIPlus_GraphicsFillPath($Button_Graphic3[0], $hPath, $hBrush)

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate(0, 0, $Width, $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)

	;Draw button text
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor1)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Button_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColorDis)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor1)
	_GDIPlus_BrushDispose($Brush_BTN_FontColorDis)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($hBrushHover)
	_GDIPlus_PathDispose($hPath)

	;Set graphic and return Bitmap handle
	$Button_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Button_Array[5] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)
	$Button_Array[7] = _iGraphicCreateBitmapHandle($Button_Array[0], $Button_Graphic3, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 768)

	_cHvr_Register($Button_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Button_Array))
	Return $Button_Array[0]

EndFunc   ;==>_Metro_CreateButtonEx2


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_DisableButton
; Description ...: Disables a Button and makes the font grayed out to indicate that the button is disabled.
; Syntax ........: _Metro_DisableButton($mButton)
; Parameters ....: $mButton             - Handle to the button.
; Example .......: _Metro_DisableButton($Button1)
; ===============================================================================================================================
Func _Metro_DisableButton($mButton)
	Local $CurrentGUI = GetCurrentGUI()
	GUICtrlSetState($mButton, 128)
	For $i_BTN = 0 To (UBound($iHoverReg) - 1)
		If ($iHoverReg[$i_BTN][0] = $mButton) And ($iHoverReg[$i_BTN][15] = $CurrentGUI) Then
			_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$i_BTN][0], 0x0172, 0, $iHoverReg[$i_BTN][7]))
		EndIf
	Next
EndFunc   ;==>_Metro_DisableButton

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_EnableButton
; Description ...: Enables a metro style button and reverts the grayed out font style.
; Syntax ........: _Metro_EnableButton($mButton)
; Parameters ....: $mButton             - Handle to the button.
; ===============================================================================================================================
Func _Metro_EnableButton($mButton)
	Local $CurrentGUI = GetCurrentGUI()
	GUICtrlSetState($mButton, 64)
	For $i_BTN = 0 To (UBound($iHoverReg) - 1)
		If ($iHoverReg[$i_BTN][0] = $mButton) And ($iHoverReg[$i_BTN][15] = $CurrentGUI) Then
			_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$i_BTN][0], 0x0172, 0, $iHoverReg[$i_BTN][5]))
		EndIf
	Next
EndFunc   ;==>_Metro_EnableButton


#EndRegion MetroButtons===========================================================================================

#Region Metro Toggles===========================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateToggle(NEW WIN10 Style)
; Description ...: Creates a Windows 10 style toggle with a text on the right side.
; Syntax ........: _Metro_CreateToggle($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"]]]])
; Parameters ....:
;                  $Text                - Text to be displayed on the right side of the GUI.
;                  $Left                - Left pos
;                  $Top                 - Top pos.
;                  $Width               - Width
;                  $Height              - Height
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
; Return values .: Handle to the toggle.
; ===============================================================================================================================
Func _Metro_CreateToggle($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11")
	Local $Text1 = $Text
	If $Height < 20 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. height is 20px for metro toggles.")
	EndIf
	If $Width < 46 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. width for metro toggles must be at least 46px without any text!")
	EndIf
	If Not (Mod($Height, 2) = 0) Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The toggle height should be an even number to prevent any misplacing.")
	EndIf
	;HighDPI Support
	Local $pDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
		If Not (Mod($Height, 2) = 0) Then $Height = $Height + 1
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	Local $Toggle_Array[16]
	$Toggle_Array[1] = False ; Hover
	$Toggle_Array[2] = False ; Checked State
	$Toggle_Array[3] = "6" ; Type
	$Toggle_Array[15] = GetCurrentGUI()

	;Calc pos/sizes
	Local $TopMargCalc = Number(20 * $pDPI, 1)
	If Not (Mod($TopMargCalc, 2) = 0) Then $TopMargCalc = $TopMargCalc + 1
	Local $TopMargCalc1 = Number(12 * $pDPI, 1)
	If Not (Mod($TopMargCalc1, 2) = 0) Then $TopMargCalc1 = $TopMargCalc1 + 1
	Local $TopMargin = Number((($Height - $TopMargCalc) / 2), 1)
	Local $TopMarginCircle = Number((($Height - $TopMargCalc1) / 2), 1)
	Local $iRadius = 10 * $pDPI
	Local $hFWidth = Number(50 * $pDPI, 1)
	If Not (Mod($hFWidth, 2) = 0) Then $hFWidth = $hFWidth + 1
	Local $togSizeW = Number(46 * $pDPI, 1)
	If Not (Mod($togSizeW, 2) = 0) Then $togSizeW = $togSizeW + 1
	Local $togSizeH = Number(20 * $pDPI, 1)
	If Not (Mod($togSizeH, 2) = 0) Then $togSizeH = $togSizeH + 1
	Local $tog_calc1 = Number(2 * $pDPI, 1)
	Local $tog_calc2 = Number(3 * $pDPI, 1)
	Local $tog_calc3 = Number(11 * $pDPI, 1)
	Local $tog_calc5 = Number(6 * $pDPI, 1)

	;Set Colors
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $Brush_BTN_FontColor1 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Color, "0x", "0xFF"))

	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $BoxFrameCol = StringReplace(_AlterBrightness($Font_Color, +65), "0x", "0xFF")
		Local $BoxFrameCol1 = StringReplace(_AlterBrightness($Font_Color, +65), "0x", "0xFF")
		Local $Font_Color1 = StringReplace(_AlterBrightness($Font_Color, +70), "0x", "0xFF")
	Else
		Local $BoxFrameCol = StringReplace(_AlterBrightness($Font_Color, -45), "0x", "0xFF")
		Local $BoxFrameCol1 = StringReplace(_AlterBrightness($Font_Color, -45), "0x", "0xFF")
		Local $Font_Color1 = StringReplace(_AlterBrightness($Font_Color, -30), "0x", "0xFF")
	EndIf

	;Unchecked
	Local $BrushInnerUC = _GDIPlus_BrushCreateSolid($BG_Color)
	Local $BrushCircleUC = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $BrushCircleHoverUC = _GDIPlus_BrushCreateSolid($BoxFrameCol1)
	Local $hPenDefaultUC = _GDIPlus_PenCreate($Font_Color, 2 * $pDPI)
	Local $hPenHoverUC = _GDIPlus_PenCreate($BoxFrameCol1, 2 * $pDPI)

	;Checked
	Local $BrushInnerC = _GDIPlus_BrushCreateSolid(StringReplace($ButtonBKColor, "0x", "0xFF"))
	Local $BrushInnerCHover = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($ButtonBKColor, +15), "0x", "0xFF"))
	Local $BrushCircleC = _GDIPlus_BrushCreateSolid(StringReplace($ButtonTextColor, "0x", "0xFF"))
	Local $hPenDefaultC = _GDIPlus_PenCreate(StringReplace($ButtonBKColor, "0x", "0xFF"), 2 * $pDPI)
	Local $hPenHoverC = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($ButtonBKColor, +15), "0x", "0xFF"), 2 * $pDPI)

	;Create graphics
	Local $Toggle_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic4 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic5 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic6 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic7 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic8 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic9 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic10 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5)

	;Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, 0)
	Local $tLayout = _GDIPlus_RectFCreate($hFWidth + (10 * $pDPI), 0, $Width - $hFWidth, $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 0)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)

	;Draw text
	If StringInStr($Text, "|@|") Then
		$Text1 = StringRegExp($Text, "\|@\|(.+)", 1)
		If Not @error Then $Text1 = $Text1[0]
		$Text = StringRegExp($Text, "^(.+)\|@\|", 1)
		If Not @error Then $Text = $Text[0]
	EndIf


	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic4[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic5[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic6[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic7[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic8[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic9[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic10[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)

	;Default state
	Local $hPath1 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath1, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath1, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath1, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath1, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath1)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic1[0], $hPath1, $BrushInnerUC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic1[0], $hPath1, $hPenDefaultUC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic1[0], 6 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleUC)

	;Default hover state
	Local $hPath2 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath2, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath2, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath2, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath2, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath2)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic9[0], $hPath2, $BrushInnerUC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic9[0], $hPath2, $hPenHoverUC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic9[0], 6 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleHoverUC)

	;CheckedStep1
	Local $hPath3 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath3, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath3, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath3, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath3, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath3)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic2[0], $hPath3, $BrushInnerUC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic2[0], $hPath3, $hPenHoverUC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic2[0], 10 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleHoverUC)

	;CheckedStep2
	Local $hPath4 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath4, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath4, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath4, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath4, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath4)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic3[0], $hPath4, $BrushInnerUC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic3[0], $hPath4, $hPenHoverUC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic3[0], 14 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleHoverUC)

	;CheckedStep3
	Local $hPath5 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath5, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath5, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath5, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath5, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath5)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic4[0], $hPath5, $BrushInnerUC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic4[0], $hPath5, $hPenHoverUC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic4[0], 18 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleHoverUC)

	;CheckedStep4
	Local $hPath6 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath6, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath6, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath6, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath6, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath6)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic5[0], $hPath6, $BrushInnerUC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic5[0], $hPath6, $hPenHoverUC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic5[0], 22 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleHoverUC)

	;CheckedStep5
	Local $hPath7 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath7, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath7, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath7, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath7, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath7)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic6[0], $hPath7, $BrushInnerCHover)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic6[0], $hPath7, $hPenHoverC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic6[0], 26 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleC)

	;CheckedStep6
	Local $hPath8 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath8, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath8, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath8, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath8, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath8)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic7[0], $hPath8, $BrushInnerCHover)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic7[0], $hPath8, $hPenHoverC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic7[0], 30 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleC)

	;Final checked state
	Local $hPath9 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath9, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath9, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath9, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath9, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath9)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic8[0], $hPath9, $BrushInnerC)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic8[0], $hPath9, $hPenDefaultC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic8[0], 34 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleC)

	;Final checked state hover
	Local $hPath10 = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath10, 0 + $hFWidth - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath10, 0 + $hFWidth - ($iRadius * 2), $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath10, 1 * $pDPI, $TopMargin + (20 * $pDPI) - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath10, 1 * $pDPI, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath10)
	_GDIPlus_GraphicsFillPath($Toggle_Graphic10[0], $hPath10, $BrushInnerCHover)
	_GDIPlus_GraphicsDrawPath($Toggle_Graphic10[0], $hPath10, $hPenHoverC)
	_GDIPlus_GraphicsFillEllipse($Toggle_Graphic10[0], 34 * $pDPI, $TopMarginCircle, 12 * $pDPI, 12 * $pDPI, $BrushCircleC)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor1)
	_GDIPlus_BrushDispose($BrushInnerUC)
	_GDIPlus_BrushDispose($BrushCircleUC)
	_GDIPlus_BrushDispose($BrushCircleHoverUC)
	_GDIPlus_BrushDispose($BrushInnerC)
	_GDIPlus_BrushDispose($BrushInnerCHover)
	_GDIPlus_BrushDispose($BrushCircleC)
	_GDIPlus_PenDispose($hPenDefaultUC)
	_GDIPlus_PenDispose($hPenHoverUC)
	_GDIPlus_PenDispose($hPenDefaultC)
	_GDIPlus_PenDispose($hPenHoverC)
	_GDIPlus_PathDispose($hPath1)
	_GDIPlus_PathDispose($hPath2)
	_GDIPlus_PathDispose($hPath3)
	_GDIPlus_PathDispose($hPath4)
	_GDIPlus_PathDispose($hPath5)
	_GDIPlus_PathDispose($hPath6)
	_GDIPlus_PathDispose($hPath7)
	_GDIPlus_PathDispose($hPath8)
	_GDIPlus_PathDispose($hPath9)
	_GDIPlus_PathDispose($hPath10)

	;Create bitmap handles and set graphics
	$Toggle_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Toggle_Array[5] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic1)
	$Toggle_Array[6] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic2, False)
	$Toggle_Array[7] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic3, False)
	$Toggle_Array[8] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic4, False)
	$Toggle_Array[9] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic5, False)
	$Toggle_Array[10] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic6, False)
	$Toggle_Array[11] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic7, False)
	$Toggle_Array[12] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic8, False)
	$Toggle_Array[13] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic9, False)
	$Toggle_Array[14] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic10, False)

	;Set Control Resizing
	GUICtrlSetResizing($Toggle_Array[0], 768)

	;Add to GUI_HOVER_REG
	_cHvr_Register($Toggle_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Toggle_Array))
	Return $Toggle_Array[0]
EndFunc   ;==>_Metro_CreateToggle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateToggleEx
; Description ...: Creates a Windows 8 style toggle with a text on the right side.
; Syntax ........: _Metro_CreateToggle($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"]]]])
; Parameters ....:
;                  $Text                - Text to be displayed on the right side of the GUI.
;                  $Left                - Left pos
;                  $Top                 - Top pos.
;                  $Width               - Width
;                  $Height              - Height
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
; Return values .: Handle to the toggle.
; ===============================================================================================================================
Func _Metro_CreateToggleEX($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11")
	Local $pDPI = _HighDPICheck(), $Text1 = $Text

	If $Height < 20 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. height is 20px for metro toggles.")
	EndIf
	If $Width < 46 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. width for metro toggles must be at least 46px without any text!")
	EndIf
	If Mod($Height, 2) <> 0 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The toggle height should be an even number to prevent any misplacing.")
	EndIf

	;HighDPI Support
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
		If Mod($Height, 2) <> 0 Then $Height = $Height + 1
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	;Create Toggle Array
	Local $Toggle_Array[16]
	$Toggle_Array[1] = False ; Hover
	$Toggle_Array[2] = False ; Checked State
	$Toggle_Array[3] = "6" ; Type
	$Toggle_Array[15] = GetCurrentGUI()

	;calc pos/sizes
	Local $TopMargCalc = Number(20 * $pDPI, 1)
	If Mod($TopMargCalc, 2) <> 0 Then $TopMargCalc = $TopMargCalc + 1
	Local $TopMargin = Number((($Height - $TopMargCalc) / 2), 1)
	Local $hFWidth = Number(50 * $pDPI, 1)
	If Mod($hFWidth, 2) <> 0 Then $hFWidth = $hFWidth + 1
	Local $togSizeW = Number(46 * $pDPI, 1)
	If Mod($togSizeW, 2) <> 0 Then $togSizeW = $togSizeW + 1
	Local $togSizeH = Number(20 * $pDPI, 1)
	If Mod($togSizeH, 2) <> 0 Then $togSizeH = $togSizeH + 1
	Local $tog_calc1 = Number(2 * $pDPI, 1)
	Local $tog_calc2 = Number(3 * $pDPI, 1)
	Local $tog_calc3 = Number(11 * $pDPI, 1)
	Local $tog_calc5 = Number(6 * $pDPI, 1)

	;Set Colors
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $Brush_BTN_FontColor1 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Color, "0x", "0xFF"))

	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $BoxFrameCol = StringReplace(_AlterBrightness($Font_Color, +45), "0x", "0xFF")
		Local $BoxFrameCol1 = StringReplace(_AlterBrightness($Font_Color, +35), "0x", "0xFF")
		Local $Font_Color1 = StringReplace(_AlterBrightness($Font_Color, +60), "0x", "0xFF")
	Else
		Local $BoxFrameCol = StringReplace(_AlterBrightness($Font_Color, -45), "0x", "0xFF")
		Local $BoxFrameCol1 = StringReplace(_AlterBrightness($Font_Color, -55), "0x", "0xFF")
		Local $Font_Color1 = StringReplace(_AlterBrightness($Font_Color, -30), "0x", "0xFF")
	EndIf

	;Unchecked
	Local $Brush1 = _GDIPlus_BrushCreateSolid($BoxFrameCol) ;Inner
	Local $Brush2 = _GDIPlus_BrushCreateSolid($BoxFrameCol1) ;Outerframe
	Local $Brush3 = _GDIPlus_BrushCreateSolid($Font_Color1) ;InnerHover
	;Checked
	Local $Brush4 = _GDIPlus_BrushCreateSolid(StringReplace($ButtonBKColor, "0x", "0xFF")) ;Inner
	Local $Brush5 = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($ButtonBKColor, -10), "0x", "0xFF")) ;Outerframe
	Local $Brush6 = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($ButtonBKColor, +15), "0x", "0xFF")) ;InnerHover

	;Create graphics
	Local $Toggle_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic4 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic5 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic6 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic7 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic8 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic9 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic10 = _iGraphicCreate($Width, $Height, $BG_Color, 0, 5)

	;Set font
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, 0)
	Local $tLayout = _GDIPlus_RectFCreate($hFWidth, 0, $Width - $hFWidth, $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)
	
	;Draw text
	If StringInStr($Text, "|@|") Then
		$Text1 = StringRegExp($Text, "\|@\|(.+)", 1)
		If Not @error Then $Text1 = $Text1[0]
		$Text = StringRegExp($Text, "^(.+)\|@\|", 1)
		If Not @error Then $Text = $Text[0]
	EndIf


	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic4[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic5[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic6[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic7[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic8[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic9[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Toggle_Graphic10[0], $Text1, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)

	;Default state
	_GDIPlus_GraphicsFillRect($Toggle_Graphic1[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush2) ; Toggle Background
	_GDIPlus_GraphicsFillRect($Toggle_Graphic1[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush1) ;Toggle Inner
	_GDIPlus_GraphicsFillRect($Toggle_Graphic1[0], 0, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1) ; Toggle Slider

	;Default hover state
	_GDIPlus_GraphicsFillRect($Toggle_Graphic9[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush2)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic9[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush3)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic9[0], 0, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;CheckedStep1
	_GDIPlus_GraphicsFillRect($Toggle_Graphic2[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush2)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic2[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush3)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic2[0], 5 * $pDPI, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;CheckedStep2
	_GDIPlus_GraphicsFillRect($Toggle_Graphic3[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush2)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic3[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush3)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic3[0], 10 * $pDPI, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;CheckedStep3
	_GDIPlus_GraphicsFillRect($Toggle_Graphic4[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush2)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic4[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush3)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic4[0], 15 * $pDPI, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;CheckedStep4
	_GDIPlus_GraphicsFillRect($Toggle_Graphic5[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush5)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic5[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush6)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic5[0], $togSizeH, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;CheckedStep5
	_GDIPlus_GraphicsFillRect($Toggle_Graphic6[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush5)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic6[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush6)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic6[0], 25 * $pDPI, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;CheckedStep6
	_GDIPlus_GraphicsFillRect($Toggle_Graphic7[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush5)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic7[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush6)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic7[0], 30 * $pDPI, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;Final checked state
	_GDIPlus_GraphicsFillRect($Toggle_Graphic8[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush5)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic8[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush4)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic8[0], $togSizeW - $tog_calc3, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;Final checked state hover
	_GDIPlus_GraphicsFillRect($Toggle_Graphic10[0], 0, $TopMargin, $togSizeW, $togSizeH, $Brush5)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic10[0], $tog_calc2, $TopMargin + $tog_calc2, $togSizeW - $tog_calc5, $togSizeH - $tog_calc5, $Brush6)
	_GDIPlus_GraphicsFillRect($Toggle_Graphic10[0], $togSizeW - $tog_calc3, $TopMargin, $tog_calc3, $togSizeH, $Brush_BTN_FontColor1)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor1)
	_GDIPlus_BrushDispose($Brush1)
	_GDIPlus_BrushDispose($Brush2)
	_GDIPlus_BrushDispose($Brush3)
	_GDIPlus_BrushDispose($Brush4)
	_GDIPlus_BrushDispose($Brush5)
	_GDIPlus_BrushDispose($Brush6)

	;Create bitmap handles and set graphics
	$Toggle_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Toggle_Array[5] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic1)
	$Toggle_Array[6] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic2, False)
	$Toggle_Array[7] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic3, False)
	$Toggle_Array[8] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic4, False)
	$Toggle_Array[9] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic5, False)
	$Toggle_Array[10] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic6, False)
	$Toggle_Array[11] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic7, False)
	$Toggle_Array[12] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic8, False)
	$Toggle_Array[13] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic9, False)
	$Toggle_Array[14] = _iGraphicCreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic10, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Toggle_Array[0], 768)

	;Add to GUI_HOVER_REG
	_cHvr_Register($Toggle_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Toggle_Array))

	Return $Toggle_Array[0]
EndFunc   ;==>_Metro_CreateToggleEX

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateToggle
; Description ...: Creates a Windows 10 style on/off toggle with custom "enable/disable" text.
; Syntax ........: _Metro_CreateToggle($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"]]]])
; Parameters ....:
;                  $OnText              - Text to be displayed when the toggle is checked
;                  $OffText             - Text to be displayed when the toggle is unchecked
;                  $Left                - Left pos
;                  $Top                 - Top pos.
;                  $Width               - Width
;                  $Height              - Height
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
; Return values .: Handle to the toggle.
; ===============================================================================================================================
Func _Metro_CreateOnOffToggle($OnText, $OffText, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11")
	Return _Metro_CreateToggle($OffText & "|@|" & $OnText, $Left, $Top, $Width, $Height, $BG_Color, $Font_Color, $Font, $Fontsize)
EndFunc   ;==>_Metro_CreateOnOffToggle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateToggleEx
; Description ...: Creates a Windows 8 style on/off toggle with custom "enable/disable" text.
; Syntax ........: _Metro_CreateToggle($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"]]]])
; Parameters ....:
;                  $OnText              - Text to be displayed when the toggle is checked
;                  $OffText             - Text to be displayed when the toggle is unchecked
;                  $Left                - Left pos
;                  $Top                 - Top pos.
;                  $Width               - Width
;                  $Height              - Height
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
; Return values .: Handle to the toggle.
; ===============================================================================================================================
Func _Metro_CreateOnOffToggleEx($OnText, $OffText, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11")
	Return _Metro_CreateToggleEX($OffText & "|@|" & $OnText, $Left, $Top, $Width, $Height, $BG_Color, $Font_Color, $Font, $Fontsize)
EndFunc   ;==>_Metro_CreateOnOffToggleEx


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_ToggleIsChecked
; Description ...: Checks if a toggle is checked
; Syntax ........: _Metro_ToggleIsChecked($Toggle)
; Parameters ....: $Toggle              - Handle of the toggle.
; Return values .: True / False
; ===============================================================================================================================
Func _Metro_ToggleIsChecked($Toggle)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Toggle Then
			If $iHoverReg[$i][2] Then
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_ToggleIsChecked

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_ToggleSwitch
; Description ...: Triggers Toggle Check/Uncheck and returns the current state of the toggle.  -> Should only be used to handle user clicks
; Syntax ........: _Metro_ToggleIsChecked($Toggle)
; Parameters ....: $Toggle              - Handle of the toggle.
; Return values .: True / False (State = Checked / Unchecked)
; ===============================================================================================================================
Func _Metro_ToggleSwitch($Toggle)
	If _Metro_ToggleIsChecked($Toggle) Then
		_Metro_ToggleUnCheck($Toggle)
		Return False
	Else
		_Metro_ToggleCheck($Toggle)
		Return True
	EndIf
EndFunc   ;==>_Metro_ToggleSwitch

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_ToggleUnCheck
; Description ...: Unchecks a toggle
; Syntax ........: _Metro_ToggleUnCheck($Toggle[, $NoAnimation = False])
; Parameters ....: $Toggle              - Handle to the toggle
;                  $NoAnimation         - [optional] True/False. Default is False. - Unchecks the toggle instantly without animation
; ===============================================================================================================================
Func _Metro_ToggleUnCheck($Toggle, $NoAnimation = False)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Toggle Then
			If $iHoverReg[$i][2] Then
				If Not $NoAnimation Then
					For $i2 = 12 To 6 Step -1
						_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $iHoverReg[$i][$i2]))
						Sleep(1)
					Next
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $iHoverReg[$i][13]))
				Else
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $iHoverReg[$i][13]))
				EndIf
				$iHoverReg[$i][1] = True
				$iHoverReg[$i][2] = False
				ExitLoop
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_ToggleUnCheck


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_ToggleCheck
; Description ...: Checks a toggle
; Syntax ........: _Metro_ToggleCheck($Toggle[, $NoAnimation = False])
; Parameters ....: $Toggle              - Handle to the toggle.
;                  			  $NoAnimation         - [optional] True/False. Default is False. - Checks the Toggle instantly without an animation and prevents hover effect from getting stuck. Should be used always when creating a gui with a checked toggle before the gui is shown.
; ===============================================================================================================================
Func _Metro_ToggleCheck($Toggle, $NoAnimation = False)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Toggle Then
			If Not $iHoverReg[$i][2] Then
				If Not $NoAnimation Then
					For $i2 = 6 To 11 Step +1
						_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $iHoverReg[$i][$i2]))
						Sleep(1)
					Next
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $iHoverReg[$i][12]))
				Else
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $iHoverReg[$i][12]))
				EndIf
				$iHoverReg[$i][2] = True
				$iHoverReg[$i][1] = True
				ExitLoop
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_ToggleCheck
#EndRegion Metro Toggles===========================================================================================


#Region MetroRadio===========================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateRadio
; Description ...: Creates a metro style radio.
; Syntax ........: _Metro_CreateRadio($RadioGroup, $Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"[, $FontStyle = 0]]]]])
; Parameters ....: $RadioGroup          - A radiogroup to assign the radio to. You can use numbers or any text.
;                  $Text                - Text.
;                  $Left                - Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
;                  $FontStyle           - [optional] Fontstyle. Default is 0.
;				   $$RadioCircleSize    - [optional] Custom circle size for radio.
; Return values .: Handle to the radio.
; ===============================================================================================================================
Func _Metro_CreateRadio($RadioGroup, $Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11", $FontStyle = 0, $RadioCircleSize = 22, $ExStyle = False)
	If $Height < 22 And $RadioCircleSize > 21 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. height is 22px for metro radios.")
	EndIf

	;HighDPI Support
	Local $rDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
		If Mod($Width, 2) <> 0 Then $Width = $Width - 1
		If Mod($Height, 2) <> 0 Then $Height = $Height - 1
		$RadioCircleSize = $RadioCircleSize * $gDPI
		If Mod($RadioCircleSize, 2) <> 0 Then $RadioCircleSize = $RadioCircleSize - 1
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	Local $Radio_Array[16]
	$Radio_Array[1] = False ; Hover
	$Radio_Array[2] = False ; Checkmark
	$Radio_Array[3] = "7" ; Type
	$Radio_Array[4] = $RadioGroup ; Radiogroup
	$Radio_Array[15] = GetCurrentGUI()

	;Set position
	Local $TopMargin = ($Height - $RadioCircleSize) / 2

	;Set Colors
	If $BG_Color <> 0 Then $BG_Color = "0xFF" & Hex($BG_Color, 6)
	
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $BoxFrameCol = StringReplace($CB_Radio_Hover_Color, "0x", "0xFF")
	Local $Brush1 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Color, "0x", "0xFF"))
	If $ExStyle Then
		Local $Brush2 = _GDIPlus_BrushCreateSolid(StringReplace($ButtonBKColor, "0x", "0xFF"))
	Else
		Local $Brush2 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_CheckMark_Color, "0x", "0xFF"))
	EndIf
	Local $Brush3 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Hover_Color, "0x", "0xFF"))

	;Create graphics
	Local $Radio_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;default state
	Local $Radio_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;checked state
	Local $Radio_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;default hover state
	Local $Radio_Graphic4 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;checked hover state

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate($RadioCircleSize + (4 * $rDPI), 0, $Width - $RadioCircleSize + (4 * $rDPI), $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 0)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)
	$tLayout.Y = 1

	;Draw radio text
	_GDIPlus_GraphicsDrawStringEx($Radio_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Radio_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Radio_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Radio_Graphic4[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)

	;Add Circle Background
	Local $radSize1 = 1 * $rDPI
	Local $radSize2 = 5 * $rDPI
	Local $radSize3 = 11 * $rDPI

	;Default state
	_GDIPlus_GraphicsFillEllipse($Radio_Graphic1[0], 0, $TopMargin, $RadioCircleSize - $radSize1, $RadioCircleSize - $radSize1, $Brush1)

	;Default hover state
	_GDIPlus_GraphicsFillEllipse($Radio_Graphic3[0], 0, $TopMargin, $RadioCircleSize - $radSize1, $RadioCircleSize - $radSize1, $Brush3)

	;Checked state
	_GDIPlus_GraphicsFillEllipse($Radio_Graphic2[0], 0, $TopMargin, $RadioCircleSize - $radSize1, $RadioCircleSize - $radSize1, $Brush1)
	_GDIPlus_GraphicsFillEllipse($Radio_Graphic2[0], $radSize2, $TopMargin + $radSize2, $RadioCircleSize - $radSize3, $RadioCircleSize - $radSize3, $Brush2)

	;Checked hover state
	_GDIPlus_GraphicsFillEllipse($Radio_Graphic4[0], 0, $TopMargin, $RadioCircleSize - $radSize1, $RadioCircleSize - $radSize1, $Brush3)
	_GDIPlus_GraphicsFillEllipse($Radio_Graphic4[0], $radSize2, $TopMargin + $radSize2, $RadioCircleSize - $radSize3, $RadioCircleSize - $radSize3, $Brush2)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush1)
	_GDIPlus_BrushDispose($Brush2)
	_GDIPlus_BrushDispose($Brush3)

	;Create bitmap handles and set graphics
	$Radio_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Radio_Array[5] = _iGraphicCreateBitmapHandle($Radio_Array[0], $Radio_Graphic1)
	$Radio_Array[7] = _iGraphicCreateBitmapHandle($Radio_Array[0], $Radio_Graphic2, False)
	$Radio_Array[6] = _iGraphicCreateBitmapHandle($Radio_Array[0], $Radio_Graphic3, False)
	$Radio_Array[8] = _iGraphicCreateBitmapHandle($Radio_Array[0], $Radio_Graphic4, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Radio_Array[0], 768)

	;Add Hover effects
	_cHvr_Register($Radio_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Radio_Array))
	Return $Radio_Array[0]
EndFunc   ;==>_Metro_CreateRadio

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateRadioEx
; Description ...: Creates a metro style radio with colored checkmark.
; Syntax ........: _Metro_CreateRadio($RadioGroup, $Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"[, $FontStyle = 0]]]]])
; Parameters ....: $RadioGroup          - A radiogroup to assign the radio to. You can use numbers or any text.
;                  $Text                - Text.
;                  $Left                - Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
;                  $FontStyle           - [optional] Fontstyle. Default is 0.
;				   $$RadioCircleSize    - [optional] Custom circle size for radio.
; Return values .: Handle to the radio.
; ===============================================================================================================================
Func _Metro_CreateRadioEx($RadioGroup, $Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11", $FontStyle = 0, $RadioCircleSize = 22)
	Return _Metro_CreateRadio($RadioGroup, $Text, $Left, $Top, $Width, $Height, $BG_Color, $Font_Color, $Font, $Fontsize, $FontStyle, $RadioCircleSize, True)
EndFunc   ;==>_Metro_CreateRadioEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_RadioCheck
; Description ...: Checks the selected radio and unchecks all other radios in the same radiogroup.
; Syntax ........: _Metro_RadioCheck($RadioGroup, $Radio)
; Parameters ....: $RadioGroup          - The group that the radio has been assigned to.
;                			  $Radio               - Handle to the radio.
;						 	  $NoHoverEffect	  - Default = False, True = Prevents the hover effect from appearing/freezing -> Should be used anytime the radio is not "clicked" by the user but checked manually during startup
; ===============================================================================================================================
Func _Metro_RadioCheck($RadioGroup, $Radio, $NoHoverEffect = False)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Radio Then
			$iHoverReg[$i][1] = True
			$iHoverReg[$i][2] = True
			If $NoHoverEffect Then
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$i][0], 0x0172, 0, $iHoverReg[$i][7]))
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$i][0], 0x0172, 0, $iHoverReg[$i][8]))
			EndIf
		Else
			If $iHoverReg[$i][4] = $RadioGroup Then
				$iHoverReg[$i][2] = False
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$i][0], 0x0172, 0, $iHoverReg[$i][5]))
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_RadioCheck
#EndRegion MetroRadio===========================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_RadioIsChecked
; Description ...: Checks if a metro radio is checked.
; Syntax ........: _Metro_RadioIsChecked($RadioGroup, $Radio)
; Parameters ....: $RadioGroup          - Radio group
;				   $Radio				- Handle to the radio
; Return values .: True / False
; ===============================================================================================================================
Func _Metro_RadioIsChecked($RadioGroup, $Radio)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Radio Then
			If $iHoverReg[$i][4] = $RadioGroup Then
				If $iHoverReg[$i][2] Then
					Return True
				Else
					Return False
				EndIf
			EndIf
		EndIf
	Next
	Return False
EndFunc   ;==>_Metro_RadioIsChecked


#Region MetroCheckbox===========================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateCheckbox
; Description ...: Creates a metro style checkbox
; Syntax ........: _Metro_CreateCheckbox($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"[, $FontStyle = 0]]]]])
; Parameters ....: $Text                - Text.
;                  $Left                - Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
;                  $FontStyle           - [optional] Fontstyle. Default is 0.
;                  $cb_style            - [optional] Creates a checkbox with the old design. You can also use _Metro_CreateCheckboxEx to do so.
; Return values .: Handle to the Checkbox
; ===============================================================================================================================
Func _Metro_CreateCheckbox($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11", $FontStyle = 0, $cb_style = 1)
	If $Height < 24 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. height is 24px for metro checkboxes.")
	EndIf

	;HighDPI Support
	Local $chDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
		If Mod($Width, 2) <> 0 Then $Width = $Width + 1
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	Local $Checkbox_Array[16]
	$Checkbox_Array[1] = False ; Hover
	$Checkbox_Array[2] = False ; Checkmark
	$Checkbox_Array[3] = "5" ; Type
	$Checkbox_Array[15] = GetCurrentGUI()

	;Calc Box position etc.
	Local $chbh = Round(22 * $chDPI)
	Local $TopMargin = ($Height - $chbh) / 2
	Local $CheckBox_Text_Margin = $chbh + ($TopMargin * 1.3)
	Local $FrameSize

	If $cb_style = 0 Then
		$FrameSize = $chbh / 7
	Else
		$FrameSize = $chbh / 8
	EndIf

	Local $BoxFrameSize = 2

	;Set Colors, Create Brushes and Pens
	If $BG_Color <> 0 Then
		$BG_Color = "0xFF" & Hex($BG_Color, 6)
	EndIf
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	
	
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	If $cb_style = 0 Then
		Local $Brush1 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Color, "0x", "0xFF")) ;default
		Local $Brush3 = $Brush1
		Local $Brush2 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Hover_Color, "0x", "0xFF")) ;default hover
		Local $Brush4 = $Brush2 ;checked hover
		Local $PenX = _GDIPlus_PenCreate(StringReplace($CB_Radio_CheckMark_Color, "0x", "0xFF"), $FrameSize) ;CheckmarkColor
	Else
		Local $Brush1 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Color, "0x", "0xFF")) ;default
		Local $Brush2 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Hover_Color, "0x", "0xFF")) ;default hover
		Local $Brush3 = _GDIPlus_BrushCreateSolid(StringReplace($ButtonBKColor, "0x", "0xFF")) ;checked
		Local $Brush4 = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($ButtonBKColor, +10), "0x", "0xFF")) ;checked hover
		Local $PenX = _GDIPlus_PenCreate(StringReplace($CB_Radio_Color, "0x", "0xFF"), $FrameSize) ;CheckmarkColor
	EndIf

	;Create graphics
	Local $Checkbox_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;default state
	Local $Checkbox_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;checked state
	Local $Checkbox_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;default hover state
	Local $Checkbox_Graphic4 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;checked hover state

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate($CheckBox_Text_Margin, 0, $Width - $CheckBox_Text_Margin, $Height)

	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)
	$tLayout.Y = 1

	;Draw checkbox text
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic4[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)

	;Draw rounded box
	Local $iRadius = Round(2 * $chDPI)
	Local $hPath = _GDIPlus_PathCreate()
	_GDIPlus_PathAddArc($hPath, $chbh - ($iRadius * 2), $TopMargin, $iRadius * 2, $iRadius * 2, 270, 90)
	_GDIPlus_PathAddArc($hPath, $chbh - ($iRadius * 2), $TopMargin + $chbh - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
	_GDIPlus_PathAddArc($hPath, 0, $TopMargin + $chbh - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
	_GDIPlus_PathAddArc($hPath, 0, $TopMargin, $iRadius * 2, $iRadius * 2, 180, 90)
	_GDIPlus_PathCloseFigure($hPath)

	_GDIPlus_GraphicsFillPath($Checkbox_Graphic1[0], $hPath, $Brush1) ;Default state
	_GDIPlus_GraphicsFillPath($Checkbox_Graphic3[0], $hPath, $Brush2) ;Default hover state
	_GDIPlus_GraphicsFillPath($Checkbox_Graphic2[0], $hPath, $Brush3) ;Checked state
	_GDIPlus_GraphicsFillPath($Checkbox_Graphic4[0], $hPath, $Brush4) ;Checked hover state


	;Calc size+pos
	Local $Cutpoint = ($FrameSize * 0.70) / 2
	Local $mpX = $chbh / 2.60
	Local $mpY = $TopMargin + $chbh / 1.3
	Local $apos1 = cAngle($mpX - $Cutpoint, $mpY, 135, $chbh / 1.35)
	Local $apos2 = cAngle($mpX, $mpY - $Cutpoint, 225, $chbh / 3)


	;Add check mark
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic2[0], $mpX - $Cutpoint, $mpY, $apos1[0], $apos1[1], $PenX) ;r
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic2[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $PenX) ;l

	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic4[0], $mpX - $Cutpoint, $mpY, $apos1[0], $apos1[1], $PenX)
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic4[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $PenX)

	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Brush1)
	_GDIPlus_BrushDispose($Brush2)
	_GDIPlus_BrushDispose($Brush3)
	_GDIPlus_BrushDispose($Brush4)
	_GDIPlus_PenDispose($PenX)

	;Create bitmap handles and set graphics
	$Checkbox_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Checkbox_Array[5] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic1)
	$Checkbox_Array[7] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic2, False)
	$Checkbox_Array[6] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic3, False)
	$Checkbox_Array[8] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic4, False)

	;For GUI Resizing
	GUICtrlSetResizing($Checkbox_Array[0], 768)
	_cHvr_Register($Checkbox_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Checkbox_Array))
	Return $Checkbox_Array[0]
EndFunc   ;==>_Metro_CreateCheckbox

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateCheckboxEx
; Description ...: Creates a checkbox with the old black and white style.
; Syntax ........: _Metro_CreateCheckboxEx($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[, $Font_Color = $FontThemeColor[,
;                  $Font = "Segoe UI"[, $Fontsize = "11"[, $FontStyle = 0[, $cb_style = 1]]]]]])
; Parameters ....: $Text                - Text.
;                  $Left                - Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
;                  $FontStyle           - [optional] Fontstyle. Default is 0.
; Return values .: Handle to the Checkbox
; ===============================================================================================================================
Func _Metro_CreateCheckboxEx($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11", $FontStyle = 0)
	Return _Metro_CreateCheckbox($Text, $Left, $Top, $Width, $Height, $BG_Color, $Font_Color, $Font, $Fontsize, $FontStyle, 0)
EndFunc   ;==>_Metro_CreateCheckboxEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateCheckboxEx2
; Description ...: Creates a modern rounded checkbox
; Syntax ........: _Metro_CreateCheckboxEx2($Text, $Left, $Top, $Width, $Height[, $BG_Color = $GUIThemeColor[,
;                  $Font_Color = $FontThemeColor[, $Font = "Segoe UI"[, $FontSize = "11"[, $FontStyle = 0]]]]])
; Parameters ....: $Text                - Text.
;                  $Left                - Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $BG_Color            - [optional] Background color. Default is $GUIThemeColor.
;                  $Font_Color          - [optional] Font color. Default is $FontThemeColor.
;                  $Font                - [optional] Font. Default is "Segoe UI".
;                  $FontSize            - [optional] Fontsize. Default is "11".
;                  $FontStyle           - [optional] Fontstyle. Default is 0.
; Return values .: Handle to the Checkbox
; ===============================================================================================================================
Func _Metro_CreateCheckboxEx2($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11", $FontStyle = 0)
	If $Height < 24 Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The min. height is 24px for metro checkboxes.")
	EndIf

	;HighDPI Support
	Local $chDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
		If Mod($Width, 2) <> 0 Then $Width = $Width + 1
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	Local $Checkbox_Array[16]
	$Checkbox_Array[1] = False ; Hover
	$Checkbox_Array[2] = False ; Checkmark
	$Checkbox_Array[3] = "5" ; Type
	$Checkbox_Array[15] = GetCurrentGUI()

	;Calc Box position etc.
	Local $chbh = Round(24 * $chDPI)
	Local $TopMargin = ($Height - $chbh) / 2
	Local $CheckBox_Text_Margin = $chbh + ($TopMargin * 1.3)
	Local $FrameSize = $chbh / 15
	Local $BoxFrameSize = 2

	;Set Colors, Create Brushes and Pens
	If $BG_Color <> 0 Then
		$BG_Color = "0xFF" & Hex($BG_Color, 6)
	EndIf
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	

	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	
	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $Pen1 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUIThemeColor, -100), "0x", "0xFF"), $FrameSize)
	Else
		Local $Pen1 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUIThemeColor, +85), "0x", "0xFF"), $FrameSize)
	EndIf
	
	
	Local $Pen2 = _GDIPlus_PenCreate(StringReplace($Font_Color, "0x", "0xFF"), $FrameSize) ;checked
	Local $Brush3 = _GDIPlus_BrushCreateSolid(StringReplace($ButtonBKColor, "0x", "0xFF")) ;checked
	Local $Brush4 = _GDIPlus_BrushCreateSolid(StringReplace(_AlterBrightness($ButtonBKColor, +10), "0x", "0xFF")) ;checked hover
	Local $PenX = _GDIPlus_PenCreate(StringReplace($CB_Radio_Color, "0x", "0xFF"), $FrameSize) ;CheckmarkColor
	

	;Create graphics
	Local $Checkbox_Graphic1 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;default state
	Local $Checkbox_Graphic2 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;checked state
	Local $Checkbox_Graphic3 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;default hover state
	Local $Checkbox_Graphic4 = _iGraphicCreate($Width, $Height, $BG_Color, 5, 5) ;checked hover state
	
	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate($CheckBox_Text_Margin, 0, $Width - $CheckBox_Text_Margin, $Height)

	_GDIPlus_StringFormatSetAlign($hFormat, 1)
	_GDIPlus_StringFormatSetLineAlign($hFormat, 1)
	$tLayout.Y = 1

	;Draw checkbox text
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic1[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic2[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic3[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)
	_GDIPlus_GraphicsDrawStringEx($Checkbox_Graphic4[0], $Text, $hFont, $tLayout, $hFormat, $Brush_BTN_FontColor)

	;Draw rounded box
	_GDIPlus_GraphicsDrawEllipse($Checkbox_Graphic1[0], 0 + ($FrameSize / 2), $TopMargin + ($FrameSize / 2), $chbh - ($FrameSize), $chbh - ($FrameSize), $Pen1) ;Default state
	_GDIPlus_GraphicsDrawEllipse($Checkbox_Graphic3[0], 0 + ($FrameSize / 2), $TopMargin + ($FrameSize / 2), $chbh - ($FrameSize), $chbh - ($FrameSize), $Pen2) ;Default hover state
	_GDIPlus_GraphicsFillEllipse($Checkbox_Graphic2[0], 0, $TopMargin, $chbh, $chbh, $Brush3) ;Checked state
	_GDIPlus_GraphicsFillEllipse($Checkbox_Graphic4[0], 0, $TopMargin, $chbh, $chbh, $Brush4) ;Checked hover state

	;Calc size+pos
	Local $Cutpoint = ($FrameSize * 0.70) / 2
	Local $mpX = $chbh / 2.4
	Local $mpY = $TopMargin + $chbh / 1.45
	Local $apos1 = cAngle($mpX - $Cutpoint, $mpY, 135, $chbh / 2)
	Local $apos2 = cAngle($mpX, $mpY - $Cutpoint, 225, $chbh / 4.3)


	;Add check mark
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic2[0], $mpX - $Cutpoint, $mpY, $apos1[0], $apos1[1], $PenX) ;r
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic2[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $PenX) ;l
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic4[0], $mpX - $Cutpoint, $mpY, $apos1[0], $apos1[1], $PenX)
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic4[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $PenX)
	
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic1[0], $mpX - $Cutpoint, $mpY, $apos1[0], $apos1[1], $Pen1) ;r
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic1[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $Pen1) ;l
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic3[0], $mpX - $Cutpoint, $mpY, $apos1[0], $apos1[1], $Pen2)
	_GDIPlus_GraphicsDrawLine($Checkbox_Graphic3[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $Pen2)


	;Release created objects
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($Brush_BTN_FontColor)
	_GDIPlus_BrushDispose($Pen1)
	_GDIPlus_BrushDispose($Pen2)
	_GDIPlus_BrushDispose($Brush3)
	_GDIPlus_BrushDispose($Brush4)
	_GDIPlus_PenDispose($PenX)

	;Create bitmap handles and set graphics
	$Checkbox_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Checkbox_Array[5] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic1)
	$Checkbox_Array[7] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic2, False)
	$Checkbox_Array[6] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic3, False)
	$Checkbox_Array[8] = _iGraphicCreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic4, False)

	;For GUI Resizing
	GUICtrlSetResizing($Checkbox_Array[0], 768)
	_cHvr_Register($Checkbox_Array[0], "_iHoverOff", "_iHoverOn", "", "", _iAddHover($Checkbox_Array))
	Return $Checkbox_Array[0]
EndFunc   ;==>_Metro_CreateCheckboxEx2

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CheckboxIsChecked
; Description ...: Checks if a metro checkbox is checked.
; Syntax ........: _Metro_CheckboxIsChecked($Checkbox)
; Parameters ....: $Checkbox            - Handle to the checkbox.
; Return values .: True / False
; ===============================================================================================================================
Func _Metro_CheckboxIsChecked($Checkbox)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Checkbox Then
			If $iHoverReg[$i][2] Then
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_CheckboxIsChecked

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CheckboxUnCheck
; Description ...: Unchecks a metro checkbox
; Syntax ........: _Metro_CheckboxUnCheck($Checkbox,)
; Parameters ....: $Checkbox            - Handle to the Checkbox.
; ===============================================================================================================================
Func _Metro_CheckboxUnCheck($Checkbox)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Checkbox Then
			$iHoverReg[$i][2] = False
			$iHoverReg[$i][1] = True
			_WinAPI_DeleteObject(GUICtrlSendMsg($Checkbox, 0x0172, 0, $iHoverReg[$i][6]))
		EndIf
	Next
EndFunc   ;==>_Metro_CheckboxUnCheck

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CheckboxCheck
; Description ...: Checks a metro checkbox
; Syntax ........: _Metro_CheckboxCheck($Checkbox, $NoHoverEffect = False)
; Parameters ....: $Checkbox            - Handle to the Checkbox.
;							  $NoHoverEffect	  - Default = False, True = Prevents the hover effect from appearing/freezing -> Should be used anytime the checkbox is not "clicked" by the user but checked manually during startup
; ===============================================================================================================================
Func _Metro_CheckboxCheck($Checkbox, $NoHoverEffect = False)
	For $i = 0 To (UBound($iHoverReg) - 1) Step +1
		If $iHoverReg[$i][0] = $Checkbox Then
			$iHoverReg[$i][2] = True
			$iHoverReg[$i][1] = True
			If $NoHoverEffect Then
				_WinAPI_DeleteObject(GUICtrlSendMsg($Checkbox, 0x0172, 0, $iHoverReg[$i][7]))
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($Checkbox, 0x0172, 0, $iHoverReg[$i][8]))
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_CheckboxCheck

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CheckboxSwitch
; Description ...: Toggles between checked/unchecked state and then returns the current state. -> Should only be used to handle user clicks
; Syntax ........: _Metro_CheckboxSwitch($Checkbox)
; Parameters ....: $Checkbox            - Handle to the Checkbox.
; Returns ---------: True = Checkbox is checked, False = Checkbox is not checked.
; ===============================================================================================================================
Func _Metro_CheckboxSwitch($Checkbox)
	If _Metro_CheckboxIsChecked($Checkbox) Then
		_Metro_CheckboxUnCheck($Checkbox)
		Return False
	Else
		_Metro_CheckboxCheck($Checkbox)
		Return True
	EndIf
EndFunc   ;==>_Metro_CheckboxSwitch



#EndRegion MetroCheckbox===========================================================================================

#Region Metro MsgBox===========================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_MsgBox
; Description ...: Creates a metro style MsgBox
; Syntax ........: _Metro_MsgBox($Flag, $Title, $Text[, $mWidth = 600[, $FontSize = 14[, $ParentGUI = "", $Timeout = 0]]])
; Parameters ....: $Flag                - Flag / Possible button combinations - See Autoit help file for possible buttons combinations under MsgBox
;				   $Title               - Title of the MsgBox.
;                  $Text                - Text of the MsgBox.
;                  $mWidth              - [optional] Width of the MsgBox. Use a value that matches the text length and font size. Default is 600.
;                  $FontSize            - [optional] Fontsize. Default is 11.
;                  $ParentGUI           - [optional] Parent GUI/Window to prevent multiple open windows in the taskbar for one program. Default is "".
;                  $Timeout             - [optional] Timeout in seconds. Default is 0.
;
; Notes .......: _GUIDisable($GUI, 0, 30) should be used before starting the MsgBox, so the MsgBox is better visible on top of your GUI. You also have to call _GUIDisable($GUI) afterwards.
; ===============================================================================================================================
Func _Metro_MsgBox($Flag, $Title, $Text, $mWidth = 600, $Fontsize = 11, $ParentGUI = "", $Timeout = 0)
	Local $1stButton, $2ndButton, $3rdButton, $1stButtonText = "-", $2ndButtonText = "-", $3rdButtonText = "-", $Buttons_Count = 1
	Switch $Flag
		Case 0 ;OK
			$Buttons_Count = 1
			$1stButtonText = "OK"
		Case 1 ;OK / Cancel
			$Buttons_Count = 2
			$1stButtonText = "OK"
			$2ndButtonText = "Cancel"
		Case 2 ;Abort / Retry / Ignore
			$Buttons_Count = 3
			$1stButtonText = "Abort"
			$2ndButtonText = "Retry"
			$3rdButtonText = "Ignore"
		Case 3 ;Yes / NO / Cancel
			$Buttons_Count = 3
			$1stButtonText = "Yes"
			$2ndButtonText = "No"
			$3rdButtonText = "Cancel"
		Case 4 ;Yes / NO
			$Buttons_Count = 2
			$1stButtonText = "Yes"
			$2ndButtonText = "No"
		Case 5 ; Retry / Cancel
			$Buttons_Count = 2
			$1stButtonText = "Retry"
			$2ndButtonText = "Cancel"
		Case 6 ; Cancel / Retry / Continue
			$Buttons_Count = 3
			$1stButtonText = "Cancel"
			$2ndButtonText = "Retry"
			$3rdButtonText = "Continue"
		Case Else
			$Buttons_Count = 1
			$1stButtonText = "OK"
	EndSwitch

	If ($Buttons_Count = 1) And ($mWidth < 180) Then MsgBox(16, "MetroUDF", "Error: Messagebox width has to be at least 180px for the selected message style/flag.")
	If ($Buttons_Count = 2) And ($mWidth < 240) Then MsgBox(16, "MetroUDF", "Error: Messagebox width has to be at least 240px for the selected message style/flag.")
	If ($Buttons_Count = 3) And ($mWidth < 360) Then MsgBox(16, "MetroUDF", "Error: Messagebox width has to be at least 360px for the selected message style/flag.")

	;HighDPI Support
	Local $msgbDPI = _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		$mWidth = Round($mWidth * $gDPI)
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	Local $LabelSize = _StringSize($Text, $Fontsize, 400, 0, "Arial", $mWidth - (30 * $msgbDPI))
	Local $mHeight = 120 + ($LabelSize[3] / $msgbDPI)
	Local $MsgBox_Form = _Metro_CreateGUI($Title, $mWidth / $msgbDPI, $mHeight, -1, -1, False, $ParentGUI)
	$mHeight = $mHeight * $msgbDPI
	GUICtrlCreateLabel(" " & $Title, 2 * $msgbDPI, 2 * $msgbDPI, $mWidth - (4 * $msgbDPI), 30 * $msgbDPI, 0x0200, 0x00100000)
	GUICtrlSetBkColor(-1, _AlterBrightness($GUIThemeColor, 30))
	GUICtrlSetColor(-1, $FontThemeColor)
	_GUICtrlSetFont(-1, 11, 600, 0, "Arial", 5)
	GUICtrlCreateLabel($Text, 15 * $msgbDPI, 50 * $msgbDPI, $LabelSize[2], $LabelSize[3], -1, 0x00100000)
	GUICtrlSetBkColor(-1, $GUIThemeColor)
	GUICtrlSetColor(-1, $FontThemeColor)
	GUICtrlSetFont(-1, $Fontsize, 400, 0, "Arial", 5)

	Local $1stButton_Left = (($mWidth / $msgbDPI) - ($Buttons_Count * 100) - (($Buttons_Count - 1) * 20)) / 2
	Local $1stButton_Left1 = ($mWidth - ($Buttons_Count * (100 * $msgbDPI)) - (($Buttons_Count - 1) * (20 * $msgbDPI))) / 2
	Local $2ndButton_Left = $1stButton_Left + 120
	Local $3rdButton_Left = $2ndButton_Left + 120

	GUICtrlCreateLabel("", 2 * $msgbDPI, $mHeight - (53 * $msgbDPI), $1stButton_Left1 - (4 * $msgbDPI), (50 * $msgbDPI), -1, 0x00100000)
	GUICtrlCreateLabel("", $mWidth - $1stButton_Left1 + (2 * $msgbDPI), $mHeight - (53 * $msgbDPI), $1stButton_Left1 - (4 * $msgbDPI), (50 * $msgbDPI), -1, 0x00100000)

	Local $cEnter = GUICtrlCreateDummy()
	Local $aAccelKeys[1][2] = [["{ENTER}", $cEnter]]
	Local $1stButton = _Metro_CreateButton($1stButtonText, $1stButton_Left, ($mHeight / $msgbDPI) - 50, 100, 34, $ButtonBKColor, $ButtonTextColor)
	Local $2ndButton = _Metro_CreateButton($2ndButtonText, $2ndButton_Left, ($mHeight / $msgbDPI) - 50, 100, 34, $ButtonBKColor, $ButtonTextColor)
	If $Buttons_Count < 2 Then GUICtrlSetState($2ndButton, 32)
	Local $3rdButton = _Metro_CreateButton($3rdButtonText, $3rdButton_Left, ($mHeight / $msgbDPI) - 50, 100, 34, $ButtonBKColor, $ButtonTextColor)
	If $Buttons_Count < 3 Then GUICtrlSetState($3rdButton, 32)
	
	;Set default btn.
	Switch $Flag
		Case 0, 1, 5
			GUICtrlSetState($1stButton, 512)
		Case 2, 4, 6
			GUICtrlSetState($2ndButton, 512)
		Case 3
			GUICtrlSetState($3rdButton, 512)
		Case Else
			GUICtrlSetState($1stButton, 512)
	EndSwitch
	GUISetAccelerators($aAccelKeys, $MsgBox_Form)
	
	GUISetState(@SW_SHOW)

	If $Timeout <> 0 Then
		$iMsgBoxTimeout = $Timeout
		AdlibRegister("_iMsgBoxTimeout", 1000)
	EndIf
	
	If $mOnEventMode Then Opt("GUIOnEventMode", 0) ;Temporarily deactivate oneventmode
	
	While 1
		If $Timeout <> 0 Then
			If $iMsgBoxTimeout <= 0 Then
				AdlibUnRegister("_iMsgBoxTimeout")
				_Metro_GUIDelete($MsgBox_Form)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
				Return SetError(1)
			EndIf
		EndIf
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case -3, $1stButton
				_Metro_GUIDelete($MsgBox_Form)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
				Return $1stButtonText
			Case $2ndButton
				_Metro_GUIDelete($MsgBox_Form)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
				Return $2ndButtonText
			Case $3rdButton
				_Metro_GUIDelete($MsgBox_Form)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
				Return $3rdButtonText
			Case $cEnter
				_Metro_GUIDelete($MsgBox_Form)
				Local $ReturnText
				Switch $Flag
					Case 0, 1, 5
						$ReturnText = $1stButtonText
					Case 2, 4, 6
						$ReturnText = $2ndButtonText
					Case 3
						$ReturnText = $3rdButtonText
					Case Else
						$ReturnText = $1stButtonText
				EndSwitch
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
				Return $ReturnText
		EndSwitch
	WEnd
EndFunc   ;==>_Metro_MsgBox


#EndRegion Metro MsgBox===========================================================================================


#Region Metro InputBox===========================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_InputBox
; Description ...: Creates a metro-style Inputbox.
; Syntax ........: _Metro_InputBox($Promt[, $Font_Size = 11[, $DefaultText = ""[, $PW = False[, $EnableEnterHotkey = True[,
;                  $ParentGUI = ""]]]]])
; Parameters ....: $Promt               - Promt for the user.
;                  $Font_Size           - [optional] Fontsize of the prompt. Default is 11. (Font Segoe UI)
;                  $DefaultText         - [optional] Default value for the input control.
;                  $PW                  - [optional] True/False - Hides the input text for password input. Default is False.
;                  $EnableEnterHotkey   - [optional] Allows confirming the entered text using the Enter key. Default is True.
;                  $ParentGUI           - [optional] Assigns a parent GUI. Default is "".
; Return values .: @error 1 (cancled)  or the text entered by the user.
; ===============================================================================================================================
Func _Metro_InputBox($Promt, $Font_Size = 11, $DefaultText = "", $PW = False, $EnableEnterHotkey = True, $ParentGUI = "")
	Local $Metro_Input, $Metro_Input_GUI
	If $ParentGUI = "" Then
		$Metro_Input_GUI = _Metro_CreateGUI($Promt, 460, 170, -1, -1, False)
	Else
		$Metro_Input_GUI = _Metro_CreateGUI(WinGetTitle($ParentGUI, "") & ".Input", 460, 170, -1, -1, False, $ParentGUI)
	EndIf
	_Metro_SetGUIOption($Metro_Input_GUI, True)
	GUICtrlCreateLabel($Promt, 3 * $gDPI, 3 * $gDPI, 454 * $gDPI, 60 * $gDPI, BitOR(0x1, 0x0200), 0x00100000)
	GUICtrlSetFont(-1, $Font_Size, 400, 0, "Segoe UI")
	GUICtrlSetColor(-1, $FontThemeColor)
	If $PW Then
		$Metro_Input = GUICtrlCreateInput($DefaultText, 16 * $gDPI, 75 * $gDPI, 429 * $gDPI, 28 * $gDPI, 32)
	Else
		$Metro_Input = GUICtrlCreateInput($DefaultText, 16 * $gDPI, 75 * $gDPI, 429 * $gDPI, 28 * $gDPI)
	EndIf
	GUICtrlSetFont(-1, 11, 500, 0, "Segoe UI")

	GUICtrlSetState($Metro_Input, 256)
	Local $cEnter = GUICtrlCreateDummy()
	Local $aAccelKeys[1][2] = [["{ENTER}", $cEnter]]
	Local $Button_Continue = _Metro_CreateButtonEx2("Continue", 110, 120, 100, 36, $ButtonBKColor, $ButtonTextColor, "Segoe UI")
	GUICtrlSetState($Button_Continue, 512)
	Local $Button_Cancel = _Metro_CreateButtonEx2("Cancel", 230, 120, 100, 36, $ButtonBKColor, $ButtonTextColor, "Segoe UI")

	GUISetState(@SW_SHOW)

	If $EnableEnterHotkey Then
		GUISetAccelerators($aAccelKeys, $Metro_Input_GUI)
	EndIf

	If $mOnEventMode Then Opt("GUIOnEventMode", 0) ;Temporarily deactivate oneventmode

	While 1
		$input_nMsg = GUIGetMsg()
		Switch $input_nMsg
			Case -3, $Button_Cancel
				_Metro_GUIDelete($Metro_Input_GUI)
				If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
				Return SetError(1, 0, "")
			Case $Button_Continue, $cEnter
				Local $User_Input = GUICtrlRead($Metro_Input)
				If Not ($User_Input = "") Then
					_Metro_GUIDelete($Metro_Input_GUI)
					If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
					Return $User_Input
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>_Metro_InputBox

#EndRegion Metro InputBox===========================================================================================



#Region Metro Progressbar===========================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CreateProgress
; Description ...: Creates a simple progressbar.
; Syntax ........: _Metro_CreateProgress($Left, $Top, $Width, $Height[, $EnableBorder = False[, $Backgroud_Color = $CB_Radio_Color[,
;                  $Progress_Color = $ButtonBKColor]]])
; Parameters ....: $Left                - Left pos.
;                  $Top                 - Top pos.
;                  $Width               - Width.
;                  $Height              - Height.
;                  $EnableBorder        - [optional] Enables a 1px border from each side for the progressbar. Default is False.
;                  $Backgroud_Color     - [optional] Background color. Default is $CB_Radio_Color.
;                  $Progress_Color      - [optional] Progress color. Default is $ButtonBKColor.
; Return values .: Array containing basic information about the progressbar that is required to set the % progress.
; ===============================================================================================================================
Func _Metro_CreateProgress($Left, $Top, $Width, $Height, $EnableBorder = False, $Backgroud_Color = $CB_Radio_Color, $Progress_Color = $ButtonBKColor)
	Local $Progress_Array[8]

	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
	EndIf
	$Progress_Array[1] = $Width
	$Progress_Array[2] = $Height
	$Progress_Array[3] = "0xFF" & Hex($Backgroud_Color, 6)
	$Progress_Array[4] = "0xFF" & Hex($Progress_Color, 6)
	$Progress_Array[5] = StringReplace($CB_Radio_Hover_Color, "0x", "0xFF")
	$Progress_Array[7] = $EnableBorder

	;Set Colors
	Local $ProgressBGPen = _GDIPlus_PenCreate($Progress_Array[5], 2)

	;Create Graphics
	Local $Progress_Graphic = _iGraphicCreate($Width, $Height, $Progress_Array[3], 1, 5)

	;Draw Progressbar border
	If $EnableBorder Then
		_GDIPlus_GraphicsDrawRect($Progress_Graphic[0], 0, 0, $Width, $Height, $ProgressBGPen)
	EndIf

	;Release created objects
	_GDIPlus_PenDispose($ProgressBGPen)

	;Create bitmap handles and set graphics
	$Progress_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Progress_Array[6] = _iGraphicCreateBitmapHandle($Progress_Array[0], $Progress_Graphic)

	;For GUI Resizing
	GUICtrlSetResizing($Progress_Array[0], 768)

	Return $Progress_Array
EndFunc   ;==>_Metro_CreateProgress

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_SetProgress
; Description ...: Sets the progress in % of a progressbar.
; Syntax ........: _Metro_SetProgress(Byref $Progress, $Percent)
; Parameters ....: $Progress            - Array of the progressbar that has been returned by _Metro_CreateProgress function.
;                  $Percent             - A value from 0-100. (In %)
; ===============================================================================================================================
Func _Metro_SetProgress(ByRef $Progress, $Percent)
	;Set Colors
	Local $ProgressBGPen = _GDIPlus_PenCreate($Progress[5], 2)
	Local $ProgressBGBrush = _GDIPlus_BrushCreateSolid($Progress[4])

	;Create Graphics
	Local $Progress_Graphic = _iGraphicCreate($Progress[1], $Progress[2], $Progress[3], 1, 5)

	;Draw Progressbar
	If $Percent > 100 Then $Percent = 100
	If $Progress[7] Then
		Local $ProgressWidth = (($Progress[1] - 2) / 100) * $Percent
		_GDIPlus_GraphicsDrawRect($Progress_Graphic[0], 0, 0, $Progress[1], $Progress[2], $ProgressBGPen)
		_GDIPlus_GraphicsFillRect($Progress_Graphic[0], 1, 1, $ProgressWidth, $Progress[2] - 2, $ProgressBGBrush)
	Else
		Local $ProgressWidth = (($Progress[1]) / 100) * $Percent
		_GDIPlus_GraphicsFillRect($Progress_Graphic[0], 0, 0, $ProgressWidth, $Progress[2], $ProgressBGBrush)
	EndIf

	;Release created objects
	_GDIPlus_PenDispose($ProgressBGPen)
	_GDIPlus_BrushDispose($ProgressBGBrush)

	;Create bitmap handles
	Local $SetProgress = _iGraphicCreateBitmapHandle($Progress[0], $Progress_Graphic)
	_WinAPI_DeleteObject($Progress[6])

	$Progress[6] = $SetProgress
EndFunc   ;==>_Metro_SetProgress
#EndRegion Metro Progressbar===========================================================================================



; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_AddHSeperator
; Description ...: Adds a horizontal seperator line to the GUI
; Syntax ........: _Metro_AddHSeperator($Left, $Top, $Width, $Size[, $Color = $GUIBorderColor])
; Parameters ....: $Left                - x Position.
;                  $Top                 - y Position
;                  $Width               - Width
;                  $Size                - Size of the line
;                  $Color               - [optional] Color of the line. Default is $GUIBorderColor.
; Return values .: Handle to the Seperator
; ===============================================================================================================================
Func _Metro_AddHSeperator($Left, $Top, $Width, $Size, $Color = $GUIBorderColor)
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Size = Round($Size * $gDPI)
	EndIf
	Local $Seperator = GUICtrlCreateLabel("", $Left, $Top, $Width, $Size)
	GUICtrlSetBkColor(-1, $Color)
	GUICtrlSetState(-1, 128)
	GUICtrlSetResizing(-1, 2 + 4 + 32 + 512)
	Return $Seperator
EndFunc   ;==>_Metro_AddHSeperator


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_AddVSeperator
; Description ...: Adds a vertical seperator line to the GUI
; Syntax ........: _Metro_AddVSeperator($Left, $Top, $Height, $Size[, $Color = $GUIBorderColor])
; Parameters ....: $Left                - x Position.
;                  $Top                 - y Position
;                  $Height               - Height
;                  $Size                - Size of the line
;                  $Color               - [optional] Color of the line. Default is $GUIBorderColor.
; Return values .: Handle to the Seperator
; ===============================================================================================================================
Func _Metro_AddVSeperator($Left, $Top, $Height, $Size, $Color = $GUIBorderColor)
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Height = Round($Height * $gDPI)
		$Size = Round($Size * $gDPI)
	EndIf
	Local $Seperator = GUICtrlCreateLabel("", $Left, $Top, $Size, $Height)
	GUICtrlSetBkColor(-1, $Color)
	GUICtrlSetState(-1, 128)
	GUICtrlSetResizing(-1, 32 + 64 + 256 + 2)
	Return $Seperator
EndFunc   ;==>_Metro_AddVSeperator



Func _iAddHover($Button_ADD)
	;Try to get an unused index from the hover reg array
	Local $HRS
	For $i = 0 To UBound($iHoverReg) - 1 Step +1
		If $iHoverReg[$i][0] = "" Then
			$HRS = $i
			ExitLoop
		EndIf
	Next
	If $HRS == "" Then ;If there is no unused index, then redim array
		$HRS = UBound($iHoverReg)
		ReDim $iHoverReg[$HRS + 1][16]
	EndIf
	For $i = 0 To 15
		$iHoverReg[$HRS][$i] = $Button_ADD[$i]
	Next
	Return $HRS
EndFunc   ;==>_iAddHover

#EndRegion HoverEffects===========================================================================================

#Region Required_Funcs===========================================================================================
Func _iGraphicCreate($hWidth, $hHeight, $BackgroundColor = 0, $Smoothingmode = 4, $TextCleartype = 0)
	Local $Picture_Array[2]
	$Picture_Array[1] = _GDIPlus_BitmapCreateFromScan0($hWidth, $hHeight, $GDIP_PXF32ARGB)
	$Picture_Array[0] = _GDIPlus_ImageGetGraphicsContext($Picture_Array[1])
	_GDIPlus_GraphicsSetSmoothingMode($Picture_Array[0], $Smoothingmode)
	_GDIPlus_GraphicsSetTextRenderingHint($Picture_Array[0], $TextCleartype)
	If $BackgroundColor <> 0 Then _GDIPlus_GraphicsClear($Picture_Array[0], $BackgroundColor)
	Return $Picture_Array
EndFunc   ;==>_iGraphicCreate

Func _iGraphicCreateBitmapHandle($hPicture, $Picture_Array, $hVisible = True)
	Local $cBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($Picture_Array[1])
	If $hVisible Then _WinAPI_DeleteObject(GUICtrlSendMsg($hPicture, 0x0172, 0, $cBitmap))
	_GDIPlus_GraphicsDispose($Picture_Array[0])
	_GDIPlus_BitmapDispose($Picture_Array[1])
	Return $cBitmap
EndFunc   ;==>_iGraphicCreateBitmapHandle

Func GetCurrentGUI() ;Thanks @binhnx
	Local $dummyCtrl = GUICtrlCreateLabel("", 0, 0, 0, 0)
	Local $hCurrent = _WinAPI_GetParent(GUICtrlGetHandle($dummyCtrl))
	GUICtrlDelete($dummyCtrl)
	Return $hCurrent
EndFunc   ;==>GetCurrentGUI

Func _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		Return $gDPI
	Else
		Return 1
	EndIf
EndFunc   ;==>_HighDPICheck

Func cAngle($x1, $y1, $Ang, $Length)
	Local $Return[2]
	$Return[0] = $x1 + ($Length * Sin($Ang / 180 * 3.14159265358979))
	$Return[1] = $y1 + ($Length * Cos($Ang / 180 * 3.14159265358979))
	Return $Return
EndFunc   ;==>cAngle

Func _GUICtrlSetFont($icontrolID, $iSize, $iweight = 400, $iattribute = 0, $sfontname = "", $iquality = 5)
	If $HIGHDPI_SUPPORT Then
		GUICtrlSetFont($icontrolID, $iSize, $iweight, $iattribute, $sfontname, $iquality)
	Else
		GUICtrlSetFont($icontrolID, $iSize / $Font_DPI_Ratio, $iweight, $iattribute, $sfontname, $iquality)
	EndIf
EndFunc   ;==>_GUICtrlSetFont

Func _GetFontDPI_Ratio()
	Local $a1[3]
	Local $iDPI, $iDPIRat, $Logpixelsy = 90, $hWnd = 0
	Local $hDC = DllCall("user32.dll", "long", "GetDC", "long", $hWnd)
	Local $aRet = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", $hDC[0], "long", $Logpixelsy)
	$hDC = DllCall("user32.dll", "long", "ReleaseDC", "long", $hWnd, "long", $hDC)
	$iDPI = $aRet[0]
	Select
		Case $iDPI = 0
			$iDPI = 96
			$iDPIRat = 94
		Case $iDPI < 84
			$iDPIRat = $iDPI / 105
		Case $iDPI < 121
			$iDPIRat = $iDPI / 96
		Case $iDPI < 145
			$iDPIRat = $iDPI / 95
		Case Else
			$iDPIRat = $iDPI / 94
	EndSelect
	$a1[0] = 2
	$a1[1] = $iDPI
	$a1[2] = $iDPIRat
	Return $a1
EndFunc   ;==>_GetFontDPI_Ratio


Func _iMsgBoxTimeout()
	$iMsgBoxTimeout -= 1
EndFunc   ;==>_iMsgBoxTimeout

Func _ReduceMemory($i_PID = -1)
	Local $ai_Return
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		$ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		$ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _AlterBrightness($StartCol, $adjust, $Select = 7)
	Local $red = $adjust * (BitAND(1, $Select) <> 0) + BitAND($StartCol, 0xff0000) / 0x10000
	Local $grn = $adjust * (BitAND(2, $Select) <> 0) + BitAND($StartCol, 0x00ff00) / 0x100
	Local $blu = $adjust * (BitAND(4, $Select) <> 0) + BitAND($StartCol, 0x0000FF)
	Return "0x" & Hex(String(limitCol($red) * 0x10000 + limitCol($grn) * 0x100 + limitCol($blu)), 6)
EndFunc   ;==>_AlterBrightness
Func limitCol($cc)
	If $cc > 255 Then Return 255
	If $cc < 0 Then Return 0
	Return $cc
EndFunc   ;==>limitCol


Func _CreateBorder($mGUI, $guiW, $guiH, $bordercolor = 0xFFFFFF)
	Local $cLeft, $cRight, $cTop, $cBottom
	Local $gID = _iGetGUIID($mGUI)
	
	$cTop = GUICtrlCreateLabel("", 0, 0, $guiW, 1)
	GUICtrlSetColor(-1, $bordercolor)
	GUICtrlSetBkColor(-1, $bordercolor)
	GUICtrlSetResizing(-1, 544)
	GUICtrlSetState(-1, 128)
	$cBottom = GUICtrlCreateLabel("", 0, $guiH - 1, $guiW, 1)
	GUICtrlSetColor(-1, $bordercolor)
	GUICtrlSetBkColor(-1, $bordercolor)
	GUICtrlSetResizing(-1, 576)
	GUICtrlSetState(-1, 128)
	$cLeft = GUICtrlCreateLabel("", 0, 1, 1, $guiH - 1)
	GUICtrlSetColor(-1, $bordercolor)
	GUICtrlSetBkColor(-1, $bordercolor)
	GUICtrlSetResizing(-1, 256 + 2)
	GUICtrlSetState(-1, 128)
	$cRight = GUICtrlCreateLabel("", $guiW - 1, 1, 1, $guiH - 1)
	GUICtrlSetColor(-1, $bordercolor)
	GUICtrlSetBkColor(-1, $bordercolor)
	GUICtrlSetResizing(-1, 256 + 4)
	GUICtrlSetState(-1, 128)
	If $gID <> "" Then
		$iGUI_LIST[$gID][12] = $cTop
		$iGUI_LIST[$gID][13] = $cBottom
		$iGUI_LIST[$gID][14] = $cLeft
		$iGUI_LIST[$gID][15] = $cRight
	EndIf
	
EndFunc   ;==>_CreateBorder

Func _WinPos($ParentWin, $Win_Wi, $Win_Hi)
	Local $Win_SetPos[2]
	$Win_SetPos[0] = "-1"
	$Win_SetPos[1] = "-1"
	Local $Win_POS = WinGetPos($ParentWin)
	If Not @error Then
		$Win_SetPos[0] = ($Win_POS[0] + (($Win_POS[2] - $Win_Wi) / 2))
		$Win_SetPos[1] = ($Win_POS[1] + (($Win_POS[3] - $Win_Hi) / 2))
	EndIf
	Return $Win_SetPos
EndFunc   ;==>_WinPos


; #FUNCTION# ====================================================================================================================
; Name ..........: _GDIPlus_GraphicsGetDPIRatio
; Description ...:
; Syntax ........: _GDIPlus_GraphicsGetDPIRatio([$iDPIDef = 96])
; Parameters ....: $iDPIDef             - [optional] An integer value. Default is 96.
; Return values .: None
; Author ........: UEZ
; Link ..........: http://www.autoitscript.com/forum/topic/159612-dpi-resolution-problem/?hl=%2Bdpi#entry1158317
; Example .......: No
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetDPIRatio($iDPIDef = 96)
	_GDIPlus_Startup()
	Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
	If @error Then Return SetError(1, @extended, 0)
	Local $aResult
	#forcedef $__g_hGDIPDll, $ghGDIPDll
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)

	If @error Then Return SetError(2, @extended, 0)
	Local $iDPI = $aResult[2]
	_GDIPlus_GraphicsDispose($hGfx)
	_GDIPlus_Shutdown()
	Return $iDPI / $iDPIDef
EndFunc   ;==>_GDIPlus_GraphicsGetDPIRatio
#EndRegion Required_Funcs===========================================================================================



;========================================================================NEW=================================================================================
Func _iHoverOn($idCtrl, $vData)
	Switch $iHoverReg[$vData][3]
		Case 5, 7
			If $iHoverReg[$vData][2] Then ;checkboxes and radios
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][8])) ;Checked hover image
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][6])) ;Default hover image
			EndIf
		Case "6"
			If $iHoverReg[$vData][2] Then ;toggles
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][14])) ;Checked hover image
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][13])) ;Default hover image
			EndIf
		Case Else
			_WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, 0x0172, 0, $iHoverReg[$vData][6])) ;Button hover image
	EndSwitch
EndFunc   ;==>_iHoverOn



Func _iHoverOff($idCtrl, $vData)
	Switch $iHoverReg[$vData][3]
		Case 0, 3, 4, 8, 9, 10 ;buttons
			If WinActive($iHoverReg[$vData][15]) Then
				_WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, 0x0172, 0, $iHoverReg[$vData][5])) ;Button default image
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, 0x0172, 0, $iHoverReg[$vData][7])) ;Inactive state
			EndIf
		Case 5, 7 ;checkboxes and radios
			If $iHoverReg[$vData][2] Then
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][7])) ;Checked image
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][5])) ;Default image
			EndIf
		Case "6" ;Toggles
			If $iHoverReg[$vData][2] Then
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][12])) ;Checked image
			Else
				_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$vData][0], 0x0172, 0, $iHoverReg[$vData][5])) ;Default image
			EndIf
		Case Else
			_WinAPI_DeleteObject(GUICtrlSendMsg($idCtrl, 0x0172, 0, $iHoverReg[$vData][5])) ;Button default image
	EndSwitch
EndFunc   ;==>_iHoverOff



; #FUNCTION# ====================================================================================================================
; Name ..........: _iGetCtrlHandlebyType
; Description ...: Internal function to get the handle of a control button using the GUI handle and Type
; ===============================================================================================================================
Func _iGetCtrlHandlebyType($Type, $hWnd)
	For $i = 0 To UBound($iHoverReg) - 1
		If ($Type = $iHoverReg[$i][3]) And ($hWnd = $iHoverReg[$i][15]) Then Return $iHoverReg[$i][0]
	Next
	Return False
EndFunc   ;==>_iGetCtrlHandlebyType


;====================================================================== Borderless UDF ==========================================================================

Func _iEffectControl($hWnd, $imsg, $wParam, $lParam, $iID, $gID)
	Switch $imsg
		Case 0x00AF, 0x0085, 0x00AE, 0x0083, 0x0086 ;Prevent default non-client arena from drawing for borderless GUI effects
			Return -1
		Case 0x031A ;Prevent rounded corners when theme changes
			DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", BitOR(2, 4))
			_WinAPI_SetWindowPos($hWnd, 0, 0, 0, 0, 0, $SWP_FRAMECHANGED + $SWP_NOMOVE + $SWP_NOSIZE + $SWP_NOREDRAW)
			DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", BitOR(1, 2, 4))
			Return 0
		Case 0x0005 ;Maximize/Restore effects -> 2 = Maximized, 0 = Restored & Fix maximized position
			If Not $iGUI_LIST[$gID][11] Then ;If not in fullscreen mode
				Switch $wParam
					Case 2 ;window maximized
						Local $wSize = _GetDesktopWorkArea($hWnd)
						Local $wPos = WinGetPos($hWnd)
						WinMove($hWnd, "", $wPos[0] - 1, $wPos[1] - 1, $wSize[2], $wSize[3]) ;Fix Maximized pos
						For $iC = 0 To UBound($iHoverReg) - 1 ;Hide max button and show restore button
							If $hWnd = $iHoverReg[$iC][15] Then
								Switch $iHoverReg[$iC][3]
									Case 3
										GUICtrlSetState($iHoverReg[$iC][0], 32)
										$iHoverReg[$iC][8] = False
									Case 4
										GUICtrlSetState($iHoverReg[$iC][0], 16)
										$iHoverReg[$iC][8] = True
								EndSwitch
							EndIf
						Next
					Case 0 ;window restored/pos change
						For $iC = 0 To UBound($iHoverReg) - 1 ;Hide restore button and show max button
							If $hWnd = $iHoverReg[$iC][15] Then
								Switch $iHoverReg[$iC][3]
									Case 3
										If Not $iHoverReg[$iC][8] Then
											GUICtrlSetState($iHoverReg[$iC][0], 16)
											$iHoverReg[$iC][8] = True
										EndIf
									Case 4
										If $iHoverReg[$iC][8] Then
											GUICtrlSetState($iHoverReg[$iC][0], 32)
											$iHoverReg[$iC][8] = False
										EndIf
								EndSwitch
							EndIf
						Next
				EndSwitch
			EndIf
		Case 0x0024 ;Prevent Windows from misplacing the GUI when maximized. (Due to missing borders.) and set minimum window size.
			Local $tMinMax = DllStructCreate("int;int;int;int;int;int;int;int;int;dword", $lParam)
			Local $WrkSize = _GetDesktopWorkArea($hWnd)
			DllStructSetData($tMinMax, 3, $WrkSize[2])
			DllStructSetData($tMinMax, 4, $WrkSize[3])
			DllStructSetData($tMinMax, 5, $WrkSize[0] + 1)
			DllStructSetData($tMinMax, 6, $WrkSize[1] + 1)
			;Set win min size
			DllStructSetData($tMinMax, 7, $iGUI_LIST[$gID][3])
			DllStructSetData($tMinMax, 8, $iGUI_LIST[$gID][4])
		Case 0x0084 ;Set mouse cursor for resizing etc. / Allow the upper GUI (28 pixel from top) to act as a control bar (doubleclick to maximize, move gui around..)
			If $iGUI_LIST[$gID][2] And Not $iGUI_LIST[$gID][11] Then ;If resize is allowed and not in fullscreen mode
				Local $iSide = 0, $iTopBot = 0, $Cur
				Local $wPos = WinGetPos($hWnd)
				Local $curInf = GUIGetCursorInfo($hWnd)
				;Check if Mouse is over Border, Margin = 5
				If Not @error Then
					If $curInf[0] < $bMarg Then $iSide = 1
					If $curInf[0] > $wPos[2] - $bMarg Then $iSide = 2
					If $curInf[1] < $bMarg Then $iTopBot = 3
					If $curInf[1] > $wPos[3] - $bMarg Then $iTopBot = 6
					$Cur = $iSide + $iTopBot
				Else
					$Cur = 0
				EndIf
				If WinGetState($hWnd) <> 47 Then ;If not maximized
					;Set resize cursor and return the correct $HT for gui resizing
					Local $Return_HT = 2, $Set_Cur = 2
					Switch $Cur
						Case 1
							$Set_Cur = 13
							$Return_HT = 10
						Case 2
							$Set_Cur = 13
							$Return_HT = 11
						Case 3
							$Set_Cur = 11
							$Return_HT = 12
						Case 4
							$Set_Cur = 12
							$Return_HT = 13
						Case 5
							$Set_Cur = 10
							$Return_HT = 14
						Case 6
							$Set_Cur = 11
							$Return_HT = 15
						Case 7
							$Set_Cur = 10
							$Return_HT = 16
						Case 8
							$Set_Cur = 12
							$Return_HT = 17
					EndSwitch
					GUISetCursor($Set_Cur, 1)
					If $Return_HT <> 2 Then Return $Return_HT
				EndIf
				;Return HTCAPTION if mouse is in the non-client area (28px from top) for doubleclick + drag
				If Abs(BitAND(BitShift($lParam, 16), 0xFFFF) - $wPos[1]) < (28 * $gDPI) Then Return $HTCAPTION
			EndIf
		Case 0x0201 ;Allow moving the GUI using LBUTTON down+drag
			If $iGUI_LIST[$gID][1] And Not $iGUI_LIST[$gID][11] And Not (WinGetState($hWnd) = 47) Then
				Local $aCurInfo = GUIGetCursorInfo($hWnd)
				If ($aCurInfo[4] = 0) Then ; Mouse not over a control
					;Allow drag
					DllCall("user32.dll", "int", "ReleaseCapture")
					DllCall("user32.dll", "long", "SendMessageA", "hwnd", $hWnd, "int", 0x00A1, "int", 2, "int", 0)
					Return 0
				EndIf
			EndIf
		Case 0x001C ;Set Active/Inactive color for control buttons when the app is being activated/deactivated
			For $iC = 0 To UBound($iHoverReg) - 1
				Switch $iHoverReg[$iC][3]
					Case 0, 3, 4, 8, 9, 10
						If $wParam Then
							_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$iC][0], 0x0172, 0, $iHoverReg[$iC][5])) ;Button default image
						Else
							_WinAPI_DeleteObject(GUICtrlSendMsg($iHoverReg[$iC][0], 0x0172, 0, $iHoverReg[$iC][7]))
						EndIf
				EndSwitch
			Next
		Case 0x0020 ;Reset cursor back to defaul to prevent from resize cursors getting stuck
			If MouseGetCursor() <> 2 Then
				Local $curInf = GUIGetCursorInfo($hWnd)
				If Not @error And $curInf[4] <> 0 Then
					Local $iSide = 0, $iTopBot = 0, $Cur = 0
					Local $wPos = WinGetPos($hWnd)
					If $curInf[0] < $bMarg Then $iSide = 1
					If $curInf[0] > $wPos[2] - $bMarg Then $iSide = 2
					If $curInf[1] < $bMarg Then $iTopBot = 3
					If $curInf[1] > $wPos[3] - $bMarg Then $iTopBot = 6
					$Cur = $iSide + $iTopBot
					If $Cur = 0 Then
						If $curInf[4] <> $iGUI_LIST[$gID][12] And $curInf[4] <> $iGUI_LIST[$gID][13] And $curInf[4] <> $iGUI_LIST[$gID][14] And $curInf[4] <> $iGUI_LIST[$gID][15] Then ;If mouse not over border labels
							GUISetCursor(2, 0, $hWnd)
						EndIf
					EndIf
				EndIf
			EndIf
	EndSwitch
	
	Return DllCall("comctl32.dll", "lresult", "DefSubclassProc", "hwnd", $hWnd, "uint", $imsg, "wparam", $wParam, "lparam", $lParam)[0]
EndFunc   ;==>_iEffectControl

; #FUNCTION# ====================================================================================================================
; Name ..........: _iMExit
; Description ...: Removes all WindowSubclasses of all GUIs before exiting, in order to prevent a program crash
; ===============================================================================================================================
Func _iMExit()
	For $i_HR = 0 To UBound($iGUI_LIST) - 1 Step +1
		_Metro_GUIDelete($iGUI_LIST[$i_HR][0])
	Next
	DllCallbackFree($m_hDll)
	_GDIPlus_Shutdown()
EndFunc   ;==>_iMExit

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetDesktopWorkArea
; Description ...: Calculate the desktop workarea for a specific window to maximize it. Supports multi display and taskbar detection.
; Syntax ........: _GetDesktopWorkArea($hWnd)
; Parameters ....: $hWnd                - Handle to the window.
; Return values .: Array in following format:
;                : [0] = X-Pos for maximizing
;				 : [1] = Y-Pos for maximizing
;                : [2] = Max. Width
;				 : [3] = Max. Height
; Author ........: BB_19
; Note ..........: The x/y position is not the real position of the window if you have multi display. It is just for setting the maximize info for WM_GETMINMAXINFO
; ===============================================================================================================================
Func _GetDesktopWorkArea($hWnd, $FullScreen = False)
	Local $MonSizePos[4], $MonNumb = 1
	$MonSizePos[0] = 0
	$MonSizePos[1] = 0
	$MonSizePos[2] = @DesktopWidth
	$MonSizePos[3] = @DesktopHeight
	;Get Monitors
	Local $aPos, $MonList = _WinAPI_EnumDisplayMonitors()
	If @error Then Return $MonSizePos

	ReDim $MonList[$MonList[0][0] + 1][5]
	For $i = 1 To $MonList[0][0]
		$aPos = _WinAPI_GetPosFromRect($MonList[$i][1])
		For $j = 0 To 3
			$MonList[$i][$j + 1] = $aPos[$j]
		Next
	Next

	;Check on which monitor our window is
	Local $GUI_Monitor = _WinAPI_MonitorFromWindow($hWnd)
	;Check on which monitor the taskbar is
	Local $TaskbarMon = _WinAPI_MonitorFromWindow(WinGetHandle("[CLASS:Shell_TrayWnd]"))
	;Write the width and height info of the correct monitor into an array
	For $iM = 1 To $MonList[0][0] Step +1
		If $MonList[$iM][0] = $GUI_Monitor Then
			If $FullScreen Then
				$MonSizePos[0] = $MonList[$iM][1]
				$MonSizePos[1] = $MonList[$iM][2]
			Else
				$MonSizePos[0] = 0
				$MonSizePos[1] = 0
			EndIf
			$MonSizePos[2] = $MonList[$iM][3]
			$MonSizePos[3] = $MonList[$iM][4]
			$MonNumb = $iM
		EndIf
	Next
	;Check if Taskbar autohide is enabled, if so then we will remove 1px from the correct side so that the taskbar will reapear when moving mouse to the side
	Local $TaskBarAH = DllCall("shell32.dll", "int", "SHAppBarMessage", "int", 0x00000004, "ptr*", 0)
	If Not @error Then
		$TaskBarAH = $TaskBarAH[0]
	Else
		$TaskBarAH = 0
	EndIf
	;Check if Taskbar is on this Monitor, if so, then recalculate the position, max. width and height of the WorkArea
	If $TaskbarMon = $GUI_Monitor Then
		Local $TaskBarPos = WinGetPos("[CLASS:Shell_TrayWnd]")
		If @error Then Return $MonSizePos
		If $FullScreen Then Return $MonSizePos
		;Win 7 classic theme compatibility
		If ($TaskBarPos[0] = $MonList[$MonNumb][1] - 2) Or ($TaskBarPos[1] = $MonList[$MonNumb][2] - 2) Then
			$TaskBarPos[0] += 2
			$TaskBarPos[1] += 2
			$TaskBarPos[2] -= 4
			$TaskBarPos[3] -= 4
		EndIf
		;Recalc width/height and pos
		If $TaskBarPos[2] = $MonSizePos[2] Then
			If $TaskBarAH = 1 Then
				If ($TaskBarPos[1] > 0) Then
					$MonSizePos[3] -= 1
				Else
					$MonSizePos[1] += 1
					$MonSizePos[3] -= 1
				EndIf
				Return $MonSizePos
			EndIf
			$MonSizePos[3] = $MonSizePos[3] - $TaskBarPos[3]
			If ($TaskBarPos[0] = $MonList[$MonNumb][1]) And ($TaskBarPos[1] = $MonList[$MonNumb][2]) Then $MonSizePos[1] = $TaskBarPos[3]
		Else
			If $TaskBarAH = 1 Then
				If ($TaskBarPos[0] > 0) Then
					$MonSizePos[2] -= 1
				Else
					$MonSizePos[0] += 1
					$MonSizePos[2] -= 1
				EndIf
				Return $MonSizePos
			EndIf
			$MonSizePos[2] = $MonSizePos[2] - $TaskBarPos[2]
			If ($TaskBarPos[0] = $MonList[$MonNumb][1]) And ($TaskBarPos[1] = $MonList[$MonNumb][2]) Then $MonSizePos[0] = $TaskBarPos[2]
		EndIf
	EndIf
	Return $MonSizePos
EndFunc   ;==>_GetDesktopWorkArea

Func _iGetGUIID($mGUI)
	For $iG = 0 To UBound($iGUI_LIST) - 1
		If $iGUI_LIST[$iG][0] = $mGUI Then
			Return $iG
		EndIf
	Next
	Return SetError(1, 0, "") ;
EndFunc   ;==>_iGetGUIID

Func _iFullscreenToggleBtn($idCtrl, $hWnd)
	If $ControlBtnsAutoMode Then _Metro_FullscreenToggle($hWnd)
EndFunc   ;==>_iFullscreenToggleBtn

