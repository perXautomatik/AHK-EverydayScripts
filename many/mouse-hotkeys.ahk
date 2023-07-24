; F13 is G-Key
F13::Alt

; Keep RButton working (mostly) normally.
RButton::Send {RButton}
RButton & WheelUp::Send, {Volume_Up}
RButton & WheelDown::Send, {Volume_Down}
RButton & MButton::Send, {Volume_Mute}
RButton & LButton::MButton

#MaxHotkeysPerInterval 500
#If MouseIsOver("ahk_class Shell_TrayWnd")
{
  WheelUp::Send {Volume_Up}
  WheelDown::Send {Volume_Down}
  MButton::Send {Media_Play_Pause}
  XButton2::Send {Media_Next}
  XButton1::Send {Media_Prev}
}

MouseIsOver(WinTitle) {
  MouseGetPos,,, Win
return WinExist(WinTitle . " ahk_id " . Win)
}
#If

XButton1::Send, {XButton1}
XButton1 & WheelUp::Send, ^{PgUp}
XButton1 & WheelDown::Send, ^{PgDn}
; Alt+Tab with mouse wheel
XButton2 & WheelUp::ShiftAltTab
XButton2 & WheelDown::AltTab
; Alt+Tab menu
XButton2 & LButton::Send, ^!{Tab}
XButton2 & RButton::Send, #{Tab}
XButton2 UP::return
#IfWinActive ahk_exe mpv.exe
  XButton2 UP::Send, {XButton2}
#IfWinActive

#IfWinActive, ahk_class MultitaskingViewFrame
  XButton2 & RButton::Esc
#IfWinActive
