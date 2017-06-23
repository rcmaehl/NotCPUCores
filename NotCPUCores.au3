#RequireAdmin
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Compiled 6/23/2017 @ 11:13 EST
#AutoIt3Wrapper_Res_Description=NotCPUCores
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=No
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPI.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


ModeSelect($CmdLine)

Func Main()

	Local $hGUI = GUICreate("NotCPUCores", 280, 320, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	Local $sVersion = "1.0.0.0"

	GUICtrlCreateTab(0, 0, 280, 320, 0)

	GUICtrlCreateTabItem("Optimize")

	GUICtrlCreateLabel("Type/Select the Process Name", 5, 25, 270, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xF0F0F0)
	GUICtrlCreateLabel("Process Name:", 10, 45, 80, 15)
	Local $hTask = GUICtrlCreateInput("", 150, 45, 100, 20, $ES_UPPERCASE + $ES_RIGHT)
	Local $hSearch = GUICtrlCreateButton("?", 250, 45, 20, 20)

	GUICtrlCreateLabel("How Many Cores Do You Have?", 5, 80, 270, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core Count:", 10, 100, 80, 15)
	Local $hCores = GUICtrlCreateInput("", 230, 100, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER)
	GUICtrlSetLimit(-2,2)

	GUICtrlCreateLabel("Which Cores Do You Want to Run On?", 5, 130, 270, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Core:", 10, 150, 80, 15)
	Local $hCores = GUICtrlCreateInput("", 230, 150, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER)
	GUICtrlSetLimit(-2,2)

	GUICtrlCreateButton("OPTIMIZE", 5, 295, 270, 20)

	GUICtrlCreateTabItem("Advanced")

	GUICtrlCreateLabel("Below You Can Enable Or Disable the High Precision Event Timer for Windows. On SOME games this may DECREASE performance instead of INCREASE. You can always change it back!", 5, 25, 270, 60, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xF0F0F0)

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

		EndSelect
	WEnd
EndFunc

Func ModeSelect($CmdLine)
	If $CmdLine[0] > 1 Then
		Switch $CmdLine[1]
			Case "OptimizeAll"
				If $CmdLine[0] < 4 Then
					ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreCount CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not ProcessExists($CmdLine[2]) Then
					ConsoleWrite($CmdLine[2] & " is not currently running. Please run the program first" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not IsInt(Number($CmdLine[3])) And Not IsInt(Number($CmdLine[4])) Then
					ConsoleWrite("Invalid options set for CoreCount and CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Number($CmdLine[3]) < Number($CmdLine[4]) Then
					ConsoleWrite("Core " & $CmdLine[4] & " does not exist on a " & $CmdLine[3] & " core system" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					OptimizeAll($CmdLine[2],$CmdLine[3],$CmdLine[4])
				EndIf
			Case "Optimize"
				If $CmdLine[0] < 4 Then
					ConsoleWrite("Optimize Requires ProcessName.exe CoreCount CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not ProcessExists($CmdLine[2]) Then
					ConsoleWrite($CmdLine[2] & " is not currently running. Please run the program first" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not IsInt(Number($CmdLine[3])) And Not IsInt(Number($CmdLine[4])) Then
					ConsoleWrite("Invalid options set for CoreCount and CoreToRunOn" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Number($CmdLine[3]) < Number($CmdLine[4]) Then
					ConsoleWrite("Core " & $CmdLine[4] & " does not exist on a " & $CmdLine[3] & " core system" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					Optimize($CmdLine[2],$CmdLine[3],$CmdLine[4])
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
			Case "Restore"
				If $CmdLine[0] < 2 Then
					ConsoleWrite("Restore Requires CoreCount" & @CRLF)
					Sleep(1000)
					Exit 1
				ElseIf Not IsInt(Number($CmdLine[2])) Then
					ConsoleWrite($CmdLine[2] & " is not a valid CoreCount" & @CRLF)
					Sleep(1000)
					Exit 1
				Else
					Restore($CmdLine[2])
				EndIf
			Case Else
				ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
				Sleep(1000)
				Exit 1
		EndSwitch
	Else
		If $CmdLine[0] = 0 Then
			Main()
		Else
			Switch $CmdLine[1]
				Case "/?"
					ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
				Case "Help"
					ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
				Case "OptimizeAll"
					ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreCount CoreToRunOn" & @CRLF)
				Case "Optimize"
					ConsoleWrite("Optimize Requires ProcessName.exe CoreCount CoreToRunOn" & @CRLF)
					Sleep(5000)
				Case "ToggleHPET"
					ConsoleWrite("ToggleHPET Requires True/False" & @CRLF)
				Case "StopServices"
					ConsoleWrite("StopServices Requires True/False" & @CRLF)
				Case "SetPowerPlan"
					ConsoleWrite("SetPowerPlan Requires True/False" & @CRLF)
				Case "Restore"
					ConsoleWrite("Restore Requires CoreCount" & @CRLF)
				Case Else
					ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
			EndSwitch
		EndIf
		Sleep(5000)
		Exit 0
	EndIf
EndFunc

Func OptimizeAll($Process,$Cores,$Core)
	StopServices("True")
	SetPowerPlan("True")
	Optimize($Process,$Cores,$Core)
EndFunc

Func Optimize($Process,$Cores,$Core)
	#cs
		TO DO:
			Allow setting processes to MULTIPLE CORES
			Automatically determine core count, not really a big deal until the above is implimented
	#ce
	Local $AllCores = 0
	For $i = 0 To $Cores - 1
		$AllCores += 2^$i
	Next
	$Core = 2^($Core-1)
	$Processes = ProcessList()
	ConsoleWrite("Optimizing " & $Process & "...")
	For $Loop = 0 to $Processes[0][0] Step 1
		If $Processes[$Loop][0] = $Process Then
			ProcessSetPriority($Processes[$Loop][0],$PROCESS_HIGH) ; Self Explanatory
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1]) ; Select the Process
			_WinAPI_SetProcessAffinityMask($hProcess, $Core) ; Set Affinity (which cores it's assigned to)
			_WinAPI_CloseHandle($hProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
		Else
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])  ; Select the Process
			_WinAPI_SetProcessAffinityMask($hProcess, $AllCores-$Core) ; Set Affinity (which cores it's assigned to)
			_WinAPI_CloseHandle($hProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
		EndIf
	Next
	ConsoleWrite("Done" & @CRLF)
	ConsoleWrite("Waiting for " & $Process & " to close...")
	While ProcessExists($Process)
		Sleep(1000)
	WEnd
	ConsoleWrite("Done!" & @CRLF)
	ConsoleWrite("Restoring Previous State..." & @CRLF & @CRLF)
	Restore($Cores)
	ConsoleWrite("Done!" & @CRLF)
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

Func StopServices($State)
	If $State = "True" Then
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE) ; Stop Windows Update
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE) ; Stop Printer Spooler
	ElseIf $State = "False" Then
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE) ; Start Windows Update
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE) ; Start Printer Spooler
	EndIf
EndFunc

Func SetPowerPlan($State)
	If $State = "True" Then
		ConsoleWrite("INVALID PARAMETER FOR SETPOWERPLAN" & @CRLF)
	ElseIf $State = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE) ; Set MINIMUM power saving, aka max performance
	EndIf
EndFunc

Func Restore($Cores)
	Local $AllCores = 0
	For $i = 0 To $Cores - 1
		$AllCores += 2^$i
	Next
	$Processes = ProcessList()
	For $Loop = 0 to $Processes[0][0] Step 1
		$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])  ; Select the Process
		_WinAPI_SetProcessAffinityMask($hProcess, $AllCores) ; Set Affinity (which cores it's assigned to)
		_WinAPI_CloseHandle($hProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
	Next
	RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE)
	RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE)
EndFunc

Func _GetCoreCount()
    Local $s_Text = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_Processor')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            Local $s_Text = $Obj_Item.numberOfCores
        Next

        Return String($s_Text)
    Else
        Return 0
    EndIf
EndFunc