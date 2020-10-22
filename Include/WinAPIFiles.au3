#include-once

#include "APIFilesConstants.au3"
#include "FileConstants.au3"
#include "WinAPIConv.au3"
#include "WinAPIError.au3"
#include "WinAPIMem.au3"
#include "WinAPIMisc.au3"
#include "WinAPIShPath.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIFiles.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_iHeapSize = 8388608
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagFILEINFO = 'uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;uint64 ChangeTime;dword Attributes'
Global Const $tagFILE_ID_DESCRIPTOR = 'dword Size;uint Type;' & $tagGUID
Global Const $tagWIN32_FIND_STREAM_DATA = 'int64 StreamSize;wchar StreamName[296]'
Global Const $tagWIN32_STREAM_ID = 'dword StreamId;dword StreamAttributes;int64 Size;dword StreamNameSize;wchar StreamName[1]'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_BackupRead
; _WinAPI_BackupReadAbort
; _WinAPI_BackupSeek
; _WinAPI_BackupWrite
; _WinAPI_BackupWriteAbort
; _WinAPI_CopyFileEx
; _WinAPI_CreateDirectory
; _WinAPI_CreateDirectoryEx
; _WinAPI_CreateFileEx
; _WinAPI_CreateFileMapping
; _WinAPI_CreateHardLink
; _WinAPI_CreateObjectID
; _WinAPI_CreateSymbolicLink
; _WinAPI_DecryptFile
; _WinAPI_DefineDosDevice
; _WinAPI_DeleteFile
; _WinAPI_DeleteObjectID
; _WinAPI_DeleteVolumeMountPoint
; _WinAPI_DeviceIoControl
; _WinAPI_DuplicateEncryptionInfoFile
; _WinAPI_EjectMedia
; _WinAPI_EncryptFile
; _WinAPI_EncryptionDisable
; _WinAPI_EnumFiles
; _WinAPI_EnumFileStreams
; _WinAPI_EnumHardLinks
; _WinAPI_FileEncryptionStatus
; _WinAPI_FileExists
; _WinAPI_FileInUse
; _WinAPI_FindClose
; _WinAPI_FindCloseChangeNotification
; _WinAPI_FindFirstChangeNotification
; _WinAPI_FindFirstFile
; _WinAPI_FindFirstFileName
; _WinAPI_FindFirstStream
; _WinAPI_FindNextChangeNotification
; _WinAPI_FindNextFile
; _WinAPI_FindNextFileName
; _WinAPI_FindNextStream
; _WinAPI_FlushFileBuffers
; _WinAPI_FlushViewOfFile
; _WinAPI_GetBinaryType
; _WinAPI_GetCDType
; _WinAPI_GetCompressedFileSize
; _WinAPI_GetCompression
; _WinAPI_GetCurrentDirectory
; _WinAPI_GetDiskFreeSpaceEx
; _WinAPI_GetDriveBusType
; _WinAPI_GetDriveGeometryEx
; _WinAPI_GetDriveNumber
; _WinAPI_GetDriveType
; _WinAPI_GetFileAttributes
; _WinAPI_GetFileID
; _WinAPI_GetFileInformationByHandle
; _WinAPI_GetFileInformationByHandleEx
; _WinAPI_GetFilePointerEx
; _WinAPI_GetFileSizeEx
; _WinAPI_GetFileSizeOnDisk
; _WinAPI_GetFileTitle
; _WinAPI_GetFileType
; _WinAPI_GetFinalPathNameByHandle
; _WinAPI_GetFinalPathNameByHandleEx
; _WinAPI_GetFullPathName
; _WinAPI_GetLogicalDrives
; _WinAPI_GetObjectID
; _WinAPI_GetOverlappedResult
; _WinAPI_GetPEType
; _WinAPI_GetProfilesDirectory
; _WinAPI_GetTempFileName
; _WinAPI_GetVolumeInformation
; _WinAPI_GetVolumeInformationByHandle
; _WinAPI_GetVolumeNameForVolumeMountPoint
; _WinAPI_IOCTL
; _WinAPI_IsDoorOpen
; _WinAPI_IsPathShared
; _WinAPI_IsWritable
; _WinAPI_LoadMedia
; _WinAPI_LockDevice
; _WinAPI_LockFile
; _WinAPI_MapViewOfFile
; _WinAPI_MoveFileEx
; _WinAPI_OpenFileById
; _WinAPI_OpenFileMapping
; _WinAPI_PathIsDirectoryEmpty
; _WinAPI_QueryDosDevice
; _WinAPI_ReadDirectoryChanges
; _WinAPI_RemoveDirectory
; _WinAPI_ReOpenFile
; _WinAPI_ReplaceFile
; _WinAPI_SearchPath
; _WinAPI_SetCompression
; _WinAPI_SetCurrentDirectory
; _WinAPI_SetEndOfFile
; _WinAPI_SetFileAttributes
; _WinAPI_SetFileInformationByHandleEx
; _WinAPI_SetFilePointer
; _WinAPI_SetFilePointerEx
; _WinAPI_SetFileShortName
; _WinAPI_SetFileValidData
; _WinAPI_SetSearchPathMode
; _WinAPI_SetVolumeMountPoint
; _WinAPI_SfcIsFileProtected
; _WinAPI_UnlockFile
; _WinAPI_UnmapViewOfFile
; _WinAPI_Wow64EnableWow64FsRedirection
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BackupRead($hFile, $pBuffer, $iLength, ByRef $iBytes, ByRef $pContext, $bSecurity = False)
	$iBytes = 0

	Local $aRet = DllCall('kernel32.dll', 'bool', 'BackupRead', 'handle', $hFile, 'struct*', $pBuffer, 'dword', $iLength, _
			'dword*', 0, 'bool', 0, 'bool', $bSecurity, 'ptr*', $pContext)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	$iBytes = $aRet[4]
	$pContext = $aRet[7]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_BackupRead

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BackupReadAbort(ByRef $pContext)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'BackupRead', 'handle', 0, 'ptr', 0, 'dword', 0, 'dword*', 0, 'bool', 1, _
			'bool', 0, 'ptr*', $pContext)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	$pContext = $aRet[7]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_BackupReadAbort

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BackupSeek($hFile, $iSeek, ByRef $iBytes, ByRef $pContext)
	$iBytes = 0

	Local $aRet = DllCall('kernel32.dll', 'bool', 'BackupSeek', 'handle', $hFile, 'dword', _WinAPI_LoDWord($iSeek), _
			'dword', _WinAPI_HiDWord($iSeek), 'dword*', 0, 'dword*', 0, 'ptr*', $pContext)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	$iBytes = __WinAPI_MakeQWord($aRet[4], $aRet[5])
	$pContext = $aRet[6]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_BackupSeek

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BackupWrite($hFile, $pBuffer, $iLength, ByRef $iBytes, ByRef $pContext, $bSecurity = False)
	$iBytes = 0

	Local $aRet = DllCall('kernel32.dll', 'bool', 'BackupWrite', 'handle', $hFile, 'struct*', $pBuffer, 'dword', $iLength, _
			'dword*', 0, 'bool', 0, 'bool', $bSecurity, 'ptr*', $pContext)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	$iBytes = $aRet[4]
	$pContext = $aRet[7]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_BackupWrite

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BackupWriteAbort(ByRef $pContext)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'BackupWrite', 'handle', 0, 'ptr', 0, 'dword', 0, 'dword*', 0, 'bool', 1, _
			'bool', 0, 'ptr*', $pContext)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	$pContext = $aRet[7]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_BackupWriteAbort

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CopyFileEx($sExistingFile, $sNewFile, $iFlags = 0, $pProgressProc = 0, $pData = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'CopyFileExW', 'wstr', $sExistingFile, 'wstr', $sNewFile, _
			'ptr', $pProgressProc, 'struct*', $pData, 'bool*', 0, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CopyFileEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateDirectory($sDir, $tSecurity = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'CreateDirectoryW', 'wstr', $sDir, 'struct*', $tSecurity)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateDirectoryEx($sNewDir, $sTemplateDir, $tSecurity = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'CreateDirectoryExW', 'wstr', $sTemplateDir, 'wstr', $sNewDir, 'struct*', $tSecurity)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateDirectoryEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateFileEx($sFilePath, $iCreation, $iAccess = 0, $iShare = 0, $iFlagsAndAttributes = 0, $tSecurity = 0, $hTemplate = 0)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateFileW', 'wstr', $sFilePath, 'dword', $iAccess, 'dword', $iShare, _
			'struct*', $tSecurity, 'dword', $iCreation, 'dword', $iFlagsAndAttributes, 'handle', $hTemplate)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = Ptr(-1) Then Return SetError(10, _WinAPI_GetLastError(), 0) ; $INVALID_HANDLE_VALUE

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateFileEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_CreateFileMapping($hFile, $iSize = 0, $sName = '', $iProtect = 0x0004, $tSecurity = 0)
	Local $sTypeOfName = 'wstr'
	If Not StringStripWS($sName, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfName = 'ptr'
		$sName = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateFileMappingW', 'handle', $hFile, 'struct*', $tSecurity, _
			'dword', $iProtect, 'dword', _WinAPI_HiDWord($iSize), 'dword', _WinAPI_LoDWord($iSize), _
			$sTypeOfName, $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return SetExtended(_WinAPI_GetLastError(), $aRet[0]) ; ERROR_ALREADY_EXISTS
EndFunc   ;==>_WinAPI_CreateFileMapping

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateHardLink($sNewFile, $sExistingFile)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'CreateHardLinkW', 'wstr', $sNewFile, 'wstr', $sExistingFile, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateHardLink

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateObjectID($sFilePath)
	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $tFOID = DllStructCreate('byte[16];byte[48]')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x000900C0, 'ptr', 0, _
			'dword', 0, 'struct*', $tFOID, 'dword', DllStructGetSize($tFOID), 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Local $tGUID = DllStructCreate($tagGUID)
	_WinAPI_MoveMemory($tGUID, $tFOID, 16)
	; Return SetError(3, 0, 0) ; cannot really occur
	; EndIf
	Return $tGUID
EndFunc   ;==>_WinAPI_CreateObjectID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_CreateSymbolicLink($sSymlink, $sTarget, $bDirectory = False)
	If $bDirectory Then
		$bDirectory = 1
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'boolean', 'CreateSymbolicLinkW', 'wstr', $sSymlink, 'wstr', $sTarget, 'dword', $bDirectory)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateSymbolicLink

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DecryptFile($sFilePath)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'DecryptFileW', 'wstr', $sFilePath, 'dword', 0)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DecryptFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DefineDosDevice($sDevice, $iFlags, $sFilePath = '')
	Local $sTypeOfPath = 'wstr'
	If Not StringStripWS($sFilePath, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfPath = 'ptr'
		$sFilePath = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DefineDosDeviceW', 'dword', $iFlags, 'wstr', $sDevice, $sTypeOfPath, $sFilePath)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DefineDosDevice

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DeleteFile($sFilePath)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeleteFileW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeleteFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DeleteObjectID($sFilePath)
	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, $GENERIC_WRITE, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x000900A0, 'ptr', 0, _
			'dword', 0, 'ptr', 0, 'dword', 0, 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DeleteObjectID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DeleteVolumeMountPoint($sMountedPath)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeleteVolumeMountPointW', 'wstr', $sMountedPath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeleteVolumeMountPoint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DeviceIoControl($hDevice, $iControlCode, $pInBuffer = 0, $iInBufferSize = 0, $pOutBuffer = 0, $iOutBufferSize = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hDevice, 'dword', $iControlCode, _
			'struct*', $pInBuffer, 'dword', $iInBufferSize, 'struct*', $pOutBuffer, 'dword', $iOutBufferSize, _
			'dword*', 0, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return SetExtended($aRet[7], $aRet[0])
EndFunc   ;==>_WinAPI_DeviceIoControl

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DuplicateEncryptionInfoFile($sSrcFilePath, $sDestFilePath, $iCreation = 2, $iAttributes = 0, $tSecurity = 0)
	Local $aRet = DllCall('advapi32.dll', 'dword', 'DuplicateEncryptionInfoFile', 'wstr', $sSrcFilePath, 'wstr', $sDestFilePath, _
			'dword', $iCreation, 'dword', $iAttributes, 'struct*', $tSecurity)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DuplicateEncryptionInfoFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EjectMedia($sDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, $GENERIC_READ, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x002D4808, 'ptr', 0, _
			'dword', 0, 'ptr', 0, 'dword', 0, 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_EjectMedia

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_EncryptFile($sFilePath)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'EncryptFileW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EncryptFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_EncryptionDisable($sDir, $bDisable)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'EncryptionDisable', 'wstr', $sDir, 'bool', $bDisable)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EncryptionDisable

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumFiles($sDir, $iFlag = 0, $sTemplate = '', $bExclude = False)
	Local $aRet = 0, $iError = 0
	Local $aData[501][7] = [[0]]

	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hDir = _WinAPI_CreateFileEx($sDir, $OPEN_EXISTING, 0x00000001, $FILE_SHARE_ANY, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $pBuffer = __HeapAlloc($__g_iHeapSize)
	If @error Then
		$iError = @error
	Else
		Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
		$aRet = DllCall('ntdll.dll', 'uint', 'ZwQueryDirectoryFile', 'handle', $hDir, 'ptr', 0, 'ptr', 0, 'ptr', 0, _
				'struct*', $tIOSB, 'struct*', $pBuffer, 'ulong', 8388608, 'uint', 1, 'boolean', 0, 'ptr', 0, 'boolean', 1)
		If @error Or $aRet[0] Then
			$iError = @error + 40
		EndIf
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hDir)
	If $iError Then
		__HeapFree($pBuffer, 1)
		If IsArray($aRet) Then
			Return SetError(10, $aRet[0], 0)
		Else
			Return SetError($iError, 0, 0)
		EndIf
	EndIf

	Local $tFDI, $iAttrib, $sTarget, $iLength = 0, $iOffset = 0
	Do
		$iLength += $iOffset
		$tFDI = DllStructCreate('ulong;ulong;int64;int64;int64;int64;int64;int64;ulong;ulong;wchar[' & (DllStructGetData(DllStructCreate('ulong', $pBuffer + $iLength + 60), 1) / 2) & ']', $pBuffer + $iLength)
		$sTarget = DllStructGetData($tFDI, 11)
		$iAttrib = DllStructGetData($tFDI, 9)
		$iOffset = DllStructGetData($tFDI, 1)
		Switch $sTarget
			Case '.', '..'
				ContinueLoop
			Case Else
				Switch $iFlag
					Case 1, 2
						If BitAND($iAttrib, 0x00000010) Then
							If $iFlag = 1 Then
								ContinueLoop
							EndIf
						Else
							If $iFlag = 2 Then
								ContinueLoop
							EndIf
						EndIf
				EndSwitch
				If $sTemplate Then
					$aRet = DllCall('shlwapi.dll', 'int', 'PathMatchSpecW', 'wstr', $sTarget, 'wstr', $sTemplate)
					If @error Or ($aRet[0] And $bExclude) Or (Not $aRet[0] And Not $bExclude) Then
						ContinueLoop
					EndIf
				EndIf
		EndSwitch
		__Inc($aData, 500)
		$aData[$aData[0][0]][0] = $sTarget
		$aData[$aData[0][0]][1] = DllStructGetData($tFDI, 3)
		$aData[$aData[0][0]][2] = DllStructGetData($tFDI, 4)
		$aData[$aData[0][0]][3] = DllStructGetData($tFDI, 5)
		$aData[$aData[0][0]][4] = DllStructGetData($tFDI, 7)
		$aData[$aData[0][0]][5] = DllStructGetData($tFDI, 8)
		$aData[$aData[0][0]][6] = $iAttrib
	Until Not $iOffset
	__HeapFree($pBuffer)
	__Inc($aData, -1)
	Return $aData
EndFunc   ;==>_WinAPI_EnumFiles

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumFileStreams($sFilePath)
	Local $tData = DllStructCreate('byte[32768]')
	Local $pData = DllStructGetPtr($tData)
	Local $aData[101][2] = [[0]]

	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $iError = 0
	Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryInformationFile', 'handle', $hFile, 'struct*', $tIOSB, 'ptr', $pData, _
			'ulong', 32768, 'uint', 22)
	If @error Then $iError = @error
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
	If $iError Then Return SetError($iError, 0, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $tFSI, $iLength = 0, $iOffset = 0
	Do
		$iLength += $iOffset
		$tFSI = DllStructCreate('ulong;ulong;int64;int64;wchar[' & (DllStructGetData(DllStructCreate('ulong', $pData + $iLength + 4), 1) / 2) & ']', $pData + $iLength)
		__Inc($aData)
		$aData[$aData[0][0]][0] = DllStructGetData($tFSI, 5)
		$aData[$aData[0][0]][1] = DllStructGetData($tFSI, 3)
		$iOffset = DllStructGetData($tFSI, 1)
	Until Not $iOffset
	__Inc($aData, -1)
	Return $aData
EndFunc   ;==>_WinAPI_EnumFileStreams

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumHardLinks($sFilePath)
	Local $tData = DllStructCreate('byte[32768]')
	Local $pData = DllStructGetPtr($tData)

	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $iError = 0
	Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryInformationFile', 'handle', $hFile, 'struct*', $tIOSB, 'ptr', $pData, _
			'ulong', 32768, 'uint', 46)
	If @error Or $aRet[0] Then
		$iError = @error + 10
		DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
		If $aRet Then Return SetError($iError, 0, 0)
		If $aRet[0] Then Return SetError(10, $iError, 0)
	EndIf

	Local $iCount = DllStructGetData(DllStructCreate('ulong;ulong', $pData), 2)
	Local $aData[$iCount + 1] = [$iCount]
	Local $tFLEI, $hPath, $sPath, $iLength = 8
	For $i = 1 To $iCount
		$tFLEI = DllStructCreate('ulong;int64;ulong;wchar[' & (DllStructGetData(DllStructCreate('ulong', $pData + $iLength + 16), 1)) & ']', $pData + $iLength)
		$iError = 0
		Do
			$hPath = _WinAPI_OpenFileById($hFile, DllStructGetData($tFLEI, 2), 0x00100080, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
			If @error Then
				$iError = @error + 100
				ExitLoop
			EndIf
			$sPath = _WinAPI_GetFinalPathNameByHandleEx($hPath)
			If @error Then
				$iError = @error + 200
				ExitLoop
			EndIf
		Until 1
		If $hPath Then
			DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hPath)
		EndIf
		If $iError Then ExitLoop

		$aData[$i] = _WinAPI_PathAppend($sPath, DllStructGetData($tFLEI, 4))
		$iLength += DllStructGetData($tFLEI, 1)
	Next
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
	If $iError Then Return SetError($iError, 0, 0)

	Return $aData
EndFunc   ;==>_WinAPI_EnumHardLinks

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FileEncryptionStatus($sFilePath)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'FileEncryptionStatusW', 'wstr', $sFilePath, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, -1)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_FileEncryptionStatus

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FileExists($sFilePath)
	If Not FileExists($sFilePath) Then Return 0
	If _WinAPI_PathIsDirectory($sFilePath) Then Return SetExtended(1, 0)

	Return 1
