; #FUNCTION# ====================================================================================================================
; Name ..........: _FreezeToStock
; Description ...: Suspend unneeded processes, excluding minialistic required system processes
; Syntax ........: _FreezeToStock($aExclusions, $hOutput = False]])
; Parameters ....: $aExclusions         - Array of Processes to Exclude
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: 1                    - An error has occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 08/28/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _FreezeToStock($aExclusions, $hOutput = False)

	Local $iExtended = 0

	#include <Array.au3>

	If @Compiled Then
		Local $aSelf[1] = [@ScriptName]
	Else
		Local $aSelf[2] = ["AutoIt3.exe", "AutoIt3_x64.exe", "SciTE.exe"]
	EndIf
	Local $aSystem[32] = ["ApplicationFrameHost.exe", _
							"backgroundTaskHost.exe", _
							"csrss.exe", _ ; Runtime System Service
							"dllhost.exe", _ ; COM Host
							"dwm.exe", _ ; Desktop Window Manager / Compositer
							"explorer.exe", _ ; Windows Explorer
							"fontdrvhost.exe", _
							"lsass.exe", _
							"MsMpEng.exe", _ ; Defender
							"NisSrv.exe", _
							"RuntimeBroker.exe", _
							"SecurityHealthService.exe", _
							"SecurityHealthSystray.exe", _
							"services.exe", _ ; Windows Services
							"SgrmBroker.exe", _
							"ShellExperienceHost.exe", _; UWP Apps
							"sihost.exe", _
							"smartscreen.exe", _
							"smss.exe", _
							"StartMenuExperienceHost.exe", _
							"svchost.exe", _ ; Service Host
							"taskhostw.exe", _ ; Task Host
							"taskmgr.exe", _ ; Task Manager
							"TextInputHost.exe", _
							"unsecapp.exe", _ ; WMI
							"VSSVC.exe", _
							"wininit.exe", _
							"winlogon.exe", _ ; Windows Logon
							"wlanext.exe", _ ; WLAN
							"WmiPrvSE.exe", _ ; WMI
							"WUDFHost.exe", _ ; Windows Usermode Drivers
							"WWAHost.exe", _
							]

	Local $aServices[71] = ["Appinfo", _ ; Application Information
							"AudioEndpointBuilder", _ ; Windows Audio Endpoint Builder
							"Audiosrv", _ ; Windows Audio
							"BFE", _ ; Base Filtering Engine
							"BrokerInfrastructure", _ ; Background Tasks Infrastructure Service
							"camsvc", _ ; Capability Access Manager Service
							"CertPropSvc", _ ; Certificate Propagation
							"CoreMessagingRegistrar", _ ; CoreMessaging
							"CryptSvc", _ ; Cryptographic Services
							"DcomLaunch", _ ; DCOM Server Process Launcher
							"Dhcp", _ ; DHCP Client
							"DispBrokerDesktopSvc", _ ; Display Policy Service
							"Dnscache", _ ; DNS Client
							"DPS", _ ; Diagnostic Policy Service
							"DusmSvc", _ ; Data Usage
							"EventLog", _ ; Windows Event Log
							"EventSystem", _ ; COM+ Event System
							"FontCache", _ ; Windows Font Cache Service
							"gpsvc", _ ; Group Policy Client
							; "InstallService", _ ; Microsoft Store Install Service
							"iphlpsvc", _ ; IP Helper
							"KeyIso", _ ; CNG Key Isolation
							"LanmanServer", _ ; Server
							"LanmanWorkstation", _ ; Workstation
							; "lfsvc", _ ; Geolocation Service
							; "LicenseManager", _ ; Windows License Manager Service
							"lmhosts", _ ; TCP/IP NetBIOS Helper
							"LSM", _ ; Local Session Manager
							"mpssvc", _ ; Windows Defender Firewall
							"NcbService", _ ; Network Connection Broker
							"netprofm", _ ; Network List Service
							"NlaSvc", _ ; Network Location Awareness
							"nsi", _ ; Network Store Interface Service
							"PcaSvc", _ ; Program Compatibility Assistant Service
							"PlugPlay", _ ; Plug and Play
							"Power", _ ; Power
							"ProfSvc", _ ; User Profile Service
							"RmSvc", _ ; Radio Management Service
							"RpcEptMapper", _ ; RPC Endpoint Mapper
							"RpcSs", _ ; Remote Procedure Call
							"SamSs", _ ; Security Accounts Manager
							"Schedule", _ ; Task Scheduler
							"SecurityHealthService", _ ; Windows Security Service
							; "SEMgrSvc", _ ; Payments and NFC/SE Manager
							"SENS", _ ; System Event Notification Service
							"SessionEvc", _ ; Remote Desktop Configuration
							"SgrmBroker", _ ; System Guard Runtime Monitor Broker
							"ShellHWDetection", _ ; Shell Hardware Detection
							; "Spooler", _ ; Print Spooler
							"StateRepository", _ ; State Repository Service
							"StorSvc", _ ; Storage Service
							"swprv", _ ; Microsoft Software Shadow Copy Provider
							"SysMain", _ ; SysMain
							"SystemEventsBroker", _ ; System Events Broker
							"TabletInputService", _ ; Touch Keyboard and Handwriting Panel Service
							"TermService", _ ; Remote Desktop Services
							"Themes", _ ; Themes
							"TimeBrokerSvc", _ ; Time Broker
							"TokenBroker", _ ; Web Account Manager
							"TrkWks", _ ; Distributed Link Tracking Client"
							"UmRdpService", _ ; Remote Desktop Services UserMode Port Redirector
							"UserManager", _ ; User Manager
							"UsoSvc", _ ; Update Orchestreator Service
							"VaultSvc", _ ; Credential Manager
							"VSS", _ ; Volume Shadow Copy
							"WarpJITSvc", _ ; WarpJITSvc
							"WbioSrvc", _ ; Windows Biometric Service
							"Wcmsvc", _ ; Windows Connection Manager
							"WdiServiceHost", _ ; Diagnostic Service Host
							"WdiSystemHost", _ ; Diagnostic System Host
							"WdNisSvc", _ ; Windows Defender Antivirus Network Inspection Service
							"WinDefend", _ ; Windows Defender Antivirus Service
							"WinHttpAutoProxySvc", _ ; WinHTTP Web Proxy Auto-Discovery Service
							"Winmgmt", _ ; Windows Management Instrumentation
							"WpnService", _ ; Windows Push Notifications System Service
							"wscsvc", _ ; Security Center
							; "WSearch", _ ; Windows Search
							]

	_ArrayConcatenate($aExclusions, $aSelf)
	_ArrayConcatenate($aExclusions, $aSystem)

	$aProcesses = ProcessList()
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		If _ArraySearch($aExclusions, $aProcesses[$iLoop][0]) = -1 Then
			_ProcessSuspend($aProcesses[$iLoop][1])
		Else
			;;;
		EndIf
	Next

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _ThawFromStock
; Description ...: Unsuspend all processes
; Syntax ........: _FreezeToStock(Byref $aExclusions, $hOutput = False]])
; Parameters ....: $aExclusions         - Array of Processes to Exclude
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: 1                    - An error has occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 08/28/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
_ThawFromStock($aExclusions, $hOutput = False)

	$aProcesses = ProcessList()
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		If _ArraySearch($aExclusions, $aProcesses[$iLoop][0]) = -1 Then
			_ProcessResume($aProcesses[$iLoop][1])
		Else
			;;;
		EndIf
	Next

EndFunc

Func _ProcessSuspend($iPID)
	$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPID)
	$i_success = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
	If IsArray($i_success) Then
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc

Func _ProcessResume($iPID)
	$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPID)
	$i_success = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
	If IsArray($i_success) Then
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc