#include-once

#include <Array.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include "./_WMIC.au3"

; #FUNCTION# ====================================================================================================================
; Name ..........: _ConsoleWrite
; Description ...: Allow on the fly writing to a GUI console based on variables passed
; Syntax ........: _ConsoleWrite($sMessage[, $hOutput = False])
; Parameters ....: $sMessage            - Message to write.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: None
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 1/8/2018
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ConsoleWrite($sMessage, $hOutput = False)

	If $hOutput = False Then
		ConsoleWrite($sMessage)
	Else
		GUICtrlSetData($hOutput, GUICtrlRead($hOutput) & $sMessage)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetHPETState
; Description ...: Get State of Window's High Precision Event Timer
; Syntax ........: _GetHPETState()
; Parameters ....: None
; Return values .: Returns HPET state as True or False
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 1/8/2018
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetHPETState()

	DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
	$hDOS = Run(@ComSpec & ' /c C:\Windows\System32\bcdedit.exe /enum Active | find "useplatformclock"', "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	ProcessWaitClose($hDOS)
	$sMessage = StdoutRead($hDOS) & StderrRead($hDOS)
	$aMessage = StringSplit($sMessage, @CRLF)
	For $iLoop = UBound($aMessage) - 1 To 0 Step -1
		If $aMessage[$iLoop] = "" Then
			_ArrayDelete($aMessage, $iLoop)
		EndIf
	Next
	$aMessage[0] = UBound($aMessage) - 1
	If $aMessage[0] >= 1 Then $aMessage[1] = StringStripWS($aMessage[1], $STR_STRIPALL)
	Return $aMessage

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Optimize
; Description ...: Adjust Priority and Affinity of a Process
; Syntax ........: _Optimize($iProcesses, $hProcess, $hCores[, $iSleepTime = 100[, $bRealtime = False[, $hOutput = False]]])
; Parameters ....: $iProcesses          - Current running process count
;                  $hProcess            - Process handle
;                  $hCores              - Cores to set affinity to
;                  $iSleepTime          - [optional] Internal Sleep Timer. Default is 100.
;                  $bRealtime           - [optional] Use Realtime Priority. Default is False.
;                  $hOutput             - [optional] a handle value. Default is False.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Optimize($iProcesses, $hProcess, $hCores, $iSleepTime = 100, $bRealtime = False, $hOutput = False)

	Dim $iThreads = _GetCPUInfo(1)

	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
	For $iLoop = 0 To $iThreads - 1
		$hAllCores += 2^$iLoop
	Next

	If $iProcesses > 0 Then
		If Not ProcessExists($hProcess) Then
			_ConsoleWrite($hProcess & " exited. Restoring..." & @CRLF, $hOutput)
			Return 1
		ElseIf ProcessExists($hProcess) Then
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			Sleep($iSleepTime)
			If Not (UBound(ProcessList()) = $iProcesses) Then
				Sleep($iSleepTime)
				_ConsoleWrite("Process Count Changed, Rerunning Optimization...", $hOutput)
				Sleep($iSleepTime)
				For $iLoop = 0 to $aProcesses[0][0] Step 1
					If $aProcesses[$iLoop][0] = $hProcess Then
						If $bRealtime Then
							ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_REALTIME)
						Else
							ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_HIGH) ; Self Explanatory
						EndIf
						$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1]) ; Select the Process
						_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
						_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
					EndIf
				Next
				Sleep($iSleepTime)
				_ConsoleWrite("Done!" & @CRLF, $hOutput)
				Sleep($iSleepTime)
			EndIf
		EndIf
	Else
		Select
			Case Not ProcessExists($hProcess)
				_ConsoleWrite("!> " & $hProcess & " is not currently running. Please run the program first" & @CRLF, $hOutput)
				Return 1
			Case Not IsInt($hCores)
				_ConsoleWrite("!> " & $hCores & " is not a proper declaration of what cores to run on" & @CRLF, $hOutput)
				Return 1
			Case $hCores > $hAllCores
				_ConsoleWrite("!> You've specified more cores than available on your system" & @CRLF, $hOutput)
				Return 1
			Case $hCores = $hAllCores
				_ConsoleWrite("!> You've left no cores for other Processes" & @CRLF, $hOutput)
				Return 1
			Case Else
				_ConsoleWrite("Optimzing " & $hProcess & " in the background until it closes..." & @CRLF, $hOutput)
				If ProcessExists($hProcess) Then
					Sleep($iSleepTime)
					$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
					Sleep($iSleepTime)
					_ConsoleWrite("Process Count Changed, Rerunning Optimization...", $hOutput)
					Sleep($iSleepTime)
					For $iLoop = 0 to $aProcesses[0][0] Step 1
						If $aProcesses[$iLoop][0] = $hProcess Then
							If $bRealtime Then
								ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_REALTIME)
							Else
								ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_HIGH) ; Self Explanatory
							EndIf
							$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1]) ; Select the Process
							_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
							_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
						EndIf
					Next
					Sleep($iSleepTime)
					_ConsoleWrite("Done!" & @CRLF, $hOutput)
					Sleep($iSleepTime)
				EndIf
		EndSelect
	EndIf
	Return UBound($aProcesses)

