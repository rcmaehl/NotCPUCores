#include-once

; #INDEX# =======================================================================================================================
; Title .........: Structures_Constants
; AutoIt Version : 3.3.14.5
; Description ...: Constants for Windows API functions.
; Author(s) .....: Paul Campbell (PaulIA), Gary Frost, Jpm, UEZ
; ===============================================================================================================================

; #LISTING# =====================================================================================================================
; $tagPOINT
; $tagRECT
; $tagMARGINS
; $tagSIZE
; $tagFILETIME
; $tagSYSTEMTIME
; $tagTIME_ZONE_INFORMATION
; $tagNMHDR
; $tagCOMBOBOXEXITEM
; $tagNMCBEDRAGBEGIN
; $tagNMCBEENDEDIT
; $tagNMCOMBOBOXEX
; $tagDTPRANGE
; $tagNMDATETIMECHANGE
; $tagNMDATETIMEFORMAT
; $tagNMDATETIMEFORMATQUERY
; $tagNMDATETIMEKEYDOWN
; $tagNMDATETIMESTRING
; $tagEVENTLOGRECORD
; $tagGDIP_EFFECTPARAMS_Blur
; $tagGDIP_EFFECTPARAMS_BrightnessContrast
; $tagGDIP_EFFECTPARAMS_ColorBalance
; $tagGDIP_EFFECTPARAMS_ColorCurve
; $tagGDIP_EFFECTPARAMS_ColorLUT
; $tagGDIP_EFFECTPARAMS_HueSaturationLightness
; $tagGDIP_EFFECTPARAMS_Levels
; $tagGDIP_EFFECTPARAMS_RedEyeCorrection
; $tagGDIP_EFFECTPARAMS_Sharpen
; $tagGDIP_EFFECTPARAMS_Tint
; $tagGDIPBITMAPDATA
; $tagGDIPCOLORMATRIX
; $tagGDIPENCODERPARAM
; $tagGDIPENCODERPARAMS
; $tagGDIPRECTF
; $tagGDIPSTARTUPINPUT
; $tagGDIPSTARTUPOUTPUT
; $tagGDIPIMAGECODECINFO
; $tagGDIPPENCODERPARAMS
; $tagHDITEM
; $tagNMHDDISPINFO
; $tagNMHDFILTERBTNCLICK
; $tagNMHEADER
; $tagGETIPAddress
; $tagNMIPADDRESS
; $tagLVFINDINFO
; $tagLVHITTESTINFO
; $tagLVITEM
; $tagNMLISTVIEW
; $tagNMLVCUSTOMDRAW
; $tagNMLVDISPINFO
; $tagNMLVFINDITEM
; $tagNMLVGETINFOTIP
; $tagNMITEMACTIVATE
; $tagNMLVKEYDOWN
; $tagNMLVSCROLL
; $tagMCHITTESTINFO
; $tagMCMONTHRANGE
; $tagMCRANGE
; $tagMCSELRANGE
; $tagNMDAYSTATE
; $tagNMSELCHANGE
; $tagNMOBJECTNOTIFY
; $tagNMTCKEYDOWN
; $tagTVITEMEX
; $tagNMTREEVIEW
; $tagNMTVCUSTOMDRAW
; $tagNMTVDISPINFO
; $tagNMTVGETINFOTIP
; $tagTVHITTESTINFO
; $tagNMTVKEYDOWN
; $tagNMMOUSE
; $tagTOKEN_PRIVILEGES
; $tagIMAGEINFO
; $tagMENUINFO
; $tagMENUITEMINFO
; $tagREBARBANDINFO
; $tagNMREBARAUTOBREAK
; $tagNMRBAUTOSIZE
; $tagNMREBAR
; $tagNMREBARCHEVRON
; $tagNMREBARCHILDSIZE
; $tagCOLORSCHEME
; $tagNMTOOLBAR
; $tagNMTBHOTITEM
; $tagTBBUTTON
; $tagTBBUTTONINFO
; $tagNETRESOURCE
; $tagOVERLAPPED
; $tagOPENFILENAME
; $tagBITMAPINFO
; $tagBLENDFUNCTION
; $tagGUID
; $tagWINDOWPLACEMENT
; $tagWINDOWPOS
; $tagSCROLLINFO
; $tagSCROLLBARINFO
; $tagLOGFONT
; $tagKBDLLHOOKSTRUCT
; $tagPROCESS_INFORMATION
; $tagSTARTUPINFO
; $tagSECURITY_ATTRIBUTES
; $tagWIN32_FIND_DATA
; $tagTEXTMETRIC
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagTVITEM
; ===============================================================================================================================

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagPOINT = "struct;long X;long Y;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagSIZE = "struct;long X;long Y;endstruct"

