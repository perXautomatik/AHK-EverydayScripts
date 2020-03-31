; Autohotkey configuration file
; AHK Version v.1.1.32.00
; Franklin Chou (franklin.chou@nelsonmullins.com)
; 22 Mar. 2020
; Tested to work on Lenovo X1 Yoga, Gen. 4 

#SingleInstance Force
#Persistent 

GLOBAL_DEBUG_MODE := 0
Return

CapsLock::Ctrl
LCtrl::Return
;LCtrl::CapsLock


; DEBUG TOOLS -----------------------------------------------------------------

#c::
  If(GLOBAL_DEBUG_MODE > 0) {
    ; WinGetTitle, title, A
    WinGetClass, title, A
    MsgBox %title%    
  }
Return

f12::
  If(GLOBAL_DEBUG_MODE > 0) {
    Reload
  }
Return

#'::
  If(GLOBAL_DEBUG_MODE > 0) {
    WinGet windows, List
    Loop %windows% {
      id := windows%A_Index%
      WinGetTitle wt, ahk_id %id%
      r .= wt . "`n"
    }
    MsgBox %r%
  }
Return


; TIMEKEEPER ------------------------------------------------------------------

; Shift focus to the timekeeper app
#!e::
  timekeeper_app := WinExist("ahk_class WindowsForms10.Window.8.app.0.262fb3d")
  ;MsgBox %timekeeper_app%
  If(timekeeper_app > 0) {
    WinActivate, ahk_id %timekeeper_app%
  } Else {
    Run, DTE.exe, C:\Program Files (x86)\DTEAxiom
  }
Return

; Start the timer on the selected item in the daily view
#IfWinActive ahk_class WindowsForms10.Window.8.app.0.262fb3d
  >+s::
    WinGetActiveTitle, active_title
    match_result := RegExMatch(active_title, "^Entries for")
    ; each item in the dropdown is approximately 25 pixels
    ; so item 4 (Start Timer) is 100 pixels down from the context menu
    drop_down := 100
    If(match_result > 0) {
      WinMove, 100, 100
      MouseMove, 100, 280
      Send {RButton}
      Sleep, 10 ; need to sleep to allow submenu time to come up
      MouseMove, 170, 300 + drop_down
      Send {LButton}
    }
Return


; WORD/OUTLOOK ----------------------------------------------------------------
#If WinActive("ahk_class OpusApp") || WinActive("ahk_class rctrl_renwnd32")
  PrintScreen::AppsKey
Return


; WORD ONLY -------------------------------------------------------------------
#If WinActive("ahk_class OpusApp")
  >+M::  ; Cycle through types of markup
    Send !r
    Sleep, 10
    Send td
    Send {Down}
    Send {Enter}
Return
