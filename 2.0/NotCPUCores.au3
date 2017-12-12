#RequireAdmin

#include <Array.au3>
#include <WinAPI.au3>
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

Func _GetWindowProcessList()
	Local $aWindows = WinList()
	Local $iDelete = 0
	Do
		$iDelete = _ArraySearch($aWindows, "Default IME")
		_ArrayDelete($aWindows, $iDelete)
	Until _ArraySearch($aWindows, "Default IME") = -1
	$aWindows[0][0] = UBound($aWindows)
	For $iLoop = 1 To $aWindows[0][0] - 1
		$aWindows[$iLoop][1] = _ProcessGetName(WinGetProcess($aWindows[$iLoop][1]))
	Next
	_ArrayDelete($aWindows, 0)
EndFunc

Func _ConsoleWrite($sMessage, $hOutput = False)
	If $hOutput = False Then
		ConsoleWrite($sMessage)
	Else
		GUICtrlSetData($hOutput, GUICtrlRead($hOutput) & $sMessage)
	EndIf
EndFunc

Func _GetCoreCount()
    Local $sText = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_Processor')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            Local $sText = $Obj_Item.numberOfLogicalProcessors
        Next

        Return String($sText)
    Else
        Return 0
    EndIf
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

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _Optimize($hProcess,$aCores = 1,$iSleepTime = 100,$hRealtime = False,$hOutput = False)

	Select
		Case Not ProcessExists($hProcess)
			_ConsoleWrite($hProcess & " is not currently running. Please run the program first" & @CRLF, $hOutput)
			Return 1
		Case Not StringRegExp($aCores, "\A[1-9]+?(,[0-9]+)*\Z")
			_ConsoleWrite($aCores & " is not a proper declaration of what cores to run on" & @CRLF, $hOutput)
			Return 1
		Case Else
			Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
			For $iLoop = 0 To _GetCoreCount() - 1
				$hAllCores += 2^$iLoop
			Next
			If StringInStr($aCores, ",") Then ; Convert Multiple Cores if Declared to Magic Number
				$aCores = StringSplit($aCores, ",", $STR_NOCOUNT)
				$hCores = 0
				For $Loop = 0 To UBound($aCores) - 1 Step 1
					$hCores += 2^($aCores[$Loop]-1)
				Next
			Else
				$hCores = 2^($aCores-1)
			EndIf
			If $hCores > $hAllCores Then
				_ConsoleWrite("You've specified more cores than available on your system" & @CRLF, $hOutput)
				Return 1
			EndIf
			_ConsoleWrite("Optimzing " & $hProcess & " in the background until it closes..." & @CRLF, $hOutput)
			$iProcessesLast = 0
			While ProcessExists($hProcess)
				Sleep($iSleepTime)
				$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
				Sleep($iSleepTime)
				If Not (UBound($aProcesses) = $iProcessesLast) Then
					Sleep($iSleepTime)
					_ConsoleWrite("Process Count Changed, Rerunning Optimization...", $hOutput)
					Sleep($iSleepTime)
					For $iLoop = 0 to $aProcesses[0][0] Step 1
						If $aProcesses[$iLoop][0] = $hProcess Then
							If $hRealtime Then
								ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_REALTIME)
							Else
								ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_HIGH) ; Self Explanatory
							EndIf
							$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1]) ; Select the Process
							_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
							_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
						Else
							$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1])  ; Select the Process
							_WinAPI_SetProcessAffinityMask($hCurProcess, $hAllCores-$hCores) ; Set Affinity (which cores it's assigned to)
							_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
						EndIf
					Next
					Sleep($iSleepTime)
					$iProcessesLast = UBound($aProcesses)
					Sleep($iSleepTime)
					_ConsoleWrite("Done!" & @CRLF, $hOutput)
					Sleep($iSleepTime)
				EndIf
			WEnd
			_ConsoleWrite("Done!" & @CRLF, $hOutput)
			_Restore(_GetCoreCount(),$hOutput) ; Do Clean Up
			Return 0
	EndSelect
EndFunc

Func _OptimizeAll($hProcess,$aCores,$iSleepTime = 100,$hRealtime = False,$hOutput = False)
	_StopServices("True", $hOutput)
	_SetPowerPlan("True", $hOutput)
	Return _Optimize($hProcess,$aCores,$iSleepTime,$hRealtime,$hOutput)
EndFunc

Func _Restore($aCores = _GetCoreCount(),$hOutput = False)
	_ConsoleWrite("Restoring Previous State..." & @CRLF & @CRLF, $hOutput)
	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
	For $iLoop = 0 To $aCores - 1
		$hAllCores += 2^$iLoop
	Next

	_ConsoleWrite("Restoring Priority and Affinity of all Other Processes...", $hOutput)
	$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority back to normal
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1])  ; Select the Process
		_WinAPI_SetProcessAffinityMask($hCurProcess, $hAllCores) ; Set Affinity (which cores it's assigned to)
		_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
	Next
	_ConsoleWrite("Done!" & @CRLF, $hOutput)

	_StopServices("False", $hOutput) ; Additional Clean Up
EndFunc

Func _SetPowerPlan($bState,$hOutput = False)
	If $bState = "True" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE) ; Set MINIMUM power saving, aka max performance
	ElseIf $bState = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_BALANCED', "", @SW_HIDE) ; Set BALANCED power plan
	Else
		_ConsoleWrite("SetPowerPlan Option " & $bState & " is not valid!" & @CRLF, $hOutput)
	EndIf
