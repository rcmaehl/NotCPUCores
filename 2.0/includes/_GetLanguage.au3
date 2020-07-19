Func _GetLanguage($iFlag = 0)
	Local $sLang = "Unknown"
	Switch @OSLang
		Case "0436"
			$sLang = "Afrikaans - South Africa"
		Case "041C"
			$sLang = "Albanian - Albania"
		Case "1401"
			$sLang = "Arabic - Algeria"
		Case "3C01"
			$sLang = "Arabic - Bahrain"
		Case "0C01"
			$sLang = "Arabic - Egypt"
		Case "0801"
			$sLang = "Arabic - Iraq"
		Case "2C01"
			$sLang = "Arabic - Jordan"
		Case "3401"
			$sLang = "Arabic - Kuwait"
		Case "3001"
			$sLang = "Arabic - Lebanon"
		Case "1001"
			$sLang = "Arabic - Libya"
		Case "1801"
			$sLang = "Arabic - Morocco"
		Case "2001"
			$sLang = "Arabic - Oman"
		Case "4001"
			$sLang = "Arabic - Qatar"
		Case "0401"
			$sLang = "Arabic - Saudi Arabia"
		Case "2801"
			$sLang = "Arabic - Syria"
		Case "1C01"
			$sLang = "Arabic - Tunisia"
		Case "3801"
			$sLang = "Arabic - United Arab Emirates"
		Case "2401"
			$sLang = "Arabic - Yemen"
		Case "042B"
			$sLang = "Armenian - Armenia"
		Case "082C"
			$sLang = "Azeri (Cyrillic) - Azerbaijan"
		Case "042C"
			$sLang = "Azeri (Latin) - Azerbaijan"
		Case "042D"
			$sLang = "Basque - Basque"
		Case "0423"
			$sLang = "Belarusian - Belarus"
		Case "0402"
			$sLang = "Bulgarian - Bulgaria"
		Case "0403"
			$sLang = "Catalan - Catalan"
		Case "0804"
			$sLang = "Chinese - China"
		Case "0C04"
			$sLang = "Chinese - Hong Kong SAR"
		Case "1404"
			$sLang = "Chinese - Macau SAR"
		Case "1004"
			$sLang = "Chinese - Singapore"
		Case "0404"
			$sLang = "Chinese - Taiwan"
		Case "0004"
			$sLang = "Chinese (Simplified)"
		Case "7C04"
			$sLang = "Chinese (Traditional)"
		Case "041A"
			$sLang = "Croatian - Croatia"
		Case "0405"
			$sLang = "Czech - Czech Republic"
		Case "0406"
			$sLang = "Danish - Denmark"
		Case "0465"
			$sLang = "Dhivehi - Maldives"
		Case "0813"
			$sLang = "Dutch - Belgium"
		Case "0413"
			$sLang = "Dutch - The Netherlands"
		Case "0C09"
			$sLang = "English - Australia"
		Case "2809"
			$sLang = "English - Belize"
		Case "1009"
			$sLang = "English - Canada"
		Case "2409"
			$sLang = "English - Caribbean"
		Case "1809"
			$sLang = "English - Ireland"
		Case "2009"
			$sLang = "English - Jamaica"
		Case "1409"
			$sLang = "English - New Zealand"
		Case "3409"
			$sLang = "English - Philippines"
		Case "1C09"
			$sLang = "English - South Africa"
		Case "2C09"
			$sLang = "English - Trinidad and Tobago"
		Case "0809"
			$sLang = "English - United Kingdom"
		Case "0409"
			$sLang = "English - United States"
		Case "3009"
			$sLang = "English - Zimbabwe"
		Case "0425"
			$sLang = "Estonian - Estonia"
		Case "0438"
			$sLang = "Faroese - Faroe Islands"
		Case "0429"
			$sLang = "Farsi - Iran"
		Case "040B"
			$sLang = "Finnish - Finland"
		Case "080C"
			$sLang = "French - Belgium"
		Case "0C0C"
			$sLang = "French - Canada"
		Case "040C"
			$sLang = "French - France"
		Case "140C"
			$sLang = "French - Luxembourg"
		Case "180C"
			$sLang = "French - Monaco"
		Case "100C"
			$sLang = "French - Switzerland"
		Case "0456"
			$sLang = "Galician - Galician"
		Case "0437"
			$sLang = "Georgian - Georgia"
		Case "0C07"
			$sLang = "German - Austria"
		Case "0407"
			$sLang = "German - Germany"
		Case "1407"
			$sLang = "German - Liechtenstein"
		Case "1007"
			$sLang = "German - Luxembourg"
		Case "0807"
			$sLang = "German - Switzerland"
		Case "0408"
			$sLang = "Greek - Greece"
		Case "0447"
			$sLang = "Gujarati - India"
		Case "040D"
			$sLang = "Hebrew - Israel"
		Case "0439"
			$sLang = "Hindi - India"
		Case "040E"
			$sLang = "Hungarian - Hungary"
		Case "040F"
			$sLang = "Icelandic - Iceland"
		Case "0421"
			$sLang = "Indonesian - Indonesia"
		Case "0410"
			$sLang = "Italian - Italy"
		Case "0810"
			$sLang = "Italian - Switzerland"
		Case "0411"
			$sLang = "Japanese - Japan"
		Case "044B"
			$sLang = "Kannada - India"
		Case "043F"
			$sLang = "Kazakh - Kazakhstan"
		Case "0457"
			$sLang = "Konkani - India"
		Case "0412"
			$sLang = "Korean - Korea"
		Case "0440"
			$sLang = "Kyrgyz - Kazakhstan"
		Case "0426"
			$sLang = "Latvian - Latvia"
		Case "0427"
			$sLang = "Lithuanian - Lithuania"
		Case "042F"
			$sLang = "Macedonian (FYROM)"
		Case "083E"
			$sLang = "Malay - Brunei"
		Case "043E"
			$sLang = "Malay - Malaysia"
		Case "044E"
			$sLang = "Marathi - India"
		Case "0450"
			$sLang = "Mongolian - Mongolia"
		Case "0414"
			$sLang = "Norwegian (Bokmål) - Norway"
		Case "0814"
			$sLang = "Norwegian (Nynorsk) - Norway"
		Case "0415"
			$sLang = "Polish - Poland"
		Case "0416"
			$sLang = "Portuguese - Brazil"
		Case "0816"
			$sLang = "Portuguese - Portugal"
		Case "0446"
			$sLang = "Punjabi - India"
		Case "0418"
			$sLang = "Romanian - Romania"
		Case "0419"
			$sLang = "Russian - Russia"
		Case "044F"
			$sLang = "Sanskrit - India"
		Case "0C1A"
			$sLang = "Serbian (Cyrillic) - Serbia"
		Case "081A"
			$sLang = "Serbian (Latin) - Serbia"
		Case "041B"
			$sLang = "Slovak - Slovakia"
		Case "0424"
			$sLang = "Slovenian - Slovenia"
		Case "2C0A"
			$sLang = "Spanish - Argentina"
		Case "400A"
			$sLang = "Spanish - Bolivia"
		Case "340A"
			$sLang = "Spanish - Chile"
		Case "240A"
			$sLang = "Spanish - Colombia"
		Case "140A"
			$sLang = "Spanish - Costa Rica"
		Case "1C0A"
			$sLang = "Spanish - Dominican Republic"
		Case "300A"
			$sLang = "Spanish - Ecuador"
		Case "440A"
			$sLang = "Spanish - El Salvador"
		Case "100A"
			$sLang = "Spanish - Guatemala"
		Case "480A"
			$sLang = "Spanish - Honduras"
		Case "080A"
			$sLang = "Spanish - Mexico"
		Case "4C0A"
			$sLang = "Spanish - Nicaragua"
		Case "180A"
			$sLang = "Spanish - Panama"
		Case "3C0A"
			$sLang = "Spanish - Paraguay"
		Case "280A"
			$sLang = "Spanish - Peru"
		Case "500A"
			$sLang = "Spanish - Puerto Rico"
		Case "0C0A"
			$sLang = "Spanish - Spain"
		Case "380A"
			$sLang = "Spanish - Uruguay"
		Case "200A"
			$sLang = "Spanish - Venezuela"
		Case "0441"
			$sLang = "Swahili - Kenya"
		Case "081D"
			$sLang = "Swedish - Finland"
		Case "041D"
			$sLang = "Swedish - Sweden"
		Case "045A"
			$sLang = "Syriac - Syria"
		Case "0449"
			$sLang = "Tamil - India"
		Case "0444"
			$sLang = "Tatar - Russia"
		Case "044A"
			$sLang = "Telugu - India"
		Case "041E"
			$sLang = "Thai - Thailand"
		Case "041F"
			$sLang = "Turkish - Turkey"
		Case "0422"
			$sLang = "Ukrainian - Ukraine"
		Case "0420"
			$sLang = "Urdu - Pakistan"
		Case "0843"
			$sLang = "Uzbek (Cyrillic) - Uzbekistan"
		Case "0443"
			$sLang = "Uzbek (Latin) - Uzbekistan"
		Case "042A"
			$sLang = "Vietnamese - Vietnam"
		Case Else
			Switch StringRight(@OSLang, 2)
				Case "36"
					$sLang = "Afrikaans - Other"
				Case "1C"
					$sLang = "Albanian - Other"
				Case "01"
					$sLang = "Arabic - Other"
				Case "2B"
					$sLang = "Armenian - Other"
				Case "2C"
					$sLang = "Azeri - Other"
				Case "2D"
					$sLang = "Basque - Other"
				Case "23"
					$sLang = "Belarusian - Other"
				Case "02"
					$sLang = "Bulgarian - Other"
				Case "03"
					$sLang = "Catalan - Other"
				Case "04"
					$sLang = "Chinese - Other"
				Case "1A"
					$sLang = "Croatian - Other"
				Case "05"
					$sLang = "Czech - Other"
				Case "06"
					$sLang = "Danish - Other"
				Case "65"
					$sLang = "Dhivehi - Other"
				Case "13"
					$sLang = "Dutch - Other"
				Case "09"
					$sLang = "English - Other"
				Case "25"
					$sLang = "Estonian - Other"
				Case "38"
					$sLang = "Faroese - Other"
				Case "29"
					$sLang = "Farsi - Other"
				Case "0B"
					$sLang = "Finnish - Other"
				Case "0C"
					$sLang = "French - Other"
				Case "56"
					$sLang = "Galician - Other"
				Case "37"
					$sLang = "Georgian - Other"
				Case "07"
					$sLang = "German - Other"
				Case "08"
					$sLang = "Greek - Other"
				Case "47"
					$sLang = "Gujarati - Other"
				Case "0D"
					$sLang = "Hebrew - Other"
				Case "39"
					$sLang = "Hindi - Other"
				Case "0E"
					$sLang = "Hungarian - Other"
				Case "0F"
					$sLang = "Icelandic - Other"
				Case "21"
					$sLang = "Indonesian - Other"
				Case "10"
					$sLang = "Italian - Other"
				Case "11"
					$sLang = "Japanese - Other"
				Case "4B"
					$sLang = "Kannada - Other"
				Case "3F"
					$sLang = "Kazakh - Other"
				Case "57"
					$sLang = "Konkani - Other"
				Case "12"
					$sLang = "Korean - Other"
				Case "40"
					$sLang = "Kyrgyz - Other"
				Case "26"
					$sLang = "Latvian - Other"
				Case "27"
					$sLang = "Lithuanian - Other"
				Case "2F"
					$sLang = "Macedonian - Other"
				Case "3E"
					$sLang = "Malay - Other"
				Case "4E"
					$sLang = "Marathi - Other"
				Case "50"
					$sLang = "Mongolian - Other"
				Case "14"
					$sLang = "Norwegian - Other"
				Case "15"
					$sLang = "Polish - Other"
				Case "16"
					$sLang = "Portuguese - Other"
				Case "46"
					$sLang = "Punjabi - Other"
				Case "18"
					$sLang = "Romanian - Other"
				Case "19"
					$sLang = "Russian - Other"
				Case "4F"
					$sLang = "Sanskrit - Other"
				Case "1A"
					$sLang = "Serbian - Other"
				Case "1B"
					$sLang = "Slovak - Other"
				Case "24"
					$sLang = "Slovenian - Other"
				Case "0A"
					$sLang = "Spanish - Other"
				Case "41"
					$sLang = "Swahili - Other"
				Case "1D"
					$sLang = "Swedish - Other"
				Case "5A"
					$sLang = "Syriac - Other"
				Case "49"
					$sLang = "Tamil - Other"
				Case "44"
					$sLang = "Tatar - Other"
				Case "4A"
					$sLang = "Telugu - Other"
				Case "1E"
					$sLang = "Thai - Other"
				Case "1F"
					$sLang = "Turkish - Other"
				Case "22"
					$sLang = "Ukrainian - Other"
				Case "20"
					$sLang = "Urdu - Other"
				Case "43"
					$sLang = "Uzbek - Other"
				Case "2A"
					$sLang = "Vietnamese - Other"
			EndSwitch
	EndSwitch
	Return $sLang
