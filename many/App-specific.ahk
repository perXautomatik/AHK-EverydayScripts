!q::Send, !{f4}
!h::Send, #{Left}
!l::Send, #{Right}
#v::SendInput, {Raw}%Clipboard%
!+m::PostMessage, 0x112, 0xF100, 0x20,, A ; context menu of the window's title bar

#If WinActive("ahk_exe brave.exe") || WinActive("ahk_exe msedge.exe")
{
  !,::Send, ^+{Tab}
  !.::Send, ^{Tab}

  ; tab picker
  !e::Send, ^+a

  ; No single alt
  Alt::KeyWait Alt
}


#If WinActive("ahk_exe firefox.exe")
{
  !,::Send, ^{PgUp}
  !.::Send, ^{PgDn}
  !+,::Send, ^+{PgUp}
  !+.::Send, ^+{PgDn}
  !w::Send, ^{Tab}
}

#IfWinActive, ahk_class CabinetWClass
  ^BS::Send ^+{Left}{del}
  ^u:: Send +{home}{del}

  +Backspace::Send !{Up}

  !,::Send, ^+{Tab}
  !.::Send, ^{Tab}

  F1::
    Clipboard =
    Send, ^c
    ClipWait, 1
    Clipboard = %Clipboard%
  return
#IfWinActive

#IfWinActive, ahk_class #32770 Run
  Tab::Down
#IfWinActive

#IfWinActive, ahk_exe Code.exe
  !s::Send, {Esc}^s
#IfWinActive

#IfWinActive, ahk_exe nvy.exe
  ^BS::Send, ^{w}
  ^i::Send, !^+{F6}
  ^;::Send, !^+{F7}
#IfWinActive

#IfWinNotActive, ahk_exe WindowsTerminal.exe
  !BS::Send ^{BS}
#IfWinNotActive

#IfWinActive, ahk_exe WindowsTerminal.exe
  !,::Send, ^+{Tab}
  !.::Send, ^{Tab}
#IfWinActive

; CapsLock & Space::^!+1 ; launch switcheroo
#IfWinNotActive, ahk_exe keypirinha-x64.exe
  CapsLock & Space::
    Send, !{Space}
    sleep 30
    Send, ..
    Send, {tab}
  return
#IfWinNotActive

#IfWinActive ahk_class AutoHotkeyGUI
  ^BS:: Send ^+{left}{del}
  ^u:: Send +{home}{del}
#IfWinActive

#IfWinActive ahk_class SUMATRA_PDF_FRAME
  j:: Send {WheelDown}
  k:: Send {WheelUp}
  !WheelDown:: Send, !{WheelDown}
  !WheelUp:: Send, !{WheelUp}

  ; strip newlines
  $^c::
    Clipboard:=""
    Send ^c
    clipwait
    StringReplace, clipboard, clipboard, `r`n,%A_Space%,All
  return
  ^+c::send ^c
#IfWinActive
