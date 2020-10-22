#include-once

#include "APIProcConstants.au3"
#include "Security.au3"
#include "SecurityConstants.au3"
#include "StringConstants.au3"
#include "WinAPICom.au3"
#include "WinAPIError.au3"
#include "WinAPIHObj.au3"
#include "WinAPIShPath.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIProc.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #CONSTANTS# ===================================================================================================================
Global Const $tagIO_COUNTERS = 'struct;uint64 ReadOperationCount;uint64 WriteOperationCount;uint64 OtherOperationCount;uint64 ReadTransferCount;uint64 WriteTransferCount;uint64 OtherTransferCount;endstruct'
Global Const $tagJOBOBJECT_ASSOCIATE_COMPLETION_PORT = 'ulong_ptr CompletionKey;ptr CompletionPort'
Global Const $tagJOBOBJECT_BASIC_ACCOUNTING_INFORMATION = 'struct;int64 TotalUserTime;int64 TotalKernelTime;int64 ThisPeriodTotalUserTime;int64 ThisPeriodTotalKernelTime;dword TotalPageFaultCount;dword TotalProcesses;dword ActiveProcesses;dword TotalTerminatedProcesses;endstruct'
Global Const $tagJOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION = $tagJOBOBJECT_BASIC_ACCOUNTING_INFORMATION & ';' & $tagIO_COUNTERS
Global Const $tagJOBOBJECT_BASIC_LIMIT_INFORMATION = 'struct;int64 PerProcessUserTimeLimit;int64 PerJobUserTimeLimit;dword LimitFlags;ulong_ptr MinimumWorkingSetSize;ulong_ptr MaximumWorkingSetSize;dword ActiveProcessLimit;ulong_ptr Affinity;dword PriorityClass;dword SchedulingClass;endstruct'
Global Const $tagJOBOBJECT_BASIC_PROCESS_ID_LIST = 'dword NumberOfAssignedProcesses;dword NumberOfProcessIdsInList' ; & ';ulong_ptr ProcessIdList[n]'
Global Const $tagJOBOBJECT_BASIC_UI_RESTRICTIONS = 'dword UIRestrictionsClass'
Global Const $tagJOBOBJECT_END_OF_JOB_TIME_INFORMATION = 'dword EndOfJobTimeAction'
Global Const $tagJOBOBJECT_EXTENDED_LIMIT_INFORMATION = $tagJOBOBJECT_BASIC_LIMIT_INFORMATION & ';' & $tagIO_COUNTERS & ';ulong_ptr ProcessMemoryLimit;ulong_ptr JobMemoryLimit;ulong_ptr PeakProcessMemoryUsed;ulong_ptr PeakJobMemoryUsed'
Global Const $tagJOBOBJECT_GROUP_INFORMATION = '' ; & 'ushort ProcessorGroup[n]'
Global Const $tagJOBOBJECT_SECURITY_LIMIT_INFORMATION = 'dword SecurityLimitFlags;ptr JobToken;ptr SidsToDisable;ptr PrivilegesToDelete;ptr RestrictedSids'
Global Const $tagMODULEINFO = 'ptr BaseOfDll;dword SizeOfImage;ptr EntryPoint'
Global Const $tagPROCESSENTRY32 = 'dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_AdjustTokenPrivileges
; _WinAPI_AssignProcessToJobObject
; _WinAPI_AttachConsole
; _WinAPI_AttachThreadInput
; _WinAPI_CreateEvent
; _WinAPI_CreateJobObject
; _WinAPI_CreateMutex
; _WinAPI_CreateProcess
; _WinAPI_CreateProcessWithToken
; _WinAPI_CreateSemaphore
; _WinAPI_DuplicateTokenEx
; _WinAPI_EmptyWorkingSet
; _WinAPI_EnumChildProcess
; _WinAPI_EnumDeviceDrivers
; _WinAPI_EnumProcessHandles
; _WinAPI_EnumProcessModules
; _WinAPI_EnumProcessThreads
; _WinAPI_EnumProcessWindows
; _WinAPI_FatalAppExit
; _WinAPI_GetCurrentProcessExplicitAppUserModelID
; _WinAPI_GetCurrentProcessID
; _WinAPI_GetCurrentThread
; _WinAPI_GetCurrentThreadId
; _WinAPI_GetDeviceDriverBaseName
; _WinAPI_GetDeviceDriverFileName
; _WinAPI_GetExitCodeProcess
; _WinAPI_GetGuiResources
; _WinAPI_GetModuleFileNameEx
; _WinAPI_GetModuleInformation
; _WinAPI_GetParentProcess
; _WinAPI_GetPriorityClass
; _WinAPI_GetProcessAffinityMask
; _WinAPI_GetProcessCommandLine
; _WinAPI_GetProcessFileName
; _WinAPI_GetProcessHandleCount
; _WinAPI_GetProcessID
; _WinAPI_GetProcessIoCounters
; _WinAPI_GetProcessMemoryInfo
; _WinAPI_GetProcessName
; _WinAPI_GetProcessTimes
; _WinAPI_GetProcessUser
; _WinAPI_GetProcessWorkingDirectory
; _WinAPI_GetThreadDesktop
; _WinAPI_GetThreadErrorMode
; _WinAPI_GetWindowFileName
; _WinAPI_IsElevated
; _WinAPI_IsProcessInJob
; _WinAPI_OpenJobObject
; _WinAPI_OpenMutex
; _WinAPI_OpenProcess
; _WinAPI_OpenProcessToken
; _WinAPI_OpenSemaphore
; _WinAPI_QueryInformationJobObject
; _WinAPI_ReleaseMutex
; _WinAPI_ReleaseSemaphore
; _WinAPI_ResetEvent
; _WinAPI_SetEvent
; _WinAPI_SetInformationJobObject
; _WinAPI_SetPriorityClass
; _WinAPI_SetProcessAffinityMask
; _WinAPI_SetThreadDesktop
; _WinAPI_SetThreadErrorMode
; _WinAPI_SetThreadExecutionState
; _WinAPI_TerminateJobObject
; _WinAPI_TerminateProcess
; _WinAPI_UserHandleGrantAccess
; _WinAPI_WaitForInputIdle
; _WinAPI_WaitForMultipleObjects
; _WinAPI_WaitForSingleObject
; _WinAPI_WriteConsole
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_AdjustTokenPrivileges($hToken, $aPrivileges, $iAttributes, ByRef $aAdjust)
	$aAdjust = 0
	If Not $aPrivileges And IsNumber($aPrivileges) Then Return 0

	Local $tTP1 = 0, $tTP2, $iCount, $aRet, $bDisable = False
	If $aPrivileges = -1 Then
		$tTP2 = DllStructCreate('dword')
		$aRet = DllCall('advapi32.dll', 'bool', 'AdjustTokenPrivileges', 'handle', $hToken, 'bool', 1, 'ptr', 0, _
				'dword', 0, 'struct*', $tTP2, 'dword*', 0)
		If @error Then Return SetError(@error, @extended, 0)
		Local $iLastError = _WinAPI_GetLastError()
		Switch $iLastError
			Case 122 ; ERROR_INSUFFICIENT_BUFFER
				$tTP2 = DllStructCreate('dword;dword[' & ($aRet[6] / 4 - 1) & ']')
				If @error Then
					ContinueCase
				EndIf
			Case Else
				Return SetError(10, $iLastError, 0)
		EndSwitch
		$bDisable = True
	Else
		Local $aPrev = 0
		If Not IsArray($aPrivileges) Then
			Dim $aPrev[1][2]
			$aPrev[0][0] = $aPrivileges
			$aPrev[0][1] = $iAttributes
		Else
			If Not UBound($aPrivileges, $UBOUND_COLUMNS) Then
				$iCount = UBound($aPrivileges)
				Dim $aPrev[$iCount][2]
				For $i = 0 To $iCount - 1
					$aPrev[$i][0] = $aPrivileges[$i]
					$aPrev[$i][1] = $iAttributes
				Next
			EndIf
		EndIf
		If IsArray($aPrev) Then
			$aPrivileges = $aPrev
		EndIf
		Local $tagStruct = 'dword;dword[' & (3 * UBound($aPrivileges)) & ']'
		$tTP1 = DllStructCreate($tagStruct)
		$tTP2 = DllStructCreate($tagStruct)
		If @error Then Return SetError(@error + 20, 0, 0)

		DllStructSetData($tTP1, 1, UBound($aPrivileges))
		For $i = 0 To UBound($aPrivileges) - 1
			DllStructSetData($tTP1, 2, $aPrivileges[$i][1], 3 * $i + 3)
			$aRet = DllCall('advapi32.dll', 'bool', 'LookupPrivilegeValueW', 'ptr', 0, 'wstr', $aPrivileges[$i][0], _
					'ptr', DllStructGetPtr($tTP1, 2) + 12 * $i)
			If @error Or Not $aRet[0] Then Return SetError(@error + 100, @extended, 0)
		Next
	EndIf
	$aRet = DllCall('advapi32.dll', 'bool', 'AdjustTokenPrivileges', 'handle', $hToken, 'bool', $bDisable, _
			'struct*', $tTP1, 'dword', DllStructGetSize($tTP2), 'struct*', $tTP2, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 200, @extended, 0)

	Local $iResult
	Switch _WinAPI_GetLastError()
		Case 1300 ; ERROR_NOT_ALL_ASSIGNED
			$iResult = 1
		Case Else
			$iResult = 0
	EndSwitch
	$iCount = DllStructGetData($tTP2, 1)
	If $iCount Then
		Local $tData = DllStructCreate('wchar[128]')
		Dim $aPrivileges[$iCount][2]
		For $i = 0 To $iCount - 1
			$aRet = DllCall('advapi32.dll', 'bool', 'LookupPrivilegeNameW', 'ptr', 0, _
					'ptr', DllStructGetPtr($tTP2, 2) + 12 * $i, 'struct*', $tData, 'dword*', 128)
			If @error Or Not $aRet[0] Then Return SetError(@error + 300, @extended, 0)

			$aPrivileges[$i][1] = DllStructGetData($tTP2, 2, 3 * $i + 3)
			$aPrivileges[$i][0] = DllStructGetData($tData, 1)
		Next
		$aAdjust = $aPrivileges
	EndIf

	Return SetExtended($iResult, 1)
