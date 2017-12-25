#include <StringConstants.au3>

Func _GetCPUInfo($iFlag = 0)
    Local $sThreads = ''
	Local $sName = ''
    Local $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Local $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_Processor')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
			$sThreads = $Obj_Item.numberOfLogicalProcessors
			$sName = $obj_Item.Name
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

Func _GetGPUInfo($iFlag = 0)
    Local $sName = ''
	Local $sMemory = ''
    Local $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Local $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_VideoController')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            $sName = $Obj_Item.Name
			$sMemory = $obj_Item.AdapterRAM
        Next

		Switch $iFlag
			Case 0
				Return String($sName)
			Case 1
				Return String($sMemory)
		EndSwitch
    Else
        Return 0
    EndIf
EndFunc

Func _GetMotherboardInfo($iFlag = 0)
    Local $sProduct = ''
    Local $sManufacturer = ''
	Local $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Local $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_BaseBoard')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            $sProduct = $Obj_Item.Product
			$sManufacturer = $Obj_Item.Manufacturer
        Next

		Switch $iFlag
			Case 0
				Return String($sManufacturer)
			Case 1
				Return String($sProduct)
		EndSwitch
    Else
        Return 0
    EndIf
EndFunc

Func _GetOSInfo($iFlag = 0)
	Local $sArch = ''
    Local $sName = ''
	Local $sLocale = ''
    Local $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Local $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_OperatingSystem')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
			$sArch = $Obj_Item.OSArchitecture
            $sName = $Obj_Item.Name
			$sLocale = $Obj_Item.Locale
        Next

		Switch $iFlag
			Case 0
				Return String(StringSplit($sName, "|", $STR_NOCOUNT)[0])
			Case 1
				Return String($sArch)
			Case 2
				Return String($sLocale)
		EndSwitch
    Else
        Return 0
    EndIf
EndFunc

Func _GetRAMInfo($iFlag = 0)
    Local $sSpeed = ''
    Local $Obj_WMIService = ObjGet('winmgmts:\\' & @ComputerName & '\root\cimv2');
    If (IsObj($Obj_WMIService)) And (Not @error) Then
        Local $Col_Items = $Obj_WMIService.ExecQuery('Select * from Win32_PhysicalMemory')

        Local $Obj_Item
        For $Obj_Item In $Col_Items
            $sSpeed = $Obj_Item.Speed
        Next

		If $iFlag = 0 Then
			Return String($sSpeed)
		EndIf
    Else
        Return 0
    EndIf
EndFunc