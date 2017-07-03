#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Tidy_Parameters=/sf

#include <WinAPI.au3>

; #INDEX# =======================================================================================================================
; Title .........: Console.au3
; Version .......: 0.0.0.28
; AutoIt Version : 3.3.9.5a1+
; Minimum OS ....: Windows 2000
; Language ......: English
; Description ...: The following functions are used to access a console.
; Author(s) .....: Matt Diesel (Mat), Erik Pilsits (wraithdu)
; Forum link ....: http://www.autoitscript.com/forum/index.php?showtopic=?????? (tba)
; MSDN link .....: http://msdn.microsoft.com/en-us/library/ms682073.aspx
; DLL(s) ........: Kernel32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Console_AddAlias
; _Console_Alloc
; _Console_Attach
; _Console_CreateScreenBuffer
; _Console_FillOutputAttribute
; _Console_FillOutputCharacter
; _Console_FlushInputBuffer
; _Console_Free
; _Console_GenerateCtrlEvent
; _Console_GetAlias
; _Console_GetAliases
; _Console_GetAliasesLength
; _Console_GetAliasExes
; _Console_GetAliasExesLength
; _Console_GetCP
; _Console_GetCurrentFont
; _Console_GetCurrentFontEx
; _Console_GetCurrentFontFace
; _Console_GetCurrentFontFamily
; _Console_GetCurrentFontIndex
; _Console_GetCurrentFontSize
; _Console_GetCurrentFontWeight
; _Console_GetCursorInfo
; _Console_GetCursorPosition
; _Console_GetCursorSize
; _Console_GetCursorVisible
; _Console_GetDisplayMode
; _Console_GetFontSize
; _Console_GetHistoryBufferSize
; _Console_GetHistoryDuplicates
; _Console_GetHistoryInfo
; _Console_GetHistoryNumberOfBuffers
; _Console_GetInput
; _Console_GetLargestWindowSize
; _Console_GetMode
; _Console_GetNumberOfInputEvents
; _Console_GetNumberOfMouseButtons
; _Console_GetOriginalTitle
; _Console_GetOutputCP
; _Console_GetProcessList
; _Console_GetScreenBufferAttributes
; _Console_GetScreenBufferColorTable
; _Console_GetScreenBufferFullscreen
; _Console_GetScreenBufferInfo
; _Console_GetScreenBufferInfoEx
; _Console_GetScreenBufferMaxSize
; _Console_GetScreenBufferPopupAttributes
; _Console_GetScreenBufferPos
; _Console_GetScreenBufferSize
; _Console_GetSelectionAnchor
; _Console_GetSelectionFlags
; _Console_GetSelectionInfo
; _Console_GetSelectionRect
; _Console_GetSelectionRectEx
; _Console_GetStdHandle
; _Console_GetTitle
; _Console_GetWindow
; _Console_Pause
; _Console_PauseMessage
; _Console_Read
; _Console_ReadConsole
; _Console_ReadConsoleEx
; _Console_ReadInput
; _Console_ReadInputRecord
; _Console_ReadConsoleInput
; _Console_ReadConsoleInputRecord
; _Console_ReadOutputCharacter
; _Console_Run
; _Console_ScrollScreenBuffer
; _Console_ScrollScreenBufferEx
; _Console_SetActiveScreenBuffer
; _Console_SetCP
; _Console_SetCtrlHandler
; _Console_SetCurrentFontEx
; _Console_SetCursorInfo
; _Console_SetCursorPosition
; _Console_SetCursorSize
; _Console_SetCursorVisible
; _Console_SetDisplayMode
; _Console_SetHistoryInfo
; _Console_SetIcon
; _Console_SetIconEx
; _Console_SetMode
; _Console_SetOutputCP
; _Console_SetScreenBufferInfoEx
; _Console_SetScreenBufferInfoExEx
; _Console_SetScreenBufferSize
; _Console_SetStdHandle
; _Console_SetTextAttribute
; _Console_SetTitle
; _Console_SetWindowInfo
; _Console_SetWindowPos
; _Console_Write
; _Console_WriteConsole
; _Console_WriteLine
; _Console_WriteOutputAttribute
; _Console_WriteOutputCharacter
; ===============================================================================================================================

; #STRUCTURES# ==================================================================================================================
; $tagCHAR_INFO
; $tagCHAR_INFO_A
; $tagCHAR_INFO_W
; $tagCONSOLE_CURSOR_INFO
; $tagCONSOLE_FONT_INFO
; $tagCONSOLE_FONT_INFOEX
; $tagCONSOLE_HISTORY_INFO
; $tagCONSOLE_READCONSOLE_CONTROL
; $tagCONSOLE_SCREEN_BUFFER_INFO
; $tagCONSOLE_SCREEN_BUFFER_INFOEX
; $tagCONSOLE_SELECTION_INFO
; $tagSMALL_RECT
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; Standard device flags
; WinBase.h (1048 - 1050)
Global Const $STD_INPUT_HANDLE = -10
Global Const $STD_OUTPUT_HANDLE = -11
Global Const $STD_ERROR_HANDLE = -12

; ControlKeyState flags
; WinCon.h (63 - 71)
Global Const $RIGHT_ALT_PRESSED = 0x0001 ; the right alt key is pressed.
Global Const $LEFT_ALT_PRESSED = 0x0002 ; the left alt key is pressed.
Global Const $RIGHT_CTRL_PRESSED = 0x0004 ; the right ctrl key is pressed.
Global Const $LEFT_CTRL_PRESSED = 0x0008 ; the left ctrl key is pressed.
Global Const $SHIFT_PRESSED = 0x0010 ; the shift key is pressed.
Global Const $NUMLOCK_ON = 0x0020 ; the numlock light is on.
Global Const $SCROLLLOCK_ON = 0x0040 ; the scrolllock light is on.
Global Const $CAPSLOCK_ON = 0x0080 ; the capslock light is on.
Global Const $ENHANCED_KEY = 0x0100 ; the key is enhanced.

; ControlKeyState flags (Other)
; WinCon.h (72 - 78)
Global Const $NLS_DBCSCHAR = 0x00010000 ; DBCS for JPN: SBCS/DBCS mode.
Global Const $NLS_ALPHANUMERIC = 0x00000000 ; DBCS for JPN: Alphanumeric mode.
Global Const $NLS_KATAKANA = 0x00020000 ; DBCS for JPN: Katakana mode.
Global Const $NLS_HIRAGANA = 0x00040000 ; DBCS for JPN: Hiragana mode.
Global Const $NLS_ROMAN = 0x00400000 ; DBCS for JPN: Roman/Noroman mode.
Global Const $NLS_IME_CONVERSION = 0x00800000 ; DBCS for JPN: IME conversion.
Global Const $NLS_IME_DISABLE = 0x20000000 ; DBCS for JPN: IME enable/disable.

; ButtonState flags
; WinCon.h (91 - 95)
Global Const $FROM_LEFT_1ST_BUTTON_PRESSED = 0x0001
Global Const $RIGHTMOST_BUTTON_PRESSED = 0x0002
Global Const $FROM_LEFT_2ND_BUTTON_PRESSED = 0x0004
Global Const $FROM_LEFT_3RD_BUTTON_PRESSED = 0x0008
Global Const $FROM_LEFT_4TH_BUTTON_PRESSED = 0x0010

; EventFlags
; WinCon.h (101 - 106)
Global Const $MOUSE_MOVED = 0x0001
Global Const $DOUBLE_CLICK = 0x0002
Global Const $MOUSE_WHEELED = 0x0004
Global Const $MOUSE_HWHEELED = 0x0008

; EventType flags
; WinCon.h (135 - 139)
Global Const $KEY_EVENT = 0x0001 ; Event contains key event record
Global Const $MOUSE_EVENT = 0x0002 ; Event contains mouse event record
Global Const $WINDOW_BUFFER_SIZE_EVENT = 0x0004 ; Event contains window change event record
Global Const $MENU_EVENT = 0x0008 ; Event contains menu event record
Global Const $FOCUS_EVENT = 0x0010 ; event contains focus change

; Attributes flags (colors)
; WinCon.h (153 - 160)
Global Const $FOREGROUND_BLUE = 0x0001 ; text color contains blue.
Global Const $FOREGROUND_GREEN = 0x0002 ; text color contains green.
Global Const $FOREGROUND_RED = 0x0004 ; text color contains red.
Global Const $FOREGROUND_INTENSITY = 0x0008 ; text color is intensified.
Global Const $BACKGROUND_BLUE = 0x0010 ; background color contains blue.
Global Const $BACKGROUND_GREEN = 0x0020 ; background color contains green.
Global Const $BACKGROUND_RED = 0x0040 ; background color contains red.
Global Const $BACKGROUND_INTENSITY = 0x0080 ; background color is intensified.

; Attributes flags
; WinCon.h (161 - 169)
Global Const $COMMON_LVB_LEADING_BYTE = 0x0100 ; Leading Byte of DBCS
Global Const $COMMON_LVB_TRAILING_BYTE = 0x0200 ; Trailing Byte of DBCS
Global Const $COMMON_LVB_GRID_HORIZONTAL = 0x0400 ; DBCS: Grid attribute: top horizontal.
Global Const $COMMON_LVB_GRID_LVERTICAL = 0x0800 ; DBCS: Grid attribute: left vertical.
Global Const $COMMON_LVB_GRID_RVERTICAL = 0x1000 ; DBCS: Grid attribute: right vertical.
Global Const $COMMON_LVB_REVERSE_VIDEO = 0x4000 ; DBCS: Reverse fore/back ground attribute.
Global Const $COMMON_LVB_UNDERSCORE = 0x8000 ; DBCS: Underscore.
Global Const $COMMON_LVB_SBCSDBCS = 0x0300 ; SBCS or DBCS flag.

; For tagCONSOLE_HISTORY_INFO
; WinCon.h (213)
Global Const $HISTORY_NO_DUP_FLAG = 0x1

; Selection flags
; WinCon.h (232 - 236)
Global Const $CONSOLE_NO_SELECTION = 0x0000
Global Const $CONSOLE_SELECTION_IN_PROGRESS = 0x0001 ; selection has begun
Global Const $CONSOLE_SELECTION_NOT_EMPTY = 0x0002 ; non-null select rectangle
Global Const $CONSOLE_MOUSE_SELECTION = 0x0004 ; selecting with mouse
Global Const $CONSOLE_MOUSE_DOWN = 0x0008 ; mouse is down

; Event flags
; WinCon.h (249 - 255)
Global Const $CTRL_C_EVENT = 0
Global Const $CTRL_BREAK_EVENT = 1
Global Const $CTRL_CLOSE_EVENT = 2
Global Const $CTRL_LOGOFF_EVENT = 5
Global Const $CTRL_SHUTDOWN_EVENT = 6

; Input Mode flags
; WinCon.h (261 - 269)
Global Const $ENABLE_PROCESSED_INPUT = 0x0001
Global Const $ENABLE_LINE_INPUT = 0x0002
Global Const $ENABLE_ECHO_INPUT = 0x0004
Global Const $ENABLE_WINDOW_INPUT = 0x0008
Global Const $ENABLE_MOUSE_INPUT = 0x0010
Global Const $ENABLE_INSERT_MODE = 0x0020
Global Const $ENABLE_QUICK_EDIT_MODE = 0x0040
Global Const $ENABLE_EXTENDED_FLAGS = 0x0080
Global Const $ENABLE_AUTO_POSITION = 0x0100

; Output Mode flags
; WinCon.h (275 - 276)
Global Const $ENABLE_PROCESSED_OUTPUT = 0x0001
Global Const $ENABLE_WRAP_AT_EOL_OUTPUT = 0x0002

; For _Console_CreateScreenBuffer
; WinCon.h (882)
Global Const $CONSOLE_TEXTMODE_BUFFER = 1

; Display Mode flags (GetConsoleDisplayMode)
; WinCon.h (922 - 923)
Global Const $CONSOLE_FULLSCREEN = 1 ; fullscreen console
Global Const $CONSOLE_FULLSCREEN_HARDWARE = 2 ; console owns the hardware

; Display Mode flags (SetConsoleDisplayMode)
; WinCon.h (931 - 932)
Global Const $CONSOLE_FULLSCREEN_MODE = 1
Global Const $CONSOLE_WINDOWED_MODE = 2
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================

; Use this variable to set a global handle to kernel32.dll instead of using parameters
; $__gvKernel32 = DllOpen("kernel32.dll")
Global $__gvKernel32 = "kernel32.dll"

; Use this variable to set a global default for unicode / ANSI (Unicode = true)
Global $__gfUnicode = True

; Determines if running under SciTE or compiled as a CUI app, then uses ConsoleWrite in _Console_WriteConsole function
Global $__gfIsCUI = False ; (_Console_GetStdHandle($STD_OUTPUT_HANDLE) <> 0)

; ===============================================================================================================================

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCHAR_INFO_W
; Description ...: Specifies a Unicode character and its attributes. This structure is used by console functions to read from
;                  and write to a console screen buffer.
; Fields ........: Char                 - Unicode character of a screen buffer character cell.
;                  Attributes           - The character attributes. This member can be zero or any combination of the following
;                                         values:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attribute.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCHAR_INFO_W = "WCHAR Char; WORD Attributes"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCHAR_INFO_A
; Description ...: Specifies a Ascii character and its attributes. This structure is used by console functions to read from
;                  and write to a console screen buffer.
; Fields ........: Char                 - Ascii character of a screen buffer character cell.
;                  Attributes           - The character attributes. This member can be zero or any combination of the following
;                                         values:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attribute.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCHAR_INFO_A = "CHAR Char; CHAR; WORD Attributes"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCHAR_INFO
; Description ...: Specifies a character and its attributes. This structure is used by console functions to read from and write
;                  to a console screen buffer.
; Fields ........: UnicodeChar          - Unicode character of a screen buffer character cell.
;                  Attributes           - The character attributes. This member can be zero or any combination of the following
;                                         values.
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attribute.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCHAR_INFO = $tagCHAR_INFO_W

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_CURSOR_INFO
; Description ...: Contains information about the console cursor.
; Fields ........: Size                 - The percentage of the character cell that is filled by the cursor. This value is
;                                         between 1 and 100. The cursor appearance varies, ranging from completely filling the
;                                         cell to showing up as a horizontal line at the bottom of the cell.
;                  Visible              - The visibility of the cursor. If the cursor is visible, this member is TRUE.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_CURSOR_INFO = "DWORD Size; BOOL Visible;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_FONT_INFO
; Description ...: Contains information for a console font.
; Fields ........: Font                 - The index of the font in the system's console font table.
;                  X                    - Contains the width of each character in the font, in logical units.
;                  Y                    - Contains the height of each character in the font, in logical units.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_FONT_INFO = "DWORD Font; SHORT X; SHORT Y;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_FONT_INFO_EX
; Description ...: Contains extended information for a console font.
; Fields ........: Size                 - The size of this structure, in bytes.
;                  Font                 - The index of the font in the system's console font table.
;                  X                    - Contains the width of each character in the font, in logical units.
;                  Y                    - Contains the height of each character in the font, in logical units.
;                  FontFamily           - The font family. This parameter can be one of the following values:
;                                       |FF_DECORATIVE
;                                       |FF_DONTCARE
;                                       |FF_MODERN
;                                       |FF_ROMAN
;                                       |FF_SCRIPT
;                                       |FF_SWISS
;                  FontWeight           - The font weight. The weight can range from 100 to 1000, in multiples of 100. For
;                                         example, the normal weight is 400, while 700 is bold.
;                  FaceName             - The name of the typeface (such as Courier or Arial).
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_FONT_INFOEX = "ULONG Size; DWORD Font; SHORT X; SHORT Y; UINT FontFamily; UINT FontWeight; " & _
		"wchar[32] FaceName;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_HISTORY_INFO
; Description ...: Contains information about the console history.
; Fields ........: Size                 - The size of the structure, in bytes. Set this member to
;                                         DllStructGetSize($tCONSOLE_HISTORY_INFO).
;                  HistoryBufferSize    - The number of commands kept in each history buffer.
;                  NumberOfHistoryBuffers - The number of history buffers kept for this console process.
;                  Flags                - This parameter can be zero or 1. If 1, duplicate entries will not be stored in the
;                                         history buffer.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_HISTORY_INFO = "UINT Size; UINT HistoryBufferSize; UINT NumberOfHistoryBuffers; DWORD Flags;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_READCONSOLE_CONTROL
; Description ...: Contains information for a console read operation.
; Fields ........: Length               - The size of the structure. Set this member to
;                                         DllStructGetSize($tCONSOLE_READCONSOLE_CONTROL).
;                  InitialChars         - The number of characters to skip (and thus preserve) before writing newly read input
;                                         in the buffer passed to the _Console_Read function. This value must be less than
;                                         the NumberOfCharsToRead parameter of the _Console_Read function.
;                  CtrlWakeupMask       - A user-defined control character used to signal that the read is complete.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values.
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_READCONSOLE_CONTROL = "ULONG Length; ULONG InitialChars; ULONG CtrlWakeupMask; ULONG ControlKeyState;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_SCREEN_BUFFER_INFO
; Description ...: Contains information about a console screen buffer.
; Fields ........: SizeX                - The width of the console screen buffer, in character columns and rows.
;                  SizeY                - The height of the console screen buffer, in character columns and rows.
;                  CursorPositionX      - The column coordinates of the cursor in the console screen buffer.
;                  CursorPositionY      - The row coordinates of the cursor in the console screen buffer.
;                  Attributes           - The attributes of the characters written to a screen buffer by the _Console_WriteFile
;                                         and _Console_WriteConsole functions, or echoed to a screen buffer by the
;                                         _WinApi_ReadFile and _Console_Read functions.
;                  Left                 - The distance between the left buffer edge and the edge of the screen.
;                  Top                  - The distance between the top buffer edge and the edge of the screen.
;                  Right                - The distance between the right buffer edge and the edge of the screen.
;                  Bottom               - The distance between the top buffer edge and the edge of the screen.
;                  MaximumWindowSizeX   - The maximum width of the console window, in character columns and rows, given the
;                                         current screen buffer size and font and the screen size.
;                  MaximumWindowSizeY   - The maximum height of the console window, in character columns and rows, given the
;                                         current screen buffer size and font and the screen size.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_SCREEN_BUFFER_INFO = "SHORT SizeX; SHORT SizeY; SHORT CursorPositionX;" & _
		"SHORT CursorPositionY; SHORT Attributes; SHORT Left; SHORT Top; SHORT Right; SHORT Bottom;" & _
		"SHORT MaximumWindowSizeX; SHORT MaximumWindowSizeY"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_SCREEN_BUFFER_INFOEX