EndFunc

Func _LoadLanguage($sPath = @OSLang)

	If Not FileExists($sPath) And $sPath = @OSLang Then
		If FileExists(".\Lang\" & @OSLang & ".ini") Then
			$sPath = ".\Lang\" & @OSLang & ".ini"
		Else
			$sPath = ".\Lang\" & StringRight(@OSLang, 2) & ".ini"
		EndIf
	EndIf

	#Region ; File Info
	Global $_sLang_Version     = IniRead($sPath, "File", "Version"   , "0"           )
	Global $_sLang_Language    = IniRead($sPath, "File", "Langauge"  , "Default"     )
	Global $_sLang_Translator  = IniRead($sPath, "File", "Translator", "Robert Maehl")
	#EndRegion

	#Region ; Global Word Usage
	Global $_sLang_Example     = IniRead($sPath, "Global", "Example", "Example")
	Global $_sLang_Usage       = IniRead($sPath, "Global", "Usage"  , "Usage"  )
	Global $_sLang_Done        = IniRead($sPath, "Global", "Done"   , "Done"   )
	#EndRegion

	#Region ; Global UI Usage
	Global $_sLang_IncludeChildren = IniRead($sPath, "Global UI", "Include Children" , "Include Children" )
	Global $_sLang_AllocationMode  = IniRead($sPath, "Global UI", "Allocation Mode"  , "Allocation Mode"  )
	Global $_sLang_Assignments     = IniRead($sPath, "Global UI", "Custom Assignment", "Custom Assignment")
	#EndRegion

	#Region ; File Menu
	Global $_sLang_FileMenu     = IniRead($sPath, "File Menu", "File Menu"  , "File"        )
	Global $_sLang_FileLoad     = IniRead($sPath, "File Menu", "Load Option", "Load Profile")
	Global $_sLang_FileSave     = IniRead($sPath, "File Menu", "Save Option", "Save Profile")
	Global $_sLang_FileQuit     = IniRead($sPath, "File Menu", "Quit Option", "Quit"        )
	#EndRegion

	#Region ; Options Menu
	Global $_sLang_OptionsMenu  = IniRead($sPath, "Options Menu", "Options Menu"    , "Options"             )
	Global $_sLang_TextMenu     = IniRead($sPath, "Options Menu", "Language Menu"   , "Language"            )
	Global $_sLang_TextCurrent  = IniRead($sPath, "Options Menu", "Current Language", "Current"             )
	Global $_sLang_TextLoad     = IniRead($sPath, "Options Menu", "Load Language"   , "Load Language File"  )
	Global $_sLang_SleepMenu    = IniRead($sPath, "Options Menu", "Sleep Menu"      , "Sleep Timer"         )
	Global $_sLang_SleepCurrent = IniRead($sPath, "Options Menu", "Current Sleep"   , "Current Timer"       )
	Global $_sLang_SleepSet     = IniRead($sPath, "Options Menu", "Set Sleep"       , "Set Sleep Timer"     )
	Global $_sLang_SetLibrary   = IniRead($sPath, "Options Menu", "Set Library"     , "Set Steam Library"   )
	Global $_sLang_RemLibrary   = IniRead($sPath, "Options Menu", "Remove Library"  , "Remove Steam Library")
	#EndRegion

	#Region ; Help Menu
	Global $_sLang_HelpMenu     = IniRead($sPath, "Help Menu", "Help Menu"     , "Help"             )
	Global $_sLang_HelpSite     = IniRead($sPath, "Help Menu", "Website Option", "Website"          )
	Global $_sLang_HelpCord     = IniRead($sPath, "Help Menu", "Discord Option", "Discord"          )
	Global $_sLang_HelpHowTo    = IniRead($sPath, "Help Menu", "HowTo Option"  , "How It Works"     )
	Global $_sLang_HelpDonate   = IniRead($sPath, "Help Menu", "Donate Option" , "Buy me a drink?"  )
	Global $_sLang_HelpUpdate   = IniRead($sPath, "Help Menu", "Update Option" , "Check for Updates")
	#EndRegion

	#Region ; Running Processes Tab
	Global $_sLang_RunningTab    = IniRead($sPath, "Running", "Running Tab "  , "Running"        )
	Global $_sLang_ProcessList   = IniRead($sPath, "Running", "Process List"  , "Window Process" )
	Global $_sLang_ProcessTitle  = IniRead($sPath, "Running", "Process Title" , "Window Title"   )
	Global $_sLang_ExclusionsTab = IniRead($sPath, "Running", "Excluded Tab"  , "Excluded"       )
	#EndRegion

	#Region ; Steam Games Tab
	Global $_sLang_GamesTab = IniRead($sPath, "Steam Games", "Games Tab", "Steam Games")
	Global $_sLang_GameName = IniRead($sPath, "Steam Games", "Game Name", "Game Name"  )
	Global $_sLang_GameID   = IniRead($sPath, "Steam Games", "Game ID"  , "Game ID"    )
	#EndRegion

	#Region ; Sleep Timer GUI
	Global $_sLang_SleepText = IniRead($sPath, "SleepUI", "Set Sleep Text", "Decreasing this value can smooth FPS drops when new programs start, at the risk of NotCPUCores having more CPU usage itself")
	Global $_sLang_NewSleep  = IniRead($sPath, "SleepUI", "New Sleep Text", "New Sleep Timer"                                                                                                            )
	#EndRegion

	#Region ; File Dialogs
	Global $_sLang_LoadProfile  = IniRead($sPath, "Files", "Load Profile" , "Load Saved Settings"  )
	Global $_sLang_SaveProfile  = IniRead($sPath, "Files", "Save Profile" , "Save Current Settings")
	Global $_sLang_LoadLanguage = IniRead($sPath, "Files", "Load Language", "Load Language File"   )
	#EndRegion

	#Region ; Debug Output
	Global $_sLang_DebugStart       = IniRead($sPath, "Console", "Debug Started", "Debug Console Initialized"             )
	Global $_sLang_Interrupt        = IniRead($sPath, "Console", "Interrupted"  , "Exiting Optimizations via Interrupt...")
	#EndRegion

	#Region ; Single Line Tooltips
	Global $_sLang_DebugTip    = IniRead($sPath, "Simple Tips", "Debug Tip"   , "Toggle Debug Mode"                              )
	Global $_sLang_RefreshTip  = IniRead($sPath, "Simple Tips", "Refresh Tip" , "F5 or Sort to Refresh"                          )
	Global $_sLang_OptimizeTip = IniRead($sPath, "Simple Tips", "Process Tip" , "Enter the name of the process(es) here"         )
	Global $_sLang_ImportTip   = IniRead($sPath, "Simple Tips", "Import Tip"  , "Import Selected Process from Process List"      )
	Global $_sLang_ChildrenTip = IniRead($sPath, "Simple Tips", "Children Tip", "Include other Processes started by this Program")
	#EndRegion

	#Region ; Multi Line Tooltips
	Global $_sLang_AssignTip1 = IniRead($sPath, "MultiTips", "Assign Line 1", "To run on a Single Core, enter the number of that core.")
	Global $_sLang_AssignTip2 = IniRead($sPath, "MultiTips", "Assign Line 2", "To run on Multiple Cores, seperate them with commas."   )
	Global $_sLang_AssignTip3 = IniRead($sPath, "MultiTips", "Assign Line 3", "Ranges seperated by a dash are supported."              )
	Global $_sLang_AssignTip4 = IniRead($sPath, "MultiTips", "Assign Line 4", "Maximum Cores"                                          )
	#EndRegion

	#Region ; Optimze Tab
	Global $_sLang_PlayTab          = IniRead($sPath, "Play", "Work/Play Tab"    , "Work/Play"          )
	Global $_sLang_PlayText         = IniRead($sPath, "Play", "Work/Play Text"   , "Game/App Settings"  )
	Global $_sLang_OptimizeProcess  = IniRead($sPath, "Play", "Process Select"   , "Process"            )
	Global $_sLang_OptimizePriority = IniRead($sPath, "Play", "Priority Select"  , "Process Priority"   )
	Global $_sLang_Optimize         = IniRead($sPath, "Play", "Optimize Text"    , "ASSIGN"             )
	Global $_sLang_OptimizeAlt      = IniRead($sPath, "Play", "Optimize Alt Text", "Pause/Break to Stop")
	Global $_sLang_Restore          = IniRead($sPath, "Play", "Restore Text"     , "RESET AFFINITIES"   )
	Global $_sLang_RestoreAlt       = IniRead($sPath, "Play", "Restore Alt Text" , "Restoring PC..."    )
	#EndRegion

	#Region ; Stream Tab
	Global $_sLang_StreamTab          = IniRead($sPath, "Stream", "Stream Tab"     , "Stream"                )
	Global $_sLang_StreamText         = IniRead($sPath, "Stream", "Stream Text"    , "Streaming Settings"    )
	Global $_sLang_StreamSoftware     = IniRead($sPath, "Stream", "Stream Software", "Broadcast Software"    )
	Global $_sLang_StreamOtherAssign  = IniRead($sPath, "Stream", "Other Processes", "Assign Other Processes")
	#EndRegion

	#Region ; Tools Tab
	Global $_sLang_ToolTab            = IniRead($sPath, "Tools", "Tools Tab"          , "Tools"             )
	Global $_sLang_GameSection        = IniRead($sPath, "Tools", "Games Section"      , "Game Performance"  )
	Global $_sLang_HPET               = IniRead($sPath, "Tools", "HPET Tool"          , " HPET"             )
	Global $_sLang_GameMode           = IniRead($sPath, "Tools", "Game Mode"          , " Game\n Mode"      )
	Global $_sLang_PowerOptions       = IniRead($sPath, "Tools", "Power Options"      , "Power\nOptions"    )
	Global $_sLang_DiskSection        = IniRead($sPath, "Tools", "Disk Section"       , "Disk Performance"  )
	Global $_sLang_DiskDefrag         = IniRead($sPath, "Tools", "Disk Defrag"        , "Disk\nDefrag"      )
	Global $_sLang_DiskCheck          = IniRead($sPath, "Tools", "Disk Check"         , " Disk\n Check"     )
	Global $_sLang_StorageSection     = IniRead($sPath, "Tools", "Storage Section"    , "Disk Space"        )
	Global $_sLang_DiskCleanup        = IniRead($sPath, "Tools", "Disk Cleanup"       , "Disk\nCleanup"     )
	Global $_sLang_StorageSense       = IniRead($sPath, "Tools", "Storage Sense"      , "Storage\nSense"    )
	Global $_sLang_ReliabilitySection = IniRead($sPath, "Tools", "Reliability Section", "System Reliability")
	Global $_sLang_RecentEvents       = IniRead($sPath, "Tools", "Recent Events"      , " Recent\n Events"  )
	Global $_sLang_ActionCenter       = IniRead($sPath, "Tools", "Action Center"      , " Action\n Center"  )
	#EndRegion

	#Region ; Tools Tab Conversions
	$_sLang_HPET         = StringReplace($_sLang_HPET        , "\n", @CRLF)
	$_sLang_GameMode     = StringReplace($_sLang_GameMode    , "\n", @CRLF)
	$_sLang_PowerOptions = StringReplace($_sLang_PowerOptions, "\n", @CRLF)
	$_sLang_DiskDefrag   = StringReplace($_sLang_DiskDefrag  , "\n", @CRLF)
	$_sLang_DiskCheck    = StringReplace($_sLang_DiskCheck   , "\n", @CRLF)
	$_sLang_DiskCleanup  = StringReplace($_sLang_DiskCleanup , "\n", @CRLF)
	$_sLang_StorageSense = StringReplace($_sLang_StorageSense, "\n", @CRLF)
	$_sLang_RecentEvents = StringReplace($_sLang_RecentEvents, "\n", @CRLF)
	$_sLang_ActionCenter = StringReplace($_sLang_ActionCenter, "\n", @CRLF)
	#EndRegion

	#Region ; Specs Tab
	Global $_sLang_SpecsTab             = IniRead($sPath, "Specs", "Specs Tab"          , "Specs"             )
	Global $_sLang_SpecsOSSection       = IniRead($sPath, "Specs", "OS Section"         , "Operating System"  )
	Global $_sLang_SpecsOS              = IniRead($sPath, "SpFunc _GetLanguage($iFlag = 0)
	Local $sLang = "Unknown"
	Switch @OSLang
		Case "0436"
			$sLang = "Afrikaans - South Africa"
		Case "041C"
			$sLang = "Albanian - Albania"
		Case "1401"
			$sLang = "Arabic - Algeria"
		Case "3C01"
			$sLang = "Arabic - Bahrain"
		Case "0C01"
			$sLang = "Arabic - Egypt"
		Case "0801"
			$sLang = "Arabic - Iraq"
		Case "2C01"
			$sLang = "Arabic - Jordan"
		Case "3401"
			$sLang = "Arabic - Kuwait"
		Case "3001"
			$sLang = "Arabic - Lebanon"
		Case "1001"
			$sLang = "Arabic - Libya"
		Case "1801"
			$sLang = "Arabic - Morocco"
		Case "2001"
			$sLang = "Arabic - Oman"
		Case "4001"
			$sLang = "Arabic - Qatar"
		Case "0401"
			$sLang = "Arabic - Saudi Arabia"
		Case "2801"
			$sLang = "Arabic - Syria"
		Case "1C01"
			$sLang = "Arabic - Tunisia"
		Case "3801"
			$sLang = "Arabic - United Arab Emirates"
		Case "2401"
			$sLang = "Arabic - Yemen"
		Case "042B"
			$sLang = "Armenian - Armenia"
		Case "082C"
			$sLang = "Azeri (Cyrillic) - Azerbaijan"
		Case "042C"
			$sLang = "Azeri (Latin) - Azerbaijan"
		Case "042D"
			$sLang = "Basque - Basque"
		Case "0423"
			$sLang = "Belarusian - Belarus"
		Case "0402"
			$sLang = "Bulgarian - Bulgaria"
		Case "0403"
			$sLang = "Catalan - Catalan"
		Case "0804"
			$sLang = "Chinese - China"
		Case "0C04"
			$sLang = "Chinese - Hong Kong SAR"
		Case "1404"
			$sLang = "Chinese - Macau SAR"
		Case "1004"
			$sLang = "Chinese - Singapore"
		Case "0404"
			$sLang = "Chinese - Taiwan"
		Case "0004"
			$sLang = "Chinese (Simplified)"
		Case "7C04"
			$sLang = "Chinese (Traditional)"
		Case "041A"
			$sLang = "Croatian - Croatia"
		Case "0405"
			$sLang = "Czech - Czech Republic"
		Case "0406"
			$sLang = "Danish - Denmark"
		Case "0465"
			$sLang = "Dhivehi - Maldives"
		Case "0813"
			$sLang = "Dutch - Belgium"
		Case "0413"
			$sLang = "Dutch - The Netherlands"
		Case "0C09"
			$sLang = "English - Australia"
		Case "2809"
			$sLang = "English - Belize"
		Case "1009"
			$sLang = "English - Canada"
		Case "2409"
			$sLang = "English - Caribbean"
		Case "1809"
			$sLang = "English - Ireland"
		Case "2009"
			$sLang = "English - Jamaica"
		Case "1409"
			$sLang = "English - New Zealand"
		Case "3409"
			$sLang = "English - Philippines"
		Case "1C09"
			$sLang = "English - South Africa"
		Case "2C09"
			$sLang = "English - Trinidad and Tobago"
		Case "0809"
			$sLang = "English - United Kingdom"
		Case "0409"
			$sLang = "English - United States"
		Case "3009"
			$sLang = "English - Zimbabwe"
		Case "0425"
			$sLang = "Estonian - Estonia"
		Case "0438"
			$sLang = "Faroese - Faroe Islands"
		Case "0429"
			$sLang = "Farsi - Iran"
		Case "040B"
			$sLang = "Finnish - Finland"
		Case "080C"
			$sLang = "French - Belgium"
		Case "0C0C"
			$sLang = "French - Canada"
		Case "040C"
			$sLang = "French - France"
		Case "140C"
			$sLang = "French - Luxembourg"
		Case "180C"
			$sLang = "French - Monaco"
		Case "100C"
			$sLang = "French - Switzerland"
		Case "0456"
			$sLang = "Galician - Galician"
		Case "0437"
			$sLang = "Georgian - Georgia"
		Case "0C07"
			$sLang = "German - Austria"
		Case "0407"
			$sLang = "German - Germany"
		Case "1407"
			$sLang = "German - Liechtenstein"
		Case "1007"
			$sLang = "German - Luxembourg"
		Case "0807"
			$sLang = "German - Switzerland"
		Case "0408"
			$sLang = "Greek - Greece"
		Case "0447"
			$sLang = "Gujarati - India"
		Case "040D"
			$sLang = "Hebrew - Israel"
		Case "0439"
			$sLang = "Hindi - India"
		Case "040E"
			$sLang = "Hungarian - Hungary"
		Case "040F"
			$sLang = "Icelandic - Iceland"
		Case "0421"
			$sLang = "Indonesian - Indonesia"
		Case "0410"
			$sLang = "Italian - Italy"
		Case "0810"
			$sLang = "Italian - Switzerland"
		Case "0411"
			$sLang = "Japanese - Japan"
		Case "044B"
			$sLang = "Kannada - India"
		Case "043F"
			$sLang = "Kazakh - Kazakhstan"
		Case "0457"
			$sLang = "Konkani - India"
		Case "0412"
			$sLang = "Korean - Korea"
		Case "0440"
			$sLang = "Kyrgyz - Kazakhstan"
		Case "0426"
			$sLang = "Latvian - Latvia"
		Case "0427"
			$sLang = "Lithuanian - Lithuania"
		Case "042F"
			$sLang = "Macedonian (FYROM)"
		Case "083E"
			$sLang = "Malay - Brunei"
		Case "043E"
			$sLang = "Malay - Malaysia"
		Case "044E"
			$sLang = "Marathi - India"
		Case "0450"
			$sLang = "Mongolian - Mongolia"
		Case "0414"
			$sLang = "Norwegian (Bokmål) - Norway"
		Case "0814"
			$sLang = "Norwegian (Nynorsk) - Norway"
		Case "0415"
			$sLang = "Polish - Poland"
		Case "0416"
			$sLang = "Portuguese - Brazil"
		Case "0816"
			$sLang = "Portuguese - Portugal"
		Case "0446"
			$sLang = "Punjabi - India"
		Case "0418"
			$sLang = "Romanian - Romania"
		Case "0419"
			$sLang = "Russian - Russia"
		Case "044F"
			$sLang = "Sanskrit - India"
		Case "0C1A"
			$sLang = "Serbian (Cyrillic) - Serbia"
		Case "081A"
			$sLang = "Serbian (Latin) - Serbia"
		Case "041B"
			$sLang = "Slovak - Slovakia"
		Case "0424"
			$sLang = "Slovenian - Slovenia"
		Case "2C0A"
			$sLang = "Spanish - Argentina"
		Case "400A"
			$sLang = "Spanish - Bolivia"
		Case "340A"
			$sLang = "Spanish - Chile"
		Case "240A"
			$sLang = "Spanish - Colombia"
		Case "140A"
			$sLang = "Spanish - Costa Rica"
		Case "1C0A"
			$sLang = "Spanish - Dominican Republic"
		Case "300A"
			$sLang = "Spanish - Ecuador"
		Case "440A"
			$sLang = "Spanish - El Salvador"
		Case "100A"
			$sLang = "Spanish - Guatemala"
		Case "480A"
			$sLang = "Spanish - Honduras"
		Case "080A"
			$sLang = "Spanish - Mexico"
		Case "4C0A"
			$sLang = "Spanish - Nicaragua"
		Case "180A"
			$sLang = "Spanish - Panama"
		Case "3C0A"
			$sLang = "Spanish - Paraguay"
		Case "280A"
			$sLang = "Spanish - Peru"
		Case "500A"
			$sLang = "Spanish - Puerto Rico"
		Case "0C0A"
			$sLang = "Spanish - Spain"
		Case "380A"
			$sLang = "Spanish - Uruguay"
		Case "200A"
			$sLang = "Spanish - Venezuela"
		Case "0441"
			$sLang = "Swahili - Kenya"
		Case "081D"
			$sLang = "Swedish - Finland"
		Case "041D"
			$sLang = "Swedish - Sweden"
		Case "045A"
			$sLang = "Syriac - Syria"
		Case "0449"
			$sLang = "Tamil - India"
		Case "0444"
			$sLang = "Tatar - Russia"
		Case "044A"
			$sLang = "Telugu - India"
		Case "041E"
			$sLang = "Thai - Thailand"
		Case "041F"
			$sLang = "Turkish - Turkey"
		Case "0422"
			$sLang = "Ukrainian - Ukraine"
		Case "0420"
			$sLang = "Urdu - Pakistan"
		Case "0843"
			$sLang = "Uzbek (Cyrillic) - Uzbekistan"
		Case "0443"
			$sLang = "Uzbek (Latin) - Uzbekistan"
		Case "042A"
			$sLang = "Vietnamese - Vietnam"
		Case Else
			Switch StringRight(@OSLang, 2)
				Case "36"
					$sLang = "Afrikaans - Other"
				Case "1C"
					$sLang = "Albanian - Other"
				Case "01"
					$sLang = "Arabic - Other"
				Case "2B"
					$sLang = "Armenian - Other"
				Case "2C"
					$sLang = "Azeri - Other"
				Case "2D"
					$sLang = "Basque - Other"
				Case "23"
					$sLang = "Belarusian - Other"
				Case "02"
					$sLang = "Bulgarian - Other"
				Case "03"
					$sLang = "Catalan - Other"
				Case "04"
					$sLang = "Chinese - Other"
				Case "1A"
					$sLang = "Croatian - Other"
				Case "05"
					$sLang = "Czech - Other"
				Case "06"
					$sLang = "Danish - Other"
				Case "65"
					$sLang = "Dhivehi - Other"
				Case "13"
					$sLang = "Dutch - Other"
				Case "09"
					$sLang = "English - Other"
				Case "25"
					$sLang = "Estonian - Other"
				Case "38"
					$sLang = "Faroese - Other"
				Case "29"
					$sLang = "Farsi - Other"
				Case "0B"
					$sLang = "Finnish - Other"
				Case "0C"
					$sLang = "French - Other"
				Case "56"
					$sLang = "Galician - Other"
				Case "37"
					$sLang = "Georgian - Other"
				Case "07"
					$sLang = "German - Other"
				Case "08"
					$sLang = "Greek - Other"
				Case "47"
					$sLang = "Gujarati - Other"
				Case "0D"
					$sLang = "Hebrew - Other"
				Case "39"
					$sLang = "Hindi - Other"
				Case "0E"
					$sLang = "Hungarian - Other"
				Case "0F"
					$sLang = "Icelandic - Other"
				Case "21"
					$sLang = "Indonesian - Other"
				Case "10"
					$sLang = "Italian - Other"
				Case "11"
					$sLang = "Japanese - Other"
				Case "4B"
					$sLang = "Kannada - Other"
				Case "3F"
					$sLang = "Kazakh - Other"
				Case "57"
					$sLang = "Konkani - Other"
				Case "12"
					$sLang = "Korean - Other"
				Case "40"
					$sLang = "Kyrgyz - Other"
				Case "26"
					$sLang = "Latvian - Other"
				Case "27"
					$sLang = "Lithuanian - Other"
				Case "2F"
					$sLang = "Macedonian - Other"
				Case "3E"
					$sLang = "Malay - Other"
				Case "4E"
					$sLang = "Marathi - Other"
				Case "50"
					$sLang = "Mongolian - Other"
				Case "14"
					$sLang = "Norwegian - Other"
				Case "15"
					$sLang = "Polish - Other"
				Case "16"
					$sLang = "Portuguese - Other"
				Case "46"
					$sLang = "Punjabi - Other"
				Case "18"
					$sLang = "Romanian - Other"
				Case "19"
					$sLang = "Russian - Other"
				Case "4F"
					$sLang = "Sanskrit - Other"
				Case "1A"
					$sLang = "Serbian - Other"
				Case "1B"
					$sLang = "Slovak - Other"
				Case "24"
					$sLang = "Slovenian - Other"
				Case "0A"
					$sLang = "Spanish - Other"
				Case "41"
					$sLang = "Swahili - Other"
				Case "1D"
					$sLang = "Swedish - Other"
				Case "5A"
					$sLang = "Syriac - Other"
				Case "49"
					$sLang = "Tamil - Other"
				Case "44"
					$sLang = "Tatar - Other"
				Case "4A"
					$sLang = "Telugu - Other"
				Case "1E"
					$sLang = "Thai - Other"
				Case "1F"
					$sLang = "Turkish - Other"
				Case "22"
					$sLang = "Ukrainian - Other"
				Case "20"
					$sLang = "Urdu - Other"
				Case "43"
					$sLang = "Uzbek - Other"
				Case "2A"
					$sLang = "Vietnamese - Other"
			EndSwitch
	EndSwitch
	Return $sLang
EndFunc

Func _LoadLanguage($sPath = @OSLang)

	If Not FileExists($sPath) And $sPath = @OSLang Then
		If FileExists(".\Lang\" & @OSLang & ".ini") Then
			$sPath = ".\Lang\" & @OSLang & ".ini"
		Else
			$sPath = ".\Lang\" & StringRight(@OSLang, 2) & ".ini"
		EndIf
	EndIf

	#Region ; File Info
	Global $_sLang_Version     = IniRead($sPath, "File", "Version"   , "0"           )
	Global $_sLang_Language    = IniRead($sPath, "File", "Langauge"  , "Default"     )
	Global $_sLang_Translator  = IniRead($sPath, "File", "Translator", "Robert Maehl")
	#EndRegion

	#Region ; Global Word Usage
	Global $_sLang_Example     = IniRead($sPath, "Global", "Example", "Example")
	Global $_sLang_Usage       = IniRead($sPath, "Global", "Usage"  , "Usage"  )
	Global $_sLang_Done        = IniRead($sPath, "Global", "Done"   , "Done"   )
	#EndRegion

	#Region ; Global UI Usage
	Global $_sLang_IncludeChildren = IniRead($sPath, "Global UI", "Include Children" , "Include Children" )
	Global $_sLang_AllocationMode  = IniRead($sPath, "Global UI", "Allocation Mode"  , "Allocation Mode"  )
	Global $_sLang_Assignments     = IniRead($sPath, "Global UI", "Custom Assignment", "Custom Assignment")
	#EndRegion

	#Region ; File Menu
	Global $_sLang_FileMenu     = IniRead($sPath, "File Menu", "File Menu"  , "File"        )
	Global $_sLang_FileLoad     = IniRead($sPath, "File Menu", "Load Option", "Load Profile")
	Global $_sLang_FileSave     = IniRead($sPath, "File Menu", "Save Option", "Save Profile")
	Global $_sLang_FileQuit     = IniRead($sPath, "File Menu", "Quit Option", "Quit"        )
	#EndRegion

	#Region ; Options Menu
	Global $_sLang_OptionsMenu  = IniRead($sPath, "Options Menu", "Options Menu"    , "Options"             )
	Global $_sLang_TextMenu     = IniRead($sPath, "Options Menu", "Language Menu"   , "Language"            )
	Global $_sLang_TextCurrent  = IniRead($sPath, "Options Menu", "Current Language", "Current"             )
	Global $_sLang_TextLoad     = IniRead($sPath, "Options Menu", "Load Language"   , "Load Language File"  )
	Global $_sLang_SleepMenu    = IniRead($sPath, "Options Menu", "Sleep Menu"      , "Sleep Timer"         )
	Global $_sLang_SleepCurrent = IniRead($sPath, "Options Menu", "Current Sleep"   , "Current Timer"       )
	Global $_sLang_SleepSet     = IniRead($sPath, "Options Menu", "Set Sleep"       , "Set Sleep Timer"     )
	Global $_sLang_SetLibrary   = IniRead($sPath, "Options Menu", "Set Library"     , "Set Steam Library"   )
	Global $_sLang_RemLibrary   = IniRead($sPath, "Options Menu", "Remove Library"  , "Remove Steam Library")
	#EndRegion

	#Region ; Help Menu
	Global $_sLang_HelpMenu     = IniRead($sPath, "Help Menu", "Help Menu"     , "Help"             )
	Global $_sLang_HelpSite     = IniRead($sPath, "Help Menu", "Website Option", "Website"          )
	Global $_sLang_HelpCord     = IniRead($sPath, "Help Menu", "Discord Option", "Discord"          )
	Global $_sLang_HelpHowTo    = IniRead($sPath, "Help Menu", "HowTo Option"  , "How It Works"     )
	Global $_sLang_HelpDonate   = IniRead($sPath, "Help Menu", "Donate Option" , "Buy me a drink?"  )
	Global $_sLang_HelpUpdate   = IniRead($sPath, "Help Menu", "Update Option" , "Check for Updates")
	#EndRegion

	#Region ; Running Processes Tab
	Global $_sLang_RunningTab    = IniRead($sPath, "Running", "Running Tab "  , "Running"        )
	Global $_sLang_ProcessList   = IniRead($sPath, "Running", "Process List"  , "Window Process" )
	Global $_sLang_ProcessTitle  = IniRead($sPath, "Running", "Process Title" , "Window Title"   )
	Global $_sLang_ExclusionsTab = IniRead($sPath, "Running", "Excluded Tab"  , "Excluded"       )
	#EndRegion

	#Region ; Steam Games Tab
	Global $_sLang_GamesTab = IniRead($sPath, "Steam Games", "Games Tab", "Steam Games")
	Global $_sLang_GameName = IniRead($sPath, "Steam Games", "Game Name", "Game Name"  )
	Global $_sLang_GameID   = IniRead($sPath, "Steam Games", "Game ID"  , "Game ID"    )
	#EndRegion

	#Region ; Sleep Timer GUI
	Global $_sLang_SleepText = IniRead($sPath, "SleepUI", "Set Sleep Text", "Decreasing this value can smooth FPS drops when new programs start, at the risk of NotCPUCores having more CPU usage itself")
	Global $_sLang_NewSleep  = IniRead($sPath, "SleepUI", "New Sleep Text", "New Sleep Timer"                                                                                                            )
	#EndRegion

	#Region ; File Dialogs
	Global $_sLang_LoadProfile  = IniRead($sPath, "Files", "Load Profile" , "Load Saved Settings"  )
	Global $_sLang_SaveProfile  = IniRead($sPath, "Files", "Save Profile" , "Save Current Settings")
	Global $_sLang_LoadLanguage = IniRead($sPath, "Files", "Load Language", "Load Language File"   )
	#EndRegion

	#Region ; Debug Output
	Global $_sLang_DebugStart       = IniRead($sPath, "Console", "Debug Started", "Debug Console Initialized"             )
	Global $_sLang_Interrupt        = IniRead($sPath, "Console", "Interrupted"  , "Exiting Optimizations via Interrupt...")
	#EndRegion

	#Region ; Single Line Tooltips
	Global $_sLang_DebugTip    = IniRead($sPath, "Simple Tips", "Debug Tip"   , "Toggle Debug Mode"                              )
	Global $_sLang_RefreshTip  = IniRead($sPath, "Simple Tips", "Refresh Tip" , "F5 or Sort to Refresh"                          )
	Global $_sLang_OptimizeTip = IniRead($sPath, "Simple Tips", "Process Tip" , "Enter the name of the process(es) here"         )
	Global $_sLang_ImportTip   = IniRead($sPath, "Simple Tips", "Import Tip"  , "Import Selected Process from Process List"      )
	Global $_sLang_ChildrenTip = IniRead($sPath, "Simple Tips", "Children Tip", "Include other Processes started by this Program")
	#EndRegion

	#Region ; Multi Line Tooltips
	Global $_sLang_AssignTip1 = IniRead($sPath, "MultiTips", "Assign Line 1", "To run on a Single Core, enter the number of that core.")
	Global $_sLang_AssignTip2 = IniRead($sPath, "MultiTips", "Assign Line 2", "To run on Multiple Cores, seperate them with commas."   )
	Global $_sLang_AssignTip3 = IniRead($sPath, "MultiTips", "Assign Line 3", "Ranges seperated by a dash are supported."              )
	Global $_sLang_AssignTip4 = IniRead($sPath, "MultiTips", "Assign Line 4", "Maximum Cores"                                          )
	#EndRegion

	#Region ; Optimze Tab
	Global $_sLang_PlayTab          = IniRead($sPath, "Play", "Work/Play Tab"    , "Work/Play"          )
	Global $_sLang_PlayText         = IniRead($sPath, "Play", "Work/Play Text"   , "Game/App Settings"  )
	Global $_sLang_OptimizeProcess  = IniRead($sPath, "Play", "Process Select"   , "Process"            )
	Global $_sLang_OptimizePriority = IniRead($sPath, "Play", "Priority Select"  , "Process Priority"   )
	Global $_sLang_Optimize         = IniRead($sPath, "Play", "Optimize Text"    , "ASSIGN"             )
	Global $_sLang_OptimizeAlt      = IniRead($sPath, "Play", "Optimize Alt Text", "Pause/Break to Stop")
	Global $_sLang_Restore          = IniRead($sPath, "Play", "Restore Text"     , "RESET AFFINITIES"   )
	Global $_sLang_RestoreAlt       = IniRead($sPath, "Play", "Restore Alt Text" , "Restoring PC..."    )
	#EndRegion

	#Region ; Stream Tab
	Global $_sLang_StreamTab          = IniRead($sPath, "Stream", "Stream Tab"     , "Stream"                )
	Global $_sLang_StreamText         = IniRead($sPath, "Stream", "Stream Text"    , "Streaming Settings"    )
	Global $_sLang_StreamSoftware     = IniRead($sPath, "Stream", "Stream Software", "Broadcast Software"    )
	Global $_sLang_StreamOtherAssign  = IniRead($sPath, "Stream", "Other Processes", "Assign Other Processes")
	#EndRegion

	#Region ; Tools Tab
	Global $_sLang_ToolTab            = IniRead($sPath, "Tools", "Tools Tab"          , "Tools"             )
	Global $_sLang_GameSection        = IniRead($sPath, "Tools", "Games Section"      , "Game Performance"  )
	Global $_sLang_HPET               = IniRead($sPath, "Tools", "HPET Tool"          , " HPET"             )
	Global $_sLang_GameMode           = IniRead($sPath, "Tools", "Game Mode"          , " Game\n Mode"      )
	Global $_sLang_PowerOptions       = IniRead($sPath, "Tools", "Power Options"      , "Power\nOptions"    )
	Global $_sLang_DiskSection        = IniRead($sPath, "Tools", "Disk Section"       , "Disk Performance"  )
	Global $_sLang_DiskDefrag         = IniRead($sPath, "Tools", "Disk Defrag"        , "Disk\nDefrag"      )
	Global $_sLang_DiskCheck          = IniRead($sPath, "Tools", "Disk Check"         , " Disk\n Check"     )
	Global $_sLang_StorageSection     = IniRead($sPath, "Tools", "Storage Section"    , "Disk Space"        )
	Global $_sLang_DiskCleanup        = IniRead($sPath, "Tools", "Disk Cleanup"       , "Disk\nCleanup"     )
	Global $_sLang_StorageSense       = IniRead($sPath, "Tools", "Storage Sense"      , "Storage\nSense"    )
	Global $_sLang_ReliabilitySection = IniRead($sPath, "Tools", "Reliability Section", "System Reliability")
	Global $_sLang_RecentEvents       = IniRead($sPath, "Tools", "Recent Events"      , " Recent\n Events"  )
	Global $_sLang_ActionCenter       = IniRead($sPath, "Tools", "Action Center"      , " Action\n Center"  )
	#EndRegion

	#Region ; Tools Tab Conversions
	$_sLang_HPET         = StringReplace($_sLang_HPET        , "\n", @CRLF)
	$_sLang_GameMode     = StringReplace($_sLang_GameMode    , "\n", @CRLF)
	$_sLang_PowerOptions = StringReplace($_sLang_PowerOptions, "\n", @CRLF)
	$_sLang_DiskDefrag   = StringReplace($_sLang_DiskDefrag  , "\n", @CRLF)
	$_sLang_DiskCheck    = StringReplace($_sLang_DiskCheck   , "\n", @CRLF)
	$_sLang_DiskCleanup  = StringReplace($_sLang_DiskCleanup , "\n", @CRLF)
	$_sLang_StorageSense = StringReplace($_sLang_StorageSense, "\n", @CRLF)
	$_sLang_RecentEvents = StringReplace($_sLang_RecentEvents, "\n", @CRLF)
	$_sLang_ActionCenter = StringReplace($_sLang_ActionCenter, "\n", @CRLF)
	#EndRegion

	#Region ; Specs Tab
	Global $_sLang_SpecsTab             = IniRead($sPath, "Specs", "Specs Tab"          , "Specs"             )
	Global $_sLang_SpecsOSSection       = IniRead($sPath, "Specs", "OS Section"         , "Operating System"  )
	Global $_sLang_SpecsOS              = IniRead($sPath, "Specs", "OS"                 , "OS"                )
	Global $_sLang_SpecsLanguage        = IniRead($sPath, "Specs", "Lanugage"           , "Language"          )
	Global $_sLang_SpecsHardwareSection = IniRead($sPath, "Specs", "Hardware Section"   , "Hardware"          )
	Global $_sLang_SpecsMobo            = IniRead($sPath, "Specs", "Motherboard"        , "Motherboard"       )
	Global $_sLang_SpecsCPU             = IniRead($sPath, "Specs", "CPU"                , "CPU"               )
	Global $_sLang_SpecsRAM             = IniRead($sPath, "Specs", "RAM"                , "RAM"               )
	Global $_sLang_SpecsGPU             = IniRead($sPath, "Specs", "GPU"                , "GPU(s)"            )
	#EndRegion

	#Region ; About Tab
	Global $_sLang_AboutTab         = IniRead($sPath, "About", "About Tab"     , "About"         )
	Global $_sLang_AboutDeveloper   = IniRead($sPath, "About", "Developer"     , "Developed by"  )
	Global $_sLang_AboutIcon        = IniRead($sPath, "About", "Icon By"       , "Icon by"       )
	Global $_sLang_AboutLanugage    = IniRead($sPath, "About", "Translation By", "Translation By")
	#EndRegion

	#Region ; Drop Downs
	Global $_sLang_AllocOff          = IniRead($sPath, "Dropdowns", "Disabled"             , "Disabled"          )
	Global $_sLang_AllocAll          = IniRead($sPath, "Dropdowns", "All Cores"            , "All Cores"         )
	Global $_sLang_AllocFirst        = IniRead($sPath, "Dropdowns", "First Core"           , "First Core"        )
	Global $_sLang_AllocFirstTwo     = IniRead($sPath, "Dropdowns", "First Two Cores"      , "First 2 Cores"     )
	Global $_sLang_AllocFirstFour    = IniRead($sPath, "Dropdowns", "First Four Cores"     , "First 4 Cores"     )
	Global $_sLang_AllocFirstHalf    = IniRead($sPath, "Dropdowns", "First Half"           , "First Half"        )
	Global $_sLang_AllocFirstAMD     = IniRead($sPath, "Dropdowns", "First AMD CCX"        , "First AMD CCX"     )
	Global $_sLang_AllocEven         = IniRead($sPath, "Dropdowns", "Even Cores"           , "Even Cores"        )
	Global $_sLang_AllocPhysical     = IniRead($sPath, "Dropdowns", "Physcial Cores"       , "Physcial Cores"    )
	Global $_sLang_AllocOdd          = IniRead($sPath, "Dropdowns", "Odd Cores"            , "Odd Cores"         )
	Global $_sLang_AllocVirtual      = IniRead($sPath, "Dropdowns", "Non-Physical Cores"   , "Non-Physical Cores")
	Global $_sLang_AllocLast         = IniRead($sPath, "Dropdowns", "Last Core"            , "Last Core"         )
	Global $_sLang_AllocLastTwo      = IniRead($sPath, "Dropdowns", "Last Two Cores"       , "Last 2 Cores"      )
	Global $_sLang_AllocLastFour     = IniRead($sPath, "Dropdowns", "Last Four Cores"      , "Last 4 Cores"      )
	Global $_sLang_AllocLastHalf     = IniRead($sPath, "Dropdowns", "Last Half"            , "Last Half"         )
	Global $_sLang_AllocLastAMD      = IniRead($sPath, "Dropdowns", "Last AMD CCX"         , "Last AMD CCX"      )
	Global $_sLang_AllocPairs        = IniRead($sPath, "Dropdowns", "Pairs"                , "Every Other Pair"  )
	Global $_sLang_AllocCustom       = IniRead($sPath, "Dropdowns", "Custom"               , "Custom"            )
	Global $_sLang_AllocBroadcaster  = IniRead($sPath, "Dropdowns", "Broadcaster Cores"    , "Broadcaster Cores" )
	Global $_sLang_AllocProcess      = IniRead($sPath, "Dropdowns", "Process Cores"        , "Game/App Cores"    )
	Global $_sLang_AllocRemaining    = IniRead($sPath, "Dropdowns", "Remaining Cores"      , "Remaining Cores"   )
	Global $_sLang_PriorityLow       = IniRead($sPath, "Dropdowns", "Low Priority"         , "Low"               )
	Global $_sLang_PriorityBNormal   = IniRead($sPath, "Dropdowns", "Below Normal Priority", "Below Normal"      )
	Global $_sLang_PriorityNormal    = IniRead($sPath, "Dropdowns", "Normal Priority"      , "Normal"            )
	Global $_sLang_PriorityANormal   = IniRead($sPath, "Dropdowns", "Above Normal Priority", "Above Normal"      )
	Global $_sLang_PriorityHigh      = IniRead($sPath, "Dropdowns", "High Priority"        , "High"              )
	Global $_sLang_PriorityRealtime  = IniRead($sPath, "Dropdowns", "Realtime Priority"    , "Realtime"          )
	#EndRegion

	#Region ; Normal Execution
	Global $_sLang_Optimizing       = IniRead($sPath, "Running", "Optimizing"      , "optimizing in the background until all close..."                                               )
	Global $_sLang_ReOptimizing     = IniRead($sPath, "Running", "Reoptimizing"    , "Process Count Changed, Optimization Reran"                                                     )
	Global $_sLang_MaxPerformance   = IniRead($sPath, "Running", "Performance Mode", "All Cores used for Assignment, Max Performance will be prioritized over Consistent Performance")
	Global $_sLang_RestoringState   = IniRead($sPath, "Running", "RestoringState"  , "Exited. Restoring Previous State..."                                                           )

	#Region ; Updater
	Global $_sLang_TooNew     = IniRead($sPath, "Updater", "Too New"     , "You're running a newer version than publicly available on Github")
	Global $_sLang_NoUpdates  = IniRead($sPath, "Updater", "No Updates"  , "Your NotCPUCores version is up to date")
	Global $_sLang_NewVersion = IniRead($sPath, "Updater", "New Version" , "An update is available, opening download page")

	#Region ; Errors
	Global $_sLang_InvalidBroadcast      = IniRead($sPath, "Errors", "Broadcaster"             , "Invalid Broadcaster Software!"                                                              )
	Global $_sLang_InvalidBroadcastCores = IniRead($sPath, "Errors", "Broadcast Assignment"    , "Invalid Broadcaster Assignment Mode!"                                                       )
	Global $_sLang_InvalidProcessCores   = IniRead($sPath, "Errors", "Process Assignment"      , "Invalid App/Game Assigment Mode!"                                                           )
	Global $_sLang_InvalidOtherCores     = IniRead($sPath, "Errors", "Other Process Assignment", "Invalid Other Process Assigment Mode!"                                                      )
	Global $_sLang_InvalidPriority       = IniRead($sPath, "Errors", "Priority Assignment"     , "Invalid Priority Mode!"                                                                     )
	Global $_sLang_NotRunning            = IniRead($sPath, "Errors", "Not Running"             , "not currently running. Please run the program(s) first"                                     )
	Global $_sLang_MaxCores              = IniRead($sPath, "Errors", "All Cores Used"          , "No Cores Left for Other Processes, defaulting to last core"                                 )
	Global $_sLang_TooManyCores          = IniRead($sPath, "Errors", "Too Many Cores"          , "You've specified more cores than available on your system"                                  )
	Global $_sLang_TooManyTotalCores     = IniRead($sPath, "Errors", "Too Many Total Cores"    , "You've specified more cores between App/Game and Broadcaster than available on your system" )
	Global $_sLang_SteamNotRunning       = IniRead($sPath, "Errors", "Steam Not Running"       , "Can't launch Steam Games if Steam isn't running. Please launch Steam, wait, and try again"  )
	Global $_sLang_LoadFail              = IniRead($sPath, "Errors", "Update Check Fail"       , "Unable to load Github API to check for updates. Are you connected to the internet?       "  )
	Global $_sLang_DataFail              = IniRead($sPath, "Errors", "Update Data Fail"        , "Data returned for Update Check was invalid or blocked. Please check your internet and retry")
	Global $_sLang_TagsFail              = IniRead($sPath, "Errors", "Update Tags Fail"        , "Data for available updates was missing or incomplete. Please try again later"               )
	Global $_sLang_TypeFail              = IniRead($sPath, "Errors", "Update Type Fail"        , "Data for available update types was missing or incomplete. Please try again later"          )
	#EndRegion

	#Region ; Future Possible Additions
	; $_sLang_RestoringProcess = IniRead($sPath, "Console", "RestoringProcess", "Restoring Priority and Affinity of all Other Processes...")
	; $_sLang_StoppingServices = IniRead($sPath, "Console", "StoppingServices", "Temporarily Pausing Game Impacting Services..."           )
	; $_sLang_StartingServices = IniRead($sPath, "Console", "StartingServices", "Restarting Any Stopped Services..."                       )
	; $_sLang_HPETChange       = IniRead($sPath, "Console", "HPETChange"      , "HPET State Changed, Please Reboot to Apply Changes"       )
	#EndRegion

EndFunc