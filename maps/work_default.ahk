; Autohotkey configuration file
; AHK Version v.1.1.30.01
; Franklin Chou (franklin.chou@nelsonmullins.com)
; 22 Mar. 2020
; Tested to work on Lenovo X1 Yoga, Gen. 4 

#SingleInstance Force
#Persistent 

GLOBAL_DEBUG_MODE := 0
Return

CapsLock::Ctrl
LCtrl::return
;LCtrl::CapsLock

; DEBUG TOOLS -----------------------------------------------------------------

#c::
  If(GLOBAL_DEBUG_MODE > 0) {
    WinGetTitle, title, A
    MsgBox %GLOBAL_DEBUG_MODE% ;%title%    
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
  }
Return

; Start the timer on the selected item in the daily view
#IfWinActive ahk_class WindowsForms10.Window.8.app.0.262fb3d
  >+s::
    WinGetActiveTitle, active_title
    match_result := RegExMatch(active_title, "^Entries for") 
    drop_down := 100
    If(match_result > 0) {
      WinMove, 100, 100
      MouseMove, 100, 280
      Send {RButton}
      Sleep, 100 ; need to sleep to allow the submenu to come up
      MouseMove, 170, 300 + drop_down
      Send {LButton}
    }
Return


; WORD ------------------------------------------------------------------------
#IfWinActive ahk_class OpusApp
   PrintScreen::AppsKey


; SYMBOL KEYS -----------------------------------------------------------------
>+s::send §
