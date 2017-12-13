#RequireAdmin
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Comment=Compiled 11/23/2017 @ 10:25 EST
#AutoIt3Wrapper_Res_Description=NotCPUCores
#AutoIt3Wrapper_Res_Fileversion=1.5.0.0
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
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>

#include ".\Includes
#include ".\Includes\_GetEnvironment.au3"

Opt("GUIResizeMode", $GUI_DOCKALL)

#cs

To Do

1. Steam Game Auto-Detection and Dropdown (v 2.0)
2. Allow Collapsing of Window/Process List (DONE)
3. Move Back-End Console when running as GUI into a CLOSE-ABLE Window (Console UDF) (Embedded Console Created)
4. Allow Selecting from Window/Process List instead of it just being a guide
5. Allow Optimization of Multiple Processes at once (v 2.0)
6. Convert GUI to a Metro GUI or Allow Themes (v 2.0)
7. Language Translation Options


== 2.0 Idea Master List ==

Options for translation
NCC launches on Start-up, automatically optimizes any processes chosen by user
Upon Launch open a small Metro UI with some options w/ Graphics (Optimize Game, Manage Auto Optimized, Optimize PC) aka Imgburn start-up but smaller

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

Main() ; Jump to ModeSelect

Func Main()

	Local $hGUI = GUICreate("NotCPUCores", 640, 480, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
	Local $sVersion = "1.5.0.0"

	GUICtrlCreateTab(0, 0, 280, 320, 0)

	#Region ; Optimize Tab
	GUICtrlCreateTabItem("Optimize")

	GUICtrlCreateLabel("Type/Select the Process Name", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Process Name:", 10, 50, 140, 15)

	Local $hTask = GUICtrlCreateInput("", 150, 45, 100, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_AUTOHSCROLL)
		GUICtrlSetTip(-1, "Enter the name of the process here." & @CRLF & "Example: NOTEPAD.EXE", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	Local $hSearch = GUICtrlCreateButton(ChrW(8678), 250, 45, 20, 20)
		GUICtrlSetFont(-1, 12)
		GUICtrlSetTip(-1, "Import Selected Process from Process List", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("How Many Cores Do You Have?", 5, 80, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core Count:", 10, 105, 220, 15)

	Local $hCores = GUICtrlCreateInput(_GetCoreCount(), 230, 100, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER + $ES_READONLY)
		GUICtrlSetLimit(-1,2)
		GUICtrlSetTip(-1, "The Total Number of Threads on your computer." & @CRLF & "This is currently Automatically Detected.", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("Which Cores Do You Want to Run On?", 5, 130, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core(s):", 10, 155, 190, 15)

	Local $hCores = GUICtrlCreateInput("1", 200, 150, 70, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_AUTOHSCROLL)
		GUICtrlSetTip(-1, "To run on a Single Core, enter the number of that core." & @CRLF & "To run on Multiple Cores, seperate them with commas." & @CRLF & "Example: 1,3,4", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("Advanced", 5, 180, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Internal Sleep Timer:", 10, 200, 220, 15)

	Local $hSleepTimer = GUICtrlCreateInput("100", 230, 200, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER)
		GUICtrlSetLimit(-1, 3,1)
		GUICtrlSetTip(-1, "Internal Sleep Timer" & @CRLF & "Decreasing this value can smooth FPS drops, " & @CRLF & "at the risk of NCC having more CPU usage itself", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	Local $hRealtime = GUICtrlCreateCheckbox("Use Realtime Priority:", 10, 220, 260, 20, $BS_RIGHTBUTTON)
		GUICtrlSetTip(-1, "Selecting this sets the process to a higher" & @CRLF & "priority, at the risk of system instability", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	$hOptimize = GUICtrlCreateButton("OPTIMIZE", 5, 275, 270, 20)
	$hReset = GUICtrlCreateButton("RESTORE TO DEFAULT", 5, 295, 270, 20)
	#EndRegion

	#Region ; Tweaks Tab
	GUICtrlCreateTabItem("1 Time Tweaks")

	GUICtrlCreateLabel("Below You Can Enable Or Disable the High Precision Event Timer for Windows. On SOME games this may DECREASE performance instead of INCREASE. You can always change it back!", 5, 25, 270, 60, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	$HPETEnable = GUICtrlCreateButton("Enable HPET", 5, 85, 135, 20)
	$HPETDisable = GUICtrlCreateButton("Disable HPET", 140, 85, 135, 20)

;	GUICtrlCreateLabel("Below you can run some Windows Maintenance Tools", 5, 115, 270, 20, $SS_CENTER + $SS_SUNKEN)
;	GUICtrlSetBkColor(-1, 0xF0F0F0)
#cs
	GUICtrlCreateTabItem("Options")

	GUICtrlCreateLabel("Processes to Always Include", 5, 25, 270, 20, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateListView("", 5, 45, 270, 120, $LVS_EX_FULLROWSELECT+$LVS_EX_DOUBLEBUFFER+$ES_READONLY)

	GUICtrlCreateLabel("Processes to Always Exclude", 5, 170, 270, 20, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateListView("", 5, 190, 270, 120, $LVS_EX_FULLROWSELECT+$LVS_EX_DOUBLEBUFFER+$ES_READONLY)
#ce
	#EndRegion

	#Region ; Specs Tab
	GUICtrlCreateTabItem("My PC")

	GUICtrlCreateLabel("Operating System", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("OS:", 10, 45, 140, 15)
		GUICtrlCreateLabel("", 150, 45, 120, 20, $ES_RIGHT)

	GUICtrlCreateLabel("Language:", 10, 65, 140, 15)
		GUICtrlCreateLabel("", 150, 65, 120, 20, $ES_RIGHT)

	GUICtrlCreateLabel("Hardware", 5, 90, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	#EndRegion

	#Region ; About Tab
	GUICtrlCreateTabItem("About")

	GUICtrlCreateLabel(@CRLF & "NotCPUCores" & @TAB & "v" & $sVersion & @CRLF & _
		"Developed by Robert Maehl" & @CRLF & _
		"Icon by /u/ImRealNow", 5, 35, 270, 70, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("What it does:" & @CRLF & _
		@CRLF & _
		"1. Find the Game Process" & @CRLF & _
		"2. Change Game Priority to High" & @CRLF & _
		"3. Change Affinity to the Selected Core(s)" & @CRLF & _
		"4. Set all other Processes Affinity off the Selected Core(s)", 5, 115, 270, 90)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("How To Do It Yourself:" & @CRLF & _
		@CRLF & _
		"1. Open Task Manager" & @CRLF & _
		"2. Find the Game Process under Processes or Details" &  @CRLF & _
		"3. Right Click, Set Priority, High" & @CRLF & _
		"4. Right Click, Set Affinity, Select Your Core(s)", 5, 215, 270, 100)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateTabItem("")
	#EndRegion

	$bCHidden = False
	$bPHidden = False

	$hDToggle = GUICtrlCreateButton("D", 260, 0, 20, 20)
		GUICtrlSetTip($hDToggle, "Toggle Debug Mode")

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

	$hConsole = GUICtrlCreateEdit("Debug Console Initialized" & @CRLF, 0, 320, 640, 160, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x000000)

	GUICtrlSetState($hConsole, $GUI_HIDE)
	GUICtrlSetState($hProcesses, $GUI_HIDE)
	$aPos = WinGetPos($hGUI)
	WinMove($hGUI, "", $aPos[0], $aPos[1], 285, 345)
	$bCHidden = True
	$bPHidden = True

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()
		Sleep(10)

		Select

			Case $hMsg = $GUI_EVENT_CLOSE
				_GUICtrlListView_UnRegisterSortCallBack($hProcesses)
				GUIDelete($hGUI)
				Exit

			Case $hMsg = $hDToggle
				If $bCHidden Or $bPHidden Then
					GUICtrlSetState($hConsole, $GUI_SHOW)
					GUICtrlSetState($hProcesses, $GUI_SHOW)
					$aPos = WinGetPos($hGUI)
					WinMove($hGUI, "", $aPos[0], $aPos[1], 640, 480)
					GUICtrlSetPos($hConsole, 0, 320, 635, 135)
					GUICtrlSetPos($hProcesses, 280, 0, 355, 320)
					$bCHidden = False
					$bPHidden = False
				Else
					GUICtrlSetState($hConsole, $GUI_HIDE)
					GUICtrlSetState($hProcesses, $GUI_HIDE)
					$aPos = WinGetPos($hGUI)
					WinMove($hGUI, "", $aPos[0], $aPos[1], 285, 345)
					$bCHidden = True
					$bPHidden = True
				EndIf

			Case $hMsg = $hProcesses
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

			Case $hMsg = $hSearch
				GUICtrlSetState($hDToggle, $GUI_DISABLE)
				If $bPHidden Then
					GUICtrlSetState($hProcesses, $GUI_SHOW)
					$aPos = WinGetPos($hGUI)
					WinMove($hGUI, "", $aPos[0], $aPos[1], 640)
					GUICtrlSetPos($hProcesses, 280, 0, 355, 320)
					$bPHidden = False
				Else
					$aTask = StringSplit(GUICtrlRead(GUICtrlRead($hProcesses)), "|", $STR_NOCOUNT)
					GUICtrlSetData($hTask, $aTask[0])
				EndIf
				GUICtrlSetState($hDToggle, $GUI_ENABLE)

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
				_Restore(_GetCoreCount(), $hConsole)
				GUICtrlSetData($hReset, "RESTORE TO DEFAULT")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next

			Case $hMsg = $hOptimize
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_DISABLE)
				Next
				GUICtrlSetData($hOptimize, "Running Optimizations...")
				If _OptimizeAll(GUICtrlRead($hTask),GUICtrlRead($hCores),GUICtrlRead($hSleepTimer),_IsChecked($hRealtime),$hConsole) Then
					_Restore(_GetCoreCount(), $hConsole)
				EndIf
				GUICtrlSetData($hOptimize, "OPTIMIZE")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next

			Case $hMsg = $HPETDisable
				_ToggleHPET("TRUE", $hConsole)

			Case $hMsg = $HPETDisable
				_ToggleHPET("FALSE", $hConsole)

			Case Else
				Sleep(10)

		EndSelect
	WEnd
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