EndFunc   ;==>_WinAPI_AdjustTokenPrivileges

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AssignProcessToJobObject($hJob, $hProcess)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'AssignProcessToJobObject', 'handle', $hJob, 'handle', $hProcess)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AssignProcessToJobObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_AttachConsole($iPID = -1)
	Local $aResult = DllCall("kernel32.dll", "bool", "AttachConsole", "dword", $iPID)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_AttachConsole

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_AttachThreadInput($iAttach, $iAttachTo, $bAttach)
	Local $aResult = DllCall("user32.dll", "bool", "AttachThreadInput", "dword", $iAttach, "dword", $iAttachTo, "bool", $bAttach)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_AttachThreadInput

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateEvent($tAttributes = 0, $bManualReset = True, $bInitialState = True, $sName = "")
	Local $sNameType = "wstr"
	If $sName = "" Then
		$sName = 0
		$sNameType = "ptr"
	EndIf

	Local $aResult = DllCall("kernel32.dll", "handle", "CreateEventW", "struct*", $tAttributes, "bool", $bManualReset, _
			"bool", $bInitialState, $sNameType, $sName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateEvent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateJobObject($sName = '', $tSecurity = 0)
	Local $sTypeOfName = 'wstr'
	If Not StringStripWS($sName, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfName = 'ptr'
		$sName = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateJobObjectW', 'struct*', $tSecurity, $sTypeOfName, $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateJobObject

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateMutex($sMutex, $bInitial = True, $tSecurity = 0)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $tSecurity, 'bool', $bInitial, 'wstr', $sMutex)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateMutex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateProcess($sAppName, $sCommand, $tSecurity, $tThread, $bInherit, $iFlags, $pEnviron, $sDir, $tStartupInfo, $tProcess)
	Local $tCommand = 0
	Local $sAppNameType = "wstr", $sDirType = "wstr"
	If $sAppName = "" Then
		$sAppNameType = "ptr"
		$sAppName = 0
	EndIf
	If $sCommand <> "" Then
		; must be MAX_PATH characters, can be updated by CreateProcessW
		$tCommand = DllStructCreate("wchar Text[" & 260 + 1 & "]")
		DllStructSetData($tCommand, "Text", $sCommand)
	EndIf
	If $sDir = "" Then
		$sDirType = "ptr"
		$sDir = 0
	EndIf

	Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "struct*", $tCommand, _
			"struct*", $tSecurity, "struct*", $tThread, "bool", $bInherit, "dword", $iFlags, "struct*", $pEnviron, $sDirType, $sDir, _
			"struct*", $tStartupInfo, "struct*", $tProcess)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateProcess

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateProcessWithToken($sApp, $sCmd, $iFlags, $tStartupInfo, $tProcessInfo, $hToken, $iLogon = 0, $pEnvironment = 0, $sDir = '')
	Local $sTypeOfApp = 'wstr', $sTypeOfCmd = 'wstr', $sTypeOfDir = 'wstr'
	If Not StringStripWS($sApp, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfApp = 'ptr'
		$sApp = 0
	EndIf
	If Not StringStripWS($sCmd, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfCmd = 'ptr'
		$sCmd = 0
	EndIf
	If Not StringStripWS($sDir, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfDir = 'ptr'
		$sDir = 0
	EndIf

	Local $aRet = DllCall('advapi32.dll', 'bool', 'CreateProcessWithTokenW', 'handle', $hToken, 'dword', $iLogon, _
			$sTypeOfApp, $sApp, $sTypeOfCmd, $sCmd, 'dword', $iFlags, 'struct*', $pEnvironment, _
			$sTypeOfDir, $sDir, 'struct*', $tStartupInfo, 'struct*', $tProcessInfo)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateProcessWithToken

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateSemaphore($sSemaphore, $iInitial, $iMaximum, $tSecurity = 0)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateSemaphoreW', 'struct*', $tSecurity, 'long', $iInitial, _
			'long', $iMaximum, 'wstr', $sSemaphore)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateSemaphore

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DuplicateTokenEx($hToken, $iAccess, $iLevel, $iType = 1, $tSecurity = 0)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'DuplicateTokenEx', 'handle', $hToken, 'dword', $iAccess, _
			'struct*', $tSecurity, 'int', $iLevel, 'int', $iType, 'handle*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_DuplicateTokenEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EmptyWorkingSet($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000500 : 0x00001100), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EmptyWorkingSet', 'handle', $hProcess[0])
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_EmptyWorkingSet

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumChildProcess($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If @error Or ($hSnapshot[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0) ; $INVALID_HANDLE_VALUE

	Local $tPROCESSENTRY32 = DllStructCreate($tagPROCESSENTRY32)
	Local $aResult[101][2] = [[0]]

	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	Local $aRet = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
	Local $iError = @error
	While (Not @error) And ($aRet[0])
		If DllStructGetData($tPROCESSENTRY32, 'ParentProcessID') = $iPID Then
			__Inc($aResult)
			$aResult[$aResult[0][0]][0] = DllStructGetData($tPROCESSENTRY32, 'ProcessID')
			$aResult[$aResult[0][0]][1] = DllStructGetData($tPROCESSENTRY32, 'ExeFile')
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
		$iError = @error
	WEnd
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)
	If Not $aResult[0][0] Then Return SetError($iError + 20, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_EnumChildProcess

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDeviceDrivers()
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumDeviceDrivers', 'ptr', 0, 'dword', 0, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $iSize
	If @AutoItX64 Then
		$iSize = $aRet[3] / 8
	Else
		$iSize = $aRet[3] / 4
	EndIf
	Local $tData = DllStructCreate('ptr[' & $iSize & ']')
	$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumDeviceDrivers', 'struct*', $tData, _
			'dword', DllStructGetSize($tData), 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	Local $aResult[$iSize + 1] = [$iSize]
	For $i = 1 To $iSize
		$aResult[$i] = DllStructGetData($tData, 1, $i)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_EnumDeviceDrivers

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumProcessHandles($iPID = 0, $iType = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $aResult[101][4] = [[0]]

	Local $tSHI = DllStructCreate('ulong;byte[4194304]')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQuerySystemInformation', 'uint', 16, 'struct*', $tSHI, _
			'ulong', DllStructGetSize($tSHI), 'ulong*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $pData = DllStructGetPtr($tSHI, 2)
	Local $tHandle
	For $i = 1 To DllStructGetData($tSHI, 1)
		$tHandle = DllStructCreate('align 4;ulong;byte;byte;ushort;ptr;ulong', $pData + (@AutoItX64 ? (4 + ($i - 1) * 24) : (($i - 1) * 16)))
		If (DllStructGetData($tHandle, 1) = $iPID) And ((Not $iType) Or ($iType = DllStructGetData($tHandle, 2))) Then
			__Inc($aResult)
			$aResult[$aResult[0][0]][0] = Ptr(DllStructGetData($tHandle, 4))
			$aResult[$aResult[0][0]][1] = DllStructGetData($tHandle, 2)
			$aResult[$aResult[0][0]][2] = DllStructGetData($tHandle, 3)
			$aResult[$aResult[0][0]][3] = DllStructGetData($tHandle, 6)
		EndIf
	Next
	If Not $aResult[0][0] Then Return SetError(11, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_EnumProcessHandles

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumProcessModules($iPID = 0, $iFlag = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $iCount, $aRet, $iError = 0
	Do
		If $__WINVER >= 0x0600 Then
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModulesEx', 'handle', $hProcess[0], 'ptr', 0, _
					'dword', 0, 'dword*', 0, 'dword', $iFlag)
		Else
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModules', 'handle', $hProcess[0], 'ptr', 0, _
					'dword', 0, 'dword*', 0)
		EndIf
		If @error Or Not $aRet[0] Then
			$iError = @error + 10
			ExitLoop
		EndIf
		If @AutoItX64 Then
			$iCount = $aRet[4] / 8
		Else
			$iCount = $aRet[4] / 4
		EndIf
		Local $tPtr = DllStructCreate('ptr[' & $iCount & ']')
		If @error Then
			$iError = @error + 30
			ExitLoop
		EndIf
		If $__WINVER >= 0x0600 Then
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModulesEx', 'handle', $hProcess[0], 'struct*', $tPtr, _
					'dword', DllStructGetSize($tPtr), 'dword*', 0, 'dword', $iFlag)
		Else
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModules', 'handle', $hProcess[0], 'struct*', $tPtr, _
					'dword', DllStructGetSize($tPtr), 'dword*', 0)
		EndIf
		If @error Or Not $aRet[0] Then
			$iError = @error + 40
			ExitLoop
		EndIf
		Local $aResult[$iCount + 1][2] = [[$iCount]]
		For $i = 1 To $iCount
			$aResult[$i][0] = DllStructGetData($tPtr, 1, $i)
			$aResult[$i][1] = _WinAPI_GetModuleFileNameEx($hProcess[0], $aResult[$i][0])
		Next
	Until 1
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
	If $iError Then Return SetError($iError, 0, 0)

	Return $aResult
EndFunc   ;==>_WinAPI_EnumProcessModules

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumProcessThreads($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000004, 'dword', 0)
	If @error Or Not $hSnapshot[0] Then Return SetError(@error + 10, @extended, 0)

	Local Const $tagTHREADENTRY32 = 'dword Size;dword Usage;dword ThreadID;dword OwnerProcessID;long BasePri;long DeltaPri;dword Flags'
	Local $tTHREADENTRY32 = DllStructCreate($tagTHREADENTRY32)
	Local $aResult[101] = [0]

	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tTHREADENTRY32, 'Size', DllStructGetSize($tTHREADENTRY32))
	Local $aRet = DllCall('kernel32.dll', 'bool', 'Thread32First', 'handle', $hSnapshot, 'struct*', $tTHREADENTRY32)
	While Not @error And $aRet[0]
		If DllStructGetData($tTHREADENTRY32, 'OwnerProcessID') = $iPID Then
			__Inc($aResult)
			$aResult[$aResult[0]] = DllStructGetData($tTHREADENTRY32, 'ThreadID')
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'Thread32Next', 'handle', $hSnapshot, 'struct*', $tTHREADENTRY32)
	WEnd
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)
	If Not $aResult[0] Then Return SetError(1, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_EnumProcessThreads

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumProcessWindows($iPID = 0, $bVisible = True)
	Local $aThreads = _WinAPI_EnumProcessThreads($iPID)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'bool', 'hwnd;lparam')

	Dim $__g_vEnum[101][2] = [[0]]
	For $i = 1 To $aThreads[0]
		DllCall('user32.dll', 'bool', 'EnumThreadWindows', 'dword', $aThreads[$i], 'ptr', DllCallbackGetPtr($hEnumProc), _
				'lparam', $bVisible)
		If @error Then
			ExitLoop
		EndIf
	Next
	DllCallbackFree($hEnumProc)
	If Not $__g_vEnum[0][0] Then Return SetError(11, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumProcessWindows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FatalAppExit($sMessage)
	DllCall("kernel32.dll", "none", "FatalAppExitW", "uint", 0, "wstr", $sMessage)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_WinAPI_FatalAppExit

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentProcessExplicitAppUserModelID()
	Local $aRet = DllCall('shell32.dll', 'long', 'GetCurrentProcessExplicitAppUserModelID', 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Local $sID = _WinAPI_GetString($aRet[1])
	_WinAPI_CoTaskMemFree($aRet[1])
	Return $sID
EndFunc   ;==>_WinAPI_GetCurrentProcessExplicitAppUserModelID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentProcessID()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetCurrentProcessId")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentProcessID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentThread()
	Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentThread

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentThreadId()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetCurrentThreadId")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentThreadId

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDeviceDriverBaseName($pDriver)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'dword', 'GetDeviceDriverBaseNameW', 'ptr', $pDriver, 'wstr', '', _
			'dword', 4096)
	If @error Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetDeviceDriverBaseName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDeviceDriverFileName($pDriver)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'dword', 'GetDeviceDriverFileNameW', 'ptr', $pDriver, 'wstr', '', _
			'dword', 4096)
	If @error Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetDeviceDriverFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetExitCodeProcess($hProcess)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetExitCodeProcess', 'handle', $hProcess, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetExitCodeProcess

