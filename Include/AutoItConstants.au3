#include-once

; #INDEX# =======================================================================================================================
; Title .........: Constants
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Constants to be included in an AutoIt v3 script.
; Author(s) .....: JLandes, Nutster, CyberSlug, Holger, ...
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; Sets the way coords are used in the mouse and pixel functions
Global Const $OPT_COORDSRELATIVE = 0 ; Relative coords to the active window
Global Const $OPT_COORDSABSOLUTE = 1 ; Absolute screen coordinates (default)
Global Const $OPT_COORDSCLIENT = 2 ; Relative coords to client area

; Sets how errors are handled if a Run/RunWait function fails
Global Const $OPT_ERRORSILENT = 0 ; Silent error (@error set to 1)
Global Const $OPT_ERRORFATAL = 1 ; Fatal error (default)

; Alters the use of Caps Lock
Global Const $OPT_CAPSNOSTORE = 0 ; Don't store/restore Caps Lock state
Global Const $OPT_CAPSSTORE = 1 ; Store/restore Caps Lock state (default)

; Alters the method that is used to match window titles
Global Const $OPT_MATCHSTART = 1 ; Match the title from the start (default)
Global Const $OPT_MATCHANY = 2 ; Match any substring in the title
Global Const $OPT_MATCHEXACT = 3 ; Match the title exactly
Global Const $OPT_MATCHADVANCED = 4 ; Use advanced window matching (deprecated)

; Common Control Styles
Global Const $CCS_TOP = 0x01
Global Const $CCS_NOMOVEY = 0x02
Global Const $CCS_BOTTOM = 0x03
Global Const $CCS_NORESIZE = 0x04
Global Const $CCS_NOPARENTALIGN = 0x08
Global Const $CCS_NOHILITE = 0x10
Global Const $CCS_ADJUSTABLE = 0x20
Global Const $CCS_NODIVIDER = 0x40
Global Const $CCS_VERT = 0x0080
Global Const $CCS_LEFT = 0x0081
Global Const $CCS_NOMOVEX = 0x0082
Global Const $CCS_RIGHT = 0x0083

; DriveGetType() Constants
Global Const $DT_DRIVETYPE = 1 ; Drive type e.g. CD-ROM, Fixed.
Global Const $DT_SSDSTATUS = 2 ; Status of whether the drive is SSD.
Global Const $DT_BUSTYPE = 3 ; Bus type e.g. SATA, SD.

; FtpSetProxy and HttpSetProxy Constants
Global Const $PROXY_IE = 0
Global Const $PROXY_NONE = 1
Global Const $PROXY_SPECIFIED = 2

; Reserved IDs for System Objects
; in MenuConstants.au3
; in ScrollBarsConstants.au3
Global Const $OBJID_WINDOW = 0x00000000
Global Const $OBJID_TITLEBAR = 0xFFFFFFFE
Global Const $OBJID_SIZEGRIP = 0xFFFFFFF9
Global Const $OBJID_CARET = 0xFFFFFFF8
Global Const $OBJID_CURSOR = 0xFFFFFFF7
Global Const $OBJID_ALERT = 0xFFFFFFF6
Global Const $OBJID_SOUND = 0xFFFFFFF5

; Progress and Splash Constants
; Indicates properties of the displayed progress or splash dialog
Global Const $DLG_CENTERONTOP = 0 ; Center justified/always on top/with title
Global Const $DLG_NOTITLE = 1 ; Titleless window
Global Const $DLG_NOTONTOP = 2 ; Without "always on top" attribute
Global Const $DLG_TEXTLEFT = 4 ; Left justified text
Global Const $DLG_TEXTRIGHT = 8 ; Right justified text
Global Const $DLG_MOVEABLE = 16 ; Window can be moved
Global Const $DLG_TEXTVCENTER = 32 ; Splash text centered vertically

