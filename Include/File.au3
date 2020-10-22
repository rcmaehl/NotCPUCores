#include-once

#include "Array.au3"
#include "FileConstants.au3"
#include "StringConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: File
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Functions that assist with files and directories.
; Author(s) .....: Brian Keene, Michael Michta, erifash, Jon, JdeB, Jeremy Landes, MrCreatoR, cdkid, Valik, Erik Pilsits, Kurt, Dale, guinness, DXRW4E, Melba23
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _FileCountLines
; _FileCreate
; _FileListToArray
; _FileListToArrayRec
; _FilePrint
; _FileReadToArray
; _FileWriteFromArray
; _FileWriteLog
; _FileWriteToLine
; _PathFull
; _PathGetRelative
; _PathMake
; _PathSplit
; _ReplaceStringInFile
; _TempFile
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __FLTAR_ListToMask
; __FLTAR_AddToList
; __FLTAR_AddFileLists
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Tylo <tylo at start dot no>
; Modified.......: Xenobiologist, Gary, guinness, DXRW4E
; ===============================================================================================================================
Func _FileCountLines($sFilePath)
	FileReadToArray($sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	Return @extended

	#cs
		Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
		If $hFileOpen = -1 Then Return SetError(1, 0, 0)

		Local $sFileRead = StringStripWS(FileRead($hFileOpen), $STR_STRIPTRAILING)
		FileClose($hFileOpen)
		Return UBound(StringRegExp($sFileRead, "\R", $STR_REGEXPARRAYGLOBALMATCH)) + 1 - Int($sFileRead = "")
	#ce
EndFunc   ;==>_FileCountLines

; #FUNCTION# ====================================================================================================================
; Author ........: Brian Keene <brian_keene at yahoo dot com>
; Modified.......:
; ===============================================================================================================================
Func _FileCreate($sFilePath)
	Local $hFileOpen = FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_CREATEPATH))
	If $hFileOpen = -1 Then Return SetError(1, 0, 0)

	Local $iFileWrite = FileWrite($hFileOpen, "")
	FileClose($hFileOpen)
	If Not $iFileWrite Then Return SetError(2, 0, 0)
	Return 1
EndFunc   ;==>_FileCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Michael Michta
; Modified.......: guinness - Added optional parameter to return the full path.
; ===============================================================================================================================
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
	Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""

	; Check parameters for the Default keyword or they meet a certain criteria
	$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\" ; Ensure a single trailing backslash
	If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
	If $bReturnPath Then $sFullPath = $sFilePath
	If $sFilter = Default Then $sFilter = "*"

	; Check if the directory exists
	If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
	If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)

	Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
	If @error Then Return SetError(4, 0, 0)
	While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If ($iFlag + @extended = 2) Then ContinueLoop
		$sFileList &= $sDelimiter & $sFullPath & $sFileName
	WEnd
	FileClose($hSearch)

	If $sFileList = "" Then Return SetError(4, 0, 0)
	Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc   ;==>_FileListToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23 - with credits for code snippets to Ultima, Partypooper, Spiff59, guinness, wraithdu
