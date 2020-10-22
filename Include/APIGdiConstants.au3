#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinAPIGdi Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; _WinAPI_AddFontResourceEx(), _WinAPI_RemoveFontResourceEx()
Global Const $FR_PRIVATE = 0x10
Global Const $FR_NOT_ENUM = 0x20

; _WinAPI_CompressBitmapBits()
Global Const $COMPRESSION_BITMAP_PNG = 0
Global Const $COMPRESSION_BITMAP_JPEG = 1

; _WinAPI_CopyImage()
;   in WinAPIConstants.au3

; _WinAPI_CreateBrushIndirect()
Global Const $BS_DIBPATTERN = 5
Global Const $BS_DIBPATTERN8X8 = 8
Global Const $BS_DIBPATTERNPT = 6
Global Const $BS_HATCHED = 2
Global Const $BS_HOLLOW = 1
Global Const $BS_NULL = 1
Global Const $BS_PATTERN = 3
Global Const $BS_PATTERN8X8 = 7
Global Const $BS_SOLID = 0

Global Const $HS_BDIAGONAL = 3
Global Const $HS_CROSS = 4
Global Const $HS_DIAGCROSS = 5
Global Const $HS_FDIAGONAL = 2
Global Const $HS_HORIZONTAL = 0
Global Const $HS_VERTICAL = 1

Global Const $DIB_PAL_COLORS = 1
Global Const $DIB_RGB_COLORS = 0

; _WinAPI_CreateColorAdjustment()
Global Const $CA_NEGATIVE = 0x01
Global Const $CA_LOG_FILTER = 0x02

Global Const $ILLUMINANT_DEVICE_DEFAULT = 0
Global Const $ILLUMINANT_A = 1
Global Const $ILLUMINANT_B = 2
Global Const $ILLUMINANT_C = 3
Global Const $ILLUMINANT_D50 = 4
Global Const $ILLUMINANT_D55 = 5
Global Const $ILLUMINANT_D65 = 6
Global Const $ILLUMINANT_D75 = 7
Global Const $ILLUMINANT_F2 = 8
Global Const $ILLUMINANT_TUNGSTEN = $ILLUMINANT_A
Global Const $ILLUMINANT_DAYLIGHT = $ILLUMINANT_C
Global Const $ILLUMINANT_FLUORESCENT = $ILLUMINANT_F2
Global Const $ILLUMINANT_NTSC = $ILLUMINANT_C

; _WinAPI_CreateDIBSection()
Global Const $BI_RGB = 0
Global Const $BI_RLE8 = 1
Global Const $BI_RLE4 = 2
Global Const $BI_BITFIELDS = 3
Global Const $BI_JPEG = 4
Global Const $BI_PNG = 5

; _WinAPI_CreatePolygonRgn()
Global Const $ALTERNATE = 1
Global Const $WINDING = 2

; _WinAPI_DwmGetWindowAttribute(), _WinAPI_DwmSetWindowAttribute()
Global Const $DWMWA_NCRENDERING_ENABLED = 1
Global Const $DWMWA_NCRENDERING_POLICY = 2
Global Const $DWMWA_TRANSITIONS_FORCEDISABLED = 3
Global Const $DWMWA_ALLOW_NCPAINT = 4
Global Const $DWMWA_CAPTION_BUTTON_BOUNDS = 5
Global Const $DWMWA_NONCLIENT_RTL_LAYOUT = 6
Global Const $DWMWA_FORCE_ICONIC_REPRESENTATION = 7
Global Const $DWMWA_FLIP3D_POLICY = 8
Global Const $DWMWA_EXTENDED_FRAME_BOUNDS = 9
Global Const $DWMWA_HAS_ICONIC_BITMAP = 10
Global Const $DWMWA_DISALLOW_PEEK = 11
Global Const $DWMWA_EXCLUDED_FROM_PEEK = 12

Global Const $DWMNCRP_USEWINDOWSTYLE = 0
Global Const $DWMNCRP_DISABLED = 1
Global Const $DWMNCRP_ENABLED = 2

Global Const $DWMFLIP3D_DEFAULT = 0
Global Const $DWMFLIP3D_EXCLUDEBELOW = 1
Global Const $DWMFLIP3D_EXCLUDEABOVE = 2

