#include-once

#include "APIGdiConstants.au3"
#include "StructureConstants.au3"
#include "WinAPICom.au3"
#include "WinAPIConv.au3"
#include "WinAPIError.au3"
#include "WinAPIGdiDC.au3"
#include "WinAPIGdiInternals.au3"
#include "WinAPIHObj.au3"
#include "WinAPIIcons.au3"
#include "WinAPIInternals.au3"
#include "WinAPIMisc.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Description ...: Additional variables, constants and functions for the WinAPIGdi.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #CONSTANTS# ===================================================================================================================
Global Const $tagBITMAPV4HEADER = 'struct;dword bV4Size;long bV4Width;long bV4Height;ushort bV4Planes;ushort bV4BitCount;dword bV4Compression;dword bV4SizeImage;long bV4XPelsPerMeter;long bV4YPelsPerMeter;dword bV4ClrUsed;dword bV4ClrImportant;dword bV4RedMask;dword bV4GreenMask;dword bV4BlueMask;dword bV4AlphaMask;dword bV4CSType;int bV4Endpoints[9];dword bV4GammaRed;dword bV4GammaGreen;dword bV4GammaBlue;endstruct'
Global Const $tagCOLORADJUSTMENT = 'ushort Size;ushort Flags;ushort IlluminantIndex;ushort RedGamma;ushort GreenGamma;ushort BlueGamma;ushort ReferenceBlack;ushort ReferenceWhite;short Contrast;short Brightness;short Colorfulness;short RedGreenTint'
Global Const $tagDEVMODE = 'wchar DeviceName[32];ushort SpecVersion;ushort DriverVersion;ushort Size;ushort DriverExtra;dword Fields;short Orientation;short PaperSize;short PaperLength;short PaperWidth;short Scale;short Copies;short DefaultSource;short PrintQuality;short Color;short Duplex;short YResolution;short TTOption;short Collate;wchar FormName[32];ushort Unused1;dword Unused2[3];dword Nup;dword Unused3;dword ICMMethod;dword ICMIntent;dword MediaType;dword DitherType;dword Reserved1;dword Reserved2;dword PanningWidth;dword PanningHeight'
Global Const $tagDEVMODE_DISPLAY = 'wchar DeviceName[32];ushort SpecVersion;ushort DriverVersion;ushort Size;ushort DriverExtra;dword Fields;' & $tagPOINT & ';dword DisplayOrientation;dword DisplayFixedOutput;short Unused1[5];wchar Unused2[32];ushort LogPixels;dword BitsPerPel;dword PelsWidth;dword PelsHeight;dword DisplayFlags;dword DisplayFrequency'
Global Const $tagDWM_COLORIZATION_PARAMETERS = 'dword Color;dword AfterGlow;uint ColorBalance;uint AfterGlowBalance;uint BlurBalance;uint GlassReflectionIntensity; uint OpaqueBlend'
Global Const $tagENHMETAHEADER = 'struct;dword Type;dword Size;long rcBounds[4];long rcFrame[4];dword Signature;dword Version;dword Bytes;dword Records;ushort Handles;ushort Reserved;dword Description;dword OffDescription;dword PalEntries;long Device[2];long Millimeters[2];dword PixelFormat;dword OffPixelFormat;dword OpenGL;long Micrometers[2];endstruct'
Global Const $tagEXTLOGPEN = 'dword PenStyle;dword Width;uint BrushStyle;dword Color;ulong_ptr Hatch;dword NumEntries' ; & ';dword StyleEntry[n];'
Global Const $tagFONTSIGNATURE = 'dword fsUsb[4];dword fsCsb[2]'
Global Const $tagGLYPHMETRICS = 'uint BlackBoxX;uint BlackBoxY;' & $tagPOINT & ';short CellIncX;short CellIncY'
Global Const $tagLOGBRUSH = 'uint Style;dword Color;ulong_ptr Hatch'
Global Const $tagLOGPEN = 'uint Style;dword Width;dword Color'
Global Const $tagMAT2 = 'short eM11[2];short eM12[2];short eM21[2];short eM22[2]'
Global Const $tagNEWTEXTMETRIC = $tagTEXTMETRIC & ';dword ntmFlags;uint ntmSizeEM;uint ntmCellHeight;uint ntmAvgWidth'
Global Const $tagNEWTEXTMETRICEX = $tagNEWTEXTMETRIC & ';' & $tagFONTSIGNATURE
Global Const $tagPANOSE = 'struct;byte bFamilyType;byte bSerifStyle;byte bWeight;byte bProportion;byte bContrast;byte bStrokeVariation;byte bArmStyle;byte bLetterform;byte bMidline;byte bXHeight;endstruct'
Global Const $tagOUTLINETEXTMETRIC = 'struct;uint otmSize;' & $tagTEXTMETRIC & ';byte otmFiller;' & $tagPANOSE & ';byte bugFiller[3];uint otmSelection;uint otmType;int otmCharSlopeRise;int otmCharSlopeRun;int otmItalicAngle;uint otmEMSquare;int otmAscent;int otmDescent;uint otmLineGap;uint otmCapEmHeight;uint otmXHeight;long otmFontBox[4];int otmMacAscent;int otmMacDescent;uint otmMacLineGap;uint otmMinimumPPEM;long otmSubscriptSize[2];long otmSubscriptOffset[2];long otmSuperscriptSize[2];long otmSuperscriptOffse[2];uint otmStrikeoutSize;int otmStrikeoutPosition;int otmUnderscoreSize;int otmUnderscorePosition;uint_ptr otmFamilyName;uint_ptr otmFaceName;uint_ptr otmStyleName;uint_ptr otmFullName;endstruct'
Global Const $tagPAINTSTRUCT = 'hwnd hDC;int fErase;dword rPaint[4];int fRestore;int fIncUpdate;byte rgbReserved[32]'
Global Const $tagRGNDATAHEADER = 'struct;dword Size;dword Type;dword Count;dword RgnSize;' & $tagRECT & ';endstruct'
; Global Const $tagRGNDATA = $tagRGNDATAHEADER ; & $tagRECT[n] & ';'
Global Const $tagXFORM = 'float eM11;float eM12;float eM21;float eM22;float eDx;float eDy'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_AbortPath
; _WinAPI_AddFontMemResourceEx
; _WinAPI_AddFontResourceEx
; _WinAPI_AddIconOverlay
; _WinAPI_AdjustBitmap
; _WinAPI_AlphaBlend
; _WinAPI_AngleArc
; _WinAPI_Arc
; _WinAPI_ArcTo
; _WinAPI_BeginPaint
; _WinAPI_BeginPath
; _WinAPI_CloseEnhMetaFile
; _WinAPI_CloseFigure
; _WinAPI_ColorAdjustLuma
; _WinAPI_ColorHLSToRGB
; _WinAPI_ColorRGBToHLS
; _WinAPI_CombineTransform
; _WinAPI_CompressBitmapBits
; _WinAPI_CopyEnhMetaFile
; _WinAPI_CopyRect
; _WinAPI_Create32BitHBITMAP
; _WinAPI_CreateBitmapIndirect
; _WinAPI_CreateBrushIndirect
; _WinAPI_CreateColorAdjustment
; _WinAPI_CreateCompatibleBitmapEx
; _WinAPI_CreateDIB
; _WinAPI_CreateDIBitmap
; _WinAPI_CreateEllipticRgn
; _WinAPI_CreateEnhMetaFile
; _WinAPI_CreateFontEx
; _WinAPI_CreateNullRgn
; _WinAPI_CreatePen
; _WinAPI_CreatePolygonRgn
; _WinAPI_CreateRectRgnIndirect
; _WinAPI_CreateSolidBitmap
; _WinAPI_CreateTransform
; _WinAPI_DeleteEnhMetaFile
; _WinAPI_DPtoLP
; _WinAPI_DrawAnimatedRects
; _WinAPI_DrawBitmap
; _WinAPI_DrawFocusRect
; _WinAPI_DrawLine
; _WinAPI_DrawShadowText
; _WinAPI_DwmDefWindowProc
; _WinAPI_DwmEnableBlurBehindWindow
; _WinAPI_DwmEnableComposition
; _WinAPI_DwmExtendFrameIntoClientArea
; _WinAPI_DwmGetColorizationColor
; _WinAPI_DwmGetColorizationParameters
; _WinAPI_DwmGetWindowAttribute
; _WinAPI_DwmInvalidateIconicBitmaps
; _WinAPI_DwmIsCompositionEnabled
; _WinAPI_DwmQueryThumbnailSourceSize
; _WinAPI_DwmRegisterThumbnail
; _WinAPI_DwmSetColorizationParameters
; _WinAPI_DwmSetIconicLivePreviewBitmap
; _WinAPI_DwmSetIconicThumbnail
; _WinAPI_DwmSetWindowAttribute
; _WinAPI_DwmUnregisterThumbnail
; _WinAPI_DwmUpdateThumbnailProperties
; _WinAPI_Ellipse
; _WinAPI_EndPaint
; _WinAPI_EndPath
; _WinAPI_EnumDisplayMonitors
; _WinAPI_EnumDisplaySettings
; _WinAPI_EnumFontFamilies
; _WinAPI_EqualRect
; _WinAPI_EqualRgn
; _WinAPI_ExcludeClipRect
; _WinAPI_ExtCreatePen
; _WinAPI_ExtCreateRegion
; _WinAPI_ExtFloodFill
; _WinAPI_ExtSelectClipRgn
; _WinAPI_FillPath
; _WinAPI_FillRgn
; _WinAPI_FlattenPath
; _WinAPI_FrameRgn
; _WinAPI_GdiComment
; _WinAPI_GetArcDirection
; _WinAPI_GetBitmapBits
; _WinAPI_GetBitmapDimension
; _WinAPI_GetBitmapDimensionEx
; _WinAPI_GetBkColor
; _WinAPI_GetBoundsRect
; _WinAPI_GetBrushOrg
; _WinAPI_GetBValue
; _WinAPI_GetClipBox
; _WinAPI_GetClipRgn
; _WinAPI_GetColorAdjustment
; _WinAPI_GetCurrentPosition
; _WinAPI_GetDeviceGammaRamp
; _WinAPI_GetDIBColorTable
; _WinAPI_GetDIBits
; _WinAPI_GetEnhMetaFile
; _WinAPI_GetEnhMetaFileBits
; _WinAPI_GetEnhMetaFileDescription
; _WinAPI_GetEnhMetaFileDimension
; _WinAPI_GetEnhMetaFileHeader
; _WinAPI_GetFontName
; _WinAPI_GetFontResourceInfo
; _WinAPI_GetFontMemoryResourceInfo
; _WinAPI_GetGlyphOutline
; _WinAPI_GetGraphicsMode
; _WinAPI_GetGValue
; _WinAPI_GetMapMode
; _WinAPI_GetMonitorInfo
; _WinAPI_GetOutlineTextMetrics
; _WinAPI_GetPixel
; _WinAPI_GetPolyFillMode
; _WinAPI_GetPosFromRect
; _WinAPI_GetRegionData
; _WinAPI_GetRgnBox
; _WinAPI_GetROP2
; _WinAPI_GetRValue
; _WinAPI_GetStretchBltMode
; _WinAPI_GetTabbedTextExtent
; _WinAPI_GetTextAlign
; _WinAPI_GetTextCharacterExtra
; _WinAPI_GetTextFace
; _WinAPI_GetUDFColorMode
; _WinAPI_GetUpdateRect
; _WinAPI_GetUpdateRgn
; _WinAPI_GetWindowExt
; _WinAPI_GetWindowOrg
; _WinAPI_GetWindowRgnBox
; _WinAPI_GetWorldTransform
; _WinAPI_GradientFill
; _WinAPI_InflateRect
; _WinAPI_IntersectClipRect
; _WinAPI_IntersectRect
; _WinAPI_InvalidateRgn
; _WinAPI_InvertANDBitmap
; _WinAPI_InvertColor
; _WinAPI_InvertRect
; _WinAPI_InvertRgn
; _WinAPI_IsRectEmpty
; _WinAPI_LineDDA
; _WinAPI_LineTo
; _WinAPI_LockWindowUpdate
; _WinAPI_LPtoDP
; _WinAPI_MaskBlt
; _WinAPI_ModifyWorldTransform
; _WinAPI_MonitorFromPoint
; _WinAPI_MonitorFromRect
; _WinAPI_MonitorFromWindow
; _WinAPI_MoveTo
; _WinAPI_MoveToEx
; _WinAPI_OffsetClipRgn
; _WinAPI_OffsetPoints
; _WinAPI_OffsetRect
; _WinAPI_OffsetRgn
; _WinAPI_OffsetWindowOrg
; _WinAPI_PaintDesktop
; _WinAPI_PaintRgn
; _WinAPI_PatBlt
; _WinAPI_PathToRegion
; _WinAPI_PlayEnhMetaFile
; _WinAPI_PlgBlt
; _WinAPI_PolyBezier
; _WinAPI_PolyBezierTo
; _WinAPI_PolyDraw
; _WinAPI_Polygon
; _WinAPI_PtInRectEx
; _WinAPI_PtInRegion
; _WinAPI_PtVisible
; _WinAPI_RadialGradientFill
; _WinAPI_Rectangle
; _WinAPI_RectInRegion
; _WinAPI_RectIsEmpty
; _WinAPI_RectVisible
; _WinAPI_RemoveFontMemResourceEx
; _WinAPI_RemoveFontResourceEx
; _WinAPI_RGB
; _WinAPI_RotatePoints
; _WinAPI_RoundRect
; _WinAPI_SaveHBITMAPToFile
; _WinAPI_SaveHICONToFile
; _WinAPI_ScaleWindowExt
; _WinAPI_SelectClipPath
; _WinAPI_SelectClipRgn
; _WinAPI_SetArcDirection
; _WinAPI_SetBitmapBits
; _WinAPI_SetBitmapDimensionEx
; _WinAPI_SetBoundsRect
; _WinAPI_SetBrushOrg
; _WinAPI_SetColorAdjustment
; _WinAPI_SetDCBrushColor
; _WinAPI_SetDCPenColor
; _WinAPI_SetDeviceGammaRamp
; _WinAPI_SetDIBColorTable
; _WinAPI_SetDIBits
; _WinAPI_SetDIBitsToDevice
; _WinAPI_SetEnhMetaFileBits
; _WinAPI_SetGraphicsMode
; _WinAPI_SetMapMode
; _WinAPI_SetPixel
; _WinAPI_SetPolyFillMode
; _WinAPI_SetRectRgn
; _WinAPI_SetROP2
; _WinAPI_SetStretchBltMode
; _WinAPI_SetTextAlign
; _WinAPI_SetTextCharacterExtra
; _WinAPI_SetTextJustification
; _WinAPI_SetUDFColorMode
; _WinAPI_SetWindowExt
; _WinAPI_SetWindowOrg
; _WinAPI_SetWorldTransform
; _WinAPI_StretchBlt
; _WinAPI_StretchDIBits
; _WinAPI_StrokeAndFillPath
; _WinAPI_StrokePath
; _WinAPI_SubtractRect
; _WinAPI_TabbedTextOut
; _WinAPI_TextOut
; _WinAPI_TransparentBlt
; _WinAPI_UnionRect
; _WinAPI_ValidateRect
; _WinAPI_ValidateRgn
; _WinAPI_WidenPath
; _WinAPI_WindowFromDC
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AbortPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'AbortPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AbortPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AddFontMemResourceEx($pData, $iSize)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'AddFontMemResourceEx', 'ptr', $pData, 'dword', $iSize, 'ptr', 0, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return SetExtended($aRet[4], $aRet[0])
EndFunc   ;==>_WinAPI_AddFontMemResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AddFontResourceEx($sFont, $iFlag = 0, $bNotify = False)
	Local $aRet = DllCall('gdi32.dll', 'int', 'AddFontResourceExW', 'wstr', $sFont, 'dword', $iFlag, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	If $bNotify Then
		Local Const $WM_FONTCHANGE = 0x001D
		Local Const $HWND_BROADCAST = 0xFFFF
		DllCall('user32.dll', 'lresult', 'SendMessage', 'hwnd', $HWND_BROADCAST, 'uint', $WM_FONTCHANGE, 'wparam', 0, _
				'lparam', 0)
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AddFontResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_AddIconOverlay($hIcon, $hOverlay)
	Local $aRet, $hResult = 0, $iError = 0
	Local $ahDev[2] = [0, 0]

	Local $tSIZE = _WinAPI_GetIconDimension($hIcon)
	Local $hIL = DllCall('comctl32.dll', 'handle', 'ImageList_Create', 'int', DllStructGetData($tSIZE, 1), _
			'int', DllStructGetData($tSIZE, 2), 'uint', 0x0021, 'int', 2, 'int', 2)
	If @error Or Not $hIL[0] Then Return SetError(@error + 10, @extended, 0)

	Do
		$ahDev[0] = _WinAPI_Create32BitHICON($hIcon)
		If @error Then
			$iError = @error + 100
			ExitLoop
		EndIf
		$aRet = DllCall('comctl32.dll', 'int', 'ImageList_ReplaceIcon', 'handle', $hIL[0], 'int', -1, 'handle', $ahDev[0])
		If @error Or ($aRet[0] = -1) Then
			$iError = @error + 200
			ExitLoop
		EndIf
		$ahDev[1] = _WinAPI_Create32BitHICON($hOverlay)
		If @error Then
			$iError = @error + 300
			ExitLoop
		EndIf
		$aRet = DllCall('comctl32.dll', 'int', 'ImageList_ReplaceIcon', 'handle', $hIL[0], 'int', -1, 'handle', $ahDev[1])
		If @error Or ($aRet[0] = -1) Then
			$iError = @error + 400
			ExitLoop
		EndIf
		$aRet = DllCall('comctl32.dll', 'bool', 'ImageList_SetOverlayImage', 'handle', $hIL[0], 'int', 1, 'int', 1)
		If @error Or Not $aRet[0] Then
			$iError = @error + 500
			ExitLoop
		EndIf
		$aRet = DllCall('comctl32.dll', 'handle', 'ImageList_GetIcon', 'handle', $hIL[0], 'int', 0, 'uint', 0x00000100)
		If @error Or Not $aRet[0] Then
			$iError = @error + 600
			ExitLoop
		EndIf
		$hResult = $aRet[0]
	Until 1
	DllCall('comctl32.dll', 'bool', 'ImageList_Destroy', 'handle', $hIL[0])
	For $i = 0 To 1
		If $ahDev[$i] Then
			_WinAPI_DestroyIcon($ahDev[$i])

		EndIf
	Next
	If Not $hResult Then Return SetError($iError, 0, 0)

	Return $hResult
EndFunc   ;==>_WinAPI_AddIconOverlay

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AdjustBitmap($hBitmap, $iWidth, $iHeight, $iMode = 3, $tAdjustment = 0)
	Local $tObj = DllStructCreate($tagBITMAP)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	If $iWidth = -1 Then
		$iWidth = DllStructGetData($tObj, 'bmWidth')
	EndIf
	If $iHeight = -1 Then
		$iHeight = DllStructGetData($tObj, 'bmHeight')
	EndIf
	$aRet = DllCall('user32.dll', 'handle', 'GetDC', 'hwnd', 0)
	Local $hDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $hDC)
	Local $hDestDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleBitmap', 'handle', $hDC, 'int', $iWidth, 'int', $iHeight)
	Local $hBmp = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hBmp)
	Local $hDestSv = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $hDC)
	Local $hSrcDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hSrcDC, 'handle', $hBitmap)
	Local $hSrcSv = $aRet[0]
	If _WinAPI_SetStretchBltMode($hDestDC, $iMode) Then
		Switch $iMode
			Case 4 ; HALFTONE
				If IsDllStruct($tAdjustment) Then
					If Not _WinAPI_SetColorAdjustment($hDestDC, $tAdjustment) Then
						; Nothing
					EndIf
				EndIf
			Case Else

		EndSwitch
	EndIf
	$aRet = _WinAPI_StretchBlt($hDestDC, 0, 0, $iWidth, $iHeight, $hSrcDC, 0, 0, DllStructGetData($tObj, 'bmWidth'), DllStructGetData($tObj, 'bmHeight'), 0x00CC0020)
	DllCall('user32.dll', 'int', 'ReleaseDC', 'hwnd', 0, 'handle', $hDC)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hDestSv)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hSrcDC, 'handle', $hSrcSv)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hDestDC)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hSrcDC)
	If Not $aRet Then Return SetError(10, 0, 0)

	Return $hBmp
