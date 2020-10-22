#include-once

#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIMem.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_hHeap = 0
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CreateBuffer
; _WinAPI_CreateBufferFromStruct
; _WinAPI_CreateString
; _WinAPI_EqualMemory
; _WinAPI_FillMemory
; _WinAPI_FreeMemory
; _WinAPI_GetMemorySize
; _WinAPI_GlobalMemoryStatus
; _WinAPI_IsBadCodePtr
; _WinAPI_IsBadReadPtr
; _WinAPI_IsBadStringPtr
; _WinAPI_IsBadWritePtr
; _WinAPI_IsMemory
; _WinAPI_LocalFree
; _WinAPI_MoveMemory
; _WinAPI_ReadProcessMemory
; _WinAPI_WriteProcessMemory
; _WinAPI_ZeroMemory
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __HeapAlloc
; __HeapFree
; __HeapReAlloc
; __HeapSize
; __HeapValidate
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateBuffer($iLength, $pBuffer = 0, $bAbort = True)
	$pBuffer = __HeapReAlloc($pBuffer, $iLength, 0, $bAbort)
	If @error Then Return SetError(@error, @extended, 0)

	Return $pBuffer
EndFunc   ;==>_WinAPI_CreateBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateBufferFromStruct($tStruct, $pBuffer = 0, $bAbort = True)
	If Not IsDllStruct($tStruct) Then Return SetError(1, 0, 0)

	$pBuffer = __HeapReAlloc($pBuffer, DllStructGetSize($tStruct), 0, $bAbort)
	If @error Then Return SetError(@error + 100, @extended, 0)

	_WinAPI_MoveMemory($pBuffer, $tStruct, DllStructGetSize($tStruct))
	; Local $iError = @error	; cannot really occur
	; __HeapFree($pBuffer)
	; Return SetError($iError, 0, 0)
	; EndIf

	Return $pBuffer
EndFunc   ;==>_WinAPI_CreateBufferFromStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateString($sString, $pString = 0, $iLength = -1, $bUnicode = True, $bAbort = True)
	$iLength = Number($iLength)
	If $iLength >= 0 Then
		$sString = StringLeft($sString, $iLength)
	Else
		$iLength = StringLen($sString)
	EndIf
	Local $iSize = $iLength + 1
	If $bUnicode Then
		$iSize *= 2
	EndIf
	$pString = __HeapReAlloc($pString, $iSize, 0, $bAbort)
	If @error Then Return SetError(@error, @extended, 0)

	DllStructSetData(DllStructCreate(($bUnicode ? 'wchar' : 'char') & '[' & ($iLength + 1) & ']', $pString), 1, $sString)
	Return SetExtended($iLength, $pString)
