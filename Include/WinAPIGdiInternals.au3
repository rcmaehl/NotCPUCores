#include-once

#include "StructureConstants.au3"
#include "WinAPIHobj.au3"
#include "WinAPIInternals.au3"
#include "WinAPIMem.au3"
#include "WinAPIMisc.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIxxx.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
Global Const $tagBITMAPV5HEADER = 'struct;dword bV5Size;long bV5Width;long bV5Height;ushort bV5Planes;ushort bV5BitCount;dword bV5Compression;dword bV5SizeImage;long bV5XPelsPerMeter;long bV5YPelsPerMeter;dword bV5ClrUsed;dword bV5ClrImportant;dword bV5RedMask;dword bV5GreenMask;dword bV5BlueMask;dword bV5AlphaMask;dword bV5CSType;int bV5Endpoints[9];dword bV5GammaRed;dword bV5GammaGreen;dword bV5GammaBlue;dword bV5Intent;dword bV5ProfileData;dword bV5ProfileSize;dword bV5Reserved;endstruct'
Global Const $tagDIBSECTION = $tagBITMAP & ';' & $tagBITMAPINFOHEADER & ';dword dsBitfields[3];ptr dshSection;dword dsOffset'

; flags for GetTextMetrics
Global Const $TMPF_FIXED_PITCH = 0x01
Global Const $TMPF_VECTOR = 0x02
Global Const $TMPF_TRUETYPE = 0x04
Global Const $TMPF_DEVICE = 0x08

