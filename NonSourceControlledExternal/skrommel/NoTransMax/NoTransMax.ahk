;NoTransMax.ahk
; Makes the taskbar transparent when no windows are maximized
;Skrommel @2005

#SingleInstance,Force
SetWinDelay,0
OnExit,EXIT

WinWait,Ahk_Class Shell_TrayWnd,,5
If ErrorLevel=1
{
  MsgBOx,0,NoTransMax,Taskbar not detected!
  ExitApp
}
WinGet,oldtrans,Transparent,Ahk_Class Shell_TrayWnd
If oldtrans<150
  oldtrans=150
Else
  oldtrans=255
START:
Sleep,1000
SysGet,work,MonitorWorkArea 
maxed=0
WinGet,ids,List,,,Program Manager
Loop,%ids% 
{
  StringTrimRight,id,ids%A_Index%,0
  WinGetPos,x,y,w,h,ahk_id %id%
  If (x<=workLeft And y<=workTop And x+w>=workRight And y+h>=workBottom)
    maxed=1
}
If maxed=1
  WinSet,Transparent,255,Ahk_Class Shell_TrayWnd
Else
  WinSet,Transparent,150,Ahk_Class Shell_TrayWnd
Goto,START

EXIT:
WinSet,Transparent,%oldtrans%,Ahk_Class Shell_TrayWnd
ExitApp