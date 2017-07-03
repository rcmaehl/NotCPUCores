; #UDF# =======================================================================================================================
; Name ..........: MetroGUI UDF
; Description ...: Create borderless GUIs with modern buttons, checkboxes, toggles, radios MsgBoxes and progressbars.
; Version .......: v4.3
; Author ........: BB_19
; Note:
; ===============================================================================================================================

#include-once
#include "MetroThemes.au3"
#include "MetroUDF-Required\BorderlessWinUDF.au3"
#include "MetroUDF-Required\StringSize.au3"
#include "MetroUDF-Required\_GUIDisable.au3"
#include <GDIPlus.au3>
_GDIPlus_Startup()

;Global Variables
Global $Font_DPI_Ratio = _SetFont_GetDPI()[2], $gDPI = _GDIPlus_GraphicsGetDPIRatio(), $HIGHDPI_SUPPORT = False
Global $GUI_TOP_MARGIN = Number(29 * $gDPI, 1) + Number(15 * $gDPI, 1)
Global $GLOBAL_HOVER_REG[0]
Global $Internal_MsgBoxTimeout = 0

#Region Metro Functions Overview
;========================================MAIN GUI==================================================
;_Metro_CreateGUI 			  - Creates a borderless Metro-Style GUI
;_SetTheme					  - Sets the GUI color scheme from the included MetroThemes.au3
;_Metro_AddControlButtons	  - Adds the selected control buttons to the gui. (Close,Maximize,Minimize,Fullscreen Toogle, Menu button)
;_Metro_HoverCheck_Loop		  - Enables hover effects for all metro style buttons, checkboxes etc. - Has to be added to the main while-loop.
;_Metro_GUIDelete			  - Destroys all created metro buttons,checkboxes,radios etc., deletes the GUI and reduces memory usage.
;_Metro_EnableHighDPIScaling  - Enables high DPI support: Detects the users DPI settings and resizes GUI and all controls to look perfectly sharp.
;_Metro_SetGUIOption    	  - Allows to set different options like dragmove, resize and min. resize width/height.
;_Metro_FullscreenToggle 	  - Toggles between fullscreen and normal window. NOTE: $AllowResize has to be set True when creating a gui and this also requires the creation of a fullscreen control button.
;_Metro_AddControlButton_Back - Creates a back button on the left+top side of the gui.
;_Metro_MenuStart 			  - Shows/creates a menu window that slides in from the right side of the gui. (Similar to Android menus or Windows 10 calculator app)

;==========================================Buttons=================================================
;_Metro_CreateButton   - Creates metro style buttons. Hovering creates a frame around the buttons.
;_Metro_CreateButtonEx - Creates Windows 10 style buttons with a frame around. Hovering changes the button color to a lighter color.
;_Metro_DisableButton  - Disables a metro button and adds a grayed out look to it.
;_Metro_EnableButton   - Enables a metro button and removes grayed out look of it.

;==========================================Toggles=================================================
;_Metro_CreateToggle - Creates a Windows 10 style toggle with a text on the right side.(NEW Style)
;_Metro_CreateToggleEx - Creates a Windows 8 style toggle with a text on the right side.
;_Metro_ToggleIsChecked - Checks if a toggle is checked or not. Returns True or False.
;_Metro_ToggleCheck - Checks/Enables a toggle.
;_Metro_ToggleUnCheck - Unchecks/Disables a toggle.

;===========================================Radios=================================================
;_Metro_CreateRadio - Creates a metro style radio.
;_Metro_RadioCheck - Checks the selected radio and unchecks all other radios in the selected group.
;_Metro_RadioIsChecked - Checks if the radio in a specific group is selected.

;==========================================Checkboxes==============================================
;_Metro_CreateCheckbox - Creates a modern looking checkbox.
;_Metro_CreateCheckboxEx - Creates a classic-style checkbox with the default black white colors.
;_Metro_CheckboxIsChecked - Checks if a checkbox is checked. Returns True or False.
;_Metro_CheckboxCheck - Checks a checkbox.
;_Metro_CheckboxUncheck - Unchecks a checkbox.

;=============================================MsgBox===============================================
;_Metro_MsgBox - Creates a MsgBox with a OK button and displays the text. _GUIDisable($GUI, 0, 30) should be used before, so the MsgBox is better visible and afterwards _GUIDisable($GUI).

;=============================================Progress=============================================
;_Metro_CreateProgress - Creates a simple progressbar.
;_Metro_SetProgress - Sets the progress in % of a progressbar.
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
	
	If $AllowResize Then
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0) ;Adds compatibility for Windows 7 Basic theme
		$GUI_Return = GUICreate($Title, $Width, $Height, $Left, $Top, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX), -1, $ParentGUI)
		_Metro_SetGUIOption($GUI_Return, True, True, $Width, $Height)
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", BitOR(1, 2, 4))
	Else
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0) ;Adds compatibility for Windows 7 Basic theme
		$GUI_Return = GUICreate($Title, $Width, $Height, $Left, $Top, -1, -1, $ParentGUI)
		_Metro_SetGUIOption($GUI_Return, False, False, $Width, $Height)
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", BitOR(1, 2, 4))
	EndIf
	WinMove($GUI_Return, "", Default, Default, $Width, $Height)

	If $ParentGUI = "" Then
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
	_CreateBorder($Width, $Height, $GUIBorderColor, 0, 1)

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
	For $iGUIs = 0 To UBound($GLOBAL_GUI_LIST) - 1 Step +1
		If $GLOBAL_GUI_LIST[$iGUIs][0] = $mGUI Then
			$iGui_Count = $iGUIs
			ExitLoop
		EndIf
	Next

	If ($iGui_Count == "") Then
		$iGui_Count = UBound($GLOBAL_GUI_LIST)
		ReDim $GLOBAL_GUI_LIST[$iGui_Count + 1][11]
	EndIf
	
	$GLOBAL_GUI_LIST[$iGui_Count][0] = $mGUI
	$GLOBAL_GUI_LIST[$iGui_Count][1] = $AllowDragMove ;Drag
	$GLOBAL_GUI_LIST[$iGui_Count][2] = $AllowResize ;Resize
	
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
		$GLOBAL_GUI_LIST[$iGui_Count][3] = $Win_MinWidth ;Set Min Width of the Window
		$GLOBAL_GUI_LIST[$iGui_Count][4] = $Win_MinHeight ;Set Min Height of the Window
		GUIRegisterMsg(0x0024, "INTERNAL_WM_GETMINMAXINFO") ;Set GUI size limits
		GUIRegisterMsg(0x0005, "INTERNAL_WM_SIZING") ; Fix the maxmized position (otherwise we have a -7px margin on all sides due to the missing border)
		GUIRegisterMsg(0x0084, "INTERNAL_WM_NCHITTEST") ; For resizing and to allow doubleclick to maximize and drag on the upper GUI.
	EndIf
	
	If $AllowDragMove Then
		GUIRegisterMsg(0x0201, "INTERNAL_WM_LBUTTONDOWN") ; For drag/GUI moving.
	EndIf

	GUIRegisterMsg(0x0083, "INTERNAL_INTERCEPT_FRAMEDRAW") ; To Prevent window border from drawing
	GUIRegisterMsg(0x0086, "INTERNAL_INTERCEPT_FRAMEDRAW") ; To Prevent window border from drawing
	GUIRegisterMsg(0x00AE, "INTERNAL_INTERCEPT_FRAMEDRAW") ; To Prevent window border from drawing
	GUIRegisterMsg(0x00AF, "INTERNAL_INTERCEPT_FRAMEDRAW") ; To Prevent window border from drawing
	GUIRegisterMsg(0x0085, "INTERNAL_INTERCEPT_FRAMEDRAW") ; To Prevent window border from drawing