EndFunc   ;==>_WinAPI_AdjustBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AlphaBlend($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iAlpha, $bAlpha = False)
	Local $iBlend = BitOR(BitShift(Not ($bAlpha = False), -24), BitShift(BitAND($iAlpha, 0xFF), -16))
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GdiAlphaBlend', 'handle', $hDestDC, 'int', $iXDest, 'int', $iYDest, _
			'int', $iWidthDest, 'int', $iHeightDest, 'handle', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, _
			'int', $iWidthSrc, 'int', $iHeightSrc, 'dword', $iBlend)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AlphaBlend

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AngleArc($hDC, $iX, $iY, $iRadius, $nStartAngle, $nSweepAngle)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'AngleArc', 'handle', $hDC, 'int', $iX, 'int', $iY, 'dword', $iRadius, _
			'float', $nStartAngle, 'float', $nSweepAngle)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AngleArc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_Arc($hDC, $tRECT, $iXStartArc, $iYStartArc, $iXEndArc, $iYEndArc)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'Arc', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), 'int', DllStructGetData($tRECT, 4), _
			'int', $iXStartArc, 'int', $iYStartArc, 'int', $iXEndArc, 'int', $iYEndArc)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_Arc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ArcTo($hDC, $tRECT, $iXRadial1, $iYRadial1, $iXRadial2, $iYRadial2)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'ArcTo', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), 'int', DllStructGetData($tRECT, 4), _
			'int', $iXRadial1, 'int', $iYRadial1, 'int', $iXRadial2, 'int', $iYRadial2)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ArcTo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BeginPaint($hWnd, ByRef $tPAINTSTRUCT)
	$tPAINTSTRUCT = DllStructCreate($tagPAINTSTRUCT)
	Local $aRet = DllCall('user32.dll', 'handle', 'BeginPaint', 'hwnd', $hWnd, 'struct*', $tPAINTSTRUCT)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginPaint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BeginPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'BeginPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseEnhMetaFile($hDC)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CloseEnhMetaFile', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseEnhMetaFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseFigure($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'CloseFigure', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseFigure

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ColorAdjustLuma($iRGB, $iPercent, $bScale = True)
	If $iRGB = -1 Then Return SetError(10, 0, -1)

	If $bScale Then
		$iPercent = Floor($iPercent * 10)
	EndIf

	Local $aRet = DllCall('shlwapi.dll', 'dword', 'ColorAdjustLuma', 'dword', __RGB($iRGB), 'int', $iPercent, 'bool', $bScale)
	If @error Then Return SetError(@error, @extended, -1)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_ColorAdjustLuma

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ColorHLSToRGB($iHue, $iLuminance, $iSaturation)
	If Not $iSaturation Then $iHue = 160

	Local $aRet = DllCall('shlwapi.dll', 'dword', 'ColorHLSToRGB', 'word', $iHue, 'word', $iLuminance, 'word', $iSaturation)
	If @error Then Return SetError(@error, @extended, -1)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_ColorHLSToRGB

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ColorRGBToHLS($iRGB, ByRef $iHue, ByRef $iLuminance, ByRef $iSaturation)
	Local $aRet = DllCall('shlwapi.dll', 'none', 'ColorRGBToHLS', 'dword', __RGB($iRGB), 'word*', 0, 'word*', 0, 'word*', 0)
	If @error Then Return SetError(@error, @extended, 0)

	$iHue = $aRet[2]
	$iLuminance = $aRet[3]
	$iSaturation = $aRet[4]
	Return 1
EndFunc   ;==>_WinAPI_ColorRGBToHLS

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CombineTransform($tXFORM1, $tXFORM2)
	Local $tXFORM = DllStructCreate($tagXFORM)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'CombineTransform', 'struct*', $tXFORM, 'struct*', $tXFORM1, 'struct*', $tXFORM2)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tXFORM
EndFunc   ;==>_WinAPI_CombineTransform

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CompressBitmapBits($hBitmap, ByRef $pBuffer, $iCompression = 0, $iQuality = 100)
	If Not __DLL('gdiplus.dll') Then Return SetError(103, 0, 0)

	Local $aSize[2], $iCount, $iFormat, $iLength, $sMime, $aRet, $hDC, $hSv, $hMem, $tBits, $tData, $pData, $iError = 1 ; JPM: 1????
	Local $hSource = 0, $hImage = 0, $hToken = 0, $pStream = 0, $tParam = 0
	Local $tDIB = DllStructCreate($tagDIBSECTION)

	Do
		Switch $iCompression
			Case 0
				$sMime = 'image/png'
			Case 1
				$sMime = 'image/jpeg'
;~ 			Case 2
;~ 				$sMime = 'image/bmp'
			Case Else
				$iError = 10
				ExitLoop
		EndSwitch
		While $hBitmap
			If Not _WinAPI_GetObject($hBitmap, DllStructGetSize($tDIB), $tDIB) Then
				$iError = 11
				ExitLoop 2
			EndIf
			If (DllStructGetData($tDIB, 'bmBitsPixel') = 32) And (Not DllStructGetData($tDIB, 'biCompression')) Then
				$iError = 12
				ExitLoop
			EndIf
			If $hSource Then
				$iError = 13
				ExitLoop 2
			EndIf
			$hSource = _WinAPI_CreateDIB(DllStructGetData($tDIB, 'bmWidth'), DllStructGetData($tDIB, 'bmHeight'))
			If Not $hSource Then
				$iError = @error + 100
				ExitLoop 2
			EndIf
			$hDC = _WinAPI_CreateCompatibleDC(0)
			$hSv = _WinAPI_SelectObject($hDC, $hSource)
			If _WinAPI_DrawBitmap($hDC, 0, 0, $hBitmap) Then
				$hBitmap = $hSource
			Else
				$iError = @error + 200
				$hBitmap = 0
			EndIf
			_WinAPI_SelectObject($hDC, $hSv)
			_WinAPI_DeleteDC($hDC)
		WEnd
		If Not $hBitmap Then
			ExitLoop
		EndIf
		For $i = 0 To 1
			$aSize[$i] = DllStructGetData($tDIB, $i + 2)
		Next
		$tBits = DllStructCreate('byte[' & ($aSize[0] * $aSize[1] * 4) & ']')
		If Not _WinAPI_GetBitmapBits($hBitmap, DllStructGetSize($tBits), $tBits) Then
			$iError = @error + 300
			ExitLoop
		EndIf
		$tData = DllStructCreate($tagGDIPSTARTUPINPUT)
		DllStructSetData($tData, "Version", 1)
		$aRet = DllCall('gdiplus.dll', 'int', 'GdiplusStartup', 'ulong_ptr*', 0, 'struct*', $tData, 'ptr', 0)
		If @error Or $aRet[0] Then
			$iError = @error + 400
			ExitLoop
		EndIf
		If _WinAPI_IsAlphaBitmap($hBitmap) Then
			$iFormat = 0x0026200A
		Else
			$iFormat = 0x00022009
		EndIf
		$hToken = $aRet[1]
		$aRet = DllCall('gdiplus.dll', 'int', 'GdipCreateBitmapFromScan0', 'int', $aSize[0], 'int', $aSize[1], _
				'uint', $aSize[0] * 4, 'int', $iFormat, 'struct*', $tBits, 'ptr*', 0)
		If @error Or $aRet[0] Then
			$iError = @error + 500
			ExitLoop
		EndIf
		$hImage = $aRet[6]
		$aRet = DllCall('gdiplus.dll', 'int', 'GdipGetImageEncodersSize', 'uint*', 0, 'uint*', 0)
		If @error Or $aRet[0] Then
			$iError = @error + 600
			ExitLoop
		EndIf
		$iCount = $aRet[1]
		$tData = DllStructCreate('byte[' & $aRet[2] & ']')
		If @error Then
			$iError = @error + 700
			ExitLoop
		EndIf
		$pData = DllStructGetPtr($tData)
		$aRet = DllCall('gdiplus.dll', 'int', 'GdipGetImageEncoders', 'uint', $iCount, 'uint', $aRet[2], 'struct*', $tData)
		If @error Or $aRet[0] Then
			$iError = @error + 800
			ExitLoop
		EndIf
		Local $tCodec, $pEncoder = 0
		For $i = 1 To $iCount
			$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pData)
			If Not StringInStr(_WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, 'MimeType')), $sMime) Then
				$pData += DllStructGetSize($tagGDIPIMAGECODECINFO)
			Else
				$pEncoder = $pData
				$iError = 0
				ExitLoop
			EndIf
		Next
		If Not $pEncoder Then
			$iError = 15
			ExitLoop
		EndIf
		Switch $iCompression
			Case 0
				; Nothing
			Case 1
				Local Const $tagENCODERPARAMETER = 'byte[16] GUID;ulong NumberOfValues;dword Type;ptr pValue'
				$tParam = DllStructCreate('dword Count;' & $tagENCODERPARAMETER & ';ulong Quality')
				DllStructSetData($tParam, 'Count', 1)
				DllStructSetData($tParam, 'NumberOfValues', 1)
				DllStructSetData($tParam, 'Type', 4)
				DllStructSetData($tParam, 'pValue', DllStructGetPtr($tParam, 'Quality'))
				DllStructSetData($tParam, 'Quality', $iQuality)
				$aRet = DllCall('ole32.dll', 'long', 'CLSIDFromString', 'wstr', '{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}', _
						'ptr', DllStructGetPtr($tParam, 2))
				If @error Or $aRet[0] Then
					$tParam = 0
				EndIf
;~ 			Case 2
;~ 				; bmp Compression
;~ 				; JPM: something to do ???
		EndSwitch
		$pStream = _WinAPI_CreateStreamOnHGlobal()
		$aRet = DllCall('gdiplus.dll', 'int', 'GdipSaveImageToStream', 'handle', $hImage, 'ptr', $pStream, _
				'ptr', $pEncoder, 'struct*', $tParam)
		If @error Or $aRet[0] Then
			$iError = @error + 900
			ExitLoop
		EndIf
		$hMem = _WinAPI_GetHGlobalFromStream($pStream)
		$aRet = DllCall('kernel32.dll', 'ulong_ptr', 'GlobalSize', 'handle', $hMem)
		If @error Or Not $aRet[0] Then
			$iError = @error + 1000
			ExitLoop
		EndIf
		$iLength = $aRet[0]
		$aRet = DllCall('kernel32.dll', 'ptr', 'GlobalLock', 'handle', $hMem)
		If @error Or Not $aRet[0] Then
			$iError = @error + 1100
			ExitLoop
		EndIf
		$pBuffer = __HeapReAlloc($pBuffer, $iLength, 1)
		If Not @error Then
			_WinAPI_MoveMemory($pBuffer, $aRet[0], $iLength)
			; $iError = @error +1200 ; cannot really occur
			; EndIf
		Else
			$iError = @error + 1300
		EndIf
	Until 1
	If $pStream Then
		_WinAPI_ReleaseStream($pStream)
	EndIf
	If $hImage Then
		DllCall('gdiplus.dll', 'int', 'GdipDisposeImage', 'handle', $hImage)
	EndIf
	If $hToken Then
		DllCall('gdiplus.dll', 'none', 'GdiplusShutdown', 'ulong_ptr', $hToken)
	EndIf
	If $hSource Then
		_WinAPI_DeleteObject($hSource)
	EndIf
	If $iError Then Return SetError($iError, 0, 0)

	Return $iLength
EndFunc   ;==>_WinAPI_CompressBitmapBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CopyEnhMetaFile($hEmf, $sFilePath = '')
	Local $sTypeOfFile = 'wstr'
	If Not StringStripWS($sFilePath, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfFile = 'ptr'
		$sFilePath = 0
	EndIf

	Local $aRet = DllCall('gdi32.dll', 'handle', 'CopyEnhMetaFileW', 'handle', $hEmf, $sTypeOfFile, $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CopyEnhMetaFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CopyRect($tRECT)
	Local $tData = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'CopyRect', 'struct*', $tData, 'struct*', $tRECT)
	If @error Or Not $aRet[0] Then SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $tData
EndFunc   ;==>_WinAPI_CopyRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_Create32BitHBITMAP($hIcon, $bDib = False, $bDelete = False)
	Local $hBitmap = 0
	Local $aDIB[2] = [0, 0]

	Local $hTemp = _WinAPI_Create32BitHICON($hIcon)
	If @error Then Return SetError(@error, @extended, 0)

	Local $iError = 0
	Do
		Local $tICONINFO = DllStructCreate($tagICONINFO)
		Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hTemp, 'struct*', $tICONINFO)
		If @error Or Not $aRet[0] Then
			$iError = @error + 10
			ExitLoop
		EndIf
		For $i = 0 To 1
			$aDIB[$i] = DllStructGetData($tICONINFO, $i + 4)
		Next
		Local $tBITMAP = DllStructCreate($tagBITMAP)
		If Not _WinAPI_GetObject($aDIB[0], DllStructGetSize($tBITMAP), $tBITMAP) Then
			$iError = @error + 20
			ExitLoop
		EndIf
		If $bDib Then
			$hBitmap = _WinAPI_CreateDIB(DllStructGetData($tBITMAP, 'bmWidth'), DllStructGetData($tBITMAP, 'bmHeight'))
			Local $hDC = _WinAPI_CreateCompatibleDC(0)
			Local $hSv = _WinAPI_SelectObject($hDC, $hBitmap)
			_WinAPI_DrawIconEx($hDC, 0, 0, $hTemp)
			_WinAPI_SelectObject($hDC, $hSv)
			_WinAPI_DeleteDC($hDC)
		Else
			$hBitmap = $aDIB[1]
			$aDIB[1] = 0
		EndIf
	Until 1
	For $i = 0 To 1
		If $aDIB[$i] Then
			_WinAPI_DeleteObject($aDIB[$i])
		EndIf
	Next
	_WinAPI_DestroyIcon($hTemp)
	If $iError Then Return SetError($iError, 0, 0)
	If Not $hBitmap Then Return SetError(12, 0, 0)

	If $bDelete Then
		_WinAPI_DestroyIcon($hIcon)
	EndIf

	Return $hBitmap