EndFunc   ;==>_WinAPI_FileExists

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FileInUse($sFilePath)
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, $GENERIC_READ)
	If @error Then
		If @extended = 32 Then Return 1 ; ERROR_SHARING_VIOLATION
		Return SetError(@error, @extended, 0)
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
	Return 0
EndFunc   ;==>_WinAPI_FileInUse

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindClose($hSearch)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FindClose', 'handle', $hSearch)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindClose

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindCloseChangeNotification($hChange)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FindCloseChangeNotification', 'handle', $hChange)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindCloseChangeNotification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindFirstChangeNotification($sDirectory, $iFlags, $bSubtree = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindFirstChangeNotificationW', 'wstr', $sDirectory, 'bool', $bSubtree, _
			'dword', $iFlags)
	If @error Or ($aRet[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0) ; $INVALID_HANDLE_VALUE

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindFirstChangeNotification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindFirstFile($sFilePath, $tData)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindFirstFileW', 'wstr', $sFilePath, 'struct*', $tData)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = Ptr(-1) Then Return SetError(10, _WinAPI_GetLastError(), 0); $INVALID_HANDLE_VALUE

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindFirstFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindFirstFileName($sFilePath, ByRef $sLink)
	$sLink = ''

	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindFirstFileNameW', 'wstr', $sFilePath, 'dword', 0, 'dword*', 4096, 'wstr', '')
	If @error Or ($aRet[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0) ; $INVALID_HANDLE_VALUE

	$sLink = $aRet[4]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindFirstFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindFirstStream($sFilePath, $tData)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindFirstStreamW', 'wstr', $sFilePath, 'uint', 0, 'struct*', $tData, 'dword', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = Ptr(-1) Then Return SetError(10, _WinAPI_GetLastError(), 0) ; $INVALID_HANDLE_VALUE

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindFirstStream

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindNextChangeNotification($hChange)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FindNextChangeNotification', 'handle', $hChange)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindNextChangeNotification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindNextFile($hSearch, $tData)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FindNextFileW', 'handle', $hSearch, 'struct*', $tData)
	If @error Then Return SetError(@error, @extended, False)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindNextFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindNextFileName($hSearch, ByRef $sLink)
	$sLink = ''

	Local $aRet = DllCall('kernel32.dll', 'bool', 'FindNextFileNameW', 'handle', $hSearch, 'dword*', 4096, 'wstr', '')
	If @error Then Return SetError(@error, @extended, False)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), 0)

	$sLink = $aRet[3]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindNextFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindNextStream($hSearch, $tData)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FindNextStreamW', 'handle', $hSearch, 'struct*', $tData)
	If @error Then Return SetError(@error, @extended, False)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindNextStream

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FlushFileBuffers($hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "FlushFileBuffers", "handle", $hFile)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FlushFileBuffers

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FlushViewOfFile($pAddress, $iBytes = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FlushViewOfFile', 'struct*', $pAddress, 'dword', $iBytes)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FlushViewOfFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBinaryType($sFilePath)
	Local $aRet = DllCall('kernel32.dll', 'int', 'GetBinaryTypeW', 'wstr', $sFilePath, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aRet[0] Then $aRet[2] = 0

	Return SetExtended($aRet[2], $aRet[0])
EndFunc   ;==>_WinAPI_GetBinaryType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCDType($sDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, $GENERIC_READWRITE, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $tagSCSI_PASS_THROUGH = 'struct;ushort Length;byte ScsiStatus;byte PathId;byte TargetId;byte Lun;byte CdbLength;byte SenseInfoLength;byte DataIn;ulong DataTransferLength;ulong TimeOutValue;ulong_ptr DataBufferOffset;ulong SenseInfoOffset;byte Cdb[16];endstruct'
	Local $tSPT = DllStructCreate($tagSCSI_PASS_THROUGH & ';byte Hdr[8]')
	Local $tCDB = DllStructCreate('byte;byte;byte[2];byte[3];byte[2];byte;byte[2];byte[4]', DllStructGetPtr($tSPT, 'Cdb'))
	Local $tHDR = DllStructCreate('byte[4];byte;byte;byte[2]', DllStructGetPtr($tSPT, 'Hdr'))
	Local $iSize = DllStructGetPtr($tSPT, 'Hdr') - DllStructGetPtr($tSPT)

	DllStructSetData($tSPT, 'Length', $iSize)
	DllStructSetData($tSPT, 'ScsiStatus', 0)
	DllStructSetData($tSPT, 'PathId', 0)
	DllStructSetData($tSPT, 'TargetId', 0)
	DllStructSetData($tSPT, 'Lun', 0)
	DllStructSetData($tSPT, 'CdbLength', 12)
	DllStructSetData($tSPT, 'SenseInfoLength', 0)
	DllStructSetData($tSPT, 'DataIn', 1)
	DllStructSetData($tSPT, 'DataTransferLength', 8)
	DllStructSetData($tSPT, 'TimeOutValue', 86400)
	DllStructSetData($tSPT, 'DataBufferOffset', $iSize)
	DllStructSetData($tSPT, 'SenseInfoOffset', 0)

	DllStructSetData($tCDB, 1, 0x46)
	DllStructSetData($tCDB, 2, 0)
	DllStructSetData($tCDB, 3, 0, 1)
	DllStructSetData($tCDB, 3, 0, 2)
	DllStructSetData($tCDB, 5, 0, 1)
	DllStructSetData($tCDB, 5, 8, 2)
	DllStructSetData($tCDB, 6, 0)
	DllStructSetData($tCDB, 7, 0, 1)
	DllStructSetData($tCDB, 7, 0, 2)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x0004D004, 'struct*', $tSPT, _
			'dword', $iSize, 'struct*', $tSPT, 'dword', DllStructGetSize($tSPT), 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Return BitOR(BitShift(DllStructGetData($tHDR, 4, 1), -8), DllStructGetData($tHDR, 4, 2))
EndFunc   ;==>_WinAPI_GetCDType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCompressedFileSize($sFilePath)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetCompressedFileSizeW', 'wstr', $sFilePath, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = -1 Then
		Local $iLastError = _WinAPI_GetLastError()
		If $aRet[2] = 0 Then Return SetError(10, $iLastError, 0)
		If $iLastError Then Return SetError(11, $iLastError, 0)
	EndIf

	Return __WinAPI_MakeQWord($aRet[0], $aRet[2])
EndFunc   ;==>_WinAPI_GetCompressedFileSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCompression($sFilePath)
	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, $GENERIC_READ, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x0009003C, 'ptr', 0, 'dword', 0, _
			'ushort*', 0, 'dword', 2, 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, -1)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetCompression

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentDirectory()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetCurrentDirectoryW', 'dword', 4096, 'wstr', '')
	If @error Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0,'')

	Return SetExtended($aRet[0], $aRet[2])
EndFunc   ;==>_WinAPI_GetCurrentDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDiskFreeSpaceEx($sDrive)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetDiskFreeSpaceEx', 'str', $sDrive, 'int64*', 0, 'int64*', 0, 'int64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = $aRet[$i + 2]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetDiskFreeSpaceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDriveBusType($sDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, -1)

	Local $tagSTORAGE_PROPERTY_QUERY = 'ulong PropertyId;ulong QueryType;byte AdditionalParameters[1]'
	Local $tSPQ = DllStructCreate($tagSTORAGE_PROPERTY_QUERY)
	Local $tSDD = DllStructCreate('ulong Version;ulong Size;byte DeviceType;byte DeviceTypeModifier;byte RemovableMedia;byte CommandQueueing;ulong VendorIdOffset;ulong ProductIdOffset;ulong ProductRevisionOffset;ulong SerialNumberOffset;ulong BusType;ulong RawPropertiesLength;byte RawDeviceProperties[1]')

	DllStructSetData($tSPQ, 'PropertyId', 0)
	DllStructSetData($tSPQ, 'QueryType', 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x002D1400, 'struct*', $tSPQ, _
			'dword', DllStructGetSize($tSPQ), 'struct*', $tSDD, 'dword', DllStructGetSize($tSDD), _
			'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, -1)

	Return DllStructGetData($tSDD, 'BusType')
EndFunc   ;==>_WinAPI_GetDriveBusType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDriveGeometryEx($iDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\PhysicalDrive' & $iDrive, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $tDGEX = DllStructCreate('uint64;dword;dword;dword;dword;uint64')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x000700A0, 'ptr', 0, _
			'dword', 0, 'struct*', $tDGEX, 'dword', DllStructGetSize($tDGEX), 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Local $aResult[6]
	For $i = 0 To 5
		$aResult[$i] = DllStructGetData($tDGEX, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetDriveGeometryEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDriveNumber($sDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $tSDN = DllStructCreate('dword;ulong;ulong')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x002D1080, 'ptr', 0, _
			'dword', 0, 'struct*', $tSDN, 'dword', DllStructGetSize($tSDN), 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = DllStructGetData($tSDN, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetDriveNumber

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDriveType($sDrive = '')
	Local $iTypeOfDrive = 'str'
	If Not StringStripWS($sDrive, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$iTypeOfDrive = 'ptr'
		$sDrive = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetDriveType', $iTypeOfDrive, $sDrive)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetDriveType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFileAttributes($sFilePath)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetFileAttributesW', 'wstr', $sFilePath)
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, 0)
	; If $aRet[0] = 4294967295Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetFileAttributes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFileID($hFile)
	Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryInformationFile', 'handle', $hFile, 'struct*', $tIOSB, 'int64*', 0, _
			'ulong', 8, 'uint', 6)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetFileID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFileInformationByHandle($hFile)
	Local $tBHFI = DllStructCreate('dword;dword[2];dword[2];dword[2];dword;dword;dword;dword;dword;dword')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetFileInformationByHandle', 'handle', $hFile, 'struct*', $tBHFI)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[8]
	$aResult[0] = DllStructGetData($tBHFI, 1)
	For $i = 1 To 3
		If DllStructGetData($tBHFI, $i + 1) Then
			$aResult[$i] = DllStructCreate($tagFILETIME)
			_WinAPI_MoveMemory($aResult[$i], DllStructGetPtr($tBHFI, $i + 1), 8)
			; Return SetError(@error + 10, @extended, 0) ; cannot really occur
			; EndIf
		Else
			$aResult[$i] = 0
		EndIf
	Next
	$aResult[4] = DllStructGetData($tBHFI, 5)
	$aResult[5] = __WinAPI_MakeQWord(DllStructGetData($tBHFI, 7), DllStructGetData($tBHFI, 6))
	$aResult[6] = DllStructGetData($tBHFI, 8)
	$aResult[7] = __WinAPI_MakeQWord(DllStructGetData($tBHFI, 9), DllStructGetData($tBHFI, 10))
	Return $aResult
EndFunc   ;==>_WinAPI_GetFileInformationByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFileInformationByHandleEx($hFile)
	Local $tFI = DllStructCreate($tagFILEINFO)
	Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryInformationFile', 'handle', $hFile, 'struct*', $tIOSB, 'struct*', $tFI, _
			'ulong', DllStructGetSize($tFI), 'uint', 4)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tFI
EndFunc   ;==>_WinAPI_GetFileInformationByHandleEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFilePointerEx($hFile)
	Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryInformationFile', 'handle', $hFile, 'struct*', $tIOSB, 'int64*', 0, _
			'ulong', 8, 'uint', 14)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetFilePointerEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetFileSizeEx($hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetFileSizeEx", "handle", $hFile, "int64*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, -1)

	Return $aResult[2]
EndFunc   ;==>_WinAPI_GetFileSizeEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFileSizeOnDisk($sFilePath)
	Local $iSize = FileGetSize($sFilePath)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetDiskFreeSpaceW', _
			'wstr', _WinAPI_PathStripToRoot(_WinAPI_GetFullPathName($sFilePath)), 'dword*', 0, 'dword*', 0, _
			'dword*', 0, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return Ceiling($iSize / ($aRet[2] * $aRet[3])) * ($aRet[2] * $aRet[3])
EndFunc   ;==>_WinAPI_GetFileSizeOnDisk

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFileTitle($sFilePath)
	Local $aRet = DllCall('comdlg32.dll', 'short', 'GetFileTitleW', 'wstr', $sFilePath, 'wstr', '', 'word', 4096)
	If @error Or $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetFileTitle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFileType($hFile)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetFileType', 'handle', $hFile)
	If @error Then Return SetError(@error, @extended, -1)
	Local $iLastError = _WinAPI_GetLastError()
	If Not $aRet[0] And $iLastError Then Return SetError(10, $iLastError, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetFileType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFinalPathNameByHandle($hFile)
	Local $tFNI = DllStructCreate('ulong;wchar[4096]')
	Local $tIOSB = DllStructCreate('ptr;ulong_ptr')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryInformationFile', 'handle', $hFile, 'struct*', $tIOSB, 'struct*', $tFNI, _
			'ulong', DllStructGetSize($tFNI), 'uint', 9)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')
	Local $iLength = DllStructGetData($tFNI, 1)
	If Not $iLength Then Return SetError(12, 0, '')

	Return DllStructGetData(DllStructCreate('wchar[' & ($iLength / 2) & ']', DllStructGetPtr($tFNI, 2)), 1)
EndFunc   ;==>_WinAPI_GetFinalPathNameByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFinalPathNameByHandleEx($hFile, $iFlags = 0)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetFinalPathNameByHandleW', 'handle', $hFile, 'wstr', '', 'dword', 4096, _
			'dword', $iFlags)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetFinalPathNameByHandleEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFullPathName($sFilePath)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetFullPathNameW', 'wstr', $sFilePath, 'dword', 4096, 'wstr', '', 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetFullPathName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetLogicalDrives()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetLogicalDrives')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetLogicalDrives

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetObjectID($sFilePath)
	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $tFOID = DllStructCreate('byte[16];byte[48]')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x0009009C, 'ptr', 0, _
			'dword', 0, 'struct*', $tFOID, 'dword', DllStructGetSize($tFOID), 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Local $tGUID = DllStructCreate($tagGUID)
	_WinAPI_MoveMemory($tGUID, $tFOID, 16)
	; Return SetError(3, 0, 0) ; cannot really occur
	; EndIf
	Return $tGUID
