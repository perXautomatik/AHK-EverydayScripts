SetCapsLockState, AlwaysOff

CapsLock & `;::
GetKeyState, CapsLockState, CapsLock, T
if CapsLockState = D
  SetCapsLockState, AlwaysOff
else
  SetCapsLockState, AlwaysOn
return

CapsLock::Send, {ESC}
+CapsLock::Send, +{ESC}

; this needs to be above CapsLock & j and CapsLock & k
; !j::
;   if (not GetKeyState("Control") and not getKeyState("Shift"))
;     Send, {ALTDOWN}{TAB}ALTUP}
; return

; !k::
;   if (not GetKeyState("Control") and not getKeyState("Shift"))
;     Send, {ALTDOWN}{SHIFTDOWN}{TAB}{SHIFTUP}ALTUP}
; return

CapsLock & k::Up
CapsLock & j::Down
CapsLock & h::Left
CapsLock & l::Right
CapsLock & i::Home
CapsLock & o::End
CapsLock & u::PgUp
CapsLock & p::PgDn

CapsLock & ,:: Send, {Del}
CapsLock & .:: Send, ^{Del}
; CapsLock & m:: Send, {BS}
CapsLock & n:: Send, ^{BS}

; Unmute
; CapsLock & c:: Run nircmd.exe mutesysvolume 0 microphone
; Mute
; CapsLock & x:: Run nircmd.exe mutesysvolume 1 microphone
; Toggle
CapsLock & z:: Run nircmd.exe mutesysvolume 2 microphone
CapsLock & a:: Send, ^a
CapsLock & y:: Send, ^y
CapsLock & b:: Send, ^{Left}
CapsLock & c:: Send, ^{c}
CapsLock & v:: Send, ^{v}
CapsLock & s:: Shift
CapsLock & d:: Ctrl
CapsLock & f:: Send, {Esc}
CapsLock & [:: Send, {Esc}
CapsLock & ]:: Send, {insert}

CapsLock & 9:: ControlClick,, A,, WheelUp
CapsLock & 0:: ControlClick,, A,, WheelDown

CapsLock & F2:: Send, {Volume_Down}
CapsLock & F3:: Send, {Volume_Up}
CapsLock & F4:: Send, {Media_Mute}
CapsLock & F5:: Send, {Media_Play_Pause}
CapsLock & F6:: Send, {Media_Stop}
CapsLock & F7:: Send, {Media_Prev}
CapsLock & F8:: Send, {Media_Next}

CapsLock & t::Send, ^{t}
CapsLock & r::Send, ^{Tab}
CapsLock & e::Send, ^+{Tab}
CapsLock & w:: Send, ^{w}
CapsLock & q::
  if GetKeyState("alt") = 0 {
    Send, ^w
  }
  else {
    Send, !{F4}
    return
  }
return
CapsLock & g:: Send, {AppsKey}

CapsLock & m::
  Input Key, L1 M
  If Key = f
  {
    if getKeyState("alt") = 0 {
      EnvGet, vUserProfile, USERPROFILE
      ; Run, %vUserProfile%\scoop\apps\mpv\current\mpv.exe --no-terminal --no-border --config-dir=%A_AppData%\mpv
      Run, mpv.exe
    }
    else {
      ; opts := "keep_session-auto_save=no,keep_session-auto_load=no"
      ; Run, mpv.exe --script-opts=%opts% %clipboard%
      Run, mpv.exe %clipboard%
    }
  }
  else if Key = s
    Run firefox.exe
  else if Key = d
    Run code.exe
  else if Key = v
  {
    Run nvy.exe
    WinWait, Nvy,, 1
    if ErrorLevel {
      MsgBox, WinWait timed out.
      return
    }
    else {
      WinActivate, Nvy
      ; sleep 400
      ; WinMove, Nvy,, 260, 47, 1400, 985
    }
  }
  else if Key = w
    Run wt.exe
  else if Key = e
    Run explorer.exe
  else if Key = r
  {
    EnvGet, vUserProfile, USERPROFILE
    Run %vUserProfile%\scoop\apps\alacritty\current\alacritty.exe --working-directory %vUserProfile%
    ; RunWait, alacritty.exe --working-directory "%vUserProfile%", , Min
  }
return