EndFunc   ;==>_WinAPI_Create32BitHBITMAP

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateBitmapIndirect(ByRef $tBITMAP)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateBitmapIndirect', 'struct*', $tBITMAP)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateBitmapIndirect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateBrushIndirect($iStyle, $iRGB, $iHatch = 0)
	Local $tLOGBRUSH = DllStructCreate($tagLOGBRUSH)
	DllStructSetData($tLOGBRUSH, 1, $iStyle)
	DllStructSetData($tLOGBRUSH, 2, __RGB($iRGB))
	DllStructSetData($tLOGBRUSH, 3, $iHatch)

	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateBrushIndirect', 'struct*', $tLOGBRUSH)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateBrushIndirect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateColorAdjustment($iFlags = 0, $iIlluminant = 0, $iGammaR = 10000, $iGammaG = 10000, $iGammaB = 10000, $iBlack = 0, $iWhite = 10000, $iContrast = 0, $iBrightness = 0, $iColorfulness = 0, $iTint = 0)
	Local $tCA = DllStructCreate($tagCOLORADJUSTMENT)
	DllStructSetData($tCA, 1, DllStructGetSize($tCA))
	DllStructSetData($tCA, 2, $iFlags)
	DllStructSetData($tCA, 3, $iIlluminant)
	DllStructSetData($tCA, 4, $iGammaR)
	DllStructSetData($tCA, 5, $iGammaG)
	DllStructSetData($tCA, 6, $iGammaB)
	DllStructSetData($tCA, 7, $iBlack)
	DllStructSetData($tCA, 8, $iWhite)
	DllStructSetData($tCA, 9, $iContrast)
	DllStructSetData($tCA, 10, $iBrightness)
	DllStructSetData($tCA, 11, $iColorfulness)
	DllStructSetData($tCA, 12, $iTint)

	Return $tCA
EndFunc   ;==>_WinAPI_CreateColorAdjustment

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateCompatibleBitmapEx($hDC, $iWidth, $iHeight, $iRGB)
	Local $hBrush = _WinAPI_CreateBrushIndirect(0, $iRGB)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $hDC)
	Local $hDestDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleBitmap', 'handle', $hDC, 'int', $iWidth, 'int', $iHeight)
	Local $hBmp = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hBmp)
	Local $hDestSv = $aRet[0]
	Local $tRECT = _WinAPI_CreateRectEx(0, 0, $iWidth, $iHeight)
	Local $iError = 0
	$aRet = DllCall('user32.dll', 'int', 'FillRect', 'handle', $hDestDC, 'struct*', $tRECT, 'handle', $hBrush)
	If @error Or Not $aRet[0] Then
		$iError = @error + 10
		_WinAPI_DeleteObject($hBmp)
	EndIf
	_WinAPI_DeleteObject($hBrush)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hDestSv)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hDestDC)
	If $iError Then Return SetError($iError, 0, 0)

	Return $hBmp
EndFunc   ;==>_WinAPI_CreateCompatibleBitmapEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateDIBitmap($hDC, ByRef $tBITMAPINFO, $iUsage, $pBits = 0)
	Local $iInit = 0
	If $pBits Then
		$iInit = 0x04
	EndIf

	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateDIBitmap', 'handle', $hDC, 'struct*', $tBITMAPINFO, 'dword', $iInit, 'struct*', $pBits, _
			'struct*', $tBITMAPINFO, 'uint', $iUsage)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateDIBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateEllipticRgn($tRECT)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateEllipticRgnIndirect', 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateEllipticRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateEnhMetaFile($hDC = 0, $tRECT = 0, $bPixels = False, $sFilePath = '', $sDescription = '')
	Local $sTypeOfFile = 'wstr'
	If Not StringStripWS($sFilePath, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfFile = 'ptr'
		$sFilePath = 0
	EndIf

	Local $tData = 0, $aData = StringSplit($sDescription, '|', $STR_NOCOUNT)
	If UBound($aData) < 2 Then
		ReDim $aData[2]
		$aData[1] = ''
	EndIf
	For $i = 0 To 1
		$aData[$i] = StringStripWS($aData[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
	Next
	If ($aData[0]) Or ($aData[1]) Then
		$tData = _WinAPI_ArrayToStruct($aData)
	EndIf

	Local $iXp, $iYp, $iXm, $iYm, $hRef = 0
	If $bPixels And (IsDllStruct($tRECT)) Then
		If Not $hDC Then
			$hRef = _WinAPI_GetDC(0)
		EndIf
		$iXp = _WinAPI_GetDeviceCaps($hRef, 8)
		$iYp = _WinAPI_GetDeviceCaps($hRef, 10)
		$iXm = _WinAPI_GetDeviceCaps($hRef, 4)
		$iYm = _WinAPI_GetDeviceCaps($hRef, 6)
		If $hRef Then
			_WinAPI_ReleaseDC(0, $hRef)
		EndIf
		For $i = 1 To 3 Step 2
			DllStructSetData($tRECT, $i, Round(DllStructGetData($tRECT, $i) * $iXm / $iXp * 100))
		Next
		For $i = 2 To 4 Step 2
			DllStructSetData($tRECT, $i, Round(DllStructGetData($tRECT, $i) * $iYm / $iYp * 100))
		Next
	EndIf

	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateEnhMetaFileW', 'handle', $hDC, $sTypeOfFile, $sFilePath, 'struct*', $tRECT, _
			'struct*', $tData)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateEnhMetaFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateFontEx($iHeight, $iWidth = 0, $iEscapement = 0, $iOrientation = 0, $iWeight = 400, $bItalic = False, $bUnderline = False, $bStrikeOut = False, $iCharSet = 1, $iOutPrecision = 0, $iClipPrecision = 0, $iQuality = 0, $iPitchAndFamily = 0, $sFaceName = '', $iStyle = 0)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateFontW', 'int', $iHeight, 'int', $iWidth, 'int', $iEscapement, _
			'int', $iOrientation, 'int', $iWeight, 'dword', $bItalic, 'dword', $bUnderline, 'dword', $bStrikeOut, _
			'dword', $iCharSet, 'dword', $iOutPrecision, 'dword', $iClipPrecision, 'dword', $iQuality, _
			'dword', $iPitchAndFamily, 'wstr', _WinAPI_GetFontName($sFaceName, $iStyle, $iCharSet))
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateFontEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateNullRgn()
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateRectRgn', 'int', 0, 'int', 0, 'int', 0, 'int', 0)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateNullRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreatePen($iPenStyle, $iWidth, $iColor)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreatePen", "int", $iPenStyle, "int", $iWidth, "INT", $iColor)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreatePen

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreatePolygonRgn(Const ByRef $aPoint, $iStart = 0, $iEnd = -1, $iMode = 1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2, 2) Then Return SetError(@error + 10, @extended, 0)

	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'int[2];'
	Next
	Local $tData = DllStructCreate($tagStruct)

	Local $iCount = 1
	For $i = $iStart To $iEnd
		For $j = 0 To 1
			DllStructSetData($tData, $iCount, $aPoint[$i][$j], $j + 1)
		Next
		$iCount += 1
	Next

	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreatePolygonRgn', 'struct*', $tData, 'int', $iCount - 1, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreatePolygonRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateRectRgnIndirect($tRECT)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateRectRgnIndirect', 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateRectRgnIndirect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (Release DC), Yashied (rewritten)
; ===============================================================================================================================
Func _WinAPI_CreateSolidBitmap($hWnd, $iColor, $iWidth, $iHeight, $bRGB = 1)
	Local $hDC = _WinAPI_GetDC($hWnd)
	Local $hDestDC = _WinAPI_CreateCompatibleDC($hDC)
	Local $hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	Local $hOld = _WinAPI_SelectObject($hDestDC, $hBitmap)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 1, 0)
	DllStructSetData($tRECT, 2, 0)
	DllStructSetData($tRECT, 3, $iWidth)
	DllStructSetData($tRECT, 4, $iHeight)
	If $bRGB Then
		$iColor = BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
	EndIf
	Local $hBrush = _WinAPI_CreateSolidBrush($iColor)
	If Not _WinAPI_FillRect($hDestDC, $tRECT, $hBrush) Then
		_WinAPI_DeleteObject($hBitmap)
		$hBitmap = 0
	EndIf
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	_WinAPI_SelectObject($hDestDC, $hOld)
	_WinAPI_DeleteDC($hDestDC)
	If Not $hBitmap Then Return SetError(1, 0, 0)
	Return $hBitmap
EndFunc   ;==>_WinAPI_CreateSolidBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateTransform($nM11 = 1, $nM12 = 0, $nM21 = 0, $nM22 = 1, $nDX = 0, $nDY = 0)
	Local $tXFORM = DllStructCreate($tagXFORM)
	DllStructSetData($tXFORM, 1, $nM11)
	DllStructSetData($tXFORM, 2, $nM12)
	DllStructSetData($tXFORM, 3, $nM21)
	DllStructSetData($tXFORM, 4, $nM22)
	DllStructSetData($tXFORM, 5, $nDX)
	DllStructSetData($tXFORM, 6, $nDY)

	Return $tXFORM
