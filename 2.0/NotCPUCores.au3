#RequireAdmin

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

#include ".\includes\Console.au3"
#include ".\includes\MetroGUI_UDF.au3"

Main()

Func _CreateButton($sText, $iLeft, $iTop, $iWidth = -1, $iHeight = -1, $iStyle = -1)
	Local $hCreated

	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			$hCreated = _Metro_CreateButton($sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle)
		Case Else
			$hCreated = GUICtrlCreateButton($sText, $iLeft, $iTop, $iWidth, $iHeight)
	EndSwitch

	Return $hCreated
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

Func _GetWindowProcessList()
	Local $aWindows = WinList()
	Local $iDelete = 0
	Do
		$iDelete = _ArraySearch($aWindows, "Default IME")
		_ArrayDelete($aWindows, $iDelete)
	Until _ArraySearch($aWindows, "Default IME") = -1
	$aWindows[0][0] = UBound($aWindows)
	For $iLoop = 1 To $aWindows[0][0] - 1
		$aWindows[$iLoop][1] = _ProcessGetName(WinGetProcess($aWindows[$iLoop][1]))
	Next
	_ArrayDelete($aWindows, 0)
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
			$aProcesses = ProcessList() ; Meat and Potatoes, Change Affinity and Priority
			ConsoleWrite("Setting Priority and Affinity of " & $hProcess & "...")
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
			ConsoleWrite("Done" & @CRLF)
			ConsoleWrite("Waiting for " & $hProcess & " to close...")
			While ProcessExists($hProcess)
				Sleep(1000)
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

Func Main()

	Switch @OSVersion
		Case "WIN_10", "WIN_81", "WIN_8"
			_SetTheme("DarkBlue")
			_Metro_EnableHighDPIScaling()
			$hGUI = _Metro_CreateGUI("NotCPUCores", 640, 120, -1, -1)
			$aControl_Buttons = _Metro_AddControlButtons(True,False,False,False)
			$hGUI_CLOSE_BUTTON = $aControl_Buttons[0]
		Case Else
			$hGUI = GUICreate("NotCPUCores", 640, 140, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
			$hGUI_CLOSE_BUTTON = $GUI_EVENT_CLOSE
	EndSwitch
	GUICtrlCreateGroup("What Would You Like To Do?", 0, 0, 640, 140)
	$hOptimize = _CreateButton("Optimize A Game", 10, 20, 200, 110, BitXOR($BS_ICON,$BS_TOP))
	$hManageSet = _CreateButton("Manage Auto Optimizes", 220, 20, 200, 110, BitXOR($BS_ICON,$BS_TOP))
	$hCleanPC = _CreateButton("Optimize PC", 430, 20, 200, 110, BitXOR($BS_ICON,$BS_TOP))


	GUISetState(@SW_SHOW, $hGUI)

	While 1

		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hGUI_CLOSE_BUTTON
				GUIDelete($hGUI)
				Exit

		EndSelect

	WEnd

EndFunc