; Mouse Constants
; Indicates current mouse cursor
Global Const $IDC_UNKNOWN = 0 ; Unknown cursor
Global Const $IDC_APPSTARTING = 1 ; Standard arrow and small hourglass
Global Const $IDC_ARROW = 2 ; Standard arrow
Global Const $IDC_CROSS = 3 ; Crosshair
Global Const $IDC_HAND = 32649 ; Hand cursor
Global Const $IDC_HELP = 4 ; Arrow and question mark
Global Const $IDC_IBEAM = 5 ; I-beam
Global Const $IDC_ICON = 6 ; Obsolete
Global Const $IDC_NO = 7 ; Slashed circle
Global Const $IDC_SIZE = 8 ; Obsolete
Global Const $IDC_SIZEALL = 9 ; Four-pointed arrow pointing N, S, E, and W
Global Const $IDC_SIZENESW = 10 ; Double-pointed arrow pointing NE and SW
Global Const $IDC_SIZENS = 11 ; Double-pointed arrow pointing N and S
Global Const $IDC_SIZENWSE = 12 ; Double-pointed arrow pointing NW and SE
Global Const $IDC_SIZEWE = 13 ; Double-pointed arrow pointing W and E
Global Const $IDC_UPARROW = 14 ; Vertical arrow
Global Const $IDC_WAIT = 15 ; Hourglass

Global Const $IDI_APPLICATION = 32512 ; Application icon
Global Const $IDI_ASTERISK = 32516 ; Asterisk icon
Global Const $IDI_EXCLAMATION = 32515 ; Exclamation point icon
Global Const $IDI_HAND = 32513 ; Stop sign icon
Global Const $IDI_QUESTION = 32514 ; Question-mark icon
Global Const $IDI_WINLOGO = 32517 ; Windows logo icon. Windows XP: Application icon
Global Const $IDI_SHIELD = 32518
Global Const $IDI_ERROR = $IDI_HAND
Global Const $IDI_INFORMATION = $IDI_ASTERISK
Global Const $IDI_WARNING = $IDI_EXCLAMATION

; Process Constants
; Indicates the type of shutdown
Global Const $SD_LOGOFF = 0 ; Logoff
Global Const $SD_SHUTDOWN = 1 ; Shutdown
Global Const $SD_REBOOT = 2 ; Reboot
Global Const $SD_FORCE = 4 ; Force
Global Const $SD_POWERDOWN = 8 ; Power down
Global Const $SD_FORCEHUNG = 16 ; Force shutdown if hung
Global Const $SD_STANDBY = 32 ; Standby
Global Const $SD_HIBERNATE = 64 ; Hibernate

; Run Constants
Global Const $STDIN_CHILD = 1
Global Const $STDOUT_CHILD = 2
Global Const $STDERR_CHILD = 4
Global Const $STDERR_MERGED = 8
Global Const $STDIO_INHERIT_PARENT = 0x10
Global Const $RUN_CREATE_NEW_CONSOLE = 0x00010000

; UBound Constants
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2

; Mouse Event Constants
Global Const $MOUSEEVENTF_ABSOLUTE = 0x8000 ; Specifies that the dx and dy parameters contain normalized absolute coordinates
Global Const $MOUSEEVENTF_MOVE = 0x0001 ; Specifies that movement occurred
Global Const $MOUSEEVENTF_LEFTDOWN = 0x0002 ; Specifies that the left button changed to down
Global Const $MOUSEEVENTF_LEFTUP = 0x0004 ; Specifies that the left button changed to up
Global Const $MOUSEEVENTF_RIGHTDOWN = 0x0008 ; Specifies that the right button changed to down
Global Const $MOUSEEVENTF_RIGHTUP = 0x0010 ; Specifies that the right button changed to up
Global Const $MOUSEEVENTF_MIDDLEDOWN = 0x0020 ; Specifies that the middle button changed to down
Global Const $MOUSEEVENTF_MIDDLEUP = 0x0040 ; Specifies that the middle button changed to up
Global Const $MOUSEEVENTF_WHEEL = 0x0800 ; Specifies that the wheel has been moved, if the mouse has a wheel
Global Const $MOUSEEVENTF_XDOWN = 0x0080 ; Specifies that an X button was pressed
Global Const $MOUSEEVENTF_XUP = 0x0100 ; Specifies that an X button was released

; Reg Value type Constants
Global Const $REG_NONE = 0
Global Const $REG_SZ = 1
Global Const $REG_EXPAND_SZ = 2
Global Const $REG_BINARY = 3
Global Const $REG_DWORD = 4
Global Const $REG_DWORD_LITTLE_ENDIAN = 4
Global Const $REG_DWORD_BIG_ENDIAN = 5
Global Const $REG_LINK = 6
Global Const $REG_MULTI_SZ = 7
Global Const $REG_RESOURCE_LIST = 8
Global Const $REG_FULL_RESOURCE_DESCRIPTOR = 9
Global Const $REG_RESOURCE_REQUIREMENTS_LIST = 10
Global Const $REG_QWORD = 11
Global Const $REG_QWORD_LITTLE_ENDIAN = 11

