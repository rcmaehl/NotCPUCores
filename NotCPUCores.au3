#RequireAdmin

#include <WinAPI.au3>
#include <AutoItConstants.au3>

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

ToggleHPET($State)
	If $State Then
		Run("bcdedit /set useplatformclock true")
	ElseIf Not $State Then
		Run("bcdedit /set useplatformclock false")
	EndIf
	MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "HPET Tweaking requires Restart", "You've changed the state of the HPET, you'll need to restart your computer for this tweak to apply")
EndFunc