EndFunc   ;==>_WinAPI_GetObjectID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetOverlappedResult($hFile, $tOverlapped, ByRef $iBytes, $bWait = False)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetOverlappedResult", "handle", $hFile, "struct*", $tOverlapped, "dword*", 0, _
			"bool", $bWait)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, False)

	$iBytes = $aResult[3]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetOverlappedResult

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetPEType($sFilePath)
	Local $tData = DllStructCreate('ushort[2]')
	Local $tUInt = DllStructCreate('uint', DllStructGetPtr($tData))

	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, $GENERIC_READ, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $iError = 0, $iVal
	Do
		Local $aRet = DllCall('kernel32.dll', 'bool', 'ReadFile', 'handle', $hFile, 'struct*', $tData, 'dword', 2, 'dword*', 0, 'ptr', 0)
		If @error Or (Not $aRet[0]) Or ($aRet[4] <> 2) Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$iVal = DllStructGetData($tData, 1, 1)
		If $iVal <> 0x00005A4D Then
			$iError = 3
			ExitLoop
		EndIf
		If Not _WinAPI_SetFilePointerEx($hFile, 0x0000003C) Then
			$iError = @error + 40
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadFile', 'handle', $hFile, 'struct*', $tData, 'dword', 4, 'dword*', 0, 'ptr', 0)
		If @error Or (Not $aRet[0]) Or ($aRet[4] <> 4) Then
			$iError = @error + 50
			ExitLoop
		EndIf
		If Not _WinAPI_SetFilePointerEx($hFile, DllStructGetData($tUInt, 1)) Then
			$iError = @error + 60
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadFile', 'handle', $hFile, 'struct*', $tData, 'dword', 4, 'dword*', 0, 'ptr', 0)
		If @error Or (Not $aRet[0]) Or ($aRet[4] <> 4) Then
			$iError = @error + 70
			ExitLoop
		EndIf
		$iVal = DllStructGetData($tUInt, 1)
		If $iVal <> 0x00004550 Then
			$iError = 4
			ExitLoop
		EndIf
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadFile', 'handle', $hFile, 'struct*', $tData, 'dword', 2, 'dword*', 0, 'ptr', 0)
		If @error Or (Not $aRet[0]) Or ($aRet[4] <> 2) Then
			$iError = @error + 80
			ExitLoop
		EndIf
		$iVal = DllStructGetData($tData, 1, 1)
	Until 1
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
	If $iError Then Return SetError($iError, 0, 0)

	Return $iVal
