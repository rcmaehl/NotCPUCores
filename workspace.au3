Func _Number_Of_Processors()
    Local $z_Text = ''
    Dim $Obj_WMIService = ObjGet('winmgmts:{impersonationLevel=impersonate}!\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Dim $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_ComputerSystem')

        Local $Obj_Items
        For $Obj_Items In $Col_Items
            Local $z_Text = 'Found: ' & $Obj_Items.NumberOfProcessors & ' processor(s)'
        Next

        Return String($z_Text)
    Else
        Return 0
    EndIf
EndFunc

MsgBox(0, "", _Number_Of_Processors())