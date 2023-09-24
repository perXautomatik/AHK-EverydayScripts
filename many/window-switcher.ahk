RAlt & e::ToggleWindowVisibility("ahk_class CabinetWClass")
RAlt & f::ToggleWindowVisibility("ahk_exe mpv.exe")
RAlt & d::ToggleWindowVisibility("ahk_exe code.exe")
RAlt & r::ToggleWindowVisibility("Alacritty")
RAlt & w::ToggleWindowVisibility("ahk_exe WindowsTerminal.exe")
RAlt & g::ToggleWindowVisibility("ahk_exe Glasswire.exe")
RAlt & x::ToggleWindowVisibility("ahk_exe Spotify.exe")

ToggleWindowVisibility(windowClass) {
  IfWinExist, %windowClass%
  {
    IfWinActive, %windowClass%
      WinMinimize, %windowClass%
    else
      WinActivate, %windowClass%
  }
  ; else {
  ;   word_array := StrSplit(windowClass, A_Space, "") ; Omits periods.
  ;   MsgBox % word_array[2] " is not open!"
  ; }
}

RAlt & b::
  SetTitleMatchMode, 2
  brave = ahk_exe brave.exe
  GroupAdd, braveGroup, - Brave
  GroupAdd, braveGroup, DevTools
  If WinActive(brave)
    GroupActivate, braveGroup, r
  else
    WinActivate %brave%
return

RAlt & s::
  firefoxClass = ahk_class MozillaWindowClass
  GroupAdd, firefoxGroup, %firefoxClass%
  If WinActive(firefoxClass)
    GroupActivate, firefoxGroup, r
  else
    WinActivate %firefoxClass%
return

RAlt & v::
  nvyClass = ahk_class Nvy_Class
  GroupAdd, nvyGroup, %nvyClass%
  WinGet, nvyList, List, %nvyClass%
  If WinActive(nvyClass)
    If nvyList = 1
      WinMinimize, %nvyClass%
    else
      GroupActivate, nvyGroup, r
  else
    WinActivate %nvyClass%
return

; minimize active window and restore it
; RAlt & c::
;   IfWinExist, ahk_id %lastWindow%
;   {
;     WinGet, WinState, MinMax, ahk_id %lastWindow%
;     If WinState = -1
;       WinActivate
;     else
;       WinMinimize
;     lastWindow:= ; remove this line if you want minimize/toggle only one window
;   }
;   else
;   {
;     lastWindow:= WinExist("A")
;     WinMinimize, ahk_id %lastWindow%
;   }
; return

!i::Send, ^!{Tab}
; #IfWinActive, ahk_class MultitaskingViewFrame ; doesn't work in windows 11
#IfWinActive, ahk_class XamlExplorerHostIslandWindow
  h::Left
  j::Down
  k::Up
  l::Right
  d::Delete
  i::Enter
  q::Esc
#IfWinActive

; switch to previous window
!o::
  winNumber = 0
  WinGet, ids, List
  Loop, %ids% {
    this_id := ids%A_Index%
    id := % "ahk_id " this_id
    WinGet, ExStyle, ExStyle, %id%
    WinGetTitle, ttitle, %id% ; Window title
    WinGet, proc, ProcessName, %id% ; Window process
    WinGetClass, class, %id% ; Window class
    ; https://www.autohotkey.com/docs/commands/WinGet.htm#ExStyle
    ; 0x8 is WS_EX_TOPMOST(always-on-top)
    winNumber += !(class ~= "i)Toolbar|#32770") && ttitle > "" && !(ExStyle & 0x8)
    && (ttitle != "Program Manager" || proc != "Explorer.exe") && proc != "FancyWM.exe"
  } Until (winNumber = 2)
  if (winNumber = 2)
    WinActivate, %id%
return

; switch between all windows of the current window class
listIndex = 1
#WinActivateForce
!+o::
Beginning:
  WinGetClass, activeWindowClass, A
  WinGet, activeWindowID, ID, A
  ; get window list
  WinGet, List, List, ahk_class %activeWindowClass%,, Program Manager
  listIndex++
  if (listIndex > List)
    listIndex = %List%

  Id := List%listIndex%
  if (activeWindowID != Id) {
    WinGetTitle, title, ahk_id %Id%
    if (title) {
      ; exclude windows without a size
      WinGetPos,,,W,H,ahk_id %Id%
      if (W AND H) {
        WinActivate, ahk_id %Id%
        return
      }
    }
    WinActivate, ahk_id %Id%
    Goto, Beginning
  }
return

; RAlt & b::
;   nvy = ahk_exe nvy.exe
;   Loop {
;     WinWait, %nvy%
;     WinMove, %nvy%,, 188, 33, 1600, 1000
;     WinSet, Style, -0xC00000, A ; toggle titlebar
;     WinWaitClose
;   }
; return

; RAlt & s::
;   WinGet, firefoxList, List, ahk_class MozillaWindowClass
;   WinGet, activeWindowID, ID, A
;   firefoxClass = ahk_class MozillaWindowClass
;   IfWinActive, %firefoxClass%
;   {
;     If activeWindowID = %firefoxList1%
;       WinActivate, ahk_id %firefoxList2%
;     else If activeWindowID = %firefoxList2%
;       WinActivate, ahk_id %firefoxList1%
;   }
;   else
;     WinActivate, %firefoxClass%
; return

; f2::
;   DetectHiddenWindows, On
;   window = ahk_exe notepad.exe
;   IfWinExist, %window%
;   {
;     IfWinActive, %window%
;     {
;       WinHide, %window%
;       Send, !{Esc}
;     }
;     else
;     {
;       WinShow, %window%
;       WinActivate, %window%
;     }
;   }
; return