; #STRUCTURE# ===================================================================================================================e
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagMARGINS = "int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight"

; *******************************************************************************************************************************
; Time Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagFILETIME = "struct;dword Lo;dword Hi;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagSYSTEMTIME = "struct;word Year;word Month;word Dow;word Day;word Hour;word Minute;word Second;word MSeconds;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagTIME_ZONE_INFORMATION = "struct;long Bias;wchar StdName[32];word StdDate[8];long StdBias;wchar DayName[32];word DayDate[8];long DayBias;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMHDR = "struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct"

; ===============================================================================================================================
; *******************************************************************************************************************************
; ComboBoxEx Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagCOMBOBOXEXITEM = "uint Mask;int_ptr Item;ptr Text;int TextMax;int Image;int SelectedImage;int OverlayImage;" & _
		"int Indent;lparam Param"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagNMCBEDRAGBEGIN = $tagNMHDR & ";int ItemID;wchar szText[260]"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagNMCBEENDEDIT = $tagNMHDR & ";bool fChanged;int NewSelection;wchar szText[260];int Why"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMCOMBOBOXEX = $tagNMHDR & ";uint Mask;int_ptr Item;ptr Text;int TextMax;int Image;" & _
		"int SelectedImage;int OverlayImage;int Indent;lparam Param"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Date/Time Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagDTPRANGE = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;" & _
		"word MinSecond;word MinMSecond;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;" & _
		"word MaxMinute;word MaxSecond;word MaxMSecond;bool MinValid;bool MaxValid"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMDATETIMECHANGE = $tagNMHDR & ";dword Flag;" & $tagSYSTEMTIME

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMDATETIMEFORMAT = $tagNMHDR & ";ptr Format;" & $tagSYSTEMTIME & ";ptr pDisplay;wchar Display[64]"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMDATETIMEFORMATQUERY = $tagNMHDR & ";ptr Format;struct;long SizeX;long SizeY;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMDATETIMEKEYDOWN = $tagNMHDR & ";int VirtKey;ptr Format;" & $tagSYSTEMTIME

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMDATETIMESTRING = $tagNMHDR & ";ptr UserString;" & $tagSYSTEMTIME & ";dword Flags"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Event Log Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagEVENTLOGRECORD = "dword Length;dword Reserved;dword RecordNumber;dword TimeGenerated;dword TimeWritten;dword EventID;" & _
		"word EventType;word NumStrings;word EventCategory;word ReservedFlags;dword ClosingRecordNumber;dword StringOffset;" & _
		"dword UserSidLength;dword UserSidOffset;dword DataLength;dword DataOffset"

; ===============================================================================================================================
; *******************************************************************************************************************************
; GDI+ Structures
; *******************************************************************************************************************************
; ===============================================================================================================================

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_Blur = "float Radius; bool ExpandEdge"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_BrightnessContrast = "int BrightnessLevel; int ContrastLevel"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_ColorBalance = "int CyanRed; int MagentaGreen; int YellowBlue"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_ColorCurve = "int Adjustment; int Channel; int AdjustValue"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_ColorLUT = "byte LutB[256]; byte LutG[256]; byte LutR[256]; byte LutA[256]" ;look up tables for each color channel.

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_HueSaturationLightness = "int HueLevel; int SaturationLevel; int LightnessLevel"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_Levels = "int Highlight; int Midtone; int Shadow"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_RedEyeCorrection = "uint NumberOfAreas; ptr Areas"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_Sharpen = "float Radius; float Amount"

; #STRUCTURE# ===================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIP_EFFECTPARAMS_Tint = "int Hue; int Amount"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGDIPBITMAPDATA = "uint Width;uint Height;int Stride;int Format;ptr Scan0;uint_ptr Reserved"

