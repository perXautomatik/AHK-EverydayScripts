#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

f1::SendMessage,0x112,0xF170,2,,Program Manager

f2::
  hideit:
  Toggle:=!Toggle
  If Toggle {
    Gui, -Caption +AlwaysOnTop
    Gui, Color, 000000
    Gui,Show, h%A_ScreenHeight% w%A_ScreenWidth%
    Return
  } else {
    Gui, destroy
  }
Return

f3::
  send #d
  goto hideit
return
