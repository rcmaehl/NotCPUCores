#include-once

; #INDEX# =======================================================================================================================
; Title .........: File_Constants
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Constants to be included in an AutoIt v3 script when using File functions.
; Author(s) .....: Valik, Gary Frost, ...
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; Indicates file copy and install options
Global Const $FC_NOOVERWRITE = 0 ; Do not overwrite existing files (default)
Global Const $FC_OVERWRITE = 1 ; Overwrite existing files
Global Const $FC_CREATEPATH = 8 ; Create destination directory structure if it doesn't exist

; Indicates file date and time options
Global Const $FT_MODIFIED = 0 ; Date and time file was last modified (default)
Global Const $FT_CREATED = 1 ; Date and time file was created
Global Const $FT_ACCESSED = 2 ; Date and time file was last accessed

; FileGetTime Constants
Global Const $FT_ARRAY = 0
Global Const $FT_STRING = 1

; FileSelectFolder Constants
Global Const $FSF_CREATEBUTTON = 1
Global Const $FSF_NEWDIALOG = 2
Global Const $FSF_EDITCONTROL = 4

; FileSetTime, FileSetAttrib
Global Const $FT_NONRECURSIVE = 0
Global Const $FT_RECURSIVE = 1

; Indicates the mode to open a file
Global Const $FO_READ = 0 ; Read mode
Global Const $FO_APPEND = 1 ; Write mode (append)
Global Const $FO_OVERWRITE = 2 ; Write mode (erase previous contents)
Global Const $FO_CREATEPATH = 8 ; Create directory structure if it doesn't exist
Global Const $FO_BINARY = 16 ; Read/Write mode binary
Global Const $FO_UNICODE = 32 ; Write mode Unicode UTF16-LE
Global Const $FO_UTF16_LE = 32 ; Write mode Unicode UTF16-LE
Global Const $FO_UTF16_BE = 64 ; Write mode Unicode UTF16-BE
Global Const $FO_UTF8 = 128 ; Read/Write mode UTF8 with BOM
Global Const $FO_UTF8_NOBOM = 256 ; Read/Write mode UTF8 with no BOM
Global Const $FO_ANSI = 512 ; Read/Write mode ANSI
Global Const $FO_UTF16_LE_NOBOM = 1024 ; Write mode Unicode UTF16-LE with no BOM
Global Const $FO_UTF16_BE_NOBOM = 2048 ; Write mode Unicode UTF16-BE with no BOM
Global Const $FO_UTF8_FULL = 16384 ; Use full file UTF8 detection if no BOM present
Global Const $FO_FULLFILE_DETECT = 16384 ; Use full file UTF8 detection if no BOM present

; Indicates file read options
Global Const $EOF = -1 ; End-of-file reached

; Indicates file open and save dialog options
Global Const $FD_FILEMUSTEXIST = 1 ; File must exist
Global Const $FD_PATHMUSTEXIST = 2 ; Path must exist
Global Const $FD_MULTISELECT = 4 ; Allow multi-select
Global Const $FD_PROMPTCREATENEW = 8 ; Prompt to create new file
Global Const $FD_PROMPTOVERWRITE = 16 ; Prompt to overWrite file

Global Const $CREATE_NEW = 1
Global Const $CREATE_ALWAYS = 2
Global Const $OPEN_EXISTING = 3
Global Const $OPEN_ALWAYS = 4
Global Const $TRUNCATE_EXISTING = 5

Global Const $INVALID_SET_FILE_POINTER = -1

; Indicates starting point for the file pointer move operations
Global Const $FILE_BEGIN = 0
Global Const $FILE_CURRENT = 1
Global Const $FILE_END = 2