EndFunc   ;==>_Metro_SetGUIOption


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_GUIDelete
; Description ...: Destroys all created metro buttons,checkboxes,radios etc., deletes the GUI and reduces memory usage.
; Syntax ........: _Metro_GUIDelete($GUI)
; Parameters ....:  $GUI  - Handle to the gui to be deleted
; ===============================================================================================================================
Func _Metro_GUIDelete($GUI)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][15] = $GUI Then
			Switch ($GLOBAL_HOVER_REG[$i][3])
				Case "5", "7"
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][5])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][6])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][7])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][8])
				Case "6"
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][5])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][6])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][7])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][8])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][9])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][10])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][11])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][12])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][13])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][14])
				Case Else
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][5])
					_WinAPI_DeleteObject($GLOBAL_HOVER_REG[$i][6])
			EndSwitch
		EndIf
	Next
	_Internal_GUIRemoveHover($GUI)
	GUIDelete($GUI)
	
	;Remove from Global GUI List
	Local $CLEANED_GUI_LIST[0]
	For $i_HR = 0 To UBound($GLOBAL_GUI_LIST) - 1 Step +1
		If Not ($GLOBAL_GUI_LIST[$i_HR][0] = $GUI) Then
			ReDim $CLEANED_GUI_LIST[UBound($CLEANED_GUI_LIST) + 1][11]
			For $i_Hx = 0 To 10 Step +1
				$CLEANED_GUI_LIST[UBound($CLEANED_GUI_LIST) - 1][$i_Hx] = $GLOBAL_GUI_LIST[$i_HR][$i_Hx]
			Next
		EndIf
	Next
	$GLOBAL_GUI_LIST = $CLEANED_GUI_LIST

	_ReduceMemory()
EndFunc   ;==>_Metro_GUIDelete

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
Func _Metro_AddControlButtons($CloseBtn = True, $MaximizeBtn = True, $MinimizeBtn = True, $FullScreenBtn = False, $MenuBtn = False, $GUI_BG_Color = $GUIThemeColor, $GUI_Font_Color = $FontThemeColor)
	Local $ButtonsToCreate_Array[5]
	$ButtonsToCreate_Array[0] = $CloseBtn
	$ButtonsToCreate_Array[1] = $MaximizeBtn
	$ButtonsToCreate_Array[2] = $MinimizeBtn
	$ButtonsToCreate_Array[3] = $FullScreenBtn
	$ButtonsToCreate_Array[4] = $MenuBtn

	Return _Internal_CreateControlButtons($ButtonsToCreate_Array, $GUI_BG_Color, $GUI_Font_Color, False)
EndFunc   ;==>_Metro_AddControlButtons

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_EnableHighDPIScaling
; Description ...: Enables high DPI support: Detects the users DPI settings and resizes GUI and all controls to look perfectly sharp
; Syntax ........: _Metro_EnableHighDPIScaling()
; ===============================================================================================================================
Func _Metro_EnableHighDPIScaling()
	$HIGHDPI_SUPPORT = True