; Z order
Global Const $HWND_BOTTOM = 1 ; Places the window at the bottom of the Z order
Global Const $HWND_NOTOPMOST = -2 ; Places the window above all non-topmost windows
Global Const $HWND_TOP = 0 ; Places the window at the top of the Z order
Global Const $HWND_TOPMOST = -1 ; Places the window above all non-topmost windows

; SetWindowPos Constants
Global Const $SWP_NOSIZE = 0x0001
Global Const $SWP_NOMOVE = 0x0002
Global Const $SWP_NOZORDER = 0x0004
Global Const $SWP_NOREDRAW = 0x0008
Global Const $SWP_NOACTIVATE = 0x0010
Global Const $SWP_FRAMECHANGED = 0x0020
Global Const $SWP_DRAWFRAME = 0x0020
Global Const $SWP_SHOWWINDOW = 0x0040
Global Const $SWP_HIDEWINDOW = 0x0080
Global Const $SWP_NOCOPYBITS = 0x0100
Global Const $SWP_NOOWNERZORDER = 0x0200
Global Const $SWP_NOREPOSITION = 0x0200
Global Const $SWP_NOSENDCHANGING = 0x0400
Global Const $SWP_DEFERERASE = 0x2000
Global Const $SWP_ASYNCWINDOWPOS = 0x4000

; Keywords (returned from the IsKeyword() function)
Global Const $KEYWORD_DEFAULT = 1
Global Const $KEYWORD_NULL = 2

; IsDeclared Constants
Global Const $DECLARED_LOCAL = -1
Global Const $DECLARED_UNKNOWN = 0
Global Const $DECLARED_GLOBAL = 1

; Assign Constants
Global Const $ASSIGN_CREATE = 0
Global Const $ASSIGN_FORCELOCAL = 1
Global Const $ASSIGN_FORCEGLOBAL = 2
Global Const $ASSIGN_EXISTFAIL = 4

; BlockInput Constants
Global Const $BI_ENABLE = 0
Global Const $BI_DISABLE = 1

; Break Constants
Global Const $BREAK_ENABLE = 1
Global Const $BREAK_DISABLE = 0

; CDTray Constants
Global Const $CDTRAY_OPEN = "open"
Global Const $CDTRAY_CLOSED = "closed"

; ControlSend and Send Constants
Global Const $SEND_DEFAULT = 0
Global Const $SEND_RAW = 1

; DirGetSize Constants
Global Const $DIR_DEFAULT = 0
Global Const $DIR_EXTENDED= 1
Global Const $DIR_NORECURSE = 2

; DirRemove Constants
;~ Global Const $DIR_DEFAULT = 0
Global Const $DIR_REMOVE= 1

; DriveGetDrive Constants
Global Const $DT_ALL = "ALL"
Global Const $DT_CDROM = "CDROM"
Global Const $DT_REMOVABLE = "REMOVABLE"
Global Const $DT_FIXED = "FIXED"
Global Const $DT_NETWORK = "NETWORK"
Global Const $DT_RAMDISK = "RAMDISK"
Global Const $DT_UNKNOWN = "UNKNOWN"

; DriveGetFileSystem Constants
Global Const $DT_UNDEFINED = 1
Global Const $DT_FAT = "FAT"
Global Const $DT_FAT32 = "FAT32"
Global Const $DT_EXFAT = "exFAT"
Global Const $DT_NTFS = "NTFS"
Global Const $DT_NWFS = "NWFS"
Global Const $DT_CDFS = "CDFS"
Global Const $DT_UDF = "UDF"

; DriveMapAdd Constants
Global Const $DMA_DEFAULT = 0
Global Const $DMA_PERSISTENT = 1
Global Const $DMA_AUTHENTICATION = 8

; DriveStatus Constants
Global Const $DS_UNKNOWN = "UNKNOWN"
Global Const $DS_READY = "READY"
Global Const $DS_NOTREADY = "NOTREADY"
Global Const $DS_INVALID = "INVALID"

