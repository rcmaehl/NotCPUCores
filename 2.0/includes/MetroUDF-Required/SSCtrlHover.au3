;======================================
;~ Author			: 	binhnx
;~ Created			:	2014/10/20
;======================================
;~ Modified	  	    : BB_19
;~ Last modified	:	2017/10/07
;======================================

#include-once
#include <WinAPI.au3>
#include <WinAPIShellEx.au3> 
Local $_cHvr_aData[0]

		
Local Const $_cHvr_HDLLCOMCTL32 = _WinAPI_LoadLibrary('comctl32.dll')
Assert($_cHvr_HDLLCOMCTL32 <> 0, 'This UDF requires comctl32.dll')
Local Const $_cHvr_PDEFSUBCLASSPROC = _WinAPI_GetProcAddress($_cHvr_HDLLCOMCTL32, 'DefSubclassProc')
Local Const $_cHvr_PINTERNALSUBCLASS_DLL = DllCallbackRegister('_cHvr_iProc', 'NONE', 'HWND;UINT;WPARAM;LPARAM;DWORD')
Local Const $_cHvr_PINTERNALSUBCLASS = DllCallbackGetPtr($_cHvr_PINTERNALSUBCLASS_DLL)

OnAutoItExitRegister("_cHvr_Finalize")
Local Const $_cHvr_TSUBCLASSEXE = Call(@AutoItX64 ? '_cHvr_CSCP_X64' : '_cHvr_CSCP_X86')
Local Const $_cHvr_HEXECUTABLEHEAP = DllCall('kernel32.dll', 'HANDLE', 'HeapCreate', 'DWORD', 0x00040000, 'ULONG_PTR', 0, 'ULONG_PTR', 0)[0]
Assert($_cHvr_HEXECUTABLEHEAP <> 0, 'Failed to create executable heap object')
Local Const $_cHvr_PSUBCLASSEXE = _cHvr_ExecutableFromStruct(Call(@AutoItX64 ? '_cHvr_CSCP_X64' : '_cHvr_CSCP_X86'))


Func _cHvr_Register($idCtrl, $fnHovOff = '', $fnHoverOn = '', $fnClick = '', $fnDblClk = '', $HoverData = 0,$ClickData = 0,$fnRightClick = '')
	Local $hWnd = GUICtrlGetHandle($idCtrl)
	If (Not (IsHWnd($hWnd))) Then Return SetError(1, 0, -1)
	Local $nIndex = _cHvr_GetNewIndex($hWnd)
	Local $aData[13]
	$aData[0] = $hWnd;Control Hwnd
	$aData[1] = $idCtrl; Control handle
	$aData[3] = $fnHovOff;Hover Off func
	$aData[4] = $HoverData;Hover Off Data
	$aData[5] = $fnHoverOn;Hover ON func
	$aData[6] = $HoverData;Hover ON Data
    $aData[7] = $fnRightClick;RClick func
	$aData[8] = $ClickData; click data
	$aData[9] = $fnClick;Click func
	$aData[10] = $ClickData; click data
	$aData[11] = $fnDblClk;DB click func
	$aData[12] = $ClickData;DB click data	
	$_cHvr_aData[$nIndex] = $aData
	_WinAPI_SetWindowSubclass($hWnd, $_cHvr_PSUBCLASSEXE, $hWnd, $nIndex)
	Return $nIndex
EndFunc   ;==>_cHvr_Register

Func _cHvr_iProc($hWnd, $uMsg, $wParam, $lParam, $cIndex)
	Switch $uMsg
		Case 0x0200;Hover
			GUISetCursor(2, 1)
			_cHvr_cMove($_cHvr_aData[$cIndex], $hWnd, $uMsg, $wParam, $lParam)
		Case 0x0201;Leftclick
			_cHvr_cDown($_cHvr_aData[$cIndex], $hWnd, $uMsg, $wParam, $lParam)
		Case 0x0202
			_cHvr_cUp($_cHvr_aData[$cIndex], $hWnd, $uMsg, $wParam, $lParam)
			Return False
		Case 0x0203;Doubleclick
			_cHvr_cDblClk($_cHvr_aData[$cIndex], $hWnd, $uMsg, $wParam, $lParam)
			   Case 0x0204;Rightclick
			  _cHvr_cRightClk($_cHvr_aData[$cIndex], $hWnd, $uMsg, $wParam, $lParam)
		Case 0x02A3;Hover leave
			_cHvr_cLeave($_cHvr_aData[$cIndex], $hWnd, $uMsg, $wParam, $lParam)
		Case 0x0082;Deleted
			_cHvr_UnRegisterInternal($cIndex, $hWnd)
	EndSwitch
	Return True
