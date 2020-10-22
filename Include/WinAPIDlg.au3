#include-once

#include "APIDlgConstants.au3"
#include "StringConstants.au3"
#include "StructureConstants.au3"
#include "WinAPICom.au3"
#include "WinAPIConstants.au3"
#include "WinAPIInternals.au3"
#include "WinAPIMem.au3"
#include "WinAPIMisc.au3"
#include "WinAPIShellEx.au3"
#include "WinAPIShPath.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIDlg.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_pFRBuffer = 0, $__g_iFRBufferSize = 16385
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagDEVNAMES = 'ushort DriverOffset;ushort DeviceOffset;ushort OutputOffset;ushort Default'
Global Const $tagFINDREPLACE = 'dword Size;hwnd hOwner;ptr hInstance;dword Flags;ptr FindWhat;ptr ReplaceWith;ushort FindWhatLen;ushort ReplaceWithLen;lparam lParam;ptr Hook;ptr TemplateName'
Global Const $tagMSGBOXPARAMS = 'uint Size;hwnd hOwner;ptr hInstance;int_ptr Text;int_ptr Caption;dword Style;int_ptr Icon;dword_ptr ContextHelpId;ptr MsgBoxCallback;dword LanguageId'
Global Const $tagPAGESETUPDLG = 'dword Size;hwnd hOwner;ptr hDevMode;ptr hDevNames;dword Flags;long PaperWidth;long PaperHeight;long MarginMinLeft;long MarginMinTop;long MarginMinRight;long MarginMinBottom;long MarginLeft;long MarginTop;long MarginRight;long MarginBottom;ptr hInstance;lparam lParam;ptr PageSetupHook;ptr PagePaintHook;ptr PageSetupTemplateName;ptr hPageSetupTemplate'
Global Const $tagPRINTDLG = (@AutoItX64 ? '' : 'align 2;') & 'dword Size;hwnd hOwner;handle hDevMode;handle hDevNames;handle hDC;dword Flags;word FromPage;word ToPage;word MinPage;word MaxPage;word Copies;handle hInstance;lparam lParam;ptr PrintHook;ptr SetupHook;ptr PrintTemplateName;ptr SetupTemplateName;handle hPrintTemplate;handle hSetupTemplate'
Global Const $tagPRINTDLGEX = 'dword Size;hwnd hOwner;handle hDevMode;handle hDevNames;handle hDC;dword Flags;dword Flags2;dword ExclusionFlags;dword NumPageRanges;dword MaxPageRanges;ptr PageRanges;dword MinPage;dword MaxPage;dword Copies;handle hInstance;ptr PrintTemplateName;lparam lParam;dword NumPropertyPages;ptr hPropertyPages;dword StartPage;dword ResultAction'
Global Const $tagPRINTPAGERANGE = 'dword FromPage;dword ToPage'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_BrowseForFolderDlg
; _WinAPI_CommDlgExtendedError
; _WinAPI_CommDlgExtendedErrorEx
; _WinAPI_ConfirmCredentials
; _WinAPI_FindTextDlg
; _WinAPI_FlushFRBuffer
; _WinAPI_FormatDriveDlg
; _WinAPI_GetConnectedDlg
; _WinAPI_GetFRBuffer
; _WinAPI_GetOpenFileName
; _WinAPI_GetSaveFileName
; _WinAPI_MessageBoxCheck
; _WinAPI_MessageBoxIndirect
; _WinAPI_OpenFileDlg
; _WinAPI_PageSetupDlg
; _WinAPI_PickIconDlg
; _WinAPI_PrintDlg
; _WinAPI_PrintDlgEx
; _WinAPI_ReplaceTextDlg
; _WinAPI_RestartDlg
; _WinAPI_SaveFileDlg
; _WinAPI_SetFRBuffer
; _WinAPI_ShellAboutDlg
; _WinAPI_ShellOpenWithDlg
; _WinAPI_ShellStartNetConnectionDlg
; _WinAPI_ShellUserAuthenticationDlg
; _WinAPI_ShellUserAuthenticationDlgEx
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __OFNDlg
; __WinAPI_ParseMultiSelectFileDialogPath
; __WinAPI_ParseFileDialogPath
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BrowseForFolderDlg($sRoot = '', $sText = '', $iFlags = 0, $pBrowseProc = 0, $lParam = 0, $hParent = 0)
	Local Const $tagBROWSEINFO = 'hwnd hwndOwner;ptr pidlRoot;ptr pszDisplayName; ptr lpszTitle;uint ulFlags;ptr lpfn;lparam lParam;int iImage'
	Local $tBROWSEINFO = DllStructCreate($tagBROWSEINFO & ';wchar[' & (StringLen($sText) + 1) & '];wchar[260]')
	Local $pPIDL = 0, $sResult = ''

	If StringStripWS($sRoot, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		Local $sPath = _WinAPI_PathSearchAndQualify($sRoot, 1)
		If @error Then
			$sPath = $sRoot
		EndIf
		$pPIDL = _WinAPI_ShellILCreateFromPath($sPath)
		If @error Then
			; Nothing
		EndIf
	EndIf

	DllStructSetData($tBROWSEINFO, 1, $hParent)
	DllStructSetData($tBROWSEINFO, 2, $pPIDL)
	DllStructSetData($tBROWSEINFO, 3, DllStructGetPtr($tBROWSEINFO, 10))
	DllStructSetData($tBROWSEINFO, 4, DllStructGetPtr($tBROWSEINFO, 9))
	DllStructSetData($tBROWSEINFO, 5, $iFlags)
	DllStructSetData($tBROWSEINFO, 6, $pBrowseProc)
	DllStructSetData($tBROWSEINFO, 7, $lParam)
	DllStructSetData($tBROWSEINFO, 8, 0)
	DllStructSetData($tBROWSEINFO, 9, $sText)

	Local $aRet = DllCall('shell32.dll', 'ptr', 'SHBrowseForFolderW', 'struct*', $tBROWSEINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	$sResult = _WinAPI_ShellGetPathFromIDList($aRet[0])
	_WinAPI_CoTaskMemFree($aRet[0])
	If $pPIDL Then
		_WinAPI_CoTaskMemFree($pPIDL)
	EndIf
	If Not $sResult Then Return SetError(10, 0, '')

	Return $sResult
EndFunc   ;==>_WinAPI_BrowseForFolderDlg

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_CommDlgExtendedError()
	Local Const $CDERR_DIALOGFAILURE = 0xFFFF
	Local Const $CDERR_FINDRESFAILURE = 0x06
	Local Const $CDERR_INITIALIZATION = 0x02
	Local Const $CDERR_LOADRESFAILURE = 0x07
	Local Const $CDERR_LOADSTRFAILURE = 0x05
	Local Const $CDERR_LOCKRESFAILURE = 0x08
	Local Const $CDERR_MEMALLOCFAILURE = 0x09
	Local Const $CDERR_MEMLOCKFAILURE = 0x0A
	Local Const $CDERR_NOHINSTANCE = 0x04
	Local Const $CDERR_NOHOOK = 0x0B
	Local Const $CDERR_NOTEMPLATE = 0x03
	Local Const $CDERR_REGISTERMSGFAIL = 0x0C
	Local Const $CDERR_STRUCTSIZE = 0x01
	Local Const $FNERR_BUFFERTOOSMALL = 0x3003
	Local Const $FNERR_INVALIDFILENAME = 0x3002
	Local Const $FNERR_SUBCLASSFAILURE = 0x3001
	Local $aResult = DllCall("comdlg32.dll", "dword", "CommDlgExtendedError")
	If Not @error Then
		Switch $aResult[0]
			Case $CDERR_DIALOGFAILURE
				Return SetError($aResult[0], 0, "The dialog box could not be created." & @LF & _
						"The common dialog box function's call to the DialogBox function failed." & @LF & _
						"For example, this error occurs if the common dialog box call specifies an invalid window handle.")
			Case $CDERR_FINDRESFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to find a specified resource.")
			Case $CDERR_INITIALIZATION
				Return SetError($aResult[0], 0, "The common dialog box function failed during initialization." & @LF & "This error often occurs when sufficient memory is not available.")
			Case $CDERR_LOADRESFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to load a specified resource.")
			Case $CDERR_LOADSTRFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to load a specified string.")
			Case $CDERR_LOCKRESFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to lock a specified resource.")
			Case $CDERR_MEMALLOCFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function was unable to allocate memory for internal structures.")
			Case $CDERR_MEMLOCKFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function was unable to lock the memory associated with a handle.")
			Case $CDERR_NOHINSTANCE
				Return SetError($aResult[0], 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & _
						"but you failed to provide a corresponding instance handle.")
			Case $CDERR_NOHOOK
				Return SetError($aResult[0], 0, "The ENABLEHOOK flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & _
						"but you failed to provide a pointer to a corresponding hook procedure.")
			Case $CDERR_NOTEMPLATE
				Return SetError($aResult[0], 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & _
						"but you failed to provide a corresponding template.")
			Case $CDERR_REGISTERMSGFAIL
				Return SetError($aResult[0], 0, "The RegisterWindowMessage function returned an error code when it was called by the common dialog box function.")
			Case $CDERR_STRUCTSIZE
				Return SetError($aResult[0], 0, "The lStructSize member of the initialization structure for the corresponding common dialog box is invalid")
			Case $FNERR_BUFFERTOOSMALL
				Return SetError($aResult[0], 0, "The buffer pointed to by the lpstrFile member of the OPENFILENAME structure is too small for the file name specified by the user." & @LF & _
						"The first two bytes of the lpstrFile buffer contain an integer value specifying the size, in TCHARs, required to receive the full name.")
			Case $FNERR_INVALIDFILENAME
				Return SetError($aResult[0], 0, "A file name is invalid.")
			Case $FNERR_SUBCLASSFAILURE
				Return SetError($aResult[0], 0, "An attempt to subclass a list box failed because sufficient memory was not available.")
		EndSwitch
	EndIf
	Return SetError(@error, @extended, '0x' & Hex($aResult[0]))
EndFunc   ;==>_WinAPI_CommDlgExtendedError

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CommDlgExtendedErrorEx()
	Local $aRet = DllCall('comdlg32.dll', 'dword', 'CommDlgExtendedError')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CommDlgExtendedErrorEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ConfirmCredentials($sTarget, $bConfirm)
	If Not __DLL('credui.dll') Then Return SetError(103, 0, 0)

	Local $aRet = DllCall('credui.dll', 'dword', 'CredUIConfirmCredentialsW', 'wstr', $sTarget, 'bool', $bConfirm)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ConfirmCredentials

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindTextDlg($hOwner, $sFindWhat = '', $iFlags = 0, $pFindProc = 0, $lParam = 0)
	$__g_pFRBuffer = __HeapReAlloc($__g_pFRBuffer, 2 * $__g_iFRBufferSize)
	If @error Then Return SetError(@error + 20, @extended, 0)

	DllStructSetData(DllStructCreate('wchar[' & $__g_iFRBufferSize & ']', $__g_pFRBuffer), 1, StringLeft($sFindWhat, $__g_iFRBufferSize - 1))
	Local $tFR = DllStructCreate($tagFINDREPLACE)
	DllStructSetData($tFR, 'Size', DllStructGetSize($tFR))
	DllStructSetData($tFR, 'hOwner', $hOwner)
	DllStructSetData($tFR, 'hInstance', 0)
	DllStructSetData($tFR, 'Flags', $iFlags)
	DllStructSetData($tFR, 'FindWhat', $__g_pFRBuffer)
	DllStructSetData($tFR, 'ReplaceWith', 0)
	DllStructSetData($tFR, 'FindWhatLen', $__g_iFRBufferSize * 2)
	DllStructSetData($tFR, 'ReplaceWithLen', 0)
	DllStructSetData($tFR, 'lParam', $lParam)
	DllStructSetData($tFR, 'Hook', $pFindProc)
	DllStructSetData($tFR, 'TemplateName', 0)

	Local $aRet = DllCall('comdlg32.dll', 'hwnd', 'FindTextW', 'struct*', $tFR)
	If @error Or Not $aRet[0] Then
		Local $iError = @error + 30
		__HeapFree($__g_pFRBuffer)
		If IsArray($aRet) Then
			Return SetError(10, _WinAPI_CommDlgExtendedErrorEx(), 0)
		Else
			Return SetError($iError, @extended, 0)
		EndIf
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindTextDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FlushFRBuffer()
	If Not __HeapFree($__g_pFRBuffer, 1) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_FlushFRBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FormatDriveDlg($sDrive, $iOption = 0, $hParent = 0)
	If Not IsString($sDrive) Then Return SetError(10, 0, 0)

	$sDrive = StringLeft(StringUpper(StringStripWS($sDrive, $STR_STRIPLEADING)), 1)
	If Not $sDrive Then Return SetError(11, 0, 0)

	$sDrive = Asc($sDrive) - 65
	If ($sDrive < 0) Or ($sDrive > 25) Then Return SetError(12, 0, 0)

	Local $aRet = DllCall('shell32.dll', 'dword', 'SHFormatDrive', 'hwnd', $hParent, 'uint', $sDrive, 'uint', 0xFFFF, _
			'uint', $iOption)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] < 0 Then Return SetError($aRet[0], 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FormatDriveDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetConnectedDlg($iDlg, $iFlags = 0, $hParent = 0)
	If Not __DLL('connect.dll') Then Return SetError(103, 0, 0)

	Switch $iDlg
		Case 0
			$iDlg = 'GetNetworkConnected'
		Case 1
			$iDlg = 'GetInternetConnected'
		Case 2
			$iDlg = 'GetVPNConnected'
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	Local $sStr = ''

	If BitAND($iFlags, 1) Then
		$sStr &= '-SkipInternetDetection '
	EndIf
	If BitAND($iFlags, 2) Then
		$sStr &= '-SkipExistingConnections '
	EndIf
	If BitAND($iFlags, 4) Then
		$sStr &= '-HideFinishPage '
	EndIf

	Local $aRet = DllCall('connect.dll', 'long', $iDlg, 'hwnd', $hParent, 'dword', 0, 'dword', 0, 'dword', 0, 'handle', 0, _
			'wstr', StringStripWS($sStr, $STR_STRIPTRAILING))
	If @error Then Return SetError(@error, @extended, 0)
	If Not ($aRet[0] = 0 Or $aRet[0] = 1) Then Return SetError(10, $aRet[0], 0) ; not S_OK nor S_FALSE

	Return Number(Not $aRet[0])
EndFunc   ;==>_WinAPI_GetConnectedDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetFRBuffer()
	Return $__g_iFRBufferSize - 1
EndFunc   ;==>_WinAPI_GetFRBuffer

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetOpenFileName($sTitle = "", $sFilter = "All files (*.*)", $sInitalDir = ".", $sDefaultFile = "", $sDefaultExt = "", $iFilterIndex = 1, $iFlags = 0, $iFlagsEx = 0, $hWndOwner = 0)
;~ 	Local $aFiles[1] = [0]
	Local $vResult = __OFNDlg(0, $sTitle, $sInitalDir, $sFilter, $iFilterIndex, $sDefaultFile, $sDefaultExt, $iFlags, $iFlagsEx, 0, 0, $hWndOwner)
	If @error Then Return SetError(@error, @extended, '')
	If BitAND($iFlags, $OFN_ALLOWMULTISELECT) Then
		Return __WinAPI_ParseMultiSelectFileDialogPath($vResult)
	Else
		Return __WinAPI_ParseFileDialogPath($vResult)
	EndIf
EndFunc   ;==>_WinAPI_GetOpenFileName

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSaveFileName($sTitle = "", $sFilter = "All files (*.*)", $sInitalDir = ".", $sDefaultFile = "", $sDefaultExt = "", $iFilterIndex = 1, $iFlags = 0, $iFlagsEx = 0, $hWndOwner = 0)
;~ 	Local $aFiles[1] = [0]
	Local $sReturn = __OFNDlg(1, $sTitle, $sInitalDir, $sFilter, $iFilterIndex, $sDefaultFile, $sDefaultExt, $iFlags, $iFlagsEx, 0, 0, $hWndOwner)
	If @error Then Return SetError(@error, @extended, '')

	Return __WinAPI_ParseFileDialogPath($sReturn)
EndFunc   ;==>_WinAPI_GetSaveFileName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_MessageBoxCheck($iType, $sTitle, $sText, $sRegVal, $iDefault = -1, $hParent = 0)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'SHMessageBoxCheckW', 'hwnd', $hParent, 'wstr', $sText, 'wstr', $sTitle, _
			'uint', $iType, 'int', $iDefault, 'wstr', $sRegVal)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MessageBoxCheck

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_MessageBoxIndirect($tMSGBOXPARAMS)
	Local $aRet = DllCall('user32.dll', 'int', 'MessageBoxIndirectW', 'struct*', $tMSGBOXPARAMS)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MessageBoxIndirect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OpenFileDlg($sTitle = '', $sInitDir = '', $sFilters = '', $iDefaultFilter = 0, $sDefaultFilePath = '', $sDefaultExt = '', $iFlags = 0, $iFlagsEx = 0, $pOFNProc = 0, $pData = 0, $hParent = 0)
	Local $sResult = __OFNDlg(0, $sTitle, $sInitDir, $sFilters, $iDefaultFilter, $sDefaultFilePath, $sDefaultExt, $iFlags, $iFlagsEx, $pOFNProc, $pData, $hParent)
	If @error Then Return SetError(@error, @extended, '')

	Return $sResult
EndFunc   ;==>_WinAPI_OpenFileDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PageSetupDlg(ByRef $tPAGESETUPDLG)
	Local $aRet = DllCall('comdlg32.dll', 'int', 'PageSetupDlgW', 'struct*', $tPAGESETUPDLG)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_CommDlgExtendedErrorEx(), 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PageSetupDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PickIconDlg($sIcon = '', $iIndex = 0, $hParent = 0)
	Local $aRet = DllCall('shell32.dll', 'int', 'PickIconDlg', 'hwnd', $hParent, 'wstr', $sIcon, 'int', 4096, 'int*', $iIndex)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Local $aResult[2]
	; $aResult[0] = _WinAPI_ExpandEnvironmentStrings($aRet[2])
	Local $aRes = DllCall("kernel32.dll", "dword", "ExpandEnvironmentStringsW", "wstr", $aRet[2], "wstr", "", "dword", 4096)
	$aResult[0] = $aRes[2]

	$aResult[1] = $aRet[4]
	Return $aResult
EndFunc   ;==>_WinAPI_PickIconDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PrintDlg(ByRef $tPRINTDLG)
	Local $aRet = DllCall('comdlg32.dll', 'long', 'PrintDlgW', 'struct*', $tPRINTDLG)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_CommDlgExtendedErrorEx(), 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PrintDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PrintDlgEx(ByRef $tPRINTDLGEX)
	Local $tPDEX = DllStructCreate($tagPRINTDLGEX, DllStructGetPtr($tPRINTDLGEX))
	Local $aRet = DllCall('comdlg32.dll', 'long', 'PrintDlgExW', 'struct*', $tPDEX)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return SetExtended(DllStructGetData($tPDEX, 'ResultAction'), 1)
EndFunc   ;==>_WinAPI_PrintDlgEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ReplaceTextDlg($hOwner, $sFindWhat = '', $sReplaceWith = '', $iFlags = 0, $pReplaceProc = 0, $lParam = 0)
	$__g_pFRBuffer = __HeapReAlloc($__g_pFRBuffer, 4 * $__g_iFRBufferSize)
	If @error Then Return SetError(@error + 100, @extended, 0)
	Local $tBuff = DllStructCreate('wchar[' & $__g_iFRBufferSize & '];wchar[' & $__g_iFRBufferSize & ']', $__g_pFRBuffer)
	DllStructSetData($tBuff, 1, StringLeft($sFindWhat, $__g_iFRBufferSize - 1))
	DllStructSetData($tBuff, 2, StringLeft($sReplaceWith, $__g_iFRBufferSize - 1))
	Local $tFR = DllStructCreate($tagFINDREPLACE)
	DllStructSetData($tFR, 'Size', DllStructGetSize($tFR))
	DllStructSetData($tFR, 'hOwner', $hOwner)
	DllStructSetData($tFR, 'hInstance', 0)
	DllStructSetData($tFR, 'Flags', $iFlags)
	DllStructSetData($tFR, 'FindWhat', DllStructGetPtr($tBuff, 1))
	DllStructSetData($tFR, 'ReplaceWith', DllStructGetPtr($tBuff, 2))
	DllStructSetData($tFR, 'FindWhatLen', $__g_iFRBufferSize * 2)
	DllStructSetData($tFR, 'ReplaceWithLen', $__g_iFRBufferSize * 2)
	DllStructSetData($tFR, 'lParam', $lParam)
	DllStructSetData($tFR, 'Hook', $pReplaceProc)
	DllStructSetData($tFR, 'TemplateName', 0)

	Local $aRet = DllCall('comdlg32.dll', 'hwnd', 'ReplaceTextW', 'struct*', $tFR)
	If @error Or Not $aRet[0] Then
		Local $iError = @error
		__HeapFree($__g_pFRBuffer)
		If IsArray($aRet) Then
			Return SetError(10, _WinAPI_CommDlgExtendedErrorEx(), 0)
		Else
			Return SetError($iError, 0, 0)
		EndIf
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ReplaceTextDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RestartDlg($sText = '', $iFlags = 2, $hParent = 0)
	Local $aRet = DllCall('shell32.dll', 'int', 'RestartDialog', 'hwnd', $hParent, 'wstr', $sText, 'int', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RestartDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SaveFileDlg($sTitle = "", $sInitDir = "", $sFilters = "", $iDefaultFilter = 0, $sDefaultFilePath = "", $sDefaultExt = "", $iFlags = 0, $iFlagsEx = 0, $pOFNProc = 0, $pData = 0, $hParent = 0)
	Local $sResult = __OFNDlg(1, $sTitle, $sInitDir, $sFilters, $iDefaultFilter, $sDefaultFilePath, $sDefaultExt, $iFlags, $iFlagsEx, $pOFNProc, $pData, $hParent)
	If @error Then Return SetError(@error, @extended, "")

	Return $sResult
EndFunc   ;==>_WinAPI_SaveFileDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetFRBuffer($iChars)
	$iChars = Number($iChars)
	If $iChars < 80 Then
		$iChars = 80
	EndIf
	$__g_iFRBufferSize = $iChars + 1
	Return 1
EndFunc   ;==>_WinAPI_SetFRBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShellAboutDlg($sTitle, $sName, $sText, $hIcon = 0, $hParent = 0)
	Local $aRet = DllCall('shell32.dll', 'int', 'ShellAboutW', 'hwnd', $hParent, 'wstr', $sTitle & '#' & $sName, 'wstr', $sText, _
			'handle', $hIcon)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShellAboutDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellOpenWithDlg($sFilePath, $iFlags = 0, $hParent = 0)
	Local $tOPENASINFO = DllStructCreate('ptr;ptr;dword;wchar[' & (StringLen($sFilePath) + 1) & ']')
	DllStructSetData($tOPENASINFO, 1, DllStructGetPtr($tOPENASINFO, 4))
	DllStructSetData($tOPENASINFO, 2, 0)
	DllStructSetData($tOPENASINFO, 3, $iFlags)
	DllStructSetData($tOPENASINFO, 4, $sFilePath)

	Local $aRet = DllCall('shell32.dll', 'long', 'SHOpenWithDialog', 'hwnd', $hParent, 'struct*', $tOPENASINFO)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellOpenWithDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellStartNetConnectionDlg($sRemote = '', $iFlags = 0, $hParent = 0)
	Local $sTypeOfRemote = 'wstr'
	If Not StringStripWS($sRemote, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfRemote = 'ptr'
		$sRemote = 0
	EndIf
	DllCall('shell32.dll', 'long', 'SHStartNetConnectionDialogW', 'hwnd', $hParent, $sTypeOfRemote, $sRemote, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ShellStartNetConnectionDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellUserAuthenticationDlg($sCaption, $sMessage, $sUser, $sPassword, $sTarget, $iFlags = 0, $iError = 0, $bSave = False, $hBitmap = 0, $hParent = 0)
	If Not __DLL('credui.dll') Then Return SetError(103, 0, 0)

	Local $tInfo = DllStructCreate('dword;hwnd;ptr;ptr;ptr;wchar[' & (StringLen($sMessage) + 1) & '];wchar[' & (StringLen($sCaption) + 1) & ']')
	DllStructSetData($tInfo, 1, DllStructGetPtr($tInfo, 6) - DllStructGetPtr($tInfo))
	DllStructSetData($tInfo, 2, $hParent)
	DllStructSetData($tInfo, 3, DllStructGetPtr($tInfo, 6))
	DllStructSetData($tInfo, 4, DllStructGetPtr($tInfo, 7))
	DllStructSetData($tInfo, 5, $hBitmap)
	DllStructSetData($tInfo, 6, $sMessage)
	DllStructSetData($tInfo, 7, $sCaption)

	Local $aRet = DllCall('credui.dll', 'dword', 'CredUIPromptForCredentialsW', 'struct*', $tInfo, 'wstr', $sTarget, 'ptr', 0, _
			'dword', $iError, 'wstr', $sUser, 'ulong', 4096, 'wstr', $sPassword, 'ulong', 4096, 'bool*', $bSave, _
			'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[3]
	$aResult[0] = $aRet[5]
	$aResult[1] = $aRet[7]
	$aResult[2] = $aRet[9]
	Return $aResult
EndFunc   ;==>_WinAPI_ShellUserAuthenticationDlg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShellUserAuthenticationDlgEx($sCaption, $sMessage, $sUser, $sPassword, $iFlags = 0, $iAuthError = 0, $bSave = False, $iPackage = 0, $hParent = 0)
	If Not __DLL('credui.dll') Then Return SetError(103, 0, 0)

	Local $tBLOB = 0, $aRet
	If StringLen($sUser) Then
		$aRet = DllCall('credui.dll', 'bool', 'CredPackAuthenticationBufferW', 'dword', 1, 'wstr', $sUser, 'wstr', $sPassword, _
				'ptr', 0, 'dword*', 0)
		If @error Or Not $aRet[5] Then Return SetError(@error + 10, @extended, 0)
		$tBLOB = DllStructCreate('byte[' & $aRet[5] & ']')
		$aRet = DllCall('credui.dll', 'bool', 'CredPackAuthenticationBufferW', 'dword', 1, 'wstr', $sUser, 'wstr', $sPassword, _
				'struct*', $tBLOB, 'dword*', $aRet[5])
		If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)
	EndIf
	Local $tInfo = DllStructCreate('dword;hwnd;ptr;ptr;ptr;wchar[' & (StringLen($sMessage) + 1) & '];wchar[' & (StringLen($sCaption) + 1) & ']')
	DllStructSetData($tInfo, 1, DllStructGetPtr($tInfo, 6) - DllStructGetPtr($tInfo))
	DllStructSetData($tInfo, 2, $hParent)
	DllStructSetData($tInfo, 3, DllStructGetPtr($tInfo, 6))
	DllStructSetData($tInfo, 4, DllStructGetPtr($tInfo, 7))
	DllStructSetData($tInfo, 5, 0)
	DllStructSetData($tInfo, 6, $sMessage)
	DllStructSetData($tInfo, 7, $sCaption)
	$aRet = DllCall('credui.dll', 'dword', 'CredUIPromptForWindowsCredentialsW', 'struct*', $tInfo, 'dword', $iAuthError, _
			'ulong*', $iPackage, 'struct*', $tBLOB, 'ulong', DllStructGetSize($tBLOB), 'ptr*', 0, 'ulong*', 0, _
			'bool*', $bSave, 'dword', $iFlags)
	If @error Then Return SetError(@error + 30, @extended, 0)
	If $aRet[0] Then Return SetError(30, $aRet[0], 0)

	Local $aResult[4], $iError = 0
	$aResult[2] = $aRet[8]
	$aResult[3] = $aRet[3]
	Local $pBLOB = $aRet[6]
	Local $iSize = $aRet[7]
	$aRet = DllCall('credui.dll', 'bool', 'CredUnPackAuthenticationBufferW', 'dword', 1, 'ptr', $pBLOB, 'dword', $iSize, _
			'wstr', '', 'dword*', 4096, 'wstr', '', 'dword*', 4096, 'wstr', '', 'dword*', 4096)
	If Not @error And $aRet[0] Then
		$aResult[0] = $aRet[4]
		$aResult[1] = $aRet[8]
	Else
		$iError = @error + 40
	EndIf
	If Not _WinAPI_ZeroMemory($pBLOB, $iSize) Then
		; Nothing
	EndIf
	_WinAPI_CoTaskMemFree($pBLOB)
	If $iError Then Return SetError($iError, 0, 0)

	Return $aResult
EndFunc   ;==>_WinAPI_ShellUserAuthenticationDlgEx

#EndRegion Public Functions

#Region Internal Functions

Func __OFNDlg($iDlg, $sTitle, $sInitDir, $sFilters, $iDefFilter, $sDefFile, $sDefExt, $iFlags, $iFlagsEx, $pOFNProc, $pData, $hParent)
	Local $tBuffer = DllStructCreate('wchar[32768]')
	Local $tFilters = 0, $tDefExt = 0, $tInitDir = 0, $tTitle = 0

	Local $tOFN = DllStructCreate($tagOPENFILENAME)
	DllStructSetData($tOFN, "StructSize", DllStructGetSize($tOFN))
	DllStructSetData($tOFN, "hwndOwner", $hParent)
	DllStructSetData($tOFN, 3, 0)
	Local $aData = StringSplit($sFilters, '|')
	Local $aFilters[$aData[0] * 2]
	Local $iCount = 0
	For $i = 1 To $aData[0]
		$aFilters[$iCount + 0] = StringStripWS($aData[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		$aFilters[$iCount + 1] = StringStripWS(StringRegExpReplace($aData[$i], '.*\((.*)\)', '\1'), $STR_STRIPALL)
		If $aFilters[$iCount + 1] Then
			$iCount += 2
		EndIf
	Next
	If $iCount Then
		$tFilters = _WinAPI_ArrayToStruct($aFilters, 0, $iCount - 1)
		If @error Then
			; Nothing
		EndIf
	EndIf
	DllStructSetData($tOFN, "lpstrFilter", DllStructGetPtr($tFilters))
	DllStructSetData($tOFN, 5, 0)
	DllStructSetData($tOFN, 6, 0)
	DllStructSetData($tOFN, "nFilterIndex", $iDefFilter)
	$sDefFile = StringStripWS($sDefFile, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	If $sDefFile Then
		DllStructSetData($tBuffer, 1, $sDefFile)
	EndIf
	DllStructSetData($tOFN, "lpstrFile", DllStructGetPtr($tBuffer))
	DllStructSetData($tOFN, "nMaxFile", 32768)
	DllStructSetData($tOFN, 10, 0)
	DllStructSetData($tOFN, 11, 0)
	$sInitDir = StringStripWS($sInitDir, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	If $sInitDir Then
		$tInitDir = DllStructCreate('wchar[' & (StringLen($sInitDir) + 1) & ']')
	EndIf
	DllStructSetData($tInitDir, 1, $sInitDir)
	DllStructSetData($tOFN, "lpstrInitialDir", DllStructGetPtr($tInitDir))
	$sTitle = StringStripWS($sTitle, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	If $sTitle Then
		$tTitle = DllStructCreate('wchar[' & (StringLen($sTitle) + 1) & ']')
	EndIf
	DllStructSetData($tTitle, 1, $sTitle)
	DllStructSetData($tOFN, "lpstrTitle", DllStructGetPtr($tTitle))
	DllStructSetData($tOFN, "Flags", $iFlags)
	DllStructSetData($tOFN, 15, 0)
	DllStructSetData($tOFN, 16, 0)
	$sDefExt = StringStripWS($sDefExt, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	If $sDefExt Then
		$tDefExt = DllStructCreate('wchar[' & (StringLen($tDefExt) + 1) & ']')
	EndIf
	DllStructSetData($tDefExt, 1, StringReplace($sDefExt, '.', ''))
	DllStructSetData($tOFN, "lpstrDefExt", DllStructGetPtr($tDefExt))
	DllStructSetData($tOFN, "lCustData", $pData)
	DllStructSetData($tOFN, "lpfnHook", $pOFNProc)
	DllStructSetData($tOFN, 20, 0)
	DllStructSetData($tOFN, 21, 0)
	DllStructSetData($tOFN, 22, 0)
	DllStructSetData($tOFN, "FlagsEx", $iFlagsEx)
	Local $aRet
	Switch $iDlg
		Case 0
			$aRet = DllCall('comdlg32.dll', 'bool', 'GetOpenFileNameW', 'struct*', $tOFN)
		Case 1
			$aRet = DllCall('comdlg32.dll', 'bool', 'GetSaveFileNameW', 'struct*', $tOFN)
		Case Else

	EndSwitch
	If @error Then Return SetError(@error, @extended, '')
	If Not $aRet[0] Then Return SetError(10, _WinAPI_CommDlgExtendedErrorEx(), '')
	If BitAND($iFlags, $OFN_ALLOWMULTISELECT) Then
		If BitAND($iFlags, $OFN_EXPLORER) Then
			$aData = _WinAPI_StructToArray($tBuffer)
			If @error Then
				Return SetError(11, 0, '')
			EndIf
		Else
			$aData = StringSplit(DllStructGetData($tBuffer, 1), ' ')
		EndIf
		Switch $aData[0]
			Case 0
				Return SetError(12, 0, '')
			Case 1

			Case Else
				Local $sPath = $aData[1]
				For $i = 2 To $aData[0]
					$aData[$i - 1] = _WinAPI_PathAppend($sPath, $aData[$i])
				Next
				ReDim $aData[$aData[0]]
				$aData[0] -= 1
		EndSwitch
	Else
		$aData = DllStructGetData($tBuffer, 1)
	EndIf
	$__g_vExt = $tOFN
	Return $aData
EndFunc   ;==>__OFNDlg

Func __WinAPI_ParseMultiSelectFileDialogPath($aPath)
	Local $aFiles[UBound($aPath) + 1]
	$aFiles[0] = UBound($aPath)
	$aFiles[1] = StringMid($aPath[1], 1, StringInStr($aPath[1], "\", $STR_NOCASESENSEBASIC, -1) - 1)
	For $i = 1 To UBound($aPath) - 1
		$aFiles[$i + 1] = StringMid($aPath[$i], StringInStr($aPath[$i], "\", $STR_NOCASESENSEBASIC, -1) + 1)
	Next
	Return $aFiles
EndFunc   ;==>__WinAPI_ParseMultiSelectFileDialogPath

Func __WinAPI_ParseFileDialogPath($sPath)
	Local $aFiles[3]
	$aFiles[0] = 2
	$aFiles[1] = StringMid($sPath, 1, StringInStr($sPath, "\", $STR_NOCASESENSEBASIC, -1) - 1)
	$aFiles[2] = StringMid($sPath, StringInStr($sPath, "\", $STR_NOCASESENSEBASIC, -1) + 1)
	Return $aFiles
EndFunc   ;==>__WinAPI_ParseFileDialogPath

#EndRegion Internal Functions