; Mouse related Constants
Global Const $MOUSE_CLICK_LEFT = "left"
Global Const $MOUSE_CLICK_RIGHT = "right"
Global Const $MOUSE_CLICK_MIDDLE = "middle"
Global Const $MOUSE_CLICK_MAIN = "main"
Global Const $MOUSE_CLICK_MENU = "menu"
Global Const $MOUSE_CLICK_PRIMARY = "primary"
Global Const $MOUSE_CLICK_SECONDARY = "secondary"
Global Const $MOUSE_WHEEL_UP = "up"
Global Const $MOUSE_WHEEL_DOWN = "down"

; Dec, Int, Number Constants
Global Const $NUMBER_AUTO = 0
Global Const $NUMBER_32BIT = 1
Global Const $NUMBER_64BIT = 2
Global Const $NUMBER_DOUBLE = 3

; ObjName Constants
Global Const $OBJ_NAME = 1
Global Const $OBJ_STRING = 2
Global Const $OBJ_PROGID = 3
Global Const $OBJ_FILE = 4
Global Const $OBJ_MODULE = 5
Global Const $OBJ_CLSID = 6
Global Const $OBJ_IID = 7

; OnAutoItExitRegister Constants
Global Const $EXITCLOSE_NORMAL = 0 ; Natural closing.
Global Const $EXITCLOSE_BYEXIT = 1 ; close by Exit function.
Global Const $EXITCLOSE_BYCLICK = 2 ; close by clicking on exit of the systray.
Global Const $EXITCLOSE_BYLOGOFF = 3 ; close by user logoff.
Global Const $EXITCLOSE_BYSHUTDOWN = 4 ; close by Windows shutdown.

; ProcessGetStats Constants
Global Const $PROCESS_STATS_MEMORY = 0
Global Const $PROCESS_STATS_IO = 1

; ProcessSetPriority Constants
Global Const $PROCESS_LOW = 0
Global Const $PROCESS_BELOWNORMAL = 1
Global Const $PROCESS_NORMAL = 2
Global Const $PROCESS_ABOVENORMAL = 3
Global Const $PROCESS_HIGH = 4
Global Const $PROCESS_REALTIME = 5

; RunAs and RunAsWait Constants
Global Const $RUN_LOGON_NOPROFILE = 0
Global Const $RUN_LOGON_PROFILE = 1
Global Const $RUN_LOGON_NETWORK = 2
Global Const $RUN_LOGON_INHERIT = 4

; SoundPlay Constants
Global Const $SOUND_NOWAIT = 0 ; continue script while sound is playing (default)
Global Const $SOUND_WAIT = 1 ; wait until sound has finished

; ShellExecute and ShellExecuteWait Constants
Global Const $SHEX_OPEN = "open"
Global Const $SHEX_EDIT = "edit"
Global Const $SHEX_PRINT = "print"
Global Const $SHEX_PROPERTIES = "properties"

; TCPRecv Constants
Global Const $TCP_DATA_DEFAULT = 0
Global Const $TCP_DATA_BINARY = 1

; UDPOpen, UDPRecv Constants
Global Const $UDP_OPEN_DEFAULT = 0
Global Const $UDP_OPEN_BROADCAST = 1
Global Const $UDP_DATA_DEFAULT = 0
Global Const $UDP_DATA_BINARY = 1
Global Const $UDP_DATA_ARRAY = 2

; ToolTip, GUICtrlSetTip Constants
Global Const $TIP_NOICON = 0 ; No icon
Global Const $TIP_INFOICON = 1 ; Info icon
Global Const $TIP_WARNINGICON = 2 ; Warning icon
Global Const $TIP_ERRORICON = 3 ; Error Icon

Global Const $TIP_BALLOON = 1
Global Const $TIP_CENTER = 2
Global Const $TIP_FORCEVISIBLE = 4

; WindowsSetOnTop Constants
Global Const $WINDOWS_NOONTOP = 0
Global Const $WINDOWS_ONTOP = 1

; WinGetState Constants
Global Const $WIN_STATE_EXISTS = 1
Global Const $WIN_STATE_VISIBLE  = 2
Global Const $WIN_STATE_ENABLED = 4
Global Const $WIN_STATE_ACTIVE = 8
Global Const $WIN_STATE_MINIMIZED = 16
Global Const $WIN_STATE_MAXIMIZED = 32
; ===============================================================================================================================
