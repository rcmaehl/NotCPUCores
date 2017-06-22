#RequireAdmin

#include <WinAPI.au3>
#include <AutoItConstants.au3>

Func OptimizeAll($Process,$Core)
	Optimize($Process, $Core)
	StopServices(True)
	SetPowerPlan(True)
EndFunc

Func Optimize($Process,$Core)
	#cs
		TO DO:
			Allow setting processes to MULTIPLE CORES
			Automatically determine core count, not really a big deal until the above is implimented
	#ce
	$Core = 2^$Core
	$Processes = ProcessList()
	For $Loop = 0 to $Processes[0][0] Step 1
		If $Processes[$Loop][0] = $Process Then
			ProcessSetPriority($Processes[$Loop][0],$PROCESS_HIGH)
			$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $Processes[$Loop][1])
			_WinAPI_SetProcessAffinityMask($hProcess, $Core)
			_WinAPI_CloseHandle($hProcess)
		Else
			ConsoleWrite("TO DO: Automatically determine core count")
		EndIf
	Next
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
		RunWait(@ComSpec & " /c " & 'net stop wsearch', "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE)
	ElseIf Not $State Then
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'net start wsearch', "", @SW_HIDE)
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

Func Restore()
	RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE)
	RunWait(@ComSpec & " /c " & 'net start wsearch', "", @SW_HIDE)
	RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE)
EndFunc