; #FUNCTION# ====================================================================================================================
; Author ........: jpm
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetGuiResources($iFlag = 0, $hProcess = -1)
	If $hProcess = -1 Then $hProcess = _WinAPI_GetCurrentProcess()
	Local $aResult = DllCall("user32.dll", "dword", "GetGuiResources", "handle", $hProcess, "dword", $iFlag)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetGuiResources

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetModuleFileNameEx($hProcess, $hModule = 0)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'dword', 'GetModuleFileNameExW', 'handle', $hProcess, 'handle', $hModule, _
			'wstr', '', 'int', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetModuleFileNameEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetModuleInformation($hProcess, $hModule = 0)
	Local $tMODULEINFO = DllStructCreate($tagMODULEINFO)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'GetModuleInformation', 'handle', $hProcess, 'handle', $hModule, _
			'struct*', $tMODULEINFO, 'dword', DllStructGetSize($tMODULEINFO))
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tMODULEINFO
EndFunc   ;==>_WinAPI_GetModuleInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetParentProcess($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If @error Or Not $hSnapshot[0] Then Return SetError(@error + 10, @extended, 0)

	Local $tPROCESSENTRY32 = DllStructCreate($tagPROCESSENTRY32)
	Local $iResult = 0

	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	Local $aRet = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
	Local $iError = @error
	While (Not @error) And ($aRet[0])
		If DllStructGetData($tPROCESSENTRY32, 'ProcessID') = $iPID Then
			$iResult = DllStructGetData($tPROCESSENTRY32, 'ParentProcessID')
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
		$iError = @error
	WEnd
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)
	If Not $iResult Then Return SetError($iError, 0, 0)

	Return $iResult