; #STRUCTURE# ===================================================================================================================
; Author ........: FireFox, UEZ
; ===============================================================================================================================
Global Const $tagGDIPCOLORMATRIX = "float m[25]"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGDIPENCODERPARAM = "struct;byte GUID[16];ulong NumberOfValues;ulong Type;ptr Values;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIPENCODERPARAMS = "uint Count;" & $tagGDIPENCODERPARAM

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGDIPRECTF = "struct;float X;float Y;float Width;float Height;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGDIPSTARTUPOUTPUT = "ptr HookProc;ptr UnhookProc"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGDIPIMAGECODECINFO = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;ptr FormatDesc;ptr FileExt;" & _
		"ptr MimeType;dword Flags;dword Version;dword SigCount;dword SigSize;ptr SigPattern;ptr SigMask"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagGDIPPENCODERPARAMS = "uint Count;byte Params[1]"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Header Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagHDITEM = "uint Mask;int XY;ptr Text;handle hBMP;int TextMax;int Fmt;lparam Param;int Image;int Order;uint Type;ptr pFilter;uint State"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMHDDISPINFO = $tagNMHDR & ";int Item;uint Mask;ptr Text;int TextMax;int Image;lparam lParam"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMHDFILTERBTNCLICK = $tagNMHDR & ";int Item;" & $tagRECT

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMHEADER = $tagNMHDR & ";int Item;int Button;ptr pItem"

; ===============================================================================================================================
; *******************************************************************************************************************************
; IPAddress Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagGETIPAddress = "byte Field4;byte Field3;byte Field2;byte Field1"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMIPADDRESS = $tagNMHDR & ";int Field;int Value"

; ===============================================================================================================================
; *******************************************************************************************************************************
; ListView Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagLVFINDINFO = "struct;uint Flags;ptr Text;lparam Param;" & $tagPOINT & ";uint Direction;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagLVHITTESTINFO = $tagPOINT & ";uint Flags;int Item;int SubItem;int iGroup"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & _
		"int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMLISTVIEW = $tagNMHDR & ";int Item;int SubItem;uint NewState;uint OldState;uint Changed;" & _
		"struct;long ActionX;long ActionY;endstruct;lparam Param"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMLVCUSTOMDRAW = "struct;" & $tagNMHDR & ";dword dwDrawStage;handle hdc;" & $tagRECT & _
		";dword_ptr dwItemSpec;uint uItemState;lparam lItemlParam;endstruct" & _
		";dword clrText;dword clrTextBk;int iSubItem;dword dwItemType;dword clrFace;int iIconEffect;" & _
		"int iIconPhase;int iPartID;int iStateID;struct;long TextLeft;long TextTop;long TextRight;long TextBottom;endstruct;uint uAlign"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMLVDISPINFO = $tagNMHDR & ";" & $tagLVITEM

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagNMLVFINDITEM = $tagNMHDR & ";int Start;" & $tagLVFINDINFO

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMLVGETINFOTIP = $tagNMHDR & ";dword Flags;ptr Text;int TextMax;int Item;int SubItem;lparam lParam"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMITEMACTIVATE = $tagNMHDR & ";int Index;int SubItem;uint NewState;uint OldState;uint Changed;" & _
		$tagPOINT & ";lparam lParam;uint KeyFlags"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMLVKEYDOWN = "align 1;" & $tagNMHDR & ";word VKey;uint Flags"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMLVSCROLL = $tagNMHDR & ";int DX;int DY"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Month Calendar Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagMCHITTESTINFO = "uint Size;" & $tagPOINT & ";uint Hit;" & $tagSYSTEMTIME & _
		";" & $tagRECT & ";int iOffset;int iRow;int iCol"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagMCMONTHRANGE = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;word MinSecond;" & _
		"word MinMSeconds;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;word MaxMinute;word MaxSecond;" & _
		"word MaxMSeconds;short Span"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagMCRANGE = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;word MinSecond;" & _
		"word MinMSeconds;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;word MaxMinute;word MaxSecond;" & _
		"word MaxMSeconds;short MinSet;short MaxSet"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagMCSELRANGE = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;word MinSecond;" & _
		"word MinMSeconds;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;word MaxMinute;word MaxSecond;" & _
		"word MaxMSeconds"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMDAYSTATE = $tagNMHDR & ";" & $tagSYSTEMTIME & ";int DayState;ptr pDayState"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMSELCHANGE = $tagNMHDR & _
		";struct;word BegYear;word BegMonth;word BegDOW;word BegDay;word BegHour;word BegMinute;word BegSecond;word BegMSeconds;endstruct;" & _
		"struct;word EndYear;word EndMonth;word EndDOW;word EndDay;word EndHour;word EndMinute;word EndSecond;word EndMSeconds;endstruct"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Tab Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagNMOBJECTNOTIFY = $tagNMHDR & ";int Item;ptr piid;ptr pObject;long Result;dword dwFlags"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMTCKEYDOWN = "align 1;" & $tagNMHDR & ";word VKey;uint Flags"