EndFunc   ;==>_WinAPI_CreateTransform

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DeleteEnhMetaFile($hEmf)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'DeleteEnhMetaFile', 'handle', $hEmf)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeleteEnhMetaFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DPtoLP($hDC, ByRef $tPOINT, $iCount = 1)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'DPtoLP', 'handle', $hDC, 'struct*', $tPOINT, 'int', $iCount)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DPtoLP

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DrawAnimatedRects($hWnd, $tRectFrom, $tRectTo)
	Local $aRet = DllCall('user32.dll', 'bool', 'DrawAnimatedRects', 'hwnd', $hWnd, 'int', 3, 'struct*', $tRectFrom, _
			'struct*', $tRectTo)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DrawAnimatedRects

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawBitmap($hDC, $iX, $iY, $hBitmap, $iRop = 0x00CC0020)
	Local $tObj = DllStructCreate($tagBITMAP)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	$aRet = DllCall('user32.dll', 'handle', 'GetDC', 'hwnd', 0)
	Local $_hDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $_hDC)
	Local $hSrcDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hSrcDC, 'handle', $hBitmap)
	Local $hSrcSv = $aRet[0]
	Local $iError = 0
	$aRet = DllCall('gdi32.dll', 'int', 'BitBlt', 'hwnd', $hDC, 'int', $iX, 'int', $iY, 'int', DllStructGetData($tObj, 'bmWidth'), 'int', DllStructGetData($tObj, 'bmHeight'), 'hwnd', $hSrcDC, 'int', 0, 'int', 0, 'int', $iRop)
	If @error Or Not $aRet[0] Then
		$iError = @error + 1
	EndIf
	DllCall('user32.dll', 'int', 'ReleaseDC', 'hwnd', 0, 'handle', $_hDC)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hSrcDC, 'handle', $hSrcSv)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hSrcDC)
	If $iError Then Return SetError(10, 0, 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DrawFocusRect($hDC, $tRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'DrawFocusRect', 'handle', $hDC, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DrawFocusRect

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DrawLine($hDC, $iX1, $iY1, $iX2, $iY2)
	_WinAPI_MoveTo($hDC, $iX1, $iY1)
	If @error Then Return SetError(@error, @extended, False)
	_WinAPI_LineTo($hDC, $iX2, $iY2)
	If @error Then Return SetError(@error + 10, @extended, False)
	Return True
EndFunc   ;==>_WinAPI_DrawLine

; #FUNCTION# ====================================================================================================================
; Author.........: Rover
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_DrawShadowText($hDC, $sText, $iRGBText, $iRGBShadow, $iXOffset = 0, $iYOffset = 0, $tRECT = 0, $iFlags = 0)
	Local $aRet

	If Not IsDllStruct($tRECT) Then
		$tRECT = DllStructCreate($tagRECT)
		$aRet = DllCall('user32.dll', 'bool', 'GetClientRect', 'hwnd', _WinAPI_WindowFromDC($hDC), 'struct*', $tRECT)
		If @error Then Return SetError(@error + 10, @extended, 0)
		If Not $aRet[0] Then Return SetError(10, 0, 0)
	EndIf
	$aRet = DllCall('comctl32.dll', 'int', 'DrawShadowText', 'handle', $hDC, 'wstr', $sText, 'uint', -1, 'struct*', $tRECT, _
			'dword', $iFlags, 'int', __RGB($iRGBText), 'int', __RGB($iRGBShadow), 'int', $iXOffset, 'int', $iYOffset)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DrawShadowText

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmDefWindowProc($hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('dwmapi.dll', 'bool', 'DwmDefWindowProc', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, 'lparam', $lParam, 'lresult*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_DwmDefWindowProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmEnableBlurBehindWindow($hWnd, $bEnable = True, $bTransition = False, $hRgn = 0)
	Local $tBLURBEHIND = DllStructCreate('dword;bool;handle;bool')
	Local $iFlags = 0

	If $hRgn Then
		$iFlags += 2
		DllStructSetData($tBLURBEHIND, 3, $hRgn)
	EndIf

	DllStructSetData($tBLURBEHIND, 1, BitOR($iFlags, 0x05))
	DllStructSetData($tBLURBEHIND, 2, $bEnable)
	DllStructSetData($tBLURBEHIND, 4, $bTransition)

	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmEnableBlurBehindWindow', 'hwnd', $hWnd, 'struct*', $tBLURBEHIND)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmEnableBlurBehindWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmEnableComposition($bEnable)
	If $bEnable Then $bEnable = 1

	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmEnableComposition', 'uint', $bEnable)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmEnableComposition

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmExtendFrameIntoClientArea($hWnd, $tMARGINS = 0)
	If Not IsDllStruct($tMARGINS) Then
		$tMARGINS = _WinAPI_CreateMargins(-1, -1, -1, -1)
	EndIf

	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmExtendFrameIntoClientArea', 'hwnd', $hWnd, 'struct*', $tMARGINS)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmExtendFrameIntoClientArea

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmGetColorizationColor()
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmGetColorizationColor', 'dword*', 0, 'bool*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return SetExtended($aRet[2], $aRet[1])
EndFunc   ;==>_WinAPI_DwmGetColorizationColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmGetColorizationParameters()
	Local $tDWMCP = DllStructCreate($tagDWM_COLORIZATION_PARAMETERS)
	Local $aRet = DllCall('dwmapi.dll', 'uint', 127, 'struct*', $tDWMCP)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tDWMCP
EndFunc   ;==>_WinAPI_DwmGetColorizationParameters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmGetWindowAttribute($hWnd, $iAttribute)
	Local $tagStruct
	Switch $iAttribute
		Case 5, 9
			$tagStruct = $tagRECT
		Case 1
			$tagStruct = 'uint'
		Case Else
			Return SetError(11, 0, 0)
	EndSwitch

	Local $tData = DllStructCreate($tagStruct)
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmGetWindowAttribute', 'hwnd', $hWnd, 'dword', $iAttribute, _
			'struct*', $tData, 'dword', DllStructGetSize($tData))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Switch $iAttribute
		Case 1
			Return DllStructGetData($tData, 1)
		Case Else
			Return $tData
	EndSwitch
EndFunc   ;==>_WinAPI_DwmGetWindowAttribute

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmInvalidateIconicBitmaps($hWnd)
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmInvalidateIconicBitmaps', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmInvalidateIconicBitmaps

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmIsCompositionEnabled()
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmIsCompositionEnabled', 'bool*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_DwmIsCompositionEnabled

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmQueryThumbnailSourceSize($hThumbnail)
	Local $tSIZE = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmQueryThumbnailSourceSize', 'handle', $hThumbnail, 'struct*', $tSIZE)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tSIZE
EndFunc   ;==>_WinAPI_DwmQueryThumbnailSourceSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmRegisterThumbnail($hDestination, $hSource)
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmRegisterThumbnail', 'hwnd', $hDestination, 'hwnd', $hSource, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_DwmRegisterThumbnail

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DwmSetColorizationParameters($tDWMCP)
	Local $aRet = DllCall('dwmapi.dll', 'uint', 131, 'struct*', $tDWMCP, 'uint', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmSetColorizationParameters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmSetIconicLivePreviewBitmap($hWnd, $hBitmap, $bFrame = False, $tClient = 0)
	Local $iFlags
	If $bFrame Then
		$iFlags = 0x00000001
	Else
		$iFlags = 0
	EndIf

	Local $aRet = DllCall('dwmapi.dll', 'uint', 'DwmSetIconicLivePreviewBitmap', 'hwnd', $hWnd, 'handle', $hBitmap, _
			'struct*', $tClient, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmSetIconicLivePreviewBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmSetIconicThumbnail($hWnd, $hBitmap, $bFrame = False)
	Local $iFlags
	If $bFrame Then
		$iFlags = 0x00000001
	Else
		$iFlags = 0
	EndIf

	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmSetIconicThumbnail', 'hwnd', $hWnd, 'handle', $hBitmap, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmSetIconicThumbnail

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmSetWindowAttribute($hWnd, $iAttribute, $iData)
	Switch $iAttribute
		Case 2, 3, 4, 6, 7, 8, 10, 11, 12

		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmSetWindowAttribute', 'hwnd', $hWnd, 'dword', $iAttribute, _
			'dword*', $iData, 'dword', 4)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmSetWindowAttribute

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmUnregisterThumbnail($hThumbnail)
	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmUnregisterThumbnail', 'handle', $hThumbnail)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmUnregisterThumbnail

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DwmUpdateThumbnailProperties($hThumbnail, $bVisible = True, $bClientAreaOnly = False, $iOpacity = 255, $tRectDest = 0, $tRectSrc = 0)
	Local Const $tagDWM_THUMBNAIL_PROPERTIES = 'struct;dword dwFlags;int rcDestination[4];int rcSource[4];byte opacity;bool opacity;bool fSourceClientAreaOnly;endstruct'
	Local $tTHUMBNAILPROPERTIES = DllStructCreate($tagDWM_THUMBNAIL_PROPERTIES)
	Local $tSIZE, $iFlags = 0
	If Not IsDllStruct($tRectDest) Then
		$tSIZE = _WinAPI_DwmQueryThumbnailSourceSize($hThumbnail)
		If @error Then
			Return SetError(@error + 10, @extended, 0)
		EndIf
		$tRectDest = _WinAPI_CreateRectEx(0, 0, DllStructGetData($tSIZE, 1), DllStructGetData($tSIZE, 2))
	EndIf
	For $i = 1 To 4
		DllStructSetData($tTHUMBNAILPROPERTIES, 2, DllStructGetData($tRectDest, $i), $i)
	Next
	If IsDllStruct($tRectSrc) Then
		$iFlags += 2
		For $i = 1 To 4
			DllStructSetData($tTHUMBNAILPROPERTIES, 3, DllStructGetData($tRectSrc, $i), $i)
		Next
	EndIf

	DllStructSetData($tTHUMBNAILPROPERTIES, 1, BitOR($iFlags, 0x1D))
	DllStructSetData($tTHUMBNAILPROPERTIES, 4, $iOpacity)
	DllStructSetData($tTHUMBNAILPROPERTIES, 5, $bVisible)
	DllStructSetData($tTHUMBNAILPROPERTIES, 6, $bClientAreaOnly)

	Local $aRet = DllCall('dwmapi.dll', 'long', 'DwmUpdateThumbnailProperties', 'handle', $hThumbnail, _
			'struct*', $tTHUMBNAILPROPERTIES)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DwmUpdateThumbnailProperties

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_Ellipse($hDC, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'Ellipse', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), 'int', DllStructGetData($tRECT, 4))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_Ellipse

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EndPaint($hWnd, ByRef $tPAINTSTRUCT)
	Local $aRet = DllCall('user32.dll', 'bool', 'EndPaint', 'hwnd', $hWnd, 'struct*', $tPAINTSTRUCT)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EndPaint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_EndPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'EndPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EndPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDisplayMonitors($hDC = 0, $tRECT = 0)
	Local $hEnumProc = DllCallbackRegister('__EnumDisplayMonitorsProc', 'bool', 'handle;handle;ptr;lparam')

	Dim $__g_vEnum[101][2] = [[0]]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumDisplayMonitors', 'handle', $hDC, 'struct*', $tRECT, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumDisplayMonitors

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDisplaySettings($sDevice, $iMode)
	Local $sTypeOfDevice = 'wstr'
	If Not StringStripWS($sDevice, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfDevice = 'ptr'
		$sDevice = 0
	EndIf

	Local $tDEVMODE = DllStructCreate($tagDEVMODE_DISPLAY)
	DllStructSetData($tDEVMODE, 'Size', DllStructGetSize($tDEVMODE))
	DllStructSetData($tDEVMODE, 'DriverExtra', 0)

	Local $aRet = DllCall('user32.dll', 'bool', 'EnumDisplaySettingsW', $sTypeOfDevice, $sDevice, 'dword', $iMode, _
			'struct*', $tDEVMODE)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[5]
	$aResult[0] = DllStructGetData($tDEVMODE, 'PelsWidth')
	$aResult[1] = DllStructGetData($tDEVMODE, 'PelsHeight')
	$aResult[2] = DllStructGetData($tDEVMODE, 'BitsPerPel')
	$aResult[3] = DllStructGetData($tDEVMODE, 'DisplayFrequency')
	$aResult[4] = DllStructGetData($tDEVMODE, 'DisplayFlags')
	Return $aResult
EndFunc   ;==>_WinAPI_EnumDisplaySettings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumFontFamilies($hDC = 0, $sFaceName = '', $iCharSet = 1, $iFontType = 0x07, $sPattern = '', $bExclude = False)
	Local $tLOGFONT = DllStructCreate($tagLOGFONT)
	Local $tPattern = DllStructCreate('uint;uint;ptr;wchar[' & (StringLen($sPattern) + 1) & ']')

	DllStructSetData($tPattern, 1, $iFontType)
	If Not $sPattern Then
		DllStructSetData($tPattern, 2, 0)
		DllStructSetData($tPattern, 3, 0)
	Else
		DllStructSetData($tPattern, 2, $bExclude)
		DllStructSetData($tPattern, 3, DllStructGetPtr($tPattern, 4))
		DllStructSetData($tPattern, 4, $sPattern)
	EndIf
	DllStructSetData($tLOGFONT, 9, $iCharSet)
	DllStructSetData($tLOGFONT, 13, 0)
	DllStructSetData($tLOGFONT, 14, StringLeft($sFaceName, 31))
	Local $hCDC
	If Not $hDC Then
		$hCDC = _WinAPI_CreateCompatibleDC(0)
	Else
		$hCDC = $hDC
	EndIf
	Dim $__g_vEnum[101][8] = [[0]]
	Local $hEnumProc = DllCallbackRegister('__EnumFontFamiliesProc', 'int', 'ptr;ptr;dword;PTR')
	Local $aRet = DllCall('gdi32.dll', 'int', 'EnumFontFamiliesExW', 'handle', $hCDC, 'struct*', $tLOGFONT, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'struct*', $tPattern, 'dword', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If Not $hDC Then
		_WinAPI_DeleteDC($hCDC)
	EndIf
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumFontFamilies

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EqualRect($tRECT1, $tRECT2)
	Local $aRet = DllCall('user32.dll', 'bool', 'EqualRect', 'struct*', $tRECT1, 'struct*', $tRECT2)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EqualRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EqualRgn($hRgn1, $hRgn2)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'EqualRgn', 'handle', $hRgn1, 'handle', $hRgn2)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EqualRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ExcludeClipRect($hDC, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'ExcludeClipRect', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), 'int', DllStructGetData($tRECT, 4))
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ExcludeClipRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ExtCreatePen($iPenStyle, $iWidth, $iBrushStyle, $iRGB, $iHatch = 0, $aUserStyle = 0, $iStart = 0, $iEnd = -1)
	Local $iCount = 0, $tStyle = 0

	If BitAND($iPenStyle, 0xFF) = 7 Then
		If __CheckErrorArrayBounds($aUserStyle, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)
		$tStyle = DllStructCreate('dword[' & ($iEnd - $iStart + 1) & ']')

		For $i = $iStart To $iEnd
			DllStructSetData($tStyle, 1, $aUserStyle[$i], $iCount + 1)
			$iCount += 1
		Next
	EndIf

	Local $tLOGBRUSH = DllStructCreate($tagLOGBRUSH)
	DllStructSetData($tLOGBRUSH, 1, $iBrushStyle)
	DllStructSetData($tLOGBRUSH, 2, __RGB($iRGB))
	DllStructSetData($tLOGBRUSH, 3, $iHatch)

	Local $aRet = DllCall('gdi32.dll', 'handle', 'ExtCreatePen', 'dword', $iPenStyle, 'dword', $iWidth, 'struct*', $tLOGBRUSH, _
			'dword', $iCount, 'struct*', $tStyle)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ExtCreatePen

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ExtCreateRegion($tRGNDATA, $tXFORM = 0)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'ExtCreateRegion', 'struct*', $tXFORM, 'dword', DllStructGetSize($tRGNDATA), _
			'struct*', $tRGNDATA)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ExtCreateRegion

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ExtFloodFill($hDC, $iX, $iY, $iRGB, $iType = 0)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'ExtFloodFill', 'handle', $hDC, 'int', $iX, 'int', $iY, 'dword', __RGB($iRGB), _
			'uint', $iType)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ExtFloodFill

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ExtSelectClipRgn($hDC, $hRgn, $iMode = 5)
	Local $aRet = DllCall('gdi32.dll', 'int', 'ExtSelectClipRgn', 'handle', $hDC, 'handle', $hRgn, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ExtSelectClipRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FillPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'FillPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FillPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FillRgn($hDC, $hRgn, $hBrush)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'FillRgn', 'handle', $hDC, 'handle', $hRgn, 'handle', $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FillRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FlattenPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'FlattenPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FlattenPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FrameRgn($hDC, $hRgn, $hBrush, $iWidth, $iHeight)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'FrameRgn', 'handle', $hDC, 'handle', $hRgn, 'handle', $hBrush, 'int', $iWidth, 'int', $iHeight)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FrameRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GdiComment($hDC, $pBuffer, $iSize)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GdiComment', 'handle', $hDC, 'uint', $iSize, 'struct*', $pBuffer)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GdiComment

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetArcDirection($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetArcDirection', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	If ($aRet[0] < 1) Or ($aRet[0] > 2) Then Return SetError(10, $aRet[0], 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetArcDirection

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetBitmapBits($hBitmap, $iSize, $pBits)
	Local $aRet = DllCall('gdi32.dll', 'long', 'GetBitmapBits', 'handle', $hBitmap, 'long', $iSize, 'struct*', $pBits)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetBitmapBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBitmapDimensionEx($hBitmap)
	Local $tSIZE = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetBitmapDimensionEx', 'handle', $hBitmap, 'struct*', $tSIZE)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $tSIZE
EndFunc   ;==>_WinAPI_GetBitmapDimensionEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetBkColor($hDC)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'GetBkColor', 'handle', $hDC)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, 0)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_GetBkColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBoundsRect($hDC, $iFlags = 0)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetBoundsRect', 'handle', $hDC, 'struct*', $tRECT, 'uint', $iFlags)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return SetExtended($aRet[0], $tRECT)
EndFunc   ;==>_WinAPI_GetBoundsRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBrushOrg($hDC)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetBrushOrgEx', 'handle', $hDC, 'struct*', $tPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_GetBrushOrg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetBValue($iRGB)
	Return BitShift(BitAND(__RGB($iRGB), 0xFF0000), 16)
EndFunc   ;==>_WinAPI_GetBValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetClipBox($hDC, ByRef $tRECT)
	$tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetClipBox', 'handle', $hDC, 'struct*', $tRECT)
	If @error Or Not $aRet[0] Then
		; If Not $aRet[0] Then Return SetError(1000, 0, 0)
		$tRECT = 0
		Return SetError(@error, @extended, 0)
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetClipBox

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetClipRgn($hDC)
	Local $hRgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)
	Local $iError = 0
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetClipRgn', 'handle', $hDC, 'handle', $hRgn)
	If @error Or ($aRet[0] = -1) Then $iError = @error + 10
	If $iError Or Not $aRet[0] Then
		_WinAPI_DeleteObject($hRgn)
		$hRgn = 0
	EndIf
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)
	Return SetError($iError, 0, $hRgn)
EndFunc   ;==>_WinAPI_GetClipRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetColorAdjustment($hDC)
	Local $tAdjustment = DllStructCreate($tagCOLORADJUSTMENT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetColorAdjustment', 'handle', $hDC, 'struct*', $tAdjustment)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tAdjustment
EndFunc   ;==>_WinAPI_GetColorAdjustment

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentPosition($hDC)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetCurrentPositionEx', 'handle', $hDC, 'struct*', $tPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_GetCurrentPosition

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDeviceGammaRamp($hDC, ByRef $aRamp)
	$aRamp = 0

	Local $tData = DllStructCreate('word[256];word[256];word[256]')
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetDeviceGammaRamp', 'handle', $hDC, 'struct*', $tData)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Dim $aRamp[256][3]
	For $i = 0 To 2
		For $j = 0 To 255
			$aRamp[$j][$i] = DllStructGetData($tData, $i + 1, $j + 1)
		Next
	Next
	Return 1
EndFunc   ;==>_WinAPI_GetDeviceGammaRamp

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDIBColorTable($hBitmap)
	Local $hDC = _WinAPI_CreateCompatibleDC(0)
	Local $hSv = _WinAPI_SelectObject($hDC, $hBitmap)
	Local $tPeak = DllStructCreate('dword[256]')
	Local $iError = 0
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetDIBColorTable', 'handle', $hDC, 'uint', 0, 'uint', 256, 'struct*', $tPeak)
	If @error Or Not $aRet[0] Then $iError = @error + 10

	_WinAPI_SelectObject($hDC, $hSv)
	_WinAPI_DeleteDC($hDC)
	If $iError Then Return SetError($iError, 0, 0)

	Local $tData = DllStructCreate('dword[' & $aRet[0] & ']')
	If @error Then Return SetError(@error + 20, @extended, 0)

	_WinAPI_MoveMemory($tData, $aRet[4], 4 * $aRet[0])
	; Return SetError(@error, @extended, 0) ; cannot really occur
	; EndIf

	Return SetExtended($aRet[0], $tData)
EndFunc   ;==>_WinAPI_GetDIBColorTable

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDIBits($hDC, $hBitmap, $iStartScan, $iScanLines, $pBits, $tBI, $iUsage)
	Local $aResult = DllCall("gdi32.dll", "int", "GetDIBits", "handle", $hDC, "handle", $hBitmap, "uint", $iStartScan, _
			"uint", $iScanLines, "struct*", $pBits, "struct*", $tBI, "uint", $iUsage)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDIBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetEnhMetaFile($sFilePath)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'GetEnhMetaFileW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetEnhMetaFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetEnhMetaFileBits($hEmf, ByRef $pBuffer)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetEnhMetaFileBits', 'handle', $hEmf, 'uint', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 50, @extended, 0)
	$pBuffer = __HeapReAlloc($pBuffer, $aRet[0], 1)
	If @error Then Return SetError(@error, @extended, 0)

	$aRet = DllCall('gdi32.dll', 'uint', 'GetEnhMetaFileBits', 'handle', $hEmf, 'uint', $aRet[0], 'ptr', $pBuffer)
	If Not $aRet[0] Then Return SetError(60, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetEnhMetaFileBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetEnhMetaFileDescription($hEmf)
	Local $tData = DllStructCreate('wchar[4096]')
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetEnhMetaFileDescriptionW', 'handle', $hEmf, 'uint', 4096, 'struct*', $tData)
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error + 20, $aRet[0], 0) ; GDI_ERROR
	If Not $aRet[0] Then Return 0

	Local $aData = _WinAPI_StructToArray($tData)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aResult[2]
	For $i = 0 To 1
		If $aData[0] > $i Then
			$aResult[$i] = $aData[$i + 1]
		Else
			$aResult[$i] = ''
		EndIf
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetEnhMetaFileDescription

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetEnhMetaFileDimension($hEmf)
	Local $tENHMETAHEADER = _WinAPI_GetEnhMetaFileHeader($hEmf)
	If @error Then Return SetError(@error, @extended, 0)

	Local $tSIZE = DllStructCreate($tagSIZE)
	DllStructSetData($tSIZE, 1, Round((DllStructGetData($tENHMETAHEADER, 'rcFrame', 3) - DllStructGetData($tENHMETAHEADER, 'rcFrame', 1)) * DllStructGetData($tENHMETAHEADER, 'Device', 1) / DllStructGetData($tENHMETAHEADER, 'Millimeters', 1) / 100))
	DllStructSetData($tSIZE, 2, Round((DllStructGetData($tENHMETAHEADER, 'rcFrame', 4) - DllStructGetData($tENHMETAHEADER, 'rcFrame', 2)) * DllStructGetData($tENHMETAHEADER, 'Device', 2) / DllStructGetData($tENHMETAHEADER, 'Millimeters', 2) / 100))

	Return $tSIZE
