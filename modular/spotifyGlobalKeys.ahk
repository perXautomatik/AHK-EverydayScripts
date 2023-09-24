#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
; https://www.reddit.com/r/AutoHotkey/comments/orzend/spotify_global_hotkeys/
DetectHiddenWindows, On

; Get the HWND of the Spotify main window.
getSpotifyHwnd() {
  WinGet, spotifyHwnd, ID, ahk_exe spotify.exe
  Return spotifyHwnd
}

; Send a key to Spotify.
spotifyKey(key) {
  spotifyHwnd := getSpotifyHwnd()
  ; Chromium ignores keys when it isn't focused.
  ; Focus the document window without bringing the app to the foreground.
  ControlFocus, Chrome_RenderWidgetHostHWND1, ahk_id %spotifyHwnd%
  ControlSend, , %key%, ahk_id %spotifyHwnd%
  if WinExist("ahk_exe spotify.exe")
  {
    ; show the Windows OSD
    hWnd := DllCall("User32\FindWindow", "Str","NativeHWNDHost", "Ptr",0)
    PostMessage 0xC028, 0x0C, 0xA0000,, % "ahk_id" hWnd
  }
  Return
}

; alt+shift+b
!+b::spotifyKey("!+{b}")
; Win+alt+p: Play/Pause
#+p::spotifyKey("{Space}")
; Win+alt+j: Next
#]::spotifyKey("^{Right}")
; Win+alt+k: Previous
#[::spotifyKey("^{Left}")
; Win+alt+l: Seek forward
#+]::spotifyKey("+{Right}")
; Win+alt+h: Seek backward
#+[::spotifyKey("+{Left}")
; Win+alt+0: Volume up
#0::spotifyKey("^{Up}")
; Win+alt+9: Volume down
#9::spotifyKey("^{Down}")
; Win+alt+o: Show Spotify
#!o::
  spotifyHwnd := getSpotifyHwnd()
  WinGet, style, Style, ahk_id %spotifyHwnd%
  if (style & 0x10000000) { ; WS_VISIBLE
    WinHide, ahk_id %spotifyHwnd%
  } Else {
    WinShow, ahk_id %spotifyHwnd%
    WinActivate, ahk_id %spotifyHwnd%
  }
Return