EndFunc   ;==>_cHvr_iProc

Func _cHvr_cDown(ByRef $aCtrlData, $hWnd, $uMsg, ByRef $wParam, ByRef $lParam)
	_WinAPI_SetCapture($hWnd)
	_cHvr_CallFunc($aCtrlData, 9)
EndFunc   ;==>_cHvr_cDown

Func _cHvr_cMove(ByRef $aCtrlData, $hWnd, $uMsg, ByRef $wParam, ByRef $lParam)
	If (_WinAPI_GetCapture() = $hWnd) Then
		Local $bIn = _cHvr_IsInClient($hWnd, $lParam)
		If Not $aCtrlData[2] Then
			If $bIn Then
				$aCtrlData[2] = 1
				_cHvr_CallFunc($aCtrlData, 9)
			EndIf
		Else
			If Not $bIn Then
				$aCtrlData[2] = 0
				_cHvr_CallFunc($aCtrlData, 3)
			EndIf
		EndIf
	ElseIf Not $aCtrlData[2] Then
		$aCtrlData[2] = 1
		_cHvr_CallFunc($aCtrlData, 5)
		Local $tTME = DllStructCreate('DWORD;DWORD;HWND;DWORD')
		DllStructSetData($tTME, 1, DllStructGetSize($tTME))
		DllStructSetData($tTME, 2, 2) ;$TME_LEAVE
		DllStructSetData($tTME, 3, $hWnd)
		DllCall('user32.dll', 'BOOL', 'TrackMouseEvent', 'STRUCT*', $tTME)
	EndIf
EndFunc   ;==>_cHvr_cMove

Func _cHvr_cUp(ByRef $aCtrlData, $hWnd, $uMsg, ByRef $wParam, ByRef $lParam)
	Local $lRet = _WinAPI_DefSubclassProc($hWnd, $uMsg, $wParam, $lParam)
	If (_WinAPI_GetCapture() = $hWnd) Then
		_WinAPI_ReleaseCapture()
		If _cHvr_IsInClient($hWnd, $lParam) Then
			_cHvr_CallFunc($aCtrlData, 9)
		EndIf
	EndIf
	Return $lRet
EndFunc   ;==>_cHvr_cUp

Func _cHvr_cDblClk(ByRef $aCtrlData, $hWnd, $uMsg, ByRef $wParam, ByRef $lParam)
	_cHvr_CallFunc($aCtrlData, 11)
EndFunc   ;==>_cHvr_cDblClk

Func _cHvr_cRightClk(ByRef $aCtrlData, $hWnd, $uMsg, ByRef $wParam, ByRef $lParam)
	_cHvr_CallFunc($aCtrlData, 7)
EndFunc   ;==>_cHvr_cDblClk

Func _cHvr_cLeave(ByRef $aCtrlData, $hWnd, $uMsg, ByRef $wParam, ByRef $lParam)
	$aCtrlData[2] = 0
	_cHvr_CallFunc($aCtrlData, 3)
EndFunc   ;==>_cHvr_cLeave

Func _cHvr_CallFunc(ByRef $aCtrlData, $iCallType)
	Call($aCtrlData[$iCallType], $aCtrlData[1], $aCtrlData[$iCallType + 1])
EndFunc   ;==>_cHvr_CallFunc