; ===============================================================================================================================
; *******************************************************************************************************************************
; TreeView Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTVITEM
; Description ...: Specifies or receives attributes of a tree-view item
; Fields ........: Mask          - Flags that indicate which of the other structure members contain valid data:
;                  ...
;                  Param         - A value to associate with the item
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTVITEM = "struct;uint Mask;handle hItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;int SelectedImage;" & _
		"int Children;lparam Param;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagTVITEMEX = "struct;" & $tagTVITEM & ";int Integral;uint uStateEx;hwnd hwnd;int iExpandedImage;int iReserved;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMTREEVIEW = $tagNMHDR & ";uint Action;" & _
		"struct;uint OldMask;handle OldhItem;uint OldState;uint OldStateMask;" & _
		"ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;endstruct;" & _
		"struct;uint NewMask;handle NewhItem;uint NewState;uint NewStateMask;" & _
		"ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;endstruct;" & _
		"struct;long PointX;long PointY;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNMTVCUSTOMDRAW = "struct;" & $tagNMHDR & ";dword DrawStage;handle HDC;" & $tagRECT & _
		";dword_ptr ItemSpec;uint ItemState;lparam ItemParam;endstruct" & _
		";dword ClrText;dword ClrTextBk;int Level"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMTVDISPINFO = $tagNMHDR & ";" & $tagTVITEM

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMTVGETINFOTIP = $tagNMHDR & ";ptr Text;int TextMax;handle hItem;lparam lParam"

; #STRUCTURE# ===================================================================================================================
; Author ........: Matt Diesel (Mat)
; ===============================================================================================================================
Global Const $tagNMTVITEMCHANGE = $tagNMHDR & ";uint Changed;handle hItem;uint StateNew;uint StateOld;lparam lParam;"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagTVHITTESTINFO = $tagPOINT & ";uint Flags;handle Item"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMTVKEYDOWN = "align 1;" & $tagNMHDR & ";word VKey;uint Flags"

; ===============================================================================================================================
; *******************************************************************************************************************************
; ToolTip Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagNMMOUSE = $tagNMHDR & ";dword_ptr ItemSpec;dword_ptr ItemData;" & $tagPOINT & ";lparam HitInfo"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Security Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"

; ===============================================================================================================================
; *******************************************************************************************************************************
; ImageList Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagIMAGEINFO = "handle hBitmap;handle hMask;int Unused1;int Unused2;" & $tagRECT

; ===============================================================================================================================
; *******************************************************************************************************************************
; Menu Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagMENUINFO = "dword Size;INT Mask;dword Style;uint YMax;handle hBack;dword ContextHelpID;ulong_ptr MenuData"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagMENUITEMINFO = "uint Size;uint Mask;uint Type;uint State;uint ID;handle SubMenu;handle BmpChecked;handle BmpUnchecked;" & _
		"ulong_ptr ItemData;ptr TypeData;uint CCH;handle BmpItem"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Rebar Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; Modified ......: jpm