; Modified ......:
; ===============================================================================================================================
Func _FileListToArrayRec($sFilePath, $sMask = "*", $iReturn = $FLTAR_FILESFOLDERS, $iRecur = $FLTAR_NORECUR, $iSort = $FLTAR_NOSORT, $iReturnPath = $FLTAR_RELPATH)
	If Not FileExists($sFilePath) Then Return SetError(1, 1, "")

	; Check for Default keyword
	If $sMask = Default Then $sMask = "*"
	If $iReturn = Default Then $iReturn = $FLTAR_FILESFOLDERS
	If $iRecur = Default Then $iRecur = $FLTAR_NORECUR
	If $iSort = Default Then $iSort = $FLTAR_NOSORT
	If $iReturnPath = Default Then $iReturnPath = $FLTAR_RELPATH

	; Check for valid recur value
	If $iRecur > 1 Or Not IsInt($iRecur) Then Return SetError(1, 6, "")

	Local $bLongPath = False
	; Check for valid path
	If StringLeft($sFilePath, 4) == "\\?\" Then
		$bLongPath = True
	EndIf

	Local $sFolderSlash = ""
	; Check if folders should have trailing \ and ensure that initial path does have one
	If StringRight($sFilePath, 1) = "\" Then
		$sFolderSlash = "\"
	Else
		$sFilePath = $sFilePath & "\"
	EndIf

	Local $asFolderSearchList[100] = [1]
	; Add path to folder search list
	$asFolderSearchList[1] = $sFilePath

	Local $iHide_HS = 0, _
			$sHide_HS = ""
	; Check for H or S omitted
	If BitAND($iReturn, $FLTAR_NOHIDDEN) Then
		$iHide_HS += 2
		$sHide_HS &= "H"
		$iReturn -= $FLTAR_NOHIDDEN
	EndIf
	If BitAND($iReturn, $FLTAR_NOSYSTEM) Then
		$iHide_HS += 4
		$sHide_HS &= "S"
		$iReturn -= $FLTAR_NOSYSTEM
	EndIf

	Local $iHide_Link = 0
	; Check for link/junction omitted
	If BitAND($iReturn, $FLTAR_NOLINK) Then
		$iHide_Link = 0x400
		$iReturn -= $FLTAR_NOLINK
	EndIf

	Local $iMaxLevel = 0
	; If required, determine \ count for max recursive level setting
	If $iRecur < 0 Then
		StringReplace($sFilePath, "\", "", 0, $STR_NOCASESENSEBASIC)
		$iMaxLevel = @extended - $iRecur
	EndIf

	Local $sExclude_List = "", $sExclude_List_Folder = "", $sInclude_List = "*"
	; Check mask parameter
	Local $aMaskSplit = StringSplit($sMask, "|")
	; Check for multiple sections and set values
	Switch $aMaskSplit[0]
		Case 3
			$sExclude_List_Folder = $aMaskSplit[3]
			ContinueCase
		Case 2
			$sExclude_List = $aMaskSplit[2]
			ContinueCase
		Case 1
			$sInclude_List = $aMaskSplit[1]
	EndSwitch

	Local $sInclude_File_Mask = ".+"
	; Create Include mask for files
	If $sInclude_List <> "*" Then
		If Not __FLTAR_ListToMask($sInclude_File_Mask, $sInclude_List) Then Return SetError(1, 2, "")
	EndIf

	Local $sInclude_Folder_Mask = ".+"
	; Set Include mask for folders
	Switch $iReturn
		Case 0
			; Folders affected by mask if not recursive
			Switch $iRecur
				Case 0
					; Folders match mask for compatibility
					$sInclude_Folder_Mask = $sInclude_File_Mask
			EndSwitch
		Case 2
			; Folders affected by mask
			$sInclude_Folder_Mask = $sInclude_File_Mask
	EndSwitch

	Local $sExclude_File_Mask = ":"
	; Create Exclude List mask for files
	If $sExclude_List <> "" Then
		If Not __FLTAR_ListToMask($sExclude_File_Mask, $sExclude_List) Then Return SetError(1, 3, "")
	EndIf

	Local $sExclude_Folder_Mask = ":"
	; Create Exclude mask for folders
	If $iRecur Then
		If $sExclude_List_Folder Then
			If Not __FLTAR_ListToMask($sExclude_Folder_Mask, $sExclude_List_Folder) Then Return SetError(1, 4, "")
		EndIf
		; If folders only
		If $iReturn = 2 Then
			; Folders affected by normal mask
			$sExclude_Folder_Mask = $sExclude_File_Mask
		EndIf
	Else
		; Folders affected by normal mask
		$sExclude_Folder_Mask = $sExclude_File_Mask
	EndIf

	; Verify other parameters
	If Not ($iReturn = 0 Or $iReturn = 1 Or $iReturn = 2) Then Return SetError(1, 5, "")
	If Not ($iSort = 0 Or $iSort = 1 Or $iSort = 2) Then Return SetError(1, 7, "")
	If Not ($iReturnPath = 0 Or $iReturnPath = 1 Or $iReturnPath = 2) Then Return SetError(1, 8, "")

	; Prepare for DllCall if required
	If $iHide_Link Then
		Local $tFile_Data = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & _
				"dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
		Local $hDLL = DllOpen('kernel32.dll'), $aDLL_Ret
	EndIf

	Local $asReturnList[100] = [0]
	Local $asFileMatchList = $asReturnList, $asRootFileMatchList = $asReturnList, $asFolderMatchList = $asReturnList
	Local $bFolder = False, _
			$hSearch = 0, _
			$sCurrentPath = "", $sName = "", $sRetPath = ""
	Local $iAttribs = 0, _
			$sAttribs = ''
	Local $asFolderFileSectionList[100][2] = [[0, 0]]
	; Search within listed folders
	While $asFolderSearchList[0] > 0

		; Set path to search
		$sCurrentPath = $asFolderSearchList[$asFolderSearchList[0]]
		; Reduce folder search list count
		$asFolderSearchList[0] -= 1
		; Determine return path to add to file/folder name
		Switch $iReturnPath
			; Case 0 ; Name only
			; Leave as ""
			Case 1 ;Relative to initial path
				$sRetPath = StringReplace($sCurrentPath, $sFilePath, "")
			Case 2 ; Full path
				If $bLongPath Then
					$sRetPath = StringTrimLeft($sCurrentPath, 4)
				Else
					$sRetPath = $sCurrentPath
				EndIf
		EndSwitch

		; Get search handle - use code matched to required listing
		If $iHide_Link Then
			; Use DLL code
			$aDLL_Ret = DllCall($hDLL, 'handle', 'FindFirstFileW', 'wstr', $sCurrentPath & "*", 'struct*', $tFile_Data)
			If @error Or Not $aDLL_Ret[0] Then
				ContinueLoop
			EndIf
			$hSearch = $aDLL_Ret[0]
		Else
			; Use native code
			$hSearch = FileFindFirstFile($sCurrentPath & "*")
			; If folder empty move to next in list
			If $hSearch = -1 Then
				ContinueLoop
			EndIf
		EndIf

		; If sorting files and folders with paths then store folder name and position of associated files in list
		If $iReturn = 0 And $iSort And $iReturnPath Then
			__FLTAR_AddToList($asFolderFileSectionList, $sRetPath, $asFileMatchList[0] + 1)
		EndIf
		$sAttribs = ''

		; Search folder - use code matched to required listing
		While 1
			; Use DLL code
			If $iHide_Link Then
				; Use DLL code
				$aDLL_Ret = DllCall($hDLL, 'int', 'FindNextFileW', 'handle', $hSearch, 'struct*', $tFile_Data)
				; Check for end of folder
				If @error Or Not $aDLL_Ret[0] Then
					ExitLoop
				EndIf
				; Extract data
				$sName = DllStructGetData($tFile_Data, "FileName")
				; Check for .. return - only returned by the DllCall
				If $sName = ".." Then
					ContinueLoop
				EndIf
				$iAttribs = DllStructGetData($tFile_Data, "FileAttributes")
				; Check for hidden/system attributes and skip if found
				If $iHide_HS And BitAND($iAttribs, $iHide_HS) Then
					ContinueLoop
				EndIf
				; Check for link attribute and skip if found
				If BitAND($iAttribs, $iHide_Link) Then
					ContinueLoop
				EndIf
				; Set subfolder flag
				$bFolder = False
				If BitAND($iAttribs, 16) Then
					$bFolder = True
				EndIf
			Else
				; Reset folder flag
				$bFolder = False
				; Use native code
				$sName = FileFindNextFile($hSearch, 1)
				; Check for end of folder
				If @error Then
					ExitLoop
				EndIf
				$sAttribs = @extended
				; Check for folder
				If StringInStr($sAttribs, "D") Then
					$bFolder = True
				EndIf
				; Check for Hidden/System
				If StringRegExp($sAttribs, "[" & $sHide_HS & "]") Then
					ContinueLoop
				EndIf
			EndIf

			; If folder then check whether to add to search list
			If $bFolder Then
				Select
					Case $iRecur < 0 ; Check recur depth
						StringReplace($sCurrentPath, "\", "", 0, $STR_NOCASESENSEBASIC)
						If @extended < $iMaxLevel Then
							ContinueCase ; Check if matched to masks
						EndIf
					Case $iRecur = 1 ; Full recur
						If Not StringRegExp($sName, $sExclude_Folder_Mask) Then ; Add folder unless excluded
							__FLTAR_AddToList($asFolderSearchList, $sCurrentPath & $sName & "\")
						EndIf
						; Case $iRecur = 0 ; Never add
						; Do nothing
				EndSelect
			EndIf

			If $iSort Then ; Save in relevant folders for later sorting
				If $bFolder Then
					If StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
						__FLTAR_AddToList($asFolderMatchList, $sRetPath & $sName & $sFolderSlash)
					EndIf
				Else
					If StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
						; Select required list for files
						If $sCurrentPath = $sFilePath Then
							__FLTAR_AddToList($asRootFileMatchList, $sRetPath & $sName)
						Else
							__FLTAR_AddToList($asFileMatchList, $sRetPath & $sName)
						EndIf
					EndIf
				EndIf
			Else ; Save directly in return list
				If $bFolder Then
					If $iReturn <> 1 And StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
						__FLTAR_AddToList($asReturnList, $sRetPath & $sName & $sFolderSlash)
					EndIf
				Else
					If $iReturn <> 2 And StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
						__FLTAR_AddToList($asReturnList, $sRetPath & $sName)
					EndIf
				EndIf
			EndIf

		WEnd

		; Close current search
		If $iHide_Link Then
			DllCall($hDLL, 'int', 'FindClose', 'ptr', $hSearch)
		Else
			FileClose($hSearch)
		EndIf

	WEnd

	; Close the DLL if needed
	If $iHide_Link Then
		DllClose($hDLL)
	EndIf

	; Sort results if required
	If $iSort Then
		Switch $iReturn
			Case 2 ; Folders only
				; Check if any folders found
				If $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
				; Correctly size folder match list
				ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
				; Copy size folder match array
				$asReturnList = $asFolderMatchList
				; Simple sort list
				__ArrayDualPivotSort($asReturnList, 1, $asReturnList[0])
			Case 1 ; Files only
				; Check if any files found
				If $asRootFileMatchList[0] = 0 And $asFileMatchList[0] = 0 Then Return SetError(1, 9, "")
				If $iReturnPath = 0 Then ; names only so simple sort suffices
					; Combine file match lists
					__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
					; Simple sort combined file list
					__ArrayDualPivotSort($asReturnList, 1, $asReturnList[0])
				Else
					; Combine sorted file match lists
					__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList, 1)
				EndIf
			Case 0 ; Both files and folders
				; Check if any root files or folders found
				If $asRootFileMatchList[0] = 0 And $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
				If $iReturnPath = 0 Then ; names only so simple sort suffices
					; Combine file match lists
					__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
					; Set correct count for folder add
					$asReturnList[0] += $asFolderMatchList[0]
					; Resize and add file match array
					ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
					_ArrayConcatenate($asReturnList, $asFolderMatchList, 1)
					; Simple sort final list
					__ArrayDualPivotSort($asReturnList, 1, $asReturnList[0])
				Else
					; Size return list
					Local $asReturnList[$asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0] + 1]
					$asReturnList[0] = $asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0]
					; Sort root file list
					__ArrayDualPivotSort($asRootFileMatchList, 1, $asRootFileMatchList[0])
					; Add the sorted root files at the top
					For $i = 1 To $asRootFileMatchList[0]
						$asReturnList[$i] = $asRootFileMatchList[$i]
					Next
					; Set next insertion index
					Local $iNextInsertionIndex = $asRootFileMatchList[0] + 1
					; Sort folder list
					__ArrayDualPivotSort($asFolderMatchList, 1, $asFolderMatchList[0])
					Local $sFolderToFind = ""
					; Work through folder list
					For $i = 1 To $asFolderMatchList[0]
						; Add folder to return list
						$asReturnList[$iNextInsertionIndex] = $asFolderMatchList[$i]
						$iNextInsertionIndex += 1
						; Format folder name for search
						If $sFolderSlash Then
							$sFolderToFind = $asFolderMatchList[$i]
						Else
							$sFolderToFind = $asFolderMatchList[$i] & "\"
						EndIf
						Local $iFileSectionEndIndex = 0, $iFileSectionStartIndex = 0
						; Find folder in FolderFileSectionList
						For $j = 1 To $asFolderFileSectionList[0][0]
							; If found then deal with files
							If $sFolderToFind = $asFolderFileSectionList[$j][0] Then
								; Set file list indexes
								$iFileSectionStartIndex = $asFolderFileSectionList[$j][1]
								If $j = $asFolderFileSectionList[0][0] Then
									$iFileSectionEndIndex = $asFileMatchList[0]
								Else
									$iFileSectionEndIndex = $asFolderFileSectionList[$j + 1][1] - 1
								EndIf
								; Sort files if required
								If $iSort = 1 Then
									__ArrayDualPivotSort($asFileMatchList, $iFileSectionStartIndex, $iFileSectionEndIndex)
								EndIf
								; Add files to return list
								For $k = $iFileSectionStartIndex To $iFileSectionEndIndex
									$asReturnList[$iNextInsertionIndex] = $asFileMatchList[$k]
									$iNextInsertionIndex += 1
								Next
								ExitLoop
							EndIf
						Next
					Next
				EndIf
		EndSwitch
	Else ; No sort
		; Check if any file/folders have been added
		If $asReturnList[0] = 0 Then Return SetError(1, 9, "")
		; Remove any unused return list elements from last ReDim
		ReDim $asReturnList[$asReturnList[0] + 1]

	EndIf

	Return $asReturnList
