#include-once

#include "MemoryConstants.au3"
#include "ProcessConstants.au3"
#include "Security.au3"
#include "StructureConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Memory
; AutoIt Version : 3.3.14.5
; Description ...: Functions that assist with Memory management.
;                  The memory manager implements virtual memory, provides a core set of services such  as  memory  mapped  files,
;                  copy-on-write memory, large memory support, and underlying support for the cache manager.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
;
; Used by GUI UDF not to be documented
;
; _MemFree
; _MemInit
; _MemRead
; _MemWrite
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _MemGlobalAlloc
; _MemGlobalFree
; _MemGlobalLock
; _MemGlobalSize
; _MemGlobalUnlock
; _MemMoveMemory
; _MemVirtualAlloc
; _MemVirtualAllocEx
; _MemVirtualFree
; _MemVirtualFreeEx
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagMEMMAP
; __Mem_OpenProcess
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagMEMMAP
; Description ...: Contains information about the memory
; Fields ........: hProc - Handle to the external process
;                  Size  - Size, in bytes, of the memory block allocated
;                  Mem   - Pointer to the memory block
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _MemFree
; Description ...: Releases a memory map structure for a control
; Syntax.........: _MemFree ( ByRef $tMemMap )
; Parameters ....: $tMemMap     - tagMEMMAP structure
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by Auto3Lib and should not normally be called
; Related .......: _MemInit
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _MemFree(ByRef $tMemMap)
	Local $pMemory = DllStructGetData($tMemMap, "Mem")
	Local $hProcess = DllStructGetData($tMemMap, "hProc")
	Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	If @error Then Return SetError(@error, @extended, False)
	Return $bResult
EndFunc   ;==>_MemFree

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemGlobalAlloc($iBytes, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $iFlags, "ulong_ptr", $iBytes)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalAlloc

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemGlobalFree($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalFree", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalFree

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemGlobalLock($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalLock

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemGlobalSize($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ulong_ptr", "GlobalSize", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemGlobalUnlock($hMemory)
	Local $aResult = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalUnlock

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _MemInit
; Description ...: Initializes a tagMEMMAP structure for a control
; Syntax.........: _MemInit ( $hWnd, $iSize, ByRef $tMemMap )
; Parameters ....: $hWnd        - Window handle of the process where memory will be mapped
;                  $iSize       - Size, in bytes, of memory space to map
;                  $tMemMap     - tagMEMMAP structure that will be initialized
; Return values .: Success      - Pointer to reserved memory block
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by Auto3Lib and should not normally be called
; Related .......: _MemFree
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
	Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	If @error Then Return SetError(@error + 10, @extended, 0)
	Local $iProcessID = $aResult[2]
	If $iProcessID = 0 Then Return SetError(1, 0, 0) ; Invalid window handle

	Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
	Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
	Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
	Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)

	If $pMemory = 0 Then Return SetError(2, 0, 0) ; Unable to allocate memory

	$tMemMap = DllStructCreate($tagMEMMAP)
	DllStructSetData($tMemMap, "hProc", $hProcess)
	DllStructSetData($tMemMap, "Size", $iSize)
	DllStructSetData($tMemMap, "Mem", $pMemory)
	Return $pMemory
EndFunc   ;==>_MemInit

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemMoveMemory($pSource, $pDest, $iLength)
	DllCall("kernel32.dll", "none", "RtlMoveMemory", "struct*", $pDest, "struct*", $pSource, "ulong_ptr", $iLength)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_MemMoveMemory

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _MemRead
; Description ...: Transfer memory from external address space to internal address space
; Syntax.........: _MemRead ( ByRef $tMemMap, $pSrce, $pDest, $iSize )
; Parameters ....: $tMemMap     - tagMEMMAP structure
;                  $pSrce       - Pointer to external memory
;                  $pDest       - Pointer to internal memory
;                  $iSize       - Size in bytes of memory to read
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by Auto3Lib and should not normally be called
; Related .......: _MemWrite
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemRead

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _MemWrite
; Description ...: Transfer memory to external address space from internal address space
; Syntax.........: _MemWrite ( ByRef $tMemMap, $pSrce [, $pDest = 0 [, $iSize = 0 [, $sSrce = "ptr"]]] )
; Parameters ....: $tMemMap     - tagMEMMAP structure
;                  $pSrce       - Pointer to internal memory
;                  $pDest       - Pointer to external memory
;                  $iSize       - Size in bytes of memory to write
;                  $sSrce       - Contains the data type for $pSrce
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by Auto3Lib and should not normally be called
; Related .......: _MemRead
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
	If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
	If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemWrite

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemVirtualAlloc($pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualAlloc

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualAllocEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemVirtualFree($pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualFree

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualFreeEx

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Mem_OpenProcess
; Description ...: Returns a handle of an existing process object
; Syntax.........: _WinAPI_OpenProcess ( $iAccess, $bInherit, $iProcessID [, $bDebugPriv = False] )
; Parameters ....: $iAccess     - Specifies the access to the process object
;                  $bInherit    - Specifies whether the returned handle can be inherited
;                  $iPID        - Specifies the process identifier of the process to open
;                  $bDebugPriv  - Certain system processes can not be opened unless you have the  debug  security  privilege.  If
;                  +True, this function will attempt to open the process with debug priviliges if the process can not  be  opened
;                  +with standard access privileges.
; Return values .: Success      - Process handle to the object
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ OpenProcess
; Example .......:
; ===============================================================================================================================
Func __Mem_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
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
EndFunc   ;==>__Mem_OpenProcess
