#RequireAdmin
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Comment=Compiled 12/25/2017 @ 8:25 EST
#AutoIt3Wrapper_Res_Description=NotCPUCores
#AutoIt3Wrapper_Res_Fileversion=1.6.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Robert Maehl, using LGPL 3 License
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Process.au3>
#include <Constants.au3>
#include <GUIListView.au3>
#include <GuiComboBox.au3>
#include <EditConstants.au3>
#include <FileConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>

#include ".\Includes\_Core.au3"
#include ".\Includes\_WMIC.au3"
;#include ".\Includes\_ModeSelect.au3"
#include ".\Includes\_GetEnvironment.au3"

Opt("GUICloseOnESC", 0)
Opt("GUIResizeMode", $GUI_DOCKALL)

Global $bInterrupt = False
HotKeySet("{PAUSE}", "_Interrupt")
HotKeySet("{BREAK}", "_Interrupt")

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

; Set Core Count as Global to Reduce WMIC calls

Global $iCores = _GetCPUInfo(0)
Global $iThreads = _GetCPUInfo(1)

Main()

Func Main()

	; One Time Variable Setting
	Local $aCores
	Local $iSleep = 100
	Local $sVersion = "1.6.0.0"
	Local $iAllCores
	Local $aProcesses[1]
	Local $iProcesses = 0
	Local $iProcessCores = 1
	Local $iBroadcasterCores = 0
	Local $iOtherProcessCores = 1

	$iAllCores = 0
	For $iLoop = 0 To $iThreads - 1
		$iAllCores += 2^$iLoop
	Next
	$iOtherProcessCores = $iAllCores - $iProcessCores

	Local $hGUI = GUICreate("NotCPUCores", 640, 480, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))

	#Region ; File Menu
	Local $hMenu1 = GUICtrlCreateMenu("File")
	Local $hLoad = GUICtrlCreateMenuItem("Load Profile", $hMenu1)
	Local $hSave = GUICtrlCreateMenuItem("Save Profile", $hMenu1)
	GUICtrlCreateMenuItem("", $hMenu1)
	Local $hQuit = GUICtrlCreateMenuItem("Quit"        , $hMenu1)
	#EndRegion

	#Region ; Options Menu
	Local $hMenu2 = GUICtrlCreateMenu("Options"    )
	Local $hTimer = GUICtrlCreateMenu("Sleep Timer", $hMenu2)
	Local $hGetTimer = GUICtrlCreateMenuItem("Current Timer: " & $iSleep & "ms", $hTimer)
	GUICtrlSetState($hGetTimer, $GUI_DISABLE)
	GUICtrlCreateMenuItem("", $hTimer)
	Local $hSetTimer = GUICtrlCreateMenuItem("Set Sleep Timer", $hTimer)
	#EndRegion

	Local $hDToggle = GUICtrlCreateButton("D", 260, 0, 20, 20)
		GUICtrlSetTip($hDToggle, "Toggle Debug Mode")

	GUICtrlCreateTab(0, 0, 280, 300, 0)

	#Region ; Optimize Tab
	GUICtrlCreateTabItem("Optimize")

	GUICtrlCreateLabel("Game/App Optimization", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Process:", 10, 50, 140, 15)

	Local $hTask = GUICtrlCreateCombo("", 150, 45, 100, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_AUTOHSCROLL)
		GUICtrlSetTip(-1, "Enter the name of the process here." & @CRLF & _
			"Example: NOTEPAD.EXE", "USAGE", $TIP_NOICON)

	Local $hSearch = GUICtrlCreateButton(ChrW(8678), 250, 45, 20, 20)
		GUICtrlSetFont(-1, 12)
		GUICtrlSetTip(-1, "Import Selected Process from Process List", "USAGE", $TIP_NOICON)

	GUICtrlCreateLabel("Include Children:", 10, 75, 140, 20)

	Local $hChildren = GUICtrlCreateCheckbox("", 150, 70, 120, 20, $BS_RIGHTBUTTON)
		GUICtrlSetTip(-1, "Include other Processes the Game/App starts" & @CRLF & _
			"Coming Soon", "USAGE", $TIP_NOICON)
		GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("Core Assignment:", 10, 100, 140, 15)

	Local $hCores = GUICtrlCreateInput("1", 150, 95, 120, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_AUTOHSCROLL)
		GUICtrlSetTip(-1, "To run on a Single Core, enter the number of that core." & @CRLF & _
			"To run on Multiple Cores, seperate them with commas." & @CRLF & _
			"Ranges seperated by a dash are supported." & @CRLF & _
			"Example: 1,3,4-6" & @TAB & @TAB & "Maximum Cores: " & $iThreads, "USAGE", $TIP_NOICON)

	GUICtrlCreateLabel("Process Priority:", 10, 125, 140, 15)

	Local $hPPriority = GUICtrlCreateCombo("", 150, 120, 120, 20, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1, "Normal|Above Normal|High|Realtime", "High")

	Local $hOptimize = GUICtrlCreateButton("OPTIMIZE", 5, 275, 135, 20)
	Local $hReset = GUICtrlCreateButton("RESTORE", 140, 275, 135, 20)
	#EndRegion

	#Region ; Stream Tab
	GUICtrlCreateTabItem("Stream")

	GUICtrlCreateLabel("Streaming Optimization", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Allocation Mode:", 10, 50, 140, 15)

	Local $hSplitMode = GUICtrlCreateCombo("", 150, 45, 120, 20, $CBS_DROPDOWNLIST)
		If $iCores = $iThreads Then
			GUICtrlSetData(-1, "OFF|Last Core|Last 2 Cores|Last 4 Cores|Last Half|Even Cores|Odd Cores|Last AMD CCX", "OFF")
		Else
			GUICtrlSetData(-1, "OFF|Last Core|Last 2 Cores|Last 4 Cores|Last Half|Physical Cores|Non-Physical Cores|Every Other Pair|Last AMD CCX", "OFF")
		EndIf

	GUICtrlCreateLabel("Broadcast Software:", 10, 75, 140, 15)

	Local $hBroadcaster = GUICtrlCreateCombo("", 150, 70, 120, 20, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1, "OBS|XSplit", "OBS")
		GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("Include Children:", 10, 100, 140, 20)

	Local $hBroChild = GUICtrlCreateCheckbox("", 150, 95, 120, 20, $BS_RIGHTBUTTON)
		GUICtrlSetTip(-1, "Include other Processes the Broadcaster starts" & @CRLF & _
			"Coming Soon", "USAGE", $TIP_NOICON)
		GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("Assign Other Processes to:", 10, 125, 140, 20)

	Local $hOAssign = GUICtrlCreateCombo("", 150, 120, 120, 20, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1, "Broadcaster Cores|Game Cores|Remaining Cores", "Remaining Cores")
		GUICtrlSetState(-1, $GUI_DISABLE)

	#EndRegion

	#Region ; Tweaks Tab
	GUICtrlCreateTabItem("PC Tweaks")

	GUICtrlCreateLabel("Game Performance", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	Local $hHPET = GUICtrlCreateButton(" HPET", 5, 40, 80, 40, $BS_MULTILINE)
		GUICtrlSetImage(-1, "shell32.dll", -13)

	Local $hGameM = GUICtrlCreateButton(" Game" & @CRLF & " Mode", 100, 40, 80, 40, $BS_MULTILINE)
		GUICtrlSetImage(-1, "shell32.dll", -208)
		If @OSVersion = "WIN_10" Then
			If @OSBuild < 15007 Then GUICtrlSetState(-1, $GUI_DISABLE)
		Else
			GUICtrlSetState($hGameM, $GUI_DISABLE)
		EndIf

	;GUICtrlCreateButton("Future button", 195, 40, 80, 40, $BS_MULTILINE)

	GUICtrlCreateLabel("Disk Performance", 5, 85, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	Local $hDefrag = GUICtrlCreateButton("Disk" & @CRLF & "Defrag", 5, 100, 80, 40, $BS_MULTILINE)
		GUICtrlSetImage(-1, "shell32.dll", -81)

	GUICtrlCreateLabel("Disk Space", 5, 145, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	Local $hCleanup = GUICtrlCreateButton("Disk" & @CRLF & "Cleanup", 5, 160, 80, 40, $BS_MULTILINE)
		GUICtrlSetImage(-1, "shell32.dll", -32)

;	GUICtrlCreateLabel("Below You Can Enable Or Disable the High Precision Event Timer for Windows. On SOME games this may DECREASE performance instead of INCREASE. You can always change it back!", 5, 25, 270, 60, $SS_CENTER + $SS_SUNKEN)
;		GUICtrlSetBkColor(-1, 0xF0F0F0)

;	Local $HPETEnable = GUICtrlCreateButton("Enable HPET", 5, 85, 135, 20)
;	Local $HPETDisable = GUICtrlCreateButton("Disable HPET", 140, 85, 135, 20)

;	GUICtrlCreateLabel("Below you can run some Windows Maintenance Tools", 5, 115, 270, 20, $SS_CENTER + $SS_SUNKEN)
;	GUICtrlSetBkColor(-1, 0xF0F0F0)
	#EndRegion

	#Region ; Options Tab
#cs
	GUICtrlCreateTabItem("Options")

	GUICtrlCreateLabel("Internal Sleep Timer:", 10, 35, 220, 15)

	Local $hSleepTimer = GUICtrlCreateInput("100", 230, 30, 40, 20, $ES_UPPERCASE + $ES_RIGHT + $ES_NUMBER)
		GUICtrlSetLimit(-1, 3,1)
		GUICtrlSetTip(-1, "Internal Sleep Timer" & @CRLF & _
			"Decreasing this value can smooth FPS drops, " & @CRLF & _
			"at the risk of NCC having more CPU usage itself", "USAGE", $TIP_NOICON, $TIP_BALLOON)

#cs
	GUICtrlCreateLabel("Processes to Always Include", 5, 25, 270, 20, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateListView("", 5, 45, 270, 120, $LVS_EX_FULLROWSELECT+$LVS_EX_DOUBLEBUFFER+$ES_READONLY)

	GUICtrlCreateLabel("Processes to Always Exclude", 5, 170, 270, 20, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateListView("", 5, 190, 270, 120, $LVS_EX_FULLROWSELECT+$LVS_EX_DOUBLEBUFFER+$ES_READONLY)
#ce
#ce
	#EndRegion

	#Region ; Specs Tab
	GUICtrlCreateTabItem("My PC")

	GUICtrlCreateLabel("Operating System", 5, 25, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("OS:", 10, 45, 70, 15)
		GUICtrlCreateLabel(_GetOSInfo(0) & " " & _GetOSInfo(1), 80, 45, 190, 20, $ES_RIGHT)

	GUICtrlCreateLabel("Language:", 10, 65, 70, 15)
		GUICtrlCreateLabel(_GetLanguage(), 80, 65, 190, 20, $ES_RIGHT)

	GUICtrlCreateLabel("Hardware", 5, 90, 270, 15, $SS_CENTER + $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)

	GUICtrlCreateLabel("Motherboard:", 10, 110, 70, 15)
		GUICtrlCreateLabel(_GetMotherboardInfo(0) & " " & _GetMotherboardInfo(1), 60, 130, 210, 20, $ES_RIGHT)

	GUICtrlCreateLabel("CPU:", 10, 150, 50, 15)
		GUICtrlCreateLabel(_GetCPUInfo(2), 60, 170, 210, 20, $ES_RIGHT)

	GUICtrlCreateLabel("RAM:", 10, 190, 70, 15)
		GUICtrlCreateLabel(Round(MemGetStats()[1]/1048576) & " GB @ " & _GetRAMInfo(0) & " MHz", 80, 210, 190, 20, $ES_RIGHT)

	GUICtrlCreateLabel("GPU:", 10, 230, 70, 15)
		GUICtrlCreateLabel(_GetGPUInfo(0), 80, 250, 190, 20, $ES_RIGHT)

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

	#EndRegion
	GUICtrlCreateTabItem("")

	#Region ; Process List
	Local $bPHidden = False
	Local $hProcesses = GUICtrlCreateListView("Window Process|Window Title", 280, 0, 360, 300, $LVS_REPORT+$LVS_SINGLESEL, $LVS_EX_GRIDLINES+$LVS_EX_FULLROWSELECT+$LVS_EX_DOUBLEBUFFER)
		_GUICtrlListView_RegisterSortCallBack($hProcesses)

	_GetProcessList($hProcesses)
	_GUICtrlListView_SortItems($hProcesses, GUICtrlGetState($hProcesses))

	GUICtrlSetState($hProcesses, $GUI_HIDE)
	$bPHidden = True
	#EndRegion

	#Region ; Debug Console
	Local $bCHidden = False
	$hConsole = GUICtrlCreateEdit("Debug Console Initialized" & @CRLF & "---" & @CRLF, 0, 300, 640, 160, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x000000)

	GUICtrlSetState($hConsole, $GUI_HIDE)
	$bCHidden = True
	#EndRegion

	WinMove($hGUI, "", Default, Default, 285, 345, 1)
	GUISetState(@SW_SHOW, $hGUI)

	While 1

		; Optimize first, always
		If Not $iProcesses = 0 Then
			If $bInterrupt = True Then
				$bInterrupt = False
				_ConsoleWrite("Exiting Optimizations via Interrupt...", $hConsole)
				$iProcesses = 1
			ElseIf $iProcesses = 1 Then
				_Restore($iThreads, $hConsole) ; Do Clean Up
				GUICtrlSetData($hOptimize, "OPTIMIZE")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next
				$iProcesses = 0
			Else
				If Not (UBound(ProcessList()) = $iProcesses) Then
					$aProcesses[0] = GUICtrlRead($hTask)
					$iProcesses = _Optimize($iProcesses,$aProcesses[0],$iProcessCores,$iSleep,GUICtrlRead($hPPriority),$hConsole)
					If _OptimizeOthers($aProcesses, $iOtherProcessCores, $iSleep, $hConsole) Then $iProcesses = 1
					If _OptimizeBroadcaster($aProcesses, $iBroadcasterCores, $iSleep, GUICtrlRead($hPPriority), $hConsole) Then $iProcesses = 1
				EndIf
			EndIf
		EndIf

		$hMsg = GUIGetMsg()
		Sleep(10)

		Select

			Case $hMsg = $GUI_EVENT_CLOSE or $hMsg = $hQuit
				_GUICtrlListView_UnRegisterSortCallBack($hProcesses)
				GUIDelete($hGUI)
				Exit

			Case $hMsg = $hDToggle
				If $bCHidden Or $bPHidden Then
					GUICtrlSetState($hConsole, $GUI_SHOW)
					GUICtrlSetState($hProcesses, $GUI_SHOW)
					$aPos = WinGetPos($hGUI)
					WinMove($hGUI, "", $aPos[0], $aPos[1], 640, 480)
					GUICtrlSetPos($hConsole, 0, 300, 635, 135)
					GUICtrlSetPos($hProcesses, 280, 0, 355, 300)
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

;			Case $hMsg = $hRealtime
;				If _IsChecked($hRealtime) Then
;					GUICtrlSetState($hRealtime, $GUI_UNCHECKED)
;				Else
;					GUICtrlSetState($hRealtime, $GUI_CHECKED)
;				EndIf

			;Case $hMsg = $hSetTimer
				;InputBox("Set Sleep Timer", "

			Case $hMsg = $hSave
				If GUICtrlRead($hTask) = "" Then
					$sFile = "profile.ncc"
				Else
					$sFile = StringLower(GUICtrlRead($hTask)) & ".ncc"
				EndIf
				$hFile = FileSaveDialog("Save Current Settings", @WorkingDir, "NotCPUCores Profile (*.ncc)", $FD_PROMPTOVERWRITE, $sFile, $hGUI)
				IniWrite($hFile, "General"  , "Process" , GUICtrlRead($hTask       ))
				IniWrite($hFile, "General"  , "Threads" , GUICtrlRead($hCores      ))
				;IniWrite($hFile, "General"  , "Children", GUICtrlRead($hChildren   ))
				IniWrite($hFile, "General"  , "Priority", GUICtrlRead($hPPriority  ))
				IniWrite($hFile, "Streaming", "SplitAs" , GUICtrlRead($hSplitMode  ))
				IniWrite($hFile, "Streaming", "Software", GUICtrlRead($hBroadcaster))

			Case $hMsg = $hProcesses
				_GetProcessList($hProcesses)

			Case $hMsg = $hSearch
				GUICtrlSetState($hDToggle, $GUI_DISABLE)
				If $bPHidden Then
					GUICtrlSetState($hProcesses, $GUI_SHOW)
					$aPos = WinGetPos($hGUI)
					WinMove($hGUI, "", $aPos[0], $aPos[1], 640)
					GUICtrlSetPos($hProcesses, 280, 0, 355, 300)
					$bPHidden = False
				Else
					$aTask = StringSplit(GUICtrlRead(GUICtrlRead($hProcesses)), "|", $STR_NOCOUNT)
					If Not $aTask[0] = 0 Then GUICtrlSetData($hTask, $aTask[0])
				EndIf
				GUICtrlSetState($hDToggle, $GUI_ENABLE)

			Case $hMsg = $hLoad
				If GUICtrlRead($hTask) = "" Then
					$sFile = "profile.ncc"
				Else
					$sFile = StringLower(GUICtrlRead($hTask)) & ".ncc"
				EndIf
				$hFile = FileOpenDialog("Load Saved Settings", @WorkingDir, "NotCPUCores Profile (*.ncc)", $FD_FILEMUSTEXIST, $sFile, $hGUI)
				GUICtrlSetData($hTask       , String(IniRead($hFile, "General"  , "Process" ,            "")))
				GUICtrlSetData($hCores      , String(IniRead($hFile, "General"  , "Threads" ,           "1")))
				;GUICtrlSetState($hChildren  , Number(IniRead($hFile, "General"  , "Children",$GUI_UNCHECKED)))
				GUICtrlSetData($hPPriority  , String(_IniRead($hFile, "General"  , "Priority", _GUICtrlComboBox_GetList($hPPriority)  , "High")))
				GUICtrlSetData($hSplitMode  , String(_IniRead($hFile, "Streaming", "SplitAs" , _GUICtrlComboBox_GetList($hSplitMode)  ,  "OFF")))
				GUICtrlSetData($hBroadcaster, String(_IniRead($hFile, "Streaming", "Software", _GUICtrlComboBox_GetList($hBroadcaster),  "OBS")))
				ContinueCase

			Case $hMsg = $hBroadcaster
				Switch GUICtrlRead($hBroadcaster)
					Case "OBS"
						ReDim $aProcesses[4]
						$aProcesses[0] = GUICtrlRead($hTask)
						$aProcesses[1] = "obs.exe"
						$aProcesses[2] = "obs32.exe"
						$aProcesses[3] = "obs64.exe"
					Case "XSplit"
						ReDim $aProcesses[5]
						$aProcesses[0] = GUICtrlRead($hTask)
						$aProcesses[1] = "XGS32.exe"
						$aProcesses[2] = "XGS64.exe"
						$aProcesses[3] = "XSplit.Core.exe"
						$aProcesses[4] = "XSplit.xbcbp.exe"
					Case Else
						ReDim $aProcesses[1]
						$aProcesses[0] = GUICtrlRead($hTask)
						_ConsoleWrite("!>Invalid Broadcaster Software!" & @CRLF, $hConsole)

				EndSwitch
				ContinueCase

			Case $hMsg = $hSplitMode
				$iBroadcasterCores = 0
				Switch GUICtrlRead($hSplitMode)

					Case "OFF"
						$iBroadcasterCores = 0
						GUICtrlSetState($hOAssign, $GUI_DISABLE)
						GUICtrlSetState($hBroadcaster, $GUI_DISABLE)
						ReDim $aProcesses[1]
						$aProcesses[0] = GUICtrlRead($hTask)

					Case "Last Core"
						$iBroadcasterCores = 2^($iThreads - 1)
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Last 2 Cores"
						For $iLoop = ($iThreads - 2) To $iThreads - 1
							$iBroadcasterCores += 2^($iLoop)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Last 4 Cores"
						For $iLoop = ($iThreads-4) To $iThreads - 1
							$iBroadcasterCores += 2^($iLoop)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Last Half"
						For $iLoop = Ceiling(($iThreads - ($iThreads/2))) To $iThreads - 1
							$iBroadcasterCores += 2^($iLoop)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Odd Cores", "Non-Physical Cores"
						For $iLoop = 1 To $iThreads - 1 Step 2
							$iBroadcasterCores += 2^($iLoop)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Even Cores", "Physical Cores"
						For $iLoop = 0 To $iThreads - 1 Step 2
							$iBroadcasterCores += 2^($iLoop)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Every Other Pair"
						For $iLoop = 0 To $iThreads - 1 Step 4
							$iBroadcasterCores += 2^($iLoop)
							$iBroadcasterCores += 2^($iLoop + 1)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case "Last AMD CCX"
						For $iLoop = ($iThreads - _CalculateCCX()) To $iThreads - 1 Step 2
							$iBroadcasterCores += 2^($iLoop)
						Next
						GUICtrlSetState($hOAssign, $GUI_ENABLE)
						GUICtrlSetState($hBroadcaster, $GUI_ENABLE)

					Case Else
						$iBroadcasterCores = 0
						GUICtrlSetState($hOAssign, $GUI_DISABLE)
						GUICtrlSetState($hBroadcaster, $GUI_DISABLE)
						ReDim $aProcesses[1]
						_ConsoleWrite("!>Invalid Broadcaster Mode!" & @CRLF, $hConsole)

				EndSwitch
				ContinueCase

			Case $hMsg = $hCores
				$iProcessCores = 0
				If Not StringRegExp(GUICtrlRead($hCores), "^(?:[1-9]\d*-?(?!\d+-)(?:[1-9]\d*)?(?!,$),?)+$") Then ;\A[0-9]+?(,[0-9]+)*\Z
					GUICtrlSetColor($hCores, 0xFF0000)
					GUICtrlSetState($hOptimize, $GUI_DISABLE)
				Else
					GUICtrlSetColor($hCores, 0x000000)
					GUICtrlSetState($hOptimize, $GUI_ENABLE)
					If StringInStr(GUICtrlRead($hCores), ",") Then ; Convert Multiple Cores if Declared to Magic Number
						$aCores = StringSplit(GUICtrlRead($hCores), ",", $STR_NOCOUNT)
						For $iLoop1 = 0 To UBound($aCores) - 1 Step 1
							If StringInStr($aCores[$iLoop1], "-") Then
								$aRange = StringSplit($aCores[$iLoop1], "-", $STR_NOCOUNT)
								If $aRange[0] < $aRange[1] Then
									For $iLoop2 = $aRange[0] To $aRange[1] Step 1
										$iProcessCores += 2^($iLoop2-1)
									Next
								Else
									For $iLoop2 = $aRange[1] To $aRange[0] Step 1
										$iProcessCores += 2^($iLoop2-1)
									Next
								EndIf
							Else
								$iProcessCores += 2^($aCores[$iLoop1]-1)
							EndIf
						Next
					Else
						$iProcessCores = 2^(GUICtrlRead($hCores)-1)
					EndIf
				EndIf
				ContinueCase

			Case $hMsg = $hOAssign
				$iOtherProcessCores = 0
				Switch GUICtrlRead($hOAssign)

					Case "Broadcaster Cores"
						$iOtherProcessCores = $iBroadcasterCores

					Case "Game Cores"
						$iOtherProcessCores = $iProcessCores

					Case "Remaining Cores"
						$iOtherProcessCores = $iAllCores - BitOR($iProcessCores, $iBroadcasterCores)

					Case Else
						$iOtherProcessCores = 1
						_ConsoleWrite("!>Invalid Process Assign Mode!" & @CRLF, $hConsole)

				EndSwitch

			Case $hMsg = $hReset
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_DISABLE)
				Next
				GUICtrlSetData($hReset, "Restoring PC...")
				_Restore($iThreads, $hConsole)
				GUICtrlSetData($hReset, "RESTORE TO DEFAULT")
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_ENABLE)
				Next

			Case $hMsg = $hOptimize
				For $Loop = $hTask to $hReset Step 1
					GUICtrlSetState($Loop, $GUI_DISABLE)
				Next
				GUICtrlSetData($hOptimize, "Running Optimizations..., Pause/Break to Stop")
				$aProcesses[0] = GUICtrlRead($hTask)
				$iProcesses = _Optimize($iProcesses,$aProcesses[0],$iProcessCores,$iSleep,GUICtrlRead($hPPriority),$hConsole)
				If _OptimizeOthers($aProcesses, $iOtherProcessCores, $iSleep, $hConsole) Then $iProcesses = 1
				If _OptimizeBroadcaster($aProcesses, $iBroadcasterCores, $iSleep, GUICtrlRead($hPPriority), $hConsole) Then $iProcesses = 1

			Case $hMsg = $hDefrag
				Run(@ComSpec & " /c " & 'defrag C: /V', "")

			Case $hMsg = $hCleanup
				Run(@ComSpec & " /c " & 'cleanmgr', "")

;			Case $hMsg = $HPETDisable
;				_ToggleHPET("TRUE", $hConsole)

;			Case $hMsg = $HPETDisable
;				_ToggleHPET("FALSE", $hConsole)

			Case Else
				Sleep(10)

		EndSelect
	WEnd
EndFunc

Func _CalculateCCX()

	If $iThreads > 16 Then ; Threadripper
		$iDivisor = 4
	Else
		$iDivisor = 2
	EndIf

	Return ($iThreads/$iDivisor)

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

Func _GetProcessList($hControl)

	_GUICtrlListView_DeleteAllItems($hControl)
	Local $aWindows = WinList()
	Do
		$iDelete = _ArraySearch($aWindows, "Default IME")
		_ArrayDelete($aWindows, $iDelete)
	Until _ArraySearch($aWindows, "Default IME") = -1
	Do
		$iDelete = _ArraySearch($aWindows, "")
		_ArrayDelete($aWindows, $iDelete)
	Until _ArraySearch($aWindows, "") = -1
	$aWindows[0][0] = UBound($aWindows)
	For $Loop = 1 To $aWindows[0][0] - 1
		$aWindows[$Loop][1] = _ProcessGetName(WinGetProcess($aWindows[$Loop][1]))
		GUICtrlCreateListViewItem($aWindows[$Loop][1] & "|" & $aWindows[$Loop][0], $hControl)
	Next
	_ArrayDelete($aWindows, 0)
	For $i = 0 To _GUICtrlListView_GetColumnCount($hControl) Step 1
		_GUICtrlListView_SetColumnWidth($hControl, $i, $LVSCW_AUTOSIZE_USEHEADER)
	Next
	_GUICtrlListView_SortItems($hControl, GUICtrlGetState($hControl))

EndFunc

Func _Interrupt()
	$bInterrupt = True
EndFunc

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _IniRead($hFile, $sSection, $sKey, $sValid, $sDefault)
	Local $sReturn = IniRead($hFile, $sSection, $sKey, $sDefault)
	Local $aValid = StringSplit($sValid, Opt("GUIDataSeparatorChar"), $STR_NOCOUNT)
	If _ArraySearch($aValid, $sReturn) = =1 Then
		ConsoleWrite("$sReturn Invalid, Defaulting to: " & $sDefault & @CRLF)
		Return $sDefault
	Else
		Return $sReturn
	EndIf
EndFunc

Func _LoadLanguage($iLanguage = @OSLang)
	$sPath = ".\Lang\" & $iLanguage & ".ini"
	If FileExists($sPath) Then

		#Region ; File Info
;		$_sLang_Version     = IniRead($sPath, "File", "Version" , $sVersion)
		$_sLang_Language    = IniRead($sPath, "File", "Name"    , "Default")
		#EndRegion

		#Region ; Global Word Usage
		$_sLang_Example     = IniRead($sPath, "Global", "Example", "Example")
		$_sLang_Usage       = IniRead($sPath, "Global", "Usage"  , "Usage"  )
		$_sLang_Done        = IniRead($sPath, "Global", "Done"   , "Done"   )
		#EndRegion

		#Region ; Main GUI
		$_sLang_DebugTip        = IniRead($sPath, "GUI", "DebugTip"     , "Toggle Debug Mode"           )
		$_sLang_ProcessList     = IniRead($sPath, "GUI", "ProcessList"  , "Window Process"              )
		$_sLang_ProcessTitle    = IniRead($sPath, "GUI", "ProcessTitle" , "Window Title"                )
		$_sLang_FileMenu        = IniRead($sPath, "GUI", "FileMenu"     , "File"                        )
		$_sLang_OptionsMenu     = IniRead($sPath, "GUI", "OptionsMenu"  , "Options"                     )
		#EndRegion

		#Region ; Console Output
		$_sLang_DebugStart       = IniRead($sPath, "Console", "DebugStart"      , "Debug Console Initialized"                                )
		$_sLang_Optimizing1      = IniRead($sPath, "Console", "Optimizing1"     , "Optimizing "                                              )
		$_sLang_Optimizing2      = IniRead($sPath, "Console", "Optimizing2"     , " in the background until it closes..."                    )
		$_sLang_RestoringState   = IniRead($sPath, "Console", "RestoringState"  , "Restoring Previous State..."                              )
		$_sLang_RestoringProcess = IniRead($sPath, "Console", "RestoringProcess", "Restoring Priority and Affinity of all Other Processes...")
		$_sLang_ProcessChange    = IniRead($sPath, "Console", "ProcessChange"   , "Process Count Changed, Rerunning Optimization..."         )
		$_sLang_StoppingServices = IniRead($sPath, "Console", "StoppingServices", "Temporarily Pausing Game Impacting Services..."           )
		$_sLang_StartingServices = IniRead($sPath, "Console", "StartingServices", "Restarting Any Stopped Services..."                       )
		$_sLang_HPETChange       = IniRead($sPath, "Console", "HPETChange"      , "HPET State Changed, Please Reboot to Apply Changes"       )
		#EndRegion

		#Region ; Errors
		$_sLang_NotRunning   = IniRead($sPath, "Errors", "NotRunning"  , " is not currently running. Please run the program first"  )
		$_sLang_CoreError    = IniRead($sPath, "Errors", "CoreError"   , " is not a proper declaration of what cores to run on"     )
		$_sLang_TooManyCores = IniRead($sPath, "Errors", "TooManyCores", "You've specified more cores than available on your system")
		#EndRegion

	EndIf
EndFunc