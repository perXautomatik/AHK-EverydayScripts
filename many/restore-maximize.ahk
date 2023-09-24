; Maximize/Restore active window
!m::
  WinGet, active_id, ID, A
  WinGet, checkmax, MinMax, A
  If(checkmax == 1) {
    WinGet, active_id, ID, A
    WinRestore, ahk_id %active_id%
  } else {
    WinGetClass, class, ahk_id %active_id%
    If class not in ahk_class WorkerW,Shell_TrayWnd, Button, SysListView32,Progman,#32768
      WinMaximize, ahk_id %active_id%
  }
return

; center active window
#o::
  SysGet Mon,MonitorWorkArea  ; This grabs the actual work space of the desktop (i.e. minus the taskbar)
  WinGetPos ,,,wW,wH,A
  WinMove A,,(MonRight-wW)/2,(MonBottom-wH)/2
return