Func _cHvr_ArrayPush(ByRef $aStackArr, Const $vSrc1 = Default, Const $vSrc2 = Default, Const $vSrc3 = Default, Const $vSrc4 = Default, Const $vSrc5 = Default)
	While (UBound($aStackArr) < ($aStackArr[0] + @NumParams))
		ReDim $aStackArr[UBound($aStackArr) * 2]
	WEnd

	If Not ($vSrc1 = Default) Then
		$aStackArr[0] += 1
		$aStackArr[$aStackArr[0]] = $vSrc1
	EndIf
	If Not ($vSrc2 = Default) Then
		$aStackArr[0] += 1
		$aStackArr[$aStackArr[0]] = $vSrc2
	EndIf
	If Not ($vSrc3 = Default) Then
		$aStackArr[0] += 1
		$aStackArr[$aStackArr[0]] = $vSrc3
	EndIf
	If Not ($vSrc4 = Default) Then
		$aStackArr[0] += 1
		$aStackArr[$aStackArr[0]] = $vSrc4
	EndIf
	If Not ($vSrc5 = Default) Then
		$aStackArr[0] += 1
		$aStackArr[$aStackArr[0]] = $vSrc5
	EndIf
EndFunc   ;==>_cHvr_ArrayPush

Func _cHvr_IsInClient($hWnd, $lParam)
	Local $iX = BitShift(BitShift($lParam, -16), 16)
	Local $iY = BitShift($lParam, 16)
	Local $aSize = WinGetClientSize($hWnd)
	Return Not ($iX < 0 Or $iY < 0 Or $iX > $aSize[0] Or $iY > $aSize[1])
EndFunc   ;==>_cHvr_IsInClient