; Description ...: Contains extended information about a console screen buffer.
; Fields ........: Size                 - The size of this structure, in bytes. Should be set to
;                                         DllStructGetSize($tCONSOLE_SCREEN_BUFFER_INFO)
;                  SizeX                - The width of the console screen buffer, in character columns and rows.
;                  SizeY                - The height of the console screen buffer, in character columns and rows.
;                  CursorPositionX      - The column coordinates of the cursor in the console screen buffer.
;                  CursorPositionY      - The row coordinates of the cursor in the console screen buffer.
;                  Attributes           - The attributes of the characters written to a screen buffer by the _Console_WriteFile
;                                         and _Console_WriteConsole functions, or echoed to a screen buffer by the
;                                         _WinApi_ReadFile and _Console_Read functions.
;                  Left                 - The distance between the left buffer edge and the edge of the screen.
;                  Top                  - The distance between the top buffer edge and the edge of the screen.
;                  Right                - The right edge of the buffer.
;                  Bottom               - The top edge of the buffer.
;                  MaximumWindowSizeX   - The maximum width of the console window, in character columns and rows, given the
;                                         current screen buffer size and font and the screen size.
;                  MaximumWindowSizeY   - The maximum height of the console window, in character columns and rows, given the
;                                         current screen buffer size and font and the screen size.
;                  PopupAttributes      - The fill attribute for console pop-ups.
;                  FullscreenSupported  - If this member is TRUE, full-screen mode is supported; otherwise, it is not.
;                  ColorTable           - An array of COLORREF values that describe the console's color settings.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_SCREEN_BUFFER_INFOEX = "ULONG Size; SHORT SizeX; SHORT SizeY;SHORT CursorPositionX;" & _
		"SHORT CursorPositionY; SHORT Attributes; SHORT Left; SHORT Top; SHORT Right; SHORT Bottom;" & _
		"SHORT MaximumWindowSizeX; SHORT MaximumWindowSizeY; WORD PopupAttributes; BOOL FullscreenSupported;" & _
		"DWORD ColorTable[16];"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagCONSOLE_SELECTION_INFO
