#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
ListLines Off
SetBatchLines -1
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#KeyHistory 0
#WinActivateForce

Process, Priority,, H

SetWinDelay -1
SetControlDelay -1

; include the library
; #Include VD.ahk
; or
#Include _VD.ahk
; ...{startup code}
VD.init()

; VD.ahk : calls `VD.init()` on #Include
; _VD.ahk : `VD.init()` when you want, like after a GUI has rendered, for startup performance reasons


; you should WinHide invisible programs that have a window.
; WinHide, % "Malwarebytes Tray Application"
; #SETUP END

; VD.createUntil(3) ;create until we have at least 3 VD

return

; useful stuff
!1::VD.goToDesktopNum(1)
!2::VD.goToDesktopNum(2)
!3::VD.goToDesktopNum(3)

; just move window
^!1::VD.MoveWindowToDesktopNum("A",1)
^!2::VD.MoveWindowToDesktopNum("A",2)
^!3::VD.MoveWindowToDesktopNum("A",3)

; follow your window
+!1::VD.MoveWindowToDesktopNum("A",1), VD.goToDesktopNum(1)
+!2::VD.MoveWindowToDesktopNum("A",2), VD.goToDesktopNum(2)
+!3::VD.MoveWindowToDesktopNum("A",3), VD.goToDesktopNum(3)

; move window to left or right and don't follow it
^!9::VD.MoveWindowToRelativeDesktopNum("A", -1)
^!0::VD.MoveWindowToRelativeDesktopNum("A", 1)

; move window to left or right and follow it
+!9::VD.goToDesktopNum(VD.MoveWindowToRelativeDesktopNum("A", -1))
+!0::VD.goToDesktopNum(VD.MoveWindowToRelativeDesktopNum("A", 1))

; to come back to this window
; #NumpadMult:: ;#*
  ; VD.goToDesktopOfWindow("VD.ahk examples WinTitle")
  ; VD.goToDesktopOfWindow("ahk_exe code.exe")
; return

; Win + x move VSCode to your current Desktop and WinActivate
!+v::VD.MoveWindowToCurrentDesktop("ahk_exe nvy.exe")

; getters and stuff
; f6::
  ; msgbox % VD.getDesktopNumOfWindow("VD.ahk examples WinTitle")
  ; ; msgbox % VD.getDesktopNumOfWindow("ahk_exe GitHubDesktop.exe")
; return
; f1:: msgbox % VD.getCurrentDesktopNum()
; f2:: msgbox % VD.getCount()

;Create/Remove Desktop
!NumpadAdd::VD.createDesktop()
#NumpadAdd::VD.createDesktop(false) ;don't go to newly created

!NumpadSub::VD.removeDesktop(VD.getCurrentDesktopNum())
#!NumpadSub::VD.removeDesktop(VD.getCount()) ;removes 3rd desktop if there are 3 desktops

^+NumpadAdd::VD.createUntil(3) ;create until we have at least 3 VD

^+NumpadSub::
  VD.createUntil(3) ;create until we have at least 3 VD
  sleep 1000
  ; FALLBACK IS ONLY USED IF YOU ARE CURRENTLY ON THAT VD
  VD.removeDesktop(3, 1)
return

; Pin Window
!7::VD.TogglePinWindow("A")
; ^7::VD.PinWindow("A")
; !7::VD.UnPinWindow("A")
!+7::MsgBox % VD.IsWindowPinned("A")

; Pin App
!6::VD.TogglePinApp("A")
; ^6::VD.PinApp("A")
; !6::VD.UnPinApp("A")
!+6::MsgBox % VD.IsAppPinned("A")

; found processes
f4::
  foundProcessesArr := []

  ; Make sure to get all windows from all virtual desktops
  DetectHiddenWindows On
  WinGet, id, List
  Loop %id%
  {
    hwnd := id%A_Index%
    ;VD.getDesktopNumOfWindow will filter out invalid windows
    desktopNum_ := VD.getDesktopNumOfWindow("ahk_id" hwnd)
    If (desktopNum_ > -1) ;-1 for invalid window, 0 for "Show on all desktops", 1 for Desktop 1
    {
      WinGet, exe, ProcessName, % "ahk_id" hwnd
      foundProcessesArr.Push({exe:exe, desktopNum_:desktopNum_})
    }
  }

  foundProcessesArr:=sortArrByKey(foundProcessesArr, "desktopNum_")

  ; finalStr:="('0' for ""Show on all desktops"", '1' for Desktop 1)`n`n"
  finalStr:=""

  for unused, v_ in foundProcessesArr {
    finalStr .= v_.desktopNum_ " " v_.exe "`n"
  }
  MsgBox % finalStr
return

sortArrByKey(arr, key, sortType:="N") {
  str:=""
  for k,v in arr {
    str.=v[key] "+" k "|"
  }
  length:=arr.Length()
  Sort, str, % "D| " sortType
  finalAr:=[]
  finalAr.SetCapacity(length)
  barPos:=1
  loop %length% {
    plusPos:=InStr(str, "+",, barPos)
    barPos:=InStr(str, "|",, plusPos)
    num:=SubStr(str, plusPos + 1, barPos - plusPos - 1)
    finalAr.Push(arr[num])
  }
  return finalAr
}

; f3::Exitapp
!^v::reload