EndFunc

Func _OptimizeAll($hProcess, $aCores = 1, $iSleepTime = 100, $hRealtime = False, $hOutput = False)

	_StopServices("True", $hOutput)
	_SetPowerPlan("True", $hOutput)
	Return _Optimize(0,$hProcess,$aCores,$iSleepTime,$hRealtime,$hOutput)

EndFunc

Func _OptimizeBroadcaster($aProcesses, $hCores, $iSleepTime = 100, $hRealtime = False, $hOutput = False)

	Dim $iThreads = _GetCPUInfo(1)

	Select
		Case Not IsInt($hCores)
			_ConsoleWrite("!> " & $hCores & " is not a proper declaration of what cores to run on" & @CRLF, $hOutput)
			Return 1
		Case Else
			Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
			For $iLoop = 0 To $iThreads - 1
				$hAllCores += 2^$iLoop
			Next
			If $hCores > $hAllCores Then
				_ConsoleWrite("!> You've specified more cores than available on your system" & @CRLF, $hOutput)
				Return 1
			EndIf
			$iProcessesLast = 0
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			For $iLoop = 0 to $aProcesses[0][0] Step 1
				If _ArraySearch($aProcesses, $aProcesses[$iLoop][0]) Then
					If $hRealtime Then
						ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_REALTIME)
					Else
						ProcessSetPriority($aProcesses[$iLoop][0],$PROCESS_HIGH) ; Self Explanatory
					EndIf
					$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1]) ; Select the Process
					_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
					_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
				EndIf
			Next
	EndSelect
	Return 0

EndFunc

Func _OptimizeOthers(ByRef $aExclusions, $hCores, $iSleepTime = 100, $hOutput = False)

	Dim $iThreads = _GetCPUInfo(1)
	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number

	For $iLoop = 0 To $iThreads - 1
		$hAllCores += 2^$iLoop
	Next

	Select
		Case $hCores > $hAllCores
			_ConsoleWrite("!> You've specified more combined cores than available on your system" & @CRLF, $hOutput)
			Return 1
		Case $hCores = $hAllCores
			_ConsoleWrite("!> You've left no cores for other Processes" & @CRLF, $hOutput)
			Return 1
		Case Else
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			Sleep($iSleepTime)
			For $iLoop = 0 to $aProcesses[0][0] Step 1
				If _ArraySearch($aExclusions, $aProcesses[$iLoop][0]) = -1 Then
					$hCurProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $aProcesses[$iLoop][1])  ; Select the Process
					_WinAPI_SetProcessAffinityMask($hCurProcess, $hAllCores-$hCores) ; Set Affinity (which cores it's assigned to)
					_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
				EndIf
			Next
			Sleep($iSleepTime)
	EndSelect

	Return 0

EndFunc

Func _Restore($aCores = _GetCPUInfo(1), $hOutput = False)

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

Func _SetPowerPlan($bState, $hOutput = False)

	If $bState = "True" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE) ; Set MINIMUM power saving, aka max performance
	ElseIf $bState = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_BALANCED', "", @SW_HIDE) ; Set BALANCED power plan
	Else
		_ConsoleWrite("!> SetPowerPlan Option " & $bState & " is not valid!" & @CRLF, $hOutput)
	EndIf

EndFunc

Func _StopServices($bState, $hOutput = False)

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
		_ConsoleWrite("!> StopServices Option " & $bState & " is not valid!" & @CRLF, $hOutput)
	EndIf

EndFunc

Func _ToggleHPET($bState, $hOutput = False)

	If $bState = "True" Then
		_ConsoleWrite("HPET State Changed, Please Reboot to Apply Changes" & @CRLF, $hOutput)
		Run("bcdedit /set useplatformclock true") ; Enable System Event Timer
	ElseIf $bState = "False" Then
		Run("bcdedit /set useplatformclock false") ; Disable System Event Timer
		_ConsoleWrite("HPET State Changed, Please Reboot to Apply Changes" & @CRLF, $hOutput)
	EndIf

EndFunc
