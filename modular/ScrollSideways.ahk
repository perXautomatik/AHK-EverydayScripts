#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
;source https://www.autohotkey.com/docs/Hotkeys.htm
~LControl & WheelUp::  ; Scroll left.
ControlGetFocus, fcontrol, A
Loop 2  ; <-- Increase this value to scroll faster.
    SendMessage, 0x0114, 0, 0, %fcontrol%, A  ; 0x0114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
return

~LControl & WheelDown::  ; Scroll right.
ControlGetFocus, fcontrol, A
Loop 2  ; <-- Increase this value to scroll faster.
    SendMessage, 0x0114, 1, 0, %fcontrol%, A  ; 0x0114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
return