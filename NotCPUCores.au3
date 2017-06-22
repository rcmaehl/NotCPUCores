#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPI.au3>
#include <Constants.au3>
#include <AutoItConstants.au3>

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
		ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
	Else
		Switch $CmdLine[1]
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

Func OptimizeAll($Process,$Cores,$Core)
	Optimize($Process,$Cores,$Core)
	StopServices(True)
	SetPowerPlan(True)
	While ProcessExists($Process)
		Sleep(1000)
	WEnd
	Restore($Cores)
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
	$Core = 2^$Core
	$Processes = ProcessList()
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
	While ProcessExists($Process)
		Sleep(1000)
	WEnd
	Restore($Cores)
EndFunc

Func ToggleHPET($State)
	If Not IsBool($State) Then
		ConsoleWrite("INVALID PARAMETER FOR TOGGLEHPET" & @CRLF)
	ElseIf $State Then
		Run("bcdedit /set useplatformclock true")
	ElseIf Not $State Then
		Run("bcdedit /set useplatformclock false")
	EndIf
	MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "HPET Tweaking requires Restart", "You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply")
EndFunc

Func StopServices($State)
	If Not IsBool($State) Then
		ConsoleWrite("INVALID PARAMETER FOR STOPSERVICES" & @CRLF)
	ElseIf $State Then
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE)
	ElseIf Not $State Then
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE)
	EndIf
EndFunc

Func SetPowerPlan($State)
	If Not IsBool($State) Then
		ConsoleWrite("INVALID PARAMETER FOR SETPOWERPLAN" & @CRLF)
	ElseIf $State Then
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