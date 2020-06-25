#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\icon.ico
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=NotCPUCores Core Beta
#AutoIt3Wrapper_Res_Description=NotCPUCores Core Beta
#AutoIt3Wrapper_Res_Fileversion=1.8.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Robert C Maehl (rcmaehl)
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once

#include <Array.au3>
#include <WinAPI.au3>
#include <Constants.au3>
;#include ".\_WMIC.au3"
;#include ".\_ExtendedFunctions.au3"

Func _Main()

	Local $aExclusions, $aInclusions, $aStatus
	Local $sStatus, $bOptimize

	While True

		$sStatus = ConsoleRead()
		If @extended = 0 Then ContinueLoop

		$aStatus = StringSplit($sStatus, ",")

		Switch $aStatus[0]

			Case "Include"

			Case "Exclude"

			Case "Start"
				$bOptimize = True

			Case "Stop"
				$bOptimize = False

			Case Else
				ConsoleWrite("NCC Core Caught unhandled parameter: " & $aStatus[0] & @CRLF)

		EndSwitch

	WEnd
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetHPETState
; Description ...: Get State of Window's High Precision Event Timer
; Syntax ........: _GetHPETState()
; Parameters ....: None
; Return values .: 1                    - HPET in use
;                  0                    - HPET not in use
;                  -1                   - Function called without Admin Rights
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 05/06/2020
; Remarks .......: Requires Admin Rights
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetHPETState()

	If IsAdmin() Then
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
		Return $aMessage[1]
	Else
		Return SetError(0, 0, -1)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetModifiedProcesses
