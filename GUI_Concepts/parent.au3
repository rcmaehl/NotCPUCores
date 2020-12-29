#include <Array.au3>
#include <AutoItConstants.au3>

Local $aPlugins[1] = ["child.exe"]

_LoadPlugins($aPlugins)

Func _LoadPlugins($aPlugins)
	Local $aChildren[0]
	_ArrayDisplay($aPlugins)
	MsgBox(0, "Array Size", UBound($aChildren))
	For $i = 0 To UBound($aPlugins) - 1 Step 1
		ReDim $aChildren[UBound($aChildren) + 1]
		MsgBox(0, "Array Size", UBound($aChildren))
		MsgBox(0, "WorkingDir", @WorkingDir)
		$aChildren[$i] = Run(".\Plugins\" & $aPlugins[$i], @WorkingDir, "", $STDIN_CHILD+$STDOUT_CHILD)
		MsgBox(0, "Element " & $i, $aChildren[$i])
	Next
	StdinWrite($aChildren[0], InputBox("StdinWrite", "Input", "test"))
	Exit
EndFunc