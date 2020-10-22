#include-once

#include "APISysConstants.au3"
#include "WinAPIConv.au3"
#include "WinAPIError.au3"
#include "WinAPIGdiInternals.au3"
#include "WinAPIHObj.au3"
#include "WinAPIIcons.au3"
#include "WinAPIMem.au3"
#include "WinAPISysWin.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPISys.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #CONSTANTS# ===================================================================================================================
Global Const $tagOSVERSIONINFOEX = $tagOSVERSIONINFO & ';ushort ServicePackMajor;ushort ServicePackMinor;ushort SuiteMask;byte ProductType;byte Reserved'
Global Const $tagRAWINPUTDEVICE = 'struct;ushort UsagePage;ushort Usage;dword Flags;hwnd hTarget;endstruct'
Global Const $tagRAWINPUTHEADER = 'struct;dword Type;dword Size;handle hDevice;wparam wParam;endstruct'
Global Const $tagRAWMOUSE = 'ushort Flags;ushort Alignment;ushort ButtonFlags;ushort ButtonData;ulong RawButtons;long LastX;long LastY;ulong ExtraInformation;'
Global Const $tagRAWKEYBOARD = 'ushort MakeCode;ushort Flags;ushort Reserved;ushort VKey;uint Message;ulong ExtraInformation;'
Global Const $tagRAWHID = 'dword SizeHid;dword Count;' ; & 'byte RawData[n];'
Global Const $tagRAWINPUTMOUSE = $tagRAWINPUTHEADER & ';' & $tagRAWMOUSE
Global Const $tagRAWINPUTKEYBOARD = $tagRAWINPUTHEADER & ';' & $tagRAWKEYBOARD
Global Const $tagRAWINPUTHID = $tagRAWINPUTHEADER & ';' & $tagRAWHID
Global Const $tagRID_DEVICE_INFO_MOUSE = 'struct;dword Id;dword NumberOfButtons;dword SampleRate;int HasHorizontalWheel;endstruc'
Global Const $tagRID_DEVICE_INFO_KEYBOARD = 'struct;dword KbType;dword KbSubType;dword KeyboardMode;dword NumberOfFunctionKeys;dword NumberOfIndicators;dword NumberOfKeysTotal;endstruc'
Global Const $tagRID_DEVICE_INFO_HID = 'struct;dword VendorId;dword ProductId;dword VersionNumber;ushort UsagePage;ushort Usage;endstruc'
Global Const $tagRID_INFO_MOUSE = 'dword Size;dword Type;' & $tagRID_DEVICE_INFO_MOUSE & ';dword Unused[2];'
Global Const $tagRID_INFO_KEYBOARD = 'dword Size;dword Type;' & $tagRID_DEVICE_INFO_KEYBOARD
Global Const $tagRID_INFO_HID = 'dword Size;dword Type;' & $tagRID_DEVICE_INFO_HID & ';dword Unused[2]'
; ??? Global Const $tagSHELLHOOKINFO = 'hwnd hWnd;' & $tagRECT
Global Const $tagUSEROBJECTFLAGS = 'int Inherit;int Reserved;dword Flags'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_ActivateKeyboardLayout
; _WinAPI_AddClipboardFormatListener
; _WinAPI_CallNextHookEx
; _WinAPI_CloseDesktop
; _WinAPI_CloseWindowStation
; _WinAPI_CompressBuffer
; _WinAPI_ComputeCrc32
; _WinAPI_CreateDesktop
; _WinAPI_CreateWindowStation
; _WinAPI_DecompressBuffer
; _WinAPI_DefRawInputProc
; _WinAPI_EnumDesktops
; _WinAPI_EnumDesktopWindows
; _WinAPI_EnumPageFiles
; _WinAPI_EnumRawInputDevices
; _WinAPI_EnumWindowStations
; _WinAPI_ExpandEnvironmentStrings
; _WinAPI_GetActiveWindow
; _WinAPI_GetAsyncKeyState
; _WinAPI_GetClipboardSequenceNumber
; _WinAPI_GetCurrentHwProfile
; _WinAPI_GetDefaultPrinter
; _WinAPI_GetDllDirectory
; _WinAPI_GetEffectiveClientRect
; _WinAPI_GetHandleInformation
; _WinAPI_GetIdleTime
; _WinAPI_GetKeyboardLayout
; _WinAPI_GetKeyboardLayoutList
; _WinAPI_GetKeyboardState
; _WinAPI_GetKeyboardType
; _WinAPI_GetKeyNameText
; _WinAPI_GetKeyState
; _WinAPI_GetModuleHandleEx
; _WinAPI_GetMUILanguage
; _WinAPI_GetPerformanceInfo
; _WinAPI_GetPhysicallyInstalledSystemMemory
; _WinAPI_GetProcAddress
; _WinAPI_GetProcessShutdownParameters
; _WinAPI_GetProcessWindowStation
; _WinAPI_GetPwrCapabilities
; _WinAPI_GetRawInputBuffer
; _WinAPI_GetRawInputBufferLength
; _WinAPI_GetRawInputData
; _WinAPI_GetRawInputDeviceInfo
; _WinAPI_GetRegisteredRawInputDevices
; _WinAPI_GetStartupInfo
; _WinAPI_GetSystemDEPPolicy
; _WinAPI_GetSystemInfo
; _WinAPI_GetSystemPowerStatus
; _WinAPI_GetSystemTimes
; _WinAPI_GetSystemWow64Directory
; _WinAPI_GetTickCount
; _WinAPI_GetTickCount64
; _WinAPI_GetUserObjectInformation
; _WinAPI_GetVersion
; _WinAPI_GetVersionEx
; _WinAPI_GetWorkArea
; _WinAPI_InitMUILanguage
; _WinAPI_IsLoadKBLayout
; _WinAPI_IsProcessorFeaturePresent
; _WinAPI_IsWindowEnabled
; _WinAPI_Keybd_Event
; _WinAPI_LoadKeyboardLayout
; _WinAPI_LockWorkStation
; _WinAPI_MapVirtualKey
; _WinAPI_Mouse_Event
; _WinAPI_OpenDesktop
; _WinAPI_OpenInputDesktop
; _WinAPI_OpenWindowStation
; _WinAPI_QueryPerformanceCounter
; _WinAPI_QueryPerformanceFrequency
; _WinAPI_RegisterHotKey
; _WinAPI_RegisterPowerSettingNotification
; _WinAPI_RegisterRawInputDevices
; _WinAPI_ReleaseCapture
; _WinAPI_RemoveClipboardFormatListener
; _WinAPI_SetActiveWindow
; _WinAPI_SetCapture
; _WinAPI_SetDefaultPrinter
; _WinAPI_SetDllDirectory
; _WinAPI_SetKeyboardLayout
; _WinAPI_SetKeyboardState
; _WinAPI_SetProcessWindowStation
; _WinAPI_SetProcessShutdownParameters
; _WinAPI_SetUserObjectInformation
; _WinAPI_SetWindowsHookEx
; _WinAPI_SetWinEventHook
; _WinAPI_ShutdownBlockReasonCreate
; _WinAPI_ShutdownBlockReasonDestroy
; _WinAPI_ShutdownBlockReasonQuery
; _WinAPI_SwitchDesktop
; _WinAPI_SystemParametersInfo
; _WinAPI_TrackMouseEvent
; _WinAPI_UnhookWindowsHookEx
; _WinAPI_UnhookWinEvent
; _WinAPI_UnloadKeyboardLayout
; _WinAPI_UnregisterHotKey
; _WinAPI_UnregisterPowerSettingNotification
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ActivateKeyboardLayout($hLocale, $iFlag = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'ActivateKeyboardLayout', 'handle', $hLocale, 'uint', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ActivateKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AddClipboardFormatListener($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'AddClipboardFormatListener', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AddClipboardFormatListener

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CallNextHookEx($hHook, $iCode, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "CallNextHookEx", "handle", $hHook, "int", $iCode, "wparam", $wParam, "lparam", $lParam)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CallNextHookEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseDesktop($hDesktop)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseDesktop', 'handle', $hDesktop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseWindowStation($hStation)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseWindowStation', 'handle', $hStation)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CompressBuffer($pUncompressedBuffer, $iUncompressedSize, $pCompressedBuffer, $iCompressedSize, $iFormatAndEngine = 0x0002)
	Local $aRet, $pWorkSpace = 0, $iError = 0
	Do
		$aRet = DllCall('ntdll.dll', 'uint', 'RtlGetCompressionWorkSpaceSize', 'ushort', $iFormatAndEngine, 'ulong*', 0, 'ulong*', 0)
		If @error Or $aRet[0] Then
			$iError = @error + 20
			ExitLoop
		EndIf
		$pWorkSpace = __HeapAlloc($aRet[2])
		If @error Then
			$iError = @error + 100
			ExitLoop
		EndIf
		$aRet = DllCall('ntdll.dll', 'uint', 'RtlCompressBuffer', 'ushort', $iFormatAndEngine, 'struct*', $pUncompressedBuffer, _
				'ulong', $iUncompressedSize, 'struct*', $pCompressedBuffer, 'ulong', $iCompressedSize, 'ulong', 4096, _
				'ulong*', 0, 'ptr', $pWorkSpace)
		If @error Or $aRet[0] Or Not $aRet[7] Then
			$iError = @error + 30
			ExitLoop
		EndIf
	Until 1
	__HeapFree($pWorkSpace)
	If $iError Then
		If IsArray($aRet) Then
			Return SetError(10, $aRet[0], 0)
		Else
			Return SetError($iError, 0, 0)
		EndIf
	EndIf

	Return $aRet[7]
EndFunc   ;==>_WinAPI_CompressBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ComputeCrc32($pMemory, $iLength)
	If _WinAPI_IsBadReadPtr($pMemory, $iLength) Then Return SetError(1, @extended, 0)

	Local $aRet = DllCall('ntdll.dll', 'dword', 'RtlComputeCrc32', 'dword', 0, 'struct*', $pMemory, 'int', $iLength)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ComputeCrc32

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateDesktop($sName, $iAccess = 0x0002, $iFlags = 0, $iHeap = 0, $tSecurity = 0)
	Local $aRet
	If $iHeap Then
		$aRet = DllCall('user32.dll', 'handle', 'CreateDesktopExW', 'wstr', $sName, 'ptr', 0, 'ptr', 0, 'dword', $iFlags, _
				'dword', $iAccess, 'struct*', $tSecurity, 'ulong', $iHeap, 'ptr', 0)
	Else
		$aRet = DllCall('user32.dll', 'handle', 'CreateDesktopW', 'wstr', $sName, 'ptr', 0, 'ptr', 0, 'dword', $iFlags, _
				'dword', $iAccess, 'struct*', $tSecurity)
	EndIf
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateWindowStation($sName = '', $iAccess = 0, $iFlags = 0, $tSecurity = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'CreateWindowStationW', 'wstr', $sName, 'dword', $iFlags, 'dword', $iAccess, _
			'struct*', $tSecurity)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DecompressBuffer($pUncompressedBuffer, $iUncompressedSize, $pCompressedBuffer, $iCompressedSize, $iFormat = 0x0002)
	Local $aRet = DllCall('ntdll.dll', 'long', 'RtlDecompressBuffer', 'ushort', $iFormat, 'struct*', $pUncompressedBuffer, _
			'ulong', $iUncompressedSize, 'struct*', $pCompressedBuffer, 'ulong', $iCompressedSize, 'ulong*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_DecompressBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DefRawInputProc($paRawInput, $iInput)
	Local $aRet = DllCall('user32.dll', 'lresult', 'DefRawInputProc', 'ptr', $paRawInput, 'int', $iInput, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DefRawInputProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDesktops($hStation)
	If StringCompare(_WinAPI_GetUserObjectInformation($hStation, 3), 'WindowStation') Then Return SetError(1, 0, 0)

	Local $hEnumProc = DllCallbackRegister('__EnumDefaultProc', 'bool', 'ptr;lparam')

	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumDesktopsW', 'handle', $hStation, 'ptr', DllCallbackGetPtr($hEnumProc), _
			'lparam', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumDesktops

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDesktopWindows($hDesktop, $bVisible = True)
	If StringCompare(_WinAPI_GetUserObjectInformation($hDesktop, 3), 'Desktop') Then Return SetError(1, 0, 0)

	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'bool', 'hwnd;lparam')

	Dim $__g_vEnum[101][2] = [[0]]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumDesktopWindows', 'handle', $hDesktop, 'ptr', DllCallbackGetPtr($hEnumProc), _
			'lparam', $bVisible)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumDesktopWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumPageFiles()
	Local $aInfo = _WinAPI_GetSystemInfo()

	Local $hEnumProc = DllCallbackRegister('__EnumPageFilesProc', 'bool', 'lparam;ptr;ptr')

	Dim $__g_vEnum[101][4] = [[0]]
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumPageFilesW', 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $aInfo[1])
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumPageFiles

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumRawInputDevices()
	Local Const $tagRAWINPUTDEVICELIST = 'struct;handle hDevice;dword Type;endstruct'
	Local $tRIDL, $iLength = DllStructGetSize(DllStructCreate($tagRAWINPUTDEVICELIST))

	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputDeviceList', 'ptr', 0, 'uint*', 0, 'uint', $iLength)
	If @error Then Return SetError(@error + 10, @extended, 0)
	If ($aRet[0] = 4294967295) Or (Not $aRet[2]) Then Return SetError(10, -1, 0)

	Local $tData = DllStructCreate('byte[' & ($aRet[2] * $iLength) & ']')
	Local $pData = DllStructGetPtr($tData)
	If @error Then Return SetError(@error + 20, 0, 0)

	$aRet = DllCall('user32.dll', 'uint', 'GetRawInputDeviceList', 'ptr', $pData, 'uint*', $aRet[2], 'uint', $iLength)
	If ($aRet[0] = 4294967295) Or (Not $aRet[0]) Then Return SetError(1, -1, 0)

	Local $aResult[$aRet[2] + 1][2] = [[$aRet[2]]]
	For $i = 1 To $aRet[2]
		$tRIDL = DllStructCreate('ptr;dword', $pData + $iLength * ($i - 1))
		For $j = 0 To 1
			$aResult[$i][$j] = DllStructGetData($tRIDL, $j + 1)
		Next
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_EnumRawInputDevices

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumWindowStations()
	Local $hEnumProc = DllCallbackRegister('__EnumDefaultProc', 'bool', 'ptr;lparam')

	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumWindowStationsW', 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumWindowStations

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ExpandEnvironmentStrings($sString)
	Local $aResult = DllCall("kernel32.dll", "dword", "ExpandEnvironmentStringsW", "wstr", $sString, "wstr", "", "dword", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	Return $aResult[2]
EndFunc   ;==>_WinAPI_ExpandEnvironmentStrings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetActiveWindow()
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetActiveWindow')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetActiveWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetAsyncKeyState($iKey)
	Local $aResult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", $iKey)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetAsyncKeyState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetClipboardSequenceNumber()
	Local $aRet = DllCall('user32.dll', 'dword', 'GetClipboardSequenceNumber')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetClipboardSequenceNumber

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentHwProfile()
	Local $tagHW_PROFILE_INFO = 'dword DockInfo;wchar szHwProfileGuid[39];wchar szHwProfileName[80]'
	Local $tHWPI = DllStructCreate($tagHW_PROFILE_INFO)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'GetCurrentHwProfileW', 'struct*', $tHWPI)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = DllStructGetData($tHWPI, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetCurrentHwProfile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDefaultPrinter()
	Local $aRet = DllCall('winspool.drv', 'bool', 'GetDefaultPrinterW', 'wstr', '', 'dword*', 2048)
	If @error Then Return SetError(@error, @extended, '')
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetDefaultPrinter

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDllDirectory()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetDllDirectoryW', 'dword', 4096, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetDllDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetEffectiveClientRect($hWnd, $aCtrl, $iStart = 0, $iEnd = -1)
	If Not IsArray($aCtrl) Then
		Local $iCtrl = $aCtrl
		Dim $aCtrl[1] = [$iCtrl]
		$iStart = 0
		$iEnd = 0
	EndIf
	If __CheckErrorArrayBounds($aCtrl, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $iCount = $iEnd - $iStart + 1
	Local $tCtrl = DllStructCreate('uint64[' & ($iCount + 2) & ']')
	$iCount = 2
	For $i = $iStart To $iEnd
		If IsHWnd($aCtrl[$i]) Then
			$aCtrl[$i] = _WinAPI_GetDlgCtrlID($aCtrl[$i])
		EndIf
		DllStructSetData($tCtrl, 1, _WinAPI_MakeQWord(1, $aCtrl[$i]), $iCount)
		$iCount += 1
	Next
	Local $tRECT = DllStructCreate($tagRECT)
	DllCall('comctl32.dll', 'none', 'GetEffectiveClientRect', 'hwnd', $hWnd, 'struct*', $tRECT, 'struct*', $tCtrl)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetEffectiveClientRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetHandleInformation($hObject)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetHandleInformation', 'handle', $hObject, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetHandleInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetIdleTime()
	Local $tLASTINPUTINFO = DllStructCreate('uint;dword')
	DllStructSetData($tLASTINPUTINFO, 1, DllStructGetSize($tLASTINPUTINFO))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetLastInputInfo', 'struct*', $tLASTINPUTINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return _WinAPI_GetTickCount() - DllStructGetData($tLASTINPUTINFO, 2)
EndFunc   ;==>_WinAPI_GetIdleTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardLayout($hWnd)
	Local $aRet = DllCall('user32.dll', 'dword', 'GetWindowThreadProcessId', 'hwnd', $hWnd, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	$aRet = DllCall('user32.dll', 'handle', 'GetKeyboardLayout', 'dword', $aRet[0])
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardLayoutList()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetKeyboardLayoutList', 'int', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	Local $tData = DllStructCreate('handle[' & $aRet[0] & ']')
	$aRet = DllCall('user32.dll', 'uint', 'GetKeyboardLayoutList', 'int', $aRet[0], 'struct*', $tData)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aList[$aRet[0] + 1] = [$aRet[0]]
	For $i = 1 To $aList[0]
		$aList[$i] = DllStructGetData($tData, 1, $i)
	Next
	Return $aList
EndFunc   ;==>_WinAPI_GetKeyboardLayoutList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardState()
	Local $tData = DllStructCreate('byte[256]')
	Local $aRet = DllCall('user32.dll', 'bool', 'GetKeyboardState', 'struct*', $tData)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tData
EndFunc   ;==>_WinAPI_GetKeyboardState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardType($iType)
	Local $aRet = DllCall('user32.dll', 'int', 'GetKeyboardType', 'int', $iType)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetKeyboardType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyNameText($lParam)
	Local $aRet = DllCall('user32.dll', 'int', 'GetKeyNameTextW', 'long', $lParam, 'wstr', '', 'int', 128)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetKeyNameText

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetKeyState($vKey)
	Local $aRet = DllCall('user32.dll', 'short', 'GetKeyState', 'int', $vKey)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetKeyState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetModuleHandleEx($sModule, $iFlags = 0)
	Local $sTypeOfModule = 'ptr'
	If IsString($sModule) Then
		If StringStripWS($sModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$sTypeOfModule = 'wstr'
		Else
			$sModule = 0
		EndIf
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetModuleHandleExW', 'dword', $iFlags, $sTypeOfModule, $sModule, 'ptr*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetModuleHandleEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetMUILanguage()
	Local $aRet = DllCall('comctl32.dll', 'word', 'GetMUILanguage')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetMUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPerformanceInfo()
	Local $tPI = DllStructCreate('dword;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;dword;dword;dword')
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'GetPerformanceInfo', 'struct*', $tPI, 'dword', DllStructGetSize($tPI))
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[13]
	For $i = 0 To 12
		$aResult[$i] = DllStructGetData($tPI, $i + 2)
	Next
	For $i = 0 To 8
		$aResult[$i] *= $aResult[9]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetPerformanceInfo

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetProcAddress($hModule, $vName)
	Local $sType = "str"
	If IsNumber($vName) Then $sType = "word" ; if ordinal value passed
	Local $aResult = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", $hModule, $sType, $vName)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetProcAddress

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPhysicallyInstalledSystemMemory()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetPhysicallyInstalledSystemMemory', 'uint64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetPhysicallyInstalledSystemMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessShutdownParameters()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessShutdownParameters', 'dword*', 0, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return SetExtended(Number(Not $aRet[2]), $aRet[1])
EndFunc   ;==>_WinAPI_GetProcessShutdownParameters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessWindowStation()
	Local $aRet = DllCall('user32.dll', 'handle', 'GetProcessWindowStation')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetProcessWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPwrCapabilities()
	If Not __DLL('powrprof.dll') Then Return SetError(103, 0, 0)

	Local $tSPC = DllStructCreate('byte[18];byte[3];byte;byte[8];byte[2];ulong[6];ulong[5]')
	Local $aRet = DllCall('powrprof.dll', 'boolean', 'GetPwrCapabilities', 'struct*', $tSPC)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[25]
	For $i = 0 To 17
		$aResult[$i] = DllStructGetData($tSPC, 1, $i + 1)
	Next
	$aResult[18] = DllStructGetData($tSPC, 3)
	For $i = 19 To 20
		$aResult[$i] = DllStructGetData($tSPC, 5, $i - 18)
	Next
	For $i = 21 To 24
		$aResult[$i] = DllStructGetData($tSPC, 7, $i - 20)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetPwrCapabilities

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputBuffer($pBuffer, $iLength)
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputBuffer', 'struct*', $pBuffer, 'uint*', $iLength, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If ($aRet[0] = 4294967295) Or (Not $aRet[1]) Then Return SetError(10, -1, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetRawInputBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputBufferLength()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputBuffer', 'ptr', 0, 'uint*', 0, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return $aRet[2] * 8
EndFunc   ;==>_WinAPI_GetRawInputBufferLength

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputData($hRawInput, $pBuffer, $iLength, $iFlag)
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputData', 'handle', $hRawInput, 'uint', $iFlag, 'struct*', $pBuffer, _
			'uint*', $iLength, 'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return ($aRet[3] ? $aRet[0] : $aRet[4])
EndFunc   ;==>_WinAPI_GetRawInputData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputDeviceInfo($hDevice, $pBuffer, $iLength, $iFlag)
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputDeviceInfoW', 'handle', $hDevice, 'uint', $iFlag, 'struct*', $pBuffer, _
			'uint*', $iLength)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return ($aRet[3] ? $aRet[0] : $aRet[4])
EndFunc   ;==>_WinAPI_GetRawInputDeviceInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRegisteredRawInputDevices($pBuffer, $iLength)
	Local $iLengthRAW = DllStructGetSize(DllStructCreate($tagRAWINPUTDEVICE))
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRegisteredRawInputDevices', 'struct*', $pBuffer, _
			'uint*', Floor($iLength / $iLengthRAW), 'uint', $iLengthRAW)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then
		Local $iLastError = _WinAPI_GetLastError()
		If $iLastError = 122 Then Return SetExtended($iLastError, $aRet[2] * $iLengthRAW) ; ERROR_INSUFFICIENT_BUFFER
		Return SetError(10, $iLastError, 0)
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetRegisteredRawInputDevices

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetStartupInfo()
	Local $tSI = DllStructCreate($tagSTARTUPINFO)
	DllCall('kernel32.dll', 'none', 'GetStartupInfoW', 'struct*', $tSI)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tSI
EndFunc   ;==>_WinAPI_GetStartupInfo

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemDEPPolicy()
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetSystemDEPPolicy')
	If @error Then Return SetError(@error, @extended, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetSystemDEPPolicy

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemInfo()
	Local $sProc
	If _WinAPI_IsWow64Process() Then
		$sProc = 'GetNativeSystemInfo'
	Else
		$sProc = 'GetSystemInfo'
	EndIf

	Local Const $tagSYSTEMINFO = 'struct;word ProcessorArchitecture;word Reserved; endstruct;dword PageSize;' & _
			'ptr MinimumApplicationAddress;ptr MaximumApplicationAddress;dword_ptr ActiveProcessorMask;dword NumberOfProcessors;' & _
			'dword ProcessorType;dword AllocationGranularity;word ProcessorLevel;word ProcessorRevision'
	Local $tSystemInfo = DllStructCreate($tagSYSTEMINFO)
	DllCall('kernel32.dll', 'none', $sProc, 'struct*', $tSystemInfo)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aResult[10]
	$aResult[0] = DllStructGetData($tSystemInfo, 1)
	For $i = 1 To 9
		$aResult[$i] = DllStructGetData($tSystemInfo, $i + 2)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetSystemInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemPowerStatus()
	Local $tagSYSTEM_POWER_STATUS = 'byte ACLineStatus;byte BatteryFlag;byte BatteryLifePercent;byte Reserved1;' & _
			'int BatteryLifeTime;int BatteryFullLifeTime'
	Local $tSYSTEM_POWER_STATUS = DllStructCreate($tagSYSTEM_POWER_STATUS)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetSystemPowerStatus', 'struct*', $tSYSTEM_POWER_STATUS)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[5]
	$aResult[0] = DllStructGetData($tSYSTEM_POWER_STATUS, 1)
	$aResult[1] = DllStructGetData($tSYSTEM_POWER_STATUS, 2)
	$aResult[2] = DllStructGetData($tSYSTEM_POWER_STATUS, 3)
	$aResult[3] = DllStructGetData($tSYSTEM_POWER_STATUS, 5)
	$aResult[4] = DllStructGetData($tSYSTEM_POWER_STATUS, 6)
	Return $aResult
EndFunc   ;==>_WinAPI_GetSystemPowerStatus

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemTimes()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetSystemTimes', 'uint64*', 0, 'uint64*', 0, 'uint64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = $aRet[$i + 1]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetSystemTimes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemWow64Directory()
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetSystemWow64DirectoryW', 'wstr', '', 'uint', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, _WinAPI_GetLastError(), '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetSystemWow64Directory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTickCount()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetTickCount')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTickCount

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTickCount64()
	Local $aRet = DllCall('kernel32.dll', 'uint64', 'GetTickCount64')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTickCount64

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetUserObjectInformation($hObject, $iIndex)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetUserObjectInformationW', 'handle', $hObject, 'int', $iIndex, 'ptr', 0, _
			'dword', 0, 'dword*', 0)
	If @error Or Not $aRet[5] Then Return SetError(@error + 10, @extended, 0)

	Local $tData
	Switch $iIndex
		Case 1
			$tData = DllStructCreate($tagUSEROBJECTFLAGS)
		Case 5, 6
			$tData = DllStructCreate('uint')
		Case 2, 3
			$tData = DllStructCreate('wchar[' & $aRet[5] & ']')
		Case 4
			$tData = DllStructCreate('byte[' & $aRet[5] & ']')
		Case Else
			Return SetError(20, 0, 0)
	EndSwitch
	$aRet = DllCall('user32.dll', 'bool', 'GetUserObjectInformationW', 'handle', $hObject, 'int', $iIndex, 'struct*', $tData, _
			'dword', DllStructGetSize($tData), 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 30, @extended, 0)

	Switch $iIndex
		Case 1, 4
			Return $tData
		Case Else
			Return DllStructGetData($tData, 1)
	EndSwitch
EndFunc   ;==>_WinAPI_GetUserObjectInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetVersion()
	; Return _WinAPI_HiByte($__WINVER) & '.' & _WinAPI_LoByte($__WINVER)
	Return Number(BitAND(BitShift($__WINVER, 8), 0xFF) & '.' & BitAND($__WINVER, 0xFF), $NUMBER_DOUBLE)
EndFunc   ;==>_WinAPI_GetVersion

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetVersionEx()
	Local $tOSVERSIONINFOEX = DllStructCreate($tagOSVERSIONINFOEX)
	DllStructSetData($tOSVERSIONINFOEX, 'OSVersionInfoSize', DllStructGetSize($tOSVERSIONINFOEX))

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVERSIONINFOEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tOSVERSIONINFOEX
EndFunc   ;==>_WinAPI_GetVersionEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWorkArea()
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'int', 'SystemParametersInfo', 'uint', 48, 'uint', 0, 'struct*', $tRECT, 'uint', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetWorkArea

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_InitMUILanguage($iLanguage)
	DllCall('comctl32.dll', 'none', 'InitMUILanguage', 'word', $iLanguage)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_InitMUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsLoadKBLayout($iLanguage)
	Local $aLayout = _WinAPI_GetKeyboardLayoutList()
	If @error Then Return SetError(@error, @extended, False)

	For $i = 1 To $aLayout[0]
		If $aLayout[$i] = $iLanguage Then Return True
	Next
	Return False
EndFunc   ;==>_WinAPI_IsLoadKBLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsProcessorFeaturePresent($iFeature)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsProcessorFeaturePresent', 'dword', $iFeature)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsProcessorFeaturePresent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsWindowEnabled($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsWindowEnabled', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsWindowEnabled

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_Keybd_Event($vKey, $iFlags, $iScanCode = 0, $iExtraInfo = 0)
	DllCall('user32.dll', 'none', 'keybd_event', 'byte', $vKey, 'byte', $iScanCode, 'dword', $iFlags, 'ulong_ptr', $iExtraInfo)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_Keybd_Event

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadKeyboardLayout($iLanguage, $iFlag = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'LoadKeyboardLayoutW', 'wstr', Hex($iLanguage, 8), 'uint', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LockWorkStation()
	Local $aRet = DllCall('user32.dll', 'bool', 'LockWorkStation')
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockWorkStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_MapVirtualKey($iCode, $iType, $hLocale = 0)
	Local $aRet = DllCall('user32.dll', 'INT', 'MapVirtualKeyExW', 'uint', $iCode, 'uint', $iType, 'uint_ptr', $hLocale)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MapVirtualKey

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_Mouse_Event($iFlags, $iX = 0, $iY = 0, $iData = 0, $iExtraInfo = 0)
	DllCall("user32.dll", "none", "mouse_event", "dword", $iFlags, "dword", $iX, "dword", $iY, "dword", $iData, _
			"ulong_ptr", $iExtraInfo)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_WinAPI_Mouse_Event

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenDesktop($sName, $iAccess = 0, $iFlags = 0, $bInherit = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'OpenDesktopW', 'wstr', $sName, 'dword', $iFlags, 'bool', $bInherit, _
			'dword', $iAccess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenInputDesktop($iAccess = 0, $iFlags = 0, $bInherit = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'OpenInputDesktop', 'dword', $iFlags, 'bool', $bInherit, 'dword', $iAccess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenInputDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenWindowStation($sName, $iAccess = 0, $bInherit = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'OpenWindowStationW', 'wstr', $sName, 'bool', $bInherit, 'dword', $iAccess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_QueryPerformanceCounter()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'QueryPerformanceCounter', 'int64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_QueryPerformanceCounter

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_QueryPerformanceFrequency()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'QueryPerformanceFrequency', 'int64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_QueryPerformanceFrequency

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterHotKey($hWnd, $iID, $iModifiers, $vKey)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterHotKey', 'hwnd', $hWnd, 'int', $iID, 'uint', $iModifiers, 'uint', $vKey)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterHotKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterPowerSettingNotification($hWnd, $sGUID)
	Local $tGUID = DllStructCreate($tagGUID)
	Local $aRet = DllCall('ole32.dll', 'long', 'CLSIDFromString', 'wstr', $sGUID, 'struct*', $tGUID)
	If @error Or $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	$aRet = DllCall('user32.dll', 'handle', 'RegisterPowerSettingNotification', 'handle', $hWnd, 'struct*', $tGUID, 'dword', 0)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterPowerSettingNotification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterRawInputDevices($paDevice, $iCount = 1)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterRawInputDevices', 'struct*', $paDevice, 'uint', $iCount, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTDEVICE)) * $iCount)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterRawInputDevices

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ReleaseCapture()
	Local $aResult = DllCall("user32.dll", "bool", "ReleaseCapture")
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReleaseCapture

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RemoveClipboardFormatListener($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'RemoveClipboardFormatListener', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RemoveClipboardFormatListener

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetActiveWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'int', 'SetActiveWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetActiveWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetCapture($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetCapture", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetCapture

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetDefaultPrinter($sPrinter)
	Local $aResult = DllCall("winspool.drv", "bool", "SetDefaultPrinterW", "wstr", $sPrinter)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetDefaultPrinter

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetDllDirectory($sDirPath = Default)
	Local $sTypeOfPath = 'wstr'
	If $sDirPath = Default Then
		$sTypeOfPath = 'ptr'
		$sDirPath = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetDllDirectoryW', $sTypeOfPath, $sDirPath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetDllDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetKeyboardLayout($hWnd, $iLanguage, $iFlags = 0)
	If Not _WinAPI_IsWindow($hWnd) Then Return SetError(@error + 10, @extended, 0)

	Local $hLocale = 0
	If $iLanguage Then
		$hLocale = _WinAPI_LoadKeyboardLayout($iLanguage)
		If Not $hLocale Then Return SetError(10, 0, 0)
	EndIf

	Local Const $WM_INPUTLANGCHANGEREQUEST = 0x0050
	DllCall('user32.dll', 'none', 'SendMessage', 'hwnd', $hWnd, 'uint', $WM_INPUTLANGCHANGEREQUEST, 'uint', $iFlags, 'uint_ptr', $hLocale)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_SetKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetKeyboardState(ByRef $tState)
	Local $aRet = DllCall('user32.dll', 'int', 'SetKeyboardState', 'struct*', $tState)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetKeyboardState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetProcessShutdownParameters($iLevel, $bDialog = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetProcessShutdownParameters', 'dword', $iLevel, 'dword', Not $bDialog)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetProcessShutdownParameters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetProcessWindowStation($hStation)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetProcessWindowStation', 'handle', $hStation)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetProcessWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetUserObjectInformation($hObject, $iIndex, ByRef $tData)
	If $iIndex <> 1 Then Return SetError(10, 0, False)

	Local $aRet = DllCall('user32.dll', 'bool', 'SetUserObjectInformationW', 'handle', $hObject, 'int', 1, 'struct*', $tData, _
			'dword', DllStructGetSize($tData))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetUserObjectInformation

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowsHookEx($iHook, $pProc, $hDll, $iThreadId = 0)
	Local $aResult = DllCall("user32.dll", "handle", "SetWindowsHookEx", "int", $iHook, "ptr", $pProc, "handle", $hDll, _
			"dword", $iThreadId)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowsHookEx

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_SetWinEventHook($iEventMin, $iEventMax, $pEventProc, $iPID = 0, $iThreadId = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'SetWinEventHook', 'uint', $iEventMin, 'uint', $iEventMax, 'ptr', 0, _
			'ptr', $pEventProc, 'dword', $iPID, 'dword', $iThreadId, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWinEventHook

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShutdownBlockReasonCreate($hWnd, $sText)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShutdownBlockReasonCreate', 'hwnd', $hWnd, 'wstr', $sText)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShutdownBlockReasonCreate

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShutdownBlockReasonDestroy($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShutdownBlockReasonDestroy', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShutdownBlockReasonDestroy

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShutdownBlockReasonQuery($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShutdownBlockReasonQuery', 'hwnd', $hWnd, 'wstr', '', 'dword*', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_ShutdownBlockReasonQuery

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SwitchDesktop($hDesktop)
	Local $aRet = DllCall('user32.dll', 'bool', 'SwitchDesktop', 'handle', $hDesktop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SwitchDesktop

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SystemParametersInfo($iAction, $iParam = 0, $vParam = 0, $iWinIni = 0)
	Local $aResult = DllCall("user32.dll", "bool", "SystemParametersInfoW", "uint", $iAction, "uint", $iParam, "struct*", $vParam, _
			"uint", $iWinIni)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SystemParametersInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Matt Diesel (Mat)
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_TrackMouseEvent($hWnd, $iFlags, $iTime = -1)
	Local $tTME = DllStructCreate('dword;dword;hwnd;dword')
	DllStructSetData($tTME, 1, DllStructGetSize($tTME))
	DllStructSetData($tTME, 2, $iFlags)
	DllStructSetData($tTME, 3, $hWnd)
	DllStructSetData($tTME, 4, $iTime)

	Local $aRet = DllCall('user32.dll', 'bool', 'TrackMouseEvent', 'struct*', $tTME)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TrackMouseEvent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_UnhookWindowsHookEx($hHook)
	Local $aResult = DllCall("user32.dll", "bool", "UnhookWindowsHookEx", "handle", $hHook)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_UnhookWindowsHookEx

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_UnhookWinEvent($hEventHook)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnhookWinEvent', 'handle', $hEventHook)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnhookWinEvent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnloadKeyboardLayout($hLocale)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnloadKeyboardLayout', 'handle', $hLocale)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnloadKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterHotKey($hWnd, $iID)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterHotKey', 'hwnd', $hWnd, 'int', $iID)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnregisterHotKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterPowerSettingNotification($hNotify)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterPowerSettingNotification', 'handle', $hNotify)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnregisterPowerSettingNotification

Func __EnumPageFilesProc($iSize, $pInfo, $pFile)
	Local $tEPFI = DllStructCreate('dword;dword;ulong_ptr;ulong_ptr;ulong_ptr', $pInfo)

	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData(DllStructCreate('wchar[' & (_WinAPI_StrLen($pFile) + 1) & ']', $pFile), 1)
	For $i = 1 To 3
		$__g_vEnum[$__g_vEnum[0][0]][$i] = DllStructGetData($tEPFI, $i + 2) * $iSize
	Next
	Return 1
EndFunc   ;==>__EnumPageFilesProc

#EndRegion Internal Functions