EndFunc   ;==>_WinAPI_GetEnhMetaFileDimension

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetEnhMetaFileHeader($hEmf)
	Local $tENHMETAHEADER = DllStructCreate($tagENHMETAHEADER)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetEnhMetaFileHeader', 'handle', $hEmf, _
			'uint', DllStructGetSize($tENHMETAHEADER), 'struct*', $tENHMETAHEADER)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return SetExtended($aRet[0], $tENHMETAHEADER)
EndFunc   ;==>_WinAPI_GetEnhMetaFileHeader

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetFontName($sFaceName, $iStyle = 0, $iCharSet = 1)
	If Not $sFaceName Then Return SetError(1, 0, '')

	Local $iFlags = 0
	If BitAND($iStyle, 0x01) Then
		$iFlags += 0x00000020
	EndIf
	If BitAND($iStyle, 0x02) Then
		$iFlags += 0x00000001
	EndIf
	If Not $iFlags Then
		$iFlags = 0x00000040
	EndIf
	Local $tLOGFONT = DllStructCreate($tagLOGFONT)
	DllStructSetData($tLOGFONT, 9, $iCharSet)
	DllStructSetData($tLOGFONT, 13, 0)
	DllStructSetData($tLOGFONT, 14, StringLeft($sFaceName, 31))
	Local $tFN = DllStructCreate('dword;wchar[64]')
	DllStructSetData($tFN, 1, $iFlags)
	DllStructSetData($tFN, 2, '')
	Local $hDC = _WinAPI_CreateCompatibleDC(0)
	Local $hEnumProc = DllCallbackRegister('__EnumFontStylesProc', 'int', 'ptr;ptr;dword;lparam')
	Local $sRet = ''
	Local $aRet = DllCall('gdi32.dll', 'int', 'EnumFontFamiliesExW', 'handle', $hDC, 'struct*', $tLOGFONT, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'struct*', $tFN, 'dword', 0)
	If Not @error And Not $aRet[0] Then $sRet = DllStructGetData($tFN, 2)
	DllCallbackFree($hEnumProc)
	_WinAPI_DeleteDC($hDC)
	If Not $sRet Then Return SetError(2, 0, '')

	Return $sRet
EndFunc   ;==>_WinAPI_GetFontName

; #FUNCTION# ====================================================================================================================
; Author ........: funkey
; Modified ......: UEZ
; ===============================================================================================================================
Func _WinAPI_GetFontResourceInfo($sFont, $bForce = False, $iFlag = Default)
	If $iFlag = Default Then
		If $bForce Then
			If Not _WinAPI_AddFontResourceEx($sFont, $FR_NOT_ENUM) Then Return SetError(@error + 20, @extended, '')
		EndIf

		Local $iError = 0
		Local $aRet = DllCall('gdi32.dll', 'bool', 'GetFontResourceInfoW', 'wstr', $sFont, 'dword*', 4096, 'wstr', '', 'dword', 0x01)
		If @error Or Not $aRet[0] Then $iError = @error + 10

		If $bForce Then
			_WinAPI_RemoveFontResourceEx($sFont, $FR_NOT_ENUM)
		EndIf
		If $iError Then Return SetError($iError, 0, '')

		Return $aRet[3]
	Else
		If Not FileExists($sFont) Then
			$sFont = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Fonts") & "\" & $sFont
			If Not FileExists($sFont) Then Return SetError(31, 0, "")
		EndIf
		Local Const $hFile = _WinAPI_CreateFile($sFont, 2, 2, 2)
		If Not $hFile Then Return SetError(32, _WinAPI_GetLastError(), "")
		Local Const $iFile = FileGetSize($sFont)
		Local Const $tBuffer = DllStructCreate("byte[" & $iFile + 1 & "]")
		Local Const $pFile = DllStructGetPtr($tBuffer)
		Local $iRead
		_WinAPI_ReadFile($hFile, $pFile, $iFile, $iRead)
		_WinAPI_CloseHandle($hFile)
		Local $sTTFName = _WinAPI_GetFontMemoryResourceInfo($pFile, $iFlag)
		If @error Then
			If @error = 1 And $iFlag = 4 Then
				$sTTFName = _WinAPI_GetFontResourceInfo($sFont, True)
				Return SetError(@error, @extended, $sTTFName)
			EndIf
			Return SetError(33, @error, "")
		EndIf
		Return $sTTFName
	EndIf
EndFunc   ;==>_WinAPI_GetFontResourceInfo

; #FUNCTION# ====================================================================================================================
; Author ........: funkey
; Modified ......: UEZ, jpm
; ===============================================================================================================================
Func _WinAPI_GetFontMemoryResourceInfo($pMemory, $iFlag = 1)
	Local Const $tagTT_OFFSET_TABLE = "USHORT uMajorVersion;USHORT uMinorVersion;USHORT uNumOfTables;USHORT uSearchRange;USHORT uEntrySelector;USHORT uRangeShift"
	Local Const $tagTT_TABLE_DIRECTORY = "char szTag[4];ULONG uCheckSum;ULONG uOffset;ULONG uLength"
	Local Const $tagTT_NAME_TABLE_HEADER = "USHORT uFSelector;USHORT uNRCount;USHORT uStorageOffset"
	Local Const $tagTT_NAME_RECORD = "USHORT uPlatformID;USHORT uEncodingID;USHORT uLanguageID;USHORT uNameID;USHORT uStringLength;USHORT uStringOffset"

	Local $tTTOffsetTable = DllStructCreate($tagTT_OFFSET_TABLE, $pMemory)
	Local $iNumOfTables = _WinAPI_SwapWord(DllStructGetData($tTTOffsetTable, "uNumOfTables"))

	;check is this is a true type font and the version is 1.0
	If Not (_WinAPI_SwapWord(DllStructGetData($tTTOffsetTable, "uMajorVersion")) = 1 And _WinAPI_SwapWord(DllStructGetData($tTTOffsetTable, "uMinorVersion")) = 0) Then Return SetError(1, 0, "")

	Local $iTblDirSize = DllStructGetSize(DllStructCreate($tagTT_TABLE_DIRECTORY))
	Local $bFound = False, $iOffset, $tTblDir
	For $i = 0 To $iNumOfTables - 1
		$tTblDir = DllStructCreate($tagTT_TABLE_DIRECTORY, $pMemory + DllStructGetSize($tTTOffsetTable) + $i * $iTblDirSize)
		If StringLeft(DllStructGetData($tTblDir, "szTag"), 4) = "name" Then
			$bFound = True
			$iOffset = _WinAPI_SwapDWord(DllStructGetData($tTblDir, "uOffset"))
			ExitLoop
		EndIf
	Next

	If Not $bFound Then Return SetError(2, 0, "")

	Local $tNTHeader = DllStructCreate($tagTT_NAME_TABLE_HEADER, $pMemory + $iOffset)
	Local $iNTHeaderSize = DllStructGetSize($tNTHeader)
	Local $iNRCount = _WinAPI_SwapWord(DllStructGetData($tNTHeader, "uNRCount"))
	Local $iStorageOffset = _WinAPI_SwapWord(DllStructGetData($tNTHeader, "uStorageOffset"))

	Local $iTTRecordSize = DllStructGetSize(DllStructCreate($tagTT_NAME_RECORD))
	Local $tResult, $sResult, $iStringLength, $iStringOffset, $iEncodingID, $tTTRecord
	For $i = 0 To $iNRCount - 1
		$tTTRecord = DllStructCreate($tagTT_NAME_RECORD, $pMemory + $iOffset + $iNTHeaderSize + $i * $iTTRecordSize)

		If _WinAPI_SwapWord($tTTRecord.uNameID) = $iFlag Then ;1 says that this is font name. 0 for example determines copyright info
			$iStringLength = _WinAPI_SwapWord(DllStructGetData($tTTRecord, "uStringLength"))
			$iStringOffset = _WinAPI_SwapWord(DllStructGetData($tTTRecord, "uStringOffset"))
			$iEncodingID = _WinAPI_SwapWord(DllStructGetData($tTTRecord, "uEncodingID"))

			Local $sWchar = "char"
			If $iEncodingID = 1 Then
				$sWchar = "word"
				$iStringLength = $iStringLength / 2
			EndIf
			$tResult = DllStructCreate($sWchar & " szTTFName[" & $iStringLength & "]", $pMemory + $iOffset + $iStringOffset + $iStorageOffset)

			If $iEncodingID = 1 Then
				$sResult = ""
				For $j = 1 To $iStringLength
					$sResult &= ChrW(_WinAPI_SwapWord(DllStructGetData($tResult, 1, $j)))
				Next
			Else
				$sResult = $tResult.szTTFName
			EndIf

			If StringLen($sResult) > 0 Then ExitLoop
		EndIf
	Next

	Return $sResult
EndFunc   ;==>_WinAPI_GetFontMemoryResourceInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetGlyphOutline($hDC, $sChar, $iFormat, ByRef $pBuffer, $tMAT2 = 0)
	Local $tGM = DllStructCreate($tagGLYPHMETRICS)
	Local $aRet, $iLength = 0

	If Not IsDllStruct($tMAT2) Then
		$tMAT2 = DllStructCreate('short[8]')
		DllStructSetData($tMAT2, 1, 1, 2)
		DllStructSetData($tMAT2, 1, 1, 8)
	EndIf
	If $iFormat Then
		$aRet = DllCall('gdi32.dll', 'dword', 'GetGlyphOutlineW', 'handle', $hDC, 'uint', AscW($sChar), 'uint', $iFormat, _
				'struct*', $tGM, 'dword', 0, 'ptr', 0, 'struct*', $tMAT2)
		If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error + 10, @extended, 0)
		$iLength = $aRet[0]
		$pBuffer = __HeapReAlloc($pBuffer, $iLength, 1)
		If @error Then Return SetError(@error + 20, @extended, 0)
	EndIf
	$aRet = DllCall('gdi32.dll', 'dword', 'GetGlyphOutlineW', 'handle', $hDC, 'uint', AscW($sChar), 'uint', $iFormat, _
			'struct*', $tGM, 'dword', $iLength, 'ptr', $pBuffer, 'struct*', $tMAT2)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return SetExtended($iLength, $tGM)