EndFunc   ;==>_Metro_EnableHighDPIScaling


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_FullscreenToggle
; Description ...: Toggles between fullscreen and normal window. NOTE: $AllowResize has to be set True when creating a gui and this also requires the creation of a fullscreen control button.
; Syntax ........: _Metro_FullscreenToggle($mGUI, $Control_Buttons_Array)
; Parameters ....: $mGUI                  - Handle to the GUI.
;                  $Control_Buttons_Array - Array containing the control button handles as returned from _Metro_AddControlButtons.
; Note2 .........: Fullscreen toggle only works with ONE gui at the same time. You can't create 2 Guis which are toggled to fullscreen at the same time. They will interfere with each other.
; ===============================================================================================================================
Func _Metro_FullscreenToggle($mGUI, $Control_Buttons_Array)

	Local $iGui_Count
	For $iGUIs = 0 To UBound($GLOBAL_GUI_LIST) - 1 Step +1
		If $GLOBAL_GUI_LIST[$iGUIs][0] = $mGUI Then
			$iGui_Count = $iGUIs
			ExitLoop
		EndIf
	Next
	If ($iGui_Count == "") Then
		ConsoleWrite("Fullscreen-Toggle failed: GUI not registered. Not created with _Metro_CreateGUI ?" & @CRLF)
		Return SetError(1) ;
	EndIf
	If Not $GLOBAL_GUI_LIST[$iGui_Count][2] Then
		ConsoleWrite("Fullscreen-Toggle failed: GUI is not registered for resizing. Please use _Metro_SetGUIOption to enable resizing." & @CRLF)
		Return SetError(2) ;
	EndIf
	
	Local $mWin_State = WinGetState($mGUI)
	Local $tRET = _WinAPI_GetWindowPlacement($mGUI)
	Local $FullScreenPOS = _GetDesktopWorkArea($mGUI, True)
	Local $FullScreenPOSEx = _GetDesktopWorkArea($mGUI)
	Local $CurrentPos = WinGetPos($mGUI)
	If (BitAND($mWin_State, 32) = 32) Then ; If maximized then
		WinMove($mGUI, "", $FullScreenPOS[0], $FullScreenPOS[1], $FullScreenPOS[2], $FullScreenPOS[3])
		$CurrentPos[0] = DllStructGetData($tRET, "rcNormalPosition", 1)
		$CurrentPos[1] = DllStructGetData($tRET, "rcNormalPosition", 2)
		$CurrentPos[2] = DllStructGetData($tRET, "rcNormalPosition", 3)
		$CurrentPos[3] = DllStructGetData($tRET, "rcNormalPosition", 4)
	EndIf

	If (($CurrentPos[0] = $FullScreenPOS[0]) And ($CurrentPos[1] = $FullScreenPOS[1]) And ($CurrentPos[2] = $FullScreenPOS[2]) And ($CurrentPos[3] = $FullScreenPOS[3])) Then
		GUIRegisterMsg(0x0024, "INTERNAL_WM_GETMINMAXINFO")
		If (BitAND($GLOBAL_GUI_LIST[$iGui_Count][9], 32) = 32) Then ; If maximized then
			GUISetState(@SW_MAXIMIZE)
			$tRET = $GLOBAL_GUI_LIST[$iGui_Count][10]
			DllStructSetData($tRET, "rcNormalPosition", $GLOBAL_GUI_LIST[$iGui_Count][5], 1) ; left
			DllStructSetData($tRET, "rcNormalPosition", $GLOBAL_GUI_LIST[$iGui_Count][6], 2) ; top
			DllStructSetData($tRET, "rcNormalPosition", $GLOBAL_GUI_LIST[$iGui_Count][7], 3) ; right
			DllStructSetData($tRET, "rcNormalPosition", $GLOBAL_GUI_LIST[$iGui_Count][8], 4) ; bottom
			_WinAPI_SetWindowPlacement($mGUI, $tRET)
		Else
			WinMove($mGUI, "", $GLOBAL_GUI_LIST[$iGui_Count][5], $GLOBAL_GUI_LIST[$iGui_Count][6], $GLOBAL_GUI_LIST[$iGui_Count][7], $GLOBAL_GUI_LIST[$iGui_Count][8])
		EndIf

		If Not ($Control_Buttons_Array[1] = "") Then
			GUICtrlSetState($Control_Buttons_Array[2], 16 + 64)
			GUICtrlSetState($Control_Buttons_Array[1], 16 + 64)
		EndIf
		GUICtrlSetState($Control_Buttons_Array[5], 32)
		GUICtrlSetState($Control_Buttons_Array[4], 16)
		GUIRegisterMsg(0x0084, "INTERNAL_WM_NCHITTEST")
		GUIRegisterMsg(0x0201, "INTERNAL_WM_LBUTTONDOWN")
		GUIRegisterMsg(0x0005, "INTERNAL_WM_SIZING")
	Else
		GUIRegisterMsg(0x0084, "")
		GUIRegisterMsg(0x0201, "")
		If (BitAND($mWin_State, 32) = 32) Then ; If maximized then
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[0], 1) ; left
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[1], 2) ; top
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[0] + $FullScreenPOS[2], 3) ; right
			DllStructSetData($tRET, "rcNormalPosition", $FullScreenPOS[1] + $FullScreenPOS[3], 4) ; bottom
			_WinAPI_SetWindowPlacement($mGUI, $tRET)
			Sleep(50)
			$GLOBAL_GUI_LIST[$iGui_Count][10] = $tRET
			GUISetState(@SW_RESTORE)
		Else
			Sleep(50)
			WinMove($mGUI, "", $FullScreenPOS[0], $FullScreenPOS[1], $FullScreenPOS[2], $FullScreenPOS[3])
		EndIf
		GUICtrlSetState($Control_Buttons_Array[4], 32)
		If Not ($Control_Buttons_Array[1] = "") Then
			GUICtrlSetState($Control_Buttons_Array[1], 32 + 128)
			GUICtrlSetState($Control_Buttons_Array[2], 32 + 128)
		EndIf
		GUICtrlSetState($Control_Buttons_Array[5], 16)
		$GLOBAL_GUI_LIST[$iGui_Count][5] = $CurrentPos[0]
		$GLOBAL_GUI_LIST[$iGui_Count][6] = $CurrentPos[1]
		$GLOBAL_GUI_LIST[$iGui_Count][7] = $CurrentPos[2]
		$GLOBAL_GUI_LIST[$iGui_Count][8] = $CurrentPos[3]
		$GLOBAL_GUI_LIST[$iGui_Count][9] = $mWin_State
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
Func _Metro_AddControlButton_Back($GUI_BG_Color = $GUIThemeColor, $GUI_Font_Color = $FontThemeColor)
	Local $cbDPI = _HighDPICheck()

	;Set Colors
	$GUI_Font_Color = StringReplace($GUI_Font_Color, "0x", "0xFF")
	$GUI_BG_Color = StringReplace($GUI_BG_Color, "0x", "0xFF")
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

	;Create Button Array
	Local $Control_Button_Array[16]

	;Calc Sizes
	Local $CBw = Number(45 * $cbDPI, 1)
	Local $CBh = Number(29 * $cbDPI, 1)
	Local $cMarginR = Number(2 * $cbDPI, 1)

	;Create GuiPics and set hover states
	
	$Control_Button_Array[1] = False ; Hover state
	$Control_Button_Array[2] = False ; Set inactive state
	$Control_Button_Array[3] = "0" ; Type
	$Control_Button_Array[15] = GetCurrentGUI()

	;Create Graphics
	Local $Control_Button_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
	Local $Control_Button_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4)
	Local $Control_Button_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)

	;Create Back Button

	;Calc size+pos
	Local $Cutpoint = Round(($FrameSize * 0.70) / 2)
	Local $mpX = $CBw / 2.95, $mpY = $CBh / 2.1
	Local $apos1 = cAngle($mpX, $mpY + $Cutpoint, 135, 12 * $cbDPI)
	Local $apos2 = cAngle($mpX, $mpY - $Cutpoint, 45, 12 * $cbDPI)

	;Add arrow
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic1[0], $mpX, $mpY + $Cutpoint, $apos1[0], $apos1[1], $hPen) ;r
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic1[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $hPen) ;l

	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic2[0], $mpX, $mpY + $Cutpoint, $apos1[0], $apos1[1], $hPen) ;r
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic2[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $hPen) ;l

	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic3[0], $mpX, $mpY + $Cutpoint, $apos1[0], $apos1[1], $hPen1) ;r
	_GDIPlus_GraphicsDrawLine($Control_Button_Graphic3[0], $mpX, $mpY - $Cutpoint, $apos2[0], $apos2[1], $hPen1) ;l
	;Release resources
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen1)

	;Create bitmap handles and set graphic
	$Control_Button_Array[0] = GUICtrlCreatePic("", $cMarginR, $cMarginR, $CBw, $CBh)
	$Control_Button_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Control_Button_Array[0], $Control_Button_Graphic1)
	$Control_Button_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Control_Button_Array[0], $Control_Button_Graphic2, False)
	$Control_Button_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Control_Button_Array[0], $Control_Button_Graphic3, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Control_Button_Array[0], 768 + 32 + 2)

	_Internal_AddHoverItem($Control_Button_Array)
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
Func _Metro_MenuStart($mGUI, $Metro_MenuBtn, $mWidth, $ButtonsArray, $bFont = "Arial", $bFontSize = 9, $bFontStyle = 1)

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
		$iButtonsArray[$iB] = _Internal_CreateMButton($ButtonsArray[$iB], 0, $ButtonStep * $iB + ($iB * 2), $mGuiWidth - $cMarginR, 30 * $cbDPI, $GUIThemeColor, $FontThemeColor, $bFont, $bFontSize, $bFontStyle)
	Next

	GUISetState(@SW_SHOW, $MenuForm)

	For $i = 0 To 8 Step +1
		$mGuiWidthAnim = $mGuiWidthAnim + $AnimStep
		WinMove($MenuForm, "", $mGuiX, $mGuiY, $mGuiWidthAnim, $mGuiHeight)
		
		Sleep(1)
	Next

	While 1
		_Metro_HoverCheck_Loop($MenuForm, $mGUI)
		_Metro_HoverCheck_Loop($mGUI, $MenuForm)
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
				GUICtrlSetState($Metro_MenuBtn, 64)
				Return $iB
			EndIf
		Next
	WEnd

EndFunc   ;==>_Metro_MenuStart


Func _Internal_CreateMButton($Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Arial", $Fontsize = 9, $FontStyle = 1, $FrameColor = "0xFFFFFF")
	Local $Button_Array[16]

	Local $btnDPI = 1
	If $HIGHDPI_SUPPORT Then
		$btnDPI = $gDPI
	Else
		$Fontsize = ($Fontsize / $Font_DPI_Ratio)
	EndIf

	
	$Button_Array[1] = False ; Set hover OFF
	$Button_Array[3] = "2" ; Type
	$Button_Array[15] = GetCurrentGUI()

	;Set Colors
	$BG_Color = StringReplace($BG_Color, "0x", "0xFF")
	$Font_Color = StringReplace($Font_Color, "0x", "0xFF")
	$FrameColor = StringReplace($FrameColor, "0x", "0xFF")
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)

	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $BG_ColorD = StringReplace(_AlterBrightness($GUIThemeColor, -12), "0x", "0xFF")
		$BG_Color = StringReplace(_AlterBrightness($GUIThemeColor, -25), "0x", "0xFF")
	Else
		Local $BG_ColorD = StringReplace(_AlterBrightness($GUIThemeColor, +12), "0x", "0xFF")
		$BG_Color = StringReplace(_AlterBrightness($GUIThemeColor, +25), "0x", "0xFF")
	EndIf

	;Create Button graphics
	Local $Button_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_ColorD, 0, 5) ;Default
	Local $Button_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5) ;Hover

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
	$Button_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)

	;For GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 802)

	_Internal_AddHoverItem($Button_Array)
	Return $Button_Array[0]
EndFunc   ;==>_Internal_CreateMButton