; DEVMODE structure
Global Const $DM_BITSPERPEL = 0x00040000
Global Const $DM_COLLATE = 0x0008000
Global Const $DM_COLOR = 0x00000800
Global Const $DM_COPIES = 0x00000100
Global Const $DM_DEFAULTSOURCE = 0x00000200
Global Const $DM_DISPLAYFIXEDOUTPUT = 0x20000000
Global Const $DM_DISPLAYFLAGS = 0x00200000
Global Const $DM_DISPLAYFREQUENCY = 0x00400000
Global Const $DM_DISPLAYORIENTATION = 0x00000080
Global Const $DM_DITHERTYPE = 0x04000000
Global Const $DM_DUPLEX = 0x0001000
Global Const $DM_FORMNAME = 0x00010000
Global Const $DM_ICMINTENT = 0x01000000
Global Const $DM_ICMMETHOD = 0x00800000
Global Const $DM_LOGPIXELS = 0x00020000
Global Const $DM_MEDIATYPE = 0x02000000
Global Const $DM_NUP = 0x00000040
Global Const $DM_ORIENTATION = 0x00000001
Global Const $DM_PANNINGHEIGHT = 0x10000000
Global Const $DM_PANNINGWIDTH = 0x08000000
Global Const $DM_PAPERLENGTH = 0x00000004
Global Const $DM_PAPERSIZE = 0x00000002
Global Const $DM_PAPERWIDTH = 0x00000008
Global Const $DM_PELSHEIGHT = 0x00100000
Global Const $DM_PELSWIDTH = 0x00080000
Global Const $DM_POSITION = 0x00000020
Global Const $DM_PRINTQUALITY = 0x00000400
Global Const $DM_SCALE = 0x00000010
Global Const $DM_TTOPTION = 0x0004000
Global Const $DM_YRESOLUTION = 0x0002000