EndFunc   ;==>_WinAPI_CreateString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EqualMemory($pSource1, $pSource2, $iLength)
	If _WinAPI_IsBadReadPtr($pSource1, $iLength) Then Return SetError(11, @extended, 0)
	If _WinAPI_IsBadReadPtr($pSource2, $iLength) Then Return SetError(12, @extended, 0)

	Local $aRet = DllCall('ntdll.dll', 'ulong_ptr', 'RtlCompareMemory', 'struct*', $pSource1, 'struct*', $pSource2, 'ulong_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return Number($aRet[0] = $iLength)
EndFunc   ;==>_WinAPI_EqualMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FillMemory($pMemory, $iLength, $iValue = 0)
	If _WinAPI_IsBadWritePtr($pMemory, $iLength) Then Return SetError(11, @extended, 0)

	DllCall('ntdll.dll', 'none', 'RtlFillMemory', 'struct*', $pMemory, 'ulong_ptr', $iLength, 'byte', $iValue)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_FillMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FreeMemory($pMemory)
	If Not __HeapFree($pMemory, 1) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_FreeMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetMemorySize($pMemory)
	Local $iResult = __HeapSize($pMemory, 1)
	If @error Then Return SetError(@error, @extended, 0)

	Return $iResult
EndFunc   ;==>_WinAPI_GetMemorySize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GlobalMemoryStatus()
	Local Const $tagMEMORYSTATUSEX = "dword Length;dword MemoryLoad;" & _
			"uint64 TotalPhys;uint64 AvailPhys;uint64 TotalPageFile;uint64 AvailPageFile;" & _
			"uint64 TotalVirtual;uint64 AvailVirtual;uint64 AvailExtendedVirtual"

	Local $tMem = DllStructCreate($tagMEMORYSTATUSEX)
	DllStructSetData($tMem, 1, DllStructGetSize($tMem))
	Local $aRet = DllCall("kernel32.dll", "bool", "GlobalMemoryStatusEx", "struct*", $tMem)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aMem[7]
	$aMem[0] = DllStructGetData($tMem, 2)
	$aMem[1] = DllStructGetData($tMem, 3)
	$aMem[2] = DllStructGetData($tMem, 4)
	$aMem[3] = DllStructGetData($tMem, 5)
	$aMem[4] = DllStructGetData($tMem, 6)
	$aMem[5] = DllStructGetData($tMem, 7)
	$aMem[6] = DllStructGetData($tMem, 8)
	Return $aMem
EndFunc   ;==>_WinAPI_GlobalMemoryStatus

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadCodePtr($pAddress)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadCodePtr', 'struct*', $pAddress)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadCodePtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadReadPtr($pAddress, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadReadPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadReadPtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadStringPtr($pAddress, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadStringPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadStringPtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadWritePtr($pAddress, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadWritePtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadWritePtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_IsMemory($pMemory)
	Local $bResult = __HeapValidate($pMemory)

	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_WinAPI_IsMemory

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LocalFree($hMemory)
	Local $aResult = DllCall("kernel32.dll", "handle", "LocalFree", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LocalFree

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_MoveMemory($pDestination, $pSource, $iLength)
	If _WinAPI_IsBadReadPtr($pSource, $iLength) Then Return SetError(10, @extended, 0)
	If _WinAPI_IsBadWritePtr($pDestination, $iLength) Then Return SetError(11, @extended, 0)

	DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'struct*', $pDestination, 'struct*', $pSource, 'ulong_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_MoveMemory

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ReadProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iRead)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $hProcess, _
			"ptr", $pBaseAddress, "struct*", $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)

	$iRead = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReadProcessMemory

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WriteProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iWritten, $sBuffer = "ptr")
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", $hProcess, "ptr", $pBaseAddress, _
			$sBuffer, $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)

	$iWritten = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_WriteProcessMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ZeroMemory($pMemory, $iLength)
	If _WinAPI_IsBadWritePtr($pMemory, $iLength) Then Return SetError(11, @extended, 0)

	DllCall('ntdll.dll', 'none', 'RtlZeroMemory', 'struct*', $pMemory, 'ulong_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ZeroMemory

#EndRegion Public Functions

#Region Internal Functions

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapAlloc
; Description ...:
; Syntax ........: __HeapAlloc($iSize[, $bAbort = False])
; Parameters ....: $iSize               - An integer value.
;                  $bAbort              - [optional] Abort the script if error. Default is False.
; Return values .: Success - a pointer to the allocated memory block
;                  Failure - Set the @error flag to 30+
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapAlloc
; Example .......:
; ===============================================================================================================================
Func __HeapAlloc($iSize, $bAbort = False)
	Local $aRet
	If Not $__g_hHeap Then
		$aRet = DllCall('kernel32.dll', 'handle', 'HeapCreate', 'dword', 0, 'ulong_ptr', 0, 'ulong_ptr', 0)
		If @error Or Not $aRet[0] Then __FatalExit(1, 'Error allocating memory.')
		$__g_hHeap = $aRet[0]
	EndIf

	$aRet = DllCall('kernel32.dll', 'ptr', 'HeapAlloc', 'handle', $__g_hHeap, 'dword', 0x00000008, 'ulong_ptr', $iSize) ; HEAP_ZERO_MEMORY
	If @error Or Not $aRet[0] Then
		If $bAbort Then __FatalExit(1, 'Error allocating memory.')
		Return SetError(@error + 30, @extended, 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>__HeapAlloc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapFree
; Description ...:
; Syntax ........: __HeapFree(Byref $pMemory[, $bCheck = False])
; Parameters ....: $pMemory             - [in/out] A pointer value.
;                  $bCheck              - [optional] Check valid pointer. Default is False (see remarks).
; Return values .: Success - 1.
;                  Failure - Set the @error flag to 1 to 9 or 40+
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......: @error and @extended are preserved when return if no error
; Related .......:
; Link ..........: @@MsdnLink@@ HeapFree
; Example .......: No
; ===============================================================================================================================
Func __HeapFree(ByRef $pMemory, $bCheck = False, $iCurErr = @error, $iCurExt = @extended)
	If $bCheck And (Not __HeapValidate($pMemory)) Then Return SetError(@error, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'int', 'HeapFree', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
	If @error Or Not $aRet[0] Then Return SetError(@error + 40, @extended, 0)

	$pMemory = 0
	Return SetError($iCurErr, $iCurExt, 1)
EndFunc   ;==>__HeapFree

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapReAlloc
; Description ...:
; Syntax ........: __HeapReAlloc($pMemory, $iSize[, $bAmount = 0[, $bAbort = 0]])
; Parameters ....: $pMemory             - A pointer value.
;                  $iSize               - An integer value.
;                  $bAmount             - [optional] A boolean value. Default is False.
;                  $bAbort              - [optional] A boolean value. Default is False.
; Return values .: Success -  a pointer to the allocated memory bloc
;                  Failure - 0 and sets the @error flag to 1 to 20+ or 30+ if no previous allocation
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapReAlloc
; Example .......: No
; ===============================================================================================================================
Func __HeapReAlloc($pMemory, $iSize, $bAmount = False, $bAbort = False)
	Local $aRet, $pRet
	If __HeapValidate($pMemory) Then
		If $bAmount And (__HeapSize($pMemory) >= $iSize) Then Return SetExtended(1, Ptr($pMemory))

		$aRet = DllCall('kernel32.dll', 'ptr', 'HeapReAlloc', 'handle', $__g_hHeap, 'dword', 0x00000008, 'ptr', $pMemory, _
				'ulong_ptr', $iSize) ; HEAP_ZERO_MEMORY
		If @error Or Not $aRet[0] Then
			If $bAbort Then __FatalExit(1, 'Error allocating memory.')
			Return SetError(@error + 20, @extended, Ptr($pMemory))
		EndIf
		$pRet = $aRet[0]
	Else
		$pRet = __HeapAlloc($iSize, $bAbort)
		If @error Then Return SetError(@error, @extended, 0)
	EndIf
	Return $pRet
EndFunc   ;==>__HeapReAlloc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapSize
; Description ...:
; Syntax ........: __HeapSize($pMemory[, $bCheck = False])
; Parameters ....: $pMemory             - A pointer value.
;                  $bCheck              - [optional] A boolean value. Default is False.
; Return values .: Success - the requested size of the allocated memory block, in bytes.
;                  Failure - 0 and sets the @error flag to 1 to 9 or 50+
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapSize
; Example .......:
; ===============================================================================================================================
Func __HeapSize($pMemory, $bCheck = False)
	If $bCheck And (Not __HeapValidate($pMemory)) Then Return SetError(@error, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'ulong_ptr', 'HeapSize', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
	If @error Or ($aRet[0] = Ptr(-1)) Then Return SetError(@error + 50, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>__HeapSize

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapValidate
; Description ...:
; Syntax ........: __HeapValidate($pMemory)
; Parameters ....: $pMemory             - A pointer value.
; Return values .: Success - True.
;                  Failure - False and sets the @error flag to 1 to 9.
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapValidate
; Example .......:
; ===============================================================================================================================
Func __HeapValidate($pMemory)
	If (Not $__g_hHeap) Or (Not Ptr($pMemory)) Then Return SetError(9, 0, False)

	Local $aRet = DllCall('kernel32.dll', 'int', 'HeapValidate', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
	If @error Then Return SetError(@error, @extended, False)
	Return $aRet[0]
EndFunc   ;==>__HeapValidate

#EndRegion Internal Functions
