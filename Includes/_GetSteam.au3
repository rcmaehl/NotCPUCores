#include-once
#include <File.au3>
#include <StringConstants.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _JSONtoArray
; Description ...: Convert Steam App ID JSON file to an Array
; Syntax ........: _JSONtoArray($hFile)
; Parameters ....: $hFile               - Steam JSON File
; Return values .: None
; Author ........: Robert C. Maehl (rcmaehl)
; Modified ......: 01/22/18
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _JSONtoArray($hFile)

	If Not FileExists($hFile) Then SetError(1,0,0)

	Local $aJSON[1]

	Return $aJSON

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
; Modified ......: 1/22/19
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GetSteamLibraries($hPath = "None")

	Local $aLibraries[1]

	$aLibraries[0] = 0

	If $hPath = "None" Then
		Local $hSteamDir = RegRead("HKEY_CURRENT_USER\Software\Valve\Steam", "SteamPath")
		If @error Then
			SetError(1,0,0)
		Else
			$hSteamDir = StringReplace($hSteamDir, "/", "\")
		EndIf
	Else
		If FileExists($hPath) Then
			Local $hSteamDir = $hPath
		Else
			SetError(1,1,0)
		EndIf
	EndIf

	If FileExists($hSteamDir & "\steamapps\libraryfolders.vdf") Then
		$hLibraryFile = FileOpen($hSteamDir & "\steamapps\libraryfolders.vdf")
		If @error Then SetError(2,0,0)
	Else
		SetError(2,1,0)
	EndIf

	Local $iLines = _FileCountLines($hSteamDir & "\steamapps\libraryfolders.vdf")

	For $iLine = 1 to $iLines Step 1
		$sLine = FileReadLine($hLibraryFile, $iLine)
		If @error = -1 Then ExitLoop
		$sLine = StringStripWS($sLine, $STR_STRIPALL)
		$sLine = StringReplace($sLine, '""', '?')
		$sLine = StringReplace($sLine, '"', "")
		$sLine = StringReplace($sLine, "\\", "\")
		$aLine = StringSplit($sLine, '?')

		If $aLine[0] = 2 And StringIsInt($aLine[1]) Then
			ReDim $aLibraries[$aLine[1] + 1]
			$aLibraries[1] = UBound($aLibraries) - 1
			$aLibraries[$aLine[1]] = $aLine[2]
		EndIf
	Next

	Return $aLibraries

EndFunc