#RequireAdmin

#include <Process.au3>
#include <Constants.au3>
#include <GUIListView.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>

#include ".\Includes\_Core.au3"
#include ".\Includes\_WMIC.au3"
;#include ".\Includes\_ModeSelect.au3"
#include ".\Includes\_GetEnvironment.au3"

#include ".\includes\Console.au3"
#include ".\includes\MetroGUI_UDF.au3"

ModeSelect()

Func _CreateButton($sText, $iLeft, $iTop, $iWidth = -1, $iHeight = -1, $iStyle = -1)
	Local $hCreated

	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			$hCreated = _Metro_CreateButton($sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle)
		Case Else
			$hCreated = GUICtrlCreateButton($sText, $iLeft, $iTop, $iWidth, $iHeight)
	EndSwitch

	Return $hCreated
EndFunc

Func _GetChildProcesses($i_pid) ; First level children processes only
    Local Const $TH32CS_SNAPPROCESS = 0x00000002

    Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
    If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)

    Local $tagPROCESSENTRY32 = _
        DllStructCreate _
            ( _
                "dword dwsize;" & _
                "dword cntUsage;" & _
                "dword th32ProcessID;" & _
                "uint th32DefaultHeapID;" & _
                "dword th32ModuleID;" & _
                "dword cntThreads;" & _
                "dword th32ParentProcessID;" & _
                "long pcPriClassBase;" & _
                "dword dwFlags;" & _
                "char szExeFile[260]" _
            )
    DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))

    Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)

    Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
    If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)

    Local $a_pnext, $a_children[11][2] = [[10]], $i_child_pid, $i_parent_pid, $i_add = 0
    $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")
    If $i_child_pid <> $i_pid Then
        $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
        If $i_parent_pid = $i_pid Then
            $i_add += 1
            $a_children[$i_add][0] = $i_child_pid
            $a_children[$i_add][1] = DllStructGetData($tagPROCESSENTRY32, "szExeFile")
        EndIf
    EndIf

    While 1
        $a_pnext = DLLCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
        If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop
        $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")
        If $i_child_pid <> $i_pid Then
            $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
            If $i_parent_pid = $i_pid Then
                If $i_add = $a_children[0][0] Then
                    ReDim $a_children[$a_children[0][0] + 11][2]
                    $a_children[0][0] = $a_children[0][0] + 10
                EndIf
                $i_add += 1
                $a_children[$i_add][0] = $i_child_pid
                $a_children[$i_add][1] = DllStructGetData($tagPROCESSENTRY32, "szExeFile")
            EndIf
        EndIf
    WEnd

    If $i_add <> 0 Then
        ReDim $a_children[$i_add + 1][2]
        $a_children[0][0] = $i_add
    EndIf

    DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
    If $i_add Then Return $a_children
    Return SetError(3, 0, 0)
EndFunc

Func _GetProcessList($hControl)

	_GUICtrlListView_DeleteAllItems($hControl)
	Local $aWindows = WinList()
	Do
		$Delete = _ArraySearch($aWindows, "Default IME")
		_ArrayDelete($aWindows, $Delete)
	Until _ArraySearch($aWindows, "Default IME") = -1
	$aWindows[0][0] = UBound($aWindows)
	For $Loop = 1 To $aWindows[0][0] - 1
		$aWindows[$Loop][1] = _ProcessGetName(WinGetProcess($aWindows[$Loop][1]))
		GUICtrlCreateListViewItem($aWindows[$Loop][1] & "|" & $aWindows[$Loop][0], $hControl)
	Next
	_ArrayDelete($aWindows, 0)
	For $i = 0 To _GUICtrlListView_GetColumnCount($hControl) Step 1
		_GUICtrlListView_SetColumnWidth($hControl, $i, $LVSCW_AUTOSIZE_USEHEADER)
	Next
	_GUICtrlListView_SortItems($hControl, GUICtrlGetState($hControl))