; ===============================================================================================================================
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & _
		"int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & _
		"uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" & ((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMREBARAUTOBREAK = $tagNMHDR & ";uint uBand;uint wID;lparam lParam;uint uMsg;uint fStyleCurrent;bool fAutoBreak"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMRBAUTOSIZE = $tagNMHDR & ";bool fChanged;" & _
		"struct;long TargetLeft;long TargetTop;long TargetRight;long TargetBottom;endstruct;" & _
		"struct;long ActualLeft;long ActualTop;long ActualRight;long ActualBottom;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMREBAR = $tagNMHDR & ";dword dwMask;uint uBand;uint fStyle;uint wID;lparam lParam"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMREBARCHEVRON = $tagNMHDR & ";uint uBand;uint wID;lparam lParam;" & $tagRECT & ";lparam lParamNM"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMREBARCHILDSIZE = $tagNMHDR & ";uint uBand;uint wID;" & _
		"struct;long CLeft;long CTop;long CRight;long CBottom;endstruct;" & _
		"struct;long BLeft;long BTop;long BRight;long BBottom;endstruct"

; ===============================================================================================================================
; *******************************************************************************************************************************
; ToolBar Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagCOLORSCHEME = "dword Size;dword BtnHighlight;dword BtnShadow"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMTOOLBAR = $tagNMHDR & ";int iItem;" & _
		"struct;int iBitmap;int idCommand;byte fsState;byte fsStyle;dword_ptr dwData;int_ptr iString;endstruct" & _
		";int cchText;ptr pszText;" & $tagRECT

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagNMTBHOTITEM = $tagNMHDR & ";int idOld;int idNew;dword dwFlags"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagTBBUTTON = "int Bitmap;int Command;byte State;byte Style;dword_ptr Param;int_ptr String"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagTBBUTTONINFO = "uint Size;dword Mask;int Command;int Image;byte State;byte Style;word CX;dword_ptr Param;ptr Text;int TextMax"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Windows Networking Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagNETRESOURCE = "dword Scope;dword Type;dword DisplayType;dword Usage;ptr LocalName;ptr RemoteName;ptr Comment;ptr Provider"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Odds and Ends Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagOVERLAPPED = "ulong_ptr Internal;ulong_ptr InternalHigh;struct;dword Offset;dword OffsetHigh;endstruct;handle hEvent"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagOPENFILENAME = "dword StructSize;hwnd hwndOwner;handle hInstance;ptr lpstrFilter;ptr lpstrCustomFilter;" & _
		"dword nMaxCustFilter;dword nFilterIndex;ptr lpstrFile;dword nMaxFile;ptr lpstrFileTitle;dword nMaxFileTitle;" & _
		"ptr lpstrInitialDir;ptr lpstrTitle;dword Flags;word nFileOffset;word nFileExtension;ptr lpstrDefExt;lparam lCustData;" & _
		"ptr lpfnHook;ptr lpTemplateName;ptr pvReserved;dword dwReserved;dword FlagsEx"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagBITMAPINFOHEADER = "struct;dword biSize;long biWidth;long biHeight;word biPlanes;word biBitCount;" & _
		"dword biCompression;dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;dword biClrUsed;dword biClrImportant;endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagBITMAPINFO = $tagBITMAPINFOHEADER & ";dword biRGBQuad[1]"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagBLENDFUNCTION = "byte Op;byte Flags;byte Alpha;byte Format"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagGUID = "struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: PsaltyDS
; ===============================================================================================================================
Global Const $tagWINDOWPLACEMENT = "uint length;uint flags;uint showCmd;long ptMinPosition[2];long ptMaxPosition[2];long rcNormalPosition[4]"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagWINDOWPOS = "hwnd hWnd;hwnd InsertAfter;int X;int Y;int CX;int CY;uint Flags"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagSCROLLINFO = "uint cbSize;uint fMask;int nMin;int nMax;uint nPage;int nPos;int nTrackPos"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagSCROLLBARINFO = "dword cbSize;" & $tagRECT & ";int dxyLineButton;int xyThumbTop;" & _
		"int xyThumbBottom;int reserved;dword rgstate[6]"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagLOGFONT = "struct;long Height;long Width;long Escapement;long Orientation;long Weight;byte Italic;byte Underline;" & _
		"byte Strikeout;byte CharSet;byte OutPrecision;byte ClipPrecision;byte Quality;byte PitchAndFamily;wchar FaceName[32];endstruct"

; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost (gafrost)
; ===============================================================================================================================
Global Const $tagKBDLLHOOKSTRUCT = "dword vkCode;dword scanCode;dword flags;dword time;ulong_ptr dwExtraInfo"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Process and Thread Structures
; *******************************************************************************************************************************
; ===============================================================================================================================

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagPROCESS_INFORMATION = "handle hProcess;handle hThread;dword ProcessID;dword ThreadID"

; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagSTARTUPINFO = "dword Size;ptr Reserved1;ptr Desktop;ptr Title;dword X;dword Y;dword XSize;dword YSize;dword XCountChars;" & _
		"dword YCountChars;dword FillAttribute;dword Flags;word ShowWindow;word Reserved2;ptr Reserved3;handle StdInput;" & _
		"handle StdOutput;handle StdError"

; ===============================================================================================================================
; *******************************************************************************************************************************
; Authorization Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Global Const $tagSECURITY_ATTRIBUTES = "dword Length;ptr Descriptor;bool InheritHandle"

; ===============================================================================================================================
; *******************************************************************************************************************************
; FileFind Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Jpm
; ===============================================================================================================================
Global Const $tagWIN32_FIND_DATA = "dword dwFileAttributes;dword ftCreationTime[2];dword ftLastAccessTime[2];dword ftLastWriteTime[2];dword nFileSizeHigh;dword nFileSizeLow;dword dwReserved0;dword dwReserved1;wchar cFileName[260];wchar cAlternateFileName[14]"

; ===============================================================================================================================
; *******************************************************************************************************************************
; GetTextMetrics Structures
; *******************************************************************************************************************************
; ===============================================================================================================================
; #STRUCTURE# ===================================================================================================================
; Author ........: Gary Frost
; ===============================================================================================================================
Global Const $tagTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & _
		"long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & _
		"wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & _
		"byte tmPitchAndFamily;byte tmCharSet"

; =============================================================================================================================== Leave this line at the end of the file =====================================================================================