Func _cHvr_CSCP_X86() ;Create Subclass Process x86
	; $hWnd	 			HWND			size: 4			ESP+4			EBP+8
	; $uMsg	 			UINT			size: 4			ESP+8			EBP+12
	; $wParam			WPARAM			size: 4			ESP+12			EBP+16
	; $lParam			LPARAM			size: 4			ESP+16			EBP+20
	; $uIdSubclass		UINT_PTR		size: 4			ESP+20			EBP+24
	; $dwRefData		DWORD_PTR		size: 4			ESP+24			EBP+28		Total: 24

	; NERVER FORGET ADDING align 1 OR YOU WILL SPEND HOURS TO FIND WHAT CAUSE 0xC0000005 Access Violation
	Local $sExe = 'align 1;'
	Local $aOpCode[100]
	$aOpCode[0] = 0
	Local $nAddrOffset[5]
	Local $nElemOffset[5]

	; Func																	; __stdcall
	$sExe &= 'BYTE;BYTE;BYTE;'
	_cHvr_ArrayPush($aOpCode, 0x55) ;push	ebp
	_cHvr_ArrayPush($aOpCode, 0x8B, 0xEC) ;mov	ebp, esp

	; Save un-modified params to nv register
	$sExe &= 'BYTE;' ;push	ebx
	_cHvr_ArrayPush($aOpCode, 0x53) ;53
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	ebx, DWORD PTR [ebp+16]
	_cHvr_ArrayPush($aOpCode, 0x8B, 0x5D, 16) ;8b 5d 10
	$sExe &= 'BYTE;' ;push	esi
	_cHvr_ArrayPush($aOpCode, 0x56) ;56
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	esi, DWORD PTR [ebp+12]
	_cHvr_ArrayPush($aOpCode, 0x8B, 0x75, 12) ;8b 75 0c
	$sExe &= 'BYTE;' ;push	edi
	_cHvr_ArrayPush($aOpCode, 0x57) ;57
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	ebx, DWORD PTR [ebp+20]
	_cHvr_ArrayPush($aOpCode, 0x8B, 0x7D, 20) ;8b 7d 14

	; If ($uMsg = 0x0082) Then Goto WndProcInternal							;WM_NCDESTROY
	$sExe &= 'BYTE;BYTE;DWORD;' ;cmp	esi, 0x82
	_cHvr_ArrayPush($aOpCode, 0x81, 0xFE, 0x82) ;81 fe 82 00 00 00
	$sExe &= 'BYTE;BYTE;' ;je		short WndProcInternal
	_cHvr_ArrayPush($aOpCode, 0x74, 0) ;74 BYTE_OFFSET
	$nAddrOffset[0] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[0] = $aOpCode[0]

	; ElseIf ($uMsg = 0x02A3) Then Goto WndProcInternal						;WM_MOUSELEAVE
	$sExe &= 'BYTE;BYTE;DWORD;' ;cmp	esi, 0x2A3
	_cHvr_ArrayPush($aOpCode, 0x81, 0xFE, 0x2A3) ;81 fe a3 02 00 00
	$sExe &= 'BYTE;BYTE;' ;je		short WndProcInternal
	_cHvr_ArrayPush($aOpCode, 0x74, 0) ;74 BYTE_OFFSET
	$nAddrOffset[1] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[1] = $aOpCode[0]

	; ElseIf ($uMsg < 0x200 Or $uMsg > 0x203) Then Goto DefaultWndProc
	$sExe &= 'BYTE;BYTE;BYTE;' ;lea	eax, DWORD PTR [esi-0x200]
	_cHvr_ArrayPush($aOpCode, 0x8D, 0x86, -0x200) ;8d 86 00 02 00 00
	$sExe &= 'BYTE;BYTE;BYTE;' ;cmp	eax, 3
	_cHvr_ArrayPush($aOpCode, 0x83, 0xF8, 3) ;83 f8 03
	$sExe &= 'BYTE;BYTE;' ;ja		short DefaultWndProc
	_cHvr_ArrayPush($aOpCode, 0x77, 0) ;77 BYTE_OFFSET
	$nAddrOffset[2] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[2] = $aOpCode[0]

	; :WndProcInternal (HWND, UINT, WPARAM, LPARAM, DWORD)
	$aOpCode[$nElemOffset[0]] = $nAddrOffset[2] - $nAddrOffset[0]
	$aOpCode[$nElemOffset[1]] = $nAddrOffset[2] - $nAddrOffset[1]

	; Prepare stack
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	ecx, DWORD PTR [ebp+28]
	_cHvr_ArrayPush($aOpCode, 0x8B, 0x4D, 28) ;8b 4d 1c
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	edx, DWORD PTR [ebp+8]
	_cHvr_ArrayPush($aOpCode, 0x8B, 0x55, 8) ;8b 55 08
	$sExe &= 'BYTE;' ;push	ecx
	_cHvr_ArrayPush($aOpCode, 0x51) ;51
	$sExe &= 'BYTE;' ;push	edi
	_cHvr_ArrayPush($aOpCode, 0x57) ;57
	$sExe &= 'BYTE;' ;push	ebx
	_cHvr_ArrayPush($aOpCode, 0x53) ;53
	$sExe &= 'BYTE;' ;push	esi
	_cHvr_ArrayPush($aOpCode, 0x56) ;56
	$sExe &= 'BYTE;' ;push	edx
	_cHvr_ArrayPush($aOpCode, 0x52) ;52

	; Call
	$sExe &= 'BYTE;PTR;' ;mov	eax, _cHvr_iProc
	_cHvr_ArrayPush($aOpCode, 0xB8, $_cHvr_PINTERNALSUBCLASS)
	$sExe &= 'BYTE;BYTE;' ;call	near eax
	_cHvr_ArrayPush($aOpCode, 0xFF, 0xD0) ;ff 75 8

	; If (WndProcInternal() = 0) Then Return
	$sExe &= 'BYTE;BYTE;' ;test	eax, eax
	_cHvr_ArrayPush($aOpCode, 0x85, 0xC0) ;85 c0
	$sExe &= 'BYTE;BYTE;' ;jz		short Return
	_cHvr_ArrayPush($aOpCode, 0x74, 0) ;74 BYTE_OFFSET
	$nAddrOffset[3] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[3] = $aOpCode[0]

	; :DefaultWndProc (HWND, UINT, WPARAM, LPARAM)
	$aOpCode[$nElemOffset[2]] = $nAddrOffset[3] - $nAddrOffset[2]

	; Prepare stack
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	eax, DWORD PTR [ebp+8]
	_cHvr_ArrayPush($aOpCode, 0x8B, 0x45, 8)
	$sExe &= 'BYTE;' ;push	edi
	_cHvr_ArrayPush($aOpCode, 0x57) ;57
	$sExe &= 'BYTE;' ;push	ebx
	_cHvr_ArrayPush($aOpCode, 0x53) ;53
	$sExe &= 'BYTE;' ;push	esi
	_cHvr_ArrayPush($aOpCode, 0x56) ;56
	$sExe &= 'BYTE;' ;push	eax
	_cHvr_ArrayPush($aOpCode, 0x50) ;50

	;Call
	$sExe &= 'BYTE;PTR;' ;mov	eax,COMCTL32.DefSubclassProc
	_cHvr_ArrayPush($aOpCode, 0xB8, $_cHvr_PDEFSUBCLASSPROC)
	$sExe &= 'BYTE;BYTE;' ;call	near eax
	_cHvr_ArrayPush($aOpCode, 0xFF, 0xD0) ;ff 75 8
	$nAddrOffset[4] = DllStructGetSize(DllStructCreate($sExe))

	; :Return
	$aOpCode[$nElemOffset[3]] = $nAddrOffset[4] - $nAddrOffset[3]

	; Restore nv-register
	$sExe &= 'BYTE;BYTE;BYTE;'
	_cHvr_ArrayPush($aOpCode, 0x5F) ;pop	edi
	_cHvr_ArrayPush($aOpCode, 0x5E) ;pop	esi
	_cHvr_ArrayPush($aOpCode, 0x5B) ;pop	ebx


	; EndFunc
	$sExe &= 'BYTE;BYTE;BYTE;WORD'
	_cHvr_ArrayPush($aOpCode, 0x5D) ;pop	ebp
	_cHvr_ArrayPush($aOpCode, 0xC2, 24) ;ret	24

	Return _cHvr_PopulateOpcode($sExe, $aOpCode)
