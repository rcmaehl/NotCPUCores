#include-once

#include "SecurityConstants.au3"
#include "WinAPIError.au3"

; #INDEX# =======================================================================================================================
; Title .........: Security
; AutoIt Version : 3.3.14.5
; Description ...: Functions that assist with Security management.
; Author(s) .....: Paul Campbell (PaulIA), trancexx
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Security__AdjustTokenPrivileges
; _Security__CreateProcessWithToken
; _Security__DuplicateTokenEx
; _Security__GetAccountSid
; _Security__GetLengthSid
; _Security__GetTokenInformation
; _Security__ImpersonateSelf
; _Security__IsValidSid
; _Security__LookupAccountName
; _Security__LookupAccountSid
; _Security__LookupPrivilegeValue
; _Security__OpenProcessToken
; _Security__OpenThreadToken
; _Security__OpenThreadTokenEx
; _Security__SetPrivilege
; _Security__SetTokenInformation
; _Security__SidToStringSid
; _Security__SidTypeStr
; _Security__StringSidToSid
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
	Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
	If @error Then Return SetError(@error, @extended, False)

	Return Not ($aCall[0] = 0)
EndFunc   ;==>_Security__AdjustTokenPrivileges

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _Security__CreateProcessWithToken($hToken, $iLogonFlags, $sCommandLine, $iCreationFlags, $sCurDir, $tSTARTUPINFO, $tPROCESS_INFORMATION)
	Local $aCall = DllCall("advapi32.dll", "bool", "CreateProcessWithTokenW", "handle", $hToken, "dword", $iLogonFlags, "ptr", 0, "wstr", $sCommandLine, "dword", $iCreationFlags, "struct*", 0, "wstr", $sCurDir, "struct*", $tSTARTUPINFO, "struct*", $tPROCESS_INFORMATION)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, False)

	Return True