EndFunc

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func Manage()
	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			_SetTheme("DarkBlue")
			_Metro_EnableHighDPIScaling()
			$hGUI = _Metro_CreateGUI("NotCPUCores", 640, 480, -1, -1)
			$aControl_Buttons = _Metro_AddControlButtons(True,False,False,False)
			$hGUI_CLOSE_BUTTON = $aControl_Buttons[0]
		Case Else
			$hGUI = GUICreate("NotCPUCores", 640, 480, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
			$hGUI_CLOSE_BUTTON = $GUI_EVENT_CLOSE
	EndSwitch

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hGUI_CLOSE_BUTTON
				GUIDelete($hGUI)
				Exit

		EndSelect
	WEnd
EndFunc

Func ModeSelect()
	Local $hGUI

	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			_SetTheme("DarkBlue")
			_Metro_EnableHighDPIScaling()
			GUICtrlSetDefColor(0xFFFFFF)
			$hGUI = _Metro_CreateGUI("NotCPUCores", 640, 160, -1, -1, False)
			$aControl_Buttons = _Metro_AddControlButtons(True,False,False,False)
			$hGUI_CLOSE_BUTTON = $aControl_Buttons[0]
			$iHOffset = 25
		Case Else
			$hGUI = GUICreate("NotCPUCores", 640, 140, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
			$hGUI_CLOSE_BUTTON = $GUI_EVENT_CLOSE
			$iHOffset = 0
	EndSwitch
;	GUICtrlCreateGroup("What Would You Like To Do?", 5, 5 + $iHOffset, 630, 110 + $iHOffset)
;	GUICtrlSetColor(-1, 0xFFFFFF)
;	$hOptimize = _CreateButton("Optimize A Game", 10, 20 + $iHOffset, 200, 110, BitXOR($BS_ICON,$BS_TOP))
;	$hManageSet = _CreateButton("Manage Auto Optimizes", 220, 20 + $iHOffset, 200, 110, BitXOR($BS_ICON,$BS_TOP))
;	$hCleanPC = _CreateButton("Optimize PC", 430, 20 + $iHOffset, 200, 110, BitXOR($BS_ICON,$BS_TOP))

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hGUI_CLOSE_BUTTON
				GUIDelete($hGUI)
				Exit
#cs
			Case $hMsg = $hOptimize
				GUIDelete($hGUI)
				OptimizeGame()

			Case $hMsg = $hManageSet
				GUIDelete($hGUI)
				Manage()

			Case $hMsg = $hCleanPC
				GUIDelete($hGUI)
				OptimizePC()
#ce
		EndSelect

	WEnd

EndFunc

Func OptimizeGame()
	Local $hGUI

	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			_SetTheme("DarkBlue")
			_Metro_EnableHighDPIScaling()
			$hGUI = _Metro_CreateGUI("NotCPUCores", 640, 480, -1, -1)
			$aControl_Buttons = _Metro_AddControlButtons(True,False,False,False)
			$hGUI_CLOSE_BUTTON = $aControl_Buttons[0]
		Case Else
			$hGUI = GUICreate("NotCPUCores", 640, 480, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
			$hGUI_CLOSE_BUTTON = $GUI_EVENT_CLOSE
	EndSwitch

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hGUI_CLOSE_BUTTON
				GUIDelete($hGUI)
				Exit

		EndSelect
	WEnd
EndFunc

Func OptimizePC()
	Local $hGUI

	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			_SetTheme("DarkBlue")
			_Metro_EnableHighDPIScaling()
			$hGUI = _Metro_CreateGUI("NotCPUCores", 640, 480, -1, -1)
			$aControl_Buttons = _Metro_AddControlButtons(True,False,False,False)
			$hGUI_CLOSE_BUTTON = $aControl_Buttons[0]
		Case Else
			$hGUI = GUICreate("NotCPUCores", 640, 480, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
			$hGUI_CLOSE_BUTTON = $GUI_EVENT_CLOSE
	EndSwitch

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hGUI_CLOSE_BUTTON
				GUIDelete($hGUI)
				Exit

		EndSelect
	WEnd
EndFunc