EndFunc   ;==>_cHvr_CSCP_X86

Func _cHvr_CSCP_X64() ;Create Subclass Process x64
	; First four INT and UINT has size = 8 instead of 4 because they are stored in RCX, RDX, R8, R9
	; $hWnd	 			HWND			size: 8			RCX			RSP+8
	; $uMsg	 			UINT			size: 8 		EDX			RSP+16
	; $wParam			WPARAM			size: 8			R8			RSP+24
	; $lParam			LPARAM			size: 8			R9			RSP+32
	; $uIdSubclass		UINT_PTR		size: 8			RSP+40
	; $dwRefData		DWORD_PTR		size: 8			RSP+48		Total: 48
	Local $sExe = 'align 1;'
	Local $aOpCode[100]
	$aOpCode[0] = 0
	Local $nAddrOffset[5]
	Local $nElemOffset[5]

	; If ($uMsg = 0x0082) Then Goto WndProcInternal							;WM_NCDESTROY
	$sExe &= 'BYTE;BYTE;DWORD;' ;cmp	edx, 0x82
	_cHvr_ArrayPush($aOpCode, 0x81, 0xFA, 0x82) ;81 fa 82 00 00 00
	$sExe &= 'BYTE;BYTE;' ;je		short WndProcInternal
	_cHvr_ArrayPush($aOpCode, 0x74, 0) ;74 BYTE_OFFSET
	$nAddrOffset[0] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[0] = $aOpCode[0]

	; ElseIf ($uMsg = 0x02A3) Then Goto WndProcInternal						;WM_MOUSELEAVE
	$sExe &= 'BYTE;BYTE;DWORD;' ;cmp	edx, 0x2A3
	_cHvr_ArrayPush($aOpCode, 0x81, 0xFA, 0x2A3) ;81 fa a3 02 00 00
	$sExe &= 'BYTE;BYTE;' ;je		short WndProcInternal
	_cHvr_ArrayPush($aOpCode, 0x74, 0) ;74 BYTE_OFFSET
	$nAddrOffset[1] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[1] = $aOpCode[0]

	; ElseIf ($uMsg < 0x200 Or $uMsg > 0x203) Then Goto DefaultWndProc
	$sExe &= 'BYTE;BYTE;DWORD;' ;lea	eax, DWORD PTR [rdx-0x200]
	_cHvr_ArrayPush($aOpCode, 0x8D, 0x82, -0x200) ;8d 82 00 02 00 00
	$sExe &= 'BYTE;BYTE;BYTE;' ;cmp	eax, 3
	_cHvr_ArrayPush($aOpCode, 0x83, 0xF8, 3) ;83 f8 03
	$sExe &= 'BYTE;BYTE;' ;ja		short DefaultWndProc
	_cHvr_ArrayPush($aOpCode, 0x77, 0) ;77 BYTE_OFFSET
	$nAddrOffset[2] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[2] = $aOpCode[0]
	$aOpCode[$nElemOffset[0]] = $nAddrOffset[2] - $nAddrOffset[0]
	$aOpCode[$nElemOffset[1]] = $nAddrOffset[2] - $nAddrOffset[1]


	; :WndProcInternal (HWND rsp+8, UINT +16, WPARAM +24, LPARAM +32, DWORD +40)
	; $dwRefData = [ESP+48+48(sub rsp, 48)+8(push rdi)] = [ESP+104]
	; Save base registers:
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	QWORD PTR [rsp+8], rbx
	_cHvr_ArrayPush($aOpCode, 0x48, 0x89, 0x5C, 0x24, 8) ;48 89 5c 24 08
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	QWORD PTR [rsp+16], rbp
	_cHvr_ArrayPush($aOpCode, 0x48, 0x89, 0x6C, 0x24, 16) ;48 89 6c 24 10
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	QWORD PTR [rsp+24], rsi
	_cHvr_ArrayPush($aOpCode, 0x48, 0x89, 0x74, 0x24, 24) ;48 89 74 24 18
	$sExe &= 'BYTE;' ;push	rdi
	_cHvr_ArrayPush($aOpCode, 0x57) ;57
	; Max sub-routine params = 5 (size = 5*8 = 40), + 8 bytes for return value = 48.
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;' ;sub	rsp, 48
	_cHvr_ArrayPush($aOpCode, 0x48, 0x83, 0xEC, 48) ;48 83 ec 30
	; rbx, rbp, rsi now at [ESP+8+56], [ESP+16+56], [ESP+24+56]

	; Save the parameters:
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	rdi, r9
	_cHvr_ArrayPush($aOpCode, 0x49, 0x8B, 0xF9) ;49 8b f9
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	rsi, r8
	_cHvr_ArrayPush($aOpCode, 0x49, 0x8B, 0xF0) ;49 8b f0
	$sExe &= 'BYTE;BYTE;' ;mov	ebx, edx
	_cHvr_ArrayPush($aOpCode, 0x8B, 0xDA) ;8b da
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	rbp, rcx
	_cHvr_ArrayPush($aOpCode, 0x48, 0x8B, 0xE9) ;48 8b e9

	; Prepare additional parameter for internal WndProc
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	rax, QWORD PTR [rsp+104]
	_cHvr_ArrayPush($aOpCode, 0x48, 0x8B, 0x44, 0x24, 104) ;48 8b 44 24 68
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	QWORD PTR [rsp+32], Rax]
	_cHvr_ArrayPush($aOpCode, 0x48, 0x89, 0x44, 0x24, 32) ;48 89 44 24 20

	; Call internal WndProc
	$sExe &= 'BYTE;BYTE;PTR;' ;mov	rax, QWORD PTR _cHvr_iProc
	_cHvr_ArrayPush($aOpCode, 0x48, 0xB8, $_cHvr_PINTERNALSUBCLASS)
	;movabs	rax, _cHvr_iProc					;48 b8 QWORD_PTR
	$sExe &= 'BYTE;BYTE;' ;call	rax
	_cHvr_ArrayPush($aOpCode, 0xFF, 0xD0) ;ff d0

	; If (WndProcInternal() = 0) Then Return
	$sExe &= 'BYTE;BYTE;BYTE;' ;cmp	edx, 0x2A3
	_cHvr_ArrayPush($aOpCode, 0x48, 0x85, 0xC0) ;48 85 c0
	$sExe &= 'BYTE;BYTE;' ;je		short WndProcInternal
	_cHvr_ArrayPush($aOpCode, 0x74, 0)
	$nAddrOffset[3] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[3] = $aOpCode[0]

	; Restore parameters for DefSubclassProc call
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	r9, rdi
	_cHvr_ArrayPush($aOpCode, 0x4C, 0x8B, 0xCF) ;4c 8b cf
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	r8, rsi
	_cHvr_ArrayPush($aOpCode, 0x4C, 0x8B, 0xC6) ;4c 8b c6
	$sExe &= 'BYTE;BYTE;' ;mov	edx, ebx
	_cHvr_ArrayPush($aOpCode, 0x8B, 0xD3) ;8b d3
	$sExe &= 'BYTE;BYTE;BYTE;' ;mov	rcx, rbp
	_cHvr_ArrayPush($aOpCode, 0x48, 0x8B, 0xCD) ;48 8b cd

	; Restore registers value
	$aOpCode[$nElemOffset[3]] = DllStructGetSize(DllStructCreate($sExe)) - $nAddrOffset[3]
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	rbx, QWORD PTR [rsp+64]
	_cHvr_ArrayPush($aOpCode, 0x48, 0x8B, 0x5C, 0x24, 64) ;48 8b 5c 24 40
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	rbp, QWORD PTR [rsp+72]
	_cHvr_ArrayPush($aOpCode, 0x48, 0x8B, 0x6C, 0x24, 72) ;48 8b 6c 24 48
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;BYTE;' ;mov	rsi, QWORD PTR [rsp+80]
	_cHvr_ArrayPush($aOpCode, 0x48, 0x8B, 0x74, 0x24, 80) ;48 8b 74 24 50
	$sExe &= 'BYTE;BYTE;BYTE;BYTE;' ;add	rsp, 48
	_cHvr_ArrayPush($aOpCode, 0x48, 0x83, 0xc4, 48) ;48 83 c4 30
	$sExe &= 'BYTE;' ;pop	rdi
	_cHvr_ArrayPush($aOpCode, 0x5F) ;5f
	$sExe &= 'BYTE;BYTE;BYTE;' ;cmp	edx, 0x2A3
	_cHvr_ArrayPush($aOpCode, 0x48, 0x85, 0xC0) ;48 85 c0
	$sExe &= 'BYTE;BYTE;' ;je		short WndProcInternal
	_cHvr_ArrayPush($aOpCode, 0x74, 0)
	$nAddrOffset[4] = DllStructGetSize(DllStructCreate($sExe))
	$nElemOffset[4] = $aOpCode[0]
	$aOpCode[$nElemOffset[2]] = DllStructGetSize(DllStructCreate($sExe)) - $nAddrOffset[2]

	; :DefaultWndProc (HWND, UINT, WPARAM, LPARAM)
	$sExe &= 'BYTE;BYTE;PTR;'
	_cHvr_ArrayPush($aOpCode, 0x48, 0xB8, $_cHvr_PDEFSUBCLASSPROC)
	$sExe &= 'BYTE;BYTE;'
	_cHvr_ArrayPush($aOpCode, 0xFF, 0xE0)

	; :Return
	$aOpCode[$nElemOffset[4]] = DllStructGetSize(DllStructCreate($sExe)) - $nAddrOffset[4]
	$sExe &= 'BYTE;' ;ret	0
	_cHvr_ArrayPush($aOpCode, 0xC3)

	Return _cHvr_PopulateOpcode($sExe, $aOpCode)