EndFunc   ;==>_WinAPI_GetParentProcess

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_GetPriorityClass($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), 'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)
	; If Not $hProcess[0] Then Return SetError(1000, 0, 0)

	Local $iError = 0
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetPriorityClass', 'handle', $hProcess[0])
	If @error Then $iError = @error
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
	If $iError Then Return SetError($iError, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetPriorityClass

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetProcessAffinityMask($hProcess)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetProcessAffinityMask", "handle", $hProcess, "dword_ptr*", 0, "dword_ptr*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aMask[3]
	$aMask[0] = True
	$aMask[1] = $aResult[2]
	$aMask[2] = $aResult[3]
	Return $aMask
EndFunc   ;==>_WinAPI_GetProcessAffinityMask

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessCommandLine($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, '')

	$hProcess = $hProcess[0]

	Local $tPBI = DllStructCreate('ulong_ptr ExitStatus;ptr PebBaseAddress;ulong_ptr AffinityMask;ulong_ptr BasePriority;ulong_ptr UniqueProcessId;ulong_ptr InheritedFromUniqueProcessId')
	Local $tPEB = DllStructCreate('byte InheritedAddressSpace;byte ReadImageFileExecOptions;byte BeingDebugged;byte Spare;ptr Mutant;ptr ImageBaseAddress;ptr LoaderData;ptr ProcessParameters;ptr SubSystemData;ptr ProcessHeap;ptr FastPebLock;ptr FastPebLockRoutine;ptr FastPebUnlockRoutine;ulong EnvironmentUpdateCount;ptr KernelCallbackTable;ptr EventLogSection;ptr EventLog;ptr FreeList;ulong TlsExpansionCounter;ptr TlsBitmap;ulong TlsBitmapBits[2];ptr ReadOnlySharedMemoryBase;ptr ReadOnlySharedMemoryHeap;ptr ReadOnlyStaticServerData;ptr AnsiCodePageData;ptr OemCodePageData;ptr UnicodeCaseTableData;ulong NumberOfProcessors;ulong NtGlobalFlag;byte Spare2[4];int64 CriticalSectionTimeout;ulong HeapSegmentReserve;ulong HeapSegmentCommit;ulong HeapDeCommitTotalFreeThreshold;ulong HeapDeCommitFreeBlockThreshold;ulong NumberOfHeaps;ulong MaximumNumberOfHeaps;ptr ProcessHeaps;ptr GdiSharedHandleTable;ptr ProcessStarterHelper;ptr GdiDCAttributeList;ptr LoaderLock;ulong OSMajorVersion;ulong OSMinorVersion;ulong OSBuildNumber;ulong OSPlatformId;ulong ImageSubSystem;ulong ImageSubSystemMajorVersion;ulong ImageSubSystemMinorVersion;ulong GdiHandleBuffer[34];ulong PostProcessInitRoutine;ulong TlsExpansionBitmap;byte TlsExpansionBitmapBits[128];ulong SessionId')
	Local $tUPP = DllStructCreate('ulong AllocationSize;ulong ActualSize;ulong Flags;ulong Unknown1;ushort LengthUnknown2;ushort MaxLengthUnknown2;ptr Unknown2;ptr InputHandle;ptr OutputHandle;ptr ErrorHandle;ushort LengthCurrentDirectory;ushort MaxLengthCurrentDirectory;ptr CurrentDirectory;ptr CurrentDirectoryHandle;ushort LengthSearchPaths;ushort MaxLengthSearchPaths;ptr SearchPaths;ushort LengthApplicationName;ushort MaxLengthApplicationName;ptr ApplicationName;ushort LengthCommandLine;ushort MaxLengthCommandLine;ptr CommandLine;ptr EnvironmentBlock;ulong Unknown[9];ushort LengthUnknown3;ushort MaxLengthUnknown3;ptr Unknown3;ushort LengthUnknown4;ushort MaxLengthUnknown4;ptr Unknown4;ushort LengthUnknown5;ushort MaxLengthUnknown5;ptr Unknown5')
	Local $tCMD

	Local $aRet, $iError = 0
	Do
		$aRet = DllCall('ntdll.dll', 'long', 'NtQueryInformationProcess', 'handle', $hProcess, 'ulong', 0, 'struct*', $tPBI, _
				'ulong', DllStructGetSize($tPBI), 'ulong*', 0)
		If @error Or $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tPBI, 'PebBaseAddress'), 'struct*', $tPEB, _
				'ulong_ptr', DllStructGetSize($tPEB), 'ulong_ptr*', 0)
		If @error Or Not $aRet[0] Or (Not $aRet[5]) Then
			$iError = @error + 40
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tPEB, 'ProcessParameters'), 'struct*', $tUPP, _
				'ulong_ptr', DllStructGetSize($tUPP), 'ulong_ptr*', 0)
		If @error Or Not $aRet[0] Or (Not $aRet[5]) Then
			$iError = @error + 50
			ExitLoop
		EndIf
		$tCMD = DllStructCreate('byte[' & DllStructGetData($tUPP, 'MaxLengthCommandLine') & ']')
		If @error Then
			$iError = @error + 60
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tUPP, 'CommandLine'), 'struct*', $tCMD, _
				'ulong_ptr', DllStructGetSize($tCMD), 'ulong_ptr*', 0)
		If @error Or Not $aRet[0] Or (Not $aRet[5]) Then
			$iError = @error + 70
			ExitLoop
		EndIf
	Until 1
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	If $iError Then Return SetError($iError, 0, '')

	Return StringStripWS(_WinAPI_PathGetArgs(_WinAPI_GetString(DllStructGetPtr($tCMD, 1))), $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc   ;==>_WinAPI_GetProcessCommandLine

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessFileName($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, '')

	Local $sPath = _WinAPI_GetModuleFileNameEx($hProcess[0])
	Local $iError = @error

	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
	If $iError Then Return SetError(@error, 0, '')

	Return $sPath
EndFunc   ;==>_WinAPI_GetProcessFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessHandleCount($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessHandleCount', 'handle', $hProcess[0], 'dword*', 0)
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetProcessHandleCount

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessID($hProcess)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetProcessId', 'handle', $hProcess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetProcessID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessIoCounters($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $tIO_COUNTERS = DllStructCreate('uint64[6]')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessIoCounters', 'handle', $hProcess[0], 'struct*', $tIO_COUNTERS)
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, 0)

	Local $aResult[6]
	For $i = 0 To 5
		$aResult[$i] = DllStructGetData($tIO_COUNTERS, 1, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetProcessIoCounters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessMemoryInfo($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $tPMC_EX = DllStructCreate('dword;dword;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr')
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'GetProcessMemoryInfo', 'handle', $hProcess[0], 'struct*', $tPMC_EX, _
			'int', DllStructGetSize($tPMC_EX))
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, 0)

	Local $aResult[10]
	For $i = 0 To 9
		$aResult[$i] = DllStructGetData($tPMC_EX, $i + 2)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetProcessMemoryInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessName($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If @error Or Not $hSnapshot[0] Then Return SetError(@error + 20, @extended, '')

	$hSnapshot = $hSnapshot[0]
	Local $tPROCESSENTRY32 = DllStructCreate($tagPROCESSENTRY32)
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	Local $aRet = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
	Local $iError = @error
	While (Not @error) And ($aRet[0])
		If DllStructGetData($tPROCESSENTRY32, 'ProcessID') = $iPID Then
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
		$iError = @error
	WEnd
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)
	If $iError Then Return SetError($iError, 0, '')
	If Not $aRet[0] Then SetError(10, 0, '')

	Return DllStructGetData($tPROCESSENTRY32, 'ExeFile')
