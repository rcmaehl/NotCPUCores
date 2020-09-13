; #FUNCTION# ====================================================================================================================
; Name ..........: _FreezeToStock
; Description ...: Suspend unneeded processes, excluding minialistic required system processes
; Syntax ........: _FreezeToStock($aExclusions, $hOutput = False]])
; Parameters ....: $aProcessExclusions  - Array of Processes to Exclude
;                  $bIncludeServices    - Boolean for whether or not services should be included
;                  $aServicesExclusions - Array of Services to Exclude
;                  $bAggressive         - Boolean for whether or not sc stop should be used
;                  $hOutput             - Handle of the GUI Console
; Return values .: 1                    - An error has occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 09/07/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _FreezeToStock($aProcessExclusions, $bIncludeServices, $aServicesExclusions, $bAggressive, $hOutput)

	_GUICtrlStatusBar_SetText($hOutput, "Freezing...", 0)

	If @Compiled Then
		Local $aSelf[1] = ["FTS.exe"]
	Else
		Local $aSelf[3] = ["AutoIt3.exe", "AutoIt3_x64.exe", "SciTE.exe"]
	EndIf

	Local $aCantBeSuspended[6] = ["Memory Compression", _
									"Registry", _
									"Secure System", _
									"System", _
									"System Idle Process", _
									"System Interrupts"]

	Local $aSystemProcesses[33] = ["ApplicationFrameHost.exe", _
									"backgroundTaskHost.exe", _
									"csrss.exe", _ ; Runtime System Service
									"ctfmon.exe", _ ; Alternative Input
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
									"WWAHost.exe"]

	Local $aSystemServices[71] = ["Appinfo", _ ; Application Information
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
									"iphlpsvc", _ ; IP Helper
									"KeyIso", _ ; CNG Key Isolation
									"LanmanServer", _ ; Server
									"LanmanWorkstation", _ ; Workstation
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
									"SENS", _ ; System Event Notification Service
									"SessionEvc", _ ; Remote Desktop Configuration
									"SgrmBroker", _ ; System Guard Runtime Monitor Broker
									"ShellHWDetection", _ ; Shell Hardware Detection
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
									"wscsvc"] ; Security Center

	_ArrayConcatenate($aProcessExclusions, $aSelf)
	_ArrayConcatenate($aProcessExclusions, $aCantBeSuspended)
	_ArrayConcatenate($aProcessExclusions, $aSystemProcesses)

	_ArrayConcatenate($aServicesExclusions, $aSystemServices)

	$aProcesses = ProcessList()
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		If _ArraySearch($aProcessExclusions, $aProcesses[$iLoop][0]) = -1 Then
			_GUICtrlStatusBar_SetText($hOutput, "Process: " & $aProcesses[$iLoop][0], 1)
			_ProcessSuspend($aProcesses[$iLoop][1])
		Else
			ConsoleWrite("Skipped " & $aProcesses[$iLoop][0] & @CRLF)
		EndIf
	Next

	If $bIncludeServices Then
		Local $hSCM = _SCMStartup()
		$aServices = _ServicesList()
		For $iLoop0 = 0 To 2 Step 1 ; Account for process dependencies
			For $iLoop1 = 0 to $aServices[0][0] Step 1
				If $aServices[$iLoop1][1] = "RUNNING" Then
					If _ArraySearch($aServicesExclusions, $aServices[$iLoop1][0]) = -1 Then
						If $bAggressive Then
							_GUICtrlStatusBar_SetText($hOutput, $iLoop0 + 1 & "/3 Service: " & $aServices[$iLoop1][0], 1)
							_ServiceStop($hSCM, $aServices[$iLoop1][0])
						Else
							_GUICtrlStatusBar_SetText($hOutput, $iLoop0 + 1 & "/3 Service: " & $aServices[$iLoop1][0], 1)
							_ServicePause($hSCM, $aServices[$iLoop1][0])
						EndIf
						Sleep(10)
					Else
						ConsoleWrite("Skipped " & $aServices[$iLoop1][0] & @CRLF)
					EndIf
				EndIf
			Next
		Next
		_SCMShutdown($hSCM)
	EndIf

	_GUICtrlStatusBar_SetText($hOutput, "", 0)
	_GUICtrlStatusBar_SetText($hOutput, "", 1)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _ServicesList
