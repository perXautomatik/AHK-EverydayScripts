#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, Force

; https://github.com/MScholtes/VirtualDesktop

; Create/Remove Desktop
!NumpadAdd::Run, cmd.exe /c Virtualdesktop11 -new,, hide
#NumpadAdd::Run, cmd.exe /c Virtualdesktop11 -new -switch,, hide
!NumpadSub::Run, cmd.exe /c Virtualdesktop11 -remove,, hide
!NumpadDiv::Run, cmd.exe /c Virtualdesktop11 -removeall,, hide

; next/prev desktop
!9::Send, {RWin down}{CONTROLDOWN}{Left}{RWin up}{CONTROLUP}
!0::Send, {RWin down}{CONTROLDOWN}{Right}{RWin up}{CONTROLUP}
; or use Virtualdesktop11 api(a bit slower)
; !9::Run cmd.exe /c Virtualdesktop11 -left,, hide
; !0::Run cmd.exe /c Virtualdesktop11 -right,, hide

; switch to specific desktop
!1::Run, cmd.exe /c Virtualdesktop11 "-switch:Desktop 1",, hide
!2::Run, cmd.exe /c Virtualdesktop11 "-switch:Desktop 2",, hide
!3::Run, cmd.exe /c Virtualdesktop11 "-switch:Desktop 3",, hide
!4::Run, cmd.exe /c Virtualdesktop11 "-switch:Desktop 4",, hide
!5::Run, cmd.exe /c Virtualdesktop11 "-switch:Desktop 5",, hide

moveToDesktop(num, follow:=false) {
  if (follow)
    Run, cmd.exe /c Virtualdesktop11 -GetDesktop:%num% -MoveActiveWindow -switch,, hide
  else
    Run, cmd.exe /c Virtualdesktop11 -GetDesktop:%num% -MoveActiveWindow,, hide
}

; just move window
^!1::moveToDesktop(0)
^!2::moveToDesktop(1)
^!3::moveToDesktop(2)
^!4::moveToDesktop(3)
^!5::moveToDesktop(4)

; follow your window
+!1::moveToDesktop(0, true)
+!2::moveToDesktop(1, true)
+!3::moveToDesktop(2, true)
+!4::moveToDesktop(3, true)
+!5::moveToDesktop(4, true)

; pin/unpin window
!8::
  WinGet, Active_PID, PID, A
  RunWait, cmd.exe /c Virtualdesktop11 -IsWindowPinned:%Active_PID%,,hide UseErrorLevel
  if (ErrorLevel = 1)
    Run, cmd.exe /c Virtualdesktop11 -PinWindow:%Active_PID%,, hide
  else
    Run, cmd.exe /c Virtualdesktop11 -UnPinWindow:%Active_PID%,, hide
return

; move windows terminal to current Desktop and WinActivate
!7::
  RunWait, cmd.exe /c Virtualdesktop11 -GetCurrentDesktop -MoveWindow:windowsterminal,, hide
  WinActivate, ahk_exe windowsterminal.exe
return