Global Const $__WINAPICONSTANT_FW_NORMAL = 400
Global Const $__WINAPICONSTANT_DEFAULT_CHARSET = 1
Global Const $__WINAPICONSTANT_OUT_DEFAULT_PRECIS = 0
Global Const $__WINAPICONSTANT_CLIP_DEFAULT_PRECIS = 0
Global Const $__WINAPICONSTANT_DEFAULT_QUALITY = 0
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
;
; Doc in WinAPIGdi
; _WinAPI_BitBlt
; _WinAPI_CombineRgn
; _WinAPI_CopyBitmap
; _WinAPI_CopyImage
; _WinAPI_CreateANDBitmap
; _WinAPI_CreateBitmap
; _WinAPI_CreateCompatibleBitmap
; _WinAPI_CreateDIB
; _WinAPI_CreateDIBSection
; _WinAPI_CreateDIBColorTable
; _WinAPI_CreateFont
; _WinAPI_CreateFontIndirect
; _WinAPI_CreateRectRgn
; _WinAPI_CreateRoundRectRgn
; _WinAPI_CreateSolidBrush
; _WinAPI_GetBitmapDimension
; _WinAPI_GetSysColorBrush
; _WinAPI_GetWindowRgn
; _WinAPI_IsAlphaBitmap
; _WinAPI_PtInRect
; _WinAPI_RedrawWindow
; _WinAPI_SetWindowRgn
;
;	Doc in WinAPIGdiDC
; _WinAPI_GetTextExtentPoint32
; _WinAPI_GetTextMetrics
;
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __Init
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_BitBlt($hDestDC, $iXDest, $iYDest, $iWidth, $iHeight, $hSrcDC, $iXSrc, $iYSrc, $iROP)
	Local $aResult = DllCall("gdi32.dll", "bool", "BitBlt", "handle", $hDestDC, "int", $iXDest, "int", $iYDest, "int", $iWidth, _
			"int", $iHeight, "handle", $hSrcDC, "int", $iXSrc, "int", $iYSrc, "dword", $iROP)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_BitBlt

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CombineRgn($hRgnDest, $hRgnSrc1, $hRgnSrc2, $iCombineMode)
	Local $aResult = DllCall("gdi32.dll", "int", "CombineRgn", "handle", $hRgnDest, "handle", $hRgnSrc1, "handle", $hRgnSrc2, _
			"int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CombineRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CopyBitmap($hBitmap)
	$hBitmap = _WinAPI_CopyImage($hBitmap, 0, 0, 0, 0x2000) ;$LR_CREATEDIBSECTION
	Return SetError(@error, @extended, $hBitmap)
EndFunc   ;==>_WinAPI_CopyBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CopyImage($hImage, $iType = 0, $iXDesiredPixels = 0, $iYDesiredPixels = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'CopyImage', 'handle', $hImage, 'uint', $iType, _
			'int', $iXDesiredPixels, 'int', $iYDesiredPixels, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CopyImage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateANDBitmap($hBitmap)
	Local $iError = 0, $hDib = 0

	$hBitmap = _WinAPI_CopyBitmap($hBitmap)
	If Not $hBitmap Then Return SetError(@error + 20, @extended, 0)

	Do
		Local $atDIB[2]
		$atDIB[0] = DllStructCreate($tagDIBSECTION)
		If (Not _WinAPI_GetObject($hBitmap, DllStructGetSize($atDIB[0]), $atDIB[0])) _
				Or (DllStructGetData($atDIB[0], 'bmBitsPixel') <> 32) Or (DllStructGetData($atDIB[0], 'biCompression')) Then
			$iError = 10
			ExitLoop
		EndIf
		$atDIB[1] = DllStructCreate($tagBITMAP)
		$hDib = _WinAPI_CreateDIB(DllStructGetData($atDIB[0], 'bmWidth'), DllStructGetData($atDIB[0], 'bmHeight'), 1)
		If Not _WinAPI_GetObject($hDib, DllStructGetSize($atDIB[1]), $atDIB[1]) Then
			$iError = 11
			ExitLoop
		EndIf
		Local $aRet = DllCall('user32.dll', 'lresult', 'CallWindowProc', 'ptr', __ANDProc(), 'ptr', 0, 'uint', 0, _
				'wparam', DllStructGetPtr($atDIB[0]), 'lparam', DllStructGetPtr($atDIB[1]))
		If @error Then
			$iError = @error
			ExitLoop
		EndIf
		If Not $aRet[0] Then
			$iError = 12
			ExitLoop
		EndIf
		$iError = 0
	Until 1
	_WinAPI_DeleteObject($hBitmap)
	If $iError Then
		If $hDib Then
			_WinAPI_DeleteObject($hDib)
		EndIf
		$hDib = 0
	EndIf

	Return SetError($iError, 0, $hDib)
EndFunc   ;==>_WinAPI_CreateANDBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateBitmap($iWidth, $iHeight, $iPlanes = 1, $iBitsPerPel = 1, $pBits = 0)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateBitmap", "int", $iWidth, "int", $iHeight, "uint", $iPlanes, _
			"uint", $iBitsPerPel, "struct*", $pBits)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleBitmap", "handle", $hDC, "int", $iWidth, "int", $iHeight)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateCompatibleBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateDIB($iWidth, $iHeight, $iBitsPerPel = 32, $tColorTable = 0, $iColorCount = 0)
	Local $aRGBQ[2], $iColors, $tagRGBQ
	Switch $iBitsPerPel
		Case 1
			$iColors = 2
		Case 4
			$iColors = 16
		Case 8
			$iColors = 256
		Case Else
			$iColors = 0
	EndSwitch
	If $iColors Then
		If Not IsDllStruct($tColorTable) Then
			Switch $iBitsPerPel
				Case 1
					$aRGBQ[0] = 0
					$aRGBQ[1] = 0xFFFFFF
					$tColorTable = _WinAPI_CreateDIBColorTable($aRGBQ)
				Case Else

			EndSwitch
		Else
			If $iColors > $iColorCount Then
				$iColors = $iColorCount
			EndIf
			If (Not $iColors) Or ((4 * $iColors) > DllStructGetSize($tColorTable)) Then
				Return SetError(20, 0, 0)
			EndIf
		EndIf
		$tagRGBQ = ';dword aRGBQuad[' & $iColors & ']'
	Else
		$tagRGBQ = ''
	EndIf
	Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFOHEADER & $tagRGBQ)

	DllStructSetData($tBITMAPINFO, 'biSize', 40)
	DllStructSetData($tBITMAPINFO, 'biWidth', $iWidth)
	DllStructSetData($tBITMAPINFO, 'biHeight', $iHeight)
	DllStructSetData($tBITMAPINFO, 'biPlanes', 1)
	DllStructSetData($tBITMAPINFO, 'biBitCount', $iBitsPerPel)
	DllStructSetData($tBITMAPINFO, 'biCompression', 0)
	DllStructSetData($tBITMAPINFO, 'biSizeImage', 0)
	DllStructSetData($tBITMAPINFO, 'biXPelsPerMeter', 0)
	DllStructSetData($tBITMAPINFO, 'biYPelsPerMeter', 0)
	DllStructSetData($tBITMAPINFO, 'biClrUsed', $iColors)
	DllStructSetData($tBITMAPINFO, 'biClrImportant', 0)
	If $iColors Then
		If IsDllStruct($tColorTable) Then
			_WinAPI_MoveMemory(DllStructGetPtr($tBITMAPINFO, 'aRGBQuad'), $tColorTable, 4 * $iColors)
		Else
			_WinAPI_ZeroMemory(DllStructGetPtr($tBITMAPINFO, 'aRGBQuad'), 4 * $iColors)
		EndIf
	EndIf
	Local $hBitmap = _WinAPI_CreateDIBSection(0, $tBITMAPINFO, 0, $__g_vExt)
	If Not $hBitmap Then Return SetError(@error, @extended, 0)

	Return $hBitmap