Func _Internal_CreateControlButtons($ButtonsToCreate_Array, $GUI_BG_Color = $GUIThemeColor, $GUI_Font_Color = "0xFFFFFF", $CloseButtonOnStyle = False)
	;HighDPI Support
	Local $cbDPI = _HighDPICheck()

	;Set Colors
	;=========================================================================
	Local $FrameSize = Round(1 * $cbDPI), $Hover_BK_Color
	$GUI_Font_Color = StringReplace($GUI_Font_Color, "0x", "0xFF")
	$GUI_BG_Color = StringReplace($GUI_BG_Color, "0x", "0xFF")
	If StringInStr($GUI_Theme_Name, "Light") Then
		$Hover_BK_Color = StringReplace(_AlterBrightness($GUI_BG_Color, -20), "0x", "0xFF")
	Else
		$Hover_BK_Color = StringReplace(_AlterBrightness($GUI_BG_Color, +20), "0x", "0xFF")
	EndIf
	Local $hPen = _GDIPlus_PenCreate($GUI_Font_Color, Round(1 * $cbDPI))
	Local $hPen2 = _GDIPlus_PenCreate($GUI_Font_Color, Round(1 * $cbDPI))
	Local $hPen3 = _GDIPlus_PenCreate("0xFFFFFFFF", Round(1 * $cbDPI))
	If StringInStr($GUI_Theme_Name, "Light") Then
		Local $hPen4 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUI_Font_Color, +60), "0x", "0xFF"), $FrameSize) ;inactive
	Else
		Local $hPen4 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness($GUI_Font_Color, -80), "0x", "0xFF"), $FrameSize) ;inactive
	EndIf
	Local $hPen5 = _GDIPlus_PenCreate(StringReplace(_AlterBrightness("0xFFFFFF", -80), "0x", "0xFF"), $FrameSize) ;inactive style 2
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
	Local $cMarginR = Number(2 * $cbDPI, 1)
	Local $CurrentGUI = GetCurrentGUI()

	Local $Win_POS = WinGetPos($CurrentGUI)
	Local $PosCount = 0

	;Create GuiPics and set hover states
	If $ButtonsToCreate_Array[0] Then
		$PosCount = $PosCount + 1
		$Button_Close_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		GUICtrlSetState(-1, 2048)
		$Button_Close_Array[1] = False ; Hover state
		$Button_Close_Array[2] = False ; Inactive Color state
		$Button_Close_Array[3] = "0" ; Type
		$Button_Close_Array[15] = $CurrentGUI
	EndIf

	If $ButtonsToCreate_Array[1] Then
		$PosCount = $PosCount + 1
		$Button_Maximize_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		GUICtrlSetState(-1, 2048)
		$Button_Maximize_Array[1] = False
		$Button_Maximize_Array[2] = False ; Inactive Color state
		$Button_Maximize_Array[3] = "3"
		$Button_Maximize_Array[15] = $CurrentGUI

		$Button_Restore_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		GUICtrlSetState(-1, 2048)
		$Button_Restore_Array[1] = False
		$Button_Restore_Array[2] = False ;Inactive Color state
		$Button_Restore_Array[3] = "4"
		$Button_Restore_Array[15] = $CurrentGUI
		If $ButtonsToCreate_Array[3] Then
			$Button_FSRestore_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
			GUICtrlSetState(-1, 2048)
			$Button_FSRestore_Array[1] = False
			$Button_FSRestore_Array[2] = False ; Inactive Color state
			$Button_FSRestore_Array[3] = "0"
			$Button_FSRestore_Array[15] = $CurrentGUI
		EndIf
	EndIf

	If $ButtonsToCreate_Array[2] Then
		$PosCount = $PosCount + 1
		$Button_Minimize_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		GUICtrlSetState(-1, 2048)
		$Button_Minimize_Array[1] = False
		$Button_Minimize_Array[2] = False ; Inactive Color state
		$Button_Minimize_Array[3] = "0"
		$Button_Minimize_Array[15] = $CurrentGUI
	EndIf

	If $ButtonsToCreate_Array[3] Then
		$PosCount = $PosCount + 1
		$Button_FullScreen_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
		GUICtrlSetState(-1, 2048)
		$Button_FullScreen_Array[1] = False
		$Button_FullScreen_Array[2] = False ; Inactive Color state
		$Button_FullScreen_Array[3] = "0"
		$Button_FullScreen_Array[15] = $CurrentGUI

		If Not ($Button_FSRestore_Array[15] = $CurrentGUI) Then
			$Button_FSRestore_Array[0] = GUICtrlCreatePic("", $Win_POS[2] - $cMarginR - ($CBw * $PosCount), $cMarginR, $CBw, $CBh)
			GUICtrlSetState(-1, 2048)
			$Button_FSRestore_Array[1] = False
			$Button_FSRestore_Array[2] = False ; Inactive Color state
			$Button_FSRestore_Array[3] = "0"
			$Button_FSRestore_Array[15] = $CurrentGUI
		EndIf
	EndIf

	If $ButtonsToCreate_Array[4] Then
		$Button_Menu_Array[0] = GUICtrlCreatePic("", $cMarginR, $cMarginR, $CBw, $CBh)
		GUICtrlSetState(-1, 2048)
		$Button_Menu_Array[1] = False
		$Button_Menu_Array[2] = False ; Inactive Color state
		$Button_Menu_Array[3] = "8"
		$Button_Menu_Array[15] = $CurrentGUI
	EndIf

	;Create Graphics
	If $ButtonsToCreate_Array[0] Then
		Local $Button_Close_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 4, 4), $Button_Close_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, "0xFFE81123", 4, 4), $Button_Close_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 4, 4)
	EndIf
	If $ButtonsToCreate_Array[1] Then
		Local $Button_Maximize_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Maximize_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Maximize_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
		Local $Button_Restore_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Restore_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Restore_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf
	If $ButtonsToCreate_Array[2] Then
		Local $Button_Minimize_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Minimize_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Minimize_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf
	If $ButtonsToCreate_Array[3] Then
		Local $Button_FullScreen_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_FullScreen_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_FullScreen_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
		Local $Button_FSRestore_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_FSRestore_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_FSRestore_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
	EndIf
	If $ButtonsToCreate_Array[4] Then
		Local $Button_Menu_Graphic1 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4), $Button_Menu_Graphic2 = _GDIPlusGraphic_Create($CBw, $CBh, $Hover_BK_Color, 0, 4), $Button_Menu_Graphic3 = _GDIPlusGraphic_Create($CBw, $CBh, $GUI_BG_Color, 0, 4)
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
		$Button_Close_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Close_Array[0], $Button_Close_Graphic1)
		$Button_Close_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Close_Array[0], $Button_Close_Graphic2, False)
		$Button_Close_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Close_Array[0], $Button_Close_Graphic3, False)
		GUICtrlSetResizing($Button_Close_Array[0], 768 + 32 + 4)
		$Control_Buttons[0] = $Button_Close_Array[0]
		_Internal_AddHoverItem($Button_Close_Array)
	EndIf
	If $ButtonsToCreate_Array[1] Then
		$Button_Maximize_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Maximize_Array[0], $Button_Maximize_Graphic1)
		$Button_Maximize_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Maximize_Array[0], $Button_Maximize_Graphic2, False)
		$Button_Maximize_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Maximize_Array[0], $Button_Maximize_Graphic3, False)
		$Button_Restore_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Restore_Array[0], $Button_Restore_Graphic1)
		$Button_Restore_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Restore_Array[0], $Button_Restore_Graphic2, False)
		$Button_Restore_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Restore_Array[0], $Button_Restore_Graphic3, False)
		GUICtrlSetResizing($Button_Maximize_Array[0], 768 + 32 + 4)
		GUICtrlSetResizing($Button_Restore_Array[0], 768 + 32 + 4)

		$Control_Buttons[1] = $Button_Maximize_Array[0]
		$Control_Buttons[2] = $Button_Restore_Array[0]
		GUICtrlSetState($Button_Restore_Array[0], 32)
		_Internal_AddHoverItem($Button_Maximize_Array)
		_Internal_AddHoverItem($Button_Restore_Array)
	EndIf

	If $ButtonsToCreate_Array[2] Then
		$Button_Minimize_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Minimize_Array[0], $Button_Minimize_Graphic1)
		$Button_Minimize_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Minimize_Array[0], $Button_Minimize_Graphic2, False)
		$Button_Minimize_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Minimize_Array[0], $Button_Minimize_Graphic3, False)
		GUICtrlSetResizing($Button_Minimize_Array[0], 768 + 32 + 4)
		$Control_Buttons[3] = $Button_Minimize_Array[0]
		_Internal_AddHoverItem($Button_Minimize_Array)
	EndIf

	If $ButtonsToCreate_Array[3] Then
		$Button_FullScreen_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_FullScreen_Array[0], $Button_FullScreen_Graphic1)
		$Button_FullScreen_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_FullScreen_Array[0], $Button_FullScreen_Graphic2, False)
		$Button_FullScreen_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_FullScreen_Array[0], $Button_FullScreen_Graphic3, False)

		$Button_FSRestore_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_FSRestore_Array[0], $Button_FSRestore_Graphic1)
		$Button_FSRestore_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_FSRestore_Array[0], $Button_FSRestore_Graphic2, False)
		$Button_FSRestore_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_FSRestore_Array[0], $Button_FSRestore_Graphic3, False)

		GUICtrlSetResizing($Button_FullScreen_Array[0], 768 + 32 + 4)
		GUICtrlSetResizing($Button_FSRestore_Array[0], 768 + 32 + 4)
		GUICtrlSetState($Button_FSRestore_Array[0], 32)

		$Control_Buttons[4] = $Button_FullScreen_Array[0]
		$Control_Buttons[5] = $Button_FSRestore_Array[0]
		_Internal_AddHoverItem($Button_FullScreen_Array)
		_Internal_AddHoverItem($Button_FSRestore_Array)
	EndIf

	If $ButtonsToCreate_Array[4] Then
		$Button_Menu_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Menu_Array[0], $Button_Menu_Graphic1)
		$Button_Menu_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Menu_Array[0], $Button_Menu_Graphic2, False)
		$Button_Menu_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Menu_Array[0], $Button_Menu_Graphic3, False)
		GUICtrlSetResizing($Button_Menu_Array[0], 768 + 32 + 2)
		$Control_Buttons[6] = $Button_Menu_Array[0]
		_Internal_AddHoverItem($Button_Menu_Array)
	EndIf

	Return $Control_Buttons