EndFunc   ;==>_WinAPI_GetProcessName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessTimes($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $tFILETIME = DllStructCreate($tagFILETIME)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessTimes', 'handle', $hProcess[0], 'struct*', $tFILETIME, 'uint64*', 0, _
			'uint64*', 0, 'uint64*', 0)
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, 0)

	Local $aResult[3]
	$aResult[0] = $tFILETIME
	$aResult[1] = $aRet[4]
	$aResult[2] = $aRet[5]
	Return $aResult
EndFunc   ;==>_WinAPI_GetProcessTimes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessUser($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $tSID, $hToken, $aRet
	Local $iError = 0

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Do
		$hToken = _WinAPI_OpenProcessToken(0x00000008, $hProcess[0])
		If Not $hToken Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$tSID = DllStructCreate('ptr;byte[1024]')
		$aRet = DllCall('advapi32.dll', 'bool', 'GetTokenInformation', 'handle', $hToken, 'uint', 1, 'struct*', $tSID, _
				'dword', DllStructGetSize($tSID), 'dword*', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$aRet = DllCall('advapi32.dll', 'bool', 'LookupAccountSidW', 'ptr', 0, 'ptr', DllStructGetData($tSID, 1), 'wstr', '', _
				'dword*', 2048, 'wstr', '', 'dword*', 2048, 'uint*', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 40
			ExitLoop
		EndIf
	Until 1
	If $hToken Then
		DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
	If $iError Then Return SetError($iError, 0, 0)

	Local $aResult[2]
	$aResult[0] = $aRet[3]
	$aResult[1] = $aRet[5]
	Return $aResult
EndFunc   ;==>_WinAPI_GetProcessUser

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessWorkingDirectory($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $aRet, $iError = 0

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), 'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, '')

	$hProcess = $hProcess[0]

	Local $tPBI = DllStructCreate('ulong_ptr ExitStatus;ptr PebBaseAddress;ulong_ptr AffinityMask;ulong_ptr BasePriority;ulong_ptr UniqueProcessId;ulong_ptr InheritedFromUniqueProcessId')
	Local $tPEB = DllStructCreate('byte InheritedAddressSpace;byte ReadImageFileExecOptions;byte BeingDebugged;byte Spare;ptr Mutant;ptr ImageBaseAddress;ptr LoaderData;ptr ProcessParameters;ptr SubSystemData;ptr ProcessHeap;ptr FastPebLock;ptr FastPebLockRoutine;ptr FastPebUnlockRoutine;ulong EnvironmentUpdateCount;ptr KernelCallbackTable;ptr EventLogSection;ptr EventLog;ptr FreeList;ulong TlsExpansionCounter;ptr TlsBitmap;ulong TlsBitmapBits[2];ptr ReadOnlySharedMemoryBase;ptr ReadOnlySharedMemoryHeap;ptr ReadOnlyStaticServerData;ptr AnsiCodePageData;ptr OemCodePageData;ptr UnicodeCaseTableData;ulong NumberOfProcessors;ulong NtGlobalFlag;byte Spare2[4];int64 CriticalSectionTimeout;ulong HeapSegmentReserve;ulong HeapSegmentCommit;ulong HeapDeCommitTotalFreeThreshold;ulong HeapDeCommitFreeBlockThreshold;ulong NumberOfHeaps;ulong MaximumNumberOfHeaps;ptr ProcessHeaps;ptr GdiSharedHandleTable;ptr ProcessStarterHelper;ptr GdiDCAttributeList;ptr LoaderLock;ulong OSMajorVersion;ulong OSMinorVersion;ulong OSBuildNumber;ulong OSPlatformId;ulong ImageSubSystem;ulong ImageSubSystemMajorVersion;ulong ImageSubSystemMinorVersion;ulong GdiHandleBuffer[34];ulong PostProcessInitRoutine;ulong TlsExpansionBitmap;byte TlsExpansionBitmapBits[128];ulong SessionId')
	Local $tUPP = DllStructCreate('ulong AllocationSize;ulong ActualSize;ulong Flags;ulong Unknown1;ushort LengthUnknown2;ushort MaxLengthUnknown2;ptr Unknown2;ptr InputHandle;ptr OutputHandle;ptr ErrorHandle;ushort LengthCurrentDirectory;ushort MaxLengthCurrentDirectory;ptr CurrentDirectory;ptr CurrentDirectoryHandle;ushort LengthSearchPaths;ushort MaxLengthSearchPaths;ptr SearchPaths;ushort LengthApplicationName;ushort MaxLengthApplicationName;ptr ApplicationName;ushort LengthCommandLine;ushort MaxLengthCommandLine;ptr CommandLine;ptr EnvironmentBlock;ulong Unknown[9];ushort LengthUnknown3;ushort MaxLengthUnknown3;ptr Unknown3;ushort LengthUnknown4;ushort MaxLengthUnknown4;ptr Unknown4;ushort LengthUnknown5;ushort MaxLengthUnknown5;ptr Unknown5')
	Local $tDIR

	Do
		$aRet = DllCall('ntdll.dll', 'long', 'NtQueryInformationProcess', 'handle', $hProcess, 'ulong', 0, 'struct*', $tPBI, _
				'ulong', DllStructGetSize($tPBI), 'ulong*', 0)
		If @error Or ($aRet[0]) Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tPBI, 'PebBaseAddress'), 'struct*', $tPEB, _
				'ulong_ptr', DllStructGetSize($tPEB), 'ulong_ptr*', 0)
		If @error Or (Not $aRet[0]) Or (Not $aRet[5]) Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tPEB, 'ProcessParameters'), 'struct*', $tUPP, _
				'ulong_ptr', DllStructGetSize($tUPP), 'ulong_ptr*', 0)
		If @error Or (Not $aRet[0]) Or (Not $aRet[5]) Then
			$iError = @error + 40
			ExitLoop
		EndIf
		$tDIR = DllStructCreate('byte[' & DllStructGetData($tUPP, 'MaxLengthCurrentDirectory') & ']')
		If @error Then
			$iError = @error + 50
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tUPP, 'CurrentDirectory'), 'struct*', $tDIR, _
				'ulong_ptr', DllStructGetSize($tDIR), 'ulong_ptr*', 0)
		If @error Or (Not $aRet[0]) Or (Not $aRet[5]) Then
			$iError = @error + 60
			ExitLoop
		EndIf
		$iError = 0
	Until 1
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	If $iError Then Return SetError($iError, 0, '')

	Return _WinAPI_PathRemoveBackslash(_WinAPI_GetString(DllStructGetPtr($tDIR)))