Global Const $FILE_ATTRIBUTE_READONLY = 0x00000001
Global Const $FILE_ATTRIBUTE_HIDDEN = 0x00000002
Global Const $FILE_ATTRIBUTE_SYSTEM = 0x00000004
Global Const $FILE_ATTRIBUTE_DIRECTORY = 0x00000010
Global Const $FILE_ATTRIBUTE_ARCHIVE = 0x00000020
Global Const $FILE_ATTRIBUTE_DEVICE = 0x00000040
Global Const $FILE_ATTRIBUTE_NORMAL = 0x00000080
Global Const $FILE_ATTRIBUTE_TEMPORARY = 0x00000100
Global Const $FILE_ATTRIBUTE_SPARSE_FILE = 0x00000200
Global Const $FILE_ATTRIBUTE_REPARSE_POINT = 0x00000400
Global Const $FILE_ATTRIBUTE_COMPRESSED = 0x00000800
Global Const $FILE_ATTRIBUTE_OFFLINE = 0x00001000
Global Const $FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 0x00002000
Global Const $FILE_ATTRIBUTE_ENCRYPTED = 0x00004000

Global Const $FILE_SHARE_READ = 0x00000001
Global Const $FILE_SHARE_WRITE = 0x00000002
Global Const $FILE_SHARE_DELETE = 0x00000004
Global Const $FILE_SHARE_READWRITE = BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE)
Global Const $FILE_SHARE_ANY = BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE, $FILE_SHARE_DELETE)

Global Const $GENERIC_ALL = 0x10000000
Global Const $GENERIC_EXECUTE = 0x20000000
Global Const $GENERIC_WRITE = 0x40000000
Global Const $GENERIC_READ = 0x80000000
Global Const $GENERIC_READWRITE = BitOR($GENERIC_READ, $GENERIC_WRITE)

; FileGetEncoding Constants
Global Const $FILE_ENCODING_UTF16LE = 32

Global Const $FE_ENTIRE_UTF8 = 1
Global Const $FE_PARTIALFIRST_UTF8 = 2

; FileGetLongName and FileGetShortName
Global Const $FN_FULLPATH = 0
Global Const $FN_RELATIVEPATH = 1

; FileGetVersion Constants _WinAPI_VerQueryValue, _WinAPI_VerQueryValueEx
Global Const $FV_COMMENTS = "Comments"
Global Const $FV_COMPANYNAME = "CompanyName"
Global Const $FV_FILEDESCRIPTION = "FileDescription"
Global Const $FV_FILEVERSION = "FileVersion"
Global Const $FV_INTERNALNAME = "InternalName"
Global Const $FV_LEGALCOPYRIGHT = "LegalCopyright"
Global Const $FV_LEGALTRADEMARKS = "LegalTrademarks"
Global Const $FV_ORIGINALFILENAME = "OriginalFilename"
Global Const $FV_PRODUCTNAME = "ProductName"
Global Const $FV_PRODUCTVERSION = "ProductVersion"
Global Const $FV_PRIVATEBUILD = "PrivateBuild"
Global Const $FV_SPECIALBUILD = "SpecialBuild"

; Indicates _FileReadToArray modes
Global Const $FRTA_NOCOUNT = 0
Global Const $FRTA_COUNT = 1
Global Const $FRTA_INTARRAYS = 2
Global Const $FRTA_ENTIRESPLIT = 4

; Indicates _FileListToArray modes
Global Const $FLTA_FILESFOLDERS = 0
Global Const $FLTA_FILES = 1
Global Const $FLTA_FOLDERS = 2

; Indicates _FileListToArrayRec modes
Global Const $FLTAR_FILESFOLDERS = 0
Global Const $FLTAR_FILES = 1
Global Const $FLTAR_FOLDERS = 2
Global Const $FLTAR_NOHIDDEN = 4
Global Const $FLTAR_NOSYSTEM = 8
Global Const $FLTAR_NOLINK = 16
Global Const $FLTAR_NORECUR = 0
Global Const $FLTAR_RECUR = 1
Global Const $FLTAR_NOSORT = 0
Global Const $FLTAR_SORT = 1
Global Const $FLTAR_FASTSORT = 2
Global Const $FLTAR_NOPATH = 0
Global Const $FLTAR_RELPATH = 1
Global Const $FLTAR_FULLPATH = 2

; _PathSplit Constants
Global Const $PATH_ORIGINAL = 0
Global Const $PATH_DRIVE = 1
Global Const $PATH_DIRECTORY = 2
Global Const $PATH_FILENAME = 3
Global Const $PATH_EXTENSION = 4
; ===============================================================================================================================