EndFunc   ;==>_Internal_CreateControlButtons

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

Func _Metro_CreateButton($Text, $Left, $Top, $Width, $Height, $BG_Color = $ButtonBKColor, $Font_Color = $ButtonTextColor, $Font = "Arial", $Fontsize = 11, $FontStyle = 1, $FrameColor = "0xFFFFFF")
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
	Local $Button_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5) ;Default
	Local $Button_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5) ;Hover
	Local $Button_Graphic3 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5) ;Disabled

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
	$Button_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)
	$Button_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic3, False)

	;For GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 768)

	_Internal_AddHoverItem($Button_Array)
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

Func _Metro_CreateButtonEx($Text, $Left, $Top, $Width, $Height, $BG_Color = $ButtonBKColor, $Font_Color = $ButtonTextColor, $Font = "Arial", $Fontsize = 11, $FontStyle = 1, $FrameColor = "0xFFFFFF")
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
	Local $Button_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5) ;Default
	Local $Button_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, StringReplace(_AlterBrightness($BG_Color, 25), "0x", "0xFF"), 0, 5) ;Hover
	Local $Button_Graphic3 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5) ;Disabled

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
	$Button_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic1)
	$Button_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic2, False)
	$Button_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Button_Array[0], $Button_Graphic3, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Button_Array[0], 768)

	_Internal_AddHoverItem($Button_Array)
	Return $Button_Array[0]

EndFunc   ;==>_Metro_CreateButtonEx

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
	For $i_BTN = 0 To (UBound($GLOBAL_HOVER_REG) - 1)
		If ($GLOBAL_HOVER_REG[$i_BTN][0] = $mButton) And ($GLOBAL_HOVER_REG[$i_BTN][15] = $CurrentGUI) Then
			_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][7]))
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
	For $i_BTN = 0 To (UBound($GLOBAL_HOVER_REG) - 1)
		If ($GLOBAL_HOVER_REG[$i_BTN][0] = $mButton) And ($GLOBAL_HOVER_REG[$i_BTN][15] = $CurrentGUI) Then
			_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][5]))
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
	If $HIGHDPI_SUPPORT = True Then
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
		Local $BoxFrameCol = StringReplace(_AlterBrightness($Font_Color, +45), "0x", "0xFF")
		Local $BoxFrameCol1 = StringReplace(_AlterBrightness($Font_Color, +30), "0x", "0xFF")
		Local $Font_Color1 = StringReplace(_AlterBrightness($Font_Color, +60), "0x", "0xFF")
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
	Local $Toggle_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic3 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic4 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic5 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic6 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic7 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic8 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic9 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5), $Toggle_Graphic10 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5)

	;Set font options
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
	$Toggle_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic1)
	$Toggle_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic2, False)
	$Toggle_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic3, False)
	$Toggle_Array[8] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic4, False)
	$Toggle_Array[9] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic5, False)
	$Toggle_Array[10] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic6, False)
	$Toggle_Array[11] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic7, False)
	$Toggle_Array[12] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic8, False)
	$Toggle_Array[13] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic9, False)
	$Toggle_Array[14] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic10, False)

	;Set Control Resizing
	GUICtrlSetResizing($Toggle_Array[0], 768)

	;Add to GUI_HOVER_REG
	_Internal_AddHoverItem($Toggle_Array)

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
	If Not (Mod($Height, 2) = 0) Then
		If (@Compiled = 0) Then MsgBox(48, "Metro UDF", "The toggle height should be an even number to prevent any misplacing.")
	EndIf

	;HighDPI Support
	If $HIGHDPI_SUPPORT Then
		$Left = Round($Left * $gDPI)
		$Top = Round($Top * $gDPI)
		$Width = Round($Width * $gDPI)
		$Height = Round($Height * $gDPI)
		If Not (Mod($Height, 2) = 0) Then $Height = $Height + 1
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
	If Not (Mod($TopMargCalc, 2) = 0) Then $TopMargCalc = $TopMargCalc + 1
	Local $TopMargin = Number((($Height - $TopMargCalc) / 2), 1)
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
	Local $Toggle_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic3 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic4 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic5 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic6 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic7 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic8 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic9 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5), $Toggle_Graphic10 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 0, 5)

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
	$Toggle_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic1)
	$Toggle_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic2, False)
	$Toggle_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic3, False)
	$Toggle_Array[8] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic4, False)
	$Toggle_Array[9] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic5, False)
	$Toggle_Array[10] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic6, False)
	$Toggle_Array[11] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic7, False)
	$Toggle_Array[12] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic8, False)
	$Toggle_Array[13] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic9, False)
	$Toggle_Array[14] = _GDIPlusGraphic_CreateBitmapHandle($Toggle_Array[0], $Toggle_Graphic10, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Toggle_Array[0], 768)

	;Add to GUI_HOVER_REG
	_Internal_AddHoverItem($Toggle_Array)

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
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Toggle Then
			If $GLOBAL_HOVER_REG[$i][2] Then
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
EndFunc   ;==>_Metro_ToggleIsChecked


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_ToggleUnCheck
; Description ...: Unchecks a toggle
; Syntax ........: _Metro_ToggleUnCheck($Toggle[, $NoAnimation = False])
; Parameters ....: $Toggle              - Handle to the toggle
;                  $NoAnimation         - [optional] True/False. Default is False. - Unchecks the toggle instantly without animation.
; ===============================================================================================================================
Func _Metro_ToggleUnCheck($Toggle, $NoAnimation = False)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Toggle Then
			If $GLOBAL_HOVER_REG[$i][2] Then
				If Not $NoAnimation Then
					For $i2 = 12 To 6 Step -1
						_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $GLOBAL_HOVER_REG[$i][$i2]))
						Sleep(1)
					Next
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $GLOBAL_HOVER_REG[$i][13]))
				Else
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $GLOBAL_HOVER_REG[$i][13]))
				EndIf
				$GLOBAL_HOVER_REG[$i][1] = True
				$GLOBAL_HOVER_REG[$i][2] = False
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
;                  $NoAnimation         - [optional] True/False. Default is False. - Checks the Toggle instantly without an animation. Should be used when creating a gui with a checked toggle before the gui is shown.
; ===============================================================================================================================
Func _Metro_ToggleCheck($Toggle, $NoAnimation = False)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Toggle Then
			If Not $GLOBAL_HOVER_REG[$i][2] Then
				If Not $NoAnimation Then
					For $i2 = 6 To 11 Step +1
						_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $GLOBAL_HOVER_REG[$i][$i2]))
						Sleep(1)
					Next
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $GLOBAL_HOVER_REG[$i][14]))
				Else
					_WinAPI_DeleteObject(GUICtrlSendMsg($Toggle, 0x0172, 0, $GLOBAL_HOVER_REG[$i][14]))
				EndIf
				$GLOBAL_HOVER_REG[$i][2] = True
				$GLOBAL_HOVER_REG[$i][1] = True
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
Func _Metro_CreateRadio($RadioGroup, $Text, $Left, $Top, $Width, $Height, $BG_Color = $GUIThemeColor, $Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "11", $FontStyle = 0, $RadioCircleSize = 22)
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
		If Not (Mod($Width, 2) = 0) Then $Width = $Width - 1
		If Not (Mod($Height, 2) = 0) Then $Height = $Height - 1
		$RadioCircleSize = $RadioCircleSize * $gDPI
		If Not (Mod($RadioCircleSize, 2) = 0) Then $RadioCircleSize = $RadioCircleSize - 1
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
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
	$Font_Color = "0xFF" & Hex($Font_Color, 6)
	Local $Brush_BTN_FontColor = _GDIPlus_BrushCreateSolid($Font_Color)
	Local $BoxFrameCol = StringReplace($CB_Radio_Hover_Color, "0x", "0xFF")
	Local $Brush1 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Color, "0x", "0xFF"))
	Local $Brush2 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_CheckMark_Color, "0x", "0xFF"))
	Local $Brush3 = _GDIPlus_BrushCreateSolid(StringReplace($CB_Radio_Hover_Color, "0x", "0xFF"))

	;Create graphics
	Local $Radio_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;default state
	Local $Radio_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;checked state
	Local $Radio_Graphic3 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;default hover state
	Local $Radio_Graphic4 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;checked hover state

	;Create font, Set font options
	Local $hFormat = _GDIPlus_StringFormatCreate(), $hFamily = _GDIPlus_FontFamilyCreate($Font), $hFont = _GDIPlus_FontCreate($hFamily, $Fontsize, $FontStyle)
	Local $tLayout = _GDIPlus_RectFCreate(30 * $rDPI, 0, $Width - (30 * $rDPI), $Height)
	_GDIPlus_StringFormatSetAlign($hFormat, 1)
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
	$Radio_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Radio_Array[0], $Radio_Graphic1)
	$Radio_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Radio_Array[0], $Radio_Graphic2, False)
	$Radio_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Radio_Array[0], $Radio_Graphic3, False)
	$Radio_Array[8] = _GDIPlusGraphic_CreateBitmapHandle($Radio_Array[0], $Radio_Graphic4, False)

	;Set GUI Resizing
	GUICtrlSetResizing($Radio_Array[0], 768)

	;Add Hover effects
	_Internal_AddHoverItem($Radio_Array)

	Return $Radio_Array[0]