EndFunc   ;==>_cHvr_CSCP_X64

Func _cHvr_PopulateOpcode(ByRef $sExe, ByRef $aOpCode)
	Local $tExe = DllStructCreate($sExe)
	Assert(@error = 0, 'DllStrucCreate Failed With Error = ' & @error)
	For $i = 1 To $aOpCode[0]
		DllStructSetData($tExe, $i, $aOpCode[$i])
	Next
	Return $tExe
EndFunc   ;==>_cHvr_PopulateOpcode

Func _cHvr_ExecutableFromStruct($tExe)
	Local $pExe = DllCall('kernel32.dll', 'PTR', 'HeapAlloc', 'HANDLE', $_cHvr_HEXECUTABLEHEAP, 'DWORD', 8, 'ULONG_PTR', DllStructGetSize($tExe))[0]
	Assert($pExe <> 0, 'Allocate memory failed')
	DllCall("kernel32.dll", "none", "RtlMoveMemory", "PTR", $pExe, "PTR", DllStructGetPtr($tExe), "ULONG_PTR", DllStructGetSize($tExe))
	Assert(@error = 0, 'Failed to copy memory')
	Return $pExe
EndFunc   ;==>_cHvr_ExecutableFromStruct

Func _cHvr_UnRegisterInternal($cIndex, $hWnd)
	_WinAPI_RemoveWindowSubclass($hWnd, $_cHvr_PSUBCLASSEXE, $hWnd)
	Local $aData=$_cHvr_aData[$cIndex]
	$_cHvr_aData[$cIndex] = 0
	 Call( "_iControlDelete",$aData[1])
