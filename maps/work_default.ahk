; Autohotkey configuration file
; AHK Version v.1.1.32.00
; Franklin Chou (franklin.chou@nelsonmullins.com)
; 22 Mar. 2020
; Tested to work on Lenovo X1 Yoga, Gen. 4 

#SingleInstance Force
#Persistent 

GLOBAL_DEBUG_MODE := 1
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


; SYSTEM ----------------------------------------------------------------------

; Access different windows of the same group with Alt + backtick
!`::
  WinGet, process_name, ProcessName, A ; get the active window's process name
  process_windows := GetWindowsOfProcess(process_name)
  
  n_process_windows := process_windows.Length()
  
  index := 1 ; AHK arrays are 1 indexed
  While(GetKeyState("Alt", "P")) {
    If (GetKeyState("``", "P")) {
      If (index < n_process_windows) {
        index := index + 1
      } Else {
        index := 1
      }
      active_id := process_windows[index]
      WinActivate, ahk_id %active_id%
    }
  }

  KeyWait, Alt
  index := ""  
Return

; Get the window ids of all the processes under that process name
GetWindowsOfProcess(process_name) {
  ids := Array()
  WinGet, window_ids, List ; get the IDs for all running windows 
  Loop %window_ids% {
    id := window_ids%A_Index%
    WinGetTitle, title, ahk_id %id%
    WinGet, a_process_name, ProcessName, ahk_id %id%
    ; only include windows with visible title
    If (title && a_process_name = process_name) { 
      ids.Push(id)
    }
  }
  Return, ids
}


; TIMEKEEPER ------------------------------------------------------------------

; Shift focus to the timekeeper app
#!e::
  timekeeper_app := WinExist("ahk_class WindowsForms10.Window.8.app.0.262fb3d")
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


; MSOFFICE --------------------------------------------------------------------

; Let the print screen key open the application options key (for spell check)
; Word and Outlook
#If WinActive("ahk_class OpusApp") || WinActive("ahk_class rctrl_renwnd32")
  PrintScreen::AppsKey
Return

; This ridiculous keymapping is care of Lenovo
; which maps F12 to some bloatware keyboard manager utility
#If WinActive("ahk_class OpusApp") || WinActive("ahk_class XLMAIN")
  F12::
    Send {F12}
Return


; WORD ONLY -------------------------------------------------------------------

; Cycle through types of markup
#If WinActive("ahk_class OpusApp")
  >+m::
    Send !r
    Sleep, 10
    Send td
    Send {Down}
    Send {Enter}
Return
