#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <GuiSlider.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=form2.kxf
$Concept1 = GUICreate("NotCPUCores - GUI Redesign Concept 1", 525, 423, 200, 135)
$MenuItem1 = GUICtrlCreateMenu("&File")
$MenuItem2 = GUICtrlCreateMenu("&Options")
$MenuItem3 = GUICtrlCreateMenu("&Help")
$ListBox1 = GUICtrlCreateList("", 10, 30, 135, 201, BitOR($LBS_NOTIFY,$WS_VSCROLL,$WS_BORDER))
GUICtrlSetData(-1, "--------------|GOG Game 1|Process 1|Process 2|Process 3|Process 4|Steam Game 2|Steam Game 3|Steam Game 4")
$Button3 = GUICtrlCreateButton("Load", 455, 205, 60, 25)
$Button4 = GUICtrlCreateButton("Prioritize", 455, 30, 60, 25)
$ListBox2 = GUICtrlCreateList("", 160, 30, 135, 201)
GUICtrlSetData(-1, "Steam Game 1")
$Button1 = GUICtrlCreateButton("Exclude", 455, 90, 60, 25)
$Button2 = GUICtrlCreateButton("Remove", 455, 60, 60, 25)
$List1 = GUICtrlCreateList("", 310, 30, 135, 201)
GUICtrlSetData(-1, "Process 5|Process 6")
$Button6 = GUICtrlCreateButton("Save", 455, 175, 60, 25)
$Label1 = GUICtrlCreateLabel("All Processes", 10, 10, 67, 17)
$Label2 = GUICtrlCreateLabel("Processes to Prioritize", 160, 10, 107, 17)
$Label3 = GUICtrlCreateLabel("Optimization Exclusions", 310, 10, 114, 17)
$Group1 = GUICtrlCreateGroup("Options", 10, 240, 505, 155)
$Group2 = GUICtrlCreateGroup("Prioritization", 20, 255, 130, 130)
$Label4 = GUICtrlCreateLabel("Resource Assignment", 30, 275, 110, 20, $SS_CENTER)
$Slider1 = GUICtrlCreateSlider(30, 295, 110, 25)
_GUICtrlSlider_SetTicFreq(-1,1)
GUICtrlSetLimit(-1, 16, 1)
GUICtrlSetData(-1, 16)
$Label5 = GUICtrlCreateLabel("Process Priority", 30, 330, 110, 17, $SS_CENTER)
$Slider2 = GUICtrlCreateSlider(30, 345, 110, 25)
_GUICtrlSlider_SetTicFreq(-1,1)
GUICtrlSetLimit(-1, 4, 1)
GUICtrlSetData(-1, 4)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Checkbox6 = GUICtrlCreateCheckbox("Optimize Child Processes", 310, 260, 190, 20)
$Checkbox1 = GUICtrlCreateCheckbox("Disable Unneeded Services", 310, 280, 190, 20)
$Checkbox3 = GUICtrlCreateCheckbox("Set Power Plan to Max Performance", 310, 300, 190, 20)
$Checkbox4 = GUICtrlCreateCheckbox("Enable Debug Log", 310, 340, 190, 20)
$Checkbox5 = GUICtrlCreateCheckbox("Automatically Check for Updates", 310, 360, 190, 20)
$Group3 = GUICtrlCreateGroup("Streaming", 160, 255, 140, 130)
$Checkbox2 = GUICtrlCreateCheckbox("Enabled", 170, 275, 120, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$Combo2 = GUICtrlCreateCombo("OBS", 170, 295, 120, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetCursor (-1, 2)
$Label6 = GUICtrlCreateLabel("Resource Assignment", 170, 330, 107, 17, $SS_CENTER)
$Slider3 = GUICtrlCreateSlider(170, 345, 120, 25)
_GUICtrlSlider_SetTicFreq(-1,1)
GUICtrlSetLimit(-1, 16, 1)
GUICtrlSetData(-1, 16)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
