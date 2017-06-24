#RequireAdmin
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=notcpucores.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Compiled 6/24/2017 @ 10:30 EST
#AutoIt3Wrapper_Res_Description=NotCPUCores
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Robert Maehl, using MIT License
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPI.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

ModeSelect($CmdLine) ; Jump to ModeSelect

Func _GetCoreCount()
    Local $s_Text = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_Processor')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            Local $s_Text = $Obj_Item.numberOfLogicalProcessors
        Next

        Return String($s_Text)
    Else
        Return 0
    EndIf
EndFunc

Func Main()

	Local $hGUI = GUICreate("NotCPUCores", 280, 320, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), $WS_EX_TOOLWINDOW)
	Local $sVersion = "1.1.0.0"

	GUICtrlCreateTab(0, 0, 280, 320, 0)

	GUICtrlCreateTabItem("Optimize")

	GUICtrlCreateLabel("Type/Select the Process Name", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)
	GUICtrlCreateLabel("Process Name:", 10, 50, 140, 15)
	Local $hTask = GUICtrlCreateInput("", 150, 45, 120, 20, $ES_UPPERCASE + $ES_RIGHT)
	GUICtrlSetTip(-1, "Enter the name of the process here." & @CRLF & "Example: NOTEPAD.EXE", "USAGE", $TIP_NOICON, $TIP_BALLOON)
	;Local $hSearch = GUICtrlCreateButton("?", 250, 45, 20, 20)
	;GUICtrlSetTip(-1, "List Current Processes", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("How Many Cores Do You Have?", 5, 80, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core Count:", 10, 105, 220, 15)
	Local $hCores = GUICtrlCreateInput(_GetCoreCount(), 230, 100, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER + $ES_READONLY)
	GUICtrlSetLimit(-1,2)
	GUICtrlSetTip(-1, "The Total Number of Threads on your computer." & @CRLF & "This is currently Automatically Detected.", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("Which Cores Do You Want to Run On?", 5, 130, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core(s):", 10, 155, 220, 15)
	Local $hCores = GUICtrlCreateInput("", 200, 150, 70, 20, $ES_UPPERCASE + $ES_RIGHT)
	GUICtrlSetTip(-1, "To run on a Single Core, enter the number of that core." & @CRLF & "To run on Multiple Cores, seperate them with commas." & @CRLF & "Example: 1,3,4", "USAGE", $TIP_NOICON, $TIP_BALLOON)

	GUICtrlCreateLabel("Advanced", 5, 180, 270, 15, $SS_CENTER + $SS_SUNKEN)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Advanced features coming future update!", 5, 200, 270, 20, $SS_CENTER)

	$hOptimize = GUICtrlCreateButton("OPTIMIZE", 5, 275, 270, 20)
	$hReset = GUICtrlCreateButton("RESTORE TO DEFAULT", 5, 295, 270, 20)

;	GUICtrlCreateTabItem("One Time Tweaks")

;	GUICtrlCreateLabel("Below You Can Enable Or Disable the High Precision Event Timer for Windows. On SOME games this may DECREASE performance instead of INCREASE. You can always change it back!", 5, 25, 270, 60, $SS_CENTER)
;	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateTabItem("About")

	GUICtrlCreateLabel(@CRLF & "NotCPUCores" & @TAB & "v" & $sVersion & @CRLF & "Developed by Robert Maehl", 5, 35, 270, 50, $SS_CENTER)

	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("What it does:" & @CRLF & @CRLF & "1. Find the Game Process" &  @CRLF & "2. Change Game Priority to High" & @CRLF & "3. Change Affinity to the Selected Core", 5, 95, 270, 90)

	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("How To Do It Yourself:" & @CRLF & @CRLF & "1. Open Task Manager" & @CRLF & "2. Find the Game Process under Processes or Details" &  @CRLF & "3. Right Click, Set Priority, High" & @CRLF & "4. Right Click, Set Affinity, Uncheck Core 0", 5, 195, 270, 100)

	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateTabItem("")

	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE
				GUIDelete($hGUI)
				Exit

			Case $hMsg = $hCores
				If Not StringIsInt(StringReplace(GUICtrlRead($hCores), ",", "")) Or StringRight(GUICtrlRead($hCores),1) = "," Or StringLeft(GUICtrlRead($hCores),1) = "," Then ; WHAT IS REGEX T_T
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
				Restore(_GetCoreCount())
				GUICtrlSetData($hReset, "RESTORE TO DEFAULT")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next

			Case $hMsg = $hOptimize
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_DISABLE)
				Next
				GUICtrlSetData($hOptimize, "Running Optimizations...")
				OptimizeAll(GUICtrlRead($hTask),GUICtrlRead($hCores))
				GUICtrlSetData($hOptimize, "OPTIMIZE")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next
		EndSelect
	WEnd
EndFunc

Func ModeSelect($CmdLine)
	If $CmdLine[0] > 1 Then
		Switch $CmdLine[1]
			Case "OptimizeAll"
				If $CmdLine[0] < 3 Then
					ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not ProcessExists($CmdLine[2]) Then
					ConsoleWrite($CmdLine[2] & " is not currently running. Please run the program first" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not IsInt(Number(StringReplace($CmdLine[3],",", ""))) Then
					ConsoleWrite("Invalid options set for CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Number($CmdLine[3]) > _GetCoreCount() Then
					ConsoleWrite("Core " & $CmdLine[4] & " does not exist on a " & _GetCoreCount() & " core system" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					OptimizeAll($CmdLine[2],$CmdLine[3])
				EndIf
			Case "Optimize"
				If $CmdLine[0] < 3 Then
					ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not ProcessExists($CmdLine[2]) Then
					ConsoleWrite($CmdLine[2] & " is not currently running. Please run the program first" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not IsInt(Number(StringReplace($CmdLine[3],",", ""))) Then
					ConsoleWrite("Invalid options set for CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Number($CmdLine[3]) > _GetCoreCount() Then
					ConsoleWrite("Core " & $CmdLine[4] & " does not exist on a " & _GetCoreCount() & " core system" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					Optimize($CmdLine[2],$CmdLine[3])
				EndIf
			Case "ToggleHPET"
				If $CmdLine[0] < 2 Then
					ConsoleWrite("ToggleHPET Requires True/False" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					ToggleHPET($CmdLine[2])
				EndIf
			Case "StopServices"
				If $CmdLine[0] < 2 Then
					ConsoleWrite("StopServices Requires True/False" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					StopServices($CmdLine[2])
				EndIf
			Case "SetPowerPlan"
				If $CmdLine[0] < 2 Then
					ConsoleWrite("SetPowerPlan Requires True/False" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					SetPowerPlan($CmdLine[2])
				EndIf
			Case Else
				ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
				Sleep(1000)
				Exit 1
		EndSwitch
	Else
		If $CmdLine[0] = 0 Then
			ConsoleWrite("Backend Console (Read-Only Mode)" & @CRLF & "Feel free to minimize, but closing will close the UI as well" & @CRLF & @CRLF)
			Main()
		Else
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
					Restore(_GetCoreCount)
				Case Else
					ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
			EndSwitch
		EndIf
		Sleep(5000)
		Exit 0
	EndIf
EndFunc

Func Optimize($Process,$Cores = 1)
	If StringInStr($Cores, ",") Then
		Local $aCores = StringSplit($Cores, ",", $STR_NOCOUNT)
		$Cores = 0
		For $Loop = 0 To UBound($aCores) - 1 Step 1
			$Cores += 2^($aCores[$Loop]-1)
		Next
	Else
		$Cores = 2^($Cores-1)
	EndIf
	Local $AllCores = 0
	For $i = 0 To _GetCoreCount() - 1
		$AllCores += 2^$i
	Next
	$Processes = ProcessList()
	ConsoleWrite("Setting Priority and Affinity of " & $Process & "...")
	For $Loop = 0 to $Processes[0][0] Step 1
		If $Processes[$Loop][0] = $Process Then
			ProcessSetPriority($Processes[$Loop][0],$PROCESS_HIGH) ; Self Explanatory
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1]) ; Select the Process
			_WinAPI_SetProcessAffinityMask($hProcess, $Cores) ; Set Affinity (which cores it's assigned to)
			_WinAPI_CloseHandle($hProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
		Else
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])  ; Select the Process
			_WinAPI_SetProcessAffinityMask($hProcess, $AllCores-$Cores) ; Set Affinity (which cores it's assigned to)
			_WinAPI_CloseHandle($hProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
		EndIf
	Next
	ConsoleWrite("Done" & @CRLF)
	ConsoleWrite("Waiting for " & $Process & " to close...")
	While ProcessExists($Process)
		Sleep(1000)
	WEnd
	ConsoleWrite("Done!" & @CRLF)
	Restore(_GetCoreCount())
EndFunc

Func OptimizeAll($Process,$Cores)
	StopServices("True")
	SetPowerPlan("True")
	Optimize($Process,$Cores)
EndFunc

Func Restore($Cores)
	ConsoleWrite("Restoring Previous State..." & @CRLF & @CRLF)
	Local $AllCores = 0
	For $i = 0 To $Cores - 1
		$AllCores += 2^$i
	Next
	ConsoleWrite("Restoring Priority and Affinity of all Other Processes...")
	$Processes = ProcessList()
	For $Loop = 0 to $Processes[0][0] Step 1
		$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])  ; Select the Process
		_WinAPI_SetProcessAffinityMask($hProcess, $AllCores) ; Set Affinity (which cores it's assigned to)
		_WinAPI_CloseHandle($hProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
	Next
	ConsoleWrite("Done!" & @CRLF)
	StopServices("False")
EndFunc

Func SetPowerPlan($State)
	If $State = "True" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_BALANCED', "", @SW_HIDE) ; Set BALANCED power plan
	ElseIf $State = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE) ; Set MINIMUM power saving, aka max performance
	Else
		ConsoleWrite("SetPowerPlan Option " & $State & " is not valid!" & @CRLF)
	EndIf
EndFunc

Func StopServices($State)
	If $State = "True" Then
		ConsoleWrite("Temporarily Game Impacting Services...")
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE) ; Stop Windows Update
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE) ; Stop Printer Spooler
		ConsoleWrite("Done!" & @CRLF)
	ElseIf $State = "False" Then
		ConsoleWrite("Restarting Any Stopped Services...")
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE) ; Start Windows Update
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE) ; Start Printer Spooler
		ConsoleWrite("Done!" & @CRLF)
	Else
		ConsoleWrite("StopServices Option " & $State & " is not valid!" & @CRLF)
	EndIf
EndFunc

Func ToggleHPET($State)
	If $State = "True" Then
		ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF)
		Run("bcdedit /set useplatformclock true") ; Enable System Event Timer
	ElseIf $State = "False" Then
		Run("bcdedit /set useplatformclock false") ; Disable System Event Timer
		ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF)
	EndIf
EndFunc