EndFunc   ;==>_WinAPI_CreateDIB

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateDIBSection($hDC, $tBITMAPINFO, $iUsage, ByRef $pBits, $hSection = 0, $iOffset = 0)
	$pBits = 0

	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateDIBSection', 'handle', $hDC, 'struct*', $tBITMAPINFO, 'uint', $iUsage, _
			'ptr*', 0, 'handle', $hSection, 'dword', $iOffset)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	$pBits = $aRet[4]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateDIBSection

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateDIBColorTable(Const ByRef $aColorTable, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aColorTable, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $tColorTable = DllStructCreate('dword[' & ($iEnd - $iStart + 1) & ']')

	Local $iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tColorTable, 1, _WinAPI_SwitchColor(__RGB($aColorTable[$i])), $iCount)
		$iCount += 1
	Next
	Return $tColorTable
EndFunc   ;==>_WinAPI_CreateDIBColorTable

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateFont($iHeight, $iWidth, $iEscape = 0, $iOrientn = 0, $iWeight = $__WINAPICONSTANT_FW_NORMAL, $bItalic = False, $bUnderline = False, $bStrikeout = False, $iCharset = $__WINAPICONSTANT_DEFAULT_CHARSET, $iOutputPrec = $__WINAPICONSTANT_OUT_DEFAULT_PRECIS, $iClipPrec = $__WINAPICONSTANT_CLIP_DEFAULT_PRECIS, $iQuality = $__WINAPICONSTANT_DEFAULT_QUALITY, $iPitch = 0, $sFace = 'Arial')
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateFontW", "int", $iHeight, "int", $iWidth, "int", $iEscape, _
			"int", $iOrientn, "int", $iWeight, "dword", $bItalic, "dword", $bUnderline, "dword", $bStrikeout, _
			"dword", $iCharset, "dword", $iOutputPrec, "dword", $iClipPrec, "dword", $iQuality, "dword", $iPitch, "wstr", $sFace)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFont

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateFontIndirect($tLogFont)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateFontIndirectW", "struct*", $tLogFont)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFontIndirect

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRectRgn($iLeftRect, $iTopRect, $iRightRect, $iBottomRect)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateRectRgn", "int", $iLeftRect, "int", $iTopRect, "int", $iRightRect, _
			"int", $iBottomRect)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateRectRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRoundRectRgn($iLeftRect, $iTopRect, $iRightRect, $iBottomRect, $iWidthEllipse, $iHeightEllipse)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateRoundRectRgn", "int", $iLeftRect, "int", $iTopRect, _
			"int", $iRightRect, "int", $iBottomRect, "int", $iWidthEllipse, "int", $iHeightEllipse)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateRoundRectRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateSolidBrush($iColor)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateSolidBrush", "INT", $iColor)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateSolidBrush

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBitmapDimension($hBitmap)
;~ 	Local Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
	Local $tObj = DllStructCreate($tagBITMAP)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return _WinAPI_CreateSize(DllStructGetData($tObj, 'bmWidth'), DllStructGetData($tObj, 'bmHeight'))