EndFunc   ;==>_WinAPI_GetGlyphOutline

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetGraphicsMode($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetGraphicsMode', 'handle', $hDC)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetGraphicsMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetGValue($iRGB)
	Return BitShift(BitAND(__RGB($iRGB), 0x00FF00), 8)
EndFunc   ;==>_WinAPI_GetGValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetMapMode($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetMapMode', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetMapMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetMonitorInfo($hMonitor)
	Local $tMIEX = DllStructCreate('dword;long[4];long[4];dword;wchar[32]')
	DllStructSetData($tMIEX, 1, DllStructGetSize($tMIEX))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetMonitorInfoW', 'handle', $hMonitor, 'struct*', $tMIEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[4]
	For $i = 0 To 1
		$aResult[$i] = DllStructCreate($tagRECT)
		_WinAPI_MoveMemory($aResult[$i], DllStructGetPtr($tMIEX, $i + 2), 16)
		; Return SetError(@error + 10, @extended, 0) ; cannot really occur
		; EndIf
	Next
	$aResult[3] = DllStructGetData($tMIEX, 5)
	Switch DllStructGetData($tMIEX, 4)
		Case 1 ; MONITORINFOF_PRIMARY
			$aResult[2] = 1
		Case Else
			$aResult[2] = 0
	EndSwitch
	Return $aResult
EndFunc   ;==>_WinAPI_GetMonitorInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetOutlineTextMetrics($hDC)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetOutlineTextMetricsW', 'handle', $hDC, 'uint', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	Local $tData = DllStructCreate('byte[' & $aRet[0] & ']')
	Local $tOLTM = DllStructCreate($tagOUTLINETEXTMETRIC, DllStructGetPtr($tData))
	$aRet = DllCall('gdi32.dll', 'uint', 'GetOutlineTextMetricsW', 'handle', $hDC, 'uint', $aRet[0], 'struct*', $tData)
	If Not $aRet[0] Then Return SetError(20, 0, 0)

	Return $tOLTM
EndFunc   ;==>_WinAPI_GetOutlineTextMetrics

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetPixel($hDC, $iX, $iY)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'GetPixel', 'handle', $hDC, 'int', $iX, 'int', $iY)
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 4294967295 Then Return SetError(1000, 0, -1)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_GetPixel

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetPolyFillMode($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetPolyFillMode', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetPolyFillMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPosFromRect($tRECT)
	Local $aResult[4]
	For $i = 0 To 3
		$aResult[$i] = DllStructGetData($tRECT, $i + 1)
		If @error Then Return SetError(@error, @extended, 0)
	Next

	For $i = 2 To 3
		$aResult[$i] -= $aResult[$i - 2]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetPosFromRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetRegionData($hRgn, ByRef $tRGNDATA)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'GetRegionData', 'handle', $hRgn, 'dword', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Then
		$tRGNDATA = 0
		; If Not $aRet[0] Then Return SetError(1000, 0, 0)
		Return SetError(@error, @extended, False)
	EndIf
	$tRGNDATA = DllStructCreate($tagRGNDATAHEADER)
	Local $iRectSize = $aRet[0] - DllStructGetSize($tRGNDATA)
	If $iRectSize > 0 Then $tRGNDATA = DllStructCreate($tagRGNDATAHEADER & ';byte[' & $iRectSize & ']')
	$aRet = DllCall('gdi32.dll', 'dword', 'GetRegionData', 'handle', $hRgn, 'dword', $aRet[0], 'struct*', $tRGNDATA)
	If Not $aRet[0] Then $tRGNDATA = 0

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetRegionData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetRgnBox($hRgn, ByRef $tRECT)
	$tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetRgnBox', 'handle', $hRgn, 'struct*', $tRECT)
	If @error Or Not $aRet[0] Then
		$tRECT = 0
		; If Not $aRet[0] Then Return SetError(1000, 0, 0)
		Return SetError(@error, @extended, 0)
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetRgnBox

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetROP2($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetROP2', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetROP2

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetRValue($iRGB)
	Return BitAND(__RGB($iRGB), 0x0000FF)
EndFunc   ;==>_WinAPI_GetRValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetStretchBltMode($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetStretchBltMode', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetStretchBltMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTabbedTextExtent($hDC, $sText, $aTab = 0, $iStart = 0, $iEnd = -1)
	Local $iTab, $iCount
	If Not IsArray($aTab) Then
		If $aTab Then
			$iTab = $aTab
			Dim $aTab[1] = [$iTab]
			$iStart = 0
			$iEnd = 0
			$iCount = 1
		Else
			$iCount = 0
		EndIf
	Else
		$iCount = 1
	EndIf

	Local $tTab = 0
	If $iCount Then
		If __CheckErrorArrayBounds($aTab, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

		$iCount = $iEnd - $iStart + 1
		$tTab = DllStructCreate('uint[' & $iCount & ']')
		$iTab = 1
		For $i = $iStart To $iEnd
			DllStructSetData($tTab, 1, $aTab[$i], $iTab)
			$iTab += 1
		Next
	EndIf
	Local $aRet = DllCall('user32.dll', 'dword', 'GetTabbedTextExtentW', 'handle', $hDC, 'wstr', $sText, 'int', StringLen($sText), 'int', $iCount, 'struct*', $tTab)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	Return _WinAPI_CreateSize(_WinAPI_LoWord($aRet[0]), _WinAPI_HiWord($aRet[0]))
EndFunc   ;==>_WinAPI_GetTabbedTextExtent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetTextAlign($hDC)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'GetTextAlign', 'handle', $hDC)
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 4294967295 Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTextAlign

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetTextCharacterExtra($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetTextCharacterExtra', 'handle', $hDC)
	If @error Or ($aRet[0] = 0x8000000) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 0x8000000 Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTextCharacterExtra

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTextFace($hDC)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetTextFaceW', 'handle', $hDC, 'int', 2048, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetTextFace

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetUDFColorMode()
	Return Number($__g_iRGBMode)
EndFunc   ;==>_WinAPI_GetUDFColorMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetUpdateRect($hWnd, $bErase = True)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetUpdateRect', 'hwnd', $hWnd, 'struct*', $tRECT, 'bool', $bErase)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetUpdateRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetUpdateRgn($hWnd, $hRgn, $bErase = True)
	Local $aRet = DllCall('user32.dll', 'int', 'GetUpdateRgn', 'hwnd', $hWnd, 'handle', $hRgn, 'bool', $bErase)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetUpdateRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowExt($hDC)
	Local $tSIZE = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetWindowExtEx', 'handle', $hDC, 'struct*', $tSIZE)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tSIZE
EndFunc   ;==>_WinAPI_GetWindowExt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowOrg($hDC)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetWindowOrgEx', 'handle', $hDC, 'struct*', $tPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_GetWindowOrg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowRgnBox($hWnd, ByRef $tRECT)
	$tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetWindowRgnBox', 'hwnd', $hWnd, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetWindowRgnBox

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWorldTransform($hDC)
	Local $tXFORM = DllStructCreate($tagXFORM)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetWorldTransform', 'handle', $hDC, 'struct*', $tXFORM)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tXFORM
EndFunc   ;==>_WinAPI_GetWorldTransform

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GradientFill($hDC, Const ByRef $aVertex, $iStart = 0, $iEnd = -1, $bRotate = False)
	If __CheckErrorArrayBounds($aVertex, $iStart, $iEnd, 2) Then Return SetError(@error + 10, @extended, 0)
	If UBound($aVertex, $UBOUND_COLUMNS) < 3 Then Return SetError(13, 0, 0)

	Local $iPoint = $iEnd - $iStart + 1
	If $iPoint > 3 Then
		$iEnd = $iStart + 2
		$iPoint = 3
	EndIf
	Local $iMode
	Switch $iPoint
		Case 2
			$iMode = Number(Not $bRotate)
		Case 3
			$iMode = 2
		Case Else
			Return SetError(15, 0, 0)
	EndSwitch
	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'ushort[8];'
	Next
	Local $tVertex = DllStructCreate($tagStruct)

	Local $iCount = 1
	Local $tGradient = DllStructCreate('ulong[' & $iPoint & ']')
	For $i = $iStart To $iEnd
		DllStructSetData($tGradient, 1, $iCount - 1, $iCount)
		DllStructSetData($tVertex, $iCount, _WinAPI_LoWord($aVertex[$i][0]), 1)
		DllStructSetData($tVertex, $iCount, _WinAPI_HiWord($aVertex[$i][0]), 2)
		DllStructSetData($tVertex, $iCount, _WinAPI_LoWord($aVertex[$i][1]), 3)
		DllStructSetData($tVertex, $iCount, _WinAPI_HiWord($aVertex[$i][1]), 4)
		DllStructSetData($tVertex, $iCount, BitShift(_WinAPI_GetRValue($aVertex[$i][2]), -8), 5)
		DllStructSetData($tVertex, $iCount, BitShift(_WinAPI_GetGValue($aVertex[$i][2]), -8), 6)
		DllStructSetData($tVertex, $iCount, BitShift(_WinAPI_GetBValue($aVertex[$i][2]), -8), 7)
		DllStructSetData($tVertex, $iCount, 0, 8)
		$iCount += 1
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'GdiGradientFill', 'handle', $hDC, 'struct*', $tVertex, 'ulong', $iPoint, _
			'struct*', $tGradient, 'ulong', 1, 'ulong', $iMode)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GradientFill

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_InflateRect(ByRef $tRECT, $iDX, $iDY)
	Local $aRet = DllCall('user32.dll', 'bool', 'InflateRect', 'struct*', $tRECT, 'int', $iDX, 'int', $iDY)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_InflateRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_IntersectClipRect($hDC, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'IntersectClipRect', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), _
			'int', DllStructGetData($tRECT, 4))
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_WinAPI_IntersectClipRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IntersectRect($tRECT1, $tRECT2)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'IntersectRect', 'struct*', $tRECT, 'struct*', $tRECT1, 'struct*', $tRECT2)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_IntersectRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_InvalidateRgn($hWnd, $hRgn = 0, $bErase = True)
	Local $aRet = DllCall('user32.dll', 'bool', 'InvalidateRgn', 'hwnd', $hWnd, 'handle', $hRgn, 'bool', $bErase)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_InvalidateRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_InvertANDBitmap($hBitmap, $bDelete = False)
	Local $tBITMAP = DllStructCreate($tagBITMAP)
	If Not _WinAPI_GetObject($hBitmap, DllStructGetSize($tBITMAP), $tBITMAP) Or (DllStructGetData($tBITMAP, 'bmBitsPixel') <> 1) Then
		Return SetError(@error + 10, @extended, 0)
	EndIf
	Local $hResult = _WinAPI_CreateDIB(DllStructGetData($tBITMAP, 'bmWidth'), DllStructGetData($tBITMAP, 'bmHeight'), 1)
	If Not $hResult Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Local $hSrcDC = _WinAPI_CreateCompatibleDC(0)
	Local $hSrcSv = _WinAPI_SelectObject($hSrcDC, $hBitmap)
	Local $hDstDC = _WinAPI_CreateCompatibleDC(0)
	Local $hDstSv = _WinAPI_SelectObject($hDstDC, $hResult)
	_WinAPI_BitBlt($hDstDC, 0, 0, DllStructGetData($tBITMAP, 'bmWidth'), DllStructGetData($tBITMAP, 'bmHeight'), $hSrcDC, 0, 0, 0x00330008)
	_WinAPI_SelectObject($hSrcDC, $hSrcSv)
	_WinAPI_DeleteDC($hSrcDC)
	_WinAPI_SelectObject($hDstDC, $hDstSv)
	_WinAPI_DeleteDC($hDstDC)
	If $bDelete Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return $hResult
EndFunc   ;==>_WinAPI_InvertANDBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_InvertColor($iColor)
	If $iColor = -1 Then Return 0
	Return 0xFFFFFF - BitAND($iColor, 0xFFFFFF)
EndFunc   ;==>_WinAPI_InvertColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_InvertRect($hDC, ByRef $tRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'InvertRect', 'handle', $hDC, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_InvertRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_InvertRgn($hDC, $hRgn)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'InvertRgn', 'handle', $hDC, 'handle', $hRgn)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_InvertRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsRectEmpty(ByRef $tRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsRectEmpty', 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsRectEmpty

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LineDDA($iX1, $iY1, $iX2, $iY2, $pLineProc, $pData = 0)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'LineDDA', 'int', $iX1, 'int', $iY1, 'int', $iX2, 'int', $iY2, 'ptr', $pLineProc, _
			'lparam', $pData)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LineDDA

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LineTo($hDC, $iX, $iY)
	Local $aResult = DllCall("gdi32.dll", "bool", "LineTo", "handle", $hDC, "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LineTo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LockWindowUpdate($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'LockWindowUpdate', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockWindowUpdate

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LPtoDP($hDC, ByRef $tPOINT, $iCount = 1)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'LPtoDP', 'handle', $hDC, 'struct*', $tPOINT, 'int', $iCount)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LPtoDP

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_MaskBlt($hDestDC, $iXDest, $iYDest, $iWidth, $iHeight, $hSrcDC, $iXSrc, $iYSrc, $hMask, $iXMask, $iYMask, $iRop)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'MaskBlt', 'handle', $hDestDC, 'int', $iXDest, 'int', $iYDest, _
			'int', $iWidth, 'int', $iHeight, 'hwnd', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, 'handle', $hMask, _
			'int', $iXMask, 'int', $iYMask, 'dword', $iRop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MaskBlt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ModifyWorldTransform($hDC, ByRef $tXFORM, $iMode)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'ModifyWorldTransform', 'handle', $hDC, 'struct*', $tXFORM, 'dword', $iMode)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ModifyWorldTransform

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_MonitorFromPoint(ByRef $tPOINT, $iFlag = 1)
	If DllStructGetSize($tPOINT) <> 8 Then Return SetError(@error + 10, @extended, 0)

	Local $aRet = DllCall('user32.dll', 'handle', 'MonitorFromPoint', 'struct', $tPOINT, 'dword', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MonitorFromPoint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_MonitorFromRect(ByRef $tRECT, $iFlag = 1)
	Local $aRet = DllCall('user32.dll', 'ptr', 'MonitorFromRect', 'struct*', $tRECT, 'dword', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MonitorFromRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_MonitorFromWindow($hWnd, $iFlag = 1)
	Local $aRet = DllCall('user32.dll', 'handle', 'MonitorFromWindow', 'hwnd', $hWnd, 'dword', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MonitorFromWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MoveTo($hDC, $iX, $iY)
	Local $aResult = DllCall("gdi32.dll", "bool", "MoveToEx", "handle", $hDC, "int", $iX, "int", $iY, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MoveTo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_MoveToEx($hDC, $iX, $iY)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'MoveToEx', 'handle', $hDC, 'int', $iX, 'int', $iY, 'struct*', $tPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_MoveToEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OffsetClipRgn($hDC, $iXOffset, $iYOffset)
	Local $aRet = DllCall('gdi32.dll', 'int', 'OffsetClipRgn', 'handle', $hDC, 'int', $iXOffset, 'int', $iYOffset)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OffsetClipRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OffsetPoints(ByRef $aPoint, $iXOffset, $iYOffset, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2) Then Return SetError(@error + 10, @extended, 0)
	If UBound($aPoint, $UBOUND_COLUMNS) < 2 Then Return SetError(13, 0, 0)

	For $i = $iStart To $iEnd
		$aPoint[$i][0] += $iXOffset
		$aPoint[$i][1] += $iYOffset
	Next
	Return 1
EndFunc   ;==>_WinAPI_OffsetPoints

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OffsetRect(ByRef $tRECT, $iDX, $iDY)
	Local $aRet = DllCall('user32.dll', 'bool', 'OffsetRect', 'struct*', $tRECT, 'int', $iDX, 'int', $iDY)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OffsetRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OffsetRgn($hRgn, $iXOffset, $iYOffset)
	Local $aRet = DllCall('gdi32.dll', 'int', 'OffsetRgn', 'handle', $hRgn, 'int', $iXOffset, 'int', $iYOffset)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OffsetRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OffsetWindowOrg($hDC, $iXOffset, $iYOffset)
	$__g_vExt = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'OffsetWindowOrgEx', 'handle', $hDC, 'int', $iXOffset, 'int', $iYOffset, _
			'struct*', $__g_vExt)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OffsetWindowOrg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PaintDesktop($hDC)
	Local $aRet = DllCall('user32.dll', 'bool', 'PaintDesktop', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PaintDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PaintRgn($hDC, $hRgn)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'PaintRgn', 'handle', $hDC, 'handle', $hRgn)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PaintRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PatBlt($hDC, $iX, $iY, $iWidth, $iHeight, $iRop)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'PatBlt', 'handle', $hDC, 'int', $iX, 'int', $iY, 'int', $iWidth, 'int', $iHeight, _
			'dword', $iRop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PatBlt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PathToRegion($hDC)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'PathToRegion', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathToRegion

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PlayEnhMetaFile($hDC, $hEmf, ByRef $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'PlayEnhMetaFile', 'handle', $hDC, 'handle', $hEmf, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PlayEnhMetaFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PlgBlt($hDestDC, Const ByRef $aPoint, $hSrcDC, $iXSrc, $iYSrc, $iWidth, $iHeight, $hMask = 0, $iXMask = 0, $iYMask = 0)
	If (UBound($aPoint) < 3) Or (UBound($aPoint, $UBOUND_COLUMNS) < 2) Then Return SetError(12, 0, False)

	Local $tPoints = DllStructCreate('long[2];long[2];long[2]')
	For $i = 0 To 2
		For $j = 0 To 1
			DllStructSetData($tPoints, $i + 1, $aPoint[$i][$j], $j + 1)
		Next
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'PlgBlt', 'handle', $hDestDC, 'struct*', $tPoints, 'handle', $hSrcDC, _
			'int', $iXSrc, 'int', $iYSrc, 'int', $iWidth, 'int', $iHeight, 'handle', $hMask, _
			'int', $iXMask, 'int', $iYMask)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PlgBlt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PolyBezier($hDC, Const ByRef $aPoint, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2, 2) Then Return SetError(@error + 10, @extended, False)

	Local $iPoint = 1 + 3 * Floor(($iEnd - $iStart) / 3)
	If $iPoint < 1 Then Return SetError(15, 0, False)

	$iEnd = $iStart + $iPoint - 1
	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'long[2];'
	Next
	Local $tPOINT = DllStructCreate($tagStruct)

	Local $iCount = 0
	For $i = $iStart To $iEnd
		$iCount += 1
		For $j = 0 To 1
			DllStructSetData($tPOINT, $iCount, $aPoint[$i][$j], $j + 1)
		Next
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'PolyBezier', 'handle', $hDC, 'struct*', $tPOINT, 'dword', $iPoint)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PolyBezier

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PolyBezierTo($hDC, Const ByRef $aPoint, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2, 2) Then Return SetError(@error + 10, @extended, False)

	Local $iPoint = 3 * Floor(($iEnd - $iStart + 1) / 3)
	If $iPoint < 3 Then Return SetError(15, 0, False)

	$iEnd = $iStart + $iPoint - 1
	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'long[2];'
	Next
	Local $tPOINT = DllStructCreate($tagStruct)

	Local $iCount = 0
	For $i = $iStart To $iEnd
		$iCount += 1
		For $j = 0 To 1
			DllStructSetData($tPOINT, $iCount, $aPoint[$i][$j], $j + 1)
		Next
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'PolyBezierTo', 'handle', $hDC, 'struct*', $tPOINT, 'dword', $iPoint)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PolyBezierTo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PolyDraw($hDC, Const ByRef $aPoint, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2) Then Return SetError(@error + 10, @extended, 0)
	If UBound($aPoint, $UBOUND_COLUMNS) < 3 Then Return SetError(13, 0, False)

	Local $iPoint = $iEnd - $iStart + 1
	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'long[2];'
	Next
	Local $tPOINT = DllStructCreate($tagStruct)
	Local $tTypes = DllStructCreate('byte[' & $iPoint & ']')
	Local $iCount = 0
	For $i = $iStart To $iEnd
		$iCount += 1
		For $j = 0 To 1
			DllStructSetData($tPOINT, $iCount, $aPoint[$i][$j], $j + 1)
		Next
		DllStructSetData($tTypes, 1, $aPoint[$i][2], $iCount)
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'PolyDraw', 'handle', $hDC, 'struct*', $tPOINT, 'struct*', $tTypes, 'dword', $iPoint)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PolyDraw

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_Polygon($hDC, Const ByRef $aPoint, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2, 2) Then Return SetError(@error + 10, @extended, False)

	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'int[2];'
	Next
	Local $tData = DllStructCreate($tagStruct)
	Local $iCount = 1
	For $i = $iStart To $iEnd
		For $j = 0 To 1
			DllStructSetData($tData, $iCount, $aPoint[$i][$j], $j + 1)
		Next
		$iCount += 1
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'Polygon', 'handle', $hDC, 'struct*', $tData, 'int', $iCount - 1)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_Polygon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PtInRectEx($iX, $iY, $iLeft, $iTop, $iRight, $iBottom)
	Local $tRECT = _WinAPI_CreateRect($iLeft, $iTop, $iRight, $iBottom)
	Local $tPOINT = _WinAPI_CreatePoint($iX, $iY)
	Local $aRet = DllCall('user32.dll', 'bool', 'PtInRect', 'struct*', $tRECT, 'struct', $tPOINT)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PtInRectEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PtInRegion($hRgn, $iX, $iY)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'PtInRegion', 'handle', $hRgn, 'int', $iX, 'int', $iY)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PtInRegion

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PtVisible($hDC, $iX, $iY)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'PtVisible', 'handle', $hDC, 'int', $iX, 'int', $iY)
	If @error Then Return SetError(@error + 10, @extended, 0)
	If $aRet[0] = -1 Then Return SetError(10, $aRet[0], 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PtVisible

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RadialGradientFill($hDC, $iX, $iY, $iRadius, $iRGB1, $iRGB2, $fAngleStart = 0, $fAngleEnd = 360, $fStep = 5)
	If Abs($fAngleStart) > 360 Then
		$fAngleStart = Mod($fAngleStart, 360)
	EndIf
	If Abs($fAngleEnd) > 360 Then
		$fAngleEnd = Mod($fAngleEnd, 360)
	EndIf
	If ($fAngleStart < 0) Or ($fAngleEnd < 0) Then
		$fAngleStart += 360
		$fAngleEnd += 360
	EndIf
	If $fAngleStart > $fAngleEnd Then
		Local $fVal = $fAngleStart
		$fAngleStart = $fAngleEnd
		$fAngleEnd = $fVal
	EndIf
	If $fStep < 1 Then
		$fStep = 1
	EndIf

	Local $fKi = ATan(1) / 45
	Local $iXp = Round($iX + $iRadius * Cos($fKi * $fAngleStart))
	Local $iYp = Round($iY + $iRadius * Sin($fKi * $fAngleStart))
	Local $iXn, $iYn, $fAn = $fAngleStart
	Local $aVertex[3][3]

	While $fAn < $fAngleEnd
		$fAn += $fStep
		If $fAn > $fAngleEnd Then
			$fAn = $fAngleEnd
		EndIf
		$iXn = Round($iX + $iRadius * Cos($fKi * $fAn))
		$iYn = Round($iY + $iRadius * Sin($fKi * $fAn))
		$aVertex[0][0] = $iX
		$aVertex[0][1] = $iY
		$aVertex[0][2] = $iRGB1
		$aVertex[1][0] = $iXp
		$aVertex[1][1] = $iYp
		$aVertex[1][2] = $iRGB2
		$aVertex[2][0] = $iXn
		$aVertex[2][1] = $iYn
		$aVertex[2][2] = $iRGB2
		If Not _WinAPI_GradientFill($hDC, $aVertex, 0, 2) Then
			Return SetError(@error, @extended, 0)
		EndIf
		$iXp = $iXn
		$iYp = $iYn
	WEnd

	Return 1
EndFunc   ;==>_WinAPI_RadialGradientFill

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_Rectangle($hDC, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'Rectangle', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), 'int', DllStructGetData($tRECT, 4))
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_Rectangle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RectInRegion($hRgn, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'RectInRegion', 'handle', $hRgn, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RectInRegion

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RectIsEmpty(ByRef $tRECT)
	Return (DllStructGetData($tRECT, "Left") = 0) And (DllStructGetData($tRECT, "Top") = 0) And _
			(DllStructGetData($tRECT, "Right") = 0) And (DllStructGetData($tRECT, "Bottom") = 0)
EndFunc   ;==>_WinAPI_RectIsEmpty

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RectVisible($hDC, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'RectVisible', 'handle', $hDC, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	Switch $aRet[0]
		Case 0, 1, 2

		Case Else
			Return SetError(10, $aRet[0], 0)
	EndSwitch

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RectVisible

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RemoveFontMemResourceEx($hFont)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'RemoveFontMemResourceEx', 'handle', $hFont)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RemoveFontMemResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RemoveFontResourceEx($sFont, $iFlag = 0, $bNotify = False)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'RemoveFontResourceExW', 'wstr', $sFont, 'dword', $iFlag, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	If $bNotify Then
		Local Const $WM_FONTCHANGE = 0x001D
		Local Const $HWND_BROADCAST = 0xFFFF
		DllCall('user32.dll', 'none', 'SendMessage', 'hwnd', $HWND_BROADCAST, 'uint', $WM_FONTCHANGE, 'wparam', 0, 'lparam', 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>_WinAPI_RemoveFontResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RGB($iRed, $iGreen, $iBlue)
	Return __RGB(BitOR(BitShift($iBlue, -16), BitShift($iGreen, -8), $iRed))
EndFunc   ;==>_WinAPI_RGB

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RotatePoints(ByRef $aPoint, $iXC, $iYC, $fAngle, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aPoint, $iStart, $iEnd, 2) Then Return SetError(@error + 10, @extended, 0)
	If UBound($aPoint, $UBOUND_COLUMNS) < 2 Then Return SetError(13, 0, 0)

	Local $fCos = Cos(ATan(1) / 45 * $fAngle)
	Local $fSin = Sin(ATan(1) / 45 * $fAngle)
	Local $iXn, $iYn

	For $i = $iStart To $iEnd
		$iXn = $aPoint[$i][0] - $iXC
		$iYn = $aPoint[$i][1] - $iYC
		$aPoint[$i][0] = $iXC + Round($iXn * $fCos - $iYn * $fSin)
		$aPoint[$i][1] = $iYC + Round($iXn * $fSin + $iYn * $fCos)
	Next
	Return 1
EndFunc   ;==>_WinAPI_RotatePoints

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RoundRect($hDC, $tRECT, $iWidth, $iHeight)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'RoundRect', 'handle', $hDC, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), _
			'int', DllStructGetData($tRECT, 4), 'int', $iWidth, 'int', $iHeight)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RoundRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SaveHBITMAPToFile($sFilePath, $hBitmap, $iXPelsPerMeter = Default, $iYPelsPerMeter = Default)
	Local $tBMP = DllStructCreate('align 1;ushort bfType;dword bfSize;ushort bfReserved1;ushort bfReserved2;dword bfOffset')
	Local $tDIB = DllStructCreate($tagDIBSECTION)

	Local $hDC, $hSv, $hSource = 0
	While $hBitmap
		If (Not _WinAPI_GetObject($hBitmap, DllStructGetSize($tDIB), $tDIB)) Or (DllStructGetData($tDIB, 'biCompression')) Then
			$hBitmap = 0
		Else
			Switch DllStructGetData($tDIB, 'bmBitsPixel')
				Case 32
					If Not _WinAPI_IsAlphaBitmap($hBitmap) Then
						If Not $hSource Then
							$hSource = _WinAPI_CreateDIB(DllStructGetData($tDIB, 'bmWidth'), DllStructGetData($tDIB, 'bmHeight'), 24)
							If Not $hSource Then
								$hBitmap = 0
							EndIf
							$hDC = _WinAPI_CreateCompatibleDC(0)
							$hSv = _WinAPI_SelectObject($hDC, $hSource)
							If _WinAPI_DrawBitmap($hDC, 0, 0, $hBitmap) Then
								$hBitmap = $hSource
							Else
								$hBitmap = 0
							EndIf
							_WinAPI_SelectObject($hDC, $hSv)
							_WinAPI_DeleteDC($hDC)
						Else
							$hBitmap = 0
						EndIf
						ContinueLoop
					EndIf
				Case Else

			EndSwitch
			If (Not DllStructGetData($tDIB, 'bmBits')) Or (Not DllStructGetData($tDIB, 'biSizeImage')) Then
				If Not $hSource Then
					$hBitmap = _WinAPI_CopyBitmap($hBitmap)
					$hSource = $hBitmap
				Else
					$hBitmap = 0
				EndIf
			Else
				ExitLoop
			EndIf
		EndIf
	WEnd

	Local $hFile = 0, $iError = 0, $iResult = 0
	Do
		If Not $hBitmap Then
			$iError = 1
			ExitLoop
		EndIf
		Local $aData[4][2]
		$aData[0][0] = DllStructGetPtr($tBMP)
		$aData[0][1] = DllStructGetSize($tBMP)
		$aData[1][0] = DllStructGetPtr($tDIB, 'biSize')
		$aData[1][1] = 40
		$aData[2][1] = DllStructGetData($tDIB, 'biClrUsed') * 4
		Local $tTable = 0
		If $aData[2][1] Then
			$tTable = _WinAPI_GetDIBColorTable($hBitmap)
			If @error Or (@extended <> $aData[2][1] / 4) Then
				$iError = @error + 10
				ExitLoop
			EndIf
		EndIf
		$aData[2][0] = DllStructGetPtr($tTable)
		$aData[3][0] = DllStructGetData($tDIB, 'bmBits')
		$aData[3][1] = DllStructGetData($tDIB, 'biSizeImage')
		DllStructSetData($tBMP, 'bfType', 0x4D42)
		DllStructSetData($tBMP, 'bfSize', $aData[0][1] + $aData[1][1] + $aData[2][1] + $aData[3][1])
		DllStructSetData($tBMP, 'bfReserved1', 0)
		DllStructSetData($tBMP, 'bfReserved2', 0)
		DllStructSetData($tBMP, 'bfOffset', $aData[0][1] + $aData[1][1] + $aData[2][1])
		$hDC = _WinAPI_GetDC(0)
		If $iXPelsPerMeter = Default Then
			If Not DllStructGetData($tDIB, 'biXPelsPerMeter') Then
				DllStructSetData($tDIB, 'biXPelsPerMeter', _WinAPI_GetDeviceCaps($hDC, 8) / _WinAPI_GetDeviceCaps($hDC, 4) * 1000)
			EndIf
		Else
			DllStructSetData($tDIB, 'biXPelsPerMeter', $iXPelsPerMeter)
		EndIf
		If $iYPelsPerMeter = Default Then
			If Not DllStructGetData($tDIB, 'biYPelsPerMeter') Then
				DllStructSetData($tDIB, 'biYPelsPerMeter', _WinAPI_GetDeviceCaps($hDC, 10) / _WinAPI_GetDeviceCaps($hDC, 6) * 1000)
			EndIf
		Else
			DllStructSetData($tDIB, 'biYPelsPerMeter', $iYPelsPerMeter)
		EndIf
		_WinAPI_ReleaseDC(0, $hDC)
		$hFile = _WinAPI_CreateFile($sFilePath, 1, 4)
		If @error Then
			$iError = @error + 20
			ExitLoop
		EndIf
		Local $iBytes
		For $i = 0 To 3
			If $aData[$i][1] Then
				If Not _WinAPI_WriteFile($hFile, $aData[$i][0], $aData[$i][1], $iBytes) Then
					$iError = @error + 30
					ExitLoop 2
				EndIf
			EndIf
		Next
		$iResult = 1
	Until 1
	If $hSource Then
		_WinAPI_DeleteObject($hSource)
	EndIf
	_WinAPI_CloseHandle($hFile)
	If Not $iResult Then
		FileDelete($sFilePath)
	EndIf

	Return SetError($iError, 0, $iResult)