EndFunc   ;==>_WinAPI_GetPEType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetProfilesDirectory()
	Local $aRet = DllCall('userenv.dll', 'bool', 'GetProfilesDirectoryW', 'wstr', '', 'dword*', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetProfilesDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetTempFileName($sFilePath, $sPrefix = '')
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetTempFileNameW', 'wstr', $sFilePath, 'wstr', $sPrefix, 'uint', 0, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[4]
EndFunc   ;==>_WinAPI_GetTempFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetVolumeInformation($sRoot = '')
	Local $sTypeOfRoot = 'wstr'
	If Not StringStripWS($sRoot, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfRoot = 'ptr'
		$sRoot = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVolumeInformationW', $sTypeOfRoot, $sRoot, 'wstr', '', 'dword', 4096, _
			'dword*', 0, 'dword*', 0, 'dword*', 0, 'wstr', '', 'dword', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[5]
	For $i = 0 To 4
		Switch $i
			Case 0
				$aResult[$i] = $aRet[2]
			Case Else
				$aResult[$i] = $aRet[$i + 3]
		EndSwitch
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetVolumeInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetVolumeInformationByHandle($hFile)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVolumeInformationByHandleW', 'handle', $hFile, 'wstr', '', 'dword', 4096, _
			'dword*', 0, 'dword*', 0, 'dword*', 0, 'wstr', '', 'dword', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[5]
	For $i = 0 To 4
		Switch $i
			Case 0
				$aResult[$i] = $aRet[2]
			Case Else
				$aResult[$i] = $aRet[$i + 3]
		EndSwitch
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetVolumeInformationByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetVolumeNameForVolumeMountPoint($sMountedPath)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVolumeNameForVolumeMountPointW', 'wstr', $sMountedPath, 'wstr', '', 'dword', 80)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetVolumeNameForVolumeMountPoint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IOCTL($iDeviceType, $iFunction, $iMethod, $iAccess)
	Return BitOR(BitShift($iDeviceType, -16), BitShift($iAccess, -14), BitShift($iFunction, -2), $iMethod)
EndFunc   ;==>_WinAPI_IOCTL

; #FUNCTION# ====================================================================================================================
; Author.........: G.Sandler (CreatoR)
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_IsDoorOpen($sDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, $GENERIC_READWRITE, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, False)

	Local $tSPT = DllStructCreate('ushort Length;byte ScsiStatus;byte PathId;byte TargetId;byte Lun;byte CdbLength;byte SenseInfoLength;byte DataIn;byte Alignment[3];ulong DataTransferLength;ulong TimeOutValue;ulong_ptr DataBufferOffset;ulong SenseInfoOffset;byte Cdb[16]' & (@AutoItX64 ? ';byte[4]' : '') & ';byte Hdr[8]')
	Local $tCDB = DllStructCreate('byte;byte;byte[6];byte[2];byte;byte;byte[4]', DllStructGetPtr($tSPT, 'Cdb'))
	Local $tHDR = DllStructCreate('byte;byte;byte[3];byte;byte[2]', DllStructGetPtr($tSPT, 'Hdr'))
	Local $iSize = DllStructGetPtr($tSPT, 'Hdr') - DllStructGetPtr($tSPT)

	DllStructSetData($tSPT, 'Length', $iSize)
	DllStructSetData($tSPT, 'ScsiStatus', 0)
	DllStructSetData($tSPT, 'PathId', 0)
	DllStructSetData($tSPT, 'TargetId', 0)
	DllStructSetData($tSPT, 'Lun', 0)
	DllStructSetData($tSPT, 'CdbLength', 12)
	DllStructSetData($tSPT, 'SenseInfoLength', 0)
	DllStructSetData($tSPT, 'DataIn', 1)
	DllStructSetData($tSPT, 'DataTransferLength', 8)
	DllStructSetData($tSPT, 'TimeOutValue', 86400)
	DllStructSetData($tSPT, 'DataBufferOffset', $iSize)
	DllStructSetData($tSPT, 'SenseInfoOffset', 0)

	DllStructSetData($tCDB, 1, 0xBD)
	DllStructSetData($tCDB, 2, 0)
	DllStructSetData($tCDB, 4, 0, 1)
	DllStructSetData($tCDB, 4, 8, 2)
	DllStructSetData($tCDB, 5, 0)
	DllStructSetData($tCDB, 6, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x0004D004, 'struct*', $tSPT, _
			'dword', $iSize, 'struct*', $tSPT, 'dword', DllStructGetSize($tSPT), 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, False)

	Return (BitAND(DllStructGetData($tHDR, 2), 0x10) = 0x10)
EndFunc   ;==>_WinAPI_IsDoorOpen

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsPathShared($sFilePath)
	If Not __DLL('ntshrui.dll') Then Return SetError(103, 0, 0)

	Local $aRet = DllCall('ntshrui.dll', 'bool', 'IsPathSharedW', 'wstr', _WinAPI_PathRemoveBackslash($sFilePath), 'int', 1)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsPathShared

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_IsWritable($sDrive)
	; to check if the Drive is Ready
	DriveGetFileSystem($sDrive)
	If @error Then Return SetError(40 + @error, _WinAPI_GetLastError(), 0)

	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x00070024, 'ptr', 0, 'dword', 0, _
			'ptr', 0, 'dword', 0, 'dword*', 0, 'ptr', 0)
	Local Const $ERROR_WRITE_PROTECT = 19 ; The media is write protected.
	If __CheckErrorCloseHandle($aRet, $hFile, 1) <> 10 And @extended = $ERROR_WRITE_PROTECT Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsWritable

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadMedia($sDrive)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, $GENERIC_READ, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, False)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x002D480C, 'ptr', 0, 'dword', 0, _
			'ptr', 0, 'dword', 0, 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadMedia

; #FUNCTION# ====================================================================================================================
; Author.........: Psandu.ro
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_LockDevice($sDrive, $bLock)
	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sDrive, $OPEN_EXISTING, $GENERIC_READWRITE, $FILE_SHARE_READWRITE)
	If @error Then Return SetError(@error + 20, @extended, False)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x002D4804, 'boolean*', $bLock, _
			'dword', 1, 'ptr', 0, 'dword', 0, 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockDevice

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LockFile($hFile, $iOffset, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'LockFile', 'handle', $hFile, _
			'dword', _WinAPI_LoDWord($iOffset), 'dword', _WinAPI_HiDWord($iOffset), _
			'dword', _WinAPI_LoDWord($iLength), 'dword', _WinAPI_HiDWord($iLength))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_MapViewOfFile($hMapping, $iOffset = 0, $iBytes = 0, $iAccess = 0x0006)
	Local $aRet = DllCall('kernel32.dll', 'ptr', 'MapViewOfFile', 'handle', $hMapping, 'dword', $iAccess, _
			'dword', _WinAPI_HiDWord($iOffset), 'dword', _WinAPI_LoDWord($iOffset), 'ulong_ptr', $iBytes)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MapViewOfFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_MoveFileEx($sExistingFile, $sNewFile, $iFlags = 0, $pProgressProc = 0, $pData = 0)
	Local $sTypeOfNewFile = 'wstr'
	If Not StringStripWS($sNewFile, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfNewFile = 'ptr'
		$sNewFile = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'MoveFileWithProgressW', 'wstr', $sExistingFile, $sTypeOfNewFile, $sNewFile, _
			'ptr', $pProgressProc, 'ptr', $pData, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MoveFileEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OpenFileById($hFile, $vID, $iAccess = 0, $iShare = 0, $iFlags = 0)
	Local $tFIDD = DllStructCreate('dword;uint;int64;int64')
	Local $hObj, $aRet, $iType, $iError = 0

	Select
		Case IsString($vID)
			$aRet = DllCall('ole32.dll', 'long', 'CLSIDFromString', 'wstr', $vID, 'ptr', DllStructGetPtr($tFIDD, 3))
			If @error Or $aRet[0] Then
				Return SetError(@error + 30, 0, 0)
			EndIf
			$iType = 1
		Case IsDllStruct($vID)
			If Not _WinAPI_MoveMemory(DllStructGetPtr($tFIDD, 3), DllStructGetPtr($vID), 16) Then
				Return SetError(@error + 40, 0, 0)
			EndIf
			$iType = 1
		Case Else
			DllStructSetData($tFIDD, 3, $vID)
			$iType = 0
	EndSelect
	DllStructSetData($tFIDD, 1, DllStructGetSize($tFIDD))
	DllStructSetData($tFIDD, 2, $iType)
	If IsString($hFile) Then
		; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
		$hObj = _WinAPI_CreateFileEx($hFile, $OPEN_EXISTING, 0, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
		If @error Then Return SetError(@error + 20, @extended, 0)
	Else
		$hObj = $hFile
	EndIf
	$aRet = DllCall('kernel32.dll', 'handle', 'OpenFileById', 'handle', $hObj, 'struct*', $tFIDD, 'dword', $iAccess, _
			'dword', $iShare, 'ptr', 0, 'dword', $iFlags)
	If @error Or ($aRet[0] = Ptr(-1)) Then $iError = @error + 10 ; $INVALID_HANDLE_VALUE
	If IsString($hFile) Then
		DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObj)
	EndIf
	If $iError Then Return SetError($iError, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenFileById

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenFileMapping($sName, $iAccess = 0x0006, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenFileMappingW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenFileMapping

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsDirectoryEmpty($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsDirectoryEmptyW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsDirectoryEmpty

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_QueryDosDevice($sDevice)
	Local $sTypeOfDevice = 'wstr'
	If Not StringStripWS($sDevice, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfDevice = 'ptr'
		$sDevice = 0
	EndIf

	Local $tData = DllStructCreate('wchar[16384]')
	Local $aRet = DllCall('kernel32.dll', 'dword', 'QueryDosDeviceW', $sTypeOfDevice, $sDevice, 'struct*', $tData, 'dword', 16384)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Local $aResult = _WinAPI_StructToArray($tData)
	If IsString($sDevice) Then
		$aResult = $aResult[1]
	EndIf
	Return $aResult
EndFunc   ;==>_WinAPI_QueryDosDevice

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ReadDirectoryChanges($hDirectory, $iFilter, $pBuffer, $iLength, $bSubtree = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ReadDirectoryChangesW', 'handle', $hDirectory, 'struct*', $pBuffer, _
			'dword', $iLength - Mod($iLength, 4), 'bool', $bSubtree, 'dword', $iFilter, 'dword*', 0, 'ptr', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Or (Not $aRet[6]) Then Return SetError(@error + 10, @extended, 0)

	$pBuffer = $aRet[2] ; if updated by the DllCall in case of not word align
	Local $aData[101][2] = [[0]]
	Local $tFNI, $iBuffer = 0, $iOffset = 0

	Do
		$iBuffer += $iOffset
		$tFNI = DllStructCreate('dword NextEntryOffset;dword Action;dword FileNameLength;wchar FileName[' & (DllStructGetData(DllStructCreate('dword FileNameLength', $pBuffer + $iBuffer + 8), 1) / 2) & ']', $pBuffer + $iBuffer)
		__Inc($aData)
		$aData[$aData[0][0]][0] = DllStructGetData($tFNI, "FileName")
		$aData[$aData[0][0]][1] = DllStructGetData($tFNI, "Action")
		$iOffset = DllStructGetData($tFNI, "NextEntryOffset")
	Until Not $iOffset
	__Inc($aData, -1)
	Return $aData
EndFunc   ;==>_WinAPI_ReadDirectoryChanges

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RemoveDirectory($sDirPath)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'RemoveDirectoryW', 'wstr', $sDirPath)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RemoveDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ReOpenFile($hFile, $iAccess, $iShare, $iFlags = 0)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'ReOpenFile', 'handle', $hFile, 'dword', $iAccess, 'dword', $iShare, 'dword', $iFlags)
	If @error Or ($aRet[0] = Ptr(-1)) Then Return SetError(@error, @extended, 0) ; $INVALID_HANDLE_VALUE
	; If $aRet[0] = Ptr(-1) Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ReOpenFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ReplaceFile($sReplacedFile, $sReplacementFile, $sBackupFile = '', $iFlags = 0)
	Local $sTypeOfBackupFile = 'wstr'
	If Not StringStripWS($sBackupFile, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfBackupFile = 'ptr'
		$sBackupFile = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'ReplaceFileW', 'wstr', $sReplacedFile, 'wstr', $sReplacementFile, _
			$sTypeOfBackupFile, $sBackupFile, 'dword', $iFlags, 'ptr', 0, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ReplaceFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SearchPath($sFilePath, $sSearchPath = '')
	Local $sTypeOfPath = 'wstr'
	If Not StringStripWS($sSearchPath, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfPath = 'ptr'
		$sSearchPath = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'dword', 'SearchPathW', $sTypeOfPath, $sSearchPath, 'wstr', $sFilePath, 'ptr', 0, 'dword', 4096, 'wstr', '', 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return $aRet[5]
EndFunc   ;==>_WinAPI_SearchPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetCompression($sFilePath, $iCompression)
	; Local Const $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000
	Local $hFile = _WinAPI_CreateFileEx($sFilePath, $OPEN_EXISTING, $GENERIC_READWRITE, $FILE_SHARE_READWRITE, $FILE_FLAG_BACKUP_SEMANTICS)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'DeviceIoControl', 'handle', $hFile, 'dword', 0x0009C040, _
			'ushort*', $iCompression, 'dword', 2, 'ptr', 0, 'dword', 0, 'dword*', 0, 'ptr', 0)
	If __CheckErrorCloseHandle($aRet, $hFile) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_SetCompression

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetCurrentDirectory($sDir)
	Local $aRet = DllCall('kernel32.dll', 'int', 'SetCurrentDirectoryW', 'wstr', $sDir)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetCurrentDirectory

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetEndOfFile($hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetEndOfFile", "handle", $hFile)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetEndOfFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetFileAttributes($sFilePath, $iAttributes)
	Local $aRet = DllCall('kernel32.dll', 'int', 'SetFileAttributesW', 'wstr', $sFilePath, 'dword', $iAttributes)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetFileAttributes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetFileInformationByHandleEx($hFile, $tFILEINFO)
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwSetInformationFile', 'handle', $hFile, 'struct*', $tFILEINFO, _
			'struct*', $tFILEINFO, 'ulong', DllStructGetSize($tFILEINFO), 'uint', 4)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_SetFileInformationByHandleEx

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetFilePointer($hFile, $iPos, $iMethod = 0)
	Local $aResult = DllCall("kernel32.dll", "INT", "SetFilePointer", "handle", $hFile, "long", $iPos, "ptr", 0, "long", $iMethod)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetFilePointer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetFilePointerEx($hFile, $iPos, $iMethod = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetFilePointerEx', 'handle', $hFile, 'int64', $iPos, 'int64*', 0, 'dword', $iMethod)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetFilePointerEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetFileShortName($hFile, $sShortName)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetFileShortNameW', 'handle', $hFile, 'wstr', $sShortName)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetFileShortName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetFileValidData($hFile, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetFileValidData', 'handle', $hFile, 'int64', $iLength)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetFileValidData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetSearchPathMode($iFlags)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetSearchPathMode', 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetSearchPathMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetVolumeMountPoint($sFilePath, $sGUID)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetVolumeMountPointW', 'wstr', $sFilePath, 'wstr', $sGUID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetVolumeMountPoint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SfcIsFileProtected($sFilePath)
	If Not __DLL('sfc.dll') Then Return SetError(103, 0, False)

	Local $aRet = DllCall('sfc.dll', 'bool', 'SfcIsFileProtected', 'handle', 0, 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SfcIsFileProtected

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnlockFile($hFile, $iOffset, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'UnlockFile', 'handle', $hFile, _
			'dword', _WinAPI_LoDWord($iOffset), 'dword', _WinAPI_HiDWord($iOffset), _
			'dword', _WinAPI_LoDWord($iLength), 'dword', _WinAPI_HiDWord($iLength))
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnlockFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnmapViewOfFile($pAddress)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'UnmapViewOfFile', 'ptr', $pAddress)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnmapViewOfFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_Wow64EnableWow64FsRedirection($bEnable)
	Local $aRet = DllCall('kernel32.dll', 'boolean', 'Wow64EnableWow64FsRedirection', 'boolean', $bEnable)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_Wow64EnableWow64FsRedirection

#EndRegion Public Functions

#Region Internal Functions

Func __WinAPI_MakeQWord($iLoDWORD, $iHiDWORD)
	Local $tInt64 = DllStructCreate("uint64")
	Local $tDwords = DllStructCreate("dword;dword", DllStructGetPtr($tInt64))
	DllStructSetData($tDwords, 1, $iLoDWORD)
	DllStructSetData($tDwords, 2, $iHiDWORD)

	Return DllStructGetData($tInt64, 1)
EndFunc   ;==>__WinAPI_MakeQWord

#EndRegion Internal Functions