EndFunc   ;==>_Metro_CreateRadio


; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_RadioCheck
; Description ...: Checks the selected radio and unchecks all other radios in the same radiogroup.
; Syntax ........: _Metro_RadioCheck($RadioGroup, $Radio)
; Parameters ....: $RadioGroup          - The group that the radio has been assigned to.
;                  $Radio               - Handle to the radio.
; ===============================================================================================================================
Func _Metro_RadioCheck($RadioGroup, $Radio)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Radio Then
			$GLOBAL_HOVER_REG[$i][1] = True
			$GLOBAL_HOVER_REG[$i][2] = True
			_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i][8]))
		Else
			If $GLOBAL_HOVER_REG[$i][4] = $RadioGroup Then
				$GLOBAL_HOVER_REG[$i][2] = False
				_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i][5]))
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
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Radio Then
			If $GLOBAL_HOVER_REG[$i][4] = $RadioGroup Then
				If $GLOBAL_HOVER_REG[$i][2] Then
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
		If Not (Mod($Width, 2) = 0) Then $Width = $Width + 1
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
	$BG_Color = "0xFF" & Hex($BG_Color, 6)
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
	Local $Checkbox_Graphic1 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;default state
	Local $Checkbox_Graphic2 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;checked state
	Local $Checkbox_Graphic3 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;default hover state
	Local $Checkbox_Graphic4 = _GDIPlusGraphic_Create($Width, $Height, $BG_Color, 5, 5) ;checked hover state

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
	$Checkbox_Array[5] = _GDIPlusGraphic_CreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic1)
	$Checkbox_Array[7] = _GDIPlusGraphic_CreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic2, False)
	$Checkbox_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic3, False)
	$Checkbox_Array[8] = _GDIPlusGraphic_CreateBitmapHandle($Checkbox_Array[0], $Checkbox_Graphic4, False)

	;For GUI Resizing
	GUICtrlSetResizing($Checkbox_Array[0], 768)

	_Internal_AddHoverItem($Checkbox_Array)

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
; Name ..........: _Metro_CheckboxIsChecked
; Description ...: Checks if a metro checkbox is checked.
; Syntax ........: _Metro_CheckboxIsChecked($Checkbox)
; Parameters ....: $Checkbox            - Handle to the checkbox.
; Return values .: True / False
; ===============================================================================================================================
Func _Metro_CheckboxIsChecked($Checkbox)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Checkbox Then
			If $GLOBAL_HOVER_REG[$i][2] Then
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
; Syntax ........: _Metro_CheckboxUnCheck($Checkbox)
; Parameters ....: $Checkbox            - Handle to the Checkbox.
; ===============================================================================================================================
Func _Metro_CheckboxUnCheck($Checkbox)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Checkbox Then
			$GLOBAL_HOVER_REG[$i][2] = False
			$GLOBAL_HOVER_REG[$i][1] = True
			_WinAPI_DeleteObject(GUICtrlSendMsg($Checkbox, 0x0172, 0, $GLOBAL_HOVER_REG[$i][6]))
		EndIf
	Next
EndFunc   ;==>_Metro_CheckboxUnCheck

; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_CheckboxCheck
; Description ...: Checks a metro checkbox
; Syntax ........: _Metro_CheckboxCheck($Checkbox)
; Parameters ....: $Checkbox            - Handle to the Checkbox.
; ===============================================================================================================================
Func _Metro_CheckboxCheck($Checkbox)
	For $i = 0 To (UBound($GLOBAL_HOVER_REG) - 1) Step +1
		If $GLOBAL_HOVER_REG[$i][0] = $Checkbox Then
			$GLOBAL_HOVER_REG[$i][2] = True
			$GLOBAL_HOVER_REG[$i][1] = True
			_WinAPI_DeleteObject(GUICtrlSendMsg($Checkbox, 0x0172, 0, $GLOBAL_HOVER_REG[$i][8]))
		EndIf
	Next
