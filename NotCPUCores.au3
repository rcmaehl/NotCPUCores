#RequireAdmin
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Compiled 7/18/2017 @ 00:45 EST
#AutoIt3Wrapper_Res_Description=NotCPUCores
#AutoIt3Wrapper_Res_Fileversion=1.3.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Robert Maehl, using MIT License
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Array.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include <Constants.au3>
#include <GUIListView.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>

#cs

To Do

1. Steam Game Auto-Detection and Dropdown (v 2.0)
2. Allow Collapsing of Window/Process List
3. Move Back-End Console when running as GUI into a CLOSE-ABLE Window (Console UDF)
4. Allow Selecting from Window/Process List instead of it just being a guide
5. Allow Optimization of Multiple Processes at once (v 2.0)
6. Convert GUI to a Metro GUI or Allow Themes (v 2.0)


== 2.0 Idea Master List ==

Upon Launch open a small Metro UI with some options w/ Graphics (Optimize Game, Manage Auto Optimized, Optimize PC) aka Imgburn start-up but smaller
NCC now launches on Start-up, automatically optimizes any processes chosen by user

Optimize Game

	Tabbed UI (Select from Steam, Select from GOG, Select from Running)
		Options for Which Services to Stop Temporarily
		More user friendly core selection (Checkboxes?)
		Check-box to add game to games to be automatically optimized

Manage Auto Optimize

	List View/Icon View of Processes set to be automatically optimized

Optimize PC

	Tabbed UI
		Defrag, Trim, Disk Cleanup, Power options
		Delayed auto-run program start
		Advanced Tweaks (Ultimate Windows Tweaker-esque)

#ce

ModeSelect($CmdLine) ; Jump to ModeSelect

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