EndFunc   ;==>_cHvr_UnRegisterInternal

Func _cHvr_Finalize()
	DllCallbackFree($_cHvr_PINTERNALSUBCLASS_DLL)
	_WinAPI_FreeLibrary($_cHvr_HDLLCOMCTL32)
	If ($_cHvr_HEXECUTABLEHEAP <> 0) Then
		If ($_cHvr_PSUBCLASSEXE <> 0) Then
			DllCall('kernel32.dll', 'BOOL', 'HeapFree', 'HANDLE', $_cHvr_HEXECUTABLEHEAP, 'DWORD', 0, 'PTR', $_cHvr_PSUBCLASSEXE)
		EndIf
		DllCall('kernel32.dll', 'BOOL', 'HeapDestroy', 'HANDLE', $_cHvr_HEXECUTABLEHEAP)
	EndIf
EndFunc   ;==>_cHvr_Finalize

Func Assert($bExpression, $sMsg = '', $sScript = @ScriptName, $sScriptPath = @ScriptFullPath, $iLine = @ScriptLineNumber, $iError = @error, $iExtend = @extended)
	If (Not ($bExpression)) Then
		MsgBox(BitOR(1, 0x10), 'Assertion Error!', _
				@CRLF & 'Script' & @TAB & ': ' & $sScript _
				 & @CRLF & 'Path' & @TAB & ': ' & $sScriptPath _
				 & @CRLF & 'Line' & @TAB & ': ' & $iLine _
				 & @CRLF & 'Error' & @TAB & ': ' & ($iError > 0x7FFF ? Hex($iError) : $iError) _
				 & ($iExtend <> 0 ? '  (Extended : ' & ($iExtend > 0x7FFF ? Hex($iExtend) : $iExtend) & ')' : '') _
				 & @CRLF & 'Message' & @TAB & ': ' & $sMsg _
				 & @CRLF & @CRLF & 'OK: Exit Script' & @TAB & 'Cancel: Continue')
		Exit
	EndIf
EndFunc   ;==>Assert

Func _cHvr_GetNewIndex($hWnd)
	;Try to assign index from previously deleted control
	For $i = 0 To UBound($_cHvr_aData) - 1 Step +1
		If Not IsArray($_cHvr_aData[$i]) Then
			Return $i
		EndIf
	Next

	ReDim $_cHvr_aData[UBound($_cHvr_aData) + 1]
	Return UBound($_cHvr_aData) - 1
EndFunc   ;==>_cHvr_GetNewIndex

Func _WinAPI_GetCapture()
	Return DllCall("user32.dll", "HWND", "GetCapture")[0]
EndFunc   ;==>_WinAPI_GetCapture
