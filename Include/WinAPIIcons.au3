#include-once

#include "WinAPIGdiDC.au3"
#include "WinAPIGdiInternals.au3"
#include "WinAPIHObj.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIIcons.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_AddIconTransparency
; _WinAPI_CopyIcon
; _WinAPI_Create32BitHICON
; _WinAPI_CreateEmptyIcon
; _WinAPI_CreateIcon
; _WinAPI_CreateIconFromResourceEx
; _WinAPI_CreateIconIndirect
; _WinAPI_DestroyIcon
; _WinAPI_ExtractIcon
; _WinAPI_ExtractIconEx
; _WinAPI_FileIconInit
; _WinAPI_GetIconDimension
; _WinAPI_GetIconInfo
; _WinAPI_GetIconInfoEx
; _WinAPI_LoadIcon
; _WinAPI_LoadIconMetric
; _WinAPI_LoadIconWithScaleDown
; _WinAPI_LoadShell32Icon
; _WinAPI_LookupIconIdFromDirectoryEx
; _WinAPI_MirrorIcon
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagICONINFO
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagICONINFO
; Description ...: Contains information about an icon or a cursor
; Fields ........: Icon     - Specifies the contents of the structure:
;                  |True  - Icon
;                  |False - Cursor
;                  XHotSpot - Specifies the x-coordinate of a cursor's hot spot
;                  YHotSpot - Specifies the y-coordinate of the cursor's hot spot
;                  hMask    - Specifies the icon bitmask bitmap
;                  hColor   - Handle to the icon color bitmap
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagICONINFO = "bool Icon;dword XHotSpot;dword YHotSpot;handle hMask;handle hColor"

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_AddIconTransparency($hIcon, $iPercent = 50, $bDelete = False)
	Local $tBITMAP, $hDib = 0, $hResult = 0
	Local $ahBitmap[2]

	Local $tICONINFO = DllStructCreate($tagICONINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hIcon, 'struct*', $tICONINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	For $i = 0 To 1
		$ahBitmap[$i] = DllStructGetData($tICONINFO, $i + 4)
	Next
	Local $iError = 0
	Do
		$hDib = _WinAPI_CopyBitmap($ahBitmap[1])
		If Not $hDib Then
			$iError = 20
			ExitLoop
		EndIf
		$tBITMAP = DllStructCreate($tagBITMAP)
		If (Not _WinAPI_GetObject($hDib, DllStructGetSize($tBITMAP), $tBITMAP)) Or (DllStructGetData($tBITMAP, 'bmBitsPixel') <> 32) Then
			$iError = 21
			ExitLoop
		EndIf
		$aRet = DllCall('user32.dll', 'lresult', 'CallWindowProc', 'PTR', __TransparencyProc(), 'hwnd', 0, _
				'uint', $iPercent, 'wparam', DllStructGetPtr($tBITMAP), 'lparam', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		If $aRet[0] = -1 Then
			$hResult = _WinAPI_CreateEmptyIcon(DllStructGetData($tBITMAP, 'bmWidth'), DllStructGetData($tBITMAP, 'bmHeight'))
		Else
			$hResult = _WinAPI_CreateIconIndirect($hDib, $ahBitmap[0])
		EndIf
		If Not $hResult Then $iError = 22
	Until 1
	If $hDib Then
		_WinAPI_DeleteObject($hDib)
	EndIf
	For $i = 0 To 1
		If $ahBitmap[$i] Then
			_WinAPI_DeleteObject($ahBitmap[$i])
		EndIf
	Next
	If $iError Then Return SetError($iError, 0, 0)

	If $bDelete Then
		_WinAPI_DestroyIcon($hIcon)
	EndIf

	Return $hResult
EndFunc   ;==>_WinAPI_AddIconTransparency

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CopyIcon($hIcon)
	Local $aResult = DllCall("user32.dll", "handle", "CopyIcon", "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CopyIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_Create32BitHICON($hIcon, $bDelete = False)
	Local $ahBitmap[2], $hResult = 0
	Local $aDIB[2][2] = [[0, 0], [0, 0]]

	Local $tICONINFO = DllStructCreate($tagICONINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hIcon, 'struct*', $tICONINFO)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aRet[0] Then Return SetError(10, 0, 0)

	For $i = 0 To 1
		$ahBitmap[$i] = DllStructGetData($tICONINFO, $i + 4)
	Next
	If _WinAPI_IsAlphaBitmap($ahBitmap[1]) Then
		$aDIB[0][0] = _WinAPI_CreateANDBitmap($ahBitmap[1])
		If Not @error Then
			$hResult = _WinAPI_CreateIconIndirect($ahBitmap[1], $aDIB[0][0])
		EndIf
	Else
		Local $tSIZE = _WinAPI_GetBitmapDimension($ahBitmap[1])
		Local $aSize[2]
		For $i = 0 To 1
			$aSize[$i] = DllStructGetData($tSIZE, $i + 1)
		Next
		Local $hSrcDC = _WinAPI_CreateCompatibleDC(0)
		Local $hDstDC = _WinAPI_CreateCompatibleDC(0)
		Local $hSrcSv, $hDstSv
		For $i = 0 To 1
			$aDIB[$i][0] = _WinAPI_CreateDIB($aSize[0], $aSize[1])
			$aDIB[$i][1] = $__g_vExt
			$hSrcSv = _WinAPI_SelectObject($hSrcDC, $ahBitmap[$i])
			$hDstSv = _WinAPI_SelectObject($hDstDC, $aDIB[$i][0])
			_WinAPI_BitBlt($hDstDC, 0, 0, $aSize[0], $aSize[1], $hSrcDC, 0, 0, 0x00C000CA)
			_WinAPI_SelectObject($hSrcDC, $hSrcSv)
			_WinAPI_SelectObject($hDstDC, $hDstSv)
		Next
		_WinAPI_DeleteDC($hSrcDC)
		_WinAPI_DeleteDC($hDstDC)
		$aRet = DllCall('user32.dll', 'lresult', 'CallWindowProc', 'ptr', __XORProc(), 'ptr', 0, _
				'uint', $aSize[0] * $aSize[1] * 4, 'wparam', $aDIB[0][1], 'lparam', $aDIB[1][1])
		If Not @error And $aRet[0] Then
			$hResult = _WinAPI_CreateIconIndirect($aDIB[1][0], $ahBitmap[0])
		EndIf
	EndIf
	For $i = 0 To 1
		_WinAPI_DeleteObject($ahBitmap[$i])
		If $aDIB[$i][0] Then
			_WinAPI_DeleteObject($aDIB[$i][0])
		EndIf
	Next
	If Not $hResult Then Return SetError(11, 0, 0)

	If $bDelete Then
		_WinAPI_DestroyIcon($hIcon)
	EndIf

	Return $hResult
EndFunc   ;==>_WinAPI_Create32BitHICON

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateEmptyIcon($iWidth, $iHeight, $iBitsPerPel = 32)
	Local $hXOR = _WinAPI_CreateDIB($iWidth, $iHeight, $iBitsPerPel)
	Local $hAND = _WinAPI_CreateDIB($iWidth, $iHeight, 1)
	Local $hDC = _WinAPI_CreateCompatibleDC(0)
	Local $hSv = _WinAPI_SelectObject($hDC, $hAND)
	Local $hBrush = _WinAPI_CreateSolidBrush(0xFFFFFF)
	Local $tRECT = _WinAPI_CreateRect(0, 0, $iWidth, $iHeight)
	_WinAPI_FillRect($hDC, $tRECT, $hBrush)
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_SelectObject($hDC, $hSv)
	_WinAPI_DeleteDC($hDC)
	Local $hIcon = _WinAPI_CreateIconIndirect($hXOR, $hAND)
	Local $iError = @error
	If $hXOR Then
		_WinAPI_DeleteObject($hXOR)
	EndIf
	If $hAND Then
		_WinAPI_DeleteObject($hAND)
	EndIf
	If Not $hIcon Then Return SetError($iError + 10, 0, 0)

	Return $hIcon
EndFunc   ;==>_WinAPI_CreateEmptyIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateIcon($hInstance, $iWidth, $iHeight, $iPlanes, $iBitsPixel, $pANDBits, $pXORBits)
	Local $aRet = DllCall('user32.dll', 'handle', 'CreateIcon', 'handle', $hInstance, 'int', $iWidth, 'int', $iHeight, _
			'byte', $iPlanes, 'byte', $iBitsPixel, 'struct*', $pANDBits, 'struct*', $pXORBits)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateIconFromResourceEx($pData, $iSize, $bIcon = True, $iXDesiredPixels = 0, $iYDesiredPixels = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'CreateIconFromResourceEx', 'ptr', $pData, 'dword', $iSize, 'bool', $bIcon, _
			'dword', 0x00030000, 'int', $iXDesiredPixels, 'int', $iYDesiredPixels, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateIconFromResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateIconIndirect($hBitmap, $hMask, $iXHotspot = 0, $iYHotspot = 0, $bIcon = True)
	Local $tICONINFO = DllStructCreate($tagICONINFO)
	DllStructSetData($tICONINFO, 1, $bIcon)
	DllStructSetData($tICONINFO, 2, $iXHotspot)
	DllStructSetData($tICONINFO, 3, $iYHotspot)
	DllStructSetData($tICONINFO, 4, $hMask)
	DllStructSetData($tICONINFO, 5, $hBitmap)

	Local $aRet = DllCall('user32.dll', 'handle', 'CreateIconIndirect', 'struct*', $tICONINFO)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateIconIndirect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DestroyIcon($hIcon)
	Local $aResult = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DestroyIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ExtractIcon($sIcon, $iIndex, $bSmall = False)
	Local $pLarge, $pSmall, $tPtr = DllStructCreate('ptr')
	If $bSmall Then
		$pLarge = 0
		$pSmall = DllStructGetPtr($tPtr)
	Else
		$pLarge = DllStructGetPtr($tPtr)
		$pSmall = 0
	EndIf

	DllCall('shell32.dll', 'uint', 'ExtractIconExW', 'wstr', $sIcon, 'int', $iIndex, 'ptr', $pLarge, 'ptr', $pSmall, 'uint', 1)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return DllStructGetData($tPtr, 1)
EndFunc   ;==>_WinAPI_ExtractIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ExtractIconEx($sFilePath, $iIndex, $paLarge, $paSmall, $iIcons)
	Local $aResult = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $sFilePath, "int", $iIndex, "struct*", $paLarge, _
			"struct*", $paSmall, "uint", $iIcons)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ExtractIconEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FileIconInit($bRestore = True)
	Local $aRet = DllCall('shell32.dll', 'int', 660, 'int', $bRestore)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return 1
EndFunc   ;==>_WinAPI_FileIconInit

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetIconDimension($hIcon)
	Local $tICONINFO = DllStructCreate($tagICONINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hIcon, 'struct*', $tICONINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $tSIZE = _WinAPI_GetBitmapDimension(DllStructGetData($tICONINFO, 5))
	For $i = 4 To 5
		_WinAPI_DeleteObject(DllStructGetData($tICONINFO, $i))
	Next
	If Not IsDllStruct($tSIZE) Then Return SetError(20, 0, 0)

	Return $tSIZE
EndFunc   ;==>_WinAPI_GetIconDimension

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetIconInfo($hIcon)
	Local $tInfo = DllStructCreate($tagICONINFO)
	Local $aRet = DllCall("user32.dll", "bool", "GetIconInfo", "handle", $hIcon, "struct*", $tInfo)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aIcon[6]
	$aIcon[0] = True
	$aIcon[1] = DllStructGetData($tInfo, "Icon") <> 0
	$aIcon[2] = DllStructGetData($tInfo, "XHotSpot")
	$aIcon[3] = DllStructGetData($tInfo, "YHotSpot")
	$aIcon[4] = DllStructGetData($tInfo, "hMask")
	$aIcon[5] = DllStructGetData($tInfo, "hColor")
	Return $aIcon
EndFunc   ;==>_WinAPI_GetIconInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetIconInfoEx($hIcon)
	Local $tIIEX = DllStructCreate('dword;int;dword;dword;ptr;ptr;ushort;wchar[260];wchar[260]')
	;	Local $tIIEX = DllStructCreate($tagICONINFOEX)
	DllStructSetData($tIIEX, 1, DllStructGetSize($tIIEX))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfoExW', 'handle', $hIcon, 'struct*', $tIIEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[8]
	For $i = 0 To 7
		$aResult[$i] = DllStructGetData($tIIEX, $i + 2)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetIconInfoEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadIcon($hInstance, $sName)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('user32.dll', 'handle', 'LoadIconW', 'handle', $hInstance, $sTypeOfName, $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadIconMetric($hInstance, $sName, $iMetric)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('comctl32.dll', 'long', 'LoadIconMetric', 'handle', $hInstance, $sTypeOfName, $sName, 'int', $iMetric, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[4]
EndFunc   ;==>_WinAPI_LoadIconMetric

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadIconWithScaleDown($hInstance, $sName, $iWidth, $iHeight)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('comctl32.dll', 'long', 'LoadIconWithScaleDown', 'handle', $hInstance, $sTypeOfName, $sName, _
			'int', $iWidth, 'int', $iHeight, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_LoadIconWithScaleDown

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadShell32Icon($iIconID)
	Local $tIcons = DllStructCreate("ptr Data")
	Local $iIcons = _WinAPI_ExtractIconEx("shell32.dll", $iIconID, 0, $tIcons, 1)
	If @error Then Return SetError(@error, @extended, 0)
	If $iIcons <= 0 Then Return SetError(10, 0, 0)

	Return DllStructGetData($tIcons, "Data")
EndFunc   ;==>_WinAPI_LoadShell32Icon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LookupIconIdFromDirectoryEx($pData, $bIcon = True, $iXDesiredPixels = 0, $iYDesiredPixels = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'int', 'LookupIconIdFromDirectoryEx', 'ptr', $pData, 'bool', $bIcon, _
			'int', $iXDesiredPixels, 'int', $iYDesiredPixels, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LookupIconIdFromDirectoryEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_MirrorIcon($hIcon, $bDelete = False)
	If Not $bDelete Then
		$hIcon = _WinAPI_CopyIcon($hIcon)
	EndIf

	Local $aRet = DllCall('comctl32.dll', 'int', 414, 'ptr', 0, 'ptr*', $hIcon)
	If @error Or Not $aRet[0] Then
		Local $iError = @error + 10
		If $hIcon And Not $bDelete Then
			_WinAPI_DestroyIcon($hIcon)
		EndIf
		Return SetError($iError, 0, 0)
	EndIf

	Return $aRet[2]
EndFunc   ;==>_WinAPI_MirrorIcon

#EndRegion Public Functions

#Region Embedded DLL Functions

Func __TransparencyProc()
	Static $pProc = 0

	If Not $pProc Then
		If @AutoItX64 Then
			$pProc = __Init(Binary( _
					'0x48894C240848895424104C894424184C894C24205541574831C0505050505050' & _
					'4883EC284883BC24800000000074054831C0EB0748C7C0010000004821C07522' & _
					'488BAC248000000048837D180074054831C0EB0748C7C0010000004821C07502' & _
					'EB0948C7C001000000EB034831C04821C0740B4831C04863C0E93C0100004C63' & _
					'7C24784983FF647E0F48C7C0010000004863C0E9220100004C637C24784D21FF' & _
					'7D08C74424780000000048C74424280100000048C74424300000000048C74424' & _
					'3800000000488BAC24800000004C637D04488BAC2480000000486345084C0FAF' & _
					'F849C1E7024983C7FC4C3B7C24380F8C88000000488BAC24800000004C8B7D18' & _
					'4C037C24384983C7034C897C2440488B6C2440480FB64500505888442448807C' & _
					'244800744B4C0FB67C244848634424784C0FAFF84C89F848C7C1640000004899' & _
					'48F7F94989C74C89F850488B6C244858884500488B6C2440807D0000740948C7' & _
					'4424280000000048C7442430010000004883442438040F8149FFFFFF48837C24' & _
					'3000741148837C242800740948C7C001000000EB034831C04821C0740E48C7C0' & _
					'FFFFFFFF4863C0EB11EB0C48C7C0010000004863C0EB034831C04883C458415F' & _
					'5DC3'))
		Else
			$pProc = __Init(Binary( _
					'0x555331C05050505050837C242800740431C0EB05B80100000021C075198B6C24' & _
					'28837D1400740431C0EB05B80100000021C07502EB07B801000000EB0231C021' & _
					'C0740731C0E9E50000008B5C242483FB647E0AB801000000E9D20000008B5C24' & _
					'2421DB7D08C744242400000000C7042401000000C744240400000000C7442408' & _
					'000000008B6C24288B5D048B6C24280FAF5D08C1E30283C3FC3B5C24087C648B' & _
					'6C24288B5D14035C240883C303895C240C8B6C240C0FB6450088442410807C24' & _
					'100074380FB65C24100FAF5C242489D8B96400000099F7F989C3538B6C241058' & _
					'8845008B6C240C807D00007407C7042400000000C74424040100000083442408' & _
					'047181837C240400740D833C24007407B801000000EB0231C021C07409B8FFFF' & _
					'FFFFEB0BEB07B801000000EB0231C083C4145B5DC21000'))
		EndIf
	EndIf
	Return $pProc
EndFunc   ;==>__TransparencyProc

#EndRegion Embedded DLL Functions
