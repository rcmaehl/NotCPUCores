#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinAPISPath Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; _WinAPI_ParseURL()
Global Const $URL_SCHEME_INVALID = -1
Global Const $URL_SCHEME_UNKNOWN = 0
Global Const $URL_SCHEME_FTP = 1
Global Const $URL_SCHEME_HTTP = 2
Global Const $URL_SCHEME_GOPHER = 3
Global Const $URL_SCHEME_MAILTO = 4
Global Const $URL_SCHEME_NEWS = 5
Global Const $URL_SCHEME_NNTP = 6
Global Const $URL_SCHEME_TELNET = 7
Global Const $URL_SCHEME_WAIS = 8
Global Const $URL_SCHEME_FILE = 9
Global Const $URL_SCHEME_MK = 10
Global Const $URL_SCHEME_HTTPS = 11
Global Const $URL_SCHEME_SHELL = 12
Global Const $URL_SCHEME_SNEWS = 13
Global Const $URL_SCHEME_LOCAL = 14
Global Const $URL_SCHEME_JAVASCRIPT = 15
Global Const $URL_SCHEME_VBSCRIPT = 16
Global Const $URL_SCHEME_ABOUT = 17
Global Const $URL_SCHEME_RES = 18
Global Const $URL_SCHEME_MSSHELLROOTED = 19
Global Const $URL_SCHEME_MSSHELLIDLIST = 20
Global Const $URL_SCHEME_MSHELP = 21
Global Const $URL_SCHEME_MSSHELLDEVICE = 22
Global Const $URL_SCHEME_WILDCARD = 23
Global Const $URL_SCHEME_SEARCH_MS = 24
Global Const $URL_SCHEME_SEARCH = 25
Global Const $URL_SCHEME_KNOWNFOLDER = 26

; _WinAPI_PathGetCharType()
Global Const $GCT_INVALID = 0x00
Global Const $GCT_LFNCHAR = 0x01
Global Const $GCT_SEPARATOR = 0x08
Global Const $GCT_SHORTCHAR = 0x02
Global Const $GCT_WILD = 0x04

; _WinAPI_UrlApplyScheme()
Global Const $URL_APPLY_DEFAULT = 0x01
Global Const $URL_APPLY_GUESSSCHEME = 0x02
Global Const $URL_APPLY_GUESSFILE = 0x04
Global Const $URL_APPLY_FORCEAPPLY = 0x08

; _WinAPI_UrlCanonicalize(), _WinAPI_UrlCombine()
Global Const $URL_DONT_SIMPLIFY = 0x08000000
Global Const $URL_ESCAPE_AS_UTF8 = 0x00040000
Global Const $URL_ESCAPE_PERCENT = 0x00001000
Global Const $URL_ESCAPE_SPACES_ONLY = 0x04000000
Global Const $URL_ESCAPE_UNSAFE = 0x20000000
Global Const $URL_NO_META = 0x08000000
Global Const $URL_PLUGGABLE_PROTOCOL = 0x40000000
Global Const $URL_UNESCAPE = 0x10000000

; _WinAPI_UrlGetPart()
Global Const $URL_PART_HOSTNAME = 2
Global Const $URL_PART_PASSWORD = 4
Global Const $URL_PART_PORT = 5
Global Const $URL_PART_QUERY = 6
Global Const $URL_PART_SCHEME = 1
Global Const $URL_PART_USERNAME = 3

; _WinAPI_UrlIs()
Global Const $URLIS_APPLIABLE = 4
Global Const $URLIS_DIRECTORY = 5
Global Const $URLIS_FILEURL = 3
Global Const $URLIS_HASQUERY = 6
Global Const $URLIS_NOHISTORY = 2
Global Const $URLIS_OPAQUE = 1
Global Const $URLIS_URL = 0
; ===============================================================================================================================