EndFunc

Func _StopServices($bState,$hOutput = False)
	If $bState = "True" Then
		_ConsoleWrite("Temporarily Pausing Game Impacting Services..." & @CRLF, $hOutput)
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE) ; Stop Windows Update
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE) ; Stop Printer Spooler
		_ConsoleWrite("Done!" & @CRLF, $hOutput)
	ElseIf $bState = "False" Then
		_ConsoleWrite("Restarting Any Stopped Services..." & @CRLF, $hOutput)
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE) ; Start Windows Update
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE) ; Start Printer Spooler
		_ConsoleWrite("Done!" & @CRLF, $hOutput)
	Else
		_ConsoleWrite("StopServices Option " & $bState & " is not valid!" & @CRLF, $hOutput)
	EndIf
EndFunc

Func _ToggleHPET($bState,$hOutput = False)
	If $bState = "True" Then
		_ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF, $hOutput)
		Run("bcdedit /set useplatformclock true") ; Enable System Event Timer
	ElseIf $bState = "False" Then
		Run("bcdedit /set useplatformclock false") ; Disable System Event Timer
		_ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF, $hOutput)
	EndIf
EndFunc

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
			$hGUI = _Metro_CreateGUI("NotCPUCores", 640, 140, -1, -1)
			$aControl_Buttons = _Metro_AddControlButtons(True,False,False,False)
			$hGUI_CLOSE_BUTTON = $aControl_Buttons[0]
		Case Else
			$hGUI = GUICreate("NotCPUCores", 640, 140, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
			$hGUI_CLOSE_BUTTON = $GUI_EVENT_CLOSE
	EndSwitch
	GUICtrlCreateGroup("What Would You Like To Do?", 0, 0, 640, 140)
	$hOptimize = _CreateButton("Optimize A Game", 10, 20, 200, 110, BitXOR($BS_ICON,$BS_TOP))
	$hManageSet = _CreateButton("Manage Auto Optimizes", 220, 20, 200, 110, BitXOR($BS_ICON,$BS_TOP))
	$hCleanPC = _CreateButton("Optimize PC", 430, 20, 200, 110, BitXOR($BS_ICON,$BS_TOP))

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hGUI_CLOSE_BUTTON
				GUIDelete($hGUI)
				Exit

			Case $hMsg = $hOptimize
				GUIDelete($hGUI)
				OptimizeGame()

			Case $hMsg = $hManageSet
				GUIDelete($hGUI)
				Manage()

			Case $hMsg = $hCleanPC
				GUIDelete($hGUI)
				OptimizePC()

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