EndFunc   ;==>_WinAPI_GetProcessWorkingDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetThreadDesktop($iThreadId)
	Local $aRet = DllCall('user32.dll', 'handle', 'GetThreadDesktop', 'dword', $iThreadId)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThreadDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThreadErrorMode()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetThreadErrorMode')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThreadErrorMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowFileName($hWnd)
	Local $iPID = 0

	Local $aResult = DllCall("user32.dll", "bool", "IsWindow", "hwnd", $hWnd)
	If $aResult[0] Then
		$aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
		$iPID = $aResult[2]
	EndIf
	If Not $iPID Then Return SetError(1, 0, '')

	Local $sResult = _WinAPI_GetProcessFileName($iPID)
	If @error Then Return SetError(@error, @extended, '')

	Return $sResult
EndFunc   ;==>_WinAPI_GetWindowFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsElevated()
	Local $iElev, $aRet, $iError = 0

	Local $hToken = _WinAPI_OpenProcessToken(0x0008)
	If Not $hToken Then Return SetError(@error + 10, @extended, False)

	Do
		$aRet = DllCall('advapi32.dll', 'bool', 'GetTokenInformation', 'handle', $hToken, 'uint', 20, 'uint*', 0, 'dword', 4, _
				'dword*', 0) ; TOKEN_ELEVATION
		If @error Or Not $aRet[0] Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$iElev = $aRet[3]
		$aRet = DllCall('advapi32.dll', 'bool', 'GetTokenInformation', 'handle', $hToken, 'uint', 18, 'uint*', 0, 'dword', 4, _
				'dword*', 0) ; TOKEN_ELEVATION_TYPE
		If @error Or Not $aRet[0] Then
			$iError = @error + 20
			ExitLoop
		EndIf
	Until 1
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
	If $iError Then Return SetError($iError, 0, False)

	Return SetExtended($aRet[0] - 1, $iElev)