; Description ...: Get a list of Services and their current state
; Syntax ........: _ServicesList()
; Parameters ....:
; Return values .: An Array containing [0][0] Services Count, [x][0] Service name, [x][1] Service State
; Author ........: rcmaehl (Robert Maehl) based on work by Kyan
; Modified ......: 09/05/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ServicesList() ;
    Local $iExitCode, $st,$a,$aServicesList[1][2],$x
    $iExitCode = Run(@ComSpec & ' /C sc queryex type= service state= all', '', @SW_HIDE, 0x2)
    While 1
        $st &= StdoutRead($iExitCode)
        If @error Then ExitLoop
        Sleep(10)
    WEnd
    $a = StringRegExp($st,'(?m)(?i)(?s)(?:SERVICE_NAME|NOME_SERVI€O)\s*?:\s+?(\w+).+?(?:STATE|ESTADO)\s+?:\s+?\d+?\s+?(\w+)',3)
    For $x = 0 To UBound($a)-1 Step 2
        ReDim $aServicesList[UBound($aServicesList)+1][2]
        $aServicesList[UBound($aServicesList)-1][0]=$a[$x]
        $aServicesList[UBound($aServicesList)-1][1]=$a[$x+1]
    Next
    $aServicesList[0][0] = UBound($aServicesList)-1
    Return $aServicesList
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _ThawFromStock
; Description ...: Unsuspend all processes
; Syntax ........: _FreezeToStock(Byref $aExclusions, $hOutput = False]])
; Parameters ....: $aProcessExclusions  - Array of Processes to Exclude
;                  $bIncludeServices    - Boolean for whether or not services should be included
;                  $aServicesSnapshot   - Array of Previously Running Services
;                  $bAggressive         - Boolean for Whether or not sc stop was used
;                  $hOutput             - [optional] Handle of the GUI Console. Default is False, for none.
; Return values .: 1                    - An error has occured
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 09/07/2020
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ThawFromStock($aProcessExclusions, $bIncludeServices, $aServicesSnapshot, $bAggressive, $hOutput)

	_GUICtrlStatusBar_SetText($hOutput, "Thawing...", 0)

	$aProcesses = ProcessList()
	For $iLoop = 0 to $aProcesses[0][0] Step 1
		If _ArraySearch($aProcessExclusions, $aProcesses[$iLoop][0]) = -1 Then
			_GUICtrlStatusBar_SetText($hOutput, "Process: " & $aProcesses[$iLoop][0], 1)
			_ProcessResume($aProcesses[$iLoop][1])
		Else
			;;;
		EndIf
	Next

	If $bIncludeServices Then
		Local $hSCM = _SCMStartup()
		For $iLoop0 = 0 To 2 Step 1 ; Account for process dependencies
			For $iLoop1 = 0 to $aServicesSnapshot[0][0] Step 1
				If $aServicesSnapshot[$iLoop1][1] = "RUNNING" Then
					If $bAggressive Then
						_GUICtrlStatusBar_SetText($hOutput, $iLoop0 + 1 & "/3 Service: " & $aServicesSnapshot[$iLoop1][0], 1)
						_ServiceStart($hSCM, $aServicesSnapshot[$iLoop1][0])
					Else
						_GUICtrlStatusBar_SetText($hOutput, $iLoop0 + 1 & "/3 Service: " & $aServicesSnapshot[$iLoop1][0], 1)
						_ServiceContinue($hSCM, $aServicesSnapshot[$iLoop1][0])
					EndIf
					Sleep(10)
				Else
					;;;
				EndIf
			Next
		Next
		_SCMShutdown($hSCM)
	EndIf

	_GUICtrlStatusBar_SetText($hOutput, "", 0)
	_GUICtrlStatusBar_SetText($hOutput, "", 1)

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