Global Const $DMPAPER_LETTER = 1 ; US Letter 8 1/2 x 11 in
Global Const $DMPAPER_LETTERSMALL = 2 ; US Letter Small 8 1/2 x 11 in
Global Const $DMPAPER_TABLOID = 3 ; US Tabloid 11 x 17 in
Global Const $DMPAPER_LEDGER = 4 ; US Ledger 17 x 11 in
Global Const $DMPAPER_LEGAL = 5 ; US Legal 8 1/2 x 14 in
Global Const $DMPAPER_STATEMENT = 6 ; US Statement 5 1/2 x 8 1/2 in
Global Const $DMPAPER_EXECUTIVE = 7 ; US Executive 7 1/4 x 10 1/2 in
Global Const $DMPAPER_A3 = 8 ; A3 297 x 420 mm
Global Const $DMPAPER_A4 = 9 ; A4 210 x 297 mm
Global Const $DMPAPER_A4SMALL = 10 ; A4 Small 210 x 297 mm
Global Const $DMPAPER_A5 = 11 ; A5 148 x 210 mm
Global Const $DMPAPER_B4 = 12 ; B4 (JIS) 257 x 364 mm
Global Const $DMPAPER_B5 = 13 ; B5 (JIS) 182 x 257 mm
Global Const $DMPAPER_FOLIO = 14 ; Folio 8 1/2 x 13 in
Global Const $DMPAPER_QUARTO = 15 ; Quarto 215 x 275 mm
Global Const $DMPAPER_10X14 = 16 ; 10 x 14 in
Global Const $DMPAPER_11X17 = 17 ; 11 x 17 in
Global Const $DMPAPER_NOTE = 18 ; US Note 8 1/2 x 11 in
Global Const $DMPAPER_ENV_9 = 19 ; US Envelope #9 3 7/8 x 8 7/8
Global Const $DMPAPER_ENV_10 = 20 ; US Envelope #10 4 1/8 x 9 1/2
Global Const $DMPAPER_ENV_11 = 21 ; US Envelope #11 4 1/2 x 10 3/8
Global Const $DMPAPER_ENV_12 = 22 ; US Envelope #12 4 3/4 x 11 in
Global Const $DMPAPER_ENV_14 = 23 ; US Envelope #14 5 x 11 1/2
Global Const $DMPAPER_CSHEET = 24 ; C size sheet
Global Const $DMPAPER_DSHEET = 25 ; D size sheet
Global Const $DMPAPER_ESHEET = 26 ; E size sheet
Global Const $DMPAPER_ENV_DL = 27 ; Envelope DL 110 x 220mm
Global Const $DMPAPER_ENV_C5 = 28 ; Envelope C5 162 x 229 mm
Global Const $DMPAPER_ENV_C3 = 29 ; Envelope C3 324 x 458 mm
Global Const $DMPAPER_ENV_C4 = 30 ; Envelope C4 229 x 324 mm
Global Const $DMPAPER_ENV_C6 = 31 ; Envelope C6 114 x 162 mm
Global Const $DMPAPER_ENV_C65 = 32 ; Envelope C65 114 x 229 mm
Global Const $DMPAPER_ENV_B4 = 33 ; Envelope B4 250 x 353 mm
Global Const $DMPAPER_ENV_B5 = 34 ; Envelope B5 176 x 250 mm
Global Const $DMPAPER_ENV_B6 = 35 ; Envelope B6 176 x 125 mm
Global Const $DMPAPER_ENV_ITALY = 36 ; Envelope 110 x 230 mm
Global Const $DMPAPER_ENV_MONARCH = 37 ; US Envelope Monarch 3.875 x 7.5 in
Global Const $DMPAPER_ENV_PERSONAL = 38 ; 6 3/4 US Envelope 3 5/8 x 6 1/2 in
Global Const $DMPAPER_FANFOLD_US = 39 ; US Std Fanfold 14 7/8 x 11 in
Global Const $DMPAPER_FANFOLD_STD_GERMAN = 40 ; German Std Fanfold 8 1/2 x 12 in
Global Const $DMPAPER_FANFOLD_LGL_GERMAN = 41 ; German Legal Fanfold 8 1/2 x 13 in
Global Const $DMPAPER_ISO_B4 = 42 ; B4 (ISO) 250 x 353 mm
Global Const $DMPAPER_JAPANESE_POSTCARD = 43 ; Japanese Postcard 100 x 148 mm
Global Const $DMPAPER_9X11 = 44 ; 9 x 11 in
Global Const $DMPAPER_10X11 = 45 ; 10 x 11 in
Global Const $DMPAPER_15X11 = 46 ; 15 x 11 in
Global Const $DMPAPER_ENV_INVITE = 47 ; Envelope Invite 220 x 220 mm
Global Const $DMPAPER_RESERVED_48 = 48 ; Reserved
Global Const $DMPAPER_RESERVED_49 = 49 ; Reserved
Global Const $DMPAPER_LETTER_EXTRA = 50 ; US Letter Extra 9 1/2 x 12 in
Global Const $DMPAPER_LEGAL_EXTRA = 51 ; US Legal Extra 9 1/2 x 15 in
Global Const $DMPAPER_TABLOID_EXTRA = 52 ; US Tabloid Extra 11.69 x 18 in
Global Const $DMPAPER_A4_EXTRA = 53 ; A4 Extra 9.27 x 12.69 in
Global Const $DMPAPER_LETTER_TRANSVERSE = 54 ; Letter Transverse 8 1/2 x 11 in
Global Const $DMPAPER_A4_TRANSVERSE = 55 ; A4 Transverse 210 x 297 mm
Global Const $DMPAPER_LETTER_EXTRA_TRANSVERSE = 56 ; Letter Extra Transverse 9 1/2 x 12 in
Global Const $DMPAPER_A_PLUS = 57 ; SuperA/SuperA/A4 227 x 356 mm
Global Const $DMPAPER_B_PLUS = 58 ; SuperB/SuperB/A3 305 x 487 mm
Global Const $DMPAPER_LETTER_PLUS = 59 ; US Letter Plus 8.5 x 12.69 in
Global Const $DMPAPER_A4_PLUS = 60 ; A4 Plus 210 x 330 mm
Global Const $DMPAPER_A5_TRANSVERSE = 61 ; A5 Transverse 148 x 210 mm
Global Const $DMPAPER_B5_TRANSVERSE = 62 ; B5 (JIS) Transverse 182 x 257 mm
Global Const $DMPAPER_A3_EXTRA = 63 ; A3 Extra 322 x 445 mm
Global Const $DMPAPER_A5_EXTRA = 64 ; A5 Extra 174 x 235 mm
Global Const $DMPAPER_B5_EXTRA = 65 ; B5 (ISO) Extra 201 x 276 mm
Global Const $DMPAPER_A2 = 66 ; A2 420 x 594 mm
Global Const $DMPAPER_A3_TRANSVERSE = 67 ; A3 Transverse 297 x 420 mm
Global Const $DMPAPER_A3_EXTRA_TRANSVERSE = 68 ; A3 Extra Transverse 322 x 445 mm
Global Const $DMPAPER_DBL_JAPANESE_POSTCARD = 69 ; Japanese Double Postcard 200 x 148 mm
Global Const $DMPAPER_A6 = 70 ; A6 105 x 148 mm
Global Const $DMPAPER_JENV_KAKU2 = 71 ; Japanese Envelope Kaku #2
Global Const $DMPAPER_JENV_KAKU3 = 72 ; Japanese Envelope Kaku #3
Global Const $DMPAPER_JENV_CHOU3 = 73 ; Japanese Envelope Chou #3
Global Const $DMPAPER_JENV_CHOU4 = 74 ; Japanese Envelope Chou #4
Global Const $DMPAPER_LETTER_ROTATED = 75 ; Letter Rotated 11 x 8 1/2 11 in
Global Const $DMPAPER_A3_ROTATED = 76 ; A3 Rotated 420 x 297 mm
Global Const $DMPAPER_A4_ROTATED = 77 ; A4 Rotated 297 x 210 mm
Global Const $DMPAPER_A5_ROTATED = 78 ; A5 Rotated 210 x 148 mm
Global Const $DMPAPER_B4_JIS_ROTATED = 79 ; B4 (JIS) Rotated 364 x 257 mm
Global Const $DMPAPER_B5_JIS_ROTATED = 80 ; B5 (JIS) Rotated 257 x 182 mm
Global Const $DMPAPER_JAPANESE_POSTCARD_ROTATED = 81 ; Japanese Postcard Rotated 148 x 100 mm
Global Const $DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED = 82 ; Double Japanese Postcard Rotated 148 x 200 mm
Global Const $DMPAPER_A6_ROTATED = 83 ; A6 Rotated 148 x 105 mm
Global Const $DMPAPER_JENV_KAKU2_ROTATED = 84 ; Japanese Envelope Kaku #2 Rotated
Global Const $DMPAPER_JENV_KAKU3_ROTATED = 85 ; Japanese Envelope Kaku #3 Rotated
Global Const $DMPAPER_JENV_CHOU3_ROTATED = 86 ; Japanese Envelope Chou #3 Rotated
Global Const $DMPAPER_JENV_CHOU4_ROTATED = 87 ; Japanese Envelope Chou #4 Rotated
Global Const $DMPAPER_B6_JIS = 88 ; B6 (JIS) 128 x 182 mm
Global Const $DMPAPER_B6_JIS_ROTATED = 89 ; B6 (JIS) Rotated 182 x 128 mm
Global Const $DMPAPER_12X11 = 90 ; 12 x 11 in
Global Const $DMPAPER_JENV_YOU4 = 91 ; Japanese Envelope You #4
Global Const $DMPAPER_JENV_YOU4_ROTATED = 92 ; Japanese Envelope You #4 Rotated
Global Const $DMPAPER_P16K = 93 ; PRC 16K 146 x 215 mm
Global Const $DMPAPER_P32K = 94 ; PRC 32K 97 x 151 mm
Global Const $DMPAPER_P32KBIG = 95 ; PRC 32K(Big) 97 x 151 mm
Global Const $DMPAPER_PENV_1 = 96 ; PRC Envelope #1 102 x 165 mm
Global Const $DMPAPER_PENV_2 = 97 ; PRC Envelope #2 102 x 176 mm
Global Const $DMPAPER_PENV_3 = 98 ; PRC Envelope #3 125 x 176 mm
Global Const $DMPAPER_PENV_4 = 99 ; PRC Envelope #4 110 x 208 mm
Global Const $DMPAPER_PENV_5 = 100 ; PRC Envelope #5 110 x 220 mm
Global Const $DMPAPER_PENV_6 = 101 ; PRC Envelope #6 120 x 230 mm
Global Const $DMPAPER_PENV_7 = 102 ; PRC Envelope #7 160 x 230 mm
Global Const $DMPAPER_PENV_8 = 103 ; PRC Envelope #8 120 x 309 mm
Global Const $DMPAPER_PENV_9 = 104 ; PRC Envelope #9 229 x 324 mm
Global Const $DMPAPER_PENV_10 = 105 ; PRC Envelope #10 324 x 458 mm
Global Const $DMPAPER_P16K_ROTATED = 106 ; PRC 16K Rotated
Global Const $DMPAPER_P32K_ROTATED = 107 ; PRC 32K Rotated
Global Const $DMPAPER_P32KBIG_ROTATED = 108 ; PRC 32K(Big) Rotated
Global Const $DMPAPER_PENV_1_ROTATED = 109 ; PRC Envelope #1 Rotated 165 x 102 mm
Global Const $DMPAPER_PENV_2_ROTATED = 110 ; PRC Envelope #2 Rotated 176 x 102 mm
Global Const $DMPAPER_PENV_3_ROTATED = 111 ; PRC Envelope #3 Rotated 176 x 125 mm
Global Const $DMPAPER_PENV_4_ROTATED = 112 ; PRC Envelope #4 Rotated 208 x 110 mm
Global Const $DMPAPER_PENV_5_ROTATED = 113 ; PRC Envelope #5 Rotated 220 x 110 mm
Global Const $DMPAPER_PENV_6_ROTATED = 114 ; PRC Envelope #6 Rotated 230 x 120 mm
Global Const $DMPAPER_PENV_7_ROTATED = 115 ; PRC Envelope #7 Rotated 230 x 160 mm
Global Const $DMPAPER_PENV_8_ROTATED = 116 ; PRC Envelope #8 Rotated 309 x 120 mm
Global Const $DMPAPER_PENV_9_ROTATED = 117 ; PRC Envelope #9 Rotated 324 x 229 mm
Global Const $DMPAPER_PENV_10_ROTATED = 118 ; PRC Envelope #10 Rotated 458 x 324 mm
Global Const $DMPAPER_USER = 256