EndFunc   ;==>_WinAPI_GetBitmapDimension

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSysColorBrush($iIndex)
	Local $aResult = DllCall("user32.dll", "handle", "GetSysColorBrush", "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetSysColorBrush

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetTextExtentPoint32($hDC, $sText)
	Local $tSize = DllStructCreate($tagSIZE)
	Local $iSize = StringLen($sText)
	Local $aRet = DllCall("gdi32.dll", "bool", "GetTextExtentPoint32W", "handle", $hDC, "wstr", $sText, "int", $iSize, "struct*", $tSize)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tSize
EndFunc   ;==>_WinAPI_GetTextExtentPoint32

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTextMetrics($hDC)
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetTextMetricsW', 'handle', $hDC, 'struct*', $tTEXTMETRIC)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tTEXTMETRIC
EndFunc   ;==>_WinAPI_GetTextMetrics

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowRgn($hWnd, $hRgn)
	Local $aResult = DllCall("user32.dll", "int", "GetWindowRgn", "hwnd", $hWnd, "handle", $hRgn)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsAlphaBitmap($hBitmap)
	$hBitmap = _WinAPI_CopyBitmap($hBitmap)
	If Not $hBitmap Then Return SetError(@error + 20, @extended, 0)

	Local $aRet, $iError = 0
	Do
		Local $tDIB = DllStructCreate($tagDIBSECTION)
		If (Not _WinAPI_GetObject($hBitmap, DllStructGetSize($tDIB), $tDIB)) Or (DllStructGetData($tDIB, 'bmBitsPixel') <> 32) Or (DllStructGetData($tDIB, 'biCompression')) Then
			$iError = 1
			ExitLoop
		EndIf
		$aRet = DllCall('user32.dll', 'int', 'CallWindowProc', 'ptr', __AlphaProc(), 'ptr', 0, 'uint', 0, 'struct*', $tDIB, 'ptr', 0)
		If @error Or ($aRet[0] = -1) Then
			$iError = @error + 10
			ExitLoop
		EndIf
	Until 1
	_WinAPI_DeleteObject($hBitmap)
	If $iError Then Return SetError($iError, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsAlphaBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _WinAPI_PtInRect(ByRef $tRECT, ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "bool", "PtInRect", "struct*", $tRECT, "struct", $tPoint)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_PtInRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RedrawWindow($hWnd, $tRECT = 0, $hRegion = 0, $iFlags = 5)
	Local $aResult = DllCall("user32.dll", "bool", "RedrawWindow", "hwnd", $hWnd, "struct*", $tRECT, "handle", $hRegion, _
			"uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_RedrawWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetWindowRgn($hWnd, $hRgn, $bRedraw = True)
	Local $aResult = DllCall("user32.dll", "int", "SetWindowRgn", "hwnd", $hWnd, "handle", $hRgn, "bool", $bRedraw)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowRgn

#EndRegion Public Functions

#Region Embedded DLL Functions

Func __AlphaProc()
	Static $pProc = 0

	If Not $pProc Then
		If @AutoItX64 Then
			$pProc = __Init(Binary( _
					'0x48894C240848895424104C894424184C894C24205541574831C050504883EC28' & _
					'48837C24600074054831C0EB0748C7C0010000004821C0751F488B6C24604883' & _
					'7D180074054831C0EB0748C7C0010000004821C07502EB0948C7C001000000EB' & _
					'034831C04821C0740C48C7C0FFFFFFFF4863C0EB6F48C744242800000000488B' & _
					'6C24604C637D04488B6C2460486345084C0FAFF849C1E7024983C7FC4C3B7C24' & _
					'287C36488B6C24604C8B7D184C037C24284983C7034C897C2430488B6C243080' & _
					'7D0000740C48C7C0010000004863C0EB1348834424280471A54831C04863C0EB' & _
					'034831C04883C438415F5DC3'))
		Else
			$pProc = __Init(Binary( _
					'0x555331C05050837C241C00740431C0EB05B80100000021C075198B6C241C837D' & _
					'1400740431C0EB05B80100000021C07502EB07B801000000EB0231C021C07407' & _
					'B8FFFFFFFFEB4FC70424000000008B6C241C8B5D048B6C241C0FAF5D08C1E302' & _
					'83C3FC3B1C247C288B6C241C8B5D14031C2483C303895C24048B6C2404807D00' & _
					'007407B801000000EB0C8304240471BE31C0EB0231C083C4085B5DC21000'))
		EndIf
	EndIf
	Return $pProc
EndFunc   ;==>__AlphaProc

Func __ANDProc()
	Static $pProc = 0

	If Not $pProc Then
		If @AutoItX64 Then
			$pProc = __Init(Binary( _
					'0x48894C240848895424104C894424184C894C2420554157415648C7C009000000' & _
					'4883EC0848C704240000000048FFC875EF4883EC284883BC24A0000000007405' & _
					'4831C0EB0748C7C0010000004821C00F85840000004883BC24A8000000007405' & _
					'4831C0EB0748C7C0010000004821C07555488BAC24A000000048837D18007405' & _
					'4831C0EB0748C7C0010000004821C07522488BAC24A800000048837D18007405' & _
					'4831C0EB0748C7C0010000004821C07502EB0948C7C001000000EB034831C048' & _
					'21C07502EB0948C7C001000000EB034831C04821C07502EB0948C7C001000000' & _
					'EB034831C04821C0740B4831C04863C0E9D701000048C74424280000000048C7' & _
					'44243000000000488BAC24A00000004C637D0849FFCF4C3B7C24300F8C9C0100' & _
					'0048C74424380000000048C74424400000000048C744244800000000488BAC24' & _
					'A00000004C637D0449FFCF4C3B7C24480F8CDB000000488BAC24A00000004C8B' & _
					'7D184C037C24284983C7034C897C2450488B6C2450807D000074264C8B7C2440' & _
					'4C8B74243849F7DE4983C61F4C89F148C7C00100000048D3E04909C74C897C24' & _
					'4048FF4424384C8B7C24384983FF1F7E6F4C8B7C244049F7D74C897C244048C7' & _
					'442458180000004831C0483B4424587F3D488BAC24A80000004C8B7D184C037C' & _
					'24604C897C24504C8B7C2440488B4C245849D3FF4C89F850488B6C2458588845' & _
					'0048FF4424604883442458F871B948C74424380000000048C744244000000000' & _
					'48834424280448FF4424480F810BFFFFFF48837C24380074794C8B7C244049F7' & _
					'D74C8B74243849F7DE4983C6204C89F148C7C0FFFFFFFF48D3E04921C74C897C' & _
					'244048C7442458180000004831C0483B4424587F3D488BAC24A80000004C8B7D' & _
					'184C037C24604C897C24504C8B7C2440488B4C245849D3FF4C89F850488B6C24' & _
					'585888450048FF4424604883442458F871B948FF4424300F814AFEFFFF48C7C0' & _
					'010000004863C0EB034831C04883C470415E415F5DC3'))
		Else
			$pProc = __Init(Binary( _
					'0x555357BA0800000083EC04C70424000000004A75F3837C243800740431C0EB05' & _
					'B80100000021C07562837C243C00740431C0EB05B80100000021C0753F8B6C24' & _
					'38837D1400740431C0EB05B80100000021C075198B6C243C837D1400740431C0' & _
					'EB05B80100000021C07502EB07B801000000EB0231C021C07502EB07B8010000' & _
					'00EB0231C021C07502EB07B801000000EB0231C021C0740731C0E969010000C7' & _
					'042400000000C7442404000000008B6C24388B5D084B3B5C24040F8C3F010000' & _
					'C744240800000000C744240C00000000C7442410000000008B6C24388B5D044B' & _
					'3B5C24100F8CA90000008B6C24388B5D14031C2483C303895C24148B6C241480' & _
					'7D0000741C8B5C240C8B7C2408F7DF83C71F89F9B801000000D3E009C3895C24' & _
					'0CFF4424088B5C240883FB1F7E578B5C240CF7D3895C240CC744241818000000' & _
					'31C03B4424187F2D8B6C243C8B5D14035C241C895C24148B5C240C8B4C2418D3' & _
					'FB538B6C241858884500FF44241C83442418F871CBC744240800000000C74424' & _
					'0C0000000083042404FF4424100F8145FFFFFF837C240800745B8B5C240CF7D3' & _
					'8B7C2408F7DF83C72089F9B8FFFFFFFFD3E021C3895C240CC744241818000000' & _
					'31C03B4424187F2D8B6C243C8B5D14035C241C895C24148B5C240C8B4C2418D3' & _
					'FB538B6C241858884500FF44241C83442418F871CBFF4424040F81AFFEFFFFB8' & _
					'01000000EB0231C083C4205F5B5DC21000'))
		EndIf
	EndIf
	Return $pProc
EndFunc   ;==>__ANDProc

Func __XORProc()
	Static $pProc = 0

	If Not $pProc Then
		If @AutoItX64 Then
			$pProc = __Init(Binary( _
					'0x48894C240848895424104C894424184C894C24205541574831C050504883EC28' & _
					'48837C24600074054831C0EB0748C7C0010000004821C0751B48837C24680074' & _
					'054831C0EB0748C7C0010000004821C07502EB0948C7C001000000EB034831C0' & _
					'4821C074084831C04863C0EB7748C7442428000000004C637C24584983C7FC4C' & _
					'3B7C24287C4F4C8B7C24604C037C24284C897C2430488B6C2430807D00007405' & _
					'4831C0EB0748C7C0010000004821C0741C4C8B7C24684C037C24284983C7034C' & _
					'897C2430488B6C2430C64500FF48834424280471A148C7C0010000004863C0EB' & _
					'034831C04883C438415F5DC3'))
		Else
			$pProc = __Init(Binary( _
					'0x555331C05050837C241C00740431C0EB05B80100000021C07516837C24200074' & _
					'0431C0EB05B80100000021C07502EB07B801000000EB0231C021C0740431C0EB' & _
					'5AC70424000000008B5C241883C3FC3B1C247C3E8B5C241C031C24895C24048B' & _
					'6C2404807D0000740431C0EB05B80100000021C074168B5C2420031C2483C303' & _
					'895C24048B6C2404C64500FF8304240471B6B801000000EB0231C083C4085B5D' & _
					'C21000'))
		EndIf
	EndIf
	Return $pProc
EndFunc   ;==>__XORProc

#EndRegion Embedded DLL Functions

#Region Internal Functions

Func __Init($dData)
	Local $iLength = BinaryLen($dData)
	Local $aRet = DllCall('kernel32.dll', 'ptr', 'VirtualAlloc', 'ptr', 0, 'ulong_ptr', $iLength, 'dword', 0x00001000, 'dword', 0x00000040)
	If @error Or Not $aRet[0] Then __FatalExit(1, 'Error allocating memory.')
	Local $tData = DllStructCreate('byte[' & $iLength & "]", $aRet[0])
	DllStructSetData($tData, 1, $dData)
	Return $aRet[0]
EndFunc   ;==>__Init

#EndRegion Internal Functions
