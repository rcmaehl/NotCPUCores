Func _GetCPUInfo($iFlag = 0)
    Local $sThreads = ''
	Local $sName = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_Processor')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            Local $sThreads = $Obj_Item.numberOfLogicalProcessors
			Local $sName = $obj_Item.Name
        Next

		If $iFlag = 0 Then
			Return String($sThreads)
		ElseIf $iFlag = 1 Then
			Return String($sName)
		EndIf
    Else
        Return 0
    EndIf
EndFunc

Func _GetOSInfo($iFlag = 0)
    Local $sName = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_OperatingSystem')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            Local $sName = $Obj_Item.Name
        Next

		If $iFlag = 0 Then
			Return String($sName)
		EndIf
    Else
        Return 0
    EndIf
EndFunc

Func _GetRAMInfo($iFlag = 0)
    Local $sSpeed = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_PhysicalMemory')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            Local $sSpeed = $Obj_Item.Speed
        Next

		If $iFlag = 0 Then
			Return String($sSpeed)
		EndIf
    Else
        Return 0
    EndIf
EndFunc