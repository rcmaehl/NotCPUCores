#include-once

#include "APIShellExConstants.au3"
#include "StringConstants.au3"
#include "WinAPICom.au3"
#include "WinAPIMem.au3"
#include "WinAPIMisc.au3"
#include "WinAPIShPath.au3"
#include "WinAPISys.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIShellEx.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagNOTIFYICONDATA = 'struct;dword Size;hwnd hWnd;uint ID;uint Flags;uint CallbackMessage;ptr hIcon;wchar Tip[128];dword State;dword StateMask;wchar Info[256];uint Version;wchar InfoTitle[64];dword InfoFlags;endstruct'
Global Const $tagNOTIFYICONDATA_V3 = $tagNOTIFYICONDATA & ';' & $tagGUID
Global Const $tagNOTIFYICONDATA_V4 = $tagNOTIFYICONDATA_V3 & ';ptr hBalloonIcon;'
Global Const $tagSHELLEXECUTEINFO = 'dword Size;ulong Mask;hwnd hWnd;ptr Verb;ptr File;ptr Parameters;ptr Directory;int Show;ulong_ptr hInstApp;ptr IDList;ptr Class;ulong_ptr hKeyClass;dword HotKey;ptr hMonitor;ptr hProcess'
Global Const $tagSHFILEINFO = 'ptr hIcon;int iIcon;dword Attributes;wchar DisplayName[260];wchar TypeName[80]'
Global Const $tagSHFILEOPSTRUCT = 'hwnd hWnd;uint Func;ptr From;ptr To;dword Flags;int fAnyOperationsAborted;ptr hNameMappings;ptr ProgressTitle'
Global Const $tagSHFOLDERCUSTOMSETTINGS = 'dword Size;dword Mask;ptr GUID;ptr WebViewTemplate;dword SizeWVT;ptr WebViewTemplateVersion;ptr InfoTip;dword SizeIT;ptr CLSID;dword Flags;ptr IconFile;dword SizeIF;int IconIndex;ptr Logo;dword SizeL'
Global Const $tagSHSTOCKICONINFO = 'dword Size;ptr hIcon;int SysImageIndex;int iIcon;wchar Path[260]'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_DefSubclassProc
; _WinAPI_DllGetVersion
; _WinAPI_FindExecutable
; _WinAPI_GetAllUsersProfileDirectory
; _WinAPI_GetDefaultUserProfileDirectory
; _WinAPI_GetWindowSubclass
; _WinAPI_RemoveWindowSubclass
; _WinAPI_SetCurrentProcessExplicitAppUserModelID
; _WinAPI_SetWindowSubclass
; _WinAPI_ShellAddToRecentDocs
; _WinAPI_ShellChangeNotify
; _WinAPI_ShellChangeNotifyDeregister
; _WinAPI_ShellChangeNotifyRegister
; _WinAPI_ShellCreateDirectory
; _WinAPI_ShellEmptyRecycleBin
; _WinAPI_ShellExecute
; _WinAPI_ShellExecuteEx
; _WinAPI_ShellExtractAssociatedIcon
; _WinAPI_ShellExtractIcon
; _WinAPI_ShellFileOperation
; _WinAPI_ShellFlushSFCache
; _WinAPI_ShellGetFileInfo
; _WinAPI_ShellGetIconOverlayIndex
; _WinAPI_ShellGetKnownFolderIDList
; _WinAPI_ShellGetKnownFolderPath
; _WinAPI_ShellGetLocalizedName
; _WinAPI_ShellGetPathFromIDList
; _WinAPI_ShellGetSetFolderCustomSettings
; _WinAPI_ShellGetSettings
; _WinAPI_ShellGetSpecialFolderLocation
; _WinAPI_ShellGetSpecialFolderPath
; _WinAPI_ShellGetStockIconInfo
; _WinAPI_ShellILCreateFromPath
; _WinAPI_ShellNotifyIcon
; _WinAPI_ShellNotifyIconGetRect
; _WinAPI_ShellObjectProperties
; _WinAPI_ShellOpenFolderAndSelectItems
; _WinAPI_ShellQueryRecycleBin
; _WinAPI_ShellQueryUserNotificationState
; _WinAPI_ShellRemoveLocalizedName
; _WinAPI_ShellRestricted
; _WinAPI_ShellSetKnownFolderPath
; _WinAPI_ShellSetLocalizedName
; _WinAPI_ShellSetSettings
; _WinAPI_ShellUpdateImage
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DefSubclassProc($hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('comctl32.dll', 'lresult', 'DefSubclassProc', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DefSubclassProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DllGetVersion($sFilePath)
	Local $tVersion = DllStructCreate('dword[5]')
	DllStructSetData($tVersion, 1, DllStructGetSize($tVersion), 1)

	Local $aRet = DllCall($sFilePath, 'uint', 'DllGetVersion', 'struct*', $tVersion)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[4]
	For $i = 0 To 3
		$aResult[$i] = DllStructGetData($tVersion, 1, $i + 2)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_DllGetVersion

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_FindExecutable($sFileName, $sDirectory = "")
	Local $aResult = DllCall("shell32.dll", "INT", "FindExecutableW", "wstr", $sFileName, "wstr", $sDirectory, "wstr", "")
	If @error Then Return SetError(@error, @extended, '')
	If $aResult[0] <= 32 Then Return SetError(10, $aResult[0], '')

	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_WinAPI_FindExecutable

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetAllUsersProfileDirectory()
	Local $aRet = DllCall('userenv.dll', 'bool', 'GetAllUsersProfileDirectoryW', 'wstr', '', 'dword*', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetAllUsersProfileDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDefaultUserProfileDirectory()
	Local $aRet = DllCall('userenv.dll', 'bool', 'GetDefaultUserProfileDirectoryW', 'wstr', '', 'dword*', 4096)
	If @error Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetDefaultUserProfileDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowSubclass($hWnd, $pSubclassProc, $idSubClass)
	Local $aRet = DllCall('comctl32.dll', 'bool', 'GetWindowSubclass', 'hwnd', $hWnd, 'ptr', $pSubclassProc, 'uint_ptr', $idSubClass, _
			'dword_ptr*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[4]
EndFunc   ;==>_WinAPI_GetWindowSubclass

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RemoveWindowSubclass($hWnd, $pSubclassProc, $idSubClass)
	Local $aRet = DllCall('comctl32.dll', 'bool', 'RemoveWindowSubclass', 'hwnd', $hWnd, 'ptr', $pSubclassProc, 'uint_ptr', $idSubClass)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RemoveWindowSubclass

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetCurrentProcessExplicitAppUserModelID($sAppID)
	Local $aRet = DllCall('shell32.dll', 'long', 'SetCurrentProcessExplicitAppUserModelID', 'wstr', $sAppID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_SetCurrentProcessExplicitAppUserModelID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowSubclass($hWnd, $pSubclassProc, $idSubClass, $pData = 0)
	Local $aRet = DllCall('comctl32.dll', 'bool', 'SetWindowSubclass', 'hwnd', $hWnd, 'ptr', $pSubclassProc, 'uint_ptr', $idSubClass, _
			'dword_ptr', $pData)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWindowSubclass

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellAddToRecentDocs($sFilePath)
	Local $sTypeOfFile = 'wstr'
	If StringStripWS($sFilePath, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sFilePath = _WinAPI_PathSearchAndQualify($sFilePath, 1)
		If Not $sFilePath Then
			Return SetError(1, 0, 0)
		EndIf
	Else
		$sTypeOfFile = 'ptr'
		$sFilePath = 0
	EndIf

	DllCall('shell32.dll', 'none', 'SHAddToRecentDocs', 'uint', 3, $sTypeOfFile, $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellAddToRecentDocs

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellChangeNotify($iEvent, $iFlags, $iItem1 = 0, $iItem2 = 0)
	Local $sTypeOfItem1 = 'dword_ptr', $sTypeOfItem2 = 'dword_ptr'
	If IsString($iItem1) Then
		$sTypeOfItem1 = 'wstr'
	EndIf
	If IsString($iItem2) Then
		$sTypeOfItem2 = 'wstr'
	EndIf

	DllCall('shell32.dll', 'none', 'SHChangeNotify', 'long', $iEvent, 'uint', $iFlags, $sTypeOfItem1, $iItem1, $sTypeOfItem2, $iItem2)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellChangeNotify

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellChangeNotifyDeregister($iID)
	Local $aRet = DllCall('shell32.dll', 'bool', 'SHChangeNotifyDeregister', 'ulong', $iID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellChangeNotifyDeregister

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellChangeNotifyRegister($hWnd, $iMsg, $iEvents, $iSources, $aPaths, $bRecursive = False)
	Local $iPath = $aPaths, $tagStruct = ''

	If IsArray($aPaths) Then
		If UBound($aPaths, $UBOUND_COLUMNS) Then Return SetError(1, 0, 0)
	Else
		Dim $aPaths[1] = [$iPath]
	EndIf
	For $i = 0 To UBound($aPaths) - 1
		If Not _WinAPI_PathIsDirectory($aPaths[$i]) Then Return SetError(2, 0, 0)
	Next
	For $i = 0 To UBound($aPaths) - 1
		$tagStruct &= 'ptr;int;'
	Next
	Local $tEntry = DllStructCreate($tagStruct)
	For $i = 0 To UBound($aPaths) - 1
		$aPaths[$i] = _WinAPI_ShellILCreateFromPath(_WinAPI_PathSearchAndQualify($aPaths[$i]))
		DllStructSetData($tEntry, 2 * $i + 1, $aPaths[$i])
		DllStructSetData($tEntry, 2 * $i + 2, $bRecursive)
	Next

	Local $iError = 0
	Local $aRet = DllCall('shell32.dll', 'ulong', 'SHChangeNotifyRegister', 'hwnd', $hWnd, 'int', $iSources, 'long', $iEvents, _
			'uint', $iMsg, 'int', UBound($aPaths), 'struct*', $tEntry)
	If @error Or Not $aRet[0] Then $iError = @error + 10

	For $i = 0 To UBound($aPaths) - 1
		_WinAPI_CoTaskMemFree($aPaths[$i])
	Next

	Return SetError($iError, 0, $aRet[0])
EndFunc   ;==>_WinAPI_ShellChangeNotifyRegister

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellCreateDirectory($sFilePath, $hParent = 0, $tSecurity = 0)
	Local $aRet = DllCall('shell32.dll', 'int', 'SHCreateDirectoryExW', 'hwnd', $hParent, 'wstr', $sFilePath, 'struct*', $tSecurity)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellCreateDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellEmptyRecycleBin($sRoot = '', $iFlags = 0, $hParent = 0)
	Local $aRet = DllCall('shell32.dll', 'long', 'SHEmptyRecycleBinW', 'hwnd', $hParent, 'wstr', $sRoot, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellEmptyRecycleBin

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellExecute($sFilePath, $sArgs = '', $sDir = '', $sVerb = '', $iShow = 1, $hParent = 0)
	Local $sTypeOfArgs = 'wstr', $sTypeOfDir = 'wstr', $sTypeOfVerb = 'wstr'
	If Not StringStripWS($sArgs, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfArgs = 'ptr'
		$sArgs = 0
	EndIf
	If Not StringStripWS($sDir, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfDir = 'ptr'
		$sDir = 0
	EndIf
	If Not StringStripWS($sVerb, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfVerb = 'ptr'
		$sVerb = 0
	EndIf

	Local $aRet = DllCall('shell32.dll', 'ULONG_PTR', 'ShellExecuteW', 'hwnd', $hParent, $sTypeOfVerb, $sVerb, 'wstr', $sFilePath, _
			$sTypeOfArgs, $sArgs, $sTypeOfDir, $sDir, 'int', $iShow)
	If @error Then Return SetError(@error, @extended, False)
	If $aRet[0] <= 32 Then Return SetError(10, $aRet[0], 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellExecute

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellExecuteEx(ByRef $tSHEXINFO)
	Local $aRet = DllCall('shell32.dll', 'bool', 'ShellExecuteExW', 'struct*', $tSHEXINFO)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellExecuteEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellExtractAssociatedIcon($sFilePath, $bSmall = False)
	Local $iFlags = 0x00000100
	If Not _WinAPI_PathIsDirectory($sFilePath) Then
		$iFlags = BitOR($iFlags, 0x00000010)
	EndIf
	If $bSmall Then
		$iFlags = BitOR($iFlags, 0x00000001)
	EndIf

	Local $tSHFILEINFO = DllStructCreate($tagSHFILEINFO)
	If Not _WinAPI_ShellGetFileInfo($sFilePath, $iFlags, 0, $tSHFILEINFO) Then Return SetError(@error + 10, @extended, 0)

	Return DllStructGetData($tSHFILEINFO, 'hIcon')
EndFunc   ;==>_WinAPI_ShellExtractAssociatedIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	Local $aRet = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $sIcon, 'int', $iIndex, 'int', $iWidth, _
			'int', $iHeight, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
	If @error Or Not $aRet[0] Or Not $aRet[5] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_ShellExtractIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellFileOperation($sFrom, $sTo, $iFunc, $iFlags, $sTitle = '', $hParent = 0)
	Local $iData
	If Not IsArray($sFrom) Then
		$iData = $sFrom
		Dim $sFrom[1] = [$iData]
	EndIf
	Local $tFrom = _WinAPI_ArrayToStruct($sFrom)
	If @error Then Return SetError(@error + 20, @extended, 0)

	If Not IsArray($sTo) Then
		$iData = $sTo
		Dim $sTo[1] = [$iData]
	EndIf
	Local $tTo = _WinAPI_ArrayToStruct($sTo)
	If @error Then Return SetError(@error + 30, @extended, 0)

	Local $tSHFILEOPSTRUCT = DllStructCreate($tagSHFILEOPSTRUCT)
	DllStructSetData($tSHFILEOPSTRUCT, 'hWnd', $hParent)
	DllStructSetData($tSHFILEOPSTRUCT, 'Func', $iFunc)
	DllStructSetData($tSHFILEOPSTRUCT, 'From', DllStructGetPtr($tFrom))
	DllStructSetData($tSHFILEOPSTRUCT, 'To', DllStructGetPtr($tTo))
	DllStructSetData($tSHFILEOPSTRUCT, 'Flags', $iFlags)
	DllStructSetData($tSHFILEOPSTRUCT, 'ProgressTitle', $sTitle)

	Local $aRet = DllCall('shell32.dll', 'int', 'SHFileOperationW', 'struct*', $tSHFILEOPSTRUCT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tSHFILEOPSTRUCT
EndFunc   ;==>_WinAPI_ShellFileOperation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellFlushSFCache()
	DllCall('shell32.dll', 'none', 'SHFlushSFCache')
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellFlushSFCache

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetFileInfo($sFilePath, $iFlags, $iAttributes, ByRef $tSHFILEINFO)
	Local $aRet = DllCall('shell32.dll', 'dword_ptr', 'SHGetFileInfoW', 'wstr', $sFilePath, 'dword', $iAttributes, _
			'struct*', $tSHFILEINFO, 'uint', DllStructGetSize($tSHFILEINFO), 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellGetFileInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetIconOverlayIndex($sIcon, $iIndex)
	Local $sTypeOfIcon = 'wstr'
	If Not StringStripWS($sIcon, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfIcon = 'ptr'
		$sIcon = 0
	EndIf

	Local $aRet = DllCall('shell32.dll', 'int', 'SHGetIconOverlayIndexW', $sTypeOfIcon, $sIcon, 'int', $iIndex)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellGetIconOverlayIndex

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetKnownFolderIDList($sGUID, $iFlags = 0, $hToken = 0)
	Local $tGUID = DllStructCreate($tagGUID)
	Local $aRet = DllCall('ole32.dll', 'uint', 'CLSIDFromString', 'wstr', $sGUID, 'struct*', $tGUID)
	If @error Or $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	$aRet = DllCall('shell32.dll', 'uint', 'SHGetKnownFolderIDList', 'struct*', $tGUID, 'dword', $iFlags, 'handle', $hToken, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[4]
EndFunc   ;==>_WinAPI_ShellGetKnownFolderIDList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetKnownFolderPath($sGUID, $iFlags = 0, $hToken = 0)
	Local $tGUID = DllStructCreate($tagGUID)
	Local $aRet = DllCall('ole32.dll', 'long', 'CLSIDFromString', 'wstr', $sGUID, 'struct*', $tGUID)
	If @error Or $aRet[0] Then Return SetError(@error + 20, @extended, '')

	$aRet = DllCall('shell32.dll', 'long', 'SHGetKnownFolderPath', 'struct*', $tGUID, 'dword', $iFlags, 'handle', $hToken, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Local $sPath = _WinAPI_GetString($aRet[4])
	_WinAPI_CoTaskMemFree($aRet[4])
	Return $sPath
EndFunc   ;==>_WinAPI_ShellGetKnownFolderPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetLocalizedName($sFilePath)
	Local $aRet = DllCall('shell32.dll', 'long', 'SHGetLocalizedName', 'wstr', $sFilePath, 'wstr', '', 'uint*', 0, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[2]
	; $aResult[0] = _WinAPI_ExpandEnvironmentStrings($aRet[2])
	Local $aRet1 = DllCall("kernel32.dll", "dword", "ExpandEnvironmentStringsW", "wstr", $aRet[2], "wstr", "", "dword", 4096)
	$aResult[0] = $aRet1[2]

	$aResult[1] = $aRet[4]
	Return $aResult
EndFunc   ;==>_WinAPI_ShellGetLocalizedName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetPathFromIDList($pPIDL)
	Local $aRet = DllCall('shell32.dll', 'bool', 'SHGetPathFromIDListW', 'struct*', $pPIDL, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_ShellGetPathFromIDList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetSetFolderCustomSettings($sFilePath, $iFlag, ByRef $tSHFCS)
	Local $sProc = 'SHGetSetFolderCustomSettings'
	If $__WINVER < 0x0600 Then $sProc &= 'W'

	Local $aRet = DllCall('shell32.dll', 'long', $sProc, 'struct*', $tSHFCS, 'wstr', $sFilePath, 'dword', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellGetSetFolderCustomSettings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetSettings($iFlags)
	Local $tSHELLSTATE = DllStructCreate('uint[8]')
	DllCall('shell32.dll', 'none', 'SHGetSetSettings', 'struct*', $tSHELLSTATE, 'dword', $iFlags, 'bool', 0)
	If @error Then Return SetError(@error, @extended, 0)

	Local $iVal1 = DllStructGetData($tSHELLSTATE, 1, 1)
	Local $iVal2 = DllStructGetData($tSHELLSTATE, 1, 8)
	Local $iResult = 0
	Local $aOpt[20][2] = _
			[[0x00000001, 0x00000001], _
			[0x00000002, 0x00000002], _
			[0x00000004, 0x00008000], _
			[0x00000008, 0x00000020], _
			[0x00000010, 0x00000008], _
			[0x00000020, 0x00000080], _
			[0x00000040, 0x00000200], _
			[0x00000080, 0x00000400], _
			[0x00000100, 0x00000800], _
			[0x00000400, 0x00001000], _
			[0x00000800, 0x00002000], _
			[0x00001000, 0x00004000], _
			[0x00002000, 0x00020000], _
			[0x00008000, 0x00040000], _
			[0x00010000, 0x00100000], _
			[0x00000001, 0x00080000], _
			[0x00000002, 0x00200000], _
			[0x00000008, 0x00800000], _
			[0x00000010, 0x01000000], _
			[0x00000020, 0x02000000]]

	For $i = 0 To 14
		If BitAND($iVal1, $aOpt[$i][0]) Then
			$iResult += $aOpt[$i][1]
		EndIf
	Next
	For $i = 15 To 19
		If BitAND($iVal2, $aOpt[$i][0]) Then
			$iResult += $aOpt[$i][1]
		EndIf
	Next
	Return $iResult
EndFunc   ;==>_WinAPI_ShellGetSettings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetSpecialFolderLocation($iCSIDL)
	Local $aRet = DllCall('shell32.dll', 'long', 'SHGetSpecialFolderLocation', 'hwnd', 0, 'int', $iCSIDL, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_ShellGetSpecialFolderLocation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetSpecialFolderPath($iCSIDL, $bCreate = False)
	Local $aRet = DllCall('shell32.dll', 'bool', 'SHGetSpecialFolderPathW', 'hwnd', 0, 'wstr', '', 'int', $iCSIDL, 'bool', $bCreate)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_ShellGetSpecialFolderPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetStockIconInfo($iSIID, $iFlags)
	Local $tSHSTOCKICONINFO = DllStructCreate($tagSHSTOCKICONINFO)
	DllStructSetData($tSHSTOCKICONINFO, 'Size', DllStructGetSize($tSHSTOCKICONINFO))

	Local $aRet = DllCall('shell32.dll', 'long', 'SHGetStockIconInfo', 'int', $iSIID, 'uint', $iFlags, 'struct*', $tSHSTOCKICONINFO)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tSHSTOCKICONINFO
EndFunc   ;==>_WinAPI_ShellGetStockIconInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellILCreateFromPath($sFilePath)
	Local $aRet = DllCall('shell32.dll', 'long', 'SHILCreateFromPath', 'wstr', $sFilePath, 'ptr*', 0, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_ShellILCreateFromPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellNotifyIcon($iMessage, ByRef $tNOTIFYICONDATA)
	Local $aRet = DllCall('shell32.dll', 'bool', 'Shell_NotifyIconW', 'dword', $iMessage, 'struct*', $tNOTIFYICONDATA)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellNotifyIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellNotifyIconGetRect($hWnd, $iID, $tGUID = 0)
	Local $tNII = DllStructCreate('dword;hwnd;uint;' & $tagGUID)
	DllStructSetData($tNII, 1, DllStructGetSize($tNII))
	DllStructSetData($tNII, 2, $hWnd)
	DllStructSetData($tNII, 3, $iID)

	If IsDllStruct($tGUID) Then
		If Not _WinAPI_MoveMemory(DllStructGetPtr($tNII, 4), $tGUID, 16) Then Return SetError(@error + 10, @extended, 0)
	EndIf

	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('shell32.dll', 'long', 'Shell_NotifyIconGetRect', 'struct*', $tNII, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_ShellNotifyIconGetRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellObjectProperties($sFilePath, $iType = 2, $sProperty = '', $hParent = 0)
	Local $sTypeOfProperty = 'wstr'
	If Not StringStripWS($sProperty, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfProperty = 'ptr'
		$sProperty = 0
	EndIf

	Local $aRet = DllCall('shell32.dll', 'bool', 'SHObjectProperties', 'hwnd', $hParent, 'dword', $iType, 'wstr', $sFilePath, _
			$sTypeOfProperty, $sProperty)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellObjectProperties

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellOpenFolderAndSelectItems($sFilePath, $aNames = 0, $iStart = 0, $iEnd = -1, $iFlags = 0)
	Local $pPIDL, $aRet, $tPtr = 0, $iCount = 0, $iObj = 0, $iError = 0

	$sFilePath = _WinAPI_PathRemoveBackslash(_WinAPI_PathSearchAndQualify($sFilePath))
	If IsArray($aNames) Then
		If $sFilePath And Not _WinAPI_PathIsDirectory($sFilePath) Then Return SetError(@error + 20, @extended, 0)
	EndIf
	$pPIDL = _WinAPI_ShellILCreateFromPath($sFilePath)
	If @error Then Return SetError(@error + 30, @extended, 0)
	If Not __CheckErrorArrayBounds($aNames, $iStart, $iEnd) Then
		$tPtr = DllStructCreate('ptr[' & ($iEnd - $iStart + 1) & ']')
		For $i = $iStart To $iEnd
			$iCount += 1
			If $aNames[$i] Then
				DllStructSetData($tPtr, 1, _WinAPI_ShellILCreateFromPath($sFilePath & '\' & $aNames[$i]), $iCount)
			Else
				DllStructSetData($tPtr, 1, 0, $iCount)
			EndIf
		Next
	EndIf
	If _WinAPI_CoInitialize() Then $iObj = 1
	$aRet = DllCall('shell32.dll', 'long', 'SHOpenFolderAndSelectItems', 'ptr', $pPIDL, 'uint', $iCount, 'struct*', $tPtr, _
			'dword', $iFlags)
	If @error Then
		$iError = @error + 10
	Else
		If $aRet[0] Then $iError = 10
	EndIf
	If $iObj Then _WinAPI_CoUninitialize()
	_WinAPI_CoTaskMemFree($pPIDL)
	For $i = 1 To $iCount
		$pPIDL = DllStructGetData($tPtr, $i)
		If $pPIDL Then
			_WinAPI_CoTaskMemFree($pPIDL)
		EndIf
	Next
	If $iError = 10 Then Return SetError(10, $aRet[0], 0)
	If $iError Then Return SetError($iError, 0, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellOpenFolderAndSelectItems

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellQueryRecycleBin($sRoot = '')
	Local $tSHQRBI = DllStructCreate('align 4;dword_ptr;int64;int64')
	DllStructSetData($tSHQRBI, 1, DllStructGetSize($tSHQRBI))

	Local $aRet = DllCall('shell32.dll', 'long', 'SHQueryRecycleBinW', 'wstr', $sRoot, 'struct*', $tSHQRBI)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[2]
	$aResult[0] = DllStructGetData($tSHQRBI, 2)
	$aResult[1] = DllStructGetData($tSHQRBI, 3)
	Return $aResult
EndFunc   ;==>_WinAPI_ShellQueryRecycleBin

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellQueryUserNotificationState()
	Local $aRet = DllCall('shell32.dll', 'long', 'SHQueryUserNotificationState', 'uint*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_ShellQueryUserNotificationState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellRemoveLocalizedName($sFilePath)
	Local $aRet = DllCall('shell32.dll', 'long', 'SHRemoveLocalizedName', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellRemoveLocalizedName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellRestricted($iRestriction)
	Local $aRet = DllCall('shell32.dll', 'dword', 'SHRestricted', 'uint', $iRestriction)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellRestricted

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellSetKnownFolderPath($sGUID, $sFilePath, $iFlags = 0, $hToken = 0)
	Local $tGUID = DllStructCreate($tagGUID)
	Local $aRet = DllCall('ole32.dll', 'long', 'CLSIDFromString', 'wstr', $sGUID, 'struct*', $tGUID)
	If @error Or $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	$aRet = DllCall('shell32.dll', 'long', 'SHSetKnownFolderPath', 'struct*', $tGUID, 'dword', $iFlags, 'handle', $hToken, 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellSetKnownFolderPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellSetLocalizedName($sFilePath, $sModule, $iResID)
	Local $aRet = DllCall('shell32.dll', 'long', 'SHSetLocalizedName', 'wstr', $sFilePath, 'wstr', $sModule, 'int', $iResID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellSetLocalizedName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellSetSettings($iFlags, $bSet)
	Local $iVal1 = 0, $iVal2 = 0
	Local $aOpt[20][2] = _
			[[0x00000001, 0x00000001], _
			[0x00000002, 0x00000002], _
			[0x00000004, 0x00008000], _
			[0x00000008, 0x00000020], _
			[0x00000010, 0x00000008], _
			[0x00000020, 0x00000080], _
			[0x00000040, 0x00000200], _
			[0x00000080, 0x00000400], _
			[0x00000100, 0x00000800], _
			[0x00000400, 0x00001000], _
			[0x00000800, 0x00002000], _
			[0x00001000, 0x00004000], _
			[0x00002000, 0x00020000], _
			[0x00008000, 0x00040000], _
			[0x00010000, 0x00100000], _
			[0x00000001, 0x00080000], _
			[0x00000002, 0x00200000], _
			[0x00000008, 0x00800000], _
			[0x00000010, 0x01000000], _
			[0x00000020, 0x02000000]]

	If $bSet Then
		For $i = 0 To 14
			If BitAND($iFlags, $aOpt[$i][1]) Then
				$iVal1 += $aOpt[$i][0]
			EndIf
		Next
		For $i = 15 To 19
			If BitAND($iFlags, $aOpt[$i][1]) Then
				$iVal2 += $aOpt[$i][0]
			EndIf
		Next
	EndIf

	Local $tSHELLSTATE = DllStructCreate('uint[8]')
	DllStructSetData($tSHELLSTATE, 1, $iVal1, 1)
	DllStructSetData($tSHELLSTATE, 1, $iVal2, 8)
	DllCall('shell32.dll', 'none', 'SHGetSetSettings', 'struct*', $tSHELLSTATE, 'dword', $iFlags, 'bool', 1)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellSetSettings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellUpdateImage($sIcon, $iIndex, $iImage, $iFlags = 0)
	DllCall('shell32.dll', 'none', 'SHUpdateImageW', 'wstr', $sIcon, 'int', $iIndex, 'uint', $iFlags, 'int', $iImage)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellUpdateImage

#EndRegion Public Functions