EndFunc   ;==>_FileListToArrayRec

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_AddFileLists
; Description ...: Add internal lists after resizing and optional sorting
; Syntax ........: __FLTAR_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2[, $iSort = 0])
; Parameters ....: $asReturnList - Base list
;                  $asRootFileMatchList - First list to add
;                  $asFileMatchList - Second list to add
;                  $iSort - (Optional) Whether to sort lists before adding
;                  |$iSort = 0 (Default) No sort
;                  |$iSort = 1 Sort in descending alphabetical order
; Return values .: None - array modified ByRef
; Author ........: Melba23
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2, $iSort = 0)
	; Correctly size root file match array
	ReDim $asSource_1[$asSource_1[0] + 1]
	; Simple sort root file match array if required
	If $iSort = 1 Then __ArrayDualPivotSort($asSource_1, 1, $asSource_1[0])
	; Copy root file match array
	$asTarget = $asSource_1
	; Add file match count
	$asTarget[0] += $asSource_2[0]
	; Correctly size file match array
	ReDim $asSource_2[$asSource_2[0] + 1]
	; Simple sort file match array if required
	If $iSort = 1 Then __ArrayDualPivotSort($asSource_2, 1, $asSource_2[0])
	; Add file match array
	_ArrayConcatenate($asTarget, $asSource_2, 1)