EndFunc   ;==>_WinAPI_SaveHBITMAPToFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm, mLipok
; ===============================================================================================================================
Func _WinAPI_SaveHICONToFile($sFilePath, Const ByRef $vIcon, $bCompress = 0, $iStart = 0, $iEnd = -1)
	Local $aIcon, $aTemp, $iCount = 1
	If Not IsArray($vIcon) Then
		Dim $aIcon[1] = [$vIcon]
		Dim $aTemp[1] = [0]
	Else
		If __CheckErrorArrayBounds($vIcon, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

		$iCount = $iEnd - $iStart + 1
		If $iCount Then
			Dim $aIcon[$iCount]
			Dim $aTemp[$iCount]
			For $i = 0 To $iCount - 1
				$aIcon[$i] = $vIcon[$iStart + $i]
				$aTemp[$i] = 0
			Next
		EndIf
	EndIf

	Local $hFile = _WinAPI_CreateFile($sFilePath, 1, 4)
	If @error Then Return SetError(@error + 20, @extended, 0)

	Local $tIco = DllStructCreate('align 1;ushort Reserved;ushort Type;ushort Count;byte Data[' & (16 * $iCount) & ']')
	Local $iLength = DllStructGetSize($tIco)
	Local $tBI = DllStructCreate($tagBITMAPINFOHEADER)
	Local $tII = DllStructCreate($tagICONINFO)
	Local $tDIB = DllStructCreate($tagDIBSECTION)
	Local $iDIB = DllStructGetSize($tDIB)
	Local $pDIB = DllStructGetPtr($tDIB)
	Local $iOffset = $iLength

	DllStructSetData($tBI, 'biSize', 40)
	DllStructSetData($tBI, 'biPlanes', 1)
	DllStructSetData($tBI, 'biXPelsPerMeter', 0)
	DllStructSetData($tBI, 'biYPelsPerMeter', 0)
	DllStructSetData($tBI, 'biClrUsed', 0)
	DllStructSetData($tBI, 'biClrImportant', 0)

	DllStructSetData($tIco, 'Reserved', 0)
	DllStructSetData($tIco, 'Type', 1)
	DllStructSetData($tIco, 'Count', $iCount)

	Local $iResult = 0, $iError = 0, $iBytes
	Local $aInfo[8], $aRet, $pData = 0, $iIndex = 0
	Local $aSize[2], $tData = 0
	Do
		If Not _WinAPI_WriteFile($hFile, $tIco, $iLength, $iBytes) Then
			$iError = @error + 30
			ExitLoop
		EndIf
		While $iCount > $iIndex
			$aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $aIcon[$iIndex], 'struct*', $tII)
			If @error Or Not $aRet[0] Then
				$iError = @error + 40
				ExitLoop 2
			EndIf
			For $i = 4 To 5
				$aInfo[$i] = _WinAPI_CopyImage(DllStructGetData($tII, $i), 0, 0, 0, 0x2008)
				If _WinAPI_GetObject($aInfo[$i], $iDIB, $pDIB) Then
					$aInfo[$i - 4] = DllStructGetData($tDIB, 'biSizeImage')
					$aInfo[$i - 2] = DllStructGetData($tDIB, 'bmBits')
				Else
					$iError = @error + 50
				EndIf
			Next
			$aInfo[6] = 40
			$aInfo[7] = DllStructGetData($tDIB, 'bmBitsPixel')
			Switch $aInfo[7]
				Case 16, 24

				Case 32
					If Not _WinAPI_IsAlphaBitmap($aInfo[5]) Then
						If Not $aTemp[$iIndex] Then
							$aIcon[$iIndex] = _WinAPI_Create32BitHICON($aIcon[$iIndex])
							$aTemp[$iIndex] = $aIcon[$iIndex]
							If Not @error Then
								ContinueLoop
							Else
								ContinueCase
							EndIf
						EndIf
					Else
						If ($aInfo[1] >= 256 * 256 * 4) And ($bCompress) Then
							$iBytes = _WinAPI_CompressBitmapBits($aInfo[5], $pData)
							If Not @error Then
								$aInfo[0] = 0
								$aInfo[1] = $iBytes
								$aInfo[2] = 0
								$aInfo[3] = $pData
								$aInfo[6] = 0
							EndIf
						EndIf
					EndIf
				Case Else
					$iError = 60
			EndSwitch
			If Not $iError Then
				$tData = DllStructCreate('byte Width;byte Height;byte ColorCount;byte Reserved;ushort Planes;ushort BitCount;long Size;long Offset', DllStructGetPtr($tIco) + 6 + 16 * $iIndex)
				DllStructSetData($tData, 'ColorCount', 0)
				DllStructSetData($tData, 'Reserved', 0)
				DllStructSetData($tData, 'Planes', 1)
				DllStructSetData($tData, 'BitCount', $aInfo[7])
				DllStructSetData($tData, 'Size', $aInfo[0] + $aInfo[1] + $aInfo[6])
				DllStructSetData($tData, 'Offset', $iOffset)
				For $i = 0 To 1
					$aSize[$i] = DllStructGetData($tDIB, $i + 2)
					If $aSize[$i] < 256 Then
						DllStructSetData($tData, $i + 1, $aSize[$i])
					Else
						DllStructSetData($tData, $i + 1, 0)
					EndIf
				Next
				DllStructSetData($tBI, 'biWidth', $aSize[0])
				DllStructSetData($tBI, 'biHeight', 2 * $aSize[1])
				DllStructSetData($tBI, 'biBitCount', $aInfo[7])
				DllStructSetData($tBI, 'biCompression', 0)
				DllStructSetData($tBI, 'biSizeImage', $aInfo[0] + $aInfo[1])
				$iOffset += $aInfo[0] + $aInfo[1] + $aInfo[6]
				Do
					If $aInfo[6] Then
						If Not _WinAPI_WriteFile($hFile, $tBI, $aInfo[6], $iBytes) Then
							$iError = @error + 70
							ExitLoop
						EndIf
						For $i = 1 To 0 Step -1
							If Not _WinAPI_WriteFile($hFile, $aInfo[$i + 2], $aInfo[$i], $iBytes) Then
								$iError = @error + 80
								ExitLoop 2
							EndIf
						Next
					Else
						If Not _WinAPI_WriteFile($hFile, $aInfo[3], $aInfo[1], $iBytes) Then
							$iError = @error + 90
							ExitLoop
						EndIf
					EndIf
				Until 1
			EndIf
			For $i = 4 To 5
				_WinAPI_DeleteObject($aInfo[$i])
			Next
			If $iError Then
				ExitLoop 2
			EndIf
			$iIndex += 1
		WEnd
		$aRet = DllCall('kernel32.dll', 'bool', 'SetFilePointerEx', 'handle', $hFile, 'int64', 0, 'int64*', 0, 'dword', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 100
			ExitLoop
		EndIf
		If Not _WinAPI_WriteFile($hFile, $tIco, $iLength, $iBytes) Then
			$iError = @error + 110
			ExitLoop
		EndIf
		$iResult = 1
	Until 1
	For $i = 0 To $iCount - 1
		If $aTemp[$i] Then
			_WinAPI_DestroyIcon($aTemp[$i])
		EndIf
	Next
	If $pData Then
		__HeapFree($pData)
	EndIf
	_WinAPI_CloseHandle($hFile)
	If Not $iResult Then
		FileDelete($sFilePath)
	EndIf

	Return SetError($iError, 0, $iResult)
EndFunc   ;==>_WinAPI_SaveHICONToFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ScaleWindowExt($hDC, $iXNum, $iXDenom, $iYNum, $iYDenom)
	$__g_vExt = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'ScaleWindowExtEx', 'handle', $hDC, 'int', $iXNum, 'int', $iXDenom, 'int', $iYNum, _
			'int', $iYDenom, 'struct*', $__g_vExt)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ScaleWindowExt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SelectClipPath($hDC, $iMode = 5)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SelectClipPath', 'handle', $hDC, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SelectClipPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SelectClipRgn($hDC, $hRgn)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SelectClipRgn', 'handle', $hDC, 'handle', $hRgn)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SelectClipRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetArcDirection($hDC, $iDirection)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetArcDirection', 'handle', $hDC, 'int', $iDirection)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetArcDirection

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetBitmapBits($hBitmap, $iSize, $pBits)
	Local $aRet = DllCall('gdi32.dll', 'long', 'SetBitmapBits', 'handle', $hBitmap, 'dword', $iSize, 'struct*', $pBits)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetBitmapBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetBitmapDimensionEx($hBitmap, $iWidth, $iHeight)
	$__g_vExt = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetBitmapDimensionEx', 'handle', $hBitmap, 'int', $iWidth, 'int', $iHeight, _
			'struct*', $__g_vExt)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetBitmapDimensionEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetBoundsRect($hDC, $iFlags, $tRECT = 0)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'SetBoundsRect', 'handle', $hDC, 'struct*', $tRECT, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetBoundsRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetBrushOrg($hDC, $iX, $iY)
	$__g_vExt = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetBrushOrgEx', 'handle', $hDC, 'int', $iX, 'int', $iY, 'struct*', $__g_vExt)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetBrushOrg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetColorAdjustment($hDC, $tAdjustment)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetColorAdjustment', 'handle', $hDC, 'struct*', $tAdjustment)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetColorAdjustment

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetDCBrushColor($hDC, $iRGB)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'SetDCBrushColor', 'handle', $hDC, 'dword', __RGB($iRGB))
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 4294967295 Then Return SetError(1000, 0, -1)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_SetDCBrushColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetDCPenColor($hDC, $iRGB)
	Local $aRet = DllCall('gdi32.dll', 'dword', 'SetDCPenColor', 'handle', $hDC, 'dword', __RGB($iRGB))
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 4294967295 Then Return SetError(1000, 0, -1)

	Return __RGB($aRet[0])
