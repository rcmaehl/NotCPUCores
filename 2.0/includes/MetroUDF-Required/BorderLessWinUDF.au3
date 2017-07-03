#include-once
#include <WinAPIGdi.au3>

Global $GLOBAL_GUI_LIST[0], $gDPI

;Prevent Borders/Frame from drawing
Func INTERNAL_INTERCEPT_FRAMEDRAW($hWnd, $iMsg, $wParam, $lParam)
	 _Int_GetGUIID($hWnd)
	 If @error Then Return 'GUI_RUNDEFMSG'
	Return -1
EndFunc   ;==>INTERNAL_INTERCEPT_FRAMEDRAW

;Fix maximized position
Func INTERNAL_WM_SIZING($hWnd, $iMsg, $wParam, $lParam)
	Local $iGui_Count = _Int_GetGUIID($hWnd)
	If @error Then Return 'GUI_RUNDEFMSG'
	If $GLOBAL_GUI_LIST[$iGui_Count][2] Then
		If (WinGetState($hWnd) = 47) Then
			Local $WrkSize = _GetDesktopWorkArea($hWnd)
			Local $aWinPos = WinGetPos($hWnd)
			WinMove($hWnd, "", $aWinPos[0] - 1, $aWinPos[1] - 1, $WrkSize[2], $WrkSize[3])
		EndIf
	EndIf
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>INTERNAL_WM_SIZING

; Set min and max GUI sizes
Func INTERNAL_WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)
	Local $iGui_Count = _Int_GetGUIID($hWnd)
	If @error Then Return 'GUI_RUNDEFMSG'
	
	If $GLOBAL_GUI_LIST[$iGui_Count][2] Then
		Local $tMinMax = DllStructCreate("int;int;int;int;int;int;int;int;int;dword", $lParam)
		Local $WrkSize = _GetDesktopWorkArea($hWnd)
		;Prevent Windows from misplacing the GUI when maximized. (Due to missing borders.)
		DllStructSetData($tMinMax, 3, $WrkSize[2])
		DllStructSetData($tMinMax, 4, $WrkSize[3])
		DllStructSetData($tMinMax, 5, $WrkSize[0] + 1)
		DllStructSetData($tMinMax, 6, $WrkSize[1] + 1)
		;Min Size limits
		DllStructSetData($tMinMax, 7, $GLOBAL_GUI_LIST[$iGui_Count][3])
		DllStructSetData($tMinMax, 8, $GLOBAL_GUI_LIST[$iGui_Count][4])
		Return 0
	Else
		Return 'GUI_RUNDEFMSG'
	EndIf
EndFunc   ;==>INTERNAL_WM_GETMINMAXINFO

;Set mouse cursor for resizing etc. / Allow the upper GUI (40 pixel from top) to act as a control bar (doubleclick to maximize, move gui around..)
Func INTERNAL_WM_NCHITTEST($hWnd, $uMsg, $wParam, $lParam)

	Local $iGui_Count = _Int_GetGUIID($hWnd)
	If @error Then Return 'GUI_RUNDEFMSG'
	
	If $GLOBAL_GUI_LIST[$iGui_Count][2] Then
		Local $iSide = 0, $iTopBot = 0, $CurSorInfo

		Local $mPos = MouseGetPos()
		Local $aWinPos = WinGetPos($hWnd)
		Local $curInf = GUIGetCursorInfo($hWnd)

		;Check if Mouse is over Border, Margin = 5
		Local $bMarg=5*$gDPI
		If Not @error Then
			If $curInf[0] < $bMarg Then $iSide = 1
			If $curInf[0] > $aWinPos[2] - $bMarg Then $iSide = 2
			If $curInf[1] < $bMarg Then $iTopBot = 3
			If $curInf[1] > $aWinPos[3] - $bMarg Then $iTopBot = 6
			$CurSorInfo = $iSide + $iTopBot
		Else
			$CurSorInfo = 0
		EndIf

		Local $tMarg = 32* $gDPI
		;Set position for drag and doubleclick to maximize
		Local $xMIN, $xMAX, $yMIN, $yMAX
		$xMIN = $aWinPos[0] + 4
		$xMAX = $aWinPos[0] + $aWinPos[2] - 4
		$yMIN = $aWinPos[1] + 4
		$yMAX = $aWinPos[1] + $tMarg
		If WinActive($hWnd) Then
			If ($mPos[0] >= $xMIN) And ($mPos[0] <= $xMAX) And ($mPos[1] >= $yMIN) And ($mPos[1] <= $yMAX) Then
				GUISetCursor(2, 1)
				Return 2 ; Return $HTCAPTION if mouse is within the position for drag + doubleclick to maximize
			EndIf
		EndIf
		If Not (WinGetState($hWnd) = 47) Then
			;Set resize cursor and return the correct $HT for gui resizing
			If ($curInf[4] < 8) Then
				Local $Return_HT = 2, $Set_Cursor = 2
				Switch $CurSorInfo
					Case 1
						$Set_Cursor = 13
						$Return_HT = 10
					Case 2
						$Set_Cursor = 13
						$Return_HT = 11
					Case 3
						$Set_Cursor = 11
						$Return_HT = 12
					Case 4
						$Set_Cursor = 12
						$Return_HT = 13
					Case 5
						$Set_Cursor = 10
						$Return_HT = 14
					Case 6
						$Set_Cursor = 11
						$Return_HT = 15
					Case 7
						$Set_Cursor = 10
						$Return_HT = 16
					Case 8
						$Set_Cursor = 12
						$Return_HT = 17
				EndSwitch
				GUISetCursor($Set_Cursor, 1)
				If Not ($Return_HT = 2) Then Return $Return_HT
			EndIf
		EndIf
	EndIf

	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>INTERNAL_WM_NCHITTEST

