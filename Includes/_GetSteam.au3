#include <File.au3>
#include <StringConstants.au3>

Func _GetSteamLibraries()

	Local $aLibraries[1]

	$aLibraries[0] = 0

	Local $SteamDir = RegRead("HKEY_CURRENT_USER\Software\Valve\Steam", "SteamPath")
	If @error Then
		Return 1
	Else
		$SteamDir = StringReplace($SteamDir, "/", "\")
	EndIf

	If FileExists($SteamDir & "\steamapps\libraryfolders.vdf") Then
		$hLibraryFile = FileOpen($SteamDir & "\steamapps\libraryfolders.vdf")
		If @error Then Return 1
	Else
		Return 1
	EndIf

	Local $iLines = _FileCountLines($SteamDir & "\steamapps\libraryfolders.vdf")

	For $iLine = 1 to $iLines Step 1
		$sLine = FileReadLine($hLibraryFile, $iLine)
		If @error = -1 Then ExitLoop
		$sLine = StringStripWS($sLine, $STR_STRIPALL)
		$sLine = StringReplace($sLine, '""', '?')
		$sLine = StringReplace($sLine, '"', "")
		$sLine = StringReplace($sLine, "\\", "\")
		$aLine = StringSplit($sLine, '?')

		If $aLine[0] = 2 And IsNumber($aLine[1]) Then ; TO DO, Fix IsNumber($aLine[1])
			ReDim $aLibraries[$aLine[1] + 1]
			$aLibraries[1] = UBound($aLibraries - 1)
			$aLibraries[$aLine[1]] = $aLine[2]
		EndIf
	Next

	Return $aLibraries

EndFunc

_ArrayDisplay(_GetSteamLibraries())