Global Const $DMBIN_UPPER = 1
Global Const $DMBIN_LOWER = 2
Global Const $DMBIN_MIDDLE = 3
Global Const $DMBIN_MANUAL = 4
Global Const $DMBIN_ENVELOPE = 5
Global Const $DMBIN_ENVMANUAL = 6
Global Const $DMBIN_AUTO = 7
Global Const $DMBIN_TRACTOR = 8
Global Const $DMBIN_SMALLFMT = 9
Global Const $DMBIN_LARGEFMT = 10
Global Const $DMBIN_LARGECAPACITY = 11
Global Const $DMBIN_CASSETTE = 14
Global Const $DMBIN_FORMSOURCE = 15
Global Const $DMBIN_USER = 256

Global Const $DMRES_DRAFT = -1
Global Const $DMRES_LOW = -2
Global Const $DMRES_MEDIUM = -3
Global Const $DMRES_HIGH = -4

Global Const $DMDO_DEFAULT = 0
Global Const $DMDO_90 = 1
Global Const $DMDO_180 = 2
Global Const $DMDO_270 = 3

Global Const $DMDFO_DEFAULT = 0
Global Const $DMDFO_STRETCH = 1
Global Const $DMDFO_CENTER = 2

Global Const $DMCOLOR_MONOCHROME = 1
Global Const $DMCOLOR_COLOR = 2

