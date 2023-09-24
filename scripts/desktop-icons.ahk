#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance, Force

; source: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=75890
; Usage: DesktopIcons(True) to show, DesktopIcons(False) to hide, DesktopIcons() to toggle the current state.

DesktopIcons( Show:=-1 )
{
  Local hProgman := WinExist("ahk_class WorkerW", "FolderView") ? WinExist()
  : WinExist("ahk_class Progman", "FolderView")

  Local hShellDefView := DllCall("user32.dll\GetWindow", "ptr",hProgman, "int",5, "ptr")
  Local hSysListView := DllCall("user32.dll\GetWindow", "ptr",hShellDefView, "int",5, "ptr")

  If (DllCall("user32.dll\IsWindowVisible", "ptr",hSysListView) != Show)
    DllCall("user32.dll\SendMessage", "ptr",hShellDefView, "ptr",0x111, "ptr",0x7402, "ptr",0)
}

F2::DesktopIcons()
