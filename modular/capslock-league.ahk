#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, Force

SetTitleMatchMode,2 ;sets title match mode to partial match
DetectHiddenWindows,on ;allow detecting hidden windows

; backslash to avoid any other matching window (e.g. a text file named 'Test Script 2.ahk - AutoHotkey.txt')
many := "\many.ahk - AutoHotkey"
host := "\Host.ahk - AutoHotkey"
spicykeys := "\spicykeys.ahk - AutoHotkey"
screenClippingTool := "\screen-clipping-tool.ahk - AutoHotkey"

; WinGetTitle, Var, %selectedScript%
; msgbox % Var

; ahk_class AutoHotkey to close AHK scripts only
WinClose, %many% ahk_class AutoHotkey
; WinClose, %host% ahk_class AutoHotkey
; WinClose, %spicykeys% ahk_class AutoHotkey
; WinClose, %screenClippingTool% ahk_class AutoHotkey
; WinClose, C:\tools\WinSize2\WinSize2.EXE

XButton1::Ctrl
CapsLock::Shift
!;::CapsLock

!1:: Run nircmd.exe mutesysvolume 1 "external microphone" ; Mute
!2:: Run nircmd.exe mutesysvolume 0 "external microphone" ; Unmute
; !4:: Run nircmd.exe mutesysvolume 2 "external microphone"  ; Toggle

!Esc::
  league = ahk_exe League of Legends.exe
  If not WinActive(league)
    WinActivate, %league%
return

!f1::
  firefox = ahk_class MozillaWindowClass
  If not WinActive(firefox)
    WinActivate, %firefox%
return

!f2::
  spotify = ahk_exe spotify.exe
  If not WinActive(spotify)
    WinActivate, %spotify%
return

; enter::
;   SetCapsLockState off
;   send, {enter}
; return
;
; +enter::
;   SetCapsLockState off
;   send, +{enter}
; return

; NumpadEnter::
;   SetCapsLockState off
;   send, {enter}
; return
;
; +NumpadEnter::
;   SetCapsLockState off
;   send, +{enter}
; return

!+c::
  EnvGet, vUserProfile, USERPROFILE
  ; Run, %vUserProfile%\Public-AutoHotKey-Scripts\Host.ahk
  Run, %vUserProfile%\autohotkey\many\many.ahk
  ; Run, %vUserProfile%\autohotkey\spicykeys\spicykeys.ahk
  ; Run, %vUserProfile%\autohotkey\screen-clipping-tool\screen-clipping-tool.ahk
  ; Run, "C:\tools\WinSize2\WinSize2.EXE"
ExitApp
return