Global Const $DMDUP_SIMPLEX = 1
Global Const $DMDUP_VERTICAL = 2
Global Const $DMDUP_HORIZONTAL = 3

Global Const $DMTT_BITMAP = 1
Global Const $DMTT_DOWNLOAD = 2
Global Const $DMTT_SUBDEV = 3
Global Const $DMTT_DOWNLOAD_OUTLINE = 4

Global Const $DMCOLLATE_FALSE = 0
Global Const $DMCOLLATE_TRUE = 1

Global Const $DM_GRAYSCALE = 1
Global Const $DM_INTERLACED = 2

Global Const $DMNUP_SYSTEM = 1
Global Const $DMNUP_ONEUP = 2

Global Const $DMICMMETHOD_NONE = 1
Global Const $DMICMMETHOD_SYSTEM = 2
Global Const $DMICMMETHOD_DRIVER = 3
Global Const $DMICMMETHOD_DEVICE = 4
Global Const $DMICMMETHOD_USER = 256

Global Const $DMICM_SATURATE = 1
Global Const $DMICM_CONTRAST = 2
Global Const $DMICM_COLORIMETRIC = 3
Global Const $DMICM_ABS_COLORIMETRIC = 4
Global Const $DMICM_USER = 256

Global Const $DMMEDIA_STANDARD = 1
Global Const $DMMEDIA_TRANSPARENCY = 2
Global Const $DMMEDIA_GLOSSY = 3
Global Const $DMMEDIA_USER = 256

