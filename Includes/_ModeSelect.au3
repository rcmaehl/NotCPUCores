Func ModeSelect($CmdLine)
	Switch $CmdLine[0]
		Case 0
			ConsoleWrite("Backend Console (Read-Only Mode)" & @CRLF & "Feel free to minimize, but closing will close the UI as well" & @CRLF & @CRLF)
			Main()
		Case 1
			Switch $CmdLine[1]
				Case "/?"
					ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
				Case "Help"
					ConsoleWrite("Available Commands: OptimizeAll Optimize ToggleHPET StopServices SetPowerPlan Restore" & @CRLF)
				Case "OptimizeAll"
					ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
				Case "Optimize"
					ConsoleWrite("Optimize Requires ProcessName.exe CoreToRunOn" & @CRLF)
					Sleep(5000)
				Case "ToggleHPET"
					ConsoleWrite("ToggleHPET Requires True/False" & @CRLF)
				Case "StopServices"
					ConsoleWrite("StopServices Requires True/False" & @CRLF)
				Case "SetPowerPlan"
					ConsoleWrite("SetPowerPlan Requires True/False" & @CRLF)
				Case "Restore"
					_Restore()
				Case Else
					ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
			EndSwitch
			Sleep(5000)
			Exit 0
		Case Else
			Switch $CmdLine[1]
				Case "OptimizeAll"
					If $CmdLine[0] < 3 Then
						ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 4 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						Exit _OptimizeAll($CmdLine[2],Number($CmdLine[3]))
					EndIf
				Case "Optimize"
					If $CmdLine[0] < 3 Then
						ConsoleWrite("OptimizeAll Requires ProcessName.exe CoreToRunOn" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 3 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						Exit _Optimize($CmdLine[2],$CmdLine[3])
					EndIf
				Case "ToggleHPET"
					If $CmdLine[0] < 2 Then
						ConsoleWrite("ToggleHPET Requires True/False" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 2 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						_ToggleHPET($CmdLine[2])
					EndIf
				Case "StopServices"
					If $CmdLine[0] < 2 Then
						ConsoleWrite("StopServices Requires True/False" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 2 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						_StopServices($CmdLine[2])
					EndIf
				Case "SetPowerPlan"
					If $CmdLine[0] < 2 Then
						ConsoleWrite("SetPowerPlan Requires True/False" & @CRLF)
						Sleep(1000)
						Exit 1
					ElseIf $CmdLine[0] > 2 Then
						ConsoleWrite("Too Many Parameters Passed" & @CRLF)
					Else
						_SetPowerPlan($CmdLine[2])
					EndIf
				Case Else
					ConsoleWrite($CmdLine[1] & " is not a valid command." & @CRLF)
					Sleep(1000)
					Exit 1
			EndSwitch
	EndSwitch
EndFunc