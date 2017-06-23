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
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>

ModeSelect($CmdLine)

Func Main()

	Local $hGUI = GUICreate("NotCPUCores", 280, 350, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	Local $sVersion = "1.0.0.0"

	GUICtrlCreateTab(0, 0, 280, 350, 0)

	GUICtrlCreateTabItem("Optimize")

	GUICtrlCreateTabItem("Advanced")

	GUICtrlCreateTabItem("About")

	GUICtrlCreateLabel(@CRLF & "NotCPUCores" & @TAB & "v" & $sVersion & @CRLF & "Developed by Robert Maehl", 30, 45, 220, 50, $SS_CENTER)
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
			ProcessSetPriority($Processes[$Loop][0],$PROCESS_HIGH)
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])
			_WinAPI_SetProcessAffinityMask($hProcess, $Core)
			_WinAPI_CloseHandle($hProcess)
		Else
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])
			_WinAPI_SetProcessAffinityMask($hProcess, $AllCores-$Core)
			_WinAPI_CloseHandle($hProcess)
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
		Run("bcdedit /set useplatformclock true")
	ElseIf $State = "False" Then
		Run("bcdedit /set useplatformclock false")
		ConsoleWrite("You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply" & @CRLF)
	EndIf
EndFunc

Func StopServices($State)
	If $State = "True" Then
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE)
	ElseIf $State = "False" Then
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE)
	EndIf
EndFunc

Func SetPowerPlan($State)
	If $State = "True" Then
		ConsoleWrite("INVALID PARAMETER FOR SETPOWERPLAN" & @CRLF)
	ElseIf $State = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE)
	EndIf
EndFunc

Func Restore($Cores)
	Local $AllCores = 0
	For $i = 0 To $Cores - 1
		$AllCores += 2^$i
	Next
	$Processes = ProcessList()
	For $Loop = 0 to $Processes[0][0] Step 1
		$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])
		_WinAPI_SetProcessAffinityMask($hProcess, $AllCores)
		_WinAPI_CloseHandle($hProcess)
	Next
	RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE)
	RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE)
EndFunc