EndFunc   ;==>__FLTAR_AddFileLists

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_AddToList
; Description ...: Add element to [?] or [?][2] list which is resized if necessary
; Syntax ........: __FLTAR_AddToList(ByRef $asList, $vValue_0, [$vValue_1])
; Parameters ....: $aList - List to be added to
;                  $vValue_0 - Value to add to array  - if $vValue_1 exists value added to [?][0] element in [?][2] array
;                  $vValue_1 - Value to add to [?][1] element in [?][2] array (optional)
; Return values .: None - array modified ByRef
; Author ........: Melba23
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_AddToList(ByRef $aList, $vValue_0, $vValue_1 = -1)
	If $vValue_1 = -1 Then ; [?] array
		; Increase list count
		$aList[0] += 1
		; Double list size if too small (fewer ReDim needed)
		If UBound($aList) <= $aList[0] Then ReDim $aList[UBound($aList) * 2]
		; Add value
		$aList[$aList[0]] = $vValue_0
	Else ; [?][2] array
		$aList[0][0] += 1
		If UBound($aList) <= $aList[0][0] Then ReDim $aList[UBound($aList) * 2][2]
		$aList[$aList[0][0]][0] = $vValue_0
		$aList[$aList[0][0]][1] = $vValue_1
	EndIf