EndFunc   ;==>_WinAPI_SetDCPenColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetDeviceGammaRamp($hDC, Const ByRef $aRamp)
	If (UBound($aRamp, $UBOUND_DIMENSIONS) <> 2) Or (UBound($aRamp, $UBOUND_ROWS) <> 256) Or (UBound($aRamp, $UBOUND_COLUMNS) <> 3) Then
		Return SetError(12, 0, 0)
	EndIf

	Local $tData = DllStructCreate('ushort[256];ushort[256];ushort[256]')
	For $i = 0 To 2
		For $j = 0 To 255
			DllStructSetData($tData, $i + 1, $aRamp[$j][$i], $j + 1)
		Next
	Next

	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetDeviceGammaRamp', 'handle', $hDC, 'struct*', $tData)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetDeviceGammaRamp

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetDIBColorTable($hBitmap, $tColorTable, $iColorCount)
	If $iColorCount > DllStructGetSize($tColorTable) / 4 Then Return SetError(1, 0, 0)

	Local $hDC = _WinAPI_CreateCompatibleDC(0)
	Local $hSv = _WinAPI_SelectObject($hDC, $hBitmap)
	Local $iError = 0
	Local $aRet = DllCall('gdi32.dll', 'uint', 'SetDIBColorTable', 'handle', $hDC, 'uint', 0, 'uint', $iColorCount, 'struct*', $tColorTable)
	If @error Then $iError = @error
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)
	_WinAPI_SelectObject($hDC, $hSv)
	_WinAPI_DeleteDC($hDC)
	If $iError Then Return SetError($iError, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetDIBColorTable

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetDIBits($hDC, $hBitmap, $iStartScan, $iScanLines, $pBits, $tBMI, $iColorUse = 0)
	Local $aResult = DllCall("gdi32.dll", "int", "SetDIBits", "handle", $hDC, "handle", $hBitmap, "uint", $iStartScan, _
			"uint", $iScanLines, "struct*", $pBits, "struct*", $tBMI, "INT", $iColorUse)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetDIBits

; #FUNCTION# ====================================================================================================================
; Author.........: Luke
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_SetDIBitsToDevice($hDC, $iXDest, $iYDest, $iWidth, $iHeight, $iXSrc, $iYSrc, $iStartScan, $iScanLines, $tBITMAPINFO, $iUsage, $pBits)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetDIBitsToDevice', 'handle', $hDC, 'int', $iXDest, 'int', $iYDest, _
			'dword', $iWidth, 'dword', $iHeight, 'int', $iXSrc, 'int', $iYSrc, 'uint', $iStartScan, _
			'uint', $iScanLines, 'struct*', $pBits, 'struct*', $tBITMAPINFO, 'uint', $iUsage)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error + 10, $aRet[0], 0) ; GDI_ERROR

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetDIBitsToDevice

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetEnhMetaFileBits($pData, $iLength)
	Local $aRet = DllCall('gdi32.dll', 'handle', 'SetEnhMetaFileBits', 'uint', $iLength, 'struct*', $pData)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetEnhMetaFileBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetGraphicsMode($hDC, $iMode)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetGraphicsMode', 'handle', $hDC, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetGraphicsMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetMapMode($hDC, $iMode)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetMapMode', 'handle', $hDC, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetMapMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetPixel($hDC, $iX, $iY, $iRGB)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetPixelV', 'handle', $hDC, 'int', $iX, 'int', $iY, 'dword', __RGB($iRGB))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetPixel

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetPolyFillMode($hDC, $iMode = 1)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetPolyFillMode', 'handle', $hDC, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetPolyFillMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetRectRgn($hRgn, $tRECT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetRectRgn', 'handle', $hRgn, 'int', DllStructGetData($tRECT, 1), _
			'int', DllStructGetData($tRECT, 2), 'int', DllStructGetData($tRECT, 3), 'int', DllStructGetData($tRECT, 4))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetRectRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetROP2($hDC, $iMode)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetROP2', 'handle', $hDC, 'int', $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetROP2

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_SetStretchBltMode($hDC, $iMode)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetStretchBltMode', 'handle', $hDC, 'int', $iMode)
	If @error Or Not $aRet[0] Or ($aRet[0] = 87) Then Return SetError(@error + 10, $aRet[0], 0) ; ERROR_INVALID_PARAMETER

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetStretchBltMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetTextAlign($hDC, $iMode = 0)
	Local $aRet = DllCall('gdi32.dll', 'uint', 'SetTextAlign', 'handle', $hDC, 'uint', $iMode)
	If @error Or ($aRet[0] = 4294967295) Then Return SetError(@error, @extended, -1) ; GDI_ERROR
	; If $aRet[0] = 4294967295 Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetTextAlign

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetTextCharacterExtra($hDC, $iCharExtra)
	Local $aRet = DllCall('gdi32.dll', 'int', 'SetTextCharacterExtra', 'handle', $hDC, 'int', $iCharExtra)
	If @error Or ($aRet[0] = 0x80000000) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = 0x80000000 Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetTextCharacterExtra

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetTextJustification($hDC, $iBreakExtra, $iBreakCount)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetTextJustification', 'handle', $hDC, 'int', $iBreakExtra, 'int', $iBreakCount)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetTextJustification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetUDFColorMode($iMode)
	$__g_iRGBMode = Not ($iMode = 0)
EndFunc   ;==>_WinAPI_SetUDFColorMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowExt($hDC, $iXExtent, $iYExtent)
	$__g_vExt = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetWindowExtEx', 'handle', $hDC, 'int', $iXExtent, 'int', $iYExtent, _
			'struct*', $__g_vExt)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWindowExt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowOrg($hDC, $iX, $iY)
	$__g_vExt = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetWindowOrgEx', 'handle', $hDC, 'int', $iX, 'int', $iY, 'struct*', $__g_vExt)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWindowOrg

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetWorldTransform($hDC, ByRef $tXFORM)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'SetWorldTransform', 'handle', $hDC, 'struct*', $tXFORM)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWorldTransform

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StretchBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iRop)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'StretchBlt', 'handle', $hDestDC, 'int', $iXDest, 'int', $iYDest, 'int', $iWidthDest, _
			'int', $iHeightDest, 'hwnd', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, _
			'int', $iWidthSrc, 'int', $iHeightSrc, 'dword', $iRop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_StretchBlt

; #FUNCTION# ====================================================================================================================
; Author.........: Jscript
; Modified.......: Yashied, JPM
; ===============================================================================================================================
Func _WinAPI_StretchDIBits($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $tBITMAPINFO, $iUsage, $pBits, $iRop)
	Local $aRet = DllCall('gdi32.dll', 'int', 'StretchDIBits', 'handle', $hDestDC, 'int', $iXDest, 'int', $iYDest, _
			'int', $iWidthDest, 'int', $iHeightDest, 'int', $iXSrc, 'int', $iYSrc, _
			'int', $iWidthSrc, 'int', $iHeightSrc, 'struct*', $pBits, 'struct*', $tBITMAPINFO, 'uint', $iUsage, _
			'dword', $iRop)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error + 10, $aRet[0], 0) ; GDI_ERROR

	Return $aRet[0]
EndFunc   ;==>_WinAPI_StretchDIBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrokeAndFillPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'StrokeAndFillPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_StrokeAndFillPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrokePath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'StrokePath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_StrokePath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SubtractRect(ByRef $tRECT1, ByRef $tRECT2)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'SubtractRect', 'struct*', $tRECT, 'struct*', $tRECT1, 'struct*', $tRECT2)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_SubtractRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TabbedTextOut($hDC, $iX, $iY, $sText, $aTab = 0, $iStart = 0, $iEnd = -1, $iOrigin = 0)
	Local $iTab, $iCount
	If Not IsArray($aTab) Then
		If $aTab Then
			$iTab = $aTab
			Dim $aTab[1] = [$iTab]
			$iStart = 0
			$iEnd = 0
			$iCount = 1
		Else
			$iCount = 0
		EndIf
	Else
		$iCount = 1
	EndIf

	Local $tTab = 0
	If $iCount Then
		If __CheckErrorArrayBounds($aTab, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

		$iCount = $iEnd - $iStart + 1
		$tTab = DllStructCreate('uint[' & $iCount & ']')
		$iTab = 1
		For $i = $iStart To $iEnd
			DllStructSetData($tTab, 1, $aTab[$i], $iTab)
			$iTab += 1
		Next
	EndIf
	Local $aRet = DllCall('user32.dll', 'long', 'TabbedTextOutW', 'handle', $hDC, 'int', $iX, 'int', $iY, 'wstr', $sText, _
			'int', StringLen($sText), 'int', $iCount, 'struct*', $tTab, 'int', $iOrigin)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)

	$__g_vExt = _WinAPI_CreateSize(_WinAPI_LoWord($aRet[0]), _WinAPI_HiWord($aRet[0]))
	Return 1
EndFunc   ;==>_WinAPI_TabbedTextOut

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TextOut($hDC, $iX, $iY, $sText)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'TextOutW', 'handle', $hDC, 'int', $iX, 'int', $iY, 'wstr', $sText, _
			'int', StringLen($sText))
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TextOut

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TransparentBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iRGB)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GdiTransparentBlt', 'handle', $hDestDC, 'int', $iXDest, 'int', $iYDest, _
			'int', $iWidthDest, 'int', $iHeightDest, 'hwnd', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, _
			'int', $iWidthSrc, 'int', $iHeightSrc, 'dword', __RGB($iRGB))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TransparentBlt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UnionRect(ByRef $tRECT1, ByRef $tRECT2)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnionRect', 'struct*', $tRECT, 'struct*', $tRECT1, 'struct*', $tRECT2)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, 0, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_UnionRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ValidateRect($hWnd, $tRECT = 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'ValidateRect', 'hwnd', $hWnd, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ValidateRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ValidateRgn($hWnd, $hRgn = 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'ValidateRgn', 'hwnd', $hWnd, 'handle', $hRgn)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ValidateRgn

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_WidenPath($hDC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'WidenPath', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_WidenPath

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WindowFromDC($hDC)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'WindowFromDC', 'handle', $hDC)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_WindowFromDC
#EndRegion Public Functions

#Region Internal Functions

Func __EnumDisplayMonitorsProc($hMonitor, $hDC, $pRECT, $lParam)
	#forceref $hDC, $lParam

	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0][0]][0] = $hMonitor
	If Not $pRECT Then
		$__g_vEnum[$__g_vEnum[0][0]][1] = 0
	Else
		$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructCreate($tagRECT)
		If Not _WinAPI_MoveMemory(DllStructGetPtr($__g_vEnum[$__g_vEnum[0][0]][1]), $pRECT, 16) Then Return 0
	EndIf
	Return 1
EndFunc   ;==>__EnumDisplayMonitorsProc

Func __EnumFontFamiliesProc($pELFEX, $pNTMEX, $iFontType, $pPattern)
	; Local $tELFEX = DllStructCreate('long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;wchar[32];wchar[64];wchar[32];wchar[32]', $pELFEX)
	Local $tELFEX = DllStructCreate($tagLOGFONT & ';wchar FullName[64];wchar Style[32];wchar Script[32]', $pELFEX)
	; Local $tNTMEX = DllStructCreate('long;long;long;long;long;long;long;long;long;long;long;wchar;wchar;wchar;wchar;byte;byte;byte;byte;byte;dword;uint;uint;uint;dword[4];dword[2]', $pNTMEX)
	Local $tNTMEX = DllStructCreate($tagNEWTEXTMETRICEX, $pNTMEX)
	Local $tPattern = DllStructCreate('uint;uint;ptr', $pPattern)

	If $iFontType And Not BitAND($iFontType, DllStructGetData($tPattern, 1)) Then
		Return 1
	EndIf
	If DllStructGetData($tPattern, 3) Then
		Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathMatchSpecW', 'ptr', DllStructGetPtr($tELFEX, 14), 'ptr', DllStructGetData($tPattern, 3))
		If Not @error Then
			If DllStructGetData($tPattern, 2) Then
				If $aRet[0] Then
					Return 1
				Else

				EndIf
			Else
				If $aRet[0] Then

				Else
					Return 1
				EndIf
			EndIf
		EndIf
	EndIf
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tELFEX, 14)
	$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructGetData($tELFEX, 16)
	$__g_vEnum[$__g_vEnum[0][0]][2] = DllStructGetData($tELFEX, 15)
	$__g_vEnum[$__g_vEnum[0][0]][3] = DllStructGetData($tELFEX, 17)
	$__g_vEnum[$__g_vEnum[0][0]][4] = $iFontType
	$__g_vEnum[$__g_vEnum[0][0]][5] = DllStructGetData($tNTMEX, 19)
	$__g_vEnum[$__g_vEnum[0][0]][6] = DllStructGetData($tNTMEX, 20)
	$__g_vEnum[$__g_vEnum[0][0]][7] = DllStructGetData($tNTMEX, 21)
	Return 1
EndFunc   ;==>__EnumFontFamiliesProc

Func __EnumFontStylesProc($pELFEX, $pNTMEX, $iFontType, $pFN)
	#forceref $iFontType

	; Local $tELFEX = DllStructCreate('long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;wchar[32];wchar[64];wchar[32];wchar[32]', $pELFEX)
	Local $tELFEX = DllStructCreate($tagLOGFONT & ';wchar FullName[64];wchar Style[32];wchar Script[32]', $pELFEX)
	; Local $tNTMEX = DllStructCreate('long;long;long;long;long;long;long;long;long;long;long;wchar;wchar;wchar;wchar;byte;byte;byte;byte;byte;dword;uint;uint;uint;dword[4];dword[2]', $pNTMEX)
	Local $tNTMEX = DllStructCreate($tagNEWTEXTMETRICEX, $pNTMEX)
	Local $tFN = DllStructCreate('dword;wchar[64]', $pFN)

	If BitAND(DllStructGetData($tNTMEX, 'ntmFlags'), 0x0061) = DllStructGetData($tFN, 1) Then
		DllStructSetData($tFN, 2, DllStructGetData($tELFEX, 'FullName'))
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>__EnumFontStylesProc
#EndRegion Internal Functions
