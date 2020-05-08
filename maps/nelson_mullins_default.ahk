; Autohotkey configuration file
; AHK Version v.1.1.32.00
; Franklin Chou (franklin.chou@nelsonmullins.com)
; 2 May 2020
; Tested to work on Lenovo X1 Yoga, Gen. 4 

#Persistent 


; SYSTEM ----------------------------------------------------------------------

; Access different windows of the same group
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
  index := ""
  process_windows := ""
  n_process_windows := ""  
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

; utility to get selected text (if any)
GetSelectedText() {
  temp := ClipboardAll
  Clipboard := ""
  Send ^c
  ClipWait, 0, 1
  selection := Clipboard
  Clipboard := temp
  Return, selection
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
    selected := GetSelectedText()
    is_releasable := RegExMatch(selected, "Ready to be released|Timer still running")
    ; match weekly view, 1 application window
    If (is_releasable && RegExMatch(active_title, "DTE Axiom") > 0) {
      WinMove, 0, 0
      MouseMove, 100, 460
      DTEAppContextClick(4, 460)
    ; match monthly view, 2 application windows
    ; in this view, Ctrl + C does NOT copy the selected text
    ; so `is_releasable` is useless
    } Else If(RegExMatch(active_title, "^Entries for") > 0) {
      WinMove, 0, 0
      ; when figuring out how low to get the mouse to move aim for the area
      ; of the menu bar that says "Drag a column header here..."
      MouseMove, 100, 280
      DTEAppContextClick(4, 280)
    } Else {
      MsgBox Select releasable entry
      Return
    }
    is_releasable := ""
    selected := ""
Return

; click the item in the DTE context menu that is `item_position` from the top
; with the starting position of `initial_mouse` (y-axis offset)
DTEAppContextClick(item_position, initial_mouse) {
    ; each item in the dropdown is approximately 25 pixels
    drop_down := 25
    Send {RButton}
    Sleep, 10 ; sleep to allow submenu time to come up
    MouseMove, 170, (initial_mouse + 20) + drop_down * item_position
    Send {LButton} 
}


; MSOFFICE --------------------------------------------------------------------

; Outlook

#If WinActive("ahk_class rctrl_renwnd32")
  ; disable Ctrl + D as delete email
  ^d::Return 
  
  ; disable Ctrl + E as find 
  $^e::Return

  ; remap Ctrl + F to find
  ^f::
    WinGetActiveTitle, title
    ; IN MESSAGE, Ctrl + F maps to F4
    If (RegExMatch(title, " - Message") > 0) {
      Send {F4}
    } Else {
      Send ^e
    }
    title := ""
Return

#If WinActive("ahk_class XLMAIN")
  ^m::Send +{F2}
Return

; This ridiculous keymapping is care of Lenovo
; which maps F12 to some bloatware keyboard manager utility
#If WinActive("ahk_class OpusApp") || WinActive("ahk_class XLMAIN")
  F12::Send {F12}
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

; Bring up the tab stop modification dialogue
#If WinActive("ahk_class OpusApp")
  >+t::
    Send !h
    Send pg
    Send !t
Return