EndFunc   ;==>__FLTAR_AddToList

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __FLTAR_ListToMask
; Description ...: Convert include/exclude lists to SRE format
; Syntax ........: __FLTAR_ListToMask(ByRef $sMask, $sList)
; Parameters ....: $asMask - Include/Exclude mask to create
;                  $asList - Include/Exclude list to convert
; Return values .: Success: 1
;                  Failure: 0
; Author ........: SRE patterns developed from those posted by various forum members and Spiff59 in particular
; Remarks .......: This function is used internally by _FileListToArrayRec
; ===============================================================================================================================
Func __FLTAR_ListToMask(ByRef $sMask, $sList)
	; Check for invalid characters within list
	If StringRegExp($sList, "\\|/|:|\<|\>|\|") Then Return 0
	; Strip WS and insert | for ;
	$sList = StringReplace(StringStripWS(StringRegExpReplace($sList, "\s*;\s*", ";"), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)), ";", "|")
	; Convert to SRE pattern
	$sList = StringReplace(StringReplace(StringRegExpReplace($sList, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
	; Add prefix and suffix
	$sMask = "(?i)^(" & $sList & ")\z"
	Return 1
EndFunc   ;==>__FLTAR_ListToMask

; #FUNCTION# ====================================================================================================================
; Author ........: erifash <erifash [at] gmail [dot] com>
; Modified.......: guinness - Use the native ShellExecute function.
; ===============================================================================================================================
Func _FilePrint($sFilePath, $iShow = @SW_HIDE)
	Return ShellExecute($sFilePath, "", @WorkingDir, "print", $iShow = Default ? @SW_HIDE : $iShow)
EndFunc   ;==>_FilePrint

; #FUNCTION# ====================================================================================================================
; Author ........: Jonathan Bennett <jon at autoitscript dot com>, Valik - Support Windows Unix and Mac line separator
; Modified ......: Jpm - fixed empty line at the end, Gary Fixed file contains only 1 line, guinness - Optional flag to return the array count.
;                : Melba23 - Read to 1D/2D arrays, guinness & jchd - Removed looping through 1D array with $FRTA_COUNT flag.
; ===============================================================================================================================
Func _FileReadToArray($sFilePath, ByRef $vReturn, $iFlags = $FRTA_COUNT, $sDelimiter = "")
	; Clear the previous contents
	$vReturn = 0

	If $iFlags = Default Then $iFlags = $FRTA_COUNT
	If $sDelimiter = Default Then $sDelimiter = ""

	; Set "array of arrays" flag
	Local $bExpand = True
	If BitAND($iFlags, $FRTA_INTARRAYS) Then
		$bExpand = False
		$iFlags -= $FRTA_INTARRAYS
	EndIf
	; Set delimiter flag
	Local $iEntire = $STR_CHRSPLIT
	If BitAND($iFlags, $FRTA_ENTIRESPLIT) Then
		$iEntire = $STR_ENTIRESPLIT
		$iFlags -= $FRTA_ENTIRESPLIT
	EndIf
	; Set row count and split count flags
	Local $iNoCount = 0
	If $iFlags <> $FRTA_COUNT Then
		$iFlags = $FRTA_NOCOUNT
		$iNoCount = $STR_NOCOUNT
	EndIf

	; Check delimiter
	If $sDelimiter Then
		; Read file into an array
		Local $aLines = FileReadToArray($sFilePath)
		If @error Then Return SetError(@error, 0, 0)

		; Get first dimension and add count if required
		Local $iDim_1 = UBound($aLines) + $iFlags
		; Check type of return array
		If $bExpand Then ; All lines have same number of fields
			; Count fields in first line
			Local $iDim_2 = UBound(StringSplit($aLines[0], $sDelimiter, $iEntire + $STR_NOCOUNT))
			; Size array
			Local $aTemp_Array[$iDim_1][$iDim_2]
			; Declare the variables
			Local $iFields, _
					$aSplit
			; Loop through the lines
			For $i = 0 To $iDim_1 - $iFlags - 1
				; Split each line as required
				$aSplit = StringSplit($aLines[$i], $sDelimiter, $iEntire + $STR_NOCOUNT)
				; Count the items
				$iFields = UBound($aSplit)
				If $iFields <> $iDim_2 Then
					; Return error
					Return SetError(3, 0, 0)
				EndIf
				; Fill this line of the array
				For $j = 0 To $iFields - 1
					$aTemp_Array[$i + $iFlags][$j] = $aSplit[$j]
				Next
			Next
			; Check at least 2 columns
			If $iDim_2 < 2 Then Return SetError(4, 0, 0)
			; Set dimension count
			If $iFlags Then
				$aTemp_Array[0][0] = $iDim_1 - $iFlags
				$aTemp_Array[0][1] = $iDim_2
			EndIf
		Else ; Create "array of arrays"
			; Size array
			Local $aTemp_Array[$iDim_1]
			; Loop through the lines
			For $i = 0 To $iDim_1 - $iFlags - 1
				; Split each line as required
				$aTemp_Array[$i + $iFlags] = StringSplit($aLines[$i], $sDelimiter, $iEntire + $iNoCount)
			Next
			; Set dimension count
			If $iFlags Then
				$aTemp_Array[0] = $iDim_1 - $iFlags
			EndIf
		EndIf
		; Return the array
		$vReturn = $aTemp_Array
	Else ; 1D
		If $iFlags Then
			Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
			If $hFileOpen = -1 Then Return SetError(1, 0, 0)
			Local $sFileRead = FileRead($hFileOpen)
			FileClose($hFileOpen)

			If StringLen($sFileRead) Then
				$vReturn = StringRegExp(@LF & $sFileRead, "(?|(\N+)\z|(\N*)(?:\R))", $STR_REGEXPARRAYGLOBALMATCH)
				$vReturn[0] = UBound($vReturn) - 1
			Else
				Return SetError(2, 0, 0)
			EndIf
		Else
			$vReturn = FileReadToArray($sFilePath)
			If @error Then
				$vReturn = 0
				Return SetError(@error, 0, 0)
			EndIf
		EndIf

	EndIf
	Return 1
EndFunc   ;==>_FileReadToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Updated for file handles by PsaltyDS, @error = 4 msg and 2-dimension capability added by Spiff59 and fixed by guinness.
; ===============================================================================================================================
Func _FileWriteFromArray($sFilePath, Const ByRef $aArray, $iBase = Default, $iUBound = Default, $sDelimiter = "|")
	Local $iReturn = 0
	; Check if we have a valid array as an input.
	If Not IsArray($aArray) Then Return SetError(2, 0, $iReturn)

	; Check the number of dimensions is no greater than a 2d array.
	Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS)
	If $iDims > 2 Then Return SetError(4, 0, 0)

	; Determine last entry of the array.
	Local $iLast = UBound($aArray) - 1
	If $iUBound = Default Or $iUBound > $iLast Then $iUBound = $iLast
	If $iBase < 0 Or $iBase = Default Then $iBase = 0
	If $iBase > $iUBound Then Return SetError(5, 0, $iReturn)
	If $sDelimiter = Default Then $sDelimiter = "|"

	; Open output file for overwrite by default, or use input file handle if passed.
	Local $hFileOpen = $sFilePath
	If IsString($sFilePath) Then
		$hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)
		If $hFileOpen = -1 Then Return SetError(1, 0, $iReturn)
	EndIf

	; Write array data to file.
	Local $iError = 0
	$iReturn = 1 ; Set the return value to true.
	Switch $iDims
		Case 1
			For $i = $iBase To $iUBound
				If Not FileWrite($hFileOpen, $aArray[$i] & @CRLF) Then
					$iError = 3
					$iReturn = 0
					ExitLoop
				EndIf
			Next
		Case 2
			Local $sTemp = ""
			For $i = $iBase To $iUBound
				$sTemp = $aArray[$i][0]
				For $j = 1 To UBound($aArray, $UBOUND_COLUMNS) - 1
					$sTemp &= $sDelimiter & $aArray[$i][$j]
				Next
				If Not FileWrite($hFileOpen, $sTemp & @CRLF) Then
					$iError = 3
					$iReturn = 0
					ExitLoop
				EndIf
			Next
	EndSwitch

	; Close file only if specified by a string path.
	If IsString($sFilePath) Then FileClose($hFileOpen)

	; Return the results.
	Return SetError($iError, 0, $iReturn)
EndFunc   ;==>_FileWriteFromArray

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......: MrCreatoR - added $iFlag parameter
; ===============================================================================================================================
Func _FileWriteLog($sLogPath, $sLogMsg, $iFlag = -1)
	Local $iOpenMode = $FO_APPEND
	Local $sMsg = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " : " & $sLogMsg

	If $iFlag = Default Then $iFlag = -1
	If $iFlag <> -1 Then
		$iOpenMode = $FO_OVERWRITE
		$sMsg &= @CRLF & FileRead($sLogPath)
	EndIf

	; Open output file for appending to the end/overwriting, or use input file handle if passed
	Local $hFileOpen = $sLogPath
	If IsString($sLogPath) Then $hFileOpen = FileOpen($sLogPath, $iOpenMode)
	If $hFileOpen = -1 Then Return SetError(1, 0, 0)

	Local $iReturn = FileWriteLine($hFileOpen, $sMsg)

	; Close file only if specified by a string path
	If IsString($sLogPath) Then $iReturn = FileClose($hFileOpen)
	If $iReturn <= 0 Then Return SetError(2, $iReturn, 0)

	Return $iReturn
EndFunc   ;==>_FileWriteLog

; #FUNCTION# ====================================================================================================================
; Author ........: cdkid
; Modified.......: partypooper, MrCreatoR, Melba23
; ===============================================================================================================================
Func _FileWriteToLine($sFilePath, $iLine, $sText, $bOverWrite = False, $bFill = False)
	If $bOverWrite = Default Then $bOverWrite = False
	If $bFill = Default Then $bFill = False
	If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)
	If $iLine <= 0 Then Return SetError(4, 0, 0)
	If Not (IsBool($bOverWrite) Or $bOverWrite = 0 Or $bOverWrite = 1) Then Return SetError(5, 0, 0)
	If Not IsString($sText) Then
		$sText = String($sText)
		If $sText = "" Then Return SetError(6, 0, 0)
	EndIf
	If Not IsBool($bFill) Then Return SetError(7, 0, 0)
	; Read current file into array
	Local $aArray = FileReadToArray($sFilePath)
	; Create empty array if empty file
	If @error Then Local $aArray[0]
	Local $iUBound = UBound($aArray) - 1
	; If Fill option set
	If $bFill Then
		; If required resize array to allow line to be written
		If $iUBound < $iLine Then
			ReDim $aArray[$iLine]
			$iUBound = $iLine - 1
		EndIf
	Else
		If ($iUBound + 1) < $iLine Then Return SetError(1, 0, 0)
	EndIf
	; Write specific line - array is 0-based so reduce by 1 - and either replace or insert
	$aArray[$iLine - 1] = ($bOverWrite ? $sText : $sText & @CRLF & $aArray[$iLine - 1])
	; Concatenate array elements
	Local $sData = ""
	For $i = 0 To $iUBound
		$sData &= $aArray[$i] & @CRLF
	Next
	$sData = StringTrimRight($sData, StringLen(@CRLF)) ; Required to strip trailing EOL
	; Write data to file
	Local $hFileOpen = FileOpen($sFilePath, FileGetEncoding($sFilePath) + $FO_OVERWRITE)
	If $hFileOpen = -1 Then Return SetError(3, 0, 0)
	FileWrite($hFileOpen, $sData)
	FileClose($hFileOpen)
	Return 1