Global Const $DMDITHER_NONE = 1
Global Const $DMDITHER_COARSE = 2
Global Const $DMDITHER_FINE = 3
Global Const $DMDITHER_LINEART = 4
Global Const $DMDITHER_ERRORDIFFUSION = 5
Global Const $DMDITHER_RESERVED6 = 6
Global Const $DMDITHER_RESERVED7 = 7
Global Const $DMDITHER_RESERVED8 = 8
Global Const $DMDITHER_RESERVED9 = 9
Global Const $DMDITHER_GRAYSCALE = 10
Global Const $DMDITHER_USER = 256

; _WinAPI_EnumDisplaySettings()
Global Const $ENUM_CURRENT_SETTINGS = -1
Global Const $ENUM_REGISTRY_SETTINGS = -2

; _WinAPI_EnumFontFamilies()
Global Const $DEVICE_FONTTYPE = 0x2
Global Const $RASTER_FONTTYPE = 0x1
Global Const $TRUETYPE_FONTTYPE = 0x4

Global Const $NTM_BOLD = 0x00000020
Global Const $NTM_DSIG = 0x00200000
Global Const $NTM_ITALIC = 0x00000001
Global Const $NTM_MULTIPLEMASTER = 0x00080000
Global Const $NTM_NONNEGATIVE_AC = 0x00010000
Global Const $NTM_PS_OPENTYPE = 0x00020000
Global Const $NTM_REGULAR = 0x00000040
Global Const $NTM_TT_OPENTYPE = 0x00040000
Global Const $NTM_TYPE1 = 0x00100000

; _WinAPI_ExtFloodFill()
Global Const $FLOODFILLBORDER = 0
Global Const $FLOODFILLSURFACE = 1

; _WinAPI_GetArcDirection(), _WinAPI_SetArcDirection()
Global Const $AD_COUNTERCLOCKWISE = 1
Global Const $AD_CLOCKWISE = 2

; _WinAPI_GetBoundsRect(), _WinAPI_SetBoundsRect()
Global Const $DCB_ACCUMULATE = 0x02
Global Const $DCB_DISABLE = 0x08
Global Const $DCB_ENABLE = 0x04
Global Const $DCB_RESET = 0x01
Global Const $DCB_SET = BitOR($DCB_RESET, $DCB_ACCUMULATE)

; _WinAPI_GetDCEx()
Global Const $DCX_WINDOW = 0x00000001
Global Const $DCX_CACHE = 0x00000002
Global Const $DCX_PARENTCLIP = 0x00000020
Global Const $DCX_CLIPSIBLINGS = 0x00000010
Global Const $DCX_CLIPCHILDREN = 0x00000008
Global Const $DCX_NORESETATTRS = 0x00000004
Global Const $DCX_LOCKWINDOWUPDATE = 0x00000400
Global Const $DCX_EXCLUDERGN = 0x00000040
Global Const $DCX_INTERSECTRGN = 0x00000080
Global Const $DCX_INTERSECTUPDATE = 0x00000200
Global Const $DCX_VALIDATE = 0x00200000

; _WinAPI_GetGlyphOutline()
Global Const $GGO_BEZIER = 3
Global Const $GGO_BITMAP = 1
Global Const $GGO_GLYPH_INDEX = 0x0080
Global Const $GGO_GRAY2_BITMAP = 4
Global Const $GGO_GRAY4_BITMAP = 5
Global Const $GGO_GRAY8_BITMAP = 6
Global Const $GGO_METRICS = 0
Global Const $GGO_NATIVE = 2
Global Const $GGO_UNHINTED = 0x0100

