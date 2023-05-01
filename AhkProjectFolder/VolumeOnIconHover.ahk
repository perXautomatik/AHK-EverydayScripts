#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#If MouseIsOver("ahk_class Shell_TrayWnd") ; For MouseIsOver, see #If example 1.
WheelUp::Send {Volume_Up}     ; Wheel over taskbar: increase/decrease volume.
WheelDown::Send {Volume_Down} ;