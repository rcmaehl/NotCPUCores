#include-once

#include "APIShPathConstants.au3"
#include "StringConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIShPath.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CommandLineToArgv
; _WinAPI_IsNameInExpression
; _WinAPI_ParseURL
; _WinAPI_ParseUserName
; _WinAPI_PathAddBackslash
; _WinAPI_PathAddExtension
; _WinAPI_PathAppend
; _WinAPI_PathBuildRoot
; _WinAPI_PathCanonicalize
; _WinAPI_PathCommonPrefix
; _WinAPI_PathCompactPath
; _WinAPI_PathCompactPathEx
; _WinAPI_PathCreateFromUrl
; _WinAPI_PathFindExtension
; _WinAPI_PathFindFileName
; _WinAPI_PathFindNextComponent
; _WinAPI_PathFindOnPath
; _WinAPI_PathGetArgs
; _WinAPI_PathGetCharType
; _WinAPI_PathGetDriveNumber
; _WinAPI_PathIsContentType
; _WinAPI_PathIsExe
; _WinAPI_PathIsFileSpec
; _WinAPI_PathIsLFNFileSpec
; _WinAPI_PathIsRelative
; _WinAPI_PathIsRoot
; _WinAPI_PathIsSameRoot
; _WinAPI_PathIsSystemFolder
; _WinAPI_PathIsUNC
; _WinAPI_PathIsUNCServer
; _WinAPI_PathIsUNCServerShare
; _WinAPI_PathMakeSystemFolder
; _WinAPI_PathMatchSpec
; _WinAPI_PathParseIconLocation
; _WinAPI_PathRelativePathTo
; _WinAPI_PathRemoveArgs
; _WinAPI_PathRemoveBackslash
; _WinAPI_PathRemoveExtension
; _WinAPI_PathRemoveFileSpec
; _WinAPI_PathRenameExtension
; _WinAPI_PathSearchAndQualify
; _WinAPI_PathSkipRoot
; _WinAPI_PathStripPath
; _WinAPI_PathStripToRoot
; _WinAPI_PathUndecorate
; _WinAPI_PathUnExpandEnvStrings
; _WinAPI_PathUnmakeSystemFolder
; _WinAPI_PathUnquoteSpaces
; _WinAPI_PathYetAnotherMakeUniqueName
; _WinAPI_ShellGetImageList
; _WinAPI_UrlApplyScheme
; _WinAPI_UrlCanonicalize
; _WinAPI_UrlCombine
; _WinAPI_UrlCompare
; _WinAPI_UrlCreateFromPath
; _WinAPI_UrlFixup
; _WinAPI_UrlGetPart
; _WinAPI_UrlHash
; _WinAPI_UrlIs
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CommandLineToArgv($sCmd)
	Local $aResult[1] = [0]

	$sCmd = StringStripWS($sCmd, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	If Not $sCmd Then
		Return $aResult
	EndIf

	Local $aRet = DllCall('shell32.dll', 'ptr', 'CommandLineToArgvW', 'wstr', $sCmd, 'int*', 0)
	If @error Or Not $aRet[0] Or (Not $aRet[2]) Then Return SetError(@error + 10, @extended, 0)

	Local $tPtr = DllStructCreate('ptr[' & $aRet[2] & ']', $aRet[0])

	Dim $aResult[$aRet[2] + 1] = [$aRet[2]]
	For $i = 1 To $aRet[2]
		$aResult[$i] = _WinAPI_GetString(DllStructGetData($tPtr, 1, $i))
	Next
	; _WinAPI_LocalFree($aRet[0])
	DllCall("kernel32.dll", "handle", "LocalFree", "handle", $aRet[0])

	Return $aResult
EndFunc   ;==>_WinAPI_CommandLineToArgv

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsNameInExpression($sString, $sPattern, $bCaseSensitive = False)
	If Not $bCaseSensitive Then $sPattern = StringUpper($sPattern)

	Local $tUS1 = __US($sPattern)
	Local $tUS2 = __US($sString)
	Local $aRet = DllCall('ntdll.dll', 'boolean', 'RtlIsNameInExpression', 'struct*', $tUS1, 'struct*', $tUS2, _
			'boolean', Not $bCaseSensitive, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsNameInExpression

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ParseURL($sUrl)
	Local $tagPARSEDURL = 'dword Size;ptr Protocol;uint cchProtocol;ptr Suffix;uint cchSuffix;uint Scheme'
	Local $tPURL = DllStructCreate($tagPARSEDURL)
	DllStructSetData($tPURL, 1, DllStructGetSize($tPURL))
	Local $tURL = DllStructCreate('wchar[4096]') ; needed as 'wstr', $sUrl is not working
	DllStructSetData($tURL, 1, $sUrl)

	Local $aRet = DllCall('shlwapi.dll', 'long', 'ParseURLW', 'struct*', $tURL, 'struct*', $tPURL)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Local $aResult[3]
	$aResult[0] = DllStructGetData(DllStructCreate('wchar[' & DllStructGetData($tPURL, 3) & ']', DllStructGetData($tPURL, 2)), 1)
	$aResult[1] = DllStructGetData(DllStructCreate('wchar[' & DllStructGetData($tPURL, 5) & ']', DllStructGetData($tPURL, 4)), 1)
	$aResult[2] = DllStructGetData($tPURL, 6)
	Return $aResult
EndFunc   ;==>_WinAPI_ParseURL

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ParseUserName($sUser)
	If Not __DLL('credui.dll') Then Return SetError(103, 0, 0)

	Local $aRet = DllCall('credui.dll', 'dword', 'CredUIParseUserNameW', 'wstr', $sUser, 'wstr', '', 'ulong', 4096, 'wstr', '', _
			'ulong', 4096)
	If @error Then Return SetError(@error, @extended, 0)
	Switch $aRet[0]
		Case 0

		Case 1315 ; ERROR_INVALID_ACCOUNT_NAME
			If StringStripWS($sUser, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
				$aRet[2] = $sUser
				$aRet[4] = ''
			Else
				ContinueCase
			EndIf
		Case Else
			Return SetError(10, $aRet[0], 0)
	EndSwitch

	Local $aResult[2]
	$aResult[0] = $aRet[4]
	$aResult[1] = $aRet[2]
	Return $aResult
EndFunc   ;==>_WinAPI_ParseUserName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PathAddBackslash($sFilePath)
	Local $tPath = DllStructCreate('wchar[260]') ; avoid buffer overflow
	DllStructSetData($tPath, 1, $sFilePath)

	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'PathAddBackslashW', 'struct*', $tPath)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')

	Return DllStructGetData($tPath, 1)
EndFunc   ;==>_WinAPI_PathAddBackslash

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PathAddExtension($sFilePath, $sExt = '')
	Local $tPath = DllStructCreate('wchar[260]') ; avoid buffer overflow
	DllStructSetData($tPath, 1, $sFilePath)

	Local $sTypeOfExt = 'wstr'
	If Not StringStripWS($sExt, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfExt = 'ptr'
		$sExt = 0
	EndIf

	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathAddExtensionW', 'struct*', $tPath, $sTypeOfExt, $sExt)
	If @error Then Return SetError(@error, @extended, '')

	Return SetExtended($aRet[0], DllStructGetData($tPath, 1))
EndFunc   ;==>_WinAPI_PathAddExtension

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PathAppend($sFilePath, $sMore)
	Local $tPath = DllStructCreate('wchar[260]') ; avoid buffer overflow
	DllStructSetData($tPath, 1, $sFilePath)

	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathAppendW', 'struct*', $tPath, 'wstr', $sMore)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return DllStructGetData($tPath, 1)
EndFunc   ;==>_WinAPI_PathAppend

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathBuildRoot($iDrive)
	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'PathBuildRootW', 'wstr', '', 'int', $iDrive)
	If @error Then Return SetError(@error, @extended, '')
	; If Not $aRet[1] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathBuildRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathCanonicalize($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathCanonicalizeW', 'wstr', '', 'wstr', $sFilePath)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, $sFilePath)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathCanonicalize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathCommonPrefix($sPath1, $sPath2)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'PathCommonPrefixW', 'wstr', $sPath1, 'wstr', $sPath2, 'wstr', '')
	If @error Then Return SetError(@error, @extended, '')

	Return SetExtended($aRet[0], $aRet[3])
EndFunc   ;==>_WinAPI_PathCommonPrefix

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathCompactPath($hWnd, $sFilePath, $iWidth = 0)
	If $iWidth < 1 Then
		; $iWidth += _WinAPI_GetClientWidth($hWnd)
		Local $tRECT = DllStructCreate($tagRECT)
		DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "struct*", $tRECT)
		$iWidth += DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
	EndIf
	Local $aRet = DllCall('user32.dll', 'handle', 'GetDC', 'hwnd', $hWnd)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, $sFilePath)

	Local $hDC = $aRet[0]
	Local Const $WM_GETFONT = 0x0031
	$aRet = DllCall('user32.dll', 'ptr', 'SendMessage', 'hwnd', $hWnd, 'uint', $WM_GETFONT, 'wparam', 0, 'lparam', 0) ; $WM_GETFONT

	; Local $hBack = _WinAPI_SelectObject($hDC, $aRet[0])
	Local $hBack = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $aRet[0])
	Local $iError = 0
	$aRet = DllCall('shlwapi.dll', 'bool', 'PathCompactPathW', 'handle', $hDC, 'wstr', $sFilePath, 'int', $iWidth)
	If @error Or Not $aRet[0] Then $iError = @error + 10
	; _WinAPI_SelectObject($hDC, $hBack[0])
	DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hBack[0])
	; _WinAPI_ReleaseDC($hWnd, $hDC)
	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	If $iError Then Return SetError($iError, 0, $sFilePath)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_PathCompactPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathCompactPathEx($sFilePath, $iMax)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathCompactPathExW', 'wstr', '', 'wstr', $sFilePath, 'uint', $iMax + 1, 'dword', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, $sFilePath)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathCompactPathEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathCreateFromUrl($sUrl)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'PathCreateFromUrlW', 'wstr', $sUrl, 'wstr', '', 'dword*', 4096, 'dword', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_PathCreateFromUrl

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathFindExtension($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'wstr', 'PathFindExtensionW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathFindExtension

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathFindFileName($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'wstr', 'PathFindFileNameW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, $sFilePath)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathFindFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathFindNextComponent($sFilePath)
	Local $tPath = DllStructCreate('wchar[' & (StringLen($sFilePath) + 1) & ']')
	DllStructSetData($tPath, 1, $sFilePath)

	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'PathFindNextComponentW', 'struct*', $tPath)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return _WinAPI_GetString($aRet[0])
EndFunc   ;==>_WinAPI_PathFindNextComponent

; #FUNCTION# ====================================================================================================================
; Author ........: Daniel Miranda (danielkza)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PathFindOnPath(Const $sFilePath, $aExtraPaths = "", Const $sPathDelimiter = @LF)
	Local $iExtraCount = 0
	If IsString($aExtraPaths) Then
		If StringLen($aExtraPaths) Then
			$aExtraPaths = StringSplit($aExtraPaths, $sPathDelimiter, $STR_ENTIRESPLIT + $STR_NOCOUNT)
			$iExtraCount = UBound($aExtraPaths, $UBOUND_ROWS)
		EndIf
	ElseIf IsArray($aExtraPaths) Then
		$iExtraCount = UBound($aExtraPaths)
	EndIf

	Local $tPaths, $tPathPtrs
	If $iExtraCount Then
		Local $tagStruct = ""
		For $path In $aExtraPaths
			$tagStruct &= "wchar[" & StringLen($path) + 1 & "];"
		Next

		$tPaths = DllStructCreate($tagStruct)
		$tPathPtrs = DllStructCreate("ptr[" & $iExtraCount + 1 & "]")

		For $i = 1 To $iExtraCount
			DllStructSetData($tPaths, $i, $aExtraPaths[$i - 1])
			DllStructSetData($tPathPtrs, 1, DllStructGetPtr($tPaths, $i), $i)
		Next
		DllStructSetData($tPathPtrs, 1, Ptr(0), $iExtraCount + 1)
	EndIf

	Local $aResult = DllCall("shlwapi.dll", "bool", "PathFindOnPathW", "wstr", $sFilePath, "struct*", $tPathPtrs)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, $sFilePath)

	Return $aResult[1]