EndFunc   ;==>_Metro_CheckboxCheck
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

	Local $1stButton = _Metro_CreateButton($1stButtonText, $1stButton_Left, ($mHeight / $msgbDPI) - 50, 100, 36, $ButtonBKColor, $ButtonTextColor)
	Local $2ndButton = _Metro_CreateButton($2ndButtonText, $2ndButton_Left, ($mHeight / $msgbDPI) - 50, 100, 36, $ButtonBKColor, $ButtonTextColor)
	If $Buttons_Count < 2 Then GUICtrlSetState($2ndButton, 32)
	Local $3rdButton = _Metro_CreateButton($3rdButtonText, $3rdButton_Left, ($mHeight / $msgbDPI) - 50, 100, 36, $ButtonBKColor, $ButtonTextColor)
	If $Buttons_Count < 3 Then GUICtrlSetState($3rdButton, 32)
	GUISetState(@SW_SHOW)

	If Not ($Timeout = 0) Then
		$Internal_MsgBoxTimeout = $Timeout
		AdlibRegister("_Internal_MsgBoxTimeout", 1000)
	EndIf
	
	While 1
		_Metro_HoverCheck_Loop($MsgBox_Form)
		If Not ($Timeout = 0) Then
			If $Internal_MsgBoxTimeout <= 0 Then
				AdlibUnRegister("_Internal_MsgBoxTimeout")
				_Metro_GUIDelete($MsgBox_Form)
				Return SetError(1)
			EndIf
		EndIf
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case -3, $1stButton
				_Metro_GUIDelete($MsgBox_Form)
				Return $1stButtonText
			Case $2ndButton
				_Metro_GUIDelete($MsgBox_Form)
				Return $2ndButtonText
			Case $3rdButton
				_Metro_GUIDelete($MsgBox_Form)
				Return $3rdButtonText
		EndSwitch
	WEnd

EndFunc   ;==>_Metro_MsgBox

#EndRegion Metro MsgBox===========================================================================================

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
	Local $Progress_Graphic = _GDIPlusGraphic_Create($Width, $Height, $Progress_Array[3], 1, 5)

	;Draw Progressbar border
	If $EnableBorder Then
		_GDIPlus_GraphicsDrawRect($Progress_Graphic[0], 0, 0, $Width, $Height, $ProgressBGPen)
	EndIf

	;Release created objects
	_GDIPlus_PenDispose($ProgressBGPen)

	;Create bitmap handles and set graphics
	$Progress_Array[0] = GUICtrlCreatePic("", $Left, $Top, $Width, $Height)
	$Progress_Array[6] = _GDIPlusGraphic_CreateBitmapHandle($Progress_Array[0], $Progress_Graphic)

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
	Local $Progress_Graphic = _GDIPlusGraphic_Create($Progress[1], $Progress[2], $Progress[3], 1, 5)

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
	Local $SetProgress = _GDIPlusGraphic_CreateBitmapHandle($Progress[0], $Progress_Graphic)
	_WinAPI_DeleteObject($Progress[6])

	$Progress[6] = $SetProgress
EndFunc   ;==>_Metro_SetProgress
#EndRegion Metro Progressbar===========================================================================================


#Region HoverEffects===========================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _Metro_HoverCheck_Loop
; Description ...: Checks all created buttons, checkboxes etc for mouse hover. Required for the hover effects. This has to be added to the main while loop of the GUI.
; Syntax ........: _Metro_HoverCheck_Loop($Metro_GUI[, $Metro_GUI_2 = 0])
; Parameters ....:
;                  $Metro_GUI           - The GUI to check for the mouse hover.
;                  $Metro_GUI_2         - [optional] Prevents the main gui from losing focus(inactivity colors set) as long as the second provided gui is still active
; ===============================================================================================================================
Func _Metro_HoverCheck_Loop($Metro_GUI, $Metro_GUI_2 = 0)

	Local $mHoverCheck = CheckGUIHover($Metro_GUI), $MInfo = GUIGetCursorInfo($Metro_GUI), $mWin_State = WinGetState($Metro_GUI)
	For $i_BTN = 0 To (UBound($GLOBAL_HOVER_REG) - 1)
		If $GLOBAL_HOVER_REG[$i_BTN][15] = $Metro_GUI Then
			Switch $GLOBAL_HOVER_REG[$i_BTN][3]
				Case "3" ;Swap Max/Restore buttons on state change
					If Not (BitAND($mWin_State, 32) = 32) Then
						If GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 96 Then GUICtrlSetState($GLOBAL_HOVER_REG[$i_BTN][0], 16)
					Else
						If GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 80 Then GUICtrlSetState($GLOBAL_HOVER_REG[$i_BTN][0], 32)
					EndIf
				Case "4" ;Swap Max/Restore buttons on state change
					If BitAND($mWin_State, 32) = 32 Then
						If GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 96 Then GUICtrlSetState($GLOBAL_HOVER_REG[$i_BTN][0], 16)
					Else
						If GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 80 Then GUICtrlSetState($GLOBAL_HOVER_REG[$i_BTN][0], 32)
					EndIf
				Case "5", "7" ;Check hover for checkboxes and radios
					If $MInfo[4] = $GLOBAL_HOVER_REG[$i_BTN][0] And $mHoverCheck Then ;Enable hover
						If (Not $GLOBAL_HOVER_REG[$i_BTN][1]) And Not (GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 144) Then
							$GLOBAL_HOVER_REG[$i_BTN][1] = True
							If $GLOBAL_HOVER_REG[$i_BTN][2] Then
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][8])) ;Checked hover image
							Else
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][6])) ;Default hover image
							EndIf
						EndIf
					Else ;Disable hover
						If $GLOBAL_HOVER_REG[$i_BTN][1] Then
							$GLOBAL_HOVER_REG[$i_BTN][1] = False
							If $GLOBAL_HOVER_REG[$i_BTN][2] Then
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][7])) ;Checked image
							Else
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][5])) ;Default image
							EndIf
						EndIf
					EndIf
					ContinueLoop
				Case "6" ;Check hover for Toggles
					If $MInfo[4] = $GLOBAL_HOVER_REG[$i_BTN][0] And $mHoverCheck Then
						If (Not $GLOBAL_HOVER_REG[$i_BTN][1]) And Not (GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 144) Then
							$GLOBAL_HOVER_REG[$i_BTN][1] = True
							If $GLOBAL_HOVER_REG[$i_BTN][2] Then
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][14])) ;Checked hover image
							Else
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][13])) ;Default hover image
							EndIf
						EndIf
					Else ;Disable hover Toggles
						If $GLOBAL_HOVER_REG[$i_BTN][1] Then
							$GLOBAL_HOVER_REG[$i_BTN][1] = False
							If $GLOBAL_HOVER_REG[$i_BTN][2] Then
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][12])) ;Checked image
							Else
								_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][5])) ;Default image
							EndIf
						EndIf
					EndIf
					ContinueLoop
			EndSwitch

			;Enable Hover for Buttons
			If $MInfo[4] = $GLOBAL_HOVER_REG[$i_BTN][0] And $mHoverCheck Then ;If mouseover
				If (Not $GLOBAL_HOVER_REG[$i_BTN][1]) And Not (GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 144) Then ;if not hover on allready and button enabled
					$GLOBAL_HOVER_REG[$i_BTN][1] = True
					$GLOBAL_HOVER_REG[$i_BTN][2] = False
					_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][6])) ;Button hover image
				EndIf
				GUISetCursor(2, 1)
				ContinueLoop
			EndIf
			;Disable hover for Buttons
			If $GLOBAL_HOVER_REG[$i_BTN][1] Then
				If $GLOBAL_HOVER_REG[$i_BTN][3] = "8" Then
					If Not (GUICtrlGetState($GLOBAL_HOVER_REG[$i_BTN][0]) = 144) Then
						$GLOBAL_HOVER_REG[$i_BTN][1] = False
						_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][5])) ;Button default image
					EndIf
				Else
					$GLOBAL_HOVER_REG[$i_BTN][1] = False
					_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][5])) ;Button default image
				EndIf
			EndIf

			;Set Active/Inactive color for control buttons
			Switch $GLOBAL_HOVER_REG[$i_BTN][3]
				Case 0, 3, 4, 8
					If WinActive($Metro_GUI) Or WinActive($Metro_GUI_2) Then
						If $GLOBAL_HOVER_REG[$i_BTN][2] Then
							_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][5])) ;Button default image
							$GLOBAL_HOVER_REG[$i_BTN][2] = False
						EndIf
					Else
						If Not $GLOBAL_HOVER_REG[$i_BTN][2] Then
							_WinAPI_DeleteObject(GUICtrlSendMsg($GLOBAL_HOVER_REG[$i_BTN][0], 0x0172, 0, $GLOBAL_HOVER_REG[$i_BTN][7]))
							$GLOBAL_HOVER_REG[$i_BTN][2] = True
						EndIf
					EndIf
			EndSwitch
		EndIf
	Next
	
