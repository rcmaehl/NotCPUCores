Main()

Func Main()

	Local $sStatus

	While True

		$sStatus = ConsoleRead()
		If @extended = 0 Then ContinueLoop

		Switch $sStatus

			Case "True"
				;;;

			Case Else
				ConsoleWrite("Plugin Caught unhandled parameter: " & $sStatus)

		EndSwitch

	WEnd
EndFunc