EndFunc   ;==>_FileWriteToLine

; #FUNCTION# ====================================================================================================================
; Author ........: Valik (Original function and modification to rewrite), tittoproject (Rewrite)
; Modified.......:
; ===============================================================================================================================
Func _PathFull($sRelativePath, $sBasePath = @WorkingDir)
	If Not $sRelativePath Or $sRelativePath = "." Then Return $sBasePath

	; Normalize slash direction.
	Local $sFullPath = StringReplace($sRelativePath, "/", "\") ; Holds the full path (later, minus the root)
	Local Const $sFullPathConst = $sFullPath ; Holds a constant version of the full path.
	Local $sPath ; Holds the root drive/server
	Local $bRootOnly = StringLeft($sFullPath, 1) = "\" And StringMid($sFullPath, 2, 1) <> "\"

	If $sBasePath = Default Then $sBasePath = @WorkingDir

	; Check for UNC paths or local drives.  We run this twice at most.  The
	; first time, we check if the relative path is absolute.  If it's not, then
	; we use the base path which should be absolute.
	For $i = 1 To 2
		$sPath = StringLeft($sFullPath, 2)
		If $sPath = "\\" Then
			$sFullPath = StringTrimLeft($sFullPath, 2)
			Local $nServerLen = StringInStr($sFullPath, "\") - 1
			$sPath = "\\" & StringLeft($sFullPath, $nServerLen)
			$sFullPath = StringTrimLeft($sFullPath, $nServerLen)
			ExitLoop
		ElseIf StringRight($sPath, 1) = ":" Then
			$sFullPath = StringTrimLeft($sFullPath, 2)
			ExitLoop
		Else
			$sFullPath = $sBasePath & "\" & $sFullPath
		EndIf
	Next

	; If this happens, we've found a funky path and don't know what to do
	; except for get out as fast as possible.  We've also screwed up our
	; variables so we definitely need to quit.
	; If $i = 3 Then Return ""

	; A path with a drive but no slash (e.g. C:Path\To\File) has the following
	; behavior.  If the relative drive is the same as the $BasePath drive then
	; insert the base path.  If the drives differ then just insert a leading
	; slash to make the path valid.
	If StringLeft($sFullPath, 1) <> "\" Then
		If StringLeft($sFullPathConst, 2) = StringLeft($sBasePath, 2) Then
			$sFullPath = $sBasePath & "\" & $sFullPath
		Else
			$sFullPath = "\" & $sFullPath
		EndIf
	EndIf

	; Build an array of the path parts we want to use.
	Local $aTemp = StringSplit($sFullPath, "\")
	Local $aPathParts[$aTemp[0]], $j = 0
	For $i = 2 To $aTemp[0]
		If $aTemp[$i] = ".." Then
			If $j Then $j -= 1
		ElseIf Not ($aTemp[$i] = "" And $i <> $aTemp[0]) And $aTemp[$i] <> "." Then
			$aPathParts[$j] = $aTemp[$i]
			$j += 1
		EndIf
	Next

	; Here we re-build the path from the parts above.  We skip the
	; loop if we are only returning the root.
	$sFullPath = $sPath
	If Not $bRootOnly Then
		For $i = 0 To $j - 1
			$sFullPath &= "\" & $aPathParts[$i]
		Next
	Else
		$sFullPath &= $sFullPathConst
		; If we detect more relative parts, remove them by calling ourself recursively.
		If StringInStr($sFullPath, "..") Then $sFullPath = _PathFull($sFullPath)
	EndIf

	; Clean up the path.
	Do
		$sFullPath = StringReplace($sFullPath, ".\", "\")
	Until @extended = 0
	Return $sFullPath
EndFunc   ;==>_PathFull

; #FUNCTION# ====================================================================================================================
; Author ........: Erik Pilsits
; Modified.......:
; ===============================================================================================================================
Func _PathGetRelative($sFrom, $sTo)
	If StringRight($sFrom, 1) <> "\" Then $sFrom &= "\" ; add missing trailing \ to $sFrom path
	If StringRight($sTo, 1) <> "\" Then $sTo &= "\" ; add trailing \ to $sTo
	If $sFrom = $sTo Then Return SetError(1, 0, StringTrimRight($sTo, 1)) ; $sFrom equals $sTo
	Local $asFrom = StringSplit($sFrom, "\")
	Local $asTo = StringSplit($sTo, "\")
	If $asFrom[1] <> $asTo[1] Then Return SetError(2, 0, StringTrimRight($sTo, 1)) ; drives are different, rel path not possible
	; create rel path
	Local $i = 2
	Local $iDiff = 1
	While 1
		If $asFrom[$i] <> $asTo[$i] Then
			$iDiff = $i
			ExitLoop
		EndIf
		$i += 1
	WEnd
	$i = 1
	Local $sRelPath = ""
	For $j = 1 To $asTo[0]
		If $i >= $iDiff Then
			$sRelPath &= "\" & $asTo[$i]
		EndIf
		$i += 1
	Next
	$sRelPath = StringTrimLeft($sRelPath, 1)
	$i = 1
	For $j = 1 To $asFrom[0]
		If $i > $iDiff Then
			$sRelPath = "..\" & $sRelPath
		EndIf
		$i += 1
	Next
	If StringRight($sRelPath, 1) == "\" Then $sRelPath = StringTrimRight($sRelPath, 1) ; remove trailing \
	Return $sRelPath
EndFunc   ;==>_PathGetRelative

; #FUNCTION# ====================================================================================================================
; Author ........: Valik
; Modified.......: guinness
; ===============================================================================================================================
Func _PathMake($sDrive, $sDir, $sFileName, $sExtension)
	; Format $sDrive, if it's not a UNC server name, then just get the drive letter and add a colon
	If StringLen($sDrive) Then
		If Not (StringLeft($sDrive, 2) = "\\") Then $sDrive = StringLeft($sDrive, 1) & ":"
	EndIf

	; Format the directory by adding any necessary slashes
	If StringLen($sDir) Then
		If Not (StringRight($sDir, 1) = "\") And Not (StringRight($sDir, 1) = "/") Then $sDir = $sDir & "\"
	Else
		$sDir = "\"
	EndIf

	If StringLen($sDir) Then
		; Append a backslash to the start of the directory if required
		If Not (StringLeft($sDir, 1) = "\") And Not (StringLeft($sDir, 1) = "/") Then $sDir = "\" & $sDir
	EndIf

	; Nothing to be done for the filename

	; Add the period to the extension if necessary
	If StringLen($sExtension) Then
		If Not (StringLeft($sExtension, 1) = ".") Then $sExtension = "." & $sExtension
	EndIf

	Return $sDrive & $sDir & $sFileName & $sExtension
EndFunc   ;==>_PathMake

; #FUNCTION# ====================================================================================================================
; Author ........: Valik
; Modified.......: DXRW4E - Re-wrote to use a regular expression; guinness - Update syntax and structure.
; ===============================================================================================================================
Func _PathSplit($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sFileName, ByRef $sExtension)
	Local $aArray = StringRegExp($sFilePath, "^\h*((?:\\\\\?\\)*(\\\\[^\?\/\\]+|[A-Za-z]:)?(.*[\/\\]\h*)?((?:[^\.\/\\]|(?(?=\.[^\/\\]*\.)\.))*)?([^\/\\]*))$", $STR_REGEXPARRAYMATCH)
	If @error Then ; This error should never happen.
		ReDim $aArray[5]
		$aArray[$PATH_ORIGINAL] = $sFilePath
	EndIf
	$sDrive = $aArray[$PATH_DRIVE]
	If StringLeft($aArray[$PATH_DIRECTORY], 1) == "/" Then
		$sDir = StringRegExpReplace($aArray[$PATH_DIRECTORY], "\h*[\/\\]+\h*", "\/")
	Else
		$sDir = StringRegExpReplace($aArray[$PATH_DIRECTORY], "\h*[\/\\]+\h*", "\\")
	EndIf
	$aArray[$PATH_DIRECTORY] = $sDir
	$sFileName = $aArray[$PATH_FILENAME]
	$sExtension = $aArray[$PATH_EXTENSION]

	Return $aArray
EndFunc   ;==>_PathSplit

; #FUNCTION# ====================================================================================================================
; Author ........: Kurt (aka /dev/null) and JdeB
; Modified ......: guinness - Re-wrote the function entirely for improvements in readability.
; ===============================================================================================================================
Func _ReplaceStringInFile($sFilePath, $sSearchString, $sReplaceString, $iCaseSensitive = 0, $iOccurance = 1)
	If StringInStr(FileGetAttrib($sFilePath), "R") Then Return SetError(1, 0, -1)

	; Open the file for reading.
	Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
	If $hFileOpen = -1 Then Return SetError(2, 0, -1)

	; Read the contents of the file and stores in a variable
	Local $sFileRead = FileRead($hFileOpen)
	FileClose($hFileOpen) ; Close the open file after reading

	; Set the default parameters
	If $iCaseSensitive = Default Then $iCaseSensitive = 0
	If $iOccurance = Default Then $iOccurance = 1

	; Replace strings
	$sFileRead = StringReplace($sFileRead, $sSearchString, $sReplaceString, 1 - $iOccurance, $iCaseSensitive)
	Local $iReturn = @extended

	; If there are replacements then overwrite the file
	If $iReturn Then
		; Retrieve the file encoding
		Local $iFileEncoding = FileGetEncoding($sFilePath)

		; Open the file for writing and set the overwrite flag
		$hFileOpen = FileOpen($sFilePath, $iFileEncoding + $FO_OVERWRITE)
		If $hFileOpen = -1 Then Return SetError(3, 0, -1)

		; Write to the open file
		FileWrite($hFileOpen, $sFileRead)
		FileClose($hFileOpen) ; Close the open file after writing
	EndIf
	Return $iReturn
EndFunc   ;==>_ReplaceStringInFile

; #FUNCTION# ====================================================================================================================
; Author ........: Dale (Klaatu) Thompson
; Modified.......: Hans Harder - Added Optional parameters, guinness - Fixed using non-supported characters in the file prefix.
; ===============================================================================================================================
Func _TempFile($sDirectoryName = @TempDir, $sFilePrefix = "~", $sFileExtension = ".tmp", $iRandomLength = 7)
	; Check parameters for the Default keyword or they meet a certain criteria
	If $iRandomLength = Default Or $iRandomLength <= 0 Then $iRandomLength = 7
	If $sDirectoryName = Default Or (Not FileExists($sDirectoryName)) Then $sDirectoryName = @TempDir
	If $sFileExtension = Default Then $sFileExtension = ".tmp"
	If $sFilePrefix = Default Then $sFilePrefix = "~"

	; Check if the directory exists or use the current script directory
	If Not FileExists($sDirectoryName) Then $sDirectoryName = @ScriptDir

	; Remove the appending backslash
	$sDirectoryName = StringRegExpReplace($sDirectoryName, "[\\/]+$", "")
	; Remove the initial dot (.) from the file extension
	$sFileExtension = StringRegExpReplace($sFileExtension, "^\.+", "")
	; Remove any non-supported characters in the file prefix
	$sFilePrefix = StringRegExpReplace($sFilePrefix, '[\\/:*?"<>|]', "")

	; Create the temporary file path without writing to the selected directory
	Local $sTempName = ""
	Do
		; Create a random filename
		$sTempName = ""
		While StringLen($sTempName) < $iRandomLength
			$sTempName &= Chr(Random(97, 122, 1))
		WEnd
		; Temporary filepath
		$sTempName = $sDirectoryName & "\" & $sFilePrefix & $sTempName & "." & $sFileExtension
	Until Not FileExists($sTempName) ; Exit the loop if no file with the same name is present
	Return $sTempName
EndFunc   ;==>_TempFile