EndFunc   ;==>_Metro_HoverCheck_Loop

Func _Internal_AddHoverItem($Button_ADD)
	Local $GLOBAL_HRSize = UBound($GLOBAL_HOVER_REG)
	ReDim $GLOBAL_HOVER_REG[$GLOBAL_HRSize + 1][16]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][0] = $Button_ADD[0]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][1] = $Button_ADD[1]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][2] = $Button_ADD[2]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][3] = $Button_ADD[3]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][4] = $Button_ADD[4]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][5] = $Button_ADD[5]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][6] = $Button_ADD[6]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][7] = $Button_ADD[7]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][8] = $Button_ADD[8]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][9] = $Button_ADD[9]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][10] = $Button_ADD[10]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][11] = $Button_ADD[11]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][12] = $Button_ADD[12]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][13] = $Button_ADD[13]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][14] = $Button_ADD[14]
	$GLOBAL_HOVER_REG[$GLOBAL_HRSize][15] = $Button_ADD[15]
EndFunc   ;==>_Internal_AddHoverItem

Func _Internal_GUIRemoveHover($mGUI)
	Local $Cleaned_Hover_REG[0]
	For $i_HR = 0 To UBound($GLOBAL_HOVER_REG) - 1 Step +1
		If Not ($GLOBAL_HOVER_REG[$i_HR][15] = $mGUI) Then
			ReDim $Cleaned_Hover_REG[UBound($Cleaned_Hover_REG) + 1][16]
			For $i_Hx = 0 To 15 Step +1
				$Cleaned_Hover_REG[UBound($Cleaned_Hover_REG) - 1][$i_Hx] = $GLOBAL_HOVER_REG[$i_HR][$i_Hx]
			Next
		EndIf
	Next
	$GLOBAL_HOVER_REG = $Cleaned_Hover_REG
EndFunc   ;==>_Internal_GUIRemoveHover

#EndRegion HoverEffects===========================================================================================

#Region Required_Funcs===========================================================================================
Func _GDIPlusGraphic_Create($hWidth, $hHeight, $BackgroundColor = 0, $Smoothingmode = 4, $TextCleartype = 0)
	Local $Picture_Array[2]
	$Picture_Array[1] = _GDIPlus_BitmapCreateFromScan0($hWidth, $hHeight)
	$Picture_Array[0] = _GDIPlus_ImageGetGraphicsContext($Picture_Array[1])
	_GDIPlus_GraphicsSetSmoothingMode($Picture_Array[0], $Smoothingmode)
	_GDIPlus_GraphicsSetTextRenderingHint($Picture_Array[0], $TextCleartype)
	If Not ($BackgroundColor = 0) Then _GDIPlus_GraphicsClear($Picture_Array[0], $BackgroundColor)
	Return $Picture_Array
EndFunc   ;==>_GDIPlusGraphic_Create


Func _GDIPlusGraphic_CreateBitmapHandle($hPicture, $Picture_Array, $hVisible = True)
	Local $cBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($Picture_Array[1])
	If $hVisible = True Then _WinAPI_DeleteObject(GUICtrlSendMsg($hPicture, 0x0172, 0, $cBitmap))
	_GDIPlus_GraphicsDispose($Picture_Array[0])
	_GDIPlus_BitmapDispose($Picture_Array[1])
	Return $cBitmap
EndFunc   ;==>_GDIPlusGraphic_CreateBitmapHandle

Func GetCurrentGUI() ;Thanks @binhnx
	Local $idCtrlDummy = GUICtrlCreateLabel("", 0, 0, 0, 0)
	Local $hWndCurrent = _WinAPI_GetParent(GUICtrlGetHandle($idCtrlDummy))
	GUICtrlDelete($idCtrlDummy)
	Return $hWndCurrent
EndFunc   ;==>GetCurrentGUI
Func _HighDPICheck()
	If $HIGHDPI_SUPPORT Then
		Return $gDPI
	Else
		Return "1"
	EndIf
EndFunc   ;==>_HighDPICheck

Func cAngle($x1, $y1, $Ang, $Length)
	Local $Return[2]
	$Return[0] = $x1 + ($Length * Sin($Ang / 180 * 3.14159265358979))
	$Return[1] = $y1 + ($Length * Cos($Ang / 180 * 3.14159265358979))
	Return $Return
EndFunc   ;==>cAngle

Func _GUICtrlSetFont($icontrolID, $iSize, $iweight = 400, $iattribute = 0, $sfontname = "", $iquality = 5)
	If $HIGHDPI_SUPPORT = True Then
		GUICtrlSetFont($icontrolID, $iSize, $iweight, $iattribute, $sfontname, $iquality)
	Else
		GUICtrlSetFont($icontrolID, $iSize / $Font_DPI_Ratio, $iweight, $iattribute, $sfontname, $iquality)
	EndIf
EndFunc   ;==>_GUICtrlSetFont

Func _SetFont_GetDPI()
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
EndFunc   ;==>_SetFont_GetDPI

Func CheckGUIHover($mGUIh)
	If WinActive($mGUIh) Then Return True
	Local Static $g_tStruct = DllStructCreate($tagPOINT)
	DllStructSetData($g_tStruct, "x", MouseGetPos(0))
	DllStructSetData($g_tStruct, "y", MouseGetPos(1))
	If _WinAPI_GetAncestor(_WinAPI_WindowFromPoint($g_tStruct), $GA_ROOT) = $mGUIh Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CheckGUIHover

Func _Internal_MsgBoxTimeout()
	$Internal_MsgBoxTimeout -= 1
EndFunc   ;==>_Internal_MsgBoxTimeout

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

Func _CreateBorder($guiW, $guiH, $bordercolor = 0xFFFFFF, $style = 1, $borderThickness = 1)
	If $style = 0 Then
		;#TOP#
		GUICtrlCreateLabel("", 0, 0, $guiW, $borderThickness)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 544)
		GUICtrlSetState(-1, 128)
		;#Bottom
		GUICtrlCreateLabel("", 0, $guiH - $borderThickness, $guiW, $borderThickness)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 576)
		GUICtrlSetState(-1, 128)
		;#Left
		GUICtrlCreateLabel("", 0, 1, $borderThickness, $guiH - 1)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 256 + 2)
		GUICtrlSetState(-1, 128)
		;#Right
		GUICtrlCreateLabel("", $guiW - $borderThickness, 1, $borderThickness, $guiH - 1)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 256 + 4)
		GUICtrlSetState(-1, 128)
	Else
		;#TOP#
		GUICtrlCreateLabel("", 1, 1, $guiW - 2, $borderThickness)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 544)
		GUICtrlSetState(-1, 128)
		;#Bottom
		GUICtrlCreateLabel("", 1, $guiH - $borderThickness - 1, $guiW - 2, $borderThickness)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 576)
		GUICtrlSetState(-1, 128)
		;#Left
		GUICtrlCreateLabel("", 1, 1, $borderThickness, $guiH - 2)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 256 + 2)
		GUICtrlSetState(-1, 128)
		;#Right
		GUICtrlCreateLabel("", $guiW - $borderThickness - 1, 1, $borderThickness, $guiH - 2)
		GUICtrlSetColor(-1, $bordercolor)
		GUICtrlSetBkColor(-1, $bordercolor)
		GUICtrlSetResizing(-1, 256 + 4)
		GUICtrlSetState(-1, 128)
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