Func Main()

	Local $hGUI = GUICreate("NotCPUCores", 640, 320, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
	Local $sVersion = "1.3.0.0"

	GUICtrlCreateTab(0, 0, 280, 320, 0)

	GUICtrlCreateTabItem("Optimize")

	GUICtrlCreateLabel("Type/Select the Process Name", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Process Name:", 10, 50, 140, 15)

	Local $hTask = GUICtrlCreateInput("", 150, 45, 100, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_AUTOHSCROLL)
	GUICtrlSetTip(-1, "Enter the name of the process here." & @CRLF & "Example: NOTEPAD.EXE", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	Local $hSearch = GUICtrlCreateButton(ChrW(8635), 250, 45, 20, 20)
	GUICtrlSetFont(-1, 12)
	GUICtrlSetTip(-1, "List Current Processes", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("How Many Cores Do You Have?", 5, 80, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core Count:", 10, 105, 220, 15)

	Local $hCores = GUICtrlCreateInput(_GetCoreCount(), 230, 100, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER + $ES_READONLY)
	GUICtrlSetLimit(-1,2)
	GUICtrlSetTip(-1, "The Total Number of Threads on your computer." & @CRLF & "This is currently Automatically Detected.", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("Which Cores Do You Want to Run On?", 5, 130, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core(s):", 10, 155, 190, 15)

	Local $hCores = GUICtrlCreateInput("1", 200, 150, 70, 20, $ES_UPPERCASE + $ES_RIGHT)
	GUICtrlSetTip(-1, "To run on a Single Core, enter the number of that core." & @CRLF & "To run on Multiple Cores, seperate them with commas." & @CRLF & "Example: 1,3,4", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("Advanced", 5, 180, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Advanced features coming future update!", 5, 200, 270, 20, $SS_CENTER)

	$hOptimize = GUICtrlCreateButton("OPTIMIZE", 5, 275, 270, 20)
	$hReset = GUICtrlCreateButton("RESTORE TO DEFAULT", 5, 295, 270, 20)

	GUICtrlCreateTabItem("One Time Tweaks")

	GUICtrlCreateLabel("Below You Can Enable Or Disable the High Precision Event Timer for Windows. On SOME games this may DECREASE performance instead of INCREASE. You can always change it back!", 5, 25, 270, 60, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	$HPETEnable = GUICtrlCreateButton("Enable HPET", 5, 85, 135, 20)
	$HPETDisable = GUICtrlCreateButton("Disable HPET", 140, 85, 135, 20)

;	GUICtrlCreateLabel("Below you can run some Windows Maintenance Tools", 5, 115, 270, 20, $SS_CENTER + $SS_SUNKEN)
;	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateTabItem("About")

	GUICtrlCreateLabel(@CRLF & "NotCPUCores" & @TAB & "v" & $sVersion & @CRLF & "Developed by Robert Maehl", 5, 35, 270, 50, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("What it does:" & @CRLF & @CRLF & "1. Find the Game Process" &  @CRLF & "2. Change Game Priority to High" & @CRLF & "3. Change Affinity to the Selected Core", 5, 95, 270, 90)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("How To Do It Yourself:" & @CRLF & @CRLF & "1. Open Task Manager" & @CRLF & "2. Find the Game Process under Processes or Details" &  @CRLF & "3. Right Click, Set Priority, High" & @CRLF & "4. Right Click, Set Affinity, Uncheck Core 0", 5, 195, 270, 100)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateTabItem("")

	$hProcesses = GUICtrlCreateListView("Window Process|Window Title", 280, 0, 360, 320, $LVS_REPORT+$LVS_SINGLESEL, $LVS_EX_GRIDLINES+$LVS_EX_FULLROWSELECT+$LVS_EX_DOUBLEBUFFER)
	_GUICtrlListView_RegisterSortCallBack($hProcesses)

	$aWindows = WinList()
	Do
		$Delete = _ArraySearch($aWindows, "Default IME")
		_ArrayDelete($aWindows, $Delete)
	Until _ArraySearch($aWindows, "Default IME") = -1
	$aWindows[0][0] = UBound($aWindows)
	For $Loop = 1 To $aWindows[0][0] - 1
		$aWindows[$Loop][1] = _ProcessGetName(WinGetProcess($aWindows[$Loop][1]))
		GUICtrlCreateListViewItem($aWindows[$Loop][1] & "|" & $aWindows[$Loop][0],$hProcesses)
	Next
	_ArrayDelete($aWindows, 0)
	For $i = 0 To _GUICtrlListView_GetColumnCount($hProcesses) Step 1
		_GUICtrlListView_SetColumnWidth($hProcesses, $i, $LVSCW_AUTOSIZE_USEHEADER)
	Next
	_GUICtrlListView_SortItems($hProcesses, GUICtrlGetState($hProcesses))

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE
				_GUICtrlListView_UnRegisterSortCallBack($hProcesses)
				GUIDelete($hGUI)
				Exit

			Case $hMsg = $hProcesses
				_GUICtrlListView_SortItems($hProcesses, GUICtrlGetState($hProcesses))


			Case $hMsg = $hSearch
				_GUICtrlListView_DeleteAllItems($hProcesses)
				$aWindows = WinList()
				Do
					$Delete = _ArraySearch($aWindows, "Default IME")
					_ArrayDelete($aWindows, $Delete)
				Until _ArraySearch($aWindows, "Default IME") = -1
				$aWindows[0][0] = UBound($aWindows)
				For $Loop = 1 To $aWindows[0][0] - 1
					$aWindows[$Loop][1] = _ProcessGetName(WinGetProcess($aWindows[$Loop][1]))
					GUICtrlCreateListViewItem($aWindows[$Loop][1] & "|" & $aWindows[$Loop][0],$hProcesses)
				Next
				_ArrayDelete($aWindows, 0)
				For $i = 0 To _GUICtrlListView_GetColumnCount($hProcesses) Step 1
					_GUICtrlListView_SetColumnWidth($hProcesses, $i, $LVSCW_AUTOSIZE_USEHEADER)
				Next
				_GUICtrlListView_SortItems($hProcesses, GUICtrlGetState($hProcesses))

			Case $hMsg = $hCores
				If Not StringRegExp(GUICtrlRead($hCores), "\A[1-9]+?(,[0-9]+)*\Z") Then
					GUICtrlSetColor($hCores, 0xFF0000)
					GUICtrlSetState($hOptimize, $GUI_DISABLE)
				Else
					GUICtrlSetColor($hCores, 0x000000)
					GUICtrlSetState($hOptimize, $GUI_ENABLE)
				EndIf

			Case $hMsg = $hReset
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_DISABLE)
				Next
				GUICtrlSetData($hReset, "Restoring PC...")
				_Restore()
				GUICtrlSetData($hReset, "RESTORE TO DEFAULT")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next

			Case $hMsg = $hOptimize
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_DISABLE)
				Next
				GUICtrlSetData($hOptimize, "Running Optimizations...")
				_OptimizeAll(GUICtrlRead($hTask),GUICtrlRead($hCores))
				GUICtrlSetData($hOptimize, "OPTIMIZE")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next

			Case $hMsg = $HPETDisable
				_ToggleHPET("TRUE")

			Case $hMsg = $HPETDisable
				_ToggleHPET("FALSE")

		EndSelect
	WEnd
EndFunc

Func ModeSelect($CmdLine)
	Switch $CmdLine[0]
		Case 0
			ConsoleWrite("Backend Console (Read-Only Mode)" & @CRLF & "Feel free to minimize, but closing will close the UI as well" & @CRLF & @CRLF)
			Main()
		Case 1
			Switch $CmdLine[1]
				Case "/?"
					ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
				Case "Help"
					ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
				Case "OptimizeAll"
					ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
				Case "Optimize"
					ConsoleWrite("Optimize Requires ProcessName.exe CoreToRunOn" & @CRLF)
					Sleep(5000)
				Case "ToggleHPET"
					ConsoleWrite("ToggleHPET Requires True/False" & @CRLF)
				Case "StopServices"
					ConsoleWrite("StopServices Requires True/False" & @CRLF)
				Case "SetPowerPlan"
					ConsoleWrite("SetPowerPlan Requires True/False" & @CRLF)
				Case "Restore"
					_Restore()
				Case Else
					ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
			EndSwitch
			Sleep(5000)
			Exit 0
		Case Else
			Switch $CmdLine[1]
				Case "OptimizeAll"
					If $CmdLine[0] < 3 Then
						ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 3 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						Exit _OptimizeAll($CmdLine[2],Number($CmdLine[3]))
					EndIf
				Case "Optimize"
					If $CmdLine[0] < 3 Then
						ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 3 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						Exit _Optimize($CmdLine[2],$CmdLine[3])
					EndIf
				Case "ToggleHPET"
					If $CmdLine[0] < 2 Then
						ConsoleWrite("ToggleHPET Requires True/False" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 2 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						_ToggleHPET($CmdLine[2])
					EndIf
				Case "StopServices"
					If $CmdLine[0] < 2 Then
						ConsoleWrite("StopServices Requires True/False" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 2 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						_StopServices($CmdLine[2])
					EndIf
				Case "SetPowerPlan"
					If $CmdLine[0] < 2 Then
						ConsoleWrite("SetPowerPlan Requires True/False" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 2 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						_SetPowerPlan($CmdLine[2])
					EndIf
				Case Else
					ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
					Sleep(1000)
					Exit 1
			EndSwitch
	EndSwitch
EndFunc

Func _Optimize($hProcess,$aCores = 1)

	Select
		Case Not ProcessExists($hProcess)
			ConsoleWrite($hProcess & " is not currently running. Please run the program first" & @CRLF)
			Return 1
		Case Not StringRegExp($aCores, "\A[1-9]+?(,[0-9]+)*\Z")
			ConsoleWrite($aCores & " is not a proper declaration of what cores to run on" & @CRLF)
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
				ConsoleWrite("You've specified more cores than available on your system" & @CRLF)
				Return 1
			EndIf
			ConsoleWrite("Optimzing " & $hProcess & " in the background until it closes...")
			$iProcessesLast = 0
			While ProcessExists($hProcess)
				$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
				If Not (UBound($aProcesses) = $iProcessesLast) Then
					ConsoleWrite("Running...")
					For $iLoop = 0 to $aProcesses[0][0] Step 1
						If $aProcesses[$iLoop][0] = $hProcess Then
							ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_HIGH) ; Self Explanatory
							$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1]) ; Select the Process
							_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
							_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
						Else
							$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1])  ; Select the Process
							_WinAPI_SetProcessAffinityMask($hCurProcess, $hAllCores-$hCores) ; Set Affinity (which cores it's assigned to)
							_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
						EndIf
					Next
					$iProcessesLast = UBound($aProcesses)
					ConsoleWrite("Done!" & @CRLF)
				EndIf
			WEnd
			ConsoleWrite("Done!" & @CRLF)

			_Restore() ; Do Clean Up
			Return 0
	EndSelect
EndFunc

Func _OptimizeAll($hProcess,$aCores)
	_StopServices("True")
	_SetPowerPlan("True")
	Return _Optimize($hProcess,$aCores)
EndFunc

Func _Restore($aCores = _GetCoreCount())
	ConsoleWrite("Restoring Previous State..." & @CRLF & @CRLF)

	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
	For $iLoop = 0 To $aCores - 1
		$hAllCores += 2^$iLoop
	Next

	ConsoleWrite("Restoring Priority and Affinity of all Other Processes...")

	$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority back to normal
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1])  ; Select the Process
		_WinAPI_SetProcessAffinityMask($hCurProcess, $hAllCores) ; Set Affinity (which cores it's assigned to)
		_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
	Next
	ConsoleWrite("Done!" & @CRLF)

	_StopServices("False") ; Additional Clean Up
EndFunc

Func _SetPowerPlan($bState)
	If $bState = "True" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_BALANCED', "", @SW_HIDE) ; Set BALANCED power plan
	ElseIf $bState = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE) ; Set MINIMUM power saving, aka max performance
	Else
		ConsoleWrite("SetPowerPlan Option " & $bState & " is not valid!" & @CRLF)
	EndIf
EndFunc

Func _StopServices($bState)
	If $bState = "True" Then
		ConsoleWrite("Temporarily Pausing Game Impacting Services...")
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE) ; Stop Windows Update
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE) ; Stop Printer Spooler
		ConsoleWrite("Done!" & @CRLF)
	ElseIf $bState = "False" Then
		ConsoleWrite("Restarting Any Stopped Services...")
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE) ; Start Windows Update
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE) ; Start Printer Spooler
		ConsoleWrite("Done!" & @CRLF)
	Else
		ConsoleWrite("StopServices Option " & $bState & " is not valid!" & @CRLF)
	EndIf
EndFunc

Func _ToggleHPET($bState)
	If $bState = "True" Then
		ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF)
		Run("bcdedit /set useplatformclock true") ; Enable System Event Timer
	ElseIf $bState = "False" Then
		Run("bcdedit /set useplatformclock false") ; Disable System Event Timer
		ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF)
	EndIf
EndFunc