; Description ...: Contains information for a console selection.
; Fields ........: Flags                - The selection indicator. This member can be one or more of the following values.
;                                       |CONSOLE_MOUSE_DOWN - Mouse is down
;                                       |CONSOLE_MOUSE_SELECTION - Selecting with the mouse
;                                       |CONSOLE_NO_SELECTION - No selection
;                                       |CONSOLE_SELECTION_IN_PROGRESS - Selection has begun
;                                       |CONSOLE_SELECTION_NOT_EMPTY - Selection rectangle is not empty
;                  X                    - The X coordinate that specifies the selection anchor, in characters.
;                  Y                    - The Y coordinate that specifies the selection anchor, in characters.
;                  Left                 - The left edge of the selection rectangle, in characters.
;                  Top                  - The top edge of the selection rectangle, in characters.
;                  Right                - The right edge of the selection rectangle, in characters.
;                  Bottom               - The bottom edge of the selection rectangle, in characters.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCONSOLE_SELECTION_INFO = "DWORD Flags; SHORT X; SHORT Y; SHORT Left; SHORT Top; SHORT Right; SHORT Bottom;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagKEY_EVENT_RECORD_W
; Description ...: Describes a keyboard input event in a console INPUT_RECORD structure (Unicode version)
; Fields ........: KeyDown              - If the key is pressed, this member is TRUE. Otherwise, this member is FALSE (the key is
;                                         released).
;                  RepeatCount          - The repeat count, which indicates that a key is being held down. For example, when a
;                                         key is held down, you might get five events with this member equal to 1, one event with
;                                         this member equal to 5, or multiple events with this member greater than or equal to 1.
;                  VirtualKeyCode       - A virtual-key code that identifies the given key in a device-independent manner.
;                  VirtualScanCode      - The virtual scan code of the given key that represents the device-dependent value
;                                         generated by the keyboard hardware.
;                  Char                 - Translated Unicode character.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Enhanced keys for the IBM 101- and 102-key keyboards are the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and
;                  direction keys in the clusters to the left of the keypad; and the divide (/) and ENTER keys in the keypad.
;+
;                  Keyboard input events are generated when any key, including control keys, is pressed or released. However, the
;                  ALT key when pressed and released without combining with another character, has special meaning to the system
;                  and is not passed through to the application. Also, the CTRL+C key combination is not passed through if the
;                  input handle is in processed mode (ENABLE_PROCESSED_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagKEY_EVENT_RECORD, $tagKEY_EVENT_RECORD_A
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684166
; ===============================================================================================================================
Global Const $tagKEY_EVENT_RECORD_W = "BOOL KeyDown; WORD RepeatCount; WORD VirtualKeyCode; WORD VirtualScanCode;" & _
		"WCHAR Char; DWORD ControlKeyState;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagKEY_EVENT_RECORD_A
; Description ...: Describes a keyboard input event in a console INPUT_RECORD structure (ASCII version)
; Fields ........: KeyDown              - If the key is pressed, this member is TRUE. Otherwise, this member is FALSE (the key is
;                                         released).
;                  RepeatCount          - The repeat count, which indicates that a key is being held down. For example, when a
;                                         key is held down, you might get five events with this member equal to 1, one event with
;                                         this member equal to 5, or multiple events with this member greater than or equal to 1.
;                  VirtualKeyCode       - A virtual-key code that identifies the given key in a device-independent manner.
;                  VirtualScanCode      - The virtual scan code of the given key that represents the device-dependent value
;                                         generated by the keyboard hardware.
;                  Char                 - Translated ASCII character.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Enhanced keys for the IBM 101- and 102-key keyboards are the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and
;                  direction keys in the clusters to the left of the keypad; and the divide (/) and ENTER keys in the keypad.
;
;                  Keyboard input events are generated when any key, including control keys, is pressed or released. However, the
;                  ALT key when pressed and released without combining with another character, has special meaning to the system
;                  and is not passed through to the application. Also, the CTRL+C key combination is not passed through if the
;                  input handle is in processed mode (ENABLE_PROCESSED_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagKEY_EVENT_RECORD, $tagKEY_EVENT_RECORD_W
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684166
; ===============================================================================================================================
Global Const $tagKEY_EVENT_RECORD_A = "BOOL KeyDown; WORD RepeatCount; WORD VirtualKeyCode; WORD VirtualScanCode;" & _
		"CHAR Char; CHAR; DWORD ControlKeyState;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagKEY_EVENT_RECORD
; Description ...: Describes a keyboard input event in a console INPUT_RECORD structure
; Fields ........: KeyDown              - If the key is pressed, this member is TRUE. Otherwise, this member is FALSE (the key is
;                                         released).
;                  RepeatCount          - The repeat count, which indicates that a key is being held down. For example, when a
;                                         key is held down, you might get five events with this member equal to 1, one event with
;                                         this member equal to 5, or multiple events with this member greater than or equal to 1.
;                  VirtualKeyCode       - A virtual-key code that identifies the given key in a device-independent manner.
;                  VirtualScanCode      - The virtual scan code of the given key that represents the device-dependent value
;                                         generated by the keyboard hardware.
;                  Char                 - Translated ASCII or Unicode character
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Enhanced keys for the IBM 101- and 102-key keyboards are the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and
;                  direction keys in the clusters to the left of the keypad; and the divide (/) and ENTER keys in the keypad.
;+
;                  Keyboard input events are generated when any key, including control keys, is pressed or released. However, the
;                  ALT key when pressed and released without combining with another character, has special meaning to the system
;                  and is not passed through to the application. Also, the CTRL+C key combination is not passed through if the
;                  input handle is in processed mode (ENABLE_PROCESSED_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagKEY_EVENT_RECORD_A, $tagKEY_EVENT_RECORD_W
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684166
; ===============================================================================================================================
Global Const $tagKEY_EVENT_RECORD = $tagKEY_EVENT_RECORD_W

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagMOUSE_EVENT_RECORD
; Description ...: Describes a mouse input event in a console INPUT_RECORD structure.
; Fields ........: MousePositionX       - The X coordinate of the location of the cursor, in terms of the console screen buffer's
;                                         character-cell coordinates.
;                  MousePositionY       - The Y coordinate of the location of the cursor, in terms of the console screen buffer's
;                                         character-cell coordinates.
;                  ButtonState          - The status of the mouse buttons. The least significant bit corresponds to the leftmost
;                                         mouse button. The next least significant bit corresponds to the rightmost mouse button.
;                                         The next bit indicates the next-to-leftmost mouse button. The bits then correspond left
;                                         to right to the mouse buttons. A bit is 1 if the button was pressed.
;+
;                                         The following constants are defined for the first five mouse buttons:
;                                         |FROM_LEFT_1ST_BUTTON_PRESSED - The leftmost mouse button.
;                                         |FROM_LEFT_2ND_BUTTON_PRESSED - The second button from the left.
;                                         |FROM_LEFT_3RD_BUTTON_PRESSED - The third button from the left.
;                                         |FROM_LEFT_4TH_BUTTON_PRESSED - The fourth button from the left.
;                                         |RIGHTMOST_BUTTON_PRESSED - The rightmost mouse button.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                         |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                         |ENHANCED_KEY - The key is enhanced.
;                                         |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                         |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                         |NUMLOCK_ON - The NUM LOCK light is on.
;                                         |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                         |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                         |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                         |SHIFT_PRESSED - The SHIFT key is pressed.
;                  EventFlags           - The type of mouse event. If this value is zero, it indicates a mouse button being
;                                         pressed or released. Otherwise, this member is one of the following values.
;                                         |DOUBLE_CLICK - The second click (button press) of a double-click occurred. The first
;                                                         click is returned as a regular button-press event.
;                                         |MOUSE_HWHEELED - The horizontal mouse wheel was moved. If the high word of the
;                                                           ButtonState member contains a positive value, the wheel was rotated
;                                                           to the right. Otherwise, the wheel was rotated to the left.
;                                         |MOUSE_MOVED - A change in mouse position occurred.
;                                         |MOUSE_WHEELED - The vertical mouse wheel was moved. If the high word of the
;                                                          ButtonState member contains a positive value, the wheel was rotated
;                                                          forward, away from the user. Otherwise, the wheel was rotated
;                                                          backward, toward the user.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Mouse events are placed in the input buffer when the console is in mouse mode (ENABLE_MOUSE_INPUT).
;+
;                  Mouse events are generated whenever the user moves the mouse, or presses or releases one of the mouse buttons.
;                  Mouse events are placed in a console's input buffer only when the console group has the keyboard focus and the
;                  cursor is within the borders of the console's window.
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagINPUT_RECORD_MOUSE
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684239
; ===============================================================================================================================
Global Const $tagMOUSE_EVENT_RECORD = "SHORT MousePositionX; SHORT MousePositionY; DWORD ButtonState; DWORD ControlKeyState;" & _
		"DWORD EventFlags;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagWINDOW_BUFFER_SIZE_RECORD
; Description ...: Describes a change in the size of the console screen buffer.
; Fields ........: SizeX                - The width of the console screen buffer, in character cell columns.
;                  SizeY                - The height of the console screen buffer, in character cell rows.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Buffer size events are placed in the input buffer when the console is in window-aware mode
;                  (ENABLE_WINDOW_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagINPUT_RECORD_SIZE
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687093
; ===============================================================================================================================
Global Const $tagWINDOW_BUFFER_SIZE_RECORD = "SHORT SizeX; SHORT SizeY;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagMENU_EVENT_RECORD
; Description ...: Describes a menu event in a console $tagINPUT_RECORD structure. These events are used internally and should be
;                  ignored.
; Fields ........: CommandId            - Reserved according to MSDN documentation. From testing it seems the only messages sent
;                                         are menu opening (278) and menu closing (287). This is regardless of whether the
;                                         console is window aware or not.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagINPUT_RECORD_MENU
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684213
; ===============================================================================================================================
Global Const $tagMENU_EVENT_RECORD = "UINT CommandId;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagFOCUS_EVENT_RECORD
; Description ...: Describes a focus event in a console tagINPUT_RECORD structure. These events are used internally and should be
;                  ignored.
; Fields ........: SetFocus             - Reserved according to MSDN. True if window is gaining focus, False if it is losing
;                                         focus.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagINPUT_RECORD_FOCUS
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683149
; ===============================================================================================================================
Global Const $tagFOCUS_EVENT_RECORD = "BOOL SetFocus;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD
; Description ...: Describes an input event in the console input buffer. These records can be read from the input buffer by using
;                  the _Console_ReadInput or _Console_PeekInput function, or written to the input buffer by using the
;                  _Console_WriteInput function.
; Fields ........: EventType            - A handle to the type of input event. This member can be one of the following values:
;                                       |FOCUS_EVENT - This structure is a $tagINPUT_RECORD_FOCUS structure.
;                                       |KEY_EVENT - This structure is a $tagINPUT_RECORD_KEY structure.
;                                       |MENU_EVENT - This structure is a $tagINPUT_RECORD_MENU structure.
;                                       |MOUSE_EVENT - This structure is a $tagINPUT_RECORD_MOUSE structure.
;                                       |WINDOW_BUFFER_SIZE_EVENT - This structure is a $tagINPUT_RECORD_SIZE structure.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; Related .......: $tagINPUT_RECORD_KEY, $tagINPUT_RECORD_MOUSE, $tagINPUT_RECORD_SIZE, $tagINPUT_RECORD_MENU,
;                  $tagINPUT_RECORD_FOCUS, _Console_ReadInputRecord, _Console_ReadInput
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD = "WORD EventType; BYTE buffer[16];"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_KEY
; Description ...: Describes a keyboard input event in the console INPUT_RECORD structure
; Fields ........: EventType            - A handle to the type of input event. This should be set to KEY_EVENT if you are using
;                                         this structure.
;                  KeyDown              - If the key is pressed, this member is TRUE. Otherwise, this member is FALSE (the key is
;                                         released).
;                  RepeatCount          - The repeat count, which indicates that a key is being held down. For example, when a
;                                         key is held down, you might get five events with this member equal to 1, one event with
;                                         this member equal to 5, or multiple events with this member greater than or equal to 1.
;                  VirtualKeyCode       - A virtual-key code that identifies the given key in a device-independent manner.
;                  VirtualScanCode      - The virtual scan code of the given key that represents the device-dependent value
;                                         generated by the keyboard hardware.
;                  Char                 - Translated ASCII or Unicode character
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Enhanced keys for the IBM 101- and 102-key keyboards are the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and
;                  direction keys in the clusters to the left of the keypad; and the divide (/) and ENTER keys in the keypad.
;+
;                  Keyboard input events are generated when any key, including control keys, is pressed or released. However, the
;                  ALT key when pressed and released without combining with another character, has special meaning to the system
;                  and is not passed through to the application. Also, the CTRL+C key combination is not passed through if the
;                  input handle is in processed mode (ENABLE_PROCESSED_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagKEY_EVENT_RECORD_A, $tagKEY_EVENT_RECORD_W
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_KEY = "WORD EventType; STRUCT; " & $tagKEY_EVENT_RECORD & "ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_KEY_A
; Description ...: Describes a keyboard input event in the console input buffer (ASCII version)
; Fields ........: EventType            - A handle to the type of input event. This should be set to KEY_EVENT if you are using
;                                         this structure.
;                  KeyDown              - If the key is pressed, this member is TRUE. Otherwise, this member is FALSE (the key is
;                                         released).
;                  RepeatCount          - The repeat count, which indicates that a key is being held down. For example, when a
;                                         key is held down, you might get five events with this member equal to 1, one event with
;                                         this member equal to 5, or multiple events with this member greater than or equal to 1.
;                  VirtualKeyCode       - A virtual-key code that identifies the given key in a device-independent manner.
;                  VirtualScanCode      - The virtual scan code of the given key that represents the device-dependent value
;                                         generated by the keyboard hardware.
;                  Char                 - Translated ASCII character.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Enhanced keys for the IBM 101- and 102-key keyboards are the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and
;                  direction keys in the clusters to the left of the keypad; and the divide (/) and ENTER keys in the keypad.
;
;                  Keyboard input events are generated when any key, including control keys, is pressed or released. However, the
;                  ALT key when pressed and released without combining with another character, has special meaning to the system
;                  and is not passed through to the application. Also, the CTRL+C key combination is not passed through if the
;                  input handle is in processed mode (ENABLE_PROCESSED_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD_KEY, $tagINPUT_RECORD_KEY_W
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_KEY_A = "WORD EventType; STRUCT; " & $tagKEY_EVENT_RECORD_A & "ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_KEY_W
; Description ...: Describes a keyboard input event in the console input buffer (Unicode version)
; Fields ........: EventType            - A handle to the type of input event. This should be set to KEY_EVENT if you are using
;                                         this structure.
;                  KeyDown              - If the key is pressed, this member is TRUE. Otherwise, this member is FALSE (the key is
;                                         released).
;                  RepeatCount          - The repeat count, which indicates that a key is being held down. For example, when a
;                                         key is held down, you might get five events with this member equal to 1, one event with
;                                         this member equal to 5, or multiple events with this member greater than or equal to 1.
;                  VirtualKeyCode       - A virtual-key code that identifies the given key in a device-independent manner.
;                  VirtualScanCode      - The virtual scan code of the given key that represents the device-dependent value
;                                         generated by the keyboard hardware.
;                  Char                 - Translated Unicode character.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                       |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                       |ENHANCED_KEY - The key is enhanced.
;                                       |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                       |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                       |NUMLOCK_ON - The NUM LOCK light is on.
;                                       |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                       |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                       |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                       |SHIFT_PRESSED - The SHIFT key is pressed.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Enhanced keys for the IBM 101- and 102-key keyboards are the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and
;                  direction keys in the clusters to the left of the keypad; and the divide (/) and ENTER keys in the keypad.
;+
;                  Keyboard input events are generated when any key, including control keys, is pressed or released. However, the
;                  ALT key when pressed and released without combining with another character, has special meaning to the system
;                  and is not passed through to the application. Also, the CTRL+C key combination is not passed through if the
;                  input handle is in processed mode (ENABLE_PROCESSED_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD_KEY, $tagINPUT_RECORD_KEY_A
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_KEY_W = "WORD EventType; STRUCT; " & $tagKEY_EVENT_RECORD_W & "ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_MOUSE
; Description ...: Describes a mouse input event in the console input buffer.
; Fields ........: EventType            - A handle to the type of input event. This should be set to MOUSE_EVENT if you are using
;                                         this structure.
;                  MousePositionX       - The X coordinate of the location of the cursor, in terms of the console screen buffer's
;                                         character-cell coordinates.
;                  MousePositionY       - The Y coordinate of the location of the cursor, in terms of the console screen buffer's
;                                         character-cell coordinates.
;                  ButtonState          - The status of the mouse buttons. The least significant bit corresponds to the leftmost
;                                         mouse button. The next least significant bit corresponds to the rightmost mouse button.
;                                         The next bit indicates the next-to-leftmost mouse button. The bits then correspond left
;                                         to right to the mouse buttons. A bit is 1 if the button was pressed.
;+
;                                         The following constants are defined for the first five mouse buttons:
;                                         |FROM_LEFT_1ST_BUTTON_PRESSED - The leftmost mouse button.
;                                         |FROM_LEFT_2ND_BUTTON_PRESSED - The second button from the left.
;                                         |FROM_LEFT_3RD_BUTTON_PRESSED - The third button from the left.
;                                         |FROM_LEFT_4TH_BUTTON_PRESSED - The fourth button from the left.
;                                         |RIGHTMOST_BUTTON_PRESSED - The rightmost mouse button.
;                  ControlKeyState      - The state of the control keys. This member can be one or more of the following values:
;                                         |CAPSLOCK_ON - The CAPS LOCK light is on.
;                                         |ENHANCED_KEY - The key is enhanced.
;                                         |LEFT_ALT_PRESSED - The left ALT key is pressed.
;                                         |LEFT_CTRL_PRESSED - The left CTRL key is pressed.
;                                         |NUMLOCK_ON - The NUM LOCK light is on.
;                                         |RIGHT_ALT_PRESSED - The right ALT key is pressed.
;                                         |RIGHT_CTRL_PRESSED - The right CTRL key is pressed.
;                                         |SCROLLLOCK_ON - The SCROLL LOCK light is on.
;                                         |SHIFT_PRESSED - The SHIFT key is pressed.
;                  EventFlags           - The type of mouse event. If this value is zero, it indicates a mouse button being
;                                         pressed or released. Otherwise, this member is one of the following values.
;                                         |DOUBLE_CLICK - The second click (button press) of a double-click occurred. The first
;                                                         click is returned as a regular button-press event.
;                                         |MOUSE_HWHEELED - The horizontal mouse wheel was moved. If the high word of the
;                                                           ButtonState member contains a positive value, the wheel was rotated
;                                                           to the right. Otherwise, the wheel was rotated to the left.
;                                         |MOUSE_MOVED - A change in mouse position occurred.
;                                         |MOUSE_WHEELED - The vertical mouse wheel was moved. If the high word of the
;                                                          ButtonState member contains a positive value, the wheel was rotated
;                                                          forward, away from the user. Otherwise, the wheel was rotated
;                                                          backward, toward the user.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Mouse events are placed in the input buffer when the console is in mouse mode (ENABLE_MOUSE_INPUT).
;+
;                  Mouse events are generated whenever the user moves the mouse, or presses or releases one of the mouse buttons.
;                  Mouse events are placed in a console's input buffer only when the console group has the keyboard focus and the
;                  cursor is within the borders of the console's window.
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagMOUSE_EVENT_RECORD
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_MOUSE = "WORD EventType; STRUCT; " & $tagMOUSE_EVENT_RECORD & "ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_SIZE
; Description ...: Describes a change in the size of the console screen event in the console input buffer.
; Fields ........: EventType            - A handle to the type of input event. This should be set to WINDOW_BUFFER_SIZE_EVENT if
;                                         you are using this structure.
;                  SizeX                - The width of the console screen buffer, in character cell columns.
;                  SizeY                - The height of the console screen buffer, in character cell rows.
; Author ........: Matt Diesel (Mat)
; Remarks .......: Buffer size events are placed in the input buffer when the console is in window-aware mode
;                  (ENABLE_WINDOW_INPUT).
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagWINDOW_BUFFER_SIZE_RECORD
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_SIZE = "WORD EventType; STRUCT; " & $tagWINDOW_BUFFER_SIZE_RECORD & "BYTE[12]; ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_MENU
; Description ...: Describes a menu event in the console input buffer. These events are used internally and should be ignored.
; Fields ........: EventType            - A handle to the type of input event. This should be set to MENU_EVENT if you are using
;                                         this structure.
;                  CommandId            - Reserved according to MSDN documentation. From testing it seems the only messages sent
;                                         are menu opening (278) and menu closing (287). This is regardless of whether the
;                                         console is window aware or not.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagMENU_EVENT_RECORD
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_MENU = "WORD EventType; STRUCT; " & $tagMENU_EVENT_RECORD & "BYTE[12]; ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagINPUT_RECORD_FOCUS
; Description ...: Describes a focus event in the console input buffer. These events are used internally and should be ignored.
; Fields ........: EventType            - A handle to the type of input event. This should be set to FOCUS_EVENT if you are using
;                                         this structure.
;                  SetFocus             - Reserved according to MSDN. True if window is gaining focus, False if it is losing
;                                         focus.
; Author ........: Matt Diesel (Mat)
; Remarks .......:
; Related .......: _Console_ReadInputRecord, _Console_ReadInput, $tagINPUT_RECORD, $tagFOCUS_EVENT_RECORD
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683499
; ===============================================================================================================================
Global Const $tagINPUT_RECORD_FOCUS = "WORD EventType; STRUCT; " & $tagFOCUS_EVENT_RECORD & "BYTE[12]; ENDSTRUCT;"

; #STRUCTURE# ===================================================================================================================
; Name ..........: $tagSMALL_RECT
; Description ...: Defines the coordinates of the upper left and lower right corners of a rectangle.
; Fields ........: Left                 - The x-coordinate of the upper left corner of the rectangle.
;                  Top                  - The y-coordinate of the upper left corner of the rectangle.
;                  Right                - The x-coordinate of the lower right corner of the rectangle.
;                  Bottom               - The y-coordinate of the lower right corner of the rectangle.
; Author ........: Matt Diesel (Mat)
; Remarks .......: This structure is used by console functions to specify rectangular areas of console screen buffers, where the
;                  coordinates specify the rows and columns of screen-buffer character cells.
; ===============================================================================================================================
Global Const $tagSMALL_RECT = "SHORT Left; SHORT Top; SHORT Right; SHORT Bottom;"




; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_AddAlias
; Description ...: Defines a console alias for the specified executable.
; Syntax ........: _Console_AddAlias($sSource, $sTarget, $sExeName [, $hDll ] )
; Parameters ....: $sSource             - The console alias to be mapped to the text specified by Target.
;                  $sTarget             - The text to be substituted for Source. If this parameter is 0, then the console alias
;                                         is removed.
;                  $sExeName            - The name of the executable file for which the console alias is to be defined. Default
;                                         is the current executable.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: Console aliases allow programs to define macros for commonly used commands. For example if you frequently need
;                  to use "cd \a_very_long_path\test" in cmd.exe you can shorten this to just "test" by calling:
;                  _Console_AddAlias("cd \a_very_long_path\test", "test", "cmd.exe")
; Related .......: _Console_GetAlias, _Console_GetAliases, _Console_GetAliasExes
; Link ..........: http://msdn.microsoft.com/en-us/library/ms681935.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_AddAlias($sSource, $sTarget, $sExeName = Default, $fUnicode = Default, $hDll = -1)
	If $sExeName = Default Then $sExeName = @AutoItExe
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "AddConsoleAlias" & ($fUnicode ? "W" : "A"), _
			($fUnicode ? "w" : "") & "str", $sSource, _
			($fUnicode ? "w" : "") & "str", $sTarget, _
			($fUnicode ? "w" : "") & "str", $sExeName)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_AddAlias

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_Alloc
; Description ...: Allocates a new console for the calling process.
; Syntax ........: _Console_Alloc( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: This function is primarily used by graphical user interface (GUI) application to create a console window. Note
;                  that AutoIt's internal ConsoleWrite function will not write to this console, you must use the
;                  _Console_WriteConsole function instead.
; Related .......: _Console_Attach, _Console_Free, _Console_GetStdHandle, _Console_Run,
;                  _Console_WriteConsole
; Link ..........: http://msdn.microsoft.com/en-us/library/ms681944.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _Console_Alloc($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "AllocConsole")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_Alloc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_Attach
; Description ...: Attaches the calling process to the console of the specified process.
; Syntax ........: _Console_Attach( [$iProcessID [, $hDll ]] )
; Parameters ....: $iProcessID          - Identifier of the process. Set to -1 (default) to use the console of the parent of the
;                                         current process.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: Requires Windows XP.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms681952.aspx
; Example .......:
; ===============================================================================================================================
Func _Console_Attach($iProcessID = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "AttachConsole", _
			"dword", $iProcessID)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_Attach

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_CreateScreenBuffer
; Description ...: Creates a console screen buffer.
; Syntax ........: _Console_CreateScreenBuffer( [ $iDesiredAccess [, $iShareMode [, $hDll ]]] )
; Parameters ....: $iDesiredAccess      - The access to the console screen buffer
;                  $iShareMode          - This parameter can be zero, indicating that the buffer cannot be shared, or it can be
;                                         one or more of the following values:
;                                       |FILE_SHARE_READ - Other open operations can be performed on the console screen buffer
;                                                          for read access.
;                                       |FILE_SHARE_WRITE - Other open operations can be performed on the console screen buffer
;                                                           for write access.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A handle to the new console screen buffer.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: FILE_SHARE_* constants are defined in FileConstants.au3. $tagSECURITY_ATTRIBUTES is defined in
;                  StructureConstants.au3
; Related .......: _Console_CloseHandle, _Console_DuplicateHandle, _Console_GetScreenBufferInfo,
;                  SECURITY_ATTRIBUTES(Struct), _Console_SetActiveScreenBuffer, _Console_SetScreenBufferSize
; Link ..........: http://msdn.microsoft.com/en-us/library/ms682122.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_CreateScreenBuffer($iDesiredAccess = -1, $iShareMode = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $iDesiredAccess = -1 Then $iDesiredAccess = BitOR(0x80000000, 0x40000000)
	If $iShareMode = -1 Then $iShareMode = BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE)

	Local $aResult = DllCall($hDll, "handle", "CreateConsoleScreenBuffer", _
			"dword", $iDesiredAccess, _
			"dword", $iShareMode, _
			"ptr", 0, _
			"dword", $CONSOLE_TEXTMODE_BUFFER, _
			"ptr", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_Console_CreateScreenBuffer

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_FillOutputAttribute
; Description ...: Sets the character attributes for a specified number of character cells, beginning at the specified
;                  coordinates in a screen buffer.
; Syntax ........: _Console_FillOutputAttribute($hConsoleOutput, $iAttribute, $nLength, $iX, $iY [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right.
;                  $iAttribute          - The attributes to use when writing to the console screen buffer.
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal.
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attributes.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
;                  $nLength             - The number of character cells to be set to the specified color attributes.
;                  $iX                  - The X coordinate that specifies the character coordinates of the first
;                                         cell whose attributes are to be set.
;                  $iY                  - The Y coordinate that specifies the character coordinates of the first
;                                         cell whose attributes are to be set.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True, the number of character cells whose attributes were actually set is returned in
;                                         @extended.
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms682662.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_FillOutputAttribute($hConsoleOutput, $iAttribute, $nLength, $iX, $iY, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "BOOL", "FillConsoleOutputAttribute", _
			"HANDLE", $hConsoleOutput, _
			"WORD", $iAttribute, _
			"DWORD", $nLength, _
			"INT", BitShift($iY, -16) + $iX, _
			"DWORD*", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return SetExtended($aResult[5], $aResult[0] <> 0)
EndFunc   ;==>_Console_FillOutputAttribute

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_FillOutputCharacter
; Description ...: Writes a character to the console screen buffer a specified number of times.
; Syntax ........: _Console_FillOutputCharacter($hConsoleOutput, $sCharacter, $nLength [, $iX [, $iY [, $fUnicode [, $hDll ]]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right.
;                  $sCharacter          - The character to be written to the console screen buffer.
;                  $nLength             - The number of character cells to which the character should be written.
;                  $iX                  - The X coordinate that specifies the character coordinates of the first
;                                         cell whose attributes are to be set.
;                  $iY                  - The Y coordinate that specifies the character coordinates of the first
;                                         cell whose attributes are to be set.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True, the number of character cells whose attributes were actually set is returned in
;                                         @extended
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms682663.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_FillOutputCharacter($hConsoleOutput, $sCharacter, $nLength, $iX = 0, $iY = 0, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall("kernel32.dll", "bool", "FillConsoleOutputCharacter" & ($fUnicode ? "W" : "A"), _
			"handle", $hConsoleOutput, _
			"byte", IsString($sCharacter) ?($fUnicode ? AscW($sCharacter) : Asc($sCharacter)) : $sCharacter, _
			"dword", $nLength, _
			"int", BitShift($iY, -16) + $iX, _
			"dword*", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return SetExtended($aResult[5], $aResult[0] <> 0)
EndFunc   ;==>_Console_FillOutputCharacter

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_FlushInputBuffer
; Description ...: Flushes the console input buffer.
; Syntax ........: _Console_FlushInputBuffer( [$hConsoleInput [, $hDll ]] )
; Parameters ....: $hConsoleInput       - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: Sometimes key presses are sent to a console before a call to _Console_Read, causing odd result, such as rogue
;                  characters. Calling _Console_FlushInputBuffer before _Console_Read fixes this, but it has some performance
;                  issues, especially when dealing with mouse and window input.
; Related .......: _Console_Read
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683147.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_FlushInputBuffer($hConsoleInput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "FlushConsoleInputBuffer", _
			"handle", $hConsoleInput)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_FlushInputBuffer

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_Free
; Description ...: Detaches the calling process from its console.
; Syntax ........: _Console_Free( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_Alloc, _Console_GetProcessList
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683150.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _Console_Free($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "FreeConsole")
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_Free

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GenerateCtrlEvent
; Description ...: Sends a specified signal to a console process group that shares the console associated with the calling
;                  process.
; Syntax ........: _Console_GenerateCtrlEvent($iCtrlEvent [, $iProcessGroupId [, $hDll ]] )
; Parameters ....: $iCtrlEvent          - The type of signal to be generated. This parameter can be one of the following values:
;                                       |CTRL_C_EVENT - Generates a CTRL+C signal. This signal cannot be generated for process
;                                                       groups. If $iProcessGroupId is non-zero, this function will succeed, but
;                                                       the CTRL+C signal will not be received by processes within the specified
;                                                       process group.
;                                       |CTRL_BREAK_EVENT - Generates a CTRL+BREAK signal.
;                  $iProcessGroupId     - The identifier of the process group to receive the signal. A process group is created
;                                         when the CREATE_NEW_PROCESS_GROUP flag is specified in a call to the CreateProcess
;                                         function. The process identifier of the new process is also the process group
;                                         identifier of a new process group. The process group includes all processes that
;                                         are descendants of the root process. Only those processes in the group that share the
;                                         same console as the calling process receive the signal. In other words, if a process
;                                         in the group creates a new console, that process does not receive the signal, nor do
;                                         its descendants. If this parameter is zero, the signal is generated in all processes
;                                         that share the console of the calling process.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683155.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GenerateCtrlEvent($iCtrlEvent, $iProcessGroupId = 0, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "GenerateConsoleCtrlEvent", _
			"dword", $iCtrlEvent, _
			"dword", $iProcessGroupId)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_GenerateCtrlEvent

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetAlias
; Description ...: Retrieves the specified alias for the specified executable.
; Syntax ........: _Console_GetAlias($sSource [, $sExeName [, $fUnicode [, $hDll ]]] )
; Parameters ....: $sSource             - The console alias whose text is to be retrieved.
;                  $sExeName            - The name of the executable file. The default is the current executable. Note that this
;                                         will be AutoIt3.exe if the program is not compiled.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The text associated with the console alias.
;                  Failure              - A blank string
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683157.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetAlias($sSource, $sExeName = -1, $fUnicode = Default, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $sExeName = -1 Then $sExeName = @AutoItExe

	Local $tTargetBuffer = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[1024]")

	Local $aResult = DllCall($hDll, "dword", "GetConsoleAlias" & ($fUnicode ? "W" : "A"), _
			($fUnicode ? "w" : "") & "str", $sSource, _
			"struct*", $tTargetBuffer, _
			"dword", DllStructGetSize($tTargetBuffer), _
			($fUnicode ? "w" : "") & "str", $sExeName)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")

	Return $tTargetBuffer.buffer
EndFunc   ;==>_Console_GetAlias

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetAliases
; Description ...: Retrieves all defined console aliases for the specified executable.
; Syntax ........: _Console_GetAliases( [$sExeName [, $fUnicode [, $hDll ]]] )
; Parameters ....: $sExeName            - The executable file whose aliases are to be retrieved.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - An array containing the console aliases.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetAliasesLength
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683158.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetAliases($sExeName = -1, $fUnicode = Default, $hDll = -1)
	If $sExeName = -1 Then $sExeName = @AutoItExe
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tAliasBuffer = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[" & _Console_GetAliasesLength($sExeName, $fUnicode, $hDll) & "]")

	Local $aResult = DllCall($hDll, "dword", "GetConsoleAliases" & ($fUnicode ? "W" : "A"), _
			"struct*", $tAliasBuffer, _
			"dword", DllStructGetSize($tAliasBuffer), _
			($fUnicode ? "w" : "") & "str", $sExeName)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return StringRegExp($tAliasBuffer.buffer, "Source\d+=(.+?)\0", 3)
EndFunc   ;==>_Console_GetAliases

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetAliasesLength
; Description ...: Returns the size, in bytes, of the buffer needed to store all of the console aliases for the specified
;                  executable.
; Syntax ........: _Console_GetAliasesLength( [$sExeName [, $fUnicode [, $hDll ]]] )
; Parameters ....: $sExeName            - The executable file whose aliases are to be retrieved.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The size, in characters, of the buffer needed to store all of the console aliases.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetAliases
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683159.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetAliasesLength($sExeName = -1, $fUnicode = Default, $hDll = -1)
	If $sExeName = -1 Then $sExeName = @AutoItExe
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "dword", "GetConsoleAliasesLength" & ($fUnicode ? "W" : "A"), _
			($fUnicode ? "w" : "") & "str", $sExeName)
	If @error Then Return SetError(@error, @extended, 0)

	If $fUnicode Then Return $aResult[0] / 2
	Return $aResult[0]
EndFunc   ;==>_Console_GetAliasesLength

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetAliasExes
; Description ...: Retrieves the names of all executables with console aliases defined.
; Syntax ........: _Console_GetAliasExes( [ $fUnicode [, $hDll ]] )
; Parameters ....: $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A string containing the exes.
;                  Failure              - A blank string
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683160.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetAliasExes($fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tExeNameBuffer = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[" & _Console_GetAliasExesLength(True, $hDll) & "]")

	Local $aResult = DllCall($hDll, "dword", "GetConsoleAliasExes" & ($fUnicode ? "W" : "A"), _
			"struct*", $tExeNameBuffer, _
			"dword", DllStructGetSize($tExeNameBuffer))
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")

	Return $tExeNameBuffer.buffer
EndFunc   ;==>_Console_GetAliasExes

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetAliasExesLength
; Description ...: Returns the size, in bytes, of the buffer needed to store the names of all executables that have console
;                  aliases defined.
; Syntax ........: _Console_GetAliasExesLength( [ $fUnicode [, $hDll ]] )
; Parameters ....: $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: The size of the buffer required to store the names of all executable files that have console aliases defined,
;                  in characters.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683161.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetAliasExesLength($fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "dword", "GetConsoleAliasExesLength" & ($fUnicode ? "W" : "A"))
	If @error Then Return SetError(@error, @extended, 0)

	If $fUnicode Then Return $aResult[0] / 2
	Return $aResult[0]
EndFunc   ;==>_Console_GetAliasExesLength

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCP
; Description ...: Retrieves the input code page used by the console associated with the calling process.
; Syntax ........: _Console_GetCP( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: A code that identifies the code page. See http://msdn.microsoft.com/en-us/library/dd317756.aspx
;                  for possible values.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: A code page maps 256 character codes to individual characters. Different code pages include different special
;                  characters, typically customized for a language or a group of languages. To retrieve more information about
;                  a code page, including it's name, see the _Console_GetCPInfoEx function.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683162.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCP($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "uint", "GetConsoleCP")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_Console_GetCP

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCursorInfo
; Description ...: Retrieves information about the size and visibility of the cursor for the specified console screen buffer.
; Syntax ........: _Console_GetCursorInfo( [$hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_CURSOR_INFO structure with the information.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCursorSize, _Console_GetCursorVisible
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683163.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCursorInfo($hConsoleOutput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tConsoleCursorInfo = DllStructCreate($tagCONSOLE_CURSOR_INFO)

	Local $aResult = DllCall($hDll, "bool", "GetConsoleCursorInfo", _
			"handle", $hConsoleOutput, _
			"struct*", $tConsoleCursorInfo)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $tConsoleCursorInfo
EndFunc   ;==>_Console_GetCursorInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCursorPosition
; Description ...: Gets the current cursor position in a console.
; Syntax ........: _Console_GetCursorPosition( [ $hConsole [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A 2 element array:
;                                       |0 - The cursors current zero based character column (X value)
;                                       |1 - The cursors current zero based character row (Y value)
;                  Failure              - Zero and set's the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_SetCursorPosition, _Console_GetScreenBufferInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCursorPosition($hConsole = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfo = _Console_GetScreenBufferInfo($hConsole, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [$tConsoleScreenBufferInfo.CursorPositionX, $tConsoleScreenBufferInfo.CursorPositionY]
	Return $aRet
EndFunc   ;==>_Console_GetCursorPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCursorSize
; Description ...: Retrieves whether the size of the cursor for the specified console screen buffer.
; Syntax ........: _Console_GetCursorSize( [ $hConsole [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The percentage of a character cell taken up by the cursor (between 1 and 100).
;                  Failure              - Less than zero.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCursorInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCursorSize($hConsole = -1, $hDll = -1)
	Local $tConsoleCursorInfo = _Console_GetCursorInfo($hConsole, $hDll)
	If @error Then Return SetError(@error, @extended, -1)

	Return $tConsoleCursorInfo.Size
EndFunc   ;==>_Console_GetCursorSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCursorVisible
; Description ...: Retrieves whether the cursor is visible for the specified console screen buffer.
; Syntax ........: _Console_GetCursorVisible( [ $hConsole [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True if the cursor is visible, otherwise False.
;                  Failure              - Set's the @error flag. Will return False, but that could be a successful return.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCursorInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCursorVisible($hConsole = -1, $hDll = -1)
	Local $tConsoleCursorInfo = _Console_GetCursorInfo($hConsole, $hDll)
	If @error Then Return SetError(@error, @extended, False)

	Return $tConsoleCursorInfo.Visible
EndFunc   ;==>_Console_GetCursorVisible

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFont
; Description ...: Retrieves information about the current console font.
; Syntax ........: _Console_GetCurrentFont( [$hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                                         Default is FALSE.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_FONT_INFO structure that has the requested font information.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683176.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFont($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tConsoleCurrentFont = DllStructCreate($tagCONSOLE_FONT_INFO)

	Local $aResult = DllCall($hDll, "bool", "GetCurrentConsoleFont", _
			"handle", $hConsoleOutput, _
			"bool", $fMaximumWindow, _
			"struct*", $tConsoleCurrentFont)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $tConsoleCurrentFont
EndFunc   ;==>_Console_GetCurrentFont

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFontEx
; Description ...: Retrieves extended information about the current console font.
; Syntax ........: _Console_GetCurrentFontEx( [$hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_FONT_INFOEX structure that has the requested font information.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683177.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFontEx($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tConsoleCurrentFontEx = DllStructCreate($tagCONSOLE_FONT_INFOEX)

	Local $aResult = DllCall($hDll, "bool", "GetCurrentConsoleFontEx", _
			"handle", $hConsoleOutput, _
			"bool", $fMaximumWindow, _
			"struct*", $tConsoleCurrentFontEx)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $tConsoleCurrentFontEx
EndFunc   ;==>_Console_GetCurrentFontEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFontFace
; Description ...: Retrieves the face name of the current console font.
; Syntax ........: _Console_GetCurrentFontFace( [ $hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The face name of the current console font as a string.
;                  Failure              - A blank string and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCurrentFontEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFontFace($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	Local $tConsoleFontInfoEx = _Console_GetCurrentFontEx($hConsoleOutput, $fMaximumWindow, $hDll)
	If @error Then Return SetError(@error, @extended, "")

	Return $tConsoleFontInfoEx.FaceName
EndFunc   ;==>_Console_GetCurrentFontFace

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFontFamily
; Description ...: Retrieves the font family of the current console font.
; Syntax ........: _Console_GetCurrentFontFamily( [ $hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The family of the current console font. This can be one of the following values:
;                                       |FF_DECORATIVE
;                                       |FF_DONTCARE
;                                       |FF_MODERN
;                                       |FF_ROMAN
;                                       |FF_SCRIPT
;                                       |FF_SWISS
;                  Failure              - Zero and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCurrentFontEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFontFamily($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	Local $tConsoleFontInfoEx = _Console_GetCurrentFontEx($hConsoleOutput, $fMaximumWindow, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tConsoleFontInfoEx.FontFamily
EndFunc   ;==>_Console_GetCurrentFontFamily

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFontIndex
; Description ...: Retrieves the system index of the current console font.
; Syntax ........: _Console_GetCurrentFontIndex( [ $hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The system index of the current console font.
;                  Failure              - Zero and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCurrentFont
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFontIndex($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	Local $tConsoleFontInfo = _Console_GetCurrentFont($hConsoleOutput, $fMaximumWindow, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tConsoleFontInfo.Font
EndFunc   ;==>_Console_GetCurrentFontIndex

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFontSize
; Description ...: Retrieves the size of the current console font.
; Syntax ........: _Console_GetCurrentFontSize( [ $hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A 2-element array:
;                                       |[0] - The width of a character for the current console font.
;                                       |[1] - The height of a character for the current console font.
;                  Failure              - Zero and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCurrentFont
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFontSize($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	Local $tConsoleFontInfo = _Console_GetCurrentFont($hConsoleOutput, $fMaximumWindow, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [$tConsoleFontInfo.X, $tConsoleFontInfo.Y]
	Return $aRet
EndFunc   ;==>_Console_GetCurrentFontSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetCurrentFontWeight
; Description ...: Retrieves the weight of the current console font.
; Syntax ........: _Console_GetCurrentFontWeight( [ $hConsoleOutput [, $fMaximumWindow [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fMaximumWindow      - If this parameter is TRUE, font information is retrieved for the maximum window size.
;                                         If this parameter is FALSE, font information is retrieved for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The weight of the current console font. This is usually a value between 100 and 1000.
;                  Failure              - Zero and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCurrentFontEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetCurrentFontWeight($hConsoleOutput = -1, $fMaximumWindow = False, $hDll = -1)
	Local $tConsoleFontInfoEx = _Console_GetCurrentFontEx($hConsoleOutput, $fMaximumWindow, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tConsoleFontInfoEx.FontWeight
EndFunc   ;==>_Console_GetCurrentFontWeight

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetDisplayMode
; Description ...: Retrieves the display mode of the current console.
; Syntax ........: _Console_GetDisplayMode( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The display mode of the console. This can be one or more of the following values:
;                                       |CONSOLE_FULLSCREEN - Full-screen console. The console is in this mode as soon as the
;                                                             window is maximized. At this point, the transition to full-screen
;                                                             mode can still fail.
;                                       |CONSOLE_FULLSCREEN_HARDWARE - Full-screen console communicating directly with the video
;                                                                      hardware. This mode is set after the console is in
;                                                                      CONSOLE_FULLSCREEN mode to indicate that the transition
;                                                                      to full-screen mode has completed.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683164.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetDisplayMode($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "GetConsoleDisplayMode", _
			"dword", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $aResult[1]
EndFunc   ;==>_Console_GetDisplayMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetFontSize
; Description ...: Retrieves the size of the font used by the specified console screen buffer.
; Syntax ........: _Console_GetFontSize( [$hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right. Default is the running process' console screen buffer.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - An array where the elements are as follows:
;                                       |[0] - The width of each character in the font, in logical units
;                                       |[1] - the height of each character in the font, in logical units
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683165.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetFontSize($hConsoleOutput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tCONSOLE_FONT_INFO = _Console_GetCurrentFont($hConsoleOutput, False, $hDll)

	Local $aResult = DllCall($hDll, "DWORD", "GetConsoleFontSize", _
			"handle", $hConsoleOutput, _
			"dword", $tCONSOLE_FONT_INFO.Font)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [BitAND($aResult[0], 0xFFFF), BitShift($aResult[0], 16)]
	Return $aRet
EndFunc   ;==>_Console_GetFontSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetHistoryBufferSize
; Description ...: Gets the number of events stored in a history buffer for the current console.
; Syntax ........: _Console_GetHistoryBufferSize( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The number of commands kept in each history buffer.
;                  Failure              - Less than zero and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetHistoryInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetHistoryBufferSize($hDll = -1)
	Local $tConsoleHistoryInfo = _Console_GetHistoryInfo($hDll)
	If @error Then Return SetError(@error, @extended, -1)

	Return $tConsoleHistoryInfo.HistoryBufferSize
EndFunc   ;==>_Console_GetHistoryBufferSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetHistoryDuplicates
; Description ...: Gets whether duplicate entries will be stored in the history buffer.
; Syntax ........: _Console_GetHistoryDuplicates( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True if duplicates are stored, false otherwise.
;                  Failure              - False and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetHistoryInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetHistoryDuplicates($hDll = -1)
	Local $tConsoleHistoryInfo = _Console_GetHistoryInfo($hDll)
	If @error Then Return SetError(@error, @extended, False)

	Return $tConsoleHistoryInfo.Flags <> $HISTORY_NO_DUP_FLAG
EndFunc   ;==>_Console_GetHistoryDuplicates

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetHistoryInfo
; Description ...: Retrieves the history settings for the calling process's console.
; Syntax ........: _Console_GetHistoryInfo( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_HISTORY_INFO structure.
;                  Failure              - 0
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetHistoryBufferSize, _Console_GetHistoryNumberOfBuffers, _Console_GetHistoryDuplicates
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683166.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetHistoryInfo($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tConsoleHistoryInfo = DllStructCreate($tagCONSOLE_HISTORY_INFO)
	$tConsoleHistoryInfo.Size = DllStructGetSize($tConsoleHistoryInfo)

	Local $aResult = DllCall($hDll, "bool", "GetConsoleHistoryInfo", _
			"struct*", $tConsoleHistoryInfo)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $tConsoleHistoryInfo
EndFunc   ;==>_Console_GetHistoryInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetHistoryNumberOfBuffers
; Description ...: Gets the number of history buffers kept for this console process.
; Syntax ........: _Console_GetHistoryNumberOfBuffers( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The number of history buffers kept for this console process.
;                  Failure              - Less than zero and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetHistoryInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetHistoryNumberOfBuffers($hDll = -1)
	Local $tConsoleHistoryInfo = _Console_GetHistoryInfo($hDll)
	If @error Then Return SetError(@error, @extended, -1)

	Return $tConsoleHistoryInfo.NumberOfHistoryBuffers
EndFunc   ;==>_Console_GetHistoryNumberOfBuffers

; #FUNCTION# ====================================================================================================
; Name ..........: _Console_GetInput
; Description....: Get user input from the console
; Syntax ........: _Console_GetInput( [
;                          $sPrompt [,
;                          $iLen [,
;                          $autoReturn [,
;                          $validateEach [,
;                          $validateFinal [,
;                          $hideInput [,
;                          $maskChar ]]]]]]] )
; Parameters.....: $sPrompt             - [Optional] Prompt text to display before input
;                  $iLen                - [Optional] Maximum length of input
;                  $autoReturn          - [Optional] Automatically return when $iLen is reached
;                  $validateEach        - [Optional] Regular expression to validate each character as it is input
;                  $validateFinal       - [Optional] Regular expression to validate the final input
;                  $hideInput           - [Optional] Do no print input characters
;                  $maskChar            - [Optional] If $hideInput is true, the character to print instead of
;                                         input
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI
;                                         is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll
;                                         which could slow it down. If you are calling lots of functions from the
;                                         same dll then this recommended.
; Return values..: Success - Input string
;                  Failure - Empty string
; Author.........: Erik Pilsits (Wraithdu)
; Modified ......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _Console_GetInput($sPrompt = "", _
		$iLen = 0, _
		$autoReturn = False, _
		$validateEach = "", _
		$validateFinal = "", _
		$hideInput = False, _
		$maskChar = "", _
		$fUnicode = Default, _
		$hDll = -1)
	$iLen = Abs($iLen)
	$maskChar = StringLeft($maskChar, 1)
	If $sPrompt <> "" Then _Console_Write($sPrompt, $fUnicode, $hDll)
	Local $sChars = "", $sIn, $aPos
	; get starting cursor position
	Local $aPosStart = _Console_GetCursorPosition(-1, $hDll)
	Local $aSize = _Console_GetScreenBufferSize(-1, $hDll)

	While True
		$sIn = AscW(_Console_Read(False, $fUnicode, $hDll))
		If $sIn < 32 Then
			; control characters
			Switch $sIn
				Case 13 ; ENTER
					; validate if no length or length not reached
					; otherwise validation was performed upon input
					If ($validateFinal <> "") And ((Not $iLen) Or (StringLen($sChars) < $iLen)) Then
						If Not StringRegExp($sChars, $validateFinal, 0) Then
							; failed validation
							; erase entire input
							If Not $hideInput Or ($hideInput And ($maskChar <> "")) Then
								; use starting position
								_Console_FillOutputCharacter(-1, " ", StringLen($sChars), $aPosStart[0], $aPosStart[1], $fUnicode, $hDll)
								_Console_SetCursorPosition(-1, $aPosStart[0], $aPosStart[1])
							EndIf
							$sChars = ""
							ContinueLoop
						EndIf
					EndIf
					; no validation or passed validation
					ExitLoop
				Case 8 ; BACKSPACE
					If $sChars <> "" Then
						If Not $hideInput Or ($hideInput And ($maskChar <> "")) Then
							; use current position
							$aPos = _Console_GetCursorPosition(-1, $hDll)
							If $aPos[0] = 0 Then
								; beginning of line of wrapped text
								$aPos[0] = $aSize[0]
								$aPos[1] -= 1
							EndIf
							_Console_WriteOutputCharacter(-1, " ", $aPos[0] - 1, $aPos[1], $fUnicode, $hDll)
							_Console_SetCursorPosition(-1, $aPos[0] - 1, $aPos[1], $hDll)
						EndIf
						$sChars = StringTrimRight($sChars, 1)
					EndIf
				Case 27 ; ESCAPE
					Return ""
			EndSwitch
		Else
			; printable characters
			; length reached, do nothing
			If $iLen And (StringLen($sChars) >= $iLen) Then ContinueLoop
			; get character
			$sIn = ChrW($sIn)
			; validate each character?
			If ($validateEach <> "") And (Not StringRegExp($sIn, $validateEach, 0)) Then ContinueLoop
			$sChars &= $sIn
			; always validate when length reached
			If ($validateFinal <> "") And $iLen And (StringLen($sChars) >= $iLen) Then
				If Not StringRegExp($sChars, $validateFinal, 0) Then
					; failed validation
					; erase last char input, do not print
					$sChars = StringTrimRight($sChars, 1)
					ContinueLoop
				EndIf
			EndIf
			; no validation or passed validation or no length or length not reached
			; print character?
			If Not $hideInput Then
				_Console_Write($sIn, $fUnicode, $hDll)
			ElseIf $hideInput And ($maskChar <> "") Then
				_Console_Write($maskChar, $fUnicode, $hDll)
			EndIf
			; autoReturn?
			If $autoReturn And $iLen And (StringLen($sChars) >= $iLen) Then ExitLoop
		EndIf
	WEnd
	Return $sChars
EndFunc   ;==>_Console_GetInput

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetLargestWindowSize
; Description ...: Retrieves the size of the largest possible console window.
; Syntax ........: _Console_GetLargestWindowSize( [$hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - An array with the following elements:
;                                       |[0] - The width of the largest possible console window.
;                                       |[1] - The height of the largest possible console window.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683193.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetLargestWindowSize($hConsoleOutput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "DWORD", "GetLargestConsoleWindowSize", _
			"handle", $hConsoleOutput)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [BitAND($aResult[0], 0xFFFF), BitShift($aResult[0], 16)]
	Return $aRet
EndFunc   ;==>_Console_GetLargestWindowSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetMode
; Description ...: Retrieves the current input mode of a console's input buffer or the current output mode of a console screen
;                  buffer.
; Syntax ........: _Console_GetMode( [$hConsoleHandle [, $hDll ]] )
; Parameters ....: $hConsoleHandle      - A handle to the console input buffer or the console screen buffer. The handle must
;                                         have the GENERIC_READ access right. Default is the running process' console screen
;                                         buffer.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The current mode of the specified buffer. If the hConsoleHandle parameter is an input
;                                         handle, the mode can be one or more of the following values. When a console is created,
;                                         all input modes except ENABLE_WINDOW_INPUT are enabled by default.
;                                       |ENABLE_ECHO_INPUT - Characters read by the ReadFile or ReadConsole function are written
;                                                            to the active screen buffer as they are read. This mode can be used
;                                                            only if the ENABLE_LINE_INPUT mode is also enabled.
;                                       |ENABLE_INSERT_MODE - When enabled, text entered in a console window will be inserted at
;                                                             the current cursor location and all text following that location
;                                                             will not be overwritten. When disabled, all following text will be
;                                                             overwritten.
;                                       |ENABLE_LINE_INPUT - The ReadFile or ReadConsole function returns only when a carriage
;                                                            return character is read. If this mode is disabled, the functions
;                                                            return when one or more characters are available.
;                                       |ENABLE_MOUSE_INPUT - If the mouse pointer is within the borders of the console window
;                                                             and the window has the keyboard focus, mouse events generated by
;                                                             mouse movement and button presses are placed in the input buffer.
;                                                             These events are discarded by _WinApi_ReadFile or
;                                                             _Console_Read, even when this mode is enabled.
;                                       |ENABLE_PROCESSED_INPUT - CTRL+C is processed by the system and is not placed in the
;                                                                 input buffer. If the input buffer is being read by
;                                                                 _WinApi_ReadFile or _Console_Read, other control keys
;                                                                 are processed by the system and are not returned in the
;                                                                 _WinApi_ReadFile or
;                                                                 _Console_Read buffer. If the ENABLE_LINE_INPUT mode is
;                                                                 also enabled, backspace, carriage return, and linefeed
;                                                                 characters are handled by the system.
;                                       |ENABLE_QUICK_EDIT_MODE - This flag enables the user to use the mouse to select and edit
;                                                                 text.
;                                       |ENABLE_WINDOW_INPUT - User interactions that change the size of the console screen
;                                                              buffer are reported in the console's input buffer. Information
;                                                              about these events can be read from the input buffer by
;                                                              applications using the _Console_ReadInput function, but
;                                                              not by those using _WinApi_ReadFile or _Console_Read.
;                                       If the hConsoleHandle parameter is a screen buffer handle, the mode can be one or more of
;                                       the following values. When a screen buffer is created, both output modes are enabled by
;                                       default.
;                                       |ENABLE_PROCESSED_OUTPUT - Characters written by the _Console_WriteFile or
;                                                                  _Console_WriteConsole function or echoed by the
;                                                                  _WinApi_ReadFile or _Console_Read function are parsed
;                                                                  for ASCII control sequences, and the correct action is
;                                                                  performed. Backspace, tab, bell, carriage return, and linefeed
;                                                                  characters are processed.
;                                       |ENABLE_WRAP_AT_EOL_OUTPUT - When writing with WriteFile or WriteConsole or echoing with
;                                                                    _WinApi_ReadFile or _Console_Read, the cursor moves
;                                                                   to the beginning of the next row when it reaches the end of
;                                                                   the current row. This causes the rows displayed in the
;                                                                   console window to scroll up automatically when the cursor
;                                                                   advances beyond the last row in the window. It also causes
;                                                                   the contents of the console screen buffer to scroll up
;                                                                   (discarding the top row of the console screen buffer) when
;                                                                   the cursor advances beyond the last row in the console screen
;                                                                   buffer. If this mode is disabled, the last character in the
;                                                                   row is overwritten with any subsequent characters.
;                  Failure              - 0
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683167.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetMode($hConsoleHandle = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleHandle = -1 Then $hConsoleHandle = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "GetConsoleMode", _
			"handle", $hConsoleHandle, _
			"dword*", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $aResult[2]
EndFunc   ;==>_Console_GetMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetNumberOfInputEvents
; Description ...: Retrieves the number of unread input records in the console's input buffer.
; Syntax ........: _Console_GetNumberOfInputEvents( [$hConsoleInput [, $hDll ]] )
; Parameters ....: $hConsoleInput       - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The number of unread input records in the console's input buffer.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683207.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetNumberOfInputEvents($hConsoleInput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "GetNumberOfConsoleInputEvents", _
			"handle", $hConsoleInput, _
			"dword*", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $aResult[2]
EndFunc   ;==>_Console_GetNumberOfInputEvents

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetNumberOfMouseButtons
; Description ...: Retrieves the number of buttons on the mouse used by the current console.
; Syntax ........: _Console_GetNumberOfMouseButtons( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The number of buttons on the mouse used by the current console.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683208.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetNumberOfMouseButtons($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "GetNumberOfConsoleMouseButtons", _
			"dword*", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $aResult[1]
EndFunc   ;==>_Console_GetNumberOfMouseButtons

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetOriginalTitle
; Description ...: Retrieves the original title for the current console window.
; Syntax ........: _Console_GetOriginalTitle( [ $fUnicode [, $hDll ]] )
; Parameters ....: $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A string containing the original title for the current console window.
;                  Failure              - A blank string
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: To set the title for a console window, use the _Console_SetTitle function. To retrieve the current
;                  title string, use the _Console_GetTitle function.
; Related .......: _Console_SetTitle, _Console_GetTitle
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683168.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetOriginalTitle($fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tConsoleTitle = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[128]")

	Local $aResult = DllCall($hDll, "dword", "GetConsoleOriginalTitle" & ($fUnicode ? "W" : "A"), _
			"struct*", $tConsoleTitle, _
			"dword", DllStructGetSize($tConsoleTitle))
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")

	Return $tConsoleTitle.buffer
EndFunc   ;==>_Console_GetOriginalTitle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetOutputCP
; Description ...: Retrieves the output code page used by the console associated with the calling process.
; Syntax ........: _Console_GetOutputCP( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: A code that identifies the code page. See http://msdn.microsoft.com/en-us/library/dd317756(v=VS.85).aspx
;                  for possible values.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: A code page maps 256 character codes to individual characters. Different code pages include different special
;                  characters, typically customized for a language or a group of languages. To retrieve more information about a
;                  code page, including it's name, see the GetCPInfoEx function.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683169.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetOutputCP($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "uint", "GetConsoleOutputCP")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_Console_GetOutputCP

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetProcessList
; Description ...: Retrieves a list of the processes attached to the current console.
; Syntax ........: _Console_GetProcessList( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - An array of PID's of the processes attached to the current console.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683170.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetProcessList($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $iProcessCount = 1
	Local $tProcessList = DllStructCreate("dword list[" & $iProcessCount & "]")

	Local $aResult = DllCall($hDll, "dword", "GetConsoleProcessList", _
			"struct*", $tProcessList, _
			"dword", $iProcessCount)
	If @error Or ($aResult[0] < 1) Then Return SetError(@error, @extended, 0)

	If $aResult[0] > 1 Then
		$iProcessCount = $aResult[0]

		$tProcessList = DllStructCreate("dword[" & $iProcessCount & "]")

		$aResult = DllCall($hDll, "dword", "GetConsoleProcessList", _
				"struct*", $tProcessList, _
				"dword", $iProcessCount)
		If @error Or ($aResult[0] < 1) Then Return SetError(@error, @extended, 0)
	EndIf

	Local $aRet[$aResult[0]]
	For $i = 0 To $aResult[0] - 1
		$aRet[$i] = DllStructGetData($tProcessList, 1, $i)
	Next

	Return $aRet
EndFunc   ;==>_Console_GetProcessList

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferAttributes
; Description ...: Retrieves the attributes of the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferAttributes( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The attributes used when writing to the screen buffer. This is a combination of the
;                                         following flags:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal.
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attributes.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
;                  Failure              - Zero and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferAttributes($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfo = _Console_GetScreenBufferInfo($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tConsoleScreenBufferInfo.Attributes
EndFunc   ;==>_Console_GetScreenBufferAttributes

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferColorTable
; Description ...: Retrieves the specified console screen buffer's color settings.
; Syntax ........: _Console_GetScreenBufferColorTable( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - Returns a 16-element array containing the COLORREF (BGR!) values used in the console.
;                  Failure              - False and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfoEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferColorTable($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfoEx = _Console_GetScreenBufferInfoEx($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[16]
	For $i = 0 To 15
		$aRet[$i] = DllStructGetData($tConsoleScreenBufferInfoEx, "ColorTable", $i + 1)
	Next

	Return $aRet
EndFunc   ;==>_Console_GetScreenBufferColorTable

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferFullscreen
; Description ...: Retrieves whether fullscreen mode is allowed for the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferFullscreen( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - Returns True if fullscreen mode is allowed, False otherwise.
;                  Failure              - False and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfoEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferFullscreen($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfoEx = _Console_GetScreenBufferInfoEx($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, False)

	Return $tConsoleScreenBufferInfoEx.FullscreenSupported
EndFunc   ;==>_Console_GetScreenBufferFullscreen

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferInfo
; Description ...: Retrieves information about the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferInfo( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_SCREEN_BUFFER_INFO struct.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCursorPosition, _Console_GetScreenBufferSize, _Console_GetScreenBufferAttributes,
;                  _Console_GetScreenBufferPos, _Console_GetScreenBufferSize, _Console_GetScreenBufferInfoEx
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683171.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferInfo($hConsoleOutput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tConsoleScreenBufferInfo = DllStructCreate($tagCONSOLE_SCREEN_BUFFER_INFO)

	Local $aResult = DllCall($hDll, "bool", "GetConsoleScreenBufferInfo", _
			"handle", $hConsoleOutput, _
			"struct*", $tConsoleScreenBufferInfo)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $tConsoleScreenBufferInfo
EndFunc   ;==>_Console_GetScreenBufferInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferInfoEx
; Description ...: Retrieves extended information about the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferInfoEx( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_SCREEN_BUFFER_INFOEX struct.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfo, _Console_GetScreenBufferPopupAttributes, _Console_GetScreenBufferFullscreen,
;                  _Console_GetScreenBufferColorTable
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683172.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferInfoEx($hConsoleOutput = -1, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tConsoleScreenBufferInfoEx = DllStructCreate($tagCONSOLE_SCREEN_BUFFER_INFOEX)
	$tConsoleScreenBufferInfoEx.Size = DllStructGetSize($tConsoleScreenBufferInfoEx)

	Local $aResult = DllCall($hDll, "bool", "GetConsoleScreenBufferInfoEx", _
			"handle", $hConsoleOutput, _
			"struct*", $tConsoleScreenBufferInfoEx)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $tConsoleScreenBufferInfoEx
EndFunc   ;==>_Console_GetScreenBufferInfoEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferMaxSize
; Description ...: Retrieves the maximum size of the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferMaxSize( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - Returns a 2-element array containing the following information:
;                                       |[0] - Max width
;                                       |[1] - Max height
;                  Failure              - Zero and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferMaxSize($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfo = _Console_GetScreenBufferInfo($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [$tConsoleScreenBufferInfo.MaximumWindowSizeX, $tConsoleScreenBufferInfo.MaximumWindowSizeY]
	Return $aRet
EndFunc   ;==>_Console_GetScreenBufferMaxSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferPopupAttributes
; Description ...: Retrieves the fill attribute for console pop-ups for the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferPopupAttributes( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - Returns the fill attribute for console pop-ups.
;                  Failure              - Zero and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfoEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferPopupAttributes($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfoEx = _Console_GetScreenBufferInfoEx($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tConsoleScreenBufferInfoEx.PopupAttributes
EndFunc   ;==>_Console_GetScreenBufferPopupAttributes

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferPos
; Description ...: Retrieves the position of the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferPos( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - Returns a 4-element array containing the following information:
;                                       |[0] - X position
;                                       |[1] - Y position
;                                       |[2] - Width
;                                       |[3] - Height
;                  Failure              - Zero and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferPos($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfo = _Console_GetScreenBufferInfo($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[4] = [$tConsoleScreenBufferInfo.Left, $tConsoleScreenBufferInfo.Top, _
			$tConsoleScreenBufferInfo.Right - $tConsoleScreenBufferInfo.Left, $tConsoleScreenBufferInfo.Bottom - $tConsoleScreenBufferInfo.Top]
	Return $aRet
EndFunc   ;==>_Console_GetScreenBufferPos

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetScreenBufferSize
; Description ...: Retrieves the size of the specified console screen buffer.
; Syntax ........: _Console_GetScreenBufferSize( [ $hConsoleOutput [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A 2 element array:
;                                       |[0] - The width of the screen buffer in character cells.
;                                       |[1] - The height of the screen buffer in character cells.
;                  Failure              - Zero and sets the @Error flag.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetScreenBufferSize($hConsoleOutput = -1, $hDll = -1)
	Local $tConsoleScreenBufferInfo = _Console_GetScreenBufferInfo($hConsoleOutput, $hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [$tConsoleScreenBufferInfo.SizeX, $tConsoleScreenBufferInfo.SizeY]
	Return $aRet
EndFunc   ;==>_Console_GetScreenBufferSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetSelectionAnchor
; Description ...: Retrieves the anchor point the current console selection.
; Syntax ........: _Console_GetSelectionAnchor( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A 2-element array:
;                                       |[0] - The X coord of the selection anchor, in character cells.
;                                       |[1] - The Y coord of the selection anchor, in character cells.
;                  Failure              - Zero and sets the @Error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetSelectionInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetSelectionAnchor($hDll = -1)
	Local $tConsoleSelectionInfo = _Console_GetSelectionInfo($hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[2] = [$tConsoleSelectionInfo.X, $tConsoleSelectionInfo.Y]
	Return $aRet
EndFunc   ;==>_Console_GetSelectionAnchor

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetSelectionFlags
; Description ...: Retrieves the flags for the current selection.
; Syntax ........: _Console_GetSelectionFlags( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The selection indicator. This can be one or more of the following values.
;                                       |CONSOLE_MOUSE_DOWN - Mouse is down
;                                       |CONSOLE_MOUSE_SELECTION - Selecting with the mouse
;                                       |CONSOLE_NO_SELECTION - No selection
;                                       |CONSOLE_SELECTION_IN_PROGRESS - Selection has begun
;                                       |CONSOLE_SELECTION_NOT_EMPTY - Selection rectangle is not empty
;                  Failure              - Zero and sets the @Error flag
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetSelectionInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetSelectionFlags($hDll = -1)
	Local $tConsoleSelectionInfo = _Console_GetSelectionInfo($hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tConsoleSelectionInfo.Flags
EndFunc   ;==>_Console_GetSelectionFlags

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetSelectionInfo
; Description ...: Retrieves information about the current console selection.
; Syntax ........: _Console_GetSelectionInfo( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A CONSOLE_SELECTION_INFO struct
;                  Failure              - Zero and sets the @Error flag
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683173.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetSelectionInfo($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tConsoleSelectionInfo = DllStructCreate($tagCONSOLE_SELECTION_INFO)

	Local $aResult = DllCall($hDll, "bool", "GetConsoleSelectionInfo", _
			"struct*", $tConsoleSelectionInfo)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $tConsoleSelectionInfo
EndFunc   ;==>_Console_GetSelectionInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetSelectionRect
; Description ...: Retrieves the current console selection rectangle.
; Syntax ........: _Console_GetSelectionRect( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A 4-element array:
;                                       |[0] - The X coordinate of the selection rectangle.
;                                       |[1] - The Y coordinate of the selection rectangle.
;                                       |[2] - The width of the selection rectangle.
;                                       |[3] - The height of the selection rectangle.
;                  Failure              - Zero and sets the @Error flag
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetSelectionInfo, _Console_GetSelectionRectEx
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetSelectionRect($hDll = -1)
	Local $tConsoleSelectionInfo = _Console_GetSelectionInfo($hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aRet[4] = [$tConsoleSelectionInfo.Left, $tConsoleSelectionInfo.Top, _
			$tConsoleSelectionInfo.Right - $tConsoleSelectionInfo.Left, $tConsoleSelectionInfo.Bottom - $tConsoleSelectionInfo.Top]
	Return $aRet
EndFunc   ;==>_Console_GetSelectionRect

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetSelectionRectEx
; Description ...: Retrieves the current console selection rectangle as a SMALL_RECT structure.
; Syntax ........: _Console_GetSelectionRectEx( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A SMALL_RECT structure containing the selection rectangle.
;                  Failure              - Zero and sets the @Error flag
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetSelectionInfo, _Console_GetSelectionRect
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_GetSelectionRectEx($hDll = -1)
	Local $tConsoleSelectionInfo = _Console_GetSelectionInfo($hDll)
	If @error Then Return SetError(@error, @extended, 0)

	Local $tRect = DllStructCreate($tagSMALL_RECT)
	$tRect.Left = $tConsoleSelectionInfo.Left
	$tRect.Top = $tConsoleSelectionInfo.Top
	$tRect.Right = $tConsoleSelectionInfo.Right
	$tRect.Bottom = $tConsoleSelectionInfo.Bottom

	Return $tRect
EndFunc   ;==>_Console_GetSelectionRectEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetStdHandle
; Description ...: Retrieves a handle for the standard input, standard output, or standard error device.
; Syntax ........: _Console_GetStdHandle( [ $nStdHandle [, $hDll ]] )
; Parameters ....: $nStdHandle          - The standard device. Default is STD_OUTPUT_HANDLE. This parameter can be one of the
;                                         following values:
;                                       |STD_INPUT_HANDLE - The standard input device. Initially, this is the console input
;                                                           buffer, CONIN$.
;                                       |STD_OUTPUT_HANDLE - The standard output device. Initially, this is the active console
;                                                            screen buffer, CONOUT$. (Default)
;                                       |STD_ERROR_HANDLE - The standard error device. Initially, this is the active console
;                                                           screen buffer, CONOUT$.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A handle to the specified device, or a redirected handle set by a previous call to
;                                         _Console_SetStdHandle. The handle has GENERIC_READ and GENERIC_WRITE access rights,
;                                         unless the application has used SetStdHandle to set a standard handle with lesser
;                                         access.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683231.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetStdHandle($nStdHandle = -11, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "handle", "GetStdHandle", _
			"dword", $nStdHandle)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_Console_GetStdHandle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetTitle
; Description ...: Retrieves the title for the current console window.
; Syntax ........: _Console_GetTitle( [ $fUnicode [, $hDll ]] )
; Parameters ....: $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The current console's title.
;                  Failure              - A blank string
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683174.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetTitle($fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "dword", "GetConsoleTitle" & ($fUnicode ? "W" : "A"), _
			"ptr", 0, _
			"dword", 0)
	If @error Then Return SetError(@error, @extended, "")

	Local $tConsoleTitle = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[" & $aResult[0] & "]")

	$aResult = DllCall($hDll, "dword", "GetConsoleTitle" & ($fUnicode ? "W" : "A"), _
			"struct*", $tConsoleTitle, _
			"dword", $aResult[0])
	If @error Then Return SetError(@error, @extended, "")

	Return $tConsoleTitle.buffer
EndFunc   ;==>_Console_GetTitle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_GetWindow
; Description ...: Retrieves the window handle used by the console associated with the calling process.
; Syntax ........: _Console_GetWindow( [ $hDll ] )
; Parameters ....: $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - A handle to the window used by the console associated with the calling process.
;                  Failure              - zero
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms683175.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_GetWindow($hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "hwnd", "GetConsoleWindow")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_Console_GetWindow

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_Pause
; Description ...: Pause the execution of the script until the user presses a key or timeout.
; Syntax ........: _Console_Pause( [ $sMsg = Default [, $iTime = -1 [, $fUnicode = Default [, $hDll = -1 ]]]] )
; Parameters ....: $hConsoleInput       - A handle to the console input buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iTime               - Pause timeout in milliseconds, -1 for INFINITE.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - Character pressed or empty string in case of timeout
;                  Failure              - Empty string and sets @error
;                                       | 1 - WaitForSingleObject failed
;                  @extended            - 1 if wait timed out, otherwise 0
; Author ........: Erik Pilsits (Wraithdu)
; Modified ......:
; Remarks .......: Returns once something has been typed into console.
; Related .......: _Console_PauseMessage
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_Pause($hConsoleInput = -1, $iTime = -1, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	; wait for input
	_Console_FlushInputBuffer($hConsoleInput, $hDll)
	Local $ret = _WinAPI_WaitForSingleObject($hConsoleInput, $iTime)
	If $ret = 0x0102 Then Return SetError(1, 0, "")

	; read input
	; get console mode
	Local $modeOrig = _Console_GetMode($hConsoleInput, $hDll)

	; remove LINE_INPUT
	_Console_SetMode($hConsoleInput, BitAND($modeOrig, BitNOT($ENABLE_LINE_INPUT)), $hDll)
	Local $charOut = _Console_ReadConsoleEx($hConsoleInput, 1, $fUnicode, $hDll)

	; flush any remaining input records
	_Console_FlushInputBuffer($hConsoleInput, $hDll)

	; restore mode
	_Console_SetMode($hConsoleInput, $modeOrig, $hDll)

	Return $charOut
EndFunc   ;==>_Console_Pause

; TODO: Doc
Func _Console_PauseMessage($hConsoleInput = -1, $hConsoleOutput = -1, $sMsg = Default, $iTime = -1, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	If $sMsg = Default Then
		_Console_Write("Press any key to continue . . . ", $fUnicode, $hDll)
	Else
		_Console_Write($sMsg, $fUnicode, $hDll)
	EndIf

	Return _Console_Pause($hConsoleInput, $iTime, $fUnicode, $hDll)
EndFunc   ;==>_Console_PauseMessage

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_Read
; Description ...: Reads data from the current console input buffer and removes it from the buffer.
; Syntax ........: _Console_Read( [ $fEcho [, $fUnicode [, $hDll ]]] )
; Parameters ....: $fEcho               - If 'True' then input is read and echoed until a carriage return. If 'False' then input
;                                         is read, NOT echoed, and returned one character at a time.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The data from the console input buffer read.
;                  Failure              - A blank string.
; Author ........: Matt Diesel (Mat)
; Modified ......: Erik Pilsits (Wraithdu)
; Remarks .......: This Reads characters until a linebreak is found.
; Related .......: _Console_ReadConsole, _Console_ReadConsoleEx
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684958.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_Read($fEcho = True, $fUnicode = Default, $hDll = -1)
	Return _Console_ReadConsole(-1, $fEcho, $fUnicode, $hDll)
EndFunc   ;==>_Console_Read

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_ReadConsole
; Description ...: Reads data from a console input buffer and removes it from the buffer.
; Syntax ........: _Console_ReadConsole( [ $hConsoleInput [, $fEcho [, $fUnicode [, $hDll ]]]] )
; Parameters ....: $hConsoleInput       - A handle to the console input buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fEcho               - If 'True' then input is read and echoed until a carriage return. If 'False' then input
;                                         is read, NOT echoed, and returned one character at a time.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The data from the console input buffer read.
;                  Failure              - A blank string.
; Author ........: Matt Diesel (Mat)
; Modified ......: Erik Pilsits (Wraithdu)
; Remarks .......: This Reads characters until a linebreak is found.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684958.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_ReadConsole($hConsoleInput = -1, $fEcho = True, $fUnicode = Default, $hDll = -1)
	Local $sRet

	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $modeOrig = _Console_GetMode($hConsoleInput, $hDll)

	If $fEcho Then
		Local $sTemp

		; read input, echo each character, until carriage return
		; make sure LINE_INPUT is ON
		_Console_SetMode($hConsoleInput, BitOR($modeOrig, $ENABLE_LINE_INPUT), $hDll)

		$sRet = ""
		While 1
			$sTemp = _Console_ReadConsoleEx($hConsoleInput, 1, $fUnicode, $hDll)
			If $sTemp = @CR Then
				; read the leftover @LF
				_Console_ReadConsoleEx($hConsoleInput, 1, $fUnicode, $hDll)
				ExitLoop
			EndIf
			$sRet &= $sTemp
		WEnd
	Else
		; read input, NO echo, return immediately after each record is read
		; remove LINE_INPUT
		_Console_SetMode($hConsoleInput, BitAND($modeOrig, BitNOT($ENABLE_LINE_INPUT)), $hDll)
		$sRet = _Console_ReadConsoleEx($hConsoleInput, 1, $fUnicode, $hDll)
	EndIf

	; restore console mode
	_Console_SetMode($hConsoleInput, $modeOrig, $hDll)

	Return $sRet
EndFunc   ;==>_Console_ReadConsole

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_ReadConsoleEx
; Description ...: Reads data from a console input buffer and removes it from the buffer.
; Syntax ........: _Console_ReadConsoleEx($hConsoleInput, $nNumberOfCharsToRead [, $fUnicode [, $hDll ]] )
; Parameters ....: $hConsoleInput       - A handle to the console input buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $nNumberOfCharsToRead- The number of characters to read from the buffer.
;                  $fUnicode            - If 'True' then the unicode version will be used (default). If 'False' then ANSI is used
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The data from the console input buffer read.
;                  Failure              - A blank string.
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_Read, _Console_ReadConsole
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684958.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_ReadConsoleEx($hConsoleInput, $nNumberOfCharsToRead, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $tBuffer = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[" & $nNumberOfCharsToRead & "]")

	Local $aResult = DllCall($hDll, "BOOL", "ReadConsole" & ($fUnicode ? "W" : "A"), _
			"handle", $hConsoleInput, _
			"struct*", $tBuffer, _
			"dword", $nNumberOfCharsToRead, _
			"dword*", 0, _
			"ptr", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, "")

	Return SetExtended($aResult[4], $tBuffer.buffer)
EndFunc   ;==>_Console_ReadConsoleEx
#region WIP


; Returns No. events read, zero = fail
Func _Console_ReadConsoleInput($hConsoleInput, $pBuffer, $iLength, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "BOOL", "ReadConsoleInput" & ($fUnicode ? "W" : "A"), _
			"handle", $hConsoleInput, _
			"ptr", $pBuffer, _
			"int", $iLength, _
			"int*", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, 0)

	Return $aResult[4]
EndFunc   ;==>_Console_ReadConsoleInput

Func _Console_ReadConsoleInputRecord($hConsoleInput = -1, $fUnicode = Default, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hConsoleInput = -1 Then $hConsoleInput = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $tInputRecord = DllStructCreate($tagINPUT_RECORD)

	If _Console_ReadConsoleInput($hConsoleInput, DllStructGetPtr($tInputRecord), 1, $fUnicode, $hDll) = 0 Then Return SetError(@error, @extended, 0)

	Return $tInputRecord
EndFunc   ;==>_Console_ReadConsoleInputRecord

Func _Console_ReadInput($pBuffer, $iLength, $fUnicode = Default, $hDll = -1)
	Return _Console_ReadConsoleInput(-1, $pBuffer, $iLength, $fUnicode, $hDll)
EndFunc   ;==>_Console_ReadInput

Func _Console_ReadInputRecord($fUnicode = Default, $hDll = -1)
	Return _Console_ReadConsoleInputRecord(-1, $fUnicode, $hDll)
EndFunc   ;==>_Console_ReadInputRecord
#endregion WIP


; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_ReadOutputCharacter
; Description ...: Copies a number of characters from consecutive cells of a console screen buffer, beginning at a specified
;                  location.
; Syntax ........: _Console_ReadOutputCharacter($hConsoleOutput, $nNumberOfCharsToRead, $iX, $iY [, $fUnicode [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $nNumberOfCharsToRead- The number of characters to read from the buffer.
;                  $iX                  - The character column to start reading from
;                  $iY                  - The character row to start reading from
;                  $fUnicode            - If 'True' then the unicode version will be used (default). If 'False' then ANSI is used
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - The string of characters read. The number of characters actually read is returned in
;                                         @extended.
;                  Failure              - A blank string and sets @error.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: The difference between this and _Console_ReadConsoleEx is that this function allows you to read the output of
;                  any console from any location.
; Related .......: _Console_ReadConsole, _Console_WriteOutputCharacter
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684969.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_ReadOutputCharacter($hConsoleOutput, $nNumberOfCharsToRead, $iX, $iY, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tBuffer = DllStructCreate(($fUnicode ? "w" : "") & "char buffer[" & $nNumberOfCharsToRead & "]")

	Local $aResult = DllCall($hDll, "bool", "ReadConsoleOutputCharacterW", _
			"handle", $hConsoleOutput, _
			"struct*", $tBuffer, _
			"dword", $nNumberOfCharsToRead, _
			"dword", BitShift($iY, -16) + $iX, _
			"dword*", 0)
	If @error Or (Not $aResult[0]) Then Return SetError(@error, @extended, "")

	Return SetExtended($aResult[4], $tBuffer.buffer)
EndFunc   ;==>_Console_ReadOutputCharacter

; #FUNCTION# ====================================================================================================
; Name ..........: _Console_Run
; Description....: Run a command in the console window
; Syntax ........: _Console_Run($sCmd [, $fWait [, $fNew [, $iShow]]] )
; Parameters.....: $sCmd     - Command to run
;                  $fWait    - [Optional] Wait for command to finish
;                  $fNew     - [Optional] Run in new console window
;                  $iShow    - [Optional] Show flag (default for Run(Wait) is @SW_HIDE)
;
; Return values..: Success - See Run(Wait) functions
;                  Failure - See Run(Wait) functions
; Author.........: Erik Pilsits
; Modified ......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _Console_Run($sCmd, $fWait = True, $fNew = False, $iShow = Default)
	Local $iFlag = 0x10
	If $fNew Then $iFlag = 0x10000

	If $fWait Then Return RunWait($sCmd, "", $iShow, $iFlag)
	Return Run($sCmd, "", $iShow, $iFlag)
EndFunc   ;==>_Console_Run


#region WIP

Func _Console_RunConsole($hStdIn, $hStdOut, $hStdErr, $sCmd, $fWait = True, $fNew = False, $iShow = Default, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hStdIn = -1 Then $hStdIn = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)
	If $hStdOut = -1 Then $hStdOut = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)
	If $hStdErr = -1 Then $hStdErr = _Console_GetStdHandle($STD_ERROR_HANDLE, $hDll)

	Local $tStartUpInfo = DllStructCreate($tagSTARTUPINFO)

	$tStartUpInfo.Flags = 0x00000100 ; $STARTF_USESTDHANDLES
	$tStartUpInfo.StdInput = $hStdIn
	$tStartUpInfo.StdOutput = $hStdOut
	$tStartUpInfo.StdError = $hStdErr

	Local $tProcInfo = DllStructCreate($tagPROCESS_INFORMATION)

	If Not _WinAPI_CreateProcess(0, $sCmd, 0, 0, True, 0, 0, @WorkingDir, DllStructGetPtr($tStartUpInfo), DllStructGetPtr($tProcInfo)) Then _
			Return SetError(1, 0, 0)

	If $fWait Then
		ProcessWaitClose($tProcInfo.ProcessID)
		Return SetError(@error, 0, @error ? 0 : @extended)
	EndIf

	Return $tProcInfo.ProcessID
EndFunc   ;==>_Console_RunConsole

#endregion WIP

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_ScrollScreenBuffer
; Description ...: Moves a block of data in a screen buffer.
; Syntax ........: _Console_ScrollScreenBuffer($hConsoleOutput,
;                  $iFromX, $iFromY,
;                  $iFromWidth, $iFromHeight,
;                  $iToX, $iToY
;                  [, $sFillChar [, $iFillAttributes
;                  [, $fUnicode [, $hDll ]]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iFromX              - The X coordinate of the console screen buffer rectangle to be moved.
;                  $iFromY              - The Y coordinate of the console screen buffer rectangle to be moved.
;                  $iFromWidth          - The width of the console screen buffer rectangle to be moved.
;                  $iFromHeight         - The height of the console screen buffer rectangle to be moved.
;                  $iToX                - The X coordinate of the upper-left corner of the new location of the rectangle contents
;                                         , in characters.
;                  $iToY                - The Y coordinate of the upper-left corner of the new location of the rectangle contents
;                                         , in characters.
;                  $sFillChar           - The character to fill any cells that were left empty as a result of the move with.
;                                         Default is a blank (or space) " ".
;                  $iFillAttributes     - The attributes to fill any cells that were left empty as a result of the move with.
;                                         This member can be zero or any combination of the following values:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attribute.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
;                  $fUnicode            - If 'True' then the unicode version will be used (default). If 'False' then ANSI is used
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: None
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_ScrollScreenBufferEx
; Link ..........: http://msdn.microsoft.com/en-us/library/ms685107.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_ScrollScreenBuffer($hConsoleOutput, _
		$iFromX, $iFromY, _
		$iFromWidth, $iFromHeight, _
		$iToX, $iToY, _
		$sFillChar = " ", $iFillAttributes = Default, _
		$fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)
	If $iFillAttributes = Default Then $iFillAttributes = _Console_GetScreenBufferAttributes($hConsoleOutput, $hDll)

	Local $tScrollRect = DllStructCreate($tagSMALL_RECT)
	$tScrollRect.Left = $iFromX
	$tScrollRect.Top = $iFromY
	$tScrollRect.Right = $iFromX + $iFromWidth
	$tScrollRect.Bottom = $iFromY + $iFromHeight

	Local $tFill
	If $fUnicode Then
		$tFill = DllStructCreate($tagCHAR_INFO_W)
	Else
		$tFill = DllStructCreate($tagCHAR_INFO_A)
	EndIf
	$tFill.Char = $sFillChar
	$tFill.Attributes = $iFillAttributes

	Return _Console_ScrollScreenBufferEx($hConsoleOutput, _
			DllStructGetPtr($tScrollRect), _
			$iToX, $iToY, _
			DllStructGetPtr($tFill), _
			0, _
			$fUnicode, $hDll)
EndFunc   ;==>_Console_ScrollScreenBuffer

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_ScrollScreenBufferEx
; Description ...: Moves a block of data in a screen buffer. The effects of the move can be limited by specifying a clipping
;                  rectangle, so the contents of the console screen buffer outside the clipping rectangle are unchanged.
; Syntax ........: _Console_ScrollScreenBufferEx($hConsoleOutput, $pScrollRect, $iOriginX, $iOriginY, $pFill
;                  [, $pClipRect [, $fUnicode [, $hDll ]]] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $pScrollRect         - A pointer to a $tagSMALL_RECT structure whose members specify the upper-left and
;                                         lower-right coordinates of the console screen buffer rectangle to be moved.
;                  $iOriginX            - The X coordinate of the upper-left corner of the new location of the $pScrollRectangle
;                                         contents, in characters.
;                  $iOriginY            - The Y coordinate of the upper-left corner of the new location of the $pScrollRectangle
;                                         contents, in characters.
;                  $pFill               - A pointer to a tagCHAR_INFO structure that specifies the character and color attributes
;                                         to be used in filling the cells within the intersection of $pScrollRect and $pClipRect
;                                         that were left empty as a result of the move.
;                  $pClipRect           - A pointer to a tagSMALL_RECT structure whose members specify the upper-left and
;                                         lower-right coordinates of the console screen buffer rectangle that is affected by
;                                         the scrolling. Default is Zero (everything is affected).
;                  $fUnicode            - If 'True' then the unicode version will be used (default). If 'False' then ANSI is used
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_ScrollScreenBuffer
; Link ..........: http://msdn.microsoft.com/en-us/library/ms685107.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_ScrollScreenBufferEx($hConsoleOutput, _
		$pScrollRect, _
		$iOriginX, $iOriginY, _
		$pFill, _
		$pClipRect = 0, _
		$fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	If IsDllStruct($pScrollRect) Then $pScrollRect = DllStructGetPtr($pScrollRect)
	If IsDllStruct($pFill) Then $pFill = DllStructGetPtr($pFill)
	If $pClipRect <> 0 And IsDllStruct($pClipRect) Then $pClipRect = DllStructGetPtr($pClipRect)

	Local $aResult = DllCall($hDll, "bool", "ScrollConsoleScreenBuffer" & ($fUnicode ? "W" : "A"), _
			"handle", $hConsoleOutput, _
			"ptr", $pScrollRect, _
			"ptr", $pClipRect, _
			"dword", BitShift($iOriginY, -16) + $iOriginX, _
			"ptr", $pFill)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_ScrollScreenBufferEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetActiveScreenBuffer
; Description ...: Sets the specified screen buffer to be the currently displayed console screen buffer.
; Syntax ........: _Console_SetActiveScreenBuffer($hConsoleOutput [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686010.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetActiveScreenBuffer($hConsoleOutput, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "SetConsoleActiveScreenBuffer", _
			"handle", $hConsoleOutput)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetActiveScreenBuffer

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCP
; Description ...: Sets the input code page used by the console associated with the calling process. A console uses its input
;                  code page to translate keyboard input into the corresponding character value.
; Syntax ........: _Console_SetCP($iCodePageID [, $hDll ] )
; Parameters ....: $iCodePageID         - The identifier of the code page to be set. For more information, see Remarks.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: A code page maps 256 character codes to individual characters. Different code pages include different special
;                  characters, typically customized for a language or a group of languages.
;                  The identifiers of the code pages available on the local computer are also stored in the registry under the
;                  following key:
;
;                  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage
;
;                  However, the registry can differ in different versions of Windows.
;                  To retrieve more information about a code page, including its name, use the _Console_GetCPInfoEx function.
;                  To determine a console's current input code page, use the _Console_GetCP function. To set and retrieve
;                  a console's output code page, use the _Console_SetOutputCP and _Console_GetOutputCP functions.
; Related .......: _Console_GetOutputCP, _Console_SetOutputCP, _Console_GetCPInfoEx, _Console_GetCP
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686013.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCP($iCodePageID, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $iCodePageID < 0 Then Return False

	Local $aResult = DllCall($hDll, "bool", "SetConsoleCP", _
			"uint", $iCodePageID)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetCP

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCtrlHandler
; Description ...: Adds or removes an application-defined HandlerRoutine function from the list of handler functions for the
;                  calling process.
; Syntax ........: _Console_SetCtrlHandler($pHandlerRoutine [, $fAdd [, $hDll ]] )
; Parameters ....: $pHandlerRoutine     - A pointer to the application-defined HandlerRoutine callback to be added or removed.
;                                         This parameter can be NULL.
;                  $fAdd                - If this parameter is TRUE, the handler is added; if it is FALSE, the handler is
;                                         removed. If the HandlerRoutine parameter is NULL, a TRUE value causes the calling
;                                         process to ignore CTRL+C input, and a FALSE value restores normal processing of
;                                         CTRL+C input. This attribute of ignoring or processing CTRL+C is inherited by child
;                                         processes.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: It is up to the user to call DllCallback free once the function is no longer needed.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686016.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCtrlHandler($pHandlerRoutine, $fAdd = True, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If Not IsPtr($pHandlerRoutine) Then $pHandlerRoutine = DllCallbackGetPtr($pHandlerRoutine)
	If $pHandlerRoutine = 0 Then Return False

	Local $aResult = DllCall($hDll, "bool", "SetConsoleCtrlHandler", _
			"ptr", $pHandlerRoutine, _
			"bool", $fAdd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetCtrlHandler

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCursorInfo
; Description ...: Sets the size and visibility of the cursor for the specified console screen buffer.
; Syntax ........: _Console_SetCursorInfo($hConsoleOutput, $iSize, $fVisible [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iSize               - The percentage of the character cell that is filled by the cursor. This value is
;                                         between 1 and 100. The cursor appearance varies, ranging from completely filling the
;                                         cell to showing up as a horizontal line at the bottom of the cell.
;                  $fVisible            - The visibility of the cursor. If the cursor is visible, this is TRUE.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: The 'cursor' refers to the console's caret NOT the mouse cursor.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686019.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCursorInfo($hConsoleOutput, $iSize, $fVisible, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	If $iSize = Default Then $iSize = _Console_GetCursorSize($hConsoleOutput, $hDll)
	If $fVisible = Default Then $fVisible = _Console_GetCursorVisible($hConsoleOutput, $hDll)

	Local $tConsoleCursorInfo = DllStructCreate($tagCONSOLE_CURSOR_INFO)
	$tConsoleCursorInfo.Size = $iSize
	$tConsoleCursorInfo.Visible = $fVisible

	Local $aResult = DllCall($hDll, "bool", "SetConsoleCursorInfo", _
			"handle", $hConsoleOutput, _
			"struct*", $tConsoleCursorInfo)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetCursorInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCursorSize
; Description ...: Sets the size of the cursor for the specified console screen buffer.
; Syntax ........: _Console_SetCursorSize($hConsoleOutput, $iSize [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iSize               - The percentage of the character cell that is filled by the cursor. This value is
;                                         between 1 and 100. The cursor appearance varies, ranging from completely filling the
;                                         cell to showing up as a horizontal line at the bottom of the cell.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_SetCursorInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCursorSize($hConsoleOutput, $iSize, $hDll = -1)
	Return _Console_SetCursorInfo($hConsoleOutput, $iSize, Default, $hDll)
EndFunc   ;==>_Console_SetCursorSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCursorVisible
; Description ...: Sets the visibility of the cursor for the specified console screen buffer.
; Syntax ........: _Console_SetCursorVisible($hConsoleOutput, $fVisible [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $fVisible            - The visibility of the cursor. If the cursor is visible, this is TRUE.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_SetCursorInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCursorVisible($hConsoleOutput, $fVisible, $hDll = -1)
	Return _Console_SetCursorInfo($hConsoleOutput, Default, $fVisible, $hDll)
EndFunc   ;==>_Console_SetCursorVisible

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCursorPosition
; Description ...: Sets the cursor position in the specified console screen buffer.
; Syntax ........: _Console_SetCursorPosition($hConsoleOutput, $iX, $iY [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iX                  - The X coord of the new cursor position, in characters. The coordinate must be within
;                                         the boundaries of the console screen buffer.
;                  $iY                  - The Y coord of the new cursor position, in characters. The coordinate must be within
;                                         the boundaries of the console screen buffer.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetCursorInfo, _Console_GetCursorPosition
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686025.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCursorPosition($hConsoleOutput, $iX, $iY, $hDll = -1)
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "SetConsoleCursorPosition", _
			"handle", $hConsoleOutput, _
			"int", BitShift($iY, -16) + $iX)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetCursorPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetCurrentFontEx
; Description ...: Sets extended information about the current console font.
; Syntax ........: _Console_SetCurrentFontEx($hConsoleOutput, $fMaximumWindow, $iFont, $iWidth, $iHeight, $iFontFamily, _
;                  $iFontWeight, $sFaceName [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iFont               - The index of the font in the system's console font table.
;                  $iWidth              - Contains the width of each character in the font, in logical units.
;                  $iHeight             - Contains the height of each character in the font, in logical units.
;                  $iFontFamily         - The font family. This parameter can be one of the following values:
;                                       |FF_DECORATIVE
;                                       |FF_DONTCARE
;                                       |FF_MODERN
;                                       |FF_ROMAN
;                                       |FF_SCRIPT
;                                       |FF_SWISS
;                  $iFontWeight         - The font weight. The weight can range from 100 to 1000, in multiples of 100. For
;                                         example, the normal weight is 400, while 700 is bold.
;                  $sFaceName           - The name of the typeface (such as Courier or Arial).
;                  $fMaximumWindow      - If this parameter is TRUE, font information is set for the maximum window size. If this
;                                         parameter is FALSE, font information is set for the current window size.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686200(VS.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetCurrentFontEx($hConsoleOutput, $iFont, $iWidth, $iHeight, $iFontFamily, $iFontWeight, $sFaceName, $fMaximumWindow = False, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tConsoleCurrentFontEx = DllStructCreate($tagCONSOLE_FONT_INFOEX)
	$tConsoleCurrentFontEx.Font = $iFont
	$tConsoleCurrentFontEx.X = $iWidth
	$tConsoleCurrentFontEx.Y = $iHeight
	$tConsoleCurrentFontEx.FontFamily = $iFontFamily
	$tConsoleCurrentFontEx.FontWeight = $iFontWeight
	$tConsoleCurrentFontEx.FaceName = $sFaceName
	$tConsoleCurrentFontEx.Size = DllStructGetSize($tConsoleCurrentFontEx)

	Local $aResult = DllCall($hDll, "bool", "SetCurrentConsoleFontEx", _
			"handle", $hConsoleOutput, _
			"bool", $fMaximumWindow, _
			"struct*", $tConsoleCurrentFontEx)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetCurrentFontEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetDisplayMode
; Description ...: Sets the display mode of the specified console screen buffer.
; Syntax ........: _Console_SetDisplayMode($hConsoleOutput, $iFlags, $iWidth, $iHeight [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console output buffer.
;                  $iFlags              - The display mode of the console. This parameter can be one or more of the following
;                                         values:
;                                       |CONSOLE_FULLSCREEN_MODE - Text is displayed in full-screen mode.
;                                       |CONSOLE_WINDOWED_MODE - Text is displayed in a console window.
;                  $iWidth              - The new width of the screen buffer, in characters.
;                  $iHeight             - The new height of the screen buffer, in characters.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686028.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetDisplayMode($hConsoleOutput, $iWidth, $iHeight, $iFlags, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "SetConsoleDisplayMode", _
			"handle", $hConsoleOutput, _
			"dword", $iFlags, _
			"int", BitShift($iHeight, -16) + $iWidth)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_Console_SetDisplayMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetHistoryInfo
; Description ...: Sets the history settings for the calling process's console.
; Syntax ........: _Console_SetHistoryInfo($iHistoryBufferSize, $iNumberOfBuffers, $fStoreDuplicates [, $hDll ] )
; Parameters ....: $iHistoryBufferSize  - The number of commands kept in each history buffer.
;                  $iNumberOfBuffers    - The number of history buffers kept for this console process.
;                  $fStoreDuplicates    - If false, duplicate entries will not be stored in the history buffer.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686031.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetHistoryInfo($iHistoryBufferSize, $iNumberOfBuffers, $fStoreDuplicates, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tConsoleHistoryInfo = DllStructCreate($tagCONSOLE_HISTORY_INFO)
	$tConsoleHistoryInfo.HistoryBufferSize = $iHistoryBufferSize
	$tConsoleHistoryInfo.NumberOfHistoryBuffers = $iNumberOfBuffers
	$tConsoleHistoryInfo.Flags = 0
	If Not $fStoreDuplicates Then $tConsoleHistoryInfo.Flags = $HISTORY_NO_DUP_FLAG

	Local $aResult = DllCall($hDll, "bool", "SetConsoleHistoryInfo", _
			"struct*", $tConsoleHistoryInfo)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_Console_SetHistoryInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetIcon
; Description ...: Sets the icon of the console from a file.
; Syntax ........: _Console_SetIcon($hConsole, $sFile [, $iInd [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to a console screen buffer.
;                  $sFile               - A path to a file that contains icons. This can be dll or exe or an icon file.
;                  $iInd                - The index of the icon to retieve. Default is 0.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: This function is a wrapper for the _Console_SetIconEx function, using _WinAPI_ExtractIconEx to get the
;                  the handle of the icon from the file.
; Related .......: _WinAPI_ExtractIconEx, _Console_SetIconEx
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Console_SetIcon($sFile, $iInd = 0, $hDll = -1)
	Local $tHICON = DllStructCreate("int")
	Local $fResult = _WinAPI_ExtractIconEx($sFile, $iInd, 0, DllStructGetPtr($tHICON), 1)
	If @error Or Not $fResult Then Return SetError(@error, @extended, False)

	Local $hIcon = DllStructGetData($tHICON, 1, 1)
	If $hIcon = 0 Then Return SetError(1, 0, False)

	$fResult = _Console_SetIconEx($hIcon, $hDll)
	If @error Then Return SetError(@error, @extended, False)

	_WinAPI_DestroyIcon(DllStructGetData($tHICON, 1, 1))
	If @error Then Return SetError(@error, @extended, False)

	Return $fResult
EndFunc   ;==>_Console_SetIcon

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetIconEx
; Description ...: Sets the icon of the console from a HICON.
; Syntax ........: _Console_SetIconEx($hConsole, $hIcon [, $hDll ] )
; Parameters ....: $hIcon               - A handle to an icon.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: This function is not documented on MSDN.
; Example .......: No
; ===============================================================================================================================
Func _Console_SetIconEx($hIcon, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "SetConsoleIcon", _
			"handle", $hIcon)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetIconEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetMode
; Description ...: Sets the input mode of a console's input buffer or the output mode of a console screen buffer.
; Syntax ........: _Console_SetMode($hConsoleHandle, $iMode [, $hDll ] )
; Parameters ....: $hConsoleHandle      - A handle to the console input buffer or a console screen buffer. The handle must have
;                                         the GENERIC_READ access right.
;                  $iMode               - The input or output mode to be set. If the hConsoleHandle parameter is an input handle,
;                                         the mode can be one or more of the following values. When a console is created, all
;                                         input modes except ENABLE_WINDOW_INPUT are enabled by default.
;                                       |ENABLE_ECHO_INPUT - Characters read by the _WinApi_ReadFile or _Console_Read
;                                                            function are written to the active screen buffer as they are read.
;                                                            This mode can be used only if the ENABLE_LINE_INPUT mode is also
;                                                            enabled.
;                                       |ENABLE_EXTENDED_FLAGS - Required to enable or disable extended flags. See
;                                                                ENABLE_INSERT_MODE and ENABLE_QUICK_EDIT_MODE.
;                                       |ENABLE_INSERT_MODE - When enabled, text entered in a console window will be inserted at
;                                                             the current cursor location and all text following that location
;                                                             will not be overwritten. When disabled, all following text will
;                                                             be overwritten.
;                                                             To enable this mode, use ENABLE_INSERT_MODE |
;                                                             ENABLE_EXTENDED_FLAGS. To disable this mode, use
;                                                             ENABLE_EXTENDED_FLAGS without this flag.
;                                       |ENABLE_LINE_INPUT - The _WinApi_ReadFile or _Console_Read function returns only
;                                                            when a carriage return character is read. If this mode is disabled,
;                                                            the functions return when one or more characters are available.
;                                       |ENABLE_MOUSE_INPUT - If the mouse pointer is within the borders of the console window
;                                                             and the window has the keyboard focus, mouse events generated by
;                                                             mouse movement and button presses are placed in the input buffer.
;                                                             These events are discarded by _WinApi_ReadFile or
;                                                             _Console_Read, even when this mode is enabled.
;                                       |ENABLE_PROCESSED_INPUT - CTRL+C is processed by the system and is not placed in the
;                                                                 input buffer. If the input buffer is being read by
;                                                                 _WinApi_ReadFile or _Console_Read, other control keys
;                                                                 are processed by the system and are not returned in the
;                                                                 _WinApi_ReadFile or _Console_Read buffer. If the
;                                                                 ENABLE_LINE_INPUT mode is also enabled, backspace, carriage
;                                                                 return, and linefeed characters are handled by the system.
;                                       |ENABLE_QUICK_EDIT_MODE - This flag enables the user to use the mouse to select and edit
;                                                                 text. To enable this mode, use ENABLE_QUICK_EDIT_MODE |
;                                                                 ENABLE_EXTENDED_FLAGS. To disable this mode, use
;                                                                 ENABLE_EXTENDED_FLAGS without this flag.
;                                       |ENABLE_WINDOW_INPUT - User interactions that change the size of the console screen
;                                                              buffer are reported in the console's input buffer. Information
;                                                              about these events can be read from the input buffer by
;                                                              applications using the _Console_ReadInput function, but not
;                                                              by those using _WinApi_ReadFile or _Console_Read.
;                                       If the hConsoleHandle parameter is a screen buffer handle, the mode can be one or more of
;                                       the following values. When a screen buffer is created, both output modes are enabled by
;                                       default.
;                                       |ENABLE_PROCESSED_OUTPUT - Characters written by the _WinApi_WriteFile or
;                                                                  _Console_WriteConsole function or echoed by the
;                                                                  _WinApi_ReadFile or _Console_Read function are examined
;                                                                  for ASCII control sequences and the correct action is
;                                                                  performed. Backspace, tab, bell, carriage return, and linefeed
;                                                                  characters are processed.
;                                       |ENABLE_WRAP_AT_EOL_OUTPUT - When writing with _WinApi_WriteFile or _Console_WriteConsole
;                                                                    or echoing with _WinApi_ReadFile or _Console_Read,
;                                                                    the cursor moves to the beginning of the next row when it
;                                                                    reaches the end of the current row. This causes the rows
;                                                                    displayed in the console window to scroll up automatically
;                                                                    when the cursor advances beyond the last row in the window.
;                                                                    It also causes the contents of the console screen buffer to
;                                                                    scroll up (discarding the top row of the console screen
;                                                                    buffer) when the cursor advances beyond the last row in the
;                                                                    console screen buffer. If this mode is disabled, the last
;                                                                    character in the row is overwritten with any subsequent
;                                                                    characters.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686033.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetMode($hConsoleHandle, $iMode, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleHandle = -1 Then $hConsoleHandle = _Console_GetStdHandle($STD_INPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "SetConsoleMode", _
			"handle", $hConsoleHandle, _
			"dword", $iMode)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_Console_SetMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetOutputCP
; Description ...: Sets the output code page used by the console associated with the calling process. A console uses its output
;                  code page to translate the character values written by the various output functions into the images displayed
;                  in the console window.
; Syntax ........: _Console_SetOutputCP($iCodePageID [, $hDll ] )
; Parameters ....: $iCodePageID         - The identifier of the code page to set. For more information, see Remarks.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: A code page maps 256 character codes to individual characters. Different code pages include different special
;                  characters, typically customized for a language or a group of languages.
;                  The identifiers of the code pages available on the local computer are also stored in the registry under the
;                  following key:
;
;                  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage
;
;                  However, the registry can differ in different versions of Windows.
;                  To retrieve more information about a code page, including its name, use the _Console_GetCPInfoEx function.
;                  To determine a console's current input code page, use the _Console_GetOutputCP function. To set and
;                  retrieve a console's input code page, use the _Console_SetCP and _Console_GetCP functions.
; Related .......: _Console_GetCPInfoEx, _Console_GetOutputCP, _Console_SetCP, _Console_GetCP
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686036.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetOutputCP($iCodePageID, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "SetConsoleOutputCP", _
			"uint", $iCodePageID)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_Console_SetOutputCP

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetScreenBufferInfoEx
; Description ...: Sets the foreground (text) and background color attributes of characters written to the console screen buffer.
; Syntax ........: _Console_SetScreenBufferInfoEx($hConsoleOutput, $iSizeX, $iSizeY, $iCursorPositionX, _
;                  $iCursorPositionY,  $iAttributes, $iLeft, $iTop, $iRight, $iBottom, $iMaximumWindowSizeX, _
;                  $iMaximumWindowSizeY, $iPopupAttributes, $fFullscreenSupported, $aiColorTable)
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right.
;                  $iSizeX              - The width of the console screen buffer, in character columns.
;                  $iSizeY              - The height of the console screen buffer, in character rows.
;                  $iCursorPositionX    - The column coordinates of the cursor in the console screen buffer.
;                  $iCursorPositionY    - The row coordinates of the cursor in the console screen buffer.
;                  $iAttributes         - The attributes of the characters written to a screen buffer by the _Console_WriteFile
;                                         and _Console_WriteConsole functions, or echoed to a screen buffer by the
;                                         _WinApi_ReadFile and _Console_Read functions. Can be a combination of the
;                                         following:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal.
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attributes.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
;                  $iLeft               - The distance between the left buffer edge and the edge of the screen.
;                  $iTop                - The distance between the top buffer edge and the edge of the screen.
;                  $iRight              - The right edge of the buffer.
;                  $iBottom             - The top edge of the buffer.
;                  $iMaximumWindowSizeX - The maximum width of the console window, in character columns and rows, given the
;                                         current screen buffer size and font and the screen size.
;                  $iMaximumWindowSizeY - The maximum height of the console window, in character columns and rows, given the
;                                         current screen buffer size and font and the screen size.
;                  $iPopupAttributes    - The fill attribute for console pop-ups.
;                  $fFullscreenSupported- If this member is TRUE, full-screen mode is supported; otherwise, it is not.
;                  $aiColorTable        - An array of rgb colour values that describe the console's color settings.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfoEx
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686039.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetScreenBufferInfoEx($hConsoleOutput, $iSizeX, $iSizeY, $iCursorPositionX, $iCursorPositionY, _
		$iAttributes, $iLeft, $iTop, $iRight, $iBottom, $iMaximumWindowSizeX, $iMaximumWindowSizeY, $iPopupAttributes, _
		$fFullscreenSupported, $aiColorTable, $hDll = -1)
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)
	If Not IsArray($aiColorTable) Then Return False
	If UBound($aiColorTable, 0) <> 1 Then Return False
	If UBound($aiColorTable, 1) < 16 Then Return False

	Local $tConsoleScreenBufferInfoEx = DllStructCreate($tagCONSOLE_SCREEN_BUFFER_INFOEX)
	$tConsoleScreenBufferInfoEx.SizeX = $iSizeX
	$tConsoleScreenBufferInfoEx.SizeY = $iSizeY
	$tConsoleScreenBufferInfoEx.CursorPositionX = $iCursorPositionX
	$tConsoleScreenBufferInfoEx.CursorPositionY = $iCursorPositionY
	$tConsoleScreenBufferInfoEx.Attributes = $iAttributes
	$tConsoleScreenBufferInfoEx.Left = $iLeft
	$tConsoleScreenBufferInfoEx.Top = $iTop
	$tConsoleScreenBufferInfoEx.Right = $iRight
	$tConsoleScreenBufferInfoEx.Bottom = $iBottom
	$tConsoleScreenBufferInfoEx.MaximumWindowSizeX = $iMaximumWindowSizeX
	$tConsoleScreenBufferInfoEx.MaximumWindowSizeY = $iMaximumWindowSizeY
	$tConsoleScreenBufferInfoEx.PopupAttributes = $iPopupAttributes
	$tConsoleScreenBufferInfoEx.FullscreenSupported = $fFullscreenSupported
	For $i = 0 To 15
		DllStructSetData($tConsoleScreenBufferInfoEx, "ColorTable", $aiColorTable[$i], $i + 1)
	Next
	$tConsoleScreenBufferInfoEx.Size = DllStructGetSize($tConsoleScreenBufferInfoEx)

	Local $fResult = _Console_SetScreenBufferInfoExEx($hConsoleOutput, DllStructGetPtr($tConsoleScreenBufferInfoEx), $hDll)
	If @error Then Return SetError(@error, @extended, False)

	Return $fResult
EndFunc   ;==>_Console_SetScreenBufferInfoEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetScreenBufferInfoExEx
; Description ...: Sets the foreground (text) and background color attributes of characters written to the console screen buffer.
; Syntax ........: _Console_SetScreenBufferInfoExEx($hConsoleOutput, $pConsoleScreenBufferInfoEx [, $hDll = -1 ] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right.
;                  $pConsoleScreenBufferInfoEx - A pointer to a CONSOLESCREENBUFFERINFOEX structure.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_GetScreenBufferInfoEx, _Console_SetScreenBufferInfoEx
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686039.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetScreenBufferInfoExEx($hConsoleOutput, $pConsoleScreenBufferInfoEx, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "SetConsoleScreenBufferInfoEx", _
			"handle", $hConsoleOutput, _
			"ptr", $pConsoleScreenBufferInfoEx)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetScreenBufferInfoExEx

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetScreenBufferSize
; Description ...: Changes the size of the specified console screen buffer.
; Syntax ........: _Console_SetScreenBufferSize($hConsoleOutput, $iWidth, $iHeight [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iWidth              - The width of the console screen buffer, in character columns.
;                  $iHeight             - The height of the console screen buffer, in character rows.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686044.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetScreenBufferSize($hConsoleOutput, $iWidth, $iHeight, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "SetConsoleScreenBufferSize", _
			"handle", $hConsoleOutput, _
			"int", BitShift($iHeight, -16) + $iWidth)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetScreenBufferSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetStdHandle
; Description ...: Sets the handle for the specified standard device (standard input, standard output, or standard error).
; Syntax ........: _Console_SetStdHandle($nStdHandle, $hHandle [, $hDll ] )
; Parameters ....: $nStdHandle          - The standard device for which the handle is to be set. This parameter can be one of
;                                         the following values.
;                                       |STD_INPUT_HANDLE - The standard input device.
;                                       |STD_OUTPUT_HANDLE - The standard output device.
;                                       |STD_ERROR_HANDLE - The standard error device.
;                  $hHandle             - The handle for the standard device.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: The standard handles of a process may have been redirected by a call to _Console_SetStdHandle, in which case
;                  _Console_GetStdHandle will return the redirected handle. If the standard handles have been redirected, you
;                  can specify the CONIN$ value in a call to the _WinApi_CreateFile function to get a handle to a console's input
;                  buffer. Similarly, you can specify the CONOUT$ value to get a handle to the console's active screen buffer.
; Related .......: _Console_GetStdHandle
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686244.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetStdHandle($nStdHandle, $hHandle, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "SetStdHandle", _
			"dword", $nStdHandle, _
			"handle", $hHandle)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetStdHandle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetTextAttribute
; Description ...: Sets the attributes of characters written to the console screen buffer by the _WinApi_WriteFile or
;                  _Console_WriteConsole function, or echoed by the _WinApi_ReadFile or _Console_Read function. This
;                  function affects text written after the function call.
; Syntax ........: _Console_SetTextAttribute($hConsoleOutput, $iAttributes [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iAttributes         - The attributes of the characters written to a screen buffer by the _Console_WriteFile
;                                         and _Console_WriteConsole functions, or echoed to a screen buffer by the
;                                         _WinApi_ReadFile and _Console_Read functions. Can be a combination of the
;                                         following:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal.
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attributes.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: To determine the current color attributes of a screen buffer, call the _Console_GetScreenBufferInfo
;                  function.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686047.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetTextAttribute($hConsoleOutput, $iAttributes, $hDll = -1)
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "SetConsoleTextAttribute", _
			"handle", $hConsoleOutput, _
			"word", $iAttributes)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetTextAttribute

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetTitle
; Description ...: Sets the title for the current console window.
; Syntax ........: _Console_SetTitle($sConsoleTitle [, $fUnicode [, $hDll ]] )
; Parameters ....: $sConsoleTitle       - A string value containing the new title
;                  $fUnicode            - If 'True' then the unicode version will be used (default). If 'False' then ANSI is used
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686050.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _Console_SetTitle($sConsoleTitle, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $aResult = DllCall($hDll, "bool", "SetConsoleTitle" & ($fUnicode ? "W" : "A"), _
			($fUnicode ? "w" : "") & "str", $sConsoleTitle)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetTitle

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetWindowInfo
; Description ...: Sets the current size and position of a console screen buffer's window.
; Syntax ........: _Console_SetWindowInfo($hConsoleOutput, $iLeft, $iTop, $iRight, $iBottom [, $fAbsolute [, $hDll ]] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iLeft               - The left edge of the buffer.
;                  $iTop                - The top edge of the buffer.
;                  $iRight              - The right edge of the buffer.
;                  $iBottom             - The top edge of the buffer.
;                  $fAbsolute           - If this parameter is TRUE (default), the coordinates specify the new upper-left and
;                                         lower-right corners of the window. If it is FALSE, the coordinates are relative to the
;                                         current window-corner coordinates.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_SetWindowPos
; Link ..........: http://msdn.microsoft.com/en-us/library/ms686125.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_SetWindowInfo($hConsoleOutput, $iLeft, $iTop, $iRight, $iBottom, $fAbsolute = True, $hDll = -1)
	If $hConsoleOutput = -1 Then $hConsoleOutput = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)
	If $hDll = -1 Then $hDll = $__gvKernel32

	Local $tConsoleWindow = DllStructCreate($tagSMALL_RECT)
	$tConsoleWindow.Left = $iLeft
	$tConsoleWindow.Top = $iTop
	$tConsoleWindow.Right = $iRight
	$tConsoleWindow.Bottom = $iBottom

	Local $aResult = DllCall($hDll, "bool", "SetConsoleWindowInfo", _
			"handle", $hConsoleOutput, _
			"bool", $fAbsolute, _
			"struct*", $tConsoleWindow)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_SetWindowInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_SetWindowPos
; Description ...: Sets the current size and position of a console screen buffer's window.
; Syntax ........: _Console_SetWindowPos($hConsoleOutput, $iX, $iY, $iWidth, $iHeight [, $hDll ] )
; Parameters ....: $hConsoleOutput      - A handle to the console screen buffer. The handle must have the GENERIC_READ access
;                                         right.
;                  $iX                  - The new X coordinate of the window
;                  $iY                  - The new Y coordinate of the window
;                  $iWidth              - The new width of the window
;                  $iHeight             - The new height of the window
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......:
; Related .......: _Console_SetWindowInfo
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Console_SetWindowPos($hConsoleOutput, $iX, $iY, $iWidth, $iHeight, $hDll = -1)
	Return _Console_SetWindowInfo($hConsoleOutput, $iX, $iY, $iX + $iWidth, $iY + $iHeight, True, $hDll)
EndFunc   ;==>_Console_SetWindowPos

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_Write
; Description ...: Writes a character string to the *current* console screen buffer beginning at the current cursor location.
; Syntax ........: _Console_Write($sText [, $fUnicode [, $hDll ]] )
; Parameters ....: $sText               - Text to be written to the console screen buffer.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True, the number of characters written is returned in @extended.
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: This is just a wrapper for the _Console_WriteConsole function. It is the same as calling _Console_WriteConsole
;                  with a first parameter ($hConsole) = -1.
; Related .......: _Console_Read, _Console_WriteConsole, _Console_WriteConsoleOutputCharacter
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687401.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _Console_Write($sText, $fUnicode = Default, $hDll = -1)
	Return _Console_WriteConsole(-1, $sText, $fUnicode, $hDll)
EndFunc   ;==>_Console_Write

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_WriteConsole
; Description ...: Writes a character string to a console screen buffer beginning at the current cursor location.
; Syntax ........: _Console_WriteConsole($hConsole, $sText [, $fUnicode [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right. -1 (default) is the active screen buffer for the current instance.
;                  $sText               - Text to be written to the console screen buffer
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True, the number of characters written is returned in @extended.
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......: Erik Pilsits (wraithdu) - Added code to handle writing to the SciTE output pane.
; Remarks .......:
; Related .......: _Console_Read
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687401.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _Console_WriteConsole($hConsole, $sText, $fUnicode = Default, $hDll = -1)
	Local $aResult

	If $__gfIsCUI Then
		$aResult = ConsoleWrite($sText)

		Return SetExtended($aResult, $aResult <> 0)
	Else
		If $fUnicode = Default Then $fUnicode = $__gfUnicode
		If $hDll = -1 Then $hDll = $__gvKernel32
		If $hConsole = -1 Then $hConsole = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

		$aResult = DllCall($hDll, "bool", "WriteConsole" & ($fUnicode ? "W" : "A"), _
				"handle", $hConsole, _
				($fUnicode ? "w" : "") & "str", $sText, _
				"dword", StringLen($sText), _
				"dword*", 0, _
				"ptr", 0)
		If @error Then Return SetError(@error, @extended, False)

		Return SetExtended($aResult[4], $aResult[0] <> 0)
	EndIf
EndFunc   ;==>_Console_WriteConsole

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_WriteLine
; Description ...: Writes a character string to the *current* console screen buffer beginning at the current cursor location
;                  and appends a new line
; Syntax ........: _Console_WriteLine($sText [, $fUnicode [, $hDll ]] )
; Parameters ....: $sText               - Text to be written to the console screen buffer.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True, the number of characters written is returned in @extended.
;                  Failure              - False
; Author ........: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: This is just a wrapper for the _Console_WriteConsole function. It is the same as calling _Console_WriteConsole
;                  with a first parameter ($hConsole) = -1.
; Related .......: _Console_Read, _Console_WriteConsole, _Console_WriteConsoleOutputCharacter
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687401.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _Console_WriteLine($sText, $fUnicode = Default, $hDll = -1)
	Return _Console_WriteConsole(-1, $sText & @CRLF, $fUnicode, $hDll)
EndFunc   ;==>_Console_WriteLine

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_WriteOutputAttribute
; Description ...: Copies a number of character attributes to consecutive cells of a console screen buffer, beginning at a
;                  specified location.
; Syntax ........: _Console_WriteOutputAttribute( $hConsole , $aiAttributes , $iX , $iY [, $iStart [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right. -1 (default) is the active screen buffer for the current instance.
;                  $aiAttributes        - An array of character attributes. Each element of this member can be zero or any
;                                         combination of the following values:
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                       |COMMON_LVB_LEADING_BYTE - Leading byte.
;                                       |COMMON_LVB_TRAILING_BYTE - Trailing byte.
;                                       |COMMON_LVB_GRID_HORIZONTAL - Top horizontal
;                                       |COMMON_LVB_GRID_LVERTICAL - Left vertical.
;                                       |COMMON_LVB_GRID_RVERTICAL - Right vertical.
;                                       |COMMON_LVB_REVERSE_VIDEO - Reverse foreground and background attribute.
;                                       |COMMON_LVB_UNDERSCORE - Underscore.
;                  $iX                  - The character column to start writing from.
;                  $iY                  - The character row to start writing from.
;                  $iStart              - The first value specifying attributes in the $aiAttributes array. For example, if element
;                                         zero holds a counter then set this to 1.
;                  $End                 - The last value specifying attributes in the $aiAttributes array.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False and sets the @error flag.
; Author(s) .....: Erik Pilsits (wraithdu)
; Modified ......:
; Remarks .......: If the number of attributes to be written to extends beyond the end of the specified row in the console screen
;                  buffer, attributes are written to the next row. If the number of attributes to be written to extends beyond
;                  the end of the console screen buffer, the attributes are written up to the end of the console screen buffer.
;                  The character values at the positions written to are not changed.
; Related .......: _Console_WriteOutputCharacter, _Console_ReadOutputAttribute, _Console_FillOutputAttribute
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687407.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_WriteOutputAttribute($hConsole, $aiAttributes, $iX, $iY, $iStart = 0, $iEnd = -1, $hDll = -1)
	If Not IsArray($aiAttributes) Then Return SetError(1, 0, False)
	If UBound($aiAttributes, 0) <> 1 Then Return SetError(1, 0, False)
	Local $iBnd = UBound($aiAttributes) - 1
	If $iEnd > $iBnd Or $iEnd < $iStart Then $iEnd = $iBnd

	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsole = -1 Then $hConsole = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $tAttributes = DllStructCreate("word[" & ($iEnd - $iStart + 1) & "]")
	For $i = $iStart To $iEnd
		DllStructSetData($tAttributes, 1, $aiAttributes[$i], $i - $iStart + 1)
	Next

	Local $aResult = DllCall($hDll, "bool", "WriteConsoleOutputAttribute", _
			"handle", $hConsole, _
			"struct*", $tAttributes, _
			"dword", $iEnd - $iStart + 1, _
			"dword", BitShift($iY, -16) + $iX, _
			"dword*", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return SetExtended($aResult[5], $aResult[0] <> 0)
EndFunc   ;==>_Console_WriteOutputAttribute

; #FUNCTION# ====================================================================================================================
; Name ..........: _Console_WriteOutputCharacter
; Description ...: Copies a number of characters to consecutive cells of a console screen buffer, beginning at a specified
;                  location.
; Syntax ........: _Console_WriteOutputCharacter( $hConsole , $sText , $iX , $iY [, $fUnicode [, $hDll ]] )
; Parameters ....: $hConsole            - A handle to the console screen buffer. The handle must have the GENERIC_WRITE access
;                                         right. -1 is the active screen buffer for the current instance.
;                  $sText               - Text to be written to the console screen buffer.
;                  $iX                  - The character column to start writing from.
;                  $iY                  - The character row to start writing from.
;                  $fUnicode            - If 'True' then the unicode version will be used. If 'False' then ANSI is used.
;                  $hDll                - A handle to a dll to use. This prevents constant opening of the dll which could slow it
;                                         down. If you are calling lots of functions from the same dll then this recommended.
; Return values .: Success              - True
;                  Failure              - False and sets the @error flag.
; Author(s) .....: Matt Diesel (Mat)
; Modified ......:
; Remarks .......: If the number of characters to be written to extends beyond the end of the specified row in the console screen
;                  buffer, characters are written to the next row. If the number of characters to be written to extends beyond
;                  the end of the console screen buffer, characters are written up to the end of the console screen buffer.
;                  The attribute values at the positions written to are not changed.
; Related .......: _Console_ReadOutputCharacter
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687410.aspx
; Example .......: No
; ===============================================================================================================================
Func _Console_WriteOutputCharacter($hConsole, $sText, $iX, $iY, $fUnicode = Default, $hDll = -1)
	If $fUnicode = Default Then $fUnicode = $__gfUnicode
	If $hDll = -1 Then $hDll = $__gvKernel32
	If $hConsole = -1 Then $hConsole = _Console_GetStdHandle($STD_OUTPUT_HANDLE, $hDll)

	Local $aResult = DllCall($hDll, "bool", "WriteConsoleOutputCharacter" & ($fUnicode ? "W" : "A"), _
			"handle", $hConsole, _
			($fUnicode ? "w" : "") & "str", $sText, _
			"dword", StringLen($sText), _
			"dword", BitShift($iY, -16) + $iX, _
			"dword*", 0)
	If @error Then Return SetError(1, @error, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_Console_WriteOutputCharacter