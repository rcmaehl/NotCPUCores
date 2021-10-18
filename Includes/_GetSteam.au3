#include-once
#include <File.au3>
#include <StringConstants.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetSteamPath
; Description ...: Obtains the Steam install Path
; Syntax ........: _GetSteamPath()
; Parameters ....: none
; Return values .: Success - Returns a string containing Steam install Path
;                  Failure - Returns 0 and sets @error:
;                  |1 - Steam Install Location Error, sets @extended: (1, Unable to read Registry; 2, Path Invalid)
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 10/17/21
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetSteamPath()

	Local $hSteamDir = RegRead("HKEY_CURRENT_USER\Software\Valve\Steam", "SteamPath")
	If @error Then
		Return SetError(1,0,0)
	Else
		$hSteamDir = StringReplace($hSteamDir, "/", "\")
	EndIf

	If FileExists($hSteamDir) Then
		Return $hSteamDir
	Else
		Return SetError(2,1,0)
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetSteamLibraries
; Description ...: Obtains a list of Steam Libraries
; Syntax ........: _GetSteamLibraries([$sPath = "None"])
; Parameters ....: $sPath               - [optional] Steam Install Directory. Default will grab from Registry
; Return values .: Success - Returns an array of Steam library locations
;                  Failure - Returns 0 and sets @error:
;                  |1 - Steam Install Location Error, sets @extended: (1, Unable to read Registry; 2, Path Invalid)
;                  |2 - Steam Library File Error, sets @extended: (1, File does not exist; 2, File could not be read)
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 09/13/21
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetSteamLibraries($hPath = "None")

	Local $aLibraries[2]
	Local $hLibraryFile

	$aLibraries[0] = 1

	If $hPath = "None" Then
		Local $hSteamDir = _GetSteamPath()
		If @error Then
			Return SetError(1,0,0)
		Else
			$hSteamDir = StringReplace($hSteamDir, "/", "\")
		EndIf
		$hSteamDir &= "\steamapps\libraryfolders.vdf"
	Else
		If FileExists($hPath) Then
			Local $hSteamDir = $hPath
			$hSteamDir = StringReplace($hSteamDir, "/", "\")
		Else
			Return SetError(1,1,0)
		EndIf
	EndIf

	$aLibraries[1] = StringReplace($hSteamDir, "steamapps\libraryfolders.vdf", "")

	If FileExists($hSteamDir) Then
		$hLibraryFile = FileOpen($hSteamDir)
		If @error Then SetError(2,0,0)
	Else
		SetError(2,1,0)
	EndIf

	Local $iLines = _FileCountLines($hSteamDir)

	For $iLine = 1 to $iLines Step 1
		$sLine = FileReadLine($hLibraryFile, $iLine)
		If @error = -1 Then ExitLoop
		$sLine = StringStripWS($sLine, $STR_STRIPLEADING)
		$sLine = StringRegExpReplace($sLine, '"\s*"', "?")
		$sLine = StringReplace($sLine, '"', "")
		$sLine = StringReplace($sLine, "\\", "\")
		$aLine = StringSplit($sLine, '?')

		If $aLine[0] = 2 And $aLine[1] = "path" Then
			ReDim $aLibraries[UBound($aLibraries) + 1]
			$aLibraries[0] = UBound($aLibraries) - 1
			$aLibraries[$aLibraries[0]] = $aLine[2]
		EndIf
	Next

	FileClose($hLibraryFile)

	Return $aLibraries

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SteamGetGamesFromLibrary
; Description ...: Obtains a list of Games from a specified Steam Library
; Syntax ........: _SteamGetGamesFromLibrary($sLibrary)
; Parameters ....: $sLibrary            - Path to a valid Steam Library
; Return values .: Success - Returns an array of Steam games
;                  Failure - Returns 0 and sets @error:
;                  |1 - Steam Library Empty
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 03/09/19
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SteamGetGamesFromLibrary($sLibrary)

	Local $aGames[1][2]

	$aGames[0][0] = "0"

	Local $hSearch = FileFindFirstFile($sLibrary & "\steamapps\appmanifest_*.acf")

	If $hSearch = -1 Then SetError(1,0,0)

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then Return $aGames

		ReDim $aGames[UBound($aGames) + 1][2]

		$hManifestFile = FileOpen($sLibrary & "\steamapps\" & $sFile)
		If $hManifestFile = -1 Then ContinueLoop

		Local $iLines = _FileCountLines($sLibrary & "\steamapps\" & $sFile)

		For $iLine = 1 to $iLines Step 1
			$sLine = FileReadLine($hManifestFile, $iLine)
			If @error = -1 Then ExitLoop
			$sLine = StringStripWS($sLine, $STR_STRIPLEADING)
			$sLine = StringRegExpReplace($sLine, '"\s*"', "?")
			$sLine = StringReplace($sLine, '"', "")
			$aLine = StringSplit($sLine, '?')

			If $aLine[0] = 2 And $aLine[1] = "appid" Then
				$aGames[UBound($aGames) - 1][0] = $aLine[2]
			EndIf

			If $aLine[0] = 2 And $aLine[1] = "name" Then
				$aGames[UBound($aGames) - 1][1] = $aLine[2]
			EndIf
		Next

		$aGames[0][0] = UBound($aGames) - 1

		FileClose($hManifestFile)

	WEnd

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _SteamGetGamesDetailsFromLibrary
; Description ...: Obtains a list of Details from a specified Steam Library
; Syntax ........: _SteamGetGamesDetailsFromLibrary($sLibrary, $sDetails)
; Parameters ....: $sLibrary            - Path to a valid Steam Library
;                  $sDetails            - a Opt("GUIDataSeparatorChar") seperated list of details to get
; Return values .: Success - Returns an array of Steam game details
;                  Failure - Returns 0 and sets @error:
;                  |1 - Steam Library Empty
; Author ........: rcmaehl (Robert Maehl)
; Modified ......: 03/09/19
; Modified ......:
; Remarks .......: Steam manifests do not include the location of the executable
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SteamGetGamesDetailsFromLibrary($sLibrary, $sDetails)

	Local $aGames[1][2]

	$aDetails = StringSplit($sDetails, Opt("GUIDataSeparatorChar"), $STR_NOCOUNT)

	$aGames[0][0] = "0"

	Local $hSearch = FileFindFirstFile($sLibrary & "\steamapps\appmanifest_*.acf")

	ReDim $aGames[0][UBound($aDetails)]

	If $hSearch = -1 Then SetError(1,0,0)

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then Return $aGames

		ReDim $aGames[UBound($aGames) + 1][UBound($aDetails)]

		$hManifestFile = FileOpen($sLibrary & "\steamapps\" & $sFile)
		If $hManifestFile = -1 Then ContinueLoop

		Local $iLines = _FileCountLines($sLibrary & "\steamapps\" & $sFile)

		For $iLine = 1 to $iLines Step 1
			$sLine = FileReadLine($hManifestFile, $iLine)
			If @error = -1 Then ExitLoop
			$sLine = StringStripWS($sLine, $STR_STRIPLEADING)
			$sLine = StringRegExpReplace($sLine, '"\s*"', "?")
			$sLine = StringReplace($sLine, '"', "")
			$aLine = StringSplit($sLine, '?')

			For $iDetail = 0 To UBound($aDetails) - 1

				If $aLine[0] = 2 And $aLine[1] = $aDetails[$iDetail] Then
					$aGames[UBound($aGames) - 1][$iDetail] = $aLine[2]
				EndIf

			Next

		Next

		$aGames[0][0] = UBound($aGames) - 1

		FileClose($hManifestFile)

	WEnd

EndFunc