; Description ...: Get a list of Processes with Modified Affinity
; Syntax ........: _GetModifiedProcesses()
; Parameters ....: None
; Return values .: Returns an array containing modified processes
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 05/06/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetModifiedProcesses()

	Local $aAffinity
	Local $aProcesses
	Local $aModified[0]

	$aProcesses = ProcessList()
	For $Loop = 3 To $aProcesses[0][0] ; Skip System
		$hCurProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, False, $aProcesses[$Loop][1])
		$aAffinity = _WinAPI_GetProcessAffinityMask($hCurProcess)
		If @error Then ContinueLoop
		If $aAffinity[1] = $aAffinity[2] Then
			;;;
		Else
			ReDim $aModified[UBound($aModified) + 1]
			$aModified[UBound($aModified)-1] = $aProcesses[$Loop][0]
		EndIf
		_WinAPI_CloseHandle($hCurProcess)
	Next

	Return $aModified

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Optimize
; Description ...: Adjust Priority and Affinity of a Process
; Syntax ........: _Optimize($iProcesses, $hProcess, $hCores[, $iSleepTime = 100[, $bRealtime = False[, $hOutput = False]]])
; Parameters ....: $iProcesses          - Current running process count
;                  $hProcess            - Process handle
;                  $hCores              - Cores to set affinity to
;                  $iSleepTime          - [optional] Internal Sleep Timer. Default is 100.
;                  $sPriority           - [optional] Priority to Use. Default is High.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: > 1                  - Success, Last Polled Process Count
;                  1                    - Optimization Exiting, Do not Continue
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 06/24/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Optimize($iProcesses, $hProcess, $hCores, $iSleepTime = 100, $sPriority = "HIGH", $hOutput = False)

	Local $iExtended = 0
	Local $aProcesses[1]
	Local $iThreads = 16

	;If IsDeclared("iThreads") = 0 Then Local Static $iThreads = _GetCPUInfo(1)
	Local $aPriorities[6] = ["LOW","BELOWNORMAL","NORMAL","ABOVENORMAL","HIGH","REALTIME"]

	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
	For $iLoop = 0 To $iThreads - 1
		$hAllCores += 2^$iLoop
	Next

	If $iProcesses > 0 Then
		If Not ProcessExists($hProcess) Then
			If FileExists($hProcess) Then
				Run($hProcess)
				Sleep(200)
			Else
				SetError(0, 1, 1)
			EndIf
		EndIf
		If ProcessExists($hProcess) Then
			$iExtended = 1
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			Sleep($iSleepTime)
			If Not (UBound(ProcessList()) = $iProcesses) Then
				Sleep($iSleepTime)
				For $iLoop = 0 to $aProcesses[0][0] Step 1
					If $aProcesses[$iLoop][0] = $hProcess Then
						ProcessSetPriority($aProcesses[$iLoop][0],Eval("Process_" & StringStripWS($sPriority, $STR_STRIPALL)))
						$hCurProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION+$PROCESS_SET_INFORMATION, False, $aProcesses[$iLoop][1]) ; Select the Process
						If Not _WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) Then ; Set Affinity (which cores it's assigned to)
;							_ConsoleWrite("Failed to adjust affinity of " & $aProcesses[$iLoop][0] & @CRLF, $hOutput)
						EndIf
						_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
					EndIf
				Next
				Sleep($iSleepTime)
			EndIf
		EndIf
	Else
		Select
			Case Not ProcessExists($hProcess)
				SetError(1,1,1)
			Case Not IsInt($hCores)
				SetError(1,2,1)
			Case $hCores > $hAllCores
				SetError(1,3,1)
			Case _ArraySearch($aPriorities, $sPriority) = -1
				SetError(1,4,1)
			Case $hCores = $hAllCores
				$iExtended = 2
				ContinueCase
			Case Else
				$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
				If ProcessExists($hProcess) Then
					Sleep($iSleepTime)
					For $iLoop = 0 to $aProcesses[0][0] Step 1
						If $aProcesses[$iLoop][0] = $hProcess Then
							ProcessSetPriority($aProcesses[$iLoop][0],Eval("Process_" & StringStripWS($sPriority, $STR_STRIPALL)))
							$hCurProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION+$PROCESS_SET_INFORMATION, False, $aProcesses[$iLoop][1]) ; Select the Process
							If Not _WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) Then ; Set Affinity (which cores it's assigned to)
;								_ConsoleWrite("Failed to adjust affinity of " & $aProcesses[$iLoop][0] & @CRLF, $hOutput)
							EndIf
							_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
						EndIf
					Next
					Sleep($iSleepTime)
				EndIf
		EndSelect
	EndIf
	Return SetError(0, $iExtended, UBound($aProcesses))

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _OptimizeAll
; Description ...: Run All Optimizations
; Syntax ........: _OptimizeAll($hProcess, $aCores = 1[, $iSleepTime = 100[, $hRealtime = False[, $hOutput = False]]])
; Parameters ....: $hProcess            - Process handle
;                  $hCores              - Cores to set affinity to
;                  $iSleepTime          - [optional] Internal Sleep Timer. Default is 100.
;                  $sPriority           - [optional] Priority to Use. Default is High.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: > 1                  - Success, Last Polled Process Count
;                  1                    - An Error Occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 1/19/2018
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OptimizeAll($hProcess, $hCores, $iSleepTime = 100, $sPriority = "High", $hOutput = False)

	_StopServices("True", $hOutput)
	_SetPowerPlan("True", $hOutput)
	Return _Optimize(0, $hProcess, $hCores, $iSleepTime, $sPriority, $hOutput)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _OptimizeBroadcaster
; Description ...: Optimize all Processes associated with the Broadcasting software
; Syntax ........: _OptimizeBroadcaster($aProcesses, $hCores[, $iSleepTime = 100[, $hRealtime = False[, $hOutput = False]]])
; Parameters ....: $aProcesses          - Array of Processes to Optimize
;                  $hCores              - Cores to set affinity to
;                  $iSleepTime          - [optional] Internal Sleep Timer. Default is 100.
;                  $sPriority           - [optional] Priority to Use. Default is High.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: 0                    - Success
;                  1                    - An error has occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 06/02/2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OptimizeBroadcaster($aProcessList, $hCores, $iSleepTime = 100, $sPriority = "HIGH", $hOutput = False)

	Local $iThreads = 16

	;If IsDeclared("iThreads") = 0 Then Local Static $iThreads = _GetCPUInfo(1)
	Local $aPriorities[6] = ["LOW","BELOW NORMAL","NORMAL","ABOVE NORMAL","HIGH","REALTIME"]

	_ArrayDelete($aProcessList, 0)
	_ArrayDelete($aProcessList, UBound($aProcessList)-1)

	Select
		Case Not IsInt($hCores)
			SetError(1,0,1)
		Case Else
			Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
			For $iLoop = 0 To $iThreads - 1
				$hAllCores += 2^$iLoop
			Next
			If $hCores > $hAllCores Then
				SetError(2,0,1)
			EndIf
			$iProcessesLast = 0
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			Sleep($iSleepTime)
			For $iLoop = 0 to $aProcesses[0][0] Step 1
				If _ArraySearch($aProcessList, $aProcesses[$iLoop][0]) = -1 Then
					;;;
				Else
					ProcessSetPriority($aProcesses[$iLoop][0],Eval("Process_" & StringStripWS($sPriority, $STR_STRIPALL)))
					$hCurProcess = _WinAPI_OpenProcess($PROCESS_SET_INFORMATION, False, $aProcesses[$iLoop][1]) ; Select the Process
					_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
					_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
				EndIf
			Next
	EndSelect
	Return 0

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _OptimizeOthers
; Description ...: Optimize all processes other than the ones Excluded
; Syntax ........: _OptimizeOthers(Byref $aExclusions, $hCores[, $iSleepTime = 100[, $hOutput = False]])
; Parameters ....: $aExclusions         - [in/out] Array of Processes to Exclude
;                  $hCores              - Cores to exclusions were set to
;                  $iSleepTime          - [optional] Internal Sleep Timer. Default is 100.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: 1                    - An error has occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 06/02/2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OptimizeOthers($aExclusions, $hCores, $iSleepTime = 100, $hOutput = False)

	Local $iExtended = 0
	Local $iThreads = 16


;	If IsDeclared("iThreads") = 0 Then Local Static $iThreads = _GetCPUInfo(1)
	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number

	For $iLoop = 0 To $iThreads - 1
		$hAllCores += 2^$iLoop
	Next

	#include <Array.au3>

	Local $aTemp = $aExclusions[UBound($aExclusions) - 1]
	_ArrayDelete($aExclusions, UBound($aExclusions) - 1)
	_ArrayConcatenate($aExclusions, $aTemp)

	Select
		Case $hCores > $hAllCores
			SetError(1,0,1)
		Case $hCores <= 0
			$hCores = 2^($iThreads - 1)
			$iExtended = 1
			ContinueCase
		Case Else
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			Sleep($iSleepTime)
			For $iLoop = 0 to $aProcesses[0][0] Step 1
				If _ArraySearch($aExclusions, $aProcesses[$iLoop][0]) = -1 Then
					$hCurProcess = _WinAPI_OpenProcess($PROCESS_SET_INFORMATION, False, $aProcesses[$iLoop][1])  ; Select the Process
					_WinAPI_SetProcessAffinityMask($hCurProcess, $hCores) ; Set Affinity (which cores it's assigned to)
					_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
				Else
					;;;
				EndIf
			Next
			Sleep($iSleepTime)
	EndSelect
	Return SetError(0, $iExtended, 0)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Restore
; Description ...: Reset Affinities and Priorities to Default
; Syntax ........: _Restore([$hCores = _GetCPUInfo(1[, $hOutput = False]])
; Parameters ....: $aExclusions         - [optional] Array of excluded processes
;                  $hCores              - [optional] Cores to Set Affinity to.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: None
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 06/02/2019
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Restore($aExclusions = Null, $hCores = 16, $hOutput = False)

	Local $hAllCores = 0 ; Get Maxmimum Cores Magic Number
	For $iLoop = 0 To $hCores - 1
		$hAllCores += 2^$iLoop
	Next

;	If $aExclusions = "" Then ReDim $aExclusions[0]

	$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority back to normal
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		If _ArraySearch($aExclusions, $aProcesses[$iLoop][0]) = -1 Then
			;;;
		Else
			ContinueLoop
		EndIf
		$hCurProcess = _WinAPI_OpenProcess($PROCESS_SET_INFORMATION, False, $aProcesses[$iLoop][1])  ; Select the Process
		_WinAPI_SetProcessAffinityMask($hCurProcess, $hAllCores) ; Set Affinity (which cores it's assigned to)
		_WinAPI_CloseHandle($hCurProcess) ; I don't need to do anything else so tell the computer I'm done messing with it
	Next
	_StopServices("False", $hOutput) ; Additional Clean Up

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetPowerPlan
; Description ...: Set Windows Power Plan to High Performance
; Syntax ........: _SetPowerPlan($bState[, $hOutput = False])
; Parameters ....: $bState              - Set Power Plan to High Performance.
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: None
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 3/13/2018
; Remarks .......: TO DO: Return values
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SetPowerPlan($bState, $hOutput = False)

	If $bState = "True" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_MIN', "", @SW_HIDE) ; Set MINIMUM power saving, aka max performance
	ElseIf $bState = "False" Then
		RunWait(@ComSpec & " /c " & 'POWERCFG /SETACTIVE SCHEME_BALANCED', "", @SW_HIDE) ; Set BALANCED power plan
;	Else
;		_ConsoleWrite("!> SetPowerPlan Option " & $bState & " is not valid!" & @CRLF, $hOutput)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _StopServices
; Description ...: Stop services that won't be needing during gaming
; Syntax ........: _StopServices($bState[, $hOutput = False])
; Parameters ....: $bState              - "True" to stop services, "False" to start services
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: None
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 3/13/2018
; Remarks .......: TO DO: Return values, Accept Array of Services to Start/Stop
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _StopServices($bState, $hOutput = False)

	If $bState = "True" Then
;		_ConsoleWrite("Temporarily Pausing Game Impacting Services..." & @CRLF, $hOutput)
		RunWait(@ComSpec & " /c " & 'net stop wuauserv', "", @SW_HIDE) ; Stop Windows Update
		RunWait(@ComSpec & " /c " & 'net stop spooler', "", @SW_HIDE) ; Stop Printer Spooler
;		_ConsoleWrite("Done!" & @CRLF, $hOutput)
	ElseIf $bState = "False" Then
;		_ConsoleWrite("Restarting Any Stopped Services..." & @CRLF, $hOutput)
		RunWait(@ComSpec & " /c " & 'net start wuauserv', "", @SW_HIDE) ; Start Windows Update
		RunWait(@ComSpec & " /c " & 'net start spooler', "", @SW_HIDE) ; Start Printer Spooler
;		_ConsoleWrite("Done!" & @CRLF, $hOutput)
;	Else
;		_ConsoleWrite("!> StopServices Option " & $bState & " is not valid!" & @CRLF, $hOutput)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _ToggleHPET
; Description ...: Toggle the High Precision Event Timer
; Syntax ........: _ToggleHPET($bState[, $hOutput = False])
; Parameters ....: $bState              - Set HPET On or Off
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: None
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 1/11/2018
; Remarks .......: TO DO: Return values
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ToggleHPET($bState, $hOutput = False)

	If $bState = "True" Then
;		_ConsoleWrite("HPET State Changed, Please Reboot to Apply Changes" & @CRLF, $hOutput)
		Run("bcdedit /set useplatformclock true") ; Enable System Event Timer
	ElseIf $bState = "False" Then
		Run("bcdedit /set useplatformclock false") ; Disable System Event Timer
;		_ConsoleWrite("HPET State Changed, Please Reboot to Apply Changes" & @CRLF, $hOutput)
	EndIf

EndFunc