; Allow drag with mouse left button down
Func INTERNAL_WM_LBUTTONDOWN($hWnd, $iMsg, $wParam, $lParam)
	
	Local $iGui_Count = _Int_GetGUIID($hWnd)
	If @error Then Return 'GUI_RUNDEFMSG'
	
	If $GLOBAL_GUI_LIST[$iGui_Count][1] Then
		If Not (WinGetState($hWnd) = 47) Then
			Local $aCurInfo = GUIGetCursorInfo($hWnd)
			If ($aCurInfo[4] = 0) Then ; Mouse not over a control
				DllCall("user32.dll", "int", "ReleaseCapture")
				DllCall("user32.dll", "long", "SendMessage", "hwnd", $hWnd, "int", 0x00A1, "int", 2, "int", 0)
				Return 0
			EndIf
		EndIf
	EndIf
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>INTERNAL_WM_LBUTTONDOWN


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

	If IsArray($MonList) Then
		ReDim $MonList[$MonList[0][0] + 1][5]
		For $i = 1 To $MonList[0][0]
			$aPos = _WinAPI_GetPosFromRect($MonList[$i][1])
			For $j = 0 To 3
				$MonList[$i][$j + 1] = $aPos[$j]
			Next
		Next
	EndIf

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
		If $FullScreen = True Then Return $MonSizePos

		;Win 7 classic theme compatibility
		If ($TaskBarPos[0] = $MonList[$MonNumb][1] - 2) Or ($TaskBarPos[1] = $MonList[$MonNumb][2] - 2) Then
			$TaskBarPos[0] = $TaskBarPos[0] + 2
			$TaskBarPos[1] = $TaskBarPos[1] + 2
			$TaskBarPos[2] = $TaskBarPos[2] - 4
			$TaskBarPos[3] = $TaskBarPos[3] - 4
		EndIf
		If ($TaskBarPos[0] = $MonList[$MonNumb][1] - 2) Or ($TaskBarPos[1] = $MonList[$MonNumb][2] - 2) Then
			$TaskBarPos[0] = $TaskBarPos[0] + 2
			$TaskBarPos[1] = $TaskBarPos[1] + 2
			$TaskBarPos[2] = $TaskBarPos[2] - 4
			$TaskBarPos[3] = $TaskBarPos[3] - 4
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


Func _Int_GetGUIID($mGUI)
    Local $iGui_Count
	For $iGUIs = 0 To UBound($GLOBAL_GUI_LIST) - 1 Step +1
		If $GLOBAL_GUI_LIST[$iGUIs][0] = $mGUI Then
			$iGui_Count = $iGUIs
			ExitLoop
		EndIf
	Next
	If ($iGui_Count == "") Then 
		 Return SetError(1);
    EndIf
	Return $iGui_Count
EndFunc