EndFunc   ;==>_WinAPI_IsElevated

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_IsProcessInJob($hProcess, $hJob = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsProcessInJob', 'handle', $hProcess, 'handle', $hJob, 'bool*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_IsProcessInJob

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenJobObject($sName, $iAccess = $JOB_OBJECT_ALL_ACCESS, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenJobObjectW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenJobObject

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenMutex($sMutex, $iAccess = $MUTEX_ALL_ACCESS, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenMutexW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sMutex)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenMutex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
	; Attempt to open process with standard security priviliges
	Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return $aResult[0]
	If Not $bDebugPriv Then Return SetError(100, 0, 0)

	; Enable debug privileged mode
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error + 10, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iError = @error
	Local $iExtended = @extended
	Local $iRet = 0
	If Not @error Then
		; Attempt to open process with debug privileges
		$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
		$iError = @error
		$iExtended = @extended
		If $aResult[0] Then $iRet = $aResult[0]

		; Disable debug privileged mode
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
		If @error Then
			$iError = @error + 20
			$iExtended = @extended
		EndIf
	Else
		$iError = @error + 30 ; SeDebugPrivilege=True error
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)

	Return SetError($iError, $iExtended, $iRet)
EndFunc   ;==>_WinAPI_OpenProcess

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenProcessToken($iAccess, $hProcess = 0)
	If Not $hProcess Then
		$hProcess = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
		$hProcess = $hProcess[0]
	EndIf

	Local $aRet = DllCall('advapi32.dll', 'bool', 'OpenProcessToken', 'handle', $hProcess, 'dword', $iAccess, 'handle*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_OpenProcessToken

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenSemaphore($sSemaphore, $iAccess = 0x001F0003, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenSemaphoreW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sSemaphore)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenSemaphore

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_QueryInformationJobObject($hJob, $iJobObjectInfoClass, ByRef $tJobObjectInfo)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'QueryInformationJobObject', 'handle', $hJob, 'int', $iJobObjectInfoClass, _
			'struct*', $tJobObjectInfo, 'dword', DllStructGetSize($tJobObjectInfo), 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_QueryInformationJobObject

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ReleaseMutex($hMutex)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ReleaseMutex', 'handle', $hMutex)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ReleaseMutex

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ReleaseSemaphore($hSemaphore, $iIncrease = 1)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ReleaseSemaphore', 'handle', $hSemaphore, 'long', $iIncrease, 'long*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_ReleaseSemaphore

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ResetEvent($hEvent)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ResetEvent', 'handle', $hEvent)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ResetEvent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetEvent($hEvent)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetEvent", "handle", $hEvent)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetEvent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetInformationJobObject($hJob, $iJobObjectInfoClass, $tJobObjectInfo)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetInformationJobObject', 'handle', $hJob, 'int', $iJobObjectInfoClass, _
			'struct*', $tJobObjectInfo, 'dword', DllStructGetSize($tJobObjectInfo))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetInformationJobObject

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_SetPriorityClass($iPriority, $iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000600 : 0x00001200), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $hProcess[0] Then Return SetError(1000, 0, 0)

	Local $iError = 0
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetPriorityClass', 'handle', $hProcess[0], 'dword', $iPriority)
	If @error Then $iError = @error
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
	If $iError Then Return SetError($iError, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetPriorityClass

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetProcessAffinityMask($hProcess, $iMask)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetProcessAffinityMask", "handle", $hProcess, "ulong_ptr", $iMask)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetProcessAffinityMask

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetThreadDesktop($hDesktop)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetThreadDesktop', 'handle', $hDesktop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetThreadDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetThreadErrorMode($iMode)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetThreadErrorMode', 'dword', $iMode, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_SetThreadErrorMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetThreadExecutionState($iFlags)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'SetThreadExecutionState', 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetThreadExecutionState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TerminateJobObject($hJob, $iExitCode = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'TerminateJobObject', 'handle', $hJob, 'uint', $iExitCode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TerminateJobObject

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TerminateProcess($hProcess, $iExitCode = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'TerminateProcess', 'handle', $hProcess, 'uint', $iExitCode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TerminateProcess

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UserHandleGrantAccess($hObject, $hJob, $bGrant)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'UserHandleGrantAccess', 'handle', $hObject, 'handle', $hJob, 'bool', $bGrant)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UserHandleGrantAccess

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WaitForInputIdle($hProcess, $iTimeout = -1)
	Local $aResult = DllCall("user32.dll", "dword", "WaitForInputIdle", "handle", $hProcess, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WaitForInputIdle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WaitForMultipleObjects($iCount, $paHandles, $bWaitAll = False, $iTimeout = -1)
	Local $aResult = DllCall("kernel32.dll", "INT", "WaitForMultipleObjects", "dword", $iCount, "struct*", $paHandles, "bool", $bWaitAll, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WaitForMultipleObjects

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WaitForSingleObject($hHandle, $iTimeout = -1)
	Local $aResult = DllCall("kernel32.dll", "INT", "WaitForSingleObject", "handle", $hHandle, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WaitForSingleObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WriteConsole($hConsole, $sText)
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteConsoleW", "handle", $hConsole, "wstr", $sText, _
			"dword", StringLen($sText), "dword*", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WriteConsole

#EndRegion Public Functions