; _WinAPI_GetGraphicsMode(), _WinAPI_SetGraphicsMode()
Global Const $GM_COMPATIBLE = 1
Global Const $GM_ADVANCED = 2

; _WinAPI_GetMapMode(), _WinAPI_SetMapMode()
Global Const $MM_ANISOTROPIC = 8
Global Const $MM_HIENGLISH = 5
Global Const $MM_HIMETRIC = 3
Global Const $MM_ISOTROPIC = 7
Global Const $MM_LOENGLISH = 4
Global Const $MM_LOMETRIC = 2
Global Const $MM_TEXT = 1
Global Const $MM_TWIPS = 6

; _WinAPI_GetROP2(), _WinAPI_SetROP2()
Global Const $R2_BLACK = 1
Global Const $R2_COPYPEN = 13
Global Const $R2_LAST = 16
Global Const $R2_MASKNOTPEN = 3
Global Const $R2_MASKPEN = 9
Global Const $R2_MASKPENNOT = 5
Global Const $R2_MERGENOTPEN = 12
Global Const $R2_MERGEPEN = 15
Global Const $R2_MERGEPENNOT = 14
Global Const $R2_NOP = 11
Global Const $R2_NOT = 6
Global Const $R2_NOTCOPYPEN = 4
Global Const $R2_NOTMASKPEN = 8
Global Const $R2_NOTMERGEPEN = 2
Global Const $R2_NOTXORPEN = 10
Global Const $R2_WHITE = 16
Global Const $R2_XORPEN = 7

; _WinAPI_GetStretchBltMode(), _WinAPI_SetStretchBltMode()
Global Const $BLACKONWHITE = 1
Global Const $COLORONCOLOR = 3
Global Const $HALFTONE = 4
Global Const $WHITEONBLACK = 2
Global Const $STRETCH_ANDSCANS = $BLACKONWHITE
Global Const $STRETCH_DELETESCANS = $COLORONCOLOR
Global Const $STRETCH_HALFTONE = $HALFTONE
Global Const $STRETCH_ORSCANS = $WHITEONBLACK

; _WinAPI_GetTextAlign(), _WinAPI_SetTextAlign()
Global Const $TA_BASELINE = 0x0018
Global Const $TA_BOTTOM = 0x0008
Global Const $TA_TOP = 0x0000
Global Const $TA_CENTER = 0x0006
Global Const $TA_LEFT = 0x0000
Global Const $TA_RIGHT = 0x0002
Global Const $TA_NOUPDATECP = 0x0000
Global Const $TA_RTLREADING = 0x0100
Global Const $TA_UPDATECP = 0x0001

Global Const $VTA_BASELINE = $TA_BASELINE
Global Const $VTA_BOTTOM = $TA_RIGHT
Global Const $VTA_TOP = $TA_LEFT
Global Const $VTA_CENTER = $TA_CENTER
Global Const $VTA_LEFT = $TA_BOTTOM
Global Const $VTA_RIGHT = $TA_TOP

; _WinAPI_GetUDFColorMode(), _WinAPI_SetUDFColorMode()
Global Const $UDF_BGR = 1
Global Const $UDF_RGB = 0

; _WinAPI_GetWorldTransform(), _WinAPI_SetWorldTransform()
Global Const $MWT_IDENTITY = 0x01
Global Const $MWT_LEFTMULTIPLY = 0x02
Global Const $MWT_RIGHTMULTIPLY = 0x03
Global Const $MWT_SET = 0x04

; _WinAPI_MonitorFrom*()
Global Const $MONITOR_DEFAULTTONEAREST = 2
Global Const $MONITOR_DEFAULTTONULL = 0
Global Const $MONITOR_DEFAULTTOPRIMARY = 1

; _WinAPI_PolyDraw()
Global Const $PT_BEZIERTO = 4
Global Const $PT_LINETO = 2
Global Const $PT_MOVETO = 6
Global Const $PT_CLOSEFIGURE = 1
; ===============================================================================================================================