EndFunc   ;==>_WinAPI_PathFindOnPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathGetArgs($sFilePath)
	Local $tPath = DllStructCreate('wchar[' & (StringLen($sFilePath) + 1) & ']')
	DllStructSetData($tPath, 1, $sFilePath)

	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'PathGetArgsW', 'struct*', $tPath)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')

	Return _WinAPI_GetString($aRet[0])
EndFunc   ;==>_WinAPI_PathGetArgs

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathGetCharType($sChar)
	Local $aRet = DllCall('shlwapi.dll', 'uint', 'PathGetCharTypeW', 'word', AscW($sChar))
	If @error Then Return SetError(@error, @extended, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathGetCharType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathGetDriveNumber($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'PathGetDriveNumberW', 'wstr', $sFilePath)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error, @extended, '')
	; If $aRet[0] = -1 Then Return SetError(1000, 0, '')

	Return Chr($aRet[0] + 65) & ':'
EndFunc   ;==>_WinAPI_PathGetDriveNumber

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsContentType($sFilePath, $sType)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsContentTypeW', 'wstr', $sFilePath, 'wstr', $sType)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsContentType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsExe($sFilePath)
	Local $aRet = DllCall('shell32.dll', 'bool', 'PathIsExe', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsExe

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsFileSpec($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsFileSpecW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsFileSpec

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsLFNFileSpec($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsLFNFileSpecW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsLFNFileSpec

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsRelative($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsRelativeW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsRelative

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsRoot($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsRootW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsSameRoot($sPath1, $sPath2)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsSameRootW', 'wstr', $sPath1, 'wstr', $sPath2)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsSameRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsSystemFolder($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsSystemFolderW', 'wstr', $sFilePath, 'dword', 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsSystemFolder

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsUNC($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsUNCW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsUNC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsUNCServer($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsUNCServerW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsUNCServer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsUNCServerShare($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsUNCServerShareW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsUNCServerShare

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathMakeSystemFolder($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathMakeSystemFolderW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathMakeSystemFolder

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathMatchSpec($sFilePath, $sSpec)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathMatchSpecW', 'wstr', $sFilePath, 'wstr', $sSpec)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathMatchSpec

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathParseIconLocation($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'PathParseIconLocationW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aResult[2]
	$aResult[0] = $aRet[1]
	$aResult[1] = $aRet[0]
	Return $aResult
EndFunc   ;==>_WinAPI_PathParseIconLocation

; #FUNCTION# ====================================================================================================================
; Author.........: Mat
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_PathRelativePathTo($sPathFrom, $bDirFrom, $sPathTo, $bDirTo)
	If $bDirFrom Then
		$bDirFrom = 0x10
	EndIf
	If $bDirTo Then
		$bDirTo = 0x10
	EndIf

	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathRelativePathToW', 'wstr', '', 'wstr', $sPathFrom, 'dword', $bDirFrom, _
			'wstr', $sPathTo, 'dword', $bDirTo)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathRelativePathTo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathRemoveArgs($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'none', 'PathRemoveArgsW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathRemoveArgs

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathRemoveBackslash($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'PathRemoveBackslashW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathRemoveBackslash

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathRemoveExtension($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'none', 'PathRemoveExtensionW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathRemoveExtension

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathRemoveFileSpec($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathRemoveFileSpecW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return SetExtended($aRet[0], $aRet[1])
EndFunc   ;==>_WinAPI_PathRemoveFileSpec

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PathRenameExtension($sFilePath, $sExt)
	Local $tPath = DllStructCreate('wchar[260]') ; as described in MSDN
	DllStructSetData($tPath, 1, $sFilePath)

	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathRenameExtensionW', 'struct*', $tPath, 'wstr', $sExt)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return DllStructGetData($tPath, 1)
EndFunc   ;==>_WinAPI_PathRenameExtension

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathSearchAndQualify($sFilePath, $bExists = False)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathSearchAndQualifyW', 'wstr', $sFilePath, 'wstr', '', 'int', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')
	If $bExists And Not FileExists($aRet[2]) Then Return SetError(20, 0, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_PathSearchAndQualify

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathSkipRoot($sFilePath)
	Local $tPath = DllStructCreate('wchar[' & (StringLen($sFilePath) + 1) & ']')
	DllStructSetData($tPath, 1, $sFilePath)

	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'PathSkipRootW', 'struct*', $tPath)
	If @error Then Return SetError(@error, @extended, '')
	If Not $aRet[0] Then Return $sFilePath

	Return _WinAPI_GetString($aRet[0])
EndFunc   ;==>_WinAPI_PathSkipRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathStripPath($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'none', 'PathStripPathW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathStripPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathStripToRoot($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathStripToRootW', 'wstr', $sFilePath)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathStripToRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathUndecorate($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'none', 'PathUndecorateW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathUndecorate

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathUnExpandEnvStrings($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathUnExpandEnvStringsW', 'wstr', $sFilePath, 'wstr', '', 'uint', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_PathUnExpandEnvStrings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathUnmakeSystemFolder($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathUnmakeSystemFolderW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathUnmakeSystemFolder

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathUnquoteSpaces($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'none', 'PathUnquoteSpacesW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathUnquoteSpaces

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathYetAnotherMakeUniqueName($sFilePath)
	Local $aRet = DllCall('shell32.dll', 'int', 'PathYetAnotherMakeUniqueName', 'wstr', '', 'wstr', $sFilePath, 'ptr', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_PathYetAnotherMakeUniqueName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellGetImageList($bSmall = False)
	Local $pLarge, $pSmall, $tPtr = DllStructCreate('ptr')
	If $bSmall Then
		$pLarge = 0
		$pSmall = DllStructGetPtr($tPtr)
	Else
		$pLarge = DllStructGetPtr($tPtr)
		$pSmall = 0
	EndIf

	Local $aRet = DllCall('shell32.dll', 'int', 'Shell_GetImageLists', 'ptr', $pLarge, 'ptr', $pSmall)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return DllStructGetData($tPtr, 1)
EndFunc   ;==>_WinAPI_ShellGetImageList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlApplyScheme($sUrl, $iFlags = 1)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlApplySchemeW', 'wstr', $sUrl, 'wstr', '', 'dword*', 4096, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_UrlApplyScheme

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlCanonicalize($sUrl, $iFlags)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlCanonicalizeW', 'wstr', $sUrl, 'wstr', '', 'dword*', 4096, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_UrlCanonicalize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlCombine($sUrl, $sPart, $iFlags = 0)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlCombineW', 'wstr', $sUrl, 'wstr', $sPart, 'wstr', '', 'dword*', 4096, _
			'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_UrlCombine

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UrlCompare($sUrl1, $sUrl2, $bIgnoreSlash = False)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'UrlCompareW', 'wstr', $sUrl1, 'wstr', $sUrl2, 'bool', $bIgnoreSlash)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UrlCompare

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlCreateFromPath($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlCreateFromPathW', 'wstr', $sFilePath, 'wstr', '', 'dword*', 4096, 'dword', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] < 0 Or $aRet[0] > 1 Then ; S_OK, S_FALSE
		Return SetError(10, $aRet[0], '')
	EndIf

	Return $aRet[2]
EndFunc   ;==>_WinAPI_UrlCreateFromPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlFixup($sUrl)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlFixupW', 'wstr', $sUrl, 'wstr', '', 'dword', 4096)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_UrlFixup

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlGetPart($sUrl, $iPart)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlGetPartW', 'wstr', $sUrl, 'wstr', '', 'dword*', 4096, 'dword', $iPart, _
			'dword', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_UrlGetPart

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlHash($sUrl, $iLength = 32)
	If $iLength <= 0 Or $iLength > 256 Then Return SetError(256, 0, 0)

	Local $tData = DllStructCreate('byte[' & $iLength & ']')

	Local $aRet = DllCall('shlwapi.dll', 'long', 'UrlHashW', 'wstr', $sUrl, 'struct*', $tData, 'dword', $iLength)
	If @error Then Return SetError(@error + 10, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_UrlHash

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UrlIs($sUrl, $iType = 0)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'UrlIsW', 'wstr', $sUrl, 'uint', $iType)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UrlIs

#EndRegion Public Functions

#Region Internal Functions

Func __US($sString, $iLength = 0)
	If $iLength Then
		$sString = StringLeft($sString, $iLength)
	Else
		$iLength = StringLen($sString)
	EndIf

	Local $tUS = DllStructCreate('ushort;ushort;ptr;wchar[' & ($iLength + 1) & ']')
	DllStructSetData($tUS, 1, 2 * StringLen($sString))
	DllStructSetData($tUS, 2, 2 * $iLength)
	DllStructSetData($tUS, 3, DllStructGetPtr($tUS, 4))
	DllStructSetData($tUS, 4, $sString)
	Return $tUS
EndFunc   ;==>__US

#EndRegion Internal Functions