EndFunc   ;==>_Security__CreateProcessWithToken

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _Security__DuplicateTokenEx($hExistingToken, $iDesiredAccess, $iImpersonationLevel, $iTokenType)
	Local $aCall = DllCall("advapi32.dll", "bool", "DuplicateTokenEx", "handle", $hExistingToken, "dword", $iDesiredAccess, "struct*", 0, "int", $iImpersonationLevel, "int", $iTokenType, "handle*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Return $aCall[6]
EndFunc   ;==>_Security__DuplicateTokenEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Security__GetAccountSid($sAccount, $sSystem = "")
	Local $aAcct = _Security__LookupAccountName($sAccount, $sSystem)
	If @error Then Return SetError(@error, @extended, 0)

	If IsArray($aAcct) Then Return _Security__StringSidToSid($aAcct[0])
	Return ''
EndFunc   ;==>_Security__GetAccountSid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__GetLengthSid($pSID)
	If Not _Security__IsValidSid($pSID) Then Return SetError(@error + 10, @extended, 0)

	Local $aCall = DllCall("advapi32.dll", "dword", "GetLengthSid", "struct*", $pSID)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aCall[0]
EndFunc   ;==>_Security__GetLengthSid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__GetTokenInformation($hToken, $iClass)
	Local $aCall = DllCall("advapi32.dll", "bool", "GetTokenInformation", "handle", $hToken, "int", $iClass, "struct*", 0, "dword", 0, "dword*", 0)
	If @error Or Not $aCall[5] Then Return SetError(@error + 10, @extended, 0)
	Local $iLen = $aCall[5]

	Local $tBuffer = DllStructCreate("byte[" & $iLen & "]")
	$aCall = DllCall("advapi32.dll", "bool", "GetTokenInformation", "handle", $hToken, "int", $iClass, "struct*", $tBuffer, "dword", DllStructGetSize($tBuffer), "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Return $tBuffer
EndFunc   ;==>_Security__GetTokenInformation

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__ImpersonateSelf($iLevel = $SECURITYIMPERSONATION)
	Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
	If @error Then Return SetError(@error, @extended, False)

	Return Not ($aCall[0] = 0)
EndFunc   ;==>_Security__ImpersonateSelf

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__IsValidSid($pSID)
	Local $aCall = DllCall("advapi32.dll", "bool", "IsValidSid", "struct*", $pSID)
	If @error Then Return SetError(@error, @extended, False)

	Return Not ($aCall[0] = 0)
EndFunc   ;==>_Security__IsValidSid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__LookupAccountName($sAccount, $sSystem = "")
	Local $tData = DllStructCreate("byte SID[256]")
	Local $aCall = DllCall("advapi32.dll", "bool", "LookupAccountNameW", "wstr", $sSystem, "wstr", $sAccount, "struct*", $tData, "dword*", DllStructGetSize($tData), "wstr", "", "dword*", DllStructGetSize($tData), "int*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Local $aAcct[3]
	$aAcct[0] = _Security__SidToStringSid(DllStructGetPtr($tData, "SID"))
	$aAcct[1] = $aCall[5] ; Domain
	$aAcct[2] = $aCall[7] ; SNU

	Return $aAcct
EndFunc   ;==>_Security__LookupAccountName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__LookupAccountSid($vSID, $sSystem = "")
	Local $pSID, $aAcct[3]

	If IsString($vSID) Then
		$pSID = _Security__StringSidToSid($vSID)
	Else
		$pSID = $vSID
	EndIf
	If Not _Security__IsValidSid($pSID) Then Return SetError(@error + 10, @extended, 0)

	Local $sTypeSystem = "ptr"
	If $sSystem Then $sTypeSystem = "wstr" ; remote system is requested

	Local $aCall = DllCall("advapi32.dll", "bool", "LookupAccountSidW", $sTypeSystem, $sSystem, "struct*", $pSID, "wstr", "", "dword*", 65536, "wstr", "", "dword*", 65536, "int*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Local $aAcct[3]
	$aAcct[0] = $aCall[3] ; Name
	$aAcct[1] = $aCall[5] ; Domain
	$aAcct[2] = $aCall[7] ; SNU

	Return $aAcct
EndFunc   ;==>_Security__LookupAccountSid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__LookupPrivilegeValue($sSystem, $sName)
	Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Return $aCall[3] ; LUID
EndFunc   ;==>_Security__LookupPrivilegeValue

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__OpenProcessToken($hProcess, $iAccess)
	Local $aCall = DllCall("advapi32.dll", "bool", "OpenProcessToken", "handle", $hProcess, "dword", $iAccess, "handle*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Return $aCall[3]
EndFunc   ;==>_Security__OpenProcessToken

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
	If $hThread = 0 Then
		Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
		If @error Then Return SetError(@error + 10, @extended, 0)
		$hThread = $aResult[0]
	EndIf

	Local $aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)

	Return $aCall[4] ; Token
EndFunc   ;==>_Security__OpenThreadToken

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
	Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
	If $hToken = 0 Then
		Local Const $ERROR_NO_TOKEN = 1008
		If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
		If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
		$hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
		If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
	EndIf

	Return $hToken
EndFunc   ;==>_Security__OpenThreadTokenEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
	Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
	If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)

	Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
	Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
	Local $iCurrState = DllStructGetSize($tCurrState)
	Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
	Local $iPrevState = DllStructGetSize($tPrevState)
	Local $tRequired = DllStructCreate("int Data")
	; Get current privilege setting
	DllStructSetData($tCurrState, "Count", 1)
	DllStructSetData($tCurrState, "LUID", $iLUID)
	If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)

	; Set privilege based on prior setting
	DllStructSetData($tPrevState, "Count", 1)
	DllStructSetData($tPrevState, "LUID", $iLUID)
	Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
	If $bEnable Then
		$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
	Else
		$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
	EndIf
	DllStructSetData($tPrevState, "Attributes", $iAttributes)

	If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then _
			Return SetError(3, @error, False)

	Return True
EndFunc   ;==>_Security__SetPrivilege

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _Security__SetTokenInformation($hToken, $iTokenInformation, $vTokenInformation, $iTokenInformationLength)
	Local $aCall = DllCall("advapi32.dll", "bool", "SetTokenInformation", "handle", $hToken, "int", $iTokenInformation, "struct*", $vTokenInformation, "dword", $iTokenInformationLength)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, False)

	Return True
EndFunc   ;==>_Security__SetTokenInformation

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__SidToStringSid($pSID)
	If Not _Security__IsValidSid($pSID) Then Return SetError(@error + 10, 0, "")

	Local $aCall = DllCall("advapi32.dll", "bool", "ConvertSidToStringSidW", "struct*", $pSID, "ptr*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, "")
	Local $pStringSid = $aCall[2]

	Local $aLen = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $pStringSid)
	Local $sSID = DllStructGetData(DllStructCreate("wchar Text[" & $aLen[0] + 1 & "]", $pStringSid), "Text")
	; _WinAPI_LocalFree($pStringSid)
	DllCall("kernel32.dll", "handle", "LocalFree", "handle", $pStringSid)

	Return $sSID
EndFunc   ;==>_Security__SidToStringSid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Security__SidTypeStr($iType)
	Switch $iType
		Case $SIDTYPEUSER
			Return "User"
		Case $SIDTYPEGROUP
			Return "Group"
		Case $SIDTYPEDOMAIN
			Return "Domain"
		Case $SIDTYPEALIAS
			Return "Alias"
		Case $SIDTYPEWELLKNOWNGROUP
			Return "Well Known Group"
		Case $SIDTYPEDELETEDACCOUNT
			Return "Deleted Account"
		Case $SIDTYPEINVALID
			Return "Invalid"
		Case $SIDTYPEUNKNOWN
			Return "Unknown Type"
		Case $SIDTYPECOMPUTER
			Return "Computer"
		Case $SIDTYPELABEL
			Return "A mandatory integrity label SID"
		Case Else
			Return "Unknown SID Type"
	EndSwitch
EndFunc   ;==>_Security__SidTypeStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _Security__StringSidToSid($sSID)
	Local $aCall = DllCall("advapi32.dll", "bool", "ConvertStringSidToSidW", "wstr", $sSID, "ptr*", 0)
	If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
	Local $pSID = $aCall[2]

	Local $tBuffer = DllStructCreate("byte Data[" & _Security__GetLengthSid($pSID) & "]", $pSID)
	Local $tSID = DllStructCreate("byte Data[" & DllStructGetSize($tBuffer) & "]")
	DllStructSetData($tSID, "Data", DllStructGetData($tBuffer, "Data"))
	; _WinAPI_LocalFree($pSID)
	DllCall("kernel32.dll", "handle", "LocalFree", "handle", $pSID)

	Return $tSID
EndFunc   ;==>_Security__StringSidToSid
